import 'package:riverpod/riverpod.dart';
import '../services/aggregation/garden_aggregation_hub.dart';
import '../services/aggregation/legacy_data_adapter.dart';
import '../services/aggregation/modern_data_adapter.dart';
import '../services/aggregation/intelligence_data_adapter.dart';
import '../services/aggregation/data_consistency_manager.dart';
import '../services/aggregation/migration_progress_tracker.dart';
import '../di/intelligence_module.dart';
import '../models/unified_garden_context.dart';

/// Providers pour le Garden Aggregation Hub
///
/// Ces providers permettent d'injecter le hub central et ses composants
/// dans toute l'application via Riverpod.

// ==================== ADAPTATEURS ====================

/// Provider pour l'adaptateur Legacy
final legacyDataAdapterProvider = Provider<LegacyDataAdapter>((ref) {
  return LegacyDataAdapter();
});

/// Provider pour l'adaptateur Moderne
final modernDataAdapterProvider = Provider<ModernDataAdapter>((ref) {
  return ModernDataAdapter();
});

/// Provider pour l'adaptateur Intelligence
/// Dépend du PlantIntelligenceRepository
final intelligenceDataAdapterProvider =
    Provider<IntelligenceDataAdapter>((ref) {
  final intelligenceRepository = ref.read(IntelligenceModule.repositoryImplProvider);
  return IntelligenceDataAdapter(
      intelligenceRepository: intelligenceRepository);
});

// ==================== HUB CENTRAL ====================

/// Provider pour le Garden Aggregation Hub
///
/// C'est le provider principal à utiliser pour accéder aux données jardins
/// de manière unifiée depuis n'importe où dans l'application.
final gardenAggregationHubProvider = Provider<GardenAggregationHub>((ref) {
  final legacyAdapter = ref.read(legacyDataAdapterProvider);
  final modernAdapter = ref.read(modernDataAdapterProvider);
  final intelligenceAdapter = ref.read(intelligenceDataAdapterProvider);

  return GardenAggregationHub(
    legacyAdapter: legacyAdapter,
    modernAdapter: modernAdapter,
    intelligenceAdapter: intelligenceAdapter,
  );
});

// ==================== COMPOSANTS DE SUPPORT ====================

/// Provider pour le Data Consistency Manager
final dataConsistencyManagerProvider = Provider<DataConsistencyManager>((ref) {
  return DataConsistencyManager();
});

/// Provider pour le Migration Progress Tracker
final migrationProgressTrackerProvider =
    Provider<MigrationProgressTracker>((ref) {
  return MigrationProgressTracker();
});

// ==================== PROVIDERS DE DONNÉES ====================

/// Provider pour récupérer le contexte unifié d'un jardin
///
/// Utilisation :
/// ```dart
/// final context = ref.watch(unifiedGardenContextProvider(gardenId));
/// context.when(
///   data: (context) => Text('Jardin: ${context.name}'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Erreur: $error'),
/// );
/// ```
final unifiedGardenContextProvider =
    FutureProvider.family<UnifiedGardenContext, String>(
  (ref, gardenId) async {
    final hub = ref.read(gardenAggregationHubProvider);
    return await hub.getUnifiedContext(gardenId);
  },
);

/// Provider pour récupérer les plantes actives d'un jardin
final gardenActivePlantsProvider =
    FutureProvider.family<List<UnifiedPlantData>, String>(
  (ref, gardenId) async {
    final hub = ref.read(gardenAggregationHubProvider);
    return await hub.getActivePlants(gardenId);
  },
);

/// Provider pour récupérer les plantes historiques d'un jardin
final gardenHistoricalPlantsProvider =
    FutureProvider.family<List<UnifiedPlantData>, String>(
  (ref, gardenId) async {
    final hub = ref.read(gardenAggregationHubProvider);
    return await hub.getHistoricalPlants(gardenId);
  },
);

/// Provider pour récupérer les statistiques d'un jardin
final gardenStatsProvider = FutureProvider.family<UnifiedGardenStats, String>(
  (ref, gardenId) async {
    final hub = ref.read(gardenAggregationHubProvider);
    return await hub.getGardenStats(gardenId);
  },
);

/// Provider pour récupérer une plante par son ID
final plantByIdProvider = FutureProvider.family<UnifiedPlantData?, String>(
  (ref, plantId) async {
    final hub = ref.read(gardenAggregationHubProvider);
    return await hub.getPlantById(plantId);
  },
);

/// Provider pour récupérer les activités récentes d'un jardin
final gardenActivitiesProvider =
    FutureProvider.family<List<UnifiedActivityHistory>, String>(
  (ref, gardenId) async {
    final hub = ref.read(gardenAggregationHubProvider);
    return await hub.getRecentActivities(gardenId, limit: 20);
  },
);

// ==================== HEALTH CHECK ====================

/// Provider pour vérifier la santé du hub
final hubHealthCheckProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final hub = ref.read(gardenAggregationHubProvider);
  return await hub.healthCheck();
});

// ==================== CONSISTENCY CHECK ====================

/// Provider pour vérifier la cohérence des données d'un jardin
final gardenConsistencyCheckProvider =
    FutureProvider.family<ConsistencyReport, String>(
  (ref, gardenId) async {
    final manager = ref.read(dataConsistencyManagerProvider);

    // Récupérer tous les adaptateurs
    final adapters = [
      ref.read(legacyDataAdapterProvider),
      ref.read(modernDataAdapterProvider),
      ref.read(intelligenceDataAdapterProvider),
    ];

    return await manager.checkGardenConsistency(
      gardenId: gardenId,
      adapters: adapters,
    );
  },
);

// ==================== ACTIONS ====================

/// Provider pour invalider le cache d'un jardin
///
/// Utilisation :
/// ```dart
/// ref.read(invalidateGardenCacheProvider(gardenId));
/// ```
final invalidateGardenCacheProvider =
    Provider.family<void, String>((ref, gardenId) {
  final hub = ref.read(gardenAggregationHubProvider);
  hub.invalidateCache(gardenId);

  // Invalider aussi les providers Riverpod associés
  ref.invalidate(unifiedGardenContextProvider(gardenId));
  ref.invalidate(gardenActivePlantsProvider(gardenId));
  ref.invalidate(gardenHistoricalPlantsProvider(gardenId));
  ref.invalidate(gardenStatsProvider(gardenId));
  ref.invalidate(gardenActivitiesProvider(gardenId));
});

/// Provider pour effacer tout le cache du hub
final clearHubCacheProvider = Provider<void>((ref) {
  final hub = ref.read(gardenAggregationHubProvider);
  hub.clearCache();

  // Invalider tous les providers de données
  ref.invalidateSelf();
});
