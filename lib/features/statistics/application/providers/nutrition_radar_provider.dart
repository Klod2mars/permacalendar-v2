import 'package:riverpod/riverpod.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';

/// Modèle pour les données du Radar Chart (6 axes)
class NutritionRadarData {
  final double energyScore; // Calories/Joules
  final double proteinScore; // Protéines
  final double fiberScore; // Fibres
  final double vitaminScore; // Moyenne Vitamines (A, C, E, K, B9)
  final double mineralScore; // Moyenne Minéraux (Ca, Mg, Fe, K)
  final double antioxidantScore; // Score composite ou proxy (ex: Vit C + E + A)

  const NutritionRadarData({
    required this.energyScore,
    required this.proteinScore,
    required this.fiberScore,
    required this.vitaminScore,
    required this.mineralScore,
    required this.antioxidantScore,
  });

  // Factory pour données vides
  factory NutritionRadarData.empty() => const NutritionRadarData(
      energyScore: 0,
      proteinScore: 0,
      fiberScore: 0,
      vitaminScore: 0,
      mineralScore: 0,
      antioxidantScore: 0);
}

/// Provider pour les données du Radar Chart Nutritionnel
/// Calcule la "Couverture Moyenne des Besoins" sur la période.
/// Score 100 = 100% des AJR couverts pour 1 personne sur toute la durée de la période selected.
/// Ex: Sur 30 jours, il faut 30 * AJR. Si on a récolté ça, score = 100.
final nutritionRadarProvider = FutureProvider<NutritionRadarData>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);
  final plantsList = ref.watch(plantsListProvider); // Sync list from catalog

  if (harvestRecordsState.isLoading) throw Exception('Loading records...');

  // 1. Définir la période et le nombre de jours
  final (startDate, endDate) = filters.getEffectiveDates();
  final durationInDays =
      endDate.difference(startDate).inDays + 1; // +1 car inclusif

  // 2. Filtrer les récoltes
  final filteredRecords = harvestRecordsState.records.where((record) {
    // Si la liste est vide => tous les jardins sont inclus (ou aucun ? En général en stats empty = all pour le dashboard,
    // mais dans la logique définie précédemment : si empty dans filters => All)
    final inGarden = filters.selectedGardenIds.isEmpty ||
        filters.selectedGardenIds.contains(record.gardenId);
    final inPeriod =
        !record.date.isBefore(startDate) && !record.date.isAfter(endDate);
    return inGarden && inPeriod;
  }).toList();

  if (filteredRecords.isEmpty) return NutritionRadarData.empty();

  // 3. Accumulateurs (Total récolté en mg/mcg/g)
  double totalKcals = 0.0;
  double totalProteinG = 0.0;
  double totalFiberG = 0.0;

  // Vitamines
  double totalVitAmcg = 0.0;
  double totalVitCmg = 0.0;
  double totalVitEmg = 0.0;
  double totalVitKmcg = 0.0;
  double totalVitB9ug = 0.0;

  // Minéraux
  double totalCaMg = 0.0;
  double totalMgMg = 0.0;
  double totalFeMg = 0.0;
  double totalKMg = 0.0;

  for (final record in filteredRecords) {
    // A. Use Snapshot if available (Approach A)
    if (record.nutritionSnapshot != null &&
        record.nutritionSnapshot!.isNotEmpty) {
      final s = record.nutritionSnapshot!;
      totalKcals += s['calories_kcal'] ?? 0.0;
      totalProteinG += s['protein_g'] ?? 0.0;
      totalFiberG += s['fiber_g'] ?? 0.0;

      totalVitAmcg += s['vitamin_a_mcg'] ?? 0.0;
      totalVitCmg += s['vitamin_c_mg'] ?? 0.0;
      totalVitEmg += s['vitamin_e_mg'] ?? 0.0;
      totalVitKmcg += s['vitamin_k_mcg'] ?? 0.0;
      totalVitB9ug += s['vitamin_b9_mcg'] ?? 0.0;

      totalCaMg += s['calcium_mg'] ?? 0.0;
      totalMgMg += s['magnesium_mg'] ?? 0.0;
      totalFeMg += s['iron_mg'] ?? 0.0;
      totalKMg += s['potassium_mg'] ?? 0.0;
      continue;
    }

    // B. Fallback: Lookup plant manually
    // Retrouver la plante pour avoir ses datas nutri
    var plant = plantsList.where((p) => p.id == record.plantId).firstOrNull;

    // Fallback: lookup by name if ID fails
    if (plant == null && record.plantName != null) {
      plant = plantsList
          .where((p) =>
              p.commonName.toLowerCase() == record.plantName!.toLowerCase())
          .firstOrNull;
    }

    if (plant == null || plant.nutritionPer100g == null) continue;

    final n = plant.nutritionPer100g!;
    final portions = record.quantityKg * 10; // 1 kg = 10 portions de 100g

    // Accumulation
    totalKcals += ((n['calories'] ?? n['energyKcal']) as num?)?.toDouble() ??
        0.0 * portions;
    totalProteinG += ((n['proteinG'] as num?)?.toDouble() ?? 0.0) * portions;
    totalFiberG += ((n['fiberG'] as num?)?.toDouble() ?? 0.0) * portions;

    totalVitAmcg += ((n['vitaminAmcg'] as num?)?.toDouble() ?? 0.0) * portions;
    totalVitCmg += ((n['vitaminCmg'] as num?)?.toDouble() ?? 0.0) * portions;
    totalVitEmg += ((n['vitaminEmg'] as num?)?.toDouble() ?? 0.0) * portions;
    final k1 = (n['vitaminK1mcg'] as num?)?.toDouble() ?? 0.0;
    final k = (n['vitaminKmcg'] as num?)?.toDouble() ?? 0.0;
    totalVitKmcg += (k1 > 0 ? k1 : k) * portions; // Fallback
    totalVitB9ug += ((n['vitaminB9ug'] as num?)?.toDouble() ?? 0.0) * portions;

    totalCaMg += ((n['calciumMg'] as num?)?.toDouble() ?? 0.0) * portions;
    totalMgMg += ((n['magnesiumMg'] as num?)?.toDouble() ?? 0.0) * portions;
    totalFeMg += ((n['ironMg'] as num?)?.toDouble() ?? 0.0) * portions;
    totalKMg += ((n['potassiumMg'] as num?)?.toDouble() ?? 0.0) * portions;
  }

  // 4. Calcul des Besoins Totaux sur la Période (Reference: Adulte moyen)
  // AJR * Nombre de jours
  final needsFactor = durationInDays.toDouble();

  // AJR standards
  const driKcal = 2000.0;
  const driProtein = 50.0;
  const driFiber = 30.0;
  const driVitA = 900.0;
  const driVitC = 90.0;
  const driVitE = 15.0;
  const driVitK = 120.0;
  const driVitB9 = 400.0;
  const driCa = 1000.0;
  const driMg = 400.0;
  const driFe = 18.0; // Moyenne homme/femme fer
  const driK = 4700.0;

  // Calcul Scores (en %)
  // Formule: (TotalRécolté / (AJR * Jours)) * 100
  // On cap souvent à 100% ou plus pour montrer l'abondance. Ici on garde la vraie valeur.

  double calcScore(double total, double dri) {
    if (needsFactor == 0) return 0;
    return (total / (dri * needsFactor)) * 100;
  }

  final sEnergy = calcScore(totalKcals, driKcal);
  final sProtein = calcScore(totalProteinG, driProtein);
  final sFiber = calcScore(totalFiberG, driFiber);

  final sVitA = calcScore(totalVitAmcg, driVitA);
  final sVitC = calcScore(totalVitCmg, driVitC);
  final sVitE = calcScore(totalVitEmg, driVitE);
  final sVitK = calcScore(totalVitKmcg, driVitK);
  final sVitB9 = calcScore(totalVitB9ug, driVitB9);

  // Moyenne des vitamines pour l'axe "Vitamines"
  final sVitamins = (sVitA + sVitC + sVitE + sVitK + sVitB9) / 5;

  final sCa = calcScore(totalCaMg, driCa);
  final sMg = calcScore(totalMgMg, driMg);
  final sFe = calcScore(totalFeMg, driFe);
  final sK = calcScore(totalKMg, driK);

  // Moyenne des minéraux pour l'axe "Minéraux"
  final sMinerals = (sCa + sMg + sFe + sK) / 4;

  // Antioxidants: Principalement Vit C, E, et A.
  // On peut faire une moyenne pondérée ou simple de ces 3 là.
  final sAntioxidants = (sVitC + sVitE + sVitA) / 3;

  return NutritionRadarData(
    energyScore: sEnergy,
    proteinScore: sProtein,
    fiberScore: sFiber,
    vitaminScore: sVitamins,
    mineralScore: sMinerals,
    antioxidantScore: sAntioxidants,
  );
});
