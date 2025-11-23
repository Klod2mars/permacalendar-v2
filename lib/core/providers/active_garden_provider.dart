// lib/core/providers/active_garden_provider.dart
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import '../repositories/repository_providers.dart';
import 'garden_awakening_registry.dart';

/// Notifier qui garde l'ID du jardin "actif" (String?).
/// Il orchestre aussi le registry pour s'assurer que les overlays sont
/// arrêtés/forcés de façon synchrone quand on change d'actif.
class ActiveGardenIdNotifier extends Notifier<String?> {
  /// Protection simple contre les appels réentrants simultanés.
  /// Si un changement est en cours, les appels entrants sont ignorés
  /// (comportement volontairement conservateur).
  bool _isChanging = false;

  @override
  String? build() {
    return null;
  }

  /// Définit le jardin actif (ID). Accepte null pour effacer la sélection.
  ///
  /// IMPORTANT : cette méthode **orchestra** le registre :
  /// - stoppe toutes les lueurs sauf [gardenId] (ou toutes si gardenId == null)
  /// - met à jour l'état
  /// - si gardenId != null, force la lueur pour cet id
  void setActiveGarden(String? gardenId) {
    // Évite réentrance
    if (_isChanging) {
      if (kDebugMode) {
        debugPrint(
            '[ActiveGarden] setActiveGarden called while changing -> ignoring request for ${gardenId ?? "null"}');
      }
      return;
    }

    _isChanging = true;
    try {
      final prev = state;
      if (kDebugMode) {
        debugPrint(
            '[ActiveGarden] setActiveGarden -> ${gardenId ?? "null"} (prev=$prev)');
      }

      final registry = ref.read(gardenAwakeningRegistryProvider);

      // 1) Stopper tout sauf gardenId (si gardenId == null => stopAll)
      try {
        registry.stopAllExcept(gardenId);
      } catch (e, st) {
        if (kDebugMode)
          debugPrint('[ActiveGarden] registry.stopAllExcept error: $e\n$st');
      }

      // 2) Mettre à jour l'état (idempotent)
      if (state != gardenId) {
        state = gardenId;
      } else {
        if (kDebugMode) {
          debugPrint(
              '[ActiveGarden] setActiveGarden: gardenId equals current state -> no state change');
        }
      }

      // 3) Forcer la lueur pour le nouveau garden si non-null.
      if (gardenId != null) {
        try {
          registry.forcePersistentFor(gardenId);
          if (kDebugMode) {
            debugPrint(
                '[ActiveGarden] registry.forcePersistentFor called for $gardenId (registered=${registry.registeredIds().contains(gardenId)})');
          }
        } catch (e, st) {
          if (kDebugMode)
            debugPrint(
                '[ActiveGarden] registry.forcePersistentFor error: $e\n$st');
        }
      } else {
        // Defensive: assurer que tout est stoppé
        try {
          registry.stopAllExcept(null);
        } catch (e, st) {
          if (kDebugMode)
            debugPrint(
                '[ActiveGarden] registry.stopAllExcept(null) error: $e\n$st');
        }
      }
    } finally {
      _isChanging = false;
    }
  }

  /// Toggle atomique : si le même garden est déjà actif, on le désactive.
  /// Sinon on active le nouveau.
  ///
  /// Cette version réutilise `setActiveGarden` pour garantir l'orchestration.
  void toggleActiveGarden(String gardenId) {
    final prev = state;
    if (kDebugMode) {
      debugPrint(
          '[ActiveGarden] toggleActiveGarden called for $gardenId (current=$prev)');
    }

    if (prev == gardenId) {
      // Si on toggled OFF : appeler setActiveGarden(null) (qui stoppe tout)
      setActiveGarden(null);
      if (kDebugMode) debugPrint('[ActiveGarden] toggled OFF $gardenId');
      return;
    }

    // Activation d'un nouveau garden : déléguer à setActiveGarden
    setActiveGarden(gardenId);
    if (kDebugMode) debugPrint('[ActiveGarden] toggled ON $gardenId');
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

      // Utiliser setActiveGarden pour assurer l'orchestration
      setActiveGarden(match.id);
      return true;
    } catch (e, st) {
      if (kDebugMode)
        debugPrint('[ActiveGarden] setActiveGardenByName error: $e\n$st');
      return false;
    }
  }

  /// Clear : stoppe toutes les lueurs et remet l'état à null.
  void clear() {
    if (kDebugMode) debugPrint('[ActiveGarden] clear()');

    final registry = ref.read(gardenAwakeningRegistryProvider);
    try {
      registry.stopAllExcept(null);
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
