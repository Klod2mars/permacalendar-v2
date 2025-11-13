import 'dart:developer' as developer;
import '../../data/hive/garden_boxes.dart';
import '../../data/hive/plant_boxes.dart';
import '../../models/unified_garden_context.dart';
import '../../models/planting.dart';
import '../plant_catalog_service.dart';
import 'data_adapter.dart';

/// Adaptateur pour le système Legacy (GardenBoxes, PlantBoxes)
///
/// Permet au Garden Aggregation Hub d'accéder aux données Legacy
/// de manière unifiée et cohérente.
class LegacyDataAdapter implements DataAdapter {
  static const String _logName = 'LegacyDataAdapter';

  @override
  String get adapterName => 'Legacy';

  @override
  int get priority => 2; // Priorité moyenne : Modern > Legacy > Intelligence

  @override
  Future<bool> isAvailable() async {
    try {
      // Vérifier que les boxes Legacy sont accessibles
      final gardens = GardenBoxes.gardens;
      final plants = PlantBoxes.plants;
      return gardens.isOpen && plants.isOpen;
    } catch (e) {
      developer.log(
        'Legacy data adapter non disponible: $e',
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
        'Récupération contexte jardin Legacy pour $gardenId',
        name: _logName,
        level: 500,
      );

      // Récupérer le jardin depuis GardenBoxes
      final garden = GardenBoxes.getGarden(gardenId);
      if (garden == null) {
        return null;
      }

      // Agréger les données
      final activePlants = await getActivePlants(gardenId);
      final historicalPlants = await getHistoricalPlants(gardenId);
      final stats = await getGardenStats(gardenId);
      final recentActivities = await getRecentActivities(gardenId);

      // Calculer les informations de sol depuis les parcelles
      final soilInfo = _calculateSoilInfo(gardenId);

      developer.log(
        'Contexte Legacy créé: ${activePlants.length} plantes actives',
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
        soil: soilInfo,
        climate: _getDefaultClimate(),
        preferences: _getDefaultPreferences(),
        recentActivities: recentActivities,
        primarySource: DataSource.legacy,
        createdAt: garden.createdAt,
        updatedAt: DateTime.now(),
        metadata: {
          'source': 'legacy',
          'adapter': adapterName,
        },
      );
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la récupération du contexte Legacy',
        name: _logName,
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      throw DataAdapterException(
        'Impossible de récupérer le contexte jardin depuis Legacy',
        adapterName,
        originalError: e,
      );
    }
  }

