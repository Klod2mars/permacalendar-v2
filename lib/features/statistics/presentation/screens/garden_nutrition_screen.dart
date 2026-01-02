import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../providers/statistics_filters_provider.dart';
import '../../application/providers/nutrition_detailed_provider.dart';
import '../widgets/nutrition_stats/month_selector.dart';
import '../widgets/nutrition_stats/monthly_composition_chart.dart';
import '../widgets/nutrition_stats/seasonal_trend_widget.dart';
import '../widgets/garden_multi_selector.dart';

class GardenNutritionScreen extends ConsumerStatefulWidget {
  final String? gardenId;
  const GardenNutritionScreen({super.key, this.gardenId});

  @override
  ConsumerState<GardenNutritionScreen> createState() =>
      _GardenNutritionScreenState();
}

class _GardenNutritionScreenState extends ConsumerState<GardenNutritionScreen> {
  int _selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    if (widget.gardenId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(statisticsFiltersProvider.notifier)
            .setGardens({widget.gardenId!});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final seasonalAsync = ref.watch(seasonalNutritionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Signature Nutritionnelle'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 0. SELECTOR & HEADER
              const GardenMultiSelector(),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  'Dynamique Saisonnière',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  'Explorez la production minérale et vitaminique de votre jardin, mois par mois.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),

              // 1. MONTH SELECTOR
              MonthSelector(
                selectedMonth: _selectedMonth,
                onMonthSelected: (m) => setState(() => _selectedMonth = m),
              ),
              const SizedBox(height: 24),

              // 2. CONTENT
              seasonalAsync.when(
                data: (state) {
                  final monthlyStats = state.monthlyStats[_selectedMonth]!;
                  final annualTotals = state.annualTotals;
                  final hasData = monthlyStats.contributionCount > 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hasData)
                          Container(
                            padding: const EdgeInsets.all(32),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(Icons.eco_outlined,
                                    size: 48, color: Colors.white24),
                                SizedBox(height: 16),
                                Text(
                                  "Aucune récolte en ce mois",
                                  style: TextStyle(color: Colors.white38),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          // TRENDS
                          SeasonalTrendWidget(
                              month: _selectedMonth,
                              monthlyData: monthlyStats.nutrientTotals,
                              annualData: annualTotals),
                          const SizedBox(height: 24),

                          // PIE CHARTS
                          if (monthlyStats.contributionCount > 0) ...[
                            const Text(
                              'Structure & Minéraux Majeurs',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: MonthlyCompositionChart(
                                data: monthlyStats.nutrientTotals,
                                isMajorMinerals: true,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Vitalité & Oligo-éléments',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: MonthlyCompositionChart(
                                data: monthlyStats.nutrientTotals,
                                isMajorMinerals: false,
                              ),
                            ),
                          ],
                        ]
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(
                    child: Text('Erreur: $e',
                        style: const TextStyle(color: Colors.red))),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
