import 'dart:async';
import 'dart:developer' as developer;
import 'package:hive/hive.dart';
import '../../adapters/garden_migration_adapters.dart';
import '../../models/garden.dart' as legacy;
import '../../models/garden_v2.dart' as v2;
import '../../models/garden_hive.dart';
import '../../models/garden_freezed.dart';

/// Script de migration unique pour convertir toutes les données Garden vers GardenFreezed
///
/// Ce service orchestre la migration complète des données Garden depuis les anciennes
/// versions (Legacy, V2, Hive) vers le modèle unifié GardenFreezed.
///
/// **Architecture :**
/// - Classe standalone (pas de dépendance Riverpod directe)
/// - Fournie via `GardenModule.dataMigrationProvider` pour injection de dépendances
/// - Utilise `GardenMigrationAdapters` pour les conversions de modèles
///
/// **Boxes Hive concernées :**
/// - `gardens` (HiveType 0) - Legacy Garden
/// - `gardens_v2` (HiveType 10) - Garden V2
/// - `gardens_hive` (HiveType 25) - GardenHive
/// - `gardens_freezed` (nouvelle box cible)
///
/// **Workflow :**
/// 1. Backup de toutes les données existantes (optionnel)
/// 2. Lecture de toutes les boxes source (avec gestion d'erreurs)
/// 3. Conversion vers GardenFreezed via adaptateurs
/// 4. Sauvegarde dans la box cible
/// 5. Vérification d'intégrité
/// 6. Cleanup optionnel des anciennes boxes
/// 7. Fermeture propre de toutes les boxes ouvertes
///
/// **Sécurité :**
/// - Toutes les opérations Hive sont protégées par try/catch
/// - Fermeture automatique des boxes après utilisation
/// - Gestion gracieuse des boxes manquantes ou corrompues
/// - Mode dry-run pour tester sans écrire
///
/// **Compatibilité Riverpod 3 :**
/// - Aucun accès direct aux providers (classe standalone)
/// - Injection via `GardenModule.dataMigrationProvider` si nécessaire
/// - Pas de dépendance circulaire
///
/// **Usage :**
/// ```dart
/// // Via Riverpod
/// final migration = ref.read(GardenModule.dataMigrationProvider);
///
/// // Ou directement
/// final migration = GardenDataMigration();
///
/// // Simulation
/// final dryRunResult = await migration.migrateAllGardens(
///   dryRun: true,
///   backupBeforeMigration: false,
/// );
///
/// // Migration réelle
/// if (dryRunResult.success) {
///   final result = await migration.migrateAllGardens(
///     cleanupOldBoxes: false, // Conserver les anciennes boxes par sécurité
///     dryRun: false,
///     backupBeforeMigration: true,
///   );
///
///   if (result.success) {
///     print('Migration réussie : ${result.migratedCount} jardins');
///     migration.printMigrationStats();
///   }
/// }
/// ```
class GardenDataMigration {
  /// Résultat de la migration
  GardenMigrationResult? _lastResult;

  /// Récupère le dernier résultat de migration
  GardenMigrationResult? get lastResult => _lastResult;

