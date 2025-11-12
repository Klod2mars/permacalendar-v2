import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';

void main() {
  group('PlantAnalysisResult', () {
    test('should create a valid PlantAnalysisResult', () {
      final result = PlantAnalysisResult(
        id: 'test_1',
        plantId: 'tomato',
        temperature: _createMockCondition(ConditionStatus.good, ConditionType.temperature),
        humidity: _createMockCondition(ConditionStatus.excellent, ConditionType.humidity),
        light: _createMockCondition(ConditionStatus.good, ConditionType.light),
        soil: _createMockCondition(ConditionStatus.fair, ConditionType.soil),
        overallHealth: ConditionStatus.good,
        healthScore: 75.0,
        warnings: ['Surveiller l\'arrosage'],
        strengths: ['Température optimale'],
        priorityActions: [],
        confidence: 0.85,
        analyzedAt: DateTime.now(),
      );
      
      expect(result.isHealthy, true);
      expect(result.isCritical, false);
      expect(result.healthScore, 75.0);
      expect(result.warnings.length, 1);
      expect(result.strengths.length, 1);
    });
    
    test('should detect critical status correctly', () {
      final result = PlantAnalysisResult(
        id: 'test_2',
        plantId: 'tomato',
        temperature: _createMockCondition(ConditionStatus.critical, ConditionType.temperature),
        humidity: _createMockCondition(ConditionStatus.poor, ConditionType.humidity),
        light: _createMockCondition(ConditionStatus.fair, ConditionType.light),
        soil: _createMockCondition(ConditionStatus.fair, ConditionType.soil),
        overallHealth: ConditionStatus.critical,
        healthScore: 30.0,
        warnings: ['Température critique!'],
        strengths: [],
        priorityActions: ['Protéger du gel immédiatement'],
        confidence: 0.90,
        analyzedAt: DateTime.now(),
      );
      
      expect(result.isCritical, true);
      expect(result.isHealthy, false);
      expect(result.criticalConditionsCount, 1);
      expect(result.priorityActions.length, 1);
    });
    
    test('should calculate criticalConditionsCount correctly', () {
      final result = PlantAnalysisResult(
        id: 'test_3',
        plantId: 'tomato',
        temperature: _createMockCondition(ConditionStatus.critical, ConditionType.temperature),
        humidity: _createMockCondition(ConditionStatus.critical, ConditionType.humidity),
        light: _createMockCondition(ConditionStatus.good, ConditionType.light),
        soil: _createMockCondition(ConditionStatus.excellent, ConditionType.soil),
        overallHealth: ConditionStatus.critical,
        healthScore: 35.0,
        warnings: ['Température critique!', 'Humidité critique!'],
        strengths: [],
        priorityActions: ['Action immédiate requise'],
        confidence: 0.85,
        analyzedAt: DateTime.now(),
      );
      
      expect(result.criticalConditionsCount, 2);
      expect(result.isCritical, true);
    });
    
    test('should identify most critical condition', () {
      final criticalTemp = _createMockCondition(ConditionStatus.critical, ConditionType.temperature);
      final poorHumidity = _createMockCondition(ConditionStatus.poor, ConditionType.humidity);
      final goodLight = _createMockCondition(ConditionStatus.good, ConditionType.light);
      final excellentSoil = _createMockCondition(ConditionStatus.excellent, ConditionType.soil);
      
      final result = PlantAnalysisResult(
        id: 'test_4',
        plantId: 'tomato',
        temperature: criticalTemp,
        humidity: poorHumidity,
        light: goodLight,
        soil: excellentSoil,
        overallHealth: ConditionStatus.critical,
        healthScore: 40.0,
        warnings: ['Température critique!'],
        strengths: ['Sol excellent'],
        priorityActions: ['Réguler température'],
        confidence: 0.80,
        analyzedAt: DateTime.now(),
      );
      
      expect(result.mostCriticalCondition.type, ConditionType.temperature);
      expect(result.mostCriticalCondition.status, ConditionStatus.critical);
    });
    
    test('should detect healthy status correctly', () {
      final result = PlantAnalysisResult(
        id: 'test_5',
        plantId: 'tomato',
        temperature: _createMockCondition(ConditionStatus.excellent, ConditionType.temperature),
        humidity: _createMockCondition(ConditionStatus.good, ConditionType.humidity),
        light: _createMockCondition(ConditionStatus.excellent, ConditionType.light),
        soil: _createMockCondition(ConditionStatus.good, ConditionType.soil),
        overallHealth: ConditionStatus.excellent,
        healthScore: 92.0,
        warnings: [],
        strengths: ['Toutes les conditions optimales'],
        priorityActions: [],
        confidence: 0.95,
        analyzedAt: DateTime.now(),
      );
      
      expect(result.isHealthy, true);
      expect(result.isCritical, false);
      expect(result.criticalConditionsCount, 0);
      expect(result.healthScore, greaterThan(90.0));
    });
    
    test('should provide correct metadata', () {
      final result = PlantAnalysisResult(
        id: 'test_6',
        plantId: 'tomato',
        temperature: _createMockCondition(ConditionStatus.good, ConditionType.temperature),
        humidity: _createMockCondition(ConditionStatus.good, ConditionType.humidity),
        light: _createMockCondition(ConditionStatus.good, ConditionType.light),
        soil: _createMockCondition(ConditionStatus.good, ConditionType.soil),
        overallHealth: ConditionStatus.good,
        healthScore: 80.0,
        warnings: ['Test warning'],
        strengths: ['Test strength'],
        priorityActions: ['Test action'],
        confidence: 0.88,
        analyzedAt: DateTime.now(),
        metadata: {'testKey': 'testValue', 'weatherAge': 2},
      );
      
      expect(result.metadata['testKey'], 'testValue');
      expect(result.metadata['weatherAge'], 2);
      expect(result.metadata.isEmpty, false);
    });
  });
}

/// Helper pour créer une PlantCondition mock
PlantCondition _createMockCondition(ConditionStatus status, ConditionType type) {
  return PlantCondition(
    id: 'mock_${type.name}',
    plantId: 'test',
    type: type,
    status: status,
    value: 20.0,
    optimalValue: 22.0,
    minValue: 15.0,
    maxValue: 28.0,
    unit: _getUnitForType(type),
    description: 'Test condition',
    recommendations: [],
    measuredAt: DateTime.now(),
    createdAt: DateTime.now(),
  );
}

/// Helper pour obtenir l'unité selon le type
String _getUnitForType(ConditionType type) {
  switch (type) {
    case ConditionType.temperature:
      return '°C';
    case ConditionType.humidity:
    case ConditionType.light:
    case ConditionType.soil:
    case ConditionType.water:
      return '%';
    case ConditionType.wind:
      return 'km/h';
  }
}

