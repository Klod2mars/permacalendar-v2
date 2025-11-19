// lib/core/providers/active_garden_provider.dart
import 'package:riverpod/riverpod.dart';
import 'package:flutter/foundation.dart';

import '../repositories/repository_providers.dart'; // pour gardenRepositoryProvider

/// Notifier qui garde l'ID du jardin "actif".
///
/// Usage attendu :
///   ref.watch(activeGardenIdProvider);
///   ref.read(activeGardenIdProvider.notifier).setActiveGarden(gardenId);
class ActiveGardenIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  /// Définit le jardin actif (ID)
  void setActiveGarden(String gardenId) {
    state = gardenId;
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

      // Activer via l'API centrale
      setActiveGarden(match.id);
      return true;
    } catch (e, st) {
      // debug léger — n'empêche pas l'appelant de continuer
      debugPrint(
          '[ActiveGardenIdNotifier] setActiveGardenByName error: $e\n$st');
      return false;
    }
  }

  /// Efface la sélection
  void clear() {
    state = null;
  }
}

/// Provider exposant l'ID du jardin actif (String?).
final activeGardenIdProvider =
    NotifierProvider<ActiveGardenIdNotifier, String?>(
        ActiveGardenIdNotifier.new);
