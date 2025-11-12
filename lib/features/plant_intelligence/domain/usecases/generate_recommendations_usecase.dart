import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:uuid/uuid.dart';

/// Use case pour générer des recommandations intelligentes basées sur l'analyse
class GenerateRecommendationsUsecase {
  const GenerateRecommendationsUsecase();

  /// Génère des recommandations personnalisées pour une plante
  ///
  /// [plant] - La plante concernée
  /// [analysisResult] - Résultat de l'analyse des conditions
  /// [weather] - Conditions météorologiques actuelles
  /// [garden] - Contexte du jardin
  /// [historicalConditions] - Historique des conditions (optionnel)
  ///
  /// Retourne une liste de [Recommendation] priorisées
  Future<List<Recommendation>> execute({
    required PlantFreezed plant,
    required PlantAnalysisResult analysisResult,
    required WeatherCondition weather,
    required GardenContext garden,
    List<PlantCondition>? historicalConditions,
  }) async {
    final recommendations = <Recommendation>[];
    const uuid = Uuid();

    // 1. Recommandations basées sur les conditions critiques
    recommendations.addAll(_generateCriticalRecommendations(
      plant: plant,
      analysisResult: analysisResult,
      gardenId: garden.gardenId,
      uuid: uuid,
    ));

    // 2. Recommandations basées sur la météo
    recommendations.addAll(_generateWeatherRecommendations(
      plant: plant,
      weather: weather,
      analysisResult: analysisResult,
      gardenId: garden.gardenId,
      uuid: uuid,
    ));

    // 3. Recommandations basées sur le calendrier cultural
    recommendations.addAll(_generateSeasonalRecommendations(
      plant: plant,
      garden: garden,
      uuid: uuid,
    ));

    // 4. Recommandations basées sur l'historique (si disponible)
    if (historicalConditions != null && historicalConditions.isNotEmpty) {
      recommendations.addAll(_generateHistoricalRecommendations(
        plant: plant,
        historicalConditions: historicalConditions,
        gardenId: garden.gardenId,
        uuid: uuid,
      ));
    }

    // 5. Trier par priorité (critical > high > medium > low)
    recommendations.sort((a, b) => _getPriorityWeight(b.priority)
        .compareTo(_getPriorityWeight(a.priority)));

    return recommendations;
  }

  /// Génère des recommandations pour les conditions critiques
  List<Recommendation> _generateCriticalRecommendations({
    required PlantFreezed plant,
    required PlantAnalysisResult analysisResult,
    required String gardenId,
    required Uuid uuid,
  }) {
    final recommendations = <Recommendation>[];

    // Température critique
    if (analysisResult.temperature.status == ConditionStatus.critical) {
      recommendations.add(Recommendation(
        id: uuid.v4(),
        plantId: plant.id,
        gardenId: gardenId,
        type: RecommendationType.weatherProtection,
        priority: RecommendationPriority.critical,
        title: 'Protéger du froid/chaleur extrême',
        description: analysisResult.temperature.recommendations?.join('. ') ??
            'Température critique détectée',
        instructions: [
          'Vérifier la température actuelle',
          'Installer une protection si nécessaire (voile, ombrage)',
          'Surveiller l\'évolution',
        ],
        expectedImpact: 90.0,
        effortRequired: 50.0,
        estimatedCost: 30.0,
        estimatedDuration: const Duration(hours: 1),
        deadline: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      ));
    }

    // Humidité critique
    if (analysisResult.humidity.status == ConditionStatus.critical) {
      recommendations.add(Recommendation(
        id: uuid.v4(),
        plantId: plant.id,
        gardenId: gardenId,
        type: RecommendationType.watering,
        priority: RecommendationPriority.critical,
        title: 'Ajuster l\'arrosage immédiatement',
        description: analysisResult.humidity.recommendations?.join('. ') ??
            'Humidité critique détectée',
        instructions: [
          'Vérifier l\'humidité du sol',
          'Arroser ou améliorer le drainage selon le cas',
          'Surveiller quotidiennement',
        ],
        expectedImpact: 85.0,
        effortRequired: 30.0,
        estimatedCost: 10.0,
        estimatedDuration: const Duration(minutes: 30),
        deadline: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      ));
    }

    // Luminosité critique
    if (analysisResult.light.status == ConditionStatus.critical) {
      recommendations.add(Recommendation(
        id: uuid.v4(),
        plantId: plant.id,
        gardenId: gardenId,
        type: RecommendationType.general,
        priority: RecommendationPriority.high,
        title: 'Repositionner la plante',
        description: analysisResult.light.recommendations?.join('. ') ??
            'Luminosité critique détectée',
        instructions: [
          'Identifier un emplacement avec meilleure exposition',
          'Déplacer la plante si possible',
          'Ou installer un éclairage/ombrage artificiel',
        ],
        expectedImpact: 70.0,
        effortRequired: 70.0,
        estimatedCost: 40.0,
        estimatedDuration: const Duration(hours: 2),
        deadline: DateTime.now().add(const Duration(days: 7)),
        createdAt: DateTime.now(),
      ));
    }

    // Sol critique
    if (analysisResult.soil.status == ConditionStatus.critical) {
      recommendations.add(Recommendation(
        id: uuid.v4(),
        plantId: plant.id,
        gardenId: gardenId,
        type: RecommendationType.soilImprovement,
        priority: RecommendationPriority.high,
        title: 'Améliorer la qualité du sol',
        description: analysisResult.soil.recommendations?.join('. ') ??
            'Qualité du sol critique détectée',
        instructions: [
          'Ajouter du compost ou amendement organique',
          'Vérifier le pH si possible',
          'Pailler pour protéger',
        ],
        expectedImpact: 75.0,
        effortRequired: 60.0,
        estimatedCost: 50.0,
        estimatedDuration: const Duration(hours: 1, minutes: 30),
        deadline: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now(),
      ));
    }

    return recommendations;
  }

