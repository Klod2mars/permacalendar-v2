// lib/core/providers/garden_awakening_registry.dart
//
// GardenAwakeningRegistry
// - Registre simple (in-memory) pour garder la référence GlobalKey des
//   InsectAwakeningWidget par gardenId.
// - Fournit des helpers synchrone pour récupérer l'état, forcer/stopper la
//   lueur et arrêter toutes les lueurs sauf une.
// - Expose un Provider (gardenAwakeningRegistryProvider) pour être lu depuis
//   les hotspots / contrôleurs.
//
// Usage:
//   ref.read(gardenAwakeningRegistryProvider).register(gardenId, key);
//   ref.read(gardenAwakeningRegistryProvider).unregister(gardenId);
//   final state = ref.read(gardenAwakeningRegistryProvider).stateFor(gardenId);
//   state?.forcePersistent();
//   ref.read(gardenAwakeningRegistryProvider).stopAllExcept(gardenId);

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Ajuste le chemin si nécessaire — InsectAwakeningWidget doit être importable ici.
import 'package:permacalendar/shared/widgets/animations/insect_awakening_widget.dart';

class GardenAwakeningRegistry {
  final Map<String, GlobalKey<InsectAwakeningWidgetState>> _map = {};

  GardenAwakeningRegistry();

  /// Register a GlobalKey for a given gardenId (overwrites existing).
  void register(String gardenId, GlobalKey<InsectAwakeningWidgetState> key) {
    _map[gardenId] = key;
    if (kDebugMode) {
      debugPrint('[Registry] register: $gardenId -> $key');
    }
  }

  /// Unregister the gardenId (safe if not present).
  void unregister(String gardenId) {
    final removed = _map.remove(gardenId);
    if (kDebugMode) {
      debugPrint('[Registry] unregister: $gardenId removed=${removed != null}');
    }
  }

  /// Return the InsectAwakeningWidgetState for a gardenId, or null.
  InsectAwakeningWidgetState? stateFor(String gardenId) {
    final key = _map[gardenId];
    if (key == null) return null;
    return key.currentState;
  }

  /// Attempt to stop persistent state for gardenId (defensive).
  void stopPersistentFor(String gardenId) {
    final st = stateFor(gardenId);
    if (st != null) {
      try {
        st.stopPersistent();
        if (kDebugMode) debugPrint('[Registry] stopPersistentFor: $gardenId');
      } catch (e, stck) {
        if (kDebugMode)
          debugPrint('[Registry] stopPersistentFor error: $e\n$stck');
      }
    } else {
      if (kDebugMode)
        debugPrint('[Registry] stopPersistentFor: no state for $gardenId');
    }
  }

  /// Attempt to force persistent for gardenId (defensive).
  void forcePersistentFor(String gardenId) {
    final st = stateFor(gardenId);
    if (st != null) {
      try {
        st.forcePersistent();
        if (kDebugMode) debugPrint('[Registry] forcePersistentFor: $gardenId');
      } catch (e, stck) {
        if (kDebugMode)
          debugPrint('[Registry] forcePersistentFor error: $e\n$stck');
      }
    } else {
      if (kDebugMode)
        debugPrint('[Registry] forcePersistentFor: no state for $gardenId');
    }
  }

  /// Stop persistent for all registered gardens except [keepId].
  /// If keepId is null, stop all.
  void stopAllExcept(String? keepId) {
    final keys = List<String>.from(_map.keys);
    for (final id in keys) {
      if (keepId != null && id == keepId) continue;
      stopPersistentFor(id);
    }
    if (kDebugMode) debugPrint('[Registry] stopAllExcept: kept=$keepId');
  }

  /// Return a read-only list of registered ids (debug / inspection).
  List<String> registeredIds() => List.unmodifiable(_map.keys);

  /// Clear the registry (useful for tests or full teardown).
  void clear() {
    _map.clear();
    if (kDebugMode) debugPrint('[Registry] cleared all entries');
  }
}

/// Provider exposant le GardenAwakeningRegistry (singleton simple).
final gardenAwakeningRegistryProvider =
    Provider<GardenAwakeningRegistry>((ref) => GardenAwakeningRegistry());
