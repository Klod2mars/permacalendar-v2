
import '../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:permacalendar/core/models/planting_v2.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Planting Model Tests (v2) - Instanciation et sÃ©rialisation', () {
    late Directory tempDir;
    late Box<Planting> plantingBox;
    const uuid = Uuid();

    setUpAll(() async {
      // CrÃ©er un rÃ©pertoire temporaire pour les tests Hive
      tempDir = await Directory.systemTemp.createTemp('planting_v2_test_');

      // Initialiser Hive avec le rÃ©pertoire temporaire
      Hive.init(tempDir.path);

      // Enregistrer l'adaptateur Planting si pas dÃ©jÃ  fait
      if (!Hive.isAdapterRegistered(14)) {
        Hive.registerAdapter(PlantingAdapter());
      }
    });

    setUp(() async {
      // Ouvrir une nouvelle box pour chaque test
      plantingBox = await Hive.openBox<Planting>('test_plantings_v2');
      await plantingBox.clear();
    });

    tearDown(() async {
      // Fermer la box aprÃ¨s chaque test
      if (plantingBox.isOpen) {
        await plantingBox.close();
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
      test('Doit crÃ©er un Planting avec tous les champs requis', () {
        final planting = Planting(
          id: 'test-planting-1',
          plantId: 'plant-123',
          gardenBedId: 'bed-456',
          plantingDate: DateTime(2024, 3, 15),
          status: 'PlantÃ©',
        );

        expect(planting.id, equals('test-planting-1'));
        expect(planting.plantId, equals('plant-123'));
        expect(planting.gardenBedId, equals('bed-456'));
        expect(planting.plantingDate, equals(DateTime(2024, 3, 15)));
        expect(planting.status, equals('PlantÃ©'));
      });

      test('Factory create doit gÃ©nÃ©rer un ID unique automatiquement', () {
        final planting1 = Planting.create(
          plantId: 'plant-1',
          gardenBedId: 'bed-1',
          plantingDate: DateTime(2024, 4, 1),
          status: 'PlanifiÃ©',
        );

        final planting2 = Planting.create(
          plantId: 'plant-2',
          gardenBedId: 'bed-2',
          plantingDate: DateTime(2024, 4, 2),
          status: 'PlantÃ©',
        );

        // VÃ©rifier que les IDs sont gÃ©nÃ©rÃ©s et diffÃ©rents
        expect(planting1.id, isNotEmpty);
        expect(planting2.id, isNotEmpty);
        expect(planting1.id, isNot(equals(planting2.id)));

        // VÃ©rifier les autres propriÃ©tÃ©s
        expect(planting1.plantId, equals('plant-1'));
        expect(planting1.gardenBedId, equals('bed-1'));
        expect(planting1.plantingDate, equals(DateTime(2024, 4, 1)));
        expect(planting1.status, equals('PlanifiÃ©'));

        expect(planting2.plantId, equals('plant-2'));
        expect(planting2.gardenBedId, equals('bed-2'));
        expect(planting2.plantingDate, equals(DateTime(2024, 4, 2)));
        expect(planting2.status, equals('PlantÃ©'));
      });

      test('Doit accepter tous les statuts disponibles', () {
        for (final status in Planting.availableStatuses) {
          final planting = Planting.create(
            plantId: 'plant-test',
            gardenBedId: 'bed-test',
            plantingDate: DateTime.now(),
            status: status,
          );

          expect(planting.status, equals(status));
          expect(Planting.availableStatuses, contains(status));
        }
      });
    });

    group('Tests de sÃ©rialisation/dÃ©sÃ©rialisation JSON', () {
      test('Doit sÃ©rialiser correctement avec toJson', () {
        final planting = Planting(
          id: 'test-planting-json-1',
          plantId: 'plant-json-1',
          gardenBedId: 'bed-json-1',
          plantingDate: DateTime(2024, 5, 10, 14, 30),
          status: 'En croissance',
        );

        final json = planting.toJson();

        expect(json['id'], equals('test-planting-json-1'));
        expect(json['plantId'], equals('plant-json-1'));
        expect(json['gardenBedId'], equals('bed-json-1'));
        expect(json['plantingDate'], equals('2024-05-10T14:30:00.000'));
        expect(json['status'], equals('En croissance'));
        expect(json['status'], isA<String>());
      });

      test('Doit dÃ©sÃ©rialiser correctement avec fromJson', () {
        final json = {
          'id': 'test-planting-json-2',
          'plantId': 'plant-json-2',
          'gardenBedId': 'bed-json-2',
          'plantingDate': '2024-06-15T10:00:00.000',
          'status': 'PrÃªt Ã  rÃ©colter',
        };

        final planting = Planting.fromJson(json);

        expect(planting.id, equals('test-planting-json-2'));
        expect(planting.plantId, equals('plant-json-2'));
        expect(planting.gardenBedId, equals('bed-json-2'));
        expect(planting.plantingDate, equals(DateTime(2024, 6, 15, 10, 0)));
        expect(planting.status, equals('PrÃªt Ã  rÃ©colter'));
      });

      test('Doit faire un round-trip JSON (toJson -> fromJson)', () {
        final original = Planting(
          id: 'test-roundtrip',
          plantId: 'plant-roundtrip',
          gardenBedId: 'bed-roundtrip',
          plantingDate: DateTime(2024, 7, 20, 15, 45),
          status: 'RÃ©coltÃ©',
        );

        final json = original.toJson();
        final restored = Planting.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.plantId, equals(original.plantId));
        expect(restored.gardenBedId, equals(original.gardenBedId));
        expect(restored.plantingDate, equals(original.plantingDate));
        expect(restored.status, equals(original.status));
      });
    });

    group('Tests de sÃ©rialisation/dÃ©sÃ©rialisation Hive', () {
      test('Doit sauvegarder et rÃ©cupÃ©rer un Planting dans Hive', () async {
        final originalPlanting = Planting(
          id: 'test-hive-1',
          plantId: 'plant-hive-1',
          gardenBedId: 'bed-hive-1',
          plantingDate: DateTime(2024, 8, 1),
          status: 'PlantÃ©',
        );

        // Sauvegarder dans Hive
        await plantingBox.put(originalPlanting.id, originalPlanting);

        // RÃ©cupÃ©rer depuis Hive
        final retrievedPlanting = plantingBox.get('test-hive-1');

        // VÃ©rifications
        expect(retrievedPlanting, isNotNull);
        expect(retrievedPlanting!.id, equals(originalPlanting.id));
        expect(retrievedPlanting.plantId, equals(originalPlanting.plantId));
        expect(retrievedPlanting.gardenBedId, equals(originalPlanting.gardenBedId));
        expect(retrievedPlanting.plantingDate, equals(originalPlanting.plantingDate));
        expect(retrievedPlanting.status, equals(originalPlanting.status));
      });

      test('Doit persister plusieurs Plantings et les rÃ©cupÃ©rer correctement', () async {
        final plantings = <Planting>[];

        // CrÃ©er plusieurs plantations
        for (int i = 0; i < 5; i++) {
          final planting = Planting(
            id: 'planting-hive-$i',
            plantId: 'plant-$i',
            gardenBedId: 'bed-$i',
            plantingDate: DateTime(2024, 1, 1 + i),
            status: Planting.availableStatuses[i % Planting.availableStatuses.length],
          );

          plantings.add(planting);
          await plantingBox.put(planting.id, planting);
        }

        // VÃ©rifier que toutes les plantations sont persistÃ©es
        expect(plantingBox.length, equals(5));

        // VÃ©rifier chaque plantation individuellement
        for (int i = 0; i < 5; i++) {
          final retrieved = plantingBox.get('planting-hive-$i');
          expect(retrieved, isNotNull);
          expect(retrieved!.plantId, equals('plant-$i'));
          expect(retrieved.gardenBedId, equals('bed-$i'));
          expect(retrieved.plantingDate, equals(DateTime(2024, 1, 1 + i)));
        }
      });
    });

    group('Tests de la mÃ©thode copyWith', () {
      test('Doit crÃ©er une copie avec des modifications', () {
        final original = Planting(
          id: 'test-copy-1',
          plantId: 'plant-original',
          gardenBedId: 'bed-original',
          plantingDate: DateTime(2024, 9, 1),
          status: 'PlanifiÃ©',
        );

        final modified = original.copyWith(
          status: 'PlantÃ©',
          plantingDate: DateTime(2024, 9, 5),
        );

        // VÃ©rifier que les champs modifiÃ©s ont changÃ©
        expect(modified.status, equals('PlantÃ©'));
        expect(modified.plantingDate, equals(DateTime(2024, 9, 5)));

        // VÃ©rifier que les autres champs sont inchangÃ©s
        expect(modified.id, equals(original.id));
        expect(modified.plantId, equals(original.plantId));
        expect(modified.gardenBedId, equals(original.gardenBedId));
      });

      test('Doit crÃ©er une copie sans modifications si aucun paramÃ¨tre fourni', () {
        final original = Planting(
          id: 'test-copy-2',
          plantId: 'plant-test',
          gardenBedId: 'bed-test',
          plantingDate: DateTime(2024, 10, 1),
          status: 'En croissance',
        );

        final copy = original.copyWith();

        expect(copy.id, equals(original.id));
        expect(copy.plantId, equals(original.plantId));
        expect(copy.gardenBedId, equals(original.gardenBedId));
        expect(copy.plantingDate, equals(original.plantingDate));
        expect(copy.status, equals(original.status));
      });

      test('Doit permettre de modifier uniquement certains champs', () {
        final original = Planting(
          id: 'test-copy-3',
          plantId: 'plant-a',
          gardenBedId: 'bed-a',
          plantingDate: DateTime(2024, 11, 1),
          status: 'PlanifiÃ©',
        );

        final modified = original.copyWith(
          status: 'PlantÃ©',
        );

        expect(modified.status, equals('PlantÃ©'));
        expect(modified.plantId, equals('plant-a')); // InchangÃ©
        expect(modified.gardenBedId, equals('bed-a')); // InchangÃ©
        expect(modified.plantingDate, equals(DateTime(2024, 11, 1))); // InchangÃ©
      });
    });

    group('Tests des mÃ©thodes utilitaires', () {
      test('Doit implÃ©menter toString correctement', () {
        final planting = Planting(
          id: 'test-toString',
          plantId: 'plant-tomato',
          gardenBedId: 'bed-north',
          plantingDate: DateTime(2024, 12, 1),
          status: 'En croissance',
        );

        final string = planting.toString();
        expect(string, contains('Planting'));
        expect(string, contains('test-toString'));
        expect(string, contains('plant-tomato'));
        expect(string, contains('bed-north'));
        expect(string, contains('En croissance'));
      });

      test('Doit implÃ©menter l\'Ã©galitÃ© basÃ©e sur l\'ID', () {
        final planting1 = Planting(
          id: 'same-id',
          plantId: 'plant-1',
          gardenBedId: 'bed-1',
          plantingDate: DateTime(2024, 1, 1),
          status: 'PlanifiÃ©',
        );

        final planting2 = Planting(
          id: 'same-id',
          plantId: 'plant-2', // Plant diffÃ©rent
          gardenBedId: 'bed-2', // Bed diffÃ©rent
          plantingDate: DateTime(2024, 2, 1), // Date diffÃ©rente
          status: 'PlantÃ©', // Status diffÃ©rent
        );

        final planting3 = Planting(
          id: 'different-id',
          plantId: 'plant-1', // MÃªme plant
          gardenBedId: 'bed-1', // MÃªme bed
          plantingDate: DateTime(2024, 1, 1), // MÃªme date
          status: 'PlanifiÃ©', // MÃªme status
        );

        expect(planting1, equals(planting2)); // MÃªme ID
        expect(planting1, isNot(equals(planting3))); // ID diffÃ©rent
        expect(planting1.hashCode, equals(planting2.hashCode));
        expect(planting1.hashCode, isNot(equals(planting3.hashCode)));
      });

      test('Doit gÃ©rer correctement les dates DateTime', () {
        final date1 = DateTime(2024, 1, 15, 10, 30, 45);
        final date2 = DateTime(2024, 1, 15, 10, 30, 45);

        final planting1 = Planting(
          id: 'test-date-1',
          plantId: 'plant-1',
          gardenBedId: 'bed-1',
          plantingDate: date1,
          status: 'PlantÃ©',
        );

        final planting2 = Planting(
          id: 'test-date-2',
          plantId: 'plant-2',
          gardenBedId: 'bed-2',
          plantingDate: date2,
          status: 'PlantÃ©',
        );

        expect(planting1.plantingDate, equals(planting2.plantingDate));
      });

      test('Doit avoir une liste de statuts disponibles', () {
        expect(Planting.availableStatuses, isNotEmpty);
        expect(Planting.availableStatuses.length, greaterThan(0));
        expect(Planting.availableStatuses, contains('PlanifiÃ©'));
        expect(Planting.availableStatuses, contains('PlantÃ©'));
        expect(Planting.availableStatuses, contains('En croissance'));
        expect(Planting.availableStatuses, contains('PrÃªt Ã  rÃ©colter'));
        expect(Planting.availableStatuses, contains('RÃ©coltÃ©'));
        expect(Planting.availableStatuses, contains('Ã‰chouÃ©'));
      });
    });
  });
}


