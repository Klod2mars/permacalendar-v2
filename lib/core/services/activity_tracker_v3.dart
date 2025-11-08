import 'dart:async';
import 'dart:developer' as developer;

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/activity_v3.dart';
import 'aggregation/garden_aggregation_hub.dart';

/// ActivityTrackerV3
/// ------------------
/// Service central d’agrégation d’activités dans PermaCalendar.
/// - Enregistre les activités jardin/plante.
/// - Fournit un historique structuré pour les vues UI.
/// - Compatible Riverpod 3 et auto-disposé.
/// - Sécurisé (try/catch sur Hive et async).
/// - Intégré au GardenAggregationHub.
typedef ActivityTrackerErrorLogger = void Function(
  String message, {
  Object? error,
  StackTrace? stackTrace,
  Map<String, dynamic>? context,
});

/// Service de tracking des activités V3 - Version propre et optimisée
class ActivityTrackerV3 {
  ActivityTrackerV3({
    GardenAggregationHub? hub,
    HiveInterface? hive,
    Uuid? uuid,
    Duration? duplicateThreshold,
    int? maxActivities,
    int? cleanupThreshold,
    ActivityTrackerErrorLogger? errorLogger,
  })  : _hub = hub,
        _hive = hive ?? Hive,
        _uuid = uuid ?? const Uuid(),
        _duplicateThreshold = duplicateThreshold ?? _defaultDuplicateThreshold,
        _maxActivities = maxActivities ?? _defaultMaxActivities,
        _cleanupThreshold = cleanupThreshold ?? _defaultCleanupThreshold,
        _errorLogger = errorLogger;

  // Configuration
  static const String _boxName = 'activities_v3';
  static const Duration _defaultDuplicateThreshold = Duration(minutes: 5);
  static const int _defaultMaxActivities = 500; // Limite raisonnable
  static const int _defaultCleanupThreshold = 1000; // Seuil de nettoyage

  final GardenAggregationHub? _hub;
  final HiveInterface _hive;
  final Uuid _uuid;
  final Duration _duplicateThreshold;
  final int _maxActivities;
  final int _cleanupThreshold;
  final ActivityTrackerErrorLogger? _errorLogger;

  // État interne
  Box<ActivityV3>? _box;
  bool _isInitialized = false;
  final Map<String, DateTime> _lastActivityCache = {};

  // Getters
  bool get isInitialized => _isInitialized;
  int get activityCount => _box?.length ?? 0;

  /// Initialise le service (appelé une seule fois)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print('ActivityTrackerV3: Ouverture de la box Hive...');
      _box = await _hive.openBox<ActivityV3>(_boxName);
      _isInitialized = true;
      print('✅ ActivityTrackerV3 initialisé avec succès');

      // Nettoyage initial si nécessaire
      await _performCleanupIfNeeded();

