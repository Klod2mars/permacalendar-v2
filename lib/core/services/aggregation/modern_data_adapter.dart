import 'dart:developer' as developer;
import '../../repositories/garden_hive_repository.dart';
import '../../../features/plant_catalog/data/repositories/plant_hive_repository.dart';
import '../../models/unified_garden_context.dart';
import '../../data/hive/garden_boxes.dart';
import 'data_adapter.dart';

/// ModernDataAdapter - Sanctuary Respectful Bridge
///
/// PHILOSOPHY:
/// This adapter embodies the "Modern System" concept from PermaCalendar
/// philosophy. It MUST respect the Sanctuary principle: the Sanctuary is
/// the sacred source of truth containing real plantings from the user's garden.
///
/// FLOW:
/// Sanctuary (Reality) → Modern System (Filter) → Intelligence (Analyze)
///
/// RULE:
/// NEVER return plants from the catalog that are not actively planted
/// in the user's garden. Always filter by gardenId to respect the truth flow.
///
/// VIOLATION:
/// Returning the entire catalog instead of filtering by gardenId breaks
/// both the technical contract and the philosophical vision of PermaCalendar.
///
/// **Priorité : HAUTE** - C'est le système cible vers lequel on migre
class ModernDataAdapter implements DataAdapter {
  final GardenHiveRepository _gardenRepository;
  final PlantHiveRepository _plantRepository;

  static const String _logName = 'ModernDataAdapter';

  ModernDataAdapter({
    GardenHiveRepository? gardenRepository,
    PlantHiveRepository? plantRepository,
  })  : _gardenRepository = gardenRepository ?? GardenHiveRepository(),
        _plantRepository = plantRepository ?? PlantHiveRepository();

  @override
  String get adapterName => 'Modern';

  @override
  int get priority => 3; // Priorité HAUTE : Modern > Legacy > Intelligence

  @override
  Future<bool> isAvailable() async {
    try {
      // Vérifier que le repository Moderne est accessible
      await _gardenRepository.getAllGardens();
      return true;
    } catch (e) {
      developer.log(
        'Modern data adapter non disponible: $e',
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
        'Récupération contexte jardin Moderne pour $gardenId',
        name: _logName,
        level: 500,
      );

      // Récupérer le jardin depuis GardenHiveRepository
      final garden = await _gardenRepository.getGardenById(gardenId);
      if (garden == null) {
        return null;
      }

      // Agréger les données
      final activePlants = await getActivePlants(gardenId);
      final historicalPlants = await getHistoricalPlants(gardenId);
      final stats = await getGardenStats(gardenId);
      final recentActivities = await getRecentActivities(gardenId);

      developer.log(
        'Contexte Moderne créé: ${activePlants.length} plantes actives',
        name: _logName,
        level: 500,
      );

      return UnifiedGardenContext(
        gardenId: garden.id,
        name: garden.name,
        description: garden.description,
        location: garden.location,
        totalArea: garden.totalAreaInSquareMeters,
        activePlants: activePlants,
        historicalPlants: historicalPlants,
        stats: stats ?? _getDefaultStats(),
        soil: _getDefaultSoilInfo(),
        climate: _getDefaultClimate(),
        preferences: _getDefaultPreferences(),
        recentActivities: recentActivities,
        primarySource: DataSource.modern,
        createdAt: garden.createdAt,
        updatedAt: DateTime.now(),
        metadata: {
          'source': 'modern',
          'adapter': adapterName,
        },
      );
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la récupération du contexte Moderne',
        name: _logName,
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      throw DataAdapterException(
        'Impossible de récupérer le contexte jardin depuis Moderne',
        adapterName,
        originalError: e,
      );
    }
  }

  @override
  Future<List<UnifiedPlantData>> getActivePlants(String gardenId) async {
    try {
      developer.log(
        '🌱 Récupération plantes ACTIVES pour jardin: $gardenId (Sanctuary-Filtered)',
        name: _logName,
        level: 500,
      );

      // ✅ ÉTAPE 1 : Récupérer le jardin spécifique depuis le Sanctuaire
      final garden = GardenBoxes.getGarden(gardenId);
      if (garden == null) {
        developer.log(
          '⚠️ Jardin $gardenId non trouvé dans le Sanctuaire',
          name: _logName,
          level: 800,
        );
        return [];
      }

      // ✅ ÉTAPE 2 : Récupérer les parcelles du jardin depuis le Sanctuaire
      final beds = GardenBoxes.getGardenBeds(gardenId);
      developer.log(
        '📦 ${beds.length} parcelle(s) trouvée(s) pour jardin $gardenId',
        name: _logName,
        level: 500,
      );

      // ✅ ÉTAPE 3 : Extraire les IDs des plantes ACTIVES uniquement
      final activePlantIds = <String>{};
      for (final bed in beds) {
        final plantings = GardenBoxes.getPlantings(bed.id);
        for (final planting in plantings.where((p) => p.isActive)) {
          activePlantIds.add(planting.plantId);
        }
      }

      developer.log(
        '✅ ${activePlantIds.length} plante(s) ACTIVE(s) identifiée(s) dans le Sanctuaire',
        name: _logName,
        level: 500,
      );

      // ✅ ÉTAPE 4 : Convertir en UnifiedPlantData (enrichissement depuis le catalogue)
      final plants = <UnifiedPlantData>[];
      for (final plantId in activePlantIds) {
        final plant = await _plantRepository.getPlantById(plantId);
        if (plant != null) {
          plants.add(_convertToUnified(plant, garden));
        } else {
          developer.log(
            '⚠️ Plante $plantId présente dans Sanctuaire mais absente du catalogue',
            name: _logName,
            level: 800,
          );
        }
      }

      developer.log(
        '✅ ${plants.length} plante(s) enrichie(s) retournée(s) (Moderne - Sanctuary Filtered)',
        name: _logName,
        level: 500,
      );

      return plants;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Erreur lors de la récupération des plantes actives Moderne',
        name: _logName,
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      // Retour défensif : liste vide pour fallback vers Legacy Adapter
      return [];
    }
  }