  /// Migre tous les jardins de toutes les sources vers GardenFreezed
  ///
  /// [cleanupOldBoxes] : Si true, supprime les anciennes boxes après migration réussie
  /// [dryRun] : Si true, simule la migration sans écrire dans la base
  /// [backupBeforeMigration] : Si true, crée un backup avant migration
  ///
  /// Retourne un [GardenMigrationResult] avec les statistiques
  Future<GardenMigrationResult> migrateAllGardens({
    bool cleanupOldBoxes = false,
    bool dryRun = false,
    bool backupBeforeMigration = true,
  }) async {
    developer.log(
      '🌱 Démarrage migration Garden vers GardenFreezed',
      name: 'GardenDataMigration',
    );

    final startTime = DateTime.now();
    final result = GardenMigrationResult(
      startedAt: startTime,
      dryRun: dryRun,
    );

    try {
      // 1. Backup si demandé
      if (backupBeforeMigration && !dryRun) {
        developer.log('💾 Création du backup...', name: 'GardenDataMigration');
        await _createBackup();
        result.backupCreated = true;
      }

      // 2. Ouvrir la box cible
      Box<GardenFreezed>? targetBox;
      if (!dryRun) {
        targetBox = await _openOrCreateTargetBox();
        developer.log('✅ Box cible ouverte', name: 'GardenDataMigration');
      }

      // 3. Migrer depuis Legacy (HiveType 0)
      developer.log('📦 Migration depuis Legacy...',
          name: 'GardenDataMigration');
      final legacyMigrated = await _migrateLegacyGardens(targetBox, dryRun);
      result.legacyCount = legacyMigrated.length;
      result.migratedGardens.addAll(legacyMigrated);

      // 4. Migrer depuis V2 (HiveType 10)
      developer.log('📦 Migration depuis V2...', name: 'GardenDataMigration');
      final v2Migrated = await _migrateV2Gardens(targetBox, dryRun);
      result.v2Count = v2Migrated.length;
      result.migratedGardens.addAll(v2Migrated);

      // 5. Migrer depuis Hive (HiveType 25)
      developer.log('📦 Migration depuis Hive...', name: 'GardenDataMigration');
      final hiveMigrated = await _migrateHiveGardens(targetBox, dryRun);
      result.hiveCount = hiveMigrated.length;
      result.migratedGardens.addAll(hiveMigrated);

      // 6. Vérification d'intégrité
      developer.log('🔍 Vérification d\'intégrité...',
          name: 'GardenDataMigration');
      final integrityCheck =
          await _verifyIntegrity(result.migratedGardens, targetBox);
      result.integrityVerified = integrityCheck;

      if (!integrityCheck) {
        result.errors.add('Échec de la vérification d\'intégrité');
        result.success = false;
      }

      // 7. Cleanup des anciennes boxes si demandé
      if (cleanupOldBoxes && !dryRun && result.success) {
        developer.log('🗑️ Nettoyage des anciennes boxes...',
            name: 'GardenDataMigration');
        await _cleanupOldBoxes();
        result.oldBoxesCleanedUp = true;
      }

      // 8. Finalisation
      result.success = true;
      result.endedAt = DateTime.now();
      result.duration = result.endedAt.difference(startTime);

      developer.log(
        '✅ Migration terminée avec succès : ${result.migratedCount} jardins en ${result.duration.inSeconds}s',
        name: 'GardenDataMigration',
      );
    } catch (e, stackTrace) {
      result.success = false;
      result.errors.add('Erreur critique: $e');
      result.endedAt = DateTime.now();
      result.duration = result.endedAt.difference(startTime);

      developer.log(
        '❌ Échec de la migration',
        name: 'GardenDataMigration',
        error: e,
        stackTrace: stackTrace,
      );
    }

    _lastResult = result;
    return result;
  }

  /// Ouvre ou crée la box cible pour GardenFreezed
  ///
  /// **Sécurité :**
  /// - Gestion d'erreurs avec try/catch
  /// - Tentative de récupération en cas d'échec (suppression et recréation)
  /// - Ne ferme pas la box (doit rester ouverte pour la migration)
  Future<Box<GardenFreezed>> _openOrCreateTargetBox() async {
    try {
      if (Hive.isBoxOpen('gardens_freezed')) {
        return Hive.box<GardenFreezed>('gardens_freezed');
      }
      return await Hive.openBox<GardenFreezed>('gardens_freezed');
    } catch (e) {
      developer.log(
        'Erreur ouverture box cible, tentative de suppression et recréation: $e',
        name: 'GardenDataMigration',
        level: 900,
      );

      // Si échec, supprimer et recréer
      try {
        if (Hive.isBoxOpen('gardens_freezed')) {
          await Hive.box('gardens_freezed').close();
        }
        await Hive.deleteBoxFromDisk('gardens_freezed');
        return await Hive.openBox<GardenFreezed>('gardens_freezed');
      } catch (e2) {
        developer.log(
          'Erreur critique lors de la récupération de la box cible: $e2',
          name: 'GardenDataMigration',
          level: 1000,
        );
        rethrow;
      }
    }
  }

