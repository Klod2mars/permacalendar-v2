ï»¿/// Enums pour les conditions et recommandations du moteur d'intelligence naturelle
/// Utilisés par les entités de domaine pour typer les états et priorités
library;

/// État général d'une condition (température, humidité, etc.)
enum ConditionStatus {
  /// Conditions optimales pour la plante
  optimal,

  /// Bonnes conditions, légèrement en dessous de l'optimal
  good,

  /// Conditions sous-optimales, légèrement en dessous de good
  suboptimal,

  /// Conditions acceptables mais nécessitent une surveillance
  fair,

  /// Conditions défavorables, action recommandée
  poor,

  /// Conditions critiques, action urgente requise
  critical,
}

/// Types de recommandations possibles
enum RecommendationType {
  /// Recommandations liées à la plantation (semis, repiquage)
  planting,

  /// Recommandations d'arrosage et irrigation
  watering,

  /// Recommandations de récolte
  harvesting,

  /// Recommandations de protection (maladies, parasites, météo)
  protection,

  /// Recommandations de maintenance (taille, désherbage, fertilisation)
  maintenance,
}

/// Niveau de priorité des recommandations
enum RecommendationPriority {
  /// Priorité faible - peut être reporté
  low,

  /// Priorité moyenne - à faire dans les prochains jours
  medium,

  /// Priorité élevée - à faire rapidement
  high,

  /// Priorité urgente - action immédiate requise
  urgent,
}

/// Tendance météorologique
enum WeatherTrend {
  /// Conditions météo qui s'améliorent
  improving,

  /// Conditions météo stables
  stable,

  /// Conditions météo qui se dégradent
  deteriorating,
}

/// Types de sol
enum SoilType {
  /// Sol argileux - retient l'eau, riche en nutriments
  clay,

  /// Sol sableux - drainage rapide, se réchauffe vite
  sandy,

  /// Sol limoneux - équilibré, idéal pour la plupart des plantes
  loamy,

  /// Sol calcaire - alcalin, bon drainage
  chalky,

  /// Sol tourbeux - acide, riche en matière organique
  peaty,
}

/// Types d'exposition au soleil
enum ExposureType {
  /// Plein soleil (6+ heures de soleil direct)
  fullSun,

  /// Soleil partiel (4-6 heures de soleil direct)
  partialSun,

  /// Ombre partielle (2-4 heures de soleil direct)
  partialShade,

  /// Ombre complète (moins de 2 heures de soleil direct)
  fullShade,
}

/// Extensions pour obtenir des descriptions lisibles
extension ConditionStatusExtension on ConditionStatus {
  String get displayName {
    switch (this) {
      case ConditionStatus.optimal:
        return 'Optimal';
      case ConditionStatus.good:
        return 'Bon';
      case ConditionStatus.suboptimal:
        return 'Sous-optimal';
      case ConditionStatus.fair:
        return 'Correct';
      case ConditionStatus.poor:
        return 'Médiocre';
      case ConditionStatus.critical:
        return 'Critique';
    }
  }

  String get description {
    switch (this) {
      case ConditionStatus.optimal:
        return 'Conditions idéales pour la croissance';
      case ConditionStatus.good:
        return 'Conditions favorables, croissance normale';
      case ConditionStatus.suboptimal:
        return 'Conditions légèrement en dessous de l\'optimal';
      case ConditionStatus.fair:
        return 'Conditions acceptables, surveillance recommandée';
      case ConditionStatus.poor:
        return 'Conditions défavorables, action nécessaire';
      case ConditionStatus.critical:
        return 'Situation critique, intervention immédiate requise';
    }
  }

  /// Score numérique de 0 à 1
  double get score {
    switch (this) {
      case ConditionStatus.optimal:
        return 1.0;
      case ConditionStatus.good:
        return 0.8;
      case ConditionStatus.suboptimal:
        return 0.7;
      case ConditionStatus.fair:
        return 0.6;
      case ConditionStatus.poor:
        return 0.4;
      case ConditionStatus.critical:
        return 0.2;
    }
  }

  String get icon {
    switch (this) {
      case ConditionStatus.optimal:
        return 'ðŸŸ¢';
      case ConditionStatus.good:
        return 'ðŸ”µ';
      case ConditionStatus.suboptimal:
        return 'ðŸŸ¦';
      case ConditionStatus.fair:
        return 'ðŸŸ¡';
      case ConditionStatus.poor:
        return 'ðŸŸ ';
      case ConditionStatus.critical:
        return 'ðŸ”´';
    }
  }

