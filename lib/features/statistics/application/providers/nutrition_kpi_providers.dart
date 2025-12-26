import 'package:riverpod/riverpod.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';

// --- TOP HEALERS (Guérisseurs) ---

class HealerPlant {
  final String plantName;
  final String plantId;
  final String mainBenefit; // Ex: "Immunité (Vit C)"
  final double densityScore; // Score arbitraire de densité nutritive

  HealerPlant({
    required this.plantName,
    required this.plantId,
    required this.mainBenefit,
    required this.densityScore,
  });
}

final topHealersProvider = FutureProvider<List<HealerPlant>>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);
  final plantsList = ref.watch(plantsListProvider);

  if (harvestRecordsState.isLoading) return [];

  final (startDate, endDate) = filters.getEffectiveDates();
  
  // Filter records
  final filteredRecords = harvestRecordsState.records.where((record) {
    bool matchGarden = filters.selectedGardenIds.isEmpty || filters.selectedGardenIds.contains(record.gardenId);
    bool matchDate = !record.date.isBefore(startDate) && !record.date.isAfter(endDate);
    return matchGarden && matchDate;
  }).toList();

  if (filteredRecords.isEmpty) return [];

  // Group by plant to aggregate quantity (optional: here we just need to know WHICH plants were harvested to rank them by intrinsic quality)
  // OR: Rank based on what was harvested the most yielding the most nutrients?
  // User spec: "3 plantes récoltées ayant la plus forte densité nutritive". 
  // -> Focus on Intrinsic Density of harvested plants.

  // 1. Identification unique des plantes récoltées (IDs or Names)
  // We iterate over records instead of just IDs to handle the fallback matching logic properly
  // But to be efficient, we can get unique plants from the records list
  
  final Map<String, HealerPlant> uniqueHealers = {};

  for (final record in filteredRecords) {
      if (uniqueHealers.containsKey(record.plantId)) continue;
      
      var plant = plantsList.where((p) => p.id == record.plantId).firstOrNull;
      if (plant == null && record.plantName != null) {
         plant = plantsList.where((p) => p.commonName.toLowerCase() == record.plantName!.toLowerCase()).firstOrNull;
      }
      
      if (plant == null || plant.nutritionPer100g == null) continue;

      // Ensure we don't process the same plant catalog entry twice (if matched by name vs id)
      if (uniqueHealers.containsKey(plant.id)) continue;
      
      final n = plant.nutritionPer100g!;

    // Calcul score densité simple : Somme des % AJR pour 100g
    // On prend quelques marqueurs clés
    double vitC = ((n['vitaminCmg'] as num?)?.toDouble() ?? 0) / 90.0 * 100;
    double vitA = ((n['vitaminAmcg'] as num?)?.toDouble() ?? 0) / 900.0 * 100;
    double iron = ((n['ironMg'] as num?)?.toDouble() ?? 0) / 18.0 * 100;
    double fiber = ((n['fiberG'] as num?)?.toDouble() ?? 0) / 30.0 * 100;

    double density = vitC + vitA + iron + fiber;
    
    // Déterminer le bénéfice principal
    String benefit = 'Vitalité';
    double maxVal = 0;
    
    if (vitC > maxVal) { maxVal = vitC; benefit = 'Immunité (Vit C)'; }
    if (vitA > maxVal) { maxVal = vitA; benefit = 'Vision & Peau (Vit A)'; }
    if (iron > maxVal) { maxVal = iron; benefit = 'Énergie (Fer)'; }
    if (fiber > maxVal) { maxVal = fiber; benefit = 'Digestion (Fibres)'; }

    uniqueHealers[plant.id] = HealerPlant(
      plantName: plant.commonName,
      plantId: plant.id,
      mainBenefit: benefit,
      densityScore: density,
    );
  }

  List<HealerPlant> healers = uniqueHealers.values.toList();

  // Sort by Density Descending
  healers.sort((a, b) => b.densityScore.compareTo(a.densityScore));

  return healers.take(3).toList();
});


// --- DEFICIENCY DETECTOR ---

class NutrientDeficiency {
  final String nutrientName;
  final double currentCoveragePercent; // 0 to ... 100+
  final String suggestedCrop; 

  NutrientDeficiency({required this.nutrientName, required this.currentCoveragePercent, required this.suggestedCrop});
}

final deficiencyProvider = FutureProvider<List<NutrientDeficiency>>((ref) async {
  // Reuse logic from Radar to get detailed breakdowns? 
  // Or simpler: just check specific critical nutrients computed in Radar Logic is a bit circular.
  // For now, let's keep it simple and independent, or we could expose an intermediate "NutrientStats" object from the radar provider.
  // But Radar provider returns aggregated scores. We need granular scores here.

  // NOTE: In a real app, I'd refactor the calculation logic into a Service or Reposiotrya to avoid duplication.
  // Due to time constraints, I will duplicate the aggregation logic briefly or assume we want just a few generic checks.
  
  // Let's assume we want to check: Vit C, Iron, Omega-3 (if available, usually not in standard veggies except purslane), Magnesium.
  // Let's stick to Vit C, Iron, Magnesium.
  
  // ... (Aggregation Logic same as Radar to get totals) ...
  // For brevity in this specific file, I'll return mock/calculated data if time permits full re-implementation.
  // Let's do a fast re-calc.
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);
  final plantsList = ref.watch(plantsListProvider);

  if (harvestRecordsState.isLoading) return [];
  final (startDate, endDate) = filters.getEffectiveDates();
  final duration = endDate.difference(startDate).inDays + 1;

  // Filtrer
   final filteredRecords = harvestRecordsState.records.where((record) {
      final inGarden = filters.selectedGardenIds.isEmpty || filters.selectedGardenIds.contains(record.gardenId);
      final inPeriod = !record.date.isBefore(startDate) && !record.date.isAfter(endDate);
      return inGarden && inPeriod;
    }).toList();

  double totalVitC = 0;
  double totalIron = 0;
  double totalMg = 0;

  for (final record in filteredRecords) {
    var plant = plantsList.where((p) => p.id == record.plantId).firstOrNull;
    if (plant == null && record.plantName != null) {
      plant = plantsList.where((p) => p.commonName.toLowerCase() == record.plantName!.toLowerCase()).firstOrNull;
    }
    
    if (plant == null || plant.nutritionPer100g == null) continue;
    final n = plant.nutritionPer100g!;
    final portions = record.quantityKg * 10;
    
    totalVitC += ((n['vitaminCmg'] as num?)?.toDouble() ?? 0) * portions;
    totalIron += ((n['ironMg'] as num?)?.toDouble() ?? 0) * portions;
    totalMg += ((n['magnesiumMg'] as num?)?.toDouble() ?? 0) * portions;
  }

  double covC = (totalVitC / (90.0 * duration)) * 100;
  double covFe = (totalIron / (18.0 * duration)) * 100;
  double covMg = (totalMg / (400.0 * duration)) * 100;

  List<NutrientDeficiency> defs = [];

  if (covC < 50) defs.add(NutrientDeficiency(nutrientName: 'Vitamine C', currentCoveragePercent: covC, suggestedCrop: 'Ciboulette, Persil'));
  if (covFe < 50) defs.add(NutrientDeficiency(nutrientName: 'Fer', currentCoveragePercent: covFe, suggestedCrop: 'Épinards, Lentilles'));
  if (covMg < 50) defs.add(NutrientDeficiency(nutrientName: 'Magnésium', currentCoveragePercent: covMg, suggestedCrop: 'Bettes, Épinards'));

  return defs;
});
