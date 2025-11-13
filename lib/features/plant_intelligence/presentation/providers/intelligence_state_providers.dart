// FICHIER CORRIGÉ POUR RIVERPOD 3.X PURE (sans annotations)

import 'dart:developer' as developer;
import 'package:riverpod/riverpod.dart';
import '../../domain/entities/intelligence_state.dart';
import '../../domain/entities/weather_condition.dart';
import '../../domain/entities/plant_condition.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/recommendation.dart';
import '../providers/plant_intelligence_providers.dart';
import '../../../../core/di/intelligence_module.dart';

// ==================== PROVIDER ====================

/// Provider avec family - SYNTAXE RIVERPOD 3.X CORRECTE
/// 
/// CHANGEMENTS par rapport à Riverpod 2.x:
/// - NotifierProvider.autoDispose.family au lieu de AutoDisposeNotifierProviderFamily
/// - La classe étend Notifier (pas AutoDisposeNotifier)
/// - L'argument family est passé via constructeur (pas via ref.arg)
final intelligenceStateProvider = NotifierProvider.autoDispose.family<
    IntelligenceStateNotifier,
    IntelligenceState,
    String  // Type de l'argument family (gardenId)
>(IntelligenceStateNotifier.new);

// ==================== NOTIFIER ====================

/// Notifier pour gérer l'état d'intelligence d'un jardin spécifique
/// 
/// EN RIVERPOD 3.X:
/// - On étend Notifier<T> (pas AutoDisposeNotifier<T>)
/// - L'argument family est un membre de la classe (this.gardenId)
/// - build() ne prend PLUS d'argument - on utilise this.gardenId
class IntelligenceStateNotifier extends Notifier<IntelligenceState> {
  /// Constructeur qui reçoit l'argument family
  /// OBLIGATOIRE pour NotifierProvider.family en Riverpod 3.x
  IntelligenceStateNotifier(this.gardenId);
  
  /// L'ID du jardin - argument family
  final String gardenId;

  @override
  IntelligenceState build() {
    // IMPORTANT: build() ne prend plus d'argument en Riverpod 3.x
    // On utilise this.gardenId à la place
    developer.log(
      'Initialisation du state pour jardin: $gardenId',
      name: 'IntelligenceStateNotifier',
    );

    return IntelligenceState(
      currentGardenId: gardenId,
      isInitialized: false,
      isAnalyzing: false,
      plantConditions: {},
      plantRecommendations: {},
      activePlantIds: [],
    );
  }

