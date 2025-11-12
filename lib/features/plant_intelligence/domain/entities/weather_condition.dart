import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_condition.freezed.dart';
part 'weather_condition.g.dart';

/// Types de conditions météorologiques
enum WeatherType {
  temperature,
  humidity,
  precipitation,
  windSpeed,
  windDirection,
  pressure,
  cloudCover,
  uvIndex,
  visibility,
}

/// Modèle des conditions météorologiques
@freezed
class WeatherCondition with _$WeatherCondition {
  const factory WeatherCondition({
    /// Identifiant unique de la condition météo
    required String id,

    /// Type de condition météorologique
    required WeatherType type,

    /// Valeur de la condition
    required double value,

    /// Unité de mesure
    required String unit,

    /// Description de la condition
    String? description,

    /// Impact sur les plantes (positif, négatif, neutre)
    WeatherImpact? impact,

    /// Date de la mesure
    required DateTime measuredAt,

    /// Coordonnées géographiques (latitude)
    double? latitude,

    /// Coordonnées géographiques (longitude)
    double? longitude,

    /// Date de création
    DateTime? createdAt,

    /// Date de dernière mise à jour
    DateTime? updatedAt,
  }) = _WeatherCondition;

  factory WeatherCondition.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionFromJson(json);
}

/// Impact météorologique sur les plantes
@freezed
class WeatherImpact with _$WeatherImpact {
  const factory WeatherImpact({
    /// Type d'impact
    required ImpactType type,

    /// Intensité de l'impact (0-100)
    required double intensity,

    /// Description de l'impact
    required String description,

    /// Plantes affectées
    List<String>? affectedPlants,

    /// Recommandations pour atténuer l'impact
    List<String>? recommendations,

    /// Durée estimée de l'impact
    Duration? duration,
  }) = _WeatherImpact;

  factory WeatherImpact.fromJson(Map<String, dynamic> json) =>
      _$WeatherImpactFromJson(json);
}

/// Types d'impact météorologique
enum ImpactType {
  beneficial,
  harmful,
  neutral,
  stress,
  growth,
  flowering,
  fruiting,
  disease,
  pest,
}

/// Extension pour ajouter des méthodes utilitaires
extension WeatherConditionExtension on WeatherCondition {
  /// Détermine si la condition est favorable aux plantes
  bool get isFavorable => impact?.type == ImpactType.beneficial;

  /// Détermine si la condition est nuisible aux plantes
  bool get isHarmful => impact?.type == ImpactType.harmful;

  /// Détermine si la condition peut causer du stress
  bool get canCauseStress => impact?.type == ImpactType.stress;

  /// Retourne la couleur associée au type d'impact
  String get impactColor {
    switch (impact?.type) {
      case ImpactType.beneficial:
        return '#4CAF50'; // Vert
      case ImpactType.harmful:
        return '#F44336'; // Rouge
      case ImpactType.neutral:
        return '#9E9E9E'; // Gris
      case ImpactType.stress:
        return '#FF9800'; // Orange
      case ImpactType.growth:
        return '#8BC34A'; // Vert clair
      case ImpactType.flowering:
        return '#E91E63'; // Rose
      case ImpactType.fruiting:
        return '#FF5722'; // Rouge orange
      case ImpactType.disease:
        return '#9C27B0'; // Violet
      case ImpactType.pest:
        return '#795548'; // Brun
      case null:
        return '#9E9E9E'; // Gris par défaut
    }
  }

  /// Retourne l'icône associée au type de condition
  String get typeIcon {
    switch (type) {
      case WeatherType.temperature:
        return 'thermostat';
      case WeatherType.humidity:
        return 'water_drop';
      case WeatherType.precipitation:
        return 'rainy';
      case WeatherType.windSpeed:
        return 'air';
      case WeatherType.windDirection:
        return 'navigation';
      case WeatherType.pressure:
        return 'speed';
      case WeatherType.cloudCover:
        return 'cloud';
      case WeatherType.uvIndex:
        return 'wb_sunny';
      case WeatherType.visibility:
        return 'visibility';
    }
  }

  /// Retourne le nom du type en français
  String get typeName {
    switch (type) {
      case WeatherType.temperature:
        return 'Température';
      case WeatherType.humidity:
        return 'Humidité';
      case WeatherType.precipitation:
        return 'Précipitations';
      case WeatherType.windSpeed:
        return 'Vitesse du vent';
      case WeatherType.windDirection:
        return 'Direction du vent';
      case WeatherType.pressure:
        return 'Pression';
      case WeatherType.cloudCover:
        return 'Couverture nuageuse';
      case WeatherType.uvIndex:
        return 'Index UV';
      case WeatherType.visibility:
        return 'Visibilité';
    }
  }
}

/// Extension pour WeatherImpact
extension WeatherImpactExtension on WeatherImpact {
  /// Détermine si l'impact est significatif
  bool get isSignificant => intensity >= 50;

  /// Détermine si l'impact est critique
  bool get isCritical => intensity >= 80;

  /// Retourne le nom du type d'impact en français
  String get typeName {
    switch (type) {
      case ImpactType.beneficial:
        return 'Bénéfique';
      case ImpactType.harmful:
        return 'Nuisible';
      case ImpactType.neutral:
        return 'Neutre';
      case ImpactType.stress:
        return 'Stress';
      case ImpactType.growth:
        return 'Croissance';
      case ImpactType.flowering:
        return 'Floraison';
      case ImpactType.fruiting:
        return 'Fructification';
      case ImpactType.disease:
        return 'Maladie';
      case ImpactType.pest:
        return 'Ravageur';
    }
  }
}


