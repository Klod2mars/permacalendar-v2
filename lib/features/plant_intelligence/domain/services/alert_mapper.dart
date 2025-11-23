import 'dart:developer' as developer;

import '../entities/notification_alert.dart';
import 'package:uuid/uuid.dart';

/// Service dédié au mapping alertes JSON → NotificationAlert.
///
/// SRP strict :
///   👉 Convertir un Map<String, dynamic> en NotificationAlert
///   👉 Gérer erreurs localement
///   👉 Ne jamais écrire dans Hive
///
class AlertMapper {
  /// Convertit une liste brute en objets NotificationAlert.
  List<NotificationAlert> mapList(List<Map<String, dynamic>> rawAlerts) {
    final alerts = <NotificationAlert>[];

    for (final raw in rawAlerts) {
      try {
        final alert = mapOne(raw);
        if (alert != null) alerts.add(alert);
      } catch (e) {
        developer.log(
          '⚠️ AlertMapper → erreur conversion : $e',
          name: 'AlertMapper',
          level: 900,
        );
      }
    }

    return alerts;
  }

  /// Convertit une seule alerte.
  NotificationAlert? mapOne(Map<String, dynamic> raw) {
    try {
      final isRead = raw['read'] as bool? ?? false;

      return NotificationAlert(
        id: raw['id'] as String? ?? const Uuid().v4(),
        title: raw['title'] as String? ?? 'Alerte',
        message: raw['message'] as String? ?? '',
        type: NotificationType.recommendation,
        priority: _priorityFromString(raw['severity'] as String?),
        createdAt: raw['createdAt'] != null
            ? DateTime.parse(raw['createdAt'] as String)
            : DateTime.now(),
        readAt: isRead ? DateTime.now() : null,
        plantId: raw['plantId'] as String?,
        metadata: raw['metadata'] as Map<String, dynamic>? ?? {},
      );
    } catch (e) {
      developer.log(
        '⚠️ AlertMapper → Erreur conversion alerte unique : $e',
        name: 'AlertMapper',
        level: 900,
      );
      return null;
    }
  }

  /// Convertit une sévérité en priorité typée.
  NotificationPriority _priorityFromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'critical':
        return NotificationPriority.critical;
      case 'high':
        return NotificationPriority.high;
      case 'medium':
        return NotificationPriority.medium;
      case 'low':
        return NotificationPriority.low;
      default:
        return NotificationPriority.medium;
    }
  }
}
