import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'notification_alert.freezed.dart';
part 'notification_alert.g.dart';

/// Type de notification pour l'intelligence végétale
@HiveType(typeId: 40)
enum NotificationType {
  @HiveField(0)
  weatherAlert,

  @HiveField(1)
  plantCondition,

  @HiveField(2)
  recommendation,

  @HiveField(3)
  reminder,

  @HiveField(4)
  criticalCondition,

  @HiveField(5)
  optimalCondition,
}

/// Priorité de la notification
@HiveType(typeId: 41)
enum NotificationPriority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,

  @HiveField(3)
  critical,
}

/// Statut de la notification
@HiveType(typeId: 42)
enum NotificationStatus {
  @HiveField(0)
  unread,

  @HiveField(1)
  read,

  @HiveField(2)
  archived,

  @HiveField(3)
  dismissed,
}

/// Sévérité de l'alerte
@HiveType(typeId: 44)
enum AlertSeverity {
  @HiveField(0)
  info,

  @HiveField(1)
  warning,

  @HiveField(2)
  error,
}

/// Modèle des notifications d'alerte pour l'intelligence végétale
@freezed
@HiveType(typeId: 43, adapterName: 'NotificationAlertAdapter')
class NotificationAlert with _$NotificationAlert {
  const NotificationAlert._();

  const factory NotificationAlert({
    /// Identifiant unique de la notification
    @HiveField(0) required String id,

    /// Titre de la notification
    @HiveField(1) required String title,

    /// Message de la notification
    @HiveField(2) required String message,

    /// Type de notification
    @HiveField(3) required NotificationType type,

    /// Priorité de la notification
    @HiveField(4) required NotificationPriority priority,

    /// Sévérité de l'alerte
    @HiveField(14)
    @Default(AlertSeverity.info)
    AlertSeverity severity,

    /// Date de création
    @HiveField(5) required DateTime createdAt,

    /// Date de lecture
    @HiveField(6) DateTime? readAt,

    /// ID de la plante concernée (optionnel)
    @HiveField(7) String? plantId,

    /// ID du jardin concerné (optionnel)
    @HiveField(8) String? gardenId,

    /// ID de l'action associée (optionnel)
    @HiveField(9) String? actionId,

    /// Statut de la notification
    @HiveField(10)
    @Default(NotificationStatus.unread)
    NotificationStatus status,

    /// Métadonnées flexibles
    @HiveField(11) @Default({}) Map<String, dynamic> metadata,

    /// Date d'archivage
    @HiveField(12) DateTime? archivedAt,

    /// Date de dismissal
    @HiveField(13) DateTime? dismissedAt,
  }) = _NotificationAlert;

  factory NotificationAlert.fromJson(Map<String, dynamic> json) =>
      _$NotificationAlertFromJson(json);
}

/// Extensions pour les types de notification
extension NotificationTypeExtension on NotificationType {
  /// Nom d'affichage en français
  String get displayName {
    switch (this) {
      case NotificationType.weatherAlert:
        return 'Alerte météo';
      case NotificationType.plantCondition:
        return 'Condition de plante';
      case NotificationType.recommendation:
        return 'Recommandation';
      case NotificationType.reminder:
        return 'Rappel';
      case NotificationType.criticalCondition:
        return 'Condition critique';
      case NotificationType.optimalCondition:
        return 'Condition optimale';
    }
  }

  /// Description du type
  String get description {
    switch (this) {
      case NotificationType.weatherAlert:
        return 'Alerte concernant les conditions météorologiques';
      case NotificationType.plantCondition:
        return 'État général de santé d\'une plante';
      case NotificationType.recommendation:
        return 'Recommandation d\'action pour améliorer les conditions';
      case NotificationType.reminder:
        return 'Rappel d\'une action à effectuer';
      case NotificationType.criticalCondition:
        return 'Situation critique nécessitant une action immédiate';
      case NotificationType.optimalCondition:
        return 'Conditions optimales détectées';
    }
  }

  /// Icône associée
  String get icon {
    switch (this) {
      case NotificationType.weatherAlert:
        return '🌤️';
      case NotificationType.plantCondition:
        return '🌱';
      case NotificationType.recommendation:
        return '💡';
      case NotificationType.reminder:
        return '⏰';
      case NotificationType.criticalCondition:
        return '🚨';
      case NotificationType.optimalCondition:
        return '✨';
    }
  }

  /// Couleur en hexadécimal
  String get colorHex {
    switch (this) {
      case NotificationType.weatherAlert:
        return '#2196F3'; // Bleu
      case NotificationType.plantCondition:
        return '#4CAF50'; // Vert
      case NotificationType.recommendation:
        return '#FF9800'; // Orange
      case NotificationType.reminder:
        return '#9C27B0'; // Violet
      case NotificationType.criticalCondition:
        return '#F44336'; // Rouge
      case NotificationType.optimalCondition:
        return '#00BCD4'; // Cyan
    }
  }
}

