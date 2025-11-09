
import '../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:permacalendar/core/models/plant_v2.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Plant Model Tests (v2) - Instanciation et sÃ©rialisation', () {
    late Directory tempDir;
    late Box<Plant> plantBox;
    const uuid = Uuid();

    setUpAll(() async {
      // CrÃ©er un rÃ©pertoire temporaire pour les tests Hive
      tempDir = await Directory.systemTemp.createTemp('plant_v2_test_');

      // Initialiser Hive avec le rÃ©pertoire temporaire
      Hive.init(tempDir.path);

      // Enregistrer l'adaptateur Plant si pas dÃ©jÃ  fait
      if (!Hive.isAdapterRegistered(12)) {
        Hive.registerAdapter(PlantAdapter());
      }
    });

    setUp(() async {
      // Ouvrir une nouvelle box pour chaque test
      plantBox = await Hive.openBox<Plant>('test_plants_v2');
      await plantBox.clear();
    });

    tearDown(() async {
      // Fermer la box aprÃ¨s chaque test
      if (plantBox.isOpen) {
        await plantBox.close();
      }
    });

    tearDownAll(() async {
      // Nettoyer complÃ¨tement aprÃ¨s tous les tests
      await Hive.deleteFromDisk();
      await Hive.close();

      // Supprimer le rÃ©pertoire temporaire
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    group('Tests de crÃ©ation et instanciation', () {
      test('Doit crÃ©er un Plant avec tous les champs requis', () {
        final plant = Plant(
          id: 'test-plant-1',
          name: 'Tomate',
          species: 'Solanum lycopersicum',
          family: 'Solanaceae',
          growthCycles: ['Germination', 'Croissance', 'Floraison', 'Fructification'],
        );

        expect(plant.id, equals('test-plant-1'));
        expect(plant.name, equals('Tomate'));
        expect(plant.species, equals('Solanum lycopersicum'));
        expect(plant.family, equals('Solanaceae'));
        expect(plant.growthCycles.length, equals(4));
        expect(plant.growthCycles, contains('Germination'));
        expect(plant.growthCycles, contains('Fructification'));
      });

      test('Doit crÃ©er un Plant avec une liste de growthCycles vide', () {
        final plant = Plant(
          id: 'test-plant-2',
          name: 'Carotte',
          species: 'Daucus carota',
          family: 'Apiaceae',
          growthCycles: [],
        );

        expect(plant.growthCycles, isEmpty);
        expect(plant.growthCycles.length, equals(0));
      });

      test('Factory create doit gÃ©nÃ©rer un ID unique automatiquement', () {
        final plant1 = Plant.create(
          name: 'Basilic',
          species: 'Ocimum basilicum',
          family: 'Lamiaceae',
          growthCycles: ['Germination', 'Croissance'],
        );

        final plant2 = Plant.create(
          name: 'Persil',
          species: 'Petroselinum crispum',
          family: 'Apiaceae',
          growthCycles: ['Germination', 'Croissance', 'RÃ©colte'],
        );

        // VÃ©rifier que les IDs sont gÃ©nÃ©rÃ©s et diffÃ©rents
        expect(plant1.id, isNotEmpty);
        expect(plant2.id, isNotEmpty);
        expect(plant1.id, isNot(equals(plant2.id)));

        // VÃ©rifier les autres propriÃ©tÃ©s
        expect(plant1.name, equals('Basilic'));
        expect(plant1.species, equals('Ocimum basilicum'));
        expect(plant1.family, equals('Lamiaceae'));
        expect(plant1.growthCycles.length, equals(2));

        expect(plant2.name, equals('Persil'));
        expect(plant2.species, equals('Petroselinum crispum'));
        expect(plant2.family, equals('Apiaceae'));
        expect(plant2.growthCycles.length, equals(3));
      });

      test('Factory create doit accepter une liste de growthCycles optionnelle', () {
        final plantWithCycles = Plant.create(
          name: 'Salade',
          species: 'Lactuca sativa',
          family: 'Asteraceae',
          growthCycles: ['Germination', 'Croissance', 'RÃ©colte'],
        );

        final plantWithoutCycles = Plant.create(
          name: 'Radis',
          species: 'Raphanus sativus',
          family: 'Brassicaceae',
        );

        expect(plantWithCycles.growthCycles.length, equals(3));
        expect(plantWithCycles.growthCycles, contains('Germination'));
        expect(plantWithoutCycles.growthCycles, isEmpty);
      });
    });

    group('Tests de sÃ©rialisation/dÃ©sÃ©rialisation JSON', () {
      test('Doit sÃ©rialiser correctement avec toJson', () {
        final plant = Plant(
          id: 'test-plant-json-1',
          name: 'Courgette',
          species: 'Cucurbita pepo',
          family: 'Cucurbitaceae',
          growthCycles: ['Germination', 'Croissance', 'Floraison'],
        );

        final json = plant.toJson();

        expect(json['id'], equals('test-plant-json-1'));
        expect(json['name'], equals('Courgette'));
        expect(json['species'], equals('Cucurbita pepo'));
        expect(json['family'], equals('Cucurbitaceae'));
        expect(json['growthCycles'], isA<List<String>>());
        expect(json['growthCycles'], equals(['Germination', 'Croissance', 'Floraison']));
      });

      test('Doit dÃ©sÃ©rialiser correctement avec fromJson', () {
        final json = {
          'id': 'test-plant-json-2',
          'name': 'Aubergine',
          'species': 'Solanum melongena',
          'family': 'Solanaceae',
          'growthCycles': ['Germination', 'Croissance', 'Floraison', 'Fructification'],
        };

        final plant = Plant.fromJson(json);

        expect(plant.id, equals('test-plant-json-2'));
        expect(plant.name, equals('Aubergine'));
        expect(plant.species, equals('Solanum melongena'));
        expect(plant.family, equals('Solanaceae'));
        expect(plant.growthCycles.length, equals(4));
        expect(plant.growthCycles, contains('Fructification'));
      });

      test('Doit faire un round-trip JSON (toJson -> fromJson)', () {
        final original = Plant(
          id: 'test-roundtrip',
          name: 'Poivron',
          species: 'Capsicum annuum',
          family: 'Solanaceae',
          growthCycles: ['Germination', 'Croissance', 'Floraison', 'Fructification', 'RÃ©colte'],
        );

        final json = original.toJson();
        final restored = Plant.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.name, equals(original.name));
        expect(restored.species, equals(original.species));
        expect(restored.family, equals(original.family));
        expect(restored.growthCycles, equals(original.growthCycles));
      });
    });

    group('Tests de sÃ©rialisation/dÃ©sÃ©rialisation Hive', () {
      test('Doit sauvegarder et rÃ©cupÃ©rer un Plant dans Hive', () async {
        final originalPlant = Plant(
          id: 'test-hive-1',
          name: 'Haricot',
          species: 'Phaseolus vulgaris',
          family: 'Fabaceae',
          growthCycles: ['Germination', 'Croissance', 'Floraison', 'RÃ©colte'],
        );

        // Sauvegarder dans Hive
        await plantBox.put(originalPlant.id, originalPlant);

        // RÃ©cupÃ©rer depuis Hive
        final retrievedPlant = plantBox.get('test-hive-1');

        // VÃ©rifications
        expect(retrievedPlant, isNotNull);
        expect(retrievedPlant!.id, equals(originalPlant.id));
        expect(retrievedPlant.name, equals(originalPlant.name));
        expect(retrievedPlant.species, equals(originalPlant.species));
        expect(retrievedPlant.family, equals(originalPlant.family));
        expect(retrievedPlant.growthCycles, equals(originalPlant.growthCycles));
      });

      test('Doit persister plusieurs Plants et les rÃ©cupÃ©rer correctement', () async {
        final plants = <Plant>[];

        // CrÃ©er plusieurs plantes
        final plantNames = ['Tomate', 'Carotte', 'Salade', 'Radis', 'Basilic'];
        final plantSpecies = [
          'Solanum lycopersicum',
          'Daucus carota',
          'Lactuca sativa',
          'Raphanus sativus',
          'Ocimum basilicum',
        ];
        final plantFamilies = [
          'Solanaceae',
          'Apiaceae',
          'Asteraceae',
          'Brassicaceae',
          'Lamiaceae',
        ];

        for (int i = 0; i < 5; i++) {
          final plant = Plant(
            id: 'plant-hive-$i',
            name: plantNames[i],
            species: plantSpecies[i],
            family: plantFamilies[i],
            growthCycles: ['Germination', 'Croissance'],
          );

          plants.add(plant);
          await plantBox.put(plant.id, plant);
        }

        // VÃ©rifier que toutes les plantes sont persistÃ©es
        expect(plantBox.length, equals(5));

        // VÃ©rifier chaque plante individuellement
        for (int i = 0; i < 5; i++) {
          final retrieved = plantBox.get('plant-hive-$i');
          expect(retrieved, isNotNull);
          expect(retrieved!.name, equals(plantNames[i]));
          expect(retrieved.species, equals(plantSpecies[i]));
          expect(retrieved.family, equals(plantFamilies[i]));
        }
      });

      test('Doit gÃ©rer un Plant avec une liste de growthCycles vide dans Hive', () async {
        final plant = Plant(
          id: 'plant-empty-cycles',
          name: 'Plante test',
          species: 'Test species',
          family: 'Test family',
          growthCycles: [],
        );

        await plantBox.put(plant.id, plant);
        final retrieved = plantBox.get('plant-empty-cycles');

        expect(retrieved, isNotNull);
        expect(retrieved!.growthCycles, isEmpty);
      });
    });

    group('Tests de la mÃ©thode copyWith', () {
      test('Doit crÃ©er une copie avec des modifications', () {
        final original = Plant(
          id: 'test-copy-1',
          name: 'Tomate Originale',
          species: 'Solanum lycopersicum',
          family: 'Solanaceae',
          growthCycles: ['Germination', 'Croissance'],
        );

        final modified = original.copyWith(
          name: 'Tomate ModifiÃ©e',
          growthCycles: ['Germination', 'Croissance', 'Floraison', 'Fructification'],
        );

        // VÃ©rifier que les champs modifiÃ©s ont changÃ©
        expect(modified.name, equals('Tomate ModifiÃ©e'));
        expect(modified.growthCycles.length, equals(4));

        // VÃ©rifier que les autres champs sont inchangÃ©s
        expect(modified.id, equals(original.id));
        expect(modified.species, equals(original.species));
        expect(modified.family, equals(original.family));
      });

      test('Doit crÃ©er une copie sans modifications si aucun paramÃ¨tre fourni', () {
        final original = Plant(
          id: 'test-copy-2',
          name: 'Carotte',
          species: 'Daucus carota',
          family: 'Apiaceae',
          growthCycles: ['Germination', 'Croissance', 'RÃ©colte'],
        );

        final copy = original.copyWith();

        expect(copy.id, equals(original.id));
        expect(copy.name, equals(original.name));
        expect(copy.species, equals(original.species));
        expect(copy.family, equals(original.family));
        expect(copy.growthCycles, equals(original.growthCycles));
      });

      test('Doit permettre de modifier uniquement certains champs', () {
        final original = Plant(
          id: 'test-copy-3',
          name: 'Salade',
          species: 'Lactuca sativa',
          family: 'Asteraceae',
          growthCycles: ['Germination'],
        );

        final modified = original.copyWith(
          name: 'Salade Romaine',
        );

        expect(modified.name, equals('Salade Romaine'));
        expect(modified.species, equals('Lactuca sativa')); // InchangÃ©
        expect(modified.family, equals('Asteraceae')); // InchangÃ©
        expect(modified.growthCycles, equals(['Germination'])); // InchangÃ©
      });
    });

    group('Tests des mÃ©thodes utilitaires', () {
      test('Doit implÃ©menter toString correctement', () {
        final plant = Plant(
          id: 'test-toString',
          name: 'Tomate',
          species: 'Solanum lycopersicum',
          family: 'Solanaceae',
          growthCycles: ['Germination', 'Croissance', 'Floraison'],
        );

        final string = plant.toString();
        expect(string, contains('Plant'));
        expect(string, contains('test-toString'));
        expect(string, contains('Tomate'));
        expect(string, contains('Solanum lycopersicum'));
        expect(string, contains('Solanaceae'));
        expect(string, contains('3')); // Nombre de growthCycles
      });

      test('Doit implÃ©menter l\'Ã©galitÃ© basÃ©e sur l\'ID', () {
        final plant1 = Plant(
          id: 'same-id',
          name: 'Tomate',
          species: 'Solanum lycopersicum',
          family: 'Solanaceae',
          growthCycles: ['Germination'],
        );

        final plant2 = Plant(
          id: 'same-id',
          name: 'Carotte', // Nom diffÃ©rent
          species: 'Daucus carota', // EspÃ¨ce diffÃ©rente
          family: 'Apiaceae', // Famille diffÃ©rente
          growthCycles: ['Germination', 'Croissance'], // Cycles diffÃ©rents
        );

        final plant3 = Plant(
          id: 'different-id',
          name: 'Tomate', // MÃªme nom
          species: 'Solanum lycopersicum', // MÃªme espÃ¨ce
          family: 'Solanaceae', // MÃªme famille
          growthCycles: ['Germination'], // MÃªmes cycles
        );

        expect(plant1, equals(plant2)); // MÃªme ID
        expect(plant1, isNot(equals(plant3))); // ID diffÃ©rent
        expect(plant1.hashCode, equals(plant2.hashCode));
        expect(plant1.hashCode, isNot(equals(plant3.hashCode)));
      });

      test('Doit gÃ©rer correctement les listes de growthCycles', () {
        final plant1 = Plant(
          id: 'test-cycles-1',
          name: 'Plante A',
          species: 'Species A',
          family: 'Family A',
          growthCycles: ['Germination', 'Croissance', 'Floraison'],
        );

        final plant2 = Plant(
          id: 'test-cycles-2',
          name: 'Plante B',
          species: 'Species B',
          family: 'Family B',
          growthCycles: ['Germination', 'Croissance', 'Floraison'],
        );

        expect(plant1.growthCycles.length, equals(plant2.growthCycles.length));
        expect(plant1.growthCycles, equals(plant2.growthCycles));
      });
    });
  });
}


