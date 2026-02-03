
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

// Use same fake catalog
class FakePlantCatalogNotifier extends PlantCatalogNotifier {
  @override
  PlantCatalogState build() {
    return const PlantCatalogState(plants: []);
  }
}

void main() {
  late Directory tempDir;
  ProviderContainer? container;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('limit_conflict_test');
    Hive.init(tempDir.path);

    try { Hive.registerAdapter(EntitlementAdapter()); } catch(_) {}
    try { Hive.registerAdapter(GardenAdapter()); } catch(_) {}
    try { Hive.registerAdapter(GardenBedAdapter()); } catch(_) {}
    try { Hive.registerAdapter(PlantingAdapter()); } catch(_) {}

    await GardenBoxes.initialize();
    await GardenBoxes.clearAllGardens();
    
    // Init Entitlement Repo to default (Free)
    await EntitlementRepository().init();
    final box = Hive.box<Entitlement>('entitlements');
    await box.clear();
    await box.put('current_entitlement', Entitlement.premium()); // Force Premium to Ignore Paywall logic for now, we want to test Technical Limit leakage
  });

  tearDown(() async {
    container?.dispose();
    await GardenBoxes.close();
    await Hive.deleteFromDisk();
  });

  test('Technical Limit Check: 6 plants distributed across beds should NOT block new planting in empty bed', () async {
    // 1. Setup Premium User (to bypass paywall of 3)
    // We want to verify the "technical limit of 6 per bed" logic.
    // If that limit is applied globally, adding 7th plant will fail even in a new bed.

    // Create Garden
    var g = Garden(id: 'g1', name: 'G1', description: 'Desc', totalAreaInSquareMeters: 10, location: 'Loc', createdAt: DateTime.now());
    await GardenBoxes.saveGarden(g);

    // Create Bed 1
    var b1 = GardenBed(id: 'b1', gardenId: 'g1', name: 'B1', description: 'Desc', sizeInSquareMeters: 1, soilType: 'Argileux', exposure: 'Plein soleil');
    await GardenBoxes.saveGardenBed(b1);
    
    // Create Bed 2
    var b2 = GardenBed(id: 'b2', gardenId: 'g1', name: 'B2', description: 'Desc', sizeInSquareMeters: 1, soilType: 'Argileux', exposure: 'Plein soleil');
    await GardenBoxes.saveGardenBed(b2);

    // Add 6 plants to Bed 1
    // Wait, user said "repartie sur plusieurs parcelles".
    // "les six plantes étaient réparties sur plusieurs parcelles différentes"
    // So let's put 3 in B1 and 3 in B2. Total 6.
    
    for(int i=0; i<3; i++) {
        await GardenBoxes.savePlanting(Planting(
          id: 'p1_$i', gardenBedId: 'b1', plantId: 'id', plantName: 'P', 
          plantedDate: DateTime.now(), quantity: 1, status: 'Planté', isActive: true
        ));
    }
    for(int i=0; i<3; i++) {
        await GardenBoxes.savePlanting(Planting(
          id: 'p2_$i', gardenBedId: 'b2', plantId: 'id', plantName: 'P', 
          plantedDate: DateTime.now(), quantity: 1, status: 'Planté', isActive: true
        ));
    }

    container = ProviderContainer(overrides: [
       plantCatalogProvider.overrideWith(() => FakePlantCatalogNotifier()),
    ]);
    final notifier = container!.read(plantingProvider.notifier);

    // Now try to add plant to Bed 3 (New, Empty)
    var b3 = GardenBed(id: 'b3', gardenId: 'g1', name: 'B3', description: 'Desc', sizeInSquareMeters: 1, soilType: 'Argileux', exposure: 'Plein soleil');
    await GardenBoxes.saveGardenBed(b3);

    final result = await notifier.createPlanting(
        gardenBedId: 'b3',
        plantId: 'new',
        plantName: 'New Plant',
        plantedDate: DateTime.now(),
        quantity: 1,
    );

    // The technical limit (GardenRules) says max 6 per bed.
    // Here B3 has 0 plants. So it should PASS.
    // If it fails with "limit reached", then the limit is global.
    
    if (!result) {
       print('Error: ${container!.read(plantingProvider).error}');
    }

    expect(result, true, reason: "Should be able to add plant to empty bed even if 6 exist elsewhere");
  });
}
