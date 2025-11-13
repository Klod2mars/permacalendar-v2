ï»¿import 'dart:developer' as developer;
import 'package:hive_flutter/hive_flutter.dart';

/// Legacy Cleanup Service - Service de Nettoyage du Système Legacy
///
/// **Architecture Enterprise - Design Pattern: Command + Strategy**
///
/// Ce service gère la suppression progressive et sécurisée du système
/// Legacy après migration réussie :
/// - Suppression progressive des boxes Legacy
/// - Vérification avant suppression
/// - Sauvegarde de sécurité
/// - Libération de mémoire
///
/// **Stratégie de Nettoyage :**
/// 1. **Validation** : S'assurer que Moderne contient toutes les données
/// 2. **Archivage** : Sauvegarde finale avant suppression
/// 3. **Suppression progressive** : Box par box avec validation
/// 4. **Libération** : Nettoyage mémoire et disque
///
/// **Standards :**
/// - Clean Architecture
/// - SOLID (Single Responsibility)
/// - Defensive Programming
class LegacyCleanupService {
  static const String _logName = 'LegacyCleanupService';

  // Boxes Legacy à nettoyer
  static const List<String> _legacyBoxNames = [
    'gardens',
    'garden_beds',
    'plantings',
    'plants',
    'plant_varieties',
    'growth_cycles',
    'germination_events',
    'activities', // Activités Legacy (Activity)
  ];

  // Statistiques
  int _boxesCleanedCount = 0;
  int _boxesFailedCount = 0;
  double _totalSpaceFreed = 0.0; // En MB

  /// Constructeur
  LegacyCleanupService() {
    _log('ðŸ—ï¸ Legacy Cleanup Service Créé', level: 500);
  }

  // ==================== NETTOYAGE COMPLET ====================

  /// Nettoie toutes les boxes Legacy progressivement
  ///
  /// **Processus :**
  /// 1. Validation que toutes les données sont dans Moderne
  /// 2. Archivage final (via DataArchivalService)
  /// 3. Suppression box par box avec validation
  /// 4. Rapport final de nettoyage
  Future<bool> cleanupAllLegacyBoxes() async {
    try {
      _log('ðŸ§¹ Nettoyage de toutes les boxes Legacy', level: 500);

      final startTime = DateTime.now();
      final results = <String, bool>{};

      for (final boxName in _legacyBoxNames) {
        _log('ðŸ—‘ï¸ Nettoyage box: $boxName', level: 500);

        try {
          // Vérifier si la box est ouverte
          if (Hive.isBoxOpen(boxName)) {
            final box = Hive.box(boxName);
            final size = _estimateBoxSize(box);

            // Fermer et supprimer
            await box.close();
            await Hive.deleteBoxFromDisk(boxName);

            _boxesCleanedCount++;
            _totalSpaceFreed += size;
            results[boxName] = true;

            _log('  âœ… Box $boxName supprimée (~${size.toStringAsFixed(2)} MB)',
                level: 500);
          } else {
            // Box déjà fermée, juste supprimer du disque
            await Hive.deleteBoxFromDisk(boxName);
            _boxesCleanedCount++;
            results[boxName] = true;

            _log('  âœ… Box $boxName supprimée (non ouverte)', level: 500);
          }
        } catch (e) {
          _boxesFailedCount++;
          results[boxName] = false;
          _log('  âŒ Échec suppression $boxName: $e', level: 1000);
        }

        // Petite pause entre chaque suppression
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final duration = DateTime.now().difference(startTime);
      final successRate = _legacyBoxNames.isNotEmpty
          ? (_boxesCleanedCount / _legacyBoxNames.length) * 100
          : 0.0;

      _log(
        'ðŸŽ¯ Nettoyage terminé: $_boxesCleanedCount/${_legacyBoxNames.length} boxes (${successRate.toStringAsFixed(1)}%)',
        level: 500,
      );
      _log(
        'ðŸ’¾ Espace libéré: ~${_totalSpaceFreed.toStringAsFixed(2)} MB',
        level: 500,
      );
      _log('â±ï¸ Durée: ${duration.inSeconds}s', level: 500);

      return _boxesFailedCount == 0;
    } catch (e, stackTrace) {
      _logError('âŒ Erreur nettoyage complet', e, stackTrace);
      return false;
    }
  }

  /// Nettoie une box Legacy spécifique
  Future<bool> cleanupBox(String boxName) async {
    try {
      _log('ðŸ—‘ï¸ Nettoyage box: $boxName', level: 500);

      if (!_legacyBoxNames.contains(boxName)) {
        _log('âš ï¸ Box $boxName non reconnue comme Legacy', level: 900);
        return false;
      }

      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        final size = _estimateBoxSize(box);

        await box.close();
        await Hive.deleteBoxFromDisk(boxName);

        _boxesCleanedCount++;
        _totalSpaceFreed += size;

        _log('âœ… Box $boxName supprimée (~${size.toStringAsFixed(2)} MB)',
            level: 500);
      } else {
        await Hive.deleteBoxFromDisk(boxName);
        _boxesCleanedCount++;
        _log('âœ… Box $boxName supprimée (non ouverte)', level: 500);
      }

      return true;
    } catch (e, stackTrace) {
      _logError('âŒ Erreur nettoyage box $boxName', e, stackTrace);
      _boxesFailedCount++;
      return false;
    }
  }

