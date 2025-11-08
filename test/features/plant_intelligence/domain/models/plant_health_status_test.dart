// 🧪 Tests unitaires pour PlantHealthStatus
// PermaCalendar v2.8.0 - Migration Riverpod 3
// Vérifie l'instanciation, la sérialisation JSON/Hive et les helpers de statut

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:permacalendar/features/plant_intelligence/domain/models/plant_health_status.dart';

void main() {
  group('PlantHealthStatus', () {
    late PlantHealthComponent humidity;
    late PlantHealthComponent light;
    late PlantHealthComponent temperature;
    late PlantHealthComponent nutrients;
    late DateTime referenceDate;

    setUp(() {
      referenceDate = DateTime(2024, 1, 15, 10, 30);
      humidity = PlantHealthComponent(
        factor: PlantHealthFactor.humidity,
        score: 82,
        level: PlantHealthLevel.good,
        value: 58,
        optimalValue: 60,
        minValue: 50,
        maxValue: 70,
        unit: '%',
        trend: 'up',
      );
      light = PlantHealthComponent(
        factor: PlantHealthFactor.light,
        score: 76,
        level: PlantHealthLevel.good,
        value: 9500,
        optimalValue: 10000,
        minValue: 8000,
        maxValue: 12000,
        unit: 'lux',
        trend: 'stable',
      );
      temperature = PlantHealthComponent(
        factor: PlantHealthFactor.temperature,
        score: 70,
        level: PlantHealthLevel.fair,
        value: 23.5,
        optimalValue: 24,
        minValue: 18,
        maxValue: 28,
        unit: '°C',
        trend: 'down',
      );
      nutrients = PlantHealthComponent(
        factor: PlantHealthFactor.nutrients,
        score: 68,
        level: PlantHealthLevel.fair,
        value: 72,
        optimalValue: 80,
        minValue: 60,
        maxValue: 95,
        unit: '%',
        trend: 'down',
      );
    });

    test('devrait créer un statut complet avec valeurs personnalisées', () {
      // Arrange
      final pestPressure = PlantHealthComponent(
        factor: PlantHealthFactor.pestPressure,
        score: 40,
        level: PlantHealthLevel.poor,
        trend: 'up',
      );

      // Act
      final status = PlantHealthStatus(
        plantId: 'plant-123',
        gardenId: 'garden-789',
        overallScore: 74,
        level: PlantHealthLevel.good,
        humidity: humidity,
        light: light,
        temperature: temperature,
        nutrients: nutrients,
        pestPressure: pestPressure,
        lastUpdated: referenceDate,
        lastSyncedAt: referenceDate.subtract(const Duration(minutes: 15)),
        activeAlerts: const ['Arroser dans les 24h'],
        recommendedActions: const ['Ajouter du compost'],
        healthTrend: 'stable',
        factorTrends: const {
          'humidity': 0.12,
          'nutrients': -0.2,
        },
        metadata: const {
          'source': 'plant_condition_analyzer',
          'version': '2.0.0',
        },
      );

      // Assert
      expect(status.plantId, equals('plant-123'));
      expect(status.gardenId, equals('garden-789'));
      expect(status.overallScore, equals(74));
      expect(status.level, equals(PlantHealthLevel.good));
      expect(status.components, containsAll(<PlantHealthComponent>[
        humidity,
        light,
        temperature,
        nutrients,
        pestPressure,
      ]));
      expect(status.componentFor(PlantHealthFactor.humidity), equals(humidity));
      expect(status.isHealthy, isTrue);
      expect(status.isCritical, isFalse);
      expect(status.normalizedScore, closeTo(0.74, 1e-6));
      expect(status.criticalComponents, isEmpty);
      expect(status.healthTrend, equals('stable'));
      expect(status.factorTrends['humidity'], closeTo(0.12, 1e-6));
    });

    test('factory initial devrait créer un statut neutre', () {
      // Act
      final status = PlantHealthStatus.initial(
        plantId: 'plant-init',
        gardenId: 'garden-init',
        timestamp: referenceDate,
      );

      // Assert
      expect(status.plantId, equals('plant-init'));
      expect(status.gardenId, equals('garden-init'));
      expect(status.overallScore, equals(50));
      expect(status.level, equals(PlantHealthLevel.fair));
      expect(status.components, hasLength(greaterThanOrEqualTo(4)));
      expect(status.healthTrend, equals('stable'));
      expect(status.activeAlerts, isEmpty);
      expect(status.lastUpdated, equals(referenceDate));
      expect(status.lastSyncedAt, equals(referenceDate));
    });

    group('Sérialisation JSON', () {
      late PlantHealthStatus status;

      setUp(() {
        status = PlantHealthStatus(
          plantId: 'plant-json-001',
          gardenId: 'garden-json-001',
          overallScore: 78,
          level: PlantHealthLevel.good,
          humidity: humidity,
          light: light,
          temperature: temperature,
          nutrients: nutrients,
          lastUpdated: referenceDate,
          activeAlerts: const ['Surveiller la température'],
          recommendedActions: const ['Installer un voile d’ombrage'],
          healthTrend: 'improving',
          factorTrends: const {
            'temperature': -0.05,
            'light': 0.02,
          },
        );
      });

      test('devrait sérialiser en JSON', () {
        // Act
        final json = status.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['plantId'], equals('plant-json-001'));
        expect(json['level'], equals('good'));
        expect(json['humidity']['factor'], equals('humidity'));
        expect(json['lastUpdated'], isA<String>());
        expect(json['activeAlerts'], equals(<String>['Surveiller la température']));
      });

      test('devrait désérialiser depuis JSON', () {
        // Arrange
        final json = status.toJson();

        // Act
        final restored = PlantHealthStatus.fromJson(json);

        // Assert
        expect(restored, equals(status));
        expect(restored.humidity.factor, equals(PlantHealthFactor.humidity));
        expect(restored.lastUpdated, equals(referenceDate));
        expect(restored.activeAlerts, equals(status.activeAlerts));
      });
    });

    group('Persistance Hive', () {
      late Directory tempDir;

      setUpAll(() async {
        tempDir = await Directory.systemTemp.createTemp('plant_health_status_test');
        Hive.init(tempDir.path);
        if (!Hive.isAdapterRegistered(PlantHealthLevelAdapter().typeId)) {
          Hive.registerAdapter(PlantHealthLevelAdapter());
        }
        if (!Hive.isAdapterRegistered(PlantHealthFactorAdapter().typeId)) {
          Hive.registerAdapter(PlantHealthFactorAdapter());
        }
        if (!Hive.isAdapterRegistered(PlantHealthComponentAdapter().typeId)) {
          Hive.registerAdapter(PlantHealthComponentAdapter());
        }
        if (!Hive.isAdapterRegistered(PlantHealthStatusAdapter().typeId)) {
          Hive.registerAdapter(PlantHealthStatusAdapter());
        }
      });

      tearDownAll(() async {
        await Hive.close();
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      test('devrait persister et restaurer un statut', () async {
        // Arrange
        final status = PlantHealthStatus(
          plantId: 'plant-hive-001',
          gardenId: 'garden-hive-001',
          overallScore: 28,
          level: PlantHealthLevel.critical,
          humidity: humidity,
          light: light,
          temperature: temperature,
          nutrients: nutrients,
          pestPressure: PlantHealthComponent(
            factor: PlantHealthFactor.pestPressure,
            score: 20,
            level: PlantHealthLevel.critical,
          ),
          activeAlerts: const ['Traitement antiparasitaire requis'],
          healthTrend: 'declining',
          lastUpdated: referenceDate,
        );

        // Act
        final box = await Hive.openBox<PlantHealthStatus>('plant_health_status_test_box');
        await box.put('status', status);
        final restored = box.get('status');

        // Assert
        expect(restored, equals(status));
        expect(restored?.isCritical, isTrue);
        expect(restored?.criticalComponents.single.factor,
            equals(PlantHealthFactor.pestPressure));

        await box.deleteFromDisk();
      });
    });
  });

  group('PlantHealthLevelExtension', () {
    test('displayName retourne la traduction attendue', () {
      expect(PlantHealthLevel.excellent.displayName, equals('Excellent'));
      expect(PlantHealthLevel.good.displayName, equals('Bon'));
      expect(PlantHealthLevel.fair.displayName, equals('Moyen'));
      expect(PlantHealthLevel.poor.displayName, equals('Faible'));
      expect(PlantHealthLevel.critical.displayName, equals('Critique'));
    });

    test('scoreThreshold respecte les seuils définis', () {
      expect(PlantHealthLevel.excellent.scoreThreshold, equals(0.9));
      expect(PlantHealthLevel.good.scoreThreshold, equals(0.75));
      expect(PlantHealthLevel.fair.scoreThreshold, equals(0.6));
      expect(PlantHealthLevel.poor.scoreThreshold, equals(0.4));
      expect(PlantHealthLevel.critical.scoreThreshold, equals(0.0));
    });
  });
}

