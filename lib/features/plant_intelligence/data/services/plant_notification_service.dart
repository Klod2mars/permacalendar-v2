import 'dart:async';
import 'dart:developer' as developer;
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/notification_alert.dart';
import '../../domain/entities/plant_condition.dart';
import '../../domain/entities/recommendation.dart' as recommendation_entities;

/// Service de gestion des notifications pour l'intelligence végétale
class PlantNotificationService {
  static const String _boxName = 'plant_notifications';
  static const String _preferencesBoxName = 'notification_preferences';

  Box<NotificationAlert>? _notificationsBox;
  Box<Map>? _preferencesBox;

  final _uuid = const Uuid();
  bool _isInitialized = false;

  // Contrôleurs de stream pour les notifications en temps réel
  final _notificationStreamController =
      StreamController<NotificationAlert>.broadcast();
  final _unreadCountController = StreamController<int>.broadcast();

  /// Stream des nouvelles notifications
  Stream<NotificationAlert> get notificationStream =>
      _notificationStreamController.stream;

  /// Stream du nombre de notifications non lues
  Stream<int> get unreadCountStream => _unreadCountController.stream;

  // Singleton
  static final PlantNotificationService _instance =
      PlantNotificationService._internal();
  factory PlantNotificationService() => _instance;
  PlantNotificationService._internal();

  /// Initialise le service
  Future<void> initialize() async {
    if (_isInitialized) {
      _logDebug('Service déjà initialisé');
      return;
    }

    try {
      _logDebug('Initialisation du service de notifications...');

      // Ouvrir les boxes Hive
      if (!Hive.isBoxOpen(_boxName)) {
        _notificationsBox = await Hive.openBox<NotificationAlert>(_boxName);
      } else {
        _notificationsBox = Hive.box<NotificationAlert>(_boxName);
      }

      if (!Hive.isBoxOpen(_preferencesBoxName)) {
        _preferencesBox = await Hive.openBox<Map>(_preferencesBoxName);
      } else {
        _preferencesBox = Hive.box<Map>(_preferencesBoxName);
      }

      _isInitialized = true;

      // Émettre le nombre initial de notifications non lues
      _updateUnreadCount();

      _logDebug('Service de notifications initialisé avec succès');
    } catch (e, stackTrace) {
      _logError('Erreur lors de l\'initialisation du service', e, stackTrace);
      rethrow;
    }
  }

  /// Assure que le service est initialisé
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // ==================== GESTION DES NOTIFICATIONS ====================

  /// Crée une nouvelle notification
  Future<NotificationAlert> createNotification({
    required String title,
    required String message,
    required NotificationType type,
    required NotificationPriority priority,
    String? plantId,
    String? gardenId,
    String? actionId,
    Map<String, dynamic>? metadata,
  }) async {
    await _ensureInitialized();

    try {
      final notification = NotificationAlert(
        id: _uuid.v4(),
        title: title,
        message: message,
        type: type,
        priority: priority,
        createdAt: DateTime.now(),
        plantId: plantId,
        gardenId: gardenId,
        actionId: actionId,
        metadata: metadata ?? {},
      );

      // Sauvegarder dans Hive
      await _notificationsBox!.put(notification.id, notification);

      // Émettre la notification dans le stream
      _notificationStreamController.add(notification);

      // Mettre à jour le compteur de notifications non lues
      _updateUnreadCount();

      _logDebug('Notification créée: ${notification.title}');

      return notification;
    } catch (e, stackTrace) {
      _logError('Erreur lors de la création de la notification', e, stackTrace);
      rethrow;
    }
  }

  /// Récupère toutes les notifications
  Future<List<NotificationAlert>> getAllNotifications() async {
    await _ensureInitialized();

    try {
      final notifications = _notificationsBox!.values.toList();

      // Trier par date de création (plus récentes en premier)
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return notifications;
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la récupération des notifications', e, stackTrace);
      return [];
    }
  }

