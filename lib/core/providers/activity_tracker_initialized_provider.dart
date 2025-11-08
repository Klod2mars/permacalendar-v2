import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import '../services/activity_tracker_v3.dart';
import 'activity_tracker_v3_provider.dart';

/// ActivityTrackerInitializedProvider
/// ----------------------------------
/// Vérifie que le moteur ActivityTrackerV3 est prêt.
/// - Auto-disposé.
/// - Compatible Riverpod 3.
/// - Utilisé au démarrage pour synchroniser les écrans d’activités.
final activityTrackerInitializedProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  try {
    final ActivityTrackerV3 tracker = ref.read(activityTrackerV3Provider);
    await tracker.ensureInitialized();
    return tracker.isInitialized;
  } catch (e, st) {
    debugPrint('ActivityTrackerInitializedProvider error: $e\n$st');
    return false;
  }
});