  /// Initialiser l'intelligence pour le jardin
  Future<void> initializeForGarden() async {
    state = state.copyWith(isAnalyzing: true, error: null);

    try {
      // Récupérer le contexte du jardin
      final gardenContext = await ref
          .read(plantIntelligenceRepositoryProvider)
          .getGardenContext(gardenId);

      // Récupérer les conditions météorologiques
      final weather = await ref
          .read(plantIntelligenceRepositoryProvider)
          .getCurrentWeatherCondition(gardenId);

      // Récupérer les plantes actives du jardin
      final activePlants = gardenContext?.activePlantIds ?? [];

      // Nettoyer les anciennes conditions
      final cleanedConditions = <String, PlantCondition>{};
      final cleanedRecommendations = <String, List<Recommendation>>{};

      for (final plantId in activePlants) {
        if (state.plantConditions.containsKey(plantId)) {
          cleanedConditions[plantId] = state.plantConditions[plantId]!;
        }
        if (state.plantRecommendations.containsKey(plantId)) {
          cleanedRecommendations[plantId] = state.plantRecommendations[plantId]!;
        }
      }

      // mise à jour intermédiaire
      state = state.copyWith(
        isInitialized: true,
        isAnalyzing: true,
        currentGardenId: gardenId,
        currentGarden: gardenContext,
        currentWeather: weather,
        activePlantIds: activePlants,
        plantConditions: cleanedConditions,
        plantRecommendations: cleanedRecommendations,
        lastAnalysis: DateTime.now(),
      );

      // Analyser chaque plante
      for (final plantId in activePlants) {
        try {
          await analyzePlant(plantId);
        } catch (e) {
          developer.log(
            'Erreur lors de l\'analyse de la plante $plantId: $e',
            name: 'IntelligenceStateNotifier',
          );
        }
      }

      // État final
      state = state.copyWith(
        isAnalyzing: false,
        lastAnalysis: DateTime.now(),
      );

      developer.log(
        'Plantes actives détectées: ${activePlants.length}',
        name: 'IntelligenceStateNotifier',
      );
      developer.log(
        'Analyses générées: ${state.plantConditions.length}/${activePlants.length}',
        name: 'IntelligenceStateNotifier',
      );

    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de l\'initialisation du jardin $gardenId',
        error: e,
        stackTrace: stackTrace,
        name: 'IntelligenceStateNotifier',
      );

      state = state.copyWith(
        isAnalyzing: false,
        isInitialized: true,
        error: e.toString(),
      );
    }
  }

  /// Analyser une plante spécifique
  Future<void> analyzePlant(String plantId) async {
    state = state.copyWith(isAnalyzing: true);

    try {
      if (state.currentGardenId == null) {
        throw Exception('Aucun jardin sélectionné');
      }

      final orchestrator = ref.read(IntelligenceModule.orchestratorProvider);

      final report = await orchestrator.generateIntelligenceReport(
        plantId: plantId,
        gardenId: gardenId,
      );

      developer.log(
        'Rapport généré pour $plantId: score=${report.intelligenceScore.toStringAsFixed(2)}, '
        '${report.recommendations.length} recommandations',
        name: 'IntelligenceStateNotifier',
      );

      final mainCondition = _selectMainConditionFromAnalysis(report.analysis, plantId);

      state = state.copyWith(
        plantConditions: {
          ...state.plantConditions,
          plantId: mainCondition,
        },
        plantRecommendations: {
          ...state.plantRecommendations,
          plantId: report.recommendations,
        },
        isAnalyzing: false,
      );

    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de l\'analyse de la plante $plantId',
        error: e,
        stackTrace: stackTrace,
        name: 'IntelligenceStateNotifier',
      );

      state = state.copyWith(
        isAnalyzing: false,
        error: e.toString(),
      );
    }
  }

  /// Mettre à jour les conditions météo
  void updateWeather(WeatherCondition weather) {
    state = state.copyWith(currentWeather: weather);
  }

  /// Effacer l'erreur
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Réinitialiser l'état
  void reset() {
    state = IntelligenceState(currentGardenId: gardenId);
  }

  /// Sélectionner la condition principale d'une analyse
  PlantCondition _selectMainConditionFromAnalysis(
    PlantAnalysisResult analysis,
    String plantId,
  ) {
    final conditions = [
      analysis.temperature,
      analysis.humidity,
      analysis.light,
      analysis.soil,
    ];

    const priorityOrder = [
      ConditionStatus.critical,
      ConditionStatus.poor,
      ConditionStatus.fair,
      ConditionStatus.good,
      ConditionStatus.excellent,
    ];

    for (final status in priorityOrder) {
      final matchingCondition = conditions.firstWhere(
        (c) => c.status == status,
        orElse: () => conditions.first,
      );
      if (matchingCondition.status == status) {
        return matchingCondition;
      }
    }

    return conditions.first;
  }
}

// ==================== EXEMPLE D'UTILISATION ====================

/* 
DANS LES WIDGETS (aucun changement):

// Lire l'état
final intelligenceState = ref.watch(intelligenceStateProvider(gardenId));

// Appeler des méthodes
await ref.read(intelligenceStateProvider(gardenId).notifier).initializeForGarden();
ref.read(intelligenceStateProvider(gardenId).notifier).clearError();

// Listen aux changements
ref.listen(
  intelligenceStateProvider(gardenId),
  (previous, next) {
    // Réagir aux changements
  },
);
*/


