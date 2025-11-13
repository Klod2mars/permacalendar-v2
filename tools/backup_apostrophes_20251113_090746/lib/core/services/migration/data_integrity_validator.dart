import 'dart:developer' as developer;
import '../../models/garden.dart';
import '../../models/garden_freezed.dart';
import '../../data/hive/garden_boxes.dart';
import '../../repositories/garden_hive_repository.dart';
import 'migration_models.dart';

/// Data Integrity Validator - Validateur d'Intégrité des Données
///
/// **Architecture Enterprise - Design Pattern: Validator + Strategy**
///
/// Ce service valide la cohérence et l'intégrité des données pendant
/// la migration Legacy → Moderne :
/// - Validation des données Legacy avant migration
/// - Validation de cohérence Legacy ↔ Moderne
/// - Validation des données après migration
/// - Détection des incohérences et corruptions
///
/// **Types de Validation :**
/// 1. **Validation structurelle** : Présence des champs requis
/// 2. **Validation métier** : Respect des règles métier
/// 3. **Validation de cohérence** : Comparaison Legacy ↔ Moderne
/// 4. **Validation d'intégrité** : Détection de corruptions
///
/// **Standards :**
/// - Clean Architecture
/// - SOLID (Single Responsibility)
/// - Defensive Programming (validation exhaustive)
class DataIntegrityValidator {
  static const String _logName = 'DataIntegrityValidator';

  final GardenHiveRepository _modernRepository = GardenHiveRepository();

  // Seuils de validation
  static const double _minCoherenceThreshold = 0.95; // 95%
  static const int _maxAllowedIssues = 5;

  // Statistiques
  int _validationsPerformed = 0;
  int _issuesDetected = 0;

  /// Constructeur
  DataIntegrityValidator() {
    _log('🏗️ Data Integrity Validator créé', level: 500);
  }

  // ==================== VALIDATION SYSTÈME ====================

  /// Valide le système Legacy complet
  Future<bool> validateLegacySystem() async {
    try {
      _log('🔍 Validation du système Legacy', level: 500);
      _validationsPerformed++;

      final gardens = GardenBoxes.getAllGardens();
      _log('📊 ${gardens.length} jardins à valider', level: 500);

      var validCount = 0;
      final issues = <String>[];

      for (final garden in gardens) {
        final isValid = _validateLegacyGardenStructure(garden);
        if (isValid) {
          validCount++;
        } else {
          issues.add('Jardin ${garden.id} (${garden.name}) invalide');
          _issuesDetected++;
        }
      }

      final validationRate =
          gardens.isNotEmpty ? (validCount / gardens.length) * 100 : 100.0;

      _log(
        '📊 Système Legacy: $validCount/${gardens.length} valides (${validationRate.toStringAsFixed(1)}%)',
        level: 500,
      );

      if (issues.isNotEmpty) {
        _log('⚠️ ${issues.length} problèmes détectés:', level: 900);
        for (final issue in issues) {
          _log('  - $issue', level: 900);
        }
      }

      final isSystemValid = validationRate >= _minCoherenceThreshold * 100 &&
          issues.length <= _maxAllowedIssues;

      if (isSystemValid) {
        _log('✅ Système Legacy valide', level: 500);
      } else {
        _log('❌ Système Legacy invalide', level: 1000);
      }

      return isSystemValid;
    } catch (e, stackTrace) {
      _logError('❌ Erreur validation système Legacy', e, stackTrace);
      return false;
    }
  }

  /// Valide un jardin Legacy spécifique
  Future<bool> validateLegacyGarden(String gardenId) async {
    try {
      _validationsPerformed++;

      final garden = GardenBoxes.getGarden(gardenId);
      if (garden == null) {
        _log('❌ Jardin $gardenId introuvable', level: 1000);
        _issuesDetected++;
        return false;
      }

      final isValid = _validateLegacyGardenStructure(garden);

      if (isValid) {
        _log('✅ Jardin $gardenId valide', level: 500);
      } else {
        _log('❌ Jardin $gardenId invalide', level: 1000);
        _issuesDetected++;
      }

      return isValid;
    } catch (e, stackTrace) {
      _logError('❌ Erreur validation jardin $gardenId', e, stackTrace);
      _issuesDetected++;
      return false;
    }
  }

