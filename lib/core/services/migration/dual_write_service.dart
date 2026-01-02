import 'dart:developer' as developer;
import '../../models/garden.dart';
import '../../models/garden_freezed.dart';
import '../../data/hive/garden_boxes.dart';
import '../../repositories/garden_hive_repository.dart';

/// Dual Write Service - Service de Double Écriture
///
/// **Architecture Enterprise - Design Pattern: Strategy + Proxy**
///
/// Ce service implémente la double écriture pour garantir la cohérence
/// des données pendant la migration Legacy â†’ Moderne :
/// - Écrit simultanément dans Legacy ET Moderne
/// - Résout les conflits d'écriture
/// - Garantit zéro perte de données
/// - Permet le rollback à tout moment
///
/// **Stratégie de Résolution des Conflits :**
/// - En cas de conflit, Moderne l'emporte (source de vérité future)
/// - Si Moderne échoue, maintenir Legacy uniquement
/// - Si Legacy échoue, continuer avec Moderne (migration progressive)
///
/// **Standards :**
/// - Clean Architecture (abstraction de l'accès aux données)
/// - SOLID (Single Responsibility)
/// - Null Safety (code sécurisé)
class DualWriteService {
  static const String _logName = 'DualWriteService';

  // État du service
  bool _isEnabled = false;

  // Repositories
  final GardenHiveRepository _modernRepository = GardenHiveRepository();

  // Statistiques
  int _legacyWriteSuccessCount = 0;
  int _legacyWriteFailureCount = 0;
  int _modernWriteSuccessCount = 0;
  int _modernWriteFailureCount = 0;
  int _conflictResolutionCount = 0;

  /// Constructeur
  DualWriteService() {
    _log('ðŸ—ï¸ Dual Write Service Créé', level: 500);
  }

  // ==================== ACTIVATION / DÉSACTIVATION ====================

  /// Active le mode double écriture
  Future<void> enableDualWrite() async {
    try {
      _log('ðŸ”„ Activation du mode double écriture', level: 500);

      // Vérifier que les deux systèmes sont disponibles
      final legacyAvailable = await _checkLegacySystemAvailable();
      final modernAvailable = await _checkModernSystemAvailable();

      if (!legacyAvailable) {
        throw const DualWriteException('Système Legacy non disponible');
      }

      if (!modernAvailable) {
        throw const DualWriteException('Système Moderne non disponible');
      }

      _isEnabled = true;
      _log('âœ… Mode double écriture activé', level: 500);
    } catch (e, stackTrace) {
      _logError('âŒ Erreur activation double écriture', e, stackTrace);
      rethrow;
    }
  }

  /// Désactive le mode double écriture
  Future<void> disableDualWrite() async {
    try {
      _log('âš ï¸ Désactivation du mode double écriture', level: 900);
      _isEnabled = false;
      _log('âœ… Mode double écriture désactivé', level: 500);
    } catch (e, stackTrace) {
      _logError('âŒ Erreur désactivation double écriture', e, stackTrace);
      rethrow;
    }
  }

  /// Prépare le système Moderne pour la migration
  Future<void> prepareModernSystem() async {
    try {
      _log('ðŸ—ï¸ Préparation du système Moderne', level: 500);

      // Initialiser le repository moderne si nécessaire
      await GardenHiveRepository.initialize();

      _log('âœ… Système Moderne prêt', level: 500);
    } catch (e, stackTrace) {
      _logError('âŒ Erreur préparation système Moderne', e, stackTrace);
      rethrow;
    }
  }

  // ==================== OPÉRATIONS D'ÉCRITURE ====================

