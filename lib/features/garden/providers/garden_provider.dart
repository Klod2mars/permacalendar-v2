import 'package:riverpod/riverpod.dart';

import '../../../core/models/garden_state.dart';
import '../../../core/models/garden_freezed.dart';
import '../../../core/repositories/dashboard_slots_repository.dart';
import '../../../core/repositories/repository_providers.dart';
import '../../../core/repositories/garden_hive_repository.dart';
import '../../../core/services/activity_observer_service.dart';
import '../../../core/events/garden_event_bus.dart';
import '../../../core/events/garden_events.dart';
import '../../../core/data/hive/garden_boxes.dart';
import '../../../core/services/migration/providers.dart';
import '../../garden_bed/providers/garden_bed_scoped_provider.dart';

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
        // Tracking avec ActivityObserverService
        await ActivityObserverService().captureGardenCreated(
          gardenId: garden.id,
          gardenName: garden.name,
          location: garden.location,
          area: garden.totalAreaInSquareMeters,
        );

        // Émettre événement via GardenEventBus
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
        // Tracking avec ActivityObserverService
        await ActivityObserverService().captureGardenUpdated(
          gardenId: garden.id,
          gardenName: garden.name,
          location: garden.location,
          area: garden.totalAreaInSquareMeters,
        );

        // Émettre événement via GardenEventBus
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
  ///
  /// Implémente une suppression robuste (Legacy + Modern)
  /// Retourne true si au moins une suppression a réussi
  Future<bool> deleteGarden(String gardenId) async {
    try {
      bool modernSuccess = false;
      bool legacySuccess = false;

      // Récupérer le jardin avant suppression pour le tracking
      final garden = state.findGardenById(gardenId);

      // --- 1. Dual Write Service (si activé) ---
      final dualWriteService = ref.read(dualWriteServiceProvider);
      if (dualWriteService.isEnabled) {
        final success = await dualWriteService.deleteGarden(gardenId);
        if (success) {
          modernSuccess = true;
          legacySuccess = true;
        }
      } else {
        // --- 2. Suppression Hybride Manuelle ---

        // A. Suppression Modern (GardenHiveRepository)
        try {
          final repository = ref.read(gardenRepositoryProvider);
          await repository.deleteGarden(gardenId);
          modernSuccess = true;
        } catch (e) {
          if (e is GardenNotFoundException) {
            // Idempotence : traité comme succès si déjà absent
            modernSuccess = true;
          } else {
            print(
                '[GardenNotifier] WARN: Modern delete failed for $gardenId: $e');
            // TODO: Enregistrer pour retry ?
          }
        }

        // B. Suppression Legacy (GardenBoxes)
        try {
          await GardenBoxes.deleteGarden(gardenId);
          legacySuccess = true;
        } catch (e) {
          // GardenBoxes ne throw pas forcément sur not found, mais si oui :
          print(
              '[GardenNotifier] WARN: Legacy delete failed for $gardenId: $e');
          // On considère que si ça fail, c'est pas bon, sauf si c'est "not found" (dur à catcher sans type précis)
          // Pour l'instant on log juste.
          // Si GardenBoxes.deleteGarden est robuste, il ne plante pas si l'ID manque.
          // On peut vérifier l'existence avant si on est puriste, mais ici on veut forcer la suppression.
        }
      }

      // --- 3. Suppression des dépendances globales (DashboardSlots) ---
      try {
        await DashboardSlotsRepository.removeGardenId(gardenId);
      } catch (e) {
        print('[GardenNotifier] WARN: Dashboard slots cleanup failed: $e');
      }

      // --- 4. Validation du résultat ---
      if (modernSuccess || legacySuccess) {
        // Tracking
        if (garden != null) {
          await ActivityObserverService().captureGardenDeleted(
            gardenId: garden.id,
            gardenName: garden.name,
          );
        }

        // Événement via EventBus
        GardenEventBus().emit(
          GardenEvent.gardenContextUpdated(
            gardenId: gardenId,
            timestamp: DateTime.now(),
            metadata: {
              'action': 'deleted',
            },
          ),
        );

        // --- 5. Rafraîchissement ---

        // Recharger la liste des jardins
        await loadGardens();

        // Invalider le cache des lits pour ce jardin (nettoyage Riverpod)
        ref.invalidate(gardenBedsForGardenProvider(gardenId));

        return true;
      } else {
        state = GardenState.error(
            'Échec de la suppression du jardin (Legacy & Modern failed)');
        return false;
      }
    } catch (e) {
      state = GardenState.error('Erreur inattendue lors de la suppression: $e');
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

  /// Crée un jardin et l'associe atomiquement à un dashboard slot si celui-ci est libre.
  /// Retourne true si la Création + association réussissent.
  Future<bool> createGardenForSlot(int slotNumber, GardenFreezed garden) async {
    try {
      // Vérifier si le slot est déjà occupé (lecture synchrone si possible)
      final existingId =
          DashboardSlotsRepository.getGardenIdForSlotSync(slotNumber);

      if (existingId != null) {
        state = GardenState.error('Slot $slotNumber déjà occupé par un jardin');
        return false;
      }

      // Créer le jardin via la logique existante
      final success = await createGarden(garden);
      if (!success) return false;

      // Lier le slot au garden id (persistant)
      await DashboardSlotsRepository.setGardenIdForSlot(slotNumber, garden.id);

      // Recharge les jardins
      await loadGardens();
      return true;
    } catch (e) {
      state = GardenState.error(
          'Erreur lors de la Création pour slot $slotNumber: $e');
      return false;
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
