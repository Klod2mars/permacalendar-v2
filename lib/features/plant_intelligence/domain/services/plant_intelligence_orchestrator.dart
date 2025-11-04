import 'dart:developer' as developer;
import '../entities/analysis_result.dart';
import '../entities/intelligence_report.dart';
import '../entities/recommendation.dart';
import '../entities/notification_alert.dart';
import '../entities/weather_condition.dart';
import '../entities/pest_threat_analysis.dart';
import '../entities/bio_control_recommendation.dart';
import '../entities/comprehensive_garden_analysis.dart';
import '../entities/plant_evolution_report.dart';
import '../entities/plant_condition.dart';
import '../repositories/i_plant_condition_repository.dart';
import '../repositories/i_weather_repository.dart';
import '../repositories/i_garden_context_repository.dart';
import '../repositories/i_recommendation_repository.dart';
import '../repositories/i_analytics_repository.dart';
import '../repositories/i_bio_control_recommendation_repository.dart';
import '../usecases/analyze_plant_conditions_usecase.dart';
import '../usecases/evaluate_planting_timing_usecase.dart';
import '../usecases/generate_recommendations_usecase.dart';
import '../usecases/analyze_pest_threats_usecase.dart';
import '../usecases/generate_bio_control_recommendations_usecase.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../plant_catalog/data/repositories/plant_hive_repository.dart';
import '../../../../core/errors/plant_exceptions.dart';
import '../../../../core/services/aggregation/garden_aggregation_hub.dart';
import 'plant_intelligence_evolution_tracker.dart';
import 'package:uuid/uuid.dart';

/// Orchestrateur domain pour l'intelligence végétale
///
/// Coordonne les différents UseCases pour générer des rapports complets
/// d'intelligence végétale. Fait partie de la couche domain.
///
/// **REFACTORÉ - Prompt 4 : ISP (Interface Segregation Principle)**
///
/// Utilise maintenant 5 interfaces spécialisées au lieu d'une seule :
/// - IPlantConditionRepository : Pour l'historique des conditions
/// - IWeatherRepository : Pour les conditions météo
/// - IGardenContextRepository : Pour le contexte jardin et les plantes
/// - IRecommendationRepository : Pour la sauvegarde des recommandations
/// - IAnalyticsRepository : Pour la sauvegarde des résultats d'analyse
///
/// **Responsabilités :**
/// - Coordonner les 3 UseCases (analyse, timing, recommandations)
/// - Générer des rapports complets PlantIntelligenceReport
/// - Sauvegarder les résultats via les repositories spécialisés
/// - Calculer les métriques globales (score d'intelligence, confiance)
///
/// **Architecture :**
/// Cette classe est dans le domain et orchestre la logique métier.
/// Elle remplace PlantIntelligenceEngine qui était mal placé dans core/services.
///
/// **CURSOR PROMPT A3 - Intelligence Evolution Tracker Integration**
///
/// Intègre le PlantIntelligenceEvolutionTracker pour permettre la comparaison
/// d'évolution entre deux sessions d'analyse (non encore utilisé activement).
class PlantIntelligenceOrchestrator {
  final IPlantConditionRepository _conditionRepository;
  final IWeatherRepository _weatherRepository;
  final IGardenContextRepository _gardenRepository;
  final IRecommendationRepository _recommendationRepository;
  final IAnalyticsRepository _analyticsRepository;
  final IBioControlRecommendationRepository?
      _bioControlRecommendationRepository;
  final PlantHiveRepository _plantCatalogRepository;
  final AnalyzePlantConditionsUsecase _analyzeUsecase;
  final EvaluatePlantingTimingUsecase _evaluateTimingUsecase;
  final GenerateRecommendationsUsecase _generateRecommendationsUsecase;
  final AnalyzePestThreatsUsecase? _analyzePestThreatsUsecase;
  final GenerateBioControlRecommendationsUsecase? _generateBioControlUsecase;
  final GardenAggregationHub? _gardenAggregationHub;

  /// 🔄 CURSOR PROMPT A6 - Evolution Tracker
  ///
  /// Service pour comparer l'évolution entre deux rapports d'intelligence.
  /// Intégré dans generateIntelligenceReport pour traquer les changements.
  final PlantIntelligenceEvolutionTracker _evolutionTracker;

  PlantIntelligenceOrchestrator({
    required IPlantConditionRepository conditionRepository,
    required IWeatherRepository weatherRepository,
    required IGardenContextRepository gardenRepository,
    required IRecommendationRepository recommendationRepository,
    required IAnalyticsRepository analyticsRepository,
    required PlantHiveRepository plantCatalogRepository,
    required AnalyzePlantConditionsUsecase analyzeUsecase,
    required EvaluatePlantingTimingUsecase evaluateTimingUsecase,
    required GenerateRecommendationsUsecase generateRecommendationsUsecase,
    required PlantIntelligenceEvolutionTracker evolutionTracker,
    IBioControlRecommendationRepository? bioControlRecommendationRepository,
    AnalyzePestThreatsUsecase? analyzePestThreatsUsecase,
    GenerateBioControlRecommendationsUsecase? generateBioControlUsecase,
    GardenAggregationHub? gardenAggregationHub,
  })  : _conditionRepository = conditionRepository,
        _weatherRepository = weatherRepository,
        _gardenRepository = gardenRepository,
        _recommendationRepository = recommendationRepository,
        _analyticsRepository = analyticsRepository,
        _plantCatalogRepository = plantCatalogRepository,
        _bioControlRecommendationRepository =
            bioControlRecommendationRepository,
        _analyzeUsecase = analyzeUsecase,
        _evaluateTimingUsecase = evaluateTimingUsecase,
        _generateRecommendationsUsecase = generateRecommendationsUsecase,
        _analyzePestThreatsUsecase = analyzePestThreatsUsecase,
        _generateBioControlUsecase = generateBioControlUsecase,
        _gardenAggregationHub = gardenAggregationHub,
        _evolutionTracker = evolutionTracker;

