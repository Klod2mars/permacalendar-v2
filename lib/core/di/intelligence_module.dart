import 'package:riverpod/riverpod.dart';
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
import '../../features/plant_intelligence/data/datasources/plant_intelligence_remote_datasource.dart';
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
import '../../features/plant_intelligence/domain/services/plant_evolution_tracker_service.dart';
import '../../features/plant_catalog/data/repositories/plant_hive_repository.dart';
import '../services/intelligence/intelligent_recommendation_engine.dart';
import '../services/intelligence/predictive_analytics_service.dart';
import '../services/intelligence/real_time_data_processor.dart';
import '../services/intelligence/real_time_time_data_processor.dart';
import 'network_module.dart';
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
/// DataSources → Repository Impl → Interfaces spécialisées (ISP)
///                                       ↓
///                                  UseCases
///                                       ↓
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

  /// Provider pour la source de données distante
  ///
  /// **Responsabilité :**
  /// - Communication avec les APIs d'intelligence végétale (REST)
  /// - Synchronisation des conditions, recommandations et alertes
  /// - Gestion résiliente des erreurs réseau (timeouts, retry via NetworkService)
  ///
  /// **Riverpod 3 :**
  /// - Injecté via `ref.read()` pour éviter tout état global
  /// - Les méthodes exposent des `Future` compatibles avec les `FutureProvider`
  ///
  /// **Usage recommandé :**
  /// ```dart
  /// final remote = ref.read(IntelligenceModule.remoteDataSourceProvider);
  /// final conditions = await remote.getRemotePlantCondition('plant-42');
  /// ```
  static final remoteDataSourceProvider =
      Provider<PlantIntelligenceRemoteDataSource>((ref) {
    final networkService = ref.read(NetworkModule.networkServiceProvider);
    return PlantIntelligenceRemoteDataSourceImpl(
      networkService: networkService,
    );
  });

  /// Provider `Future` pour récupérer le statut de synchronisation distant.
  ///
  /// À utiliser dans l'UI pour afficher l'état réseau courant sans
  /// gérer manuellement les lifecycles (`autoDispose`).
  static final remoteSyncStatusProvider =
      FutureProvider.autoDispose<SyncStatus>((ref) async {
    final dataSource = ref.read(remoteDataSourceProvider);
    return dataSource.getSyncStatus();
  });

  /// Provider pour la source de données de lutte biologique
  ///
  /// Gère :
  /// - Catalogues JSON (ravageurs, auxiliaires) - lecture seule
  /// - Observations de ravageurs (Sanctuaire) - créées par l'utilisateur
  /// - Recommandations de lutte biologique - générées par l'IA
  static final biologicalControlDataSourceProvider =
      Provider<BiologicalControlDataSource>((ref) {
    return BiologicalControlDataSourceImpl(Hive);
  });

  /// Provider pour la source de données des plantes
  ///
  /// **Responsabilité:**
  /// Fournit un accès découplé au catalogue des plantes via l'interface `IPlantDataSource`.
  /// Cette source de données encapsule `PlantHiveRepository` pour isoler les UseCases
  /// des détails d'implémentation Hive.
  ///
  /// **Type de données:**
  /// - Retourne une instance de `IPlantDataSource` (interface)
  /// - Implémentation: `PlantDataSourceImpl` qui encapsule `PlantHiveRepository`
  /// - Données: Catalogue des plantes (lecture seule depuis Hive local)
  ///
  /// **Dépendances:**
  /// - `PlantHiveRepository`: Repository Hive pour la persistance locale
  ///   - Accès à la box `plants_box` (Hive)
  ///   - Chargement depuis `assets/data/plants.json`
  ///   - Pas de dépendance réseau (source locale uniquement)
  ///
  /// **Gestion d'erreurs:**
  /// - Les erreurs d'initialisation sont capturées et loggées
  /// - Les méthodes de l'interface retournent des valeurs par défaut (null, [])
  ///   en cas d'erreur plutôt que de lever des exceptions
  ///
  /// **Interactions:**
  /// - Utilisé par `analyzePestThreatsUsecaseProvider` pour récupérer les infos plantes
  /// - Utilisé par `generateBioControlRecommendationsUsecaseProvider` pour le compagnonnage
  /// - Peut être utilisé par `realTimeDataProcessor` pour les mises à jour en temps réel
  /// - Peut être utilisé par `intelligentRecommendationEngine` pour les recommandations
  ///
  /// **Usage:**
  /// ```dart
  /// // Dans un widget ou un UseCase
  /// final dataSource = ref.read(IntelligenceModule.plantDataSourceProvider);
  ///
  /// // Récupérer une plante spécifique
  /// final plant = await dataSource.getPlant('plant-123');
  ///
  /// // Récupérer toutes les plantes
  /// final allPlants = await dataSource.getAllPlants();
  ///
  /// // Rechercher des plantes
  /// final results = await dataSource.searchPlants('tomate');
  /// ```
  ///
  /// **Bonnes pratiques:**
  /// - Utiliser `ref.watch()` dans les widgets pour la réactivité
  /// - Utiliser `ref.read()` dans les UseCases et services
  /// - Les erreurs sont gérées silencieusement (retour de valeurs par défaut)
  /// - Pour un diagnostic, vérifier les logs avec `developer.log`
  ///
  /// **Note:**
  /// Ce provider est conforme à Riverpod 3 :
  /// - Pas de variable globale utilisée directement
  /// - Toutes les dépendances sont injectées via le provider
  /// - Pas d'état persistant entre recharges (nouvelle instance à chaque fois)
  static final plantDataSourceProvider = Provider<IPlantDataSource>((ref) {
    // Création d'une nouvelle instance de PlantHiveRepository
    // Note: PlantHiveRepository initialise la box Hive de manière lazy
    // via _getBox(), donc pas besoin d'initialisation synchrone ici.
    // Les erreurs d'accès aux données sont gérées par PlantDataSourceImpl
    // qui retourne des valeurs par défaut (null, []) plutôt que de lever des exceptions.
    final plantRepository = PlantHiveRepository();
    return PlantDataSourceImpl(plantRepository);
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

  // ==================== INTELLIGENCE SERVICES ====================

  /// Provider pour le PredictiveAnalyticsService
  ///
  /// **Responsabilité:**
  /// Service d'analytics prédictif pour les prédictions ML :
  /// - Prédictions de séries temporelles
  /// - Analyse de tendances
  /// - Détection d'anomalies
  /// - Prédiction de récoltes
  ///
  /// **Usage:**
  /// Utilisé par `IntelligentRecommendationEngine` pour améliorer
  /// la qualité des recommandations via des prédictions ML.
  static final predictiveAnalyticsServiceProvider =
      Provider<PredictiveAnalyticsService>((ref) {
    return PredictiveAnalyticsService();
  });

  /// Provider pour le RealTimeDataProcessor
  ///
  /// **Responsabilité:**
  /// Processeur de flux événementiels en temps réel pour :
  /// - Traitement des événements de jardin (changements de conditions, nouvelles plantations)
  /// - Mise à jour des recommandations intelligentes en temps réel
  /// - Synchronisation des données entre différents composants du système
  /// - Gestion de la backpressure pour éviter la surcharge du système
  ///
  /// **Dépendances:**
  /// Aucune (service autonome)
  ///
  /// **Configuration:**
  /// - maxQueueSize: 1000 (par défaut)
  /// - processingTimeout: 30 secondes (par défaut)
  /// - enableBackpressure: true (par défaut)
  ///
  /// **Usage:**
  /// ```dart
  /// final processor = ref.read(IntelligenceModule.realTimeDataProcessorProvider);
  /// await processor.start();
  ///
  /// // Soumettre un événement
  /// await processor.submitEvent(DataEvent(
  ///   id: 'garden_update_123',
  ///   data: gardenData,
  ///   priority: ProcessingPriority.high,
  /// ));
  ///
  /// // S'abonner aux événements critiques
  /// processor.subscribe<String>(
  ///   priority: ProcessingPriority.critical,
  ///   onEvent: (event) async {
  ///     // Traiter l'événement
  ///     return ProcessingResult(
  ///       eventId: event.id,
  ///       success: true,
  ///       processingTime: Duration.zero,
  ///     );
  ///   },
  /// );
  /// ```
  ///
  /// **Note:**
  /// Ce provider utilise `autoDispose` pour s'assurer que le processeur
  /// est arrêté et les ressources libérées lorsque plus aucun widget
  /// ne l'utilise.
  static final realTimeDataProcessorProvider =
      Provider.autoDispose<RealTimeDataProcessor>((ref) {
    final processor = RealTimeDataProcessor(
      maxQueueSize: 1000,
      processingTimeout: const Duration(seconds: 30),
      enableBackpressure: true,
    );

    // Auto-dispose: arrêter le processeur quand le provider est supprimé
    ref.onDispose(() async {
      await processor.dispose();
    });

    return processor;
  });

  /// Provider pour le RealTimeTimeDataProcessor
  ///
  /// **Responsabilité:**
  /// Processeur de flux événementiels avec conscience temporelle pour :
  /// - Traitement d'événements horodatés avec validation de séquence
  /// - Synchronisation temporelle avec l'horloge système
  /// - Gestion des retards et événements hors séquence
  /// - Détection des dérives de temps (horloges système décalées)
  /// - Mise à jour de modèles temporels basés sur les événements
  /// - Throttling intelligent basé sur le temps réel
  ///
  /// **Différences avec RealTimeDataProcessor:**
  /// - `RealTimeDataProcessor` : Traite les événements par priorité, sans conscience temporelle
  /// - `RealTimeTimeDataProcessor` : Traite les événements par ordre temporel, avec validation de séquence
  ///
  /// **Dépendances:**
  /// - `realTimeDataProcessorProvider` : Processeur de base pour le traitement des événements
  ///
  /// **Configuration:**
  /// - maxQueueSize: 1000 (par défaut)
  /// - processingTimeout: 30 secondes (par défaut)
  /// - maxLatency: 5 minutes (par défaut)
  /// - temporalWindow: 10 secondes (par défaut)
  /// - enableSequenceValidation: true (par défaut)
  /// - enableTimeDriftDetection: true (par défaut)
  /// - throttleInterval: 100ms (par défaut)
  ///
  /// **Usage:**
  /// ```dart
  /// final temporalProcessor = ref.read(
  ///   IntelligenceModule.realTimeTimeDataProcessorProvider,
  /// );
  /// await temporalProcessor.startTemporalStream();
  ///
  /// // Soumettre un événement horodaté
  /// await temporalProcessor.processTimedEvent(TimedEvent(
  ///   id: 'garden_update_123',
  ///   data: gardenData,
  ///   timestamp: DateTime.now(),
  ///   expectedSequence: 42,
  /// ));
  ///
  /// // S'abonner aux événements temporels
  /// temporalProcessor.subscribeToTemporalStream<String>(
  ///   onEvent: (event) async {
  ///     // Traiter l'événement avec conscience temporelle
  ///     return TemporalProcessingResult(
  ///       eventId: event.id,
  ///       success: true,
  ///       processingTime: Duration.zero,
  ///       latency: event.latency,
  ///       sequenceValid: event.sequenceValid,
  ///     );
  ///   },
  /// );
  /// ```
  ///
  /// **Utilisation avec StreamProvider:**
  /// ```dart
  /// final temporalStreamProvider = StreamProvider.autoDispose<TimedEvent<String>>((ref) {
  ///   final processor = ref.read(
  ///     IntelligenceModule.realTimeTimeDataProcessorProvider,
  ///   );
  ///   return processor.getTemporalStream<String>();
  /// });
  /// ```
  ///
  /// **Note:**
  /// Ce provider utilise `autoDispose` pour s'assurer que le processeur
  /// est arrêté et les ressources libérées lorsque plus aucun widget
  /// ne l'utilise.
  static final realTimeTimeDataProcessorProvider =
      Provider.autoDispose<RealTimeTimeDataProcessor>((ref) {
    final baseProcessor = ref.read(realTimeDataProcessorProvider);
    final processor = RealTimeTimeDataProcessor(
      baseProcessor: baseProcessor,
      maxQueueSize: 1000,
      processingTimeout: const Duration(seconds: 30),
      maxLatency: const Duration(minutes: 5),
      temporalWindow: const Duration(seconds: 10),
      enableSequenceValidation: true,
      enableTimeDriftDetection: true,
    );

    // Auto-dispose: arrêter le processeur quand le provider est supprimé
    ref.onDispose(() async {
      await processor.dispose();
    });

    return processor;
  });

  /// Provider pour le IntelligentRecommendationEngine
  ///
  /// **Responsabilité:**
  /// Moteur de recommandations intelligentes basé sur :
  /// - Conditions météorologiques (gel, canicule, sécheresse)
  /// - Santé des plantes (scores de santé, détection de problèmes)
  /// - Opportunités saisonnières (plantation printanière, automnale)
  /// - Compagnonnage végétal (plantes compagnes bénéfiques)
  /// - Préférences utilisateur et historique (personnalisation)
  ///
  /// **Dépendances:**
  /// - `predictiveAnalyticsServiceProvider` : Service d'analytics ML (optionnel)
  ///
  /// **Usage:**
  /// ```dart
  /// final engine = ref.read(IntelligenceModule.intelligentRecommendationEngineProvider);
  /// final batch = await engine.generateRecommendations(
  ///   gardenId: 'garden-123',
  ///   gardenData: garden.toJson(),
  ///   weatherData: weatherData,
  ///   plants: plants.map((p) => p.toJson()).toList(),
  /// );
  /// ```
  static final intelligentRecommendationEngineProvider =
      Provider<IntelligentRecommendationEngine>((ref) {
    final analyticsService = ref.read(predictiveAnalyticsServiceProvider);
    return IntelligentRecommendationEngine(
      analyticsService: analyticsService,
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

  /// Provider pour le PlantEvolutionTrackerService (Riverpod 3)
  ///
  /// Utiliser `ref.watch(IntelligenceModule.plantEvolutionTrackerProvider)` pour
  /// récupérer une instance auto-disposée compatible caches légers.
  static final plantEvolutionTrackerProvider =
      Provider.autoDispose<PlantEvolutionTrackerService>((ref) {
    return const PlantEvolutionTrackerService(
      enableLogging: false,
      stabilityThreshold: 1.0,
      historyRetention: Duration(days: 90),
      trendWindowSize: 5,
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
  ///   ├─→ AnalyzePlantConditionsUsecase → PlantAnalysisResult
  ///   ├─→ EvaluatePlantingTimingUsecase → PlantingTimingEvaluation
  ///   └─→ GenerateRecommendationsUsecase → List<Recommendation>
  ///        ↓
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
    return PlantIntelligenceOrchestrator(
      conditionRepository: ref.read(conditionRepositoryProvider),
      weatherRepository: ref.read(weatherRepositoryProvider),
      gardenRepository: ref.read(gardenContextRepositoryProvider),
      recommendationRepository: ref.read(recommendationRepositoryProvider),
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
/// final hub = ref.read(IntelligenceModule.aggregationHubProvider); // ❌ Circular
///
/// // On fait :
/// final hub = ref.read(GardenModule.aggregationHubProvider); // ✅
/// ```
extension IntelligenceModuleExtensions on Ref {
  /// Raccourci pour accéder à l'orchestrateur
  PlantIntelligenceOrchestrator get intelligenceOrchestrator =>
      read(IntelligenceModule.orchestratorProvider);
}
