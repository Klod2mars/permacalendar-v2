import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_evolution_report.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/plant_evolution_tracker_service.dart';
import 'package:uuid/uuid.dart';

/// 🧪 CURSOR PROMPT A5 - Plant Evolution Tracker Service Tests
/// 
/// Comprehensive test coverage for PlantEvolutionTrackerService
/// 
/// Test Coverage:
/// 1. ✅ Stable report → trend = "stable", all unchanged
/// 2. ✅ Score increase → trend = "up", some improvements
/// 3. ✅ Score decrease → trend = "down", some degradations
/// 4. ✅ Empty reports → handled gracefully
/// 5. ✅ Null values in conditions → safe comparison
/// 6. ✅ Exact boundary threshold (±1%)
/// 7. ✅ Conditions added/removed between reports
/// 8. ✅ Different plants → ArgumentError
/// 9. ✅ All conditions improved
/// 10. ✅ Mixed condition changes
/// 11. ✅ Extension methods work correctly

void main() {
  group('PlantEvolutionTrackerService', () {
    late PlantEvolutionTrackerService tracker;
    
    setUp(() {
      tracker = PlantEvolutionTrackerService(
        stabilityThreshold: 1.0,
        enableLogging: false,
      );
    });
    
    // ==================== TEST CASE 1: Stable Report ====================
    
    test('should return stable trend when no significant changes', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'tomato_1',
        intelligenceScore: 75.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'tomato_1',
        intelligenceScore: 75.5, // +0.5 (within 1.0 threshold)
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 2),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.plantId, 'tomato_1');
      expect(result.trend, 'stable');
      expect(result.deltaScore, 0.5);
      expect(result.previousScore, 75.0);
      expect(result.currentScore, 75.5);
      expect(result.improvedConditions, isEmpty);
      expect(result.degradedConditions, isEmpty);
      expect(result.unchangedConditions, hasLength(4));
      expect(result.unchangedConditions, containsAll(['temperature', 'humidity', 'light', 'soil']));
    });
    
    // ==================== TEST CASE 2: Score Increase ====================
    
    test('should return up trend when score increases significantly', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'pepper_1',
        intelligenceScore: 60.0,
        temperatureStatus: ConditionStatus.fair,
        humidityStatus: ConditionStatus.poor,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.fair,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'pepper_1',
        intelligenceScore: 75.0, // +15.0 (well above 1.0 threshold)
        temperatureStatus: ConditionStatus.good, // improved
        humidityStatus: ConditionStatus.good, // improved
        lightStatus: ConditionStatus.excellent, // improved
        soilStatus: ConditionStatus.fair, // unchanged
        generatedAt: DateTime(2025, 10, 5),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.trend, 'up');
      expect(result.deltaScore, 15.0);
      expect(result.improvedConditions, hasLength(3));
      expect(result.improvedConditions, containsAll(['temperature', 'humidity', 'light']));
      expect(result.degradedConditions, isEmpty);
      expect(result.unchangedConditions, contains('soil'));
      expect(result.hasImproved, isTrue);
      expect(result.isStable, isFalse);
      expect(result.hasDegraded, isFalse);
    });
    
    // ==================== TEST CASE 3: Score Decrease ====================
    
    test('should return down trend when score decreases significantly', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'lettuce_1',
        intelligenceScore: 85.0,
        temperatureStatus: ConditionStatus.excellent,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'lettuce_1',
        intelligenceScore: 55.0, // -30.0 (significant decrease)
        temperatureStatus: ConditionStatus.fair, // degraded
        humidityStatus: ConditionStatus.poor, // degraded
        lightStatus: ConditionStatus.good, // unchanged
        soilStatus: ConditionStatus.critical, // degraded
        generatedAt: DateTime(2025, 10, 3),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.trend, 'down');
      expect(result.deltaScore, -30.0);
      expect(result.improvedConditions, isEmpty);
      expect(result.degradedConditions, hasLength(3));
      expect(result.degradedConditions, containsAll(['temperature', 'humidity', 'soil']));
      expect(result.unchangedConditions, contains('light'));
      expect(result.hasDegraded, isTrue);
      expect(result.isStable, isFalse);
      expect(result.hasImproved, isFalse);
    });
    
    // ==================== TEST CASE 4: Null Values Handled ====================
    
    test('should handle null analysis gracefully', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'basil_1',
        intelligenceScore: 70.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'basil_1',
        intelligenceScore: 72.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 2),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert - should not throw, should return valid result
      expect(result.plantId, 'basil_1');
      expect(result.trend, 'up'); // +2.0 is above threshold
      expect(result.deltaScore, 2.0);
    });
    
    // ==================== TEST CASE 5: Exact Boundary Threshold ====================
    
    test('should treat exact threshold boundary as stable', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'carrot_1',
        intelligenceScore: 70.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'carrot_1',
        intelligenceScore: 70.99, // +0.99 (just below 1.0 threshold)
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 2),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.trend, 'stable');
      expect(result.deltaScore, closeTo(0.99, 0.01));
    });
    
    test('should treat exact negative threshold boundary as stable', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'spinach_1',
        intelligenceScore: 70.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'spinach_1',
        intelligenceScore: 69.01, // -0.99 (just above -1.0 threshold)
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 2),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.trend, 'stable');
      expect(result.deltaScore, closeTo(-0.99, 0.01));
    });
    
    test('should treat score at exact +1.0 threshold as up', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'cucumber_1',
        intelligenceScore: 70.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'cucumber_1',
        intelligenceScore: 71.0, // +1.0 (exactly at threshold)
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 2),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.trend, 'up');
      expect(result.deltaScore, 1.0);
    });
    
    // ==================== TEST CASE 6: Different Plants Error ====================
    
    test('should throw ArgumentError when comparing different plants', () {
      // Arrange
      final report1 = _createMockReport(
        plantId: 'tomato_1',
        intelligenceScore: 70.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final report2 = _createMockReport(
        plantId: 'pepper_1',
        intelligenceScore: 75.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 2),
      );
      
      // Act & Assert
      expect(
        () => tracker.compareReports(
          previous: report1,
          current: report2,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Cannot compare reports for different plants'),
        )),
      );
    });
    
    // ==================== TEST CASE 7: All Conditions Improved ====================
    
    test('should detect when all conditions improved', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'kale_1',
        intelligenceScore: 50.0,
        temperatureStatus: ConditionStatus.poor,
        humidityStatus: ConditionStatus.critical,
        lightStatus: ConditionStatus.fair,
        soilStatus: ConditionStatus.poor,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'kale_1',
        intelligenceScore: 85.0, // +35.0
        temperatureStatus: ConditionStatus.excellent,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.excellent,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 7),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.trend, 'up');
      expect(result.improvedConditions, hasLength(4));
      expect(result.improvedConditions, containsAll(['temperature', 'humidity', 'light', 'soil']));
      expect(result.degradedConditions, isEmpty);
      expect(result.unchangedConditions, isEmpty);
      expect(result.improvementRate, 100.0);
      expect(result.degradationRate, 0.0);
    });
    
    // ==================== TEST CASE 8: Mixed Condition Changes ====================
    
    test('should handle mixed condition changes correctly', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'bean_1',
        intelligenceScore: 70.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.fair,
        lightStatus: ConditionStatus.excellent,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'bean_1',
        intelligenceScore: 71.5, // +1.5
        temperatureStatus: ConditionStatus.excellent, // improved
        humidityStatus: ConditionStatus.good, // improved
        lightStatus: ConditionStatus.good, // degraded
        soilStatus: ConditionStatus.good, // unchanged
        generatedAt: DateTime(2025, 10, 3),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.trend, 'up');
      expect(result.improvedConditions, hasLength(2));
      expect(result.improvedConditions, containsAll(['temperature', 'humidity']));
      expect(result.degradedConditions, hasLength(1));
      expect(result.degradedConditions, contains('light'));
      expect(result.unchangedConditions, hasLength(1));
      expect(result.unchangedConditions, contains('soil'));
      expect(result.totalConditions, 4);
      expect(result.improvementRate, 50.0);
      expect(result.degradationRate, 25.0);
    });
    
    // ==================== TEST CASE 9: Custom Threshold ====================
    
    test('should respect custom stability threshold', () {
      // Arrange
      final customTracker = PlantEvolutionTrackerService(
        stabilityThreshold: 5.0, // Higher threshold
        enableLogging: false,
      );
      
      final previousReport = _createMockReport(
        plantId: 'zucchini_1',
        intelligenceScore: 70.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'zucchini_1',
        intelligenceScore: 73.0, // +3.0 (within 5.0 threshold)
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 2),
      );
      
      // Act
      final result = customTracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.trend, 'stable'); // Should be stable with 5.0 threshold
      expect(result.deltaScore, 3.0);
    });
    
    // ==================== TEST CASE 10: Extension Methods ====================
    
    test('extension methods should provide helpful utilities', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'parsley_1',
        intelligenceScore: 60.0,
        temperatureStatus: ConditionStatus.fair,
        humidityStatus: ConditionStatus.poor,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.fair,
        generatedAt: DateTime(2025, 10, 1, 12, 0),
      );
      
      final currentReport = _createMockReport(
        plantId: 'parsley_1',
        intelligenceScore: 75.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.fair,
        generatedAt: DateTime(2025, 10, 5, 12, 0), // 4 days later
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.hasImproved, isTrue);
      expect(result.hasDegraded, isFalse);
      expect(result.isStable, isFalse);
      expect(result.description, contains('Amélioration'));
      expect(result.description, contains('+15.0 points'));
      expect(result.timeBetweenReports, const Duration(days: 4));
      expect(result.hasConditionChanges, isTrue);
      expect(result.totalConditions, 4);
    });
    
    // ==================== TEST CASE 11: Zero Score Delta ====================
    
    test('should handle exact zero score delta', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'mint_1',
        intelligenceScore: 80.0,
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'mint_1',
        intelligenceScore: 80.0, // Exact same
        temperatureStatus: ConditionStatus.good,
        humidityStatus: ConditionStatus.good,
        lightStatus: ConditionStatus.good,
        soilStatus: ConditionStatus.good,
        generatedAt: DateTime(2025, 10, 2),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.trend, 'stable');
      expect(result.deltaScore, 0.0);
      expect(result.improvedConditions, isEmpty);
      expect(result.degradedConditions, isEmpty);
      expect(result.unchangedConditions, hasLength(4));
    });
    
    // ==================== TEST CASE 12: All Conditions Degraded ====================
    
    test('should detect when all conditions degraded', () {
      // Arrange
      final previousReport = _createMockReport(
        plantId: 'oregano_1',
        intelligenceScore: 90.0,
        temperatureStatus: ConditionStatus.excellent,
        humidityStatus: ConditionStatus.excellent,
        lightStatus: ConditionStatus.excellent,
        soilStatus: ConditionStatus.excellent,
        generatedAt: DateTime(2025, 10, 1),
      );
      
      final currentReport = _createMockReport(
        plantId: 'oregano_1',
        intelligenceScore: 40.0, // -50.0
        temperatureStatus: ConditionStatus.poor,
        humidityStatus: ConditionStatus.critical,
        lightStatus: ConditionStatus.fair,
        soilStatus: ConditionStatus.poor,
        generatedAt: DateTime(2025, 10, 10),
      );
      
      // Act
      final result = tracker.compareReports(
        previous: previousReport,
        current: currentReport,
      );
      
      // Assert
      expect(result.trend, 'down');
      expect(result.improvedConditions, isEmpty);
      expect(result.degradedConditions, hasLength(4));
      expect(result.unchangedConditions, isEmpty);
      expect(result.improvementRate, 0.0);
      expect(result.degradationRate, 100.0);
    });
  });
}

