
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../../core/services/nutrition_normalizer.dart';

/// Modèle de donnée pour une ligne de nutriment
class NutrientBarData {
  final String label;
  final String unit;
  final double totalValue;
  final double driPercentage; // 0..100+
  final double driTarget; // Valeur cible totale sur la période

  const NutrientBarData({
    required this.label,
    required this.unit,
    required this.totalValue,
    required this.driPercentage,
    required this.driTarget,
  });
}

/// Modèle complet groupé
class NutritionDetailedState {
  final List<NutrientBarData> macros;
  final List<NutrientBarData> vitamins;
  final List<NutrientBarData> minerals;

  const NutritionDetailedState({
    required this.macros,
    required this.vitamins,
    required this.minerals,
  });

  factory NutritionDetailedState.empty() => const NutritionDetailedState(
        macros: [],
        vitamins: [],
        minerals: [],
  );
}

final nutritionDetailedProvider = FutureProvider<NutritionDetailedState>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);
  final plantsList = ref.watch(plantsListProvider);

  if (harvestRecordsState.isLoading) throw Exception('Loading records...');

  // 1. Filtrage (Période & Jardin)
  final (startDate, endDate) = filters.getEffectiveDates();
  final durationInDays = endDate.difference(startDate).inDays + 1;
  
  final filteredRecords = harvestRecordsState.records.where((record) {
    final inGarden = filters.selectedGardenIds.isEmpty || filters.selectedGardenIds.contains(record.gardenId);
    final inPeriod = !record.date.isBefore(startDate) && !record.date.isAfter(endDate);
    return inGarden && inPeriod;
  }).toList();

  if (filteredRecords.isEmpty) return NutritionDetailedState.empty();

  // 2. Accumulateurs (Map key -> total)
  final totals = <String, double>{};

  for (final record in filteredRecords) {
    // A. Snapshot (Priorité)
    if (record.nutritionSnapshot != null && record.nutritionSnapshot!.isNotEmpty) {
      record.nutritionSnapshot!.forEach((key, val) {
        totals[key] = (totals[key] ?? 0.0) + val;
      });
      continue;
    }

    // B. Fallback (Calcul live via catalogue)
    var plant = plantsList.where((p) => p.id == record.plantId).firstOrNull;
    if (plant == null && record.plantName != null) {
      plant = plantsList.where((p) => p.commonName.toLowerCase() == record.plantName!.toLowerCase()).firstOrNull;
    }
    if (plant != null && plant.nutritionPer100g != null) {
      // On réutilise le service pour normaliser à la volée
      final snapshot = NutritionNormalizer.computeSnapshot(plant.nutritionPer100g, record.quantityKg);
      snapshot.forEach((key, val) {
        totals[key] = (totals[key] ?? 0.0) + val;
      });
    }
  }

  // 3. Définition des AJR (DRI) / jour
  // Source simplifiée (Adulte moyen)
  final dailyDri = <String, double>{
    'calories_kcal': 2000,
    'protein_g': 50,
    'carbs_g': 260,
    'fat_g': 70,
    'fiber_g': 30,
    
    'vitamin_a_mcg': 900,
    'vitamin_c_mg': 90,
    'vitamin_e_mg': 15,
    'vitamin_k_mcg': 120,
    'vitamin_b6_mg': 1.3,
    'vitamin_b9_mcg': 400, // Folates

    'calcium_mg': 1000,
    'magnesium_mg': 400,
    'iron_mg': 18, 
    'potassium_mg': 4700,
    'zinc_mg': 11,
    'manganese_mg': 2.3,
  };

  // 4. Construction des listes
  NutrientBarData buildBar(String key, String label, String unit) {
    final total = totals[key] ?? 0.0;
    final dailyTarget = dailyDri[key] ?? 1.0; 
    final periodTarget = dailyTarget * durationInDays;
    
    // Cap percentage visual logic might happen in UI, here we give raw %
    final pct = (periodTarget > 0) ? (total / periodTarget) * 100 : 0.0;
    
    return NutrientBarData(
      label: label,
      unit: unit,
      totalValue: total,
      driPercentage: pct,
      driTarget: periodTarget,
    );
  }

  final macros = [
    buildBar('calories_kcal', 'Énergie', 'kcal'),
    buildBar('protein_g', 'Protéines', 'g'),
    buildBar('carbs_g', 'Glucides', 'g'),
    buildBar('fat_g', 'Lipides', 'g'),
    buildBar('fiber_g', 'Fibres', 'g'),
  ];

  final vitamins = [
    buildBar('vitamin_a_mcg', 'Vitamine A', 'µg'),
    buildBar('vitamin_c_mg', 'Vitamine C', 'mg'),
    buildBar('vitamin_e_mg', 'Vitamine E', 'mg'),
    buildBar('vitamin_k_mcg', 'Vitamine K', 'µg'),
    buildBar('vitamin_b6_mg', 'Vitamine B6', 'mg'),
    buildBar('vitamin_b9_mcg', 'Vitamine B9', 'µg'),
  ];

  final minerals = [
    buildBar('calcium_mg', 'Calcium', 'mg'),
    buildBar('magnesium_mg', 'Magnésium', 'mg'),
    buildBar('iron_mg', 'Fer', 'mg'),
    buildBar('potassium_mg', 'Potassium', 'mg'),
    buildBar('zinc_mg', 'Zinc', 'mg'),
    buildBar('manganese_mg', 'Manganèse', 'mg'),
  ];

  return NutritionDetailedState(
    macros: macros,
    vitamins: vitamins,
    minerals: minerals,
  );
});