/// Extensions pour les priorités de notification
extension NotificationPriorityExtension on NotificationPriority {
  /// Nom d'affichage en français
  String get displayName {
    switch (this) {
      case NotificationPriority.low:
        return 'Faible';
      case NotificationPriority.medium:
        return 'Moyenne';
      case NotificationPriority.high:
        return 'Élevée';
      case NotificationPriority.critical:
        return 'Critique';
    }
  }

  /// Description de la priorité
  String get description {
    switch (this) {
      case NotificationPriority.low:
        return 'Information générale, pas d\'urgence';
      case NotificationPriority.medium:
        return 'À traiter dans les prochains jours';
      case NotificationPriority.high:
        return 'Nécessite une attention rapide';
      case NotificationPriority.critical:
        return 'Action immédiate requise';
    }
  }

  /// Score numérique pour le tri
  int get score {
    switch (this) {
      case NotificationPriority.low:
        return 1;
      case NotificationPriority.medium:
        return 2;
      case NotificationPriority.high:
        return 3;
      case NotificationPriority.critical:
        return 4;
    }
  }

  /// Icône associée
  String get icon {
    switch (this) {
      case NotificationPriority.low:
        return '📗';
      case NotificationPriority.medium:
        return '📙';
      case NotificationPriority.high:
        return '📕';
      case NotificationPriority.critical:
        return '🚨';
    }
  }

  /// Couleur en hexadécimal
  String get colorHex {
    switch (this) {
      case NotificationPriority.low:
        return '#4CAF50'; // Vert
      case NotificationPriority.medium:
        return '#FF9800'; // Orange
      case NotificationPriority.high:
        return '#FF5722'; // Rouge-orange
      case NotificationPriority.critical:
        return '#F44336'; // Rouge
    }
  }
}

/// Extensions pour les statuts de notification
extension NotificationStatusExtension on NotificationStatus {
  /// Nom d'affichage en français
  String get displayName {
    switch (this) {
      case NotificationStatus.unread:
        return 'Non lue';
      case NotificationStatus.read:
        return 'Lue';
      case NotificationStatus.archived:
        return 'Archivée';
      case NotificationStatus.dismissed:
        return 'Ignorée';
    }
  }

  /// Icône associée
  String get icon {
    switch (this) {
      case NotificationStatus.unread:
        return '🔔';
      case NotificationStatus.read:
        return '✅';
      case NotificationStatus.archived:
        return '📦';
      case NotificationStatus.dismissed:
        return '🚫';
    }
  }
}

/// Extensions pour NotificationAlert
extension NotificationAlertExtension on NotificationAlert {
  /// Détermine si la notification est non lue
  bool get isUnread => status == NotificationStatus.unread;

  /// Détermine si la notification est urgente
  bool get isUrgent =>
      priority == NotificationPriority.critical ||
      priority == NotificationPriority.high;

  /// Détermine si la notification est critique
  bool get isCritical =>
      priority == NotificationPriority.critical ||
      type == NotificationType.criticalCondition;

  /// Détermine si la notification est active (non archivée, non ignorée)
  bool get isActive =>
      status != NotificationStatus.archived &&
      status != NotificationStatus.dismissed;

  /// Calcule l'âge de la notification
  Duration get age => DateTime.now().difference(createdAt);

  /// Formate l'âge en texte lisible
  String get ageText {
    final age = this.age;

    if (age.inDays > 0) {
      return '${age.inDays} jour${age.inDays > 1 ? 's' : ''}';
    } else if (age.inHours > 0) {
      return '${age.inHours} heure${age.inHours > 1 ? 's' : ''}';
    } else if (age.inMinutes > 0) {
      return '${age.inMinutes} minute${age.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }

  /// Marque la notification comme lue
  NotificationAlert markAsRead() {
    return copyWith(
      status: NotificationStatus.read,
      readAt: DateTime.now(),
    );
  }

  /// Archive la notification
  NotificationAlert archive() {
    return copyWith(
      status: NotificationStatus.archived,
      archivedAt: DateTime.now(),
    );
  }

  /// Ignore la notification
  NotificationAlert dismiss() {
    return copyWith(
      status: NotificationStatus.dismissed,
      dismissedAt: DateTime.now(),
    );
  }

  /// Score de priorité composite (pour le tri)
  int get priorityScore {
    int baseScore = priority.score * 100;

    // Bonus pour les types critiques
    if (type == NotificationType.criticalCondition) {
      baseScore += 50;
    } else if (type == NotificationType.weatherAlert) {
      baseScore += 25;
    }

    // Malus pour l'âge (les anciennes notifications sont moins prioritaires)
    final daysPenalty = age.inDays * 5;

    return baseScore - daysPenalty;
  }
}


