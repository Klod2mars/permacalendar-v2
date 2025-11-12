import 'dart:developer' as developer;
import '../../domain/repositories/plant_intelligence_repository.dart';
import '../../domain/repositories/i_plant_condition_repository.dart';
import '../../domain/repositories/i_weather_repository.dart';
import '../../domain/repositories/i_garden_context_repository.dart';
import '../../domain/repositories/i_recommendation_repository.dart';
import '../../domain/repositories/i_analytics_repository.dart';
import '../../domain/entities/plant_condition.dart';
import '../../domain/entities/weather_condition.dart';
import '../../domain/entities/garden_context.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/intelligence_report.dart';
import '../../domain/entities/plant_evolution_report.dart';
import '../../domain/models/plant_freezed.dart';
import '../datasources/plant_intelligence_local_datasource.dart';
import '../datasources/weather_datasource.dart';
import '../../../../core/services/open_meteo_service.dart';
import '../../../../core/services/aggregation/garden_aggregation_hub.dart';
import '../../../../core/models/unified_garden_context.dart';
import '../../../../core/data/hive/garden_boxes.dart';

/// Implémentation concrète du repository d'intelligence des plantes
///
/// **REFACTORÉ - Prompt 4 : ISP (Interface Segregation Principle)**
///
/// Implémente désormais 5 interfaces spécialisées au lieu d'une seule monolithique :
/// - ✅ IPlantConditionRepository : Gestion des conditions de plantes
/// - ✅ IWeatherRepository : Gestion de la météo
/// - ✅ IGardenContextRepository : Gestion du contexte jardin
/// - ✅ IRecommendationRepository : Gestion des recommandations
/// - ✅ IAnalyticsRepository : Analytics et statistiques
///
/// **Architecture précédente (Prompt 2) :**
/// Ce repository ne dépend PLUS de :
/// - ❌ GardenHiveRepository (accès direct supprimé)
/// - ❌ PlantHiveRepository (accès direct supprimé)
/// - ❌ GardenDataAggregationService (remplacé par le hub)
///
/// Il consomme maintenant via :
/// - ✅ GardenAggregationHub : Hub central unifié (Legacy + Modern)
/// - ✅ PlantIntelligenceLocalDataSource : Persistance Intelligence (conditions, recommandations)
/// - ✅ WeatherDataSource : Données météorologiques
///
/// **Bénéfices :**
/// - Respect du principe ISP (clients ne dépendent que de ce dont ils ont besoin)
/// - Plus de conflits d'initialisation Hive
/// - Accès unifié et cohérent aux données
/// - Découplage de l'IA des détails d'implémentation
/// - Architecture évolutive et maintenable
class PlantIntelligenceRepositoryImpl
    implements
        PlantIntelligenceRepository,
        IPlantConditionRepository,
        IWeatherRepository,
        IGardenContextRepository,
        IRecommendationRepository,
        IAnalyticsRepository {
  final PlantIntelligenceLocalDataSource _localDataSource;
  final WeatherDataSource _weatherDataSource;
  final GardenAggregationHub _aggregationHub;

  // Cache pour optimiser les performances
  final Map<String, dynamic> _cache = {};
  final Duration _cacheValidityDuration = const Duration(minutes: 30);

  PlantIntelligenceRepositoryImpl({
    required PlantIntelligenceLocalDataSource localDataSource,
    required GardenAggregationHub aggregationHub,
    WeatherDataSource? weatherDataSource,
  })  : _localDataSource = localDataSource,
        _aggregationHub = aggregationHub,
        _weatherDataSource = weatherDataSource ??
            WeatherDataSourceImpl(OpenMeteoService.instance);

  // ==================== GESTION DES CONDITIONS ====================

  @override
  Future<String> savePlantCondition({
    required String plantId,
    required PlantCondition condition,
  }) async {
    try {
      await _localDataSource.savePlantCondition(condition);
      _invalidateCache('plant_conditions_$plantId');
      return condition.id;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to save plant condition: $e',
        code: 'SAVE_CONDITION_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<PlantCondition?> getCurrentPlantCondition(String plantId) async {
    developer.log(
        '🔍 DIAGNOSTIC - Début getCurrentPlantCondition: plantId=$plantId',
        name: 'PlantIntelligenceRepositoryImpl');

    try {
      final cacheKey = 'current_condition_$plantId';
      developer.log('🔍 DIAGNOSTIC - Vérification cache: $cacheKey',
          name: 'PlantIntelligenceRepositoryImpl');

      if (_isCacheValid(cacheKey)) {
        developer.log('🔍 DIAGNOSTIC - Cache valide trouvé',
            name: 'PlantIntelligenceRepositoryImpl');
        return _cache[cacheKey];
      }

      developer.log(
          '🔍 DIAGNOSTIC - Cache invalide, récupération depuis datasource...',
          name: 'PlantIntelligenceRepositoryImpl');
      final condition =
          await _localDataSource.getCurrentPlantCondition(plantId);
      developer.log(
          '🔍 DIAGNOSTIC - Condition récupérée: ${condition != null ? "OUI" : "NON"}',
          name: 'PlantIntelligenceRepositoryImpl');

      _cache[cacheKey] = condition;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return condition;
    } catch (e, stackTrace) {
      developer.log('❌ DIAGNOSTIC - Erreur getCurrentPlantCondition: $e',
          name: 'PlantIntelligenceRepositoryImpl');
      developer.log('❌ DIAGNOSTIC - StackTrace: $stackTrace',
          name: 'PlantIntelligenceRepositoryImpl');

      throw PlantIntelligenceRepositoryException(
        'Failed to get current plant condition: $e',
        code: 'GET_CONDITION_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<PlantCondition>> getPlantConditionHistory({
    required String plantId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) async {
    try {
      final cacheKey =
          'condition_history_${plantId}_${startDate?.millisecondsSinceEpoch}_${endDate?.millisecondsSinceEpoch}_$limit';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final history = await _localDataSource.getPlantConditionHistory(
        plantId: plantId,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );

      _cache[cacheKey] = history;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return history;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get plant condition history: $e',
        code: 'GET_HISTORY_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> updatePlantCondition({
    required String conditionId,
    required PlantCondition condition,
  }) async {
    try {
      final success =
          await _localDataSource.updatePlantCondition(conditionId, condition);
      if (success) {
        _invalidateCache('plant_conditions_${condition.plantId}');
      }
      return success;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to update plant condition: $e',
        code: 'UPDATE_CONDITION_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> deletePlantCondition(String conditionId) async {
    try {
      final success = await _localDataSource.deletePlantCondition(conditionId);
      if (success) {
        _invalidateCacheByPattern('plant_conditions_*');
      }
      return success;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to delete plant condition: $e',
        code: 'DELETE_CONDITION_ERROR',
        originalError: e,
      );
    }
  }

  // ==================== GESTION DES CONDITIONS MÉTÉOROLOGIQUES ====================

  @override
  Future<String> saveWeatherCondition({
    required String gardenId,
    required WeatherCondition weather,
  }) async {
    try {
      await _localDataSource.saveWeatherCondition(gardenId, weather);
      _invalidateCache('weather_$gardenId');
      return weather.id;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to save weather condition: $e',
        code: 'SAVE_WEATHER_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<WeatherCondition?> getCurrentWeatherCondition(String gardenId) async {
    try {
      final cacheKey = 'current_weather_$gardenId';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      // Essayer d'abord le cache local
      var weather = await _localDataSource.getCurrentWeatherCondition(gardenId);

      // Si pas de données récentes, récupérer depuis l'API météo
      if (weather == null || _isWeatherDataStale(weather)) {
        // **REFACTORÉ - Prompt 2 :** Utilisation du hub au lieu de _gardenRepository
        final unifiedContext =
            await _aggregationHub.getUnifiedContext(gardenId);
        if (unifiedContext.location != null) {
          // Extraire les coordonnées depuis le contexte unifié
          final latitude =
              _extractLatitudeFromLocation(unifiedContext.location!) ?? 48.8566;
          final longitude =
              _extractLongitudeFromLocation(unifiedContext.location!) ?? 2.3522;

          weather = await _weatherDataSource.getCurrentWeather(
            gardenId: gardenId,
            latitude: latitude,
            longitude: longitude,
          );

          // Sauvegarder les nouvelles données
          if (weather != null) {
            await _localDataSource.saveWeatherCondition(gardenId, weather);
          }
        }
      }

      _cache[cacheKey] = weather;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return weather;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get current weather condition: $e',
        code: 'GET_WEATHER_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<WeatherCondition>> getWeatherHistory({
    required String gardenId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) async {
    try {
      final cacheKey =
          'weather_history_${gardenId}_${startDate?.millisecondsSinceEpoch}_${endDate?.millisecondsSinceEpoch}_$limit';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      var history = await _localDataSource.getWeatherHistory(
        gardenId: gardenId,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );

      // Si pas assez de données, récupérer depuis l'API
      if (history.length < limit) {
        // **REFACTORÉ - Prompt 2 :** Utilisation du hub au lieu de _gardenRepository
        final unifiedContext =
            await _aggregationHub.getUnifiedContext(gardenId);
        if (unifiedContext.location != null) {
          final latitude =
              _extractLatitudeFromLocation(unifiedContext.location!) ?? 48.8566;
          final longitude =
              _extractLongitudeFromLocation(unifiedContext.location!) ?? 2.3522;

          final apiHistory = await _weatherDataSource.getWeatherHistory(
            gardenId: gardenId,
            latitude: latitude,
            longitude: longitude,
            pastDays: startDate != null
                ? DateTime.now().difference(startDate).inDays
                : 14,
          );

          // Merger et sauvegarder
          for (final weather in apiHistory) {
            await _localDataSource.saveWeatherCondition(gardenId, weather);
          }

          history = await _localDataSource.getWeatherHistory(
            gardenId: gardenId,
            startDate: startDate,
            endDate: endDate,
            limit: limit,
          );
        }
      }

      _cache[cacheKey] = history;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return history;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get weather history: $e',
        code: 'GET_WEATHER_HISTORY_ERROR',
        originalError: e,
      );
    }
  }

  /// ✅ NOUVEAU - Synchronise le GardenContext avec les plantations actuelles
  Future<GardenContext?> _syncGardenContextWithPlantings(
      String gardenId) async {
    try {
      developer.log('🔄 SYNC - Synchronisation GardenContext pour: $gardenId',
          name: 'PlantIntelligenceRepository');

      // Récupérer le contexte existant
      var context = await _localDataSource.getGardenContext(gardenId);

      // Récupérer le contexte unifié depuis le hub
      final unifiedContext = await _aggregationHub.getUnifiedContext(gardenId);

      // Récupérer les plantations actives pour ce jardin
      final activePlantIds = await _getActivePlantIdsFromPlantings(gardenId);
      developer.log(
          '🔄 SYNC - Plantes actives trouvées: ${activePlantIds.length} - $activePlantIds',
          name: 'PlantIntelligenceRepository');

      // Créer ou mettre à jour le contexte avec les plantations synchronisées
      context = context?.copyWith(
            name: unifiedContext.name,
            description: unifiedContext.description,
            location: _createGardenLocationFromString(unifiedContext.location),
            activePlantIds: activePlantIds,
            stats: GardenStats(
              totalPlants: activePlantIds.length,
              activePlants: activePlantIds.length,
              totalArea: unifiedContext.totalArea ?? 0.0,
              activeArea: unifiedContext.totalArea ?? 0.0,
              totalYield: 0.0,
              currentYearYield: 0.0,
              harvestsThisYear: 0,
              plantingsThisYear: activePlantIds.length,
              successRate: 100.0,
              totalInputCosts: 0.0,
              totalHarvestValue: 0.0,
            ),
            updatedAt: DateTime.now(),
          ) ??
          GardenContext(
            gardenId: gardenId,
            name: unifiedContext.name,
            description: unifiedContext.description,
            location: _createGardenLocationFromString(unifiedContext.location),
            climate: _createDefaultClimateConditions(),
            soil: _createDefaultSoilInfo(),
            activePlantIds: activePlantIds,
            historicalPlantIds: context?.historicalPlantIds ?? [],
            stats: GardenStats(
              totalPlants: activePlantIds.length,
              activePlants: activePlantIds.length,
              totalArea: unifiedContext.totalArea ?? 0.0,
              activeArea: unifiedContext.totalArea ?? 0.0,
              totalYield: 0.0,
              currentYearYield: 0.0,
              harvestsThisYear: 0,
              plantingsThisYear: activePlantIds.length,
              successRate: 100.0,
              totalInputCosts: 0.0,
              totalHarvestValue: 0.0,
            ),
            preferences: context?.preferences ??
                const CultivationPreferences(
                  method: CultivationMethod.organic,
                  usePesticides: false,
                  useChemicalFertilizers: false,
                  useOrganicFertilizers: true,
                  companionPlanting: true,
                  cropRotation: true,
                  mulching: true,
                  automaticIrrigation: false,
                  regularMonitoring: true,
                  objectives: ['Sustainable', 'Healthy'],
                ),
            createdAt: context?.createdAt ?? DateTime.now(),
            updatedAt: DateTime.now(),
          );

      // Sauvegarder le contexte synchronisé
      await _localDataSource.saveGardenContext(context);

      developer.log(
          '✅ SYNC - GardenContext synchronisé avec ${activePlantIds.length} plantes actives',
          name: 'PlantIntelligenceRepository');

      return context;
    } catch (e, stackTrace) {
      developer.log('❌ SYNC - Erreur synchronisation: $e',
          name: 'PlantIntelligenceRepository');
      developer.log('❌ SYNC - StackTrace: $stackTrace',
          name: 'PlantIntelligenceRepository');
      // En cas d'erreur, retourner le contexte existant
      return await _localDataSource.getGardenContext(gardenId);
    }
  }

  /// Récupère les IDs des plantes actives depuis les plantations
  Future<List<String>> _getActivePlantIdsFromPlantings(String gardenId) async {
    try {
      // Récupérer toutes les plantations actives pour ce jardin
      final plantings = GardenBoxes.getActivePlantingsForGarden(gardenId);

      // Extraire les IDs des plantes uniques
      final plantIds = plantings
          .map((planting) => planting.plantId)
          .toSet() // Éliminer les doublons
          .toList();

      developer.log(
          '🔄 SYNC - Plantations trouvées: ${plantings.length}, Plantes uniques: ${plantIds.length}',
          name: 'PlantIntelligenceRepository');

      return plantIds;
    } catch (e) {
      developer.log('❌ SYNC - Erreur récupération plantations: $e',
          name: 'PlantIntelligenceRepository');
      return [];
    }
  }

  // ==================== GESTION DU CONTEXTE JARDIN ====================

  @override
  Future<String> saveGardenContext(GardenContext garden) async {
    try {
      developer.log(
        '🔍 DIAGNOSTIC: Repository - Début sauvegarde GardenContext ${garden.gardenId}',
        name: 'PlantIntelligenceRepository',
        level: 500,
      );

      await _localDataSource.saveGardenContext(garden);

      developer.log(
        '🔍 DIAGNOSTIC: Repository - GardenContext sauvegardé avec succès',
        name: 'PlantIntelligenceRepository',
        level: 500,
      );

      _invalidateCache('garden_context_${garden.gardenId}');
      return garden.gardenId;
    } catch (e) {
      developer.log(
        '❌ ERREUR CRITIQUE Repository - Échec sauvegarde GardenContext',
        name: 'PlantIntelligenceRepository',
        level: 1000,
        error: e,
      );

      throw PlantIntelligenceRepositoryException(
        'Failed to save garden context: $e',
        code: 'SAVE_GARDEN_CONTEXT_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<GardenContext?> getGardenContext(String gardenId) async {
    try {
      developer.log('🔍 SYNC - Récupération GardenContext pour $gardenId',
          name: 'PlantIntelligenceRepository');

      // 🔥 CORRECTION CRITIQUE : TOUJOURS synchroniser avec la source de vérité
      // Ne pas utiliser le cache pour éviter les désynchronisations
      // Le cache sera mis à jour après la synchronisation
      developer.log(
          '🔄 SYNC - Synchronisation forcée depuis la source de vérité (Hive Plantings)',
          name: 'PlantIntelligenceRepository');

      // ✅ Synchroniser automatiquement avec les plantations actuelles
      var context = await _syncGardenContextWithPlantings(gardenId);

      // Mettre à jour le cache APRÈS la synchronisation
      final cacheKey = 'garden_context_$gardenId';
      _cache[cacheKey] = context;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      developer.log('✅ SYNC - GardenContext récupéré et cache mis à jour',
          name: 'PlantIntelligenceRepository');

      return context;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get garden context: $e',
        code: 'GET_GARDEN_CONTEXT_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> updateGardenContext(GardenContext garden) async {
    try {
      final success = await _localDataSource.updateGardenContext(garden);
      if (success) {
        _invalidateCache('garden_context_${garden.gardenId}');
      }
      return success;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to update garden context: $e',
        code: 'UPDATE_GARDEN_CONTEXT_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<GardenContext>> getUserGardens(String userId) async {
    try {
      final cacheKey = 'user_gardens_$userId';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final gardens = await _localDataSource.getUserGardens(userId);

      _cache[cacheKey] = gardens;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return gardens;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get user gardens: $e',
        code: 'GET_USER_GARDENS_ERROR',
        originalError: e,
      );
    }
  }

  // ==================== GESTION DES RECOMMANDATIONS ====================

  @override
  Future<String> saveRecommendation({
    required String plantId,
    required Recommendation recommendation,
  }) async {
    try {
      await _localDataSource.saveRecommendation(plantId, recommendation);
      _invalidateCache('recommendations_$plantId');
      return recommendation.id;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to save recommendation: $e',
        code: 'SAVE_RECOMMENDATION_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Recommendation>> getActiveRecommendations({
    required String plantId,
    int limit = 10,
  }) async {
    try {
      final cacheKey = 'active_recommendations_${plantId}_$limit';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final recommendations = await _localDataSource.getActiveRecommendations(
        plantId: plantId,
        limit: limit,
      );

      _cache[cacheKey] = recommendations;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return recommendations;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get active recommendations: $e',
        code: 'GET_RECOMMENDATIONS_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Recommendation>> getRecommendationsByPriority({
    required String plantId,
    required String priority,
  }) async {
    try {
      final cacheKey = 'recommendations_priority_${plantId}_$priority';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final recommendations =
          await _localDataSource.getRecommendationsByPriority(
        plantId: plantId,
        priority: priority,
      );

      _cache[cacheKey] = recommendations;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return recommendations;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get recommendations by priority: $e',
        code: 'GET_RECOMMENDATIONS_BY_PRIORITY_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> markRecommendationAsApplied({
    required String recommendationId,
    DateTime? appliedAt,
    String? notes,
  }) async {
    try {
      final success = await _localDataSource.markRecommendationAsApplied(
        recommendationId: recommendationId,
        appliedAt: appliedAt,
        notes: notes,
      );
      if (success) {
        _invalidateCacheByPattern('recommendations_*');
      }
      return success;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to mark recommendation as applied: $e',
        code: 'MARK_RECOMMENDATION_APPLIED_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> markRecommendationAsIgnored({
    required String recommendationId,
    String? reason,
  }) async {
    try {
      final success = await _localDataSource.markRecommendationAsIgnored(
        recommendationId: recommendationId,
        reason: reason,
      );
      if (success) {
        _invalidateCacheByPattern('recommendations_*');
      }
      return success;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to mark recommendation as ignored: $e',
        code: 'MARK_RECOMMENDATION_IGNORED_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> deleteRecommendation(String recommendationId) async {
    try {
      final success =
          await _localDataSource.deleteRecommendation(recommendationId);
      if (success) {
        _invalidateCacheByPattern('recommendations_*');
      }
      return success;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to delete recommendation: $e',
        code: 'DELETE_RECOMMENDATION_ERROR',
        originalError: e,
      );
    }
  }

  // ==================== GESTION DES ANALYSES ====================

  @override
  Future<String> saveAnalysisResult({
    required String plantId,
    required String analysisType,
    required Map<String, dynamic> result,
    required double confidence,
  }) async {
    try {
      await _localDataSource.saveAnalysisResult(
        plantId: plantId,
        analysisType: analysisType,
        result: result,
        confidence: confidence,
      );
      _invalidateCache('analyses_$plantId');
      return '${plantId}_${analysisType}_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to save analysis result: $e',
        code: 'SAVE_ANALYSIS_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getLatestAnalysis({
    required String plantId,
    required String analysisType,
  }) async {
    try {
      final cacheKey = 'latest_analysis_${plantId}_$analysisType';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final analysis = await _localDataSource.getLatestAnalysis(
        plantId: plantId,
        analysisType: analysisType,
      );

      _cache[cacheKey] = analysis;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return analysis;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get latest analysis: $e',
        code: 'GET_ANALYSIS_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAnalysisHistory({
    required String plantId,
    String? analysisType,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  }) async {
    try {
      final cacheKey =
          'analysis_history_${plantId}_${analysisType ?? 'all'}_${startDate?.millisecondsSinceEpoch}_${endDate?.millisecondsSinceEpoch}_$limit';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final history = await _localDataSource.getAnalysisHistory(
        plantId: plantId,
        analysisType: analysisType,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );

      _cache[cacheKey] = history;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return history;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get analysis history: $e',
        code: 'GET_ANALYSIS_HISTORY_ERROR',
        originalError: e,
      );
    }
  }

  // ==================== GESTION DES ALERTES ====================

  @override
  Future<String> saveAlert({
    required String plantId,
    required String alertType,
    required String severity,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _localDataSource.saveAlert(
        plantId: plantId,
        alertType: alertType,
        severity: severity,
        message: message,
        data: data,
      );
      _invalidateCache('alerts_$plantId');
      return '${plantId}_${alertType}_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to save alert: $e',
        code: 'SAVE_ALERT_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getActiveAlerts({
    String? plantId,
    String? gardenId,
    String? severity,
  }) async {
    try {
      final cacheKey =
          'active_alerts_${plantId ?? 'all'}_${gardenId ?? 'all'}_${severity ?? 'all'}';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final alerts = await _localDataSource.getActiveAlerts(
        plantId: plantId,
        gardenId: gardenId,
        severity: severity,
      );

      _cache[cacheKey] = alerts;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return alerts;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get active alerts: $e',
        code: 'GET_ALERTS_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> resolveAlert({
    required String alertId,
    DateTime? resolvedAt,
    String? resolution,
  }) async {
    try {
      final success = await _localDataSource.resolveAlert(
        alertId: alertId,
        resolvedAt: resolvedAt,
        resolution: resolution,
      );
      if (success) {
        _invalidateCacheByPattern('alerts_*');
      }
      return success;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to resolve alert: $e',
        code: 'RESOLVE_ALERT_ERROR',
        originalError: e,
      );
    }
  }

  // ==================== GESTION DES PRÉFÉRENCES UTILISATEUR ====================

  @override
  Future<bool> saveUserPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      final success = await _localDataSource.saveUserPreferences(
        userId: userId,
        preferences: preferences,
      );
      if (success) {
        _invalidateCache('user_preferences_$userId');
      }
      return success;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to save user preferences: $e',
        code: 'SAVE_PREFERENCES_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserPreferences(String userId) async {
    try {
      final cacheKey = 'user_preferences_$userId';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final preferences = await _localDataSource.getUserPreferences(userId);

      _cache[cacheKey] = preferences;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return preferences;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get user preferences: $e',
        code: 'GET_PREFERENCES_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> updateUserPreference({
    required String userId,
    required String key,
    required dynamic value,
  }) async {
    try {
      final success = await _localDataSource.updateUserPreference(
        userId: userId,
        key: key,
        value: value,
      );
      if (success) {
        _invalidateCache('user_preferences_$userId');
      }
      return success;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to update user preference: $e',
        code: 'UPDATE_PREFERENCE_ERROR',
        originalError: e,
      );
    }
  }

  // ==================== STATISTIQUES ET MÉTRIQUES ====================

  @override
  Future<Map<String, dynamic>> getPlantHealthStats({
    required String plantId,
    int period = 30,
  }) async {
    try {
      final cacheKey = 'plant_health_stats_${plantId}_$period';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final stats = await _localDataSource.getPlantHealthStats(
        plantId: plantId,
        period: period,
      );

      _cache[cacheKey] = stats;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return stats;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get plant health stats: $e',
        code: 'GET_HEALTH_STATS_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getGardenPerformanceMetrics({
    required String gardenId,
    int period = 30,
  }) async {
    try {
      final cacheKey = 'garden_performance_${gardenId}_$period';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final metrics = await _localDataSource.getGardenPerformanceMetrics(
        gardenId: gardenId,
        period: period,
      );

      _cache[cacheKey] = metrics;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return metrics;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get garden performance metrics: $e',
        code: 'GET_PERFORMANCE_METRICS_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTrendData({
    required String plantId,
    required String metric,
    int period = 90,
  }) async {
    try {
      final cacheKey = 'trend_data_${plantId}_${metric}_$period';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      final trendData = await _localDataSource.getTrendData(
        plantId: plantId,
        metric: metric,
        period: period,
      );

      _cache[cacheKey] = trendData;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return trendData;
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get trend data: $e',
        code: 'GET_TREND_DATA_ERROR',
        originalError: e,
      );
    }
  }

  // ==================== SYNCHRONISATION ET CACHE ====================

  @override
  Future<bool> syncData({bool forceSync = false}) async {
    try {
      // Pour l'instant, pas de synchronisation distante
      // Cette méthode pourrait être étendue pour synchroniser avec un serveur
      return await _localDataSource.syncData(forceSync: forceSync);
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to sync data: $e',
        code: 'SYNC_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> clearCache({Duration? olderThan}) async {
    try {
      // Nettoyer le cache local
      _cache.clear();

      // Nettoyer le cache de la source de données
      return await _localDataSource.clearCache(olderThan: olderThan);
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to clear cache: $e',
        code: 'CLEAR_CACHE_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> isHealthy() async {
    try {
      // Vérifier la santé de tous les composants
      final localHealthy = await _localDataSource.isHealthy();

      // Pour l'instant, on considère que le repository est sain si le local l'est
      // On pourrait ajouter des vérifications pour les services externes
      return localHealthy;
    } catch (e) {
      return false;
    }
  }

  // ==================== RECHERCHE ET FILTRAGE ====================

  @override
  Future<List<PlantFreezed>> searchPlants(Map<String, dynamic> criteria) async {
    try {
      // **REFACTORÉ - Prompt 2 :** Utilisation du hub pour accéder aux plantes
      // Récupérer toutes les plantes depuis le hub (via le catalogue unifié)
      // Note: Pour l'instant, on utilise le gardenId si fourni, sinon on retourne vide
      if (criteria['gardenId'] != null) {
        final gardenId = criteria['gardenId'] as String;
        final unifiedPlants = await _aggregationHub.getActivePlants(gardenId);

        // Convertir UnifiedPlantData en PlantFreezed
        var filteredPlants = unifiedPlants
            .map((up) => _convertUnifiedToPlantFreezed(up))
            .toList();

        // Appliquer les filtres
        if (criteria['name'] != null) {
          final name = criteria['name'] as String;
          filteredPlants = filteredPlants
              .where((plant) =>
                  plant.commonName.toLowerCase().contains(name.toLowerCase()) ||
                  plant.scientificName
                      .toLowerCase()
                      .contains(name.toLowerCase()))
              .toList();
        }

        if (criteria['family'] != null) {
          final family = criteria['family'] as String;
          filteredPlants = filteredPlants
              .where((plant) =>
                  plant.family.toLowerCase().contains(family.toLowerCase()))
              .toList();
        }

        if (criteria['season'] != null) {
          final season = criteria['season'] as String;
          filteredPlants = filteredPlants
              .where((plant) => plant.plantingSeason.contains(season))
              .toList();
        }

        return filteredPlants;
      }

      return [];
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to search plants: $e',
        code: 'SEARCH_PLANTS_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Recommendation>> filterRecommendations(
      Map<String, dynamic> criteria) async {
    try {
      return await _localDataSource.filterRecommendations(criteria);
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to filter recommendations: $e',
        code: 'FILTER_RECOMMENDATIONS_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchHistory({
    required String query,
    required String type,
    int limit = 20,
  }) async {
    try {
      return await _localDataSource.searchHistory(
        query: query,
        type: type,
        limit: limit,
      );
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to search history: $e',
        code: 'SEARCH_HISTORY_ERROR',
        originalError: e,
      );
    }
  }

  // ==================== IMPORT/EXPORT ====================

  @override
  Future<Map<String, dynamic>> exportPlantData({
    required String plantId,
    String format = 'json',
    bool includeHistory = true,
  }) async {
    try {
      return await _localDataSource.exportPlantData(
        plantId: plantId,
        format: format,
        includeHistory: includeHistory,
      );
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to export plant data: $e',
        code: 'EXPORT_DATA_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> importPlantData({
    required Map<String, dynamic> data,
    String format = 'json',
    bool overwrite = false,
  }) async {
    try {
      return await _localDataSource.importPlantData(
        data: data,
        format: format,
        overwrite: overwrite,
      );
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to import plant data: $e',
        code: 'IMPORT_DATA_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> backupGarden({
    required String gardenId,
    bool includeHistory = true,
  }) async {
    try {
      return await _localDataSource.backupGarden(
        gardenId: gardenId,
        includeHistory: includeHistory,
      );
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to backup garden: $e',
        code: 'BACKUP_GARDEN_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> restoreGarden({
    required Map<String, dynamic> backupData,
    required String gardenId,
  }) async {
    try {
      return await _localDataSource.restoreGarden(
        backupData: backupData,
        gardenId: gardenId,
      );
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to restore garden: $e',
        code: 'RESTORE_GARDEN_ERROR',
        originalError: e,
      );
    }
  }

  // ==================== MÉTHODES SUPPLÉMENTAIRES POUR LE MOTEUR ====================

  /// Récupère l'historique des conditions d'une plante (méthode simplifiée)
  ///
  /// Utilisée par PlantIntelligenceEngine pour obtenir rapidement les conditions récentes
  /// Par défaut, retourne les 30 derniers jours
  Future<List<PlantCondition>> getPlantConditions(String plantId) async {
    try {
      return await getPlantConditionHistory(
        plantId: plantId,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        limit: 100,
      );
    } catch (e) {
      throw PlantIntelligenceRepositoryException(
        'Failed to get plant conditions: $e',
        code: 'GET_PLANT_CONDITIONS_ERROR',
        originalError: e,
      );
    }
  }

  /// Récupère toutes les plantes d'un jardin spécifique
  ///
  /// **REFACTORÉ - Prompt 2 :**
  /// Utilisée par PlantIntelligenceEngine pour les analyses au niveau du jardin.
  /// Utilise maintenant le Garden Aggregation Hub au lieu d'accéder directement
  /// au catalogue de plantes.
  ///
  /// Retourne la liste des PlantFreezed associées au jardin
  @override
  Future<List<PlantFreezed>> getGardenPlants(String gardenId) async {
    try {
      _logDebug('🔍 DIAGNOSTIC - getGardenPlants appelé pour jardin $gardenId');

      // **REFACTORÉ - Prompt 2 :** Utilisation du hub au lieu de gardenContext + _plantCatalogService
      final unifiedPlants = await _aggregationHub.getActivePlants(gardenId);

      _logDebug(
          '🔍 DIAGNOSTIC - ${unifiedPlants.length} plantes unifiées récupérées depuis le hub');

      // Convertir UnifiedPlantData en PlantFreezed
      final gardenPlants =
          unifiedPlants.map((up) => _convertUnifiedToPlantFreezed(up)).toList();

      _logDebug(
          '✅ ${gardenPlants.length} plantes trouvées pour le jardin $gardenId');
      return gardenPlants;
    } catch (e) {
      _logDebug('❌ ERREUR - getGardenPlants: $e');
      throw PlantIntelligenceRepositoryException(
        'Failed to get garden plants: $e',
        code: 'GET_GARDEN_PLANTS_ERROR',
        originalError: e,
      );
    }
  }

  // ==================== MÉTHODES UTILITAIRES PRIVÉES ====================

  /// Log de debug pour le repository
  void _logDebug(String message) {
    developer.log(
      message,
      name: 'PlantIntelligenceRepository',
      level: 500,
    );
  }

  /// Vérifie si une entrée du cache est encore valide
  bool _isCacheValid(String cacheKey) {
    final timestampKey = '${cacheKey}_timestamp';
    if (!_cache.containsKey(cacheKey) || !_cache.containsKey(timestampKey)) {
      return false;
    }

    final timestamp = _cache[timestampKey] as DateTime;
    return DateTime.now().difference(timestamp) < _cacheValidityDuration;
  }

  /// Invalide une entrée spécifique du cache
  void _invalidateCache(String cacheKey) {
    _cache.remove(cacheKey);
    _cache.remove('${cacheKey}_timestamp');
  }

  /// Invalide toutes les entrées du cache correspondant à un pattern
  void _invalidateCacheByPattern(String pattern) {
    final keysToRemove = <String>[];
    for (final key in _cache.keys) {
      if (key.contains(pattern.replaceAll('*', ''))) {
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }

  /// Vérifie si les données météorologiques sont obsolètes (plus de 1 heure)
  bool _isWeatherDataStale(WeatherCondition weather) {
    return DateTime.now().difference(weather.measuredAt) >
        const Duration(hours: 1);
  }

  /// **NOUVEAU - Prompt 2 :** Extrait la latitude depuis le contexte unifié
  double? _extractLatitudeFromLocation(String location) {
    // Parse location string (format: "latitude, longitude" or address)
    // Pour l'instant, retourner null pour utiliser la valeur par défaut
    // TODO: Parser la localisation ou récupérer depuis les métadonnées
    return null;
  }

  /// **NOUVEAU - Prompt 2 :** Extrait la longitude depuis le contexte unifié
  double? _extractLongitudeFromLocation(String location) {
    // Parse location string (format: "latitude, longitude" or address)
    // Pour l'instant, retourner null pour utiliser la valeur par défaut
    // TODO: Parser la localisation ou récupérer depuis les métadonnées
    return null;
  }

  /// **NOUVEAU - Prompt 2 :** Convertit UnifiedGardenContext en GardenContext
  ///
  /// Cette méthode permet de convertir le format unifié du hub vers
  /// le format utilisé par l'Intelligence Végétale.
  GardenContext _convertUnifiedToGardenContext(UnifiedGardenContext unified) {
    try {
      return GardenContext(
        gardenId: unified.gardenId,
        name: unified.name,
        description: unified.description,
        location: GardenLocation(
          latitude: 48.8566, // TODO: Parser depuis unified.location
          longitude: 2.3522,
          altitude: 100.0,
          address: unified.location ?? 'Adresse non spécifiée',
        ),
        climate: ClimateConditions(
          averageTemperature: unified.climate.averageTemperature,
          minTemperature: unified.climate.minTemperature,
          maxTemperature: unified.climate.maxTemperature,
          averagePrecipitation: unified.climate.averagePrecipitation,
          averageHumidity: unified.climate.averageHumidity,
          frostDays: unified.climate.frostDays,
          growingSeasonLength: unified.climate.growingSeasonLength,
          dominantWindDirection: unified.climate.dominantWindDirection,
          averageWindSpeed: unified.climate.averageWindSpeed,
          averageSunshineHours: unified.climate.averageSunshineHours,
        ),
        soil: _convertUnifiedSoilInfo(unified.soil),
        activePlantIds: unified.activePlants.map((p) => p.plantId).toList(),
        historicalPlantIds:
            unified.historicalPlants.map((p) => p.plantId).toList(),
        stats: _convertUnifiedStats(unified.stats),
        preferences: _convertUnifiedPreferences(unified.preferences),
        createdAt: unified.createdAt,
        updatedAt: unified.updatedAt,
      );
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la conversion UnifiedGardenContext',
        name: 'PlantIntelligenceRepository',
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Convertit UnifiedSoilInfo en SoilInfo
  SoilInfo _convertUnifiedSoilInfo(UnifiedSoilInfo unified) {
    return SoilInfo(
      type: _parseSoilType(unified.type),
      ph: unified.ph,
      texture: _parseSoilTexture(unified.texture),
      organicMatter: unified.organicMatter,
      waterRetention: unified.waterRetention,
      drainage: _parseSoilDrainage(unified.drainage),
      depth: unified.depth,
      nutrients: _parseNutrientLevels(unified.nutrients),
      biologicalActivity: BiologicalActivity.moderate,
    );
  }

  /// Convertit UnifiedGardenStats en GardenStats
  GardenStats _convertUnifiedStats(UnifiedGardenStats unified) {
    return GardenStats(
      totalPlants: unified.totalPlants,
      activePlants: unified.activePlants,
      totalArea: unified.totalArea,
      activeArea: unified.activeArea,
      totalYield: unified.totalYield,
      currentYearYield: unified.currentYearYield,
      harvestsThisYear: unified.harvestsThisYear,
      plantingsThisYear: unified.plantingsThisYear,
      successRate: unified.successRate,
      totalInputCosts: 0.0,
      totalHarvestValue: 0.0,
    );
  }

  /// Convertit UnifiedCultivationPreferences en CultivationPreferences
  CultivationPreferences _convertUnifiedPreferences(
      UnifiedCultivationPreferences unified) {
    return CultivationPreferences(
      method: _parseCultivationMethod(unified.method),
      usePesticides: unified.usePesticides,
      useChemicalFertilizers: unified.useChemicalFertilizers,
      useOrganicFertilizers: unified.useOrganicFertilizers,
      cropRotation: unified.cropRotation,
      companionPlanting: unified.companionPlanting,
      mulching: unified.mulching,
      automaticIrrigation: unified.automaticIrrigation,
      regularMonitoring: unified.regularMonitoring,
      objectives: unified.objectives,
    );
  }

  /// **NOUVEAU - Prompt 2 :** Convertit UnifiedPlantData en PlantFreezed
  /// **CORRIGÉ - Prompt 1 Phase 2 :** Mapping correct vers PlantFreezed
  PlantFreezed _convertUnifiedToPlantFreezed(UnifiedPlantData unified) {
    // Conversion List<String> → String pour plantingSeason/harvestSeason
    final plantingSeasonStr = unified.plantingSeason.isNotEmpty
        ? unified.plantingSeason.join(', ')
        : 'Spring';
    final harvestSeasonStr = unified.harvestSeason.isNotEmpty
        ? unified.harvestSeason.join(', ')
        : 'Summer';

    // Construction de metadata pour stocker les données supplémentaires
    final metadata = <String, dynamic>{
      if (unified.growthCycle != null) 'growthCycle': unified.growthCycle,
      if (unified.soilType != null) 'soilType': unified.soilType,
      if (unified.companionPlants != null)
        'companionPlants': unified.companionPlants,
      if (unified.incompatiblePlants != null)
        'incompatiblePlants': unified.incompatiblePlants,
      if (unified.diseases != null) 'diseases': unified.diseases,
      if (unified.pests != null) 'pests': unified.pests,
      if (unified.benefits != null) 'benefits': unified.benefits,
      if (unified.notes != null) 'notes': unified.notes,
      if (unified.imageUrl != null) 'imageUrl': unified.imageUrl,
    };

    return PlantFreezed(
      id: unified.plantId,
      commonName: unified.commonName,
      scientificName: unified.scientificName,
      family: unified.family ?? 'Unknown',
      plantingSeason: plantingSeasonStr,
      harvestSeason: harvestSeasonStr,
      daysToMaturity:
          90, // Valeur par défaut - TODO: extraire depuis metadata si disponible
      spacing: (unified.spacingInCm ?? 30.0).round(), // Conversion double → int
      depth: unified.depthInCm ?? 1.0,
      sunExposure: unified.sunExposure ?? 'Full Sun',
      waterNeeds: unified.waterNeeds ?? 'Moderate',
      description: unified.notes ?? 'No description available',
      sowingMonths: unified.plantingSeason, // List<String> → List<String> (OK)
      harvestMonths: unified.harvestSeason, // List<String> → List<String> (OK)
      metadata: metadata,
      createdAt: unified.createdAt,
      updatedAt: unified.updatedAt ?? DateTime.now(),
    );
  }

  // Méthodes helper pour parser les enums
  SoilType _parseSoilType(String type) {
    switch (type.toLowerCase()) {
      case 'clay':
        return SoilType.clay;
      case 'sandy':
        return SoilType.sandy;
      case 'loamy':
        return SoilType.loamy;
      case 'silty':
        return SoilType.silty;
      case 'peaty':
        return SoilType.peaty;
      case 'chalky':
        return SoilType.chalky;
      case 'rocky':
        return SoilType.rocky;
      default:
        return SoilType.loamy;
    }
  }

  SoilTexture _parseSoilTexture(String texture) {
    switch (texture.toLowerCase()) {
      case 'fine':
        return SoilTexture.fine;
      case 'medium':
        return SoilTexture.medium;
      case 'coarse':
        return SoilTexture.coarse;
      default:
        return SoilTexture.medium;
    }
  }

  SoilDrainage _parseSoilDrainage(String drainage) {
    switch (drainage.toLowerCase()) {
      case 'poor':
        return SoilDrainage.poor;
      case 'moderate':
        return SoilDrainage.moderate;
      case 'good':
        return SoilDrainage.good;
      case 'excellent':
        return SoilDrainage.excellent;
      default:
        return SoilDrainage.good;
    }
  }

  CultivationMethod _parseCultivationMethod(String method) {
    switch (method.toLowerCase()) {
      case 'organic':
        return CultivationMethod.organic;
      case 'permaculture':
        return CultivationMethod.permaculture;
      case 'biointensive':
        return CultivationMethod
            .permaculture; // Biointensive mapped to permaculture (similar approach)
      case 'biodynamic':
        return CultivationMethod.biodynamic;
      case 'conventional':
        return CultivationMethod.conventional;
      case 'hydroponic':
        return CultivationMethod.hydroponic;
      case 'aquaponic':
        return CultivationMethod.aquaponic;
      case 'agroforestry':
        return CultivationMethod.agroforestry;
      default:
        return CultivationMethod.organic;
    }
  }

  NutrientLevels _parseNutrientLevels(Map<String, String> nutrients) {
    return NutrientLevels(
      nitrogen: _parseNutrientLevel(nutrients['nitrogen']),
      phosphorus: _parseNutrientLevel(nutrients['phosphorus']),
      potassium: _parseNutrientLevel(nutrients['potassium']),
      calcium: NutrientLevel.adequate,
      magnesium: NutrientLevel.adequate,
      sulfur: NutrientLevel.adequate,
    );
  }

  NutrientLevel _parseNutrientLevel(String? level) {
    switch (level?.toLowerCase()) {
      case 'low':
        return NutrientLevel.low;
      case 'adequate':
        return NutrientLevel.adequate;
      case 'high':
        return NutrientLevel.high;
      case 'excessive':
        return NutrientLevel.excessive;
      default:
        return NutrientLevel.adequate;
    }
  }

  /// Crée un GardenLocation à partir d'une chaîne de localisation
  GardenLocation _createGardenLocationFromString(String? locationString) {
    if (locationString == null || locationString.isEmpty) {
      return const GardenLocation(
        latitude: 48.8566, // Paris par défaut
        longitude: 2.3522,
        altitude: 100.0,
        address: 'Adresse non spécifiée',
      );
    }

    // Pour l'instant, on utilise des coordonnées par défaut
    // TODO: Parser la chaîne de localisation pour extraire lat/lng
    return GardenLocation(
      latitude: 48.8566,
      longitude: 2.3522,
      altitude: 100.0,
      address: locationString,
    );
  }

  /// Crée des conditions climatiques par défaut
  ClimateConditions _createDefaultClimateConditions() {
    return const ClimateConditions(
      averageTemperature: 15.0,
      minTemperature: -5.0,
      maxTemperature: 35.0,
      averagePrecipitation: 800.0,
      averageHumidity: 70.0,
      frostDays: 30,
      growingSeasonLength: 200,
      dominantWindDirection: 'SW',
      averageWindSpeed: 10.0,
      averageSunshineHours: 2000.0,
    );
  }

  /// Crée des informations de sol par défaut
  SoilInfo _createDefaultSoilInfo() {
    return const SoilInfo(
      type: SoilType.loamy,
      ph: 6.5,
      texture: SoilTexture.medium,
      organicMatter: 5.0,
      waterRetention: 60.0,
      drainage: SoilDrainage.good,
      depth: 50.0,
      nutrients: NutrientLevels(
        nitrogen: NutrientLevel.adequate,
        phosphorus: NutrientLevel.adequate,
        potassium: NutrientLevel.adequate,
        calcium: NutrientLevel.adequate,
        magnesium: NutrientLevel.adequate,
        sulfur: NutrientLevel.adequate,
      ),
      biologicalActivity: BiologicalActivity.moderate,
    );
  }

  // ==================== CURSOR PROMPT A4 - REPORT PERSISTENCE ====================

  @override
  Future<void> saveLatestReport(PlantIntelligenceReport report) async {
    try {
      developer.log(
        '💾 REPOSITORY - Sauvegarde rapport intelligence pour plante ${report.plantId}',
        name: 'PlantIntelligenceRepository',
      );

      // Sérialiser le rapport en JSON
      final reportJson = report.toJson();

      // Sauvegarder via le datasource
      await _localDataSource.saveIntelligenceReport(report.plantId, reportJson);

      // Invalider le cache pour ce rapport
      _invalidateCache('intelligence_report_${report.plantId}');

      developer.log(
        '✅ REPOSITORY - Rapport sauvegardé avec succès (score: ${report.intelligenceScore.toStringAsFixed(1)}, confiance: ${(report.confidence * 100).toStringAsFixed(0)}%)',
        name: 'PlantIntelligenceRepository',
      );
    } catch (e, stackTrace) {
      // Programmation défensive : ne jamais crasher si la persistence échoue
      developer.log(
        '❌ REPOSITORY - Erreur sauvegarde rapport (non bloquant): $e',
        name: 'PlantIntelligenceRepository',
        error: e,
        stackTrace: stackTrace,
        level: 900,
      );
      // Ne pas propager l'exception
    }
  }

  @override
  Future<PlantIntelligenceReport?> getLastReport(String plantId) async {
    try {
      developer.log(
        '🔍 REPOSITORY - Récupération dernier rapport pour plante $plantId',
        name: 'PlantIntelligenceRepository',
      );

      // Vérifier le cache d'abord
      final cacheKey = 'intelligence_report_$plantId';
      if (_isCacheValid(cacheKey)) {
        developer.log(
          '✅ REPOSITORY - Rapport trouvé dans le cache',
          name: 'PlantIntelligenceRepository',
        );
        return _cache[cacheKey] as PlantIntelligenceReport?;
      }

      // Récupérer depuis le datasource
      final reportJson = await _localDataSource.getIntelligenceReport(plantId);

      if (reportJson == null) {
        developer.log(
          'ℹ️ REPOSITORY - Aucun rapport trouvé pour plante $plantId',
          name: 'PlantIntelligenceRepository',
        );
        return null;
      }

      // Désérialiser le JSON en PlantIntelligenceReport
      final report = PlantIntelligenceReport.fromJson(reportJson);

      // Mettre en cache
      _cache[cacheKey] = report;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      developer.log(
        '✅ REPOSITORY - Rapport récupéré avec succès (généré le: ${report.generatedAt}, score: ${report.intelligenceScore.toStringAsFixed(1)})',
        name: 'PlantIntelligenceRepository',
      );

      return report;
    } catch (e, stackTrace) {
      // Programmation défensive : ne jamais crasher si la récupération échoue
      developer.log(
        '❌ REPOSITORY - Erreur récupération rapport (non bloquant): $e',
        name: 'PlantIntelligenceRepository',
        error: e,
        stackTrace: stackTrace,
        level: 900,
      );
      // Retourner null en cas d'erreur
      return null;
    }
  }

  // ==================== CURSOR PROMPT A7 - EVOLUTION HISTORY PERSISTENCE ====================

  @override
  Future<void> saveEvolutionReport(PlantEvolutionReport report) async {
    try {
      developer.log(
        '💾 REPOSITORY - Sauvegarde rapport évolution pour plante ${report.plantId}',
        name: 'PlantIntelligenceRepository',
      );

      // Sérialiser le rapport en JSON
      final reportJson = report.toJson();

      // Sauvegarder via le datasource
      await _localDataSource.saveEvolutionReport(reportJson);

      // Invalider le cache pour ces rapports
      _invalidateCache('evolution_reports_${report.plantId}');

      developer.log(
        '✅ REPOSITORY - Rapport évolution sauvegardé avec succès (Δ score: ${report.deltaScore.toStringAsFixed(1)}, trend: ${report.trend})',
        name: 'PlantIntelligenceRepository',
      );
    } catch (e, stackTrace) {
      // Programmation défensive : ne jamais crasher si la persistence échoue
      developer.log(
        '❌ REPOSITORY - Erreur sauvegarde rapport évolution (non bloquant): $e',
        name: 'PlantIntelligenceRepository',
        error: e,
        stackTrace: stackTrace,
        level: 900,
      );
      // Ne pas propager l'exception
    }
  }

  @override
  Future<List<PlantEvolutionReport>> getEvolutionReports(String plantId) async {
    try {
      developer.log(
        '🔍 REPOSITORY - Récupération rapports évolution pour plante $plantId',
        name: 'PlantIntelligenceRepository',
      );

      // Vérifier le cache d'abord
      final cacheKey = 'evolution_reports_$plantId';
      if (_isCacheValid(cacheKey)) {
        developer.log(
          '✅ REPOSITORY - Rapports trouvés dans le cache',
          name: 'PlantIntelligenceRepository',
        );
        return _cache[cacheKey] as List<PlantEvolutionReport>;
      }

      // Récupérer depuis le datasource
      final reportsJson = await _localDataSource.getEvolutionReports(plantId);

      if (reportsJson.isEmpty) {
        developer.log(
          'ℹ️ REPOSITORY - Aucun rapport évolution trouvé pour plante $plantId',
          name: 'PlantIntelligenceRepository',
        );
        return [];
      }

      // Désérialiser chaque JSON en PlantEvolutionReport
      // Skip corrupted reports gracefully
      final reports = <PlantEvolutionReport>[];
      for (final json in reportsJson) {
        try {
          final report = PlantEvolutionReport.fromJson(json);
          reports.add(report);
        } catch (e) {
          developer.log(
            '⚠️ REPOSITORY - Rapport corrompu ignoré: $e',
            name: 'PlantIntelligenceRepository',
            level: 900,
          );
          // Continue with other reports
          continue;
        }
      }

      // Mettre en cache
      _cache[cacheKey] = reports;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      developer.log(
        '✅ REPOSITORY - ${reports.length} rapports évolution récupérés',
        name: 'PlantIntelligenceRepository',
      );

      return reports;
    } catch (e, stackTrace) {
      // Programmation défensive : ne jamais crasher si la récupération échoue
      developer.log(
        '❌ REPOSITORY - Erreur récupération rapports évolution (non bloquant): $e',
        name: 'PlantIntelligenceRepository',
        error: e,
        stackTrace: stackTrace,
        level: 900,
      );
      // Retourner liste vide en cas d'erreur
      return [];
    }
  }
}

