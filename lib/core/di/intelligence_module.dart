import 'package:riverpod/riverpod.dart';
import 'garden_module.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/recommendation_pipeline.dart';
import 'package:hive/hive.dart';

import '../../features/plant_intelligence/domain/repositories/i_plant_condition_repository.dart';

import '../../features/plant_intelligence/domain/repositories/i_weather_repository.dart';

import '../../features/plant_intelligence/domain/repositories/i_garden_context_repository.dart';

import '../../features/plant_intelligence/domain/repositories/i_recommendation_repository.dart';

import '../../features/plant_intelligence/domain/repositories/i_analytics_repository.dart';

import '../../features/plant_intelligence/domain/repositories/i_pest_repository.dart';

import '../../features/plant_intelligence/domain/repositories/i_beneficial_insect_repository.dart';

import '../../features/plant_intelligence/domain/repositories/i_pest_observation_repository.dart';

import '../../features/plant_intelligence/domain/repositories/i_bio_control_recommendation_repository.dart';

import '../../features/plant_intelligence/data/repositories/plant_intelligence_repository_impl.dart';

import '../../features/plant_intelligence/data/repositories/biological_control_repository_impl.dart';

import '../../features/plant_intelligence/data/datasources/plant_intelligence_local_datasource.dart';

import '../../features/plant_intelligence/data/datasources/biological_control_datasource.dart';

import '../../features/plant_intelligence/data/datasources/plant_datasource_impl.dart';

import '../../features/plant_intelligence/domain/repositories/i_plant_data_source.dart';

import '../../features/plant_intelligence/domain/usecases/analyze_plant_conditions_usecase.dart';

import '../../features/plant_intelligence/domain/usecases/evaluate_planting_timing_usecase.dart';

import '../../features/plant_intelligence/domain/usecases/generate_recommendations_usecase.dart';

import '../../features/plant_intelligence/domain/usecases/analyze_pest_threats_usecase.dart';

import '../../features/plant_intelligence/domain/usecases/generate_bio_control_recommendations_usecase.dart';

import '../../features/plant_intelligence/domain/services/plant_intelligence_orchestrator.dart';

import '../../features/plant_intelligence/domain/services/plant_intelligence_evolution_tracker.dart';

import '../../features/plant_catalog/data/repositories/plant_hive_repository.dart';

import 'garden_module.dart';

/// Module d'injection de dépendances pour l'Intelligence Végétale

///

/// Ce module centralise toutes les dépendances de la feature Intelligence Végétale :

/// - DataSources

/// - Repositories (implémentation + interfaces spécialisées)

/// - UseCases

/// - Orchestrator

///

/// **Architecture :**

/// ```

/// DataSources â†’ Repository Impl â†’ Interfaces spécialisées (ISP)

///                                       â†“

///                                  UseCases

///                                       â†“

///                                  Orchestrator

/// ```

///

/// **Usage :**

/// ```dart

/// final orchestrator = ref.read(IntelligenceModule.orchestratorProvider);

/// ```

class IntelligenceModule {
  IntelligenceModule._(); // Private constructor pour empêcher l'instanciation

  // ==================== DATA SOURCES ====================

  /// Provider pour la source de données locale

  ///

  /// Gère la persistance des données d'Intelligence Végétale :

  /// - PlantCondition

  /// - Recommendation

  /// - NotificationAlert

  /// - Résultats d'analyse

  static final localDataSourceProvider =
      Provider<PlantIntelligenceLocalDataSource>((ref) {
    return PlantIntelligenceLocalDataSourceImpl(Hive);
  });

  /// Provider pour la source de données de lutte biologique

  ///

  /// Gère :

  /// - Catalogues JSON (ravageurs, auxiliaires) - lecture seule

  /// - Observations de ravageurs (Sanctuaire) - Créées par l'utilisateur

  /// - Recommandations de lutte biologique - générées par l'IA

  static final biologicalControlDataSourceProvider =
      Provider<BiologicalControlDataSource>((ref) {
    return BiologicalControlDataSourceImpl(Hive);
  });

  /// Provider pour la source de données des plantes

  ///

  /// Fournit accès au catalogue des plantes via PlantHiveRepository.

  /// Utilisé par les UseCases de lutte biologique pour récupérer les infos plantes.

  static final plantDataSourceProvider = Provider<IPlantDataSource>((ref) {
    return PlantDataSourceImpl(PlantHiveRepository());
  });

  // ==================== REPOSITORIES ====================

  /// Provider pour l'implémentation concrète du repository

