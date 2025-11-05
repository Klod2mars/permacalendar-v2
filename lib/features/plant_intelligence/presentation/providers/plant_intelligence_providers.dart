import 'package:riverpod/riverpod.dart';
import '../../domain/repositories/plant_intelligence_repository.dart';
import '../../domain/entities/intelligence_report.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/comprehensive_garden_analysis.dart';
import '../../../../core/services/weather_impact_analyzer.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';

// ==================== PROVIDERS DE BASE ====================
// ✅ REFACTORÉ - Prompt 8 : Utilisation des modules DI
//
// Les providers de base sont maintenant définis dans les modules DI.
// Ces providers ci-dessous ne sont que des alias pour compatibilité.
//
// **Migration vers les modules :**
// - IntelligenceModule : Contient tous les providers Intelligence Végétale
// - GardenModule : Contient tous les providers Jardin
//
// **Nouveaux usages recommandés :**
// ```dart
// // ❌ Ancien (déprécié)
// final repo = ref.read(plantIntelligenceRepositoryImplProvider);
//
// // ✅ Nouveau
// final repo = ref.read(IntelligenceModule.repositoryImplProvider);
// ```

import '../../../../core/di/intelligence_module.dart';
import '../../../../core/di/garden_module.dart';

/// Provider pour la source de données locale
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `IntelligenceModule.localDataSourceProvider` à la place.
@Deprecated(
    'Utilisez IntelligenceModule.localDataSourceProvider à la place. Sera supprimé dans la v3.0')
final plantIntelligenceLocalDataSourceProvider =
    IntelligenceModule.localDataSourceProvider;

/// Provider pour le Garden Aggregation Hub (Hub Central Unifié)
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `GardenModule.aggregationHubProvider` à la place.
@Deprecated(
    'Utilisez GardenModule.aggregationHubProvider à la place. Sera supprimé dans la v3.0')
final gardenAggregationHubProvider = GardenModule.aggregationHubProvider;

/// Provider pour l'implémentation concrète du repository
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `IntelligenceModule.repositoryImplProvider` à la place.
@Deprecated(
    'Utilisez IntelligenceModule.repositoryImplProvider à la place. Sera supprimé dans la v3.0')
final plantIntelligenceRepositoryImplProvider =
    IntelligenceModule.repositoryImplProvider;

/// Provider pour le repository d'intelligence des plantes (interface complète)
///
/// ⚠️ **DÉPRÉCIÉ** - Utilisez les interfaces spécialisées à la place :
/// - [plantConditionRepositoryProvider]
/// - [weatherRepositoryProvider]
/// - [gardenContextRepositoryProvider]
/// - [recommendationRepositoryProvider]
/// - [analyticsRepositoryProvider]
@Deprecated(
    'Utilisez les interfaces spécialisées à la place. Sera supprimé dans la v3.0')
final plantIntelligenceRepositoryProvider =
    Provider<PlantIntelligenceRepository>((ref) {
  return ref.read(plantIntelligenceRepositoryImplProvider);
});

// ==================== PROVIDERS D'INTERFACES SPÉCIALISÉES ====================
// ✅ REFACTORÉ - Prompt 8 : Utilisation des modules DI
//
// Les providers ci-dessous sont maintenant des alias vers IntelligenceModule.
// Ils sont conservés pour compatibilité avec le code existant.

/// Provider pour l'interface de gestion des conditions de plantes
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `IntelligenceModule.conditionRepositoryProvider` à la place.
@Deprecated(
    'Utilisez IntelligenceModule.conditionRepositoryProvider à la place. Sera supprimé dans la v3.0')
final plantConditionRepositoryProvider =
    IntelligenceModule.conditionRepositoryProvider;

/// Provider pour l'interface de gestion des conditions météorologiques
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `IntelligenceModule.weatherRepositoryProvider` à la place.
@Deprecated(
    'Utilisez IntelligenceModule.weatherRepositoryProvider à la place. Sera supprimé dans la v3.0')