  String get colorHex {
    switch (this) {
      case ConditionStatus.optimal:
        return '#4CAF50';
      case ConditionStatus.good:
        return '#2196F3';
      case ConditionStatus.suboptimal:
        return '#64B5F6';
      case ConditionStatus.fair:
        return '#FFEB3B';
      case ConditionStatus.poor:
        return '#FF9800';
      case ConditionStatus.critical:
        return '#F44336';
    }
  }
}

extension RecommendationTypeExtension on RecommendationType {
  String get displayName {
    switch (this) {
      case RecommendationType.planting:
        return 'Plantation';
      case RecommendationType.watering:
        return 'Arrosage';
      case RecommendationType.harvesting:
        return 'Récolte';
      case RecommendationType.protection:
        return 'Protection';
      case RecommendationType.maintenance:
        return 'Entretien';
    }
  }

  String get description {
    switch (this) {
      case RecommendationType.planting:
        return 'Recommandations liées à la plantation et au semis';
      case RecommendationType.watering:
        return 'Recommandations d\'arrosage et d\'irrigation';
      case RecommendationType.harvesting:
        return 'Recommandations de récolte et de cueillette';
      case RecommendationType.protection:
        return 'Recommandations de protection contre les maladies et parasites';
      case RecommendationType.maintenance:
        return 'Recommandations d\'entretien et de maintenance';
    }
  }

  String get icon {
    switch (this) {
      case RecommendationType.planting:
        return 'ðŸŒ±';
      case RecommendationType.watering:
        return 'ðŸ’§';
      case RecommendationType.harvesting:
        return 'ðŸŒ¾';
      case RecommendationType.protection:
        return 'ðŸ›¡ï¸';
      case RecommendationType.maintenance:
        return 'ðŸ”§';
    }
  }

  String get colorHex {
    switch (this) {
      case RecommendationType.planting:
        return '#4CAF50';
      case RecommendationType.watering:
        return '#2196F3';
      case RecommendationType.harvesting:
        return '#FF9800';
      case RecommendationType.protection:
        return '#F44336';
      case RecommendationType.maintenance:
        return '#9C27B0';
    }
  }
}

extension RecommendationPriorityExtension on RecommendationPriority {
  String get displayName {
    switch (this) {
      case RecommendationPriority.low:
        return 'Faible';
      case RecommendationPriority.medium:
        return 'Moyenne';
      case RecommendationPriority.high:
        return 'Haute';
      case RecommendationPriority.urgent:
        return 'Urgente';
    }
  }

  String get description {
    switch (this) {
      case RecommendationPriority.low:
        return 'Priorité faible - peut attendre';
      case RecommendationPriority.medium:
        return 'Priorité modérée - à faire dans les prochains jours';
      case RecommendationPriority.high:
        return 'Priorité importante - à faire rapidement';
      case RecommendationPriority.urgent:
        return 'Action immédiate requise';
    }
  }

  String get icon {
    switch (this) {
      case RecommendationPriority.low:
        return 'â¬‡ï¸';
      case RecommendationPriority.medium:
        return 'âž¡ï¸';
      case RecommendationPriority.high:
        return 'â¬†ï¸';
      case RecommendationPriority.urgent:
        return 'ðŸš¨';
    }
  }

  /// Score numérique pour le tri
  double get score {
    switch (this) {
      case RecommendationPriority.low:
        return 0.25;
      case RecommendationPriority.medium:
        return 0.5;
      case RecommendationPriority.high:
        return 0.75;
      case RecommendationPriority.urgent:
        return 1.0;
    }
  }

  /// Couleur associée (hex)
  String get colorHex {
    switch (this) {
      case RecommendationPriority.low:
        return '#4CAF50'; // Vert
      case RecommendationPriority.medium:
        return '#FF9800'; // Orange
      case RecommendationPriority.high:
        return '#FF5722'; // Rouge
      case RecommendationPriority.urgent:
        return '#F44336'; // Violet
    }
  }
}

extension WeatherTrendExtension on WeatherTrend {
  String get displayName {
    switch (this) {
      case WeatherTrend.improving:
        return 'En amélioration';
      case WeatherTrend.stable:
        return 'Stable';
      case WeatherTrend.deteriorating:
        return 'En dégradation';
    }
  }

