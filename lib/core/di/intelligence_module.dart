import 'package:riverpod/riverpod.dart';
import 'garden_module.dart';

import 'package:hive/hive.dart';

// Pipelines + services
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/recommendation_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/analysis_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/evolution_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/garden_report_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/pest_analysis_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/bio_control_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/utils/plant_resolver.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/intelligence_scoring_service.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/confidence_service.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/summary_service.dart';
import 'package:permacalendar/features/plant_intelligence/domain/maintenance/garden_initialization_service.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/evolution_condition_mapper.dart';

import '../../features/plant_intelligence/domain/services/plant_intelligence_orchestrator.dart';
import '../../features/plant_intelligence/domain/services/plant_intelligence_evolution_tracker.dart';
import '../../features/plant_catalog/data/repositories/plant_hive_repository.dart';

// 🔧 PATCH APPLIQUÉ ICI :
import '../../features/plant_intelligence/domain/models/plant_freezed.dart';

// Repository interfaces
import '../../features/plant_intelligence/domain/repositories/i_plant_condition_repository.dart';
import '../../features/plant_intelligence/domain/repositories/i_weather_repository.dart';
import '../../features/plant_intelligence/domain/repositories/i_garden_context_repository.dart';
import '../../features/plant_intelligence/domain/repositories/i_recommendation_repository.dart';
import '../../features/plant_intelligence/domain/repositories/i_analytics_repository.dart';
import '../../features/plant_intelligence/domain/repositories/i_pest_repository.dart';
import '../../features/plant_intelligence/domain/repositories/i_beneficial_insect_repository.dart';
import '../../features/plant_intelligence/domain/repositories/i_pest_observation_repository.dart';
import '../../features/plant_intelligence/domain/repositories/i_bio_control_recommendation_repository.dart';
import '../../features/plant_intelligence/domain/repositories/i_plant_data_source.dart';

// Repository impl + datasources
import '../../features/plant_intelligence/data/repositories/plant_intelligence_repository_impl.dart';
import '../../features/plant_intelligence/data/repositories/biological_control_repository_impl.dart';
import '../../features/plant_intelligence/data/datasources/plant_intelligence_local_datasource.dart';
import '../../features/plant_intelligence/data/datasources/biological_control_datasource.dart';
import '../../features/plant_intelligence/data/datasources/plant_datasource_impl.dart';

// Usecases
import '../../features/plant_intelligence/domain/usecases/analyze_plant_conditions_usecase.dart';
import '../../features/plant_intelligence/domain/usecases/evaluate_planting_timing_usecase.dart';
import '../../features/plant_intelligence/domain/usecases/generate_recommendations_usecase.dart';
import '../../features/plant_intelligence/domain/usecases/analyze_pest_threats_usecase.dart';
import '../../features/plant_intelligence/domain/usecases/generate_bio_control_recommendations_usecase.dart';

class IntelligenceModule {
  IntelligenceModule._();

  // ==================== DATA SOURCES ====================

  static final localDataSourceProvider =
      Provider<PlantIntelligenceLocalDataSource>((ref) {
    return PlantIntelligenceLocalDataSourceImpl(Hive);
  });

  static final biologicalControlDataSourceProvider =
      Provider<BiologicalControlDataSource>((ref) {
    return BiologicalControlDataSourceImpl(Hive);
  });

  static final plantDataSourceProvider = Provider<IPlantDataSource>((ref) {
    return PlantDataSourceImpl(PlantHiveRepository());
  });

  // ==================== REPOSITORIES ====================

  static final repositoryImplProvider =
      Provider<PlantIntelligenceRepositoryImpl>((ref) {
    final localDataSource = ref.read(localDataSourceProvider);
    final aggregationHub = ref.read(GardenModule.aggregationHubProvider);
    return PlantIntelligenceRepositoryImpl(
      localDataSource: localDataSource,
      aggregationHub: aggregationHub,
    );
  });

  static final conditionRepositoryProvider =
      Provider<IPlantConditionRepository>((ref) {
    return ref.read(repositoryImplProvider);
  });

  static final weatherRepositoryProvider = Provider<IWeatherRepository>((ref) {
    return ref.read(repositoryImplProvider);
  });

  static final gardenContextRepositoryProvider =
      Provider<IGardenContextRepository>((ref) {
    return ref.read(repositoryImplProvider);
  });

  static final recommendationRepositoryProvider =
      Provider<IRecommendationRepository>((ref) {
    return ref.read(repositoryImplProvider);
  });

  static final analyticsRepositoryProvider =
      Provider<IAnalyticsRepository>((ref) {
    return ref.read(repositoryImplProvider);
  });

  // ==================== BIOLOGICAL CONTROL REPOSITORIES ====================

  static final biologicalControlRepositoryImplProvider =
      Provider<BiologicalControlRepositoryImpl>((ref) {
    final dataSource = ref.read(biologicalControlDataSourceProvider);
    return BiologicalControlRepositoryImpl(dataSource: dataSource);
  });

  static final pestRepositoryProvider = Provider<IPestRepository>((ref) {
    return ref.read(biologicalControlRepositoryImplProvider);
  });

  static final beneficialInsectRepositoryProvider =
      Provider<IBeneficialInsectRepository>((ref) {
    return ref.read(biologicalControlRepositoryImplProvider);
  });

  static final pestObservationRepositoryProvider =
      Provider<IPestObservationRepository>((ref) {
    return ref.read(biologicalControlRepositoryImplProvider);
  });

  static final bioControlRecommendationRepositoryProvider =
      Provider<IBioControlRecommendationRepository>((ref) {
    return ref.read(biologicalControlRepositoryImplProvider);
  });