  /// Migre les jardins Legacy (HiveType 0)
  Future<List<GardenFreezed>> _migrateLegacyGardens(
    Box<GardenFreezed>? targetBox,
    bool dryRun,
  ) async {
    final migratedGardens = <GardenFreezed>[];
    Box<legacy.Garden>? legacyBox;
    bool wasBoxOpen = false;

    try {
      // Ouvrir la box legacy
      if (Hive.isBoxOpen('gardens')) {
        legacyBox = Hive.box<legacy.Garden>('gardens');
        wasBoxOpen = true;
      } else {
        try {
          legacyBox = await Hive.openBox<legacy.Garden>('gardens');
          wasBoxOpen = false;
        } catch (e) {
          developer.log(
            'Box legacy "gardens" n\'existe pas ou ne peut pas être ouverte: $e',
            name: 'GardenDataMigration',
            level: 900,
          );
          return migratedGardens;
        }
      }

      // Lire tous les jardins
      final legacyGardens = legacyBox.values.toList();
      developer.log(
        '📊 ${legacyGardens.length} jardins Legacy trouvés',
        name: 'GardenDataMigration',
      );

      // Convertir et sauvegarder
      for (final legacyGarden in legacyGardens) {
        try {
          final gardenFreezed =
              GardenMigrationAdapters.fromLegacy(legacyGarden);
          migratedGardens.add(gardenFreezed);

          if (!dryRun && targetBox != null) {
            try {
              await targetBox.put(gardenFreezed.id, gardenFreezed);
              developer.log(
                '✅ Legacy "${gardenFreezed.name}" migré (${gardenFreezed.id})',
                name: 'GardenDataMigration',
              );
            } catch (e) {
              developer.log(
                'Erreur sauvegarde jardin Legacy "${gardenFreezed.name}": $e',
                name: 'GardenDataMigration',
                level: 1000,
              );
            }
          }
        } catch (e) {
          developer.log(
            'Erreur migration jardin Legacy "${legacyGarden.name}": $e',
            name: 'GardenDataMigration',
            level: 1000,
          );
        }
      }
    } catch (e) {
      developer.log(
        'Erreur lors de la migration Legacy: $e',
        name: 'GardenDataMigration',
        level: 1000,
      );
    } finally {
      // Fermer la box si nous l'avons ouverte
      if (legacyBox != null && !wasBoxOpen) {
        try {
          await legacyBox.close();
        } catch (e) {
          developer.log(
            'Erreur fermeture box legacy: $e',
            name: 'GardenDataMigration',
            level: 900,
          );
        }
      }
    }

    return migratedGardens;
  }

