
import '../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:permacalendar/core/models/garden_v2.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Garden Model Tests (v2) - Instanciation et sÃ©rialisation', () {
    late Directory tempDir;
    late Box<Garden> gardenBox;
    const uuid = Uuid();

    setUpAll(() async {
      // CrÃ©er un rÃ©pertoire temporaire pour les tests Hive
      tempDir = await Directory.systemTemp.createTemp('garden_v2_test_');

      // Initialiser Hive avec le rÃ©pertoire temporaire
      Hive.init(tempDir.path);

      // Enregistrer l'adaptateur Garden si pas dÃ©jÃ  fait
      if (!Hive.isAdapterRegistered(10)) {
        Hive.registerAdapter(GardenAdapter());
      }
    });

    setUp(() async {
      // Ouvrir une nouvelle box pour chaque test
      gardenBox = await Hive.openBox<Garden>('test_gardens_v2');
      await gardenBox.clear();
    });

    tearDown(() async {
      // Fermer la box aprÃ¨s chaque test
      if (gardenBox.isOpen) {
        await gardenBox.close();
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
      test('Doit crÃ©er un Garden avec tous les champs requis', () {
        final garden = Garden(
          id: 'test-garden-1',
          name: 'Mon Jardin',
          description: 'Un beau jardin de permaculture',
          location: 'Paris, France',
          createdDate: DateTime(2024, 1, 15),
          gardenBeds: ['bed-1', 'bed-2', 'bed-3'],
        );

        expect(garden.id, equals('test-garden-1'));
        expect(garden.name, equals('Mon Jardin'));
        expect(garden.description, equals('Un beau jardin de permaculture'));
        expect(garden.location, equals('Paris, France'));
        expect(garden.createdDate, equals(DateTime(2024, 1, 15)));
        expect(garden.gardenBeds, equals(['bed-1', 'bed-2', 'bed-3']));
        expect(garden.gardenBeds.length, equals(3));
      });

      test('Doit crÃ©er un Garden avec une liste de gardenBeds vide', () {
        final garden = Garden(
          id: 'test-garden-2',
          name: 'Jardin Vide',
          description: 'Un jardin sans parcelles',
          location: 'Lyon, France',
          createdDate: DateTime(2024, 2, 1),
          gardenBeds: [],
        );

        expect(garden.gardenBeds, isEmpty);
        expect(garden.gardenBeds.length, equals(0));
      });

      test('Factory create doit gÃ©nÃ©rer un ID unique automatiquement', () {
        final garden1 = Garden.create(
          name: 'Jardin Est',
          description: 'Description 1',
          location: 'Marseille, France',
        );

        final garden2 = Garden.create(
          name: 'Jardin Ouest',
          description: 'Description 2',
          location: 'Bordeaux, France',
        );

        // VÃ©rifier que les IDs sont gÃ©nÃ©rÃ©s et diffÃ©rents
        expect(garden1.id, isNotEmpty);
        expect(garden2.id, isNotEmpty);
        expect(garden1.id, isNot(equals(garden2.id)));

        // VÃ©rifier les autres propriÃ©tÃ©s
        expect(garden1.name, equals('Jardin Est'));
        expect(garden1.description, equals('Description 1'));
        expect(garden1.location, equals('Marseille, France'));
        expect(garden1.gardenBeds, isEmpty); // Par dÃ©faut, liste vide
        expect(garden1.createdDate, isA<DateTime>());

        expect(garden2.name, equals('Jardin Ouest'));
        expect(garden2.description, equals('Description 2'));
        expect(garden2.location, equals('Bordeaux, France'));
      });

      test('Factory create doit accepter une liste de gardenBeds optionnelle', () {
        final garden = Garden.create(
          name: 'Jardin avec parcelles',
          description: 'Un jardin avec plusieurs parcelles',
          location: 'Toulouse, France',
          gardenBeds: ['bed-a', 'bed-b', 'bed-c'],
        );

        expect(garden.gardenBeds.length, equals(3));
        expect(garden.gardenBeds, contains('bed-a'));
        expect(garden.gardenBeds, contains('bed-b'));
        expect(garden.gardenBeds, contains('bed-c'));
      });
    });

    group('Tests de sÃ©rialisation/dÃ©sÃ©rialisation JSON', () {
      test('Doit sÃ©rialiser correctement avec toJson', () {
        final garden = Garden(
          id: 'test-garden-json-1',
          name: 'Jardin JSON',
          description: 'Description JSON',
          location: 'Nantes, France',
          createdDate: DateTime(2024, 3, 10, 14, 30),
          gardenBeds: ['bed-1', 'bed-2'],
        );

        final json = garden.toJson();

        expect(json['id'], equals('test-garden-json-1'));
        expect(json['name'], equals('Jardin JSON'));
        expect(json['description'], equals('Description JSON'));
        expect(json['location'], equals('Nantes, France'));
        expect(json['createdDate'], equals('2024-03-10T14:30:00.000'));
        expect(json['gardenBeds'], equals(['bed-1', 'bed-2']));
        expect(json['gardenBeds'], isA<List<String>>());
      });

      test('Doit dÃ©sÃ©rialiser correctement avec fromJson', () {
        final json = {
          'id': 'test-garden-json-2',
          'name': 'Jardin depuis JSON',
          'description': 'Description depuis JSON',
          'location': 'Strasbourg, France',
          'createdDate': '2024-04-15T10:00:00.000',
          'gardenBeds': ['bed-x', 'bed-y'],
        };

        final garden = Garden.fromJson(json);

        expect(garden.id, equals('test-garden-json-2'));
        expect(garden.name, equals('Jardin depuis JSON'));
        expect(garden.description, equals('Description depuis JSON'));
        expect(garden.location, equals('Strasbourg, France'));
        expect(garden.createdDate, equals(DateTime(2024, 4, 15, 10, 0)));
        expect(garden.gardenBeds, equals(['bed-x', 'bed-y']));
      });

      test('fromJson doit gÃ©rer le cas oÃ¹ gardenBeds est null ou absent', () {
        final json1 = {
          'id': 'test-garden-json-3',
          'name': 'Jardin sans parcelles',
          'description': 'Description',
          'location': 'Lille, France',
          'createdDate': '2024-05-01T12:00:00.000',
          'gardenBeds': null,
        };

        final json2 = {
          'id': 'test-garden-json-4',
          'name': 'Jardin sans champ gardenBeds',
          'description': 'Description',
          'location': 'Nice, France',
          'createdDate': '2024-05-02T12:00:00.000',
        };

        final garden1 = Garden.fromJson(json1);
        final garden2 = Garden.fromJson(json2);

        expect(garden1.gardenBeds, isEmpty);
        expect(garden2.gardenBeds, isEmpty);
      });

      test('Doit faire un round-trip JSON (toJson -> fromJson)', () {
        final original = Garden(
          id: 'test-roundtrip',
          name: 'Jardin RoundTrip',
          description: 'Description RoundTrip',
          location: 'Montpellier, France',
          createdDate: DateTime(2024, 6, 20, 15, 45),
          gardenBeds: ['rt1', 'rt2', 'rt3'],
        );

        final json = original.toJson();
        final restored = Garden.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.name, equals(original.name));
        expect(restored.description, equals(original.description));
        expect(restored.location, equals(original.location));
        expect(restored.createdDate, equals(original.createdDate));
        expect(restored.gardenBeds, equals(original.gardenBeds));
      });
    });

    group('Tests de sÃ©rialisation/dÃ©sÃ©rialisation Hive', () {
      test('Doit sauvegarder et rÃ©cupÃ©rer un Garden dans Hive', () async {
        final originalGarden = Garden(
          id: 'test-hive-1',
          name: 'Jardin Hive',
          description: 'Description Hive',
          location: 'Rennes, France',
          createdDate: DateTime(2024, 7, 1),
          gardenBeds: ['h1', 'h2', 'h3'],
        );

        // Sauvegarder dans Hive
        await gardenBox.put(originalGarden.id, originalGarden);

        // RÃ©cupÃ©rer depuis Hive
        final retrievedGarden = gardenBox.get('test-hive-1');

        // VÃ©rifications
        expect(retrievedGarden, isNotNull);
        expect(retrievedGarden!.id, equals(originalGarden.id));
        expect(retrievedGarden.name, equals(originalGarden.name));
        expect(retrievedGarden.description, equals(originalGarden.description));
        expect(retrievedGarden.location, equals(originalGarden.location));
        expect(retrievedGarden.createdDate, equals(originalGarden.createdDate));
        expect(retrievedGarden.gardenBeds, equals(originalGarden.gardenBeds));
      });

      test('Doit persister plusieurs Gardens et les rÃ©cupÃ©rer correctement', () async {
        final gardens = <Garden>[];

        // CrÃ©er plusieurs jardins
        for (int i = 0; i < 5; i++) {
          final garden = Garden(
            id: 'garden-hive-$i',
            name: 'Jardin $i',
            description: 'Description $i',
            location: 'Ville $i, France',
            createdDate: DateTime(2024, 1, 1 + i),
            gardenBeds: ['bed-$i-1', 'bed-$i-2'],
          );

          gardens.add(garden);
          await gardenBox.put(garden.id, garden);
        }

        // VÃ©rifier que tous les jardins sont persistÃ©s
        expect(gardenBox.length, equals(5));

        // VÃ©rifier chaque jardin individuellement
        for (int i = 0; i < 5; i++) {
          final retrieved = gardenBox.get('garden-hive-$i');
          expect(retrieved, isNotNull);
          expect(retrieved!.name, equals('Jardin $i'));
          expect(retrieved.description, equals('Description $i'));
          expect(retrieved.location, equals('Ville $i, France'));
          expect(retrieved.gardenBeds.length, equals(2));
        }
      });

      test('Doit gÃ©rer un Garden avec une liste de gardenBeds vide dans Hive', () async {
        final garden = Garden(
          id: 'garden-empty-beds',
          name: 'Jardin vide',
          description: 'Description',
          location: 'Tours, France',
          createdDate: DateTime(2024, 8, 1),
          gardenBeds: [],
        );

        await gardenBox.put(garden.id, garden);
        final retrieved = gardenBox.get('garden-empty-beds');

        expect(retrieved, isNotNull);
        expect(retrieved!.gardenBeds, isEmpty);
      });
    });

    group('Tests de la mÃ©thode copyWith', () {
      test('Doit crÃ©er une copie avec des modifications', () {
        final original = Garden(
          id: 'test-copy-1',
          name: 'Jardin Original',
          description: 'Description Originale',
          location: 'Angers, France',
          createdDate: DateTime(2024, 9, 1),
          gardenBeds: ['bed-1', 'bed-2'],
        );

        final modified = original.copyWith(
          name: 'Jardin ModifiÃ©',
          description: 'Description ModifiÃ©e',
          location: 'Caen, France',
          gardenBeds: ['bed-1', 'bed-2', 'bed-3'],
        );

        // VÃ©rifier que les champs modifiÃ©s ont changÃ©
        expect(modified.name, equals('Jardin ModifiÃ©'));
        expect(modified.description, equals('Description ModifiÃ©e'));
        expect(modified.location, equals('Caen, France'));
        expect(modified.gardenBeds.length, equals(3));

        // VÃ©rifier que les autres champs sont inchangÃ©s
        expect(modified.id, equals(original.id));
        expect(modified.createdDate, equals(original.createdDate));
      });

      test('Doit crÃ©er une copie sans modifications si aucun paramÃ¨tre fourni', () {
        final original = Garden(
          id: 'test-copy-2',
          name: 'Jardin Test',
          description: 'Description Test',
          location: 'Le Mans, France',
          createdDate: DateTime(2024, 10, 1),
          gardenBeds: ['bed-1'],
        );

        final copy = original.copyWith();

        expect(copy.id, equals(original.id));
        expect(copy.name, equals(original.name));
        expect(copy.description, equals(original.description));
        expect(copy.location, equals(original.location));
        expect(copy.createdDate, equals(original.createdDate));
        expect(copy.gardenBeds, equals(original.gardenBeds));
      });

      test('Doit permettre de modifier uniquement certains champs', () {
        final original = Garden(
          id: 'test-copy-3',
          name: 'Jardin A',
          description: 'Description A',
          location: 'NÃ®mes, France',
          createdDate: DateTime(2024, 11, 1),
          gardenBeds: ['bed-1'],
        );

        final modified = original.copyWith(
          name: 'Jardin B',
        );

        expect(modified.name, equals('Jardin B'));
        expect(modified.description, equals('Description A')); // InchangÃ©
        expect(modified.location, equals('NÃ®mes, France')); // InchangÃ©
        expect(modified.gardenBeds, equals(['bed-1'])); // InchangÃ©
      });
    });

    group('Tests des mÃ©thodes utilitaires', () {
      test('Doit implÃ©menter toString correctement', () {
        final garden = Garden(
          id: 'test-toString',
          name: 'Mon Jardin',
          description: 'Description',
          location: 'Aix-en-Provence, France',
          createdDate: DateTime(2024, 12, 1),
          gardenBeds: ['bed-1', 'bed-2', 'bed-3'],
        );

        final string = garden.toString();
        expect(string, contains('Garden'));
        expect(string, contains('test-toString'));
        expect(string, contains('Mon Jardin'));
        expect(string, contains('Aix-en-Provence, France'));
        expect(string, contains('3')); // Nombre de gardenBeds
      });

      test('Doit implÃ©menter l\'Ã©galitÃ© basÃ©e sur l\'ID', () {
        final garden1 = Garden(
          id: 'same-id',
          name: 'Jardin 1',
          description: 'Description 1',
          location: 'Location 1',
          createdDate: DateTime(2024, 1, 1),
          gardenBeds: ['bed-1'],
        );

        final garden2 = Garden(
          id: 'same-id',
          name: 'Jardin 2', // Nom diffÃ©rent
          description: 'Description 2', // Description diffÃ©rente
          location: 'Location 2', // Location diffÃ©rente
          createdDate: DateTime(2024, 2, 1), // Date diffÃ©rente
          gardenBeds: ['bed-2'], // Beds diffÃ©rents
        );

        final garden3 = Garden(
          id: 'different-id',
          name: 'Jardin 1', // MÃªme nom
          description: 'Description 1', // MÃªme description
          location: 'Location 1', // MÃªme location
          createdDate: DateTime(2024, 1, 1), // MÃªme date
          gardenBeds: ['bed-1'], // MÃªmes beds
        );

        expect(garden1, equals(garden2)); // MÃªme ID
        expect(garden1, isNot(equals(garden3))); // ID diffÃ©rent
        expect(garden1.hashCode, equals(garden2.hashCode));
        expect(garden1.hashCode, isNot(equals(garden3.hashCode)));
      });

      test('Doit gÃ©rer correctement les dates DateTime', () {
        final date1 = DateTime(2024, 1, 15, 10, 30, 45);
        final date2 = DateTime(2024, 1, 15, 10, 30, 45);

        final garden1 = Garden(
          id: 'test-date-1',
          name: 'Jardin',
          description: 'Description',
          location: 'Location',
          createdDate: date1,
          gardenBeds: [],
        );

        final garden2 = Garden(
          id: 'test-date-2',
          name: 'Jardin',
          description: 'Description',
          location: 'Location',
          createdDate: date2,
          gardenBeds: [],
        );

        expect(garden1.createdDate, equals(garden2.createdDate));
      });
    });
  });
}