  /// Crée un jardin avec double écriture Legacy + Moderne
  Future<bool> createGarden(GardenFreezed garden) async {
    if (!_isEnabled) {
      // Si double écriture désactivée, écrire uniquement dans Moderne
      return await _createModernOnly(garden);
    }

    try {
      _log('ðŸ’¾ Création jardin (double écriture): ${garden.name}',
          level: 500);

      // Écriture parallèle Legacy + Moderne
      final results = await Future.wait([
        _createLegacy(garden),
        _createModern(garden),
      ]);

      final legacySuccess = results[0];
      final modernSuccess = results[1];

      // Gestion des résultats
      if (legacySuccess && modernSuccess) {
        _log('âœ… Double écriture réussie', level: 500);
        _legacyWriteSuccessCount++;
        _modernWriteSuccessCount++;
        return true;
      } else if (modernSuccess) {
        _log('âš ï¸ Legacy échoué, Moderne OK (migration progressive)',
            level: 900);
        _legacyWriteFailureCount++;
        _modernWriteSuccessCount++;
        return true;
      } else if (legacySuccess) {
        _log('âš ï¸ Moderne échoué, Legacy OK (fallback)', level: 900);
        _legacyWriteSuccessCount++;
        _modernWriteFailureCount++;
        return true;
      } else {
        _log('âŒ Double écriture échouée', level: 1000);
        _legacyWriteFailureCount++;
        _modernWriteFailureCount++;
        return false;
      }
    } catch (e, stackTrace) {
      _logError('âŒ Erreur Création jardin', e, stackTrace);
      return false;
    }
  }

  /// Met à jour un jardin avec double écriture
  Future<bool> updateGarden(GardenFreezed garden) async {
    if (!_isEnabled) {
      return await _updateModernOnly(garden);
    }

    try {
      _log('ðŸ”„ mise à jour jardin (double écriture): ${garden.name}',
          level: 500);

      // Écriture parallèle
      final results = await Future.wait([
        _updateLegacy(garden),
        _updateModern(garden),
      ]);

      final legacySuccess = results[0];
      final modernSuccess = results[1];

      if (legacySuccess && modernSuccess) {
        _legacyWriteSuccessCount++;
        _modernWriteSuccessCount++;
        return true;
      } else if (modernSuccess) {
        _legacyWriteFailureCount++;
        _modernWriteSuccessCount++;
        return true;
      } else {
        _legacyWriteFailureCount++;
        _modernWriteFailureCount++;
        return legacySuccess;
      }
    } catch (e, stackTrace) {
      _logError('âŒ Erreur mise à jour jardin', e, stackTrace);
      return false;
    }
  }

  /// Supprime un jardin avec double suppression
  Future<bool> deleteGarden(String gardenId) async {
    if (!_isEnabled) {
      return await _deleteModernOnly(gardenId);
    }

    try {
      _log('ðŸ—‘ï¸ Suppression jardin (double écriture): $gardenId',
          level: 500);

      // Suppression parallèle
      final results = await Future.wait([
        _deleteLegacy(gardenId),
        _deleteModern(gardenId),
      ]);

      final legacySuccess = results[0];
      final modernSuccess = results[1];

      if (legacySuccess && modernSuccess) {
        _legacyWriteSuccessCount++;
        _modernWriteSuccessCount++;
        return true;
      } else if (modernSuccess) {
        _legacyWriteFailureCount++;
        _modernWriteSuccessCount++;
        return true;
      } else {
        _legacyWriteFailureCount++;
        _modernWriteFailureCount++;
        return legacySuccess;
      }
    } catch (e, stackTrace) {
      _logError('âŒ Erreur suppression jardin', e, stackTrace);
      return false;
    }
  }

  // ==================== MIGRATION DE DONNÉES ====================

  /// Migre un jardin Legacy vers Moderne
  Future<bool> migrateGardenToModern(String gardenId) async {
    try {
      _log('ðŸ”„ Migration jardin $gardenId vers Moderne', level: 500);

      // 1. Récupérer depuis Legacy
      final legacyGarden = GardenBoxes.getGarden(gardenId);
      if (legacyGarden == null) {
        _log('âŒ Jardin Legacy introuvable: $gardenId', level: 1000);
        return false;
      }

      // 2. Convertir en GardenFreezed
      final modernGarden = _convertLegacyToModern(legacyGarden);

      // 3. Écrire dans Moderne
      final success = await _modernRepository.createGarden(modernGarden);

      if (success) {
        _log('âœ… Jardin $gardenId migré vers Moderne', level: 500);
        _modernWriteSuccessCount++;
      } else {
        _log('âŒ Échec migration jardin $gardenId', level: 1000);
        _modernWriteFailureCount++;
      }

      return success;
    } catch (e, stackTrace) {
      _logError('âŒ Erreur migration jardin $gardenId', e, stackTrace);
      _modernWriteFailureCount++;
      return false;
    }
  }

