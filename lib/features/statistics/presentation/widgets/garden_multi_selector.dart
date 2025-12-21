import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../garden/providers/garden_provider.dart';
import '../providers/statistics_filters_provider.dart';

class GardenMultiSelector extends ConsumerWidget {
  const GardenMultiSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardensState = ref.watch(gardenProvider);
    final filters = ref.watch(statisticsFiltersProvider);
    final notifier = ref.read(statisticsFiltersProvider.notifier);

    // Si on n'a pas encore chargé les jardins, ou s'il n'y en a pas
    if (gardensState.gardens.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: gardensState.gardens.map((garden) {
          final isSelected = filters.selectedGardenIds.contains(garden.id);
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(garden.name),
              selected: isSelected,
              onSelected: (_) => notifier.toggleGarden(garden.id),
              backgroundColor: Colors.black54,
              selectedColor: Colors.greenAccent.withOpacity(0.2),
              checkmarkColor: Colors.greenAccent,
              labelStyle: TextStyle(
                color: isSelected ? Colors.greenAccent : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.greenAccent : Colors.white24,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