final weatherRepositoryProvider = IntelligenceModule.weatherRepositoryProvider;

/// Provider pour l'interface de gestion du contexte jardin
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `IntelligenceModule.gardenContextRepositoryProvider` à la place.
@Deprecated(
    'Utilisez IntelligenceModule.gardenContextRepositoryProvider à la place. Sera supprimé dans la v3.0')
final gardenContextRepositoryProvider =
    IntelligenceModule.gardenContextRepositoryProvider;

/// Provider pour l'interface de gestion des recommandations
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `IntelligenceModule.recommendationRepositoryProvider` à la place.
@Deprecated(
    'Utilisez IntelligenceModule.recommendationRepositoryProvider à la place. Sera supprimé dans la v3.0')
final recommendationRepositoryProvider =
    IntelligenceModule.recommendationRepositoryProvider;

/// Provider pour l'interface d'analytics et statistiques
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `IntelligenceModule.analyticsRepositoryProvider` à la place.
@Deprecated(
    'Utilisez IntelligenceModule.analyticsRepositoryProvider à la place. Sera supprimé dans la v3.0')
final analyticsRepositoryProvider =
    IntelligenceModule.analyticsRepositoryProvider;

/// Provider pour le use case d'analyse des conditions de plantes
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `IntelligenceModule.analyzeConditionsUsecaseProvider` à la place.
@Deprecated(
    'Utilisez IntelligenceModule.analyzeConditionsUsecaseProvider à la place. Sera supprimé dans la v3.0')
final analyzePlantConditionsUsecaseProvider =
    IntelligenceModule.analyzeConditionsUsecaseProvider;

/// Provider pour le use case d'évaluation du timing de plantation
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `IntelligenceModule.evaluateTimingUsecaseProvider` à la place.
@Deprecated(
    'Utilisez IntelligenceModule.evaluateTimingUsecaseProvider à la place. Sera supprimé dans la v3.0')
final evaluatePlantingTimingUsecaseProvider =
    IntelligenceModule.evaluateTimingUsecaseProvider;

/// Provider pour le use case de génération de recommandations
///
/// **⚠️ DÉPRÉCIÉ - Prompt 8 :**
/// Utilisez `IntelligenceModule.generateRecommendationsUsecaseProvider` à la place.
@Deprecated(
    'Utilisez IntelligenceModule.generateRecommendationsUsecaseProvider à la place. Sera supprimé dans la v3.0')
final generateRecommendationsUsecaseProvider =
    IntelligenceModule.generateRecommendationsUsecaseProvider;

// ==================== ORCHESTRATOR ====================

/// Provider pour l'orchestrateur domain
///
/// **✅ REFACTORÉ - Prompt 8 : Utilisation des modules DI**
/// L'orchestrateur est maintenant défini dans IntelligenceModule.
/// Ce provider n'est qu'un alias pour compatibilité.
///
/// **Architecture :**
/// ```
/// IntelligenceModule.orchestratorProvider
///   ├─→ 5 interfaces spécialisées (ISP - Prompt 4)
///   └─→ 3 UseCases
/// ```
///
/// **Usage recommandé :**
/// ```dart
/// // ❌ Ancien (déprécié)
/// final orchestrator = ref.read(plantIntelligenceOrchestratorProvider);
///
/// // ✅ Nouveau
/// final orchestrator = ref.read(IntelligenceModule.orchestratorProvider);
/// // ou
/// final orchestrator = ref.intelligenceOrchestrator; // Extension
/// ```
@Deprecated(
    'Utilisez IntelligenceModule.orchestratorProvider à la place. Sera supprimé dans la v3.0')
final plantIntelligenceOrchestratorProvider =
    IntelligenceModule.orchestratorProvider;

