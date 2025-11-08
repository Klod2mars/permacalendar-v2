import 'package:permacalendar/core/models/plant_v2.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/models/plant_health_status.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/plant_evolution_tracker_service.dart';
import 'package:test/test.dart';

Plant _createPlant() => Plant(
      id: 'plant_1',
      name: 'Tomate',
      species: 'Solanum lycopersicum',
      family: 'Solanaceae',
      growthCycles: const ['spring'],
    );

PlantCondition _condition({
  required String plantId,
  required ConditionType type,
  required ConditionStatus status,
  required double value,
  required DateTime measuredAt,
}) {
  return PlantCondition(
    id: '${type.name}_${measuredAt.microsecondsSinceEpoch}',
    plantId: plantId,
    gardenId: 'garden_1',
    type: type,
    status: status,
    value: value,
    optimalValue: value,
    minValue: value - 5,
    maxValue: value + 5,
    unit: 'unit',
    measuredAt: measuredAt,
    createdAt: measuredAt,
    updatedAt: measuredAt,
    description: null,
    recommendations: const [],
  );
}

PlantAnalysisResult _analysis({
  required String plantId,
  required DateTime analyzedAt,
  required ConditionStatus temperature,
  required ConditionStatus humidity,
  required ConditionStatus light,
  required ConditionStatus soil,
  required double healthScore,
}) {
  return PlantAnalysisResult(
    id: 'analysis_${analyzedAt.microsecondsSinceEpoch}',
    plantId: plantId,
    temperature: _condition(
      plantId: plantId,
      type: ConditionType.temperature,
      status: temperature,
      value: 24,
      measuredAt: analyzedAt,
    ),
    humidity: _condition(
      plantId: plantId,
      type: ConditionType.humidity,
      status: humidity,
      value: 70,
      measuredAt: analyzedAt,
    ),
    light: _condition(
      plantId: plantId,
      type: ConditionType.light,
      status: light,
      value: 80,
      measuredAt: analyzedAt,
    ),
    soil: _condition(
      plantId: plantId,
      type: ConditionType.soil,
      status: soil,
      value: 65,
      measuredAt: analyzedAt,
    ),
    overallHealth: soil,
    healthScore: healthScore,
    warnings: const [],
    strengths: const [],
    priorityActions: const [],
    confidence: 0.85,
    analyzedAt: analyzedAt,
    metadata: const {},
  );
}

PlantIntelligenceReport _report({
  required String plantId,
  required double score,
  required DateTime generatedAt,
  required PlantAnalysisResult analysis,
}) {
  return PlantIntelligenceReport(
    id: 'report_${generatedAt.microsecondsSinceEpoch}',
    plantId: plantId,
    plantName: 'Tomate',
    gardenId: 'garden_1',
    analysis: analysis,
    recommendations: const [],
    plantingTiming: PlantingTimingEvaluation(
      isOptimalTime: true,
      timingScore: 80,
      reason: 'Fenêtre idéale',
      optimalPlantingDate: generatedAt,
      favorableFactors: const [],
      unfavorableFactors: const [],
      risks: const [],
    ),
    activeAlerts: const [],
    intelligenceScore: score,
    confidence: 0.9,
    generatedAt: generatedAt,
    expiresAt: generatedAt.add(const Duration(hours: 6)),
    metadata: const {},
  );
}

PlantHealthComponent _component({
  required PlantHealthFactor factor,
  required double score,
  required PlantHealthLevel level,
  String trend = 'stable',
}) {
  return PlantHealthComponent(
    factor: factor,
    score: score,
    level: level,
    trend: trend,
    value: score,
    optimalValue: score,
    minValue: score - 10,
    maxValue: score + 10,
    unit: 'unit',
  );
}

PlantHealthStatus _healthStatus({
  required String plantId,
  required double overallScore,
  required PlantHealthLevel level,
  required DateTime lastUpdated,
  Map<PlantHealthFactor, PlantHealthComponent>? overrides,
}) {
  PlantHealthComponent defaultComponent(PlantHealthFactor factor) {
    final componentScore = overallScore;
    return _component(
      factor: factor,
      score: componentScore,
      level: level,
    );
  }

  final components = <PlantHealthFactor, PlantHealthComponent>{
    for (final factor in PlantHealthFactor.values) factor: defaultComponent(factor),
    if (overrides != null) ...overrides,
  };

  return PlantHealthStatus(
    plantId: plantId,
    gardenId: 'garden_1',
    overallScore: overallScore,
    level: level,
    humidity: components[PlantHealthFactor.humidity]!,
    light: components[PlantHealthFactor.light]!,
    temperature: components[PlantHealthFactor.temperature]!,
    nutrients: components[PlantHealthFactor.nutrients]!,
    soilMoisture: components[PlantHealthFactor.soilMoisture],
    waterStress: components[PlantHealthFactor.waterStress],
    pestPressure: components[PlantHealthFactor.pestPressure],
    lastUpdated: lastUpdated,
    lastSyncedAt: lastUpdated,
    activeAlerts: const [],
    recommendedActions: const [],
    healthTrend: 'stable',
    factorTrends: const {},
    metadata: const {},
  );
}

