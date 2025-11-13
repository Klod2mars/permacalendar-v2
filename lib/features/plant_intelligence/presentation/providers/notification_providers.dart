ï»¿import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification_alert.dart';
import '../../data/services/plant_notification_service.dart';

// ==================== SERVICE PROVIDER ====================

/// Provider pour le service de notifications
final plantNotificationServiceProvider =
    Provider<PlantNotificationService>((ref) {
  return PlantNotificationService();
});

// ==================== STREAM PROVIDERS ====================

/// Provider pour le stream des notifications en temps réel
final notificationStreamProvider = StreamProvider<NotificationAlert>((ref) {
  final service = ref.watch(plantNotificationServiceProvider);
  return service.notificationStream;
});

/// Provider pour le stream du nombre de notifications non lues
final unreadNotificationCountStreamProvider = StreamProvider<int>((ref) {
  final service = ref.watch(plantNotificationServiceProvider);
  return service.unreadCountStream;
});

// ==================== FUTURE PROVIDERS ====================

/// Provider pour toutes les notifications
final allNotificationsProvider =
    FutureProvider<List<NotificationAlert>>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  return await service.getAllNotifications();
});

/// Provider pour les notifications actives
final activeNotificationsProvider =
    FutureProvider<List<NotificationAlert>>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  return await service.getActiveNotifications();
});

/// Provider pour les notifications non lues
final unreadNotificationsProvider =
    FutureProvider<List<NotificationAlert>>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  return await service.getUnreadNotifications();
});

/// Provider pour le nombre de notifications non lues
final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  return await service.getUnreadCount();
});

/// Provider pour les notifications par priorité
final notificationsByPriorityProvider =
    FutureProvider.family<List<NotificationAlert>, NotificationPriority>(
        (ref, priority) async {
  final service = ref.watch(plantNotificationServiceProvider);
  return await service.getNotificationsByPriority(priority);
});

/// Provider pour les notifications par type
final notificationsByTypeProvider =
    FutureProvider.family<List<NotificationAlert>, NotificationType>(
        (ref, type) async {
  final service = ref.watch(plantNotificationServiceProvider);
  return await service.getNotificationsByType(type);
});

/// Provider pour les notifications d'une plante
final notificationsForPlantProvider =
    FutureProvider.family<List<NotificationAlert>, String>(
        (ref, plantId) async {
  final service = ref.watch(plantNotificationServiceProvider);
  return await service.getNotificationsForPlant(plantId);
});

/// Provider pour les notifications d'un jardin
final notificationsForGardenProvider =
    FutureProvider.family<List<NotificationAlert>, String>(
        (ref, gardenId) async {
  final service = ref.watch(plantNotificationServiceProvider);
  return await service.getNotificationsForGarden(gardenId);
});

/// Provider pour les préférences de notification
final notificationPreferencesProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  return await service.getPreferences();
});

/// Provider pour vérifier si les notifications sont activées
final notificationsEnabledProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  return await service.areNotificationsEnabled();
});

// ==================== STATE NOTIFIER PROVIDERS ====================

/// Notifier pour gérer les notifications en temps réel
class NotificationListNotifier extends AsyncNotifier<List<NotificationAlert>> {
  @override
  Future<List<NotificationAlert>> build() async {
    final service = ref.read(plantNotificationServiceProvider);
    return await service.getActiveNotifications();
  }

  /// Actualise la liste des notifications
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(plantNotificationServiceProvider);
      final notifications = await service.getActiveNotifications();
      state = AsyncValue.data(notifications);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Marque une notification comme lue
  Future<void> markAsRead(String notificationId) async {
    final service = ref.read(plantNotificationServiceProvider);
    await service.markAsRead(notificationId);
    await refresh();
  }

  /// Marque toutes les notifications comme lues
  Future<void> markAllAsRead() async {
    final service = ref.read(plantNotificationServiceProvider);
    await service.markAllAsRead();
    await refresh();
  }

  /// Archive une notification
  Future<void> archive(String notificationId) async {
    final service = ref.read(plantNotificationServiceProvider);
    await service.archiveNotification(notificationId);
    await refresh();
  }

  /// Ignore une notification
  Future<void> dismiss(String notificationId) async {
    final service = ref.read(plantNotificationServiceProvider);
    await service.dismissNotification(notificationId);
    await refresh();
  }

  /// Supprime une notification
  Future<void> delete(String notificationId) async {
    final service = ref.read(plantNotificationServiceProvider);
    await service.deleteNotification(notificationId);
    await refresh();
  }
}

/// Provider pour le notifier de liste de notifications
final notificationListNotifierProvider =
    AsyncNotifierProvider<NotificationListNotifier, List<NotificationAlert>>(
        () {
  return NotificationListNotifier();
});

