import 'package:riverpod/riverpod.dart';
import '../services/activity_tracker_v3.dart';
import '../models/activity_v3.dart';
import '../../features/garden/providers/garden_provider.dart';

/// Provider pour le service ActivityTrackerV3
final activityTrackerV3Provider = Provider<ActivityTrackerV3>((ref) {
  return ActivityTrackerV3();
});

/// Provider pour les activités récentes avec mise à jour en temps réel
final recentActivitiesProvider =
    AsyncNotifierProvider<RecentActivitiesNotifier, List<ActivityV3>>(() {
  return RecentActivitiesNotifier();
});

/// Provider pour les activités importantes avec mise à jour en temps réel
final importantActivitiesProvider =
    AsyncNotifierProvider<ImportantActivitiesNotifier, List<ActivityV3>>(() {
  return ImportantActivitiesNotifier();
});

/// Notifier pour les activités récentes avec refresh automatique
class RecentActivitiesNotifier extends AsyncNotifier<List<ActivityV3>> {
  @override
  Future<List<ActivityV3>> build() async {
    final tracker = ref.read(activityTrackerV3Provider);
    
    // Watch garden selection for context-aware filtering
    final gardenState = ref.watch(gardenProvider);
    
    if (gardenState.selectedGarden != null) {
      return await tracker.getActivitiesByGarden(
        gardenState.selectedGarden!.id, 
        limit: 20
      );
    } else {
      return await tracker.getRecentActivities(limit: 20);
    }
  }

  /// Force le refresh des activités
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final tracker = ref.read(activityTrackerV3Provider);
    state = AsyncValue.data(await tracker.getRecentActivities(limit: 20));
  }

  /// Ajoute une nouvelle activité et refresh
  Future<void> addActivity(ActivityV3 activity) async {
    await refresh();
  }
}

/// Notifier pour les activités importantes avec refresh automatique
class ImportantActivitiesNotifier extends AsyncNotifier<List<ActivityV3>> {
  @override
  Future<List<ActivityV3>> build() async {
    final tracker = ref.read(activityTrackerV3Provider);
    final activities = await tracker.getRecentActivities(
      limit: 10,
      minPriority: ActivityPriority.important,
    );
    return activities;
  }

  /// Force le refresh des activités
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final tracker = ref.read(activityTrackerV3Provider);
    state = AsyncValue.data(await tracker.getRecentActivities(
      limit: 10,
      minPriority: ActivityPriority.important,
    ));
  }
}

/// Provider pour les activités par type
final activitiesByTypeProvider =
    FutureProvider.family<List<ActivityV3>, String>((ref, type) async {
  final tracker = ref.read(activityTrackerV3Provider);
  return await tracker.getActivitiesByType(type);
});

/// Provider pour le nombre d'activités
final activityCountProvider = FutureProvider<int>((ref) async {
  final tracker = ref.read(activityTrackerV3Provider);
  return tracker.activityCount;
});

/// Provider pour vérifier l'état d'initialisation
final activityTrackerInitializedProvider = Provider<bool>((ref) {
  final tracker = ref.read(activityTrackerV3Provider);
  return tracker.isInitialized;
});
