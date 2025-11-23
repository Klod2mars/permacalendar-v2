import 'dart:developer' as developer;

import '../entities/recommendation.dart';
import '../entities/analysis_result.dart';
import '../repositories/i_plant_condition_repository.dart';
import '../repositories/i_garden_context_repository.dart';
import '../repositories/i_weather_repository.dart';
import '../usecases/generate_recommendations_usecase.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

/// Pipeline dédiée à la génération des recommandations pour une plante.
///
/// SRP :
///  👉 Exécuter la logique du GenerateRecommendationsUsecase.
///  👉 Récupérer éventuellement l’historique des conditions.
///  👉 Ne gère NI persistance NI scoring.
///
class RecommendationPipeline {
  final GenerateRecommendationsUsecase _generateUsecase;
  final IPlantConditionRepository _conditionRepository;
  final IGardenContextRepository _gardenRepository;
  final IWeatherRepository _weatherRepository;

  RecommendationPipeline({
    required GenerateRecommendationsUsecase generateUsecase,
    required IPlantConditionRepository conditionRepository,
    required IGardenContextRepository gardenRepository,
    required IWeatherRepository weatherRepository,
  })  : _generateUsecase = generateUsecase,
        _conditionRepository = conditionRepository,
        _gardenRepository = gardenRepository,
        _weatherRepository = weatherRepository;

  /// Exécute la génération complète des recommandations.
  ///
  /// ⚠️ Pas de persistance ici : l’Orchestrateur fait le _saveResults().
  /// ⚠️ Pas de modification Sanctuaire.
  Future<List<Recommendation>> run({
    required PlantFreezed plant,
    required String gardenId,
    required PlantAnalysisResult analysis,
  }) async {
    developer.log(
      '📝 RecommendationPipeline → Génération recommandations pour ${plant.id}',
      name: 'RecommendationPipeline',
    );

    // Récupérer contexte jardin
    final gardenContext = await _gardenRepository.getGardenContext(gardenId);
    if (gardenContext == null) {
      throw Exception(
          'Contexte jardin introuvable pour gardenId=$gardenId dans RecommendationPipeline');
    }

    // Récupérer météo
    final weather =
        await _weatherRepository.getCurrentWeatherCondition(gardenId);
    if (weather == null) {
      throw Exception(
          'Conditions météo introuvables pour gardenId=$gardenId dans RecommendationPipeline');
    }

    // Conditions historiques 30 jours
    final historicalConditions =
        await _conditionRepository.getPlantConditionHistory(
      plantId: plant.id,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      limit: 200,
    );

    developer.log(
      '📊 RecommendationPipeline → Historique récupéré (${historicalConditions.length} points)',
      name: 'RecommendationPipeline',
    );

    // Exécuter la génération via le UseCase
    final recs = await _generateUsecase.execute(
      plant: plant,
      analysisResult: analysis,
      weather: weather,
      garden: gardenContext,
      historicalConditions:
          historicalConditions.isNotEmpty ? historicalConditions : null,
    );

    developer.log(
      '✅ RecommendationPipeline → ${recs.length} recommandation(s) générée(s)',
      name: 'RecommendationPipeline',
    );

    return recs;
  }
}