/// Provider pour générer un rapport complet d'intelligence pour une plante
///
/// Utilise l'orchestrateur domain pour coordonner les analyses
final generateIntelligenceReportProvider = FutureProvider.family<
    PlantIntelligenceReport,
    ({String plantId, String gardenId})>((ref, params) async {
  final orchestrator = ref.read(plantIntelligenceOrchestratorProvider);
  return orchestrator.generateIntelligenceReport(
    plantId: params.plantId,
    gardenId: params.gardenId,
  );
});

/// Provider pour générer un rapport intelligence pour tout le jardin
///
/// Analyse toutes les plantes actives du jardin
final generateGardenIntelligenceReportProvider =
    FutureProvider.family<List<PlantIntelligenceReport>, String>(
        (ref, gardenId) async {
  final orchestrator = ref.read(plantIntelligenceOrchestratorProvider);
  return orchestrator.generateGardenIntelligenceReport(gardenId: gardenId);
});

/// Provider pour analyser uniquement les conditions (sans rapport complet)
///
/// Utile pour des analyses rapides
final analyzePlantConditionsOnlyProvider = FutureProvider.family<
    PlantAnalysisResult,
    ({String plantId, String gardenId})>((ref, params) async {
  final orchestrator = ref.read(plantIntelligenceOrchestratorProvider);
  return orchestrator.analyzePlantConditions(
    plantId: params.plantId,
    gardenId: params.gardenId,
  );
});

/// Provider pour générer une analyse complète du jardin avec lutte biologique
///
/// ✅ NOUVEAU - Phase 1 : Connexion Fonctionnelle
/// Analyse complète incluant :
/// - Rapports d'intelligence des plantes
/// - Analyse des menaces ravageurs
/// - Recommandations de lutte biologique
/// - Score de santé global du jardin
///
/// Utilise l'orchestrateur domain pour coordonner les 5 UseCases
final generateComprehensiveGardenAnalysisProvider =
    FutureProvider.family<ComprehensiveGardenAnalysis, String>(
        (ref, gardenId) async {
  final orchestrator = ref.read(plantIntelligenceOrchestratorProvider);
  return orchestrator.analyzeGardenWithBioControl(gardenId: gardenId);
});

/// Provider pour l'analyseur d'impact météorologique
final weatherImpactAnalyzerProvider = Provider<WeatherImpactAnalyzer>((ref) {
  return const WeatherImpactAnalyzer();
});

// Provider PlantIntelligenceEngine supprimé (v2.1.0)
// Utilisez plantIntelligenceOrchestratorProvider à la place

// ==================== PROVIDERS D'ÉTAT ====================

/// Notifier pour l'état de chargement du moteur d'intelligence
class PlantIntelligenceLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;
}

/// Provider pour l'état de chargement du moteur d'intelligence
final plantIntelligenceLoadingProvider =
    NotifierProvider<PlantIntelligenceLoadingNotifier, bool>(
        PlantIntelligenceLoadingNotifier.new);

/// Notifier pour les erreurs du moteur d'intelligence
class PlantIntelligenceErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;
}

/// Provider pour les erreurs du moteur d'intelligence
final plantIntelligenceErrorProvider =
    NotifierProvider<PlantIntelligenceErrorNotifier, String?>(
        PlantIntelligenceErrorNotifier.new);

/// Provider pour l'état de santé du repository
final plantIntelligenceHealthProvider = FutureProvider<bool>((ref) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.isHealthy();
});

// ==================== PROVIDERS DE DONNÉES ====================

/// Provider pour les conditions d'une plante spécifique
final plantConditionProvider =
    FutureProvider.family<PlantCondition?, String>((ref, plantId) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getCurrentPlantCondition(plantId);
});

/// Provider pour l'historique des conditions d'une plante
final plantConditionHistoryProvider =
    FutureProvider.family<List<PlantCondition>, PlantConditionHistoryParams>(
        (ref, params) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getPlantConditionHistory(
    plantId: params.plantId,
    startDate: params.startDate,
    endDate: params.endDate,
    limit: params.limit,
  );
});

