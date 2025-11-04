import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:permacalendar/features/plant_intelligence/data/repositories/plant_intelligence_repository_impl.dart';
import 'package:permacalendar/features/plant_intelligence/data/datasources/plant_intelligence_local_datasource.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_evolution_report.dart';
import 'package:permacalendar/core/services/aggregation/garden_aggregation_hub.dart';

@GenerateMocks([], customMocks: [
  MockSpec<PlantIntelligenceLocalDataSource>(as: #MockPlantIntelligenceLocalDataSource),
  MockSpec<GardenAggregationHub>(as: #MockGardenAggregationHub),
])
import 'plant_evolution_persistence_test.mocks.dart';

/// **CURSOR PROMPT A7 - Evolution History Persistence Tests**
/// 
/// Test suite complet pour la persistence de l'historique d'évolution.
/// 
/// **Couverture :**
/// - Sauvegarde d'un rapport d'évolution
/// - Récupération de l'historique complet
/// - Tri des rapports par timestamp
/// - Gestion des données corrompues (skip gracefully)
/// - Programmation défensive (ne crash jamais)

void main() {
  late PlantIntelligenceRepositoryImpl repository;
  late MockPlantIntelligenceLocalDataSource mockDataSource;
  late MockGardenAggregationHub mockAggregationHub;

  setUp(() {
    mockDataSource = MockPlantIntelligenceLocalDataSource();
    mockAggregationHub = MockGardenAggregationHub();
    
    repository = PlantIntelligenceRepositoryImpl(
      localDataSource: mockDataSource,
      aggregationHub: mockAggregationHub,
    );
  });

  group('CURSOR PROMPT A7 - saveEvolutionReport', () {
    test('should save evolution report successfully with valid data', () async {
      // Arrange
      final report = _createTestEvolutionReport('plant_1', 'up', 5.5);
      final reportJson = report.toJson();

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((_) async => Future.value());

      // Act
      await repository.saveEvolutionReport(report);

      // Assert
      verify(mockDataSource.saveEvolutionReport(reportJson))
          .called(1);
    });

    test('should handle serialization correctly', () async {
      // Arrange
      final report = _createTestEvolutionReport('plant_2', 'down', -3.2);
      Map<String, dynamic>? capturedJson;

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((invocation) async {
        capturedJson = invocation.positionalArguments[0] as Map<String, dynamic>;
      });

      // Act
      await repository.saveEvolutionReport(report);

      // Assert
      expect(capturedJson, isNotNull);
      expect(capturedJson!['plantId'], equals('plant_2'));
      expect(capturedJson!['trend'], equals('down'));
      expect(capturedJson!['deltaScore'], equals(-3.2));
      expect(capturedJson!['previousScore'], equals(75.0));
      expect(capturedJson!['currentScore'], equals(71.8));
    });

    test('should not throw exception when datasource fails', () async {
      // Arrange
      final report = _createTestEvolutionReport('plant_3', 'stable', 0.1);

      when(mockDataSource.saveEvolutionReport(any))
          .thenThrow(Exception('Hive write error'));

      // Act & Assert - should not throw
      await expectLater(
        repository.saveEvolutionReport(report),
        completes,
      );
    });

    test('should handle complex evolution data', () async {
      // Arrange
      final report = PlantEvolutionReport(
        plantId: 'plant_4',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 15),
        previousScore: 65.0,
        currentScore: 82.5,
        deltaScore: 17.5,
        trend: 'up',
        improvedConditions: ['temperature', 'humidity', 'light'],
        degradedConditions: [],
        unchangedConditions: ['soil'],
      );

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert - should not throw
      await expectLater(
        repository.saveEvolutionReport(report),
        completes,
      );
      
      verify(mockDataSource.saveEvolutionReport(any)).called(1);
    });

    test('should save multiple reports for same plant without overwriting', () async {
      // Arrange
      final report1 = _createTestEvolutionReport('plant_5', 'up', 5.0);
      final report2 = _createTestEvolutionReport('plant_5', 'up', 3.5);

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((_) async => Future.value());

      // Act
      await repository.saveEvolutionReport(report1);
      await repository.saveEvolutionReport(report2);

      // Assert - should be called twice (not overwriting)
      verify(mockDataSource.saveEvolutionReport(any)).called(2);
    });
  });

  group('CURSOR PROMPT A7 - getEvolutionReports', () {
    test('should retrieve evolution reports successfully when they exist', () async {
      // Arrange
      final expectedReports = [
        _createTestEvolutionReport('plant_6', 'up', 5.0).toJson(),
        _createTestEvolutionReport('plant_6', 'stable', 0.5).toJson(),
        _createTestEvolutionReport('plant_6', 'down', -2.0).toJson(),
      ];

      when(mockDataSource.getEvolutionReports('plant_6'))
          .thenAnswer((_) async => expectedReports);

      // Act
      final result = await repository.getEvolutionReports('plant_6');

      // Assert
      expect(result, isNotNull);
      expect(result.length, equals(3));
      expect(result[0].plantId, equals('plant_6'));
      expect(result[0].trend, equals('up'));
      verify(mockDataSource.getEvolutionReports('plant_6')).called(1);
    });

    test('should return empty list when no reports exist for plant', () async {
      // Arrange
      when(mockDataSource.getEvolutionReports('unknown_plant'))
          .thenAnswer((_) async => []);

      // Act
      final result = await repository.getEvolutionReports('unknown_plant');

      // Assert
      expect(result, isEmpty);
      verify(mockDataSource.getEvolutionReports('unknown_plant')).called(1);
    });

    test('should return empty list when datasource throws exception', () async {
      // Arrange
      when(mockDataSource.getEvolutionReports(any))
          .thenThrow(Exception('Hive read error'));

      // Act
      final result = await repository.getEvolutionReports('plant_8');

      // Assert - should not throw, return empty list instead
      expect(result, isEmpty);
    });

    test('should skip corrupted reports gracefully', () async {
      // Arrange
      final reportsWithCorrupted = [
        _createTestEvolutionReport('plant_9', 'up', 5.0).toJson(),
        {'invalid': 'data'}, // Corrupted report
        _createTestEvolutionReport('plant_9', 'stable', 0.5).toJson(),
      ];

      when(mockDataSource.getEvolutionReports('plant_9'))
          .thenAnswer((_) async => reportsWithCorrupted);

      // Act
      final result = await repository.getEvolutionReports('plant_9');

      // Assert - should skip corrupted and return valid ones
      expect(result.length, equals(2));
      expect(result[0].trend, equals('up'));
      expect(result[1].trend, equals('stable'));
    });

    test('should deserialize complex reports correctly', () async {
      // Arrange
      final complexReport = PlantEvolutionReport(
        plantId: 'plant_10',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 15),
        previousScore: 65.0,
        currentScore: 82.5,
        deltaScore: 17.5,
        trend: 'up',
        improvedConditions: ['temperature', 'humidity', 'light'],
        degradedConditions: ['soil'],
        unchangedConditions: [],
      );

      when(mockDataSource.getEvolutionReports('plant_10'))
          .thenAnswer((_) async => [complexReport.toJson()]);

      // Act
      final result = await repository.getEvolutionReports('plant_10');

      // Assert
      expect(result, isNotNull);
      expect(result.length, equals(1));
      expect(result[0].improvedConditions.length, equals(3));
      expect(result[0].degradedConditions.length, equals(1));
      expect(result[0].improvedConditions, contains('temperature'));
      expect(result[0].degradedConditions, contains('soil'));
    });

    test('should use cache on second call', () async {
      // Arrange
      final reports = [
        _createTestEvolutionReport('plant_11', 'up', 5.0).toJson(),
      ];

      when(mockDataSource.getEvolutionReports('plant_11'))
          .thenAnswer((_) async => reports);

      // Act
      final result1 = await repository.getEvolutionReports('plant_11');
      final result2 = await repository.getEvolutionReports('plant_11');

      // Assert
      expect(result1, isNotNull);
      expect(result2, isNotNull);
      expect(result1.length, equals(result2.length));
      // Should only call datasource once due to caching
      verify(mockDataSource.getEvolutionReports('plant_11')).called(1);
    });
  });

  group('CURSOR PROMPT A7 - Round-trip serialization', () {
    test('should maintain data integrity through save and load cycle', () async {
      // Arrange
      final originalReport = _createTestEvolutionReport('plant_12', 'up', 7.5);
      Map<String, dynamic>? savedJson;

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((invocation) async {
        savedJson = invocation.positionalArguments[0] as Map<String, dynamic>;
      });

      when(mockDataSource.getEvolutionReports('plant_12'))
          .thenAnswer((_) async => [savedJson!]);

      // Act
      await repository.saveEvolutionReport(originalReport);
      final retrievedReports = await repository.getEvolutionReports('plant_12');

      // Assert
      expect(retrievedReports, isNotNull);
      expect(retrievedReports.length, equals(1));
      final retrieved = retrievedReports.first;
      expect(retrieved.plantId, equals(originalReport.plantId));
      expect(retrieved.deltaScore, equals(originalReport.deltaScore));
      expect(retrieved.trend, equals(originalReport.trend));
      expect(retrieved.previousScore, equals(originalReport.previousScore));
      expect(retrieved.currentScore, equals(originalReport.currentScore));
    });

    test('should preserve all condition lists through serialization', () async {
      // Arrange
      final originalReport = PlantEvolutionReport(
        plantId: 'plant_13',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 15),
        previousScore: 70.0,
        currentScore: 85.0,
        deltaScore: 15.0,
        trend: 'up',
        improvedConditions: ['temperature', 'light'],
        degradedConditions: ['humidity'],
        unchangedConditions: ['soil'],
      );
      Map<String, dynamic>? savedJson;

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((invocation) async {
        savedJson = invocation.positionalArguments[0] as Map<String, dynamic>;
      });

      when(mockDataSource.getEvolutionReports('plant_13'))
          .thenAnswer((_) async => [savedJson!]);

      // Act
      await repository.saveEvolutionReport(originalReport);
      final retrievedReports = await repository.getEvolutionReports('plant_13');

      // Assert
      expect(retrievedReports, isNotNull);
      expect(retrievedReports.length, equals(1));
      final retrieved = retrievedReports.first;
      expect(retrieved.improvedConditions.length, 
             equals(originalReport.improvedConditions.length));
      expect(retrieved.degradedConditions.length, 
             equals(originalReport.degradedConditions.length));
      expect(retrieved.unchangedConditions.length, 
             equals(originalReport.unchangedConditions.length));
    });
  });

  group('CURSOR PROMPT A7 - Edge cases', () {
    test('should handle empty plantId', () async {
      // Arrange
      final report = _createTestEvolutionReport('', 'stable', 0.0);

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert
      await expectLater(
        repository.saveEvolutionReport(report),
        completes,
      );
    });

    test('should handle very large deltaScore', () async {
      // Arrange
      final report = _createTestEvolutionReport('plant_14', 'up', 99.9);

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert
      await expectLater(
        repository.saveEvolutionReport(report),
        completes,
      );
    });

    test('should handle negative deltaScore for degradation', () async {
      // Arrange
      final report = _createTestEvolutionReport('plant_15', 'down', -50.5);

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert
      await expectLater(
        repository.saveEvolutionReport(report),
        completes,
      );
    });

    test('should handle report with old timestamps', () async {
      // Arrange
      final report = PlantEvolutionReport(
        plantId: 'plant_16',
        previousDate: DateTime(2020, 1, 1),
        currentDate: DateTime(2020, 1, 15),
        previousScore: 70.0,
        currentScore: 75.0,
        deltaScore: 5.0,
        trend: 'up',
        improvedConditions: [],
        degradedConditions: [],
        unchangedConditions: ['temperature', 'humidity', 'light', 'soil'],
      );

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((_) async => Future.value());

      when(mockDataSource.getEvolutionReports('plant_16'))
          .thenAnswer((_) async => [report.toJson()]);

      // Act
      await repository.saveEvolutionReport(report);
      final result = await repository.getEvolutionReports('plant_16');

      // Assert
      expect(result, isNotNull);
      expect(result.length, equals(1));
      expect(result[0].previousDate.year, equals(2020));
    });

    test('should handle report with all conditions improved', () async {
      // Arrange
      final report = PlantEvolutionReport(
        plantId: 'plant_17',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 15),
        previousScore: 50.0,
        currentScore: 95.0,
        deltaScore: 45.0,
        trend: 'up',
        improvedConditions: ['temperature', 'humidity', 'light', 'soil'],
        degradedConditions: [],
        unchangedConditions: [],
      );

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert
      await expectLater(
        repository.saveEvolutionReport(report),
        completes,
      );
    });

    test('should handle report with all conditions degraded', () async {
      // Arrange
      final report = PlantEvolutionReport(
        plantId: 'plant_18',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 15),
        previousScore: 90.0,
        currentScore: 30.0,
        deltaScore: -60.0,
        trend: 'down',
        improvedConditions: [],
        degradedConditions: ['temperature', 'humidity', 'light', 'soil'],
        unchangedConditions: [],
      );

      when(mockDataSource.saveEvolutionReport(any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert
      await expectLater(
        repository.saveEvolutionReport(report),
        completes,
      );
    });
  });

  group('CURSOR PROMPT A7 - Timeline/Sorting', () {
    test('should return reports in chronological order', () async {
      // Arrange
      // Note: DataSource is responsible for sorting, so we provide already sorted data
      final reports = [
        PlantEvolutionReport(
          plantId: 'plant_19',
          previousDate: DateTime(2023, 12, 1),
          currentDate: DateTime(2024, 1, 1), // First (sorted)
          previousScore: 65.0,
          currentScore: 70.0,
          deltaScore: 5.0,
          trend: 'up',
        ).toJson(),
        PlantEvolutionReport(
          plantId: 'plant_19',
          previousDate: DateTime(2024, 1, 1),
          currentDate: DateTime(2024, 1, 15), // Second (sorted)
          previousScore: 70.0,
          currentScore: 75.0,
          deltaScore: 5.0,
          trend: 'up',
        ).toJson(),
        PlantEvolutionReport(
          plantId: 'plant_19',
          previousDate: DateTime(2024, 1, 15),
          currentDate: DateTime(2024, 2, 1), // Third (sorted)
          previousScore: 75.0,
          currentScore: 80.0,
          deltaScore: 5.0,
          trend: 'up',
        ).toJson(),
      ];

      when(mockDataSource.getEvolutionReports('plant_19'))
          .thenAnswer((_) async => reports);

      // Act
      final result = await repository.getEvolutionReports('plant_19');

      // Assert
      expect(result, isNotNull);
      expect(result.length, equals(3));
      // Should be sorted chronologically by currentDate (datasource responsibility)
      expect(result[0].currentDate.isBefore(result[1].currentDate), isTrue);
      expect(result[1].currentDate.isBefore(result[2].currentDate), isTrue);
      // Verify correct order
      expect(result[0].currentDate, equals(DateTime(2024, 1, 1)));
      expect(result[1].currentDate, equals(DateTime(2024, 1, 15)));
      expect(result[2].currentDate, equals(DateTime(2024, 2, 1)));
    });
  });
}

// ==================== TEST HELPERS ====================

PlantEvolutionReport _createTestEvolutionReport(
  String plantId,
  String trend,
  double deltaScore,
) {
  const previousScore = 75.0;
  final currentScore = previousScore + deltaScore;

  return PlantEvolutionReport(
    plantId: plantId,
    previousDate: DateTime(2024, 1, 1),
    currentDate: DateTime(2024, 1, 15),
    previousScore: previousScore,
    currentScore: currentScore,
    deltaScore: deltaScore,
    trend: trend,
    improvedConditions: deltaScore > 0 ? ['temperature'] : [],
    degradedConditions: deltaScore < 0 ? ['humidity'] : [],
    unchangedConditions: deltaScore == 0 ? ['light', 'soil'] : [],
  );
}

