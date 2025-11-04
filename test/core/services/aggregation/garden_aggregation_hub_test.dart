import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/services/aggregation/garden_aggregation_hub.dart';
import 'package:permacalendar/core/services/aggregation/modern_data_adapter.dart';
import 'package:permacalendar/core/services/aggregation/legacy_data_adapter.dart';
import 'package:permacalendar/core/models/unified_garden_context.dart';
import 'package:permacalendar/core/repositories/garden_hive_repository.dart';
import 'package:permacalendar/features/plant_catalog/data/repositories/plant_hive_repository.dart';

/// Tests d'intégration pour le Garden Aggregation Hub
/// 
/// Ces tests vérifient le bon fonctionnement du hub central et
/// de sa stratégie de résolution avec fallback.

void main() {
  group('GardenAggregationHub - Integration Tests', () {
    group('Fallback Strategy', () {
      test('should use Modern adapter first (highest priority)', () async {
        // Arrange
        final mockModernAdapter = MockModernAdapter(
          shouldSucceed: true,
          gardenName: 'Modern Garden',
        );
        final mockLegacyAdapter = MockLegacyAdapter(
          shouldSucceed: true,
          gardenName: 'Legacy Garden',
        );
        
        final hub = GardenAggregationHub(
          modernAdapter: mockModernAdapter,
          legacyAdapter: mockLegacyAdapter,
        );
        
        // Act
        final context = await hub.getUnifiedContext('test-garden-1');
        
        // Assert
        expect(context.name, 'Modern Garden');
        expect(context.primarySource, DataSource.modern);
        expect(mockModernAdapter.wasCalledCount, 1);
        expect(mockLegacyAdapter.wasCalledCount, 0); // Ne devrait pas être appelé
      });
      
      test('should fallback to Legacy if Modern fails', () async {
        // Arrange
        final mockModernAdapter = MockModernAdapter(
          shouldSucceed: false,
        );
        final mockLegacyAdapter = MockLegacyAdapter(
          shouldSucceed: true,
          gardenName: 'Legacy Garden',
        );
        
        final hub = GardenAggregationHub(
          modernAdapter: mockModernAdapter,
          legacyAdapter: mockLegacyAdapter,
        );
        
        // Act
        final context = await hub.getUnifiedContext('test-garden-1');
        
        // Assert
        expect(context.name, 'Legacy Garden');
        expect(context.primarySource, DataSource.legacy);
        expect(mockModernAdapter.wasCalledCount, 1);
        expect(mockLegacyAdapter.wasCalledCount, 1); // Devrait être appelé en fallback
      });
      
      test('should return default context if all adapters fail', () async {
        // Arrange
        final mockModernAdapter = MockModernAdapter(shouldSucceed: false);
        final mockLegacyAdapter = MockLegacyAdapter(shouldSucceed: false);
        
        final hub = GardenAggregationHub(
          modernAdapter: mockModernAdapter,
          legacyAdapter: mockLegacyAdapter,
        );
        
        // Act
        final context = await hub.getUnifiedContext('test-garden-1');
        
        // Assert
        expect(context.gardenId, 'test-garden-1');
        expect(context.primarySource, DataSource.fallback);
        expect(mockModernAdapter.wasCalledCount, 1);
        expect(mockLegacyAdapter.wasCalledCount, 1);
      });
    });
    
    group('Cache Management', () {
      test('should cache results and not call adapters again', () async {
        // Arrange
        final mockModernAdapter = MockModernAdapter(
          shouldSucceed: true,
          gardenName: 'Modern Garden',
        );
        
        final hub = GardenAggregationHub(
          modernAdapter: mockModernAdapter,
        );
        
        // Act
        final context1 = await hub.getUnifiedContext('test-garden-1');
        final context2 = await hub.getUnifiedContext('test-garden-1');
        
        // Assert
        expect(context1.name, context2.name);
        expect(mockModernAdapter.wasCalledCount, 1); // Une seule fois, ensuite cache
      });
      
      test('should invalidate cache and call adapters again', () async {
        // Arrange
        final mockModernAdapter = MockModernAdapter(
          shouldSucceed: true,
          gardenName: 'Modern Garden',
        );
        
        final hub = GardenAggregationHub(
          modernAdapter: mockModernAdapter,
        );
        
        // Act
        await hub.getUnifiedContext('test-garden-1');
        hub.invalidateCache('test-garden-1');
        await hub.getUnifiedContext('test-garden-1');
        
        // Assert
        expect(mockModernAdapter.wasCalledCount, 2); // Deux fois car cache invalidé
      });
    });
    
    group('Health Check', () {
      test('should report adapter availability', () async {
        // Arrange
        final mockModernAdapter = MockModernAdapter(shouldSucceed: true);
        final mockLegacyAdapter = MockLegacyAdapter(shouldSucceed: false);
        
        final hub = GardenAggregationHub(
          modernAdapter: mockModernAdapter,
          legacyAdapter: mockLegacyAdapter,
        );
        
        // Act
        final health = await hub.healthCheck();
        
        // Assert
        expect(health['adapters'], isNotEmpty);
        final modernHealth = (health['adapters'] as List).firstWhere(
          (a) => a['name'] == 'MockModern',
        );
        expect(modernHealth['available'], true);
      });
    });
  });
}

