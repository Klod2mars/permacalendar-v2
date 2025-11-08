import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:permacalendar/core/models/garden_bed_v2.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GardenBed Model Tests (v2) - Instanciation et sérialisation', () {
    late Directory tempDir;
    late Box<GardenBed> gardenBedBox;
    const uuid = Uuid();

    setUpAll(() async {
      // Créer un répertoire temporaire pour les tests Hive
      tempDir = await Directory.systemTemp.createTemp('garden_bed_v2_test_');

      // Initialiser Hive avec le répertoire temporaire
      Hive.init(tempDir.path);

      // Enregistrer l'adaptateur GardenBed si pas déjà fait
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
      // Fermer la box après chaque test
      if (gardenBedBox.isOpen) {
        await gardenBedBox.close();
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
      test('Doit créer un GardenBed avec tous les champs requis', () {
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

      test('Doit créer un GardenBed avec une liste de plantings vide', () {
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

      test('Factory create doit générer un ID unique automatiquement', () {
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

        // Vérifier que les IDs sont générés et différents
        expect(gardenBed1.id, isNotEmpty);
        expect(gardenBed2.id, isNotEmpty);
        expect(gardenBed1.id, isNot(equals(gardenBed2.id)));

        // Vérifier les autres propriétés
        expect(gardenBed1.name, equals('Parcelle Est'));
        expect(gardenBed1.sizeInSquareMeters, equals(10.0));
        expect(gardenBed1.gardenId, equals('garden-789'));
        expect(gardenBed1.plantings, isEmpty); // Par défaut, liste vide

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

    group('Tests de sérialisation/désérialisation JSON', () {
      test('Doit sérialiser correctement avec toJson', () {
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

      test('Doit désérialiser correctement avec fromJson', () {
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

      test('fromJson doit gérer le cas où plantings est null ou absent', () {
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

    group('Tests de sérialisation/désérialisation Hive', () {
      test('Doit sauvegarder et récupérer un GardenBed dans Hive', () async {
        final originalBed = GardenBed(
          id: 'test-hive-1',
          name: 'Parcelle Hive',
          sizeInSquareMeters: 22.5,
          gardenId: 'garden-hive-1',
          plantings: ['h1', 'h2', 'h3'],
        );

        // Sauvegarder dans Hive
        await gardenBedBox.put(originalBed.id, originalBed);

        // Récupérer depuis Hive
        final retrievedBed = gardenBedBox.get('test-hive-1');

        // Vérifications
        expect(retrievedBed, isNotNull);
        expect(retrievedBed!.id, equals(originalBed.id));
        expect(retrievedBed.name, equals(originalBed.name));
        expect(retrievedBed.sizeInSquareMeters, equals(originalBed.sizeInSquareMeters));
        expect(retrievedBed.gardenId, equals(originalBed.gardenId));
        expect(retrievedBed.plantings, equals(originalBed.plantings));
      });

      test('Doit persister plusieurs GardenBeds et les récupérer correctement', () async {
        final beds = <GardenBed>[];

        // Créer plusieurs parcelles
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

        // Vérifier que toutes les parcelles sont persistées
        expect(gardenBedBox.length, equals(5));

        // Vérifier chaque parcelle individuellement
        for (int i = 0; i < 5; i++) {
          final retrieved = gardenBedBox.get('bed-hive-$i');
          expect(retrieved, isNotNull);
          expect(retrieved!.name, equals('Parcelle $i'));
          expect(retrieved.sizeInSquareMeters, equals((i + 1) * 5.0));
          expect(retrieved.plantings.length, equals(2));
        }
      });

      test('Doit gérer un GardenBed avec une liste de plantings vide dans Hive', () async {
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

    group('Tests de la méthode copyWith', () {
      test('Doit créer une copie avec des modifications', () {
        final original = GardenBed(
          id: 'test-copy-1',
          name: 'Parcelle Originale',
          sizeInSquareMeters: 15.0,
          gardenId: 'garden-original',
          plantings: ['p1', 'p2'],
        );

        final modified = original.copyWith(
          name: 'Parcelle Modifiée',
          sizeInSquareMeters: 20.0,
          plantings: ['p1', 'p2', 'p3'],
        );

        // Vérifier que les champs modifiés ont changé
        expect(modified.name, equals('Parcelle Modifiée'));
        expect(modified.sizeInSquareMeters, equals(20.0));
        expect(modified.plantings.length, equals(3));

        // Vérifier que les autres champs sont inchangés
        expect(modified.id, equals(original.id));
        expect(modified.gardenId, equals(original.gardenId));
      });

      test('Doit créer une copie sans modifications si aucun paramètre fourni', () {
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
        expect(modified.sizeInSquareMeters, equals(10.0)); // Inchangé
        expect(modified.gardenId, equals('garden-a')); // Inchangé
        expect(modified.plantings, equals(['p1'])); // Inchangé
      });
    });

    group('Tests des méthodes utilitaires', () {
      test('Doit implémenter toString correctement', () {
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
        expect(string, contains('15.5m²'));
        expect(string, contains('3')); // Nombre de plantings
      });

      test('Doit implémenter l\'égalité basée sur l\'ID', () {
        final bed1 = GardenBed(
          id: 'same-id',
          name: 'Parcelle 1',
          sizeInSquareMeters: 10.0,
          gardenId: 'garden-1',
          plantings: ['p1'],
        );

        final bed2 = GardenBed(
          id: 'same-id',
          name: 'Parcelle 2', // Nom différent
          sizeInSquareMeters: 20.0, // Taille différente
          gardenId: 'garden-2', // Jardin différent
          plantings: ['p2'], // Plantings différents
        );

        final bed3 = GardenBed(
          id: 'different-id',
          name: 'Parcelle 1', // Même nom
          sizeInSquareMeters: 10.0, // Même taille
          gardenId: 'garden-1', // Même jardin
          plantings: ['p1'], // Mêmes plantings
        );

        expect(bed1, equals(bed2)); // Même ID
        expect(bed1, isNot(equals(bed3))); // ID différent
        expect(bed1.hashCode, equals(bed2.hashCode));
        expect(bed1.hashCode, isNot(equals(bed3.hashCode)));
      });

      test('Doit gérer correctement les valeurs numériques (double)', () {
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

