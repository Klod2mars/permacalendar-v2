import 'dart:developer' as developer;
import '../../domain/repositories/i_plant_data_source.dart';
import '../../../plant_catalog/data/repositories/plant_hive_repository.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';

/// Implementation of IPlantDataSource using PlantHiveRepository
///
/// This datasource provides access to the plant catalog.
/// It wraps the existing PlantHiveRepository to decouple use cases from Hive.
class PlantDataSourceImpl implements IPlantDataSource {
  static const String _logName = 'PlantDataSource';

  final PlantHiveRepository _plantRepository;

  PlantDataSourceImpl(this._plantRepository);

  @override
  Future<PlantFreezed?> getPlant(String plantId) async {
    try {
      return await _plantRepository.getPlantById(plantId);
    } catch (e) {
      developer.log('Error getting plant $plantId: $e',
          name: _logName, level: 900);
      return null;
    }
  }

  @override
  Future<List<PlantFreezed>> getAllPlants() async {
    try {
      return await _plantRepository.getAllPlants();
    } catch (e) {
      developer.log('Error getting all plants: $e',
          name: _logName, level: 1000);
      return [];
    }
  }

  @override
  Future<List<PlantFreezed>> searchPlants(String query) async {
    try {
      final allPlants = await _plantRepository.getAllPlants();
      final lowerQuery = query.toLowerCase();
      return allPlants
          .where((plant) =>
              plant.commonName.toLowerCase().contains(lowerQuery) ||
              plant.scientificName.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      developer.log('Error searching plants with query "$query": $e',
          name: _logName, level: 900);
      return [];
    }
  }
}

