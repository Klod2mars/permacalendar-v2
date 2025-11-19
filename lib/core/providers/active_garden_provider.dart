import 'package:riverpod/riverpod.dart';
import 'package:flutter/foundation.dart';
import '../repositories/repository_providers.dart'; // pour gardenRepositoryProvider

/// Notifier qui garde l'ID du jardin "actif".
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
      // Récupérer le repository des jardins (provider central)
      final repo = ref.read(gardenRepositoryProvider);

      // Rechercher des candidats par nom (méthode existante)
      final candidates = repo.searchGardens(name);
      if (candidates.isEmpty) return false;

      // Préférer une correspondance exacte (insensible à la casse), sinon prendre le premier
      final match = candidates.firstWhere(
        (g) => g.name.toLowerCase().trim() == name.toLowerCase().trim(),
        orElse: () => candidates.first,
      );

      // Activer via l'API centrale (même méthode que le long-press)
      setActiveGarden(match.id);
      return true;
    } catch (e, st) {
      // Debug léger (ne pas lever l'exception pour l'appelant)
      debugPrint('[ActiveGardenIdNotifier] setActiveGardenByName error: $e\n$st');
      return false;
    }
  }

  /// Efface la sélection
  void clear() {
    state = null;
  }
}

/// Provider exposant l'ID du jardin actif (String?).
final activeGardenIdProvider = NotifierProvider<ActiveGardenIdNotifier, String?>(ActiveGardenIdNotifier.new);