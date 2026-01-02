import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../domain/models/economy_trend_point.dart';

/// Provider pour la tendance mensuelle de la valeur des récoltes
///
/// Agrège les valeurs de récoltes par mois sur la période sélectionnée.
final economyTrendProvider = Provider<List<EconomyTrendPoint>>((ref) {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);

  // Calculer les dates effectives selon la période sélectionnée
  final (startDate, endDate) = filters.getEffectiveDates();

  // Filtrage
  List<dynamic> filteredRecords;
  if (filters.selectedGardenIds.isNotEmpty) {
    filteredRecords = harvestRecordsState.records.where((record) {
      final inGarden = filters.selectedGardenIds.contains(record.gardenId);
      final inPeriod =
          record.date.isAfter(startDate) && record.date.isBefore(endDate);
      return inGarden && inPeriod;
    }).toList();
  } else {
    filteredRecords = harvestRecordsState.records
        .where((record) =>
            record.date.isAfter(startDate) && record.date.isBefore(endDate))
        .toList();
  }

  if (filteredRecords.isEmpty) return [];

  // Agrégation par mois (clé: YYYY-MM)
  final Map<String, double> monthlySums = {};

  // Pour s'assurer d'avoir tous les mois dans l'ordre, on peut itérer ou trier après.
  // Ici on fait simple : on agrège tout, puis on trie les clés.

  for (final record in filteredRecords) {
    final date = record.date as DateTime;
    final key = "${date.year}-${date.month.toString().padLeft(2, '0')}";
    monthlySums[key] = (monthlySums[key] ?? 0.0) + record.totalValue;
  }

  // Création et tri des points
  final points = monthlySums.entries.map((entry) {
    final parts = entry.key.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    // On met le point au 1er du mois ou milieu ? 15 du mois pour centrer visuellement si besoin
    final date = DateTime(year, month, 15);
    return EconomyTrendPoint(date: date, value: entry.value);
  }).toList();

  points.sort((a, b) => a.date.compareTo(b.date));

  return points;
});
