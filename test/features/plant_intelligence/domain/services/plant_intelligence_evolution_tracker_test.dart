
import '../../../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/plant_intelligence_evolution_tracker.dart';
import 'package:uuid/uuid.dart';

/// ðŸ§ª CURSOR PROMPT A3 - Intelligence Evolution Tracker Tests
/// 
/// Tests for the PlantIntelligenceEvolutionTracker service
/// 
/// Test Coverage:
/// 1. Basic report comparison with improvements
/// 2. Report comparison with degradation
/// 3. Stable reports (no changes)
/// 4. Recommendation changes detection
/// 5. Timing score shifts
/// 6. Tolerance threshold application
/// 7. Garden-wide comparison

void main() {
  group('PlantIntelligenceEvolutionTracker', () {
    late PlantIntelligenceEvolutionTracker tracker;
    
    setUp(() {
      tracker = PlantIntelligenceEvolutionTracker(
        enableLogging: false,
        toleranceThreshold: 0.01, // 1%
      );
    });
    
    // ==================== TEST CASE 1: Health Improvement ====================
    
    test('should detect health improvement when score increases', () {
      // Arrange
      final oldReport = _createMockReport(
        plantId: 'tomato_1',
        plantName: 'Tomato',
        intelligenceScore: 65.0,
        confidence: 0.8,
        recommendations: [
          _createMockRecommendation(
            title: 'Water more frequently',
            priority: RecommendationPriority.high,
          ),
          _createMockRecommendation(
            title: 'Add nitrogen fertilizer',
            priority: RecommendationPriority.medium,
          ),
        ],
      );
      
      final newReport = _createMockReport(
        plantId: 'tomato_1',
        plantName: 'Tomato',
        intelligenceScore: 80.0, // +15 points
        confidence: 0.85, // +0.05
        recommendations: [
          _createMockRecommendation(
            title: 'Add nitrogen fertilizer',
            priority: RecommendationPriority.low, // Reduced priority
          ),
        ],
      );
      
      // Act
      final summary = tracker.compareReports(oldReport, newReport);
      
      // Assert
      expect(summary.plantId, 'tomato_1');
      expect(summary.plantName, 'Tomato');
      expect(summary.scoreDelta, 15.0); // Significant improvement
      expect(summary.confidenceDelta, closeTo(0.05, 0.001));
      expect(summary.isImproved, isTrue);
      expect(summary.isStable, isFalse);
      expect(summary.isDegraded, isFalse);
      expect(summary.removedRecommendations, contains('Water more frequently'));
      expect(summary.addedRecommendations, isEmpty);
      expect(summary.modifiedRecommendations, contains('Add nitrogen fertilizer'));
    });
    
    // ==================== TEST CASE 2: Health Degradation ====================
    
    test('should detect health degradation when score decreases', () {
      // Arrange
      final oldReport = _createMockReport(
        plantId: 'pepper_1',
        plantName: 'Bell Pepper',
        intelligenceScore: 85.0,
        confidence: 0.9,
        recommendations: [
          _createMockRecommendation(
            title: 'Maintain current care',
            priority: RecommendationPriority.low,
          ),
        ],
      );
      
      final newReport = _createMockReport(
        plantId: 'pepper_1',
        plantName: 'Bell Pepper',
        intelligenceScore: 60.0, // -25 points
        confidence: 0.75, // -0.15
        recommendations: [
          _createMockRecommendation(
            title: 'Maintain current care',
            priority: RecommendationPriority.low,
          ),
          _createMockRecommendation(
            title: 'Check for pests',
            priority: RecommendationPriority.critical,
          ),
          _createMockRecommendation(
            title: 'Increase watering',
            priority: RecommendationPriority.high,
          ),
        ],
      );
      
      // Act
      final summary = tracker.compareReports(oldReport, newReport);
      
      // Assert
      expect(summary.scoreDelta, -25.0); // Significant degradation
      expect(summary.confidenceDelta, closeTo(-0.15, 0.001));
      expect(summary.isImproved, isFalse);
      expect(summary.isStable, isFalse);
      expect(summary.isDegraded, isTrue);
      expect(summary.addedRecommendations, hasLength(2));
      expect(summary.addedRecommendations, contains('Check for pests'));
      expect(summary.addedRecommendations, contains('Increase watering'));
    });
    
    // ==================== TEST CASE 3: Stable Health ====================
    
    test('should detect stable health when no significant changes', () {
      // Arrange
      final oldReport = _createMockReport(
        plantId: 'lettuce_1',
        plantName: 'Lettuce',
        intelligenceScore: 75.0,
        confidence: 0.85,
        recommendations: [
          _createMockRecommendation(
            title: 'Regular watering',
            priority: RecommendationPriority.medium,
          ),
        ],
      );
      
      final newReport = _createMockReport(
        plantId: 'lettuce_1',
        plantName: 'Lettuce',
        intelligenceScore: 75.005, // +0.005 (within 0.01 tolerance)
        confidence: 0.85, // No change
        recommendations: [
          _createMockRecommendation(
            title: 'Regular watering',
            priority: RecommendationPriority.medium,
          ),
        ],
      );
      
      // Act
      final summary = tracker.compareReports(oldReport, newReport);
      
      // Assert
      expect(summary.scoreDelta, 0.0); // Within tolerance
      expect(summary.confidenceDelta, 0.0);
      expect(summary.isImproved, isFalse);
      expect(summary.isStable, isTrue);
      expect(summary.isDegraded, isFalse);
      expect(summary.addedRecommendations, isEmpty);
      expect(summary.removedRecommendations, isEmpty);
      expect(summary.modifiedRecommendations, isEmpty);
    });
    
    // ==================== TEST CASE 4: Timing Score Changes ====================
    
    test('should detect timing score changes', () {
      // Arrange
      final oldReport = _createMockReport(
        plantId: 'carrot_1',
        plantName: 'Carrot',
        intelligenceScore: 70.0,
        confidence: 0.8,
        timingScore: 50.0, // Not optimal time
      );
      
      final newReport = _createMockReport(
        plantId: 'carrot_1',
        plantName: 'Carrot',
        intelligenceScore: 70.0, // Same
        confidence: 0.8, // Same
        timingScore: 90.0, // Much better timing
      );
      
      // Act
      final summary = tracker.compareReports(oldReport, newReport);
      
      // Assert
      expect(summary.timingScoreShift, 40.0);
      expect(summary.isStable, isTrue); // Health is stable
    });
    
    // ==================== TEST CASE 5: Different Plants Exception ====================
    
    test('should throw ArgumentError when comparing different plants', () {
      // Arrange
      final report1 = _createMockReport(
        plantId: 'tomato_1',
        plantName: 'Tomato',
        intelligenceScore: 70.0,
        confidence: 0.8,
      );
      
      final report2 = _createMockReport(
        plantId: 'pepper_1',
        plantName: 'Pepper',
        intelligenceScore: 75.0,
        confidence: 0.85,
      );
      
      // Act & Assert
      expect(
        () => tracker.compareReports(report1, report2),
        throwsA(isA<ArgumentError>()),
      );
    });
    
    // ==================== TEST CASE 6: Garden-wide Comparison ====================
    
    test('should compare multiple reports for a whole garden', () {
      // Arrange
      final oldReports = [
        _createMockReport(
          plantId: 'tomato_1',
          plantName: 'Tomato',
          intelligenceScore: 65.0,
          confidence: 0.8,
        ),
        _createMockReport(
          plantId: 'pepper_1',
          plantName: 'Pepper',
          intelligenceScore: 80.0,
          confidence: 0.85,
        ),
        _createMockReport(
          plantId: 'lettuce_1',
          plantName: 'Lettuce',
          intelligenceScore: 70.0,
          confidence: 0.75,
        ),
      ];
      
      final newReports = [
        _createMockReport(
          plantId: 'tomato_1',
          plantName: 'Tomato',
          intelligenceScore: 75.0, // Improved
          confidence: 0.85,
        ),
        _createMockReport(
          plantId: 'pepper_1',
          plantName: 'Pepper',
          intelligenceScore: 75.0, // Degraded
          confidence: 0.80,
        ),
        // lettuce_1 removed from garden
        _createMockReport(
          plantId: 'carrot_1', // New plant
          plantName: 'Carrot',
          intelligenceScore: 85.0,
          confidence: 0.9,
        ),
      ];
      
      // Act
      final summaries = tracker.compareGardenReports(oldReports, newReports);
      
      // Assert
      expect(summaries, hasLength(2)); // Only tomato and pepper (common plants)
      
      final tomatoSummary = summaries.firstWhere((s) => s.plantId == 'tomato_1');
      expect(tomatoSummary.isImproved, isTrue);
      expect(tomatoSummary.scoreDelta, 10.0);
      
      final pepperSummary = summaries.firstWhere((s) => s.plantId == 'pepper_1');
      expect(pepperSummary.isDegraded, isTrue);
      expect(pepperSummary.scoreDelta, -5.0);
    });
    
    // ==================== TEST CASE 7: Tolerance Threshold ====================
    
    test('should ignore changes within tolerance threshold', () {
      // Arrange
      final trackerWithHighTolerance = PlantIntelligenceEvolutionTracker(
        enableLogging: false,
        toleranceThreshold: 5.0, // 5% tolerance
      );
      
      final oldReport = _createMockReport(
        plantId: 'basil_1',
        plantName: 'Basil',
        intelligenceScore: 70.0,
        confidence: 0.8,
      );
      
      final newReport = _createMockReport(
        plantId: 'basil_1',
        plantName: 'Basil',
        intelligenceScore: 72.0, // +2 (within 5% tolerance)
        confidence: 0.82, // +0.02
      );
      
      // Act
      final summary = trackerWithHighTolerance.compareReports(oldReport, newReport);
      
      // Assert
      expect(summary.scoreDelta, 0.0); // Within tolerance, so normalized to 0
      expect(summary.isStable, isTrue);
    });
    
    // ==================== TEST CASE 8: Extension Methods ====================
    
    test('extension methods should provide helpful utilities', () {
      // Arrange
      final oldReport = _createMockReport(
        plantId: 'tomato_1',
        plantName: 'Tomato',
        intelligenceScore: 65.0,
        confidence: 0.8,
        generatedAt: DateTime(2025, 10, 10, 10, 0),
      );
      
      final newReport = _createMockReport(
        plantId: 'tomato_1',
        plantName: 'Tomato',
        intelligenceScore: 80.0,
        confidence: 0.85,
        generatedAt: DateTime(2025, 10, 12, 10, 0), // 2 days later
      );
      
      final summary = tracker.compareReports(oldReport, newReport);
      
      // Act & Assert
      expect(summary.statusText, 'AmÃ©lioration');
      expect(summary.statusEmoji, 'ðŸ“ˆ');
      expect(summary.description, contains('amÃ©lioration'));
      expect(summary.description, contains('Tomato'));
      expect(summary.hasSignificantChanges, isTrue);
      expect(summary.timeBetweenReports, const Duration(days: 2));
      expect(summary.timeBetweenReportsText, '2 jours');
    });
  });
}