  /// Génère des recommandations basées sur les prévisions météo
  List<Recommendation> _generateWeatherRecommendations({
    required PlantFreezed plant,
    required WeatherCondition weather,
    required PlantAnalysisResult analysisResult,
    required String gardenId,
    required Uuid uuid,
  }) {
    final recommendations = <Recommendation>[];

    // Risque de gel
    if (weather.value < 5.0 && plant.metadata.containsKey('frostSensitive')) {
      final isFrostSensitive = plant.metadata['frostSensitive'] == true ||
          plant.metadata['frostSensitive'] == 'true';

      if (isFrostSensitive) {
        recommendations.add(Recommendation(
          id: uuid.v4(),
          plantId: plant.id,
          gardenId: gardenId,
          type: RecommendationType.weatherProtection,
          priority: RecommendationPriority.critical,
          title: 'Risque de gel détecté',
          description:
              'La température va descendre en dessous de 5°C. ${plant.commonName} est sensible au gel.',
          instructions: [
            'Installer un voile d\'hivernage',
            'Pailler abondamment',
            'Rentrer les plantes en pot si possible',
          ],
          expectedImpact: 95.0,
          effortRequired: 50.0,
          estimatedCost: 35.0,
          estimatedDuration: const Duration(hours: 1),
          deadline: DateTime.now().add(const Duration(hours: 12)),
          requiredTools: ['Voile d\'hivernage', 'Paillis', 'Attaches'],
          createdAt: DateTime.now(),
        ));
      }
    }

    // Forte chaleur
    if (weather.value > 30.0) {
      recommendations.add(Recommendation(
        id: uuid.v4(),
        plantId: plant.id,
        gardenId: gardenId,
        type: RecommendationType.watering,
        priority: RecommendationPriority.high,
        title: 'Canicule prévue',
        description:
            'Températures élevées attendues. Augmenter la fréquence d\'arrosage.',
        instructions: [
          'Arroser tôt le matin ou tard le soir',
          'Installer un paillage pour conserver l\'humidité',
          'Ombrer si possible pendant les heures les plus chaudes',
        ],
        expectedImpact: 80.0,
        effortRequired: 40.0,
        estimatedCost: 20.0,
        estimatedDuration: const Duration(minutes: 45),
        deadline: DateTime.now().add(const Duration(days: 2)),
        optimalConditions: ['Matin tôt (6-8h)', 'Soir tard (19-21h)'],
        createdAt: DateTime.now(),
      ));
    }

    return recommendations;
  }

