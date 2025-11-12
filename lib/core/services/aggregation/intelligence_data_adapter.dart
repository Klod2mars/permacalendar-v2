import 'dart:developer' as developer;
import '../../../features/plant_intelligence/domain/repositories/plant_intelligence_repository.dart';
import '../../models/unified_garden_context.dart';
import 'data_adapter.dart';

/// Adaptateur pour le système Intelligence Végétale (PlantIntelligenceRepository)
///
/// Permet au Garden Aggregation Hub d'accéder aux données d'Intelligence
/// (contextes jardins, recommandations, alertes) de manière unifiée.
///
/// **Priorité : BASSE** - Utilisé en fallback pour enrichir les données
class IntelligenceDataAdapter implements DataAdapter {
  final PlantIntelligenceRepository _intelligenceRepository;

  static const String _logName = 'IntelligenceDataAdapter';

  IntelligenceDataAdapter({
    required PlantIntelligenceRepository intelligenceRepository,
  }) : _intelligenceRepository = intelligenceRepository;

  @override
  String get adapterName => 'Intelligence';

  @override
  int get priority => 1; // Priorité BASSE : Modern > Legacy > Intelligence

  @override
  Future<bool> isAvailable() async {
    try {
      // Vérifier que le repository Intelligence est accessible
      final isHealthy = await _intelligenceRepository.isHealthy();
      return isHealthy;
    } catch (e) {
      developer.log(
        'Intelligence data adapter non disponible: $e',
        name: _logName,
        level: 900,
      );
      return false;
    }
  }

