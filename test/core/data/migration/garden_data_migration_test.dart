import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:permacalendar/core/data/migration/garden_data_migration.dart';
import 'package:permacalendar/core/models/garden.dart' as legacy;
import 'package:permacalendar/core/models/garden_v2.dart' as v2;
import 'package:permacalendar/core/models/garden_hive.dart';
import 'package:permacalendar/core/models/garden_bed_hive.dart';
import 'package:permacalendar/core/models/garden_freezed.dart';

void main() {
  group('GardenDataMigration', () {
    setUp(() async {
      await setUpTestHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('should create GardenMigrationResult with correct initial values', () {
      // Arrange
      final startTime = DateTime.now();

      // Act
      final result = GardenMigrationResult(
        startedAt: startTime,
        dryRun: false,
      );

      // Assert
      expect(result.startedAt, startTime);
      expect(result.dryRun, false);
      expect(result.success, false);
      expect(result.migratedCount, 0);
      expect(result.legacyCount, 0);
      expect(result.v2Count, 0);
      expect(result.hiveCount, 0);
      expect(result.migratedGardens, isEmpty);
      expect(result.errors, isEmpty);
      expect(result.backupCreated, false);
      expect(result.integrityVerified, false);
      expect(result.oldBoxesCleanedUp, false);
    });

    test('should calculate migratedCount correctly', () {
      // Arrange
      final result = GardenMigrationResult(
        startedAt: DateTime.now(),
        dryRun: false,
      );

      // Act
      result.legacyCount = 3;
      result.v2Count = 5;
      result.hiveCount = 2;

      // Assert
      expect(result.migratedCount, 10);
    });

    test('should serialize GardenMigrationResult to JSON', () {
      // Arrange
      final result = GardenMigrationResult(
        startedAt: DateTime(2024, 10, 8, 10, 0),
        dryRun: true,
      );
      result.success = true;
      result.legacyCount = 2;
      result.v2Count = 3;
      result.hiveCount = 1;
      result.endedAt = DateTime(2024, 10, 8, 10, 1);
      result.duration = const Duration(seconds: 60);
      result.backupCreated = true;
      result.integrityVerified = true;

      // Act
      final json = result.toJson();

      // Assert
      expect(json['success'], true);
      expect(json['dryRun'], true);
      expect(json['legacyCount'], 2);
      expect(json['v2Count'], 3);
      expect(json['hiveCount'], 1);
      expect(json['migratedCount'], 6);
      expect(json['durationSeconds'], 60);
      expect(json['backupCreated'], true);
      expect(json['integrityVerified'], true);
    });

    test('should run dry-run migration without writing data', () async {
      // Arrange
      final migration = GardenDataMigration();

      // Créer une box legacy avec des données
      final legacyBox = await Hive.openBox<legacy.Garden>('gardens');
      final legacyGarden = legacy.Garden(
        id: 'test-garden-1',
        name: 'Test Garden',
        description: 'Test',
        totalAreaInSquareMeters: 100.0,
        location: 'Test Location',
      );
      await legacyBox.put(legacyGarden.id, legacyGarden);

      // Act
      final result = await migration.migrateAllGardens(
        dryRun: true,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );

      // Assert
      expect(result.dryRun, true);
      expect(result.legacyCount, 1);
      expect(result.migratedGardens, hasLength(1));
      expect(result.migratedGardens.first.name, 'Test Garden');

      // Vérifier que la box cible n'a pas été créée
      expect(Hive.isBoxOpen('gardens_freezed'), false);
    });

    test('should migrate legacy gardens successfully', () async {
      // Arrange
      Hive.registerAdapter(GardenFreezedAdapter());

      final migration = GardenDataMigration();

      // Créer une box legacy avec des données
      final legacyBox = await Hive.openBox<legacy.Garden>('gardens');
      await legacyBox.put(
        'garden-1',
        legacy.Garden(
          id: 'garden-1',
          name: 'Jardin Legacy 1',
          description: 'Premier jardin',
          totalAreaInSquareMeters: 150.0,
          location: 'Paris',
        ),
      );
      await legacyBox.put(
        'garden-2',
        legacy.Garden(
          id: 'garden-2',
          name: 'Jardin Legacy 2',
          description: 'Deuxième jardin',
          totalAreaInSquareMeters: 200.0,
          location: 'Lyon',
        ),
      );

      // Act
      final result = await migration.migrateAllGardens(
        dryRun: false,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );

      // Assert
      expect(result.success, true);
      expect(result.legacyCount, 2);
      expect(result.migratedCount, 2);
      expect(result.integrityVerified, true);

      // Vérifier que les données sont dans la box cible
      final targetBox = Hive.box<GardenFreezed>('gardens_freezed');
      expect(targetBox.length, 2);
      expect(targetBox.get('garden-1')?.name, 'Jardin Legacy 1');
      expect(targetBox.get('garden-2')?.name, 'Jardin Legacy 2');
    });

    test('should migrate V2 gardens successfully', () async {
      // Arrange
      Hive.registerAdapter(GardenFreezedAdapter());

      final migration = GardenDataMigration();

      // Créer une box v2 avec des données
      final v2Box = await Hive.openBox<v2.Garden>('gardens_v2');
      await v2Box.put(
        'garden-v2-1',
        v2.Garden(
          id: 'garden-v2-1',
          name: 'Jardin V2',
          description: 'Test V2',
          location: 'Toulouse',
          createdDate: DateTime(2024, 5, 1),
          gardenBeds: ['bed-1', 'bed-2'],
        ),
      );

      // Act
      final result = await migration.migrateAllGardens(
        dryRun: false,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );

      // Assert
      expect(result.success, true);
      expect(result.v2Count, 1);
      expect(result.migratedCount, 1);
      expect(result.integrityVerified, true);

      // Vérifier les données
      final targetBox = Hive.box<GardenFreezed>('gardens_freezed');
      final migrated = targetBox.get('garden-v2-1');
      expect(migrated?.name, 'Jardin V2');
      expect(migrated?.location, 'Toulouse');
      expect(migrated?.metadata['gardenBedIds'], ['bed-1', 'bed-2']);
      expect(migrated?.metadata['migratedFrom'], 'GardenV2');
    });

    test('should migrate Hive gardens successfully', () async {
      // Arrange
      Hive.registerAdapter(GardenFreezedAdapter());
      Hive.registerAdapter(GardenBedHiveAdapter());

      final migration = GardenDataMigration();

      // Créer une box hive avec des données
      final hiveBox = await Hive.openBox<GardenHive>('gardens_hive');
      await hiveBox.put(
        'garden-hive-1',
        GardenHive(
          id: 'garden-hive-1',
          name: 'Jardin Hive',
          description: 'Test Hive',
          createdDate: DateTime(2024, 6, 1),
          gardenBeds: [
            GardenBedHive(
              id: 'bed-1',
              name: 'Parcelle 1',
              sizeInSquareMeters: 50.0,
              gardenId: 'garden-hive-1',
              plantingIds: ['plant-1'],
            ),
            GardenBedHive(
              id: 'bed-2',
              name: 'Parcelle 2',
              sizeInSquareMeters: 75.0,
              gardenId: 'garden-hive-1',
              plantingIds: ['plant-2', 'plant-3'],
            ),
          ],
        ),
      );

      // Act
      final result = await migration.migrateAllGardens(
        dryRun: false,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );

      // Assert
      expect(result.success, true);
      expect(result.hiveCount, 1);
      expect(result.migratedCount, 1);
      expect(result.integrityVerified, true);

      // Vérifier les données
      final targetBox = Hive.box<GardenFreezed>('gardens_freezed');
      final migrated = targetBox.get('garden-hive-1');
      expect(migrated?.name, 'Jardin Hive');
      expect(migrated?.totalAreaInSquareMeters, 125.0); // 50 + 75
      expect(migrated?.metadata['gardenBedIds'], ['bed-1', 'bed-2']);
      expect(migrated?.metadata['totalPlantings'], 3);
      expect(migrated?.metadata['migratedFrom'], 'GardenHive');
    });

    test('should migrate from multiple sources simultaneously', () async {
      // Arrange
      Hive.registerAdapter(GardenFreezedAdapter());
      Hive.registerAdapter(GardenBedHiveAdapter());

      final migration = GardenDataMigration();

      // Créer des données dans les 3 sources
      final legacyBox = await Hive.openBox<legacy.Garden>('gardens');
      await legacyBox.put(
        'legacy-1',
        legacy.Garden(
          id: 'legacy-1',
          name: 'Legacy',
          description: 'Test',
          totalAreaInSquareMeters: 100.0,
          location: 'Paris',
        ),
      );

      final v2Box = await Hive.openBox<v2.Garden>('gardens_v2');
      await v2Box.put(
        'v2-1',
        v2.Garden(
          id: 'v2-1',
          name: 'V2',
          description: 'Test',
          location: 'Lyon',
          createdDate: DateTime(2024, 5, 1),
          gardenBeds: ['bed-1'],
        ),
      );

      final hiveBox = await Hive.openBox<GardenHive>('gardens_hive');
      await hiveBox.put(
        'hive-1',
        GardenHive.create(
          name: 'Hive',
          description: 'Test',
        ),
      );

      // Act
      final result = await migration.migrateAllGardens(
        dryRun: false,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );

      // Assert
      expect(result.success, true);
      expect(result.legacyCount, 1);
      expect(result.v2Count, 1);
      expect(result.hiveCount, 1);
      expect(result.migratedCount, 3);
      expect(result.integrityVerified, true);

      // Vérifier la box cible
      final targetBox = Hive.box<GardenFreezed>('gardens_freezed');
      expect(targetBox.length, 3);
      expect(targetBox.get('legacy-1')?.name, 'Legacy');
      expect(targetBox.get('v2-1')?.name, 'V2');
      expect(targetBox.get('hive-1')?.name, 'Hive');
    });

    test('should handle empty source boxes gracefully', () async {
      // Arrange
      Hive.registerAdapter(GardenFreezedAdapter());

      final migration = GardenDataMigration();

      // Créer des boxes vides
      await Hive.openBox<legacy.Garden>('gardens');
      await Hive.openBox<v2.Garden>('gardens_v2');
      await Hive.openBox<GardenHive>('gardens_hive');

      // Act
      final result = await migration.migrateAllGardens(
        dryRun: false,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );

      // Assert
      expect(result.success, true);
      expect(result.migratedCount, 0);
      expect(result.integrityVerified, true);
    });

    test('should handle non-existent source boxes gracefully', () async {
      // Arrange
      Hive.registerAdapter(GardenFreezedAdapter());

      final migration = GardenDataMigration();

      // Ne pas créer les boxes sources

      // Act
      final result = await migration.migrateAllGardens(
        dryRun: false,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );

      // Assert
      expect(result.success, true);
      expect(result.migratedCount, 0);
      expect(result.integrityVerified, true);
    });

    test('should print migration stats correctly', () async {
      // Arrange
      Hive.registerAdapter(GardenFreezedAdapter());

      final migration = GardenDataMigration();

      final legacyBox = await Hive.openBox<legacy.Garden>('gardens');
      await legacyBox.put(
        'test-1',
        legacy.Garden(
          id: 'test-1',
          name: 'Test',
          description: 'Test',
          totalAreaInSquareMeters: 100.0,
          location: 'Paris',
        ),
      );

      await migration.migrateAllGardens(
        dryRun: false,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );

      // Act & Assert (ne devrait pas crasher)
      expect(() => migration.printMigrationStats(), returnsNormally);

      // Vérifier que lastResult est disponible
      expect(migration.lastResult, isNotNull);
      expect(migration.lastResult?.success, true);
      expect(migration.lastResult?.migratedCount, 1);
    });

    test('should store lastResult after migration', () async {
      // Arrange
      Hive.registerAdapter(GardenFreezedAdapter());

      final migration = GardenDataMigration();

      // Act
      await migration.migrateAllGardens(
        dryRun: true,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );

      // Assert
      expect(migration.lastResult, isNotNull);
      expect(migration.lastResult?.dryRun, true);
    });

    test('should respect cleanupOldBoxes flag', () async {
      // Arrange
      Hive.registerAdapter(GardenFreezedAdapter());

      final migration = GardenDataMigration();

      final legacyBox = await Hive.openBox<legacy.Garden>('gardens');
      await legacyBox.put(
        'test-1',
        legacy.Garden(
          id: 'test-1',
          name: 'Test',
          description: 'Test',
          totalAreaInSquareMeters: 100.0,
          location: 'Paris',
        ),
      );

      // Act
      final result = await migration.migrateAllGardens(
        dryRun: false,
        backupBeforeMigration: false,
        cleanupOldBoxes: false, // Ne pas nettoyer
      );

      // Assert
      expect(result.oldBoxesCleanedUp, false);
      expect(Hive.isBoxOpen('gardens'), true); // Box toujours ouverte
    });

    test('should handle migration errors gracefully', () async {
      // Arrange
      final migration = GardenDataMigration();

      // Créer une box legacy avec des données invalides simulées
      // (Hive peut lancer des exceptions lors de l'ouverture de boxes corrompues)

      // Act
      final result = await migration.migrateAllGardens(
        dryRun: false,
        backupBeforeMigration: false,
        cleanupOldBoxes: false,
      );

      // Assert
      // La migration devrait réussir même avec des boxes manquantes
      expect(result.success, true);
    });
  });

  group('GardenMigrationResult', () {
    test('should initialize with correct defaults', () {
      // Arrange
      final startTime = DateTime.now();

      // Act
      final result = GardenMigrationResult(
        startedAt: startTime,
        dryRun: false,
      );

      // Assert
      expect(result.success, false);
      expect(result.startedAt, startTime);
      expect(result.dryRun, false);
      expect(result.migratedGardens, isEmpty);
      expect(result.errors, isEmpty);
    });

    test('should calculate correct migratedCount from all sources', () {
      // Arrange
      final result = GardenMigrationResult(
        startedAt: DateTime.now(),
        dryRun: false,
      );

      // Act
      result.legacyCount = 10;
      result.v2Count = 20;
      result.hiveCount = 15;

      // Assert
      expect(result.migratedCount, 45);
    });

    test('should include all fields in JSON serialization', () {
      // Arrange
      final result = GardenMigrationResult(
        startedAt: DateTime(2024, 10, 8, 10, 0),
        dryRun: true,
      );
      result.success = true;
      result.endedAt = DateTime(2024, 10, 8, 10, 5);
      result.duration = const Duration(minutes: 5);
      result.legacyCount = 5;
      result.v2Count = 10;
      result.hiveCount = 3;
      result.backupCreated = true;
      result.integrityVerified = true;
      result.oldBoxesCleanedUp = false;
      result.errors = ['Test error'];

      // Act
      final json = result.toJson();

      // Assert
      expect(json, containsPair('success', true));
      expect(json, containsPair('dryRun', true));
      expect(json, containsPair('legacyCount', 5));
      expect(json, containsPair('v2Count', 10));
      expect(json, containsPair('hiveCount', 3));
      expect(json, containsPair('migratedCount', 18));
      expect(json, containsPair('durationSeconds', 300));
      expect(json, containsPair('backupCreated', true));
      expect(json, containsPair('integrityVerified', true));
      expect(json, containsPair('oldBoxesCleanedUp', false));
      expect(json['errors'], ['Test error']);
    });
  });
}
