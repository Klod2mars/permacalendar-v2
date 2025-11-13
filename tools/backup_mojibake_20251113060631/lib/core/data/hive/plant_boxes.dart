import 'package:hive_flutter/hive_flutter.dart';
import '../../models/plant.dart';
import '../../models/plant_variety.dart';
import '../../models/growth_cycle.dart';

class PlantBoxes {
  static const String _plantsBoxName = 'plants';
  static const String _varietiesBoxName = 'plant_varieties';
  static const String _growthCyclesBoxName = 'growth_cycles';

  static Box<Plant>? _plantsBox;
  static Box<PlantVariety>? _varietiesBox;
  static Box<GrowthCycle>? _growthCyclesBox;

  // Getters pour les boxes
  static Box<Plant> get plants {
    if (_plantsBox == null || !_plantsBox!.isOpen) {
      throw Exception('Plants box n\'est pas initialisée');
    }
    return _plantsBox!;
  }

  static Box<PlantVariety> get varieties {
    if (_varietiesBox == null || !_varietiesBox!.isOpen) {
      throw Exception('Plant varieties box n\'est pas initialisée');
    }
    return _varietiesBox!;
  }

  static Box<GrowthCycle> get growthCycles {
    if (_growthCyclesBox == null || !_growthCyclesBox!.isOpen) {
      throw Exception('Growth cycles box n\'est pas initialisée');
    }
    return _growthCyclesBox!;
  }

  static Future<void> initialize() async {
    try {
      // Ouvrir les boxes
      _plantsBox = await Hive.openBox<Plant>(_plantsBoxName);
      _varietiesBox = await Hive.openBox<PlantVariety>(_varietiesBoxName);
      _growthCyclesBox = await Hive.openBox<GrowthCycle>(_growthCyclesBoxName);

      print('[PlantBoxes] Boxes initialisées avec succès');
    } catch (e) {
      print('[PlantBoxes] Erreur lors de l\'initialisation: $e');
      rethrow;
    }
  }

  static Future<void> close() async {
    await _plantsBox?.close();
    await _varietiesBox?.close();
    await _growthCyclesBox?.close();

    _plantsBox = null;
    _varietiesBox = null;
    _growthCyclesBox = null;
  }

  // Méthodes utilitaires pour les plantes
  static Future<void> clearAllPlants() async {
    await plants.clear();
    await varieties.clear();
    await growthCycles.clear();
  }

  static List<Plant> getAllPlants() {
    try {
      return plants.values.toList();
    } catch (e) {
      return <Plant>[];
    }
  }

  static Plant? getPlant(String id) {
    return plants.get(id);
  }

  static Future<void> savePlant(Plant plant) async {
    await plants.put(plant.id, plant);
  }

  static Future<void> deletePlant(String id) async {
    // Supprimer la plante
    await plants.delete(id);

    // Supprimer toutes les variétés associées
    final varietiesToDelete = varieties.values
        .where((variety) => variety.plantId == id)
        .map((variety) => variety.id)
        .toList();

    for (final varietyId in varietiesToDelete) {
      await varieties.delete(varietyId);
    }

    // Supprimer tous les cycles de croissance associés
    final cyclesToDelete = growthCycles.values
        .where((cycle) => cycle.plantId == id)
        .map((cycle) => cycle.id)
        .toList();

    for (final cycleId in cyclesToDelete) {
      await growthCycles.delete(cycleId);
    }
  }

  // Méthodes utilitaires pour les variétés
  static List<PlantVariety> getPlantVarieties(String plantId) {
    return varieties.values
        .where((variety) => variety.plantId == plantId)
        .toList();
  }

  static Future<void> savePlantVariety(PlantVariety variety) async {
    await varieties.put(variety.id, variety);
  }

  static Future<void> deletePlantVariety(String id) async {
    await varieties.delete(id);
  }

  // Méthodes utilitaires pour les cycles de croissance
  static List<GrowthCycle> getGrowthCycles(String plantId) {
    return growthCycles.values
        .where((cycle) => cycle.plantId == plantId)
        .toList();
  }

  static GrowthCycle? getCurrentGrowthCycle(String plantId, DateTime date) {
    final cycles = getGrowthCycles(plantId);

    for (final cycle in cycles) {
      if (date.isAfter(cycle.startDate) && date.isBefore(cycle.endDate)) {
        return cycle;
      }
    }

    return null;
  }

  static Future<void> saveGrowthCycle(GrowthCycle cycle) async {
    await growthCycles.put(cycle.id, cycle);
  }

  static Future<void> deleteGrowthCycle(String id) async {
    await growthCycles.delete(id);
  }

  // Méthodes de recherche
  static List<Plant> searchPlants(String query) {
    try {
      final lowerQuery = query.toLowerCase();
      return plants.values
          .where((plant) =>
              plant.commonName.toLowerCase().contains(lowerQuery) ||
              plant.scientificName.toLowerCase().contains(lowerQuery) ||
              plant.category.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      return <Plant>[];
    }
  }

  static List<Plant> getPlantsByCategory(String category) {
    return plants.values
        .where(
            (plant) => plant.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  static List<Plant> getPlantsBySeason(String season) {
    return plants.values
        .where((plant) => plant.plantingSeason.contains(season))
        .toList();
  }
}


