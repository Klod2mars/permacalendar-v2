import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;

import 'package:hive/hive.dart';

import 'package:permacalendar/core/data/migration/garden_data_migration.dart';
import 'package:permacalendar/core/models/garden_bed.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/services/migration/migration_orchestrator.dart';

import '../../domain/entities/plant_condition_hive.dart';
import '../../domain/entities/recommendation_hive.dart';

/// ---------------------------------------------------------------------------
/// Multi-Garden Migration Service (Prompt A15)
/// ---------------------------------------------------------------------------
///
/// Rôle principal : assurer la transition multi-versions (Legacy → V2 → Hive →
/// Freezed) des données jardins **et** synchroniser les données de
/// l'Intelligence Végétale (conditions & recommandations) après migration.
///
/// Relation avec les autres services :
/// - `GardenDataMigration` gère la conversion des modèles de jardins.
/// - `MigrationOrchestrator` supervise l'enchaînement des phases (préparation,
///   transition, switch, cleanup) et fournit la visibilité métier.
/// - Ce service agit comme **pont** entre les deux : il vérifie les versions
///   présentes, déclenche la migration des jardins si nécessaire puis fusionne
///   les données Hive de l'intelligence végétale en respectant le Sanctuaire.
///
/// Garanties Sanctuaire Hive :
/// - Verrou d'exécution (`_sanctuaryLock`) pour éviter les écritures
///   concurrentes.
/// - Ouverture sécurisée des boxes (`_openBoxForMigration`) avec contrôle du
///   statut `Hive.isBoxOpen` avant toute écriture.
/// - Mode `dryRun` disponible pour auditer sans modifier les données.
/// - Pas d'écrasement sans inférence validée (`_inferGardenIdFromPlantId`).
///
/// Séquence recommandée (Legacy → V2 → Hive) :
/// 1. `detectDataVersions()` inspecte les boxes sources/cibles.
/// 2. `migrateLegacyGardens()` puis `migrateV2Gardens()` préparent le rapport.
/// 3. `runMultiMigration()` orchestre :
///    - Optionnel : déclenche `GardenDataMigration.migrateAllGardens()`.
///    - Verrouille le sanctuaire et appelle `mergeHiveData()`.
/// 4. `mergeHiveData()` renseigne les `gardenId` manquants pour conditions et
///    recommandations.
/// 5. Un `MultiGardenMigrationReport` détaillé est produit (statistiques,
///    éventuelles erreurs, durée, mode dry-run).
///
/// Exemple d'usage (Riverpod 3) :
/// ```dart
/// final report = await ref
///     .read(GardenModule.multiGardenMigrationProvider)
///     .runMultiMigration();
/// if (report.success) {
///   // Migration terminée, afficher les statistiques
/// }
/// ```
class MultiGardenMigration {
  MultiGardenMigration({
    required GardenDataMigration dataMigration,
    MigrationOrchestrator? orchestrator,
  })  : _dataMigration = dataMigration,
        _orchestrator = orchestrator;

  static const _logName = 'MultiGardenMigration';
  static const String _conditionsBoxName = 'plant_conditions';
  static const String _recommendationsBoxName = 'plant_recommendations';
  static const String _gardenBedsBoxName = 'garden_beds';
  static const String _plantingsBoxName = 'plantings';

  final GardenDataMigration _dataMigration;
  final MigrationOrchestrator? _orchestrator;

  /// Verrou global pour empêcher toute écriture concurrente dans les boxes du
  /// sanctuaire pendant la migration.
  static final _AsyncSanctuaryLock _sanctuaryLock = _AsyncSanctuaryLock();

  MultiGardenMigrationReport? _lastReport;
  GardenMigrationResult? _cachedPreview;

