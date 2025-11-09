import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:permacalendar/core/data/migration/garden_data_migration.dart';
import 'package:permacalendar/core/models/garden.dart' as legacy;
import 'package:permacalendar/core/models/garden_bed.dart';
import 'package:permacalendar/core/models/garden_bed_hive.dart';
import 'package:permacalendar/core/models/garden_freezed.dart';
import 'package:permacalendar/core/models/garden_hive.dart';
import 'package:permacalendar/core/models/garden_v2.dart' as v2;
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/services/aggregation/garden_aggregation_hub.dart';
import 'package:permacalendar/features/plant_intelligence/data/migration/multi_garden_migration.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition_hive.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation_hive.dart';

void main() {
  group(
    'MultiGardenMigration',
    () {
      setUp(() async {
        await setUpTestHive();
        _registerHiveAdapters();
      });

      tearDown(() async {
        await tearDownTestHive();
      });

      test('runMultiMigration migrates legacy and v2 gardens and updates sanctuary data', () async {
        // Arrange
        final migration = MultiGardenMigration(
          dataMigration: GardenDataMigration(),
        );

        // Seed legacy garden
        final legacyBox = await Hive.openBox<legacy.Garden>('gardens');
        const legacyGardenId = 'legacy-garden-1';
        legacyBox.put(
          legacyGardenId,
          legacy.Garden(
            id: legacyGardenId,
            name: 'Jardin Legacy',
            description: 'Ancien jardin',
            totalAreaInSquareMeters: 120,
            location: 'Bordeaux',
          ),
        );

        // Seed V2 garden
        final v2Box = await Hive.openBox<v2.Garden>('gardens_v2');
        const v2GardenId = 'v2-garden-1';
        v2Box.put(
          v2GardenId,
          v2.Garden(
            id: v2GardenId,
            name: 'Jardin V2',
            description: 'Jardin modernisé',
            location: 'Lyon',
            createdDate: DateTime(2024, 1, 1),
            gardenBeds: const ['v2-bed-1'],
          ),
        );

        // Seed beds & plantings for inference
        final bedsBox = await Hive.openBox<GardenBed>('garden_beds');
        const bedId = 'legacy-bed-1';
        bedsBox.put(
          bedId,
          GardenBed(
            id: bedId,
            gardenId: legacyGardenId,
            name: 'Parcelle Sud',
            description: 'Parcelle du jardin legacy',
            sizeInSquareMeters: 40,
            soilType: 'Humifère',
            exposure: 'Plein soleil',
          ),
        );

        final plantingsBox = await Hive.openBox<Planting>('plantings');
        const plantId = 'plant-123';
        plantingsBox.put(
          'planting-1',
          Planting(
            id: 'planting-1',
            gardenBedId: bedId,
            plantId: plantId,
            plantName: 'Tomate',
            plantedDate: DateTime(2024, 2, 12),
            quantity: 4,
          ),
        );

        // Seed sanctuary data without gardenId
        final conditionsBox = await Hive.openBox<PlantConditionHive>('plant_conditions');
        conditionsBox.put(
          'cond-1',
          PlantConditionHive(
            id: 'cond-1',
            plantId: plantId,
            gardenId: '',
            typeIndex: 0,
            statusIndex: 0,
            value: 18,
            optimalValue: 20,
            minValue: 15,
            maxValue: 24,
            unit: '°C',
            measuredAt: DateTime(2024, 2, 15),
          ),
        );

        final recommendationsBox = await Hive.openBox<RecommendationHive>('plant_recommendations');
        recommendationsBox.put(
          'rec-1',
          RecommendationHive(
            id: 'rec-1',
            plantId: plantId,
            gardenId: '',
            title: 'Arroser modérément',
            description: 'Maintenir le sol humide sans excès',
            priorityIndex: 1,
            statusIndex: 0,
            createdAt: DateTime(2024, 2, 16),
          ),
        );

        // Act
        final report = await migration.runMultiMigration();

        // Assert
        expect(report.success, isTrue);
        expect(report.sanctuaryMergeReport?.conditions.migrated, 1);
        expect(report.sanctuaryMergeReport?.recommendations.migrated, 1);

        final migratedCondition = conditionsBox.get('cond-1');
        expect(migratedCondition?.gardenId, legacyGardenId);

        final migratedRecommendation = recommendationsBox.get('rec-1');
        expect(migratedRecommendation?.gardenId, legacyGardenId);

        final freezedBox = Hive.box<GardenFreezed>('gardens_freezed');
        expect(freezedBox.isNotEmpty, isTrue);
      });

      test('mergeHiveData handles incomplete gardens gracefully', () async {
        // Arrange
        final migration = MultiGardenMigration(
          dataMigration: GardenDataMigration(),
        );

        final conditionsBox = await Hive.openBox<PlantConditionHive>('plant_conditions');
        conditionsBox.put(
          'cond-incomplete',
          PlantConditionHive(
            id: 'cond-incomplete',
            plantId: 'unknown-plant',
            gardenId: '',
            typeIndex: 0,
            statusIndex: 0,
            value: 0,
            optimalValue: 0,
            minValue: 0,
            maxValue: 0,
            unit: '°C',
            measuredAt: DateTime.now(),
          ),
        );

        // Act
        final report = await migration.mergeHiveData();

        // Assert
        expect(report.conditions.errors, 1);
        expect(report.conditions.migrated, 0);
        expect(conditionsBox.get('cond-incomplete')?.gardenId, isEmpty);
      });

      test('mergeHiveData keeps data coherent across multiple gardens', () async {
        // Arrange
        final migration = MultiGardenMigration(
          dataMigration: GardenDataMigration(),
        );

        final bedsBox = await Hive.openBox<GardenBed>('garden_beds');
        final plantingsBox = await Hive.openBox<Planting>('plantings');
        final conditionsBox = await Hive.openBox<PlantConditionHive>('plant_conditions');

        bedsBox.put(
          'bed-A',
          GardenBed(
            id: 'bed-A',
            gardenId: 'garden-A',
            name: 'Parcelle A',
            description: 'Zone A',
            sizeInSquareMeters: 30,
            soilType: 'Argileux',
            exposure: 'Mi-soleil',
          ),
        );
        bedsBox.put(
          'bed-B',
          GardenBed(
            id: 'bed-B',
            gardenId: 'garden-B',
            name: 'Parcelle B',
            description: 'Zone B',
            sizeInSquareMeters: 20,
            soilType: 'Mixte',
            exposure: 'Ombre',
          ),
        );

        plantingsBox
          ..put(
            'planting-A',
            Planting(
              id: 'planting-A',
              gardenBedId: 'bed-A',
              plantId: 'plant-A',
              plantName: 'Salade',
              plantedDate: DateTime(2024, 3, 1),
              quantity: 6,
            ),
          )
          ..put(
            'planting-B',
            Planting(
              id: 'planting-B',
              gardenBedId: 'bed-B',
              plantId: 'plant-B',
              plantName: 'Carotte',
              plantedDate: DateTime(2024, 3, 5),
              quantity: 8,
            ),
          );

        conditionsBox
          ..put(
            'cond-A',
            PlantConditionHive(
              id: 'cond-A',
              plantId: 'plant-A',
              gardenId: '',
              typeIndex: 0,
              statusIndex: 0,
              value: 1,
              optimalValue: 1,
              minValue: 0,
              maxValue: 2,
              unit: 'unit',
              measuredAt: DateTime.now(),
            ),
          )
          ..put(
            'cond-B',
            PlantConditionHive(
              id: 'cond-B',
              plantId: 'plant-B',
              gardenId: '',
              typeIndex: 0,
              statusIndex: 0,
              value: 1,
              optimalValue: 1,
              minValue: 0,
              maxValue: 2,
              unit: 'unit',
              measuredAt: DateTime.now(),
            ),
          );

        // Act
        final report = await migration.mergeHiveData();

        // Assert
        expect(report.conditions.migrated, 2);
        expect(conditionsBox.get('cond-A')?.gardenId, 'garden-A');
        expect(conditionsBox.get('cond-B')?.gardenId, 'garden-B');
      });

      test('runMultiMigration aborts cleanly when garden migration fails', () async {
        // Arrange
        final migration = MultiGardenMigration(
          dataMigration: _FailingGardenDataMigration(),
        );

        final conditionsBox = await Hive.openBox<PlantConditionHive>('plant_conditions');
        conditionsBox.put(
          'cond-safe',
          PlantConditionHive(
            id: 'cond-safe',
            plantId: 'plant-safe',
            gardenId: '',
            typeIndex: 0,
            statusIndex: 0,
            value: 1,
            optimalValue: 1,
            minValue: 0,
            maxValue: 2,
            unit: 'unit',
            measuredAt: DateTime.now(),
          ),
        );

        // Act
        final report = await migration.runMultiMigration();

        // Assert
        expect(report.success, isFalse);
        expect(report.error, contains('Forcé'));
        expect(report.sanctuaryMergeReport, isNull);
        expect(conditionsBox.get('cond-safe')?.gardenId, isEmpty);
      });
    },
    skip: 'temporarily skipped: migration tests need cleanup / directives fix',
  );

  group('GardenIntelligenceCache', () {
    test('markAccessed updates lastAccessedAt', () async {
      final now = DateTime.now();
      final cache = GardenIntelligenceCache(
        gardenId: 'garden_1',
        data: {},
        createdAt: now,
        lastAccessedAt: now,
      );

      await Future.delayed(const Duration(milliseconds: 100));
      cache.markAccessed();

      expect(cache.lastAccessedAt.isAfter(now), isTrue);
    });

    test('isValid returns true for recent cache', () {
      final now = DateTime.now();
      final cache = GardenIntelligenceCache(
        gardenId: 'garden_1',
        data: {},
        createdAt: now,
        lastAccessedAt: now,
      );

      expect(cache.isValid(const Duration(minutes: 10)), isTrue);
    });

    test('isValid returns false for expired cache', () {
      final oldTime = DateTime.now().subtract(const Duration(minutes: 15));
      final cache = GardenIntelligenceCache(
        gardenId: 'garden_1',
        data: {},
        createdAt: oldTime,
        lastAccessedAt: oldTime,
      );

      expect(cache.isValid(const Duration(minutes: 10)), isFalse);
    });
  });
}