/// Provider pour les recommandations actives d'une plante
final plantRecommendationsProvider =
    FutureProvider.family<List<Recommendation>, String>((ref, plantId) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getActiveRecommendations(plantId: plantId);
});

/// Provider pour les recommandations par priorité
final plantRecommendationsByPriorityProvider = FutureProvider.family<
    List<Recommendation>,
    PlantRecommendationsByPriorityParams>((ref, params) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getRecommendationsByPriority(
    plantId: params.plantId,
    priority: params.priority,
  );
});

/// Provider pour les conditions météorologiques actuelles
final currentWeatherProvider =
    FutureProvider.family<WeatherCondition?, String>((ref, gardenId) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getCurrentWeatherCondition(gardenId);
});

/// Provider pour l'historique météorologique
final weatherHistoryProvider =
    FutureProvider.family<List<WeatherCondition>, WeatherHistoryParams>(
        (ref, params) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getWeatherHistory(
    gardenId: params.gardenId,
    startDate: params.startDate,
    endDate: params.endDate,
    limit: params.limit,
  );
});

/// Provider pour le contexte d'un jardin
final gardenContextProvider =
    FutureProvider.family<GardenContext?, String>((ref, gardenId) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getGardenContext(gardenId);
});

/// Provider pour les jardins d'un utilisateur
final userGardensProvider =
    FutureProvider.family<List<GardenContext>, String>((ref, userId) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getUserGardens(userId);
});

/// Provider pour les alertes actives
final activeAlertsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, ActiveAlertsParams>(
        (ref, params) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getActiveAlerts(
    plantId: params.plantId,
    gardenId: params.gardenId,
    severity: params.severity,
  );
});

/// Provider pour les statistiques de santé d'une plante
final plantHealthStatsProvider =
    FutureProvider.family<Map<String, dynamic>, PlantHealthStatsParams>(
        (ref, params) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getPlantHealthStats(
    plantId: params.plantId,
    period: params.period,
  );
});

/// Provider pour les métriques de performance d'un jardin
final gardenPerformanceMetricsProvider =
    FutureProvider.family<Map<String, dynamic>, GardenPerformanceMetricsParams>(
        (ref, params) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getGardenPerformanceMetrics(
    gardenId: params.gardenId,
    period: params.period,
  );
});

/// Provider pour les données de tendance
final trendDataProvider =
    FutureProvider.family<List<Map<String, dynamic>>, TrendDataParams>(
        (ref, params) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getTrendData(
    plantId: params.plantId,
    metric: params.metric,
    period: params.period,
  );
});

/// Provider pour les préférences utilisateur
final userPreferencesProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
  final repository = ref.read(plantIntelligenceRepositoryProvider);
  return await repository.getUserPreferences(userId);
});

// ==================== PROVIDERS D'ACTIONS ====================

/// Provider pour l'analyse d'une plante
/// [params] Contient plantId et gardenId
final analyzePlantProvider =
    FutureProvider.family<PlantAnalysisResult, AnalyzePlantSimpleParams>(
        (ref, params) async {
  final orchestrator = ref.read(plantIntelligenceOrchestratorProvider);
  return await orchestrator.analyzePlantConditions(
    plantId: params.plantId,
    gardenId: params.gardenId,
  );
});

/// Provider pour la génération de recommandations pour une plante
/// [params] Contient plantId et gardenId
final generatePlantRecommendationsProvider =
    FutureProvider.family<List<Recommendation>, AnalyzePlantSimpleParams>(
        (ref, params) async {
  final orchestrator = ref.read(plantIntelligenceOrchestratorProvider);

  // Générer le rapport complet
  final report = await orchestrator.generateIntelligenceReport(
    plantId: params.plantId,
    gardenId: params.gardenId,
  );

  return report.recommendations;
});

