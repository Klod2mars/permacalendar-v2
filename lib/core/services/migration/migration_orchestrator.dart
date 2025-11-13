import 'dart:developer' as developer;
import 'package:riverpod/riverpod.dart';
import 'dual_write_service.dart';
import 'read_switch_service.dart';
import 'data_integrity_validator.dart';
import 'legacy_cleanup_service.dart';
import 'data_archival_service.dart';
import 'migration_health_checker.dart';
import 'migration_models.dart';

/// Migration Orchestrator - Orchestrateur Principal de Migration
///
/// **Architecture Enterprise - Design Pattern: Orchestrator + Strategy**
///
/// Cet orchestrateur gère la migration complète et progressive du système
/// Legacy vers le système Moderne, en garantissant :
/// - Zéro perte de données via double écriture
/// - Migration transparente pour l'utilisateur
/// - Possibilité de rollback à tout moment
/// - Monitoring complet de la progression
/// - Performance maintenue pendant la migration
///
/// **Phases de Migration :**
/// 1. **Preparation** : Validation et archivage des données Legacy
/// 2. **Transition** : Double écriture Legacy + Moderne avec validation
/// 3. **Switch** : Basculement de lecture vers Moderne uniquement
/// 4. **Cleanup** : Suppression progressive du système Legacy
///
/// **Standards :**
/// - Clean Architecture (séparation des responsabilités)
/// - SOLID Principles (Single Responsibility, Open/Closed)
/// - Enterprise Patterns (Orchestrator, Strategy, Observer)
/// - Null Safety (code sécurisé)
class MigrationOrchestrator {
  static const String _logName = 'MigrationOrchestrator';

  // Services de migration
  final DualWriteService _dualWriteService;
  final ReadSwitchService _readSwitchService;
  final DataIntegrityValidator _integrityValidator;
  final LegacyCleanupService _cleanupService;
  final DataArchivalService _archivalService;
  final MigrationHealthChecker _healthChecker;

  // État de la migration
  MigrationPhase _currentPhase = MigrationPhase.notStarted;
  MigrationProgress? _currentProgress;

  // Configuration
  final MigrationConfig config;

  /// Constructeur avec injection de dépendances
  MigrationOrchestrator({
    DualWriteService? dualWriteService,
    ReadSwitchService? readSwitchService,
    DataIntegrityValidator? integrityValidator,
    LegacyCleanupService? cleanupService,
    DataArchivalService? archivalService,
    MigrationHealthChecker? healthChecker,
    MigrationConfig? config,
  })  : _dualWriteService = dualWriteService ?? DualWriteService(),
        _readSwitchService = readSwitchService ?? ReadSwitchService(),
        _integrityValidator = integrityValidator ?? DataIntegrityValidator(),
        _cleanupService = cleanupService ?? LegacyCleanupService(),
        _archivalService = archivalService ?? DataArchivalService(),
        _healthChecker = healthChecker ?? MigrationHealthChecker(),
        config = config ?? MigrationConfig.defaultConfig() {
    _log('🏗️ Migration Orchestrator initialisé', level: 500);
  }

  // ==================== API PUBLIQUE ====================

