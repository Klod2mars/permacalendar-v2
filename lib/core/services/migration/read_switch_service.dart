import 'dart:developer' as developer;
import '../../models/garden.dart';
import '../../models/garden_freezed.dart';
import '../../data/hive/garden_boxes.dart';
import '../../repositories/garden_hive_repository.dart';

/// Read Switch Service - Service de Basculement de Lecture
///
/// **Architecture Enterprise - Design Pattern: Strategy + Proxy**
///
/// Ce service gère le basculement intelligent des lectures entre
/// les systèmes Legacy et Moderne pendant la migration :
/// - Lecture depuis Legacy par défaut (safe)
/// - Basculement progressif vers Moderne (après validation)
/// - Fallback automatique en cas d'erreur
/// - Monitoring de la performance
///
/// **Stratégie de Basculement :**
/// 1. **Phase initiale** : Lecture 100% Legacy
/// 2. **Phase transition** : Lecture graduelle Moderne (10% → 50% → 90%)
/// 3. **Phase finale** : Lecture 100% Moderne
/// 4. **Fallback** : Retour automatique Legacy si erreurs
///
/// **Standards :**
/// - Clean Architecture (abstraction)
/// - SOLID (Open/Closed)
/// - Performance (cache intelligent)
class ReadSwitchService {
  static const String _logName = 'ReadSwitchService';

  // État du service
  ReadSource _currentReadSource = ReadSource.legacy;

  // Repositories
  final GardenHiveRepository _modernRepository = GardenHiveRepository();

  // Stratégie de basculement graduel
  GradualSwitchStrategy _switchStrategy = GradualSwitchStrategy.off;
  int _modernReadPercentage = 0; // 0-100

  // Statistiques
  int _legacyReadCount = 0;
  int _modernReadCount = 0;
  int _fallbackCount = 0;
  int _errorCount = 0;

  /// Constructeur
  ReadSwitchService() {
    _log('🏗️ Read Switch Service créé', level: 500);
  }

  // ==================== BASCULEMENT ====================

  /// Bascule les lectures vers le système Moderne
  Future<void> switchToModernReads() async {
    try {
      _log('🔀 Basculement vers lectures Moderne', level: 500);

      // Vérifier la disponibilité du système Moderne
      final available = await _checkModernSystemAvailable();
      if (!available) {
        throw const ReadSwitchException('Système Moderne non disponible');
      }

      _currentReadSource = ReadSource.modern;
      _modernReadPercentage = 100;
      _switchStrategy = GradualSwitchStrategy.off;

      _log('✅ Lectures basculées vers Moderne (100%)', level: 500);
    } catch (e, stackTrace) {
      _logError('❌ Erreur basculement vers Moderne', e, stackTrace);
      rethrow;
    }
  }

  /// Bascule les lectures vers le système Legacy
  Future<void> switchToLegacyReads() async {
    try {
      _log('⏪ Basculement vers lectures Legacy', level: 900);

      _currentReadSource = ReadSource.legacy;
      _modernReadPercentage = 0;
      _switchStrategy = GradualSwitchStrategy.off;

      _log('✅ Lectures basculées vers Legacy (100%)', level: 500);
    } catch (e, stackTrace) {
      _logError('❌ Erreur basculement vers Legacy', e, stackTrace);
      rethrow;
    }
  }

