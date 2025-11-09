/// Helpers rÃ©utilisables pour les tests d'Intelligence VÃ©gÃ©tale
/// 
/// Ce fichier fournit des fonctions helper pour crÃ©er des objets mock
/// utilisÃ©s dans les tests unitaires et d'intÃ©gration.

library plant_intelligence_test_helpers;

import '../test_setup_stub.dart';

import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';

// ==================== PLANTES ====================

/// CrÃ©e une plante mock pour les tests
/// 
/// Permet de personnaliser les paramÃ¨tres principaux :
/// - [id] : Identifiant unique de la plante
/// - [commonName] : Nom commun
/// - [sowingMonths] : Mois de semis (abrÃ©viation)
/// - [harvestMonths] : Mois de rÃ©colte
/// - [waterNeeds] : Besoins en eau (Faible/Moyen/Ã‰levÃ©)
/// - [sunExposure] : Exposition solaire
/// - [metadata] : MÃ©tadonnÃ©es personnalisÃ©es
PlantFreezed createMockPlant({
  String id = 'tomato',
  String commonName = 'Tomate',
  List<String> sowingMonths = const ['M', 'A', 'M'],
  List<String> harvestMonths = const ['J', 'J', 'A'],
  String waterNeeds = 'Moyen',
  String sunExposure = 'Plein soleil',
  Map<String, dynamic>? metadata,
}) {
  return PlantFreezed(
    id: id,
    commonName: commonName,
    scientificName: 'Solanum lycopersicum',
    family: 'Solanaceae',
    plantingSeason: 'Printemps',
    harvestSeason: 'Ã‰tÃ©',
    daysToMaturity: 80,
    spacing: 60,
    depth: 0.5,
    sunExposure: sunExposure,
    waterNeeds: waterNeeds,
    description: 'Test plant for $commonName',
    sowingMonths: sowingMonths,
    harvestMonths: harvestMonths,
    metadata: metadata ?? {
      'germination': {
        'optimalTemperature': {'min': 18, 'max': 25},
      },
      'frostSensitive': false,
    },
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

/// CrÃ©e une plante sensible au gel
PlantFreezed createFrostSensitivePlant({
  String id = 'tomato_frost',
  String commonName = 'Tomate (sensible gel)',
}) {
  return createMockPlant(
    id: id,
    commonName: commonName,
    metadata: {
      'germination': {
        'optimalTemperature': {'min': 18, 'max': 25},
      },
      'frostSensitive': true,
    },
  );
}

// ==================== MÃ‰TÃ‰O ====================

/// CrÃ©e des conditions mÃ©tÃ©o mock
/// 
/// ParamÃ¨tres :
/// - [temperature] : TempÃ©rature en Â°C
/// - [measuredAt] : Date de mesure (dÃ©faut: maintenant)
WeatherCondition createMockWeather({
  double temperature = 20.0,
  DateTime? measuredAt,
}) {
  return WeatherCondition(
    id: 'weather_test_${DateTime.now().millisecondsSinceEpoch}',
    type: WeatherType.temperature,
    value: temperature,
    unit: 'Â°C',
    description: 'TempÃ©rature de test: ${temperature.toStringAsFixed(1)}Â°C',
    measuredAt: measuredAt ?? DateTime.now(),
    createdAt: DateTime.now(),
  );
}

/// CrÃ©e des conditions mÃ©tÃ©o avec risque de gel
WeatherCondition createFrostWeather({
  double temperature = 2.0,
}) {
  return createMockWeather(temperature: temperature);
}

/// CrÃ©e des conditions mÃ©tÃ©o de canicule
WeatherCondition createHeatWaveWeather({
  double temperature = 35.0,
}) {
  return createMockWeather(temperature: temperature);
}

// ==================== JARDIN ====================

/// CrÃ©e un contexte jardin mock
/// 
/// ParamÃ¨tres :
/// - [id] : Identifiant du jardin
/// - [ph] : pH du sol (dÃ©faut: 6.5)
/// - [soilType] : Type de sol
/// - [exposition] : Exposition solaire
GardenContext createMockGarden({
  String id = 'garden_1',
  double ph = 6.5,
  String soilType = 'loamy',
  String exposition = 'plein soleil',
}) {
  return GardenContext(
    gardenId: id,
    name: 'Test Garden',
    description: 'Jardin de test pour les tests unitaires',
    location: const GardenLocation(
      latitude: 48.8566,
      longitude: 2.3522,
      altitude: 100.0,
      address: 'Paris, France',
    ),
    soil: SoilInfo(
      type: SoilType.loamy,
      ph: ph,
      texture: SoilTexture.medium,
      organicMatter: 5.0,
      waterRetention: 0.7,
      drainage: SoilDrainage.good,
      depth: 30.0,
      nutrients: const NutrientLevels(
        nitrogen: NutrientLevel.adequate,
        phosphorus: NutrientLevel.adequate,
        potassium: NutrientLevel.adequate,
        calcium: NutrientLevel.adequate,
        magnesium: NutrientLevel.adequate,
        sulfur: NutrientLevel.adequate,
      ),
      biologicalActivity: BiologicalActivity.high,
    ),
    climate: const ClimateConditions(
      averageTemperature: 15.0,
      minTemperature: 5.0,
      maxTemperature: 25.0,
      averagePrecipitation: 600.0,
      averageHumidity: 70.0,
      frostDays: 20,
      growingSeasonLength: 180,
      dominantWindDirection: 'W',
      averageWindSpeed: 15.0,
      averageSunshineHours: 1800.0,
    ),
    activePlantIds: [],
    historicalPlantIds: [],
    stats: const GardenStats(
      totalPlants: 0,
      activePlants: 0,
      totalArea: 100.0,
      activeArea: 50.0,
      totalYield: 0.0,
      currentYearYield: 0.0,
      harvestsThisYear: 0,
      plantingsThisYear: 0,
      successRate: 0.0,
      totalInputCosts: 0.0,
      totalHarvestValue: 0.0,
    ),
    preferences: const CultivationPreferences(
      method: CultivationMethod.organic,
      usePesticides: false,
      useChemicalFertilizers: false,
      useOrganicFertilizers: true,
      cropRotation: true,
      companionPlanting: true,
      mulching: true,
      automaticIrrigation: false,
      regularMonitoring: true,
      objectives: ['sustainability', 'yield'],
    ),
    metadata: {
      'soilType': soilType,
      'exposition': exposition,
    },
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

// ==================== CONDITIONS ====================

/// CrÃ©e une PlantCondition mock
/// 
/// ParamÃ¨tres obligatoires :
/// - [plantId] : ID de la plante
/// - [type] : Type de condition (tempÃ©rature, humiditÃ©, etc.)
/// - [status] : Statut (excellent, good, fair, poor, critical)
/// 
/// ParamÃ¨tres optionnels :
/// - [value] : Valeur mesurÃ©e
/// - [optimalValue] : Valeur optimale
/// - [minValue] : Valeur minimale acceptable
/// - [maxValue] : Valeur maximale acceptable
PlantCondition createMockCondition({
  required String plantId,
  required ConditionType type,
  required ConditionStatus status,
  double value = 20.0,
  double optimalValue = 22.0,
  double minValue = 15.0,
  double maxValue = 28.0,
}) {
  String unit;
  String description;
  
  switch (type) {
    case ConditionType.temperature:
      unit = 'Â°C';
      description = 'TempÃ©rature: ${value.toStringAsFixed(1)}Â°C';
      break;
    case ConditionType.humidity:
      unit = '%';
      description = 'HumiditÃ©: ${value.toStringAsFixed(1)}%';
      break;
    case ConditionType.light:
      unit = '%';
      description = 'LuminositÃ©: ${value.toStringAsFixed(1)}%';
      break;
    case ConditionType.soil:
      unit = '%';
      description = 'QualitÃ© du sol: ${value.toStringAsFixed(1)}%';
      break;
    case ConditionType.wind:
      unit = 'km/h';
      description = 'Vent: ${value.toStringAsFixed(1)} km/h';
      break;
    case ConditionType.water:
      unit = 'L';
      description = 'Eau: ${value.toStringAsFixed(1)} L';
      break;
  }
  
  return PlantCondition(
    id: 'mock_${type.toString()}_${DateTime.now().millisecondsSinceEpoch}',
    plantId: plantId,
    type: type,
    status: status,
    value: value,
    optimalValue: optimalValue,
    minValue: minValue,
    maxValue: maxValue,
    unit: unit,
    description: description,
    recommendations: status == ConditionStatus.critical 
        ? ['Action immÃ©diate requise'] 
        : ['Surveillance recommandÃ©e'],
    measuredAt: DateTime.now(),
    createdAt: DateTime.now(),
  );
}

// ==================== ANALYSES ====================

/// CrÃ©e une analyse complÃ¨te avec toutes les conditions
PlantAnalysisResult createMockAnalysis({
  String plantId = 'tomato',
  ConditionStatus overallHealth = ConditionStatus.good,
  double healthScore = 80.0,
}) {
  return PlantAnalysisResult(
    id: 'analysis_${DateTime.now().millisecondsSinceEpoch}',
    plantId: plantId,
    temperature: createMockCondition(
      plantId: plantId,
      type: ConditionType.temperature,
      status: overallHealth,
      value: 22.0,
    ),
    humidity: createMockCondition(
      plantId: plantId,
      type: ConditionType.humidity,
      status: overallHealth,
      value: 70.0,
    ),
    light: createMockCondition(
      plantId: plantId,
      type: ConditionType.light,
      status: overallHealth,
      value: 80.0,
    ),
    soil: createMockCondition(
      plantId: plantId,
      type: ConditionType.soil,
      status: overallHealth,
      value: 75.0,
    ),
    overallHealth: overallHealth,
    healthScore: healthScore,
    warnings: overallHealth == ConditionStatus.critical ? ['Attention critique!'] : [],
    strengths: overallHealth == ConditionStatus.excellent ? ['Conditions optimales'] : [],
    priorityActions: overallHealth == ConditionStatus.critical ? ['Action immÃ©diate'] : [],
    confidence: 0.85,
    analyzedAt: DateTime.now(),
  );
}

/// CrÃ©e une analyse avec Ã©tat critique
PlantAnalysisResult createCriticalAnalysis({String plantId = 'tomato'}) {
  return createMockAnalysis(
    plantId: plantId,
    overallHealth: ConditionStatus.critical,
    healthScore: 25.0,
  );
}

/// CrÃ©e une analyse avec Ã©tat excellent
PlantAnalysisResult createExcellentAnalysis({String plantId = 'tomato'}) {
  return createMockAnalysis(
    plantId: plantId,
    overallHealth: ConditionStatus.excellent,
    healthScore: 95.0,
  );
}

// ==================== RECOMMANDATIONS ====================

/// CrÃ©e une recommandation mock
Recommendation createMockRecommendation({
  String plantId = 'tomato',
  RecommendationType type = RecommendationType.watering,
  RecommendationPriority priority = RecommendationPriority.medium,
  RecommendationStatus status = RecommendationStatus.pending,
}) {
  return Recommendation(
    id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
    plantId: plantId,
    type: type,
    priority: priority,
    title: 'Recommandation de test',
    description: 'Description de la recommandation',
    status: status,
    instructions: ['Ã‰tape 1', 'Ã‰tape 2'],
    expectedImpact: 70,
    effortRequired: 50,
    estimatedCost: 20,
    estimatedDuration: const Duration(hours: 1),
    deadline: DateTime.now().add(const Duration(days: 7)),
    requiredTools: ['Outil 1'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

/// CrÃ©e une recommandation critique
Recommendation createCriticalRecommendation({String plantId = 'tomato'}) {
  return createMockRecommendation(
    plantId: plantId,
    priority: RecommendationPriority.critical,
    type: RecommendationType.weatherProtection,
  );
}

// ==================== RAPPORTS ====================

/// CrÃ©e un rapport d'intelligence complet
PlantIntelligenceReport createMockReport({
  String plantId = 'tomato',
  String gardenId = 'garden_1',
  PlantAnalysisResult? analysis,
  List<Recommendation>? recommendations,
}) {
  return PlantIntelligenceReport(
    id: 'report_${DateTime.now().millisecondsSinceEpoch}',
    plantId: plantId,
    plantName: 'Tomate',
    gardenId: gardenId,
    analysis: analysis ?? createMockAnalysis(plantId: plantId),
    recommendations: recommendations ?? [
      createMockRecommendation(plantId: plantId),
    ],
    plantingTiming: const PlantingTimingEvaluation(
      isOptimalTime: true,
      timingScore: 85.0,
      reason: 'PÃ©riode de semis idÃ©ale',
      optimalPlantingDate: null,
      favorableFactors: ['TempÃ©rature optimale'],
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

/// CrÃ©e un rapport avec Ã©tat critique
PlantIntelligenceReport createCriticalReport({
  String plantId = 'tomato',
  String gardenId = 'garden_1',
}) {
  return createMockReport(
    plantId: plantId,
    gardenId: gardenId,
    analysis: createCriticalAnalysis(plantId: plantId),
    recommendations: [
      createCriticalRecommendation(plantId: plantId),
    ],
  );
}

