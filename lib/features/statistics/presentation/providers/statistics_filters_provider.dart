import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return const StatisticsFiltersState();
  }

  /// Bascule la sélection d'un jardin.
  void toggleGarden(String id) {
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
