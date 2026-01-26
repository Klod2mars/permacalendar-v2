import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import 'nutrition_aggregation_provider.dart';
import 'package:permacalendar/core/services/nutrition_normalizer.dart';

/// Statistique Mensuelle Pure (Masse brute)
class MonthlyNutritionStats {
  final int month; // 1..12

  // Totaux en masse pour ce mois (accumulateurs)
  final Map<String, double> nutrientTotals;

  // Nombre de récoltes ayant contribué
  final int contributionCount;
  
  // Quantité totale récoltée (kg) ayant contribué
  final double totalQuantityKg;

  const MonthlyNutritionStats({
    required this.month,
    required this.nutrientTotals,
    required this.contributionCount,
    required this.totalQuantityKg,
  });

  factory MonthlyNutritionStats.empty(int month) => MonthlyNutritionStats(
        month: month,
        nutrientTotals: {},
        contributionCount: 0,
        totalQuantityKg: 0.0,
      );

  double getTotal(String key) => nutrientTotals[key] ?? 0.0;
}

/// État Global Saisonnier
class SeasonalNutritionState {
  final Map<int, MonthlyNutritionStats> monthlyStats; // 1 -> Jan, etc.
  final Map<String, double> annualTotals; // Somme de toute l'année

  const SeasonalNutritionState({
    required this.monthlyStats,
    required this.annualTotals,
  });

  factory SeasonalNutritionState.empty() {
    return SeasonalNutritionState(
      monthlyStats: Map.fromEntries(
        List.generate(
            12, (i) => MapEntry(i + 1, MonthlyNutritionStats.empty(i + 1))),
      ),
      annualTotals: {},
    );
  }
}

final seasonalNutritionProvider =
    FutureProvider<SeasonalNutritionState>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);
  final aggregationService = ref.watch(nutritionAggregationServiceProvider);

  if (harvestRecordsState.isLoading) throw Exception('Loading records...');

  final (startDate, endDate) = filters.getEffectiveDates();

  // Filtrer les récoltes
  final filteredRecords = harvestRecordsState.records.where((record) {
    final inGarden = filters.selectedGardenIds.isEmpty ||
        filters.selectedGardenIds.contains(record.gardenId);
    final inPeriod =
        !record.date.isBefore(startDate) && !record.date.isAfter(endDate);
    return inGarden && inPeriod;
  }).toList();

  if (filteredRecords.isEmpty) return SeasonalNutritionState.empty();

  final result = await aggregationService.aggregate(
    filteredRecords,
    startDate: startDate,
    endDate: endDate,
  );

  // Convertir en format ViewModel existant
  final monthlyStats = <int, MonthlyNutritionStats>{};
  for (var m = 1; m <= 12; m++) {
    monthlyStats[m] = MonthlyNutritionStats(
      month: m,
      nutrientTotals: result.monthlyTotals[m] ?? {},
      contributionCount: result.monthlyRecordCounts[m] ?? 0,
      totalQuantityKg: result.monthlyMassKg[m] ?? 0.0,
    );
  }

  final annualTotals = <String, double>{};
  result.byNutrient.forEach((key, agg) {
    if (agg.sumAvailable > 0) annualTotals[key] = agg.sumAvailable;
  });

  return SeasonalNutritionState(
    monthlyStats: monthlyStats,
    annualTotals: annualTotals,
  );
});

final seasonalNutritionAllProvider =
    FutureProvider<SeasonalNutritionState>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final aggregationService = ref.watch(nutritionAggregationServiceProvider);

  if (harvestRecordsState.isLoading) throw Exception('Loading records...');

  final allRecords = harvestRecordsState.records;

  if (allRecords.isEmpty) return SeasonalNutritionState.empty();

  // Pour "All", on prend une plage large ou on laisse le service gérer
  // Le service a besoin de dates pour AJR, on prend min/max des records ou année courante
  // Ici l'AJR global n'est peut-être pas affiché dans la vue "All" de la même façon.
  final startDate = DateTime(DateTime.now().year, 1, 1);
  final endDate = DateTime(DateTime.now().year, 12, 31);

  final result = await aggregationService.aggregate(
    allRecords,
    startDate: startDate, // Dates arbitraires si on ne regarde que les totaux absolus
    endDate: endDate,
  );

  final monthlyStats = <int, MonthlyNutritionStats>{};
  for (var m = 1; m <= 12; m++) {
    monthlyStats[m] = MonthlyNutritionStats(
      month: m,
      nutrientTotals: result.monthlyTotals[m] ?? {},
      contributionCount: result.monthlyRecordCounts[m] ?? 0,
      totalQuantityKg: result.monthlyMassKg[m] ?? 0.0,
    );
  }

  final annualTotals = <String, double>{};
  result.byNutrient.forEach((key, agg) {
    if (agg.sumAvailable > 0) annualTotals[key] = agg.sumAvailable;
  });

  return SeasonalNutritionState(
    monthlyStats: monthlyStats,
    annualTotals: annualTotals,
  );
});
