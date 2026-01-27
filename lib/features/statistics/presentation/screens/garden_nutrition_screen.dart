import 'package:flutter/material.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../providers/statistics_filters_provider.dart';
import '../../application/providers/nutrition_detailed_provider.dart';
import '../widgets/nutrition_stats/month_selector.dart';
import '../widgets/nutrition_stats/nutrient_inventory_widget.dart';
import '../widgets/nutrition_stats/seasonal_trend_widget.dart';
import '../../../../core/providers/app_settings_provider.dart';
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
    // FIX: Use seasonalNutritionProvider to respect filters
    final seasonalAsync = ref.watch(seasonalNutritionProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(l10n.nutrition_page_title),
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
              GardenMultiSelector(),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  l10n.nutrition_seasonal_dynamics_title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  l10n.nutrition_seasonal_dynamics_desc,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
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
                                const Icon(Icons.eco_outlined,
                                    size: 48, color: Colors.white24),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.nutrition_no_harvest_month,
                                  style: const TextStyle(color: Colors.white38),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          // TRENDS
                          SeasonalTrendWidget(
                            selectedMonth: _selectedMonth,
                            monthlyStatsMap: state.monthlyStats,
                            annualData: annualTotals,
                            onMonthTap: (m) => setState(() => _selectedMonth = m),
                          ),
                          const SizedBox(height: 24),

                          // INVENTORY HEADER + TOGGLE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Inventaire Nutritionnel",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Row(
                                children: [
                                  Text(
                                    appSettings.showNutritionInterpretation
                                        ? "Interprétation"
                                        : "Mesure",
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: appSettings.showNutritionInterpretation,
                                    onChanged: (val) {
                                      ref
                                          .read(appSettingsProvider.notifier)
                                          .toggleShowNutritionInterpretation(val);
                                    },
                                    activeColor: Colors.greenAccent,
                                    activeTrackColor: Colors.greenAccent.withOpacity(0.2),
                                    inactiveThumbColor: Colors.white54,
                                    inactiveTrackColor: Colors.white10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.05)),
                            ),
                            child: NutrientInventoryWidget(
                              data: monthlyStats.nutrientTotals,
                              showHumanUnits: appSettings.showNutritionInterpretation,
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
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
