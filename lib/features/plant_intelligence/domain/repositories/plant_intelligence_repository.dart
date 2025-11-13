ï»¿import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

/// Repository abstrait pour l'intelligence des plantes
///
/// **âš ï¸ DÉPRÉCIÉ - Prompt 4 : ISP (Interface Segregation Principle)**
///
/// Cette interface monolithique viole le principe ISP en forçant les clients
/// à dépendre de nombreuses méthodes dont ils n'ont pas besoin (40+ méthodes).
///
/// **Utilisez à la place les interfaces spécialisées :**
/// - `IPlantConditionRepository` : Gestion des conditions de plantes
/// - `IWeatherRepository` : Gestion des conditions météorologiques
/// - `IGardenContextRepository` : Gestion du contexte jardin
/// - `IRecommendationRepository` : Gestion des recommandations
/// - `IAnalyticsRepository` : Analytics et statistiques
///
/// **Migration :**
/// ```dart
/// // âŒ Avant
/// PlantIntelligenceRepository repository;
///
/// // âœ… Après
/// IPlantConditionRepository conditionRepo;
/// IWeatherRepository weatherRepo;
/// IGardenContextRepository gardenRepo;
/// IRecommendationRepository recommendationRepo;
/// IAnalyticsRepository analyticsRepo;
/// ```
///
/// **Sera supprimé dans :** v3.0
///
/// Définit les contrats pour l'accès aux données et la persistance
/// des informations d'intelligence des plantes, incluant les conditions,
/// les analyses, les recommandations et l'historique
@Deprecated(
    'Utilisez les interfaces spécialisées (IPlantConditionRepository, IWeatherRepository, '
    'IGardenContextRepository, IRecommendationRepository, IAnalyticsRepository) à la place. '
    'Sera supprimé dans la v3.0')
abstract class PlantIntelligenceRepository {
  // ==================== GESTION DES CONDITIONS ====================

  /// Sauvegarde les conditions d'une plante
  ///
  /// [plantId] - Identifiant unique de la plante
  /// [condition] - Conditions actuelles de la plante
  ///
  /// Retourne l'ID de l'enregistrement Créé
  Future<String> savePlantCondition({
    required String plantId,
    required PlantCondition condition,
  });

  /// Récupère les conditions actuelles d'une plante
  ///
  /// [plantId] - Identifiant unique de la plante
  ///
  /// Retourne les conditions actuelles ou null si non trouvées
  Future<PlantCondition?> getCurrentPlantCondition(String plantId);

  /// Récupère l'historique des conditions d'une plante
  ///
  /// [plantId] - Identifiant unique de la plante
  /// [startDate] - Date de début de la période (optionnel)
  /// [endDate] - Date de fin de la période (optionnel)
  /// [limit] - Nombre maximum d'enregistrements à retourner
  ///
  /// Retourne la liste des conditions historiques
  Future<List<PlantCondition>> getPlantConditionHistory({
    required String plantId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  });

  /// Met à jour les conditions d'une plante
  ///
  /// [conditionId] - Identifiant de l'enregistrement de condition
  /// [condition] - Nouvelles conditions
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> updatePlantCondition({
    required String conditionId,
    required PlantCondition condition,
  });

  /// Supprime un enregistrement de condition
  ///
  /// [conditionId] - Identifiant de l'enregistrement à supprimer
  ///
  /// Retourne true si la suppression a réussi
  Future<bool> deletePlantCondition(String conditionId);

  // ==================== GESTION DES CONDITIONS MÉTÉOROLOGIQUES ====================

  /// Sauvegarde les conditions météorologiques
  ///
  /// [gardenId] - Identifiant du jardin
  /// [weather] - Conditions météorologiques
  ///
  /// Retourne l'ID de l'enregistrement Créé
  Future<String> saveWeatherCondition({
    required String gardenId,
    required WeatherCondition weather,
  });

  /// Récupère les conditions météorologiques actuelles
  ///
  /// [gardenId] - Identifiant du jardin
  ///
  /// Retourne les conditions météorologiques actuelles
  Future<WeatherCondition?> getCurrentWeatherCondition(String gardenId);

