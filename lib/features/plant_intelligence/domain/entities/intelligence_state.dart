import 'plant_condition.dart';
import 'recommendation.dart';
import 'garden_context.dart';
import 'weather_condition.dart';

/// État global de l'intelligence végétale pour un jardin
///
/// Représente l'état complet du système d'intelligence pour un jardin donné,
/// incluant les conditions des plantes, les recommandations, et le contexte météorologique.
class IntelligenceState {
  final String? currentGardenId;
  final bool isInitialized;
  final bool isAnalyzing;
  final Map<String, PlantCondition> plantConditions;
  final Map<String, List<Recommendation>> plantRecommendations;
  final List<String> activePlantIds;
  final GardenContext? currentGarden;
  final WeatherCondition? currentWeather;
  final DateTime? lastAnalysis;
  final String? error;

  const IntelligenceState({
    this.currentGardenId,
    this.isInitialized = false,
    this.isAnalyzing = false,
    Map<String, PlantCondition>? plantConditions,
    Map<String, List<Recommendation>>? plantRecommendations,
    List<String>? activePlantIds,
    this.currentGarden,
    this.currentWeather,
    this.lastAnalysis,
    this.error,
  })  : plantConditions = plantConditions ?? const {},
        plantRecommendations = plantRecommendations ?? const {},
        activePlantIds = activePlantIds ?? const [];

  IntelligenceState copyWith({
    Object? currentGardenId = _undefined,
    Object? isInitialized = _undefined,
    Object? isAnalyzing = _undefined,
    Object? plantConditions = _undefined,
    Object? plantRecommendations = _undefined,
    Object? activePlantIds = _undefined,
    Object? currentGarden = _undefined,
    Object? currentWeather = _undefined,
    Object? lastAnalysis = _undefined,
    Object? error = _undefined,
  }) {
    return IntelligenceState(
      currentGardenId: currentGardenId == _undefined
          ? this.currentGardenId
          : currentGardenId as String?,
      isInitialized: isInitialized == _undefined
          ? this.isInitialized
          : isInitialized as bool,
      isAnalyzing: isAnalyzing == _undefined ? this.isAnalyzing : isAnalyzing as bool,
      plantConditions: plantConditions == _undefined
          ? this.plantConditions
          : plantConditions as Map<String, PlantCondition>?,
      plantRecommendations: plantRecommendations == _undefined
          ? this.plantRecommendations
          : plantRecommendations as Map<String, List<Recommendation>>?,
      activePlantIds: activePlantIds == _undefined
          ? this.activePlantIds
          : activePlantIds as List<String>?,
      currentGarden: currentGarden == _undefined
          ? this.currentGarden
          : currentGarden as GardenContext?,
      currentWeather: currentWeather == _undefined
          ? this.currentWeather
          : currentWeather as WeatherCondition?,
      lastAnalysis: lastAnalysis == _undefined
          ? this.lastAnalysis
          : lastAnalysis as DateTime?,
      error: error == _undefined ? this.error : error as String?,
    );
  }
}

/// Sentinel value pour détecter si un paramètre a été passé à copyWith
const _undefined = Object();