  /// Valide un jardin migré (comparaison Legacy ↔ Moderne)
  Future<bool> validateMigratedGarden(String gardenId) async {
    try {
      _log('🔍 Validation post-migration jardin $gardenId', level: 500);
      _validationsPerformed++;

      // Récupérer depuis les deux systèmes
      final legacyGarden = GardenBoxes.getGarden(gardenId);
      final modernGarden = await _modernRepository.getGardenById(gardenId);

      // Vérifier la présence dans les deux systèmes
      if (legacyGarden == null) {
        _log('⚠️ Jardin absent de Legacy', level: 900);
      }

      if (modernGarden == null) {
        _log('❌ Jardin absent de Moderne (échec migration)', level: 1000);
        _issuesDetected++;
        return false;
      }

      // Comparer les données
      if (legacyGarden != null) {
        final isCoherent = _compareGardens(legacyGarden, modernGarden);

        if (isCoherent) {
          _log('✅ Jardin $gardenId cohérent entre Legacy et Moderne',
              level: 500);
        } else {
          _log('⚠️ Jardin $gardenId présente des différences', level: 900);
          _issuesDetected++;
        }

        return isCoherent;
      }

      // Si Legacy absent mais Moderne présent, considérer comme migré
      _log('✅ Jardin $gardenId migré avec succès', level: 500);
      return true;
    } catch (e, stackTrace) {
      _logError('❌ Erreur validation post-migration $gardenId', e, stackTrace);
      _issuesDetected++;
      return false;
    }
  }