  /// Exécute la migration complète (détection + migration jardins + fusion
  /// sanctuaire).
  Future<MultiGardenMigrationReport> runMultiMigration({
    bool dryRun = false,
    bool ensureBackupBeforeGardenMigration = true,
  }) async {
    return _sanctuaryLock.synchronized(() async {
      final startedAt = DateTime.now();
      final report = MultiGardenMigrationReport(
        startedAt: startedAt,
        dryRun: dryRun,
      );

      developer.log(
        '🔄 DÉMARRAGE MIGRATION MULTI-GARDEN (dryRun=$dryRun)',
        name: _logName,
      );

      try {
        // Phase 0 - Détection
        final snapshot = await detectDataVersions();
        report.dataSnapshot = snapshot;

        // Phase 1 - Migration des jardins si nécessaire
        if (snapshot.requiresGardenMigration && !dryRun) {
          developer.log(
            '🌱 MIGRATION JARDINS nécessaire (Legacy=${snapshot.legacyCount}, V2=${snapshot.v2Count}, Hive=${snapshot.hiveCount})',
            name: _logName,
          );

          final gardenResult = await _dataMigration.migrateAllGardens(
            dryRun: false,
            cleanupOldBoxes: false,
            backupBeforeMigration: ensureBackupBeforeGardenMigration,
          );
          report.gardenMigrationResult = gardenResult;
        } else if (snapshot.requiresGardenMigration && dryRun) {
          developer.log(
            '🧪 DRY-RUN : prévisualisation migration jardins',
            name: _logName,
          );
          report.gardenMigrationResult = await _previewGardenMigration();
        }

        // Phase 2 - Fusion Sanctuaire (conditions + recommandations)
        final mergeReport = await mergeHiveData(
          dryRun: dryRun,
          acquireLock: false, // déjà verrouillé par runMultiMigration
        );
        report.sanctuaryMergeReport = mergeReport;

        report.success = true;
      } catch (e, stackTrace) {
        report.success = false;
        report.error = e.toString();

        developer.log(
          '❌ ÉCHEC MIGRATION MULTI-GARDEN: $e',
          name: _logName,
          level: 1000,
          error: e,
          stackTrace: stackTrace,
        );
      } finally {
        report.endedAt = DateTime.now();
        report.duration = report.endedAt!.difference(startedAt);
        _lastReport = report;

        developer.log(
          '📊 Rapport multi-garden: ${report.summary}',
          name: _logName,
        );
      }

      return report;
    });
  }

  /// Fournit un aperçu des jardins Legacy avant migration.
  Future<GardenVersionReport> migrateLegacyGardens({bool dryRun = true}) async {
    final snapshot = await detectDataVersions();
    final preview = await _previewGardenMigration();
    return GardenVersionReport(
      version: GardenDataVersion.legacy,
      detected: snapshot.legacyCount,
      migrated: preview.legacyCount,
      dryRun: dryRun,
    );
  }

  /// Fournit un aperçu des jardins V2 avant migration.
  Future<GardenVersionReport> migrateV2Gardens({bool dryRun = true}) async {
    final snapshot = await detectDataVersions();
    final preview = await _previewGardenMigration();
    return GardenVersionReport(
      version: GardenDataVersion.v2,
      detected: snapshot.v2Count,
      migrated: preview.v2Count,
      dryRun: dryRun,
    );
  }

  /// Fusionne les données du sanctuaire en inférant les `gardenId` manquants.
  Future<SanctuaryMergeReport> mergeHiveData({
    bool dryRun = false,
    bool acquireLock = true,
  }) async {
    Future<SanctuaryMergeReport> action() async {
      final conditionsHandle =
          await _openBoxForMigration<PlantConditionHive>(_conditionsBoxName);
      final recommendationsHandle = await _openBoxForMigration<RecommendationHive>(
        _recommendationsBoxName,
      );

      try {
        final conditionsStats = await _migrateConditions(
          handle: conditionsHandle,
          dryRun: dryRun,
        );
        final recommendationsStats = await _migrateRecommendations(
          handle: recommendationsHandle,
          dryRun: dryRun,
        );

        return SanctuaryMergeReport(
          conditions: conditionsStats,
          recommendations: recommendationsStats,
          dryRun: dryRun,
        );
      } finally {
        await conditionsHandle.closeIfNeeded();
        await recommendationsHandle.closeIfNeeded();
      }
    }

    if (acquireLock) {
      return _sanctuaryLock.synchronized(action);
    }
    return action();
  }

