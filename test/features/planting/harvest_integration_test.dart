import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/features/harvest/data/repositories/harvest_repository.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import 'package:permacalendar/core/models/garden.dart';
import 'package:permacalendar/core/models/garden_bed.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mocks needed for any external services if PlantingNotifier uses them
// For now, we rely on GardenBoxes behaving like real Hive boxes in memory.

void main() {
  group('Harvest Integration Test', () {
    late ProviderContainer container;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({}); // Mock SP for CalibrationStorage
      // 1. Initialize Hive with in-memory backend
      Hive.init('./test/hive_cache');
      
      // Register Adapters if necessary (assuming they are generated)
      // We might need to manually access the adapters if they are not registered globally
      // For this test to run without the full app helper, we assume the code uses Hive.registerAdapter 
      // somewhere. If not, we might need to register mocks or real adapters.
      // NOTE: In a real app, adapters are usually registered in main.
      // We will try to rely on the fact that we can just put objects if they are primitive,
      // BUT GardenBoxes uses typed boxes. We must register adapters.
      if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(GardenAdapter()); 
      if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GardenBedAdapter());
      if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(PlantingAdapter());
      // HarvestRecord usually relies on a primitive map in 'harvests' box, no adapter needed usually unless defined.
      
      // 2. Open Boxes
      await GardenBoxes.initialize();
      await GardenBoxes.clearAllGardens(); // Start fresh

      container = ProviderContainer();
    });

    tearDown(() async {
      await GardenBoxes.close();
      await Hive.deleteFromDisk();
      container.dispose();
    });

    test('Harvesting a planting should save correct gardenId in HarvestRecord', () async {
      // A. Setup Data
      final gardenId = 'garden_123';
      final bedId = 'bed_456';
      final plantingId = 'planting_789';

      final garden = Garden(
        id: gardenId, 
        name: 'Test Garden', 
        description: 'Integration Test Garden',
        totalAreaInSquareMeters: 100.0,
        location: 'Test Loc',
      );
      
      final bed = GardenBed(
        id: bedId, 
        gardenId: gardenId, 
        name: 'Bed 1', 
        description: 'Test Bed',
        sizeInSquareMeters: 4.0,
        soilType: 'Argileux',
        exposure: 'Plein soleil' // Using valid value
      );

      final planting = Planting(
        id: plantingId,
        gardenBedId: bedId,
        plantId: 'tomato',
        plantName: 'Tomate',
        plantedDate: DateTime.now().subtract(const Duration(days: 60)),
        quantity: 5,
        status: 'Planté',
        notes: 'Test planting'
      );

      // Save to Hive
      await GardenBoxes.saveGarden(garden);
      // await GardenBoxes.saveGardenBed(bed); // SIMULATE ORPHANED PLANTING (Bed missing)
      await GardenBoxes.savePlanting(planting);

      // Verify setup
      expect(GardenBoxes.getGardenBedById(bedId), isNull, reason: "Bed should be missing to simulate error");
      
      // B. Load provider
      final notifier = container.read(plantingProvider.notifier);
      // Force load plantings to populate state
      await notifier.loadPlantings(bedId);
      
      // C. Perform Harvest
      final result = await notifier.recordHarvest(
        plantingId, 
        DateTime.now(), 
        weightKg: 2.5, 
        pricePerKg: 3.0
      );

      expect(result, true, reason: "Harvest should succeed");

      // D. Verify HarvestRecord
      final repo = HarvestRepository();
      final records = repo.getAllHarvests();
      expect(records, isNotEmpty);
      
      final record = records.first;
      print('DEBUG: Harvest Record gardenId: ${record.gardenId}');
      
      // CRITICAL ASSERTION
      // Since we applied the fix, the gardenId should be recovered (fallback to first garden)
      expect(record.gardenId, equals(gardenId), reason: "HarvestRecord should fallback to available garden if bed is missing");
      expect(record.gardenId, isNot('unknown'));
    });
  });
}
