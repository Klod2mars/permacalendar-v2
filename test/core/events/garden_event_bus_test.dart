import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/events/garden_event_bus.dart';
import 'package:permacalendar/core/events/garden_events.dart';

void main() {
  group('GardenEventBus', () {
    late GardenEventBus eventBus;
    
    setUp(() {
      eventBus = GardenEventBus();
      eventBus.resetStats();
    });
    
    tearDown(() {
      // Ne pas disposer car c'est un singleton
      eventBus.resetStats();
    });
    
    test('should emit plantingAdded event', () async {
      // Arrange
      final List<GardenEvent> receivedEvents = [];
      
      final subscription = eventBus.events.listen((event) {
        receivedEvents.add(event);
      });
      
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
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(receivedEvents, hasLength(1));
      expect(receivedEvents.first, isA<PlantingAddedEvent>());
      
      receivedEvents.first.when(
        plantingAdded: (gardenId, plantingId, plantId, timestamp, metadata) {
          expect(gardenId, 'garden_1');
          expect(plantingId, 'planting_1');
          expect(plantId, 'tomato');
        },
        plantingHarvested: (_, __, ___, ____, _____) => fail('Wrong event type'),
        weatherChanged: (_, __, ___, ____, _____) => fail('Wrong event type'),
        activityPerformed: (_, __, ___, ____, _____) => fail('Wrong event type'),
        gardenContextUpdated: (_, __, ___) => fail('Wrong event type'),
      );
      
      await subscription.cancel();
    });
    
    test('should emit plantingHarvested event', () async {
      // Arrange
      final List<GardenEvent> receivedEvents = [];
      
      final subscription = eventBus.events.listen((event) {
        receivedEvents.add(event);
      });
      
      // Act
      eventBus.emit(
        GardenEvent.plantingHarvested(
          gardenId: 'garden_1',
          plantingId: 'planting_1',
          harvestYield: 5.0,
          timestamp: DateTime.now(),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(receivedEvents, hasLength(1));
      expect(receivedEvents.first, isA<PlantingHarvestedEvent>());
      
      await subscription.cancel();
    });
    
    test('should emit weatherChanged event', () async {
      // Arrange
      final List<GardenEvent> receivedEvents = [];
      
      final subscription = eventBus.events.listen((event) {
        receivedEvents.add(event);
      });
      
      // Act
      eventBus.emit(
        GardenEvent.weatherChanged(
          gardenId: 'garden_1',
          previousTemperature: 15.0,
          currentTemperature: 22.0,
          timestamp: DateTime.now(),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(receivedEvents, hasLength(1));
      expect(receivedEvents.first, isA<WeatherChangedEvent>());
      
      receivedEvents.first.when(
        plantingAdded: (_, __, ___, ____, _____) => fail('Wrong event type'),
        plantingHarvested: (_, __, ___, ____, _____) => fail('Wrong event type'),
        weatherChanged: (gardenId, prevTemp, currTemp, timestamp, metadata) {
          expect(gardenId, 'garden_1');
          expect(prevTemp, 15.0);
          expect(currTemp, 22.0);
          expect(currTemp - prevTemp, 7.0);
        },
        activityPerformed: (_, __, ___, ____, _____) => fail('Wrong event type'),
        gardenContextUpdated: (_, __, ___) => fail('Wrong event type'),
      );
      
      await subscription.cancel();
    });
    
    test('should emit activityPerformed event', () async {
      // Arrange
      final List<GardenEvent> receivedEvents = [];
      
      final subscription = eventBus.events.listen((event) {
        receivedEvents.add(event);
      });
      
      // Act
      eventBus.emit(
        GardenEvent.activityPerformed(
          gardenId: 'garden_1',
          activityType: 'watering',
          targetId: 'planting_1',
          timestamp: DateTime.now(),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(receivedEvents, hasLength(1));
      expect(receivedEvents.first, isA<ActivityPerformedEvent>());
      
      await subscription.cancel();
    });
    
    test('should track event count', () {
      // Arrange & Act
      eventBus.emit(
        GardenEvent.plantingAdded(
          gardenId: 'garden_1',
          plantingId: 'planting_1',
          plantId: 'tomato',
          timestamp: DateTime.now(),
        ),
      );
      
      eventBus.emit(
        GardenEvent.weatherChanged(
          gardenId: 'garden_1',
          previousTemperature: 15.0,
          currentTemperature: 22.0,
          timestamp: DateTime.now(),
        ),
      );
      
      // Assert
      expect(eventBus.eventCount, 2);
    });
    
    test('should handle multiple listeners', () async {
      // Arrange
      final List<GardenEvent> listener1Events = [];
      final List<GardenEvent> listener2Events = [];
      
      final subscription1 = eventBus.events.listen((event) {
        listener1Events.add(event);
      });
      
      final subscription2 = eventBus.events.listen((event) {
        listener2Events.add(event);
      });
      
      // Act
      eventBus.emit(
        GardenEvent.plantingAdded(
          gardenId: 'garden_1',
          plantingId: 'planting_1',
          plantId: 'tomato',
          timestamp: DateTime.now(),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(listener1Events, hasLength(1));
      expect(listener2Events, hasLength(1));
      
      await subscription1.cancel();
      await subscription2.cancel();
    });
    
    test('should reset stats', () {
      // Arrange
      eventBus.emit(
        GardenEvent.plantingAdded(
          gardenId: 'garden_1',
          plantingId: 'planting_1',
          plantId: 'tomato',
          timestamp: DateTime.now(),
        ),
      );
      
      expect(eventBus.eventCount, 1);
      
      // Act
      eventBus.resetStats();
      
      // Assert
      expect(eventBus.eventCount, 0);
    });
  });
}