  /// Génère un rapport complet d'intelligence pour une plante
  ///
  /// [plantId] - ID de la plante à analyser
  /// [gardenId] - ID du jardin
  /// [plant] - Entité plante (optionnel, sera récupérée si non fournie)
  ///
  /// Retourne un [PlantIntelligenceReport] complet
  ///
  /// Lance [PlantIntelligenceOrchestratorException] si :
  /// - Le contexte jardin n'est pas trouvé
  /// - Les conditions météo ne sont pas disponibles
  /// - La plante n'est pas trouvée
  Future<PlantIntelligenceReport> generateIntelligenceReport({
    required String plantId,
    required String gardenId,
    PlantFreezed? plant,
  }) async {
    developer.log(
      'Génération rapport intelligence pour plante $plantId',
      name: 'PlantIntelligenceOrchestrator',
    );

    try {
      // 🔄 CURSOR PROMPT A4 - Récupérer le dernier rapport pour comparaison
      PlantIntelligenceReport? previousReport;
      try {
        previousReport = await _analyticsRepository.getLastReport(plantId);
        if (previousReport != null) {
          developer.log(
            '📊 Rapport précédent trouvé (généré le ${previousReport.generatedAt}, score: ${previousReport.intelligenceScore.toStringAsFixed(1)})',
            name: 'PlantIntelligenceOrchestrator',
          );
        } else {
          developer.log(
            'ℹ️ Aucun rapport précédent trouvé - première analyse pour cette plante',
            name: 'PlantIntelligenceOrchestrator',
          );
        }
      } catch (e) {
        developer.log(
          '⚠️ Erreur récupération rapport précédent (non bloquant): $e',
          name: 'PlantIntelligenceOrchestrator',
          level: 900,
        );
      }

      // 1. Récupérer les données nécessaires
      final resolvedPlant = plant ?? await _getPlant(plantId);
      final gardenContext = await _gardenRepository.getGardenContext(gardenId);
      final weather =
          await _weatherRepository.getCurrentWeatherCondition(gardenId);

      if (gardenContext == null) {
        throw PlantIntelligenceOrchestratorException(
            'Contexte jardin $gardenId non trouvé');
      }

      if (weather == null) {
        throw PlantIntelligenceOrchestratorException(
            'Conditions météo pour jardin $gardenId non disponibles');
      }

      // 2. Exécuter l'analyse des conditions
      developer.log('Analyse des conditions...',
          name: 'PlantIntelligenceOrchestrator');
      final analysisResult = await _analyzeUsecase.execute(
        plant: resolvedPlant,
        weather: weather,
        garden: gardenContext,
      );

      // 3. Évaluer le timing de plantation
      developer.log('Évaluation timing plantation...',
          name: 'PlantIntelligenceOrchestrator');
      final plantingTiming = await _evaluateTimingUsecase.execute(
        plant: resolvedPlant,
        weather: weather,
        garden: gardenContext,
      );

      // 4. Récupérer l'historique des conditions (pour recommandations contextuelles)
      final historicalConditions =
          await _conditionRepository.getPlantConditionHistory(
        plantId: plantId,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        limit: 100,
      );

      // 5. Générer les recommandations
      developer.log('Génération recommandations...',
          name: 'PlantIntelligenceOrchestrator');
      final recommendations = await _generateRecommendationsUsecase.execute(
        plant: resolvedPlant,
        analysisResult: analysisResult,
        weather: weather,
        garden: gardenContext,
        historicalConditions:
            historicalConditions.isNotEmpty ? historicalConditions : null,
      );

      // 6. Récupérer les alertes actives
      final activeAlerts =
          await _analyticsRepository.getActiveAlerts(plantId: plantId);

      // 7. Sauvegarder l'analyse et les recommandations
      await _saveResults(analysisResult, recommendations, plantId);

      // 8. Calculer le score global d'intelligence
      final intelligenceScore = _calculateIntelligenceScore(
        analysisResult: analysisResult,
        recommendations: recommendations,
        plantingTiming: plantingTiming,
      );

      // 9. Calculer la confiance globale
      final confidence = _calculateOverallConfidence(
        analysisResult: analysisResult,
        weather: weather,
      );

      // 10. Créer le rapport
      final report = PlantIntelligenceReport(
        id: const Uuid().v4(),
        plantId: plantId,
        plantName: resolvedPlant.commonName,
        gardenId: gardenId,
        analysis: analysisResult,
        recommendations: recommendations,
        plantingTiming: plantingTiming,
        activeAlerts: _convertAlertsToNotifications(activeAlerts),
        intelligenceScore: intelligenceScore,
        confidence: confidence,
        generatedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 6)),
        metadata: {
          'weatherAge': DateTime.now().difference(weather.measuredAt).inHours,
          'historicalDataPoints': historicalConditions.length,
        },
      );

      developer.log(
        'Rapport généré avec succès (score: ${intelligenceScore.toStringAsFixed(1)})',
        name: 'PlantIntelligenceOrchestrator',
      );

      // 💾 CURSOR PROMPT A4 - Sauvegarder le rapport pour comparaisons futures
      try {
        await _analyticsRepository.saveLatestReport(report);
        developer.log(
          '✅ Rapport sauvegardé pour comparaisons futures',
          name: 'PlantIntelligenceOrchestrator',
        );
      } catch (e) {
        developer.log(
          '⚠️ Erreur sauvegarde rapport (non bloquant): $e',
          name: 'PlantIntelligenceOrchestrator',
          level: 900,
        );
      }

      // 📈 CURSOR PROMPT A6 - Track evolution
      try {
        if (previousReport != null) {
          final evolution = _evolutionTracker.compareReports(
            previousReport,
            report,
          );

          // Determine trend emoji and sign
          final String trendEmoji;
          final String deltaSign;
          if (evolution.isImproved) {
            trendEmoji = '📈';
            deltaSign = '+';
          } else if (evolution.isDegraded) {
            trendEmoji = '📉';
            deltaSign = '';
          } else {
            trendEmoji = '➡️';
            deltaSign = evolution.scoreDelta >= 0 ? '+' : '';
          }

          // Log the delta
          developer.log(
            '$trendEmoji Evolution detected: ${evolution.isImproved ? "up" : evolution.isDegraded ? "down" : "stable"} '
            '(Δ $deltaSign${evolution.scoreDelta.toStringAsFixed(2)} points)',
            name: 'IntelligenceEvolution',
          );

          // 💾 CURSOR PROMPT A7 - Store evolution for future statistics and timeline visualization
          try {
            // Convert IntelligenceEvolutionSummary to PlantEvolutionReport
            final evolutionReport = PlantEvolutionReport(
              plantId: plantId,
              previousDate: previousReport.generatedAt,
              currentDate: report.generatedAt,
              previousScore: previousReport.intelligenceScore,
              currentScore: report.intelligenceScore,
              deltaScore: evolution.scoreDelta,
              trend: evolution.isImproved
                  ? 'up'
                  : evolution.isDegraded
                      ? 'down'
                      : 'stable',
              improvedConditions: _extractImprovedConditions(evolution),
              degradedConditions: _extractDegradedConditions(evolution),
              unchangedConditions: _extractUnchangedConditions(evolution),
            );

            await _analyticsRepository.saveEvolutionReport(evolutionReport);

            developer.log(
              '💾 Evolution report saved successfully',
              name: 'IntelligenceEvolution',
            );
          } catch (saveError, saveStack) {
            developer.log(
              '⚠️ Evolution report save failed (non-blocking)',
              name: 'IntelligenceEvolution',
              error: saveError,
              stackTrace: saveStack,
              level: 900,
            );
          }
        }
      } catch (e, stack) {
        developer.log(
          '⚠️ Evolution comparison failed (non-blocking)',
          name: 'IntelligenceEvolution',
          error: e,
          stackTrace: stack,
          level: 900,
        );
      }

