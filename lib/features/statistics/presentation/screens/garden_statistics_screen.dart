import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importer la liste des piliers si elle existe :
import '../widgets/statistics_pillars_list.dart';
import '../providers/statistics_filters_provider.dart';

class GardenStatisticsScreen extends ConsumerWidget {
  final String gardenId;
  const GardenStatisticsScreen({super.key, required this.gardenId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialiser le filtre gardenId
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statisticsFiltersProvider.notifier).setGardenId(gardenId);
    });

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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Hero(
                      tag: 'stats-bubble-hero-$gardenId',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          'Statistiques de résilience',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                    const Center(
                      child: CircularProgressIndicator(color: Colors.greenAccent),
                    ),

                    // Plus tard : StatisticsPillarsList(),
                    // Expanded(child: StatisticsPillarsList()),
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