// ==================== MOCK ADAPTERS ====================

/// Mock Modern Adapter qui hérite de ModernDataAdapter
class MockModernAdapter extends ModernDataAdapter {
  final bool shouldSucceed;
  final String gardenName;
  int wasCalledCount = 0;
  
  MockModernAdapter({
    required this.shouldSucceed,
    this.gardenName = 'Test Garden',
  }) : super(
    gardenRepository: GardenHiveRepository(),
    plantRepository: PlantHiveRepository(),
  );
  
  @override
  String get adapterName => 'MockModern';
  
  @override
  int get priority => 3;
  
  @override
  Future<bool> isAvailable() async => true; // Toujours disponible pour le test
  
  @override
  Future<UnifiedGardenContext?> getGardenContext(String gardenId) async {
    wasCalledCount++;
    
    if (!shouldSucceed) {
      return null; // Retourner null au lieu de throw pour déclencher le fallback
    }
    
    return UnifiedGardenContext(
      gardenId: gardenId,
      name: gardenName,
      description: 'Mock garden from Modern adapter',
      location: 'Test Location',
      totalArea: 100.0,
      activePlants: [],
      historicalPlants: [],
      stats: const UnifiedGardenStats(
        totalPlants: 10,
        activePlants: 5,
        historicalPlants: 5,
        totalArea: 100.0,
        activeArea: 50.0,
        totalBeds: 3,
        activeBeds: 2,
        plantingsThisYear: 10,
        harvestsThisYear: 3,
        successRate: 30.0,
        totalYield: 100.0,
        currentYearYield: 50.0,
        averageHealth: 75.0,
        activeRecommendations: 2,
        activeAlerts: 1,
      ),
      soil: const UnifiedSoilInfo(
        type: 'Loamy',
        ph: 7.0,
        texture: 'medium',
        organicMatter: 3.0,
        waterRetention: 60.0,
        drainage: 'good',
        depth: 30.0,
        nutrients: {},
      ),
      climate: const UnifiedClimate(
        averageTemperature: 15.0,
        minTemperature: -5.0,
        maxTemperature: 35.0,
        averagePrecipitation: 800.0,
        averageHumidity: 70.0,
        frostDays: 30,
        growingSeasonLength: 250,
        dominantWindDirection: 'West',
        averageWindSpeed: 10.0,
        averageSunshineHours: 8.0,
      ),
      preferences: const UnifiedCultivationPreferences(
        method: 'permaculture',
        usePesticides: false,
        useChemicalFertilizers: false,
        useOrganicFertilizers: true,
        cropRotation: true,
        companionPlanting: true,
        mulching: true,
        automaticIrrigation: false,
        regularMonitoring: true,
        objectives: [],
      ),
      recentActivities: [],
      primarySource: DataSource.modern,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  @override
  Future<List<UnifiedPlantData>> getActivePlants(String gardenId) async => [];
  
  @override
  Future<List<UnifiedPlantData>> getHistoricalPlants(String gardenId) async => [];
  
  @override
  Future<UnifiedPlantData?> getPlantById(String plantId) async => null;
  
  @override
  Future<UnifiedGardenStats?> getGardenStats(String gardenId) async => null;
  
  @override
  Future<List<UnifiedActivityHistory>> getRecentActivities(
    String gardenId, {
    int limit = 20,
  }) async => [];
}

/// Mock Legacy Adapter qui hérite de LegacyDataAdapter
class MockLegacyAdapter extends LegacyDataAdapter {
  final bool shouldSucceed;
  final String gardenName;
  int wasCalledCount = 0;
  
  MockLegacyAdapter({
    required this.shouldSucceed,
    this.gardenName = 'Test Legacy Garden',
  });
  
  @override
  String get adapterName => 'MockLegacy';
  
  @override
  int get priority => 2;
  
  @override
  Future<bool> isAvailable() async => true; // Toujours disponible pour le test
  
  @override
  Future<UnifiedGardenContext?> getGardenContext(String gardenId) async {
    wasCalledCount++;
    
    if (!shouldSucceed) {
      return null; // Retourner null au lieu de throw pour déclencher le fallback
    }
    
    return UnifiedGardenContext(
      gardenId: gardenId,
      name: gardenName,
      description: 'Mock garden from Legacy adapter',
      location: 'Legacy Location',
      totalArea: 80.0,
      activePlants: [],
      historicalPlants: [],
      stats: const UnifiedGardenStats(
        totalPlants: 8,
        activePlants: 4,
        historicalPlants: 4,
        totalArea: 80.0,
        activeArea: 40.0,
        totalBeds: 2,
        activeBeds: 1,
        plantingsThisYear: 8,
        harvestsThisYear: 2,
        successRate: 25.0,
        totalYield: 80.0,
        currentYearYield: 40.0,
        averageHealth: 0.0,
        activeRecommendations: 0,
        activeAlerts: 0,
      ),
      soil: const UnifiedSoilInfo(
        type: 'Clay',
        ph: 6.5,
        texture: 'fine',
        organicMatter: 2.5,
        waterRetention: 70.0,
        drainage: 'poor',
        depth: 25.0,
        nutrients: {},
      ),
      climate: const UnifiedClimate(
        averageTemperature: 14.0,
        minTemperature: -10.0,
        maxTemperature: 30.0,
        averagePrecipitation: 700.0,
        averageHumidity: 65.0,
        frostDays: 40,
        growingSeasonLength: 230,
        dominantWindDirection: 'North',
        averageWindSpeed: 12.0,
        averageSunshineHours: 7.0,
      ),
      preferences: const UnifiedCultivationPreferences(
        method: 'organic',
        usePesticides: false,
        useChemicalFertilizers: false,
        useOrganicFertilizers: true,
        cropRotation: true,
        companionPlanting: false,
        mulching: false,
        automaticIrrigation: false,
        regularMonitoring: true,
        objectives: [],
      ),
      recentActivities: [],
      primarySource: DataSource.legacy,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  @override
  Future<List<UnifiedPlantData>> getActivePlants(String gardenId) async => [];
  
  @override
  Future<List<UnifiedPlantData>> getHistoricalPlants(String gardenId) async => [];
  
  @override
  Future<UnifiedPlantData?> getPlantById(String plantId) async => null;
  
  @override
  Future<UnifiedGardenStats?> getGardenStats(String gardenId) async => null;
  
  @override
  Future<List<UnifiedActivityHistory>> getRecentActivities(
    String gardenId, {
    int limit = 20,
  }) async => [];
}