  /// Lance la migration complète avec toutes les phases
  ///
  /// **Phases exécutées :**
  /// 1. Préparation (archivage + validation)
  /// 2. Transition (double écriture)
  /// 3. Basculement (lecture depuis Moderne)
  /// 4. Nettoyage (suppression Legacy)
  ///
  /// **Retourne :** Résultat complet de la migration
  Future<MigrationResult> startCompleteMigration() async {
    _log('🚀 DÉBUT MIGRATION COMPLÈTE', level: 500);

    final startTime = DateTime.now();
    final results = <String, dynamic>{};

    try {
      // Phase 1 : Préparation
      _currentPhase = MigrationPhase.preparation;
      final prepResult = await _executePreparationPhase();
      results['preparation'] = prepResult;

      if (!prepResult.success) {
        return _createFailedResult(
          'Échec phase de préparation',
          startTime,
          results,
        );
      }

      // Phase 2 : Transition (Double écriture)
      _currentPhase = MigrationPhase.transition;
      final transitionResult = await _executeTransitionPhase();
      results['transition'] = transitionResult;

      if (!transitionResult.success) {
        // Rollback si échec
        await rollbackMigration();
        return _createFailedResult(
          'Échec phase de transition - Rollback effectué',
          startTime,
          results,
        );
      }

      // Phase 3 : Basculement
      _currentPhase = MigrationPhase.switching;
      final switchResult = await _executeSwitchPhase();
      results['switch'] = switchResult;

      if (!switchResult.success) {
        await rollbackMigration();
        return _createFailedResult(
          'Échec phase de basculement - Rollback effectué',
          startTime,
          results,
        );
      }

      // Phase 4 : Nettoyage (optionnel selon config)
      if (config.autoCleanupLegacy) {
        _currentPhase = MigrationPhase.cleanup;
        final cleanupResult = await _executeCleanupPhase();
        results['cleanup'] = cleanupResult;
      }

      // Migration complétée avec succès
      _currentPhase = MigrationPhase.completed;

      final duration = DateTime.now().difference(startTime);
      _log('✅ MIGRATION COMPLÈTE RÉUSSIE (${duration.inSeconds}s)', level: 500);

      return MigrationResult(
        success: true,
        phase: _currentPhase,
        message: 'Migration complète terminée avec succès',
        duration: duration,
        details: results,
        timestamp: DateTime.now(),
      );
    } catch (e, stackTrace) {
      _logError('❌ ERREUR CRITIQUE MIGRATION', e, stackTrace);

      // Tenter rollback en cas d'erreur critique
      try {
        await rollbackMigration();
        results['rollback'] = {'success': true};
      } catch (rollbackError) {
        _logError('❌ Échec du rollback', rollbackError);
        results['rollback'] = {
          'success': false,
          'error': rollbackError.toString()
        };
      }

      return _createFailedResult(
        'Erreur critique : $e',
        startTime,
        results,
      );
    }
  }

