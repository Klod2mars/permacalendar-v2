
import '../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/adapters/garden_migration_adapters.dart';
import 'package:permacalendar/core/models/garden.dart' as legacy;
import 'package:permacalendar/core/models/garden_v2.dart' as v2;
import 'package:permacalendar/core/models/garden_hive.dart';
import 'package:permacalendar/core/models/garden_bed_hive.dart';
import 'package:permacalendar/core/models/garden_freezed.dart';

void main() {
  group('GardenMigrationAdapters - Legacy to Freezed', () {
    test('should convert legacy Garden to GardenFreezed preserving all fields', () {
      // Arrange
      final legacyGarden = legacy.Garden(
        id: 'test-garden-1',
        name: 'Mon Jardin Legacy',
        description: 'Un beau jardin traditionnel',
        totalAreaInSquareMeters: 150.5,
        location: 'Paris, France',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 10, 8),
        imageUrl: 'https://example.com/garden.jpg',
        metadata: {'type': 'permaculture', 'zone': '8a'},
        isActive: true,
      );

      // Act
      final gardenFreezed = GardenMigrationAdapters.fromLegacy(legacyGarden);

      // Assert
      expect(gardenFreezed.id, 'test-garden-1');
      expect(gardenFreezed.name, 'Mon Jardin Legacy');
      expect(gardenFreezed.description, 'Un beau jardin traditionnel');
      expect(gardenFreezed.totalAreaInSquareMeters, 150.5);
      expect(gardenFreezed.location, 'Paris, France');
      expect(gardenFreezed.createdAt, DateTime(2024, 1, 1));
      expect(gardenFreezed.updatedAt, DateTime(2024, 10, 8));
      expect(gardenFreezed.imageUrl, 'https://example.com/garden.jpg');
      expect(gardenFreezed.metadata['type'], 'permaculture');
      expect(gardenFreezed.metadata['zone'], '8a');
      expect(gardenFreezed.isActive, true);
    });

    test('should handle legacy Garden with minimal fields', () {
      // Arrange
      final legacyGarden = legacy.Garden(
        name: 'Jardin Simple',
        description: 'Description',
        totalAreaInSquareMeters: 50.0,
        location: 'Lyon',
      );

      // Act
      final gardenFreezed = GardenMigrationAdapters.fromLegacy(legacyGarden);

      // Assert
      expect(gardenFreezed.name, 'Jardin Simple');
      expect(gardenFreezed.id, isNotEmpty);
      expect(gardenFreezed.createdAt, isNotNull);
      expect(gardenFreezed.updatedAt, isNotNull);
      expect(gardenFreezed.metadata, isEmpty);
      expect(gardenFreezed.isActive, true);
    });

    test('should convert GardenFreezed back to legacy Garden', () {
      // Arrange
      final gardenFreezed = GardenFreezed(
        id: 'test-garden-2',
        name: 'Jardin Moderne',
        description: 'Un jardin avec Freezed',
        totalAreaInSquareMeters: 200.0,
        location: 'Marseille',
        createdAt: DateTime(2024, 5, 1),
        updatedAt: DateTime(2024, 10, 8),
        imageUrl: 'https://example.com/modern.jpg',
        metadata: {'modern': true},
        isActive: true,
      );

      // Act
      final legacyGarden = GardenMigrationAdapters.toLegacy(gardenFreezed);

      // Assert
      expect(legacyGarden.id, 'test-garden-2');
      expect(legacyGarden.name, 'Jardin Moderne');
      expect(legacyGarden.description, 'Un jardin avec Freezed');
      expect(legacyGarden.totalAreaInSquareMeters, 200.0);
      expect(legacyGarden.location, 'Marseille');
      expect(legacyGarden.isActive, true);
    });
  });

  group('GardenMigrationAdapters - V2 to Freezed', () {
    test('should convert Garden V2 to GardenFreezed', () {
      // Arrange
      final gardenV2 = v2.Garden(
        id: 'test-garden-v2',
        name: 'Jardin V2',
        description: 'Un jardin version 2',
        location: 'Toulouse',
        createdDate: DateTime(2024, 3, 15),
        gardenBeds: ['bed-1', 'bed-2', 'bed-3'],
      );

      // Act
      final gardenFreezed = GardenMigrationAdapters.fromV2(gardenV2);

      // Assert
      expect(gardenFreezed.id, 'test-garden-v2');
      expect(gardenFreezed.name, 'Jardin V2');
      expect(gardenFreezed.description, 'Un jardin version 2');
      expect(gardenFreezed.location, 'Toulouse');
      expect(gardenFreezed.createdAt, DateTime(2024, 3, 15));
      expect(gardenFreezed.updatedAt, DateTime(2024, 3, 15)); // Same as createdAt
      expect(gardenFreezed.totalAreaInSquareMeters, 0.0); // Will be recalculated
      expect(gardenFreezed.imageUrl, isNull);
      expect(gardenFreezed.metadata['gardenBedIds'], ['bed-1', 'bed-2', 'bed-3']);
      expect(gardenFreezed.metadata['migratedFrom'], 'GardenV2');
      expect(gardenFreezed.isActive, true);
    });

    test('should convert GardenFreezed back to Garden V2', () {
      // Arrange
      final gardenFreezed = GardenFreezed(
        id: 'test-garden-3',
        name: 'Jardin pour V2',
        description: 'Migration inverse',
        location: 'Bordeaux',
        createdAt: DateTime(2024, 6, 1),
        updatedAt: DateTime(2024, 10, 8),
        metadata: {'gardenBedIds': ['bed-a', 'bed-b']},
      );

      // Act
      final gardenV2 = GardenMigrationAdapters.toV2(gardenFreezed);

      // Assert
      expect(gardenV2.id, 'test-garden-3');
      expect(gardenV2.name, 'Jardin pour V2');
      expect(gardenV2.description, 'Migration inverse');
      expect(gardenV2.location, 'Bordeaux');
      expect(gardenV2.createdDate, DateTime(2024, 6, 1));
      expect(gardenV2.gardenBeds, ['bed-a', 'bed-b']);
    });

    test('should handle V2 Garden without gardenBeds metadata', () {
      // Arrange
      final gardenFreezed = GardenFreezed(
        id: 'test-garden-4',
        name: 'Jardin sans metadata',
        createdAt: DateTime(2024, 7, 1),
        updatedAt: DateTime(2024, 10, 8),
      );

      // Act
      final gardenV2 = GardenMigrationAdapters.toV2(gardenFreezed);

      // Assert
      expect(gardenV2.gardenBeds, isEmpty);
    });
  });

  group('GardenMigrationAdapters - Hive to Freezed', () {
    test('should convert GardenHive to GardenFreezed', () {
      // Arrange
      final gardenHive = GardenHive(
        id: 'test-garden-hive',
        name: 'Jardin Hive',
        description: 'Un jardin avec Hive',
        createdDate: DateTime(2024, 4, 20),
        gardenBeds: [
          GardenBedHive(
            id: 'bed-1',
            name: 'Parcelle 1',
            sizeInSquareMeters: 50.0,
            gardenId: 'test-garden-hive',
            plantingIds: ['plant-1', 'plant-2'],
          ),
          GardenBedHive(
            id: 'bed-2',
            name: 'Parcelle 2',
            sizeInSquareMeters: 75.5,
            gardenId: 'test-garden-hive',
            plantingIds: ['plant-3'],
          ),
        ],
      );

      // Act
      final gardenFreezed = GardenMigrationAdapters.fromHive(gardenHive);

      // Assert
      expect(gardenFreezed.id, 'test-garden-hive');
      expect(gardenFreezed.name, 'Jardin Hive');
      expect(gardenFreezed.description, 'Un jardin avec Hive');
      expect(gardenFreezed.createdAt, DateTime(2024, 4, 20));
      expect(gardenFreezed.totalAreaInSquareMeters, 125.5); // 50.0 + 75.5
      expect(gardenFreezed.location, ''); // Not available in Hive
      expect(gardenFreezed.metadata['gardenBedIds'], ['bed-1', 'bed-2']);
      expect(gardenFreezed.metadata['totalPlantings'], 3);
      expect(gardenFreezed.metadata['migratedFrom'], 'GardenHive');
      expect(gardenFreezed.isActive, true);
    });

    test('should handle GardenHive with empty gardenBeds', () {
      // Arrange
      final gardenHive = GardenHive(
        id: 'test-garden-empty',
        name: 'Jardin Vide',
        description: 'Pas de parcelles',
        createdDate: DateTime(2024, 8, 1),
        gardenBeds: [],
      );

      // Act
      final gardenFreezed = GardenMigrationAdapters.fromHive(gardenHive);

      // Assert
      expect(gardenFreezed.totalAreaInSquareMeters, 0.0);
      expect(gardenFreezed.metadata['gardenBedIds'], isEmpty);
      expect(gardenFreezed.metadata['totalPlantings'], 0);
    });

    test('should convert GardenFreezed back to GardenHive', () {
      // Arrange
      final gardenFreezed = GardenFreezed(
        id: 'test-garden-5',
        name: 'Jardin pour Hive',
        description: 'Migration vers Hive',
        createdAt: DateTime(2024, 9, 1),
        updatedAt: DateTime(2024, 10, 8),
      );

      final gardenBeds = [
        GardenBedHive(
          id: 'bed-x',
          name: 'Parcelle X',
          sizeInSquareMeters: 30.0,
          gardenId: 'test-garden-5',
          plantingIds: [],
        ),
      ];

      // Act
      final gardenHive = GardenMigrationAdapters.toHive(gardenFreezed, gardenBeds: gardenBeds);

      // Assert
      expect(gardenHive.id, 'test-garden-5');
      expect(gardenHive.name, 'Jardin pour Hive');
      expect(gardenHive.description, 'Migration vers Hive');
      expect(gardenHive.createdDate, DateTime(2024, 9, 1));
      expect(gardenHive.gardenBeds.length, 1);
      expect(gardenHive.gardenBeds.first.id, 'bed-x');
    });
  });

  group('GardenMigrationAdapters - Batch Migrations', () {
    test('should batch migrate legacy gardens', () {
      // Arrange
      final legacyGardens = [
        legacy.Garden(
          name: 'Jardin 1',
          description: 'Premier jardin',
          totalAreaInSquareMeters: 100.0,
          location: 'Paris',
        ),
        legacy.Garden(
          name: 'Jardin 2',
          description: 'DeuxiÃ¨me jardin',
          totalAreaInSquareMeters: 200.0,
          location: 'Lyon',
        ),
      ];

      // Act
      final gardensFreezedu = GardenMigrationAdapters.batchMigrateLegacy(legacyGardens);

      // Assert
      expect(gardensFreezedu, hasLength(2));
      expect(gardensFreezedu[0].name, 'Jardin 1');
      expect(gardensFreezedu[1].name, 'Jardin 2');
    });

    test('should batch migrate V2 gardens', () {
      // Arrange
      final gardensV2 = [
        v2.Garden.create(name: 'Jardin A', description: 'A', location: 'Nice'),
        v2.Garden.create(name: 'Jardin B', description: 'B', location: 'Lille'),
      ];

      // Act
      final gardensFreezed = GardenMigrationAdapters.batchMigrateV2(gardensV2);

      // Assert
      expect(gardensFreezed, hasLength(2));
      expect(gardensFreezed[0].name, 'Jardin A');
      expect(gardensFreezed[1].name, 'Jardin B');
    });

    test('should batch migrate Hive gardens', () {
      // Arrange
      final gardensHive = [
        GardenHive.create(name: 'Jardin X', description: 'X'),
        GardenHive.create(name: 'Jardin Y', description: 'Y'),
      ];

      // Act
      final gardensFreezed = GardenMigrationAdapters.batchMigrateHive(gardensHive);

      // Assert
      expect(gardensFreezed, hasLength(2));
      expect(gardensFreezed[0].name, 'Jardin X');
      expect(gardensFreezed[1].name, 'Jardin Y');
    });
  });

  group('GardenMigrationAdapters - Model Type Detection', () {
    test('should detect legacy Garden model', () {
      // Arrange
      final json = {
        'id': 'test-1',
        'name': 'Jardin',
        'totalAreaInSquareMeters': 100.0,
        'updatedAt': '2024-10-08T12:00:00Z',
      };

      // Act
      final type = GardenMigrationAdapters.detectGardenModelType(json);

      // Assert
      expect(type, 'legacy');
    });

    test('should detect V2 Garden model', () {
      // Arrange
      final json = {
        'id': 'test-2',
        'name': 'Jardin',
        'createdDate': '2024-10-08T12:00:00Z',
        'gardenBeds': ['bed-1', 'bed-2'],
      };

      // Act
      final type = GardenMigrationAdapters.detectGardenModelType(json);

      // Assert
      expect(type, 'v2');
    });

    test('should detect Hive Garden model', () {
      // Arrange
      final json = {
        'id': 'test-3',
        'name': 'Jardin',
        'createdDate': '2024-10-08T12:00:00Z',
        'gardenBeds': [
          {'id': 'bed-1', 'name': 'Parcelle 1'},
        ],
      };

      // Act
      final type = GardenMigrationAdapters.detectGardenModelType(json);

      // Assert
      expect(type, 'hive');
    });

    test('should detect Freezed Garden model', () {
      // Arrange
      final json = {
        'id': 'test-4',
        'name': 'Jardin',
        'totalAreaInSquareMeters': 100.0,
        'location': 'Paris',
        'createdAt': '2024-10-08T12:00:00Z',
        'updatedAt': '2024-10-08T12:00:00Z',
        'metadata': {},
        'isActive': true,
      };

      // Act
      final type = GardenMigrationAdapters.detectGardenModelType(json);

      // Assert
      expect(type, 'freezed');
    });

    test('should detect unknown model', () {
      // Arrange
      final json = {
        'id': 'test-5',
        'name': 'Jardin',
      };

      // Act
      final type = GardenMigrationAdapters.detectGardenModelType(json);

      // Assert
      expect(type, 'unknown');
    });
  });

  group('GardenMigrationAdapters - Auto Migration', () {
    test('should auto migrate legacy Garden', () {
      // Arrange
      final json = <String, dynamic>{
        'id': 'test-auto-1',
        'name': 'Jardin Auto',
        'description': 'Test',
        'totalAreaInSquareMeters': 150.0,
        'location': 'Nantes',
        'createdAt': '2024-10-08T10:00:00Z',
        'updatedAt': '2024-10-08T12:00:00Z',
        'metadata': <String, dynamic>{},
        'isActive': true,
      };

      // Act
      final gardenFreezed = GardenMigrationAdapters.autoMigrate(json);

      // Assert
      expect(gardenFreezed.name, 'Jardin Auto');
      expect(gardenFreezed.totalAreaInSquareMeters, 150.0);
    });

    test('should auto migrate V2 Garden', () {
      // Arrange
      final json = {
        'id': 'test-auto-2',
        'name': 'Jardin V2 Auto',
        'description': 'Test V2',
        'location': 'Strasbourg',
        'createdDate': '2024-10-08T10:00:00Z',
        'gardenBeds': ['bed-1', 'bed-2'],
      };

      // Act
      final gardenFreezed = GardenMigrationAdapters.autoMigrate(json);

      // Assert
      expect(gardenFreezed.name, 'Jardin V2 Auto');
      expect(gardenFreezed.location, 'Strasbourg');
      expect(gardenFreezed.metadata['gardenBedIds'], ['bed-1', 'bed-2']);
    });

    test('should throw exception for unknown model', () {
      // Arrange
      final json = {
        'id': 'test-auto-3',
        'someField': 'value',
      };

      // Act & Assert
      expect(
        () => GardenMigrationAdapters.autoMigrate(json),
        throwsException,
      );
    });
  });

  group('GardenMigrationAdapters - Migration Stats', () {
    test('should provide stats for V2 to Freezed migration', () {
      // Act
      final stats = GardenMigrationAdapters.getMigrationStats('v2', 'freezed');

      // Assert
      expect(stats['dataLoss'], 'moderate');
      expect(stats['fieldsLost'], isNotEmpty);
      expect(stats['fieldsGained'], isNotEmpty);
      expect(stats['recommendation'], contains('Recalculer'));
    });

    test('should provide stats for Legacy to Freezed migration', () {
      // Act
      final stats = GardenMigrationAdapters.getMigrationStats('legacy', 'freezed');

      // Assert
      expect(stats['dataLoss'], 'none');
      expect(stats['fieldsLost'], isEmpty);
      expect(stats['recommendation'], contains('sans perte'));
    });

    test('should provide stats for Hive to Freezed migration', () {
      // Act
      final stats = GardenMigrationAdapters.getMigrationStats('hive', 'freezed');

      // Assert
      expect(stats['dataLoss'], 'low');
      expect(stats['fieldsGained'], contains('location'));
    });
  });

  group('GardenMigrationAdapters - Data Integrity', () {
    test('should preserve all data in round-trip legacy -> freezed -> legacy', () {
      // Arrange
      final original = legacy.Garden(
        id: 'round-trip-1',
        name: 'Test Round Trip',
        description: 'Testing data preservation',
        totalAreaInSquareMeters: 175.25,
        location: 'Montpellier',
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 10, 8),
        imageUrl: 'https://example.com/image.jpg',
        metadata: {'key1': 'value1', 'key2': 42},
        isActive: true,
      );

      // Act
      final freezed = GardenMigrationAdapters.fromLegacy(original);
      final roundTrip = GardenMigrationAdapters.toLegacy(freezed);

      // Assert
      expect(roundTrip.id, original.id);
      expect(roundTrip.name, original.name);
      expect(roundTrip.description, original.description);
      expect(roundTrip.totalAreaInSquareMeters, original.totalAreaInSquareMeters);
      expect(roundTrip.location, original.location);
      expect(roundTrip.createdAt, original.createdAt);
      expect(roundTrip.updatedAt, original.updatedAt);
      expect(roundTrip.imageUrl, original.imageUrl);
      expect(roundTrip.metadata['key1'], original.metadata['key1']);
      expect(roundTrip.isActive, original.isActive);
    });

    test('should calculate correct total area from GardenHive beds', () {
      // Arrange
      final gardenHive = GardenHive(
        id: 'area-test',
        name: 'Test Area Calculation',
        description: 'Testing',
        createdDate: DateTime(2024, 10, 8),
        gardenBeds: [
          GardenBedHive(
            id: 'bed-1',
            name: 'Bed 1',
            sizeInSquareMeters: 33.33,
            gardenId: 'area-test',
            plantingIds: [],
          ),
          GardenBedHive(
            id: 'bed-2',
            name: 'Bed 2',
            sizeInSquareMeters: 66.67,
            gardenId: 'area-test',
            plantingIds: [],
          ),
        ],
      );

      // Act
      final gardenFreezed = GardenMigrationAdapters.fromHive(gardenHive);

      // Assert
      expect(gardenFreezed.totalAreaInSquareMeters, 100.0);
    });
  });
}