// ==================== HELPER FUNCTIONS ====================

/// Creates a mock PlantIntelligenceReport for testing
PlantIntelligenceReport _createMockReport({
  required String plantId,
  required String plantName,
  required double intelligenceScore,
  required double confidence,
  List<Recommendation>? recommendations,
  double? timingScore,
  DateTime? generatedAt,
}) {
  return PlantIntelligenceReport(
    id: 'report_$plantId',
    plantId: plantId,
    plantName: plantName,
    gardenId: 'test_garden',
    analysis: _createMockAnalysis(),
    recommendations: recommendations ?? [],
    plantingTiming: timingScore != null
        ? PlantingTimingEvaluation(
            isOptimalTime: timingScore >= 70,
            timingScore: timingScore,
            reason: 'Test timing evaluation',
          )
        : null,
    intelligenceScore: intelligenceScore,
    confidence: confidence,
    generatedAt: generatedAt ?? DateTime.now(),
    expiresAt: (generatedAt ?? DateTime.now()).add(const Duration(hours: 6)),
  );
}

/// Creates a mock PlantAnalysisResult for testing
PlantAnalysisResult _createMockAnalysis() {
  final now = DateTime.now();
  return PlantAnalysisResult(
    id: const Uuid().v4(),
    plantId: 'test_plant',
    temperature: PlantCondition(
      id: const Uuid().v4(),
      plantId: 'test_plant',
      type: ConditionType.temperature,
      status: ConditionStatus.good,
      value: 22.0,
      optimalValue: 22.0,
      minValue: 18.0,
      maxValue: 28.0,
      unit: 'Â°C',
      description: 'Temperature is good',
      measuredAt: now,
    ),
    humidity: PlantCondition(
      id: const Uuid().v4(),
      plantId: 'test_plant',
      type: ConditionType.humidity,
      status: ConditionStatus.good,
      value: 65.0,
      optimalValue: 65.0,
      minValue: 50.0,
      maxValue: 80.0,
      unit: '%',
      description: 'Humidity is good',
      measuredAt: now,
    ),
    light: PlantCondition(
      id: const Uuid().v4(),
      plantId: 'test_plant',
      type: ConditionType.light,
      status: ConditionStatus.good,
      value: 5000.0,
      optimalValue: 5000.0,
      minValue: 3000.0,
      maxValue: 8000.0,
      unit: 'lux',
      description: 'Light is good',
      measuredAt: now,
    ),
    soil: PlantCondition(
      id: const Uuid().v4(),
      plantId: 'test_plant',
      type: ConditionType.soil,
      status: ConditionStatus.good,
      value: 6.5,
      optimalValue: 6.5,
      minValue: 6.0,
      maxValue: 7.0,
      unit: 'pH',
      description: 'Soil is good',
      measuredAt: now,
    ),
    overallHealth: ConditionStatus.good,
    healthScore: 75.0,
    confidence: 0.9,
    warnings: [],
    strengths: ['Good overall health'],
    priorityActions: [],
    analyzedAt: now,
  );
}

/// Creates a mock Recommendation for testing
Recommendation _createMockRecommendation({
  required String title,
  required RecommendationPriority priority,
  RecommendationStatus status = RecommendationStatus.pending,
}) {
  return Recommendation(
    id: 'rec_${title.replaceAll(' ', '_')}',
    plantId: 'test_plant',
    type: RecommendationType.general,
    priority: priority,
    title: title,
    description: 'Test recommendation: $title',
    instructions: ['Step 1', 'Step 2'],
    expectedImpact: 50.0,
    effortRequired: 30.0,
    estimatedCost: 20.0,
    status: status,
  );
}