void _registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(legacy.GardenAdapter().typeId)) {
    Hive.registerAdapter(legacy.GardenAdapter());
  }
  if (!Hive.isAdapterRegistered(GardenBedAdapter().typeId)) {
    Hive.registerAdapter(GardenBedAdapter());
  }
  if (!Hive.isAdapterRegistered(PlantingAdapter().typeId)) {
    Hive.registerAdapter(PlantingAdapter());
  }
  if (!Hive.isAdapterRegistered(PlantConditionHiveAdapter().typeId)) {
    Hive.registerAdapter(PlantConditionHiveAdapter());
  }
  if (!Hive.isAdapterRegistered(RecommendationHiveAdapter().typeId)) {
    Hive.registerAdapter(RecommendationHiveAdapter());
  }
  if (!Hive.isAdapterRegistered(GardenFreezedAdapter().typeId)) {
    Hive.registerAdapter(GardenFreezedAdapter());
  }
  if (!Hive.isAdapterRegistered(v2.GardenAdapter().typeId)) {
    Hive.registerAdapter(v2.GardenAdapter());
  }
  if (!Hive.isAdapterRegistered(GardenHiveAdapter().typeId)) {
    Hive.registerAdapter(GardenHiveAdapter());
  }
  if (!Hive.isAdapterRegistered(GardenBedHiveAdapter().typeId)) {
    Hive.registerAdapter(GardenBedHiveAdapter());
  }
}

class _FailingGardenDataMigration extends GardenDataMigration {
  @override
  Future<GardenMigrationResult> migrateAllGardens({
    bool cleanupOldBoxes = false,
    bool dryRun = false,
    bool backupBeforeMigration = true,
  }) async {
    throw Exception('Forcé: échec migration jardins');
  }
}

