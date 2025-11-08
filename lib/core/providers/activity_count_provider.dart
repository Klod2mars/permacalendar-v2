import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import 'activity_tracker_v3_provider.dart';

/// ActivityCountProvider
/// ----------------------
/// Fournit le nombre d’activités récentes d’un jardin.
/// Utilisé pour les tuiles statistiques et l’écran d’accueil.
/// - Auto-disposé.
/// - Compatible Riverpod 3.
/// - Repose sur ActivityTrackerV3.
final activityCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final tracker = ref.read(activityTrackerV3Provider);

  try {
    final activities = await tracker.getRecentActivities();
    final cutoffDate = DateTime.now().subtract(const Duration(days: 7));

    return activities
        .where((activity) => activity.timestamp.isAfter(cutoffDate))
        .length;
  } catch (error, stackTrace) {
    debugPrint('ActivityCountProvider error: $error');
    debugPrint('$stackTrace');
    return 0;
  }
});

