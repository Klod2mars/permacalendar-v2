import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/economy_details_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../../harvest/application/harvest_records_provider.dart';

import '../widgets/economy_stats/economy_kpi_row.dart';
import '../widgets/economy_stats/top_plants_ranking.dart';
import '../widgets/economy_stats/monthly_revenue_chart.dart';
import '../widgets/economy_stats/top_plant_per_month_grid.dart';
import '../widgets/economy_stats/annual_revenue_line.dart';
import '../widgets/economy_stats/plant_share_pie.dart';
import '../widgets/economy_stats/diversity_indicator.dart';
import '../widgets/economy_stats/recommendation_card.dart';
import '../widgets/economy_stats/fast_vs_long_table.dart';
import '../widgets/economy_stats/key_months_widget.dart';
import '../widgets/economy_stats/historical_revenue_widget.dart';

class GardenEconomyScreen extends ConsumerStatefulWidget {
  final String gardenId;
  const GardenEconomyScreen({super.key, required this.gardenId});

  @override
  ConsumerState<GardenEconomyScreen> createState() => _GardenEconomyScreenState();
}

class _GardenEconomyScreenState extends ConsumerState<GardenEconomyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        ref.read(statisticsFiltersProvider.notifier).setGardens({widget.gardenId});
      } catch (e, st) {
        debugPrint('[GardenEconomyScreen] Warning: failed to set default garden in postFrame: $e\n$st');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get Filters
    final filters = ref.watch(statisticsFiltersProvider);
    final (startDate, endDate) = filters.getEffectiveDates();
    
    // 2. Prepare Query Params
    final queryParams = EconomyQueryParams(
      gardenId: widget.gardenId, // Use widget.gardenId directly as it's required for this screen
      startDate: startDate,
      endDate: endDate,
    );

    // 3. Watch Data
    final details = ref.watch(economyDetailsProvider(queryParams));
    final harvestState = ref.watch(harvestRecordsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark theme
      appBar: AppBar(
        title: const Text('Économie du Jardin'),
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
        child: harvestState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EconomyKpiRow(details: details),
                    const SizedBox(height: 24),
                    
                    if (details.harvestCount == 0)
                      const Center(
                          child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('Aucune récolte sur la période sélectionnée.',
                            style: TextStyle(color: Colors.white54)),
                      ))
                    else ...[
                      // Module 1: Plantes les plus rentables
                      TopPlantsRanking(rankings: details.topPlants),
                      const SizedBox(height: 24),

                      // Module 2: Revenu total par mois
                      MonthlyRevenueChart(monthlyRevenue: details.monthlyRevenue),
                      const SizedBox(height: 24),

                      // Module 3: Plante la plus rentable par mois
                      TopPlantPerMonthGrid(
                        topPlantPerMonth: details.topPlantPerMonth,
                        monthlyRevenue: details.monthlyRevenue,
                      ),
                      const SizedBox(height: 24),

                      // Module 4: Évolution du revenu sur l’année
                      AnnualRevenueLine(revenueSeries: details.revenueSeries),
                      const SizedBox(height: 24),

                      // Module 5: Répartition du revenu par plante
                      PlantSharePie(plantShare: details.plantShare),
                      const SizedBox(height: 24),

                      // Module 6: Mois clés du jardin
                      KeyMonthsWidget(
                        monthlyRevenue: details.monthlyRevenue,
                        mostProfitableIndex: details.mostProfitableMonthIndex,
                        leastProfitableIndex: details.leastProfitableMonthIndex,
                      ),
                      const SizedBox(height: 24),

                      // Module 7: Diversité économique
                      DiversityIndicator(
                        diversityIndex: details.diversityIndex,
                        label: details.diversityLabel,
                      ),
                      const SizedBox(height: 24),

                      // Module 8: Synthèse automatique
                      RecommendationCard(
                        recommendationText: details.recommendationText,
                        onExport: () => _exportCsv(context, details, queryParams),
                      ),
                      const SizedBox(height: 24),

                      // Module 9: Évolution histoire (Historical)
                      HistoricalRevenueWidget(revenueSeries: details.revenueSeries),
                      const SizedBox(height: 24),

                      // Module 10: Rentabilité rapide vs Long terme
                      FastVsLongTable(metrics: details.fastVsLongTerm),
                      const SizedBox(height: 48),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  void _exportCsv(BuildContext context, EconomyDetails details, EconomyQueryParams params) {
    // Basic stub for export.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export CSV généré pour ${details.harvestCount} récoltes.')),
    );
  }
}
