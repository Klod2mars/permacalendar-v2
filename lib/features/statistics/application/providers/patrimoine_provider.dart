import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../../harvest/application/harvest_records_provider.dart';

/// Provider pour préparer les données du jardin à l'export (Format JSON)
///
/// Ce provider agrège :
/// - Les informations du jardin sélectionné (ou tous)
/// - L'historique des récoltes
/// - (Futur) L'historique des actions, le plan de culture, etc.
final exportGardenDataProvider = FutureProvider<String>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);

  // Attendre le chargement des données
  if (harvestRecordsState.isLoading) {
    throw Exception('Chargement des données en cours...');
  }

  // Récupérer les données brutes
  final records = harvestRecordsState.records;

  // Filtrer si un jardin spécifique est sélectionné
  final gardenId = filters.selectedGardenId;
  final gardenRecords = (gardenId != null && gardenId.isNotEmpty)
      ? records.where((r) => r.gardenId == gardenId).toList()
      : records;

  // Construire la structure de l'export
  final exportData = {
    'exportDate': DateTime.now().toIso8601String(),
    'gardenId': gardenId ?? 'all_gardens',
    'stats': {
      'totalHarvestCount': gardenRecords.length,
      'totalValue': gardenRecords.fold(0.0, (sum, r) => sum + r.totalValue),
      'totalWeight': gardenRecords.fold(0.0, (sum, r) => sum + r.weight),
    },
    'records': gardenRecords
        .map((r) => {
              'date': r.date.toIso8601String(),
              'plantId': r.plantId,
              'plantName': r.plantName,
              'weight': r.weight,
              'unit': 'kg', // Standardisation interne
              'quality': r.qualityRating,
              'marketPrice': r.marketPriceAtHarvest,
              'calculatedValue': r.totalValue,
              'notes': r.notes,
            })
        .toList(),
  };

  // Convertir en JSON indenté pour lisibilité
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(exportData);
});