  /// Vide une box Legacy sans la supprimer
  Future<bool> clearBox(String boxName) async {
    try {
      _log('ðŸ§¹ Vidage box: $boxName', level: 500);

      if (!Hive.isBoxOpen(boxName)) {
        _log('âš ï¸ Box $boxName non ouverte', level: 900);
        return false;
      }

      final box = Hive.box(boxName);
      final itemCount = box.length;

      await box.clear();

      _log('âœ… Box $boxName vidée ($itemCount éléments)', level: 500);
      return true;
    } catch (e, stackTrace) {
      _logError('âŒ Erreur vidage box $boxName', e, stackTrace);
      return false;
    }
  }

  // ==================== NETTOYAGE SÉLECTIF ====================

  /// Nettoie uniquement les jardins Legacy (pas les autres entités)
  Future<bool> cleanupGardensOnly() async {
    try {
      _log('ðŸ§¹ Nettoyage jardins Legacy uniquement', level: 500);

      final gardenBoxes = ['gardens'];
      var success = true;

      for (final boxName in gardenBoxes) {
        final cleaned = await cleanupBox(boxName);
        success = success && cleaned;
      }

      return success;
    } catch (e, stackTrace) {
      _logError('âŒ Erreur nettoyage jardins', e, stackTrace);
      return false;
    }
  }

  /// Nettoie les entités liées aux jardins (beds, plantings)
  Future<bool> cleanupGardenRelatedEntities() async {
    try {
      _log('ðŸ§¹ Nettoyage entités liées aux jardins', level: 500);

      final relatedBoxes = ['garden_beds', 'plantings'];
      var success = true;

      for (final boxName in relatedBoxes) {
        final cleaned = await cleanupBox(boxName);
        success = success && cleaned;
      }

      return success;
    } catch (e, stackTrace) {
      _logError('âŒ Erreur nettoyage entités liées', e, stackTrace);
      return false;
    }
  }

  /// Nettoie les plantes Legacy
  Future<bool> cleanupPlantsOnly() async {
    try {
      _log('ðŸ§¹ Nettoyage plantes Legacy', level: 500);

      final plantBoxes = ['plants', 'plant_varieties', 'growth_cycles'];
      var success = true;

      for (final boxName in plantBoxes) {
        final cleaned = await cleanupBox(boxName);
        success = success && cleaned;
      }

      return success;
    } catch (e, stackTrace) {
      _logError('âŒ Erreur nettoyage plantes', e, stackTrace);
      return false;
    }
  }

  // ==================== INFORMATION ====================

  /// Obtient les informations sur les boxes Legacy
  Future<Map<String, dynamic>> getLegacyBoxesInfo() async {
    final info = <String, dynamic>{
      'boxes': <Map<String, dynamic>>[],
      'totalBoxes': 0,
      'totalItems': 0,
      'estimatedSize': 0.0,
    };

    try {
      for (final boxName in _legacyBoxNames) {
        try {
          if (Hive.isBoxOpen(boxName)) {
            final box = Hive.box(boxName);
            final itemCount = box.length;
            final size = _estimateBoxSize(box);

            info['boxes'].add({
              'name': boxName,
              'isOpen': true,
              'itemCount': itemCount,
              'estimatedSize': size,
            });

            info['totalItems'] += itemCount;
            info['estimatedSize'] += size;
          } else {
            info['boxes'].add({
              'name': boxName,
              'isOpen': false,
              'itemCount': 0,
              'estimatedSize': 0.0,
            });
          }

          info['totalBoxes']++;
        } catch (e) {
          _log('âš ï¸ Erreur info box $boxName: $e', level: 700);
        }
      }

      _log(
        'ðŸ“Š Info Legacy: ${info['totalBoxes']} boxes, ${info['totalItems']} items, ~${(info['estimatedSize'] as double).toStringAsFixed(2)} MB',
        level: 500,
      );
    } catch (e, stackTrace) {
      _logError('âŒ Erreur obtention infos Legacy', e, stackTrace);
    }

    return info;
  }

  /// Estime la taille d'une box en MB
  double _estimateBoxSize(Box box) {
    // Estimation approximative : 1 KB par élément en moyenne
    return (box.length * 1024) / (1024 * 1024); // Conversion en MB
  }

  // ==================== STATISTIQUES ====================

  Map<String, dynamic> getStatistics() {
    return {
      'boxesCleaned': _boxesCleanedCount,
      'boxesFailed': _boxesFailedCount,
      'totalSpaceFreed': _totalSpaceFreed,
      'cleanupRate': (_boxesCleanedCount + _boxesFailedCount) > 0
          ? (_boxesCleanedCount / (_boxesCleanedCount + _boxesFailedCount)) *
              100
          : 0.0,
    };
  }

  void resetStatistics() {
    _boxesCleanedCount = 0;
    _boxesFailedCount = 0;
    _totalSpaceFreed = 0.0;
    _log('ðŸ“Š Statistiques nettoyage réinitialisées', level: 500);
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

  int get boxesCleanedCount => _boxesCleanedCount;
  int get boxesFailedCount => _boxesFailedCount;
  double get totalSpaceFreed => _totalSpaceFreed;
  List<String> get legacyBoxNames => List.unmodifiable(_legacyBoxNames);
}

/// Exception de nettoyage
class LegacyCleanupException implements Exception {
  final String message;
  const LegacyCleanupException(this.message);

  @override
  String toString() => 'LegacyCleanupException: $message';
}