/// Provider pour l'évaluation du timing de plantation
/// [params] Contient plantId et gardenId
final evaluatePlantingTimingProvider =
    FutureProvider.family<PlantingTimingEvaluation, AnalyzePlantSimpleParams>(
        (ref, params) async {
  final orchestrator = ref.read(plantIntelligenceOrchestratorProvider);

  // Générer le rapport complet et extraire l'évaluation du timing
  final report = await orchestrator.generateIntelligenceReport(
    plantId: params.plantId,
    gardenId: params.gardenId,
  );

  return report.plantingTiming ??
      const PlantingTimingEvaluation(
        isOptimalTime: false,
        timingScore: 0,
        reason: 'Timing non disponible',
        favorableFactors: [],
        unfavorableFactors: [],
        risks: [],
      );
});

// ==================== PROVIDERS DE NOTIFICATIONS ====================

/// Provider pour les notifications d'alertes
final alertNotificationsProvider =
    NotifierProvider<AlertNotificationsNotifier, List<Map<String, dynamic>>>(
        AlertNotificationsNotifier.new);

/// Provider pour les notifications de recommandations
final recommendationNotificationsProvider =
    NotifierProvider<RecommendationNotificationsNotifier, List<Recommendation>>(
        RecommendationNotificationsNotifier.new);

// ==================== CLASSES DE PARAMÈTRES ====================

/// Paramètres pour l'historique des conditions de plantes
class PlantConditionHistoryParams {
  final String plantId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int limit;

