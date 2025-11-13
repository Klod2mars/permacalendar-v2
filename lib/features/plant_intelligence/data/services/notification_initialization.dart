ï»¿import 'package:hive/hive.dart';
import '../../domain/entities/notification_alert.dart';
import 'plant_notification_service.dart';
import 'flutter_notification_service.dart';
import 'dart:developer' as developer;

/// Service d'initialisation des notifications pour l'intelligence végétale
class NotificationInitialization {
  static bool _isInitialized = false;

  /// Initialise tous les services de notification
  static Future<void> initialize() async {
    if (_isInitialized) {
      _logDebug('Services de notification déjà initialisés');
      return;
    }

    try {
      _logDebug('Initialisation des services de notification...');

      // 1. Enregistrer les adapters Hive
      await _registerHiveAdapters();

      // 2. Initialiser PlantNotificationService
      await PlantNotificationService().initialize();
      _logDebug('PlantNotificationService initialisé');

      // 3. Initialiser FlutterNotificationService
      await FlutterNotificationService.initialize();
      _logDebug('FlutterNotificationService initialisé');

      // 4. Nettoyer les anciennes notifications (30 jours)
      await PlantNotificationService().cleanupOldNotifications(daysToKeep: 30);
      _logDebug('Nettoyage des anciennes notifications effectué');

      _isInitialized = true;
      _logDebug('âœ… Services de notification initialisés avec succès');
    } catch (e, stackTrace) {
      _logError('Erreur lors de l\'initialisation des services de notification',
          e, stackTrace);
      rethrow;
    }
  }

  /// Enregistre les adapters Hive pour les notifications
  static Future<void> _registerHiveAdapters() async {
    try {
      // Vérifier si les adapters sont déjà enregistrés
      if (!Hive.isAdapterRegistered(40)) {
        Hive.registerAdapter(NotificationTypeAdapter());
        _logDebug('NotificationTypeAdapter enregistré (typeId: 40)');
      }

      if (!Hive.isAdapterRegistered(41)) {
        Hive.registerAdapter(NotificationPriorityAdapter());
        _logDebug('NotificationPriorityAdapter enregistré (typeId: 41)');
      }

      if (!Hive.isAdapterRegistered(42)) {
        Hive.registerAdapter(NotificationStatusAdapter());
        _logDebug('NotificationStatusAdapter enregistré (typeId: 42)');
      }

      if (!Hive.isAdapterRegistered(43)) {
        Hive.registerAdapter(NotificationAlertAdapter());
        _logDebug('NotificationAlertAdapter enregistré (typeId: 43)');
      }
    } catch (e, stackTrace) {
      _logError(
          'Erreur lors de l\'enregistrement des adapters Hive', e, stackTrace);
      rethrow;
    }
  }

  /// Vérifie si les services sont initialisés
  static bool get isInitialized => _isInitialized;

  /// Désactive les services de notification
  static Future<void> dispose() async {
    try {
      await PlantNotificationService().dispose();
      await FlutterNotificationService.cancelAllNotifications();
      _isInitialized = false;
      _logDebug('Services de notification désactivés');
    } catch (e, stackTrace) {
      _logError('Erreur lors de la désactivation des services', e, stackTrace);
    }
  }

  // ==================== LOGGING ====================

  static void _logDebug(String message) {
    developer.log(
      message,
      name: 'NotificationInitialization',
      level: 500,
    );
  }

  static void _logError(String message, Object error,
      [StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'NotificationInitialization',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    print('[NotificationInitialization] ERROR: $message - $error');
  }
}

/// Classe pour les adapters Hive des enums

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 40;

  @override
  NotificationType read(BinaryReader reader) {
    return NotificationType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    writer.writeByte(obj.index);
  }
}

class NotificationPriorityAdapter extends TypeAdapter<NotificationPriority> {
  @override
  final int typeId = 41;

  @override
  NotificationPriority read(BinaryReader reader) {
    return NotificationPriority.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, NotificationPriority obj) {
    writer.writeByte(obj.index);
  }
}

class NotificationStatusAdapter extends TypeAdapter<NotificationStatus> {
  @override
  final int typeId = 42;

  @override
  NotificationStatus read(BinaryReader reader) {
    return NotificationStatus.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, NotificationStatus obj) {
    writer.writeByte(obj.index);
  }
}