  ///

  /// **IMPORTANT :** Cette implémentation satisfait toutes les interfaces spécialisées.

  /// Les clients doivent utiliser les interfaces spécialisées via les providers dédiés.

  ///

  /// **Dépendances :**

  /// - localDataSource : Persistance locale

  /// - aggregationHub : Accès unifié aux jardins/plantes (via GardenModule)

  static final repositoryImplProvider =
      Provider<PlantIntelligenceRepositoryImpl>((ref) {
    final localDataSource = ref.read(localDataSourceProvider);

    final aggregationHub = ref.read(GardenModule.aggregationHubProvider);

    return PlantIntelligenceRepositoryImpl(
      localDataSource: localDataSource,
      aggregationHub: aggregationHub,
    );
  });

  /// Provider pour l'interface de gestion des conditions de plantes

  ///

  /// **Interface Segregation Principle (ISP) :**

  /// Les clients ne dépendent que des méthodes dont ils ont besoin.

  ///

  /// **Méthodes (5) :**

  /// - savePlantCondition()

  /// - getCurrentPlantCondition()

  /// - getPlantConditionHistory()

  /// - updatePlantCondition()

  /// - deletePlantCondition()

  static final conditionRepositoryProvider =
      Provider<IPlantConditionRepository>((ref) {
    return ref.read(repositoryImplProvider);
  });

  /// Provider pour l'interface de gestion météo

  ///

  /// **Méthodes (3) :**

  /// - saveWeatherCondition()

  /// - getCurrentWeatherCondition()

  /// - getWeatherHistory()

  static final weatherRepositoryProvider = Provider<IWeatherRepository>((ref) {
    return ref.read(repositoryImplProvider);
  });

  /// Provider pour l'interface de gestion du contexte jardin

  ///

  /// **Méthodes (6) :**

  /// - saveGardenContext()

  /// - getGardenContext()

  /// - updateGardenContext()

  /// - getUserGardens()

  /// - getGardenPlants()

  /// - searchPlants()

  static final gardenContextRepositoryProvider =
      Provider<IGardenContextRepository>((ref) {
    return ref.read(repositoryImplProvider);
  });

  /// Provider pour l'interface de gestion des recommandations

  ///

  /// **Méthodes (7) :**

  /// - saveRecommendation()

  /// - getActiveRecommendations()

  /// - getRecommendationsByPriority()

  /// - markRecommendationAsApplied()

  /// - markRecommendationAsIgnored()

  /// - deleteRecommendation()

  /// - filterRecommendations()

  static final recommendationRepositoryProvider =
      Provider<IRecommendationRepository>((ref) {
    return ref.read(repositoryImplProvider);
  });

  /// Provider pour l'interface d'analytics

  ///

  /// **Méthodes (11) :**

  /// - saveAnalysisResult()

  /// - getLatestAnalysis()

  /// - getAnalysisHistory()

  /// - getPlantHealthStats()

  /// - getGardenPerformanceMetrics()

  /// - getTrendData()

  /// - saveAlert()

  /// - getActiveAlerts()

  /// - resolveAlert()

  static final analyticsRepositoryProvider =
      Provider<IAnalyticsRepository>((ref) {
    return ref.read(repositoryImplProvider);
  });

  // ==================== BIOLOGICAL CONTROL REPOSITORIES ====================

  /// Provider pour l'implémentation concrète du repository de lutte biologique

  ///

  /// **PHILOSOPHY:**

  /// This implementation respects the Sanctuary principle:

  /// - Pest observations are CREATED BY USER (Sanctuary data)

  /// - Recommendations are GENERATED BY AI (Intelligence data)

  /// - Catalogs are READ-ONLY reference data

  ///

  /// **Dépendances:**

  /// - biologicalControlDataSource: Accès catalogues JSON + persistance Hive

  static final biologicalControlRepositoryImplProvider =
      Provider<BiologicalControlRepositoryImpl>((ref) {
    final dataSource = ref.read(biologicalControlDataSourceProvider);

    return BiologicalControlRepositoryImpl(dataSource: dataSource);
  });

  /// Provider pour l'interface de gestion des ravageurs (catalogue read-only)

  ///

  /// **Méthodes (3):**

  /// - getPest()

  /// - getAllPests()

  /// - getPestsForPlant()

  static final pestRepositoryProvider = Provider<IPestRepository>((ref) {
    return ref.read(biologicalControlRepositoryImplProvider);
  });

  /// Provider pour l'interface de gestion des auxiliaires (catalogue read-only)

