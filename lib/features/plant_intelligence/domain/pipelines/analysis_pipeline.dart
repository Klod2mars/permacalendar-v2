import 'dart:developer' as developer;

import '../entities/analysis_result.dart';
import '../repositories/i_plant_condition_repository.dart';
import '../repositories/i_garden_context_repository.dart';
import '../repositories/i_weather_repository.dart';
import '../usecases/analyze_plant_conditions_usecase.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_freezed.dart';

/// Pipeline dédiée à l’analyse des conditions d’une plante.
///
/// SRP (Single Responsibility Principle) :
////  👉 Exécuter l’analyse via le UseCase
///  👉 Rien d’autre (pas de scoring, pas de recos, pas de persistance)
///
/// Cette classe est appelée par l’Orchestrateur.
class AnalysisPipeline {
  final AnalyzePlantConditionsUsecase _analyzeUsecase;
  final IGardenContextRepository _gardenRepository;
  final IWeatherRepository _weatherRepository;
  final IPlantConditionRepository _conditionRepository;

  AnalysisPipeline({
    required AnalyzePlantConditionsUsecase analyzeUsecase,
    required IGardenContextRepository gardenRepository,
    required IWeatherRepository weatherRepository,
    required IPlantConditionRepository conditionRepository,
  })  : _analyzeUsecase = analyzeUsecase,
        _gardenRepository = gardenRepository,
        _weatherRepository = weatherRepository,
        _conditionRepository = conditionRepository;

  /// Exécute l’analyse complète des conditions pour une plante.
  ///
  /// ⚠️ Ne génère aucune recommandation.
  /// ⚠️ Ne modifie aucune box du Sanctuaire.
  /// ⚠️ Ne gère pas la persistance : rôle de l’orchestrateur ou du repository.
  Future<PlantAnalysisResult> run({
    required PlantFreezed plant,
    required String gardenId,
  }) async {
    developer.log(
      '🌡️ AnalysisPipeline → Analyse conditions pour ${plant.id}',
      name: 'AnalysisPipeline',
    );

    // Récupération contexte jardin
    final gardenContext = await _gardenRepository.getGardenContext(gardenId);
    if (gardenContext == null) {
      throw Exception(
          'Contexte jardin introuvable pour gardenId=$gardenId dans AnalysisPipeline');
    }

    // Récupération météo actuelle
    final weather =
        await _weatherRepository.getCurrentWeatherCondition(gardenId);
    if (weather == null) {
      throw Exception(
          'Conditions météo introuvables pour gardenId=$gardenId dans AnalysisPipeline');
    }

    // Exécution du UseCase principal d’analyse
    final result = await _analyzeUsecase.execute(
      plant: plant,
      weather: weather,
      garden: gardenContext,
    );

    developer.log(
      '✅ AnalysisPipeline → Analyse terminée (score=${result.healthScore})',
      name: 'AnalysisPipeline',
    );

    return result;
  }
}
