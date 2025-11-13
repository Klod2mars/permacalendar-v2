import 'dart:developer' as developer;
import 'package:hive/hive.dart';
import '../../domain/entities/plant_condition.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/weather_condition.dart';
import '../../domain/entities/weather_condition_hive.dart';
import '../../domain/entities/garden_context.dart';
import '../../domain/entities/garden_context_hive.dart';
import '../../domain/models/plant_freezed.dart';

/// Interface pour la source de données locale de l'intelligence des plantes
///
/// Définit les contrats pour l'accès aux données locales via Hive
/// pour la persistance des informations d'intelligence des plantes
abstract class PlantIntelligenceLocalDataSource {
  // ==================== GESTION DES CONDITIONS ====================

  /// Sauvegarde les conditions d'une plante
  Future<void> savePlantCondition(PlantCondition condition);

  /// Récupère les conditions actuelles d'une plante
  Future<PlantCondition?> getCurrentPlantCondition(String plantId);

  /// Récupère l'historique des conditions d'une plante
  Future<List<PlantCondition>> getPlantConditionHistory({
    required String plantId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  });

  /// Met à jour les conditions d'une plante
  Future<bool> updatePlantCondition(
      String conditionId, PlantCondition condition);

  /// Supprime un enregistrement de condition
  Future<bool> deletePlantCondition(String conditionId);

  // ==================== GESTION DES CONDITIONS MÉTÉOROLOGIQUES ====================

  /// Sauvegarde les conditions météorologiques
  Future<void> saveWeatherCondition(String gardenId, WeatherCondition weather);

  /// Récupère les conditions météorologiques actuelles
  Future<WeatherCondition?> getCurrentWeatherCondition(String gardenId);

  /// Récupère l'historique météorologique
  Future<List<WeatherCondition>> getWeatherHistory({
    required String gardenId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  });

  // ==================== GESTION DU CONTEXTE JARDIN ====================

  /// Sauvegarde le contexte d'un jardin
  Future<void> saveGardenContext(GardenContext garden);

  /// Récupère le contexte d'un jardin
  Future<GardenContext?> getGardenContext(String gardenId);

  /// Met à jour le contexte d'un jardin
  Future<bool> updateGardenContext(GardenContext garden);

  /// Récupère tous les jardins d'un utilisateur
  Future<List<GardenContext>> getUserGardens(String userId);

  // ==================== GESTION DES RECOMMANDATIONS ====================

  /// Sauvegarde une recommandation
  Future<void> saveRecommendation(
      String plantId, Recommendation recommendation);

  /// Récupère les recommandations actives pour une plante
  Future<List<Recommendation>> getActiveRecommendations({
    required String plantId,
    int limit = 10,
  });

  /// Récupère les recommandations par priorité
  Future<List<Recommendation>> getRecommendationsByPriority({
    required String plantId,
    required String priority,
  });

  /// Marque une recommandation comme appliquée
  Future<bool> markRecommendationAsApplied({
    required String recommendationId,
    DateTime? appliedAt,
    String? notes,
  });

  /// Marque une recommandation comme ignorée
  Future<bool> markRecommendationAsIgnored({
    required String recommendationId,
    String? reason,
  });

  /// Supprime une recommandation
  Future<bool> deleteRecommendation(String recommendationId);

  // ==================== GESTION DES ANALYSES ====================

  /// Sauvegarde le résultat d'une analyse
  Future<void> saveAnalysisResult({
    required String plantId,
    required String analysisType,
    required Map<String, dynamic> result,
    required double confidence,
  });

  /// Récupère la dernière analyse d'un type pour une plante
  Future<Map<String, dynamic>?> getLatestAnalysis({
    required String plantId,
    required String analysisType,
  });

  /// Récupère l'historique des analyses
  Future<List<Map<String, dynamic>>> getAnalysisHistory({
    required String plantId,
    String? analysisType,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  });

  // ==================== GESTION DES ALERTES ====================

  /// Sauvegarde une alerte
  Future<void> saveAlert({
    required String plantId,
    required String alertType,
    required String severity,
    required String message,
    Map<String, dynamic>? data,
  });

  /// Récupère les alertes actives
  Future<List<Map<String, dynamic>>> getActiveAlerts({
    String? plantId,
    String? gardenId,
    String? severity,
  });

  /// Marque une alerte comme résolue
  Future<bool> resolveAlert({
    required String alertId,
    DateTime? resolvedAt,
    String? resolution,
  });

  // ==================== GESTION DES PRÉFÉRENCES UTILISATEUR ====================