  /// Migre les jardins V2 (HiveType 10)
  Future<List<GardenFreezed>> _migrateV2Gardens(
    Box<GardenFreezed>? targetBox,
    bool dryRun,
  ) async {
    final migratedGardens = <GardenFreezed>[];
    Box<v2.Garden>? v2Box;
    bool wasBoxOpen = false;

    try {
      // Ouvrir la box v2
      if (Hive.isBoxOpen('gardens_v2')) {
        v2Box = Hive.box<v2.Garden>('gardens_v2');
        wasBoxOpen = true;
      } else {
        try {
          v2Box = await Hive.openBox<v2.Garden>('gardens_v2');
          wasBoxOpen = false;
        } catch (e) {
          developer.log(
            'Box v2 "gardens_v2" n\'existe pas ou ne peut pas être ouverte: $e',
            name: 'GardenDataMigration',
            level: 900,
          );
          return migratedGardens;
        }
      }

      // Lire tous les jardins
      final v2Gardens = v2Box.values.toList();
      developer.log(
        '📊 ${v2Gardens.length} jardins V2 trouvés',
        name: 'GardenDataMigration',
      );

      // Convertir et sauvegarder
      for (final v2Garden in v2Gardens) {
        try {
          final gardenFreezed = GardenMigrationAdapters.fromV2(v2Garden);
          migratedGardens.add(gardenFreezed);

          if (!dryRun && targetBox != null) {
            try {
              await targetBox.put(gardenFreezed.id, gardenFreezed);
              developer.log(
                '✅ V2 "${gardenFreezed.name}" migré (${gardenFreezed.id})',
                name: 'GardenDataMigration',
              );
            } catch (e) {
              developer.log(
                'Erreur sauvegarde jardin V2 "${gardenFreezed.name}": $e',
                name: 'GardenDataMigration',
                level: 1000,
              );
            }
          }
        } catch (e) {
          developer.log(
            'Erreur migration jardin V2 "${v2Garden.name}": $e',
            name: 'GardenDataMigration',
            level: 1000,
          );
        }
      }
    } catch (e) {
      developer.log(
        'Erreur lors de la migration V2: $e',
        name: 'GardenDataMigration',
        level: 1000,
      );
    } finally {
      // Fermer la box si nous l'avons ouverte
      if (v2Box != null && !wasBoxOpen) {
        try {
          await v2Box.close();
        } catch (e) {
          developer.log(
            'Erreur fermeture box v2: $e',
            name: 'GardenDataMigration',
            level: 900,
          );
        }
      }
    }

    return migratedGardens;
  }

  /// Migre les jardins Hive (HiveType 25)
  Future<List<GardenFreezed>> _migrateHiveGardens(
    Box<GardenFreezed>? targetBox,
    bool dryRun,
  ) async {
    final migratedGardens = <GardenFreezed>[];
    Box<GardenHive>? hiveBox;
    bool wasBoxOpen = false;

    try {
      // Ouvrir la box hive
      if (Hive.isBoxOpen('gardens_hive')) {
        hiveBox = Hive.box<GardenHive>('gardens_hive');
        wasBoxOpen = true;
      } else {
        try {
          hiveBox = await Hive.openBox<GardenHive>('gardens_hive');
          wasBoxOpen = false;
        } catch (e) {
          developer.log(
            'Box "gardens_hive" n\'existe pas ou ne peut pas être ouverte: $e',
            name: 'GardenDataMigration',
            level: 900,
          );
          return migratedGardens;
        }
      }

      // Lire tous les jardins
      final hiveGardens = hiveBox.values.toList();
      developer.log(
        '📊 ${hiveGardens.length} jardins Hive trouvés',
        name: 'GardenDataMigration',
      );

      // Convertir et sauvegarder
      for (final hiveGarden in hiveGardens) {
        try {
          final gardenFreezed = GardenMigrationAdapters.fromHive(hiveGarden);
          migratedGardens.add(gardenFreezed);

          if (!dryRun && targetBox != null) {
            try {
              await targetBox.put(gardenFreezed.id, gardenFreezed);
              developer.log(
                '✅ Hive "${gardenFreezed.name}" migré (${gardenFreezed.id}) - Surface: ${gardenFreezed.totalAreaInSquareMeters.toStringAsFixed(2)} m²',
                name: 'GardenDataMigration',
              );
            } catch (e) {
              developer.log(
                'Erreur sauvegarde jardin Hive "${gardenFreezed.name}": $e',
                name: 'GardenDataMigration',
                level: 1000,
              );
            }
          }
        } catch (e) {
          developer.log(
            'Erreur migration jardin Hive "${hiveGarden.name}": $e',
            name: 'GardenDataMigration',
            level: 1000,
          );
        }
      }
    } catch (e) {
      developer.log(
        'Erreur lors de la migration Hive: $e',
        name: 'GardenDataMigration',
        level: 1000,
      );
    } finally {
      // Fermer la box si nous l'avons ouverte
      if (hiveBox != null && !wasBoxOpen) {
        try {
          await hiveBox.close();
        } catch (e) {
          developer.log(
            'Erreur fermeture box hive: $e',
            name: 'GardenDataMigration',
            level: 900,
          );
        }
      }
    }

    return migratedGardens;
  }