  /// Récupère les notifications actives (non archivées, non ignorées)
  Future<List<NotificationAlert>> getActiveNotifications() async {
    await _ensureInitialized();

    try {
      final allNotifications = await getAllNotifications();
      return allNotifications.where((n) => n.isActive).toList();
    } catch (e, stackTrace) {
      _logError('Erreur lors de la récupération des notifications actives', e,
          stackTrace);
      return [];
    }
  }

  /// Récupère les notifications non lues
  Future<List<NotificationAlert>> getUnreadNotifications() async {
    await _ensureInitialized();

    try {
      final allNotifications = await getAllNotifications();
      return allNotifications.where((n) => n.isUnread).toList();
    } catch (e, stackTrace) {
      _logError('Erreur lors de la récupération des notifications non lues', e,
          stackTrace);
      return [];
    }
  }

  /// Récupère les notifications par priorité
  Future<List<NotificationAlert>> getNotificationsByPriority(
    NotificationPriority priority,
  ) async {
    await _ensureInitialized();

    try {
      final allNotifications = await getAllNotifications();
      return allNotifications.where((n) => n.priority == priority).toList();
    } catch (e, stackTrace) {
      _logError('Erreur lors de la récupération des notifications par priorité',
          e, stackTrace);
      return [];
    }
  }

  /// Récupère les notifications par type
  Future<List<NotificationAlert>> getNotificationsByType(
    NotificationType type,
  ) async {
    await _ensureInitialized();

    try {
      final allNotifications = await getAllNotifications();
      return allNotifications.where((n) => n.type == type).toList();
    } catch (e, stackTrace) {
      _logError('Erreur lors de la récupération des notifications par type', e,
          stackTrace);
      return [];
    }
  }

