import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/notification_alert.dart';

void main() {
  group('PlantIntelligenceReport', () {
    test('should create valid PlantIntelligenceReport', () {
      final report = _createMockReport();
      
      expect(report.id, isNotEmpty);
      expect(report.plantId, 'tomato');
      expect(report.plantName, 'Tomate');
      expect(report.gardenId, 'garden_1');
      expect(report.analysis, isNotNull);
      expect(report.recommendations, isNotEmpty);
      expect(report.intelligenceScore, greaterThanOrEqualTo(0.0));
      expect(report.intelligenceScore, lessThanOrEqualTo(100.0));
      expect(report.confidence, greaterThanOrEqualTo(0.0));
      expect(report.confidence, lessThanOrEqualTo(1.0));
    });
    
    test('should detect urgent action requirement correctly', () {
      // Rapport avec analyse critique
      final criticalReport = PlantIntelligenceReport(
        id: 'report_1',
        plantId: 'tomato',
        plantName: 'Tomate',
        gardenId: 'garden_1',
        analysis: _createCriticalAnalysis(),
        recommendations: [],
        plantingTiming: null,
        activeAlerts: [],
        intelligenceScore: 30.0,
        confidence: 0.9,
        generatedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 6)),
      );
      
      expect(criticalReport.requiresUrgentAction, isTrue);
    });
    
    test('should detect urgent action when critical alerts present', () {
      final reportWithAlerts = PlantIntelligenceReport(
        id: 'report_2',
        plantId: 'tomato',
        plantName: 'Tomate',
        gardenId: 'garden_1',
        analysis: _createHealthyAnalysis(),
        recommendations: [],
        plantingTiming: null,
        activeAlerts: [_createCriticalAlert()],
        intelligenceScore: 80.0,
        confidence: 0.9,
        generatedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 6)),
      );
      
      expect(reportWithAlerts.requiresUrgentAction, isTrue);
    });
    
    test('should filter recommendations by priority', () {
      final report = _createMockReport();
      
      final criticalRecs = report.getRecommendationsByPriority(RecommendationPriority.critical);
      expect(criticalRecs, isNotEmpty);
      expect(criticalRecs.every((r) => r.priority == RecommendationPriority.critical), isTrue);
      
      final highRecs = report.getRecommendationsByPriority(RecommendationPriority.high);
      expect(highRecs.every((r) => r.priority == RecommendationPriority.high), isTrue);
    });
    
    test('should identify pending recommendations', () {
      final report = _createMockReport();
      
      final pending = report.pendingRecommendations;
      expect(pending, isNotEmpty);
      expect(pending.every((r) => r.status == RecommendationStatus.pending), isTrue);
    });
    
    test('should check expiration correctly', () {
      final expiredReport = PlantIntelligenceReport(
        id: 'report_3',
        plantId: 'tomato',
        plantName: 'Tomate',
        gardenId: 'garden_1',
        analysis: _createHealthyAnalysis(),
        recommendations: [],
        plantingTiming: null,
        activeAlerts: [],
        intelligenceScore: 80.0,
        confidence: 0.9,
        generatedAt: DateTime.now().subtract(const Duration(hours: 8)),
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      
      expect(expiredReport.isExpired, isTrue);
      expect(expiredReport.remainingValidity.isNegative, isTrue);
    });
    
    test('should calculate remaining validity correctly', () {
      final futureExpiration = DateTime.now().add(const Duration(hours: 3));
      final report = PlantIntelligenceReport(
        id: 'report_4',
        plantId: 'tomato',
        plantName: 'Tomate',
        gardenId: 'garden_1',
        analysis: _createHealthyAnalysis(),
        recommendations: [],
        plantingTiming: null,
        activeAlerts: [],
        intelligenceScore: 80.0,
        confidence: 0.9,
        generatedAt: DateTime.now(),
        expiresAt: futureExpiration,
      );
      
      expect(report.isExpired, isFalse);
      expect(report.remainingValidity.inHours, closeTo(3, 1));
    });
  });
  
  group('PlantingTimingEvaluation', () {
    test('should create valid PlantingTimingEvaluation', () {
      const evaluation = PlantingTimingEvaluation(
        isOptimalTime: true,
        timingScore: 85.0,
        reason: 'Conditions optimales pour la plantation',
        optimalPlantingDate: null,
        favorableFactors: ['Température optimale', 'Période de semis'],
        unfavorableFactors: [],
        risks: [],
      );
      
      expect(evaluation.isOptimalTime, isTrue);
      expect(evaluation.timingScore, 85.0);
      expect(evaluation.favorableFactors, isNotEmpty);
      expect(evaluation.unfavorableFactors, isEmpty);
      expect(evaluation.risks, isEmpty);
    });
    
    test('should provide optimal planting date when not optimal', () {
      final futureDate = DateTime.now().add(const Duration(days: 30));
      final evaluation = PlantingTimingEvaluation(
        isOptimalTime: false,
        timingScore: 40.0,
        reason: 'Hors période de semis',
        optimalPlantingDate: futureDate,
        favorableFactors: [],
        unfavorableFactors: ['Hors période de semis', 'Température trop basse'],
        risks: ['Risque de gel'],
      );
      
      expect(evaluation.isOptimalTime, isFalse);
      expect(evaluation.optimalPlantingDate, isNotNull);
      expect(evaluation.optimalPlantingDate!.isAfter(DateTime.now()), isTrue);
      expect(evaluation.risks, isNotEmpty);
    });
  });
}

