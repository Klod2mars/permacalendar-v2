import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../domain/entities/notification_alert.dart';

/// Service d'intégration avec flutter_local_notifications
/// Gère l'affichage des notifications système
class FlutterNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  // Canaux de notification Android
  static const AndroidNotificationChannel _criticalChannel =
      AndroidNotificationChannel(
    'plant_intelligence_critical',
    'Alertes Critiques',
    description: 'Notifications critiques pour les conditions de plantes',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  static const AndroidNotificationChannel _highPriorityChannel =
      AndroidNotificationChannel(
    'plant_intelligence_high',
    'Alertes Importantes',
    description: 'Notifications importantes pour les plantes',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
    'plant_intelligence_default',
    'Notifications Générales',
    description: 'Notifications générales pour les plantes',
    importance: Importance.defaultImportance,
    playSound: true,
  );

  static const AndroidNotificationChannel _lowPriorityChannel =
      AndroidNotificationChannel(
    'plant_intelligence_low',
    'Informations',
    description: 'Informations générales',
    importance: Importance.low,
    playSound: false,
  );

  /// Initialise le service de notifications
  static Future<void> initialize() async {
    if (_isInitialized) {
      _logDebug('Service déjà initialisé');
      return;
    }

    try {
      _logDebug('Initialisation du service de notifications Flutter...');

      // Configuration Android
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuration iOS/macOS
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Configuration Linux
      const LinuxInitializationSettings linuxSettings =
          LinuxInitializationSettings(defaultActionName: 'Ouvrir');

      // Configuration globale
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
        linux: linuxSettings,
      );

      // Initialiser le plugin
      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Créer les canaux Android
      await _createAndroidChannels();

      // Demander les permissions
      await _requestPermissions();

      _isInitialized = true;
      _logDebug('Service de notifications Flutter initialisé avec succès');
    } catch (e, stackTrace) {
      _logError('Erreur lors de l\'initialisation', e, stackTrace);
      rethrow;
    }
  }

  /// Crée les canaux de notification Android
  static Future<void> _createAndroidChannels() async {
    try {
      final androidPlugin =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(_criticalChannel);
        await androidPlugin.createNotificationChannel(_highPriorityChannel);
        await androidPlugin.createNotificationChannel(_defaultChannel);
        await androidPlugin.createNotificationChannel(_lowPriorityChannel);

        _logDebug('Canaux Android créés');
      }
    } catch (e, stackTrace) {
      _logError('Erreur lors de la création des canaux Android', e, stackTrace);
    }
  }

  /// Demande les permissions de notification
  static Future<void> _requestPermissions() async {
    try {
      // iOS/macOS
      final iosPlugin =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosPlugin != null) {
        await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      final macOSPlugin =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>();

      if (macOSPlugin != null) {
        await macOSPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      // Android 13+
      final androidPlugin =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
      }
    } catch (e, stackTrace) {
      _logError('Erreur lors de la demande de permissions', e, stackTrace);
    }
  }

  /// Callback quand une notification est tapée
  static void _onNotificationTap(NotificationResponse response) {
    _logDebug('Notification tapée: ${response.payload}');

    // TODO: Implémenter la navigation vers l'écran approprié
    // en fonction du payload
  }

  /// Affiche une notification système à partir d'une NotificationAlert
  static Future<void> showNotification(NotificationAlert alert) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Déterminer le canal et la priorité
      final channelData = _getChannelForPriority(alert.priority);

      // Créer les détails de notification
      final androidDetails = AndroidNotificationDetails(
        channelData['channelId'] as String,
        channelData['channelName'] as String,
        channelDescription: channelData['channelDescription'] as String,
        importance: channelData['importance'] as Importance,
        priority: channelData['priority'] as Priority,
        playSound: true,
        enableVibration: alert.priority == NotificationPriority.critical ||
            alert.priority == NotificationPriority.high,
        icon: '@mipmap/ic_launcher',
        styleInformation: _getBigTextStyle(alert),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      // Afficher la notification
      await _notificationsPlugin.show(
        alert.id.hashCode, // ID unique basé sur l'ID de la notification
        alert.title,
        alert.message,
        notificationDetails,
        payload: alert.id,
      );

      _logDebug('Notification affichée: ${alert.title}');
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de l\'affichage de la notification', e, stackTrace);
    }
  }

  /// Retourne le canal approprié selon la priorité
  static Map<String, dynamic> _getChannelForPriority(
      NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.critical:
        return {
          'channelId': _criticalChannel.id,
          'channelName': _criticalChannel.name,
          'channelDescription': _criticalChannel.description,
          'importance': Importance.max,
          'priority': Priority.max,
        };

      case NotificationPriority.high:
        return {
          'channelId': _highPriorityChannel.id,
          'channelName': _highPriorityChannel.name,
          'channelDescription': _highPriorityChannel.description,
          'importance': Importance.high,
          'priority': Priority.high,
        };

      case NotificationPriority.medium:
        return {
          'channelId': _defaultChannel.id,
          'channelName': _defaultChannel.name,
          'channelDescription': _defaultChannel.description,
          'importance': Importance.defaultImportance,
          'priority': Priority.defaultPriority,
        };

      case NotificationPriority.low:
        return {
          'channelId': _lowPriorityChannel.id,
          'channelName': _lowPriorityChannel.name,
          'channelDescription': _lowPriorityChannel.description,
          'importance': Importance.low,
          'priority': Priority.low,
        };
    }
  }

  /// Crée le style de notification avec texte long
  static BigTextStyleInformation _getBigTextStyle(NotificationAlert alert) {
    return BigTextStyleInformation(
      alert.message,
      contentTitle: alert.title,
      summaryText: '${alert.type.displayName} · ${alert.ageText}',
    );
  }

  /// Annule une notification système
  static Future<void> cancelNotification(String alertId) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _notificationsPlugin.cancel(alertId.hashCode);
      _logDebug('Notification annulée: $alertId');
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de l\'annulation de la notification', e, stackTrace);
    }
  }

  /// Annule toutes les notifications système
  static Future<void> cancelAllNotifications() async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _notificationsPlugin.cancelAll();
      _logDebug('Toutes les notifications annulées');
    } catch (e, stackTrace) {
      _logError('Erreur lors de l\'annulation de toutes les notifications', e,
          stackTrace);
    }
  }

  /// Planifie une notification pour plus tard
  static Future<void> scheduleNotification(
    NotificationAlert alert,
    DateTime scheduledTime,
  ) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final channelData = _getChannelForPriority(alert.priority);

      final androidDetails = AndroidNotificationDetails(
        channelData['channelId'] as String,
        channelData['channelName'] as String,
        channelDescription: channelData['channelDescription'] as String,
        importance: channelData['importance'] as Importance,
        priority: channelData['priority'] as Priority,
        playSound: true,
        enableVibration: alert.priority == NotificationPriority.critical ||
            alert.priority == NotificationPriority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      // Planifier la notification
      await _notificationsPlugin.zonedSchedule(
        alert.id.hashCode,
        alert.title,
        alert.message,
        _convertToTZDateTime(scheduledTime),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: alert.id,
      );

      _logDebug('Notification planifiée: ${alert.title} pour $scheduledTime');
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la planification de la notification', e, stackTrace);
    }
  }

  /// Convertit DateTime en TZDateTime (pour le moment, utilisation simple)
  static dynamic _convertToTZDateTime(DateTime dateTime) {
    // Note: Pour une gestion complète des fuseaux horaires,
    // utiliser le package timezone
    return dateTime;
  }

  /// Récupère le nombre de notifications en attente
  static Future<int> getPendingNotificationCount() async {
    if (!_isInitialized) {
      return 0;
    }

    try {
      final pendingNotifications =
          await _notificationsPlugin.pendingNotificationRequests();
      return pendingNotifications.length;
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de la récupération du nombre de notifications en attente',
          e,
          stackTrace);
      return 0;
    }
  }

  /// Récupère les notifications actives
  static Future<List<ActiveNotification>> getActiveNotifications() async {
    if (!_isInitialized) {
      return [];
    }

    try {
      final androidPlugin =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        return await androidPlugin.getActiveNotifications() ?? [];
      }

      return [];
    } catch (e, stackTrace) {
      _logError('Erreur lors de la récupération des notifications actives', e,
          stackTrace);
      return [];
    }
  }

  // ==================== LOGGING ====================

  static void _logDebug(String message) {
    developer.log(
      message,
      name: 'FlutterNotificationService',
      level: 500,
    );
  }

  static void _logError(String message, Object error,
      [StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'FlutterNotificationService',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    print('[FlutterNotificationService] ERROR: $message - $error');
  }
}
