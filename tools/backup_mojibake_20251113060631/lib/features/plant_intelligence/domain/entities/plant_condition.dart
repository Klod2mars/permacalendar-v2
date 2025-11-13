import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_condition.freezed.dart';
part 'plant_condition.g.dart';

/// État des conditions d'une plante
enum ConditionStatus {
  optimal,
  excellent,
  good,
  suboptimal,
  fair,
  poor,
  critical,
}

/// Types de conditions mesurées
enum ConditionType {
  temperature,
  humidity,
  light,
  soil,
  wind,
  water,
}

/// Modèle des conditions d'une plante
@freezed
class PlantCondition with _$PlantCondition {
  const factory PlantCondition({
    /// Identifiant unique de la condition
    required String id,

    /// ID de la plante concernée
    required String plantId,

    /// ID du jardin (pour le multi-garden)
    required String gardenId,

    /// Type de condition mesurée
    required ConditionType type,

    /// Statut actuel de la condition
    required ConditionStatus status,

    /// Valeur numérique de la condition (0-100)
    required double value,

    /// Valeur optimale pour cette plante
    required double optimalValue,

    /// Valeur minimale acceptable
    required double minValue,

    /// Valeur maximale acceptable
    required double maxValue,

    /// Unité de mesure (C°, %, lux, etc.)
    required String unit,

    /// Description de la condition
    String? description,

    /// Recommandations pour améliorer cette condition
    List<String>? recommendations,

    /// Date de la mesure
    required DateTime measuredAt,

    /// Date de création
    DateTime? createdAt,

    /// Date de dernière mise à jour
    DateTime? updatedAt,
  }) = _PlantCondition;

  factory PlantCondition.fromJson(Map<String, dynamic> json) =>
      _$PlantConditionFromJson(json);
}

/// Extension pour ajouter des méthodes utilitaires
extension PlantConditionExtension on PlantCondition {
  /// Calcule le score de santé basé sur la condition (0-100)
  double get healthScore {
    if (value >= minValue && value <= maxValue) {
      // Si dans la plage acceptable, calculer la proximité avec la valeur optimale
      final distanceFromOptimal = (value - optimalValue).abs();
      final maxDistance = (maxValue - minValue) / 2;
      final score = 100 - (distanceFromOptimal / maxDistance) * 50;
      return score.clamp(0, 100);
    } else {
      // Si hors plage acceptable, score dégradé
      final distanceFromRange =
          value < minValue ? minValue - value : value - maxValue;
      final maxDeviation = (maxValue - minValue) * 2;
      final penalty = (distanceFromRange / maxDeviation) * 100;
      return (50 - penalty).clamp(0, 50);
    }
  }

  /// Détermine si la condition est critique
  bool get isCritical => status == ConditionStatus.critical;

  /// Détermine si la condition est optimale
  bool get isOptimal => status == ConditionStatus.optimal;

  /// Détermine si la condition est excellente
  bool get isExcellent => status == ConditionStatus.excellent;

  /// Détermine si la condition nécessite une attention immédiate
  bool get needsAttention =>
      status == ConditionStatus.poor || status == ConditionStatus.critical;

  /// Calcule la tendance de la condition (basée sur l'historique)
  String get trend {
    // Cette méthode pourrait être étendue pour analyser l'historique
    switch (status) {
      case ConditionStatus.optimal:
        return 'stable';
      case ConditionStatus.excellent:
        return 'stable';
      case ConditionStatus.good:
        return 'stable';
      case ConditionStatus.suboptimal:
        return 'stable';
      case ConditionStatus.fair:
        return 'déclinant';
      case ConditionStatus.poor:
        return 'déclinant';
      case ConditionStatus.critical:
        return 'critique';
    }
  }

  /// Retourne la couleur associée au statut
  String get statusColor {
    switch (status) {
      case ConditionStatus.optimal:
        return '#00C853'; // Vert foncé
      case ConditionStatus.excellent:
        return '#4CAF50'; // Vert
      case ConditionStatus.good:
        return '#8BC34A'; // Vert clair
      case ConditionStatus.suboptimal:
        return '#CDDC39'; // Lime
      case ConditionStatus.fair:
        return '#FFC107'; // Jaune
      case ConditionStatus.poor:
        return '#FF9800'; // Orange
      case ConditionStatus.critical:
        return '#F44336'; // Rouge
    }
  }

  /// Retourne l'icône associée au type de condition
  String get typeIcon {
    switch (type) {
      case ConditionType.temperature:
        return 'thermostat';
      case ConditionType.humidity:
        return 'water_drop';
      case ConditionType.light:
        return 'light_mode';
      case ConditionType.soil:
        return 'terrain';
      case ConditionType.wind:
        return 'air';
      case ConditionType.water:
        return 'water';
    }
  }

  /// Retourne le nom du type de condition en français
  String get typeName {
    switch (type) {
      case ConditionType.temperature:
        return 'Température';
      case ConditionType.humidity:
        return 'Humidité';
      case ConditionType.light:
        return 'Lumière';
      case ConditionType.soil:
        return 'Sol';
      case ConditionType.wind:
        return 'Vent';
      case ConditionType.water:
        return 'Eau';
    }
  }

  /// Retourne le nom du statut en français
  String get statusName {
    switch (status) {
      case ConditionStatus.optimal:
        return 'Optimal';
      case ConditionStatus.excellent:
        return 'Excellent';
      case ConditionStatus.good:
        return 'Bon';
      case ConditionStatus.suboptimal:
        return 'Sous-optimal';
      case ConditionStatus.fair:
        return 'Correct';
      case ConditionStatus.poor:
        return 'Mauvais';
      case ConditionStatus.critical:
        return 'Critique';
    }
  }
}


