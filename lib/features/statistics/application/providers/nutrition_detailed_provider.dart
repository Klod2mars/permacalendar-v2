import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../../core/services/nutrition_normalizer.dart';

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
  final plantsList = ref.watch(plantsListProvider);

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

  final monthlyData = <int, Map<String, double>>{};
  final monthlyCounts = <int, int>{};
  final monthlyQuantities = <int, double>{};
  final annualTotals = <String, double>{};

  for (var m = 1; m <= 12; m++) {
    monthlyData[m] = {};
    monthlyCounts[m] = 0;
    monthlyQuantities[m] = 0.0;
  }

  for (final record in filteredRecords) {
    // Récup nutrition
    Map<String, double> nutris = {};

    // A. Snapshot
    if (record.nutritionSnapshot != null &&
        record.nutritionSnapshot!.isNotEmpty) {
      nutris = record.nutritionSnapshot!;
    } else {
      // B. Fallback Catalog
      var plant = plantsList.where((p) => p.id == record.plantId).firstOrNull;
      if (plant == null && record.plantName != null) {
        plant = plantsList
            .where((p) =>
                p.commonName.toLowerCase() == record.plantName!.toLowerCase())
            .firstOrNull;
      }

      if (plant != null && plant.nutritionPer100g != null) {
        nutris = NutritionNormalizer.computeSnapshot(
            plant.nutritionPer100g, record.quantityKg);
      }
    }

    // Skip if no nutrition data
    if (nutris.isEmpty) continue;

    final month = record.date.month;
    monthlyCounts[month] = (monthlyCounts[month] ?? 0) + 1;
    monthlyQuantities[month] = (monthlyQuantities[month] ?? 0.0) + record.quantityKg;

    // Accumuler
    nutris.forEach((key, val) {
      // Mensuel
      final mStats = monthlyData[month]!;
      mStats[key] = (mStats[key] ?? 0.0) + val;

      // Annuel
      annualTotals[key] = (annualTotals[key] ?? 0.0) + val;
    });
  }

  // Convertir en objets immuables
  final finalMonthlyStats = <int, MonthlyNutritionStats>{};
  for (var m = 1; m <= 12; m++) {
    finalMonthlyStats[m] = MonthlyNutritionStats(
      month: m,
      nutrientTotals: monthlyData[m]!,
      contributionCount: monthlyCounts[m] ?? 0,
      totalQuantityKg: monthlyQuantities[m] ?? 0.0,
    );
  }

  return SeasonalNutritionState(
    monthlyStats: finalMonthlyStats,
    annualTotals: annualTotals,
  );
});

/// Version NON FILTRÉE de seasonalNutritionProvider.
/// Agrège toutes les récoltes existantes, indépendamment des filtres (jardin/dates).
/// Utilisée pour la vue "Nutriments" globale.
final seasonalNutritionAllProvider =
    FutureProvider<SeasonalNutritionState>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final plantsList = ref.watch(plantsListProvider);

  if (harvestRecordsState.isLoading) throw Exception('Loading records...');

  // ON PREND TOUTES LES RÉCOLTES, AUCUN FILTRE
  final allRecords = harvestRecordsState.records;

  if (allRecords.isEmpty) return SeasonalNutritionState.empty();

  final monthlyData = <int, Map<String, double>>{};
  final monthlyCounts = <int, int>{};
  final monthlyQuantities = <int, double>{};
  final annualTotals = <String, double>{};

  for (var m = 1; m <= 12; m++) {
    monthlyData[m] = {};
    monthlyCounts[m] = 0;
    monthlyQuantities[m] = 0.0;
  }

  for (final record in allRecords) {
    // Récup nutrition
    Map<String, double> nutris = {};

    if (record.nutritionSnapshot != null &&
        record.nutritionSnapshot!.isNotEmpty) {
      nutris = record.nutritionSnapshot!;
    } else {
      var plant = plantsList.where((p) => p.id == record.plantId).firstOrNull;
      if (plant == null && record.plantName != null) {
        plant = plantsList
            .where((p) =>
                p.commonName.toLowerCase() == record.plantName!.toLowerCase())
            .firstOrNull;
      }
      if (plant != null && plant.nutritionPer100g != null) {
        nutris = NutritionNormalizer.computeSnapshot(
            plant.nutritionPer100g, record.quantityKg);
      }
    }

    // N'INCREMENTER contributionCount QUE SI la récolte apporte des nutriments
    if (nutris.isEmpty) continue;

    final month = record.date.month;
    monthlyCounts[month] = (monthlyCounts[month] ?? 0) + 1;
    monthlyQuantities[month] = (monthlyQuantities[month] ?? 0.0) + record.quantityKg;

    // Accumuler
    nutris.forEach((key, val) {
      final mStats = monthlyData[month]!;
      mStats[key] = (mStats[key] ?? 0.0) + val;
      annualTotals[key] = (annualTotals[key] ?? 0.0) + val;
    });
  }

  // Convertir en objets immuables
  final finalMonthlyStats = <int, MonthlyNutritionStats>{};
  for (var m = 1; m <= 12; m++) {
    finalMonthlyStats[m] = MonthlyNutritionStats(
      month: m,
      nutrientTotals: monthlyData[m]!,
      contributionCount: monthlyCounts[m] ?? 0,
      totalQuantityKg: monthlyQuantities[m] ?? 0.0,
    );
  }

  return SeasonalNutritionState(
    monthlyStats: finalMonthlyStats,
    annualTotals: annualTotals,
  );
});