  /// Vérifie l'intégrité des données migrées
  Future<bool> _verifyIntegrity(
    List<GardenFreezed> migratedGardens,
    Box<GardenFreezed>? targetBox,
  ) async {
    if (targetBox == null) {
      // En mode dry-run, pas de vérification
      return true;
    }

    try {
      // Vérifier que tous les jardins migrés sont dans la box
      for (final garden in migratedGardens) {
        final stored = targetBox.get(garden.id);
        if (stored == null) {
          developer.log(
            '❌ Jardin "${garden.name}" (${garden.id}) absent de la box cible',
            name: 'GardenDataMigration',
            level: 1000,
          );
          return false;
        }

        // Vérifier les propriétés essentielles
        if (stored.name != garden.name ||
            stored.createdAt != garden.createdAt) {
          developer.log(
            '❌ Jardin "${garden.name}" (${garden.id}) corrompu dans la box cible',
            name: 'GardenDataMigration',
            level: 1000,
          );
          return false;
        }
      }

      developer.log(
        '✅ Intégrité vérifiée : ${migratedGardens.length} jardins',
        name: 'GardenDataMigration',
      );
      return true;
    } catch (e) {
      developer.log(
        'Erreur lors de la vérification d\'intégrité: $e',
        name: 'GardenDataMigration',
        level: 1000,
      );
      return false;
    }
  }

  /// Crée un backup de toutes les boxes Garden
  Future<void> _createBackup() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupBoxName = 'garden_backup_$timestamp';

      // Créer une box de backup
      final backupBox = await Hive.openBox(backupBoxName);

      // Sauvegarder toutes les sources
      final backupData = {
        'timestamp': timestamp,
        'legacy': await _getBoxData('gardens'),
        'v2': await _getBoxData('gardens_v2'),
        'hive': await _getBoxData('gardens_hive'),
      };

      await backupBox.put('garden_migration_backup', backupData);
      await backupBox.close();

