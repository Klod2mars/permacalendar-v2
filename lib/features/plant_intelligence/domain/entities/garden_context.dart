import 'package:freezed_annotation/freezed_annotation.dart';

part 'garden_context.freezed.dart';
part 'garden_context.g.dart';

/// Modèle du contexte du jardin
@freezed
class GardenContext with _$GardenContext {
  const factory GardenContext({
    /// Identifiant unique du jardin
    required String gardenId,

    /// Nom du jardin
    required String name,

    /// Description du jardin
    String? description,

    /// Emplacement du jardin
    required GardenLocation location,

    /// Conditions climatiques générales
    required ClimateConditions climate,

    /// Informations sur le sol
    required SoilInfo soil,

    /// Plantes actuellement dans le jardin
    required List<String> activePlantIds,

    /// Historique des plantations
    required List<String> historicalPlantIds,

    /// Statistiques du jardin
    required GardenStats stats,

    /// Préférences de culture
    required CultivationPreferences preferences,

    /// Date de création
    DateTime? createdAt,

    /// Date de dernière mise à jour
    DateTime? updatedAt,

    /// Métadonnées additionnelles
    @Default({}) Map<String, dynamic> metadata,
  }) = _GardenContext;

  factory GardenContext.fromJson(Map<String, dynamic> json) =>
      _$GardenContextFromJson(json);
}

/// Emplacement géographique du jardin
@freezed
class GardenLocation with _$GardenLocation {
  const factory GardenLocation({
    /// Latitude
    required double latitude,

    /// Longitude
    required double longitude,

    /// Adresse ou description de l'emplacement
    String? address,

    /// Ville
    String? city,

    /// Code postal
    String? postalCode,

    /// Pays
    String? country,

    /// Zone climatique USDA
    String? usdaZone,

    /// Altitude (en mètres)
    double? altitude,

    /// Exposition générale (N, S, E, O, etc.)
    String? exposure,
  }) = _GardenLocation;

  factory GardenLocation.fromJson(Map<String, dynamic> json) =>
      _$GardenLocationFromJson(json);
}

/// Conditions climatiques
@freezed
class ClimateConditions with _$ClimateConditions {
  const factory ClimateConditions({
    /// Température moyenne annuelle (°C)
    required double averageTemperature,

    /// Température minimale enregistrée (°C)
    required double minTemperature,

    /// Température maximale enregistrée (°C)
    required double maxTemperature,

    /// Précipitations annuelles moyennes (mm)
    required double averagePrecipitation,

    /// Humidité moyenne (%)
    required double averageHumidity,

    /// Nombre de jours de gel par an
    required int frostDays,

    /// Saison de croissance (en jours)
    required int growingSeasonLength,

    /// Vent dominant (direction)
    String? dominantWindDirection,

    /// Vitesse moyenne du vent (km/h)
    double? averageWindSpeed,

    /// Nombre d'heures d'ensoleillement par jour
    double? averageSunshineHours,
  }) = _ClimateConditions;

  factory ClimateConditions.fromJson(Map<String, dynamic> json) =>
      _$ClimateConditionsFromJson(json);
}

/// Informations sur le sol
@freezed
class SoilInfo with _$SoilInfo {
  const factory SoilInfo({
    /// Type de sol
    required SoilType type,

    /// pH du sol
    required double ph,

    /// Texture du sol
    required SoilTexture texture,

    /// Teneur en matière organique (%)
    required double organicMatter,

    /// Capacité de rétention d'eau (%)
    required double waterRetention,

    /// Drainage du sol
    required SoilDrainage drainage,

    /// Profondeur du sol (cm)
    required double depth,

    /// Teneur en nutriments
    required NutrientLevels nutrients,

    /// Activité biologique
    required BiologicalActivity biologicalActivity,

    /// Contamination éventuelle
    List<String>? contaminants,
  }) = _SoilInfo;

  factory SoilInfo.fromJson(Map<String, dynamic> json) =>
      _$SoilInfoFromJson(json);
}

/// Types de sol
enum SoilType {
  clay,
  sandy,
  loamy,
  silty,
  peaty,
  chalky,
  rocky,
}

/// Texture du sol
enum SoilTexture {
  fine,
  medium,
  coarse,
}