  /// Convertit une plante du catalogue en UnifiedPlantData
  /// Enrichit avec le contexte du jardin
  UnifiedPlantData _convertToUnified(dynamic plant, dynamic garden) {
    return UnifiedPlantData(
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
      companionPlants: (plant.companionPlanting?['good'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .join(', '),
      incompatiblePlants: (plant.companionPlanting?['bad'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .join(', '),
      diseases: (plant.biologicalControl?['diseases'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .join(', '),
      pests: (plant.biologicalControl?['pests'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .join(', '),
      benefits: plant.metadata['benefits']?.toString() ?? '',
      notes: plant.metadata['notes']?.toString(),
      imageUrl: plant.metadata['imageUrl']?.toString(),
      source: DataSource.modern,
      createdAt: plant.createdAt ?? DateTime.now(),
      updatedAt: plant.updatedAt ?? DateTime.now(),
    );
  }

  @override
  Future<List<UnifiedPlantData>> getHistoricalPlants(String gardenId) async {
    // Non implémenté dans le système Moderne pour l'instant
    return [];
  }

  @override
  Future<UnifiedPlantData?> getPlantById(String plantId) async {
    try {
      final plant = await _plantRepository.getPlantById(plantId);
      if (plant == null) return null;

      return UnifiedPlantData(
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
        companionPlants: (plant.companionPlanting?['good'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .join(', '),
        incompatiblePlants: (plant.companionPlanting?['bad'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .join(', '),
        diseases: (plant.biologicalControl?['diseases'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .join(', '),
        pests: (plant.biologicalControl?['pests'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .join(', '),
        benefits: plant.metadata['benefits']?.toString() ?? '',
        notes: plant.metadata['notes']?.toString(),
        imageUrl: plant.metadata['imageUrl']?.toString(),
        source: DataSource.modern,
        createdAt: plant.createdAt ?? DateTime.now(),
        updatedAt: plant.updatedAt ?? DateTime.now(),
      );
    } catch (e) {
      developer.log(
        'Erreur lors de la récupération de la plante Moderne $plantId',
        name: _logName,
        level: 1000,
        error: e,
      );
      return null;
    }
  }

  @override
  Future<UnifiedGardenStats?> getGardenStats(String gardenId) async {
    // Statistiques non disponibles directement dans le système Moderne
    // On pourrait les calculer, mais c'est le rôle du hub d'agréger
    return _getDefaultStats();
  }

  @override
  Future<List<UnifiedActivityHistory>> getRecentActivities(
    String gardenId, {
    int limit = 20,
  }) async {
    // Les activités devraient être récupérées depuis ActivityTrackerV3
    // Pour l'instant, retourner une liste vide
    return [];
  }

  // ==================== MÉTHODES PRIVÉES ====================

  UnifiedSoilInfo _getDefaultSoilInfo() {
    return const UnifiedSoilInfo(
      type: 'Loamy',
      ph: 7.0,
      texture: 'medium',
      organicMatter: 3.0,
      waterRetention: 60.0,
      drainage: 'good',
      depth: 30.0,
      nutrients: {
        'nitrogen': 'adequate',
        'phosphorus': 'adequate',
        'potassium': 'adequate',
      },
    );
  }

  UnifiedClimate _getDefaultClimate() {
    return const UnifiedClimate(
      averageTemperature: 15.0,
      minTemperature: -5.0,
      maxTemperature: 35.0,
      averagePrecipitation: 800.0,
      averageHumidity: 70.0,
      frostDays: 30,
      growingSeasonLength: 250,
      dominantWindDirection: 'Ouest',
      averageWindSpeed: 10.0,
      averageSunshineHours: 8.0,
      usdaZone: '8b',
      climateType: 'Temperate',
    );
  }

  UnifiedCultivationPreferences _getDefaultPreferences() {
    return const UnifiedCultivationPreferences(
      method: 'permaculture',
      usePesticides: false,
      useChemicalFertilizers: false,
      useOrganicFertilizers: true,
      cropRotation: true,
      companionPlanting: true,
      mulching: true,
      automaticIrrigation: false,
      regularMonitoring: true,
      objectives: ['Production de légumes', 'Autonomie alimentaire'],
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


