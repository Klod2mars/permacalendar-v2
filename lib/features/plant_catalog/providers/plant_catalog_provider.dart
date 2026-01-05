import 'package:riverpod/riverpod.dart';

import '../data/repositories/plant_hive_repository.dart';
import '../data/repositories/custom_plant_repository.dart'; // Import du nouveau repository

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
  PlantCatalogState build() {
    // Ne pas lancer d'effets de bord ici.
    // L'initialisation doit être différée ou gérée autrement si nécessaire,
    // mais pour un Notifier, state initial est synchrone.
    // On lance le chargement en asynchrone après le build.
    Future.microtask(() => loadPlants());
    return const PlantCatalogState();
  }

  // Chargement UNIFIÉ (Standard + Custom)

  Future<void> loadPlants() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 1. Charger le catalogue standard
      final stdRepo = PlantHiveRepository();
      final stdPlants = await stdRepo.getAllPlants();

      // 2. Charger le catalogue personnalisé
      final customRepo = CustomPlantRepository();
      List<PlantFreezed> customPlants = [];
      try {
        customPlants = await customRepo.getAllPlants();
      } catch (e) {
        print('PlantCatalogNotifier: Error loading custom plants: $e');
        // On continue même si erreur sur custom
      }

      // 3. Marquer les plantes personnalisées (si nécessaire) et fusionner
      // Note: On pourrait modifier le metadata ici si ce n'est pas déjà fait en amont,
      // mais idéalement c'est fait à la création.
      // Pour l'affichage, on fusionne simplement.

      final allPlants = [...stdPlants, ...customPlants];

      // Optionnel : trier par nom
      allPlants.sort((a, b) => a.commonName.compareTo(b.commonName));

      state = state.copyWith(
        plants: allPlants,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement des plantes: $e',
      );
    }
  }

  // Ajouter une nouvelle plante STANDARD (legacy / admin)
  Future<void> addPlant(PlantHive plant) async {
    // Cette méthode reste pour le catalogue standard si besoin,
    // mais pour l'utilisateur on préférera addCustomPlant.
    try {
      state = state.copyWith(isLoading: true, error: null);
      final repository = PlantHiveRepository();
      await repository.addPlant(plant);
      
      final activityTracker = ActivityTrackerV3();
      await activityTracker.trackActivity(
        type: 'plantCreated',
        description: 'Plante standard "${plant.commonName}" ajoutée',
        metadata: {'plantId': plant.id},
        priority: ActivityPriority.normal,
      );

      await loadPlants();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erreur ajout standard: $e');
    }
  }

  // === GESTION DES PLANTES PERSONNALISÉES ===

  Future<void> addCustomPlant(PlantHive plant) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final repository = CustomPlantRepository();
      
      // S'assurer que le metadata est initialisé
      if (plant.metadata == null) {
        plant.metadata = <String, dynamic>{};
      }
      
      // S'assurer que le flag isCustom est bien mis
      if (!plant.metadata!.containsKey('isCustom')) {
        plant.metadata!['isCustom'] = true;
      }
      if (!plant.metadata!.containsKey('origin')) {
        plant.metadata!['origin'] = 'user';
      }

      await repository.addPlant(plant);

      final activityTracker = ActivityTrackerV3();
      await activityTracker.trackActivity(
        type: 'customPlantCreated',
        description: 'Plante personnalisée "${plant.commonName}" créée',
        metadata: {
          'plantId': plant.id,
          'commonName': plant.commonName,
          'isCustom': true
        },
        priority: ActivityPriority.normal,
      );

      await loadPlants();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la création de la plante personnalisée: $e',
      );
    }
  }

  Future<void> updateCustomPlant(PlantHive plant) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final repository = CustomPlantRepository();
      await repository.updatePlant(plant);

      final activityTracker = ActivityTrackerV3();
      await activityTracker.trackActivity(
        type: 'customPlantUpdated',
        description: 'Plante personnalisée "${plant.commonName}" modifiée',
        metadata: {
          'plantId': plant.id,
          'updatedAt': DateTime.now().toIso8601String(),
        },
        priority: ActivityPriority.normal,
      );

      await loadPlants();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur modifications plante personnalisée: $e',
      );
    }
  }

  Future<void> deleteCustomPlant(String plantId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final repository = CustomPlantRepository();
      // On vérifie d'abord
      if (await repository.plantExists(plantId)) {
        await repository.deletePlant(plantId);
        
        final activityTracker = ActivityTrackerV3();
        await activityTracker.trackActivity(
          type: 'customPlantDeleted',
          description: 'Plante personnalisée supprimée',
          metadata: {'plantId': plantId},
          priority: ActivityPriority.normal,
        );
      } else {
        throw Exception('Plante personnalisée introuvable');
      }

      await loadPlants();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur suppression plante personnalisée: $e',
      );
    }
  }


  // Mettre à jour une plante (Méthode générique qui déduit le repo ?)
  // Pour l'instant on garde les méthodes séparées pour être explicite,
  // ou on pourrait vérifier l'ID/metadata. 
  // Gardons la compatibilité avec l'existant :
  Future<void> updatePlant(PlantHive plant) async {
    // Si c'est une custom, on redirige
    if (plant.metadata != null && plant.metadata!['isCustom'] == true) {
      await updateCustomPlant(plant);
      return;
    }
    
    // Sinon comportement standard (update dans plants_box)
    try {
      state = state.copyWith(isLoading: true, error: null);
      final repository = PlantHiveRepository();
      await repository.updatePlant(plant);
      
      final activityTracker = ActivityTrackerV3();
      await activityTracker.trackActivity(
        type: 'plantUpdated',
        description: 'Plante "${plant.commonName}" mise à jour',
        metadata: {'plantId': plant.id},
        priority: ActivityPriority.normal,
      );

      await loadPlants();
    } catch (e) {
       // Si échoue, peut-être qu'elle est dans custom par erreur ?
       // On log juste l'erreur standard.
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la mise à jour de la plante: $e',
      );
    }
  }

  // Supprimer une plante (Générique)
  Future<void> deletePlant(String plantId) async {
    // On essaie de savoir d'où elle vient.
    // Le plus simple est de regarder dans la liste chargée en mémoire.
    final target = state.plants.firstWhere((p) => p.id == plantId, orElse: () => throw Exception('Plante non trouvée dans la liste'));
    
    if (target.metadata != null && target.metadata['isCustom'] == true) {
      await deleteCustomPlant(plantId);
      return;
    }

    // Standard delete
    try {
      state = state.copyWith(isLoading: true, error: null);
      final repository = PlantHiveRepository();
      await repository.deletePlant(plantId);

      final activityTracker = ActivityTrackerV3();
      await activityTracker.trackActivity(
        type: 'plantDeleted',
        description: 'Plante "${target.commonName}" supprimée',
        metadata: {'plantId': plantId},
        priority: ActivityPriority.normal,
      );

      await loadPlants();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la suppression de la plante: $e',
      );
    }
  }

  // Vérifier si une plante existe (dans l'un ou l'autre)
  Future<bool> plantExists(String plantId) async {
     // Check memory first
     if (state.plants.any((p) => p.id == plantId)) return true;
     
     // Check repos
     if (await PlantHiveRepository().plantExists(plantId)) return true;
     if (await CustomPlantRepository().plantExists(plantId)) return true;
     
     return false;
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

  // Réinitialiser la base de données avec les graines par défaut
  Future<void> seedDefaultPlants() async {
    try {
      print('PlantCatalogNotifier: seedDefaultPlants called');
      state = state.copyWith(isLoading: true, error: null);

      final repository = PlantHiveRepository();
      
      // On recharge depuis le JSON en effaçant d'abord (clean reload)
      await repository.initializeFromJson(clearBefore: true);

      await loadPlants();
      print('PlantCatalogNotifier: seedDefaultPlants completed successfully');
    } catch (e) {
      print('PlantCatalogNotifier: seedDefaultPlants failed: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du rechargement des plantes: $e',
      );
    }
  }

  // Supprimer toutes les plantes
  // Attention : Ne devrait supprimer que les standards ou tout ?
  // Pour le debug "Nuke", on peut vouloir tout supprimer.
  Future<void> deleteAllPlants() async {
    // Implémentation conservative : on ne touche pas au custom ici sauf si explicitement demandé.
    // Laisons vide pour l'instant comme avant.
  }

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
