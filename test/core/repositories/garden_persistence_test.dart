
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Just specific imports if needed, though hive_flutter usually exports hive.
import 'package:permacalendar/core/models/garden_hive.dart';
import 'package:permacalendar/core/models/garden_bed_hive.dart';
import 'package:permacalendar/core/models/garden_freezed.dart';
import 'package:permacalendar/core/repositories/garden_hive_repository.dart';
import 'package:uuid/uuid.dart';

// Since we can't easily import generated adapters without generic imports or exact paths, 
// and `AppInitializer` does it, we'll implement a minimal setup for the test.

void main() {
  group('GardenHiveRepository Persistence Fix', () {
    late Directory tempDir;
    late GardenHiveRepository repository;

    setUp(() async {
      // Create a temporary directory for Hive
      tempDir = await Directory.systemTemp.createTemp('hive_test_');
      
      // Initialize Hive
      Hive.init(tempDir.path);

      // Register Adapters
      // We assume adapters are generated in .g.dart files which are parts of moddel files.
      // So importing models should be enough if we use the generated Adapter classes.
      // However, we need to instantiate them.
      // Checking AppInitializer: Hive.registerAdapter(GardenHiveAdapter());
      
      try {
        if (!Hive.isAdapterRegistered(25)) Hive.registerAdapter(GardenHiveAdapter());
        if (!Hive.isAdapterRegistered(26)) Hive.registerAdapter(GardenBedHiveAdapter());
      } catch (e) {
        // Ignore if already registered
      }

      // Initialize Repository
      // We need to bypass the static initialization that uses getApplicationDocumentsDirectory
      // For this test, we can manually open the box if the repository allows injection or if we mock the box opening.
      // The current repository implementation uses a static _box and static initialize().
      // This is hard to test without mocking getApplicationDocumentsDirectory (path_provider).
      // BUT, Hive.init(tempDir.path) might be enough if we can override where getApplicationDocumentsDirectory points to
      // OR if we assume the test environment runs without path_provider dependency issues (Flutter test usually creates a mock environment).
      
      // Better approach for unit test: Use `Hive.openBox` directly and assume the repo uses the opened box.
      // The repository code: _openBoxWithRetry uses generic Hive.openBox.
      // If we open it first, subsequent calls *might* just return the opened box.
      
      await Hive.openBox<GardenHive>('gardens_hive');
      
      // We have to set the static _box in the repo? 
      // The repo has: static Box<GardenHive>? _box;
      // And: static Future<void> initialize() async { _box = ... }
      // We can try calling initialize(). However, it prints and uses getApplicationDocumentsDirectory in catch block potentially?
      // No, `_openBoxWithRetry` calls `Hive.openBox`.
      // If we initialize Hive with a path, `Hive.openBox` should work in that path.
      
      // Let's rely on the fact that `Hive.init` sets the home for boxes.
      await GardenHiveRepository.initialize();
      
      repository = GardenHiveRepository();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
      try {
        await tempDir.delete(recursive: true);
      } catch (_) {}
    });

    test('updateGarden should preserve gardenBeds', () async {
      // 1. Create a Hive Garden directly with beds to simulate existing state
      final bedId = const Uuid().v4();
      final gardenId = const Uuid().v4();
      
      final bed = GardenBedHive(
        id: bedId,
        name: 'Bed 1',
        sizeInSquareMeters: 6.0,
        gardenId: gardenId,
        plantingIds: [],
      );

      final hiveGarden = GardenHive(
        id: gardenId,
        name: 'My Old Garden',
        description: 'Original description',
        createdDate: DateTime.now(),
        gardenBeds: [bed],
      );

      // Manually access the box to put invalid state (or just use repo to create it if create supports beds? No, create takes GardenFreezed which lacks beds)
      // So we must manipulate the HiveBox directly to set up the "Pre-condition".
      final box = Hive.box<GardenHive>('gardens_hive');
      await box.put(gardenId, hiveGarden);

      // Verify setup
      final storedRaw = box.get(gardenId);
      expect(storedRaw!.gardenBeds.length, 1, reason: 'Setup failed: Bed not saved');

      // 2. Prepare an update via GardenFreezed (which simulates the UI sending an update)
      // GardenFreezed DOES NOT have beds.
      final updateData = GardenFreezed(
        id: gardenId,
        name: 'My New Garden Name',
        description: 'Updated description',
        totalAreaInSquareMeters: 100.0,
        location: 'Paris',
        createdAt: hiveGarden.createdDate,
        updatedAt: DateTime.now(),
        metadata: {},
        isActive: true,
      );

      // 3. Call updateGarden
      final success = await repository.updateGarden(updateData);
      expect(success, true);

      // 4. Verify Persistence
      final updatedHiveGarden = box.get(gardenId);
      expect(updatedHiveGarden, isNotNull);
      expect(updatedHiveGarden!.name, 'My New Garden Name');
      expect(updatedHiveGarden.description, 'Updated description');
      
      // CRITICAL CHECK
      expect(updatedHiveGarden.gardenBeds.length, 1, reason: 'Persistence FAILURE: Beds were deleted!');
      expect(updatedHiveGarden.gardenBeds.first.id, bedId);
    });
  });
}
