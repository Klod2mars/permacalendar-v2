import 'package:riverpod/riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../harvest/application/harvest_records_provider.dart';
import '../../../../../core/models/planting.dart';
import '../../../../../core/models/planting_hive.dart';
import '../../../domain/models/seasonal_performance.dart';
import '../../../presentation/providers/statistics_filters_provider.dart';

/// Provider pour les données brutes de performance saisonnière
///
/// Ce provider calcule les métriques de performance par saison (année) :
/// - Nombre total de cultures lancées
/// - Nombre de cultures achevées
/// - Durée moyenne de maturation
/// - Valeur totale des récoltes
/// - Rendement moyen par culture
/// - Taux de complétion
final seasonalPerformanceRawDataProvider =
    FutureProvider<Map<int, SeasonalPerformance>>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);

  // S'assurer que les boîtes Hive sont ouvertes
  Box<Planting>? plantingBox;
  Box<PlantingHive>? plantingHiveBox;

  try {
    plantingBox = await Hive.openBox<Planting>('plantings');
  } catch (e) {
    // Si la boîte n'existe pas ou ne peut pas être ouverte, on continue sans
    plantingBox = null;
  }

  try {
    plantingHiveBox = await Hive.openBox<PlantingHive>('planting_hive');
  } catch (e) {
    // Si la boîte n'existe pas ou ne peut pas être ouverte, on continue sans
    plantingHiveBox = null;
  }

  // Grouper les récoltes par année
  final Map<int, List<dynamic>> harvestsByYear = {};
  final Map<int, List<dynamic>> plantingsByYear = {};

  // Filtrer les récoltes selon les filtres
  final (startDate, endDate) = filters.getEffectiveDates();

  for (final record in harvestRecordsState.records) {
    // Appliquer le filtre de jardin si spécifié
    if (filters.selectedGardenId != null &&
        filters.selectedGardenId!.isNotEmpty &&
        record.gardenId != filters.selectedGardenId) {
      continue;
    }

    // Appliquer le filtre de période
    if (record.date.isAfter(startDate) && record.date.isBefore(endDate)) {
      final year = record.date.year;
      harvestsByYear.putIfAbsent(year, () => []).add(record);
    }
  }

  // Grouper les plantations par année de plantation
  if (plantingBox != null) {
    for (final planting in plantingBox.values) {
      // Appliquer le filtre de jardin si spécifié
      if (filters.selectedGardenId != null &&
          filters.selectedGardenId!.isNotEmpty) {
        // Note: Planting n'a pas de gardenId direct, on utilise gardenBedId
        // On pourrait filtrer par gardenBedId si nécessaire
      }

      final year = planting.plantedDate.year;
      plantingsByYear.putIfAbsent(year, () => []).add(planting);
    }
  }

  // Ajouter aussi les plantations de PlantingHive
  if (plantingHiveBox != null) {
    for (final plantingHive in plantingHiveBox.values) {
      final year = plantingHive.plantingDate.year;
      plantingsByYear.putIfAbsent(year, () => []).add(plantingHive);
    }
  }

  // Calculer les métriques par année
  final Map<int, SeasonalPerformance> performanceByYear = {};

  for (final year in harvestsByYear.keys.toSet()
    ..addAll(plantingsByYear.keys)) {
    final harvests = harvestsByYear[year] ?? [];
    final plantings = plantingsByYear[year] ?? [];

    // Nombre total de cultures lancées (plantations)
    final totalCulturesStarted = plantings.length;

    // Nombre de cultures achevées (récoltes)
    final totalCulturesCompleted = harvests.length;

    // Calculer la durée moyenne de maturation
    double totalMaturationDuration = 0.0;
    int validMaturationCount = 0;

    for (final harvest in harvests) {
      // Chercher la plantation correspondante
      Planting? correspondingPlanting;

      for (final planting in plantings) {
        if (planting is Planting) {
          if (planting.plantId == harvest.plantId &&
              planting.actualHarvestDate != null) {
            correspondingPlanting = planting;
            break;
          }
        } else if (planting is PlantingHive) {
          if (planting.plantId == harvest.plantId) {
            // Pour PlantingHive, on ne peut pas calculer la durée exacte
            // car on n'a pas la date de récolte réelle
            continue;
          }
        }
      }

      if (correspondingPlanting != null &&
          correspondingPlanting.actualHarvestDate != null) {
        final duration = correspondingPlanting.actualHarvestDate!
            .difference(correspondingPlanting.plantedDate)
            .inDays;
        totalMaturationDuration += duration;
        validMaturationCount++;
      }
    }

    final averageMaturationDuration = validMaturationCount > 0
        ? totalMaturationDuration / validMaturationCount
        : 0.0;

    // Calculer la valeur totale des récoltes
    final totalHarvestValue =
        harvests.fold(0.0, (sum, harvest) => sum + harvest.totalValue);

    // Calculer le rendement moyen par culture
    final averageYieldPerCulture = harvests.isNotEmpty
        ? harvests.fold(0.0, (sum, harvest) => sum + harvest.weight) /
            harvests.length
        : 0.0;

    // Calculer le taux de complétion
    final completionRate = totalCulturesStarted > 0
        ? totalCulturesCompleted / totalCulturesStarted
        : 0.0;

    performanceByYear[year] = SeasonalPerformance(
      year: year,
      totalCulturesStarted: totalCulturesStarted,
      totalCulturesCompleted: totalCulturesCompleted,
      averageMaturationDuration: averageMaturationDuration,
      totalHarvestValue: totalHarvestValue,
      averageYieldPerCulture: averageYieldPerCulture,
      completionRate: completionRate,
    );
  }

  return performanceByYear;
});