  /// Sauvegarde les préférences d'un utilisateur
  Future<bool> saveUserPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  });

  /// Récupère les préférences d'un utilisateur
  Future<Map<String, dynamic>?> getUserPreferences(String userId);

  /// Met à jour une préférence spécifique
  Future<bool> updateUserPreference({
    required String userId,
    required String key,
    required dynamic value,
  });

  // ==================== STATISTIQUES ET MÉTRIQUES ====================

  /// Récupère les statistiques de santé d'une plante
  Future<Map<String, dynamic>> getPlantHealthStats({
    required String plantId,
    int period = 30,
  });

  /// Récupère les métriques de performance du jardin
  Future<Map<String, dynamic>> getGardenPerformanceMetrics({
    required String gardenId,
    int period = 30,
  });

  /// Récupère les tendances d'évolution
  Future<List<Map<String, dynamic>>> getTrendData({
    required String plantId,
    required String metric,
    int period = 90,
  });

  // ==================== SYNCHRONISATION ET CACHE ====================

  /// Synchronise les données avec le serveur distant
  Future<bool> syncData({bool forceSync = false});

  /// Vide le cache local
  Future<bool> clearCache({Duration? olderThan});

  /// Vérifie la connectivité et l'état du repository
  Future<bool> isHealthy();

  // ==================== RECHERCHE ET FILTRAGE ====================

  /// Recherche des plantes par critères
  Future<List<PlantFreezed>> searchPlants(Map<String, dynamic> criteria);

  /// Filtre les recommandations par critères
  Future<List<Recommendation>> filterRecommendations(
      Map<String, dynamic> criteria);

  /// Recherche dans l'historique par mots-clés
  Future<List<Map<String, dynamic>>> searchHistory({
    required String query,
    required String type,
    int limit = 20,
  });

  // ==================== IMPORT/EXPORT ====================

  /// Exporte les données d'une plante
  Future<Map<String, dynamic>> exportPlantData({
    required String plantId,
    String format = 'json',
    bool includeHistory = true,
  });

  /// Importe des données de plante
  Future<bool> importPlantData({
    required Map<String, dynamic> data,
    String format = 'json',
    bool overwrite = false,
  });

  /// Sauvegarde complète du jardin
  Future<Map<String, dynamic>> backupGarden({
    required String gardenId,
    bool includeHistory = true,
  });

  /// Restauration complète du jardin
  Future<bool> restoreGarden({
    required Map<String, dynamic> backupData,
    required String gardenId,
  });

  // ==================== CURSOR PROMPT A4 - REPORT PERSISTENCE ====================

  /// Sauvegarde le dernier rapport d'intelligence pour une plante
  ///
  /// Stocke le rapport en JSON dans Hive avec le plantId comme clé
  Future<void> saveIntelligenceReport(
      String plantId, Map<String, dynamic> reportJson);

  /// Récupère le dernier rapport d'intelligence pour une plante
  ///
  /// Retourne null si aucun rapport n'existe pour cette plante
  Future<Map<String, dynamic>?> getIntelligenceReport(String plantId);

  // ==================== CURSOR PROMPT A7 - EVOLUTION HISTORY PERSISTENCE ====================

  /// Sauvegarde un rapport d'évolution pour une plante
  ///
  /// Stocke le rapport en JSON dans Hive avec une clé composée (plantId + timestamp)
  Future<void> saveEvolutionReport(Map<String, dynamic> evolutionReportJson);

  /// Récupère l'historique des rapports d'évolution pour une plante
  ///
  /// Retourne liste vide si aucun rapport n'existe pour cette plante
  Future<List<Map<String, dynamic>>> getEvolutionReports(String plantId);
}