  /// Récupère l'historique météorologique
  ///
  /// [gardenId] - Identifiant du jardin
  /// [startDate] - Date de début de la période (optionnel)
  /// [endDate] - Date de fin de la période (optionnel)
  /// [limit] - Nombre maximum d'enregistrements à retourner
  ///
  /// Retourne la liste des conditions météorologiques historiques
  Future<List<WeatherCondition>> getWeatherHistory({
    required String gardenId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  });

  // ==================== GESTION DU CONTEXTE JARDIN ====================

  /// Sauvegarde le contexte d'un jardin
  ///
  /// [garden] - Contexte du jardin
  ///
  /// Retourne l'ID de l'enregistrement Créé
  Future<String> saveGardenContext(GardenContext garden);

  /// Récupère le contexte d'un jardin
  ///
  /// [gardenId] - Identifiant du jardin
  ///
  /// Retourne le contexte du jardin
  Future<GardenContext?> getGardenContext(String gardenId);

  /// Met à jour le contexte d'un jardin
  ///
  /// [garden] - Nouveau contexte du jardin
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> updateGardenContext(GardenContext garden);

  /// Récupère tous les jardins d'un utilisateur
  ///
  /// [userId] - Identifiant de l'utilisateur
  ///
  /// Retourne la liste des contextes de jardins
  Future<List<GardenContext>> getUserGardens(String userId);

  // ==================== GESTION DES RECOMMANDATIONS ====================

  /// Sauvegarde une recommandation
  ///
  /// [plantId] - Identifiant de la plante
  /// [recommendation] - Recommandation à sauvegarder
  ///
  /// Retourne l'ID de l'enregistrement Créé
  Future<String> saveRecommendation({
    required String plantId,
    required Recommendation recommendation,
  });

  /// Récupère les recommandations actives pour une plante
  ///
  /// [plantId] - Identifiant de la plante
  /// [limit] - Nombre maximum de recommandations à retourner
  ///
  /// Retourne la liste des recommandations actives
  Future<List<Recommendation>> getActiveRecommendations({
    required String plantId,
    int limit = 10,
  });

  /// Récupère les recommandations par priorité
  ///
  /// [plantId] - Identifiant de la plante
  /// [priority] - Niveau de priorité recherché
  ///
  /// Retourne la liste des recommandations de la priorité spécifiée
  Future<List<Recommendation>> getRecommendationsByPriority({
    required String plantId,
    required String priority,
  });

  /// Marque une recommandation comme appliquée
  ///
  /// [recommendationId] - Identifiant de la recommandation
  /// [appliedAt] - Date d'application (optionnel, par défaut maintenant)
  /// [notes] - Notes sur l'application (optionnel)
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> markRecommendationAsApplied({
    required String recommendationId,
    DateTime? appliedAt,
    String? notes,
  });

  /// Marque une recommandation comme ignorée
  ///
  /// [recommendationId] - Identifiant de la recommandation
  /// [reason] - Raison de l'ignorance (optionnel)
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> markRecommendationAsIgnored({
    required String recommendationId,
    String? reason,
  });

  /// Supprime une recommandation
  ///
  /// [recommendationId] - Identifiant de la recommandation à supprimer
  ///
  /// Retourne true si la suppression a réussi
  Future<bool> deleteRecommendation(String recommendationId);

  // ==================== GESTION DES ANALYSES ====================

  /// Sauvegarde le résultat d'une analyse
  ///
  /// [plantId] - Identifiant de la plante
  /// [analysisType] - Type d'analyse (condition, weather, intelligence)
  /// [result] - Résultat de l'analyse (JSON)
  /// [confidence] - Niveau de confiance de l'analyse
  ///
  /// Retourne l'ID de l'enregistrement Créé
  Future<String> saveAnalysisResult({
    required String plantId,
    required String analysisType,
    required Map<String, dynamic> result,
    required double confidence,
  });

  /// Récupère la dernière analyse d'un type pour une plante
  ///
  /// [plantId] - Identifiant de la plante
  /// [analysisType] - Type d'analyse recherché
  ///
  /// Retourne le résultat de la dernière analyse
  Future<Map<String, dynamic>?> getLatestAnalysis({
    required String plantId,
    required String analysisType,
  });