  ///

  /// **Méthodes (3):**

  /// - getInsect()

  /// - getAllInsects()

  /// - getPredatorsOf()

  static final beneficialInsectRepositoryProvider =
      Provider<IBeneficialInsectRepository>((ref) {
    return ref.read(biologicalControlRepositoryImplProvider);
  });

  /// Provider pour l'interface de gestion des observations de ravageurs (Sanctuary)

  ///

  /// **Méthodes (3):**

  /// - savePestObservation()

  /// - getObservationsForGarden()

  /// - getActiveObservations()

  ///

  /// **SANCTUARY PRINCIPLE:**

  /// Observations are CREATED ONLY BY USER, never by AI.

  static final pestObservationRepositoryProvider =
      Provider<IPestObservationRepository>((ref) {
    return ref.read(biologicalControlRepositoryImplProvider);
  });

  /// Provider pour l'interface de gestion des recommandations de lutte biologique

  ///

  /// **Méthodes (3):**

  /// - saveRecommendation()

  /// - getRecommendationsForGarden()

  /// - markRecommendationApplied()

  ///

  /// **AI PRINCIPLE:**

  /// Recommendations are GENERATED ONLY BY AI, never directly by user.

  static final bioControlRecommendationRepositoryProvider =
      Provider<IBioControlRecommendationRepository>((ref) {
    return ref.read(biologicalControlRepositoryImplProvider);
  });

  // ==================== USE CASES ====================

  /// Provider pour le UseCase d'analyse des conditions

  ///

  /// **Responsabilité :**

  /// Analyse les 4 conditions d'une plante (température, humidité, lumière, sol)

  /// et génère un PlantAnalysisResult complet avec score de santé.

  static final analyzeConditionsUsecaseProvider =
      Provider<AnalyzePlantConditionsUsecase>((ref) {
    return const AnalyzePlantConditionsUsecase();
  });

  /// Provider pour le UseCase d'évaluation du timing de plantation

  ///

  /// **Responsabilité :**

  /// Évalue si c'est le bon moment pour planter une espèce donnée

  /// en analysant les conditions météo, saison, sol, etc.

  static final evaluateTimingUsecaseProvider =
      Provider<EvaluatePlantingTimingUsecase>((ref) {
    return const EvaluatePlantingTimingUsecase();
  });

  /// Provider pour le UseCase de génération de recommandations

  ///

  /// **Responsabilité :**

  /// Génère des recommandations personnalisées basées sur :

  /// - Analyse des conditions

  /// - Données météo

  /// - Calendrier cultural

  /// - Historique des conditions

  static final generateRecommendationsUsecaseProvider =
      Provider<GenerateRecommendationsUsecase>((ref) {
    return const GenerateRecommendationsUsecase();
  });

  // ==================== BIOLOGICAL CONTROL USE CASES ====================

  /// Provider pour le UseCase d'analyse des menaces ravageurs

  ///

  /// **Responsabilité:**

  /// Analyse les observations de ravageurs dans un jardin et

  /// génère une analyse globale des menaces.

  static final analyzePestThreatsUsecaseProvider =
      Provider<AnalyzePestThreatsUsecase>((ref) {
    return AnalyzePestThreatsUsecase(
      observationRepository: ref.read(pestObservationRepositoryProvider),
      pestRepository: ref.read(pestRepositoryProvider),
      plantDataSource: ref.read(plantDataSourceProvider),
    );
  });

  /// Provider pour le UseCase de génération de recommandations de lutte biologique

  ///

  /// **Responsabilité:**

  /// Génère des recommandations de lutte biologique basées sur :

  /// - Observations de ravageurs

  /// - Catalogue des auxiliaires

  /// - Plantes compagnes répulsives

  /// - Création d'habitats

  static final generateBioControlRecommendationsUsecaseProvider =
      Provider<GenerateBioControlRecommendationsUsecase>((ref) {
    return GenerateBioControlRecommendationsUsecase(
      pestRepository: ref.read(pestRepositoryProvider),
      beneficialRepository: ref.read(beneficialInsectRepositoryProvider),
      plantDataSource: ref.read(plantDataSourceProvider),
    );
  });

  // ==================== EVOLUTION TRACKER ====================

  /// Provider pour le PlantIntelligenceEvolutionTracker

  ///

  /// **CURSOR PROMPT A6 - Evolution Tracker Integration**

  ///

  /// **Responsabilité:**

  /// Comparer l'évolution entre deux rapports d'intelligence successifs

