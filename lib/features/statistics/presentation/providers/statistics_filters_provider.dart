import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../garden/providers/garden_provider.dart';

// ...

class StatisticsFiltersState {
  /// Ensemble des IDs de jardins sélectionnés.
  /// Si vide, on considère que TOUS les jardins sont sélectionnés (ou aucun ? on va dire 'Tous' par défaut pour l'agrégation).
  /// Alternative UX : Vide = Aucun, mais on peut avoir une méthode `isAllSelected`.
  /// Pour simplifier : Vide = Aucun filtre actif => Agrégation de TOUT.
  final Set<String> selectedGardenIds;

  const StatisticsFiltersState({this.selectedGardenIds = const {}});

  StatisticsFiltersState copyWith({Set<String>? selectedGardenIds}) {
    return StatisticsFiltersState(
      selectedGardenIds: selectedGardenIds ?? this.selectedGardenIds,
    );
  }

  /// Retourne la période effective.
  /// Par défaut : année en cours.
  (DateTime, DateTime) getEffectiveDates() {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    final end = DateTime(now.year, 12, 31, 23, 59, 59);
    return (start, end);
  }
}

class StatisticsFiltersNotifier extends Notifier<StatisticsFiltersState> {
  @override
  StatisticsFiltersState build() {
    // Écouter les changements dans la liste des jardins pour nettoyer la sélection
    ref.listen(gardenProvider, (previous, next) {
      final currentIds = state.selectedGardenIds;
      if (currentIds.isEmpty) return;

      final availableIds = next.gardens.map((g) => g.id).toSet();
      // On garde l'intersection
      final validIds = currentIds.intersection(availableIds);

      // Si on ne trouve plus les jardins sélectionnés (ex: supprimés), on reset à "Tous les jardins" (vide)
      if (validIds.isEmpty && currentIds.isNotEmpty) {
        state = state.copyWith(selectedGardenIds: {});
      } else if (validIds.length != currentIds.length) {
        state = state.copyWith(selectedGardenIds: validIds);
      }
    });

    return const StatisticsFiltersState();
  }

  /// Bascule la sélection d'un jardin.
  void toggleGarden(String id) {
    // Si l'application ne contient qu'un jardin, on le garde toujours sélectionné.
    final gardens = ref.read(gardenProvider).gardens;
    if (gardens.length == 1) {
      // forcer la sélection unique (empêche la désélection)
      state = state.copyWith(selectedGardenIds: {gardens.first.id});
      return;
    }

    final current = state.selectedGardenIds.toSet();
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(selectedGardenIds: current);
  }

  /// Sélectionne explicitement une liste de jardins (ou un seul).
  void setGardens(Set<String> ids) {
    state = state.copyWith(selectedGardenIds: ids);
  }

  /// Efface tous les filtres (implique une vue globale/agrégée par défaut dans la logique des consumers).
  void clearAll() {
    state = state.copyWith(selectedGardenIds: {});
  }
}

final statisticsFiltersProvider =
    NotifierProvider<StatisticsFiltersNotifier, StatisticsFiltersState>(
        StatisticsFiltersNotifier.new);