  /// Active le basculement graduel (10% → 50% → 90% → 100%)
  Future<void> enableGradualSwitch({
    GradualSwitchStrategy strategy = GradualSwitchStrategy.conservative,
  }) async {
    try {
      _log('🔄 Activation basculement graduel ($strategy)', level: 500);

      _switchStrategy = strategy;
      _modernReadPercentage = _getInitialPercentage(strategy);

      _log(
        '✅ Basculement graduel activé - Moderne: $_modernReadPercentage%',
        level: 500,
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur activation basculement graduel', e, stackTrace);
      rethrow;
    }
  }

  /// Augmente progressivement le pourcentage de lectures Moderne
  Future<bool> increaseModernReadPercentage() async {
    try {
      final oldPercentage = _modernReadPercentage;

      // Augmentation selon la stratégie
      switch (_switchStrategy) {
        case GradualSwitchStrategy.off:
          return false; // Pas de stratégie graduelle

        case GradualSwitchStrategy.conservative:
          _modernReadPercentage = _increaseConservative(_modernReadPercentage);
          break;

        case GradualSwitchStrategy.moderate:
          _modernReadPercentage = _increaseModerate(_modernReadPercentage);
          break;

        case GradualSwitchStrategy.aggressive:
          _modernReadPercentage = _increaseAggressive(_modernReadPercentage);
          break;
      }

      _log(
        '📈 Pourcentage Moderne: $oldPercentage% → $_modernReadPercentage%',
        level: 500,
      );

      // Si on atteint 100%, basculer complètement
      if (_modernReadPercentage >= 100) {
        _currentReadSource = ReadSource.modern;
        _switchStrategy = GradualSwitchStrategy.off;
        _log('✅ Basculement graduel terminé - 100% Moderne', level: 500);
      }

      return true;
    } catch (e, stackTrace) {
      _logError('❌ Erreur augmentation pourcentage', e, stackTrace);
      return false;
    }
  }

  // ==================== OPÉRATIONS DE LECTURE ====================

  /// Récupère tous les jardins depuis la source appropriée
  Future<List<GardenFreezed>> getAllGardens() async {
    try {
      // Déterminer la source de lecture
      final source = _determineReadSource();

      if (source == ReadSource.modern) {
        _modernReadCount++;
        return await _readFromModern();
      } else {
        _legacyReadCount++;
        return await _readFromLegacyAsFreezed();
      }
    } catch (e, stackTrace) {
      _errorCount++;
      _logError('❌ Erreur lecture jardins', e, stackTrace);

      // Fallback automatique
      return await _fallbackRead();
    }
  }

  /// Récupère un jardin par ID depuis la source appropriée
  Future<GardenFreezed?> getGardenById(String gardenId) async {
    try {
      final source = _determineReadSource();

      if (source == ReadSource.modern) {
        _modernReadCount++;
        return await _modernRepository.getGardenById(gardenId);
      } else {
        _legacyReadCount++;
        final legacyGarden = GardenBoxes.getGarden(gardenId);
        return legacyGarden != null
            ? _convertLegacyToFreezed(legacyGarden)
            : null;
      }
    } catch (e, stackTrace) {
      _errorCount++;
      _logError('❌ Erreur lecture jardin $gardenId', e, stackTrace);

      // Fallback
      return await _fallbackReadById(gardenId);
    }
  }

  // ==================== LOGIQUE DE BASCULEMENT ====================

  /// Détermine la source de lecture selon la stratégie
  ReadSource _determineReadSource() {
    // Si basculement complet
    if (_currentReadSource == ReadSource.modern &&
        _modernReadPercentage >= 100) {
      return ReadSource.modern;
    }

    if (_currentReadSource == ReadSource.legacy && _modernReadPercentage == 0) {
      return ReadSource.legacy;
    }

    // Si basculement graduel
    if (_switchStrategy != GradualSwitchStrategy.off) {
      // Générer un nombre aléatoire entre 0 et 100
      final random = DateTime.now().microsecond % 100;

      // Si le nombre est inférieur au pourcentage Moderne, lire depuis Moderne
      if (random < _modernReadPercentage) {
        return ReadSource.modern;
      }
    }

    return ReadSource.legacy;
  }

  /// Lecture depuis Moderne
  Future<List<GardenFreezed>> _readFromModern() async {
    try {
      return await _modernRepository.getAllGardens();
    } catch (e) {
      _log('❌ Erreur lecture Moderne, fallback Legacy', level: 900);
      _fallbackCount++;
      return await _readFromLegacyAsFreezed();
    }
  }

  /// Lecture depuis Legacy avec conversion en Freezed
  Future<List<GardenFreezed>> _readFromLegacyAsFreezed() async {
    try {
      final legacyGardens = GardenBoxes.getAllGardens();
      return legacyGardens.map((g) => _convertLegacyToFreezed(g)).toList();
    } catch (e) {
      _log('❌ Erreur lecture Legacy', level: 1000);
      rethrow;
    }
  }

  /// Fallback en cas d'erreur
  Future<List<GardenFreezed>> _fallbackRead() async {
    _fallbackCount++;

    try {
      // Essayer Legacy en premier
      return await _readFromLegacyAsFreezed();
    } catch (e) {
      try {
        // Essayer Moderne en dernier recours
        return await _modernRepository.getAllGardens();
      } catch (e2) {
        _log('❌ Fallback complet échoué', level: 1000);
        return []; // Retour liste vide en dernier recours
      }
    }
  }

  /// Fallback pour lecture par ID
  Future<GardenFreezed?> _fallbackReadById(String gardenId) async {
    _fallbackCount++;

    try {
      // Essayer Legacy
      final legacyGarden = GardenBoxes.getGarden(gardenId);
      if (legacyGarden != null) {
        return _convertLegacyToFreezed(legacyGarden);
      }

      // Essayer Moderne
      return await _modernRepository.getGardenById(gardenId);
    } catch (e) {
      _log('❌ Fallback lecture $gardenId échoué', level: 1000);
      return null;
    }
  }

  // ==================== AUGMENTATION PROGRESSIVE ====================

  int _increaseConservative(int currentPercentage) {
    // Augmentation : 0 → 10 → 25 → 50 → 75 → 90 → 100
    if (currentPercentage == 0) return 10;
    if (currentPercentage == 10) return 25;
    if (currentPercentage == 25) return 50;
    if (currentPercentage == 50) return 75;
    if (currentPercentage == 75) return 90;
    if (currentPercentage == 90) return 100;
    return 100;
  }

  int _increaseModerate(int currentPercentage) {
    // Augmentation : 0 → 20 → 50 → 80 → 100
    if (currentPercentage == 0) return 20;
    if (currentPercentage == 20) return 50;
    if (currentPercentage == 50) return 80;
    if (currentPercentage == 80) return 100;
    return 100;
  }

  int _increaseAggressive(int currentPercentage) {
    // Augmentation : 0 → 50 → 100
    if (currentPercentage == 0) return 50;
    if (currentPercentage == 50) return 100;
    return 100;
  }

  int _getInitialPercentage(GradualSwitchStrategy strategy) {
    switch (strategy) {
      case GradualSwitchStrategy.off:
        return 0;
      case GradualSwitchStrategy.conservative:
        return 10;
      case GradualSwitchStrategy.moderate:
        return 20;
      case GradualSwitchStrategy.aggressive:
        return 50;
    }
  }

  // ==================== CONVERSIONS ====================

  GardenFreezed _convertLegacyToFreezed(Garden legacyGarden) {
    return GardenFreezed.create(
      name: legacyGarden.name,
      description:
          legacyGarden.description.isNotEmpty ? legacyGarden.description : null,
      totalAreaInSquareMeters: legacyGarden.totalAreaInSquareMeters,
      location: legacyGarden.location.isNotEmpty ? legacyGarden.location : null,
      imageUrl: legacyGarden.imageUrl,
    );
  }

  // ==================== VÉRIFICATIONS ====================

  Future<bool> _checkModernSystemAvailable() async {
    try {
      await _modernRepository.getAllGardens();
      return true;
    } catch (e) {
      _log('❌ Système Moderne non disponible', level: 1000);
      return false;
    }
  }

  // ==================== STATISTIQUES ====================

  Map<String, dynamic> getStatistics() {
    final totalReads = _legacyReadCount + _modernReadCount;

    return {
      'currentSource': _currentReadSource.toString(),
      'modernPercentage': _modernReadPercentage,
      'strategy': _switchStrategy.toString(),
      'reads': {
        'legacy': _legacyReadCount,
        'modern': _modernReadCount,
        'total': totalReads,
        'modernRate':
            totalReads > 0 ? (_modernReadCount / totalReads) * 100 : 0.0,
      },
      'fallbacks': _fallbackCount,
      'errors': _errorCount,
    };
  }

  void resetStatistics() {
    _legacyReadCount = 0;
    _modernReadCount = 0;
    _fallbackCount = 0;
    _errorCount = 0;
    _log('📊 Statistiques réinitialisées', level: 500);
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

  bool get isReadingFromModern => _currentReadSource == ReadSource.modern;
  bool get isReadingFromLegacy => _currentReadSource == ReadSource.legacy;
  int get modernReadPercentage => _modernReadPercentage;
  GradualSwitchStrategy get switchStrategy => _switchStrategy;
  ReadSource get currentReadSource => _currentReadSource;
}

/// Source de lecture
enum ReadSource {
  legacy,
  modern,
  hybrid,
}

/// Stratégie de basculement graduel
enum GradualSwitchStrategy {
  off, // Pas de basculement graduel
  conservative, // 0 → 10 → 25 → 50 → 75 → 90 → 100
  moderate, // 0 → 20 → 50 → 80 → 100
  aggressive, // 0 → 50 → 100
}

/// Exception de basculement de lecture
class ReadSwitchException implements Exception {
  final String message;
  const ReadSwitchException(this.message);

  @override
  String toString() => 'ReadSwitchException: $message';
}


