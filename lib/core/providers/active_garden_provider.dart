// lib/core/providers/active_garden_provider.dart
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import '../repositories/repository_providers.dart';
import 'garden_awakening_registry.dart';

/// Notifier qui garde l'ID du jardin "actif" (String?).
/// Il orchestre aussi le registry pour s'assurer que les overlays sont
/// arrêtés/forcés de façon synchrone quand on change d'actif.
class ActiveGardenIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  /// Définit le jardin actif (ID). Accepte null pour effacer la sélection.
  void setActiveGarden(String? gardenId) {
    if (kDebugMode) {
      debugPrint(
          '[ActiveGarden] setActiveGarden -> ${gardenId ?? "null"} (prev=$state)');
    }
    state = gardenId;
  }

  /// Toggle atomique : si le même garden est déjà actif, on le désactive.
  /// Sinon on active le nouveau.
  /// En plus : on appelle le registry pour stopper l'ancien overlay et
  /// forcer le nouveau afin de garder overlay/state synchrones.
  void toggleActiveGarden(String gardenId) {
    final prev = state;
    if (kDebugMode) {
      debugPrint(
          '[ActiveGarden] toggleActiveGarden called for $gardenId (current=$prev)');
    }

    final registry = ref.read(gardenAwakeningRegistryProvider);

    if (prev == gardenId) {
      // Désactivation : demander au registry d'arrêter la lueur pour cet id
      try {
        registry.stopPersistentFor(gardenId);
      } catch (e, st) {
        if (kDebugMode)
          debugPrint(
              '[ActiveGarden] registry stopPersistentFor error: $e\n$st');
      }
      state = null;
      if (kDebugMode) debugPrint('[ActiveGarden] toggled OFF $gardenId');
      return;
    }

    // Activation d'un nouveau garden : arrêter l'ancien synchroniquement
    if (prev != null) {
      try {
        registry.stopPersistentFor(prev);
      } catch (e, st) {
        if (kDebugMode)
          debugPrint(
              '[ActiveGarden] registry stopPersistentFor previous error: $e\n$st');
      }
    }

    // Définir le nouvel état
    state = gardenId;
    if (kDebugMode) debugPrint('[ActiveGarden] toggled ON $gardenId');

    // Forcer la lueur pour le nouveau garden (si la clé est déjà enregistrée).
    try {
      registry.forcePersistentFor(gardenId);
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[ActiveGarden] registry forcePersistentFor error: $e\n$st');
    }
  }

  /// Active un jardin à partir de son nom (résolution nom -> id).
  Future<bool> setActiveGardenByName(String name) async {
    try {
      final repo = ref.read(gardenRepositoryProvider);
      final gardens = await repo.getAllGardens();
      final normalized = name.toLowerCase().trim();
      final candidates = gardens
          .where((g) => g.name.toLowerCase().contains(normalized))
          .toList();
      if (candidates.isEmpty) return false;
      final match = candidates.firstWhere(
          (g) => g.name.toLowerCase().trim() == normalized,
          orElse: () => candidates.first);
      setActiveGarden(match.id);
      return true;
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[ActiveGarden] setActiveGardenByName error: $e\n$st');
      return false;
    }
  }

  void clear() {
    if (kDebugMode) debugPrint('[ActiveGarden] clear()');
    // stop all overlays as well for safety
    try {
      ref.read(gardenAwakeningRegistryProvider).stopAllExcept(null);
    } catch (e, st) {
      if (kDebugMode)
        debugPrint(
            '[ActiveGarden] registry.stopAllExcept error on clear: $e\n$st');
    }
    state = null;
  }
}

final activeGardenIdProvider =
    NotifierProvider<ActiveGardenIdNotifier, String?>(
        ActiveGardenIdNotifier.new);
