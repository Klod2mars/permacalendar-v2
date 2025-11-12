/// Helpers réutilisables pour les tests d'Intelligence Végétale
/// 
/// Ce fichier fournit des fonctions helper pour créer des objets mock
/// utilisés dans les tests unitaires et d'intégration.
library plant_intelligence_test_helpers;

import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';

// ==================== PLANTES ====================

/// Crée une plante mock pour les tests
/// 
/// Permet de personnaliser les paramètres principaux :
/// - [id] : Identifiant unique de la plante
/// - [commonName] : Nom commun
/// - [sowingMonths] : Mois de semis (abréviation)
/// - [harvestMonths] : Mois de récolte
/// - [waterNeeds] : Besoins en eau (Faible/Moyen/Élevé)
/// - [sunExposure] : Exposition solaire
/// - [metadata] : Métadonnées personnalisées
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
    harvestSeason: 'Été',
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

/// Crée une plante sensible au gel
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

// ==================== MÉTÉO ====================

/// Crée des conditions météo mock
/// 
/// Paramètres :
/// - [temperature] : Température en °C
/// - [measuredAt] : Date de mesure (défaut: maintenant)
WeatherCondition createMockWeather({
  double temperature = 20.0,
  DateTime? measuredAt,
}) {
  return WeatherCondition(
    id: 'weather_test_${DateTime.now().millisecondsSinceEpoch}',
    type: WeatherType.temperature,
    value: temperature,
    unit: '°C',
    description: 'Température de test: ${temperature.toStringAsFixed(1)}°C',
    measuredAt: measuredAt ?? DateTime.now(),
    createdAt: DateTime.now(),
  );
}

/// Crée des conditions météo avec risque de gel
WeatherCondition createFrostWeather({
  double temperature = 2.0,
}) {
  return createMockWeather(temperature: temperature);
}

/// Crée des conditions météo de canicule
WeatherCondition createHeatWaveWeather({
  double temperature = 35.0,
}) {
  return createMockWeather(temperature: temperature);
}

// ==================== JARDIN ====================

/// Crée un contexte jardin mock
/// 
/// Paramètres :
/// - [id] : Identifiant du jardin
/// - [ph] : pH du sol (défaut: 6.5)
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

/// Crée une PlantCondition mock
/// 
/// Paramètres obligatoires :
/// - [plantId] : ID de la plante
/// - [type] : Type de condition (température, humidité, etc.)
/// - [status] : Statut (excellent, good, fair, poor, critical)
/// 
/// Paramètres optionnels :
/// - [value] : Valeur mesurée
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
      unit = '°C';
      description = 'Température: ${value.toStringAsFixed(1)}°C';
      break;
    case ConditionType.humidity:
      unit = '%';
      description = 'Humidité: ${value.toStringAsFixed(1)}%';
      break;
    case ConditionType.light:
      unit = '%';
      description = 'Luminosité: ${value.toStringAsFixed(1)}%';
      break;
    case ConditionType.soil:
      unit = '%';
      description = 'Qualité du sol: ${value.toStringAsFixed(1)}%';
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
        ? ['Action immédiate requise'] 
        : ['Surveillance recommandée'],
    measuredAt: DateTime.now(),
    createdAt: DateTime.now(),
  );
}

// ==================== ANALYSES ====================

/// Crée une analyse complète avec toutes les conditions
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
    priorityActions: overallHealth == ConditionStatus.critical ? ['Action immédiate'] : [],
    confidence: 0.85,
    analyzedAt: DateTime.now(),
  );
}

/// Crée une analyse avec état critique
PlantAnalysisResult createCriticalAnalysis({String plantId = 'tomato'}) {
  return createMockAnalysis(
    plantId: plantId,
    overallHealth: ConditionStatus.critical,
    healthScore: 25.0,
  );
}

/// Crée une analyse avec état excellent
PlantAnalysisResult createExcellentAnalysis({String plantId = 'tomato'}) {
  return createMockAnalysis(
    plantId: plantId,
    overallHealth: ConditionStatus.excellent,
    healthScore: 95.0,
  );
}

// ==================== RECOMMANDATIONS ====================

/// Crée une recommandation mock
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
    instructions: ['Étape 1', 'Étape 2'],
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

/// Crée une recommandation critique
Recommendation createCriticalRecommendation({String plantId = 'tomato'}) {
  return createMockRecommendation(
    plantId: plantId,
    priority: RecommendationPriority.critical,
    type: RecommendationType.weatherProtection,
  );
}

// ==================== RAPPORTS ====================

/// Crée un rapport d'intelligence complet
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
      reason: 'Période de semis idéale',
      optimalPlantingDate: null,
      favorableFactors: ['Température optimale'],
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

/// Crée un rapport avec état critique
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


