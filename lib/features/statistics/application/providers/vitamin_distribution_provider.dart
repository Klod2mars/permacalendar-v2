import 'package:riverpod/riverpod.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../../../core/services/plant_catalog_service.dart';

/// Provider pour le KPI "Distribution vitaminique" du pilier Santé
///
/// Ce provider calcule la répartition des apports en vitamines selon :
/// - Le filtre période sélectionné (today, last7Days, last30Days, currentYear, custom)
/// - Le filtre jardin s'il est actif (sinon tous les jardins)
///
/// Formule : (total récolté en kg) Ã— (valeur nutritionnelle par 100g) Ã— 10
///
/// Retourne un Map avec les totaux en unités appropriées :
/// - vitaminA, vitaminB9, vitaminK : en microgrammes (Âµg)
/// - vitaminC, vitaminE : en milligrammes (mg)
final vitaminDistributionProvider =
    FutureProvider<Map<String, double>>((ref) async {
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

  if (filters.selectedGardenId != null &&
      filters.selectedGardenId!.isNotEmpty) {
    // Filtrer par jardin ET par période
    filteredRecords = harvestRecordsState.records.where((record) {
      final inGarden = record.gardenId == filters.selectedGardenId;
      final inPeriod =
          record.date.isAfter(startDate) && record.date.isBefore(endDate);
      return inGarden && inPeriod;
    }).toList();
  } else {
    // Filtrer seulement par période (tous les jardins)
    filteredRecords = harvestRecordsState.records
        .where((record) =>
            record.date.isAfter(startDate) && record.date.isBefore(endDate))
        .toList();
  }

  if (filteredRecords.isEmpty) {
    return {
      'vitaminA': 0.0,
      'vitaminB9': 0.0,
      'vitaminC': 0.0,
      'vitaminE': 0.0,
      'vitaminK': 0.0,
    };
  }

  // Charger le catalogue de plantes
  final plants = await PlantCatalogService.loadPlants();

  // Initialiser les totaux vitaminiques
  double totalVitaminA = 0.0; // Âµg
  double totalVitaminB9 = 0.0; // Âµg
  double totalVitaminC = 0.0; // mg
  double totalVitaminE = 0.0; // mg
  double totalVitaminK = 0.0; // Âµg

  // Calculer les apports vitaminiques pour chaque récolte
  for (final record in filteredRecords) {
    // Trouver la plante correspondante
    final plant = plants.firstWhere(
      (p) => p.id == record.plantId,
      orElse: () => throw Exception('Plant not found: ${record.plantId}'),
    );

    // Récupérer les valeurs nutritionnelles par 100g
    final nutrition = plant.nutritionPer100g;
    if (nutrition.isEmpty) continue;

    // Appliquer la formule : (poids en kg) Ã— (valeur par 100g) Ã— 10
    final multiplier = record.weight * 10;

    // Accumuler les vitamines (unités conservées)
    totalVitaminA +=
        ((nutrition['vitaminAmcg'] as num?)?.toDouble() ?? 0.0) * multiplier;
    totalVitaminB9 +=
        ((nutrition['vitaminB9ug'] as num?)?.toDouble() ?? 0.0) * multiplier;
    totalVitaminC +=
        ((nutrition['vitaminCmg'] as num?)?.toDouble() ?? 0.0) * multiplier;
    totalVitaminE +=
        ((nutrition['vitaminEmg'] as num?)?.toDouble() ?? 0.0) * multiplier;
    totalVitaminK +=
        ((nutrition['vitaminK1mcg'] as num?)?.toDouble() ?? 0.0) * multiplier;
  }

  return {
    'vitaminA': totalVitaminA,
    'vitaminB9': totalVitaminB9,
    'vitaminC': totalVitaminC,
    'vitaminE': totalVitaminE,
    'vitaminK': totalVitaminK,
  };
});

/// Provider pour obtenir les pourcentages de distribution vitaminique
///
/// Convertit les totaux absolus en pourcentages pour l'affichage du camembert
final vitaminDistributionPercentagesProvider =
    FutureProvider<Map<String, double>>((ref) async {
  final vitaminTotals = await ref.watch(vitaminDistributionProvider.future);

  // Calculer le total général
  final total = vitaminTotals.values.fold(0.0, (sum, value) => sum + value);

  if (total == 0.0) {
    return {
      'vitaminA': 0.0,
      'vitaminB9': 0.0,
      'vitaminC': 0.0,
      'vitaminE': 0.0,
      'vitaminK': 0.0,
    };
  }

  // Convertir en pourcentages
  return {
    'vitaminA': (vitaminTotals['vitaminA']! / total) * 100,
    'vitaminB9': (vitaminTotals['vitaminB9']! / total) * 100,
    'vitaminC': (vitaminTotals['vitaminC']! / total) * 100,
    'vitaminE': (vitaminTotals['vitaminE']! / total) * 100,
    'vitaminK': (vitaminTotals['vitaminK']! / total) * 100,
  };
});