  /// Récupère l'historique des analyses
  ///
  /// [plantId] - Identifiant de la plante
  /// [analysisType] - Type d'analyse (optionnel)
  /// [startDate] - Date de début de la période (optionnel)
  /// [endDate] - Date de fin de la période (optionnel)
  /// [limit] - Nombre maximum d'enregistrements à retourner
  ///
  /// Retourne la liste des résultats d'analyses historiques
  Future<List<Map<String, dynamic>>> getAnalysisHistory({
    required String plantId,
    String? analysisType,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  });

  // ==================== GESTION DES ALERTES ====================

  /// Sauvegarde une alerte
  ///
  /// [plantId] - Identifiant de la plante
  /// [alertType] - Type d'alerte
  /// [severity] - Niveau de sévérité
  /// [message] - Message de l'alerte
  /// [data] - Données additionnelles (optionnel)
  ///
  /// Retourne l'ID de l'enregistrement Créé
  Future<String> saveAlert({
    required String plantId,
    required String alertType,
    required String severity,
    required String message,
    Map<String, dynamic>? data,
  });

  /// Récupère les alertes actives
  ///
  /// [plantId] - Identifiant de la plante (optionnel)
  /// [gardenId] - Identifiant du jardin (optionnel)
  /// [severity] - Niveau de sévérité minimum (optionnel)
  ///
  /// Retourne la liste des alertes actives
  Future<List<Map<String, dynamic>>> getActiveAlerts({
    String? plantId,
    String? gardenId,
    String? severity,
  });

  /// Marque une alerte comme résolue
  ///
  /// [alertId] - Identifiant de l'alerte
  /// [resolvedAt] - Date de résolution (optionnel, par défaut maintenant)
  /// [resolution] - Description de la résolution (optionnel)
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> resolveAlert({
    required String alertId,
    DateTime? resolvedAt,
    String? resolution,
  });

  // ==================== GESTION DES PRÉFÉRENCES UTILISATEUR ====================

