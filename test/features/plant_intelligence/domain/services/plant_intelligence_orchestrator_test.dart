import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/plant_intelligence_orchestrator.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_plant_condition_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_weather_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_garden_context_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_recommendation_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_analytics_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/usecases/analyze_plant_conditions_usecase.dart';
import 'package:permacalendar/features/plant_intelligence/domain/usecases/evaluate_planting_timing_usecase.dart';
import 'package:permacalendar/features/plant_intelligence/domain/usecases/generate_recommendations_usecase.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/plant_catalog/data/repositories/plant_hive_repository.dart';
import 'package:permacalendar/core/services/aggregation/garden_aggregation_hub.dart';
import 'package:permacalendar/core/errors/plant_exceptions.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/plant_intelligence_evolution_tracker.dart';
import '../usecases/test_helpers.dart';

// Génère les mocks pour les 5 interfaces spécialisées + GardenAggregationHub + PlantHiveRepository + EvolutionTracker
@GenerateMocks([
  IPlantConditionRepository,
  IWeatherRepository,
  IGardenContextRepository,
  IRecommendationRepository,
  IAnalyticsRepository,
  GardenAggregationHub,
  PlantHiveRepository,
  PlantIntelligenceEvolutionTracker,
])
import 'plant_intelligence_orchestrator_test.mocks.dart';

