import 'dart:developer' as developer;
import 'package:hive/hive.dart';
import '../models/plant_hive.dart';
import '../../domain/entities/plant_entity.dart';

/// Repository specific for Custom User Plants
/// Uses a separate Hive box 'custom_plants_box' to avoid polluting the core catalog.
class CustomPlantRepository {
  static const String _boxName = 'custom_plants_box';
  Box<PlantHive>? _box;

  /// Ensures box is open
  Future<Box<PlantHive>> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      try {
        _box = await Hive.openBox<PlantHive>(_boxName);
      } catch (e) {
        developer.log('CustomPlantRepository: Error opening box: $e',
            name: 'CustomPlantRepository', level: 1000);
        // Fallback or rethrow? Rethrow ensures we know something is wrong.
        throw Exception('Could not open custom plants box: $e');
      }
    }
    return _box!;
  }

  /// Get all custom plants
  Future<List<PlantFreezed>> getAllPlants() async {
    try {
      final box = await _getBox();
      final plants = <PlantFreezed>[];

      for (final plantHive in box.values) {
        try {
          final plantFreezed = _fromHiveModel(plantHive);
          plants.add(plantFreezed);
        } catch (e) {
             developer.log('CustomPlantRepository: Error converting plant ${plantHive.id}: $e',
              name: 'CustomPlantRepository');
        }
      }
      return plants;

    } catch (e) {
      developer.log('CustomPlantRepository: Error fetching plants: $e',
          name: 'CustomPlantRepository', level: 1000);
      return [];
    }
  }

  /// Add a new custom plant
  Future<void> addPlant(PlantHive plant) async {
    try {
      final box = await _getBox();
      await box.put(plant.id, plant);
      developer.log('CustomPlantRepository: Added plant ${plant.id} (${plant.commonName})',
          name: 'CustomPlantRepository');
    } catch (e) {
      developer.log('CustomPlantRepository: Error adding plant: $e',
          name: 'CustomPlantRepository', level: 1000);
      throw Exception('Could not add custom plant: $e');
    }
  }

  /// Update an existing custom plant
  Future<void> updatePlant(PlantHive plant) async {
    try {
      final box = await _getBox();
      if (box.containsKey(plant.id)) {
        plant.updatedAt = DateTime.now();
        await box.put(plant.id, plant);
         developer.log('CustomPlantRepository: Updated plant ${plant.id}',
          name: 'CustomPlantRepository');
      } else {
        throw Exception('Plant not found in custom box: ${plant.id}');
      }
    } catch (e) {
      developer.log('CustomPlantRepository: Error updating plant: $e',
          name: 'CustomPlantRepository', level: 1000);
      throw e;
    }
  }

  /// Delete a custom plant
  Future<void> deletePlant(String id) async {
    try {
      final box = await _getBox();
      if (box.containsKey(id)) {
        await box.delete(id);
        developer.log('CustomPlantRepository: Deleted plant $id',
          name: 'CustomPlantRepository');
      }
    } catch (e) {
       developer.log('CustomPlantRepository: Error deleting plant: $e',
          name: 'CustomPlantRepository', level: 1000);
       throw e;
    }
  }

  /// Check if plant exists
  Future<bool> plantExists(String id) async {
    final box = await _getBox();
    return box.containsKey(id);
  }

   /// Convert PlantHive to PlantFreezed (Matches logic in PlantHiveRepository)
   /// We can duplicate this helper or make it static in PlantHiveRepository.
   /// For safety and independence, I'll duplicate the logic here to ensure
   /// CustomRepository is self-contained.
  PlantFreezed _fromHiveModel(PlantHive hiveModel) {
    return PlantFreezed(
      id: hiveModel.id,
      commonName: hiveModel.commonName,
      scientificName: hiveModel.scientificName,
      family: hiveModel.family,
      plantingSeason: hiveModel.plantingSeason,
      harvestSeason: hiveModel.harvestSeason,
      daysToMaturity: hiveModel.daysToMaturity,
      spacing: hiveModel.spacing,
      depth: hiveModel.depth,
      sunExposure: hiveModel.sunExposure,
      waterNeeds: hiveModel.waterNeeds,
      description: hiveModel.description,
      sowingMonths: hiveModel.sowingMonths,
      harvestMonths: hiveModel.harvestMonths,
      marketPricePerKg: hiveModel.marketPricePerKg,
      defaultUnit: hiveModel.defaultUnit,
      nutritionPer100g: _castMap(hiveModel.nutritionPer100g),
      germination: _castMap(hiveModel.germination),
      growth: _castMap(hiveModel.growth),
      watering: _castMap(hiveModel.watering),
      thinning: _castMap(hiveModel.thinning),
      weeding: _castMap(hiveModel.weeding),
      culturalTips: hiveModel.culturalTips,
      biologicalControl: _castMap(hiveModel.biologicalControl),
      harvestTime: hiveModel.harvestTime,
      companionPlanting: _castMap(hiveModel.companionPlanting),
      notificationSettings: _castMap(hiveModel.notificationSettings),
      varieties: _castMap(hiveModel.varieties),
      metadata: _castMap(hiveModel.metadata) ?? {},
      createdAt: hiveModel.createdAt,
      updatedAt: hiveModel.updatedAt,
      isActive: hiveModel.isActive,
    );
  }

  Map<String, dynamic>? _castMap(Map? map) {
    if (map == null) return null;
    return Map<String, dynamic>.from(map);
  }
}
