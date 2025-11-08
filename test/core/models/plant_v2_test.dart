import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:permacalendar/core/models/plant_v2.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Plant Model Tests (v2) - Instanciation et sérialisation', () {
    late Directory tempDir;
    late Box<Plant> plantBox;
    const uuid = Uuid();

    setUpAll(() async {
      // Créer un répertoire temporaire pour les tests Hive
      tempDir = await Directory.systemTemp.createTemp('plant_v2_test_');

      // Initialiser Hive avec le répertoire temporaire
      Hive.init(tempDir.path);

      // Enregistrer l'adaptateur Plant si pas déjà fait
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
      // Fermer la box après chaque test
      if (plantBox.isOpen) {
        await plantBox.close();
      }
    });

    tearDownAll(() async {
      // Nettoyer complètement après tous les tests
      await Hive.deleteFromDisk();
      await Hive.close();

      // Supprimer le répertoire temporaire
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    group('Tests de création et instanciation', () {
      test('Doit créer un Plant avec tous les champs requis', () {
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

      test('Doit créer un Plant avec une liste de growthCycles vide', () {
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

      test('Factory create doit générer un ID unique automatiquement', () {
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
          growthCycles: ['Germination', 'Croissance', 'Récolte'],
        );

        // Vérifier que les IDs sont générés et différents
        expect(plant1.id, isNotEmpty);
        expect(plant2.id, isNotEmpty);
        expect(plant1.id, isNot(equals(plant2.id)));

        // Vérifier les autres propriétés
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
          growthCycles: ['Germination', 'Croissance', 'Récolte'],
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

    group('Tests de sérialisation/désérialisation JSON', () {
      test('Doit sérialiser correctement avec toJson', () {
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

      test('Doit désérialiser correctement avec fromJson', () {
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
          growthCycles: ['Germination', 'Croissance', 'Floraison', 'Fructification', 'Récolte'],
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

    group('Tests de sérialisation/désérialisation Hive', () {
      test('Doit sauvegarder et récupérer un Plant dans Hive', () async {
        final originalPlant = Plant(
          id: 'test-hive-1',
          name: 'Haricot',
          species: 'Phaseolus vulgaris',
          family: 'Fabaceae',
          growthCycles: ['Germination', 'Croissance', 'Floraison', 'Récolte'],
        );

        // Sauvegarder dans Hive
        await plantBox.put(originalPlant.id, originalPlant);

        // Récupérer depuis Hive
        final retrievedPlant = plantBox.get('test-hive-1');

        // Vérifications
        expect(retrievedPlant, isNotNull);
        expect(retrievedPlant!.id, equals(originalPlant.id));
        expect(retrievedPlant.name, equals(originalPlant.name));
        expect(retrievedPlant.species, equals(originalPlant.species));
        expect(retrievedPlant.family, equals(originalPlant.family));
        expect(retrievedPlant.growthCycles, equals(originalPlant.growthCycles));
      });

      test('Doit persister plusieurs Plants et les récupérer correctement', () async {
        final plants = <Plant>[];

        // Créer plusieurs plantes
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

        // Vérifier que toutes les plantes sont persistées
        expect(plantBox.length, equals(5));

        // Vérifier chaque plante individuellement
        for (int i = 0; i < 5; i++) {
          final retrieved = plantBox.get('plant-hive-$i');
          expect(retrieved, isNotNull);
          expect(retrieved!.name, equals(plantNames[i]));
          expect(retrieved.species, equals(plantSpecies[i]));
          expect(retrieved.family, equals(plantFamilies[i]));
        }
      });

      test('Doit gérer un Plant avec une liste de growthCycles vide dans Hive', () async {
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

    group('Tests de la méthode copyWith', () {
      test('Doit créer une copie avec des modifications', () {
        final original = Plant(
          id: 'test-copy-1',
          name: 'Tomate Originale',
          species: 'Solanum lycopersicum',
          family: 'Solanaceae',
          growthCycles: ['Germination', 'Croissance'],
        );

        final modified = original.copyWith(
          name: 'Tomate Modifiée',
          growthCycles: ['Germination', 'Croissance', 'Floraison', 'Fructification'],
        );

        // Vérifier que les champs modifiés ont changé
        expect(modified.name, equals('Tomate Modifiée'));
        expect(modified.growthCycles.length, equals(4));

        // Vérifier que les autres champs sont inchangés
        expect(modified.id, equals(original.id));
        expect(modified.species, equals(original.species));
        expect(modified.family, equals(original.family));
      });

      test('Doit créer une copie sans modifications si aucun paramètre fourni', () {
        final original = Plant(
          id: 'test-copy-2',
          name: 'Carotte',
          species: 'Daucus carota',
          family: 'Apiaceae',
          growthCycles: ['Germination', 'Croissance', 'Récolte'],
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
        expect(modified.species, equals('Lactuca sativa')); // Inchangé
        expect(modified.family, equals('Asteraceae')); // Inchangé
        expect(modified.growthCycles, equals(['Germination'])); // Inchangé
      });
    });

    group('Tests des méthodes utilitaires', () {
      test('Doit implémenter toString correctement', () {
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

      test('Doit implémenter l\'égalité basée sur l\'ID', () {
        final plant1 = Plant(
          id: 'same-id',
          name: 'Tomate',
          species: 'Solanum lycopersicum',
          family: 'Solanaceae',
          growthCycles: ['Germination'],
        );

        final plant2 = Plant(
          id: 'same-id',
          name: 'Carotte', // Nom différent
          species: 'Daucus carota', // Espèce différente
          family: 'Apiaceae', // Famille différente
          growthCycles: ['Germination', 'Croissance'], // Cycles différents
        );

        final plant3 = Plant(
          id: 'different-id',
          name: 'Tomate', // Même nom
          species: 'Solanum lycopersicum', // Même espèce
          family: 'Solanaceae', // Même famille
          growthCycles: ['Germination'], // Mêmes cycles
        );

        expect(plant1, equals(plant2)); // Même ID
        expect(plant1, isNot(equals(plant3))); // ID différent
        expect(plant1.hashCode, equals(plant2.hashCode));
        expect(plant1.hashCode, isNot(equals(plant3.hashCode)));
      });

      test('Doit gérer correctement les listes de growthCycles', () {
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