  /// Sauvegarde les préférences d'un utilisateur
  ///
  /// [userId] - Identifiant de l'utilisateur
  /// [preferences] - Préférences de l'utilisateur
  ///
  /// Retourne true si la sauvegarde a réussi
  Future<bool> saveUserPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  });

  /// Récupère les préférences d'un utilisateur
  ///
  /// [userId] - Identifiant de l'utilisateur
  ///
  /// Retourne les préférences de l'utilisateur
  Future<Map<String, dynamic>?> getUserPreferences(String userId);

  /// Met à jour une préférence spécifique
  ///
  /// [userId] - Identifiant de l'utilisateur
  /// [key] - Clé de la préférence
  /// [value] - Nouvelle valeur
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> updateUserPreference({
    required String userId,
    required String key,
    required dynamic value,
  });

  // ==================== STATISTIQUES ET MÉTRIQUES ====================

  /// Récupère les statistiques de santé d'une plante
  ///
  /// [plantId] - Identifiant de la plante
  /// [period] - Période d'analyse en jours (par défaut 30)
  ///
  /// Retourne les statistiques de santé
  Future<Map<String, dynamic>> getPlantHealthStats({
    required String plantId,
    int period = 30,
  });

  /// Récupère les métriques de performance du jardin
  ///
  /// [gardenId] - Identifiant du jardin
  /// [period] - Période d'analyse en jours (par défaut 30)
  ///
  /// Retourne les métriques de performance
  Future<Map<String, dynamic>> getGardenPerformanceMetrics({
    required String gardenId,
    int period = 30,
  });

  /// Récupère les tendances d'évolution
  ///
  /// [plantId] - Identifiant de la plante
  /// [metric] - Métrique à analyser (health, growth, etc.)
  /// [period] - Période d'analyse en jours (par défaut 90)
  ///
  /// Retourne les données de tendance
  Future<List<Map<String, dynamic>>> getTrendData({
    required String plantId,
    required String metric,
    int period = 90,
  });

  // ==================== SYNCHRONISATION ET CACHE ====================

  /// Synchronise les données avec le serveur distant
  ///
  /// [forceSync] - Force la synchronisation même si les données sont récentes
  ///
  /// Retourne true si la synchronisation a réussi
  Future<bool> syncData({bool forceSync = false});

  /// Vide le cache local
  ///
  /// [olderThan] - Supprime les données plus anciennes que cette durée (optionnel)
  ///
  /// Retourne true si le nettoyage a réussi
  Future<bool> clearCache({Duration? olderThan});

  /// Vérifie la connectivité et l'état du repository
  ///
  /// Retourne true si le repository est opérationnel
  Future<bool> isHealthy();

  // ==================== RECHERCHE ET FILTRAGE ====================

  /// Récupère toutes les plantes d'un jardin spécifique
  ///
  /// [gardenId] - Identifiant du jardin
  ///
  /// Retourne la liste des plantes actives du jardin
  Future<List<PlantFreezed>> getGardenPlants(String gardenId);

  /// Recherche des plantes par critères
  ///
  /// [criteria] - Critères de recherche
  ///
  /// Retourne la liste des plantes correspondantes
  Future<List<PlantFreezed>> searchPlants(Map<String, dynamic> criteria);

  /// Filtre les recommandations par critères
  ///
  /// [criteria] - Critères de filtrage
  ///
  /// Retourne la liste des recommandations filtrées
  Future<List<Recommendation>> filterRecommendations(
      Map<String, dynamic> criteria);

  /// Recherche dans l'historique par mots-clés
  ///
  /// [query] - Requête de recherche
  /// [type] - Type d'historique (condition, weather, analysis)
  /// [limit] - Nombre maximum de résultats
  ///
  /// Retourne la liste des résultats de recherche
  Future<List<Map<String, dynamic>>> searchHistory({
    required String query,
    required String type,
    int limit = 20,
  });

  // ==================== IMPORT/EXPORT ====================

  /// Exporte les données d'une plante
  ///
  /// [plantId] - Identifiant de la plante
  /// [format] - Format d'export (json, csv)
  /// [includeHistory] - Inclure l'historique dans l'export
  ///
  /// Retourne les données exportées
  Future<Map<String, dynamic>> exportPlantData({
    required String plantId,
    String format = 'json',
    bool includeHistory = true,
  });

  /// Importe des données de plante
  ///
  /// [data] - Données à importer
  /// [format] - Format des données (json, csv)
  /// [overwrite] - Écraser les données existantes
  ///
  /// Retourne true si l'import a réussi
  Future<bool> importPlantData({
    required Map<String, dynamic> data,
    String format = 'json',
    bool overwrite = false,
  });

  /// Sauvegarde complète du jardin
  ///
  /// [gardenId] - Identifiant du jardin
  /// [includeHistory] - Inclure l'historique complet
  ///
  /// Retourne les données de sauvegarde
  Future<Map<String, dynamic>> backupGarden({
    required String gardenId,
    bool includeHistory = true,
  });

  /// Restauration complète du jardin
  ///
  /// [backupData] - Données de sauvegarde
  /// [gardenId] - Identifiant du jardin de destination
  ///
  /// Retourne true si la restauration a réussi
  Future<bool> restoreGarden({
    required Map<String, dynamic> backupData,
    required String gardenId,
  });
}

/// Exception pour les erreurs du repository
class PlantIntelligenceRepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const PlantIntelligenceRepositoryException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    final codeStr = code != null ? ' [$code]' : '';
    return 'PlantIntelligenceRepositoryException$codeStr: $message';
  }
}

/// Résultat d'opération avec métadonnées
class RepositoryResult<T> {
  final T? data;
  final bool success;
  final String? error;
  final Map<String, dynamic>? metadata;

  const RepositoryResult({
    this.data,
    required this.success,
    this.error,
    this.metadata,
  });

  factory RepositoryResult.success(T data, {Map<String, dynamic>? metadata}) {
    return RepositoryResult(
      data: data,
      success: true,
      metadata: metadata,
    );
  }

  factory RepositoryResult.failure(String error,
      {Map<String, dynamic>? metadata}) {
    return RepositoryResult(
      success: false,
      error: error,
      metadata: metadata,
    );
  }
}

/// Configuration du repository
class RepositoryConfig {
  final String databasePath;
  final bool enableCache;
  final Duration cacheExpiration;
  final bool enableSync;
  final String? syncEndpoint;
  final Map<String, dynamic> customSettings;

  const RepositoryConfig({
    required this.databasePath,
    this.enableCache = true,
    this.cacheExpiration = const Duration(hours: 1),
    this.enableSync = false,
    this.syncEndpoint,
    this.customSettings = const {},
  });
}