  /// Migre un jardin spécifique de Legacy vers Moderne
  ///
  /// **Processus :**
  /// 1. Validation du jardin Legacy
  /// 2. Archivage du jardin
  /// 3. Conversion Legacy → Moderne
  /// 4. Validation de cohérence
  /// 5. Écriture dans Moderne
  /// 6. Vérification finale
  Future<MigrationResult> migrateGarden(String gardenId) async {
    _log('🌱 Migration du jardin $gardenId', level: 500);

    final startTime = DateTime.now();

    try {
      // 1. Validation du jardin Legacy
      final isValid = await _integrityValidator.validateLegacyGarden(gardenId);
      if (!isValid) {
        return MigrationResult(
          success: false,
          phase: MigrationPhase.validation,
          message: 'Jardin Legacy invalide ou introuvable',
          duration: DateTime.now().difference(startTime),
          details: {'gardenId': gardenId, 'valid': false},
          timestamp: DateTime.now(),
        );
      }

      // 2. Archivage
      final archived = await _archivalService.archiveGarden(gardenId);
      if (!archived) {
        _log('⚠️ Archivage échoué (non critique)', level: 900);
      }

      // 3. Migration via DualWriteService
      final migrated = await _dualWriteService.migrateGardenToModern(gardenId);
      if (!migrated) {
        return MigrationResult(
          success: false,
          phase: MigrationPhase.transition,
          message: 'Échec de la migration du jardin',
          duration: DateTime.now().difference(startTime),
          details: {'gardenId': gardenId, 'migrated': false},
          timestamp: DateTime.now(),
        );
      }

      // 4. Validation post-migration
      final coherent =
          await _integrityValidator.validateMigratedGarden(gardenId);
      if (!coherent) {
        _log('❌ Validation post-migration échouée', level: 1000);
        // Rollback du jardin
        await _dualWriteService.rollbackGarden(gardenId);
        return MigrationResult(
          success: false,
          phase: MigrationPhase.validation,
          message: 'Validation post-migration échouée - Rollback effectué',
          duration: DateTime.now().difference(startTime),
          details: {'gardenId': gardenId, 'validated': false},
          timestamp: DateTime.now(),
        );
      }

      _log('✅ Jardin $gardenId migré avec succès', level: 500);

      return MigrationResult(
        success: true,
        phase: MigrationPhase.completed,
        message: 'Jardin migré avec succès',
        duration: DateTime.now().difference(startTime),
        details: {
          'gardenId': gardenId,
          'archived': archived,
          'validated': coherent,
        },
        timestamp: DateTime.now(),
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur migration jardin $gardenId', e, stackTrace);

      return MigrationResult(
        success: false,
        phase: _currentPhase,
        message: 'Erreur lors de la migration : $e',
        duration: DateTime.now().difference(startTime),
        details: {'gardenId': gardenId, 'error': e.toString()},
        timestamp: DateTime.now(),
      );
    }
  }

  /// Migre tous les jardins par batch avec contrôle de progression
  ///
  /// **Configuration :**
  /// - Taille du batch configurable (défaut: 10 jardins)
  /// - Pause entre batches pour performance
  /// - Validation après chaque batch
  /// - Arrêt automatique si taux d'erreur > seuil
  Future<MigrationBatchResult> migrateAllGardens({
    int batchSize = 10,
    Duration pauseBetweenBatches = const Duration(seconds: 2),
  }) async {
    _log('🔄 Migration de tous les jardins (batch: $batchSize)', level: 500);

    final startTime = DateTime.now();
    final successfulMigrations = <String>[];
    final failedMigrations = <String, String>{};

    try {
      // Récupérer tous les jardins Legacy
      final legacyGardenIds = await _dualWriteService.getAllLegacyGardenIds();
      final totalGardens = legacyGardenIds.length;

      _log('📊 $totalGardens jardins à migrer', level: 500);

      // Migrer par batch
      for (var i = 0; i < legacyGardenIds.length; i += batchSize) {
        final batchEnd = (i + batchSize < legacyGardenIds.length)
            ? i + batchSize
            : legacyGardenIds.length;
        final batch = legacyGardenIds.sublist(i, batchEnd);
        final batchNumber = (i / batchSize).floor() + 1;

        _log('📦 Batch $batchNumber : ${batch.length} jardins', level: 500);

        // Migrer chaque jardin du batch
        for (final gardenId in batch) {
          final result = await migrateGarden(gardenId);

          if (result.success) {
            successfulMigrations.add(gardenId);
            _log('  ✅ $gardenId migré', level: 500);
          } else {
            failedMigrations[gardenId] = result.message;
            _log('  ❌ $gardenId échoué: ${result.message}', level: 1000);
          }

          // Vérifier le seuil d'erreur
          final errorRate = failedMigrations.length / (i + 1);
          if (errorRate > config.maxErrorRate) {
            _log(
              '🚨 Taux d\'erreur trop élevé (${(errorRate * 100).toStringAsFixed(1)}%) - Arrêt',
              level: 1000,
            );
            break;
          }
        }

        // Pause entre batches pour ne pas surcharger
        if (batchEnd < legacyGardenIds.length) {
          _log('⏸️ Pause ${pauseBetweenBatches.inSeconds}s...', level: 500);
          await Future.delayed(pauseBetweenBatches);
        }
      }

      final duration = DateTime.now().difference(startTime);
      final successRate = totalGardens > 0
          ? (successfulMigrations.length / totalGardens) * 100
          : 0.0;

      _log(
        '🎯 Migration batch terminée: ${successfulMigrations.length}/$totalGardens (${successRate.toStringAsFixed(1)}%)',
        level: 500,
      );

      return MigrationBatchResult(
        totalItems: totalGardens,
        successfulMigrations: successfulMigrations,
        failedMigrations: failedMigrations,
        duration: duration,
        successRate: successRate,
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur migration batch', e, stackTrace);

      return MigrationBatchResult(
        totalItems: 0,
        successfulMigrations: successfulMigrations,
        failedMigrations: failedMigrations,
        duration: DateTime.now().difference(startTime),
        successRate: 0.0,
        error: e.toString(),
      );
    }
  }

  /// Active le mode de double écriture pour la migration progressive
  ///
  /// En mode double écriture :
  /// - Toutes les écritures vont vers Legacy ET Moderne
  /// - Les lectures viennent toujours de Legacy (safe)
  /// - Permet une migration transparente sans risque
  Future<bool> enableDualWriteMode() async {
    try {
      _log('🔄 Activation du mode double écriture', level: 500);

      // Valider l'état du système
      final health = await _healthChecker.checkSystemHealth();
      if (!health.isHealthy) {
        _log('❌ Système non sain - Impossible d\'activer', level: 1000);
        return false;
      }

      // Activer la double écriture
      await _dualWriteService.enableDualWrite();

      // Vérifier l'activation
      if (_dualWriteService.isEnabled) {
        _currentPhase = MigrationPhase.transition;
        _log('✅ Mode double écriture activé', level: 500);
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      _logError('❌ Erreur activation double écriture', e, stackTrace);
      return false;
    }
  }

  /// Bascule les lectures vers le système Moderne
  ///
  /// **Préconditions :**
  /// - Double écriture active depuis un certain temps
  /// - Validation de cohérence réussie
  /// - Taux d'erreur < seuil acceptable
  Future<bool> switchToModernReads() async {
    try {
      _log('🔄 Basculement vers lectures Moderne', level: 500);

      // Vérifier les préconditions
      if (!_dualWriteService.isEnabled) {
        _log('❌ Double écriture non active', level: 1000);
        return false;
      }

      // Valider la cohérence des données
      final coherenceResult = await _integrityValidator.validateAllData();
      if (!coherenceResult.isCoherent) {
        _log(
          '❌ Données incohérentes - Basculement refusé (${coherenceResult.issuesCount} problèmes)',
          level: 1000,
        );
        return false;
      }

      // Vérifier la santé du système Moderne
      final modernHealth = await _healthChecker.checkModernSystemHealth();
      if (modernHealth != SystemHealth.healthy) {
        _log('❌ Système Moderne non sain', level: 1000);
        return false;
      }

      // Effectuer le basculement
      await _readSwitchService.switchToModernReads();

      if (_readSwitchService.isReadingFromModern) {
        _currentPhase = MigrationPhase.switching;
        _log('✅ Basculement réussi - Lecture depuis Moderne', level: 500);
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      _logError('❌ Erreur basculement lectures', e, stackTrace);
      return false;
    }
  }

  /// Désactive la double écriture et passe en mode Moderne uniquement
  ///
  /// **Attention :** Action irréversible sans rollback manuel
  Future<bool> disableDualWriteMode() async {
    try {
      _log('⚠️ Désactivation du mode double écriture', level: 900);

      // Validation finale avant désactivation
      final coherenceResult = await _integrityValidator.validateAllData();
      if (!coherenceResult.isCoherent) {
        _log(
          '❌ Données incohérentes - Désactivation refusée',
          level: 1000,
        );
        return false;
      }

      // Désactiver la double écriture
      await _dualWriteService.disableDualWrite();

      if (!_dualWriteService.isEnabled) {
        _log('✅ Mode double écriture désactivé - Moderne uniquement',
            level: 500);
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      _logError('❌ Erreur désactivation double écriture', e, stackTrace);
      return false;
    }
  }

  /// Nettoie progressivement le système Legacy
  ///
  /// **Étapes :**
  /// 1. Archivage final des données Legacy
  /// 2. Suppression progressive des boxes
  /// 3. Nettoyage des services Legacy
  /// 4. Libération de la mémoire
  Future<MigrationResult> cleanupLegacySystem() async {
    _log('🧹 Nettoyage du système Legacy', level: 500);

    final startTime = DateTime.now();

    try {
      // Vérifier que la migration est terminée
      if (_currentPhase != MigrationPhase.completed &&
          _currentPhase != MigrationPhase.switching) {
        return MigrationResult(
          success: false,
          phase: _currentPhase,
          message: 'Migration non terminée - Nettoyage refusé',
          duration: DateTime.now().difference(startTime),
          details: {'currentPhase': _currentPhase.toString()},
          timestamp: DateTime.now(),
        );
      }

      // Archivage final
      _log('📦 Archivage final des données Legacy', level: 500);
      final archived = await _archivalService.archiveAllLegacyData();

      // Nettoyage progressif
      _log('🗑️ Suppression progressive des boxes Legacy', level: 500);
      final cleaned = await _cleanupService.cleanupAllLegacyBoxes();

      _currentPhase = MigrationPhase.cleanup;

      final duration = DateTime.now().difference(startTime);
      _log('✅ Nettoyage terminé (${duration.inSeconds}s)', level: 500);

      return MigrationResult(
        success: true,
        phase: _currentPhase,
        message: 'Nettoyage Legacy complété',
        duration: duration,
        details: {
          'archived': archived,
          'cleaned': cleaned,
        },
        timestamp: DateTime.now(),
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur nettoyage Legacy', e, stackTrace);

      return MigrationResult(
        success: false,
        phase: _currentPhase,
        message: 'Erreur lors du nettoyage : $e',
        duration: DateTime.now().difference(startTime),
        details: {'error': e.toString()},
        timestamp: DateTime.now(),
      );
    }
  }

  /// Effectue un rollback complet vers le système Legacy
  ///
  /// **Actions :**
  /// 1. Désactivation double écriture
  /// 2. Restauration lectures depuis Legacy
  /// 3. Restauration depuis archives si nécessaire
  Future<bool> rollbackMigration() async {
    _log('⏪ ROLLBACK DE LA MIGRATION', level: 1000);

    try {
      // Désactiver double écriture
      await _dualWriteService.disableDualWrite();

      // Restaurer lectures depuis Legacy
      await _readSwitchService.switchToLegacyReads();

      // Restaurer depuis archives si nécessaire
      final restored = await _archivalService.restoreFromLatestArchive();

      _currentPhase = MigrationPhase.rolledBack;
      _log('✅ Rollback terminé', level: 500);

      return restored;
    } catch (e, stackTrace) {
      _logError('❌ Erreur critique lors du rollback', e, stackTrace);
      return false;
    }
  }

  /// Obtient la progression actuelle de la migration
  MigrationProgress getCurrentProgress() {
    if (_currentProgress == null) {
      return MigrationProgress(
        phase: _currentPhase,
        totalItems: 0,
        processedItems: 0,
        successfulItems: 0,
        failedItems: 0,
        percentComplete: 0.0,
        estimatedTimeRemaining: Duration.zero,
      );
    }

    return _currentProgress!;
  }

  /// Obtient l'état de santé complet du système de migration
  Future<MigrationHealthReport> getHealthReport() async {
    try {
      return await _healthChecker.generateFullReport();
    } catch (e, stackTrace) {
      _logError('❌ Erreur génération rapport santé', e, stackTrace);

      return MigrationHealthReport(
        isHealthy: false,
        timestamp: DateTime.now(),
        legacySystemHealth: SystemHealth.unknown,
        modernSystemHealth: SystemHealth.unknown,
        dataCoherence: 0.0,
        errorRate: 1.0,
        issues: ['Erreur génération rapport : $e'],
      );
    }
  }

  // ==================== PHASES DE MIGRATION ====================

  /// Phase 1 : Préparation (Archivage + Validation)
  Future<PhaseResult> _executePreparationPhase() async {
    _log('📋 PHASE 1 : Préparation', level: 500);

    final startTime = DateTime.now();

    try {
      // 1. Validation système Legacy
      _log('🔍 Validation du système Legacy', level: 500);
      final legacyValid = await _integrityValidator.validateLegacySystem();
      if (!legacyValid) {
        return PhaseResult(
          success: false,
          phase: MigrationPhase.preparation,
          message: 'Système Legacy invalide',
          duration: DateTime.now().difference(startTime),
        );
      }

      // 2. Archivage complet
      _log('📦 Archivage des données Legacy', level: 500);
      final archived = await _archivalService.archiveAllLegacyData();
      if (!archived) {
        _log('⚠️ Archivage échoué (non bloquant)', level: 900);
      }

      // 3. Préparation système Moderne
      _log('🏗️ Préparation du système Moderne', level: 500);
      await _dualWriteService.prepareModernSystem();

      final duration = DateTime.now().difference(startTime);
      _log('✅ Phase préparation terminée (${duration.inSeconds}s)', level: 500);

      return PhaseResult(
        success: true,
        phase: MigrationPhase.preparation,
        message: 'Préparation réussie',
        duration: duration,
        details: {
          'legacyValid': legacyValid,
          'archived': archived,
        },
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur phase préparation', e, stackTrace);

      return PhaseResult(
        success: false,
        phase: MigrationPhase.preparation,
        message: 'Erreur préparation : $e',
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  /// Phase 2 : Transition (Double écriture)
  Future<PhaseResult> _executeTransitionPhase() async {
    _log('🔄 PHASE 2 : Transition (Double écriture)', level: 500);

    final startTime = DateTime.now();

    try {
      // Activer la double écriture
      final enabled = await enableDualWriteMode();
      if (!enabled) {
        return PhaseResult(
          success: false,
          phase: MigrationPhase.transition,
          message: 'Impossible d\'activer la double écriture',
          duration: DateTime.now().difference(startTime),
        );
      }

      // Migrer tous les jardins existants
      _log('📊 Migration des jardins existants', level: 500);
      final batchResult = await migrateAllGardens(
        batchSize: config.batchSize,
        pauseBetweenBatches: config.pauseBetweenBatches,
      );

      if (batchResult.successRate < config.minSuccessRate) {
        return PhaseResult(
          success: false,
          phase: MigrationPhase.transition,
          message:
              'Taux de succès insuffisant (${batchResult.successRate.toStringAsFixed(1)}%)',
          duration: DateTime.now().difference(startTime),
          details: {
            'batchResult': batchResult.toJson(),
          },
        );
      }

      // Validation finale de cohérence
      _log('🔍 Validation de cohérence', level: 500);
      final coherenceResult = await _integrityValidator.validateAllData();
      if (!coherenceResult.isCoherent) {
        return PhaseResult(
          success: false,
          phase: MigrationPhase.transition,
          message: 'Données incohérentes après migration',
          duration: DateTime.now().difference(startTime),
          details: {
            'issues': coherenceResult.issues,
          },
        );
      }

      final duration = DateTime.now().difference(startTime);
      _log('✅ Phase transition terminée (${duration.inSeconds}s)', level: 500);

      return PhaseResult(
        success: true,
        phase: MigrationPhase.transition,
        message: 'Transition réussie',
        duration: duration,
        details: {
          'migratedGardens': batchResult.successfulMigrations.length,
          'successRate': batchResult.successRate,
        },
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur phase transition', e, stackTrace);

      return PhaseResult(
        success: false,
        phase: MigrationPhase.transition,
        message: 'Erreur transition : $e',
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  /// Phase 3 : Basculement (Lecture depuis Moderne)
  Future<PhaseResult> _executeSwitchPhase() async {
    _log('🔀 PHASE 3 : Basculement vers Moderne', level: 500);

    final startTime = DateTime.now();

    try {
      // Basculer les lectures
      final switched = await switchToModernReads();
      if (!switched) {
        return PhaseResult(
          success: false,
          phase: MigrationPhase.switching,
          message: 'Échec du basculement',
          duration: DateTime.now().difference(startTime),
        );
      }

      // Période de monitoring (selon config)
      _log('⏱️ Période de monitoring (${config.monitoringPeriod.inHours}h)',
          level: 500);
      await _monitorSystemStability(config.monitoringPeriod);

      // Validation finale
      final health = await _healthChecker.checkSystemHealth();
      if (!health.isHealthy) {
        // Rollback si problèmes détectés
        await _readSwitchService.switchToLegacyReads();
        return PhaseResult(
          success: false,
          phase: MigrationPhase.switching,
          message: 'Problèmes détectés - Rollback effectué',
          duration: DateTime.now().difference(startTime),
          details: health.toJson(),
        );
      }

      final duration = DateTime.now().difference(startTime);
      _log('✅ Phase basculement terminée (${duration.inSeconds}s)', level: 500);

      return PhaseResult(
        success: true,
        phase: MigrationPhase.switching,
        message: 'Basculement réussi',
        duration: duration,
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur phase basculement', e, stackTrace);

      return PhaseResult(
        success: false,
        phase: MigrationPhase.switching,
        message: 'Erreur basculement : $e',
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  /// Phase 4 : Nettoyage (Suppression Legacy)
  Future<PhaseResult> _executeCleanupPhase() async {
    _log('🧹 PHASE 4 : Nettoyage Legacy', level: 500);

    final startTime = DateTime.now();

    try {
      // Nettoyage du système Legacy
      final cleanupResult = await cleanupLegacySystem();

      final duration = DateTime.now().difference(startTime);

      if (cleanupResult.success) {
        _log('✅ Phase nettoyage terminée (${duration.inSeconds}s)', level: 500);
      } else {
        _log('⚠️ Phase nettoyage partiellement réussie', level: 900);
      }

      return PhaseResult(
        success: cleanupResult.success,
        phase: MigrationPhase.cleanup,
        message: cleanupResult.message,
        duration: duration,
        details: cleanupResult.details,
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur phase nettoyage', e, stackTrace);

      return PhaseResult(
        success: false,
        phase: MigrationPhase.cleanup,
        message: 'Erreur nettoyage : $e',
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  // ==================== UTILITAIRES ====================

  /// Monitore la stabilité du système pendant une période donnée
  Future<void> _monitorSystemStability(Duration duration) async {
    final endTime = DateTime.now().add(duration);
    var checkCount = 0;

    while (DateTime.now().isBefore(endTime)) {
      checkCount++;
      _log('📊 Monitoring check $checkCount', level: 500);

      final health = await _healthChecker.checkSystemHealth();
      if (!health.isHealthy) {
        _log('⚠️ Problème détecté lors du monitoring', level: 1000);
        throw MigrationException(
          'Problème de stabilité détecté : ${health.issues.join(", ")}',
        );
      }

      // Attendre avant le prochain check (1 minute)
      await Future.delayed(const Duration(minutes: 1));
    }

    _log('✅ Monitoring terminé - Système stable', level: 500);
  }

  /// Crée un résultat d'échec
  MigrationResult _createFailedResult(
    String message,
    DateTime startTime,
    Map<String, dynamic> details,
  ) {
    return MigrationResult(
      success: false,
      phase: _currentPhase,
      message: message,
      duration: DateTime.now().difference(startTime),
      details: details,
      timestamp: DateTime.now(),
    );
  }

  /// Log une info
  void _log(String message, {int level = 500}) {
    developer.log(message, name: _logName, level: level);
    print('[$_logName] $message');
  }

  /// Log une erreur
  void _logError(String message, Object error, [StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _logName,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    print('[$_logName] ERROR: $message - $error');
  }

  // ==================== GETTERS ====================

  MigrationPhase get currentPhase => _currentPhase;
  bool get isDualWriteEnabled => _dualWriteService.isEnabled;
  bool get isReadingFromModern => _readSwitchService.isReadingFromModern;
}

/// Exception de migration
class MigrationException implements Exception {
  final String message;
  const MigrationException(this.message);

  @override
  String toString() => 'MigrationException: $message';
}

/// Provider Riverpod pour le Migration Orchestrator
final migrationOrchestratorProvider = Provider<MigrationOrchestrator>((ref) {
  return MigrationOrchestrator();
});