/// Drainage du sol
enum SoilDrainage {
  poor,
  moderate,
  good,
  excellent,
}

/// Niveaux de nutriments
@freezed
class NutrientLevels with _$NutrientLevels {
  const factory NutrientLevels({
    /// Azote (N)
    required NutrientLevel nitrogen,

    /// Phosphore (P)
    required NutrientLevel phosphorus,

    /// Potassium (K)
    required NutrientLevel potassium,

    /// Calcium (Ca)
    required NutrientLevel calcium,

    /// Magnésium (Mg)
    required NutrientLevel magnesium,

    /// Soufre (S)
    required NutrientLevel sulfur,

    /// Micronutriments
    @Default({}) Map<String, NutrientLevel> micronutrients,
  }) = _NutrientLevels;

  factory NutrientLevels.fromJson(Map<String, dynamic> json) =>
      _$NutrientLevelsFromJson(json);
}

/// Niveau d'un nutriment
enum NutrientLevel {
  deficient,
  low,
  adequate,
  high,
  excessive,
}

/// Activité biologique du sol
enum BiologicalActivity {
  veryLow,
  low,
  moderate,
  high,
  veryHigh,
}

/// Statistiques du jardin
@freezed
class GardenStats with _$GardenStats {
  const factory GardenStats({
    /// Nombre total de plantes
    required int totalPlants,

    /// Nombre de plantes actives
    required int activePlants,

    /// Surface totale cultivée (m²)
    required double totalArea,

    /// Surface cultivée actuellement (m²)
    required double activeArea,

    /// Rendement total (kg)
    required double totalYield,

    /// Rendement de l'année courante (kg)
    required double currentYearYield,

    /// Nombre de récoltes cette année
    required int harvestsThisYear,

    /// Nombre de plantations cette année
    required int plantingsThisYear,

    /// Taux de réussite (%)
    required double successRate,

    /// Coût total des intrants (€)
    required double totalInputCosts,

    /// Valeur totale des récoltes (€)
    required double totalHarvestValue,
  }) = _GardenStats;

  factory GardenStats.fromJson(Map<String, dynamic> json) =>
      _$GardenStatsFromJson(json);
}

/// Préférences de culture
@freezed
class CultivationPreferences with _$CultivationPreferences {
  const factory CultivationPreferences({
    /// Méthode de culture préférée
    required CultivationMethod method,

    /// Utilisation de pesticides
    required bool usePesticides,

    /// Utilisation d'engrais chimiques
    required bool useChemicalFertilizers,

    /// Utilisation d'engrais organiques
    required bool useOrganicFertilizers,

    /// Rotation des cultures
    required bool cropRotation,

    /// Association de plantes
    required bool companionPlanting,

    /// Paillage
    required bool mulching,

    /// Irrigation automatique
    required bool automaticIrrigation,

    /// Surveillance régulière
    required bool regularMonitoring,

    /// Objectifs de culture
    required List<String> objectives,
  }) = _CultivationPreferences;

  factory CultivationPreferences.fromJson(Map<String, dynamic> json) =>
      _$CultivationPreferencesFromJson(json);
}

/// Méthodes de culture
enum CultivationMethod {
  conventional,
  organic,
  biodynamic,
  permaculture,
  agroforestry,
  hydroponic,
  aquaponic,
}

/// Extension pour ajouter des méthodes utilitaires
extension GardenContextExtension on GardenContext {
  /// Détermine si le jardin est situé dans une zone tempérée
  bool get isTemperateZone =>
      climate.averageTemperature >= 5 && climate.averageTemperature <= 25;

  /// Détermine si le jardin est situé dans une zone tropicale
  bool get isTropicalZone =>
      climate.averageTemperature > 25 && climate.averagePrecipitation > 1500;

  /// Détermine si le jardin est situé dans une zone aride
  bool get isAridZone => climate.averagePrecipitation < 250;

  /// Calcule la densité de plantation (plantes par m²)
  double get plantDensity {
    if (stats.activeArea <= 0) return 0;
    return stats.activePlants / stats.activeArea;
  }

  /// Calcule le rendement par m²
  double get yieldPerSquareMeter {
    if (stats.activeArea <= 0) return 0;
    return stats.currentYearYield / stats.activeArea;
  }

