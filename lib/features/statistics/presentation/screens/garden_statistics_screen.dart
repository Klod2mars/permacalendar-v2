import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importer la liste des piliers si elle existe :
import '../widgets/statistics_pillars_list.dart';
import '../providers/statistics_filters_provider.dart';

import '../widgets/garden_multi_selector.dart';

class GardenStatisticsScreen extends ConsumerStatefulWidget {
  final String? gardenId;
  const GardenStatisticsScreen({super.key, this.gardenId});

  @override
  ConsumerState<GardenStatisticsScreen> createState() =>
      _GardenStatisticsScreenState();
}

class _GardenStatisticsScreenState
    extends ConsumerState<GardenStatisticsScreen> {
  @override
  void initState() {
    super.initState();
    // Intialization logic
    // If a gardenId is passed specifically (old route), we force-set it.
    // If generic route (null), we leave the provider as is (or defaulted to empty).
    if (widget.gardenId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // We use setGardens to set a single ID in the set
        ref
            .read(statisticsFiltersProvider.notifier)
            .setGardens({widget.gardenId!});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'CONSCIENCE DU VIVANT',
                style: TextStyle(
                  color: Colors.greenAccent.withOpacity(0.8),
                  letterSpacing: 1.2,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            // Multi-Garden Selector
            const SliverToBoxAdapter(
              child: GardenMultiSelector(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Hero(
                      // Using a global tag for the generic entry point
                      tag: 'stats-bubble-hero-global',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          'Statistiques de résilience',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Analyse en temps réel de votre autonomie.',
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                    const SizedBox(height: 40),

                    // Ici : la liste de piliers (ou placeholder)
                    const SizedBox(height: 24),
                    // Injection : liste/pivot des 4 bulles
                    const StatisticsPillarsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
