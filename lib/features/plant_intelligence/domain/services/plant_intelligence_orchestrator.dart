// lib/features/plant_intelligence/domain/services/plant_intelligence_orchestrator.dart

import 'dart:developer' as developer;
import 'package:uuid/uuid.dart';

import 'package:permacalendar/features/plant_intelligence/domain/pipelines/analysis_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/recommendation_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/pest_analysis_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/bio_control_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/evolution_pipeline.dart';
import 'package:permacalendar/features/plant_intelligence/domain/pipelines/garden_report_pipeline.dart';

import 'package:permacalendar/features/plant_intelligence/domain/services/intelligence_scoring_service.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/confidence_service.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/summary_service.dart';

import 'package:permacalendar/features/plant_intelligence/domain/maintenance/garden_initialization_service.dart';
import 'package:permacalendar/features/plant_intelligence/domain/utils/plant_resolver.dart';

import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/comprehensive_garden_analysis.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/pest_threat_analysis.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/bio_control_recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';

import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_analytics_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_garden_context_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_weather_repository.dart';

import 'package:permacalendar/features/plant_intelligence/domain/usecases/evaluate_planting_timing_usecase.dart';

/// Plant Intelligence Orchestrator (Refactored & Fixed)
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

  // Utils & maintenance
  final PlantResolver _resolver;
  final GardenInitializationService _initializationService;

  // Repositories
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
      '🌿 Orchestrator → Génération rapport pour plantId=$plantId gardenId=$gardenId',
      name: 'PlantIntelligenceOrchestrator',
    );

    // 1) Résoudre la plante
    final resolvedPlant = plant ?? await _resolver.resolve(plantId);

    // 2) Récupérer contexte jardin + météo
    final gardenContext = await _gardenRepository.getGardenContext(gardenId);
    if (gardenContext == null) {
      throw Exception('Contexte jardin $gardenId introuvable');
    }

    final weather =
        await _weatherRepository.getCurrentWeatherCondition(gardenId);
    if (weather == null) {
      developer.log('⚠️ Aucune météo disponible — la confiance sera réduite',
          name: 'PlantIntelligenceOrchestrator', level: 900);
    }

    // 3) Analyse
    final analysis =
        await _analysisPipeline.run(plant: resolvedPlant, gardenId: gardenId);

    // 4) Timing
    PlantingTimingEvaluation? plantingTiming;
    try {
      // FIX: Added 'id' parameter required by Freezed
      final usedWeather = weather ??
          WeatherCondition(
            id: 'default_temp',
            type: WeatherType.temperature,
            value: 0.0,
            unit: '°C',
            measuredAt: DateTime.now(),
          );

      plantingTiming = await _evaluateTimingUsecase.execute(
          plant: resolvedPlant, weather: usedWeather, garden: gardenContext);
    } catch (e, st) {
      developer.log(
          '⚠️ EvaluatePlantingTimingUsecase failed (non-blocking): $e',
          name: 'PlantIntelligenceOrchestrator',
          error: e,
          stackTrace: st,
          level: 900);
      plantingTiming = null;
    }

    // 5) Recommendations
    final recommendations = await _recommendationPipeline.run(
        plant: resolvedPlant, gardenId: gardenId, analysis: analysis);

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

    // 7) Bio control (optionnel)
    List<BioControlRecommendation> bioControlRecs = [];
    if (_bioPipeline != null) {
      try {
        // FIX: Changed _bio_pipeline to _bioPipeline
        bioControlRecs = await _bioPipeline!.run(pestThreats);
      } catch (e, st) {
        developer.log('⚠️ BioControlPipeline failed (non-blocking): $e',
            name: 'PlantIntelligenceOrchestrator',
            error: e,
            stackTrace: st,
            level: 900);
      }
    }

    // 8) Score
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
        timing: timingForScoring);

    // 9) Confidence
    double confidence;
    try {
      confidence = (weather != null)
          ? _confidenceService.compute(analysis: analysis, weather: weather)
          : analysis.confidence;
    } catch (e, st) {
      developer.log('⚠️ Confidence computation failed (non-blocking): $e',
          name: 'PlantIntelligenceOrchestrator',
          error: e,
          stackTrace: st,
          level: 900);
      confidence = analysis.confidence;
    }

    // 10) Build report
    final now = DateTime.now();
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
      generatedAt: now,
      expiresAt: now.add(const Duration(hours: 6)),
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

    // 11) Persister (defensive)
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

    // 12) Evolution (defensive)
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
  // Garden report
  // ---------------------------------------------------------------------------
  Future<List<PlantIntelligenceReport>> generateGardenIntelligenceReport(
      {required String gardenId}) async {
    developer.log(
        '🌳 Orchestrator → Génération rapports pour gardenId=$gardenId',
        name: 'PlantIntelligenceOrchestrator');

    try {
      await _initializationService.initialize(gardenId: gardenId);
    } catch (e, st) {
      developer.log('⚠️ Initialisation jardin échouée (non bloquant): $e',
          name: 'PlantIntelligenceOrchestrator',
          error: e,
          stackTrace: st,
          level: 900);
    }

    final reports = await _gardenPipeline.run(gardenId: gardenId);
    developer.log(
        '🏁 Orchestrator → ${reports.length} rapport(s) généré(s) pour gardenId=$gardenId',
        name: 'PlantIntelligenceOrchestrator');
    return reports;
  }

  // ---------------------------------------------------------------------------
  // Wrappers compatibility
  // ---------------------------------------------------------------------------
  Future<PlantAnalysisResult> analyzePlantConditions(
      {required String plantId,
      required String gardenId,
      PlantFreezed? plant}) async {
    final resolved = plant ?? await _resolver.resolve(plantId);
    return await _analysisPipeline.run(plant: resolved, gardenId: gardenId);
  }

  Future<ComprehensiveGardenAnalysis> analyzeGardenWithBioControl(
      {required String gardenId}) async {
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
        bioControlRecommendations: bioRecs);

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
