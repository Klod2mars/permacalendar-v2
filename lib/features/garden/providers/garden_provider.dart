import 'package:riverpod/riverpod.dart';
import '../../../core/models/garden_state.dart';
import '../../../core/models/garden_freezed.dart';
import '../../../core/repositories/repository_providers.dart';
import '../../../core/services/activity_observer_service.dart';
import '../../../core/events/garden_event_bus.dart';
import '../../../core/events/garden_events.dart';

/// Notifier pour la gestion de l'état des jardins
/// Utilise GardenHiveRepository pour les opérations CRUD
class GardenNotifier extends Notifier<GardenState> {
  @override
  GardenState build() {
    // Charger les jardins au démarrage
    loadGardens();
    return GardenState.initial();
  }

  /// Charge tous les jardins depuis le repository
  Future<void> loadGardens() async {
    try {
      state = GardenState.loading();
      final repository = ref.read(gardenRepositoryProvider);
      final gardens = await repository.getAllGardens();
      state = GardenState.loaded(gardens);
    } catch (e) {
      state = GardenState.error('Erreur lors du chargement des jardins: $e');
    }
  }

  /// Crée un nouveau jardin
  /// Retourne true si la création réussit, false sinon
  Future<bool> createGarden(GardenFreezed garden) async {
    try {
      // Vérifier la limite de jardins avant création
      if (!state.canAddGarden) {
        state = GardenState.error('Limite de 5 jardins atteinte');
        return false;
      }

      final repository = ref.read(gardenRepositoryProvider);
      final success = await repository.createGarden(garden);

      if (success) {
        // ✅ NOUVEAU : Tracking avec ActivityObserverService
        await ActivityObserverService().captureGardenCreated(
          gardenId: garden.id,
          gardenName: garden.name,
          location: garden.location,
          area: garden.totalAreaInSquareMeters,
        );

        // ✅ REFACTORÉ (SYNC-2) : Émettre événement via GardenEventBus
        GardenEventBus().emit(
          GardenEvent.gardenContextUpdated(
            gardenId: garden.id,
            timestamp: DateTime.now(),
            metadata: {
              'action': 'created',
              'gardenName': garden.name,
            },
          ),
        );

        // Recharger les jardins après création
        await loadGardens();
        return true;
      } else {
        state = GardenState.error('Échec de la création du jardin');
        return false;
      }
    } catch (e) {
      state = GardenState.error('Erreur lors de la création: $e');
      return false;
    }
  }

  /// Met à jour un jardin existant
  /// Retourne true si la mise à jour réussit, false sinon
  Future<bool> updateGarden(GardenFreezed garden) async {
    try {
      final repository = ref.read(gardenRepositoryProvider);
      final success = await repository.updateGarden(garden);

      if (success) {
        // ✅ NOUVEAU : Tracking avec ActivityObserverService
        await ActivityObserverService().captureGardenUpdated(
          gardenId: garden.id,
          gardenName: garden.name,
          location: garden.location,
          area: garden.totalAreaInSquareMeters,
        );

        // ✅ REFACTORÉ (SYNC-2) : Émettre événement via GardenEventBus
        GardenEventBus().emit(
          GardenEvent.gardenContextUpdated(
            gardenId: garden.id,
            timestamp: DateTime.now(),
            metadata: {
              'action': 'updated',
              'gardenName': garden.name,
            },
          ),
        );

        // Recharger les jardins après mise à jour
        await loadGardens();
        return true;
      } else {
        state = GardenState.error('Échec de la mise à jour du jardin');
        return false;
      }
    } catch (e) {
      state = GardenState.error('Erreur lors de la mise à jour: $e');
      return false;
    }
  }

  /// Supprime un jardin par son ID
  /// Retourne true si la suppression réussit, false sinon
  Future<bool> deleteGarden(String gardenId) async {
    try {
      // Récupérer le jardin avant suppression pour le tracking
      final garden = state.findGardenById(gardenId);

      final repository = ref.read(gardenRepositoryProvider);
      final success = await repository.deleteGarden(gardenId);

      if (success) {
        // ✅ NOUVEAU : Tracking avec ActivityObserverService
        if (garden != null) {
          await ActivityObserverService().captureGardenDeleted(
            gardenId: garden.id,
            gardenName: garden.name,
          );
        }

        // ✅ REFACTORÉ (SYNC-2) : Émettre événement via GardenEventBus
        GardenEventBus().emit(
          GardenEvent.gardenContextUpdated(
            gardenId: gardenId,
            timestamp: DateTime.now(),
            metadata: {
              'action': 'deleted',
            },
          ),
        );

        // Recharger les jardins après suppression
        await loadGardens();
        return true;
      } else {
        state = GardenState.error('Échec de la suppression du jardin');
        return false;
      }
    } catch (e) {
      state = GardenState.error('Erreur lors de la suppression: $e');
      return false;
    }
  }

  /// Bascule le statut actif/inactif d'un jardin
  /// Méthode utilitaire pour archiver/désarchiver un jardin
  Future<bool> toggleGardenStatus(String gardenId) async {
    try {
      final garden = state.findGardenById(gardenId);
      if (garden == null) {
        state = GardenState.error('Jardin non trouvé');
        return false;
      }

      final updatedGarden = garden.copyWith(
        isActive: !garden.isActive,
        updatedAt: DateTime.now(),
      );

      return await updateGarden(updatedGarden);
    } catch (e) {
      state = GardenState.error('Erreur lors du changement de statut: $e');
      return false;
    }
  }

  /// Sélectionne un jardin spécifique
  void selectGarden(String gardenId) {
    final garden = state.findGardenById(gardenId);
    if (garden != null) {
      state = state.copyWith(selectedGarden: garden);
    }
  }

  /// Désélectionne le jardin actuel
  void clearSelection() {
    state = state.copyWith(selectedGarden: null);
  }

  /// Efface l'erreur actuelle
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(error: null);
    }
  }
}

/// Provider principal pour la gestion des jardins
/// NotifierProvider qui expose GardenNotifier et GardenState
final gardenProvider =
    NotifierProvider<GardenNotifier, GardenState>(GardenNotifier.new);

/// Provider pour accéder uniquement aux jardins actifs
/// Dérivé du gardenProvider principal
final activeGardensProvider = Provider<List<GardenFreezed>>((ref) {
  final gardenState = ref.watch(gardenProvider);
  return gardenState.activeGardens;
});

/// Provider pour vérifier si on peut ajouter un nouveau jardin
/// Utile pour l'UI pour désactiver les boutons d'ajout
final canAddGardenProvider = Provider<bool>((ref) {
  final gardenState = ref.watch(gardenProvider);
  return gardenState.canAddGarden;
});

/// Provider pour obtenir le nombre de jardins actifs
/// Utile pour afficher des statistiques
final activeGardensCountProvider = Provider<int>((ref) {
  final gardenState = ref.watch(gardenProvider);
  return gardenState.activeGardensCount;
});
