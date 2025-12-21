import 'package:riverpod/riverpod.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../../../core/services/plant_catalog_service.dart';

/// Modèle pour les données du Radar Chart
class NutritionRadarData {
  final double proteinScore;
  final double fiberScore;
  final double vitaminScore;
  final double mineralScore;

  const NutritionRadarData({
    required this.proteinScore,
    required this.fiberScore,
    required this.vitaminScore,
    required this.mineralScore,
  });

  // Pour l'affichage, on peut normaliser sur 100 ou renvoyer les valeurs brutes (en % des AJR totaux sur la période)
  // Ici on renverra le cumul des % AJR, ce qui signifie que 100 = 1 jour de besoins couverts
}

/// Provider pour les données du Radar Chart Nutritionnel
/// Calcule les apports en % des Apports Journaliers Recommandés (AJR) cumulés
final nutritionRadarProvider = FutureProvider<NutritionRadarData>((ref) async {
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);

  if (harvestRecordsState.isLoading) throw Exception('Loading records...');
  if (harvestRecordsState.error != null) throw Exception('Error loading records');

  final (startDate, endDate) = filters.getEffectiveDates();

  List<dynamic> filteredRecords;
  if (filters.selectedGardenIds.isNotEmpty) {
     filteredRecords = harvestRecordsState.records.where((record) {
      final inGarden = filters.selectedGardenIds.contains(record.gardenId);
      final inPeriod = record.date.isAfter(startDate) && record.date.isBefore(endDate);
      return inGarden && inPeriod;
    }).toList();
  } else {
    filteredRecords = harvestRecordsState.records
        .where((record) => record.date.isAfter(startDate) && record.date.isBefore(endDate))
        .toList();
  }

  if (filteredRecords.isEmpty) {
    return const NutritionRadarData(proteinScore: 0, fiberScore: 0, vitaminScore: 0, mineralScore: 0);
  }

  final plants = await PlantCatalogService.loadPlants();

  // Accumulateurs de % AJR
  double accProtein = 0.0;
  double accFiber = 0.0;
  double accVitamins = 0.0;
  double accMinerals = 0.0;

  // Références AJR (Adulte moyen)
  const driProteinG = 50.0;
  const driFiberG = 30.0;
  
  // Vitamines
  const driVitAmcg = 900.0;
  const driVitCmg = 90.0;
  const driVitEmg = 15.0;
  const driVitKmcg = 120.0;
  const driVitB9ug = 400.0;

  // Minéraux
  const driCalciumMg = 1000.0;
  const driMagnesiumMg = 400.0;
  const driIronMg = 18.0;
  const driPotassiumMg = 4700.0;
  // const driManganeseMg = 2.3; // Souvent manquant, on se concentre sur les majeurs

  int vitaminCount = 0;
  int mineralCount = 0;

  for (final record in filteredRecords) {
    final plant = plants.firstWhere((p) => p.id == record.plantId, orElse: () => throw Exception('Plant not found'));
    final n = plant.nutritionPer100g;
    if (n.isEmpty) continue;

    // Poids en Hg (HectoGrammes = 100g units)
    // record.quantityKg * 10 = nombre de portions de 100g
    final portions = record.quantityKg * 10; 

    // Macronutriments
    final pG = (n['proteinG'] as num?)?.toDouble() ?? 0.0;
    final fG = (n['fiberG'] as num?)?.toDouble() ?? 0.0;
    
    accProtein += (pG * portions) / driProteinG * 100; // % AJR
    accFiber += (fG * portions) / driFiberG * 100; // % AJR

    // Vitamines (Somme des % AJR pondérés ?)
    // On additionne les contributions brutes en % AJR. 
    // Si j'ai mangé 100% de mes Vit C et 0% de Vit A, mon score Vitamines total augmente.
    // Pour éviter que l'un écrase l'autre dans un score unique, on fait la moyenne des % Cover ? 
    // Non, "Apports" suggère la quantité totale. On va sommer les % de couverture de chaque vitamine.
    
    double vScore = 0.0;
    vScore += ((n['vitaminAmcg'] as num?)?.toDouble() ?? 0.0) * portions / driVitAmcg;
    vScore += ((n['vitaminCmg'] as num?)?.toDouble() ?? 0.0) * portions / driVitCmg;
    vScore += ((n['vitaminEmg'] as num?)?.toDouble() ?? 0.0) * portions / driVitEmg;
    vScore += ((n['vitaminK1mcg'] as num?)?.toDouble() ?? 0.0) * portions / driVitKmcg; // json uses vitaminK1mcg or vitaminKmcg? Checked json: lettuce has vitaminK1mcg, rocket vitaminKmcg. Need check both.
    vScore += ((n['vitaminKmcg'] as num?)?.toDouble() ?? 0.0) * portions / driVitKmcg;
    vScore += ((n['vitaminB9ug'] as num?)?.toDouble() ?? 0.0) * portions / driVitB9ug;
    
    // On normalise arbitrairement par le nombre de vitamines trackées (5) pour avoir une échelle comparables aux macros (qui sont 1 seule dimension) ?
    // Non, Protein est 1 dimension. Vitamins sont 5. 100% Protein = 100. 100% de chaque Vitamine = 500.
    // Pour le Radar, il vaut mieux ramener ça à "Equivalent jours de nutrition complète".
    // Donc on divise par 5 pour les vitamines.
    accVitamins += (vScore / 5.0) * 100;

    // Minéraux
    double mScore = 0.0;
    mScore += ((n['calciumMg'] as num?)?.toDouble() ?? 0.0) * portions / driCalciumMg;
    mScore += ((n['magnesiumMg'] as num?)?.toDouble() ?? 0.0) * portions / driMagnesiumMg;
    mScore += ((n['ironMg'] as num?)?.toDouble() ?? 0.0) * portions / driIronMg;
    mScore += ((n['potassiumMg'] as num?)?.toDouble() ?? 0.0) * portions / driPotassiumMg;
    
    // Divisé par 4 minéraux trackés
    accMinerals += (mScore / 4.0) * 100;
  }

  return NutritionRadarData(
    proteinScore: accProtein,
    fiberScore: accFiber,
    vitaminScore: accVitamins,
    mineralScore: accMinerals,
  );
});
