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

class GardenEconomyDetailScreen extends ConsumerWidget {
  final String? gardenId;

  const GardenEconomyDetailScreen({super.key, this.gardenId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get Filters
    final filters = ref.watch(statisticsFiltersProvider);
    final (startDate, endDate) = filters.getEffectiveDates();
    
    // 2. Prepare Query Params
    final queryParams = EconomyQueryParams(
      gardenId: gardenId ?? (filters.selectedGardenIds.length == 1 ? filters.selectedGardenIds.first : null),
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
                      // Charts & Visuals
                      MonthlyRevenueChart(monthlyRevenue: details.monthlyRevenue),
                      const SizedBox(height: 24),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: TopPlantsRanking(rankings: details.topPlants)),
                          const SizedBox(width: 16),
                          Expanded(child: PlantSharePie(plantShare: details.plantShare)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      AnnualRevenueLine(revenueSeries: details.revenueSeries),
                      const SizedBox(height: 24),
                      
                      TopPlantPerMonthGrid(
                        topPlantPerMonth: details.topPlantPerMonth,
                        monthlyRevenue: details.monthlyRevenue,
                      ),
                      const SizedBox(height: 24),
                      
                      DiversityIndicator(
                        diversityIndex: details.diversityIndex,
                        label: details.diversityLabel,
                      ),
                      const SizedBox(height: 24),
                      
                      FastVsLongTable(metrics: details.fastVsLongTerm),
                      const SizedBox(height: 24),
                      
                      RecommendationCard(
                        recommendationText: details.recommendationText,
                        onExport: () {
                           // Implement CSV Export
                           // Can trigger a separate provider or simple logic here
                           _exportCsv(context, details, queryParams);
                        },
                      ),
                      const SizedBox(height: 48), // Padding bottom
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  void _exportCsv(BuildContext context, EconomyDetails details, EconomyQueryParams params) {
    // Basic stub for export.
    // In a real impl, we would use csv package and share_plus
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export CSV généré pour ${details.harvestCount} récoltes.')),
    );
  }
}
