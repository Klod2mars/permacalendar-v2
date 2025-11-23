import 'dart:developer' as developer;

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

import '../entities/intelligence_report.dart';
import '../entities/plant_evolution_report.dart';
import '../entities/pest_threat_analysis.dart';
import '../entities/bio_control_recommendation.dart';
import '../entities/recommendation.dart';
import '../entities/analysis_result.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';

import '../repositories/i_analytics_repository.dart';

/// 🌿
/// NOUVEL ORCHESTRATEUR CLEAN ARCHITECTURE
/// ---------------------------------------
///
/// Rôles :
////   - Orchestrer les pipelines
////   - Construire les rapports
////   - Coordonner la persistance finale des rapports
////   - Appeler evolution pipeline
///
/// Ce fichier NE fait pas :
////   - d’analyse (delegué aux pipelines)
////   - de persistance de conditions/recommandations (déjà dans les pipelines ou services dédiés)
////   - de nettoyage Hive (delegué)
////   - d'évolution détaillée (delegué)
///
/// SRP strict : orchestrer.
///
class PlantIntelligenceOrchestrator {
  // Pipelines
  final AnalysisPipeline _analysisPipeline;
  final RecommendationPipeline _recommendationPipeline;
  final PestAnalysisPipeline? _pestPipeline;
  final BioControlPipeline? _bioPipeline;
  final EvolutionPipeline _evolutionPipeline;
  final GardenReportPipeline _gardenPipeline;

  // Services
  final IntelligenceScoringService _scoring;
  final ConfidenceService _confidence;
  final SummaryService _summary;

  // Utils
  final PlantResolver _resolver;

  // Repositories
  final IAnalyticsRepository _analyticsRepository;

  // Maintenance
  final GardenInitializationService _initService;

  PlantIntelligenceOrchestrator({
    required AnalysisPipeline analysisPipeline,
    required RecommendationPipeline recommendationPipeline,
    required EvolutionPipeline evolutionPipeline,
    required GardenReportPipeline gardenPipeline,
    required IntelligenceScoringService scoringService,
    required ConfidenceService confidenceService,
    required SummaryService summaryService,
    required PlantResolver resolver,
    required IAnalyticsRepository analyticsRepository,
    required GardenInitializationService initializationService,
    PestAnalysisPipeline? pestPipeline,
    BioControlPipeline? bioControlPipeline,
  })  : _analysisPipeline = analysisPipeline,
        _recommendationPipeline = recommendationPipeline,
        _evolutionPipeline = evolutionPipeline,
        _gardenPipeline = gardenPipeline,
        _scoring = scoringService,
        _confidence = confidenceService,
        _summary = summaryService,
        _resolver = resolver,
        _analyticsRepository = analyticsRepository,
        _initService = initializationService,
        _pestPipeline = pestPipeline,
        _bioPipeline = bioControlPipeline;

  // ---------------------------------------------------------------------------
  // 🌱 Analyse d’une seule plante (méthode principale)
  // ---------------------------------------------------------------------------

  Future<PlantIntelligenceReport> generateIntelligenceReport({
    required String plantId,
    required String gardenId,
    PlantFreezed? plant,
  }) async {
    developer.log(
      '🌿 Orchestrator → Analyse plante $plantId',
      name: 'PlantIntelligenceOrchestrator',
    );

    // 1) Résoudre la plante
    final resolvedPlant = plant ?? await _resolver.resolve(plantId);

    // 2) Analyse des conditions
    final analysis = await _analysisPipeline.run(
      plant: resolvedPlant,
      gardenId: gardenId,
    );

    // 3) Recommandations
    final recos = await _recommendationPipeline.run(
      plant: resolvedPlant,
      gardenId: gardenId,
      analysis: analysis,
    );

    // 4) Analyse des ravageurs
    PestThreatAnalysis? threats;
    if (_pestPipeline != null) {
      threats = await _pestPipeline!.run(gardenId);
    }

    // 5) Recommandations bio-control
    List<BioControlRecommendation> bioRecs = [];
    if (_bioPipeline != null) {
      bioRecs = await _bioPipeline!.run(threats);
    }

    // 6) Score global
    final timing = analysis.plantingTiming; // déjà dans le résultat
    final score = _scoring.compute(
      analysis: analysis,
      recommendations: recos,
      timing: timing,
    );

    // 7) Confiance
    final confidence = _confidence.compute(
      analysis: analysis,
      weather: analysis.weather,
    );

    // 8) Construction rapport final
    final report = PlantIntelligenceReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plantId: resolvedPlant.id,
      plantName: resolvedPlant.commonName,
      gardenId: gardenId,
      analysis: analysis,
      recommendations: recos,
      plantingTiming: timing,
      activeAlerts: const [],
      intelligenceScore: score,
      confidence: confidence,
      generatedAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 6)),
      metadata: {
        'historicalDataPoints': analysis.historicalCount,
      },
    );

    // 9) Persister rapport
    await _analyticsRepository.saveLatestReport(report);

    // 10) Évolution
    await _evolutionPipeline.run(current: report);

    return report;
  }

  // ---------------------------------------------------------------------------
  // 🌳 Analyse jardin complet
  // ---------------------------------------------------------------------------

  Future<List<PlantIntelligenceReport>> generateGardenIntelligenceReport({
    required String gardenId,
  }) async {
    developer.log(
      '🌳 Orchestrator → Analyse complète jardin $gardenId',
      name: 'PlantIntelligenceOrchestrator',
    );

    // Initialisation (nettoyage + cache invalidation)
    await _initService.initialize(gardenId: gardenId);

    // Pipeline jardin
    final reports = await _gardenPipeline.run(
      gardenId: gardenId,
    );

    developer.log(
      '🏁 Orchestrator → ${reports.length} rapport(s) généré(s)',
      name: 'PlantIntelligenceOrchestrator',
    );

    return reports;
  }
}
