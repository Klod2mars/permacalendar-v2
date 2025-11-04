import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:permacalendar/features/plant_intelligence/data/repositories/plant_intelligence_repository_impl.dart';
import 'package:permacalendar/features/plant_intelligence/data/datasources/plant_intelligence_local_datasource.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/notification_alert.dart';
import 'package:permacalendar/core/services/aggregation/garden_aggregation_hub.dart';

@GenerateMocks([], customMocks: [
  MockSpec<PlantIntelligenceLocalDataSource>(as: #MockPlantIntelligenceLocalDataSource),
  MockSpec<GardenAggregationHub>(as: #MockGardenAggregationHub),
])
import 'analytics_repository_test.mocks.dart';

/// **CURSOR PROMPT A4 - Intelligence Report Persistence Tests**
/// 
/// Test suite complet pour la persistence des rapports d'intelligence.
/// 
/// **Couverture :**
/// - Sauvegarde d'un rapport
/// - Récupération du dernier rapport
/// - Comportement avec ID plante inconnu
/// - Comportement quand Hive est vide ou non initialisé
/// - Sérialisation/désérialisation correcte
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

  group('CURSOR PROMPT A4 - saveLatestReport', () {
    test('should save report successfully with valid data', () async {
      // Arrange
      final report = _createTestReport('plant_1', 'garden_1');
      final reportJson = report.toJson();

      when(mockDataSource.saveIntelligenceReport(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      await repository.saveLatestReport(report);

      // Assert
      verify(mockDataSource.saveIntelligenceReport('plant_1', reportJson))
          .called(1);
    });

    test('should handle serialization correctly', () async {
      // Arrange
      final report = _createTestReport('plant_2', 'garden_1');
      Map<String, dynamic>? capturedJson;

      when(mockDataSource.saveIntelligenceReport(any, any))
          .thenAnswer((invocation) async {
        capturedJson = invocation.positionalArguments[1] as Map<String, dynamic>;
      });

      // Act
      await repository.saveLatestReport(report);

      // Assert
      expect(capturedJson, isNotNull);
      expect(capturedJson!['plantId'], equals('plant_2'));
      expect(capturedJson!['gardenId'], equals('garden_1'));
      expect(capturedJson!['intelligenceScore'], equals(85.5));
      expect(capturedJson!['confidence'], equals(0.9));
      expect(capturedJson!['plantName'], equals('Test Plant'));
    });

    test('should not throw exception when datasource fails', () async {
      // Arrange
      final report = _createTestReport('plant_3', 'garden_1');

      when(mockDataSource.saveIntelligenceReport(any, any))
          .thenThrow(Exception('Hive write error'));

      // Act & Assert - should not throw
      await expectLater(
        repository.saveLatestReport(report),
        completes,
      );
    });

    test('should handle null values gracefully', () async {
      // Arrange
      final report = _createTestReportWithNulls('plant_4', 'garden_1');

      when(mockDataSource.saveIntelligenceReport(any, any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert - should not throw
      await expectLater(
        repository.saveLatestReport(report),
        completes,
      );
    });

    test('should overwrite previous report for same plant', () async {
      // Arrange
      final report1 = _createTestReport('plant_5', 'garden_1');
      final report2 = _createTestReport('plant_5', 'garden_1')
          .copyWith(intelligenceScore: 90.0);

      when(mockDataSource.saveIntelligenceReport(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      await repository.saveLatestReport(report1);
      await repository.saveLatestReport(report2);

      // Assert - should be called twice with the same plantId
      verify(mockDataSource.saveIntelligenceReport('plant_5', any))
          .called(2);
    });
  });

  group('CURSOR PROMPT A4 - getLastReport', () {
    test('should retrieve report successfully when it exists', () async {
      // Arrange
      final expectedReport = _createTestReport('plant_6', 'garden_1');
      final reportJson = expectedReport.toJson();

      when(mockDataSource.getIntelligenceReport('plant_6'))
          .thenAnswer((_) async => reportJson);

      // Act
      final result = await repository.getLastReport('plant_6');

      // Assert
      expect(result, isNotNull);
      expect(result!.plantId, equals('plant_6'));
      expect(result.intelligenceScore, equals(85.5));
      expect(result.confidence, equals(0.9));
      verify(mockDataSource.getIntelligenceReport('plant_6')).called(1);
    });

    test('should return null when no report exists for plant', () async {
      // Arrange
      when(mockDataSource.getIntelligenceReport('unknown_plant'))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getLastReport('unknown_plant');

      // Assert
      expect(result, isNull);
      verify(mockDataSource.getIntelligenceReport('unknown_plant')).called(1);
    });

    test('should return null when Hive box is empty', () async {
      // Arrange
      when(mockDataSource.getIntelligenceReport(any))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getLastReport('plant_7');

      // Assert
      expect(result, isNull);
    });

    test('should return null when datasource throws exception', () async {
      // Arrange
      when(mockDataSource.getIntelligenceReport(any))
          .thenThrow(Exception('Hive read error'));

      // Act
      final result = await repository.getLastReport('plant_8');

      // Assert - should not throw, return null instead
      expect(result, isNull);
    });

    test('should handle deserialization errors gracefully', () async {
      // Arrange
      when(mockDataSource.getIntelligenceReport('plant_9'))
          .thenAnswer((_) async => {'invalid': 'data'});

      // Act
      final result = await repository.getLastReport('plant_9');

      // Assert - should not throw, return null instead
      expect(result, isNull);
    });

    test('should deserialize complex report correctly', () async {
      // Arrange
      final originalReport = _createComplexTestReport('plant_10', 'garden_1');
      final reportJson = originalReport.toJson();

      when(mockDataSource.getIntelligenceReport('plant_10'))
          .thenAnswer((_) async => reportJson);

      // Act
      final result = await repository.getLastReport('plant_10');

      // Assert
      expect(result, isNotNull);
      expect(result!.recommendations.length, equals(2));
      expect(result.activeAlerts.length, equals(1));
      expect(result.metadata['testKey'], equals('testValue'));
      expect(result.plantingTiming, isNotNull);
    });

    test('should use cache on second call', () async {
      // Arrange
      final reportJson = _createTestReport('plant_11', 'garden_1').toJson();

      when(mockDataSource.getIntelligenceReport('plant_11'))
          .thenAnswer((_) async => reportJson);

      // Act
      final result1 = await repository.getLastReport('plant_11');
      final result2 = await repository.getLastReport('plant_11');

      // Assert
      expect(result1, isNotNull);
      expect(result2, isNotNull);
      expect(result1!.plantId, equals(result2!.plantId));
      // Should only call datasource once due to caching
      verify(mockDataSource.getIntelligenceReport('plant_11')).called(1);
    });
  });

  group('CURSOR PROMPT A4 - Round-trip serialization', () {
    test('should maintain data integrity through save and load cycle', () async {
      // Arrange
      final originalReport = _createTestReport('plant_12', 'garden_1');
      Map<String, dynamic>? savedJson;

      when(mockDataSource.saveIntelligenceReport(any, any))
          .thenAnswer((invocation) async {
        savedJson = invocation.positionalArguments[1] as Map<String, dynamic>;
      });

      when(mockDataSource.getIntelligenceReport('plant_12'))
          .thenAnswer((_) async => savedJson);

      // Act
      await repository.saveLatestReport(originalReport);
      final retrievedReport = await repository.getLastReport('plant_12');

      // Assert
      expect(retrievedReport, isNotNull);
      expect(retrievedReport!.plantId, equals(originalReport.plantId));
      expect(retrievedReport.intelligenceScore, equals(originalReport.intelligenceScore));
      expect(retrievedReport.confidence, equals(originalReport.confidence));
      expect(retrievedReport.plantName, equals(originalReport.plantName));
    });

    test('should preserve all report fields through serialization', () async {
      // Arrange
      final originalReport = _createComplexTestReport('plant_13', 'garden_1');
      Map<String, dynamic>? savedJson;

      when(mockDataSource.saveIntelligenceReport(any, any))
          .thenAnswer((invocation) async {
        savedJson = invocation.positionalArguments[1] as Map<String, dynamic>;
      });

      when(mockDataSource.getIntelligenceReport('plant_13'))
          .thenAnswer((_) async => savedJson);

      // Act
      await repository.saveLatestReport(originalReport);
      final retrievedReport = await repository.getLastReport('plant_13');

      // Assert
      expect(retrievedReport, isNotNull);
      expect(retrievedReport!.recommendations.length, 
             equals(originalReport.recommendations.length));
      expect(retrievedReport.activeAlerts.length, 
             equals(originalReport.activeAlerts.length));
      expect(retrievedReport.metadata['testKey'], equals('testValue'));
    });
  });

  group('CURSOR PROMPT A4 - Edge cases', () {
    test('should handle empty plantId', () async {
      // Arrange
      final report = _createTestReport('', 'garden_1');

      when(mockDataSource.saveIntelligenceReport(any, any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert
      await expectLater(
        repository.saveLatestReport(report),
        completes,
      );
    });

    test('should handle very large report', () async {
      // Arrange
      final report = _createLargeTestReport('plant_14', 'garden_1');

      when(mockDataSource.saveIntelligenceReport(any, any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert
      await expectLater(
        repository.saveLatestReport(report),
        completes,
      );
    });

    test('should handle report with expired timestamp', () async {
      // Arrange
      final expiredReport = _createTestReport('plant_15', 'garden_1')
          .copyWith(
            generatedAt: DateTime.now().subtract(const Duration(days: 30)),
            expiresAt: DateTime.now().subtract(const Duration(days: 29)),
          );
      
      final reportJson = expiredReport.toJson();

      when(mockDataSource.saveIntelligenceReport(any, any))
          .thenAnswer((_) async => Future.value());
      
      when(mockDataSource.getIntelligenceReport('plant_15'))
          .thenAnswer((_) async => reportJson);

      // Act
      await repository.saveLatestReport(expiredReport);
      final result = await repository.getLastReport('plant_15');

      // Assert
      expect(result, isNotNull);
      expect(result!.isExpired, isTrue);
    });
  });
}

// ==================== TEST HELPERS ====================

PlantIntelligenceReport _createTestReport(String plantId, String gardenId) {
  return PlantIntelligenceReport(
    id: 'report_$plantId',
    plantId: plantId,
    plantName: 'Test Plant',
    gardenId: gardenId,
    analysis: PlantAnalysisResult(
      id: 'analysis_1',
      plantId: plantId,
      overallHealth: PlantHealth.good,
      healthScore: 80.0,
      confidence: 0.85,
      temperature: ConditionStatus.optimal,
      humidity: ConditionStatus.optimal,
      light: ConditionStatus.optimal,
      soil: ConditionStatus.optimal,
      analyzedAt: DateTime.now(),
      warnings: [],
      strengths: ['Good conditions'],
    ),
    recommendations: [],
    intelligenceScore: 85.5,
    confidence: 0.9,
    generatedAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(hours: 6)),
  );
}

PlantIntelligenceReport _createTestReportWithNulls(String plantId, String gardenId) {
  return PlantIntelligenceReport(
    id: 'report_$plantId',
    plantId: plantId,
    plantName: 'Test Plant',
    gardenId: gardenId,
    analysis: PlantAnalysisResult(
      id: 'analysis_1',
      plantId: plantId,
      overallHealth: PlantHealth.good,
      healthScore: 80.0,
      confidence: 0.85,
      temperature: ConditionStatus.optimal,
      humidity: ConditionStatus.optimal,
      light: ConditionStatus.optimal,
      soil: ConditionStatus.optimal,
      analyzedAt: DateTime.now(),
      warnings: [],
      strengths: [],
    ),
    recommendations: [],
    plantingTiming: null,
    activeAlerts: [],
    intelligenceScore: 85.5,
    confidence: 0.9,
    generatedAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(hours: 6)),
    metadata: {},
  );
}

PlantIntelligenceReport _createComplexTestReport(String plantId, String gardenId) {
  return PlantIntelligenceReport(
    id: 'report_$plantId',
    plantId: plantId,
    plantName: 'Complex Test Plant',
    gardenId: gardenId,
    analysis: PlantAnalysisResult(
      id: 'analysis_1',
      plantId: plantId,
      overallHealth: PlantHealth.good,
      healthScore: 80.0,
      confidence: 0.85,
      temperature: ConditionStatus.optimal,
      humidity: ConditionStatus.suboptimal,
      light: ConditionStatus.optimal,
      soil: ConditionStatus.good,
      analyzedAt: DateTime.now(),
      warnings: ['Low humidity'],
      strengths: ['Good temperature', 'Good light'],
    ),
    recommendations: [
      Recommendation(
        id: 'rec_1',
        plantId: plantId,
        title: 'Increase watering',
        description: 'Water more frequently',
        priority: RecommendationPriority.high,
        category: RecommendationCategory.watering,
        status: RecommendationStatus.pending,
        createdAt: DateTime.now(),
      ),
      Recommendation(
        id: 'rec_2',
        plantId: plantId,
        title: 'Add fertilizer',
        description: 'Apply organic fertilizer',
        priority: RecommendationPriority.medium,
        category: RecommendationCategory.fertilization,
        status: RecommendationStatus.pending,
        createdAt: DateTime.now(),
      ),
    ],
    plantingTiming: const PlantingTimingEvaluation(
      isOptimalTime: true,
      timingScore: 85.0,
      reason: 'Good season for planting',
      favorableFactors: ['Temperature', 'Season'],
      unfavorableFactors: [],
      risks: [],
    ),
    activeAlerts: [
      NotificationAlert(
        id: 'alert_1',
        title: 'Low humidity',
        message: 'Consider increasing humidity',
        type: NotificationType.warning,
        priority: NotificationPriority.medium,
        createdAt: DateTime.now(),
        plantId: plantId,
      ),
    ],
    intelligenceScore: 85.5,
    confidence: 0.9,
    generatedAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(hours: 6)),
    metadata: {'testKey': 'testValue'},
  );
}

PlantIntelligenceReport _createLargeTestReport(String plantId, String gardenId) {
  return PlantIntelligenceReport(
    id: 'report_$plantId',
    plantId: plantId,
    plantName: 'Large Test Plant',
    gardenId: gardenId,
    analysis: PlantAnalysisResult(
      id: 'analysis_1',
      plantId: plantId,
      overallHealth: PlantHealth.good,
      healthScore: 80.0,
      confidence: 0.85,
      temperature: ConditionStatus.optimal,
      humidity: ConditionStatus.optimal,
      light: ConditionStatus.optimal,
      soil: ConditionStatus.optimal,
      analyzedAt: DateTime.now(),
      warnings: List.generate(50, (i) => 'Warning $i'),
      strengths: List.generate(50, (i) => 'Strength $i'),
    ),
    recommendations: List.generate(
      100,
      (i) => Recommendation(
        id: 'rec_$i',
        plantId: plantId,
        title: 'Recommendation $i',
        description: 'Description $i',
        priority: RecommendationPriority.medium,
        category: RecommendationCategory.general,
        status: RecommendationStatus.pending,
        createdAt: DateTime.now(),
      ),
    ),
    intelligenceScore: 85.5,
    confidence: 0.9,
    generatedAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(hours: 6)),
    metadata: { for (var i in List.generate(100, (i) => i)) 'key_$i' : 'value_$i' },
  );
}

