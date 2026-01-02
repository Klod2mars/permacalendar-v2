import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:permacalendar/features/home/providers/calendar_aggregation_provider.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/models/activity_v3.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import 'package:permacalendar/core/providers/activity_tracker_v3_provider.dart';
import 'package:permacalendar/core/services/activity_tracker_v3.dart';

// Manual Adapter backup if generated one is not accessible or to avoid build runner dependency issues in test environment
class MockPlantingAdapter extends TypeAdapter<Planting> {
  @override
  final int typeId = 3;

  @override
  Planting read(BinaryReader reader) {
    // Minimal impl for test reading if we wrote manually (but we stick to objects in memory for tests usually)
    // Hive memory box stores objects directly if not compacted? No, it serializes.
    // For unit tests with hive_test, usually valid objects are needed.
    // If we can't use real adapter, we might struggle with openBox checks.
    // But setUpTestHive uses in-memory backend?
    throw UnimplementedError();
  }

  @override
  void write(BinaryWriter writer, Planting obj) {
    throw UnimplementedError();
  }
}

void main() {
  group('calendarAggregationProvider', () {
    late ProviderContainer container;

    setUp(() async {
      print('Setting up test hive...');
      await setUpTestHive();

      try {
        if (!Hive.isAdapterRegistered(3)) {
          print('Registering PlantingAdapter...');
          Hive.registerAdapter(PlantingAdapter());
        }
        if (!Hive.isAdapterRegistered(30)) {
          print('Registering ActivityV3Adapter...');
          Hive.registerAdapter(ActivityV3Adapter());
        }

        print('Initializing GardenBoxes...');
        await GardenBoxes.initialize();
        print('GardenBoxes initialized.');
      } catch (e, st) {
        print('Error in setup: $e');
        print(st);
        rethrow;
      }

      container = ProviderContainer(
        overrides: [
          activityTrackerInitializedProvider.overrideWithValue(true),
          activityTrackerV3Provider.overrideWithValue(ActivityTrackerV3()),
        ],
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
        return null;
      });
    });

    tearDown(() async {
      await GardenBoxes.close();
      await tearDownTestHive();
      container.dispose();
    });

    test('should return empty zeros map for empty month', () async {
      final month = DateTime(2025, 5, 1);
      final result =
          await container.read(calendarAggregationProvider(month).future);
      expect(result['2025-05-01']!['plantingCount'], 0);
    });

    test('should count plantings correctly', () async {
      final month = DateTime(2025, 6, 1);
      final box = GardenBoxes.plantings;

      final p1 = Planting(
        id: '1',
        gardenBedId: 'b1',
        plantId: 'tomate',
        plantName: 'Tomate',
        plantedDate: DateTime(2025, 6, 15),
        quantity: 10,
        status: 'Planté',
        metadata: {}, // Fix for potential null check issues depending on constructor
      );

      await box.put('1', p1);

      final result =
          await container.read(calendarAggregationProvider(month).future);
      expect(result['2025-06-15']!['plantingCount'], 1);
    });
  });
}