  /// Retourne un aperçu (cache) de la migration jardins via un dry-run.
  Future<GardenMigrationResult> _previewGardenMigration() async {
    if (_cachedPreview != null) {
      return _cachedPreview!;
    }

    try {
      _cachedPreview = await _dataMigration.migrateAllGardens(
        dryRun: true,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Impossible de prévisualiser la migration jardins: $e',
        name: _logName,
        level: 900,
        error: e,
        stackTrace: stackTrace,
      );
      _cachedPreview = GardenMigrationResult(
        startedAt: DateTime.now(),
        dryRun: true,
      )
        ..success = false
        ..errors = ['Prévisualisation impossible: $e'];
    }

    return _cachedPreview!;
  }

  /// Inspecte les boxes Legacy / V2 / Hive / Freezed et le sanctuaire.
  Future<DataVersionSnapshot> detectDataVersions() async {
    final legacy = await _inspectBox('gardens');
    final v2 = await _inspectBox('gardens_v2');
    final hive = await _inspectBox('gardens_hive');
    final freezed = await _inspectBox('gardens_freezed');

    final conditionsNeedingMigration =
        await _countMissingGardenIds<PlantConditionHive>(
      _conditionsBoxName,
      (entity) => entity.gardenId,
    );

    final recommendationsNeedingMigration =
        await _countMissingGardenIds<RecommendationHive>(
      _recommendationsBoxName,
      (entity) => entity.gardenId,
    );

    return DataVersionSnapshot(
      legacyCount: legacy.count,
      v2Count: v2.count,
      hiveCount: hive.count,
      freezedCount: freezed.count,
      conditionsNeedingMigration: conditionsNeedingMigration,
      recommendationsNeedingMigration: recommendationsNeedingMigration,
      errors: {
        if (legacy.error != null)
          'legacy': legacy.error!,
        if (v2.error != null) 'v2': v2.error!,
        if (hive.error != null) 'hive': hive.error!,
        if (freezed.error != null) 'freezed': freezed.error!,
      },
    );
  }

  /// Migration des conditions (inférence du gardenId).
  Future<EntityMigrationStats> _migrateConditions({
    required _BoxHandle<PlantConditionHive> handle,
    required bool dryRun,
  }) async {
    if (handle.box == null) {
      return EntityMigrationStats.empty(dryRun: dryRun);
    }

    final box = handle.box!;
    if (!box.isOpen) {
      developer.log(
        '🔒 Sanctuaire: box conditions inaccessible (fermée)',
        name: _logName,
        level: 900,
      );
      return EntityMigrationStats.empty(dryRun: dryRun);
    }

    var migrated = 0;
    var skipped = 0;
    var errors = 0;

    for (var i = 0; i < box.length; i++) {
      try {
        final condition = box.getAt(i);
        if (condition == null) {
          skipped++;
          continue;
        }

        if (condition.gardenId.isNotEmpty) {
          skipped++;
          continue;
        }

        final gardenId = await _inferGardenIdFromPlantId(condition.plantId);

        if (gardenId == null) {
          errors++;
          continue;
        }

        if (!dryRun) {
          condition.gardenId = gardenId;
          await box.putAt(i, condition);
        }

        migrated++;
      } catch (e, stackTrace) {
        errors++;
        developer.log(
          '❌ Erreur migration condition index=$i: $e',
          name: _logName,
          level: 900,
          error: e,
          stackTrace: stackTrace,
        );
      }
    }

    return EntityMigrationStats(
      migrated: migrated,
      skipped: skipped,
      errors: errors,
      dryRun: dryRun,
    );
  }