  String get description {
    switch (this) {
      case WeatherTrend.improving:
        return 'Conditions météorologiques qui s\'améliorent';
      case WeatherTrend.stable:
        return 'Conditions météorologiques stables';
      case WeatherTrend.deteriorating:
        return 'Conditions météorologiques qui se dégradent';
    }
  }

  String get icon {
    switch (this) {
      case WeatherTrend.improving:
        return 'ðŸ“ˆ';
      case WeatherTrend.stable:
        return 'âž¡ï¸';
      case WeatherTrend.deteriorating:
        return 'ðŸ“‰';
    }
  }

  String get colorHex {
    switch (this) {
      case WeatherTrend.improving:
        return '#4CAF50';
      case WeatherTrend.stable:
        return '#2196F3';
      case WeatherTrend.deteriorating:
        return '#FF5722';
    }
  }
}

extension SoilTypeExtension on SoilType {
  String get displayName {
    switch (this) {
      case SoilType.clay:
        return 'Argileux';
      case SoilType.sandy:
        return 'Sableux';
      case SoilType.loamy:
        return 'Limoneux';
      case SoilType.chalky:
        return 'Calcaire';
      case SoilType.peaty:
        return 'Tourbeux';
    }
  }

  String get description {
    switch (this) {
      case SoilType.clay:
        return 'Sol argileux, retient l\'eau, riche en nutriments';
      case SoilType.sandy:
        return 'Sol sableux, drainage rapide, nécessite plus d\'arrosage';
      case SoilType.loamy:
        return 'Sol équilibré, idéal pour la plupart des plantes';
      case SoilType.chalky:
        return 'Sol calcaire, alcalin, peut nécessiter des amendements';
      case SoilType.peaty:
        return 'Sol riche en matière organique, acide, retient l\'humidité';
    }
  }

  String get icon {
    switch (this) {
      case SoilType.clay:
        return 'ðŸŸ¤';
      case SoilType.sandy:
        return 'ðŸŸ¨';
      case SoilType.loamy:
        return 'ðŸŸ«';
      case SoilType.chalky:
        return 'âšª';
      case SoilType.peaty:
        return 'ðŸ–¤';
    }
  }

  String get colorHex {
    switch (this) {
      case SoilType.clay:
        return '#8D6E63';
      case SoilType.sandy:
        return '#FFEB3B';
      case SoilType.loamy:
        return '#795548';
      case SoilType.chalky:
        return '#FAFAFA';
      case SoilType.peaty:
        return '#424242';
    }
  }
}

extension ExposureTypeExtension on ExposureType {
  String get displayName {
    switch (this) {
      case ExposureType.fullSun:
        return 'Plein soleil';
      case ExposureType.partialSun:
        return 'Soleil partiel';
      case ExposureType.partialShade:
        return 'Ombre partielle';
      case ExposureType.fullShade:
        return 'Ombre complète';
    }
  }

  String get description {
    switch (this) {
      case ExposureType.fullSun:
        return 'Plus de 6+ heures de soleil direct par jour';
      case ExposureType.partialSun:
        return 'Entre 4-6 heures de soleil direct par jour';
      case ExposureType.partialShade:
        return 'Entre 2-4 heures de soleil direct par jour';
      case ExposureType.fullShade:
        return 'moins de 2 heures de soleil direct par jour';
    }
  }

  String get icon {
    switch (this) {
      case ExposureType.fullSun:
        return 'â˜€ï¸';
      case ExposureType.partialSun:
        return 'â›…';
      case ExposureType.partialShade:
        return 'ðŸŒ¤ï¸';
      case ExposureType.fullShade:
        return 'â˜ï¸';
    }
  }

  String get colorHex {
    switch (this) {
      case ExposureType.fullSun:
        return '#FFD700';
      case ExposureType.partialSun:
        return '#FF9800';
      case ExposureType.partialShade:
        return '#9E9E9E';
      case ExposureType.fullShade:
        return '#708090';
    }
  }

  /// Heures de soleil minimum
  double get minSunHours {
    switch (this) {
      case ExposureType.fullSun:
        return 6.0;
      case ExposureType.partialSun:
        return 4.0;
      case ExposureType.partialShade:
        return 2.0;
      case ExposureType.fullShade:
        return 0.0;
    }
  }

  /// Heures de soleil maximum
  double get maxSunHours {
    switch (this) {
      case ExposureType.fullSun:
        return 12.0;
      case ExposureType.partialSun:
        return 6.0;
      case ExposureType.partialShade:
        return 4.0;
      case ExposureType.fullShade:
        return 2.0;
    }
  }
}