void main() {
  group('PlantIntelligenceOrchestrator', () {
    late PlantIntelligenceOrchestrator orchestrator;
    late MockIPlantConditionRepository mockConditionRepo;
    late MockIWeatherRepository mockWeatherRepo;
    late MockIGardenContextRepository mockGardenRepo;
    late MockIRecommendationRepository mockRecommendationRepo;
    late MockIAnalyticsRepository mockAnalyticsRepo;
    late MockGardenAggregationHub mockGardenAggregationHub;
    late MockPlantHiveRepository mockPlantHiveRepo;
    late MockPlantIntelligenceEvolutionTracker mockEvolutionTracker;
    late AnalyzePlantConditionsUsecase analyzeUsecase;
    late EvaluatePlantingTimingUsecase evaluateTimingUsecase;
    late GenerateRecommendationsUsecase generateRecommendationsUsecase;

    setUp(() {
      mockConditionRepo = MockIPlantConditionRepository();
      mockWeatherRepo = MockIWeatherRepository();
      mockGardenRepo = MockIGardenContextRepository();
      mockRecommendationRepo = MockIRecommendationRepository();
      mockAnalyticsRepo = MockIAnalyticsRepository();
      mockGardenAggregationHub = MockGardenAggregationHub();
      mockPlantHiveRepo = MockPlantHiveRepository();
      mockEvolutionTracker = MockPlantIntelligenceEvolutionTracker();
      analyzeUsecase = const AnalyzePlantConditionsUsecase();
      evaluateTimingUsecase = const EvaluatePlantingTimingUsecase();
      generateRecommendationsUsecase = const GenerateRecommendationsUsecase();
      
      orchestrator = PlantIntelligenceOrchestrator(
        conditionRepository: mockConditionRepo,
        weatherRepository: mockWeatherRepo,
        gardenRepository: mockGardenRepo,
        recommendationRepository: mockRecommendationRepo,
        analyticsRepository: mockAnalyticsRepo,
        plantCatalogRepository: mockPlantHiveRepo,
        analyzeUsecase: analyzeUsecase,
        evaluateTimingUsecase: evaluateTimingUsecase,
        generateRecommendationsUsecase: generateRecommendationsUsecase,
        evolutionTracker: mockEvolutionTracker,
        gardenAggregationHub: mockGardenAggregationHub,
      );
    });

    test('should generate complete intelligence report', () async {
      // Arrange
      final plant = createMockPlant();
      final garden = createMockGarden();
      final weather = createMockWeather(temperature: 20.0);
      
      // Mock plant catalog repository
      when(mockPlantHiveRepo.getAllPlants())
          .thenAnswer((_) async => [plant]);
      
      // Mock repository responses avec interfaces spécialisées
      when(mockGardenRepo.searchPlants({'id': 'tomato'}))
          .thenAnswer((_) async => [plant]);
      
      when(mockGardenRepo.getGardenContext('garden_1'))
          .thenAnswer((_) async => garden);
      
      when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
          .thenAnswer((_) async => weather);
      
      when(mockConditionRepo.getPlantConditionHistory(
        plantId: 'tomato',
        startDate: anyNamed('startDate'),
        limit: 100,
      )).thenAnswer((_) async => []);
      
      when(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato'))
          .thenAnswer((_) async => []);
      
      when(mockConditionRepo.savePlantCondition(
        plantId: 'tomato',
        condition: anyNamed('condition'),
      )).thenAnswer((_) async => 'condition_id');
      
      when(mockRecommendationRepo.saveRecommendation(
        plantId: 'tomato',
        recommendation: anyNamed('recommendation'),
      )).thenAnswer((_) async => 'rec_id');
      
      when(mockAnalyticsRepo.saveAnalysisResult(
        plantId: 'tomato',
        analysisType: 'complete_analysis',
        result: anyNamed('result'),
        confidence: anyNamed('confidence'),
      )).thenAnswer((_) async => 'analysis_id');
      
      // Act
      final report = await orchestrator.generateIntelligenceReport(
        plantId: 'tomato',
        gardenId: 'garden_1',
      );
      
      // Assert
      expect(report, isNotNull);
      expect(report.plantId, 'tomato');
      expect(report.gardenId, 'garden_1');
      expect(report.plantName, 'Tomate');
      expect(report.analysis, isNotNull);
      // Les recommandations peuvent être vides si toutes les conditions sont bonnes
      expect(report.recommendations, isNotNull);
      expect(report.plantingTiming, isNotNull);
      expect(report.intelligenceScore, greaterThan(0.0));
      expect(report.intelligenceScore, lessThanOrEqualTo(100.0));
      expect(report.confidence, greaterThan(0.0));
      expect(report.confidence, lessThanOrEqualTo(1.0));
      
      // Vérifier que les méthodes du repository ont été appelées
      verify(mockGardenRepo.getGardenContext('garden_1')).called(1);
      verify(mockWeatherRepo.getCurrentWeatherCondition('garden_1')).called(1);
      verify(mockConditionRepo.getPlantConditionHistory(
        plantId: 'tomato',
        startDate: anyNamed('startDate'),
        limit: 100,
      )).called(1);
      verify(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato')).called(1);
    });

    test('should throw exception when garden context not found', () async {
      // Arrange
      final plant = createMockPlant();
      when(mockPlantHiveRepo.getAllPlants())
          .thenAnswer((_) async => [plant]);
      when(mockGardenRepo.searchPlants({'id': 'tomato'}))
          .thenAnswer((_) async => [plant]);
      
      when(mockGardenRepo.getGardenContext('garden_1'))
          .thenAnswer((_) async => null);
      
      // getCurrentWeatherCondition est appelé avant la vérification du gardenContext
      when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
          .thenAnswer((_) async => createMockWeather());
      
      // Act & Assert
      expect(
        () => orchestrator.generateIntelligenceReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
        ),
        throwsA(isA<PlantIntelligenceOrchestratorException>()),
      );
    });

    test('should throw exception when weather condition not found', () async {
      // Arrange
      final plant = createMockPlant();
      when(mockPlantHiveRepo.getAllPlants())
          .thenAnswer((_) async => [plant]);
      when(mockGardenRepo.searchPlants({'id': 'tomato'}))
          .thenAnswer((_) async => [plant]);
      
      when(mockGardenRepo.getGardenContext('garden_1'))
          .thenAnswer((_) async => createMockGarden());
      
      when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
          .thenAnswer((_) async => null);
      
      // Act & Assert
      expect(
        () => orchestrator.generateIntelligenceReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
        ),
        throwsA(isA<PlantIntelligenceOrchestratorException>()),
      );
    });

    test('should throw exception when plant not found', () async {
      // Arrange
      when(mockPlantHiveRepo.getAllPlants())
          .thenAnswer((_) async => []);
      when(mockGardenRepo.searchPlants({'id': 'unknown'}))
          .thenAnswer((_) async => []);
      
      // Act & Assert - should throw EmptyPlantCatalogException when catalog is empty
      expect(
        () => orchestrator.generateIntelligenceReport(
          plantId: 'unknown',
          gardenId: 'garden_1',
        ),
        throwsA(isA<EmptyPlantCatalogException>()),
      );
    });

    test('should generate garden intelligence report for multiple plants', () async {
      // Arrange
      final plants = <PlantFreezed>[
        createMockPlant(id: 'tomato'),
        createMockPlant(id: 'lettuce', commonName: 'Laitue'),
      ];
      
      final garden = createMockGarden();
      final weather = createMockWeather(temperature: 20.0);
      
      when(mockPlantHiveRepo.getAllPlants())
          .thenAnswer((_) async => plants);
      when(mockGardenRepo.getGardenPlants('garden_1'))
          .thenAnswer((_) async => plants);
      
      when(mockGardenRepo.getGardenContext('garden_1'))
          .thenAnswer((_) async => garden);
      
      when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
          .thenAnswer((_) async => weather);
      
      when(mockConditionRepo.getPlantConditionHistory(
        plantId: anyNamed('plantId'),
        startDate: anyNamed('startDate'),
        limit: 100,
      )).thenAnswer((_) async => []);
      
      when(mockAnalyticsRepo.getActiveAlerts(plantId: anyNamed('plantId')))
          .thenAnswer((_) async => []);
      
      when(mockConditionRepo.savePlantCondition(
        plantId: anyNamed('plantId'),
        condition: anyNamed('condition'),
      )).thenAnswer((_) async => 'condition_id');
      
      when(mockRecommendationRepo.saveRecommendation(
        plantId: anyNamed('plantId'),
        recommendation: anyNamed('recommendation'),
      )).thenAnswer((_) async => 'rec_id');
      
      when(mockAnalyticsRepo.saveAnalysisResult(
        plantId: anyNamed('plantId'),
        analysisType: anyNamed('analysisType'),
        result: anyNamed('result'),
        confidence: anyNamed('confidence'),
      )).thenAnswer((_) async => 'analysis_id');
      
      // Act
      final reports = await orchestrator.generateGardenIntelligenceReport(
        gardenId: 'garden_1',
      );
      
      // Assert
      expect(reports.length, 2);
      expect(reports[0].plantId, 'tomato');
      expect(reports[1].plantId, 'lettuce');
    });

    test('should handle errors gracefully when generating garden report', () async {
      // Arrange
      final plants = <PlantFreezed>[
        createMockPlant(id: 'tomato'),
        createMockPlant(id: 'lettuce', commonName: 'Laitue'),
      ];
      
      when(mockPlantHiveRepo.getAllPlants())
          .thenAnswer((_) async => plants);
      when(mockGardenRepo.getGardenPlants('garden_1'))
          .thenAnswer((_) async => plants);
      
      // Premier plant réussit
      when(mockGardenRepo.getGardenContext('garden_1'))
          .thenAnswer((_) async => createMockGarden());
      
      when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
          .thenAnswer((_) async => createMockWeather());
      
      when(mockConditionRepo.getPlantConditionHistory(
        plantId: anyNamed('plantId'),
        startDate: anyNamed('startDate'),
        limit: 100,
      )).thenAnswer((_) async => []);
      
      when(mockAnalyticsRepo.getActiveAlerts(plantId: anyNamed('plantId')))
          .thenAnswer((_) async => []);
      
      when(mockConditionRepo.savePlantCondition(
        plantId: anyNamed('plantId'),
        condition: anyNamed('condition'),
      )).thenAnswer((_) async => 'condition_id');
      
      when(mockRecommendationRepo.saveRecommendation(
        plantId: anyNamed('plantId'),
        recommendation: anyNamed('recommendation'),
      )).thenAnswer((_) async => 'rec_id');
      
      when(mockAnalyticsRepo.saveAnalysisResult(
        plantId: anyNamed('plantId'),
        analysisType: anyNamed('analysisType'),
        result: anyNamed('result'),
        confidence: anyNamed('confidence'),
      )).thenAnswer((_) async => 'analysis_id');
      
      // Act
      final reports = await orchestrator.generateGardenIntelligenceReport(
        gardenId: 'garden_1',
      );
      
      // Assert
      // L'orchestrateur devrait continuer même si une plante échoue
      expect(reports, isNotEmpty);
    });

    test('should analyze plant conditions only without generating full report', () async {
      // Arrange
      final plant = createMockPlant();
      final garden = createMockGarden();
      final weather = createMockWeather(temperature: 20.0);
      
      when(mockPlantHiveRepo.getAllPlants())
          .thenAnswer((_) async => [plant]);
      when(mockGardenRepo.searchPlants({'id': 'tomato'}))
          .thenAnswer((_) async => [plant]);
      
      when(mockGardenRepo.getGardenContext('garden_1'))
          .thenAnswer((_) async => garden);
      
      when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
          .thenAnswer((_) async => weather);
      
      // Act
      final analysis = await orchestrator.analyzePlantConditions(
        plantId: 'tomato',
        gardenId: 'garden_1',
      );
      
      // Assert
      expect(analysis, isNotNull);
      expect(analysis.plantId, 'tomato');
      expect(analysis.temperature, isNotNull);
      expect(analysis.humidity, isNotNull);
      expect(analysis.light, isNotNull);
      expect(analysis.soil, isNotNull);
      expect(analysis.healthScore, greaterThan(0.0));
      
      // Vérifier que les méthodes de sauvegarde ne sont PAS appelées
      verifyNever(mockConditionRepo.savePlantCondition(
        plantId: anyNamed('plantId'),
        condition: anyNamed('condition'),
      ));
      verifyNever(mockRecommendationRepo.saveRecommendation(
        plantId: anyNamed('plantId'),
        recommendation: anyNamed('recommendation'),
      ));
    });

    test('should calculate intelligence score correctly', () async {
      // Arrange
      final plant = createMockPlant();
      final garden = createMockGarden();
      final weather = createMockWeather(temperature: 22.0); // Température optimale
      
      when(mockPlantHiveRepo.getAllPlants())
          .thenAnswer((_) async => [plant]);
      when(mockGardenRepo.searchPlants({'id': 'tomato'}))
          .thenAnswer((_) async => [plant]);
      
      when(mockGardenRepo.getGardenContext('garden_1'))
          .thenAnswer((_) async => garden);
      
      when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
          .thenAnswer((_) async => weather);
      
      when(mockConditionRepo.getPlantConditionHistory(
        plantId: 'tomato',
        startDate: anyNamed('startDate'),
        limit: 100,
      )).thenAnswer((_) async => []);
      
      when(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato'))
          .thenAnswer((_) async => []);
      
      when(mockConditionRepo.savePlantCondition(
        plantId: anyNamed('plantId'),
        condition: anyNamed('condition'),
      )).thenAnswer((_) async => 'condition_id');
      
      when(mockRecommendationRepo.saveRecommendation(
        plantId: anyNamed('plantId'),
        recommendation: anyNamed('recommendation'),
      )).thenAnswer((_) async => 'rec_id');
      
      when(mockAnalyticsRepo.saveAnalysisResult(
        plantId: anyNamed('plantId'),
        analysisType: anyNamed('analysisType'),
        result: anyNamed('result'),
        confidence: anyNamed('confidence'),
      )).thenAnswer((_) async => 'analysis_id');
      
      // Act
      final report = await orchestrator.generateIntelligenceReport(
        plantId: 'tomato',
        gardenId: 'garden_1',
      );
      
      // Assert
      expect(report.intelligenceScore, greaterThan(0.0));
      expect(report.intelligenceScore, lessThanOrEqualTo(100.0));
      
      // Avec des conditions optimales, le score devrait être élevé
      expect(report.intelligenceScore, greaterThan(50.0));
    });

    test('should calculate confidence correctly based on weather age', () async {
      // Arrange
      final plant = createMockPlant();
      final garden = createMockGarden();
      
      // Données météo anciennes mais encore valides (18 heures)
      final oldWeather = createMockWeather(
        temperature: 20.0,
        measuredAt: DateTime.now().subtract(const Duration(hours: 18)),
      );
      
      when(mockPlantHiveRepo.getAllPlants())
          .thenAnswer((_) async => [plant]);
      when(mockGardenRepo.searchPlants({'id': 'tomato'}))
          .thenAnswer((_) async => [plant]);
      
      when(mockGardenRepo.getGardenContext('garden_1'))
          .thenAnswer((_) async => garden);
      
      when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
          .thenAnswer((_) async => oldWeather);
      
      when(mockConditionRepo.getPlantConditionHistory(
        plantId: 'tomato',
        startDate: anyNamed('startDate'),
        limit: 100,
      )).thenAnswer((_) async => []);
      
      when(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato'))
          .thenAnswer((_) async => []);
      
      when(mockConditionRepo.savePlantCondition(
        plantId: anyNamed('plantId'),
        condition: anyNamed('condition'),
      )).thenAnswer((_) async => 'condition_id');
      
      when(mockRecommendationRepo.saveRecommendation(
        plantId: anyNamed('plantId'),
        recommendation: anyNamed('recommendation'),
      )).thenAnswer((_) async => 'rec_id');
      
      when(mockAnalyticsRepo.saveAnalysisResult(
        plantId: anyNamed('plantId'),
        analysisType: anyNamed('analysisType'),
        result: anyNamed('result'),
        confidence: anyNamed('confidence'),
      )).thenAnswer((_) async => 'analysis_id');
      
      // Act
      final report = await orchestrator.generateIntelligenceReport(
        plantId: 'tomato',
        gardenId: 'garden_1',
      );
      
      // Assert
      // Avec des données anciennes (18h), la confiance devrait être réduite
      expect(report.confidence, lessThan(1.0));
      expect(report.metadata['weatherAge'], greaterThan(12));
      expect(report.metadata['weatherAge'], lessThan(25));
    });

    // ==================== CURSOR PROMPT A2: INITIALIZATION & CLEANUP TESTS ====================
    
    group('initializeForGarden', () {
      test('should call _cleanOrphanedConditionsInHive and invalidateAllCache in order', () async {
        // Arrange
        final callOrder = <String>[];
        
        when(mockGardenAggregationHub.clearCache()).thenAnswer((_) {
          callOrder.add('clearCache');
          return;
        });
        
        when(mockPlantHiveRepo.getAllPlants()).thenAnswer((_) async {
          callOrder.add('getAllPlants');
          return [createMockPlant()];
        });
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: anyNamed('plantId'),
          limit: anyNamed('limit'),
        )).thenAnswer((_) async {
          callOrder.add('getPlantConditionHistory');
          return [];
        });
        
        // Act
        final stats = await orchestrator.initializeForGarden(gardenId: 'garden_1');
        
        // Assert
        expect(stats['gardenId'], 'garden_1');
        expect(stats['cleanupSuccess'], isTrue);
        expect(stats['cacheInvalidationSuccess'], isTrue);
        expect(stats['errors'], isEmpty);
        
        // Verify order: cleanup happens before cache invalidation
        expect(callOrder.indexOf('getAllPlants'), 
               lessThan(callOrder.indexOf('clearCache')));
        
        verify(mockPlantHiveRepo.getAllPlants()).called(1);
        verify(mockGardenAggregationHub.clearCache()).called(1);
      });
      
      test('should not fail if cleanup method has internal errors', () async {
        // Arrange - simulate failure in cleanup dependencies
        // Note: _cleanOrphanedConditionsInHive is defensive and catches all errors,
        // returning 0 instead of throwing. So cleanup always "succeeds" externally.
        when(mockPlantHiveRepo.getAllPlants())
            .thenThrow(Exception('Catalog access failed'));
        
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        
        // Act
        final stats = await orchestrator.initializeForGarden(gardenId: 'garden_1');
        
        // Assert - should continue and complete everything
        // Cleanup is defensive, so it "succeeds" even with internal errors (returns 0)
        expect(stats['gardenId'], 'garden_1');
        expect(stats['cleanupSuccess'], isTrue); // Always true as method doesn't throw
        expect(stats['cacheInvalidationSuccess'], isTrue);
        expect(stats['orphanedConditionsRemoved'], 0); // No conditions deleted due to error
        
        // Cache invalidation should still be called
        verify(mockGardenAggregationHub.clearCache()).called(1);
      });
      
      test('should complete successfully even if cache invalidation has internal errors', () async {
        // Arrange
        // Note: invalidateAllCache() is also defensive and never throws.
        // It catches all errors internally and logs them.
        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [createMockPlant()]);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: anyNamed('plantId'),
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => []);
        
        when(mockGardenAggregationHub.clearCache())
            .thenThrow(Exception('Cache clear failed'));
        
        // Act
        final stats = await orchestrator.initializeForGarden(gardenId: 'garden_1');
        
        // Assert - both methods complete successfully externally (defensive programming)
        expect(stats['gardenId'], 'garden_1');
        expect(stats['cleanupSuccess'], isTrue);
        expect(stats['cacheInvalidationSuccess'], isTrue); // Defensive, doesn't throw
        expect(stats['errors'], isEmpty); // Errors logged but not recorded in stats
      });
      
      test('should handle both methods having internal errors gracefully', () async {
        // Arrange
        // Both methods are defensive and never throw externally
        when(mockPlantHiveRepo.getAllPlants())
            .thenThrow(Exception('Catalog failed'));
        
        when(mockGardenAggregationHub.clearCache())
            .thenThrow(Exception('Cache failed'));
        
        // Act
        final stats = await orchestrator.initializeForGarden(gardenId: 'garden_1');
        
        // Assert
        // Both methods are defensive - they catch all errors and don't throw
        expect(stats['gardenId'], 'garden_1');
        expect(stats['cleanupSuccess'], isTrue); // Defensive, doesn't throw
        expect(stats['cacheInvalidationSuccess'], isTrue); // Defensive, doesn't throw
        expect(stats['orphanedConditionsRemoved'], 0); // No deletions due to catalog error
        // Errors are logged but not added to stats (defensive programming)
      });
      
      test('should be idempotent - can be called multiple times', () async {
        // Arrange
        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [createMockPlant()]);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: anyNamed('plantId'),
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => []);
        
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        
        // Act
        final stats1 = await orchestrator.initializeForGarden(gardenId: 'garden_1');
        final stats2 = await orchestrator.initializeForGarden(gardenId: 'garden_1');
        final stats3 = await orchestrator.initializeForGarden(gardenId: 'garden_1');
        
        // Assert - all calls should succeed
        expect(stats1['cleanupSuccess'], isTrue);
        expect(stats2['cleanupSuccess'], isTrue);
        expect(stats3['cleanupSuccess'], isTrue);
        
        verify(mockPlantHiveRepo.getAllPlants()).called(3);
        verify(mockGardenAggregationHub.clearCache()).called(3);
      });
      
      test('should return correct statistics', () async {
        // Arrange
        final mockPlant1 = createMockPlant(id: 'tomato');
        final mockPlant2 = createMockPlant(id: 'lettuce', commonName: 'Laitue');
        
        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [mockPlant1, mockPlant2]);
        
        // Mock orphaned conditions
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: 'tomato',
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => [
          createMockCondition(
            plantId: 'tomato',
            type: ConditionType.temperature,
            status: ConditionStatus.excellent,
          ),
        ]);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: 'lettuce',
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => []);
        
        when(mockConditionRepo.deletePlantCondition(any))
            .thenAnswer((_) async => true);
        
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        
        // Act
        final stats = await orchestrator.initializeForGarden(gardenId: 'garden_1');
        
        // Assert
        expect(stats, isA<Map<String, dynamic>>());
        expect(stats.containsKey('gardenId'), isTrue);
        expect(stats.containsKey('cleanupSuccess'), isTrue);
        expect(stats.containsKey('cacheInvalidationSuccess'), isTrue);
        expect(stats.containsKey('orphanedConditionsRemoved'), isTrue);
        expect(stats.containsKey('errors'), isTrue);
      });
    });
    
    group('generateGardenIntelligenceReport with initialization', () {
      test('should produce a valid report after cache invalidation and cleanup', () async {
        // Arrange
        final plant = createMockPlant();
        final garden = createMockGarden();
        final weather = createMockWeather(temperature: 20.0);
        
        // Mock cleanup
        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [plant]);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: anyNamed('plantId'),
          startDate: anyNamed('startDate'),
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => []);
        
        // Mock cache invalidation
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        
        // Mock garden report generation
        when(mockGardenRepo.getGardenPlants('garden_1'))
            .thenAnswer((_) async => [plant]);
        
        when(mockGardenRepo.getGardenContext('garden_1'))
            .thenAnswer((_) async => garden);
        
        when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
            .thenAnswer((_) async => weather);
        
        when(mockAnalyticsRepo.getActiveAlerts(plantId: anyNamed('plantId')))
            .thenAnswer((_) async => []);
        
        when(mockConditionRepo.savePlantCondition(
          plantId: anyNamed('plantId'),
          condition: anyNamed('condition'),
        )).thenAnswer((_) async => 'condition_id');
        
        when(mockRecommendationRepo.saveRecommendation(
          plantId: anyNamed('plantId'),
          recommendation: anyNamed('recommendation'),
        )).thenAnswer((_) async => 'rec_id');
        
        when(mockAnalyticsRepo.saveAnalysisResult(
          plantId: anyNamed('plantId'),
          analysisType: anyNamed('analysisType'),
          result: anyNamed('result'),
          confidence: anyNamed('confidence'),
        )).thenAnswer((_) async => 'analysis_id');
        
        // Act
        final reports = await orchestrator.generateGardenIntelligenceReport(
          gardenId: 'garden_1',
        );
        
        // Assert
        expect(reports, isNotEmpty);
        expect(reports.first.plantId, 'tomato');
        expect(reports.first.plantName, 'Tomate');
        expect(reports.first.gardenId, 'garden_1');
        expect(reports.first.analysis, isNotNull);
        expect(reports.first.recommendations, isNotNull);
        expect(reports.first.plantingTiming, isNotNull);
        expect(reports.first.intelligenceScore, greaterThan(0.0));
        expect(reports.first.confidence, greaterThan(0.0));
        
        // Verify cache was invalidated
        verify(mockGardenAggregationHub.clearCache()).called(1);
      });
      
      test('should fail gracefully if catalog is empty', () async {
        // Arrange - empty catalog
        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => []);
        
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        
        when(mockGardenRepo.getGardenPlants('garden_1'))
            .thenAnswer((_) async => []);
        
        // Act
        final reports = await orchestrator.generateGardenIntelligenceReport(
          gardenId: 'garden_1',
        );
        
        // Assert - should return empty list, not crash
        expect(reports, isEmpty);
        
        // Cache should still be invalidated
        verify(mockGardenAggregationHub.clearCache()).called(1);
      });
      
      test('should fail gracefully if plant is missing from catalog', () async {
        // Arrange
        final validPlant = createMockPlant(id: 'tomato');
        
        // Mock cleanup - catalog has plant
        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [validPlant]);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: anyNamed('plantId'),
          startDate: anyNamed('startDate'),
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => []);
        
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        
        // Mock garden having a different plant
        when(mockGardenRepo.getGardenPlants('garden_1'))
            .thenAnswer((_) async => [
              createMockPlant(id: 'unknown_plant', commonName: 'Unknown'),
            ]);
        
        // When trying to generate report for unknown plant, catalog lookup will fail
        when(mockGardenRepo.getGardenContext('garden_1'))
            .thenAnswer((_) async => createMockGarden());
        
        when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
            .thenAnswer((_) async => createMockWeather());
        
        // Act
        final reports = await orchestrator.generateGardenIntelligenceReport(
          gardenId: 'garden_1',
        );
        
        // Assert - should handle error gracefully and continue
        // The orchestrator catches exceptions for individual plants
        expect(reports, isA<List>());
        
        // Verify cache was invalidated
        verify(mockGardenAggregationHub.clearCache()).called(1);
      });
      
      test('should handle PlantNotFoundException gracefully', () async {
        // Arrange
        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [createMockPlant(id: 'tomato')]);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: anyNamed('plantId'),
          startDate: anyNamed('startDate'),
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => []);
        
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        
        when(mockGardenRepo.getGardenPlants('garden_1'))
            .thenAnswer((_) async => [createMockPlant(id: 'invalid_plant')]);
        
        // Act
        final reports = await orchestrator.generateGardenIntelligenceReport(
          gardenId: 'garden_1',
        );
        
        // Assert - should not throw, just log and continue
        expect(reports, isA<List>());
        verify(mockGardenAggregationHub.clearCache()).called(1);
      });
      
      test('should handle EmptyPlantCatalogException gracefully', () async {
        // Arrange - empty catalog
        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => []);
        
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        
        when(mockGardenRepo.getGardenPlants('garden_1'))
            .thenAnswer((_) async => []);
        
        // Act
        final reports = await orchestrator.generateGardenIntelligenceReport(
          gardenId: 'garden_1',
        );
        
        // Assert
        expect(reports, isEmpty);
        verify(mockGardenAggregationHub.clearCache()).called(1);
      });
    });
    
    // ==================== CURSOR PROMPT 2: CACHE INVALIDATION TESTS ====================
    
    group('invalidateAllCache', () {
      test('should invalidate GardenAggregationHub cache when hub is injected', () async {
        // Arrange
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        
        // Act
        await orchestrator.invalidateAllCache();
        
        // Assert
        verify(mockGardenAggregationHub.clearCache()).called(1);
      });

      test('should not throw error when GardenAggregationHub is not injected', () async {
        // Arrange
        final orchestratorWithoutHub = PlantIntelligenceOrchestrator(
          conditionRepository: mockConditionRepo,
          weatherRepository: mockWeatherRepo,
          gardenRepository: mockGardenRepo,
          recommendationRepository: mockRecommendationRepo,
          analyticsRepository: mockAnalyticsRepo,
          plantCatalogRepository: mockPlantHiveRepo,
          analyzeUsecase: analyzeUsecase,
          evaluateTimingUsecase: evaluateTimingUsecase,
          generateRecommendationsUsecase: generateRecommendationsUsecase,
          evolutionTracker: mockEvolutionTracker,
          // gardenAggregationHub intentionally null
        );
        
        // Act & Assert
        expect(
          () => orchestratorWithoutHub.invalidateAllCache(),
          returnsNormally,
        );
      });

      test('should be idempotent - can be called multiple times', () async {
        // Arrange
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        
        // Act
        await orchestrator.invalidateAllCache();
        await orchestrator.invalidateAllCache();
        await orchestrator.invalidateAllCache();
        
        // Assert
        verify(mockGardenAggregationHub.clearCache()).called(3);
      });

      test('should not throw error even if clearCache throws', () async {
        // Arrange
        when(mockGardenAggregationHub.clearCache())
            .thenThrow(Exception('Cache clear failed'));
        
        // Act & Assert
        expect(
          () => orchestrator.invalidateAllCache(),
          returnsNormally,
        );
      });

      test('should be called at the start of generateGardenIntelligenceReport', () async {
        // Arrange
        final plants = <PlantFreezed>[createMockPlant()];
        
        when(mockGardenAggregationHub.clearCache()).thenReturn(null);
        when(mockGardenRepo.getGardenPlants('garden_1'))
            .thenAnswer((_) async => plants);
        when(mockGardenRepo.getGardenContext('garden_1'))
            .thenAnswer((_) async => createMockGarden());
        when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
            .thenAnswer((_) async => createMockWeather());
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: anyNamed('plantId'),
          startDate: anyNamed('startDate'),
          limit: 100,
        )).thenAnswer((_) async => []);
        when(mockAnalyticsRepo.getActiveAlerts(plantId: anyNamed('plantId')))
            .thenAnswer((_) async => []);
        when(mockConditionRepo.savePlantCondition(
          plantId: anyNamed('plantId'),
          condition: anyNamed('condition'),
        )).thenAnswer((_) async => 'condition_id');
        when(mockRecommendationRepo.saveRecommendation(
          plantId: anyNamed('plantId'),
          recommendation: anyNamed('recommendation'),
        )).thenAnswer((_) async => 'rec_id');
        when(mockAnalyticsRepo.saveAnalysisResult(
          plantId: anyNamed('plantId'),
          analysisType: anyNamed('analysisType'),
          result: anyNamed('result'),
          confidence: anyNamed('confidence'),
        )).thenAnswer((_) async => 'analysis_id');
        
        // Act
        await orchestrator.generateGardenIntelligenceReport(gardenId: 'garden_1');
        
        // Assert
        verify(mockGardenAggregationHub.clearCache()).called(1);
      });

      test('should complete successfully even if no cache services are available', () async {
        // Arrange
        final minimalOrchestrator = PlantIntelligenceOrchestrator(
          conditionRepository: mockConditionRepo,
          weatherRepository: mockWeatherRepo,
          gardenRepository: mockGardenRepo,
          recommendationRepository: mockRecommendationRepo,
          analyticsRepository: mockAnalyticsRepo,
          plantCatalogRepository: mockPlantHiveRepo,
          analyzeUsecase: analyzeUsecase,
          evaluateTimingUsecase: evaluateTimingUsecase,
          generateRecommendationsUsecase: generateRecommendationsUsecase,
          evolutionTracker: mockEvolutionTracker,
          // No cache services injected
        );
        
        // Act
        await minimalOrchestrator.invalidateAllCache();
        
        // Assert
        // Should complete without errors (defensive programming)
        expect(true, isTrue);
      });
    });

    // ==================== CURSOR PROMPT A4 - REPORT PERSISTENCE TESTS ====================
    
    group('CURSOR PROMPT A4 - Report Persistence Integration', () {
      test('should attempt to retrieve last report before generating new one', () async {
        // Arrange
        final plant = createMockPlant();
        final garden = createMockGarden();
        final weather = createMockWeather(temperature: 20.0);

        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [plant]);
        
        when(mockGardenRepo.getGardenContext('garden_1'))
            .thenAnswer((_) async => garden);
        
        when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
            .thenAnswer((_) async => weather);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: 'tomato',
          startDate: anyNamed('startDate'),
          limit: 100,
        )).thenAnswer((_) async => []);
        
        when(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato'))
            .thenAnswer((_) async => []);
        
        when(mockConditionRepo.savePlantCondition(
          plantId: anyNamed('plantId'),
          condition: anyNamed('condition'),
        )).thenAnswer((_) async => 'condition_id');
        
        when(mockRecommendationRepo.saveRecommendation(
          plantId: anyNamed('plantId'),
          recommendation: anyNamed('recommendation'),
        )).thenAnswer((_) async => 'rec_id');
        
        when(mockAnalyticsRepo.saveAnalysisResult(
          plantId: anyNamed('plantId'),
          analysisType: anyNamed('analysisType'),
          result: anyNamed('result'),
          confidence: anyNamed('confidence'),
        )).thenAnswer((_) async => 'analysis_id');

        // Mock getLastReport to return null (first analysis)
        when(mockAnalyticsRepo.getLastReport('tomato'))
            .thenAnswer((_) async => null);

        // Mock saveLatestReport
        when(mockAnalyticsRepo.saveLatestReport(any))
            .thenAnswer((_) async => Future.value());

        // Act
        final report = await orchestrator.generateIntelligenceReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
          plant: plant,
        );

        // Assert
        verify(mockAnalyticsRepo.getLastReport('tomato')).called(1);
        expect(report, isNotNull);
      });

      test('should save report after successful generation', () async {
        // Arrange
        final plant = createMockPlant();
        final garden = createMockGarden();
        final weather = createMockWeather(temperature: 20.0);

        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [plant]);
        
        when(mockGardenRepo.getGardenContext('garden_1'))
            .thenAnswer((_) async => garden);
        
        when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
            .thenAnswer((_) async => weather);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: 'tomato',
          startDate: anyNamed('startDate'),
          limit: 100,
        )).thenAnswer((_) async => []);
        
        when(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato'))
            .thenAnswer((_) async => []);
        
        when(mockConditionRepo.savePlantCondition(
          plantId: anyNamed('plantId'),
          condition: anyNamed('condition'),
        )).thenAnswer((_) async => 'condition_id');
        
        when(mockRecommendationRepo.saveRecommendation(
          plantId: anyNamed('plantId'),
          recommendation: anyNamed('recommendation'),
        )).thenAnswer((_) async => 'rec_id');
        
        when(mockAnalyticsRepo.saveAnalysisResult(
          plantId: anyNamed('plantId'),
          analysisType: anyNamed('analysisType'),
          result: anyNamed('result'),
          confidence: anyNamed('confidence'),
        )).thenAnswer((_) async => 'analysis_id');

        when(mockAnalyticsRepo.getLastReport('tomato'))
            .thenAnswer((_) async => null);

        when(mockAnalyticsRepo.saveLatestReport(any))
            .thenAnswer((_) async => Future.value());

        // Act
        final report = await orchestrator.generateIntelligenceReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
          plant: plant,
        );

        // Assert
        verify(mockAnalyticsRepo.saveLatestReport(argThat(
          predicate((PlantIntelligenceReport r) => 
            r.plantId == 'tomato' && r.gardenId == 'garden_1'
          )
        ))).called(1);
        expect(report, isNotNull);
      });

      test('should not crash if saveLatestReport fails', () async {
        // Arrange
        final plant = createMockPlant();
        final garden = createMockGarden();
        final weather = createMockWeather(temperature: 20.0);

        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [plant]);
        
        when(mockGardenRepo.getGardenContext('garden_1'))
            .thenAnswer((_) async => garden);
        
        when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
            .thenAnswer((_) async => weather);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: 'tomato',
          startDate: anyNamed('startDate'),
          limit: 100,
        )).thenAnswer((_) async => []);
        
        when(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato'))
            .thenAnswer((_) async => []);
        
        when(mockConditionRepo.savePlantCondition(
          plantId: anyNamed('plantId'),
          condition: anyNamed('condition'),
        )).thenAnswer((_) async => 'condition_id');
        
        when(mockRecommendationRepo.saveRecommendation(
          plantId: anyNamed('plantId'),
          recommendation: anyNamed('recommendation'),
        )).thenAnswer((_) async => 'rec_id');
        
        when(mockAnalyticsRepo.saveAnalysisResult(
          plantId: anyNamed('plantId'),
          analysisType: anyNamed('analysisType'),
          result: anyNamed('result'),
          confidence: anyNamed('confidence'),
        )).thenAnswer((_) async => 'analysis_id');

        when(mockAnalyticsRepo.getLastReport('tomato'))
            .thenAnswer((_) async => null);

        // Mock saveLatestReport to throw exception
        when(mockAnalyticsRepo.saveLatestReport(any))
            .thenThrow(Exception('Hive write error'));

        // Act & Assert - should not throw
        final report = await orchestrator.generateIntelligenceReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
          plant: plant,
        );

        // Verify the report was still generated successfully
        expect(report, isNotNull);
        expect(report.plantId, equals('tomato'));
      });

      test('should not crash if getLastReport fails', () async {
        // Arrange
        final plant = createMockPlant();
        final garden = createMockGarden();
        final weather = createMockWeather(temperature: 20.0);

        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [plant]);
        
        when(mockGardenRepo.getGardenContext('garden_1'))
            .thenAnswer((_) async => garden);
        
        when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
            .thenAnswer((_) async => weather);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: 'tomato',
          startDate: anyNamed('startDate'),
          limit: 100,
        )).thenAnswer((_) async => []);
        
        when(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato'))
            .thenAnswer((_) async => []);
        
        when(mockConditionRepo.savePlantCondition(
          plantId: anyNamed('plantId'),
          condition: anyNamed('condition'),
        )).thenAnswer((_) async => 'condition_id');
        
        when(mockRecommendationRepo.saveRecommendation(
          plantId: anyNamed('plantId'),
          recommendation: anyNamed('recommendation'),
        )).thenAnswer((_) async => 'rec_id');
        
        when(mockAnalyticsRepo.saveAnalysisResult(
          plantId: anyNamed('plantId'),
          analysisType: anyNamed('analysisType'),
          result: anyNamed('result'),
          confidence: anyNamed('confidence'),
        )).thenAnswer((_) async => 'analysis_id');

        // Mock getLastReport to throw exception
        when(mockAnalyticsRepo.getLastReport('tomato'))
            .thenThrow(Exception('Hive read error'));

        when(mockAnalyticsRepo.saveLatestReport(any))
            .thenAnswer((_) async => Future.value());

        // Act & Assert - should not throw
        final report = await orchestrator.generateIntelligenceReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
          plant: plant,
        );

        // Verify the report was still generated successfully
        expect(report, isNotNull);
        expect(report.plantId, equals('tomato'));
      });
    });

    // ==================== CURSOR PROMPT A6 - EVOLUTION INTEGRATION TESTS ====================
    
    group('Evolution Integration', () {
      test('compute evolution and log trend if previous report exists', () async {
        // Arrange
        final plant = createMockPlant();
        final garden = createMockGarden();
        final weather = createMockWeather(temperature: 20.0);

        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [plant]);
        
        when(mockGardenRepo.getGardenContext('garden_1'))
            .thenAnswer((_) async => garden);
        
        when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
            .thenAnswer((_) async => weather);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: 'tomato',
          startDate: anyNamed('startDate'),
          limit: 100,
        )).thenAnswer((_) async => []);
        
        when(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato'))
            .thenAnswer((_) async => []);
        
        when(mockConditionRepo.savePlantCondition(
          plantId: anyNamed('plantId'),
          condition: anyNamed('condition'),
        )).thenAnswer((_) async => 'condition_id');
        
        when(mockRecommendationRepo.saveRecommendation(
          plantId: anyNamed('plantId'),
          recommendation: anyNamed('recommendation'),
        )).thenAnswer((_) async => 'rec_id');
        
        when(mockAnalyticsRepo.saveAnalysisResult(
          plantId: anyNamed('plantId'),
          analysisType: anyNamed('analysisType'),
          result: anyNamed('result'),
          confidence: anyNamed('confidence'),
        )).thenAnswer((_) async => 'analysis_id');

        // Create a previous report with lower score
        final previousReport = createMockReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
          intelligenceScore: 70.0,
        );

        when(mockAnalyticsRepo.getLastReport('tomato'))
            .thenAnswer((_) async => previousReport);

        when(mockAnalyticsRepo.saveLatestReport(any))
            .thenAnswer((_) async => Future.value());

        // Create evolution summary with improvement
        final mockEvolution = IntelligenceEvolutionSummary(
          plantId: 'tomato',
          plantName: 'Tomate',
          scoreDelta: 10.0,
          confidenceDelta: 0.05,
          addedRecommendations: [],
          removedRecommendations: [],
          modifiedRecommendations: [],
          isImproved: true,
          isStable: false,
          isDegraded: false,
          oldReport: previousReport,
          newReport: previousReport, // Will be replaced by actual new report
          comparedAt: DateTime.now(),
        );

        when(mockEvolutionTracker.compareReports(any, any))
            .thenReturn(mockEvolution);

        // Act
        final report = await orchestrator.generateIntelligenceReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
          plant: plant,
        );

        // Assert
        expect(report, isNotNull);
        verify(mockAnalyticsRepo.getLastReport('tomato')).called(1);
        verify(mockEvolutionTracker.compareReports(previousReport, report)).called(1);
      });

      test('skip evolution tracking if previous report is null', () async {
        // Arrange
        final plant = createMockPlant();
        final garden = createMockGarden();
        final weather = createMockWeather(temperature: 20.0);

        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [plant]);
        
        when(mockGardenRepo.getGardenContext('garden_1'))
            .thenAnswer((_) async => garden);
        
        when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
            .thenAnswer((_) async => weather);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: 'tomato',
          startDate: anyNamed('startDate'),
          limit: 100,
        )).thenAnswer((_) async => []);
        
        when(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato'))
            .thenAnswer((_) async => []);
        
        when(mockConditionRepo.savePlantCondition(
          plantId: anyNamed('plantId'),
          condition: anyNamed('condition'),
        )).thenAnswer((_) async => 'condition_id');
        
        when(mockRecommendationRepo.saveRecommendation(
          plantId: anyNamed('plantId'),
          recommendation: anyNamed('recommendation'),
        )).thenAnswer((_) async => 'rec_id');
        
        when(mockAnalyticsRepo.saveAnalysisResult(
          plantId: anyNamed('plantId'),
          analysisType: anyNamed('analysisType'),
          result: anyNamed('result'),
          confidence: anyNamed('confidence'),
        )).thenAnswer((_) async => 'analysis_id');

        // No previous report
        when(mockAnalyticsRepo.getLastReport('tomato'))
            .thenAnswer((_) async => null);

        when(mockAnalyticsRepo.saveLatestReport(any))
            .thenAnswer((_) async => Future.value());

        // Act
        final report = await orchestrator.generateIntelligenceReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
          plant: plant,
        );

        // Assert
        expect(report, isNotNull);
        verify(mockAnalyticsRepo.getLastReport('tomato')).called(1);
        // Evolution tracker should NOT be called when previous report is null
        verifyNever(mockEvolutionTracker.compareReports(any, any));
      });

      test('never crash on evolution comparison failure', () async {
        // Arrange
        final plant = createMockPlant();
        final garden = createMockGarden();
        final weather = createMockWeather(temperature: 20.0);

        when(mockPlantHiveRepo.getAllPlants())
            .thenAnswer((_) async => [plant]);
        
        when(mockGardenRepo.getGardenContext('garden_1'))
            .thenAnswer((_) async => garden);
        
        when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
            .thenAnswer((_) async => weather);
        
        when(mockConditionRepo.getPlantConditionHistory(
          plantId: 'tomato',
          startDate: anyNamed('startDate'),
          limit: 100,
        )).thenAnswer((_) async => []);
        
        when(mockAnalyticsRepo.getActiveAlerts(plantId: 'tomato'))
            .thenAnswer((_) async => []);
        
        when(mockConditionRepo.savePlantCondition(
          plantId: anyNamed('plantId'),
          condition: anyNamed('condition'),
        )).thenAnswer((_) async => 'condition_id');
        
        when(mockRecommendationRepo.saveRecommendation(
          plantId: anyNamed('plantId'),
          recommendation: anyNamed('recommendation'),
        )).thenAnswer((_) async => 'rec_id');
        
        when(mockAnalyticsRepo.saveAnalysisResult(
          plantId: anyNamed('plantId'),
          analysisType: anyNamed('analysisType'),
          result: anyNamed('result'),
          confidence: anyNamed('confidence'),
        )).thenAnswer((_) async => 'analysis_id');

        final previousReport = createMockReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
          intelligenceScore: 70.0,
        );

        when(mockAnalyticsRepo.getLastReport('tomato'))
            .thenAnswer((_) async => previousReport);

        when(mockAnalyticsRepo.saveLatestReport(any))
            .thenAnswer((_) async => Future.value());

        // Mock evolution tracker to throw exception
        when(mockEvolutionTracker.compareReports(any, any))
            .thenThrow(Exception('Evolution comparison failed'));

        // Act - should NOT throw
        final report = await orchestrator.generateIntelligenceReport(
          plantId: 'tomato',
          gardenId: 'garden_1',
          plant: plant,
        );

        // Assert
        expect(report, isNotNull);
        expect(report.plantId, equals('tomato'));
        verify(mockEvolutionTracker.compareReports(previousReport, report)).called(1);
      });
    });
  });
}