  @override
  Future<List<UnifiedPlantData>> getActivePlants(String gardenId) async {
    try {
      final beds = GardenBoxes.getGardenBeds(gardenId);
      final activePlantIds = <String>{};

      // Récupérer les IDs de plantes actives
      for (final bed in beds) {
        final plantings = GardenBoxes.getPlantings(bed.id);
        for (final planting in plantings.where((p) => p.isActive)) {
          activePlantIds.add(planting.plantId);
        }
      }

      developer.log(
        '🔍 AUDIT - ${activePlantIds.length} IDs de plantes actives trouvées: $activePlantIds',
        name: _logName,
        level: 500,
      );

      // ✅ CORRECTION : Utiliser PlantCatalogService au lieu de PlantBoxes
      // PlantBoxes est vide, les plantes sont dans le catalogue JSON
      final plants = <UnifiedPlantData>[];
      for (final plantId in activePlantIds) {
        try {
          developer.log(
              '🔍 AUDIT - Recherche plante $plantId dans le catalogue',
              name: _logName);

          // Utiliser PlantCatalogService pour récupérer depuis JSON
          final plant = await PlantCatalogService.getPlantById(plantId);

          if (plant != null) {
            developer.log('✅ AUDIT - Plante trouvée: ${plant.commonName}',
                name: _logName);

            plants.add(UnifiedPlantData(
              plantId: plant.id,
              commonName: plant.commonName,
              scientificName: plant.scientificName,
              family: plant.family,
              variety: plant.metadata['variety']?.toString() ?? '',
              plantingSeason: [plant.plantingSeason],
              harvestSeason: [plant.harvestSeason],
              growthCycle: plant.growth['cycle']?.toString() ?? '',
              sunExposure: plant.sunExposure,
              waterNeeds: plant.waterNeeds,
              soilType: plant.metadata['soilType']?.toString() ?? '',
              spacingInCm: plant.spacing.toDouble(),
              depthInCm: plant.depth,
              companionPlants:
                  (plant.companionPlanting['good'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .join(', '),
              incompatiblePlants:
                  (plant.companionPlanting['bad'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .join(', '),
              diseases: (plant.biologicalControl['diseases'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .join(', '),
              pests: (plant.biologicalControl['pests'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .join(', '),
              benefits: plant.metadata['benefits']?.toString() ?? '',
              notes: plant.notes,
              imageUrl: plant.imageUrl,
              source: DataSource.legacy,
              createdAt: plant.createdAt,
              updatedAt: plant.updatedAt,
            ));
          } else {
            developer.log(
                '❌ AUDIT - Plante $plantId NOT FOUND dans le catalogue',
                name: _logName);
          }
        } catch (e) {
          developer.log(
            '⚠️ AUDIT - Erreur lors de la récupération de la plante $plantId: $e',
            name: _logName,
            level: 900,
          );
        }
      }

      developer.log(
        '✅ ${plants.length} plantes actives trouvées et converties (Legacy)',
        name: _logName,
        level: 500,
      );

      return plants;
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la récupération des plantes actives Legacy',
        name: _logName,
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  @override
  Future<List<UnifiedPlantData>> getHistoricalPlants(String gardenId) async {
    try {
      final beds = GardenBoxes.getGardenBeds(gardenId);
      final activePlantIds = <String>{};
      final historicalPlantIds = <String>{};

      // Récupérer les IDs de plantes actives et historiques
      for (final bed in beds) {
        final plantings = GardenBoxes.getPlantings(bed.id);
        for (final planting in plantings) {
          if (planting.isActive) {
            activePlantIds.add(planting.plantId);
          } else {
            historicalPlantIds.add(planting.plantId);
          }
        }
      }

      // Exclure les plantes qui sont encore actives
      historicalPlantIds.removeAll(activePlantIds);

      // Convertir en UnifiedPlantData
      final plants = <UnifiedPlantData>[];
      for (final plantId in historicalPlantIds) {
        final plant = PlantBoxes.getPlant(plantId);
        if (plant != null) {
          plants.add(UnifiedPlantData(
            plantId: plant.id,
            commonName: plant.commonName,
            scientificName: plant.scientificName,
            family: plant.family,
            variety: plant.metadata['variety']?.toString() ?? '',
            plantingSeason: [plant.plantingSeason],
            harvestSeason: [plant.harvestSeason],
            growthCycle: plant.growth['cycle']?.toString() ?? '',
            sunExposure: plant.sunExposure,
            waterNeeds: plant.waterNeeds,
            soilType: plant.metadata['soilType']?.toString() ?? '',
            spacingInCm: plant.spacing,
            depthInCm: plant.depth,
            companionPlants: (plant.companionPlanting['good'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .join(', '),
            incompatiblePlants:
                (plant.companionPlanting['bad'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .join(', '),
            diseases: (plant.biologicalControl['diseases'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .join(', '),
            pests: (plant.biologicalControl['pests'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .join(', '),
            benefits: plant.metadata['benefits']?.toString() ?? '',
            notes: plant.notes,
            imageUrl: plant.imageUrl,
            source: DataSource.legacy,
            createdAt: plant.createdAt,
            updatedAt: plant.updatedAt,
          ));
        }
      }

      return plants;
    } catch (e) {
      developer.log(
        'Erreur lors de la récupération des plantes historiques Legacy',
        name: _logName,
        level: 1000,
        error: e,
      );
      return [];
    }
  }

  @override
  Future<UnifiedPlantData?> getPlantById(String plantId) async {
    try {
      final plant = PlantBoxes.getPlant(plantId);
      if (plant == null) return null;

      return UnifiedPlantData(
        plantId: plant.id,
        commonName: plant.commonName,
        scientificName: plant.scientificName,
        family: plant.family,
        variety: plant.metadata['variety']?.toString() ?? '',
        plantingSeason: [plant.plantingSeason],
        harvestSeason: [plant.harvestSeason],
        growthCycle: plant.growth['cycle']?.toString() ?? '',
        sunExposure: plant.sunExposure,
        waterNeeds: plant.waterNeeds,
        soilType: plant.metadata['soilType']?.toString() ?? '',
        spacingInCm: plant.spacing,
        depthInCm: plant.depth,
        companionPlants: (plant.companionPlanting['good'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .join(', '),
        incompatiblePlants: (plant.companionPlanting['bad'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .join(', '),
        diseases: (plant.biologicalControl['diseases'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .join(', '),
        pests: (plant.biologicalControl['pests'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .join(', '),
        benefits: plant.metadata['benefits']?.toString() ?? '',
        notes: plant.notes,
        imageUrl: plant.imageUrl,
        source: DataSource.legacy,
        createdAt: plant.createdAt,
        updatedAt: plant.updatedAt,
      );
    } catch (e) {
      developer.log(
        'Erreur lors de la récupération de la plante Legacy $plantId',
        name: _logName,
        level: 1000,
        error: e,
      );
      return null;
    }
  }

  @override
  Future<UnifiedGardenStats?> getGardenStats(String gardenId) async {
    try {
      final beds = GardenBoxes.getGardenBeds(gardenId);

      // Calculer les surfaces
      double totalArea = 0.0;
      double activeArea = 0.0;
      int activeBeds = 0;

      for (final bed in beds) {
        totalArea += bed.sizeInSquareMeters;
        if (bed.isActive) {
          activeArea += bed.sizeInSquareMeters;
          activeBeds++;
        }
      }

      // Récupérer toutes les plantations
      final allPlantings = <Planting>[];
      for (final bed in beds) {
        allPlantings.addAll(GardenBoxes.getPlantings(bed.id));
      }

      // Calculer les compteurs
      final totalPlants = allPlantings.length;
      final activePlants = allPlantings.where((p) => p.isActive).length;
      final historicalPlants = totalPlants - activePlants;

      // Plantations de l'année en cours
      final currentYear = DateTime.now().year;
      final plantingsThisYear =
          allPlantings.where((p) => p.plantedDate.year == currentYear).length;

      // Récoltes de l'année en cours
      final harvestsThisYear = allPlantings
          .where((p) =>
              p.actualHarvestDate != null &&
              p.actualHarvestDate!.year == currentYear)
          .length;

      // Calculer le taux de réussite
      double successRate = 0.0;
      if (plantingsThisYear > 0) {
        successRate = (harvestsThisYear / plantingsThisYear) * 100;
      }

      return UnifiedGardenStats(
        totalPlants: totalPlants,
        activePlants: activePlants,
        historicalPlants: historicalPlants,
        totalArea: totalArea,
        activeArea: activeArea,
        totalBeds: beds.length,
        activeBeds: activeBeds,
        plantingsThisYear: plantingsThisYear,
        harvestsThisYear: harvestsThisYear,
        successRate: successRate,
        totalYield: 0.0, // Non disponible dans Legacy
        currentYearYield: 0.0, // Non disponible dans Legacy
        averageHealth: 0.0, // Non disponible dans Legacy
        activeRecommendations: 0, // Non disponible dans Legacy
        activeAlerts: 0, // Non disponible dans Legacy
      );
    } catch (e) {
      developer.log(
        'Erreur lors du calcul des stats Legacy',
        name: _logName,
        level: 1000,
        error: e,
      );
      return null;
    }
  }

  @override
  Future<List<UnifiedActivityHistory>> getRecentActivities(
    String gardenId, {
    int limit = 20,
  }) async {
    // Les activités ne sont pas disponibles dans le système Legacy
    // Cette fonctionnalité devrait être fournie par le système Moderne
    return [];
  }

  // ==================== MÉTHODES PRIVÉES ====================

  /// Calcule les informations de sol depuis les parcelles du jardin
  UnifiedSoilInfo _calculateSoilInfo(String gardenId) {
    try {
      final beds = GardenBoxes.getGardenBeds(gardenId);

      if (beds.isEmpty) {
        return _getDefaultSoilInfo();
      }

      // Analyser la distribution des types de sol
      final soilTypeDistribution = <String, int>{};
      for (final bed in beds) {
        final soilType = bed.soilType;
        soilTypeDistribution[soilType] =
            (soilTypeDistribution[soilType] ?? 0) + 1;
      }

      // Sélectionner le type de sol majoritaire
      String majorSoilType = 'Mixte';
      int maxCount = 0;

      soilTypeDistribution.forEach((soilType, count) {
        if (count > maxCount) {
          maxCount = count;
          majorSoilType = soilType;
        }
      });

      return UnifiedSoilInfo(
        type: majorSoilType,
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
    } catch (e) {
      return _getDefaultSoilInfo();
    }
  }

  /// Retourne des informations de sol par défaut
  UnifiedSoilInfo _getDefaultSoilInfo() {
    return const UnifiedSoilInfo(
      type: 'Mixte',
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

  /// Retourne des conditions climatiques par défaut
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

  /// Retourne des préférences de culture par défaut
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

  /// Retourne des statistiques par défaut
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