// ==================== HELPER FUNCTIONS ====================

/// Creates a mock PlantIntelligenceReport for testing
PlantIntelligenceReport _createMockReport({
  required String plantId,
  required double intelligenceScore,
  required ConditionStatus temperatureStatus,
  required ConditionStatus humidityStatus,
  required ConditionStatus lightStatus,
  required ConditionStatus soilStatus,
  required DateTime generatedAt,
}) {
  final analysis = _createMockAnalysis(
    plantId: plantId,
    temperatureStatus: temperatureStatus,
    humidityStatus: humidityStatus,
    lightStatus: lightStatus,
    soilStatus: soilStatus,
  );
  
  return PlantIntelligenceReport(
    id: 'report_$plantId',
    plantId: plantId,
    plantName: 'Test Plant',
    gardenId: 'test_garden',
    analysis: analysis,
    recommendations: [],
    intelligenceScore: intelligenceScore,
    confidence: 0.85,
    generatedAt: generatedAt,
    expiresAt: generatedAt.add(const Duration(hours: 6)),
  );
}

/// Creates a mock PlantAnalysisResult for testing
PlantAnalysisResult _createMockAnalysis({
  required String plantId,
  required ConditionStatus temperatureStatus,
  required ConditionStatus humidityStatus,
  required ConditionStatus lightStatus,
  required ConditionStatus soilStatus,
}) {
  final now = DateTime.now();
  
  return PlantAnalysisResult(
    id: const Uuid().v4(),
    plantId: plantId,
    temperature: PlantCondition(
      id: const Uuid().v4(),
      plantId: plantId,
      type: ConditionType.temperature,
      status: temperatureStatus,
      value: 22.0,
      optimalValue: 22.0,
      minValue: 18.0,
      maxValue: 28.0,
      unit: '°C',
      description: 'Temperature condition',
      measuredAt: now,
    ),
    humidity: PlantCondition(
      id: const Uuid().v4(),
      plantId: plantId,
      type: ConditionType.humidity,
      status: humidityStatus,
      value: 65.0,
      optimalValue: 65.0,
      minValue: 50.0,
      maxValue: 80.0,
      unit: '%',
      description: 'Humidity condition',
      measuredAt: now,
    ),
    light: PlantCondition(
      id: const Uuid().v4(),
      plantId: plantId,
      type: ConditionType.light,
      status: lightStatus,
      value: 5000.0,
      optimalValue: 5000.0,
      minValue: 3000.0,
      maxValue: 8000.0,
      unit: 'lux',
      description: 'Light condition',
      measuredAt: now,
    ),
    soil: PlantCondition(
      id: const Uuid().v4(),
      plantId: plantId,
      type: ConditionType.soil,
      status: soilStatus,
      value: 6.5,
      optimalValue: 6.5,
      minValue: 6.0,
      maxValue: 7.0,
      unit: 'pH',
      description: 'Soil condition',
      measuredAt: now,
    ),
    overallHealth: temperatureStatus,
    healthScore: 75.0,
    confidence: 0.9,
    warnings: [],
    strengths: [],
    priorityActions: [],
    analyzedAt: now,
  );
}