  /// Migration des recommandations (inférence du gardenId).
  Future<EntityMigrationStats> _migrateRecommendations({
    required _BoxHandle<RecommendationHive> handle,
    required bool dryRun,
  }) async {
    if (handle.box == null) {
      return EntityMigrationStats.empty(dryRun: dryRun);
    }

    final box = handle.box!;
    if (!box.isOpen) {
      developer.log(
        '🔒 Sanctuaire: box recommandations inaccessible (fermée)',
        name: _logName,
        level: 900,
      );
      return EntityMigrationStats.empty(dryRun: dryRun);
    }

    var migrated = 0;
    var skipped = 0;
    var errors = 0;

    for (var i = 0; i < box.length; i++) {
      try {
        final recommendation = box.getAt(i);
        if (recommendation == null) {
          skipped++;
          continue;
        }

        if (recommendation.gardenId.isNotEmpty) {
          skipped++;
          continue;
        }

        final gardenId = await _inferGardenIdFromPlantId(recommendation.plantId);

        if (gardenId == null) {
          errors++;
          continue;
        }

        if (!dryRun) {
          recommendation.gardenId = gardenId;
          await box.putAt(i, recommendation);
        }

        migrated++;
      } catch (e, stackTrace) {
        errors++;
        developer.log(
          '❌ Erreur migration recommandation index=$i: $e',
          name: _logName,
          level: 900,
          error: e,
          stackTrace: stackTrace,
        );
      }
    }

    return EntityMigrationStats(
      migrated: migrated,
      skipped: skipped,
      errors: errors,
      dryRun: dryRun,
    );
  }

  /// Infère le `gardenId` à partir d'un `plantId` via la chaîne
  /// plant → planting → gardenBed → garden.
  Future<String?> _inferGardenIdFromPlantId(String plantId) async {
    _BoxHandle<GardenBed>? bedsHandle;
    _BoxHandle<Planting>? plantingsHandle;

    try {
      bedsHandle = await _openBoxForMigration<GardenBed>(_gardenBedsBoxName);
      plantingsHandle = await _openBoxForMigration<Planting>(_plantingsBoxName);

      final bedsBox = bedsHandle.box;
      final plantingsBox = plantingsHandle.box;

      if (bedsBox == null || plantingsBox == null) {
        developer.log(
          'ℹ️ Impossible d\'accéder aux boxes garden_beds / plantings pour inférence',
          name: _logName,
          level: 800,
        );
        return null;
      }

      for (final bed in bedsBox.values) {
        if (bed is! GardenBed) continue;
        for (final planting in plantingsBox.values) {
          if (planting is! Planting) continue;
          if (planting.gardenBedId == bed.id && planting.plantId == plantId) {
            developer.log(
              '✅ gardenId inféré (${bed.gardenId}) pour plantId=$plantId',
              name: _logName,
            );
            return bed.gardenId;
          }
        }
      }

      developer.log(
        'ℹ️ Aucune plantation associée au plantId=$plantId',
        name: _logName,
        level: 800,
      );
      return null;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Erreur inférence gardenId pour plantId=$plantId: $e',
        name: _logName,
        level: 900,
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    } finally {
      await bedsHandle?.closeIfNeeded();
      await plantingsHandle?.closeIfNeeded();
    }
  }

  /// Ouvre une box Hive de façon sécurisée pour la migration.
  Future<_BoxHandle<T>> _openBoxForMigration<T>(String boxName) async {
    Box<T>? box;
    var wasOpen = false;

    try {
      final exists = await Hive.boxExists(boxName);
      if (!exists) {
        return _BoxHandle<T>(box: null, wasOpen: false);
      }

      if (Hive.isBoxOpen(boxName)) {
        box = Hive.box<T>(boxName);
        wasOpen = true;
      } else {
        box = await Hive.openBox<T>(boxName);
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Échec ouverture box "$boxName": $e',
        name: _logName,
        level: 900,
        error: e,
        stackTrace: stackTrace,
      );
      return _BoxHandle<T>(box: null, wasOpen: false, error: e.toString());
    }

    return _BoxHandle<T>(box: box, wasOpen: wasOpen);
  }