// ==================== HELPERS ====================

PlantIntelligenceReport _createMockReport() {
  return PlantIntelligenceReport(
    id: 'report_test',
    plantId: 'tomato',
    plantName: 'Tomate',
    gardenId: 'garden_1',
    analysis: _createHealthyAnalysis(),
    recommendations: [
      _createCriticalRecommendation(),
      _createHighRecommendation(),
      _createMediumRecommendation(),
    ],
    plantingTiming: const PlantingTimingEvaluation(
      isOptimalTime: true,
      timingScore: 85.0,
      reason: 'Période de semis idéale',
      optimalPlantingDate: null,
      favorableFactors: ['Température optimale', 'Période de semis'],
      unfavorableFactors: [],
      risks: [],
    ),
    activeAlerts: [],
    intelligenceScore: 85.0,
    confidence: 0.9,
    generatedAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(hours: 6)),
  );
}

PlantAnalysisResult _createHealthyAnalysis() {
  return PlantAnalysisResult(
    id: 'analysis_1',
    plantId: 'tomato',
    temperature: _createMockCondition(ConditionStatus.good, ConditionType.temperature),
    humidity: _createMockCondition(ConditionStatus.good, ConditionType.humidity),
    light: _createMockCondition(ConditionStatus.good, ConditionType.light),
    soil: _createMockCondition(ConditionStatus.good, ConditionType.soil),
    overallHealth: ConditionStatus.good,
    healthScore: 80.0,
    warnings: [],
    strengths: ['Conditions optimales'],
    priorityActions: [],
    confidence: 0.9,
    analyzedAt: DateTime.now(),
  );
}

PlantAnalysisResult _createCriticalAnalysis() {
  return PlantAnalysisResult(
    id: 'analysis_2',
    plantId: 'tomato',
    temperature: _createMockCondition(ConditionStatus.critical, ConditionType.temperature),
    humidity: _createMockCondition(ConditionStatus.poor, ConditionType.humidity),
    light: _createMockCondition(ConditionStatus.fair, ConditionType.light),
    soil: _createMockCondition(ConditionStatus.fair, ConditionType.soil),
    overallHealth: ConditionStatus.critical,
    healthScore: 30.0,
    warnings: ['Température critique!'],
    strengths: [],
    priorityActions: ['Protection immédiate requise'],
    confidence: 0.9,
    analyzedAt: DateTime.now(),
  );
}

PlantCondition _createMockCondition(ConditionStatus status, ConditionType type) {
  return PlantCondition(
    id: 'condition_${type.toString()}',
    plantId: 'tomato',
    type: type,
    status: status,
    value: 20.0,
    optimalValue: 22.0,
    minValue: 15.0,
    maxValue: 28.0,
    unit: _getUnitForType(type),
    description: 'Test condition',
    recommendations: ['Test recommendation'],
    measuredAt: DateTime.now(),
    createdAt: DateTime.now(),
  );
}

String _getUnitForType(ConditionType type) {
  switch (type) {
    case ConditionType.temperature:
      return '°C';
    case ConditionType.humidity:
      return '%';
    case ConditionType.light:
      return 'lux';
    case ConditionType.soil:
      return 'pH';
    default:
      return '';
  }
}

Recommendation _createCriticalRecommendation() {
  return Recommendation(
    id: 'rec_critical',
    plantId: 'tomato',
    type: RecommendationType.weatherProtection,
    priority: RecommendationPriority.critical,
    title: 'Protéger du gel',
    description: 'Température critique détectée',
    status: RecommendationStatus.pending,
    instructions: ['Installer voile d\'hivernage'],
    expectedImpact: 90,
    effortRequired: 50,
    estimatedCost: 30,
    estimatedDuration: const Duration(hours: 1),
    deadline: DateTime.now().add(const Duration(hours: 12)),
    requiredTools: ['Voile d\'hivernage'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

Recommendation _createHighRecommendation() {
  return Recommendation(
    id: 'rec_high',
    plantId: 'tomato',
    type: RecommendationType.watering,
    priority: RecommendationPriority.high,
    title: 'Arroser',
    description: 'Sol légèrement sec',
    status: RecommendationStatus.pending,
    instructions: ['Arroser 2L'],
    expectedImpact: 70,
    effortRequired: 20,
    estimatedCost: 5,
    estimatedDuration: const Duration(minutes: 15),
    deadline: DateTime.now().add(const Duration(days: 1)),
    requiredTools: ['Arrosoir'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

Recommendation _createMediumRecommendation() {
  return Recommendation(
    id: 'rec_medium',
    plantId: 'tomato',
    type: RecommendationType.fertilizing,
    priority: RecommendationPriority.medium,
    title: 'Fertiliser',
    description: 'Apport de nutriments recommandé',
    status: RecommendationStatus.pending,
    instructions: ['Ajouter compost'],
    expectedImpact: 50,
    effortRequired: 40,
    estimatedCost: 20,
    estimatedDuration: const Duration(minutes: 30),
    deadline: DateTime.now().add(const Duration(days: 7)),
    requiredTools: ['Compost'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

NotificationAlert _createCriticalAlert() {
  return NotificationAlert(
    id: 'alert_1',
    type: NotificationType.weatherAlert,
    priority: NotificationPriority.critical,
    title: 'Alerte gel',
    message: 'Risque de gel cette nuit',
    plantId: 'tomato',
    gardenId: 'garden_1',
    createdAt: DateTime.now(),
    readAt: null,
  );
}


