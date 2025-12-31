import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarFilterState {
  final bool showHarvestsOnly;
  final bool showUrgentOnly;
  final String? selectedGardenBedId;

  const CalendarFilterState({
    this.showHarvestsOnly = false,
    this.showUrgentOnly = false,
    this.selectedGardenBedId,
  });

  CalendarFilterState copyWith({
    bool? showHarvestsOnly,
    bool? showUrgentOnly,
    String? selectedGardenBedId,
  }) {
    return CalendarFilterState(
      showHarvestsOnly: showHarvestsOnly ?? this.showHarvestsOnly,
      showUrgentOnly: showUrgentOnly ?? this.showUrgentOnly,
      selectedGardenBedId: selectedGardenBedId ?? this.selectedGardenBedId,
    );
  }
}

class CalendarFilterNotifier extends Notifier<CalendarFilterState> {
  @override
  CalendarFilterState build() => const CalendarFilterState();

  void toggleHarvestsOnly() {
    state = state.copyWith(showHarvestsOnly: !state.showHarvestsOnly);
  }

  void toggleUrgentOnly() {
    state = state.copyWith(showUrgentOnly: !state.showUrgentOnly);
  }

  void setGardenBedId(String? id) {
    state = state.copyWith(selectedGardenBedId: id);
  }
  
  void clearFilters() {
    state = const CalendarFilterState();
  }
}

final calendarFilterProvider =
    NotifierProvider<CalendarFilterNotifier, CalendarFilterState>(
        CalendarFilterNotifier.new);
