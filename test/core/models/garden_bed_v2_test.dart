
import '../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:permacalendar/core/models/garden_bed_v2.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GardenBed Model Tests (v2) - Instanciation et sÃ©rialisation', () {
    late Directory tempDir;
    late Box<GardenBed> gardenBedBox;
    const uuid = Uuid();

    setUpAll(() async {
      // CrÃ©er un rÃ©pertoire temporaire pour les tests Hive
      tempDir = await Directory.systemTemp.createTemp('garden_bed_v2_test_');

      // Initialiser Hive avec le rÃ©pertoire temporaire
      Hive.init(tempDir.path);

      // Enregistrer l'adaptateur GardenBed si pas dÃ©jÃ  fait
      if (!Hive.isAdapterRegistered(11)) {
        Hive.registerAdapter(GardenBedAdapter());
      }
    });

    setUp(() async {
      // Ouvrir une nouvelle box pour chaque test
      gardenBedBox = await Hive.openBox<GardenBed>('test_garden_beds_v2');
      await gardenBedBox.clear();
    });

    tearDown(() async {
      // Fermer la box aprÃ¨s chaque test
      if (gardenBedBox.isOpen) {
        await gardenBedBox.close();
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
      test('Doit crÃ©er un GardenBed avec tous les champs requis', () {
        final gardenBed = GardenBed(
          id: 'test-bed-1',
          name: 'Parcelle Nord',
          sizeInSquareMeters: 12.5,
          gardenId: 'garden-123',
          plantings: ['planting-1', 'planting-2'],
        );

        expect(gardenBed.id, equals('test-bed-1'));
        expect(gardenBed.name, equals('Parcelle Nord'));
        expect(gardenBed.sizeInSquareMeters, equals(12.5));
        expect(gardenBed.gardenId, equals('garden-123'));
        expect(gardenBed.plantings, equals(['planting-1', 'planting-2']));
        expect(gardenBed.plantings.length, equals(2));
      });

      test('Doit crÃ©er un GardenBed avec une liste de plantings vide', () {
        final gardenBed = GardenBed(
          id: 'test-bed-2',
          name: 'Parcelle Sud',
          sizeInSquareMeters: 8.0,
          gardenId: 'garden-456',
          plantings: [],
        );

        expect(gardenBed.plantings, isEmpty);
        expect(gardenBed.plantings.length, equals(0));
      });

      test('Factory create doit gÃ©nÃ©rer un ID unique automatiquement', () {
        final gardenBed1 = GardenBed.create(
          name: 'Parcelle Est',
          sizeInSquareMeters: 10.0,
          gardenId: 'garden-789',
        );

        final gardenBed2 = GardenBed.create(
          name: 'Parcelle Ouest',
          sizeInSquareMeters: 15.0,
          gardenId: 'garden-789',
        );

        // VÃ©rifier que les IDs sont gÃ©nÃ©rÃ©s et diffÃ©rents
        expect(gardenBed1.id, isNotEmpty);
        expect(gardenBed2.id, isNotEmpty);
        expect(gardenBed1.id, isNot(equals(gardenBed2.id)));

        // VÃ©rifier les autres propriÃ©tÃ©s
        expect(gardenBed1.name, equals('Parcelle Est'));
        expect(gardenBed1.sizeInSquareMeters, equals(10.0));
        expect(gardenBed1.gardenId, equals('garden-789'));
        expect(gardenBed1.plantings, isEmpty); // Par dÃ©faut, liste vide

        expect(gardenBed2.name, equals('Parcelle Ouest'));
        expect(gardenBed2.sizeInSquareMeters, equals(15.0));
      });

      test('Factory create doit accepter une liste de plantings optionnelle', () {
        final gardenBed = GardenBed.create(
          name: 'Parcelle avec plantings',
          sizeInSquareMeters: 20.0,
          gardenId: 'garden-999',
          plantings: ['planting-a', 'planting-b', 'planting-c'],
        );

        expect(gardenBed.plantings.length, equals(3));
        expect(gardenBed.plantings, contains('planting-a'));
        expect(gardenBed.plantings, contains('planting-b'));
        expect(gardenBed.plantings, contains('planting-c'));
      });
    });

    group('Tests de sÃ©rialisation/dÃ©sÃ©rialisation JSON', () {
      test('Doit sÃ©rialiser correctement avec toJson', () {
        final gardenBed = GardenBed(
          id: 'test-bed-json-1',
          name: 'Parcelle JSON',
          sizeInSquareMeters: 25.75,
          gardenId: 'garden-json-1',
          plantings: ['p1', 'p2', 'p3'],
        );

        final json = gardenBed.toJson();

        expect(json['id'], equals('test-bed-json-1'));
        expect(json['name'], equals('Parcelle JSON'));
        expect(json['sizeInSquareMeters'], equals(25.75));
        expect(json['gardenId'], equals('garden-json-1'));
        expect(json['plantings'], equals(['p1', 'p2', 'p3']));
        expect(json['plantings'], isA<List<String>>());
      });

      test('Doit dÃ©sÃ©rialiser correctement avec fromJson', () {
        final json = {
          'id': 'test-bed-json-2',
          'name': 'Parcelle depuis JSON',
          'sizeInSquareMeters': 30.5,
          'gardenId': 'garden-json-2',
          'plantings': ['planting-x', 'planting-y'],
        };

        final gardenBed = GardenBed.fromJson(json);

        expect(gardenBed.id, equals('test-bed-json-2'));
        expect(gardenBed.name, equals('Parcelle depuis JSON'));
        expect(gardenBed.sizeInSquareMeters, equals(30.5));
        expect(gardenBed.gardenId, equals('garden-json-2'));
        expect(gardenBed.plantings, equals(['planting-x', 'planting-y']));
      });

      test('fromJson doit gÃ©rer le cas oÃ¹ plantings est null ou absent', () {
        final json1 = {
          'id': 'test-bed-json-3',
          'name': 'Parcelle sans plantings',
          'sizeInSquareMeters': 15.0,
          'gardenId': 'garden-json-3',
          'plantings': null,
        };

        final json2 = {
          'id': 'test-bed-json-4',
          'name': 'Parcelle sans champ plantings',
          'sizeInSquareMeters': 20.0,
          'gardenId': 'garden-json-4',
        };

        final gardenBed1 = GardenBed.fromJson(json1);
        final gardenBed2 = GardenBed.fromJson(json2);

        expect(gardenBed1.plantings, isEmpty);
        expect(gardenBed2.plantings, isEmpty);
      });

      test('Doit faire un round-trip JSON (toJson -> fromJson)', () {
        final original = GardenBed(
          id: 'test-roundtrip',
          name: 'Parcelle RoundTrip',
          sizeInSquareMeters: 18.25,
          gardenId: 'garden-roundtrip',
          plantings: ['rt1', 'rt2'],
        );

        final json = original.toJson();
        final restored = GardenBed.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.name, equals(original.name));
        expect(restored.sizeInSquareMeters, equals(original.sizeInSquareMeters));
        expect(restored.gardenId, equals(original.gardenId));
        expect(restored.plantings, equals(original.plantings));
      });
    });

    group('Tests de sÃ©rialisation/dÃ©sÃ©rialisation Hive', () {
      test('Doit sauvegarder et rÃ©cupÃ©rer un GardenBed dans Hive', () async {
        final originalBed = GardenBed(
          id: 'test-hive-1',
          name: 'Parcelle Hive',
          sizeInSquareMeters: 22.5,
          gardenId: 'garden-hive-1',
          plantings: ['h1', 'h2', 'h3'],
        );

        // Sauvegarder dans Hive
        await gardenBedBox.put(originalBed.id, originalBed);

        // RÃ©cupÃ©rer depuis Hive
        final retrievedBed = gardenBedBox.get('test-hive-1');

        // VÃ©rifications
        expect(retrievedBed, isNotNull);
        expect(retrievedBed!.id, equals(originalBed.id));
        expect(retrievedBed.name, equals(originalBed.name));
        expect(retrievedBed.sizeInSquareMeters, equals(originalBed.sizeInSquareMeters));
        expect(retrievedBed.gardenId, equals(originalBed.gardenId));
        expect(retrievedBed.plantings, equals(originalBed.plantings));
      });

      test('Doit persister plusieurs GardenBeds et les rÃ©cupÃ©rer correctement', () async {
        final beds = <GardenBed>[];

        // CrÃ©er plusieurs parcelles
        for (int i = 0; i < 5; i++) {
          final bed = GardenBed(
            id: 'bed-hive-$i',
            name: 'Parcelle $i',
            sizeInSquareMeters: (i + 1) * 5.0,
            gardenId: 'garden-hive-batch',
            plantings: ['p$i-1', 'p$i-2'],
          );

          beds.add(bed);
          await gardenBedBox.put(bed.id, bed);
        }

        // VÃ©rifier que toutes les parcelles sont persistÃ©es
        expect(gardenBedBox.length, equals(5));

        // VÃ©rifier chaque parcelle individuellement
        for (int i = 0; i < 5; i++) {
          final retrieved = gardenBedBox.get('bed-hive-$i');
          expect(retrieved, isNotNull);
          expect(retrieved!.name, equals('Parcelle $i'));
          expect(retrieved.sizeInSquareMeters, equals((i + 1) * 5.0));
          expect(retrieved.plantings.length, equals(2));
        }
      });

      test('Doit gÃ©rer un GardenBed avec une liste de plantings vide dans Hive', () async {
        final bed = GardenBed(
          id: 'bed-empty-plantings',
          name: 'Parcelle vide',
          sizeInSquareMeters: 10.0,
          gardenId: 'garden-empty',
          plantings: [],
        );

        await gardenBedBox.put(bed.id, bed);
        final retrieved = gardenBedBox.get('bed-empty-plantings');

        expect(retrieved, isNotNull);
        expect(retrieved!.plantings, isEmpty);
      });
    });

    group('Tests de la mÃ©thode copyWith', () {
      test('Doit crÃ©er une copie avec des modifications', () {
        final original = GardenBed(
          id: 'test-copy-1',
          name: 'Parcelle Originale',
          sizeInSquareMeters: 15.0,
          gardenId: 'garden-original',
          plantings: ['p1', 'p2'],
        );

        final modified = original.copyWith(
          name: 'Parcelle ModifiÃ©e',
          sizeInSquareMeters: 20.0,
          plantings: ['p1', 'p2', 'p3'],
        );

        // VÃ©rifier que les champs modifiÃ©s ont changÃ©
        expect(modified.name, equals('Parcelle ModifiÃ©e'));
        expect(modified.sizeInSquareMeters, equals(20.0));
        expect(modified.plantings.length, equals(3));

        // VÃ©rifier que les autres champs sont inchangÃ©s
        expect(modified.id, equals(original.id));
        expect(modified.gardenId, equals(original.gardenId));
      });

      test('Doit crÃ©er une copie sans modifications si aucun paramÃ¨tre fourni', () {
        final original = GardenBed(
          id: 'test-copy-2',
          name: 'Parcelle Test',
          sizeInSquareMeters: 12.0,
          gardenId: 'garden-test',
          plantings: ['p1'],
        );

        final copy = original.copyWith();

        expect(copy.id, equals(original.id));
        expect(copy.name, equals(original.name));
        expect(copy.sizeInSquareMeters, equals(original.sizeInSquareMeters));
        expect(copy.gardenId, equals(original.gardenId));
        expect(copy.plantings, equals(original.plantings));
      });

      test('Doit permettre de modifier uniquement certains champs', () {
        final original = GardenBed(
          id: 'test-copy-3',
          name: 'Parcelle A',
          sizeInSquareMeters: 10.0,
          gardenId: 'garden-a',
          plantings: ['p1'],
        );

        final modified = original.copyWith(
          name: 'Parcelle B',
        );

        expect(modified.name, equals('Parcelle B'));
        expect(modified.sizeInSquareMeters, equals(10.0)); // InchangÃ©
        expect(modified.gardenId, equals('garden-a')); // InchangÃ©
        expect(modified.plantings, equals(['p1'])); // InchangÃ©
      });
    });

    group('Tests des mÃ©thodes utilitaires', () {
      test('Doit implÃ©menter toString correctement', () {
        final gardenBed = GardenBed(
          id: 'test-toString',
          name: 'Ma Parcelle',
          sizeInSquareMeters: 15.5,
          gardenId: 'garden-123',
          plantings: ['p1', 'p2', 'p3'],
        );

        final string = gardenBed.toString();
        expect(string, contains('GardenBed'));
        expect(string, contains('test-toString'));
        expect(string, contains('Ma Parcelle'));
        expect(string, contains('15.5mÂ²'));
        expect(string, contains('3')); // Nombre de plantings
      });

      test('Doit implÃ©menter l\'Ã©galitÃ© basÃ©e sur l\'ID', () {
        final bed1 = GardenBed(
          id: 'same-id',
          name: 'Parcelle 1',
          sizeInSquareMeters: 10.0,
          gardenId: 'garden-1',
          plantings: ['p1'],
        );

        final bed2 = GardenBed(
          id: 'same-id',
          name: 'Parcelle 2', // Nom diffÃ©rent
          sizeInSquareMeters: 20.0, // Taille diffÃ©rente
          gardenId: 'garden-2', // Jardin diffÃ©rent
          plantings: ['p2'], // Plantings diffÃ©rents
        );

        final bed3 = GardenBed(
          id: 'different-id',
          name: 'Parcelle 1', // MÃªme nom
          sizeInSquareMeters: 10.0, // MÃªme taille
          gardenId: 'garden-1', // MÃªme jardin
          plantings: ['p1'], // MÃªmes plantings
        );

        expect(bed1, equals(bed2)); // MÃªme ID
        expect(bed1, isNot(equals(bed3))); // ID diffÃ©rent
        expect(bed1.hashCode, equals(bed2.hashCode));
        expect(bed1.hashCode, isNot(equals(bed3.hashCode)));
      });

      test('Doit gÃ©rer correctement les valeurs numÃ©riques (double)', () {
        final bed1 = GardenBed(
          id: 'test-double-1',
          name: 'Parcelle',
          sizeInSquareMeters: 12.3456789,
          gardenId: 'garden-1',
          plantings: [],
        );

        final bed2 = GardenBed(
          id: 'test-double-2',
          name: 'Parcelle',
          sizeInSquareMeters: 12.3456789,
          gardenId: 'garden-1',
          plantings: [],
        );

        expect(bed1.sizeInSquareMeters, equals(bed2.sizeInSquareMeters));
      });
    });
  });
}


