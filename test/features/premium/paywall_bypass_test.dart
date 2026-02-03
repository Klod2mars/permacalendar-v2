
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import 'package:permacalendar/core/models/entitlement.dart';
import 'package:permacalendar/core/models/garden.dart';
import 'package:permacalendar/core/models/garden_bed.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart';
import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';
import 'package:permacalendar/features/premium/domain/can_perform_action_checker.dart';
import 'package:permacalendar/features/premium/data/entitlement_repository.dart';

// Mock Notifier for Catalog
class FakePlantCatalogNotifier extends PlantCatalogNotifier {
  @override
  PlantCatalogState build() {
    return const PlantCatalogState(plants: []);
  }
  @override
  Future<void> loadPlants() async {}
}

void main() {
  late Directory tempDir;
  ProviderContainer? container;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_paywall');
    Hive.init(tempDir.path);

    // Register Adapters
    try { Hive.registerAdapter(EntitlementAdapter()); } catch(_) {}
    try { Hive.registerAdapter(GardenAdapter()); } catch(_) {}
    try { Hive.registerAdapter(GardenBedAdapter()); } catch(_) {}
    try { Hive.registerAdapter(PlantingAdapter()); } catch(_) {}

    // Initialize garden boxes
    await GardenBoxes.initialize();
    await GardenBoxes.clearAllGardens();
    
    // Initialize EntitlementRepository singleton
    await EntitlementRepository().init();
    
    // Clear entitlement box (accessed via Repo or Hive direct)
    final box = Hive.box<Entitlement>('entitlements');
    await box.clear();
  });

  tearDown(() async {
    container?.dispose();
    await GardenBoxes.close();
    await Hive.deleteFromDisk();
  });

  group('Paywall Global Limits', () {
    
    test('CanPerformActionChecker enforces global limits', () async {
      // Setup Free User
      await Hive.box<Entitlement>('entitlements').put('current_entitlement', Entitlement.free());

      final checker = CanPerformActionChecker();
      
      // Garden Limit (Max 1)
      expect(checker.canCreateGarden(0), true);
      expect(checker.canCreateGarden(1), false);
      
      // Bed Limit (Max 1)
      expect(checker.canCreateBed(0), true);
      expect(checker.canCreateBed(1), false);
      
      // Plant Limit (Max 3)
      expect(checker.canAddPlant(2), true);
      expect(checker.canAddPlant(3), false);
      
      // Premium Bypass
      await Hive.box<Entitlement>('entitlements').put('current_entitlement', Entitlement.premium(productId: 'test_prod', source: 'test'));
      expect(checker.canCreateGarden(5), true);
      expect(checker.canCreateBed(5), true);
      expect(checker.canAddPlant(100), true);
    });

    test('PlantingNotifier.createPlanting blocks 4th plant', () async {
      final entBox = Hive.box<Entitlement>('entitlements');
      await entBox.put('current_entitlement', Entitlement.free());

      // Create a bed
      final g = Garden(id: 'g1', name: 'G1', description: 'Desc', totalAreaInSquareMeters: 10, location: 'Loc', createdAt: DateTime.now());
      await GardenBoxes.saveGarden(g);
      final b = GardenBed(id: 'b1', gardenId: 'g1', name: 'B1', description: 'Desc', sizeInSquareMeters: 1, soilType: 'Argileux', exposure: 'Plein soleil');
      await GardenBoxes.saveGardenBed(b);

      // Add 3 plants
      for(int i=0; i<3; i++) {
        await GardenBoxes.savePlanting(Planting(
          id: 'p$i', gardenBedId: 'b1', plantId: 'id$i', plantName: 'P$i', 
          plantedDate: DateTime.now(), quantity: 1,
          status: 'Planté', isActive: true // Ensure active
        ));
      }

      container = ProviderContainer(
        overrides: [
          plantCatalogProvider.overrideWith(() => FakePlantCatalogNotifier()),
        ],
      );

      final notifier = container!.read(plantingProvider.notifier);
      
      // Try adding 4th plant
      final result = await notifier.createPlanting(
        gardenBedId: 'b1',
        plantId: 'new',
        plantName: 'New Plant',
        plantedDate: DateTime.now(),
        quantity: 1,
      );

      expect(result, false, reason: "Should fail to create 4th plant");
      expect(container!.read(plantingProvider).error, 'paywall_limit_reached');
    });

    test('GardenBedNotifier.createGardenBed ALLOWS 2nd bed if plants < 3', () async {
      final entBox = Hive.box<Entitlement>('entitlements');
      await entBox.put('current_entitlement', Entitlement.free());
      
      // Create 1 bed
      var g = Garden(id: 'g1', name: 'G1', description: 'Desc', totalAreaInSquareMeters: 10, location: 'Loc', createdAt: DateTime.now());
      await GardenBoxes.saveGarden(g);
      var b = GardenBed(id: 'b1', gardenId: 'g1', name: 'B1', description: 'Desc', sizeInSquareMeters: 1, soilType: 'Argileux', exposure: 'Plein soleil');
      await GardenBoxes.saveGardenBed(b);
      
      // Verify count
      expect(GardenBoxes.gardenBeds.length, 1);

      container = ProviderContainer(); 
      
      final notifier = container!.read(gardenBedNotifierProvider.notifier);
      
      final newBed = GardenBed(id: 'b2', gardenId: 'g1', name: 'B2', description: 'Desc', sizeInSquareMeters: 1, soilType: 'Argileux', exposure: 'Plein soleil');
      
      final result = await notifier.createGardenBed(newBed);
      
      expect(result, true, reason: "Should allow 2nd bed because plant count is 0");
    });

    test('GardenBedNotifier.createGardenBed blocks bed creation if plant limit reached (3)', () async {
      final entBox = Hive.box<Entitlement>('entitlements');
      await entBox.put('current_entitlement', Entitlement.free());

      // Create 1 bed
      var g = Garden(id: 'g1', name: 'G1', description: 'Desc', totalAreaInSquareMeters: 10, location: 'Loc', createdAt: DateTime.now());
      await GardenBoxes.saveGarden(g);
      var b = GardenBed(id: 'b1', gardenId: 'g1', name: 'B1', description: 'Desc', sizeInSquareMeters: 1, soilType: 'Argileux', exposure: 'Plein soleil');
      await GardenBoxes.saveGardenBed(b);

      // Add 3 active plants
      for(int i=0; i<3; i++) {
        await GardenBoxes.savePlanting(Planting(
          id: 'p$i', gardenBedId: 'b1', plantId: 'id$i', plantName: 'P$i', 
          plantedDate: DateTime.now(), quantity: 1,
          status: 'Planté', isActive: true
        ));
      }

      container = ProviderContainer(); 
      final notifier = container!.read(gardenBedNotifierProvider.notifier);

      final newBed = GardenBed(id: 'b2', gardenId: 'g1', name: 'B2', description: 'Desc', sizeInSquareMeters: 1, soilType: 'Argileux', exposure: 'Plein soleil');
      final result = await notifier.createGardenBed(newBed);

      expect(result, false, reason: "Should fail to create bed because user has 3 plants");
      expect(container!.read(gardenBedNotifierProvider).error, 'paywall_limit_reached');
    });
  });
}
