// lib/features/plant_intelligence/domain/services/plant_intelligence_orchestrator.dart

import 'dart:developer' as developer;

import 'package:uuid/uuid.dart';

import '../pipelines/analysis_pipeline.dart';
import '../pipelines/recommendation_pipeline.dart';
import '../pipelines/pest_analysis_pipeline.dart';
import '../pipelines/bio_control_pipeline.dart';
import '../pipelines/evolution_pipeline.dart';
import '../pipelines/garden_report_pipeline.dart';

import '../services/intelligence_scoring_service.dart';
import '../services/confidence_service.dart';
import '../services/summary_service.dart';

import '../maintenance/garden_initialization_service.dart';
import '../utils/plant_resolver.dart';

import '../../plant_catalog/domain/entities/plant_entity.dart';

import '../entities/intelligence_report.dart';
import '../entities/comprehensive_garden_analysis.dart';
import '../entities/pest_threat_analysis.dart';
import '../entities/bio_control_recommendation.dart';
import '../entities/recommendation.dart';
import '../entities/analysis_result.dart';

import '../repositories/i_analytics_repository.dart';
import '../repositories/i_garden_context_repository.dart';
import '../repositories/i_weather_repository.dart';

import '../usecases/evaluate_planting_timing_usecase.dart';

/// Plant Intelligence Orchestrator (refactoré)
///
/// Rôle : chef d'orchestre — composer pipelines, construire et persister
/// les rapports d'intelligence végétale. Aucune logique métier lourde,
/// tout est délégable aux pipelines & services.
///
/// Principes :
///  - SRP : uniquement orchestration
///  - Défensive : la persistance ne doit pas bloquer l'analyse
///  - Compatibilité : expose quelques wrappers historiques attendus par la UI
class PlantIntelligenceOrchestrator {
  // Pipelines
  final AnalysisPipeline _analysisPipeline;
  final RecommendationPipeline _recommendationPipeline;
  final PestAnalysisPipeline? _pestPipeline;
  final BioControlPipeline? _bioPipeline;
  final EvolutionPipeline _evolutionPipeline;
  final GardenReportPipeline _gardenPipeline;

  // Services
  final IntelligenceScoringService _scoringService;
  final ConfidenceService _confidenceService;
  final SummaryService _summaryService;

  // Utils / Maintenance
  final PlantResolver _resolver;
  final GardenInitializationService _initializationService;

  // Repos / infra
  final IAnalyticsRepository _analyticsRepository;
  final IGardenContextRepository _gardenRepository;
  final IWeatherRepository _weatherRepository;

  // Usecases
  final EvaluatePlantingTimingUsecase _evaluateTimingUsecase;

  PlantIntelligenceOrchestrator({
    required AnalysisPipeline analysisPipeline,
    required RecommendationPipeline recommendationPipeline,
    required EvolutionPipeline evolutionPipeline,
    required GardenReportPipeline gardenPipeline,
    required IntelligenceScoringService scoringService,
    required ConfidenceService confidenceService,
    required SummaryService summaryService,
    required PlantResolver resolver,
    required GardenInitializationService initializationService,
    required IAnalyticsRepository analyticsRepository,
    required IGardenContextRepository gardenRepository,
    required IWeatherRepository weatherRepository,
    required EvaluatePlantingTimingUsecase evaluateTimingUsecase,
    PestAnalysisPipeline? pestPipeline,
    BioControlPipeline? bioControlPipeline,
  })  : _analysisPipeline = analysisPipeline,
        _recommendationPipeline = recommendationPipeline,
        _evolutionPipeline = evolutionPipeline,
        _gardenPipeline = gardenPipeline,
        _scoringService = scoringService,
        _confidenceService = confidenceService,
        _summaryService = summaryService,
        _resolver = resolver,
        _initializationService = initializationService,
        _analyticsRepository = analyticsRepository,
        _gardenRepository = gardenRepository,
        _weatherRepository = weatherRepository,
        _evaluateTimingUsecase = evaluateTimingUsecase,
        _pestPipeline = pestPipeline,
        _bioPipeline = bioControlPipeline;

