import 'package:riverpod/riverpod.dart';

import '../models/activity_v3.dart';
import '../services/activity_tracker_v3.dart';
import 'garden_aggregation_providers.dart';

/// Provider pour le service ActivityTrackerV3
///
/// Usage :
/// ```dart
/// final tracker = ref.read(activityTrackerV3Provider);
/// await tracker.recordActivity(ActivityV3(
///   id: 'activity-id',
///   type: 'system',
///   description: 'Initialisation',
///   timestamp: DateTime.now(),
/// ));
/// ```
final activityTrackerV3Provider =
    Provider.autoDispose<ActivityTrackerV3>((ref) {
  final hub = ref.read(gardenAggregationHubProvider);
  final tracker = ActivityTrackerV3(hub: hub);

  ref.onDispose(tracker.close);
  return tracker;
});

/// Provider pour les activités récentes avec mise à jour en temps réel
final recentActivitiesProvider =
    FutureProvider.autoDispose<List<ActivityV3>>((ref) async {
  final tracker = ref.read(activityTrackerV3Provider);
  return tracker.getRecentActivities(limit: 20);
});

/// Provider pour les activités importantes avec mise à jour en temps réel
final importantActivitiesProvider =
    FutureProvider.autoDispose<List<ActivityV3>>((ref) async {
  final tracker = ref.read(activityTrackerV3Provider);
  return tracker.getRecentActivities(
    limit: 10,
    minPriority: ActivityPriority.important,
  );
});

/// Provider pour les activités par type
final activitiesByTypeProvider =
    FutureProvider.family<List<ActivityV3>, String>((ref, type) async {
  final tracker = ref.watch(activityTrackerV3Provider);
  return await tracker.getActivitiesByType(type);
});