void main() {
  group('PlantEvolutionTrackerService', () {
    test('tracks evolution for single plant across days', () {
      final service = const PlantEvolutionTrackerService();
      final plant = _createPlant();
      final baseDate = DateTime(2025, 1, 10);

      final previousAnalysis = _analysis(
        plantId: plant.id,
        analyzedAt: baseDate.subtract(const Duration(days: 2)),
        temperature: ConditionStatus.fair,
        humidity: ConditionStatus.fair,
        light: ConditionStatus.good,
        soil: ConditionStatus.fair,
        healthScore: 68,
      );

      final previousReport = _report(
        plantId: plant.id,
        score: 68,
        generatedAt: baseDate.subtract(const Duration(days: 2)),
        analysis: previousAnalysis,
      );

      final currentAnalysis = _analysis(
        plantId: plant.id,
        analyzedAt: baseDate,
        temperature: ConditionStatus.good,
        humidity: ConditionStatus.good,
        light: ConditionStatus.good,
        soil: ConditionStatus.good,
        healthScore: 80,
      );

      final currentReport = _report(
        plantId: plant.id,
        score: 80,
        generatedAt: baseDate,
        analysis: currentAnalysis,
      );

      final previousHealth = _healthStatus(
        plantId: plant.id,
        overallScore: 68,
        level: PlantHealthLevel.fair,
        lastUpdated: baseDate.subtract(const Duration(days: 2)),
      );

      final currentHealth = _healthStatus(
        plantId: plant.id,
        overallScore: 80,
        level: PlantHealthLevel.good,
        lastUpdated: baseDate,
        overrides: {
          PlantHealthFactor.humidity: _component(
            factor: PlantHealthFactor.humidity,
            score: 85,
            level: PlantHealthLevel.good,
            trend: 'up',
          ),
        },
      );

      final result = service.trackEvolution(
        plant: plant,
        currentReport: currentReport,
        currentHealthStatus: currentHealth,
        intelligenceHistory: [previousReport],
        healthHistory: [previousHealth],
      );

      expect(result, isNotNull);
      expect(result!.evolution.trend, equals('up'));
      expect(result.healthComparison.improvedFactors,
          contains(PlantHealthFactor.humidity));
      expect(result.trend.direction, equals('up'));
      expect(result.intelligenceHistory.length, equals(2));
      expect(result.healthHistory.length, equals(2));
    });

    test('detects anomalies when score drops quickly', () {
      final service = const PlantEvolutionTrackerService();
      final plant = _createPlant();
      final baseDate = DateTime(2025, 2, 1);

      final previous = _report(
        plantId: plant.id,
        score: 90,
        generatedAt: baseDate.subtract(const Duration(days: 1)),
        analysis: _analysis(
          plantId: plant.id,
          analyzedAt: baseDate.subtract(const Duration(days: 1)),
          temperature: ConditionStatus.excellent,
          humidity: ConditionStatus.good,
          light: ConditionStatus.excellent,
          soil: ConditionStatus.good,
          healthScore: 92,
        ),
      );

      final current = _report(
        plantId: plant.id,
        score: 58,
        generatedAt: baseDate,
        analysis: _analysis(
          plantId: plant.id,
          analyzedAt: baseDate,
          temperature: ConditionStatus.poor,
          humidity: ConditionStatus.poor,
          light: ConditionStatus.fair,
          soil: ConditionStatus.poor,
          healthScore: 55,
        ),
      );

      final previousHealth = _healthStatus(
        plantId: plant.id,
        overallScore: 90,
        level: PlantHealthLevel.excellent,
        lastUpdated: baseDate.subtract(const Duration(days: 1)),
      );

      final currentHealth = _healthStatus(
        plantId: plant.id,
        overallScore: 58,
        level: PlantHealthLevel.poor,
        lastUpdated: baseDate,
      );

      final result = service.trackEvolution(
        plant: plant,
        currentReport: current,
        currentHealthStatus: currentHealth,
        intelligenceHistory: [previous],
        healthHistory: [previousHealth],
      );

      expect(result, isNotNull);
      expect(result!.evolution.trend, equals('down'));
      expect(result.trend.hasAnomaly, isTrue);
      expect(result.healthComparison.degradedFactors.isNotEmpty, isTrue);
    });

    test('returns null when history is missing', () {
      final service = const PlantEvolutionTrackerService();
      final plant = _createPlant();
      final now = DateTime(2025, 3, 10);
      final analysis = _analysis(
        plantId: plant.id,
        analyzedAt: now,
        temperature: ConditionStatus.good,
        humidity: ConditionStatus.good,
        light: ConditionStatus.good,
        soil: ConditionStatus.good,
        healthScore: 82,
      );

      final report = _report(
        plantId: plant.id,
        score: 82,
        generatedAt: now,
        analysis: analysis,
      );

      final health = _healthStatus(
        plantId: plant.id,
        overallScore: 82,
        level: PlantHealthLevel.good,
        lastUpdated: now,
      );

      final result = service.trackEvolution(
        plant: plant,
        currentReport: report,
        currentHealthStatus: health,
      );

      expect(result, isNull);
    });

    test('throws when report plant does not match provided plant', () {
      final service = const PlantEvolutionTrackerService();
      final plant = _createPlant();
      final now = DateTime(2025, 4, 1);

      final analysis = _analysis(
        plantId: 'other_plant',
        analyzedAt: now,
        temperature: ConditionStatus.good,
        humidity: ConditionStatus.good,
        light: ConditionStatus.good,
        soil: ConditionStatus.good,
        healthScore: 70,
      );

      final report = _report(
        plantId: 'other_plant',
        score: 70,
        generatedAt: now,
        analysis: analysis,
      );

      final health = _healthStatus(
        plantId: plant.id,
        overallScore: 70,
        level: PlantHealthLevel.good,
        lastUpdated: now,
      );

      expect(
        () => service.trackEvolution(
          plant: plant,
          currentReport: report,
          currentHealthStatus: health,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('prunes histories according to retention window', () {
      final service = const PlantEvolutionTrackerService(
        historyRetention: Duration(days: 30),
      );
      final plant = _createPlant();
      final now = DateTime(2025, 5, 1);

      final veryOldDate = now.subtract(const Duration(days: 90));
      final recentDate = now.subtract(const Duration(days: 10));

      final veryOldReport = _report(
        plantId: plant.id,
        score: 60,
        generatedAt: veryOldDate,
        analysis: _analysis(
          plantId: plant.id,
          analyzedAt: veryOldDate,
          temperature: ConditionStatus.fair,
          humidity: ConditionStatus.fair,
          light: ConditionStatus.fair,
          soil: ConditionStatus.fair,
          healthScore: 60,
        ),
      );

      final recentReport = _report(
        plantId: plant.id,
        score: 70,
        generatedAt: recentDate,
        analysis: _analysis(
          plantId: plant.id,
          analyzedAt: recentDate,
          temperature: ConditionStatus.good,
          humidity: ConditionStatus.good,
          light: ConditionStatus.good,
          soil: ConditionStatus.good,
          healthScore: 70,
        ),
      );

      final currentReport = _report(
        plantId: plant.id,
        score: 75,
        generatedAt: now,
        analysis: _analysis(
          plantId: plant.id,
          analyzedAt: now,
          temperature: ConditionStatus.good,
          humidity: ConditionStatus.good,
          light: ConditionStatus.good,
          soil: ConditionStatus.good,
          healthScore: 75,
        ),
      );

      final veryOldHealth = _healthStatus(
        plantId: plant.id,
        overallScore: 60,
        level: PlantHealthLevel.fair,
        lastUpdated: veryOldDate,
      );

      final recentHealth = _healthStatus(
        plantId: plant.id,
        overallScore: 70,
        level: PlantHealthLevel.good,
        lastUpdated: recentDate,
      );

      final currentHealth = _healthStatus(
        plantId: plant.id,
        overallScore: 75,
        level: PlantHealthLevel.good,
        lastUpdated: now,
      );

      final result = service.trackEvolution(
        plant: plant,
        currentReport: currentReport,
        currentHealthStatus: currentHealth,
        intelligenceHistory: [veryOldReport, recentReport],
        healthHistory: [veryOldHealth, recentHealth],
      );

      expect(result, isNotNull);
      expect(result!.intelligenceHistory.length, equals(2));
      expect(result.intelligenceHistory.first.generatedAt, equals(recentDate));
      expect(result.healthHistory.length, equals(2));
      expect(result.healthHistory.first.lastUpdated, equals(recentDate));
    });
  });
}

