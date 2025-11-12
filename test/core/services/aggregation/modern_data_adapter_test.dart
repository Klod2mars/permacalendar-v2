import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:permacalendar/core/services/aggregation/modern_data_adapter.dart';
import 'package:permacalendar/core/models/garden.dart' as legacy;
import 'package:permacalendar/core/models/garden_bed.dart' as legacy_bed;
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import 'package:permacalendar/features/plant_catalog/data/repositories/plant_hive_repository.dart';
import 'package:permacalendar/features/plant_catalog/data/models/plant_hive.dart';

/// Tests pour ModernDataAdapter — Validation Philosophie du Sanctuaire
/// 
/// Ces tests valident que Modern Adapter respecte le flux de vérité :
/// Réel → Sanctuaire → Système Moderne → Intelligence Végétale
/// 
/// RÈGLE CRITIQUE : Modern Adapter DOIT filtrer par gardenId
/// et retourner UNIQUEMENT les plantes ACTIVES du jardin spécifique
void main() {
  group('ModernDataAdapter - Sanctuary Philosophy Validation', () {
    late ModernDataAdapter adapter;
    late Directory tempDir;

    setUpAll(() async {
      // Initialiser les bindings Flutter pour les tests
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Créer un répertoire temporaire pour les tests
      tempDir = await Directory.systemTemp.createTemp('hive_test_');
      Hive.init(tempDir.path);
      
      // Enregistrer les adaptateurs Hive (legacy models utilisés par GardenBoxes)
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(legacy.GardenAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(legacy_bed.GardenBedAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(PlantingAdapter());
      }
      if (!Hive.isAdapterRegistered(28)) {
        Hive.registerAdapter(PlantHiveAdapter());
      }
      
      // Initialiser GardenBoxes
      await GardenBoxes.initialize();
      
      // Initialiser PlantHiveRepository et charger le catalogue
      await PlantHiveRepository.initialize();
      final plantRepository = PlantHiveRepository();
      await plantRepository.initializeFromJson();
    });

    setUp(() async {
      // Nettoyer les données avant chaque test
      await GardenBoxes.clearAllGardens();
      
      // Créer l'adapter
      adapter = ModernDataAdapter();
    });

    tearDownAll(() async {
      // Fermer Hive et nettoyer le répertoire temporaire
      await Hive.close();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    /// Scénario 1 : Jardin vide
    /// Given: Jardin sans plantations
    /// When: getActivePlants('garden_empty')
    /// Then: Retourne []
    test('Scénario 1: Jardin vide retourne liste vide', () async {
      // Given: Jardin sans plantations
      final garden = legacy.Garden(
        name: 'Jardin Vide',
        description: 'Test jardin vide',
        location: 'Test',
        totalAreaInSquareMeters: 10.0,
      );
      await GardenBoxes.saveGarden(garden);

      // When: Récupération des plantes actives
      final plants = await adapter.getActivePlants(garden.id);

      // Then: Retourne liste vide
      expect(plants, isEmpty);
      expect(plants.length, equals(0));
    });

    /// Scénario 2 : 1 plante active
    /// Given: Jardin avec 1 épinard planté
    /// When: getActivePlants('garden_1plant')
    /// Then: Retourne [épinard]
    /// And: plants.length == 1
    test('Scénario 2: Jardin avec 1 plante active', () async {
      // Given: Jardin avec 1 parcelle et 1 plante
      final garden = legacy.Garden(
        name: 'Jardin 1 Plante',
        description: 'Test 1 plante',
        location: 'Test',
        totalAreaInSquareMeters: 10.0,
      );
      await GardenBoxes.saveGarden(garden);

      final bed = legacy_bed.GardenBed(
        gardenId: garden.id,
        name: 'Parcelle Test',
        description: 'Parcelle de test',
        sizeInSquareMeters: 10.0,
        soilType: 'Limoneux',
        exposure: 'Plein soleil',
      );
      await GardenBoxes.saveGardenBed(bed);

      final planting = Planting(
        gardenBedId: bed.id,
        plantId: 'spinach',
        plantName: 'Épinards',
        plantedDate: DateTime.now(),
        quantity: 10,
        status: 'Planté',
        isActive: true,
      );
      await GardenBoxes.savePlanting(planting);

      // When: Récupération des plantes actives
      final plants = await adapter.getActivePlants(garden.id);

      // Then: Retourne 1 plante
      expect(plants.length, equals(1));
      expect(plants.first.plantId, equals('spinach'));
      expect(plants.first.commonName, isNotEmpty);
    });

    /// Scénario 3 : Multiple plantes actives
    /// Given: Jardin avec 3 plantes plantées
    /// When: getActivePlants('garden_3plants')
    /// Then: Retourne [plante1, plante2, plante3]
    /// And: plants.length == 3
    test('Scénario 3: Jardin avec multiple plantes actives', () async {
      // Given: Jardin avec 2 parcelles et 3 plantes
      final garden = legacy.Garden(
        name: 'Jardin 3 Plantes',
        description: 'Test 3 plantes',
        location: 'Test',
        totalAreaInSquareMeters: 20.0,
      );
      await GardenBoxes.saveGarden(garden);

      final bed1 = legacy_bed.GardenBed(
        gardenId: garden.id,
        name: 'Parcelle 1',
        description: 'Première parcelle',
        sizeInSquareMeters: 10.0,
        soilType: 'Limoneux',
        exposure: 'Plein soleil',
      );
      await GardenBoxes.saveGardenBed(bed1);

      final bed2 = legacy_bed.GardenBed(
        gardenId: garden.id,
        name: 'Parcelle 2',
        description: 'Deuxième parcelle',
        sizeInSquareMeters: 10.0,
        soilType: 'Limoneux',
        exposure: 'Mi-soleil',
      );
      await GardenBoxes.saveGardenBed(bed2);

      // 2 plantes dans parcelle 1
      final planting1 = Planting(
        gardenBedId: bed1.id,
        plantId: 'tomato',
        plantName: 'Tomate',
        plantedDate: DateTime.now(),
        quantity: 5,
        status: 'Planté',
        isActive: true,
      );
      await GardenBoxes.savePlanting(planting1);

      final planting2 = Planting(
        gardenBedId: bed1.id,
        plantId: 'carrot',
        plantName: 'Carotte',
        plantedDate: DateTime.now(),
        quantity: 20,
        status: 'Planté',
        isActive: true,
      );
      await GardenBoxes.savePlanting(planting2);

      // 1 plante dans parcelle 2
      final planting3 = Planting(
        gardenBedId: bed2.id,
        plantId: 'lettuce',
        plantName: 'Laitue',
        plantedDate: DateTime.now(),
        quantity: 10,
        status: 'Planté',
        isActive: true,
      );
      await GardenBoxes.savePlanting(planting3);

      // When: Récupération des plantes actives
      final plants = await adapter.getActivePlants(garden.id);

      // Then: Retourne 3 plantes
      expect(plants.length, equals(3));
      
      final plantIds = plants.map((p) => p.plantId).toSet();
      expect(plantIds, containsAll(['tomato', 'carrot', 'lettuce']));
    });

    /// Scénario 4 : Plantes inactives ignorées
    /// Given: Jardin avec 2 plantes actives + 1 inactive
    /// When: getActivePlants('garden_mixed')
    /// Then: Retourne [active1, active2]
    /// And: plants.length == 2
    /// And: inactive plant NOT in results
    test('Scénario 4: Plantes inactives sont ignorées', () async {
      // Given: Jardin avec 2 plantes actives + 1 inactive
      final garden = legacy.Garden(
        name: 'Jardin Mixte',
        description: 'Test actives + inactives',
        location: 'Test',
        totalAreaInSquareMeters: 10.0,
      );
      await GardenBoxes.saveGarden(garden);

      final bed = legacy_bed.GardenBed(
        gardenId: garden.id,
        name: 'Parcelle Test',
        description: 'Parcelle mixte',
        sizeInSquareMeters: 10.0,
        soilType: 'Limoneux',
        exposure: 'Plein soleil',
      );
      await GardenBoxes.saveGardenBed(bed);

      // 2 plantes actives
      final activePlanting1 = Planting(
        gardenBedId: bed.id,
        plantId: 'tomato',
        plantName: 'Tomate',
        plantedDate: DateTime.now(),
        quantity: 5,
        status: 'Planté',
        isActive: true,
      );
      await GardenBoxes.savePlanting(activePlanting1);

      final activePlanting2 = Planting(
        gardenBedId: bed.id,
        plantId: 'carrot',
        plantName: 'Carotte',
        plantedDate: DateTime.now(),
        quantity: 20,
        status: 'Planté',
        isActive: true,
      );
      await GardenBoxes.savePlanting(activePlanting2);

      // 1 plante inactive (récoltée)
      final inactivePlanting = Planting(
        gardenBedId: bed.id,
        plantId: 'lettuce',
        plantName: 'Laitue',
        plantedDate: DateTime.now().subtract(const Duration(days: 90)),
        quantity: 10,
        status: 'Récolté',
        isActive: false,
        actualHarvestDate: DateTime.now().subtract(const Duration(days: 1)),
      );
      await GardenBoxes.savePlanting(inactivePlanting);

      // When: Récupération des plantes actives
      final plants = await adapter.getActivePlants(garden.id);

      // Then: Retourne UNIQUEMENT les 2 plantes actives
      expect(plants.length, equals(2));
      
      final plantIds = plants.map((p) => p.plantId).toSet();
      expect(plantIds, containsAll(['tomato', 'carrot']));
      expect(plantIds, isNot(contains('lettuce'))); // Laitue inactive NOT included
    });

    /// Scénario 5 : Isolation entre jardins
    /// Given: 2 jardins avec plantes différentes
    /// When: getActivePlants('garden1')
    /// Then: Retourne UNIQUEMENT plantes de garden1
    /// And: Plantes de garden2 NOT included
    test('Scénario 5: Isolation entre jardins (respect du Sanctuaire)', () async {
      // Given: 2 jardins séparés
      final garden1 = legacy.Garden(
        name: 'Jardin 1',
        description: 'Premier jardin',
        location: 'Test',
        totalAreaInSquareMeters: 10.0,
      );
      await GardenBoxes.saveGarden(garden1);

      final garden2 = legacy.Garden(
        name: 'Jardin 2',
        description: 'Deuxième jardin',
        location: 'Test',
        totalAreaInSquareMeters: 10.0,
      );
      await GardenBoxes.saveGarden(garden2);

      // Jardin 1 : Tomate
      final bed1 = legacy_bed.GardenBed(
        gardenId: garden1.id,
        name: 'Parcelle Jardin 1',
        description: 'Première parcelle',
        sizeInSquareMeters: 10.0,
        soilType: 'Limoneux',
        exposure: 'Plein soleil',
      );
      await GardenBoxes.saveGardenBed(bed1);

      final planting1 = Planting(
        gardenBedId: bed1.id,
        plantId: 'tomato',
        plantName: 'Tomate',
        plantedDate: DateTime.now(),
        quantity: 5,
        status: 'Planté',
        isActive: true,
      );
      await GardenBoxes.savePlanting(planting1);

      // Jardin 2 : Carotte
      final bed2 = legacy_bed.GardenBed(
        gardenId: garden2.id,
        name: 'Parcelle Jardin 2',
        description: 'Deuxième parcelle',
        sizeInSquareMeters: 10.0,
        soilType: 'Limoneux',
        exposure: 'Plein soleil',
      );
      await GardenBoxes.saveGardenBed(bed2);

      final planting2 = Planting(
        gardenBedId: bed2.id,
        plantId: 'carrot',
        plantName: 'Carotte',
        plantedDate: DateTime.now(),
        quantity: 20,
        status: 'Planté',
        isActive: true,
      );
      await GardenBoxes.savePlanting(planting2);

      // When: Récupération des plantes de garden1
      final plantsGarden1 = await adapter.getActivePlants(garden1.id);

      // Then: UNIQUEMENT la tomate de garden1
      expect(plantsGarden1.length, equals(1));
      expect(plantsGarden1.first.plantId, equals('tomato'));
      
      final plantIds = plantsGarden1.map((p) => p.plantId).toSet();
      expect(plantIds, isNot(contains('carrot'))); // Carotte de garden2 NOT included
    });
  });
}


