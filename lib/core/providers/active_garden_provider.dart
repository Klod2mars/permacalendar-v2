// lib/core/providers/active_garden_provider.dart
//
// ActiveGardenIdNotifier
// - Fournit l'ID du jardin "actif" (String?)
// - API robuste : setActiveGarden(String?), toggleActiveGarden(String),
//   setActiveGardenByName(String) et clear()
// - Conçu pour être utilisé depuis le dashboard / hotspots afin d'avoir une
//   activation atomique et nullable (null == aucun jardin actif).
//
// Remarque : conserve la dépendance au repository via repository_providers.dart
// si tu utilises setActiveGardenByName.

import 'package:riverpod/riverpod.dart';
import 'package:flutter/foundation.dart';

import '../repositories/repository_providers.dart'; // pour gardenRepositoryProvider

/// Notifier qui garde l'ID du jardin "actif".
///
/// Usage attendu :
///   ref.watch(activeGardenIdProvider);
///   ref.read(activeGardenIdProvider.notifier).setActiveGarden(gardenId);
///   ref.read(activeGardenIdProvider.notifier).toggleActiveGarden(gardenId);
class ActiveGardenIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    // Aucun jardin actif par défaut
    return null;
  }

  /// Définit le jardin actif (ID). Accepte null pour effacer la sélection.
  /// Utiliser plutôt toggleActiveGarden pour les interactions 'long-press'.
  void setActiveGarden(String? gardenId) {
    if (kDebugMode) {
      debugPrint('[ActiveGarden] setActiveGarden -> ${gardenId ?? "null"}');
    }
    state = gardenId;
  }

  /// Toggle atomique : si le même garden est déjà actif, on le désactive.
  /// Sinon on active le nouveau (opération synchrone sur state).
  void toggleActiveGarden(String gardenId) {
    if (kDebugMode) {
      debugPrint(
          '[ActiveGarden] toggleActiveGarden called for $gardenId (current=$state)');
    }
    if (state == gardenId) {
      state = null;
      if (kDebugMode) debugPrint('[ActiveGarden] toggled OFF $gardenId');
    } else {
      state = gardenId;
      if (kDebugMode) debugPrint('[ActiveGarden] toggled ON $gardenId');
    }
  }

  /// Active un jardin à partir de son nom (résolution nom -> id).
  /// Retourne true si un jardin a été trouvé et activé.
  Future<bool> setActiveGardenByName(String name) async {
    try {
      // Récupérer le repository des jardins
      final repo = ref.read(gardenRepositoryProvider);

      // Charger tous les jardins (async)
      final gardens = await repo.getAllGardens();

      // Filtrer par correspondance (insensible à la casse)
      final normalized = name.toLowerCase().trim();
      final candidates = gardens
          .where((g) => g.name.toLowerCase().contains(normalized))
          .toList();

      if (candidates.isEmpty) return false;

      // Prioriser correspondance exacte (si existante), sinon prendre le premier
      final match = candidates.firstWhere(
        (g) => g.name.toLowerCase().trim() == normalized,
        orElse: () => candidates.first,
      );

      // Activer via l'API centrale (nullable)
      setActiveGarden(match.id);
      return true;
    } catch (e, st) {
      debugPrint('[ActiveGarden] setActiveGardenByName error: $e\n$st');
      return false;
    }
  }

  /// Efface la sélection (met à null)
  void clear() {
    if (kDebugMode) debugPrint('[ActiveGarden] clear()');
    state = null;
  }
}

/// Provider exposant l'ID du jardin actif (String?).
final activeGardenIdProvider =
    NotifierProvider<ActiveGardenIdNotifier, String?>(
        ActiveGardenIdNotifier.new);