  /// Récupère les notifications pour une plante
  Future<List<NotificationAlert>> getNotificationsForPlant(
      String plantId) async {
    await _ensureInitialized();

    try {
      final allNotifications = await getAllNotifications();
      return allNotifications.where((n) => n.plantId == plantId).toList();
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la récupération des notifications pour la plante',
          e,
          stackTrace);
      return [];
    }
  }

  /// Récupère les notifications pour un jardin
  Future<List<NotificationAlert>> getNotificationsForGarden(
      String gardenId) async {
    await _ensureInitialized();

    try {
      final allNotifications = await getAllNotifications();
      return allNotifications.where((n) => n.gardenId == gardenId).toList();
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la récupération des notifications pour le jardin',
          e,
          stackTrace);
      return [];
    }
  }

  /// Marque une notification comme lue
  Future<void> markAsRead(String notificationId) async {
    await _ensureInitialized();

    try {
      final notification = _notificationsBox!.get(notificationId);
      if (notification != null) {
        final updatedNotification = notification.markAsRead();
        await _notificationsBox!.put(notificationId, updatedNotification);
        _updateUnreadCount();
        _logDebug('Notification marquée comme lue: $notificationId');
      }
    } catch (e, stackTrace) {
      _logError('Erreur lors du marquage de la notification comme lue', e,
          stackTrace);
    }
  }

  /// Marque toutes les notifications comme lues
  Future<void> markAllAsRead() async {
    await _ensureInitialized();

    try {
      final unreadNotifications = await getUnreadNotifications();
      for (final notification in unreadNotifications) {
        await markAsRead(notification.id);
      }
      _logDebug('Toutes les notifications marquées comme lues');
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors du marquage de toutes les notifications comme lues',
          e,
          stackTrace);
    }
  }

  /// Archive une notification
  Future<void> archiveNotification(String notificationId) async {
    await _ensureInitialized();

    try {
      final notification = _notificationsBox!.get(notificationId);
      if (notification != null) {
        final updatedNotification = notification.archive();
        await _notificationsBox!.put(notificationId, updatedNotification);
        _updateUnreadCount();
        _logDebug('Notification archivée: $notificationId');
      }
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de l\'archivage de la notification', e, stackTrace);
    }
  }

  /// Ignore une notification
  Future<void> dismissNotification(String notificationId) async {
    await _ensureInitialized();

    try {
      final notification = _notificationsBox!.get(notificationId);
      if (notification != null) {
        final updatedNotification = notification.dismiss();
        await _notificationsBox!.put(notificationId, updatedNotification);
        _updateUnreadCount();
        _logDebug('Notification ignorée: $notificationId');
      }
    } catch (e, stackTrace) {
      _logError('Erreur lors du rejet de la notification', e, stackTrace);
    }
  }

  /// Supprime une notification
  Future<void> deleteNotification(String notificationId) async {
    await _ensureInitialized();

    try {
      await _notificationsBox!.delete(notificationId);
      _updateUnreadCount();
      _logDebug('Notification supprimée: $notificationId');
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la suppression de la notification', e, stackTrace);
    }
  }

  /// Supprime toutes les notifications archivées
  Future<void> deleteArchivedNotifications() async {
    await _ensureInitialized();

    try {
      final allNotifications = await getAllNotifications();
      final archivedNotifications = allNotifications
          .where((n) => n.status == NotificationStatus.archived)
          .toList();

      for (final notification in archivedNotifications) {
        await deleteNotification(notification.id);
      }

      _logDebug(
          '${archivedNotifications.length} notifications archivées supprimées');
    } catch (e, stackTrace) {
      _logError('Erreur lors de la suppression des notifications archivées', e,
          stackTrace);
    }
  }

  /// Récupère le nombre de notifications non lues
  Future<int> getUnreadCount() async {
    await _ensureInitialized();

    try {
      final unreadNotifications = await getUnreadNotifications();
      return unreadNotifications.length;
    } catch (e) {
      return 0;
    }
  }

  /// Met à jour le compteur de notifications non lues dans le stream
  void _updateUnreadCount() {
    getUnreadCount().then((count) {
      _unreadCountController.add(count);
    });
  }

  // ==================== NOTIFICATIONS MÉTÉO ====================

  /// Crée une notification d'alerte météo à partir d'une condition météo
  /// NOTE Prompt 9: Accepte CompositeWeatherData car WeatherCondition est UNITAIRE
  Future<NotificationAlert?> createWeatherAlert({
    required dynamic
        weather, // CompositeWeatherData ou map avec propriétés composites
    required String gardenId,
    String? plantId,
  }) async {
    await _ensureInitialized();

    try {
      // Vérifier si les alertes météo sont activées
      if (!await isNotificationTypeEnabled(NotificationType.weatherAlert)) {
        return null;
      }

      String? alertTitle;
      String? alertMessage;
      NotificationPriority priority = NotificationPriority.medium;

      // Alerte de gel
      if (weather.temperature < 0) {
        alertTitle = '❄️ Alerte Gel';
        alertMessage =
            'Risque de gel détecté (${weather.temperature.toStringAsFixed(1)}°C). '
            'Protégez vos plantes sensibles au froid.';
        priority = NotificationPriority.critical;
      }
      // Alerte température élevée
      else if (weather.temperature > 35) {
        alertTitle = '🔥 Alerte Chaleur';
        alertMessage =
            'Température élevée (${weather.temperature.toStringAsFixed(1)}°C). '
            'Augmentez l\'arrosage et protégez vos plantes du soleil.';
        priority = NotificationPriority.high;
      }
      // Alerte sécheresse
      else if (weather.humidity < 30 && weather.precipitation < 1) {
        alertTitle = '🏜️ Alerte Sécheresse';
        alertMessage =
            'Humidité très basse (${weather.humidity.toStringAsFixed(0)}%). '
            'Vérifiez l\'arrosage de vos plantes.';
        priority = NotificationPriority.high;
      }
      // Alerte vent fort
      else if (weather.windSpeed > 50) {
        alertTitle = '💨 Alerte Vent Fort';
        alertMessage =
            'Vents forts prévus (${weather.windSpeed.toStringAsFixed(0)} km/h). '
            'Sécurisez vos plantes et structures.';
        priority = NotificationPriority.high;
      }

      // Si aucune alerte nécessaire, retourner null
      if (alertTitle == null || alertMessage == null) {
        return null;
      }

      return await createNotification(
        title: alertTitle,
        message: alertMessage,
        type: NotificationType.weatherAlert,
        priority: priority,
        gardenId: gardenId,
        plantId: plantId,
        metadata: {
          'temperature': weather.temperature,
          'humidity': weather.humidity,
          'windSpeed': weather.windSpeed,
          'precipitation': weather.precipitation,
        },
      );
    } catch (e, stackTrace) {
      _logError('Erreur lors de la création de l\'alerte météo', e, stackTrace);
      return null;
    }
  }

  /// Crée une notification de conditions optimales
  /// NOTE Prompt 9: Accepte dynamic car PlantCondition est UNITAIRE
  Future<NotificationAlert?> createOptimalConditionsAlert({
    required dynamic plantCondition, // CompositePlantCondition ou map
    required String plantName,
  }) async {
    await _ensureInitialized();

    try {
      // Vérifier si les alertes de conditions optimales sont activées
      if (!await isNotificationTypeEnabled(NotificationType.optimalCondition)) {
        return null;
      }

      // Créer une notification uniquement si toutes les conditions sont optimales
      if (plantCondition.overallStatus == ConditionStatus.excellent) {
        return await createNotification(
          title: '✨ Conditions Optimales',
          message: 'Les conditions sont parfaites pour $plantName ! '
              'C\'est le moment idéal pour planter ou effectuer des actions importantes.',
          type: NotificationType.optimalCondition,
          priority: NotificationPriority.low,
          plantId: plantCondition.plantId,
          metadata: {
            'healthScore': plantCondition.healthScore,
            'overallStatus': plantCondition.overallStatus.name,
          },
        );
      }

      return null;
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la création de l\'alerte de conditions optimales',
          e,
          stackTrace);
      return null;
    }
  }

  /// Crée une notification de condition critique
  /// NOTE Prompt 9: Accepte dynamic car PlantCondition est UNITAIRE
  Future<NotificationAlert?> createCriticalConditionAlert({
    required dynamic plantCondition, // CompositePlantCondition ou map
    required String plantName,
  }) async {
    await _ensureInitialized();

    try {
      // Vérifier si les alertes de conditions critiques sont activées
      if (!await isNotificationTypeEnabled(
          NotificationType.criticalCondition)) {
        return null;
      }

      // Créer une notification si la condition est critique
      if (plantCondition.overallStatus == ConditionStatus.critical ||
          plantCondition.overallStatus == ConditionStatus.poor) {
        String message =
            'Attention ! $plantName nécessite une intervention urgente. ';

        // Ajouter des détails selon les conditions
        final issues = <String>[];
        if (plantCondition.temperatureStatus == ConditionStatus.critical) {
          issues.add('température inadaptée');
        }
        if (plantCondition.humidityStatus == ConditionStatus.critical) {
          issues.add('humidité critique');
        }
        if (plantCondition.soilMoistureStatus == ConditionStatus.critical) {
          issues.add('humidité du sol critique');
        }

        if (issues.isNotEmpty) {
          message += 'Problèmes détectés : ${issues.join(', ')}.';
        }

        return await createNotification(
          title: '🚨 Condition Critique',
          message: message,
          type: NotificationType.criticalCondition,
          priority: NotificationPriority.critical,
          plantId: plantCondition.plantId,
          metadata: {
            'healthScore': plantCondition.healthScore,
            'overallStatus': plantCondition.overallStatus.name,
            'issues': issues,
          },
        );
      }

      return null;
    } catch (e, stackTrace) {
      _logError('Erreur lors de la création de l\'alerte de condition critique',
          e, stackTrace);
      return null;
    }
  }

  /// Crée une notification de recommandation
  Future<NotificationAlert?> createRecommendationAlert({
    required recommendation_entities.Recommendation recommendation,
    required String plantName,
  }) async {
    await _ensureInitialized();

    try {
      // Vérifier si les notifications de recommandations sont activées
      if (!await isNotificationTypeEnabled(NotificationType.recommendation)) {
        return null;
      }

      // Créer une notification uniquement pour les recommandations urgentes ou importantes
      // Note: RecommendationPriority de recommendation.dart a 'critical', pas 'urgent'
      if (recommendation.priority ==
              recommendation_entities.RecommendationPriority.critical ||
          recommendation.priority ==
              recommendation_entities.RecommendationPriority.high) {
        NotificationPriority notificationPriority =
            NotificationPriority.low; // Valeur par défaut
        switch (recommendation.priority) {
          case recommendation_entities.RecommendationPriority.critical:
            notificationPriority = NotificationPriority.critical;
            break;
          case recommendation_entities.RecommendationPriority.high:
            notificationPriority = NotificationPriority.high;
            break;
          case recommendation_entities.RecommendationPriority.medium:
            notificationPriority = NotificationPriority.medium;
            break;
          case recommendation_entities.RecommendationPriority.low:
            notificationPriority = NotificationPriority.low;
            break;
        }

        return await createNotification(
          title: '💡 ${recommendation.title}',
          message: recommendation.description,
          type: NotificationType.recommendation,
          priority: notificationPriority,
          plantId: recommendation.plantId,
          actionId: recommendation.id,
          metadata: {
            'recommendationType': recommendation.type.name,
            'recommendationPriority': recommendation.priority.name,
            'expectedImpact': recommendation.expectedImpact,
          },
        );
      }

      return null;
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la création de la notification de recommandation',
          e,
          stackTrace);
      return null;
    }
  }

  // ==================== PRÉFÉRENCES ====================

  /// Récupère les préférences de notification
  Future<Map<String, dynamic>> getPreferences() async {
    await _ensureInitialized();

    try {
      final preferences = _preferencesBox!.get('user_preferences');
      if (preferences != null) {
        return Map<String, dynamic>.from(preferences);
      }

      // Retourner les préférences par défaut
      return _getDefaultPreferences();
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la récupération des préférences', e, stackTrace);
      return _getDefaultPreferences();
    }
  }

  /// Préférences par défaut
  Map<String, dynamic> _getDefaultPreferences() {
    return {
      'enabled': true,
      'types': {
        'weatherAlert': true,
        'plantCondition': true,
        'recommendation': true,
        'reminder': true,
        'criticalCondition': true,
        'optimalCondition': false, // Désactivé par défaut
      },
      'priorities': {
        'low': false,
        'medium': true,
        'high': true,
        'critical': true,
      },
      'quietHoursEnabled': false,
      'quietHoursStart': '22:00',
      'quietHoursEnd': '08:00',
      'soundEnabled': true,
      'vibrationEnabled': true,
    };
  }

  /// Met à jour les préférences
  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    await _ensureInitialized();

    try {
      await _preferencesBox!.put('user_preferences', preferences);
      _logDebug('Préférences de notification mises à jour');
    } catch (e, stackTrace) {
      _logError('Erreur lors de la mise à jour des préférences', e, stackTrace);
    }
  }

  /// Vérifie si les notifications sont activées globalement
  Future<bool> areNotificationsEnabled() async {
    final preferences = await getPreferences();
    return preferences['enabled'] == true;
  }

  /// Vérifie si un type de notification est activé
  Future<bool> isNotificationTypeEnabled(NotificationType type) async {
    if (!await areNotificationsEnabled()) {
      return false;
    }

    final preferences = await getPreferences();
    final types = preferences['types'] as Map<String, dynamic>?;
    if (types == null) return true;

    return types[type.name] == true;
  }

  /// Vérifie si une priorité de notification est activée
  Future<bool> isNotificationPriorityEnabled(
      NotificationPriority priority) async {
    if (!await areNotificationsEnabled()) {
      return false;
    }

    final preferences = await getPreferences();
    final priorities = preferences['priorities'] as Map<String, dynamic>?;
    if (priorities == null) return true;

    return priorities[priority.name] == true;
  }

  /// Active ou désactive les notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    final preferences = await getPreferences();
    preferences['enabled'] = enabled;
    await updatePreferences(preferences);
  }

  /// Active ou désactive un type de notification
  Future<void> setNotificationTypeEnabled(
      NotificationType type, bool enabled) async {
    final preferences = await getPreferences();
    final types = preferences['types'] as Map<String, dynamic>;
    types[type.name] = enabled;
    preferences['types'] = types;
    await updatePreferences(preferences);
  }

  // ==================== NETTOYAGE ====================

  /// Nettoie les anciennes notifications
  Future<void> cleanupOldNotifications({int daysToKeep = 30}) async {
    await _ensureInitialized();

    try {
      final allNotifications = await getAllNotifications();
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

      int deletedCount = 0;
      for (final notification in allNotifications) {
        // Supprimer les notifications anciennes et archivées/ignorées
        if (notification.createdAt.isBefore(cutoffDate) &&
            (notification.status == NotificationStatus.archived ||
                notification.status == NotificationStatus.dismissed)) {
          await deleteNotification(notification.id);
          deletedCount++;
        }
      }

      _logDebug('$deletedCount anciennes notifications supprimées');
    } catch (e, stackTrace) {
      _logError('Erreur lors du nettoyage des anciennes notifications', e,
          stackTrace);
    }
  }

  // ==================== GÉNÉRATION AUTOMATIQUE D'ALERTES ====================
  // ✅ NOUVEAU - Phase 1 : Connexion Fonctionnelle

  /// Génère des alertes météo automatiques basées sur les conditions actuelles
  ///
  /// Détecte et crée des notifications pour :
  /// - Risque de gel (< 0°C)
  /// - Alerte canicule (> 35°C)
  /// - Sécheresse (humidité < 30%)
  /// - Vents forts (> 50 km/h)
  Future<void> generateWeatherAlerts({
    required String gardenId,
    required double temperature,
    double? humidity,
    double? windSpeed,
    List<String>? affectedPlantIds,
  }) async {
    await _ensureInitialized();

    try {
      // Alerte gel
      if (temperature < 0) {
        await createNotification(
          title: '❄️ Alerte Gel',
          message:
              'Température négative détectée (${temperature.toStringAsFixed(1)}°C). Protégez vos plantes sensibles au gel.',
          type: NotificationType.weatherAlert,
          priority: NotificationPriority.critical,
          gardenId: gardenId,
          metadata: {
            'temperature': temperature,
            'alertType': 'frost',
            'affectedPlantIds': affectedPlantIds ?? [],
          },
        );
        _logDebug('Alerte gel générée pour jardin $gardenId');
      }

      // Alerte canicule
      if (temperature > 35) {
        await createNotification(
          title: '🔥 Alerte Canicule',
          message:
              'Température élevée détectée (${temperature.toStringAsFixed(1)}°C). Augmentez l\'arrosage et protégez du soleil.',
          type: NotificationType.weatherAlert,
          priority: NotificationPriority.high,
          gardenId: gardenId,
          metadata: {
            'temperature': temperature,
            'alertType': 'heatwave',
            'affectedPlantIds': affectedPlantIds ?? [],
          },
        );
        _logDebug('Alerte canicule générée pour jardin $gardenId');
      }

      // Alerte sécheresse
      if (humidity != null && humidity < 30) {
        await createNotification(
          title: '💧 Alerte Sécheresse',
          message:
              'Humidité faible détectée (${humidity.toStringAsFixed(1)}%). Vérifiez l\'arrosage de vos plantes.',
          type: NotificationType.weatherAlert,
          priority: NotificationPriority.high,
          gardenId: gardenId,
          metadata: {
            'humidity': humidity,
            'alertType': 'drought',
            'affectedPlantIds': affectedPlantIds ?? [],
          },
        );
        _logDebug('Alerte sécheresse générée pour jardin $gardenId');
      }

      // Alerte vents forts
      if (windSpeed != null && windSpeed > 50) {
        await createNotification(
          title: '💨 Alerte Vents Forts',
          message:
              'Vents forts prévus (${windSpeed.toStringAsFixed(0)} km/h). Protégez vos plantes fragiles.',
          type: NotificationType.weatherAlert,
          priority: NotificationPriority.medium,
          gardenId: gardenId,
          metadata: {
            'windSpeed': windSpeed,
            'alertType': 'strongWind',
            'affectedPlantIds': affectedPlantIds ?? [],
          },
        );
        _logDebug('Alerte vents forts générée pour jardin $gardenId');
      }
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la génération des alertes météo', e, stackTrace);
    }
  }

  /// Génère une alerte pour une condition critique détectée
  ///
  /// Crée une notification de priorité critique quand une condition
  /// de plante est dans un état critique (poor ou critical)
  Future<void> generateCriticalConditionAlert({
    required String plantId,
    required String plantName,
    required String gardenId,
    required ConditionType conditionType,
    required ConditionStatus conditionStatus,
    required double currentValue,
    required String unit,
    String? recommendation,
  }) async {
    await _ensureInitialized();

    try {
      final conditionName = _getConditionName(conditionType);
      final statusText = _getStatusText(conditionStatus);

      await createNotification(
        title: '⚠️ Condition Critique - $plantName',
        message:
            '$conditionName en état $statusText (${currentValue.toStringAsFixed(1)} $unit). ${recommendation ?? 'Action immédiate recommandée.'}',
        type: NotificationType.criticalCondition,
        priority: NotificationPriority.critical,
        plantId: plantId,
        gardenId: gardenId,
        metadata: {
          'conditionType': conditionType.name,
          'conditionStatus': conditionStatus.name,
          'currentValue': currentValue,
          'unit': unit,
          'recommendation': recommendation,
        },
      );

      _logDebug(
          'Alerte condition critique générée pour plante $plantId ($conditionName)');
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la génération de l\'alerte critique', e, stackTrace);
    }
  }

  /// Génère une alerte pour une condition optimale atteinte
  ///
  /// Crée une notification positive quand une condition
  /// de plante atteint l'état optimal (excellent)
  Future<void> generateOptimalConditionAlert({
    required String plantId,
    required String plantName,
    required String gardenId,
    required ConditionType conditionType,
    required double currentValue,
    required String unit,
  }) async {
    await _ensureInitialized();

    try {
      final conditionName = _getConditionName(conditionType);

      await createNotification(
        title: '✅ Conditions Optimales - $plantName',
        message:
            '$conditionName en état excellent (${currentValue.toStringAsFixed(1)} $unit). Conditions idéales !',
        type: NotificationType.optimalCondition,
        priority: NotificationPriority.low,
        plantId: plantId,
        gardenId: gardenId,
        metadata: {
          'conditionType': conditionType.name,
          'currentValue': currentValue,
          'unit': unit,
        },
      );

      _logDebug(
          'Alerte condition optimale générée pour plante $plantId ($conditionName)');
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la génération de l\'alerte optimale', e, stackTrace);
    }
  }

  // ==================== HELPERS POUR ALERTES ====================

  /// Retourne le nom lisible d'un type de condition
  String _getConditionName(ConditionType type) {
    switch (type) {
      case ConditionType.temperature:
        return 'Température';
      case ConditionType.humidity:
        return 'Humidité';
      case ConditionType.light:
        return 'Luminosité';
      case ConditionType.soil:
        return 'Sol';
      case ConditionType.wind:
        return 'Vent';
      case ConditionType.water:
        return 'Eau';
    }
  }

  /// Retourne le texte lisible d'un statut de condition
  String _getStatusText(ConditionStatus status) {
    switch (status) {
      case ConditionStatus.optimal:
        return 'optimal';
      case ConditionStatus.excellent:
        return 'excellent';
      case ConditionStatus.good:
        return 'bon';
      case ConditionStatus.suboptimal:
        return 'sous-optimal';
      case ConditionStatus.fair:
        return 'acceptable';
      case ConditionStatus.poor:
        return 'médiocre';
      case ConditionStatus.critical:
        return 'critique';
    }
  }

  // ==================== LOGGING ====================

  void _logDebug(String message) {
    developer.log(
      message,
      name: 'PlantNotificationService',
      level: 500,
    );
  }

  void _logError(String message, Object error, [StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'PlantNotificationService',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    print('[PlantNotificationService] ERROR: $message - $error');
  }

  // ==================== DISPOSE ====================

  /// Ferme le service et libère les ressources
  Future<void> dispose() async {
    await _notificationStreamController.close();
    await _unreadCountController.close();
    await _notificationsBox?.close();
    await _preferencesBox?.close();
    _isInitialized = false;
  }
}