      developer.log(
        'ActivityTrackerV3 initialisé avec succès',
        name: 'ActivityTrackerV3',
        level: 800, // Info level
      );
    } catch (e, stackTrace) {
      print('❌ Erreur initialisation ActivityTrackerV3: $e');
      _logError(
        'Erreur lors de l\'initialisation d\'ActivityTrackerV3: $e',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// S'assure que le service est initialisé avant utilisation.
  Future<void> ensureInitialized() async {
    await initialize();
  }

  /// Enregistre une activité avec déduplication intelligente
  Future<void> trackActivity({
    required String type,
    required String description,
    Map<String, dynamic>? metadata,
    ActivityPriority priority = ActivityPriority.normal,
  }) async {
    if (!_isInitialized || _box == null) {
      developer.log(
        'ActivityTrackerV3 non initialisé, activité ignorée: $type',
        name: 'ActivityTrackerV3',
        level: 900, // Warning level
      );
      return;
    }

    try {
      final activity = ActivityV3(
        id: _uuid.v4(),
        type: type,
        description: description,
        timestamp: DateTime.now(),
        metadata: metadata,
        priority: priority.value,
      );

      final activityKey = _generateActivityKey(type, description, metadata);
      await recordActivity(activity, activityKeyOverride: activityKey);
    } catch (e, stackTrace) {
      _logError(
        'Erreur lors de l\'enregistrement de l\'activité: $e',
        error: e,
        stackTrace: stackTrace,
        context: {
          'type': type,
          'description': description,
        },
      );
      // Ne pas rethrow pour éviter de casser l'application
    }
  }

  /// Enregistre directement une activité existante
  Future<void> recordActivity(
    ActivityV3 activity, {
    String? activityKeyOverride,
  }) async {
    if (!_isInitialized || _box == null) {
      developer.log(
        'ActivityTrackerV3 non initialisé, activité ignorée (recordActivity): ${activity.type}',
        name: 'ActivityTrackerV3',
        level: 900, // Warning level
      );
      return;
    }

    try {
      final activityKey = activityKeyOverride ??
          _generateActivityKey(
            activity.type,
            activity.description,
            activity.metadata,
          );

      if (_isDuplicateActivity(activityKey)) {
        developer.log(
          'Activité dupliquée ignorée (recordActivity): ${activity.type} - ${activity.description}',
          name: 'ActivityTrackerV3',
          level: 700, // Debug level
        );
        return;
      }

      await _box!.put(activity.id, activity);
      _lastActivityCache[activityKey] = activity.timestamp;

      await _performCleanupIfNeeded();
      _notifyAggregationLayer(activity);

      developer.log(
        'Activité enregistrée via recordActivity: ${activity.type} - ${activity.description}',
        name: 'ActivityTrackerV3',
        level: 700, // Debug level
      );
    } catch (e, stackTrace) {
      _logError(
        'Erreur lors de l\'enregistrement direct de l\'activité: $e',
        error: e,
        stackTrace: stackTrace,
        context: {
          'activityId': activity.id,
          'type': activity.type,
        },
      );
    }
  }

  /// Récupère les activités récentes
  Future<List<ActivityV3>> getRecentActivities({
    int limit = 10,
    ActivityPriority? minPriority,
  }) async {
    if (!_isInitialized || _box == null) {
      return [];
    }

    try {
      final allActivities =
          _box!.values.where((activity) => activity.isActive).toList();

      // Filtrer par priorité si spécifiée
      final filteredActivities = minPriority != null
          ? allActivities
              .where((activity) => activity.priority >= minPriority.value)
              .toList()
          : allActivities;

      // Trier par timestamp (plus récent en premier)
      filteredActivities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Limiter le nombre de résultats
      return filteredActivities.take(limit).toList();
    } catch (e) {
      developer.log(
        'Erreur lors de la récupération des activités: $e',
        name: 'ActivityTrackerV3',
        level: 1000, // Error level
      );
      return [];
    }
  }

  /// Récupère les activités par type
  Future<List<ActivityV3>> getActivitiesByType(String type) async {
    if (!_isInitialized || _box == null) {
      return [];
    }

    try {
      return _box!.values
          .where((activity) => activity.isActive && activity.type == type)
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      developer.log(
        'Erreur lors de la récupération des activités par type: $e',
        name: 'ActivityTrackerV3',
        level: 1000, // Error level
      );
      return [];
    }
  }

  /// Marque une activité comme inactive (soft delete)
  Future<void> deactivateActivity(String activityId) async {
    if (!_isInitialized || _box == null) return;

    try {
      final activity = _box!.get(activityId);
      if (activity != null) {
        final updatedActivity = activity.copyWith(isActive: false);
        await _box!.put(activityId, updatedActivity);
      }
    } catch (e) {
      developer.log(
        'Erreur lors de la désactivation de l\'activité: $e',
        name: 'ActivityTrackerV3',
        level: 1000, // Error level
      );
    }
  }

  /// Nettoie les anciennes activités inactives
  Future<void> cleanupOldActivities({int daysOld = 30}) async {
    if (!_isInitialized || _box == null) return;

    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      final activitiesToDelete = _box!.values
          .where((activity) =>
              !activity.isActive && activity.timestamp.isBefore(cutoffDate))
          .map((activity) => activity.id)
          .toList();

      for (final id in activitiesToDelete) {
        await _box!.delete(id);
      }

      if (activitiesToDelete.isNotEmpty) {
        developer.log(
          '${activitiesToDelete.length} anciennes activités supprimées',
          name: 'ActivityTrackerV3',
          level: 800, // Info level
        );
      }
    } catch (e) {
      developer.log(
        'Erreur lors du nettoyage des activités: $e',
        name: 'ActivityTrackerV3',
        level: 1000, // Error level
      );
    }
  }

  /// Vide toutes les activités (pour les tests)
  Future<void> clearAllActivities() async {
    if (!_isInitialized || _box == null) return;

    try {
      await _box!.clear();
      _lastActivityCache.clear();

      developer.log(
        'Toutes les activités ont été supprimées',
        name: 'ActivityTrackerV3',
        level: 800, // Info level
      );
    } catch (e) {
      developer.log(
        'Erreur lors de la suppression de toutes les activités: $e',
        name: 'ActivityTrackerV3',
        level: 1000, // Error level
      );
    }
  }

  /// Ferme le service
  Future<void> close() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
    }
    _isInitialized = false;
    _lastActivityCache.clear();
  }

  // Méthodes privées

  /// Génère une clé unique pour une activité
  String _generateActivityKey(
      String type, String description, Map<String, dynamic>? metadata) {
    final metadataString =
        metadata?.entries.map((e) => '${e.key}:${e.value}').join(',') ?? '';
    return '$type|$description|$metadataString';
  }

  /// Vérifie si une activité est un doublon
  bool _isDuplicateActivity(String key) {
    final lastTime = _lastActivityCache[key];
    if (lastTime == null) return false;

    return DateTime.now().difference(lastTime) < _duplicateThreshold;
  }

  /// Effectue un nettoyage si nécessaire
  Future<void> _performCleanupIfNeeded() async {
    if (_box == null) return;

    final count = _box!.length;
    if (count > _cleanupThreshold) {
      // Garder seulement les activités les plus récentes
      final allActivities = _box!.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Supprimer les activités les plus anciennes
      final activitiesToDelete = allActivities.skip(_maxActivities).toList();
      for (final activity in activitiesToDelete) {
        await _box!.delete(activity.id);
      }

      developer.log(
        'Nettoyage automatique: ${activitiesToDelete.length} activités supprimées',
        name: 'ActivityTrackerV3',
        level: 800, // Info level
      );
    }
  }

  void _notifyAggregationLayer(ActivityV3 activity) {
    final hub = _hub;
    if (hub == null) return;

    try {
      final metadata = activity.metadata ?? {};
      final possibleGardenIds = <String?>[
        metadata['gardenId'] as String?,
        metadata['garden_id'] as String?,
        metadata['gardenID'] as String?,
        if (metadata['garden'] is Map<String, dynamic>)
          (metadata['garden'] as Map<String, dynamic>)['id'] as String?,
      ];

      final gardenId = possibleGardenIds.firstWhere(
        (value) => value != null && value.isNotEmpty,
        orElse: () => null,
      );

      if (gardenId == null) {
        return;
      }

      hub.invalidateCache(gardenId);
      hub.invalidateGardenIntelligenceCache(gardenId);
    } catch (e, stackTrace) {
      _logError(
        'Erreur lors de la notification du GardenAggregationHub: $e',
        error: e,
        stackTrace: stackTrace,
        context: {
          'activityId': activity.id,
          'type': activity.type,
        },
      );
    }
  }

  void _logError(
    String message, {
    required Object error,
    required StackTrace stackTrace,
    Map<String, dynamic>? context,
  }) {
    try {
      _errorLogger?.call(
        message,
        error: error,
        stackTrace: stackTrace,
        context: context,
      );
    } catch (_) {
      // Ignorer les erreurs provenant du logger externe
    }

    developer.log(
      message,
      name: 'ActivityTrackerV3',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
