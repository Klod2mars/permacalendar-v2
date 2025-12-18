import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsFiltersState {
  final String? selectedGardenId;

  const StatisticsFiltersState({this.selectedGardenId});

  StatisticsFiltersState copyWith({String? selectedGardenId}) {
    return StatisticsFiltersState(
      selectedGardenId: selectedGardenId ?? this.selectedGardenId,
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

  void setGardenId(String? id) {
    state = state.copyWith(selectedGardenId: id);
  }
}

final statisticsFiltersProvider =
    NotifierProvider<StatisticsFiltersNotifier, StatisticsFiltersState>(
        StatisticsFiltersNotifier.new);