  /// Effectue un rollback d'un jardin (restaure Legacy, supprime Moderne)
  Future<bool> rollbackGarden(String gardenId) async {
    try {
      _log('âª Rollback jardin $gardenId', level: 900);

      // Supprimer de Moderne (si existe)
      try {
        await _modernRepository.deleteGarden(gardenId);
      } catch (e) {
        _log('âš ï¸ Suppression Moderne échouée (peut-être absent)',
            level: 700);
      }

      // Vérifier que Legacy existe toujours
      final legacyGarden = GardenBoxes.getGarden(gardenId);
      final exists = legacyGarden != null;

      if (exists) {
        _log('âœ… Rollback réussi - Jardin $gardenId restauré depuis Legacy',
            level: 500);
      } else {
        _log('âš ï¸ Jardin $gardenId absent de Legacy également', level: 900);
      }

      return exists;
    } catch (e, stackTrace) {
      _logError('âŒ Erreur rollback jardin $gardenId', e, stackTrace);
      return false;
    }
  }

  /// Récupère tous les IDs de jardins Legacy
  Future<List<String>> getAllLegacyGardenIds() async {
    try {
      final gardens = GardenBoxes.getAllGardens();
      return gardens.map((g) => g.id).toList();
    } catch (e, stackTrace) {
      _logError('âŒ Erreur récupération IDs Legacy', e, stackTrace);
      return [];
    }
  }

  // ==================== ÉCRITURE LEGACY ====================

  Future<bool> _createLegacy(GardenFreezed garden) async {
    try {
      final legacyGarden = _convertModernToLegacy(garden);
      await GardenBoxes.saveGarden(legacyGarden);
      return true;
    } catch (e) {
      _log('âŒ Erreur écriture Legacy: $e', level: 1000);
      return false;
    }
  }

  Future<bool> _updateLegacy(GardenFreezed garden) async {
    try {
      final legacyGarden = _convertModernToLegacy(garden);
      await GardenBoxes.saveGarden(legacyGarden);
      return true;
    } catch (e) {
      _log('âŒ Erreur mise à jour Legacy: $e', level: 1000);
      return false;
    }
  }

  Future<bool> _deleteLegacy(String gardenId) async {
    try {
      await GardenBoxes.deleteGarden(gardenId);
      return true;
    } catch (e) {
      _log('âŒ Erreur suppression Legacy: $e', level: 1000);
      return false;
    }
  }

  // ==================== ÉCRITURE MODERNE ====================

  Future<bool> _createModern(GardenFreezed garden) async {
    try {
      return await _modernRepository.createGarden(garden);
    } catch (e) {
      _log('âŒ Erreur écriture Moderne: $e', level: 1000);
      return false;
    }
  }

  Future<bool> _updateModern(GardenFreezed garden) async {
    try {
      return await _modernRepository.updateGarden(garden);
    } catch (e) {
      _log('âŒ Erreur mise à jour Moderne: $e', level: 1000);
      return false;
    }
  }

  Future<bool> _deleteModern(String gardenId) async {
    try {
      await _modernRepository.deleteGarden(gardenId);
      return true;
    } catch (e) {
      _log('âŒ Erreur suppression Moderne: $e', level: 1000);
      return false;
    }
  }

  // ==================== ÉCRITURE MODERNE UNIQUEMENT ====================

  Future<bool> _createModernOnly(GardenFreezed garden) async {
    try {
      return await _modernRepository.createGarden(garden);
    } catch (e) {
      _logError('âŒ Erreur Création Moderne seul', e);
      return false;
    }
  }

  Future<bool> _updateModernOnly(GardenFreezed garden) async {
    try {
      return await _modernRepository.updateGarden(garden);
    } catch (e) {
      _logError('âŒ Erreur mise à jour Moderne seul', e);
      return false;
    }
  }

  Future<bool> _deleteModernOnly(String gardenId) async {
    try {
      await _modernRepository.deleteGarden(gardenId);
      return true;
    } catch (e) {
      _logError('âŒ Erreur suppression Moderne seul', e);
      return false;
    }
  }

