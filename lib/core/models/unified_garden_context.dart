import 'package:freezed_annotation/freezed_annotation.dart';

part 'unified_garden_context.freezed.dart';
part 'unified_garden_context.g.dart';

/// Modèles unifiés pour le Garden Aggregation Hub
///
/// Ces modèles servent d'interface commune pour tous les consommateurs,
/// masquant la complexité des 3 systèmes sous-jacents (Legacy/Moderne/Intelligence).

// ==================== UNIFIED GARDEN CONTEXT ====================

/// Contexte unifié d'un jardin depuis le Hub d'Agrégation
///
/// Agrège les données des 3 systèmes :
/// - Legacy : GardenBoxes, PlantBoxes
/// - Moderne : GardenHiveRepository, PlantHiveRepository
/// - Intelligence : PlantIntelligenceRepository
@freezed
class UnifiedGardenContext with _$UnifiedGardenContext {
  const factory UnifiedGardenContext({
    required String gardenId,
    required String name,
    String? description,
    String? location,
    double? totalArea,
    required List<UnifiedPlantData> activePlants,
    required List<UnifiedPlantData> historicalPlants,
    required UnifiedGardenStats stats,
    required UnifiedSoilInfo soil,
    required UnifiedClimate climate,
    required UnifiedCultivationPreferences preferences,
    required List<UnifiedActivityHistory> recentActivities,
    required DataSource
        primarySource, // Source de données utilisée (Legacy/Moderne/Intelligence)
    required DateTime createdAt,
    required DateTime updatedAt,
    Map<String, dynamic>? metadata,
  }) = _UnifiedGardenContext;

  factory UnifiedGardenContext.fromJson(Map<String, dynamic> json) =>
      _$UnifiedGardenContextFromJson(json);
}

// ==================== UNIFIED PLANT DATA ====================

/// Données unifiées d'une plante depuis le Hub d'Agrégation
@freezed
class UnifiedPlantData with _$UnifiedPlantData {
  const factory UnifiedPlantData({
    required String plantId,
    required String commonName,
    required String scientificName,
    String? family,
    String? variety,
    required List<String> plantingSeason,
    required List<String> harvestSeason,
    String? growthCycle,
    String? sunExposure,
    String? waterNeeds,
    String? soilType,
    double? spacingInCm,
    double? depthInCm,
    String? companionPlants,
    String? incompatiblePlants,
    String? diseases,
    String? pests,
    String? benefits,
    String? notes,
    String? imageUrl,
    required DataSource source, // Source de la plante (Legacy/Moderne/Catalog)
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UnifiedPlantData;

  factory UnifiedPlantData.fromJson(Map<String, dynamic> json) =>
      _$UnifiedPlantDataFromJson(json);
}

// ==================== UNIFIED GARDEN STATS ====================

/// Statistiques unifiées d'un jardin
@freezed
class UnifiedGardenStats with _$UnifiedGardenStats {
  const factory UnifiedGardenStats({
    required int totalPlants,
    required int activePlants,
    required int historicalPlants,
    required double totalArea,
    required double activeArea,
    required int totalBeds,
    required int activeBeds,
    required int plantingsThisYear,
    required int harvestsThisYear,
    required double successRate,
    required double totalYield,
    required double currentYearYield,
    required double averageHealth, // Santé moyenne des plantes (0-100)
    required int activeRecommendations, // Recommandations IA actives
    required int activeAlerts, // Alertes IA actives
  }) = _UnifiedGardenStats;

  factory UnifiedGardenStats.fromJson(Map<String, dynamic> json) =>
      _$UnifiedGardenStatsFromJson(json);
}

// ==================== UNIFIED SOIL INFO ====================

/// Informations unifiées sur le sol
@freezed
class UnifiedSoilInfo with _$UnifiedSoilInfo {
  const factory UnifiedSoilInfo({
    required String type, // Type de sol dominant
    required double ph,
    required String texture,
    required double organicMatter,
    required double waterRetention,
    required String drainage,
    required double depth,
    required Map<String, String> nutrients,
  }) = _UnifiedSoilInfo;

  factory UnifiedSoilInfo.fromJson(Map<String, dynamic> json) =>
      _$UnifiedSoilInfoFromJson(json);
}

// ==================== UNIFIED CLIMATE ====================

/// Conditions climatiques unifiées
@freezed
class UnifiedClimate with _$UnifiedClimate {
  const factory UnifiedClimate({
    required double averageTemperature,
    required double minTemperature,
    required double maxTemperature,
    required double averagePrecipitation,
    required double averageHumidity,
    required int frostDays,
    required int growingSeasonLength,
    required String dominantWindDirection,
    required double averageWindSpeed,
    required double averageSunshineHours,
    String? usdaZone,
    String? climateType,
  }) = _UnifiedClimate;

  factory UnifiedClimate.fromJson(Map<String, dynamic> json) =>
      _$UnifiedClimateFromJson(json);
}

// ==================== UNIFIED CULTIVATION PREFERENCES ====================

/// Préférences de culture unifiées
@freezed
class UnifiedCultivationPreferences with _$UnifiedCultivationPreferences {
  const factory UnifiedCultivationPreferences({
    required String method, // permaculture, organic, conventional, etc.
    required bool usePesticides,
    required bool useChemicalFertilizers,
    required bool useOrganicFertilizers,
    required bool cropRotation,
    required bool companionPlanting,
    required bool mulching,
    required bool automaticIrrigation,
    required bool regularMonitoring,
    required List<String> objectives,
  }) = _UnifiedCultivationPreferences;

  factory UnifiedCultivationPreferences.fromJson(Map<String, dynamic> json) =>
      _$UnifiedCultivationPreferencesFromJson(json);
}

// ==================== UNIFIED ACTIVITY HISTORY ====================

/// Historique d'activités unifié
@freezed
class UnifiedActivityHistory with _$UnifiedActivityHistory {
  const factory UnifiedActivityHistory({
    required String activityId,
    required String type,
    required String description,
    required DateTime timestamp,
    String? plantId,
    String? bedId,
    Map<String, dynamic>? metadata,
  }) = _UnifiedActivityHistory;

  factory UnifiedActivityHistory.fromJson(Map<String, dynamic> json) =>
      _$UnifiedActivityHistoryFromJson(json);
}

// ==================== DATA SOURCE ENUM ====================

/// Source de données utilisée pour résoudre les informations
enum DataSource {
  legacy, // Système Legacy (GardenBoxes, PlantBoxes)
  modern, // Système Moderne (GardenHiveRepository, PlantHiveRepository)
  intelligence, // Système Intelligence (PlantIntelligenceRepository)
  aggregated, // Données agrégées depuis plusieurs sources
  fallback, // Données par défaut (aucune source disponible)
}


