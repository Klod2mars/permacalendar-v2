import 'package:riverpod/riverpod.dart';
import '../data/repositories/plant_hive_repository.dart';
import '../domain/entities/plant_entity.dart';
import '../data/models/plant_hive.dart';
import '../../../core/services/activity_tracker_v3.dart';
import '../../../core/models/activity_v3.dart';

// État simplifié et moderne
class PlantCatalogState {
  final List<PlantFreezed> plants;
  final bool isLoading;
  final String? error;
  final PlantFreezed? selectedPlant;

  const PlantCatalogState({
    this.plants = const [],
    this.isLoading = false,
    this.error,
    this.selectedPlant,
  });

  PlantCatalogState copyWith({
    List<PlantFreezed>? plants,
    bool? isLoading,
    String? error,
    PlantFreezed? selectedPlant,
  }) {
    return PlantCatalogState(
      plants: plants ?? this.plants,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedPlant: selectedPlant ?? this.selectedPlant,
    );
  }
}

// Notifier utilisant le NOUVEAU repository avec tracking d'activités
class PlantCatalogNotifier extends Notifier<PlantCatalogState> {
  @override
  PlantCatalogState build() => const PlantCatalogState();

  // Chargement SIMPLIFIÉ avec le nouveau repository
  Future<void> loadPlants() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // UTILISATION DIRECTE du nouveau repository
      final repository = PlantHiveRepository();
      final plants = await repository.getAllPlants();

      state = state.copyWith(
        plants: plants,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement des plantes: $e',
      );
    }
  }

  // Ajouter une nouvelle plante avec tracking
  Future<void> addPlant(PlantHive plant) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Ajouter la plante au repository
      final repository = PlantHiveRepository();
      await repository.addPlant(plant);

      // Tracker l'activité de création
      final activityTracker = ActivityTrackerV3();
      await activityTracker.trackActivity(
        type: 'plantCreated',
        description: 'Plante "${plant.commonName}" ajoutée au catalogue',
        metadata: {
          'plantId': plant.id,
          'commonName': plant.commonName,
          'scientificName': plant.scientificName,
          'family': plant.family,
          'plantingSeason': plant.plantingSeason,
        },
        priority: ActivityPriority.normal,
      );

      // Recharger la liste des plantes
      await loadPlants();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de l\'ajout de la plante: $e',
      );
    }
  }

  // Mettre à jour une plante avec tracking
  Future<void> updatePlant(PlantHive plant) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Mettre à jour la plante dans le repository
      final repository = PlantHiveRepository();
      await repository.updatePlant(plant);

      // Tracker l'activité de mise à jour
      final activityTracker = ActivityTrackerV3();
      await activityTracker.trackActivity(
        type: 'plantUpdated',
        description: 'Plante "${plant.commonName}" mise à jour',
        metadata: {
          'plantId': plant.id,
          'commonName': plant.commonName,
          'scientificName': plant.scientificName,
          'family': plant.family,
          'plantingSeason': plant.plantingSeason,
          'updatedAt': plant.updatedAt?.toIso8601String(),
        },
        priority: ActivityPriority.normal,
      );

      // Recharger la liste des plantes
      await loadPlants();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la mise à jour de la plante: $e',
      );
    }
  }

  // Supprimer une plante avec tracking
  Future<void> deletePlant(String plantId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Récupérer les informations de la plante avant suppression
      final repository = PlantHiveRepository();
      final plant = await repository.getPlantById(plantId);
      if (plant == null) {
        throw Exception('Plante non trouvée');
      }

      // Supprimer la plante du repository
      await repository.deletePlant(plantId);

      // Tracker l'activité de suppression
      final activityTracker = ActivityTrackerV3();
      await activityTracker.trackActivity(
        type: 'plantDeleted',
        description: 'Plante "${plant.commonName}" supprimée du catalogue',
        metadata: {
          'plantId': plantId,
          'commonName': plant.commonName,
          'scientificName': plant.scientificName,
          'family': plant.family,
          'deletedAt': DateTime.now().toIso8601String(),
        },
        priority: ActivityPriority.normal,
      );

      // Recharger la liste des plantes
      await loadPlants();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la suppression de la plante: $e',
      );
    }
  }

  // Vérifier si une plante existe
  Future<bool> plantExists(String plantId) async {
    try {
      final repository = PlantHiveRepository();
      return await repository.plantExists(plantId);
    } catch (e) {
      return false;
    }
  }

  // Recherche SIMPLIFIÉE
  List<PlantFreezed> searchPlants(String query) {
    if (query.isEmpty) return state.plants;

    return state.plants
        .where((plant) =>
            plant.commonName.toLowerCase().contains(query.toLowerCase()) ||
            plant.scientificName.toLowerCase().contains(query.toLowerCase()) ||
            plant.family.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Filtrage par saison
  List<PlantFreezed> getPlantsBySeason(String season) {
    if (season == 'Toutes') return state.plants;
    return state.plants
        .where((plant) => plant.plantingSeason.contains(season))
        .toList();
  }

  // Sélection plante
  void selectPlant(PlantFreezed? plant) {
    state = state.copyWith(selectedPlant: plant);
  }

  // Effacer erreur
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider PRINCIPAL avec injection du repository et du tracker d'activités
final plantCatalogProvider =
    NotifierProvider<PlantCatalogNotifier, PlantCatalogState>(
        PlantCatalogNotifier.new);

// Providers calculés SIMPLIFIÉS
final plantsListProvider = Provider<List<PlantFreezed>>((ref) {
  return ref.watch(plantCatalogProvider).plants;
});

final selectedPlantProvider = Provider<PlantFreezed?>((ref) {
  return ref.watch(plantCatalogProvider).selectedPlant;
});

final plantCatalogLoadingProvider = Provider<bool>((ref) {
  return ref.watch(plantCatalogProvider).isLoading;
});

final plantCatalogErrorProvider = Provider<String?>((ref) {
  return ref.watch(plantCatalogProvider).error;
});

// Provider de recherche
final plantSearchProvider =
    Provider.family<List<PlantFreezed>, String>((ref, query) {
  final notifier = ref.read(plantCatalogProvider.notifier);
  return notifier.searchPlants(query);
});

// Provider par saison
final plantsBySeasonProvider =
    Provider.family<List<PlantFreezed>, String>((ref, season) {
  final notifier = ref.read(plantCatalogProvider.notifier);
  return notifier.getPlantsBySeason(season);
});