  /// Inspecte une box (compte et erreurs potentielles).
  Future<_BoxInspection> _inspectBox(String boxName) async {
    Box? box;
    var wasOpen = false;

    try {
      final exists = await Hive.boxExists(boxName);
      if (!exists) {
        return _BoxInspection(count: 0);
      }

      if (Hive.isBoxOpen(boxName)) {
        box = Hive.box(boxName);
        wasOpen = true;
      } else {
        box = await Hive.openBox(boxName);
      }

      final count = box.length;
      return _BoxInspection(count: count);
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Inspection box "$boxName" impossible: $e',
        name: _logName,
        level: 900,
        error: e,
        stackTrace: stackTrace,
      );
      return _BoxInspection(count: 0, error: e.toString());
    } finally {
      if (box != null && !wasOpen) {
        await box.close();
      }
    }
  }

  /// Compte les entités dont le gardenId est vide dans une box donnée.
  Future<int> _countMissingGardenIds<T>(
    String boxName,
    String Function(T entity) gardenIdSelector,
  ) async {
    final handle = await _openBoxForMigration<T>(boxName);
    try {
      final box = handle.box;
      if (box == null) {
        return 0;
      }

      var missing = 0;
      for (final value in box.values) {
        if (value is T) {
          final gardenId = gardenIdSelector(value);
          if (gardenId.isEmpty) {
            missing++;
          }
        }
      }
      return missing;
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Impossible de compter les gardenId manquants dans "$boxName": $e',
        name: _logName,
        level: 900,
        error: e,
        stackTrace: stackTrace,
      );
      return 0;
    } finally {
      await handle.closeIfNeeded();
    }
  }

  /// Dernier rapport généré.
  MultiGardenMigrationReport? get lastReport => _lastReport;
}

/// Résumé de la migration multi-garden.
class MultiGardenMigrationReport {
  MultiGardenMigrationReport({
    required this.startedAt,
    required this.dryRun,
  });

  final DateTime startedAt;
  final bool dryRun;

  bool success = false;
  String? error;
  DateTime? endedAt;
  Duration? duration;

  DataVersionSnapshot? dataSnapshot;
  GardenMigrationResult? gardenMigrationResult;
  SanctuaryMergeReport? sanctuaryMergeReport;

  String get summary {
    final buffer = StringBuffer();
    buffer.write('success=$success');
    buffer.write(', dryRun=$dryRun');
    if (duration != null) {
      buffer.write(', duration=${duration!.inSeconds}s');
    }
    if (sanctuaryMergeReport != null) {
      buffer.write(', conditions=${sanctuaryMergeReport!.conditions.migrated}');
      buffer.write(
          ', recommandations=${sanctuaryMergeReport!.recommendations.migrated}');
    }
    if (error != null) {
      buffer.write(', error=$error');
    }
    return buffer.toString();
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('═══════════════════════════════════════════════════════');
    buffer.writeln('        RAPPORT MIGRATION MULTI-GARDEN');
    buffer.writeln('═══════════════════════════════════════════════════════');
    buffer.writeln('Statut: ${success ? "✅ SUCCÈS" : "❌ ÉCHEC"}');
    buffer.writeln('Mode: ${dryRun ? "Dry-run" : "Réel"}');
    buffer.writeln('Début: $startedAt');
    buffer.writeln('Fin: ${endedAt ?? "-"}');
    buffer.writeln('Durée: ${duration?.inSeconds ?? 0}s');
    if (error != null) {
      buffer.writeln('Erreur: $error');
    }
    if (dataSnapshot != null) {
      buffer.writeln(dataSnapshot);
    }
    if (sanctuaryMergeReport != null) {
      buffer.writeln(sanctuaryMergeReport);
    }
    buffer.writeln('═══════════════════════════════════════════════════════');
    return buffer.toString();
  }
}

/// Rapport d'une version spécifique (Legacy, V2, Hive).
class GardenVersionReport {
  GardenVersionReport({
    required this.version,
    required this.detected,
    required this.migrated,
    required this.dryRun,
  });

  final GardenDataVersion version;
  final int detected;
  final int migrated;
  final bool dryRun;

  @override
  String toString() {
    return 'GardenVersionReport(version=$version, detected=$detected, migrated=$migrated, dryRun=$dryRun)';
  }
}