  const PlantConditionHistoryParams({
    required this.plantId,
    this.startDate,
    this.endDate,
    this.limit = 100,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantConditionHistoryParams &&
          runtimeType == other.runtimeType &&
          plantId == other.plantId &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          limit == other.limit;

  @override
  int get hashCode =>
      plantId.hashCode ^ startDate.hashCode ^ endDate.hashCode ^ limit.hashCode;
}

/// Paramètres pour les recommandations par priorité
class PlantRecommendationsByPriorityParams {
  final String plantId;
  final String priority;

  const PlantRecommendationsByPriorityParams({
    required this.plantId,
    required this.priority,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantRecommendationsByPriorityParams &&
          runtimeType == other.runtimeType &&
          plantId == other.plantId &&
          priority == other.priority;

  @override
  int get hashCode => plantId.hashCode ^ priority.hashCode;
}

/// Paramètres pour l'historique météorologique
class WeatherHistoryParams {
  final String gardenId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int limit;

  const WeatherHistoryParams({
    required this.gardenId,
    this.startDate,
    this.endDate,
    this.limit = 100,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherHistoryParams &&
          runtimeType == other.runtimeType &&
          gardenId == other.gardenId &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          limit == other.limit;

  @override
  int get hashCode =>
      gardenId.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      limit.hashCode;
}

/// Paramètres pour les alertes actives
class ActiveAlertsParams {
  final String? plantId;
  final String? gardenId;
  final String? severity;

  const ActiveAlertsParams({
    this.plantId,
    this.gardenId,
    this.severity,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveAlertsParams &&
          runtimeType == other.runtimeType &&
          plantId == other.plantId &&
          gardenId == other.gardenId &&
          severity == other.severity;

  @override
  int get hashCode => plantId.hashCode ^ gardenId.hashCode ^ severity.hashCode;
}

/// Paramètres pour les statistiques de santé d'une plante
class PlantHealthStatsParams {
  final String plantId;
  final int period;

  const PlantHealthStatsParams({
    required this.plantId,
    this.period = 30,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantHealthStatsParams &&
          runtimeType == other.runtimeType &&
          plantId == other.plantId &&
          period == other.period;

  @override
  int get hashCode => plantId.hashCode ^ period.hashCode;
}

/// Paramètres pour les métriques de performance d'un jardin
class GardenPerformanceMetricsParams {
  final String gardenId;
  final int period;

  const GardenPerformanceMetricsParams({
    required this.gardenId,
    this.period = 30,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GardenPerformanceMetricsParams &&
          runtimeType == other.runtimeType &&
          gardenId == other.gardenId &&
          period == other.period;

  @override
  int get hashCode => gardenId.hashCode ^ period.hashCode;
}

/// Paramètres pour les données de tendance
class TrendDataParams {
  final String plantId;
  final String metric;
  final int period;

  const TrendDataParams({
    required this.plantId,
    required this.metric,
    this.period = 90,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendDataParams &&
          runtimeType == other.runtimeType &&
          plantId == other.plantId &&
          metric == other.metric &&
          period == other.period;

  @override
  int get hashCode => plantId.hashCode ^ metric.hashCode ^ period.hashCode;
}

/// Paramètres simplifiés pour l'analyse d'une plante (avec IDs)
class AnalyzePlantSimpleParams {
  final String plantId;
  final String gardenId;
  final bool forceRefresh;

  const AnalyzePlantSimpleParams({
    required this.plantId,
    required this.gardenId,
    this.forceRefresh = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyzePlantSimpleParams &&
          runtimeType == other.runtimeType &&
          plantId == other.plantId &&
          gardenId == other.gardenId &&
          forceRefresh == other.forceRefresh;

  @override
  int get hashCode =>
      plantId.hashCode ^ gardenId.hashCode ^ forceRefresh.hashCode;
}

// ==================== NOTIFIERS ====================

/// Notifier pour les notifications d'alertes
class AlertNotificationsNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() => [];

  /// Ajouter une nouvelle alerte
  void addAlert(Map<String, dynamic> alert) {
    state = [...state, alert];
  }

  /// Supprimer une alerte
  void removeAlert(String alertId) {
    state = state.where((alert) => alert['id'] != alertId).toList();
  }

  /// Marquer une alerte comme lue
  void markAsRead(String alertId) {
    state = state.map((alert) {
      if (alert['id'] == alertId) {
        return {...alert, 'read': true};
      }
      return alert;
    }).toList();
  }

  /// Vider toutes les alertes
  void clearAll() {
    state = [];
  }
}

/// Notifier pour les notifications de recommandations
class RecommendationNotificationsNotifier
    extends Notifier<List<Recommendation>> {
  @override
  List<Recommendation> build() => [];

  /// Ajouter une nouvelle recommandation
  void addRecommendation(Recommendation recommendation) {
    state = [...state, recommendation];
  }

  /// Supprimer une recommandation
  void removeRecommendation(String recommendationId) {
    state = state.where((rec) => rec.id != recommendationId).toList();
  }

  /// Marquer une recommandation comme appliquée
  void markAsApplied(String recommendationId) {
    // Cette méthode pourrait déclencher une mise à jour dans le repository
    // Pour l'instant, on supprime simplement de la liste des notifications
    removeRecommendation(recommendationId);
  }

  /// Vider toutes les recommandations
  void clearAll() {
    state = [];
  }
}

// ==================== PROVIDERS DE CONFIGURATION ====================

/// Provider pour la configuration du repository
final repositoryConfigProvider = Provider<RepositoryConfig>((ref) {
  return const RepositoryConfig(
    databasePath: 'plant_intelligence_db',
    enableCache: true,
    cacheExpiration: Duration(hours: 1),
    enableSync: false,
  );
});

/// Provider pour les paramètres de l'application
final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, Map<String, dynamic>>(
        AppSettingsNotifier.new);

/// Notifier pour les paramètres de l'application
class AppSettingsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => {
        'autoAnalyze': true,
        'notificationsEnabled': true,
        'syncInterval': 30, // minutes
        'cacheSize': 100, // MB
        'debugMode': false,
      };

  /// Mettre à jour un paramètre
  void updateSetting(String key, dynamic value) {
    state = {...state, key: value};
  }

  /// Réinitialiser les paramètres par défaut
  void resetToDefaults() {
    state = {
      'autoAnalyze': true,
      'notificationsEnabled': true,
      'syncInterval': 30,
      'cacheSize': 100,
      'debugMode': false,
    };
  }
}
