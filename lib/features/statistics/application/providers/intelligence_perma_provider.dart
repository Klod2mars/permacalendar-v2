import 'package:riverpod/riverpod.dart';
import '../../../harvest/application/harvest_records_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../../../core/services/plant_catalog_service.dart';
import '../../../../core/models/plant.dart';
import 'nutrition_radar_provider.dart';

class PlantSuggestion {
  final Plant plant;
  final String reason; // e.g. "Riche en Fer & Compagnon de Tomate"
  final String nutrient; // e.g. "Fer"

  PlantSuggestion({required this.plant, required this.reason, required this.nutrient});
}

final intelligencePermaProvider = FutureProvider<List<PlantSuggestion>>((ref) async {
  // 1. Analyser les carences via le Radar
  final radarData = await ref.watch(nutritionRadarProvider.future);
  
  // Identifier le score le plus bas
  final scores = {
    'Protéines': radarData.proteinScore,
    'Fibres': radarData.fiberScore,
    'Vitamines': radarData.vitaminScore,
    'Minéraux': radarData.mineralScore,
  };
  
  // Trouver la catégorie la plus faible
  var lowestCategory = scores.entries.first;
  for (final entry in scores.entries) {
    if (entry.value < lowestCategory.value) {
      lowestCategory = entry;
    }
  }
  
  // Si tout est > 100%, pas de carence majeure, mais on peut toujours optimiser
  // On va cibler plus précisément quel nutriment manque dans cette catégorie
  // Pour simplifier, on cherche juste une plante riche en "Protéine" ou "Fer" (si Minéraux est bas)
  
  // NOTE: Pour faire mieux, il faudrait que nutritionRadarProvider expose le détail des minéraux/vitamines.
  // Ici on va faire une approximation basée sur la catégorie.
  
  String targetNutrientLabel = lowestCategory.key;
  // Mappage vers clés JSON approximatif pour la recherche
  List<String> targetJsonKeys = [];
  
  switch (targetNutrientLabel) {
    case 'Protéines': targetJsonKeys = ['proteinG']; break;
    case 'Fibres': targetJsonKeys = ['fiberG']; break;
    case 'Vitamines': targetJsonKeys = ['vitaminCmg', 'vitaminAmcg', 'vitaminB9ug']; break; // Top vitamines
    case 'Minéraux': targetJsonKeys = ['ironMg', 'magnesiumMg', 'calciumMg']; break;
  }

  // 2. Identifier les plantes du jardin (pour le compagnonnage)
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final filters = ref.watch(statisticsFiltersProvider);
  final (startDate, endDate) = filters.getEffectiveDates();
  
  final myPlantIds = harvestRecordsState.records
      .where((r) => r.date.isAfter(startDate) && r.date.isBefore(endDate))
      .map((r) => r.plantId)
      .toSet();
      
  final allPlants = await PlantCatalogService.loadPlants();
  final myPlants = allPlants.where((p) => myPlantIds.contains(p.id)).toList();

  // 3. Chercher des candidats
  List<PlantSuggestion> suggestions = [];
  
  for (final candidate in allPlants) {
    if (myPlantIds.contains(candidate.id)) continue; // Déjà cultivée
    
    // Check Richesse nutritionnelle
    bool isRich = false;
    String richReason = '';
    
    for (final key in targetJsonKeys) {
      final val = (candidate.nutritionPer100g[key] as num?)?.toDouble() ?? 0.0;
      // Seuils arbitraires de "Richesse"
      if (key == 'proteinG' && val > 3.0) { isRich = true; richReason = 'Riche en Protéines'; }
      if (key == 'fiberG' && val > 3.0) { isRich = true; richReason = 'Riche en Fibres'; }
      if (key == 'vitaminCmg' && val > 50) { isRich = true; richReason = 'Riche en Vitamine C'; }
      if (key == 'ironMg' && val > 2.0) { isRich = true; richReason = 'Riche en Fer'; }
      // ... autres règles
    }
    
    // Fallback générique si pas de règle spécifique (on prend juste les max du catalogue ?)
    // Pour l'instant on reste simple.
    
    if (isRich) {
      // Check Compagnonnage
      // Cherche si ce candidat est bénéfique pour une de mes plantes
      for (final myPlant in myPlants) {
        // Est-ce que candidate est listé dans beneficial de myPlant ?
        // Ou myPlant dans beneficial de candidate ?
        
        // Le sens du compagnonnage : A aide B.
        // Si je plante A (candidate), elle aide B (myPlant).
        // Check candidate.companionPlanting['beneficial'] contains myPlant.commonName (ou ID mais JSON use commonName usually lowercase)
        
        final beneficials = candidate.beneficialCompanions.map((s) => s.toLowerCase()).toList();
        // Matching flou par nom commun
        if (beneficials.contains(myPlant.commonName.toLowerCase())) {
          suggestions.add(PlantSuggestion(
            plant: candidate, 
            reason: '$richReason & Ami de ${myPlant.commonName}',
            nutrient: targetNutrientLabel
          ));
          break; // Un seul match suffit
        }
      }
    }
  }
  
  // Trier par nombre de matchs ou autre ? On prend les 3 premiers
  return suggestions.take(3).toList();
});
