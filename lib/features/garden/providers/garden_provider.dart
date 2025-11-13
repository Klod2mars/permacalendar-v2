ï»¿import 'package:riverpod/riverpod.dart';
import '../../../core/models/garden_state.dart';
import '../../../core/models/garden_freezed.dart';
import '../../../core/repositories/dashboard_slots_repository.dart';
import '../../../core/repositories/repository_providers.dart';
import '../../../core/services/activity_observer_service.dart';
import '../../../core/events/garden_event_bus.dart';
import '../../../core/events/garden_events.dart';

/// Notifier pour la gestion de l'ÃƒÂ©tat des jardins
/// Utilise GardenHiveRepository pour les opÃƒÂ©rations CRUD
class GardenNotifier extends Notifier<GardenState> {
  @override
  GardenState build() {
    // Charger les jardins au dÃƒÂ©marrage
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

  /// CrÃƒÂ©e un nouveau jardin
  /// Retourne true si la crÃƒÂ©ation rÃƒÂ©ussit, false sinon
  Future<bool> createGarden(GardenFreezed garden) async {
    try {
      // VÃƒÂ©rifier la limite de jardins avant crÃƒÂ©ation
      if (!state.canAddGarden) {
        state = GardenState.error('Limite de 5 jardins atteinte');
        return false;
      }

      final repository = ref.read(gardenRepositoryProvider);
      final success = await repository.createGarden(garden);

      if (success) {
        // âÅ“… NOUVEAU : Tracking avec ActivityObserverService
        await ActivityObserverService().captureGardenCreated(
          gardenId: garden.id,
          gardenName: garden.name,
          location: garden.location,
          area: garden.totalAreaInSquareMeters,
        );

        // âÅ“… REFACTORÃƒâ€° (SYNC-2) : Ãƒâ€°mettre ÃƒÂ©vÃƒÂ©nement via GardenEventBus
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

        // Recharger les jardins aprÃƒÂ¨s crÃƒÂ©ation
        await loadGardens();
        return true;
      } else {
        state = GardenState.error('Ãƒâ€°chec de la crÃƒÂ©ation du jardin');
        return false;
      }
    } catch (e) {
      state = GardenState.error('Erreur lors de la crÃƒÂ©ation: $e');
      return false;
    }
  }

  /// Met ÃƒÂ  jour un jardin existant
  /// Retourne true si la mise ÃƒÂ  jour rÃƒÂ©ussit, false sinon
  Future<bool> updateGarden(GardenFreezed garden) async {
    try {
      final repository = ref.read(gardenRepositoryProvider);
      final success = await repository.updateGarden(garden);

      if (success) {
        // âÅ“… NOUVEAU : Tracking avec ActivityObserverService
        await ActivityObserverService().captureGardenUpdated(
          gardenId: garden.id,
          gardenName: garden.name,
          location: garden.location,
          area: garden.totalAreaInSquareMeters,
        );

        // âÅ“… REFACTORÃƒâ€° (SYNC-2) : Ãƒâ€°mettre ÃƒÂ©vÃƒÂ©nement via GardenEventBus
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

        // Recharger les jardins aprÃƒÂ¨s mise ÃƒÂ  jour
        await loadGardens();
        return true;
      } else {
        state = GardenState.error('Ãƒâ€°chec de la mise ÃƒÂ  jour du jardin');
        return false;
      }
    } catch (e) {
      state = GardenState.error('Erreur lors de la mise ÃƒÂ  jour: $e');
      return false;
    }
  }

  /// Supprime un jardin par son ID
  /// Retourne true si la suppression rÃƒÂ©ussit, false sinon
  Future<bool> deleteGarden(String gardenId) async {
    try {
      // RÃƒÂ©cupÃƒÂ©rer le jardin avant suppression pour le tracking
      final garden = state.findGardenById(gardenId);

      final repository = ref.read(gardenRepositoryProvider);
      final success = await repository.deleteGarden(gardenId);

      if (success) {
        // âÅ“… NOUVEAU : Tracking avec ActivityObserverService
        if (garden != null) {
          await ActivityObserverService().captureGardenDeleted(
            gardenId: garden.id,
            gardenName: garden.name,
          );
        }

        // âÅ“… REFACTORÃƒâ€° (SYNC-2) : Ãƒâ€°mettre ÃƒÂ©vÃƒÂ©nement via GardenEventBus
        GardenEventBus().emit(
          GardenEvent.gardenContextUpdated(
            gardenId: gardenId,
            timestamp: DateTime.now(),
            metadata: {
              'action': 'deleted',
            },
          ),
        );

        // Recharger les jardins aprÃƒÂ¨s suppression
        await loadGardens();
        return true;
      } else {
        state = GardenState.error('Ãƒâ€°chec de la suppression du jardin');
        return false;
      }
    } catch (e) {
      state = GardenState.error('Erreur lors de la suppression: $e');
      return false;
    }
  }

  /// Bascule le statut actif/inactif d'un jardin
  /// MÃƒÂ©thode utilitaire pour archiver/dÃƒÂ©sarchiver un jardin
  Future<bool> toggleGardenStatus(String gardenId) async {
    try {
      final garden = state.findGardenById(gardenId);
      if (garden == null) {
        state = GardenState.error('Jardin non trouvÃƒÂ©');
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

  /// SÃƒÂ©lectionne un jardin spÃƒÂ©cifique
  void selectGarden(String gardenId) {
    final garden = state.findGardenById(gardenId);
    if (garden != null) {
      state = state.copyWith(selectedGarden: garden);
    }
  }

  /// DÃƒÂ©sÃƒÂ©lectionne le jardin actuel
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
      final existingId = DashboardSlotsRepository.getGardenIdForSlotSync(slotNumber);
      if (existingId != null) {
        state = GardenState.error('Slot $slotNumber déjà occupé par un jardin');
        return false;
      }

      // Créer le jardin via la logique existante
      final success = await createGarden(garden);
      if (!success) return false;

      // Lier le slot au garden id (persistant)
      await DashboardSlotsRepository.setGardenIdForSlot(slotNumber, garden.id);

      // Recharge les jardins (createGarden appelle déjà loadGardens mais on reconfirme)
      await loadGardens();
      return true;
    } catch (e) {
      state = GardenState.error('Erreur lors de la Création pour slot $slotNumber: $e');
      return false;
    }
  }}

/// Provider principal pour la gestion des jardins
/// NotifierProvider qui expose GardenNotifier et GardenState
final gardenProvider =
    NotifierProvider<GardenNotifier, GardenState>(GardenNotifier.new);

/// Provider pour accÃƒÂ©der uniquement aux jardins actifs
/// DÃƒÂ©rivÃƒÂ© du gardenProvider principal
final activeGardensProvider = Provider<List<GardenFreezed>>((ref) {
  final gardenState = ref.watch(gardenProvider);
  return gardenState.activeGardens;
});

/// Provider pour vÃƒÂ©rifier si on peut ajouter un nouveau jardin
/// Utile pour l'UI pour dÃƒÂ©sactiver les boutons d'ajout
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




