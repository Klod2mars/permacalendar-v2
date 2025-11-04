import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:permacalendar/core/services/garden_event_observer_service.dart';
import 'package:permacalendar/core/events/garden_event_bus.dart';
import 'package:permacalendar/core/events/garden_events.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/plant_intelligence_orchestrator.dart';

import 'garden_event_observer_service_test.mocks.dart';
import '../../helpers/plant_intelligence_test_helpers.dart';

@GenerateMocks([PlantIntelligenceOrchestrator])
void main() {
  group('GardenEventObserverService', () {
    late GardenEventObserverService service;
    late MockPlantIntelligenceOrchestrator mockOrchestrator;
    late GardenEventBus eventBus;
    
    setUp(() {
      service = GardenEventObserverService.instance;
      mockOrchestrator = MockPlantIntelligenceOrchestrator();
      eventBus = GardenEventBus();
      eventBus.resetStats();
      service.resetStats();
    });
    
    tearDown(() {
      service.dispose();
    });
    
    test('should initialize correctly', () {
      // Act
      service.initialize(orchestrator: mockOrchestrator);
      
      // Assert
      expect(service.isInitialized, isTrue);
    });
    
    test('should handle plantingAdded event and trigger analysis', () async {
      // Arrange
      service.initialize(orchestrator: mockOrchestrator);
      
      final mockReport = createMockReport(
        plantId: 'tomato',
        gardenId: 'garden_1',
      );
      
      when(mockOrchestrator.generateIntelligenceReport(
        plantId: anyNamed('plantId'),
        gardenId: anyNamed('gardenId'),
      )).thenAnswer((_) async => mockReport);
      
      // Act
      eventBus.emit(
        GardenEvent.plantingAdded(
          gardenId: 'garden_1',
          plantingId: 'planting_1',
          plantId: 'tomato',
          timestamp: DateTime.now(),
        ),
      );
      
      // Wait for event to be processed
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Assert
      verify(mockOrchestrator.generateIntelligenceReport(
        plantId: 'tomato',
        gardenId: 'garden_1',
      )).called(1);
      
      final stats = service.getStats();
      expect(stats.plantingEventsCount, 1);
      expect(stats.analysisTriggeredCount, 1);
    });
    
    test('should handle plantingHarvested event without triggering analysis', () async {
      // Arrange
      service.initialize(orchestrator: mockOrchestrator);
      
      // Act
      eventBus.emit(
        GardenEvent.plantingHarvested(
          gardenId: 'garden_1',
          plantingId: 'planting_1',
          harvestYield: 5.0,
          timestamp: DateTime.now(),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Assert
      verifyNever(mockOrchestrator.generateIntelligenceReport(
        plantId: anyNamed('plantId'),
        gardenId: anyNamed('gardenId'),
      ));
      
      final stats = service.getStats();
      expect(stats.harvestEventsCount, 1);
      expect(stats.analysisTriggeredCount, 0);
    });
    
    test('should handle weatherChanged event and trigger garden analysis when significant', () async {
      // Arrange
      service.initialize(orchestrator: mockOrchestrator);
      
      final mockReports = [
        createMockReport(plantId: 'tomato', gardenId: 'garden_1'),
        createMockReport(plantId: 'lettuce', gardenId: 'garden_1'),
      ];
      
      when(mockOrchestrator.generateGardenIntelligenceReport(
        gardenId: anyNamed('gardenId'),
      )).thenAnswer((_) async => mockReports);
      
      // Act - Changement > 5°C (significatif)
      eventBus.emit(
        GardenEvent.weatherChanged(
          gardenId: 'garden_1',
          previousTemperature: 15.0,
          currentTemperature: 22.0, // Δ 7°C
          timestamp: DateTime.now(),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Assert
      verify(mockOrchestrator.generateGardenIntelligenceReport(
        gardenId: 'garden_1',
      )).called(1);
      
      final stats = service.getStats();
      expect(stats.weatherEventsCount, 1);
      expect(stats.analysisTriggeredCount, 2); // 2 plantes analysées
    });
    
    test('should NOT trigger analysis for minor weather change', () async {
      // Arrange
      service.initialize(orchestrator: mockOrchestrator);
      
      // Act - Changement < 5°C (non significatif)
      eventBus.emit(
        GardenEvent.weatherChanged(
          gardenId: 'garden_1',
          previousTemperature: 20.0,
          currentTemperature: 23.0, // Δ 3°C
          timestamp: DateTime.now(),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Assert
      verifyNever(mockOrchestrator.generateGardenIntelligenceReport(
        gardenId: anyNamed('gardenId'),
      ));
      
      final stats = service.getStats();
      expect(stats.weatherEventsCount, 1);
      expect(stats.analysisTriggeredCount, 0);
    });
    
    test('should handle activityPerformed event', () async {
      // Arrange
      service.initialize(orchestrator: mockOrchestrator);
      
      // Act
      eventBus.emit(
        GardenEvent.activityPerformed(
          gardenId: 'garden_1',
          activityType: 'watering',
          targetId: 'planting_1',
          timestamp: DateTime.now(),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Assert
      final stats = service.getStats();
      expect(stats.activityEventsCount, 1);
    });
    
    test('should track statistics correctly', () async {
      // Arrange
      service.initialize(orchestrator: mockOrchestrator);
      
      final mockReport = createMockReport(
        plantId: 'tomato',
        gardenId: 'garden_1',
      );
      
      when(mockOrchestrator.generateIntelligenceReport(
        plantId: anyNamed('plantId'),
        gardenId: anyNamed('gardenId'),
      )).thenAnswer((_) async => mockReport);
      
      // Act - Émettre plusieurs événements
      eventBus.emit(
        GardenEvent.plantingAdded(
          gardenId: 'garden_1',
          plantingId: 'planting_1',
          plantId: 'tomato',
          timestamp: DateTime.now(),
        ),
      );
      
      eventBus.emit(
        GardenEvent.plantingHarvested(
          gardenId: 'garden_1',
          plantingId: 'planting_1',
          harvestYield: 5.0,
          timestamp: DateTime.now(),
        ),
      );
      
      eventBus.emit(
        GardenEvent.activityPerformed(
          gardenId: 'garden_1',
          activityType: 'watering',
          targetId: 'planting_1',
          timestamp: DateTime.now(),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Assert
      final stats = service.getStats();
      expect(stats.plantingEventsCount, 1);
      expect(stats.harvestEventsCount, 1);
      expect(stats.activityEventsCount, 1);
      expect(stats.totalEventsCount, 3);
      expect(stats.analysisTriggeredCount, 1);
    });
    
    test('should handle errors gracefully', () async {
      // Arrange
      service.initialize(orchestrator: mockOrchestrator);
      
      when(mockOrchestrator.generateIntelligenceReport(
        plantId: anyNamed('plantId'),
        gardenId: anyNamed('gardenId'),
      )).thenThrow(Exception('Test error'));
      
      // Act
      eventBus.emit(
        GardenEvent.plantingAdded(
          gardenId: 'garden_1',
          plantingId: 'planting_1',
          plantId: 'tomato',
          timestamp: DateTime.now(),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Assert - L'erreur est loggée mais ne crash pas
      final stats = service.getStats();
      expect(stats.plantingEventsCount, 1);
      expect(stats.analysisErrorCount, 1);
    });
  });
}