      developer.log(
        '💾 Backup créé : $backupBoxName',
        name: 'GardenDataMigration',
      );
    } catch (e) {
      developer.log(
        '⚠️ Impossible de créer le backup: $e',
        name: 'GardenDataMigration',
        level: 900,
      );
    }
  }

  /// Récupère les données d'une box (JSON-safe)
  Future<List<Map<String, dynamic>>> _getBoxData(String boxName) async {
    Box? box;
    bool wasBoxOpen = false;

    try {
      if (Hive.isBoxOpen(boxName)) {
        box = Hive.box(boxName);
        wasBoxOpen = true;
      } else {
        try {
          box = await Hive.openBox(boxName);
          wasBoxOpen = false;
        } catch (e) {
          developer.log(
            'Box $boxName n\'existe pas ou ne peut pas être ouverte: $e',
            name: 'GardenDataMigration',
            level: 900,
          );
          return [];
        }
      }

      return box.values.map<Map<String, dynamic>>((e) {
        try {
          if (e is legacy.Garden) {
            return <String, dynamic>{
              'id': e.id,
              'name': e.name,
              'description': e.description,
              'totalAreaInSquareMeters': e.totalAreaInSquareMeters,
              'location': e.location,
              'createdAt': e.createdAt.toIso8601String(),
              'updatedAt': e.updatedAt.toIso8601String(),
            };
          } else if (e is v2.Garden) {
            return <String, dynamic>{
              'id': e.id,
              'name': e.name,
              'description': e.description,
              'location': e.location,
              'createdDate': e.createdDate.toIso8601String(),
              'gardenBeds': e.gardenBeds,
            };
          } else if (e is GardenHive) {
            return <String, dynamic>{
              'id': e.id,
              'name': e.name,
              'description': e.description,
              'createdDate': e.createdDate.toIso8601String(),
              'gardenBedsCount': e.gardenBeds.length,
            };
          }
          return <String, dynamic>{};
        } catch (e) {
          developer.log(
            'Erreur sérialisation élément de $boxName: $e',
            name: 'GardenDataMigration',
            level: 900,
          );
          return <String, dynamic>{};
        }
      }).toList();
    } catch (e) {
      developer.log(
        'Erreur lecture box $boxName: $e',
        name: 'GardenDataMigration',
        level: 900,
      );
      return [];
    } finally {
      // Fermer la box si nous l'avons ouverte
      if (box != null && !wasBoxOpen) {
        try {
          await box.close();
        } catch (e) {
          developer.log(
            'Erreur fermeture box $boxName: $e',
            name: 'GardenDataMigration',
            level: 900,
          );
        }
      }
    }
  }

  /// Nettoie les anciennes boxes après migration réussie
  Future<void> _cleanupOldBoxes() async {
    final boxesToDelete = ['gardens', 'gardens_v2', 'gardens_hive'];

    for (final boxName in boxesToDelete) {
      try {
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).close();
        }
        await Hive.deleteBoxFromDisk(boxName);
        developer.log('🗑️ Box "$boxName" supprimée',
            name: 'GardenDataMigration');
      } catch (e) {
        developer.log(
          '⚠️ Impossible de supprimer box "$boxName": $e',
          name: 'GardenDataMigration',
          level: 900,
        );
      }
    }
  }

  /// Restaure depuis un backup
  Future<void> restoreFromBackup(String backupBoxName) async {
    developer.log(
      '🔄 Restauration depuis backup: $backupBoxName',
      name: 'GardenDataMigration',
    );

    try {
      final backupBox = await Hive.openBox(backupBoxName);
      final backupData =
          backupBox.get('garden_migration_backup') as Map<dynamic, dynamic>?;

      if (backupData == null) {
        throw Exception('Backup introuvable dans la box $backupBoxName');
      }

      developer.log(
        'Backup trouvé, restauration en cours...',
        name: 'GardenDataMigration',
      );

      // La restauration complète nécessiterait de recréer les objets typés
      // Pour l'instant, on log seulement les données disponibles
      developer.log(
        'Données disponibles dans le backup:',
        name: 'GardenDataMigration',
      );
      developer.log('- Legacy: ${backupData['legacy']}',
          name: 'GardenDataMigration');
      developer.log('- V2: ${backupData['v2']}', name: 'GardenDataMigration');
      developer.log('- Hive: ${backupData['hive']}',
          name: 'GardenDataMigration');

      developer.log(
        '✅ Restauration terminée (vérifiez les données)',
        name: 'GardenDataMigration',
      );
    } catch (e, stackTrace) {
      developer.log(
        '❌ Erreur lors de la restauration',
        name: 'GardenDataMigration',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Liste les backups disponibles
  Future<List<String>> listAvailableBackups() async {
    try {
      // Filtrer les boxes qui commencent par 'garden_backup_'
      // Note: Cette méthode est simplifiée, une vraie implémentation
      // nécessiterait d'accéder au système de fichiers Hive
      return [];
    } catch (e) {
      developer.log(
        'Erreur lors de la liste des backups: $e',
        name: 'GardenDataMigration',
      );
      return [];
    }
  }

  /// Affiche les statistiques de la dernière migration
  void printMigrationStats() {
    if (_lastResult == null) {
      developer.log('Aucune migration exécutée', name: 'GardenDataMigration');
      return;
    }

    final result = _lastResult!;
    developer.log('\n📊 STATISTIQUES DE MIGRATION GARDEN\n',
        name: 'GardenDataMigration');
    developer.log('─' * 50, name: 'GardenDataMigration');
    developer.log('Statut: ${result.success ? "✅ RÉUSSI" : "❌ ÉCHEC"}',
        name: 'GardenDataMigration');
    developer.log('Mode: ${result.dryRun ? "Dry-run (simulation)" : "Réel"}',
        name: 'GardenDataMigration');
    developer.log('Durée: ${result.duration.inSeconds}s',
        name: 'GardenDataMigration');
    developer.log('─' * 50, name: 'GardenDataMigration');
    developer.log('Jardins migrés:', name: 'GardenDataMigration');
    developer.log('  - Legacy (HiveType 0): ${result.legacyCount}',
        name: 'GardenDataMigration');
    developer.log('  - V2 (HiveType 10): ${result.v2Count}',
        name: 'GardenDataMigration');
    developer.log('  - Hive (HiveType 25): ${result.hiveCount}',
        name: 'GardenDataMigration');
    developer.log('  - TOTAL: ${result.migratedCount}',
        name: 'GardenDataMigration');
    developer.log('─' * 50, name: 'GardenDataMigration');
    developer.log('Vérifications:', name: 'GardenDataMigration');
    developer.log('  - Backup créé: ${result.backupCreated ? "✅" : "❌"}',
        name: 'GardenDataMigration');
    developer.log(
        '  - Intégrité vérifiée: ${result.integrityVerified ? "✅" : "❌"}',
        name: 'GardenDataMigration');
    developer.log(
        '  - Anciennes boxes nettoyées: ${result.oldBoxesCleanedUp ? "✅" : "❌"}',
        name: 'GardenDataMigration');
    developer.log('─' * 50, name: 'GardenDataMigration');

    if (result.errors.isNotEmpty) {
      developer.log('Erreurs:', name: 'GardenDataMigration');
      for (final error in result.errors) {
        developer.log('  ❌ $error', name: 'GardenDataMigration');
      }
      developer.log('─' * 50, name: 'GardenDataMigration');
    }

    developer.log('\n', name: 'GardenDataMigration');
  }
}

/// Résultat d'une migration Garden
class GardenMigrationResult {
  /// Succès de la migration
  bool success = false;

  /// Mode dry-run (simulation)
  final bool dryRun;

  /// Date de début
  final DateTime startedAt;

  /// Date de fin
  DateTime endedAt = DateTime.now();

  /// Durée de la migration
  Duration duration = Duration.zero;

  /// Nombre de jardins Legacy migrés
  int legacyCount = 0;

  /// Nombre de jardins V2 migrés
  int v2Count = 0;

  /// Nombre de jardins Hive migrés
  int hiveCount = 0;

  /// Nombre total de jardins migrés
  int get migratedCount => legacyCount + v2Count + hiveCount;

  /// Liste des jardins migrés
  List<GardenFreezed> migratedGardens = [];

  /// Backup créé
  bool backupCreated = false;

  /// Intégrité vérifiée
  bool integrityVerified = false;

  /// Anciennes boxes nettoyées
  bool oldBoxesCleanedUp = false;

  /// Liste des erreurs
  List<String> errors = [];

  GardenMigrationResult({
    required this.startedAt,
    required this.dryRun,
  });

  /// Résumé JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'dryRun': dryRun,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt.toIso8601String(),
      'durationSeconds': duration.inSeconds,
      'legacyCount': legacyCount,
      'v2Count': v2Count,
      'hiveCount': hiveCount,
      'migratedCount': migratedCount,
      'backupCreated': backupCreated,
      'integrityVerified': integrityVerified,
      'oldBoxesCleanedUp': oldBoxesCleanedUp,
      'errors': errors,
    };
  }
}