/// Implémentation concrète de la source de données locale avec Hive
class PlantIntelligenceLocalDataSourceImpl
    implements PlantIntelligenceLocalDataSource {
  final HiveInterface hive;

  PlantIntelligenceLocalDataSourceImpl(this.hive);

  // ==================== BOXES HIVE ====================

  Future<Box<PlantCondition>> get _plantConditionsBox async {
    // Vérifier si la box est déjà ouverte
    if (hive.isBoxOpen('plant_conditions')) {
      // Retourner la box existante avec un cast sécurisé
      try {
        return hive.box<PlantCondition>('plant_conditions');
      } catch (e) {
        // Si le cast échoue, fermer et rouvrir la box
        await hive.box('plant_conditions').close();
        return await hive.openBox<PlantCondition>('plant_conditions');
      }
    }
    // Sinon, ouvrir la box avec le type correct
    return await hive.openBox<PlantCondition>('plant_conditions');
  }

  Future<Box<Recommendation>> get _recommendationsBox async {
    // Vérifier si la box est déjà ouverte
    if (hive.isBoxOpen('recommendations')) {
      // Retourner la box existante avec un cast sécurisé
      try {
        return hive.box<Recommendation>('recommendations');
      } catch (e) {
        // Si le cast échoue, fermer et rouvrir la box
        await hive.box('recommendations').close();
        return await hive.openBox<Recommendation>('recommendations');
      }
    }
    // Sinon, ouvrir la box avec le type correct
    return await hive.openBox<Recommendation>('recommendations');
  }

  Future<Box<WeatherConditionHive>> get _weatherConditionsBox async {
    // Toujours ouvrir la box directement au lieu d'utiliser hive.box()
    // Cela évite le conflit de type interne de Hive
    return await hive.openBox<WeatherConditionHive>('weather_conditions');
  }

  Future<Box<GardenContextHive>> get _gardenContextsBox async {
    return await hive.openBox<GardenContextHive>('garden_contexts');
  }

  Future<Box<Map<dynamic, dynamic>>> get _analysesBox async {
    return await hive.openBox<Map<dynamic, dynamic>>('analyses');
  }

  Future<Box<Map<dynamic, dynamic>>> get _alertsBox async {
    return await hive.openBox<Map<dynamic, dynamic>>('alerts');
  }

  Future<Box<Map<dynamic, dynamic>>> get _preferencesBox async {
    return await hive.openBox<Map<dynamic, dynamic>>('user_preferences');
  }

  /// 🔄 CURSOR PROMPT A4 - Intelligence Reports Box
  ///
  /// Box Hive pour stocker les rapports d'intelligence complets
  /// Clé = plantId, Valeur = JSON du PlantIntelligenceReport
  Future<Box<Map<dynamic, dynamic>>> get _intelligenceReportsBox async {
    return await hive.openBox<Map<dynamic, dynamic>>('intelligence_reports');
  }

  /// 🔄 CURSOR PROMPT A7 - Evolution Reports Box
  ///
  /// Box Hive pour stocker l'historique des rapports d'évolution
  /// Clé = plantId_timestamp, Valeur = JSON du PlantEvolutionReport
  Future<Box<Map<dynamic, dynamic>>> get _evolutionReportsBox async {
    return await hive.openBox<Map<dynamic, dynamic>>('evolution_reports');
  }

  // ==================== GESTION DES CONDITIONS ====================

  @override
  Future<void> savePlantCondition(PlantCondition condition) async {
    final box = await _plantConditionsBox;
    await box.put(condition.id, condition);
  }

  @override
  Future<PlantCondition?> getCurrentPlantCondition(String plantId) async {
    developer.log(
        '🔍 DIAGNOSTIC - Début getCurrentPlantCondition: plantId=$plantId',
        name: 'PlantIntelligenceLocalDataSource');

    try {
      developer.log('🔍 DIAGNOSTIC - Récupération box plant_conditions...',
          name: 'PlantIntelligenceLocalDataSource');
      final box = await _plantConditionsBox;
      developer.log('🔍 DIAGNOSTIC - Box récupérée: ${box.length} entrées',
          name: 'PlantIntelligenceLocalDataSource');

      developer.log(
          '🔍 DIAGNOSTIC - Filtrage conditions pour plantId=$plantId...',
          name: 'PlantIntelligenceLocalDataSource');
      final conditions = box.values.where((c) => c.plantId == plantId).toList();
      developer.log('🔍 DIAGNOSTIC - Conditions trouvées: ${conditions.length}',
          name: 'PlantIntelligenceLocalDataSource');

      if (conditions.isEmpty) {
        developer.log(
            '🔍 DIAGNOSTIC - Aucune condition trouvée pour plantId=$plantId',
            name: 'PlantIntelligenceLocalDataSource');
        return null;
      }

      developer.log('🔍 DIAGNOSTIC - Tri par date...',
          name: 'PlantIntelligenceLocalDataSource');
      // Retourner la condition la plus récente
      conditions.sort((a, b) => b.measuredAt.compareTo(a.measuredAt));
      final result = conditions.first;

      developer.log(
          '✅ DIAGNOSTIC - Condition récupérée: id=${result.id}, date=${result.measuredAt}',
          name: 'PlantIntelligenceLocalDataSource');
      return result;
    } catch (e, stackTrace) {
      developer.log('❌ DIAGNOSTIC - Erreur getCurrentPlantCondition: $e',
          name: 'PlantIntelligenceLocalDataSource');
      developer.log('❌ DIAGNOSTIC - StackTrace: $stackTrace',
          name: 'PlantIntelligenceLocalDataSource');
      rethrow;
    }
  }

  @override
  Future<List<PlantCondition>> getPlantConditionHistory({
    required String plantId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) async {
    final box = await _plantConditionsBox;
    var conditions = box.values.where((c) => c.plantId == plantId).toList();

    // Filtrer par date si spécifié
    if (startDate != null) {
      conditions =
          conditions.where((c) => c.measuredAt.isAfter(startDate)).toList();
    }
    if (endDate != null) {
      conditions =
          conditions.where((c) => c.measuredAt.isBefore(endDate)).toList();
    }

    // Trier par date décroissante et limiter
    conditions.sort((a, b) => b.measuredAt.compareTo(a.measuredAt));
    return conditions.take(limit).toList();
  }

  @override
  Future<bool> updatePlantCondition(
      String conditionId, PlantCondition condition) async {
    try {
      final box = await _plantConditionsBox;
      await box.put(conditionId, condition);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deletePlantCondition(String conditionId) async {
    try {
      final box = await _plantConditionsBox;
      await box.delete(conditionId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== GESTION DES CONDITIONS MÉTÉOROLOGIQUES ====================

  @override
  Future<void> saveWeatherCondition(
      String gardenId, WeatherCondition weather) async {
    final box = await _weatherConditionsBox;
    // Convertir WeatherCondition vers WeatherConditionHive pour la persistance
    final weatherHive = WeatherConditionHive.fromComposite({
      'timestamp': weather.measuredAt,
      'currentTemperature': weather.value,
      'minTemperature': weather.value - 2.0, // Estimation
      'maxTemperature': weather.value + 2.0, // Estimation
      'humidity': 70.0, // Valeur par défaut
      'precipitation': 0.0, // Valeur par défaut
      'windSpeed': 0.0, // Valeur par défaut
      'cloudCover': 50, // Valeur par défaut
      'forecast': [],
      'metadata': {
        'id': weather.id,
        'type': weather.type.name,
        'unit': weather.unit,
        'description': weather.description,
        'latitude': weather.latitude,
        'longitude': weather.longitude,
      },
    });
    await box.put('${gardenId}_${weather.measuredAt.millisecondsSinceEpoch}',
        weatherHive);
  }

  @override
  Future<WeatherCondition?> getCurrentWeatherCondition(String gardenId) async {
    final box = await _weatherConditionsBox;
    final weatherConditionsHive = box.values
        .where((w) => w.metadata?['id']?.toString().contains(gardenId) ?? false)
        .toList();

    if (weatherConditionsHive.isEmpty) return null;

    // Retourner la condition météo la plus récente
    weatherConditionsHive.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final latestHive = weatherConditionsHive.first;

    // Convertir WeatherConditionHive vers WeatherCondition
    return WeatherCondition(
      id: latestHive.metadata?['id']?.toString() ?? 'unknown',
      type: WeatherType.values.firstWhere(
        (t) => t.name == latestHive.metadata?['type'],
        orElse: () => WeatherType.temperature,
      ),
      value: latestHive.currentTemperature,
      unit: latestHive.metadata?['unit']?.toString() ?? '°C',
      description: latestHive.metadata?['description']?.toString(),
      measuredAt: latestHive.timestamp,
      latitude: latestHive.metadata?['latitude']?.toDouble(),
      longitude: latestHive.metadata?['longitude']?.toDouble(),
    );
  }

  @override
  Future<List<WeatherCondition>> getWeatherHistory({
    required String gardenId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) async {
    final box = await _weatherConditionsBox;
    var weatherConditionsHive = box.values
        .where((w) => w.metadata?['id']?.toString().contains(gardenId) ?? false)
        .toList();

    // Filtrer par date si spécifié
    if (startDate != null) {
      weatherConditionsHive = weatherConditionsHive
          .where((w) => w.timestamp.isAfter(startDate))
          .toList();
    }
    if (endDate != null) {
      weatherConditionsHive = weatherConditionsHive
          .where((w) => w.timestamp.isBefore(endDate))
          .toList();
    }

    // Trier par date décroissante et limiter
    weatherConditionsHive.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Convertir vers WeatherCondition
    return weatherConditionsHive
        .take(limit)
        .map((hive) => WeatherCondition(
              id: hive.metadata?['id']?.toString() ?? 'unknown',
              type: WeatherType.values.firstWhere(
                (t) => t.name == hive.metadata?['type'],
                orElse: () => WeatherType.temperature,
              ),
              value: hive.currentTemperature,
              unit: hive.metadata?['unit']?.toString() ?? '°C',
              description: hive.metadata?['description']?.toString(),
              measuredAt: hive.timestamp,
              latitude: hive.metadata?['latitude']?.toDouble(),
              longitude: hive.metadata?['longitude']?.toDouble(),
            ))
        .toList();
  }

  // ==================== GESTION DU CONTEXTE JARDIN ====================

  @override
  Future<void> saveGardenContext(GardenContext garden) async {
    try {
      developer.log(
        '🔍 DIAGNOSTIC: DataSource - Début sauvegarde GardenContext ${garden.gardenId}',
        name: 'PlantIntelligenceLocalDataSource',
        level: 500,
      );

      final box = await _gardenContextsBox;

      developer.log(
        '🔍 DIAGNOSTIC: DataSource - Box récupérée, type: ${box.runtimeType}',
        name: 'PlantIntelligenceLocalDataSource',
        level: 500,
      );

      // Convertir GardenContext vers GardenContextHive
      final gardenContextHive = GardenContextHive.fromGardenContext(garden);

      developer.log(
        '🔍 DIAGNOSTIC: DataSource - Conversion réussie, type Hive: ${gardenContextHive.runtimeType}',
        name: 'PlantIntelligenceLocalDataSource',
        level: 500,
      );

      developer.log(
        '🔍 DIAGNOSTIC: DataSource - Début put() avec clé: ${garden.gardenId}',
        name: 'PlantIntelligenceLocalDataSource',
        level: 500,
      );

      await box.put(garden.gardenId, gardenContextHive);

      developer.log(
        '🔍 DIAGNOSTIC: DataSource - GardenContext sauvegardé avec succès',
        name: 'PlantIntelligenceLocalDataSource',
        level: 500,
      );
    } catch (e, stackTrace) {
      developer.log(
        '❌ ERREUR CRITIQUE DataSource - Échec sauvegarde GardenContext: $e',
        name: 'PlantIntelligenceLocalDataSource',
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<GardenContext?> getGardenContext(String gardenId) async {
    final box = await _gardenContextsBox;
    final gardenContextHive = box.get(gardenId);
    return gardenContextHive?.toGardenContext();
  }

  @override
  Future<bool> updateGardenContext(GardenContext garden) async {
    try {
      final box = await _gardenContextsBox;
      final gardenContextHive = GardenContextHive.fromGardenContext(garden);
      await box.put(garden.gardenId, gardenContextHive);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<GardenContext>> getUserGardens(String userId) async {
    final box = await _gardenContextsBox;
    // Pour l'instant, retourner tous les jardins car GardenContext n'a pas de userId
    // TODO: Ajouter un champ userId à GardenContext ou utiliser une autre approche
    return box.values
        .cast<GardenContextHive>()
        .map((hive) => hive.toGardenContext())
        .toList();
  }

  // ==================== GESTION DES RECOMMANDATIONS ====================

  @override
  Future<void> saveRecommendation(
      String plantId, Recommendation recommendation) async {
    final box = await _recommendationsBox;
    await box.put(recommendation.id, recommendation);
  }

  @override
  Future<List<Recommendation>> getActiveRecommendations({
    required String plantId,
    int limit = 10,
  }) async {
    final box = await _recommendationsBox;
    final recommendations = box.values
        .where((r) =>
            r.plantId == plantId && r.status == RecommendationStatus.pending)
        .toList();

    // Trier par priorité et date
    recommendations.sort((a, b) {
      final priorityComparison = _getPriorityWeight(b.priority.name)
          .compareTo(_getPriorityWeight(a.priority.name));
      if (priorityComparison != 0) return priorityComparison;
      return (b.createdAt ?? DateTime.now())
          .compareTo(a.createdAt ?? DateTime.now());
    });

    return recommendations.take(limit).toList();
  }

  @override
  Future<List<Recommendation>> getRecommendationsByPriority({
    required String plantId,
    required String priority,
  }) async {
    final box = await _recommendationsBox;
    return box.values
        .where((r) => r.plantId == plantId && r.priority.name == priority)
        .toList();
  }

  @override
  Future<bool> markRecommendationAsApplied({
    required String recommendationId,
    DateTime? appliedAt,
    String? notes,
  }) async {
    try {
      final box = await _recommendationsBox;
      final recommendation = box.get(recommendationId);
      if (recommendation == null) return false;

      final updatedRecommendation = recommendation.copyWith(
        status: RecommendationStatus.completed,
        completedAt: appliedAt ?? DateTime.now(),
        notes: notes,
      );

      await box.put(recommendationId, updatedRecommendation);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> markRecommendationAsIgnored({
    required String recommendationId,
    String? reason,
  }) async {
    try {
      final box = await _recommendationsBox;
      final recommendation = box.get(recommendationId);
      if (recommendation == null) return false;

      final updatedRecommendation = recommendation.copyWith(
        status: RecommendationStatus.dismissed,
        updatedAt: DateTime.now(),
        notes: reason,
      );

      await box.put(recommendationId, updatedRecommendation);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteRecommendation(String recommendationId) async {
    try {
      final box = await _recommendationsBox;
      await box.delete(recommendationId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== GESTION DES ANALYSES ====================

  @override
  Future<void> saveAnalysisResult({
    required String plantId,
    required String analysisType,
    required Map<String, dynamic> result,
    required double confidence,
  }) async {
    final box = await _analysesBox;
    final analysisId =
        '${plantId}_${analysisType}_${DateTime.now().millisecondsSinceEpoch}';

    final analysisData = {
      'id': analysisId,
      'plantId': plantId,
      'analysisType': analysisType,
      'result': result,
      'confidence': confidence,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await box.put(analysisId, analysisData);
  }

  @override
  Future<Map<String, dynamic>?> getLatestAnalysis({
    required String plantId,
    required String analysisType,
  }) async {
    final box = await _analysesBox;
    final analyses = box.values
        .where(
            (a) => a['plantId'] == plantId && a['analysisType'] == analysisType)
        .toList();

    if (analyses.isEmpty) return null;

    // Trier par timestamp et retourner le plus récent
    analyses.sort((a, b) => DateTime.parse(b['timestamp'])
        .compareTo(DateTime.parse(a['timestamp'])));

    return Map<String, dynamic>.from(analyses.first);
  }

  @override
  Future<List<Map<String, dynamic>>> getAnalysisHistory({
    required String plantId,
    String? analysisType,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  }) async {
    final box = await _analysesBox;
    var analyses = box.values.where((a) => a['plantId'] == plantId).toList();

    // Filtrer par type si spécifié
    if (analysisType != null) {
      analyses =
          analyses.where((a) => a['analysisType'] == analysisType).toList();
    }

    // Filtrer par date si spécifié
    if (startDate != null) {
      analyses = analyses
          .where((a) => DateTime.parse(a['timestamp']).isAfter(startDate))
          .toList();
    }
    if (endDate != null) {
      analyses = analyses
          .where((a) => DateTime.parse(a['timestamp']).isBefore(endDate))
          .toList();
    }

    // Trier par timestamp décroissant et limiter
    analyses.sort((a, b) => DateTime.parse(b['timestamp'])
        .compareTo(DateTime.parse(a['timestamp'])));

    return analyses
        .take(limit)
        .map((a) => Map<String, dynamic>.from(a))
        .toList();
  }

  // ==================== GESTION DES ALERTES ====================

  @override
  Future<void> saveAlert({
    required String plantId,
    required String alertType,
    required String severity,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    final box = await _alertsBox;
    final alertId =
        '${plantId}_${alertType}_${DateTime.now().millisecondsSinceEpoch}';

    final alertData = {
      'id': alertId,
      'plantId': plantId,
      'alertType': alertType,
      'severity': severity,
      'message': message,
      'data': data,
      'createdAt': DateTime.now().toIso8601String(),
      'resolved': false,
    };

    await box.put(alertId, alertData);
  }

  @override
  Future<List<Map<String, dynamic>>> getActiveAlerts({
    String? plantId,
    String? gardenId,
    String? severity,
  }) async {
    final box = await _alertsBox;
    var alerts = box.values.where((a) => a['resolved'] == false).toList();

    // Filtrer par plantId si spécifié
    if (plantId != null) {
      alerts = alerts.where((a) => a['plantId'] == plantId).toList();
    }

    // Filtrer par gardenId si spécifié
    if (gardenId != null) {
      // Note: Ici on pourrait ajouter une logique pour récupérer les plantIds du jardin
      // Pour l'instant, on filtre directement par plantId
    }

    // Filtrer par sévérité si spécifiée
    if (severity != null) {
      alerts = alerts.where((a) => a['severity'] == severity).toList();
    }

    // Trier par sévérité et date
    alerts.sort((a, b) {
      final severityComparison = _getSeverityWeight(b['severity'])
          .compareTo(_getSeverityWeight(a['severity']));
      if (severityComparison != 0) return severityComparison;
      return DateTime.parse(b['createdAt'])
          .compareTo(DateTime.parse(a['createdAt']));
    });

    return alerts.map((a) => Map<String, dynamic>.from(a)).toList();
  }

  @override
  Future<bool> resolveAlert({
    required String alertId,
    DateTime? resolvedAt,
    String? resolution,
  }) async {
    try {
      final box = await _alertsBox;
      final alert = box.get(alertId);
      if (alert == null) return false;

      final updatedAlert = Map<String, dynamic>.from(alert);
      updatedAlert['resolved'] = true;
      updatedAlert['resolvedAt'] =
          (resolvedAt ?? DateTime.now()).toIso8601String();
      if (resolution != null) {
        updatedAlert['resolution'] = resolution;
      }

      await box.put(alertId, updatedAlert);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== GESTION DES PRÉFÉRENCES UTILISATEUR ====================

  @override
  Future<bool> saveUserPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      final box = await _preferencesBox;
      await box.put(userId, preferences);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserPreferences(String userId) async {
    final box = await _preferencesBox;
    final prefs = box.get(userId);
    return prefs != null ? Map<String, dynamic>.from(prefs) : null;
  }

  @override
  Future<bool> updateUserPreference({
    required String userId,
    required String key,
    required dynamic value,
  }) async {
    try {
      final box = await _preferencesBox;
      final preferences = box.get(userId) ?? <String, dynamic>{};
      preferences[key] = value;
      await box.put(userId, preferences);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== STATISTIQUES ET MÉTRIQUES ====================

  @override
  Future<Map<String, dynamic>> getPlantHealthStats({
    required String plantId,
    int period = 30,
  }) async {
    final conditions = await getPlantConditionHistory(
      plantId: plantId,
      startDate: DateTime.now().subtract(Duration(days: period)),
    );

    if (conditions.isEmpty) {
      return {
        'averageHealth': 0.0,
        'healthTrend': 'unknown',
        'totalRecords': 0,
        'period': period,
      };
    }

    final healthScores = conditions.map((c) => c.healthScore).toList();
    final averageHealth =
        healthScores.reduce((a, b) => a + b) / healthScores.length;

    // Calculer la tendance
    String healthTrend = 'stable';
    if (conditions.length >= 2) {
      final recent =
          healthScores.take(conditions.length ~/ 2).reduce((a, b) => a + b) /
              (conditions.length ~/ 2);
      final older =
          healthScores.skip(conditions.length ~/ 2).reduce((a, b) => a + b) /
              (conditions.length - conditions.length ~/ 2);

      if (recent > older + 0.1) {
        healthTrend = 'improving';
      } else if (recent < older - 0.1) {
        healthTrend = 'declining';
      }
    }

    return {
      'averageHealth': averageHealth,
      'healthTrend': healthTrend,
      'totalRecords': conditions.length,
      'period': period,
      'latestHealthScore': healthScores.first,
    };
  }

  @override
  Future<Map<String, dynamic>> getGardenPerformanceMetrics({
    required String gardenId,
    int period = 30,
  }) async {
    // Cette méthode nécessiterait une logique plus complexe
    // pour agréger les données de toutes les plantes du jardin
    return {
      'totalPlants': 0,
      'averageHealth': 0.0,
      'activeRecommendations': 0,
      'resolvedAlerts': 0,
      'period': period,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getTrendData({
    required String plantId,
    required String metric,
    int period = 90,
  }) async {
    // Cette méthode retournerait les données de tendance pour une métrique spécifique
    return [];
  }

  // ==================== SYNCHRONISATION ET CACHE ====================

  @override
  Future<bool> syncData({bool forceSync = false}) async {
    // Pour l'instant, pas de synchronisation distante
    return true;
  }

  @override
  Future<bool> clearCache({Duration? olderThan}) async {
    try {
      // Nettoyer les données plus anciennes que la durée spécifiée
      if (olderThan != null) {
        final cutoffDate = DateTime.now().subtract(olderThan);

        // Nettoyer les conditions
        final conditionsBox = await _plantConditionsBox;
        final oldConditions = conditionsBox.values
            .where((c) => c.measuredAt.isBefore(cutoffDate))
            .map((c) => c.id)
            .toList();
        for (final id in oldConditions) {
          await conditionsBox.delete(id);
        }

        // Nettoyer les analyses
        final analysesBox = await _analysesBox;
        final oldAnalyses = analysesBox.values
            .where((a) => DateTime.parse(a['timestamp']).isBefore(cutoffDate))
            .map((a) => a['id'])
            .toList();
        for (final id in oldAnalyses) {
          await analysesBox.delete(id);
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isHealthy() async {
    try {
      // Vérifier que toutes les boxes sont accessibles
      await _plantConditionsBox;
      await _recommendationsBox;
      await _weatherConditionsBox;
      await _gardenContextsBox;
      await _analysesBox;
      await _alertsBox;
      await _preferencesBox;

      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== RECHERCHE ET FILTRAGE ====================

  @override
  Future<List<PlantFreezed>> searchPlants(Map<String, dynamic> criteria) async {
    // Cette méthode nécessiterait l'accès au catalogue de plantes
    // Pour l'instant, retourner une liste vide
    return [];
  }

  @override
  Future<List<Recommendation>> filterRecommendations(
      Map<String, dynamic> criteria) async {
    final box = await _recommendationsBox;
    var recommendations = box.values.toList();

    // Appliquer les filtres
    if (criteria['plantId'] != null) {
      recommendations = recommendations
          .where((r) => r.plantId == criteria['plantId'])
          .toList();
    }
    if (criteria['priority'] != null) {
      recommendations = recommendations
          .where((r) => r.priority == criteria['priority'])
          .toList();
    }
    if (criteria['status'] != null) {
      recommendations =
          recommendations.where((r) => r.status == criteria['status']).toList();
    }

    return recommendations;
  }

  @override
  Future<List<Map<String, dynamic>>> searchHistory({
    required String query,
    required String type,
    int limit = 20,
  }) async {
    // Implémentation basique de recherche dans l'historique
    final results = <Map<String, dynamic>>[];

    if (type == 'condition' || type == 'all') {
      final box = await _plantConditionsBox;
      final conditions = box.values
          .where((c) =>
              c.description?.toLowerCase().contains(query.toLowerCase()) ==
              true)
          .take(limit)
          .toList();

      for (final condition in conditions) {
        results.add({
          'type': 'condition',
          'id': condition.id,
          'plantId': condition.plantId,
          'timestamp': condition.measuredAt,
          'content': condition.description ?? '',
        });
      }
    }

    return results.take(limit).toList();
  }

  // ==================== IMPORT/EXPORT ====================

  @override
  Future<Map<String, dynamic>> exportPlantData({
    required String plantId,
    String format = 'json',
    bool includeHistory = true,
  }) async {
    final exportData = <String, dynamic>{
      'plantId': plantId,
      'exportDate': DateTime.now().toIso8601String(),
      'format': format,
    };

    if (includeHistory) {
      exportData['conditions'] =
          await getPlantConditionHistory(plantId: plantId);
      exportData['recommendations'] =
          await getActiveRecommendations(plantId: plantId);
      exportData['analyses'] = await getAnalysisHistory(plantId: plantId);
    }

    return exportData;
  }

  @override
  Future<bool> importPlantData({
    required Map<String, dynamic> data,
    String format = 'json',
    bool overwrite = false,
  }) async {
    try {
      // TODO: Implémenter l'import des données de plante
      // final plantId = data['plantId'] as String;

      if (data['conditions'] != null) {
        // final conditions = data['conditions'] as List;
        // Ici il faudrait reconstruire l'objet PlantCondition
        // Pour l'instant, on skip
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> backupGarden({
    required String gardenId,
    bool includeHistory = true,
  }) async {
    // Implémentation de la sauvegarde complète du jardin
    return {
      'gardenId': gardenId,
      'backupDate': DateTime.now().toIso8601String(),
      'data': {},
    };
  }

  @override
  Future<bool> restoreGarden({
    required Map<String, dynamic> backupData,
    required String gardenId,
  }) async {
    // Implémentation de la restauration complète du jardin
    return true;
  }

  // ==================== CURSOR PROMPT A4 - REPORT PERSISTENCE ====================

  @override
  Future<void> saveIntelligenceReport(
      String plantId, Map<String, dynamic> reportJson) async {
    try {
      developer.log(
        '💾 DATASOURCE - Sauvegarde rapport intelligence pour plante $plantId',
        name: 'PlantIntelligenceLocalDataSource',
      );

      final box = await _intelligenceReportsBox;

      // Sauvegarder le rapport avec le plantId comme clé
      // Un seul rapport par plante (écrase l'ancien)
      await box.put(plantId, reportJson);

      developer.log(
        '✅ DATASOURCE - Rapport sauvegardé avec succès (taille: ${reportJson.keys.length} clés)',
        name: 'PlantIntelligenceLocalDataSource',
      );
    } catch (e, stackTrace) {
      developer.log(
        '❌ DATASOURCE - Erreur sauvegarde rapport: $e',
        name: 'PlantIntelligenceLocalDataSource',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
      // Ne pas propager l'erreur - programmation défensive
      // La persistence ne doit jamais bloquer l'analyse
    }
  }

  @override
  Future<Map<String, dynamic>?> getIntelligenceReport(String plantId) async {
    try {
      developer.log(
        '🔍 DATASOURCE - Récupération rapport intelligence pour plante $plantId',
        name: 'PlantIntelligenceLocalDataSource',
      );

      final box = await _intelligenceReportsBox;

      // Récupérer le rapport pour cette plante
      final reportJson = box.get(plantId);

      if (reportJson == null) {
        developer.log(
          'ℹ️ DATASOURCE - Aucun rapport trouvé pour plante $plantId',
          name: 'PlantIntelligenceLocalDataSource',
        );
        return null;
      }

      // Convertir Map<dynamic, dynamic> en Map<String, dynamic>
      final result = Map<String, dynamic>.from(reportJson);

      developer.log(
        '✅ DATASOURCE - Rapport récupéré avec succès (${result.keys.length} clés)',
        name: 'PlantIntelligenceLocalDataSource',
      );

      return result;
    } catch (e, stackTrace) {
      developer.log(
        '❌ DATASOURCE - Erreur récupération rapport: $e',
        name: 'PlantIntelligenceLocalDataSource',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
      // Ne pas propager l'erreur - programmation défensive
      // Retourner null en cas d'erreur
      return null;
    }
  }

  // ==================== CURSOR PROMPT A7 - EVOLUTION HISTORY PERSISTENCE ====================

  @override
  Future<void> saveEvolutionReport(
      Map<String, dynamic> evolutionReportJson) async {
    try {
      developer.log(
        '💾 DATASOURCE - Sauvegarde rapport évolution pour plante ${evolutionReportJson['plantId']}',
        name: 'PlantIntelligenceLocalDataSource',
      );

      final box = await _evolutionReportsBox;

      // Extraire plantId et timestamp pour créer la clé
      final plantId = evolutionReportJson['plantId'] as String;
      final currentDate = evolutionReportJson['currentDate'] as String;

      // Créer une clé unique: plantId_timestamp
      final key = '${plantId}_$currentDate';

      // Sauvegarder le rapport d'évolution
      // Note: On ne remplace PAS les anciens rapports (historique complet)
      await box.put(key, evolutionReportJson);

      developer.log(
        '✅ DATASOURCE - Rapport évolution sauvegardé avec succès (clé: $key)',
        name: 'PlantIntelligenceLocalDataSource',
      );
    } catch (e, stackTrace) {
      developer.log(
        '❌ DATASOURCE - Erreur sauvegarde rapport évolution: $e',
        name: 'PlantIntelligenceLocalDataSource',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
      // Ne pas propager l'erreur - programmation défensive
      // La persistence ne doit jamais bloquer l'analyse
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getEvolutionReports(String plantId) async {
    try {
      developer.log(
        '🔍 DATASOURCE - Récupération rapports évolution pour plante $plantId',
        name: 'PlantIntelligenceLocalDataSource',
      );

      final box = await _evolutionReportsBox;

      // Récupérer tous les rapports qui commencent par plantId_
      final allReports = <Map<String, dynamic>>[];

      for (final key in box.keys) {
        if (key.toString().startsWith('${plantId}_')) {
          try {
            final reportJson = box.get(key);
            if (reportJson != null) {
              allReports.add(Map<String, dynamic>.from(reportJson));
            }
          } catch (e) {
            developer.log(
              '⚠️ DATASOURCE - Rapport corrompu ignoré (clé: $key): $e',
              name: 'PlantIntelligenceLocalDataSource',
              level: 900,
            );
            // Skip corrupted reports
            continue;
          }
        }
      }

      // Trier par timestamp (currentDate) en ordre chronologique
      allReports.sort((a, b) {
        try {
          final dateA = DateTime.parse(a['currentDate'] as String);
          final dateB = DateTime.parse(b['currentDate'] as String);
          return dateA.compareTo(dateB);
        } catch (e) {
          return 0; // En cas d'erreur de parsing, garder l'ordre actuel
        }
      });

      developer.log(
        '✅ DATASOURCE - ${allReports.length} rapports évolution récupérés',
        name: 'PlantIntelligenceLocalDataSource',
      );

      return allReports;
    } catch (e, stackTrace) {
      developer.log(
        '❌ DATASOURCE - Erreur récupération rapports évolution: $e',
        name: 'PlantIntelligenceLocalDataSource',
        error: e,
        stackTrace: stackTrace,
        level: 1000,
      );
      // Ne pas propager l'erreur - programmation défensive
      // Retourner liste vide en cas d'erreur
      return [];
    }
  }

  // ==================== MÉTHODES UTILITAIRES ====================

  /// Convertit une priorité de recommandation en poids numérique
  int _getPriorityWeight(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return 4;
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }

  /// Convertit une sévérité d'alerte en poids numérique
  int _getSeverityWeight(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return 4;
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }
}