  // ---------------------------------------------------------------------------
  // Génération d'un rapport d'intelligence pour une plante
  // ---------------------------------------------------------------------------
  Future<PlantIntelligenceReport> generateIntelligenceReport({
    required String plantId,
    required String gardenId,
    PlantFreezed? plant,
  }) async {
    developer.log(
      '🌿 Orchestrator → Génération rapport pour plantId=$plantId, gardenId=$gardenId',
      name: 'PlantIntelligenceOrchestrator',
    );

    // 1) Résolution plante
    final resolvedPlant = plant ?? await _resolver.resolve(plantId);

    // 2) Récupérer contexte jardin et météo (pour usecases externes)
    final gardenContext = await _gardenRepository.getGardenContext(gardenId);
    if (gardenContext == null) {
      throw Exception('Contexte jardin $gardenId introuvable');
    }

    final weather =
        await _weatherRepository.getCurrentWeatherCondition(gardenId);
    if (weather == null) {
      developer.log(
          '⚠️ Aucune météo disponible pour gardenId=$gardenId — la confiance sera réduite',
          name: 'PlantIntelligenceOrchestrator',
          level: 900);
    }

    // 3) Analyse des conditions (pipeline dédié)
    final analysis = await _analysisPipeline.run(
      plant: resolvedPlant,
      gardenId: gardenId,
    );

    // 4) Évaluer le timing (usecase dédié)
    PlantingTimingEvaluation? plantingTiming;
    try {
      if (weather != null) {
        plantingTiming = await _evaluateTimingUsecase.execute(
          plant: resolvedPlant,
          weather: weather,
          garden: gardenContext,
        );
      } else {
        // Si pas de météo, on appelle quand même le usecase avec un fallback (non bloquant)
        plantingTiming = await _evaluateTimingUsecase.execute(
          plant: resolvedPlant,
          weather: WeatherCondition(
              value: 0.0, measuredAt: DateTime.now()), // minimal dummy
          garden: gardenContext,
        );
      }
    } catch (e, st) {
      developer.log('⚠️ Échec EvaluatePlantingTimingUsecase (non bloquant): $e',
          name: 'PlantIntelligenceOrchestrator',
          error: e,
          stackTrace: st,
          level: 900);
      plantingTiming = null;
    }

    // 5) Génération des recommandations (pipeline dédié)
    final recommendations = await _recommendationPipeline.run(
      plant: resolvedPlant,
      gardenId: gardenId,
      analysis: analysis,
    );

    // 6) Pest analysis (optionnel)
    PestThreatAnalysis? pestThreats;
    if (_pestPipeline != null) {
      try {
        pestThreats = await _pestPipeline!.run(gardenId);
      } catch (e, st) {
        developer.log('⚠️ PestAnalysis failed (non-blocking): $e',
            name: 'PlantIntelligenceOrchestrator',
            error: e,
            stackTrace: st,
            level: 900);
      }
    }

    // 7) Bio-control recommendations (optionnel)
    List<BioControlRecommendation> bioControlRecs = [];
    if (_bioPipeline != null) {
      try {
        bioControlRecs = await _bioPipeline!.run(pestThreats);
      } catch (e, st) {
        developer.log('⚠️ BioControlPipeline failed (non-blocking): $e',
            name: 'PlantIntelligenceOrchestrator',
            error: e,
            stackTrace: st,
            level: 900);
      }
    }

    // 8) Score global
    final timingForScoring = plantingTiming ??
        PlantingTimingEvaluation(
            isOptimalTime: false,
            timingScore: 0.0,
            reason: 'no-timing',
            favorableFactors: [],
            unfavorableFactors: [],
            risks: []);
    final intelligenceScore = _scoringService.compute(
      analysis: analysis,
      recommendations: recommendations,
      timing: timingForScoring,
    );

    // 9) Confiance globale
    double confidence = 0.0;
    try {
      if (weather != null) {
        confidence =
            _confidenceService.compute(analysis: analysis, weather: weather);
      } else {
        // fallback: base sur analysis.confidence
        confidence = analysis.confidence;
      }
    } catch (e, st) {
      developer.log('⚠️ Confidence computation failed (non-blocking): $e',
          name: 'PlantIntelligenceOrchestrator',
          error: e,
          stackTrace: st,
          level: 900);
      confidence = analysis.confidence;
    }

    // 10) Construire le rapport
    final generatedAt = DateTime.now();
    final report = PlantIntelligenceReport(
      id: const Uuid().v4(),
      plantId: resolvedPlant.id,
      plantName: resolvedPlant.commonName,
      gardenId: gardenId,
      analysis: analysis,
      recommendations: recommendations,
      plantingTiming: plantingTiming,
      activeAlerts: const [],
      intelligenceScore: intelligenceScore,
      confidence: confidence,
      generatedAt: generatedAt,
      expiresAt: generatedAt.add(const Duration(hours: 6)),
      metadata: {
        'historicalDataPoints': analysis.metadata['historicalDataPoints'] ?? 0,
        'weatherAgeHours': weather != null
            ? DateTime.now().difference(weather.measuredAt).inHours
            : null,
      },
    );

    developer.log(
        '✅ Orchestrator → Rapport construit (score=${intelligenceScore.toStringAsFixed(1)})',
        name: 'PlantIntelligenceOrchestrator');

    // 11) Persister le rapport de manière défensive (ne doit pas bloquer)
    try {
      await _analyticsRepository.saveLatestReport(report);
      developer.log('✔️ Rapport sauvegardé via analyticsRepository',
          name: 'PlantIntelligenceOrchestrator');
    } catch (e, st) {
      developer.log('⚠️ Échec sauvegarde rapport (non bloquant): $e',
          name: 'PlantIntelligenceOrchestrator',
          error: e,
          stackTrace: st,
          level: 900);
    }

    // 12) Traquer et sauvegarder l'évolution (non bloquant)
    try {
      await _evolutionPipeline.run(current: report);
    } catch (e, st) {
      developer.log('⚠️ Échec evolutionPipeline (non bloquant): $e',
          name: 'PlantIntelligenceOrchestrator',
          error: e,
          stackTrace: st,
          level: 900);
    }

    return report;
  }

