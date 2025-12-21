import 'package:riverpod/riverpod.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../domain/models/plant_value_ranking.dart';

/// Provider pour le KPI "Valeur totale des récoltes (â‚¬)" du pilier Économie Vivante
///
/// Ce provider calcule la somme des valeurs totales des récoltes selon :
/// - Le filtre période sélectionné (today, last7Days, last30Days, currentYear, custom)
/// - Le filtre jardin s'il est actif (sinon tous les jardins)
///
/// Utilise les providers existants pour les filtres et les données de récoltes
final totalEconomyKpiProvider = Provider<double>((ref) {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);

  // Calculer les dates effectives selon la période sélectionnée
  final (startDate, endDate) = filters.getEffectiveDates();

  // Récupérer les enregistrements selon les filtres
  List<dynamic> filteredRecords;

  if (filters.selectedGardenIds.isNotEmpty) {
    // Filtrer par liste de jardins ET par période
    filteredRecords = harvestRecordsState.records.where((record) {
      final inGarden = filters.selectedGardenIds.contains(record.gardenId);
      final inPeriod =
          !record.date.isBefore(startDate) && !record.date.isAfter(endDate);
      return inGarden && inPeriod;
    }).toList();
  } else {
    // Filtrer seulement par période (tous les jardins)
    filteredRecords = harvestRecordsState.records
        .where((record) =>
            !record.date.isBefore(startDate) && !record.date.isAfter(endDate))
        .toList();
  }

  // Calculer la somme totale
  final total = filteredRecords.isEmpty
      ? 0.0
      : filteredRecords
          .map((record) => record.totalValue)
          .fold(0.0, (sum, value) => sum + value);
  
  debugPrint('[totalEconomyKpi] computed total=$total from ${filteredRecords.length} records');
  return total;
});

/// Provider pour le KPI "Valeur totale des récoltes (â‚¬)" avec gestion d'état de chargement
///
/// Version alternative qui gère les états de chargement et d'erreur
final totalEconomyKpiAsyncProvider = FutureProvider<double>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);

  // Attendre que les données soient chargées
  if (harvestRecordsState.isLoading) {
    throw Exception('Loading harvest records...');
  }

  if (harvestRecordsState.error != null) {
    throw Exception(
        'Error loading harvest records: ${harvestRecordsState.error}');
  }

  // Calculer les dates effectives selon la période sélectionnée
  final (startDate, endDate) = filters.getEffectiveDates();

  // Récupérer les enregistrements selon les filtres
  List<dynamic> filteredRecords;

  if (filters.selectedGardenIds.isNotEmpty) {
    // Filtrer par liste de jardins ET par période
    filteredRecords = harvestRecordsState.records.where((record) {
      final inGarden = filters.selectedGardenIds.contains(record.gardenId);
      final inPeriod =
          !record.date.isBefore(startDate) && !record.date.isAfter(endDate);
      return inGarden && inPeriod;
    }).toList();
  } else {
    // Filtrer seulement par période (tous les jardins)
    filteredRecords = harvestRecordsState.records
        .where((record) =>
            !record.date.isBefore(startDate) && !record.date.isAfter(endDate))
        .toList();
  }

  // Calculer la somme totale
  if (filteredRecords.isEmpty) return 0.0;

  double total = 0.0;
  for (final record in filteredRecords) {
    total += record.totalValue;
  }

  return total;
});

/// Provider pour le Top 3 des plantes les plus rentables (â‚¬) du pilier Économie Vivante
///
/// Ce provider calcule le classement des 3 plantes les plus rentables selon :
/// - Le filtre période sélectionné (today, last7Days, last30Days, currentYear, custom)
/// - Le filtre jardin s'il est actif (sinon tous les jardins)
///
/// Utilise exactement la même logique de filtrage que totalEconomyKpiProvider
final top3PlantsValueRankingProvider = Provider<List<PlantValueRanking>>((ref) {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);

  // Calculer les dates effectives selon la période sélectionnée
  final (startDate, endDate) = filters.getEffectiveDates();

  // Récupérer les enregistrements selon les filtres (même logique que totalEconomyKpiProvider)
  List<dynamic> filteredRecords;

  if (filters.selectedGardenIds.isNotEmpty) {
    // Filtrer par liste de jardins ET par période
    filteredRecords = harvestRecordsState.records.where((record) {
      final inGarden = filters.selectedGardenIds.contains(record.gardenId);
      final inPeriod =
          !record.date.isBefore(startDate) && !record.date.isAfter(endDate);
      return inGarden && inPeriod;
    }).toList();
  } else {
    // Filtrer seulement par période (tous les jardins)
    filteredRecords = harvestRecordsState.records
        .where((record) =>
            !record.date.isBefore(startDate) && !record.date.isAfter(endDate))
        .toList();
  }

  if (filteredRecords.isEmpty) return [];

  // Grouper par nom de plante et calculer la valeur totale par plante
  final Map<String, double> plantValues = {};

  for (final record in filteredRecords) {
    final plantName = record.plantName ?? 'Plante inconnue';
    final currentValue = plantValues[plantName] ?? 0.0;
    plantValues[plantName] = currentValue + record.totalValue;
  }

  // Convertir en liste de PlantValueRanking et trier par valeur décroissante
  final rankings = plantValues.entries
      .map((entry) => PlantValueRanking(
            plantName: entry.key,
            totalValue: entry.value,
          ))
      .toList();

  // Trier par valeur décroissante et prendre le top 3
  rankings.sort((a, b) => b.totalValue.compareTo(a.totalValue));

  return rankings.take(3).toList();
});
