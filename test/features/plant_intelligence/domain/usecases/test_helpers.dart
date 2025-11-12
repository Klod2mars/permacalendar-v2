import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';

/// Crée une plante mock pour les tests
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
    description: 'Test plant',
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

/// Crée des conditions météo mock
WeatherCondition createMockWeather({
  double temperature = 20.0,
  DateTime? measuredAt,
}) {
  return WeatherCondition(
    id: 'weather_test',
    type: WeatherType.temperature,
    value: temperature,
    unit: '°C',
    description: 'Test weather',
    measuredAt: measuredAt ?? DateTime.now(),
    createdAt: DateTime.now(),
  );
}

/// Crée un contexte jardin mock
GardenContext createMockGarden({
  String id = 'garden_1',
  double ph = 6.5,
  String soilType = 'loamy',
  String exposition = 'plein soleil',
}) {
  return GardenContext(
    gardenId: id,
    name: 'Test Garden',
    description: 'Test description',
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

/// Crée une PlantCondition mock
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
    recommendations: ['Test recommendation'],
    measuredAt: DateTime.now(),
    createdAt: DateTime.now(),
  );
}

/// Crée un PlantIntelligenceReport mock pour les tests
PlantIntelligenceReport createMockReport({
  required String plantId,
  required String gardenId,
  String plantName = 'Tomate',
  double intelligenceScore = 75.0,
  double confidence = 0.85,
}) {
  // Create mock analysis
  final analysis = PlantAnalysisResult(
    id: 'analysis_${DateTime.now().millisecondsSinceEpoch}',
    plantId: plantId,
    overallHealth: ConditionStatus.good,
    healthScore: intelligenceScore * 0.9,
    confidence: confidence,
    temperature: createMockCondition(
      plantId: plantId,
      type: ConditionType.temperature,
      status: ConditionStatus.good,
    ),
    humidity: createMockCondition(
      plantId: plantId,
      type: ConditionType.humidity,
      status: ConditionStatus.good,
    ),
    light: createMockCondition(
      plantId: plantId,
      type: ConditionType.light,
      status: ConditionStatus.good,
    ),
    soil: createMockCondition(
      plantId: plantId,
      type: ConditionType.soil,
      status: ConditionStatus.good,
    ),
    warnings: [],
    strengths: ['Good temperature', 'Good humidity'],
    priorityActions: [],
    analyzedAt: DateTime.now(),
  );

  // Create mock timing
  const timing = PlantingTimingEvaluation(
    isOptimalTime: true,
    timingScore: 85.0,
    reason: 'Bonne période de plantation',
    favorableFactors: ['Température optimale', 'Saison appropriée'],
  );

  return PlantIntelligenceReport(
    id: 'report_${DateTime.now().millisecondsSinceEpoch}',
    plantId: plantId,
    plantName: plantName,
    gardenId: gardenId,
    analysis: analysis,
    recommendations: [],
    plantingTiming: timing,
    activeAlerts: [],
    intelligenceScore: intelligenceScore,
    confidence: confidence,
    generatedAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(hours: 6)),
    metadata: {},
  );
}