  /// pour détecter les changements de santé des plantes.

  ///

  /// **Configuration:**

  /// - enableLogging: false (désactivé par défaut, sauf pour debug)

  /// - toleranceThreshold: 0.01 (ignore les variations < 1%)

  static final evolutionTrackerProvider =
      Provider<PlantIntelligenceEvolutionTracker>((ref) {
    return PlantIntelligenceEvolutionTracker(
      enableLogging: false,
      toleranceThreshold: 0.01,
    );
  });

  // ==================== ORCHESTRATOR ====================

  /// Provider pour l'orchestrateur domain

  ///

  /// **Responsabilité :**

  /// Coordonne les 3 UseCases pour générer des rapports complets d'Intelligence Végétale.

  ///

  /// **Architecture :**

  /// ```

  /// Orchestrator

  ///   â”œâ”€â†’ AnalyzePlantConditionsUsecase â†’ PlantAnalysisResult

  ///   â”œâ”€â†’ EvaluatePlantingTimingUsecase â†’ PlantingTimingEvaluation

  ///   â””â”€â†’ GenerateRecommendationsUsecase â†’ List<Recommendation>

  ///        â†“

  ///   PlantIntelligenceReport (composite)

  /// ```

  ///

  /// **Dépendances injectées :**

  /// - 5 interfaces repositories (ISP)

  /// - PlantHiveRepository (catalogue des plantes)

  /// - 3 UseCases

  /// - PlantIntelligenceEvolutionTracker (CURSOR A6)

  /// - 4 biological control repositories (optional)

  /// - 2 biological control UseCases (optional)

  static final orchestratorProvider =
      Provider<PlantIntelligenceOrchestrator>((ref) {
   
      weatherRepository: ref.read(weatherRepositoryProvider),

      gardenRepository: ref.read(gardenContextRepositoryProvider),

      recommendationPipeline: RecommendationPipeline(
       generateUsecase: ref.read(generateRecommendationsUsecaseProvider),
       conditionRepository: ref.read(conditionRepositoryProvider),
       gardenRepository: ref.read(gardenContextRepositoryProvider),
       weatherRepository: ref.read(weatherRepositoryProvider),
      ),

      analyticsRepository: ref.read(analyticsRepositoryProvider),

      plantCatalogRepository: PlantHiveRepository(),

      analyzeUsecase: ref.read(analyzeConditionsUsecaseProvider),

      evaluateTimingUsecase: ref.read(evaluateTimingUsecaseProvider),

      generateRecommendationsUsecase:
          ref.read(generateRecommendationsUsecaseProvider),

      evolutionTracker: ref.read(evolutionTrackerProvider),

      // Biological control (optional dependencies)

      bioControlRecommendationRepository:
          ref.read(bioControlRecommendationRepositoryProvider),

      analyzePestThreatsUsecase: ref.read(analyzePestThreatsUsecaseProvider),

      generateBioControlUsecase:
          ref.read(generateBioControlRecommendationsUsecaseProvider),
    );
  });
}

/// Extension pour faciliter l'accès aux providers de lutte biologique

extension BiologicalControlExtensions on Ref {
  /// Raccourci pour accéder au repository des ravageurs

  IPestRepository get pestRepository =>
      read(IntelligenceModule.pestRepositoryProvider);

  /// Raccourci pour accéder au repository des auxiliaires

  IBeneficialInsectRepository get beneficialInsectRepository =>
      read(IntelligenceModule.beneficialInsectRepositoryProvider);

  /// Raccourci pour accéder au repository des observations

  IPestObservationRepository get pestObservationRepository =>
      read(IntelligenceModule.pestObservationRepositoryProvider);

  /// Raccourci pour accéder au repository des recommandations bio

  IBioControlRecommendationRepository get bioControlRecommendationRepository =>
      read(IntelligenceModule.bioControlRecommendationRepositoryProvider);
}

/// Extension pour faciliter l'accès aux providers depuis GardenModule

///

/// Permet d'éviter les imports circulaires :

/// ```dart

/// // Au lieu de :

/// final hub = ref.read(IntelligenceModule.aggregationHubProvider); // âŒ Circular

///

/// // On fait :

/// final hub = ref.read(GardenModule.aggregationHubProvider); // âœ…

/// ```

extension IntelligenceModuleExtensions on Ref {
  /// Raccourci pour accéder à l'orchestrateur

  PlantIntelligenceOrchestrator get intelligenceOrchestrator =>
      read(IntelligenceModule.orchestratorProvider);
}
