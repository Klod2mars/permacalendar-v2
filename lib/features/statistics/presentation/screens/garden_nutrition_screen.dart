import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../providers/statistics_filters_provider.dart';
import '../../application/providers/nutrition_radar_provider.dart';
import '../../application/providers/nutrition_kpi_providers.dart';

import '../widgets/nutrition_stats/vitality_radar_chart.dart';
import '../widgets/nutrition_stats/top_healers_widget.dart';
import '../widgets/nutrition_stats/deficiency_gauge.dart';

class GardenNutritionScreen extends ConsumerStatefulWidget {
  final String gardenId;
  const GardenNutritionScreen({super.key, required this.gardenId});

  @override
  ConsumerState<GardenNutritionScreen> createState() => _GardenNutritionScreenState();
}

class _GardenNutritionScreenState extends ConsumerState<GardenNutritionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statisticsFiltersProvider.notifier).setGardens({widget.gardenId});
    });
  }

  @override
  Widget build(BuildContext context) {
    final radarAsync = ref.watch(nutritionRadarProvider);
    final healersAsync = ref.watch(topHealersProvider);
    final deficiencyAsync = ref.watch(deficiencyProvider);
    final harvestState = ref.watch(harvestRecordsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark Theme Root
      appBar: AppBar(
        title: const Text('Équilibre Nutritionnel'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(harvestRecordsProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER: RADAR CHART
              const Text(
                'Bilan de Production Réelle',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Couverture de vos besoins journaliers (AJR) basée sur les récoltes de la période.',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 12),
              
              Container(
                height: 320,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: radarAsync.when(
                  data: (data) => VitalityRadarChart(data: data),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Erreur: $e', style: const TextStyle(color: Colors.red))),
                ),
              ),

              const SizedBox(height: 32),

              // 2. TOP HEALERS
              healersAsync.when(
                data: (healers) => TopHealersWidget(healers: healers),
                loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                error: (_,__) => const SizedBox(),
              ),

              const SizedBox(height: 32),

              // 4. DEFICIENCY (Kept as gentle suggestion)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF252525), const Color(0xFF1E1E1E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: deficiencyAsync.when(
                  data: (defs) => DeficiencyGauge(
                    deficiencies: defs,
                    onPlantAction: (suggestion) {
                       // ...
                    },
                  ),
                  loading: () => const SizedBox(height: 50),
                   error: (_,__) => const SizedBox(),
                ),
              ),

              const SizedBox(height: 48),

              if (harvestState.records.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 48, color: Colors.white24),
                        SizedBox(height: 16),
                        Text(
                          "Aucune récolte enregistrée",
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
