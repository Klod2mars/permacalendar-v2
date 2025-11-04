import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/usecases/generate_recommendations_usecase.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'test_helpers.dart';

void main() {
  group('GenerateRecommendationsUsecase', () {
    late GenerateRecommendationsUsecase usecase;
    
    setUp(() {
      usecase = const GenerateRecommendationsUsecase();
    });
    
    test('should generate critical recommendations for critical conditions', () async {
      // Arrange
      final plant = createMockPlant();
      final weather = createMockWeather(temperature: -5.0);
      final garden = createMockGarden();
      final analysisResult = _createAnalysisWithCriticalTemp(plant.id);
      
      // Act
      final recommendations = await usecase.execute(
        plant: plant,
        analysisResult: analysisResult,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(recommendations, isNotEmpty);
      expect(
        recommendations.any((r) => r.priority == RecommendationPriority.critical),
        isTrue,
      );
    });
    
    test('should generate weather-based recommendations for frost risk', () async {
      // Arrange
      final plant = createMockPlant(metadata: {'frostSensitive': true});
      final weather = createMockWeather(temperature: 2.0); // Frost risk
      final garden = createMockGarden();
      final analysisResult = _createMockAnalysis(plant.id);
      
      // Act
      final recommendations = await usecase.execute(
        plant: plant,
        analysisResult: analysisResult,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(recommendations, isNotEmpty);
      expect(
        recommendations.any((r) => r.title.toLowerCase().contains('gel')),
        isTrue,
      );
    });
    
    test('should generate seasonal recommendations for sowing period', () async {
      // Arrange
      final currentMonth = DateTime.now().month;
      final monthAbbr = _getMonthAbbreviation(currentMonth);
      final plant = createMockPlant(sowingMonths: [monthAbbr]);
      final weather = createMockWeather();
      final garden = createMockGarden();
      final analysisResult = _createMockAnalysis(plant.id);
      
      // Act
      final recommendations = await usecase.execute(
        plant: plant,
        analysisResult: analysisResult,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(recommendations, isNotEmpty);
      expect(
        recommendations.any((r) => r.type == RecommendationType.planting),
        isTrue,
      );
    });
    
    test('should generate harvest recommendations during harvest period', () async {
      // Arrange
      final currentMonth = DateTime.now().month;
      final monthAbbr = _getMonthAbbreviation(currentMonth);
      final plant = createMockPlant(harvestMonths: [monthAbbr]);
      final weather = createMockWeather();
      final garden = createMockGarden();
      final analysisResult = _createMockAnalysis(plant.id);
      
      // Act
      final recommendations = await usecase.execute(
        plant: plant,
        analysisResult: analysisResult,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(recommendations, isNotEmpty);
      expect(
        recommendations.any((r) => r.type == RecommendationType.harvesting),
        isTrue,
      );
    });
    
    test('should sort recommendations by priority', () async {
      // Arrange
      final plant = createMockPlant();
      final weather = createMockWeather(temperature: -5.0);
      final garden = createMockGarden();
      final analysisResult = _createAnalysisWithCriticalTemp(plant.id);
      
      // Act
      final recommendations = await usecase.execute(
        plant: plant,
        analysisResult: analysisResult,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      if (recommendations.length >= 2) {
        expect(
          recommendations.first.priority.index >= recommendations.last.priority.index,
          isTrue,
        );
      }
    });
    
    test('should generate historical recommendations when trends detected', () async {
      // Arrange
      final plant = createMockPlant();
      final weather = createMockWeather();
      final garden = createMockGarden();
      final analysisResult = _createMockAnalysis(plant.id);
      final historicalConditions = _createDecreasingHumidityHistory(plant.id);
      
      // Act
      final recommendations = await usecase.execute(
        plant: plant,
        analysisResult: analysisResult,
        weather: weather,
        garden: garden,
        historicalConditions: historicalConditions,
      );
      
      // Assert
      expect(recommendations, isNotEmpty);
      // La recommandation de tendance historique contient "tendance" dans le titre
      expect(
        recommendations.any((r) => r.title.toLowerCase().contains('tendance') ||
                                   r.description.toLowerCase().contains('tendance')),
        isTrue,
      );
    });
    
    test('should generate watering recommendations for critical humidity', () async {
      // Arrange
      final plant = createMockPlant();
      final weather = createMockWeather();
      final garden = createMockGarden();
      final analysisResult = _createAnalysisWithCriticalHumidity(plant.id);
      
      // Act
      final recommendations = await usecase.execute(
        plant: plant,
        analysisResult: analysisResult,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(recommendations, isNotEmpty);
      expect(
        recommendations.any((r) => r.type == RecommendationType.watering),
        isTrue,
      );
    });
    
    test('should generate recommendations with proper deadline', () async {
      // Arrange
      final plant = createMockPlant();
      final weather = createMockWeather(temperature: -5.0);
      final garden = createMockGarden();
      final analysisResult = _createAnalysisWithCriticalTemp(plant.id);
      
      // Act
      final recommendations = await usecase.execute(
        plant: plant,
        analysisResult: analysisResult,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      final criticalRecs = recommendations.where((r) => r.priority == RecommendationPriority.critical);
      if (criticalRecs.isNotEmpty) {
        expect(criticalRecs.first.deadline, isNotNull);
        expect(criticalRecs.first.deadline!.isAfter(DateTime.now()), isTrue);
      }
    });
    
    test('should generate recommendations for heat wave', () async {
      // Arrange
      final plant = createMockPlant();
      final weather = createMockWeather(temperature: 35.0); // Heat wave
      final garden = createMockGarden();
      final analysisResult = _createMockAnalysis(plant.id);
      
      // Act
      final recommendations = await usecase.execute(
        plant: plant,
        analysisResult: analysisResult,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(recommendations, isNotEmpty);
      expect(
        recommendations.any((r) => r.title.toLowerCase().contains('canicule') || 
                                   r.title.toLowerCase().contains('chaleur')),
        isTrue,
      );
    });
  });
}

// ==================== HELPER FUNCTIONS ====================

PlantAnalysisResult _createMockAnalysis(String plantId) {
  final temp = createMockCondition(
    plantId: plantId,
    type: ConditionType.temperature,
    status: ConditionStatus.good,
  );
  final humidity = createMockCondition(
    plantId: plantId,
    type: ConditionType.humidity,
    status: ConditionStatus.good,
  );
  final light = createMockCondition(
    plantId: plantId,
    type: ConditionType.light,
    status: ConditionStatus.good,
  );
  final soil = createMockCondition(
    plantId: plantId,
    type: ConditionType.soil,
    status: ConditionStatus.good,
  );
  
  return PlantAnalysisResult(
    id: 'analysis_1',
    plantId: plantId,
    temperature: temp,
    humidity: humidity,
    light: light,
    soil: soil,
    overallHealth: ConditionStatus.good,
    healthScore: 80.0,
    warnings: [],
    strengths: ['Conditions optimales'],
    priorityActions: [],
    confidence: 0.9,
    analyzedAt: DateTime.now(),
  );
}

PlantAnalysisResult _createAnalysisWithCriticalTemp(String plantId) {
  final temp = createMockCondition(
    plantId: plantId,
    type: ConditionType.temperature,
    status: ConditionStatus.critical,
    value: -5.0,
  );
  final humidity = createMockCondition(
    plantId: plantId,
    type: ConditionType.humidity,
    status: ConditionStatus.good,
  );
  final light = createMockCondition(
    plantId: plantId,
    type: ConditionType.light,
    status: ConditionStatus.good,
  );
  final soil = createMockCondition(
    plantId: plantId,
    type: ConditionType.soil,
    status: ConditionStatus.good,
  );
  
  return PlantAnalysisResult(
    id: 'analysis_2',
    plantId: plantId,
    temperature: temp,
    humidity: humidity,
    light: light,
    soil: soil,
    overallHealth: ConditionStatus.critical,
    healthScore: 30.0,
    warnings: ['Température critique'],
    strengths: [],
    priorityActions: ['Protéger du froid'],
    confidence: 0.9,
    analyzedAt: DateTime.now(),
  );
}

PlantAnalysisResult _createAnalysisWithCriticalHumidity(String plantId) {
  final temp = createMockCondition(
    plantId: plantId,
    type: ConditionType.temperature,
    status: ConditionStatus.good,
  );
  final humidity = createMockCondition(
    plantId: plantId,
    type: ConditionType.humidity,
    status: ConditionStatus.critical,
    value: 20.0,
  );
  final light = createMockCondition(
    plantId: plantId,
    type: ConditionType.light,
    status: ConditionStatus.good,
  );
  final soil = createMockCondition(
    plantId: plantId,
    type: ConditionType.soil,
    status: ConditionStatus.good,
  );
  
  return PlantAnalysisResult(
    id: 'analysis_3',
    plantId: plantId,
    temperature: temp,
    humidity: humidity,
    light: light,
    soil: soil,
    overallHealth: ConditionStatus.critical,
    healthScore: 35.0,
    warnings: ['Humidité critique'],
    strengths: [],
    priorityActions: ['Arroser immédiatement'],
    confidence: 0.9,
    analyzedAt: DateTime.now(),
  );
}

List<PlantCondition> _createDecreasingHumidityHistory(String plantId) {
  // Créer historique avec des dates différentes pour détecter tendance à la baisse
  // Logique UseCase (ligne 312) : trie par date décroissante (b.compareTo(a))
  // puis vérifie si [0].value < [1].value < [2].value
  final now = DateTime.now();
  
  return [
    // Condition la plus ancienne (il y a 2 jours) - valeur la plus élevée
    PlantCondition(
      id: 'humidity_oldest',
      plantId: plantId,
      type: ConditionType.humidity,
      status: ConditionStatus.good,
      value: 70.0,
      optimalValue: 70.0,
      minValue: 50.0,
      maxValue: 85.0,
      unit: '%',
      description: 'Humidité: 70.0%',
      recommendations: [],
      measuredAt: now.subtract(const Duration(days: 2)),
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    // Condition intermédiaire (il y a 1 jour) - valeur moyenne
    PlantCondition(
      id: 'humidity_middle',
      plantId: plantId,
      type: ConditionType.humidity,
      status: ConditionStatus.good,
      value: 60.0,
      optimalValue: 70.0,
      minValue: 50.0,
      maxValue: 85.0,
      unit: '%',
      description: 'Humidité: 60.0%',
      recommendations: [],
      measuredAt: now.subtract(const Duration(days: 1)),
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    // Condition la plus récente (maintenant) - valeur la plus basse
    PlantCondition(
      id: 'humidity_recent',
      plantId: plantId,
      type: ConditionType.humidity,
      status: ConditionStatus.fair,
      value: 50.0,
      optimalValue: 70.0,
      minValue: 50.0,
      maxValue: 85.0,
      unit: '%',
      description: 'Humidité: 50.0%',
      recommendations: [],
      measuredAt: now,
      createdAt: now,
    ),
  ];
}

String _getMonthAbbreviation(int month) {
  const abbr = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
  return abbr[month - 1];
}
