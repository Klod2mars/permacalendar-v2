import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import 'package:permacalendar/core/models/garden.dart';
import 'package:permacalendar/core/models/garden_freezed.dart';
import 'package:permacalendar/core/providers/active_garden_provider.dart';
import 'package:permacalendar/features/statistics/presentation/providers/statistics_filters_provider.dart';
import 'package:permacalendar/features/export/presentation/providers/export_builder_provider.dart';
import 'package:permacalendar/core/models/garden_hive.dart';
import 'package:permacalendar/core/models/garden_bed_hive.dart';
import 'package:permacalendar/core/repositories/garden_hive_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Garden Deletion Integration Test', () {
    late ProviderContainer container;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      Hive.init('./test/hive_cache_garden_delete');

      // Register Adapters
      if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(GardenAdapter());
      if (!Hive.isAdapterRegistered(25)) Hive.registerAdapter(GardenHiveAdapter());
      if (!Hive.isAdapterRegistered(26)) Hive.registerAdapter(GardenBedHiveAdapter());
      
      // Initialize Boxes
      await GardenBoxes.initialize();
      await GardenHiveRepository.initialize();
      await GardenBoxes.clearAllGardens();
      await Hive.openBox('export_preferences'); // Mock export box if needed
      
      // Clear GardenHiveRepository box manually
      final hiveBox = await Hive.openBox<GardenHive>('gardens_hive');
      await hiveBox.clear();

      container = ProviderContainer();
    });

    tearDown(() async {
      await GardenBoxes.close();
      await GardenHiveRepository.close();
      await Hive.deleteFromDisk();
      try {
        container.dispose();
      } catch (e) {
        // ignore
      }
    });

    test('Deleting a garden should remove it from Active, Filters, and Export Scope', () async {
      // 1. Setup Data - Manually inject GardenHive to bypass EnvironmentService/dotenv
      final gardenId = 'garden_delete_test_1';
      final gardenHive = GardenHive.create(
        name: 'Zombie Garden',
        description: 'Graveyard',
      );
      // Force ID to match our test ID if needed, but create generates random.
      // Better to use constructor directly if we want specific ID, or let it generate and use it.
      // But GardenHive constructor has required id.
      final fixedGardenHive = GardenHive(
        id: gardenId,
        name: 'Zombie Garden',
        description: 'Graveyard',
        createdDate: DateTime.now(),
        gardenBeds: [],
      );
      
      // Find the open box (GardenHiveRepository opened it)
      final hiveBox = Hive.box<GardenHive>('gardens_hive');
      await hiveBox.put(gardenId, fixedGardenHive);
      
      // Check if it's there
      expect(hiveBox.get(gardenId), isNotNull);
      
      // Also inject into Legacy GardenBoxes just in case logic checks it? 
      // The deletion logic tries to delete from legacy too.
      // But new deleteGarden logic relies on GardenHiveRepository mainly?
      // deleteGarden implementation: 
      // await repository.deleteGarden(gardenId);
      // await GardenBoxes.deleteGarden(gardenId);
      
      // 2. Refresh Provider to see the garden
      final gardenNotifier = container.read(gardenProvider.notifier);
      await gardenNotifier.loadGardens();
      
      expect(container.read(gardenProvider).gardens.any((g) => g.id == gardenId), true, reason: "Garden should be loaded from Hive");

      // 3. Set as Active Garden
      final activeNotifier = container.read(activeGardenIdProvider.notifier);
      activeNotifier.setActiveGarden(gardenId);
      expect(container.read(activeGardenIdProvider), equals(gardenId));

      // 4. Add to Statistics Filters
      final statsNotifier = container.read(statisticsFiltersProvider.notifier);
      statsNotifier.setGardens({gardenId});
      expect(container.read(statisticsFiltersProvider).selectedGardenIds.contains(gardenId), true);

      // 5. Add to Export Scope
      final exportNotifier = container.read(exportBuilderProvider.notifier);
      var exportState = container.read(exportBuilderProvider);
      var currentScope = exportState.config.scope;
      await exportNotifier.updateScope(currentScope.copyWith(gardenIds: [gardenId, 'other_garden']));
      
      exportState = container.read(exportBuilderProvider);
      expect(exportState.config.scope.gardenIds, contains(gardenId));

      // 6. PERFORM DELETION
      final success = await gardenNotifier.deleteGarden(gardenId);
      expect(success, true, reason: "Deletion should succeed");

      // 7. VERIFY CLEANUP

      // A. Active Garden should be null
      expect(container.read(activeGardenIdProvider), isNull, reason: "Active garden should be cleared");

      // B. Statistics Filters should not contain gardenId
      final filterState = container.read(statisticsFiltersProvider);
      expect(filterState.selectedGardenIds.contains(gardenId), false, reason: "Statistics filter should remove deleted ID");

      // C. Export Scope should not contain gardenId
      final finalExportState = container.read(exportBuilderProvider);
      expect(finalExportState.config.scope.gardenIds.contains(gardenId), false, reason: "Export scope should remove deleted ID");
      expect(finalExportState.config.scope.gardenIds.contains('other_garden'), true, reason: "Other IDs should remain");
    });
  });
}