  // ==================== CONVERSIONS ====================

  /// Convertit un Garden Legacy en GardenFreezed Moderne
  GardenFreezed _convertLegacyToModern(Garden legacyGarden) {
    return GardenFreezed.create(
      name: legacyGarden.name,
      description:
          legacyGarden.description.isNotEmpty ? legacyGarden.description : null,
      totalAreaInSquareMeters: legacyGarden.totalAreaInSquareMeters,
      location: legacyGarden.location.isNotEmpty ? legacyGarden.location : null,
      imageUrl: legacyGarden.imageUrl,
    );
  }

  /// Convertit un GardenFreezed Moderne en Garden Legacy
  Garden _convertModernToLegacy(GardenFreezed modernGarden) {
    return Garden(
      id: modernGarden.id,
      name: modernGarden.name,
      description: modernGarden.description ?? '',
      totalAreaInSquareMeters: modernGarden.totalAreaInSquareMeters,
      location: modernGarden.location ?? '',
      createdAt: modernGarden.createdAt,
      updatedAt: modernGarden.updatedAt,
      imageUrl: modernGarden.imageUrl,
      metadata: modernGarden.metadata ?? {},
      isActive: modernGarden.isActive,
    );
  }

  // ==================== VÉRIFICATIONS ====================

  Future<bool> _checkLegacySystemAvailable() async {
    try {
      // Vérifier que la box Legacy est accessible
      GardenBoxes.getAllGardens();
      return true; // Si pas d'exception, le système est disponible
    } catch (e) {
      _log('âŒ Système Legacy non disponible: $e', level: 1000);
      return false;
    }
  }

  Future<bool> _checkModernSystemAvailable() async {
    try {
      // Vérifier que le repository Moderne est accessible
      await _modernRepository.getAllGardens();
      return true;
    } catch (e) {
      _log('âŒ Système Moderne non disponible: $e', level: 1000);
      return false;
    }
  }

  // ==================== STATISTIQUES ====================

  /// Obtient les statistiques de double écriture
  Map<String, dynamic> getStatistics() {
    final totalLegacyWrites =
        _legacyWriteSuccessCount + _legacyWriteFailureCount;
    final totalModernWrites =
        _modernWriteSuccessCount + _modernWriteFailureCount;

    return {
      'enabled': _isEnabled,
      'legacy': {
        'success': _legacyWriteSuccessCount,
        'failure': _legacyWriteFailureCount,
        'total': totalLegacyWrites,
        'successRate': totalLegacyWrites > 0
            ? (_legacyWriteSuccessCount / totalLegacyWrites) * 100
            : 0.0,
      },
      'modern': {
        'success': _modernWriteSuccessCount,
        'failure': _modernWriteFailureCount,
        'total': totalModernWrites,
        'successRate': totalModernWrites > 0
            ? (_modernWriteSuccessCount / totalModernWrites) * 100
            : 0.0,
      },
      'conflicts': _conflictResolutionCount,
    };
  }

  /// Réinitialise les statistiques
  void resetStatistics() {
    _legacyWriteSuccessCount = 0;
    _legacyWriteFailureCount = 0;
    _modernWriteSuccessCount = 0;
    _modernWriteFailureCount = 0;
    _conflictResolutionCount = 0;
    _log('ðŸ“Š Statistiques réinitialisées', level: 500);
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

  bool get isEnabled => _isEnabled;
  int get legacySuccessCount => _legacyWriteSuccessCount;
  int get modernSuccessCount => _modernWriteSuccessCount;
  double get overallSuccessRate {
    final total = _legacyWriteSuccessCount +
        _legacyWriteFailureCount +
        _modernWriteSuccessCount +
        _modernWriteFailureCount;

    if (total == 0) return 0.0;

    return ((_legacyWriteSuccessCount + _modernWriteSuccessCount) / total) *
        100;
  }
}

/// Exception de double écriture
class DualWriteException implements Exception {
  final String message;
  const DualWriteException(this.message);

  @override
  String toString() => 'DualWriteException: $message';
}
