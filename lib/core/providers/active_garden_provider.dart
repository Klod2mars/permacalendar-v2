import 'package:flutter_riverpod/flutter_riverpod.dart';
// ---------- AJOUTER CES IMPORTS EN TÊTE DU FICHIER ----------
import 'package:flutter/foundation.dart'; // pour debugPrint
import '../repositories/repository_providers.dart'; // pour gardenRepositoryProvider
// ---------- FIN DES IMPORTS À AJOUTER ----------

/// Provider pour l'ID du jardin actuellement actif
///
/// **PROMPT A15 - Multi-Garden Activation**
///
/// Ce provider centralise la gestion du jardin actif dans l'application.
/// Lorsqu'un jardin est activé, il déclenche automatiquement :
/// - La luminescence dans InsectAwakeningWidget
/// - La mise à jour des interfaces concernées
/// - Les calculs d'intelligence végétale pour ce jardin
///
/// Utilisation :
/// ```dart
/// // Pour activer un jardin
/// ref.read(activeGardenIdProvider.notifier).setActiveGarden(gardenId);
///
/// // Pour activer par nom
/// await ref.read(activeGardenIdProvider.notifier).setActiveGardenByName('Nom');
///
/// // Pour lire le jardin actif
/// final activeGardenId = ref.watch(activeGardenIdProvider);
/// ```
final activeGardenIdProvider = StateNotifierProvider<ActiveGardenIdNotifier, String?>(
  (ref) => ActiveGardenIdNotifier(ref),
);

/// Notifier pour la gestion de l'ID du jardin actif
class ActiveGardenIdNotifier extends StateNotifier<String?> {
  ActiveGardenIdNotifier(this.ref) : super(null);
  
  final Ref ref;

  /// Active un jardin spécifique par son ID
  ///
  /// Déclenche immédiatement la mise à jour de l'état et les effets
  /// associés (luminescence, etc.)
  void setActiveGarden(String gardenId) {
    state = gardenId;
    debugPrint('[ActiveGardenIdNotifier] Jardin activé: $gardenId');
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
      debugPrint('[ActiveGardenIdNotifier] setActiveGardenByName error: $e\n$st');
      return false;
    }
  }
}

/// Extension pour des méthodes utilitaires sur le provider
extension ActiveGardenIdExtensions on WidgetRef {
  /// Active un jardin par son nom de manière pratique
  Future<bool> activateGardenByName(String name) async {
    return read(activeGardenIdProvider.notifier).setActiveGardenByName(name);
  }

  /// Active un jardin par son ID de manière pratique
  void activateGarden(String gardenId) {
    read(activeGardenIdProvider.notifier).setActiveGarden(gardenId);
  }

  /// Retourne l'ID du jardin actuellement actif
  String? get activeGardenId => read(activeGardenIdProvider);
}

/// Mixin pour faciliter l'accès au jardin actif dans les widgets
mixin ActiveGardenMixin on ConsumerWidget {
  /// Raccourci pour accéder à l'ID du jardin actif dans build method
  String? activeGardenId(WidgetRef ref) => ref.activeGardenId;
}

/// Provider dérivé pour obtenir les détails complets du jardin actif
///
/// Combine activeGardenIdProvider avec gardenProvider pour fournir
/// l'objet GardenFreezed complet du jardin actif
final activeGardenProvider = Provider<GardenFreezed?>((ref) {
  final activeGardenId = ref.watch(activeGardenIdProvider);
  final gardens = ref.watch(gardenProvider).gardens;

  if (activeGardenId == null) return null;

  return gardens.firstWhere(
    (garden) => garden.id == activeGardenId,
    orElse: () => null,
  );
});