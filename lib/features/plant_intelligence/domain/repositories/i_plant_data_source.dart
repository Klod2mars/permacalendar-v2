import '../../../plant_catalog/domain/entities/plant_entity.dart';

/// Plant Data Source Interface
///
/// Provides access to plant catalog data.
/// This is a simple interface to decouple use cases from direct Hive access.
abstract class IPlantDataSource {
  /// Get a specific plant by ID
  Future<PlantFreezed?> getPlant(String plantId);

  /// Get all plants
  Future<List<PlantFreezed>> getAllPlants();

  /// Search plants by name
  Future<List<PlantFreezed>> searchPlants(String query);
}


