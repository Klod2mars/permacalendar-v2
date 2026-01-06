import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/garden_aggregation_providers.dart';
import '../../domain/models/garden_history.dart';

class GardenHistoryWidget extends ConsumerStatefulWidget {
  final String gardenId;

  const GardenHistoryWidget({Key? key, required this.gardenId}) : super(key: key);

  @override
  ConsumerState<GardenHistoryWidget> createState() => _GardenHistoryWidgetState();
}

class _GardenHistoryWidgetState extends ConsumerState<GardenHistoryWidget> {
  late PageController _pageController;
  int _initialPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Note: gardenHistoryProvider is exported in garden_aggregation_providers.dart
    final asyncHistory = ref.watch(gardenHistoryProvider(widget.gardenId));

    return asyncHistory.when(
      data: (gardenHistory) {
        if (gardenHistory.years.isEmpty) {
          return const Center(child: Text('Aucun historique disponible'));
        }

        // initial page is 0 (current year)
        return PageView.builder(
          controller: _pageController,
          itemCount: gardenHistory.years.length,
          itemBuilder: (context, index) {
            final yearPage = gardenHistory.years[index];
            return _buildYearPage(context, yearPage);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Erreur: $e')),
    );
  }

  Widget _buildYearPage(BuildContext context, YearPage yearPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () {
                if (_pageController.page! < _pageController.positions.first.maxScrollExtent) {
                    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              }, icon: const Icon(Icons.arrow_back_ios, size: 16)),
              Text('Année ${yearPage.year}', style: Theme.of(context).textTheme.titleLarge),
              IconButton(onPressed: () {
                if (_pageController.page! > 0) {
                    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              }, icon: const Icon(Icons.arrow_forward_ios, size: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: yearPage.beds.length,
              itemBuilder: (context, idx) {
                final bed = yearPage.beds[idx];
                return _BedCard(bed: bed);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BedCard extends StatelessWidget {
  final BedYearHistory bed;

  const _BedCard({Key? key, required this.bed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasPlants = bed.plants.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text('${bed.bedName}', style: Theme.of(context).textTheme.titleMedium),
        subtitle: hasPlants
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bed.plants.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.eco, size: 14, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(p.plantName, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  )).toList(),
                ),
              )
            : Text('Aucune plantation', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
        onTap: () {
          // Optional: open detail filtered for this bed + year
        },
      ),
    );
  }
}
