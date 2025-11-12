import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

import 'package:permacalendar/core/models/garden.dart';
import 'package:permacalendar/core/models/garden_bed.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import 'package:permacalendar/features/garden_bed/providers/garden_bed_scoped_provider.dart';

void main() {
  group('Garden Bed Scoped Provider Unit Tests', () {
    late Directory tempDir;

    setUpAll(() async {
      // Initialiser Hive pour les tests avec un répertoire temporaire
      tempDir = await Directory.systemTemp.createTemp('hive_test_');
      Hive.init(tempDir.path);
      
      // Enregistrer les adaptateurs Hive
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(GardenAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(GardenBedAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(PlantingAdapter());
      }
      
      await GardenBoxes.initialize();
    });

    tearDownAll(() async {
      await Hive.close();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    setUp(() async {
      // Nettoyer les données avant chaque test
      await GardenBoxes.clearAllGardens();
    });

    test('gardenBedProvider should return empty list for non-existent garden', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Attendre que le provider se charge et obtenir le résultat
      final gardenBeds = await container.read(gardenBedProvider('non_existent_garden').future);
      
      expect(gardenBeds, isEmpty);
    });

    test('gardenBedProvider should return correct beds for specific garden', () async {
      await GardenBoxes.clearAllGardens();
      
      // Créer des jardins de test
      final garden1 = Garden(
        name: 'Jardin 1',
        description: 'Premier jardin',
        totalAreaInSquareMeters: 100.0,
        location: 'Emplacement 1',
      );

      final garden2 = Garden(
        name: 'Jardin 2',
        description: 'Deuxième jardin',
        totalAreaInSquareMeters: 150.0,
        location: 'Emplacement 2',
      );

      // Sauvegarder les jardins pour obtenir leurs IDs
      await GardenBoxes.saveGarden(garden1);
      await GardenBoxes.saveGarden(garden2);

      // Créer des planches
      final bed1Garden1 = GardenBed(
        gardenId: garden1.id,
        name: 'Planche 1 - Jardin 1',
        description: 'Première planche',
        sizeInSquareMeters: 10.0,
        exposure: 'Plein soleil',
        soilType: 'Argileux',
      );

      final bed2Garden1 = GardenBed(
        gardenId: garden1.id,
        name: 'Planche 2 - Jardin 1',
        description: 'Deuxième planche',
        sizeInSquareMeters: 15.0,
        exposure: 'Mi-soleil',
        soilType: 'Sableux',
      );

      final bed1Garden2 = GardenBed(
        gardenId: garden2.id,
        name: 'Planche 1 - Jardin 2',
        description: 'Première planche du jardin 2',
        sizeInSquareMeters: 20.0,
        exposure: 'Mi-ombre',
        soilType: 'Limoneux',
      );

      // Sauvegarder les planches
      await GardenBoxes.saveGardenBed(bed1Garden1);
      await GardenBoxes.saveGardenBed(bed2Garden1);
      await GardenBoxes.saveGardenBed(bed1Garden2);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Tester l'isolation des planches - attendre que les données se chargent
      final garden1Beds = await container.read(gardenBedProvider(garden1.id).future);
      final garden2Beds = await container.read(gardenBedProvider(garden2.id).future);

      expect(garden1Beds.length, equals(2));
      expect(garden2Beds.length, equals(1));

      // Vérifier que les planches appartiennent au bon jardin
      expect(garden1Beds.every((bed) => bed.gardenId == garden1.id), isTrue);
      expect(garden2Beds.every((bed) => bed.gardenId == garden2.id), isTrue);

      // Vérifier les noms
      final garden1BedNames = garden1Beds.map((bed) => bed.name).toSet();
      final garden2BedNames = garden2Beds.map((bed) => bed.name).toSet();

      expect(garden1BedNames.contains('Planche 1 - Jardin 1'), isTrue);
      expect(garden1BedNames.contains('Planche 2 - Jardin 1'), isTrue);
      expect(garden1BedNames.contains('Planche 1 - Jardin 2'), isFalse);

      expect(garden2BedNames.contains('Planche 1 - Jardin 2'), isTrue);
      expect(garden2BedNames.contains('Planche 1 - Jardin 1'), isFalse);
    });

    test('gardenBedCountProvider should return correct count', () async {
      await GardenBoxes.clearAllGardens();
      
      // Créer un jardin avec 3 planches
      final garden = Garden(
        name: 'Test Garden',
        description: 'Garden for count test',
        totalAreaInSquareMeters: 100.0,
        location: 'Test Location',
      );

      await GardenBoxes.saveGarden(garden);

      // Ajouter 3 planches
      for (int i = 1; i <= 3; i++) {
        await GardenBoxes.saveGardenBed(GardenBed(
          gardenId: garden.id,
          name: 'Planche $i',
          description: 'Description $i',
          sizeInSquareMeters: 10.0,
          exposure: 'Plein soleil',
          soilType: 'Argileux',
        ));
      }

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Attendre que les données se chargent et obtenir le résultat
      final count = await container.read(gardenBedCountProvider(garden.id).future);
      
      expect(count, equals(3));
    });

    test('gardenTotalAreaProvider should calculate correct total area', () async {
      await GardenBoxes.clearAllGardens();
      
      // Créer un jardin avec planches de différentes tailles
      final garden = Garden(
        name: 'Area Test Garden',
        description: 'Garden for area calculation test',
        totalAreaInSquareMeters: 100.0,
        location: 'Test Location',
      );

      await GardenBoxes.saveGarden(garden);

      // Ajouter planches avec tailles spécifiques
      await GardenBoxes.saveGardenBed(GardenBed(
        gardenId: garden.id,
        name: 'Petite planche',
        description: 'Planche de 5m²',
        sizeInSquareMeters: 5.0,
        exposure: 'Plein soleil',
        soilType: 'Argileux',
      ));

      await GardenBoxes.saveGardenBed(GardenBed(
        gardenId: garden.id,
        name: 'Grande planche',
        description: 'Planche de 15m²',
        sizeInSquareMeters: 15.0,
        exposure: 'Mi-soleil',
        soilType: 'Sableux',
      ));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Attendre que les données se chargent et obtenir le résultat
      final totalArea = await container.read(gardenTotalAreaProvider(garden.id).future);
      
      expect(totalArea, equals(20.0)); // 5.0 + 15.0
    });

    test('gardenBedDetailProvider should return correct bed', () async {
      await GardenBoxes.clearAllGardens();

      final garden = Garden(
        name: 'Detail Test Garden',
        description: 'Garden for detail test',
        totalAreaInSquareMeters: 100.0,
        location: 'Test Location',
      );

      await GardenBoxes.saveGarden(garden);

      final bed = GardenBed(
        gardenId: garden.id,
        name: 'Planche cible',
        description: 'Planche à retrouver',
        sizeInSquareMeters: 12.0,
        exposure: 'Mi-ombre',
        soilType: 'Limoneux',
      );

      await GardenBoxes.saveGardenBed(bed);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Attendre que les données se chargent et obtenir le résultat
      final foundBed = await container.read(
        gardenBedDetailProvider((gardenId: garden.id, bedId: bed.id)).future
      );

      expect(foundBed, isNotNull);
      expect(foundBed!.id, equals(bed.id));
      expect(foundBed.name, equals('Planche cible'));
      expect(foundBed.gardenId, equals(garden.id));
    });

    test('gardenBedDetailProvider should return null for non-existent bed', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Attendre que les données se chargent et obtenir le résultat
      final foundBed = await container.read(
        gardenBedDetailProvider((gardenId: 'non_existent_garden', bedId: 'non_existent_bed')).future
      );

      expect(foundBed, isNull);
    });
  });
}