/// Rapport de fusion du sanctuaire.
class SanctuaryMergeReport {
  SanctuaryMergeReport({
    required this.conditions,
    required this.recommendations,
    required this.dryRun,
  });

  final EntityMigrationStats conditions;
  final EntityMigrationStats recommendations;
  final bool dryRun;

  int get totalMigrated =>
      conditions.migrated + recommendations.migrated;

  @override
  String toString() {
    return 'SanctuaryMergeReport(dryRun=$dryRun, conditions=$conditions, recommendations=$recommendations)';
  }
}

/// Statistiques pour une entité (conditions ou recommandations).
class EntityMigrationStats {
  const EntityMigrationStats({
    required this.migrated,
    required this.skipped,
    required this.errors,
    required this.dryRun,
  });

  final int migrated;
  final int skipped;
  final int errors;
  final bool dryRun;

  factory EntityMigrationStats.empty({required bool dryRun}) {
    return EntityMigrationStats(
      migrated: 0,
      skipped: 0,
      errors: 0,
      dryRun: dryRun,
    );
  }

  @override
  String toString() {
    return 'EntityMigrationStats(migrated=$migrated, skipped=$skipped, errors=$errors, dryRun=$dryRun)';
  }
}

/// Résumé des versions détectées.
class DataVersionSnapshot {
  DataVersionSnapshot({
    required this.legacyCount,
    required this.v2Count,
    required this.hiveCount,
    required this.freezedCount,
    required this.conditionsNeedingMigration,
    required this.recommendationsNeedingMigration,
    this.errors = const {},
  });

  final int legacyCount;
  final int v2Count;
  final int hiveCount;
  final int freezedCount;
  final int conditionsNeedingMigration;
  final int recommendationsNeedingMigration;
  final Map<String, String> errors;

  bool get requiresGardenMigration =>
      legacyCount > 0 || v2Count > 0 || hiveCount > 0;

  bool get requiresSanctuaryMerge =>
      conditionsNeedingMigration > 0 || recommendationsNeedingMigration > 0;

  @override
  String toString() {
    return '''
───────────────────────────────────────────────────────
  DATA SNAPSHOT
───────────────────────────────────────────────────────
  Legacy:           $legacyCount
  V2:               $v2Count
  Hive:             $hiveCount
  Freezed (cible):  $freezedCount
  Conditions sans gardenId:       $conditionsNeedingMigration
  Recommandations sans gardenId:  $recommendationsNeedingMigration
  Erreurs: ${errors.isEmpty ? 'Aucune' : errors}
''';
  }
}

/// Gestion simplifiée d'un verrou asynchrone (non réentrant).
class _AsyncSanctuaryLock {
  bool _locked = false;
  final Queue<Completer<void>> _waiters = Queue<Completer<void>>();

  Future<T> synchronized<T>(Future<T> Function() action) async {
    await _acquire();
    try {
      return await action();
    } finally {
      _release();
    }
  }

  Future<void> _acquire() {
    if (!_locked) {
      _locked = true;
      return Future.value();
    }
    final completer = Completer<void>();
    _waiters.add(completer);
    return completer.future;
  }

  void _release() {
    if (_waiters.isEmpty) {
      _locked = false;
      return;
    }
    final next = _waiters.removeFirst();
    if (!next.isCompleted) {
      next.complete();
    }
  }
}

/// Résultat d'ouverture de box pour migration.
class _BoxHandle<T> {
  _BoxHandle({
    required this.box,
    required this.wasOpen,
    this.error,
  });

  final Box<T>? box;
  final bool wasOpen;
  final String? error;

  Future<void> closeIfNeeded() async {
    if (box != null && !wasOpen && box!.isOpen) {
      await box!.close();
    }
  }
}

/// Résultat d'inspection simple (compte + éventuelle erreur).
class _BoxInspection {
  _BoxInspection({required this.count, this.error});

  final int count;
  final String? error;
}

/// Versions de données gérées par la migration jardins.
enum GardenDataVersion { legacy, v2, hive }