  // ==================== USE CASES ====================

  static final analyzeConditionsUsecaseProvider =
      Provider<AnalyzePlantConditionsUsecase>((ref) {
    return const AnalyzePlantConditionsUsecase();
  });

  static final evaluateTimingUsecaseProvider =
      Provider<EvaluatePlantingTimingUsecase>((ref) {
    return const EvaluatePlantingTimingUsecase();
  });

  static final generateRecommendationsUsecaseProvider =
      Provider<GenerateRecommendationsUsecase>((ref) {
    return const GenerateRecommendationsUsecase();
  });

  static final analyzePestThreatsUsecaseProvider =
      Provider<AnalyzePestThreatsUsecase>((ref) {
    return AnalyzePestThreatsUsecase(
      observationRepository: ref.read(pestObservationRepositoryProvider),
      pestRepository: ref.read(pestRepositoryProvider),
      plantDataSource: ref.read(plantDataSourceProvider),
    );
  });

  static final generateBioControlRecommendationsUsecaseProvider =
      Provider<GenerateBioControlRecommendationsUsecase>((ref) {
    return GenerateBioControlRecommendationsUsecase(
      pestRepository: ref.read(pestRepositoryProvider),
      beneficialRepository: ref.read(beneficialInsectRepositoryProvider),
      plantDataSource: ref.read(plantDataSourceProvider),
    );
  });

  // ==================== EVOLUTION TRACKER ====================

  static final evolutionTrackerProvider =
      Provider<PlantIntelligenceEvolutionTracker>((ref) {
    return PlantIntelligenceEvolutionTracker(
      enableLogging: false,
      toleranceThreshold: 0.01,
    );
  });

  // ==================== ORCHESTRATOR (VERSION AFTER) ====================

  static final orchestratorProvider =
      Provider<PlantIntelligenceOrchestrator>((ref) {
    final analysisPipeline = AnalysisPipeline(
      analyzeUsecase: ref.read(analyzeConditionsUsecaseProvider),
      gardenRepository: ref.read(gardenContextRepositoryProvider),
      weatherRepository: ref.read(weatherRepositoryProvider),
      conditionRepository: ref.read(conditionRepositoryProvider),
    );

    final recommendationPipeline = RecommendationPipeline(
      generateUsecase: ref.read(generateRecommendationsUsecaseProvider),
      conditionRepository: ref.read(conditionRepositoryProvider),
      gardenRepository: ref.read(gardenContextRepositoryProvider),
      weatherRepository: ref.read(weatherRepositoryProvider),
    );

    final pestPipeline = PestAnalysisPipeline(
      analyzePestThreatsUsecase: ref.read(analyzePestThreatsUsecaseProvider),
    );

    final bioPipeline = BioControlPipeline(
      generateUsecase:
          ref.read(generateBioControlRecommendationsUsecaseProvider),
      bioControlRecommendationRepository:
          ref.read(bioControlRecommendationRepositoryProvider),
    );

    final evolutionPipeline = EvolutionPipeline(
      analyticsRepository: ref.read(analyticsRepositoryProvider),
      tracker: ref.read(evolutionTrackerProvider),
      conditionMapper: EvolutionConditionMapper(),
    );

    late PlantIntelligenceOrchestrator orchestrator;

    final gardenPipeline = GardenReportPipeline(
      gardenRepository: ref.read(gardenContextRepositoryProvider),
      reportGenerator: ({
        required String plantId,
        required String gardenId,
        PlantFreezed? plant,
      }) =>
          orchestrator.generateIntelligenceReport(
        plantId: plantId,
        gardenId: gardenId,
        plant: plant,
      ),
    );

    orchestrator = PlantIntelligenceOrchestrator(
      analysisPipeline: analysisPipeline,
      recommendationPipeline: recommendationPipeline,
      evolutionPipeline: evolutionPipeline,
      gardenPipeline: gardenPipeline,
      scoringService: IntelligenceScoringService(),
      confidenceService: ConfidenceService(),
      summaryService: SummaryService(),
      resolver: PlantResolver(plantCatalogRepository: PlantHiveRepository()),
      initializationService: GardenInitializationService(),
      analyticsRepository: ref.read(analyticsRepositoryProvider),
      gardenRepository: ref.read(gardenContextRepositoryProvider),
      weatherRepository: ref.read(weatherRepositoryProvider),
      evaluateTimingUsecase: ref.read(evaluateTimingUsecaseProvider),
      pestPipeline: pestPipeline,
      bioControlPipeline: bioPipeline,
    );

    return orchestrator;
  });
}

// ====================== EXTENSIONS ======================

/// Extension pour faciliter l'accès aux providers de lutte biologique
extension BiologicalControlExtensions on Ref {
  IPestRepository get pestRepository =>
      read(IntelligenceModule.pestRepositoryProvider);

  IBeneficialInsectRepository get beneficialInsectRepository =>
      read(IntelligenceModule.beneficialInsectRepositoryProvider);

  IPestObservationRepository get pestObservationRepository =>
      read(IntelligenceModule.pestObservationRepositoryProvider);

  IBioControlRecommendationRepository get bioControlRecommendationRepository =>
      read(IntelligenceModule.bioControlRecommendationRepositoryProvider);
}

/// Extension pour faciliter l'accès aux providers depuis GardenModule
extension IntelligenceModuleExtensions on Ref {
  PlantIntelligenceOrchestrator get intelligenceOrchestrator =>
      read(IntelligenceModule.orchestratorProvider);
}