  /// Calcule la rentabilité du jardin (€/m²)
  double get profitabilityPerSquareMeter {
    if (stats.activeArea <= 0) return 0;
    final profit = stats.totalHarvestValue - stats.totalInputCosts;
    return profit / stats.activeArea;
  }

  /// Détermine si le sol est acide
  bool get isAcidicSoil => soil.ph < 6.5;

  /// Détermine si le sol est alcalin
  bool get isAlkalineSoil => soil.ph > 7.5;

  /// Détermine si le sol est neutre
  bool get isNeutralSoil => soil.ph >= 6.5 && soil.ph <= 7.5;

  /// Détermine si le jardin utilise des méthodes durables
  bool get usesSustainableMethods =>
      preferences.method == CultivationMethod.organic ||
      preferences.method == CultivationMethod.biodynamic ||
      preferences.method == CultivationMethod.permaculture;

  /// Calcule le score de santé global du jardin (0-100)
  double get overallHealthScore {
    double score = 0;

    // Score basé sur le taux de réussite (40%)
    score += stats.successRate * 0.4;

    // Score basé sur la qualité du sol (30%)
    final soilScore = _calculateSoilHealthScore();
    score += soilScore * 0.3;

    // Score basé sur la diversité des plantes (20%)
    final diversityScore = _calculateDiversityScore();
    score += diversityScore * 0.2;

    // Score basé sur les pratiques durables (10%)
    final sustainabilityScore = _calculateSustainabilityScore();
    score += sustainabilityScore * 0.1;

    return score.clamp(0, 100);
  }

  double _calculateSoilHealthScore() {
    double score = 50; // Score de base

    // Ajustement basé sur le pH
    if (isNeutralSoil) {
      score += 20;
    } else if (soil.ph >= 6.0 && soil.ph <= 8.0) score += 10;

    // Ajustement basé sur la matière organique
    if (soil.organicMatter >= 3) {
      score += 15;
    } else if (soil.organicMatter >= 1) score += 10;

    // Ajustement basé sur l'activité biologique
    switch (soil.biologicalActivity) {
      case BiologicalActivity.veryHigh:
        score += 15;
        break;
      case BiologicalActivity.high:
        score += 10;
        break;
      case BiologicalActivity.moderate:
        score += 5;
        break;
      case BiologicalActivity.low:
        score -= 5;
        break;
      case BiologicalActivity.veryLow:
        score -= 15;
        break;
    }

    return score.clamp(0, 100);
  }

  double _calculateDiversityScore() {
    if (stats.activePlants <= 1) return 0;

    // Score basé sur le nombre de plantes différentes
    final diversityRatio = stats.activePlants / stats.totalPlants;
    return (diversityRatio * 100).clamp(0, 100);
  }

  double _calculateSustainabilityScore() {
    double score = 0;

    if (usesSustainableMethods) score += 30;
    if (preferences.companionPlanting) score += 20;
    if (preferences.cropRotation) score += 20;
    if (preferences.mulching) score += 15;
    if (!preferences.usePesticides) score += 15;

    return score;
  }
}

/// Extension pour SoilInfo
extension SoilInfoExtension on SoilInfo {
  /// Détermine si le sol est fertile
  bool get isFertile =>
      organicMatter >= 2 &&
      nutrients.nitrogen != NutrientLevel.deficient &&
      nutrients.phosphorus != NutrientLevel.deficient &&
      nutrients.potassium != NutrientLevel.deficient;

  /// Détermine si le sol nécessite une amélioration
  bool get needsImprovement =>
      organicMatter < 1 ||
      ph < 6.0 ||
      ph > 8.0 ||
      drainage == SoilDrainage.poor;

  /// Retourne le nom du type de sol en français
  String get typeName {
    switch (type) {
      case SoilType.clay:
        return 'Argileux';
      case SoilType.sandy:
        return 'Sableux';
      case SoilType.loamy:
        return 'Limon';
      case SoilType.silty:
        return 'Limoneux';
      case SoilType.peaty:
        return 'Tourbeux';
      case SoilType.chalky:
        return 'Calcaire';
      case SoilType.rocky:
        return 'Rocheux';
    }
  }
}