  /// Valide la cohérence de toutes les données Legacy ↔ Moderne
  Future<CoherenceResult> validateAllData() async {
    try {
      _log('🔍 Validation de cohérence complète', level: 500);
      _validationsPerformed++;

      final startTime = DateTime.now();

      // Récupérer tous les jardins des deux systèmes
      final legacyGardens = GardenBoxes.getAllGardens();
      final modernGardens = await _modernRepository.getAllGardens();

      _log(
        '📊 Comparaison: ${legacyGardens.length} Legacy vs ${modernGardens.length} Moderne',
        level: 500,
      );

      final issues = <String>[];
      var coherentCount = 0;
      var incoherentCount = 0;

      // Vérifier chaque jardin Legacy
      for (final legacyGarden in legacyGardens) {
        try {
          final modernGarden = modernGardens.firstWhere(
            (g) => g.id == legacyGarden.id,
            orElse: () => throw StateError('Not found'),
          );

          final isCoherent = _compareGardens(legacyGarden, modernGarden);
          if (isCoherent) {
            coherentCount++;
          } else {
            incoherentCount++;
            issues.add(
                'Jardin ${legacyGarden.id} incohérent entre Legacy et Moderne');
            _issuesDetected++;
          }
        } catch (e) {
          incoherentCount++;
          issues.add('Jardin ${legacyGarden.id} absent de Moderne');
          _issuesDetected++;
        }
      }

      // Vérifier les jardins Moderne qui n'existent pas dans Legacy
      for (final modernGarden in modernGardens) {
        final existsInLegacy =
            legacyGardens.any((g) => g.id == modernGarden.id);
        if (!existsInLegacy) {
          issues
              .add('Jardin ${modernGarden.id} présent uniquement dans Moderne');
        }
      }

      final totalChecked = legacyGardens.length;
      final coherencePercentage =
          totalChecked > 0 ? (coherentCount / totalChecked) * 100 : 0.0;

      final isCoherent =
          coherencePercentage >= (_minCoherenceThreshold * 100) &&
              issues.length <= _maxAllowedIssues;

      final duration = DateTime.now().difference(startTime);
      _log(
        '📊 Cohérence: $coherentCount/$totalChecked (${coherencePercentage.toStringAsFixed(1)}%) - ${duration.inMilliseconds}ms',
        level: 500,
      );

      if (issues.isNotEmpty) {
        _log('⚠️ ${issues.length} problèmes de cohérence détectés', level: 900);
      }

      return CoherenceResult(
        isCoherent: isCoherent,
        checkedItems: totalChecked,
        coherentItems: coherentCount,
        incoherentItems: incoherentCount,
        issues: issues,
        coherencePercentage: coherencePercentage,
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur validation cohérence', e, stackTrace);

      return CoherenceResult(
        isCoherent: false,
        checkedItems: 0,
        coherentItems: 0,
        incoherentItems: 0,
        issues: ['Erreur validation: $e'],
        coherencePercentage: 0.0,
      );
    }
  }

  // ==================== VALIDATION STRUCTURELLE ====================

  /// Valide la structure d'un jardin Legacy
  bool _validateLegacyGardenStructure(Garden garden) {
    try {
      // Validation des champs requis
      if (garden.id.isEmpty) {
        _log('❌ Jardin sans ID', level: 1000);
        return false;
      }

      if (garden.name.isEmpty) {
        _log('❌ Jardin ${garden.id} sans nom', level: 1000);
        return false;
      }

      if (garden.totalAreaInSquareMeters < 0) {
        _log('❌ Jardin ${garden.id} avec surface négative', level: 1000);
        return false;
      }

      // Validation des dates
      if (garden.createdAt.isAfter(DateTime.now())) {
        _log('❌ Jardin ${garden.id} avec date création future', level: 1000);
        return false;
      }

      if (garden.updatedAt.isBefore(garden.createdAt)) {
        _log('❌ Jardin ${garden.id} avec updatedAt < createdAt', level: 1000);
        return false;
      }

      // Validation métier
      if (!garden.isValid) {
        _log('❌ Jardin ${garden.id} échoue isValid()', level: 1000);
        return false;
      }

      return true;
    } catch (e) {
      _log('❌ Erreur validation structure jardin ${garden.id}: $e',
          level: 1000);
      return false;
    }
  }

  /// Compare deux jardins (Legacy vs Moderne) pour cohérence
  bool _compareGardens(Garden legacyGarden, GardenFreezed modernGarden) {
    try {
      // Comparaison des champs critiques
      if (legacyGarden.id != modernGarden.id) {
        _log('❌ IDs différents', level: 1000);
        return false;
      }

      if (legacyGarden.name != modernGarden.name) {
        _log('⚠️ Noms différents pour ${legacyGarden.id}', level: 900);
        return false;
      }

      // Tolérance pour les champs non critiques (description peut différer)
      final descriptionMatch =
          legacyGarden.description == (modernGarden.description ?? '');
      if (!descriptionMatch && legacyGarden.description.isNotEmpty) {
        _log('⚠️ Descriptions différentes pour ${legacyGarden.id}', level: 700);
      }

      // Comparaison des surfaces (tolérance de 0.01)
      final areaDiff = (legacyGarden.totalAreaInSquareMeters -
              modernGarden.totalAreaInSquareMeters)
          .abs();
      if (areaDiff > 0.01) {
        _log(
          '⚠️ Surfaces différentes pour ${legacyGarden.id}: $areaDiff m²',
          level: 900,
        );
        return false;
      }

      // Comparaison des localisations
      final locationMatch =
          legacyGarden.location == (modernGarden.location ?? '');
      if (!locationMatch && legacyGarden.location.isNotEmpty) {
        _log('⚠️ Localisations différentes pour ${legacyGarden.id}',
            level: 700);
      }

      return true;
    } catch (e) {
      _log('❌ Erreur comparaison jardins: $e', level: 1000);
      return false;
    }
  }

  // ==================== VALIDATION BATCH ====================

  /// Valide un batch de jardins après migration
  Future<CoherenceResult> validateGardenBatch(List<String> gardenIds) async {
    try {
      _log('🔍 Validation batch de ${gardenIds.length} jardins', level: 500);
      _validationsPerformed++;

      final issues = <String>[];
      var coherentCount = 0;
      var incoherentCount = 0;

      for (final gardenId in gardenIds) {
        final isValid = await validateMigratedGarden(gardenId);
        if (isValid) {
          coherentCount++;
        } else {
          incoherentCount++;
          issues.add('Jardin $gardenId invalide après migration');
        }
      }

      final coherencePercentage =
          gardenIds.isNotEmpty ? (coherentCount / gardenIds.length) * 100 : 0.0;

      _log(
        '📊 Batch: $coherentCount/${gardenIds.length} cohérents (${coherencePercentage.toStringAsFixed(1)}%)',
        level: 500,
      );

      return CoherenceResult(
        isCoherent: coherencePercentage >= (_minCoherenceThreshold * 100),
        checkedItems: gardenIds.length,
        coherentItems: coherentCount,
        incoherentItems: incoherentCount,
        issues: issues,
        coherencePercentage: coherencePercentage,
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur validation batch', e, stackTrace);

      return CoherenceResult(
        isCoherent: false,
        checkedItems: gardenIds.length,
        coherentItems: 0,
        incoherentItems: gardenIds.length,
        issues: ['Erreur validation batch: $e'],
        coherencePercentage: 0.0,
      );
    }
  }

  // ==================== VALIDATION DÉTAILLÉE ====================

  /// Effectue une validation détaillée d'un jardin Legacy
  Future<Map<String, dynamic>> performDetailedValidation(
      String gardenId) async {
    try {
      _validationsPerformed++;

      final validation = <String, dynamic>{
        'gardenId': gardenId,
        'timestamp': DateTime.now().toIso8601String(),
        'checks': <String, bool>{},
        'issues': <String>[],
        'warnings': <String>[],
      };

      // Récupérer le jardin
      final garden = GardenBoxes.getGarden(gardenId);
      if (garden == null) {
        validation['checks']['exists'] = false;
        validation['issues'].add('Jardin introuvable');
        return validation;
      }

      validation['checks']['exists'] = true;

      // Check structure
      validation['checks']['hasId'] = garden.id.isNotEmpty;
      validation['checks']['hasName'] = garden.name.isNotEmpty;
      validation['checks']['validArea'] = garden.totalAreaInSquareMeters >= 0;
      validation['checks']['validLocation'] = garden.location.isNotEmpty;
      validation['checks']['validCreatedAt'] =
          !garden.createdAt.isAfter(DateTime.now());
      validation['checks']['validUpdatedAt'] =
          !garden.updatedAt.isBefore(garden.createdAt);
      validation['checks']['isValid'] = garden.isValid;

      // Collecter les problèmes
      validation['checks'].forEach((key, value) {
        if (!value) {
          validation['issues'].add('Check $key échoué');
          _issuesDetected++;
        }
      });

      // Validation métier
      if (garden.totalAreaInSquareMeters > 10000) {
        validation['warnings']
            .add('Surface très grande (${garden.totalAreaInSquareMeters}m²)');
      }

      if (garden.description.isEmpty) {
        validation['warnings'].add('Pas de description');
      }

      validation['isValid'] = (validation['issues'] as List).isEmpty;

      _log(
        '📊 Validation détaillée $gardenId: ${validation['checks'].length} checks, ${validation['issues'].length} problèmes',
        level: 500,
      );

      return validation;
    } catch (e, stackTrace) {
      _logError('❌ Erreur validation détaillée $gardenId', e, stackTrace);

      return {
        'gardenId': gardenId,
        'error': e.toString(),
        'isValid': false,
      };
    }
  }

  // ==================== CORRECTION AUTOMATIQUE ====================

  /// Tente de corriger automatiquement les incohérences simples
  Future<bool> attemptAutoFix(String gardenId) async {
    try {
      _log('🔧 Tentative correction automatique $gardenId', level: 500);

      // Récupérer les deux versions
      final legacyGarden = GardenBoxes.getGarden(gardenId);
      final modernGarden = await _modernRepository.getGardenById(gardenId);

      if (legacyGarden == null || modernGarden == null) {
        _log('❌ Impossible de corriger - Jardin manquant', level: 1000);
        return false;
      }

      // Détecter les différences et prioriser Moderne
      var fixed = false;

      // Correction du nom
      if (legacyGarden.name != modernGarden.name) {
        legacyGarden.name = modernGarden.name;
        fixed = true;
      }

      // Correction de la surface
      if ((legacyGarden.totalAreaInSquareMeters -
                  modernGarden.totalAreaInSquareMeters)
              .abs() >
          0.01) {
        legacyGarden.totalAreaInSquareMeters =
            modernGarden.totalAreaInSquareMeters;
        fixed = true;
      }

      // Sauvegarder les corrections
      if (fixed) {
        legacyGarden.markAsUpdated();
        await GardenBoxes.saveGarden(legacyGarden);
        _log('✅ Corrections appliquées à $gardenId', level: 500);
      } else {
        _log('ℹ️ Aucune correction nécessaire pour $gardenId', level: 500);
      }

      return true;
    } catch (e, stackTrace) {
      _logError('❌ Erreur correction auto $gardenId', e, stackTrace);
      return false;
    }
  }

  // ==================== STATISTIQUES ====================

  Map<String, dynamic> getStatistics() {
    return {
      'validationsPerformed': _validationsPerformed,
      'issuesDetected': _issuesDetected,
      'issueRate': _validationsPerformed > 0
          ? (_issuesDetected / _validationsPerformed) * 100
          : 0.0,
    };
  }

  void resetStatistics() {
    _validationsPerformed = 0;
    _issuesDetected = 0;
    _log('📊 Statistiques validateur réinitialisées', level: 500);
  }

  // ==================== UTILITAIRES ====================

  void _log(String message, {int level = 500}) {
    developer.log(message, name: _logName, level: level);
    print('[$_logName] $message');
  }

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

  int get validationsPerformed => _validationsPerformed;
  int get issuesDetected => _issuesDetected;
}

/// Exception de validation
class DataIntegrityException implements Exception {
  final String message;
  const DataIntegrityException(this.message);

  @override
  String toString() => 'DataIntegrityException: $message';
}