  // ---------------------------------------------------------------------------
  // Génération de rapports pour tout le jardin
  // ---------------------------------------------------------------------------
  Future<List<PlantIntelligenceReport>> generateGardenIntelligenceReport({
    required String gardenId,
  }) async {
    developer.log(
        '🌳 Orchestrator → Génération rapports pour gardenId=$gardenId',
        name: 'PlantIntelligenceOrchestrator');

    // Initialisation sécurisée : nettoyage + invalidation caches
    try {
      await _initializationService.initialize(gardenId: gardenId);
    } catch (e, st) {
      developer.log('⚠️ Initialisation jardin échouée (non bloquant): $e',
          name: 'PlantIntelligenceOrchestrator',
          error: e,
          stackTrace: st,
          level: 900);
    }

    // Déléguer au GardenReportPipeline (qui appellera generateIntelligenceReport via callback)
    final reports = await _gardenPipeline.run(gardenId: gardenId);

    developer.log(
        '🏁 Orchestrator → ${reports.length} rapport(s) généré(s) pour gardenId=$gardenId',
        name: 'PlantIntelligenceOrchestrator');

    return reports;
  }

  // ---------------------------------------------------------------------------
  // Wrappers de compatibilité (API historique pour la présentation)
  // ---------------------------------------------------------------------------

  /// Compatibilité : expose l'analyse des conditions seule (historique)
  Future<PlantAnalysisResult> analyzePlantConditions({
    required String plantId,
    required String gardenId,
    PlantFreezed? plant,
  }) async {
    final resolved = plant ?? await _resolver.resolve(plantId);
    return await _analysisPipeline.run(plant: resolved, gardenId: gardenId);
  }

  /// Compatibilité : expose l'analyse complète du jardin incluant bio-control
  Future<ComprehensiveGardenAnalysis> analyzeGardenWithBioControl({
    required String gardenId,
  }) async {
    final plantReports =
        await generateGardenIntelligenceReport(gardenId: gardenId);

    PestThreatAnalysis? threats;
    if (_pestPipeline != null) {
      try {
        threats = await _pestPipeline!.run(gardenId);
      } catch (e, st) {
        developer.log(
            '⚠️ PestAnalysis failed in analyzeGardenWithBioControl: $e',
            name: 'PlantIntelligenceOrchestrator',
            error: e,
            stackTrace: st,
            level: 900);
      }
    }

    final bioRecs = (_bioPipeline != null)
        ? await _bioPipeline!.run(threats)
        : <BioControlRecommendation>[];

    final overallHealthScore = plantReports.isEmpty
        ? 0.0
        : plantReports.fold<double>(0.0, (s, r) => s + r.intelligenceScore) /
            plantReports.length;

    final summary = _summaryService.buildGardenSummary(
      plantReports: plantReports,
      pestThreats: threats,
      bioControlRecommendations: bioRecs,
    );

    return ComprehensiveGardenAnalysis(
      gardenId: gardenId,
      plantReports: plantReports,
      pestThreats: threats,
      bioControlRecommendations: bioRecs,
      overallHealthScore: overallHealthScore,
      analyzedAt: DateTime.now(),
      summary: summary,
    );
  }
}
