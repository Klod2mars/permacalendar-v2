import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation.freezed.dart';
part 'recommendation.g.dart';

/// Priorité des recommandations
enum RecommendationPriority {
  low,
  medium,
  high,
  critical,
}

/// Type de recommandation
enum RecommendationType {
  watering,
  fertilizing,
  pruning,
  planting,
  harvesting,
  pestControl,
  diseaseControl,
  soilImprovement,
  weatherProtection,
  general,
}

/// Statut de la recommandation
enum RecommendationStatus {
  pending,
  inProgress,
  completed,
  dismissed,
  expired,
}

/// Modèle des recommandations pour les plantes
@freezed
class Recommendation with _$Recommendation {
  const factory Recommendation({
    /// Identifiant unique de la recommandation
    required String id,

    /// ID de la plante concernée
    required String plantId,

    /// ID du jardin (pour le multi-garden)
    required String gardenId,

    /// Type de recommandation
    required RecommendationType type,

    /// Priorité de la recommandation
    required RecommendationPriority priority,

    /// Titre de la recommandation
    required String title,

    /// Description détaillée
    required String description,

    /// Instructions spécifiques
    required List<String> instructions,

    /// Raison de la recommandation
    String? reason,

    /// Impact attendu (0-100)
    required double expectedImpact,

    /// Effort requis (0-100)
    required double effortRequired,

    /// Coût estimé (0-100)
    required double estimatedCost,

    /// Durée estimée pour appliquer la recommandation
    Duration? estimatedDuration,

    /// Date limite pour appliquer la recommandation
    DateTime? deadline,

    /// Conditions météorologiques optimales
    List<String>? optimalConditions,

    /// Outils ou matériaux nécessaires
    List<String>? requiredTools,

    /// Statut actuel de la recommandation
    @Default(RecommendationStatus.pending) RecommendationStatus status,

    /// Date de Création
    DateTime? createdAt,

    /// Date de dernière mise à jour
    DateTime? updatedAt,

    /// Date de completion
    DateTime? completedAt,

    /// Notes additionnelles
    String? notes,

    /// Métadonnées flexibles
    @Default({}) Map<String, dynamic> metadata,
  }) = _Recommendation;

  factory Recommendation.fromJson(Map<String, dynamic> json) =>
      _$RecommendationFromJson(json);
}

/// Extension pour ajouter des méthodes utilitaires
extension RecommendationExtension on Recommendation {
  /// Détermine si la recommandation est urgente
  bool get isUrgent =>
      priority == RecommendationPriority.critical ||
      priority == RecommendationPriority.high;