  @override
  Future<UnifiedGardenContext?> getGardenContext(String gardenId) async {
    try {
      developer.log(
        'Récupération contexte jardin Intelligence pour $gardenId',
        name: _logName,
        level: 500,
      );

      // Récupérer le contexte depuis PlantIntelligenceRepository
      final gardenContext =
          await _intelligenceRepository.getGardenContext(gardenId);
      if (gardenContext == null) {
        return null;
      }

      // Récupérer les plantes du jardin
      final gardenPlants =
          await _intelligenceRepository.getGardenPlants(gardenId);

      // Convertir en UnifiedPlantData
      final plants = gardenPlants
          .map((plant) => UnifiedPlantData(
                plantId: plant.id,
                commonName: plant.commonName,
                scientificName: plant.scientificName,
                family: plant.family,
                variety: plant.varieties?['recommended']?.toString() ?? '',
                plantingSeason: [plant.plantingSeason],
                harvestSeason: [plant.harvestSeason],
                growthCycle: plant.growth?['cycle']?.toString() ?? '',
                sunExposure: plant.sunExposure,
                waterNeeds: plant.waterNeeds,
                soilType: plant.metadata['soilType']?.toString() ?? '',
                spacingInCm: plant.spacing.toDouble(),
                depthInCm: plant.depth,
                companionPlants:
                    (plant.companionPlanting?['good'] as List<dynamic>?)
                        ?.map((e) => e.toString())
                        .join(', '),
                incompatiblePlants:
                    (plant.companionPlanting?['bad'] as List<dynamic>?)
                        ?.map((e) => e.toString())
                        .join(', '),
                diseases:
                    (plant.biologicalControl?['diseases'] as List<dynamic>?)
                        ?.map((e) => e.toString())
                        .join(', '),
                pests: (plant.biologicalControl?['pests'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .join(', '),
                benefits: plant.metadata['benefits']?.toString() ?? '',
                notes: plant.metadata['notes']?.toString(),
                imageUrl: plant.metadata['imageUrl']?.toString(),
                source: DataSource.intelligence,
                createdAt: plant.createdAt ?? DateTime.now(),
                updatedAt: plant.updatedAt ?? DateTime.now(),
              ))
          .toList();

      // Récupérer les statistiques enrichies avec les données IA
      final stats = await _calculateIntelligenceStats(gardenId, gardenContext);

      developer.log(
        'Contexte Intelligence créé: ${plants.length} plantes, ${stats.activeRecommendations} recommandations',
        name: _logName,
        level: 500,
      );

      return UnifiedGardenContext(
        gardenId: gardenContext.gardenId,
        name: gardenContext.name,
        description: gardenContext.description,
        location: gardenContext.location.address,
        totalArea: gardenContext.stats.totalArea,
        activePlants: plants,
        historicalPlants: [],
        stats: stats,
        soil: _convertSoilInfo(gardenContext),
        climate: _convertClimate(gardenContext),
        preferences: _convertPreferences(gardenContext),
        recentActivities: [],
        primarySource: DataSource.intelligence,
        createdAt: gardenContext.createdAt ?? DateTime.now(),
        updatedAt: gardenContext.updatedAt ?? DateTime.now(),
        metadata: {
          'source': 'intelligence',
          'adapter': adapterName,
          'activePlantIds': gardenContext.activePlantIds,
          'historicalPlantIds': gardenContext.historicalPlantIds,
        },
      );
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la récupération du contexte Intelligence',
        name: _logName,
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      throw DataAdapterException(
        'Impossible de récupérer le contexte jardin depuis Intelligence',
        adapterName,
        originalError: e,
      );
    }
  }

  @override
  Future<List<UnifiedPlantData>> getActivePlants(String gardenId) async {
    try {
      final gardenPlants =
          await _intelligenceRepository.getGardenPlants(gardenId);

      return gardenPlants
          .map((plant) => UnifiedPlantData(
                plantId: plant.id,
                commonName: plant.commonName,
                scientificName: plant.scientificName,
                family: plant.family,
                variety: plant.varieties?['recommended']?.toString() ?? '',
                plantingSeason: [plant.plantingSeason],
                harvestSeason: [plant.harvestSeason],
                growthCycle: plant.growth?['cycle']?.toString() ?? '',
                sunExposure: plant.sunExposure,
                waterNeeds: plant.waterNeeds,
                soilType: plant.metadata['soilType']?.toString() ?? '',
                spacingInCm: plant.spacing.toDouble(),
                depthInCm: plant.depth,
                companionPlants:
                    (plant.companionPlanting?['good'] as List<dynamic>?)
                        ?.map((e) => e.toString())
                        .join(', '),
                incompatiblePlants:
                    (plant.companionPlanting?['bad'] as List<dynamic>?)
                        ?.map((e) => e.toString())
                        .join(', '),
                diseases:
                    (plant.biologicalControl?['diseases'] as List<dynamic>?)
                        ?.map((e) => e.toString())
                        .join(', '),
                pests: (plant.biologicalControl?['pests'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .join(', '),
                benefits: plant.metadata['benefits']?.toString() ?? '',
                notes: plant.metadata['notes']?.toString(),
                imageUrl: plant.metadata['imageUrl']?.toString(),
                source: DataSource.intelligence,
                createdAt: plant.createdAt ?? DateTime.now(),
                updatedAt: plant.updatedAt ?? DateTime.now(),
              ))
          .toList();
    } catch (e) {
      developer.log(
        'Erreur lors de la récupération des plantes Intelligence',
        name: _logName,
        level: 1000,
        error: e,
      );
      return [];
    }
  }

  @override
  Future<List<UnifiedPlantData>> getHistoricalPlants(String gardenId) async {
    // Non implémenté pour Intelligence
    return [];
  }

  @override
  Future<UnifiedPlantData?> getPlantById(String plantId) async {
    // Non implémenté pour Intelligence (pas d'accès direct par ID)
    return null;
  }

  @override
  Future<UnifiedGardenStats?> getGardenStats(String gardenId) async {
    try {
      final gardenContext =
          await _intelligenceRepository.getGardenContext(gardenId);
      if (gardenContext == null) return null;

      return await _calculateIntelligenceStats(gardenId, gardenContext);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<UnifiedActivityHistory>> getRecentActivities(
    String gardenId, {
    int limit = 20,
  }) async {
    // Non implémenté pour Intelligence
    return [];
  }

  // ==================== MÉTHODES PRIVÉES ====================

  /// Calcule les statistiques enrichies avec les données d'Intelligence
  Future<UnifiedGardenStats> _calculateIntelligenceStats(
    String gardenId,
    dynamic gardenContext,
  ) async {
    try {
      // Récupérer le nombre de recommandations actives
      int activeRecommendations = 0;
      int activeAlerts = 0;
      double averageHealth = 0.0;

      // Compter les recommandations actives pour toutes les plantes du jardin
      try {
        final activePlantIds = gardenContext.activePlantIds as List<String>;
        for (final plantId in activePlantIds) {
          final recommendations =
              await _intelligenceRepository.getActiveRecommendations(
            plantId: plantId,
            limit: 100,
          );
          activeRecommendations += recommendations.length;
        }

        // Compter les alertes actives
        final alerts =
            await _intelligenceRepository.getActiveAlerts(gardenId: gardenId);
        activeAlerts = alerts.length;

        // Calculer la santé moyenne (TODO: implémenter quand disponible)
        averageHealth = 75.0; // Valeur temporaire
      } catch (e) {
        developer.log(
          'Erreur lors du calcul des métriques IA: $e',
          name: _logName,
          level: 900,
        );
      }

      final stats = gardenContext.stats;
      return UnifiedGardenStats(
        totalPlants: stats.totalPlants,
        activePlants: stats.activePlants,
        historicalPlants: gardenContext.historicalPlantIds.length,
        totalArea: stats.totalArea,
        activeArea: stats.activeArea,
        totalBeds: 0, // Non disponible dans Intelligence
        activeBeds: 0, // Non disponible dans Intelligence
        plantingsThisYear: stats.plantingsThisYear,
        harvestsThisYear: stats.harvestsThisYear,
        successRate: stats.successRate,
        totalYield: stats.totalYield,
        currentYearYield: stats.currentYearYield,
        averageHealth: averageHealth, // Enrichi par IA
        activeRecommendations: activeRecommendations, // Enrichi par IA
        activeAlerts: activeAlerts, // Enrichi par IA
      );
    } catch (e) {
      developer.log(
        'Erreur lors du calcul des stats Intelligence',
        name: _logName,
        level: 1000,
        error: e,
      );
      return _getDefaultStats();
    }
  }

  /// Convertit les informations de sol du contexte Intelligence
  UnifiedSoilInfo _convertSoilInfo(dynamic gardenContext) {
    final soil = gardenContext.soil;
    return UnifiedSoilInfo(
      type: soil.type.toString().split('.').last,
      ph: soil.ph,
      texture: soil.texture.toString().split('.').last,
      organicMatter: soil.organicMatter,
      waterRetention: soil.waterRetention,
      drainage: soil.drainage.toString().split('.').last,
      depth: soil.depth,
      nutrients: {
        'nitrogen': soil.nutrients.nitrogen.toString().split('.').last,
        'phosphorus': soil.nutrients.phosphorus.toString().split('.').last,
        'potassium': soil.nutrients.potassium.toString().split('.').last,
      },
    );
  }

  /// Convertit les conditions climatiques du contexte Intelligence
  UnifiedClimate _convertClimate(dynamic gardenContext) {
    final climate = gardenContext.climate;
    return UnifiedClimate(
      averageTemperature: climate.averageTemperature,
      minTemperature: climate.minTemperature,
      maxTemperature: climate.maxTemperature,
      averagePrecipitation: climate.averagePrecipitation,
      averageHumidity: climate.averageHumidity,
      frostDays: climate.frostDays,
      growingSeasonLength: climate.growingSeasonLength,
      dominantWindDirection: climate.dominantWindDirection,
      averageWindSpeed: climate.averageWindSpeed,
      averageSunshineHours: climate.averageSunshineHours,
      usdaZone: gardenContext.location.usdaZone,
      climateType: 'Temperate',
    );
  }

  /// Convertit les préférences de culture du contexte Intelligence
  UnifiedCultivationPreferences _convertPreferences(dynamic gardenContext) {
    final prefs = gardenContext.preferences;
    return UnifiedCultivationPreferences(
      method: prefs.method.toString().split('.').last,
      usePesticides: prefs.usePesticides,
      useChemicalFertilizers: prefs.useChemicalFertilizers,
      useOrganicFertilizers: prefs.useOrganicFertilizers,
      cropRotation: prefs.cropRotation,
      companionPlanting: prefs.companionPlanting,
      mulching: prefs.mulching,
      automaticIrrigation: prefs.automaticIrrigation,
      regularMonitoring: prefs.regularMonitoring,
      objectives: prefs.objectives,
    );
  }

  UnifiedGardenStats _getDefaultStats() {
    return const UnifiedGardenStats(
      totalPlants: 0,
      activePlants: 0,
      historicalPlants: 0,
      totalArea: 0.0,
      activeArea: 0.0,
      totalBeds: 0,
      activeBeds: 0,
      plantingsThisYear: 0,
      harvestsThisYear: 0,
      successRate: 0.0,
      totalYield: 0.0,
      currentYearYield: 0.0,
      averageHealth: 0.0,
      activeRecommendations: 0,
      activeAlerts: 0,
    );
  }
}