  /// Génère des recommandations basées sur la saison et le calendrier
  List<Recommendation> _generateSeasonalRecommendations({
    required PlantFreezed plant,
    required GardenContext garden,
    required Uuid uuid,
  }) {
    final recommendations = <Recommendation>[];
    final now = DateTime.now();
    final currentMonth = now.month;

    // Vérifier si c'est la période de semis
    if (plant.sowingMonths.contains(_getMonthAbbreviation(currentMonth))) {
      recommendations.add(Recommendation(
        id: uuid.v4(),
        plantId: plant.id,
        gardenId: garden.gardenId,
        type: RecommendationType.planting,
        priority: RecommendationPriority.medium,
        title: 'Période de semis favorable',
        description: 'C\'est la période idéale pour semer ${plant.commonName}.',
        instructions: [
          'Préparer le sol',
          'Semer selon les recommandations (profondeur: ${plant.depth}cm, espacement: ${plant.spacing}cm)',
          'Arroser régulièrement',
        ],
        expectedImpact: 85.0,
        effortRequired: 55.0,
        estimatedCost: 25.0,
        estimatedDuration: Duration(hours: plant.daysToMaturity > 100 ? 3 : 2),
        deadline: DateTime(now.year, now.month, _getLastDayOfMonth(now)),
        requiredTools: ['Graines', 'Outils de jardinage', 'Arrosoir'],
        createdAt: DateTime.now(),
      ));
    }

    // Vérifier si c'est la période de récolte
    if (plant.harvestMonths.contains(_getMonthAbbreviation(currentMonth))) {
      recommendations.add(Recommendation(
        id: uuid.v4(),
        plantId: plant.id,
        gardenId: garden.gardenId,
        type: RecommendationType.harvesting,
        priority: RecommendationPriority.medium,
        title: 'Période de récolte',
        description: 'C\'est le moment de récolter ${plant.commonName}.',
        instructions: [
          'Vérifier la maturité des fruits/légumes',
          'Récolter au bon moment de la journée',
          'Consommer ou conserver rapidement',
        ],
        expectedImpact: 90.0,
        effortRequired: 35.0,
        estimatedCost: 5.0,
        estimatedDuration: const Duration(hours: 1),
        deadline: DateTime(now.year, now.month, _getLastDayOfMonth(now)),
        optimalConditions: ['Temps sec', 'Matin après la rosée'],
        createdAt: DateTime.now(),
      ));
    }

    return recommendations;
  }

  /// Génère des recommandations basées sur l'historique
  List<Recommendation> _generateHistoricalRecommendations({
    required PlantFreezed plant,
    required List<PlantCondition> historicalConditions,
    required String gardenId,
    required Uuid uuid,
  }) {
    final recommendations = <Recommendation>[];

    // Analyser les tendances dans l'historique
    // Par exemple : si l'humidité diminue constamment, recommander un arrosage préventif

    final recentConditions = historicalConditions
        .where((c) => c.type == ConditionType.humidity)
        .toList()
      ..sort((a, b) => b.measuredAt.compareTo(a.measuredAt));

    if (recentConditions.length >= 3) {
      // Vérifier si tendance à la baisse
      final isDecreasing =
          recentConditions[0].value < recentConditions[1].value &&
              recentConditions[1].value < recentConditions[2].value;

      if (isDecreasing) {
        recommendations.add(Recommendation(
          id: uuid.v4(),
          plantId: plant.id,
          gardenId: gardenId,
          type: RecommendationType.watering,
          priority: RecommendationPriority.medium,
          title: 'Tendance à la baisse de l\'humidité',
          description:
              'L\'humidité du sol diminue progressivement. Prévoir un arrosage.',
          instructions: [
            'Vérifier l\'humidité du sol',
            'Arroser si nécessaire',
            'Surveiller l\'évolution',
          ],
          expectedImpact: 65.0,
          effortRequired: 25.0,
          estimatedCost: 10.0,
          estimatedDuration: const Duration(minutes: 20),
          deadline: DateTime.now().add(const Duration(days: 3)),
          createdAt: DateTime.now(),
        ));
      }
    }

    return recommendations;
  }

  /// Convertit un numéro de mois en abréviation
  String _getMonthAbbreviation(int month) {
    const abbr = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    return abbr[month - 1];
  }

  /// Retourne le dernier jour du mois
  int _getLastDayOfMonth(DateTime date) {
    final nextMonth = date.month == 12
        ? DateTime(date.year + 1, 1, 1)
        : DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  /// Retourne le poids d'une priorité pour le tri
  int _getPriorityWeight(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.critical:
        return 4;
      case RecommendationPriority.high:
        return 3;
      case RecommendationPriority.medium:
        return 2;
      case RecommendationPriority.low:
        return 1;
    }
  }
}