  /// Détermine si la recommandation est en retard
  bool get isOverdue {
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline!) &&
        status != RecommendationStatus.completed;
  }

  /// Détermine si la recommandation est active (peut être appliquée)
  bool get isActive =>
      status == RecommendationStatus.pending ||
      status == RecommendationStatus.inProgress;

  /// Détermine si la recommandation est terminée
  bool get isCompleted => status == RecommendationStatus.completed;

  /// Calcule le score de priorité (plus élevé = plus prioritaire)
  int get priorityScore {
    switch (priority) {
      case RecommendationPriority.critical:
        return 4;
      case RecommendationPriority.high:
        return 3;
      case RecommendationPriority.medium:
        return 2;
      case RecommendationPriority.low:
        return 1;
    }
  }

  /// Calcule le score d'efficacité (impact vs effort)
  double get efficiencyScore {
    if (effortRequired == 0) return expectedImpact;
    return expectedImpact / effortRequired;
  }

  /// Calcule le score de rentabilité (impact vs coût)
  double get costEffectivenessScore {
    if (estimatedCost == 0) return expectedImpact;
    return expectedImpact / estimatedCost;
  }

  /// Retourne la couleur associée à la priorité
  String get priorityColor {
    switch (priority) {
      case RecommendationPriority.critical:
        return '#F44336'; // Rouge
      case RecommendationPriority.high:
        return '#FF9800'; // Orange
      case RecommendationPriority.medium:
        return '#FFC107'; // Jaune
      case RecommendationPriority.low:
        return '#4CAF50'; // Vert
    }
  }

  /// Retourne la couleur associée au statut
  String get statusColor {
    switch (status) {
      case RecommendationStatus.pending:
        return '#9E9E9E'; // Gris
      case RecommendationStatus.inProgress:
        return '#2196F3'; // Bleu
      case RecommendationStatus.completed:
        return '#4CAF50'; // Vert
      case RecommendationStatus.dismissed:
        return '#FF5722'; // Rouge orange
      case RecommendationStatus.expired:
        return '#795548'; // Brun
    }
  }

  /// Retourne l'icône associée au type
  String get typeIcon {
    switch (type) {
      case RecommendationType.watering:
        return 'water_drop';
      case RecommendationType.fertilizing:
        return 'eco';
      case RecommendationType.pruning:
        return 'content_cut';
      case RecommendationType.planting:
        return 'park';
      case RecommendationType.harvesting:
        return 'agriculture';
      case RecommendationType.pestControl:
        return 'bug_report';
      case RecommendationType.diseaseControl:
        return 'medical_services';
      case RecommendationType.soilImprovement:
        return 'terrain';
      case RecommendationType.weatherProtection:
        return 'shield';
      case RecommendationType.general:
        return 'info';
    }
  }

  /// Retourne le nom du type en français
  String get typeName {
    switch (type) {
      case RecommendationType.watering:
        return 'Arrosage';
      case RecommendationType.fertilizing:
        return 'Fertilisation';
      case RecommendationType.pruning:
        return 'Taille';
      case RecommendationType.planting:
        return 'Plantation';
      case RecommendationType.harvesting:
        return 'Récolte';
      case RecommendationType.pestControl:
        return 'Lutte contre les ravageurs';
      case RecommendationType.diseaseControl:
        return 'Lutte contre les maladies';
      case RecommendationType.soilImprovement:
        return 'Amélioration du sol';
      case RecommendationType.weatherProtection:
        return 'Protection météo';
      case RecommendationType.general:
        return 'Général';
    }
  }

  /// Retourne le nom de la priorité en français
  String get priorityName {
    switch (priority) {
      case RecommendationPriority.low:
        return 'Faible';
      case RecommendationPriority.medium:
        return 'Moyenne';
      case RecommendationPriority.high:
        return 'Élevée';
      case RecommendationPriority.critical:
        return 'Critique';
    }
  }

  /// Retourne le nom du statut en français
  String get statusName {
    switch (status) {
      case RecommendationStatus.pending:
        return 'En attente';
      case RecommendationStatus.inProgress:
        return 'En cours';
      case RecommendationStatus.completed:
        return 'Terminée';
      case RecommendationStatus.dismissed:
        return 'Ignorée';
      case RecommendationStatus.expired:
        return 'Expirée';
    }
  }

  /// Calcule le temps restant avant la deadline
  Duration? get timeRemaining {
    if (deadline == null) return null;
    final now = DateTime.now();
    if (now.isAfter(deadline!)) return Duration.zero;
    return deadline!.difference(now);
  }

  /// Formate le temps restant en texte lisible
  String get timeRemainingText {
    final remaining = timeRemaining;
    if (remaining == null) return 'Aucune deadline';
    if (remaining == Duration.zero) return 'En retard';

    final days = remaining.inDays;
    final hours = remaining.inHours % 24;

    if (days > 0) {
      return '$days jour${days > 1 ? 's' : ''} restant${days > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '$hours heure${hours > 1 ? 's' : ''} restante${hours > 1 ? 's' : ''}';
    } else {
      return 'Moins d\'une heure';
    }
  }

  /// Marque la recommandation comme en cours
  Recommendation markAsInProgress() {
    return copyWith(
      status: RecommendationStatus.inProgress,
      updatedAt: DateTime.now(),
    );
  }

  /// Marque la recommandation comme terminée
  Recommendation markAsCompleted({String? notes}) {
    return copyWith(
      status: RecommendationStatus.completed,
      completedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      notes: notes ?? this.notes,
    );
  }

  /// Ignore la recommandation
  Recommendation dismiss({String? reason}) {
    return copyWith(
      status: RecommendationStatus.dismissed,
      updatedAt: DateTime.now(),
      notes: reason ?? notes,
    );
  }
}


