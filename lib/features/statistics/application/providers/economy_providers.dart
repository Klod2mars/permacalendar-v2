import 'package:riverpod/riverpod.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';

/// Provider pour le total des Kgs récoltés (filtré)
final totalKgProvider = Provider<double>((ref) {
  final harvestState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);
  final (startDate, endDate) = filters.getEffectiveDates();

  final filtered = harvestState.records.where((r) {
    final periodOk = !r.date.isBefore(startDate) && !r.date.isAfter(endDate);
    final gardenOk = filters.selectedGardenIds.isEmpty ||
        filters.selectedGardenIds.contains(r.gardenId);
    return periodOk && gardenOk;
  }).toList();

  return filtered.fold<double>(0.0, (s, r) => s + (r.quantityKg ?? 0.0));
});

/// Provider pour la valeur totale (filtrée) - Alias de totalEconomyKpiProvider mais plus générique
final totalValueProvider = Provider<double>((ref) {
  final harvestState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);
  final (startDate, endDate) = filters.getEffectiveDates();

  final filtered = harvestState.records.where((r) {
    final periodOk = !r.date.isBefore(startDate) && !r.date.isAfter(endDate);
    final gardenOk = filters.selectedGardenIds.isEmpty ||
        filters.selectedGardenIds.contains(r.gardenId);
    return periodOk && gardenOk;
  }).toList();

  return filtered.fold<double>(0.0, (s, r) => s + r.totalValue);
});

/// Provider pour le prix moyen pondéré au Kg (filtré)
/// Formule : Somme(TotalValue) / Somme(QuantityKg)
final weightedAvgPriceProvider = Provider<double>((ref) {
  final totalValue = ref.watch(totalValueProvider);
  final totalKg = ref.watch(totalKgProvider);

  if (totalKg == 0) return 0.0;
  return totalValue / totalKg;
});