      return report;
    } catch (e, stackTrace) {
      developer.log(
        'Erreur génération rapport',
        name: 'PlantIntelligenceOrchestrator',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Génère un rapport pour tout le jardin
  ///
  /// Génère un rapport pour chaque plante active du jardin
  ///
  /// [gardenId] - ID du jardin
  ///
  /// Retourne une liste de [PlantIntelligenceReport] pour toutes les plantes
  Future<List<PlantIntelligenceReport>> generateGardenIntelligenceReport({
    required String gardenId,
  }) async {
    developer.log(
      'Génération rapport intelligence pour jardin $gardenId',
      name: 'PlantIntelligenceOrchestrator',
    );

    // 🧹 CURSOR PROMPT 2: Invalider tous les caches avant l'analyse
    await invalidateAllCache();

    try {
      // Récupérer toutes les plantes du jardin
      final plants = await _gardenRepository.getGardenPlants(gardenId);

      developer.log(
        '${plants.length} plantes à analyser',
        name: 'PlantIntelligenceOrchestrator',
      );

      // Générer un rapport pour chaque plante
      final reports = <PlantIntelligenceReport>[];

      for (final plant in plants) {
        try {
          final report = await generateIntelligenceReport(
            plantId: plant.id,
            gardenId: gardenId,
            plant: plant,
          );
          reports.add(report);
        } catch (e) {
          developer.log(
            'Erreur génération rapport pour plante ${plant.id}: $e',
            name: 'PlantIntelligenceOrchestrator',
            level: 900,
          );
          // Continue avec les autres plantes
        }
      }

      developer.log(
        '${reports.length}/${plants.length} rapports générés',
        name: 'PlantIntelligenceOrchestrator',
      );

      return reports;
    } catch (e, stackTrace) {
      developer.log(
        'Erreur génération rapport jardin',
        name: 'PlantIntelligenceOrchestrator',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Analyse uniquement les conditions d'une plante (sans rapport complet)
  ///
  /// Utile pour des analyses rapides sans générer un rapport complet
  ///
  /// [plantId] - ID de la plante
  /// [gardenId] - ID du jardin
  /// [plant] - Entité plante (optionnel)
  ///
  /// Retourne un [PlantAnalysisResult]
  ///
  /// Lance :
  /// - [PlantNotFoundException] si la plante n'est pas trouvée
  /// - [EmptyPlantCatalogException] si le catalogue est vide
  /// - [PlantIntelligenceOrchestratorException] pour les autres erreurs
  Future<PlantAnalysisResult> analyzePlantConditions({
    required String plantId,
    required String gardenId,
    PlantFreezed? plant,
  }) async {
    developer.log(
        '🔍 DIAGNOSTIC - Début analyzePlantConditions: plantId=$plantId, gardenId=$gardenId',
        name: 'PlantIntelligenceOrchestrator');

    try {
      developer.log('🔍 DIAGNOSTIC - Récupération plante...',
          name: 'PlantIntelligenceOrchestrator');
      final resolvedPlant = plant ?? await _getPlant(plantId);
      developer.log(
          '🔍 DIAGNOSTIC - Plante récupérée: ${resolvedPlant.commonName} (${resolvedPlant.scientificName})',
          name: 'PlantIntelligenceOrchestrator');

      developer.log('🔍 DIAGNOSTIC - Récupération contexte jardin...',
          name: 'PlantIntelligenceOrchestrator');
      final gardenContext = await _gardenRepository.getGardenContext(gardenId);
      developer.log(
          '🔍 DIAGNOSTIC - Contexte jardin: ${gardenContext != null ? "OUI" : "NON"}',
          name: 'PlantIntelligenceOrchestrator');

      developer.log('🔍 DIAGNOSTIC - Récupération météo...',
          name: 'PlantIntelligenceOrchestrator');
      final weather =
          await _weatherRepository.getCurrentWeatherCondition(gardenId);
      developer.log('🔍 DIAGNOSTIC - Météo: ${weather != null ? "OUI" : "NON"}',
          name: 'PlantIntelligenceOrchestrator');

      if (gardenContext == null || weather == null) {
        developer.log(
            '❌ DIAGNOSTIC - Données manquantes: gardenContext=${gardenContext != null}, weather=${weather != null}',
            name: 'PlantIntelligenceOrchestrator');
        throw const PlantIntelligenceOrchestratorException(
            'Données manquantes');
      }

      developer.log('🔍 DIAGNOSTIC - Exécution UseCase analyse...',
          name: 'PlantIntelligenceOrchestrator');
      final result = await _analyzeUsecase.execute(
        plant: resolvedPlant,
        weather: weather,
        garden: gardenContext,
      );

      developer.log(
          '✅ DIAGNOSTIC - Analyse terminée: score=${result.healthScore}',
          name: 'PlantIntelligenceOrchestrator');
      return result;
    } catch (e, stackTrace) {
      // Remonter les exceptions spécifiques de plantes telles quelles
      if (e is PlantNotFoundException || e is EmptyPlantCatalogException) {
        developer.log(
          '❌ Erreur liée au catalogue de plantes: $e',
          name: 'PlantIntelligenceOrchestrator',
          level: 1000,
        );
        rethrow;
      }

      // Pour les autres erreurs, logger et remonter
      developer.log(
        '❌ Erreur lors de l\'analyse des conditions',
        name: 'PlantIntelligenceOrchestrator',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
      rethrow;
    }
  }

  /// 🌱 BIOLOGICAL CONTROL INTEGRATION v2.2.A3b
  ///
  /// Génère un rapport d'intelligence complet incluant l'analyse de lutte biologique
  ///
  /// PHILOSOPHY:
  /// Cette méthode étend l'intelligence végétale pour inclure l'analyse des menaces
  /// ravageurs et la génération de recommandations de lutte biologique.
  /// Elle respecte le flux de vérité : Sanctuaire (Observations) → Modern → Intelligence
  ///
  /// [gardenId] - ID du jardin à analyser
  ///
  /// Retourne un [ComprehensiveGardenAnalysis] incluant :
  /// - Analyse des conditions des plantes
  /// - Analyse des menaces ravageurs
  /// - Recommandations de lutte biologique
  Future<ComprehensiveGardenAnalysis> analyzeGardenWithBioControl({
    required String gardenId,
  }) async {
    developer.log(
      '🌱 Génération analyse complète avec lutte biologique pour jardin $gardenId',
      name: 'PlantIntelligenceOrchestrator',
    );

    try {
      // 1. Analyse des plantes (existant) - cache invalidé dans generateGardenIntelligenceReport
      final plantReports =
          await generateGardenIntelligenceReport(gardenId: gardenId);

      // 2. NOUVEAU : Analyse des menaces ravageurs
      PestThreatAnalysis? pestThreats;
      if (_analyzePestThreatsUsecase != null) {
        developer.log('🐛 Analyse des menaces ravageurs...',
            name: 'PlantIntelligenceOrchestrator');
        try {
          pestThreats = await _analyzePestThreatsUsecase!.execute(gardenId);
          developer.log(
            '✅ ${pestThreats.totalThreats} menace(s) détectée(s)',
            name: 'PlantIntelligenceOrchestrator',
          );
        } catch (e) {
          developer.log(
            '⚠️ Erreur analyse menaces (non bloquant): $e',
            name: 'PlantIntelligenceOrchestrator',
            level: 900,
          );
        }
      }

      // 3. NOUVEAU : Génération recommandations lutte biologique
      final bioControlRecommendations = <BioControlRecommendation>[];
      if (_generateBioControlUsecase != null &&
          _bioControlRecommendationRepository != null &&
          pestThreats != null) {
        developer.log(
          '🌿 Génération recommandations lutte biologique...',
          name: 'PlantIntelligenceOrchestrator',
        );

        for (final threat in pestThreats.threats) {
          try {
            final recs =
                await _generateBioControlUsecase!.execute(threat.observation);

            // Sauvegarder chaque recommandation
            for (final rec in recs) {
              await _bioControlRecommendationRepository!
                  .saveRecommendation(rec);
            }

            bioControlRecommendations.addAll(recs);
          } catch (e) {
            developer.log(
              '⚠️ Erreur génération recommandations pour observation ${threat.observation.id}: $e',
              name: 'PlantIntelligenceOrchestrator',
              level: 900,
            );
          }
        }

        developer.log(
          '✅ ${bioControlRecommendations.length} recommandation(s) générée(s)',
          name: 'PlantIntelligenceOrchestrator',
        );
      }

      // 4. Calcul du score de santé global
      final overallHealthScore = _calculateOverallGardenHealth(
        plantReports: plantReports,
        pestThreats: pestThreats,
      );

      // 5. Créer l'analyse complète
      final analysis = ComprehensiveGardenAnalysis(
        gardenId: gardenId,
        plantReports: plantReports,
        pestThreats: pestThreats,
        bioControlRecommendations: bioControlRecommendations,
        overallHealthScore: overallHealthScore,
        analyzedAt: DateTime.now(),
        summary: _generateGardenSummary(
          plantReports: plantReports,
          pestThreats: pestThreats,
          bioControlRecommendations: bioControlRecommendations,
        ),
      );

      developer.log(
        '✅ Analyse complète générée (santé globale: ${overallHealthScore.toStringAsFixed(1)}%)',
        name: 'PlantIntelligenceOrchestrator',
      );

      return analysis;
    } catch (e, stackTrace) {
      developer.log(
        'Erreur génération analyse complète',
        name: 'PlantIntelligenceOrchestrator',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // ==================== CACHE MANAGEMENT METHODS ====================

  /// 🚀 Initialise l'orchestrateur pour un jardin spécifique
  ///
  /// **CURSOR PROMPT A2 - Garden Initialization Method**
  ///
  /// Cette méthode prépare l'orchestrateur pour une nouvelle session d'analyse
  /// en effectuant les opérations de maintenance nécessaires :
  ///
  /// 1. Nettoyage des conditions orphelines dans Hive
  /// 2. Invalidation de tous les caches
  ///
  /// **Responsabilités :**
  /// - Appeler `_cleanOrphanedConditionsInHive()` pour supprimer les données obsolètes
  /// - Appeler `invalidateAllCache()` pour rafraîchir les caches
  /// - Logger toutes les opérations pour la traçabilité
  /// - Être résiliente : ne jamais lancer d'exception, continuer même si une étape échoue
  /// - Être idempotente (peut être appelée plusieurs fois sans effets secondaires)
  ///
  /// **Architecture :**
  /// Respecte Clean Architecture en orchestrant les méthodes de maintenance.
  /// Cette méthode est publique et peut être appelée avant `generateGardenIntelligenceReport()`.
  ///
  /// **Utilisation :**
  /// ```dart
  /// await orchestrator.initializeForGarden(gardenId: 'garden_1');
  /// final reports = await orchestrator.generateGardenIntelligenceReport(gardenId: 'garden_1');
  /// ```
  ///
  /// **Paramètres :**
  /// - [gardenId] : ID du jardin à initialiser
  ///
  /// **Retourne :** Future<Map<String, dynamic>> avec les statistiques d'initialisation
  Future<Map<String, dynamic>> initializeForGarden({
    required String gardenId,
  }) async {
    developer.log(
      '🚀 Initialisation pour jardin $gardenId',
      name: 'PlantIntelligenceOrchestrator',
    );

    final stats = <String, dynamic>{
      'gardenId': gardenId,
      'cleanupSuccess': false,
      'cacheInvalidationSuccess': false,
      'orphanedConditionsRemoved': 0,
      'errors': <String>[],
    };

    try {
      // Étape 1 : Nettoyage des conditions orphelines
      developer.log(
        '🧹 Étape 1/2 : Nettoyage des conditions orphelines',
        name: 'PlantIntelligenceOrchestrator',
      );

      try {
        final deletedCount = await _cleanOrphanedConditionsInHive();
        stats['orphanedConditionsRemoved'] = deletedCount;
        stats['cleanupSuccess'] = true;

        developer.log(
          '✅ Nettoyage terminé : $deletedCount condition(s) supprimée(s)',
          name: 'PlantIntelligenceOrchestrator',
        );
      } catch (e, stackTrace) {
        final errorMsg = 'Erreur lors du nettoyage (non bloquant): $e';
        stats['errors'].add(errorMsg);

        developer.log(
          '⚠️ $errorMsg',
          name: 'PlantIntelligenceOrchestrator',
          error: e,
          stackTrace: stackTrace,
          level: 900,
        );
        // Continuer avec l'invalidation du cache même si le nettoyage échoue
      }

      // Étape 2 : Invalidation de tous les caches
      developer.log(
        '🧹 Étape 2/2 : Invalidation des caches',
        name: 'PlantIntelligenceOrchestrator',
      );

      try {
        await invalidateAllCache();
        stats['cacheInvalidationSuccess'] = true;

        developer.log(
          '✅ Caches invalidés avec succès',
          name: 'PlantIntelligenceOrchestrator',
        );
      } catch (e, stackTrace) {
        final errorMsg =
            'Erreur lors de l\'invalidation des caches (non bloquant): $e';
        stats['errors'].add(errorMsg);

        developer.log(
          '⚠️ $errorMsg',
          name: 'PlantIntelligenceOrchestrator',
          error: e,
          stackTrace: stackTrace,
          level: 900,
        );
        // Continuer même si l'invalidation échoue
      }

      // Résumé final
      final successCount = (stats['cleanupSuccess'] as bool ? 1 : 0) +
          (stats['cacheInvalidationSuccess'] as bool ? 1 : 0);

      developer.log(
        '🎯 Initialisation terminée : $successCount/2 étape(s) réussie(s)',
        name: 'PlantIntelligenceOrchestrator',
      );

      if ((stats['errors'] as List).isEmpty) {
        developer.log(
          '✅ Initialisation complète avec succès pour jardin $gardenId',
          name: 'PlantIntelligenceOrchestrator',
        );
      } else {
        developer.log(
          '⚠️ Initialisation terminée avec ${(stats['errors'] as List).length} avertissement(s)',
          name: 'PlantIntelligenceOrchestrator',
          level: 900,
        );
      }

      return stats;
    } catch (e, stackTrace) {
      // Gestion défensive : ne jamais propager l'erreur
      developer.log(
        '❌ Erreur critique lors de l\'initialisation (non bloquant)',
        name: 'PlantIntelligenceOrchestrator',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );

      stats['errors'].add('Erreur critique: $e');
      return stats;
    }
  }

  /// 🧹 Invalide tous les caches de l'orchestrateur et des dépendances
  ///
  /// **Cursor Prompt 2 - Cache Invalidation Method**
  ///
  /// Cette méthode garantit un état propre avant chaque nouvelle session d'analyse
  /// en invalidant tous les caches internes et des services dépendants.
  ///
  /// **Responsabilités :**
  /// - Invalider le cache du GardenAggregationHub si disponible
  /// - Logger toutes les opérations pour la traçabilité
  /// - Être idempotente (peut être appelée plusieurs fois sans effets secondaires)
  /// - Ne jamais lancer d'exception (gestion défensive des erreurs)
  ///
  /// **Architecture :**
  /// Respecte Clean Architecture en n'interagissant qu'avec les dépendances injectées.
  /// Aucun accès direct à Hive ou autres implémentations.
  ///
  /// **Utilisation :**
  /// Doit être appelée au début de toute initialisation (ex: avant analyse jardin)
  /// pour garantir que les données ne sont pas obsolètes ou corrompues.
  ///
  /// **Retourne :** Future<void> - opération asynchrone sans valeur de retour
  Future<void> invalidateAllCache() async {
    developer.log(
      '🧹 Début invalidation de tous les caches',
      name: 'PlantIntelligenceOrchestrator',
    );

    int invalidatedServices = 0;

    try {
      // 1. Invalider le cache du GardenAggregationHub si disponible
      if (_gardenAggregationHub != null) {
        try {
          _gardenAggregationHub!.clearCache();
          invalidatedServices++;
          developer.log(
            '✅ Cache GardenAggregationHub invalidé',
            name: 'PlantIntelligenceOrchestrator',
          );
        } catch (e) {
          developer.log(
            '⚠️ Erreur invalidation GardenAggregationHub (non bloquant): $e',
            name: 'PlantIntelligenceOrchestrator',
            level: 900,
          );
        }
      } else {
        developer.log(
          'ℹ️ GardenAggregationHub non injecté - cache non invalidé',
          name: 'PlantIntelligenceOrchestrator',
          level: 500,
        );
      }

      // 2. Note: Les repositories n'ont pas d'interface de cache standardisée
      // Si des méthodes de cache sont ajoutées aux interfaces repository à l'avenir,
      // les appeler ici de manière défensive

      // Log du résumé
      developer.log(
        '🎯 Invalidation terminée: $invalidatedServices service(s) traité(s)',
        name: 'PlantIntelligenceOrchestrator',
      );

      developer.log(
        '✅ Tous les caches invalidés avec succès',
        name: 'PlantIntelligenceOrchestrator',
      );
    } catch (e, stackTrace) {
      // Gestion défensive : logger mais ne jamais propager l'erreur
      // L'invalidation du cache ne doit jamais bloquer l'application
      developer.log(
        '❌ Erreur lors de l\'invalidation des caches (non bloquant)',
        name: 'PlantIntelligenceOrchestrator',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
    }
  }

  // ==================== MÉTHODES PRIVÉES ====================

  /// Récupère une plante depuis le catalogue
  ///
  /// **REFACTORÉ - Audit & Renforcement :**
  /// - Logs détaillés pour le debug
  /// - Normalisation des IDs (trim + toLowerCase)
  /// - Exception structurée avec contexte
  /// - Vérification du catalogue vide
  ///
  /// Lance [PlantNotFoundException] si la plante n'est pas trouvée
  /// Lance [EmptyPlantCatalogException] si le catalogue est vide
  Future<PlantFreezed> _getPlant(String plantId) async {
    developer.log(
      '🔍 Recherche de la plante "$plantId"',
      name: 'PlantIntelligenceOrchestrator',
    );

    try {
      // Normalisation de l'ID recherché
      final normalizedId = plantId.trim().toLowerCase();
      developer.log(
        '🔍 ID normalisé: "$normalizedId" (original: "$plantId")',
        name: 'PlantIntelligenceOrchestrator',
      );

      // Récupérer toutes les plantes du catalogue pour diagnostiquer
      final allPlants = await _plantCatalogRepository.getAllPlants();

      developer.log(
        '📚 Catalogue chargé: ${allPlants.length} plantes disponibles',
        name: 'PlantIntelligenceOrchestrator',
      );

      // Vérification catalogue vide
      if (allPlants.isEmpty) {
        developer.log(
          '❌ ERREUR: Le catalogue de plantes est vide!',
          name: 'PlantIntelligenceOrchestrator',
          level: 1000,
        );
        throw const EmptyPlantCatalogException(
          'Le catalogue de plantes est vide. Vérifiez que plants.json est correctement chargé.',
        );
      }

      // Logger les premiers IDs disponibles pour debug
      final availableIds = allPlants.map((p) => p.id).toList();
      developer.log(
        '📋 Premiers IDs disponibles (${availableIds.take(10).length}/${availableIds.length}): ${availableIds.take(10).join(", ")}',
        name: 'PlantIntelligenceOrchestrator',
      );

      // Recherche avec comparaison normalisée
      PlantFreezed? foundPlant;

      for (final plant in allPlants) {
        final plantIdNormalized = plant.id.trim().toLowerCase();
        if (plantIdNormalized == normalizedId) {
          foundPlant = plant;
          break;
        }
      }

      // Si plante trouvée
      if (foundPlant != null) {
        developer.log(
          '✅ Plante trouvée: "${foundPlant.commonName}" (${foundPlant.scientificName})',
          name: 'PlantIntelligenceOrchestrator',
        );
        return foundPlant;
      }

      // Plante non trouvée - Exception structurée
      developer.log(
        '❌ Plante "$plantId" introuvable dans le catalogue',
        name: 'PlantIntelligenceOrchestrator',
        level: 1000,
      );

      throw PlantNotFoundException(
        plantId: plantId,
        catalogSize: allPlants.length,
        searchedIds: availableIds,
        message:
            'Vérifiez que l\'ID est correct et que la plante existe dans plants.json',
      );
    } catch (e) {
      // Si c'est déjà une PlantNotFoundException ou EmptyPlantCatalogException, on la remonte
      if (e is PlantNotFoundException || e is EmptyPlantCatalogException) {
        rethrow;
      }

      // Sinon, logger et encapsuler dans une exception orchestrateur
      developer.log(
        '❌ Erreur inattendue lors de la récupération de la plante',
        name: 'PlantIntelligenceOrchestrator',
        error: e,
        level: 1000,
      );

      throw PlantIntelligenceOrchestratorException(
        'Erreur lors de la récupération de la plante $plantId: $e',
      );
    }
  }

  /// Sauvegarde les résultats d'analyse et recommandations
  Future<void> _saveResults(
    PlantAnalysisResult analysis,
    List<Recommendation> recommendations,
    String plantId,
  ) async {
    try {
      // Sauvegarder chaque condition
      await _conditionRepository.savePlantCondition(
        plantId: plantId,
        condition: analysis.temperature,
      );
      await _conditionRepository.savePlantCondition(
        plantId: plantId,
        condition: analysis.humidity,
      );
      await _conditionRepository.savePlantCondition(
        plantId: plantId,
        condition: analysis.light,
      );
      await _conditionRepository.savePlantCondition(
        plantId: plantId,
        condition: analysis.soil,
      );

      // Sauvegarder les recommandations
      for (final recommendation in recommendations) {
        await _recommendationRepository.saveRecommendation(
          plantId: plantId,
          recommendation: recommendation,
        );
      }

      // Sauvegarder le résultat d'analyse complet
      await _analyticsRepository.saveAnalysisResult(
        plantId: plantId,
        analysisType: 'complete_analysis',
        result: {
          'overallHealth': analysis.overallHealth.toString(),
          'healthScore': analysis.healthScore,
          'confidence': analysis.confidence,
          'warnings': analysis.warnings,
          'strengths': analysis.strengths,
        },
        confidence: analysis.confidence,
      );
    } catch (e) {
      developer.log(
        'Erreur sauvegarde résultats (non bloquant): $e',
        name: 'PlantIntelligenceOrchestrator',
        level: 900,
      );
      // Ne pas bloquer si la sauvegarde échoue
    }
  }

  /// Calcule le score global d'intelligence (0-100)
  ///
  /// Le score est calculé à partir de :
  /// - 60% : Score de santé de l'analyse
  /// - 20% : Score du timing de plantation
  /// - 20% : Bonus basé sur le nombre de recommandations critiques
  double _calculateIntelligenceScore({
    required PlantAnalysisResult analysisResult,
    required List<Recommendation> recommendations,
    required PlantingTimingEvaluation plantingTiming,
  }) {
    // Base sur le score de santé
    double score = analysisResult.healthScore * 0.6;

    // Bonus si le timing est optimal
    score += plantingTiming.timingScore * 0.2;

    // Bonus si peu de recommandations critiques (plante en bonne santé)
    final criticalRecommendations = recommendations
        .where((r) => r.priority == RecommendationPriority.critical)
        .length;

    if (criticalRecommendations == 0) {
      score += 20.0;
    } else {
      score += (20.0 - criticalRecommendations * 5.0).clamp(0.0, 20.0);
    }

    return score.clamp(0.0, 100.0);
  }

  /// Calcule la confiance globale du rapport (0-1)
  ///
  /// La confiance est réduite si les données météo sont anciennes
  double _calculateOverallConfidence({
    required PlantAnalysisResult analysisResult,
    required WeatherCondition weather,
  }) {
    // Base sur la confiance de l'analyse
    double confidence = analysisResult.confidence;

    // Réduire si les données météo sont anciennes
    final weatherAge = DateTime.now().difference(weather.measuredAt).inHours;
    if (weatherAge > 12) {
      confidence *= 0.8;
    }
    if (weatherAge > 24) {
      confidence *= 0.7;
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Convertit les alertes brutes en NotificationAlert
  ///
  /// TODO: Implémenter la conversion complète
  /// Pour l'instant retourne une liste vide
  List<NotificationAlert> _convertAlertsToNotifications(
      List<Map<String, dynamic>> alerts) {
    // Convertir chaque alerte en NotificationAlert
    return alerts
        .map((alert) {
          try {
            final isRead = alert['read'] as bool? ?? false;
            return NotificationAlert(
              id: alert['id'] as String? ?? const Uuid().v4(),
              title: alert['title'] as String? ?? 'Alerte',
              message: alert['message'] as String? ?? '',
              type: NotificationType.recommendation,
              priority: _mapPriorityFromString(alert['severity'] as String?),
              createdAt: alert['createdAt'] != null
                  ? DateTime.parse(alert['createdAt'] as String)
                  : DateTime.now(),
              readAt: isRead ? DateTime.now() : null,
              plantId: alert['plantId'] as String?,
              metadata: alert['metadata'] as Map<String, dynamic>? ?? {},
            );
          } catch (e) {
            developer.log(
              'Erreur conversion alerte: $e',
              name: 'PlantIntelligenceOrchestrator',
              level: 900,
            );
            return null;
          }
        })
        .whereType<NotificationAlert>()
        .toList();
  }

  /// Mappe la priorité depuis une chaîne de caractères
  NotificationPriority _mapPriorityFromString(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'critical':
        return NotificationPriority.critical;
      case 'high':
        return NotificationPriority.high;
      case 'medium':
        return NotificationPriority.medium;
      case 'low':
        return NotificationPriority.low;
      default:
        return NotificationPriority.medium;
    }
  }

  // ==================== MAINTENANCE AND CLEANUP METHODS ====================

  /// Nettoie les conditions orphelines dans Hive
  ///
  /// Supprime toutes les conditions dont le plantId ne correspond pas à une plante active.
  /// Cette méthode est idempotente et peut être appelée plusieurs fois sans effet secondaire.
  ///
  /// **Responsabilités :**
  /// - Lire toutes les conditions depuis le box Hive des conditions
  /// - Lire tous les IDs de plantes actives dans Hive (filtrées par isActive == true)
  /// - Supprimer toutes les conditions dont le plantId ne fait pas partie des IDs actifs
  /// - Logger les actions réalisées pour la traçabilité
  ///
  /// **Retourne :** Le nombre de conditions supprimées
  ///
  /// **Utilisation :**
  /// ```dart
  /// final deletedCount = await orchestrator._cleanOrphanedConditionsInHive();
  /// print('$deletedCount condition(s) orpheline(s) supprimée(s)');
  /// ```
  Future<int> _cleanOrphanedConditionsInHive() async {
    developer.log(
      '🧹 Début du nettoyage des conditions orphelines',
      name: 'PlantIntelligenceOrchestrator',
    );

    try {
      // 1. Récupérer toutes les plantes actives du catalogue
      developer.log(
        '📚 Récupération des plantes actives du catalogue...',
        name: 'PlantIntelligenceOrchestrator',
      );

      final allPlants = await _plantCatalogRepository.getAllPlants();
      final activePlantIds = allPlants
          .where((plant) => plant.isActive)
          .map((plant) => plant.id)
          .toSet(); // Utiliser un Set pour une recherche O(1)

      developer.log(
        '✅ ${activePlantIds.length} plante(s) active(s) trouvée(s)',
        name: 'PlantIntelligenceOrchestrator',
      );

      // 2. Récupérer toutes les conditions existantes via le repository
      // Note: Nous devons accéder directement au datasource pour obtenir TOUTES les conditions
      // car IPlantConditionRepository n'a pas de méthode pour récupérer toutes les conditions
      developer.log(
        '🔍 Analyse des conditions stockées...',
        name: 'PlantIntelligenceOrchestrator',
      );

      // Stratégie : On récupère les conditions pour chaque plante du catalogue
      // puis on vérifie lesquelles sont orphelines
      final allConditionIds = <String>[];
      final orphanedConditionIds = <String>[];

      // Pour chaque plante (active ou non), récupérer son historique de conditions
      for (final plant in allPlants) {
        try {
          final conditions =
              await _conditionRepository.getPlantConditionHistory(
            plantId: plant.id,
            limit: 10000, // Récupérer toutes les conditions
          );

          for (final condition in conditions) {
            allConditionIds.add(condition.id);

            // Si la plante n'est plus active, cette condition est orpheline
            if (!activePlantIds.contains(plant.id)) {
              orphanedConditionIds.add(condition.id);
            }
          }
        } catch (e) {
          developer.log(
            '⚠️ Erreur lors de la récupération des conditions pour ${plant.id}: $e',
            name: 'PlantIntelligenceOrchestrator',
            level: 900,
          );
          // Continuer avec les autres plantes
        }
      }

      developer.log(
        '📊 Total conditions analysées: ${allConditionIds.length}',
        name: 'PlantIntelligenceOrchestrator',
      );

      developer.log(
        '🗑️ Conditions orphelines détectées: ${orphanedConditionIds.length}',
        name: 'PlantIntelligenceOrchestrator',
      );

      // 3. Supprimer les conditions orphelines
      int deletedCount = 0;

      if (orphanedConditionIds.isNotEmpty) {
        developer.log(
          '🧹 Suppression des conditions orphelines...',
          name: 'PlantIntelligenceOrchestrator',
        );

        for (final conditionId in orphanedConditionIds) {
          try {
            final success =
                await _conditionRepository.deletePlantCondition(conditionId);
            if (success) {
              deletedCount++;
            }
          } catch (e) {
            developer.log(
              '⚠️ Erreur lors de la suppression de la condition $conditionId: $e',
              name: 'PlantIntelligenceOrchestrator',
              level: 900,
            );
            // Continuer avec les autres conditions
          }
        }

        developer.log(
          '✅ $deletedCount condition(s) orpheline(s) supprimée(s) avec succès',
          name: 'PlantIntelligenceOrchestrator',
        );
      } else {
        developer.log(
          '✅ Aucune condition orpheline détectée',
          name: 'PlantIntelligenceOrchestrator',
        );
      }

      // 4. Résumé final
      developer.log(
        '🎯 Nettoyage terminé : $deletedCount/${orphanedConditionIds.length} condition(s) supprimée(s)',
        name: 'PlantIntelligenceOrchestrator',
      );

      return deletedCount;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Erreur critique lors du nettoyage des conditions orphelines',
        name: 'PlantIntelligenceOrchestrator',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );

      // Ne pas remonter l'erreur, retourner 0 pour indiquer qu'aucun nettoyage n'a été fait
      return 0;
    }
  }

  // ==================== BIOLOGICAL CONTROL PRIVATE METHODS ====================

  /// Calcule le score de santé global du jardin (0-100)
  ///
  /// Prend en compte :
  /// - 70% : Score moyen de santé des plantes
  /// - 30% : Impact des menaces ravageurs
  double _calculateOverallGardenHealth({
    required List<PlantIntelligenceReport> plantReports,
    PestThreatAnalysis? pestThreats,
  }) {
    if (plantReports.isEmpty) return 0.0;

    // Calculer le score moyen des plantes
    final avgPlantHealth = plantReports.fold<double>(
          0.0,
          (sum, report) => sum + report.intelligenceScore,
        ) /
        plantReports.length;

    // Pénalité liée aux menaces ravageurs
    double threatPenalty = 0.0;
    if (pestThreats != null && pestThreats.totalThreats > 0) {
      // Pénalité progressive basée sur la sévérité des menaces
      threatPenalty = (pestThreats.criticalThreats * 10.0) +
          (pestThreats.highThreats * 5.0) +
          (pestThreats.moderateThreats * 2.0) +
          (pestThreats.lowThreats * 0.5);

      // Limiter la pénalité à 30% maximum
      threatPenalty = threatPenalty.clamp(0.0, 30.0);
    }

    // Score final = 70% plantes + 30% menaces
    final healthScore = (avgPlantHealth * 0.7) + ((100 - threatPenalty) * 0.3);

    return healthScore.clamp(0.0, 100.0);
  }

  /// Génère un résumé textuel de l'analyse du jardin
  String _generateGardenSummary({
    required List<PlantIntelligenceReport> plantReports,
    PestThreatAnalysis? pestThreats,
    required List<BioControlRecommendation> bioControlRecommendations,
  }) {
    final buffer = StringBuffer();

    // Partie 1 : Plantes
    if (plantReports.isNotEmpty) {
      buffer.write('${plantReports.length} plante(s) analysée(s). ');

      final avgHealth = plantReports.fold<double>(
            0.0,
            (sum, r) => sum + r.intelligenceScore,
          ) /
          plantReports.length;

      if (avgHealth >= 80) {
        buffer.write('Excellent état de santé général ! 🌟 ');
      } else if (avgHealth >= 60) {
        buffer.write('État de santé satisfaisant. 🌱 ');
      } else {
        buffer.write('Certaines plantes nécessitent attention. ⚠️ ');
      }
    }

    // Partie 2 : Menaces ravageurs
    if (pestThreats != null && pestThreats.totalThreats > 0) {
      buffer.write('\n\n🐛 Menaces détectées : ');

      if (pestThreats.criticalThreats > 0) {
        buffer.write('${pestThreats.criticalThreats} critique(s) 🚨 ');
      }
      if (pestThreats.highThreats > 0) {
        buffer.write('${pestThreats.highThreats} élevée(s) ⚠️ ');
      }
      if (pestThreats.moderateThreats > 0) {
        buffer.write('${pestThreats.moderateThreats} modérée(s) 👀 ');
      }
      if (pestThreats.lowThreats > 0) {
        buffer.write('${pestThreats.lowThreats} faible(s) ℹ️ ');
      }
    } else {
      buffer.write('\n\n✅ Aucune menace ravageur détectée.');
    }

    // Partie 3 : Recommandations
    if (bioControlRecommendations.isNotEmpty) {
      buffer.write(
          '\n\n🌿 ${bioControlRecommendations.length} recommandation(s) de lutte biologique disponible(s).');

      final urgentRecs =
          bioControlRecommendations.where((r) => r.priority <= 2).length;
      if (urgentRecs > 0) {
        buffer.write(' $urgentRecs action(s) urgente(s) recommandée(s).');
      }
    }

    return buffer.toString();
  }

  // ==================== CURSOR PROMPT A7 - EVOLUTION CONDITION EXTRACTION ====================

  /// Extrait les noms des conditions qui se sont améliorées
  ///
  /// Compare les états des conditions entre l'ancien et le nouveau rapport
  /// pour identifier les améliorations.
  List<String> _extractImprovedConditions(
      IntelligenceEvolutionSummary evolution) {
    final improved = <String>[];

    try {
      final oldAnalysis = evolution.oldReport.analysis;
      final newAnalysis = evolution.newReport.analysis;

      // Comparer température
      if (_isConditionImproved(
          oldAnalysis.temperature.status, newAnalysis.temperature.status)) {
        improved.add('temperature');
      }

      // Comparer humidité
      if (_isConditionImproved(
          oldAnalysis.humidity.status, newAnalysis.humidity.status)) {
        improved.add('humidity');
      }

      // Comparer luminosité
      if (_isConditionImproved(
          oldAnalysis.light.status, newAnalysis.light.status)) {
        improved.add('light');
      }

      // Comparer sol
      if (_isConditionImproved(
          oldAnalysis.soil.status, newAnalysis.soil.status)) {
        improved.add('soil');
      }
    } catch (e) {
      developer.log(
        '⚠️ Erreur extraction conditions améliorées: $e',
        name: 'PlantIntelligenceOrchestrator',
        level: 900,
      );
    }

    return improved;
  }

  /// Extrait les noms des conditions qui se sont dégradées
  List<String> _extractDegradedConditions(
      IntelligenceEvolutionSummary evolution) {
    final degraded = <String>[];

    try {
      final oldAnalysis = evolution.oldReport.analysis;
      final newAnalysis = evolution.newReport.analysis;

      // Comparer température
      if (_isConditionDegraded(
          oldAnalysis.temperature.status, newAnalysis.temperature.status)) {
        degraded.add('temperature');
      }

      // Comparer humidité
      if (_isConditionDegraded(
          oldAnalysis.humidity.status, newAnalysis.humidity.status)) {
        degraded.add('humidity');
      }

      // Comparer luminosité
      if (_isConditionDegraded(
          oldAnalysis.light.status, newAnalysis.light.status)) {
        degraded.add('light');
      }

      // Comparer sol
      if (_isConditionDegraded(
          oldAnalysis.soil.status, newAnalysis.soil.status)) {
        degraded.add('soil');
      }
    } catch (e) {
      developer.log(
        '⚠️ Erreur extraction conditions dégradées: $e',
        name: 'PlantIntelligenceOrchestrator',
        level: 900,
      );
    }

    return degraded;
  }

  /// Extrait les noms des conditions qui n'ont pas changé
  List<String> _extractUnchangedConditions(
      IntelligenceEvolutionSummary evolution) {
    final unchanged = <String>[];

    try {
      final oldAnalysis = evolution.oldReport.analysis;
      final newAnalysis = evolution.newReport.analysis;

      // Comparer température
      if (!_isConditionImproved(
              oldAnalysis.temperature.status, newAnalysis.temperature.status) &&
          !_isConditionDegraded(
              oldAnalysis.temperature.status, newAnalysis.temperature.status)) {
        unchanged.add('temperature');
      }

      // Comparer humidité
      if (!_isConditionImproved(
              oldAnalysis.humidity.status, newAnalysis.humidity.status) &&
          !_isConditionDegraded(
              oldAnalysis.humidity.status, newAnalysis.humidity.status)) {
        unchanged.add('humidity');
      }

      // Comparer luminosité
      if (!_isConditionImproved(
              oldAnalysis.light.status, newAnalysis.light.status) &&
          !_isConditionDegraded(
              oldAnalysis.light.status, newAnalysis.light.status)) {
        unchanged.add('light');
      }

      // Comparer sol
      if (!_isConditionImproved(
              oldAnalysis.soil.status, newAnalysis.soil.status) &&
          !_isConditionDegraded(
              oldAnalysis.soil.status, newAnalysis.soil.status)) {
        unchanged.add('soil');
      }
    } catch (e) {
      developer.log(
        '⚠️ Erreur extraction conditions inchangées: $e',
        name: 'PlantIntelligenceOrchestrator',
        level: 900,
      );
    }

    return unchanged;
  }

  /// Vérifie si une condition s'est améliorée
  ///
  /// Une condition est considérée comme améliorée si elle passe à un état "meilleur"
  /// dans l'échelle: critical < poor < suboptimal < good < optimal
  bool _isConditionImproved(
      ConditionStatus oldStatus, ConditionStatus newStatus) {
    final statusOrder = {
      ConditionStatus.critical: 0,
      ConditionStatus.poor: 1,
      ConditionStatus.suboptimal: 2,
      ConditionStatus.good: 3,
      ConditionStatus.optimal: 4,
    };

    final oldScore = statusOrder[oldStatus] ?? 0;
    final newScore = statusOrder[newStatus] ?? 0;

    return newScore > oldScore;
  }

  /// Vérifie si une condition s'est dégradée
  bool _isConditionDegraded(
      ConditionStatus oldStatus, ConditionStatus newStatus) {
    final statusOrder = {
      ConditionStatus.critical: 0,
      ConditionStatus.poor: 1,
      ConditionStatus.suboptimal: 2,
      ConditionStatus.good: 3,
      ConditionStatus.optimal: 4,
    };

    final oldScore = statusOrder[oldStatus] ?? 0;
    final newScore = statusOrder[newStatus] ?? 0;

    return newScore < oldScore;
  }
}

/// Exception personnalisée pour l'orchestrateur
class PlantIntelligenceOrchestratorException implements Exception {
  final String message;
  const PlantIntelligenceOrchestratorException(this.message);

  @override
  String toString() => 'PlantIntelligenceOrchestratorException: $message';
}