/// Notifier pour gérer les préférences de notification
class NotificationPreferencesNotifier
    extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> build() async {
    try {
      final service = ref.read(plantNotificationServiceProvider);
      final preferences = await service.getPreferences();
      return preferences;
    } catch (error) {
      // Utiliser les préférences par défaut en cas d'erreur
      return {};
    }
  }

  /// Actualise les préférences
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final preferences = await build();
      state = AsyncValue.data(preferences);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Active ou désactive les notifications
  Future<void> setEnabled(bool enabled) async {
    final service = ref.read(plantNotificationServiceProvider);
    await service.setNotificationsEnabled(enabled);
    await refresh();
  }

  /// Active ou désactive un type de notification
  Future<void> setTypeEnabled(NotificationType type, bool enabled) async {
    final service = ref.read(plantNotificationServiceProvider);
    await service.setNotificationTypeEnabled(type, enabled);
    await refresh();
  }

  /// Met à jour toutes les préférences
  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    final service = ref.read(plantNotificationServiceProvider);
    await service.updatePreferences(preferences);
    await refresh();
  }

  /// Réinitialise les préférences par défaut
  Future<void> resetToDefaults() async {
    final defaultPreferences = {
      'enabled': true,
      'types': {
        'weatherAlert': true,
        'plantCondition': true,
        'recommendation': true,
        'reminder': true,
        'criticalCondition': true,
        'optimalCondition': false,
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

    await updatePreferences(defaultPreferences);
  }
}

/// Provider pour le notifier de préférences de notification
final notificationPreferencesNotifierProvider = AsyncNotifierProvider<
    NotificationPreferencesNotifier, Map<String, dynamic>>(() {
  return NotificationPreferencesNotifier();
});

// ==================== COMPUTED PROVIDERS ====================

/// Provider pour les notifications critiques non lues
final criticalUnreadNotificationsProvider =
    FutureProvider<List<NotificationAlert>>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  final unreadNotifications = await service.getUnreadNotifications();
  return unreadNotifications.where((n) => n.isCritical).toList();
});

/// Provider pour les notifications urgentes non lues
final urgentUnreadNotificationsProvider =
    FutureProvider<List<NotificationAlert>>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  final unreadNotifications = await service.getUnreadNotifications();
  return unreadNotifications.where((n) => n.isUrgent).toList();
});

/// Provider pour les notifications triées par priorité
final sortedNotificationsProvider =
    FutureProvider<List<NotificationAlert>>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  final notifications = await service.getActiveNotifications();

  // Trier par score de priorité décroissant
  notifications.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));

  return notifications;
});

/// Provider pour les notifications groupées par type
final notificationsGroupedByTypeProvider =
    FutureProvider<Map<NotificationType, List<NotificationAlert>>>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  final notifications = await service.getActiveNotifications();

  final grouped = <NotificationType, List<NotificationAlert>>{};

  for (final notification in notifications) {
    if (!grouped.containsKey(notification.type)) {
      grouped[notification.type] = [];
    }
    grouped[notification.type]!.add(notification);
  }

  return grouped;
});

/// Provider pour les notifications groupées par priorité
final notificationsGroupedByPriorityProvider =
    FutureProvider<Map<NotificationPriority, List<NotificationAlert>>>(
        (ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  final notifications = await service.getActiveNotifications();

  final grouped = <NotificationPriority, List<NotificationAlert>>{};

  for (final notification in notifications) {
    if (!grouped.containsKey(notification.priority)) {
      grouped[notification.priority] = [];
    }
    grouped[notification.priority]!.add(notification);
  }

  return grouped;
});

/// Provider pour les statistiques de notifications
final notificationStatsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(plantNotificationServiceProvider);
  final allNotifications = await service.getAllNotifications();
  final unreadNotifications = await service.getUnreadNotifications();
  final activeNotifications = await service.getActiveNotifications();

  // Compter par type
  final byType = <String, int>{};
  for (final notification in activeNotifications) {
    final typeName = notification.type.name;
    byType[typeName] = (byType[typeName] ?? 0) + 1;
  }

  // Compter par priorité
  final byPriority = <String, int>{};
  for (final notification in activeNotifications) {
    final priorityName = notification.priority.name;
    byPriority[priorityName] = (byPriority[priorityName] ?? 0) + 1;
  }

  return {
    'total': allNotifications.length,
    'unread': unreadNotifications.length,
    'active': activeNotifications.length,
    'byType': byType,
    'byPriority': byPriority,
    'criticalCount': activeNotifications.where((n) => n.isCritical).length,
    'urgentCount': activeNotifications.where((n) => n.isUrgent).length,
  };
});

// ==================== ACTION PROVIDERS ====================

/// Provider pour Créer une notification
final createNotificationProvider = Provider<
    Future<NotificationAlert> Function({
      required String title,
      required String message,
      required NotificationType type,
      required NotificationPriority priority,
      String? plantId,
      String? gardenId,
      String? actionId,
      Map<String, dynamic>? metadata,
    })>((ref) {
  final service = ref.watch(plantNotificationServiceProvider);

  return ({
    required String title,
    required String message,
    required NotificationType type,
    required NotificationPriority priority,
    String? plantId,
    String? gardenId,
    String? actionId,
    Map<String, dynamic>? metadata,
  }) async {
    final notification = await service.createNotification(
      title: title,
      message: message,
      type: type,
      priority: priority,
      plantId: plantId,
      gardenId: gardenId,
      actionId: actionId,
      metadata: metadata,
    );

    // Actualiser les providers
    ref.invalidate(allNotificationsProvider);
    ref.invalidate(activeNotificationsProvider);
    ref.invalidate(unreadNotificationsProvider);
    ref.invalidate(notificationListNotifierProvider);

    return notification;
  };
});

/// Provider pour nettoyer les anciennes notifications
final cleanupOldNotificationsProvider =
    Provider<Future<void> Function({int? daysToKeep})>((ref) {
  final service = ref.watch(plantNotificationServiceProvider);

  return ({int? daysToKeep}) async {
    await service.cleanupOldNotifications(daysToKeep: daysToKeep ?? 30);

    // Actualiser les providers
    ref.invalidate(allNotificationsProvider);
    ref.invalidate(activeNotificationsProvider);
    ref.invalidate(notificationListNotifierProvider);
  };
});


