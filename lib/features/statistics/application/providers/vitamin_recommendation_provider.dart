import 'package:riverpod/riverpod.dart';
import '../../domain/models/vitamin_suggestion.dart';
import 'vitamin_distribution_provider.dart';
import '../../../../core/services/plant_catalog_service.dart';
import '../../../../core/models/plant.dart';
import '../../../harvest/application/harvest_records_provider.dart';

/// Provider pour les recommandations de plantes pour rééquilibrer les carences vitaminiques
///
/// Ce provider analyse les carences détectées dans la distribution vitaminique
/// et propose 3 plantes pour rééquilibrer les apports, en priorisant les plantes
/// qui sont des compagnons bénéfiques pour les cultures déjà présentes au jardin.
final vitaminRecommendationProvider =
    FutureProvider<List<VitaminSuggestion>>((ref) async {
  final vitaminDistribution =
      await ref.watch(vitaminDistributionProvider.future);

  // Charger le catalogue de plantes
  final plants = await PlantCatalogService.loadPlants();
  
  // Récupérer l'historique des récoltes pour identifier le contexte du jardin
  final harvestRecordsState = ref.watch(harvestRecordsProvider);
  final Set<String> gardenPlantCommonNames = {};

  if (!harvestRecordsState.isLoading && harvestRecordsState.records.isNotEmpty) {
     for (final record in harvestRecordsState.records) {
       if (record.plantName != null) {
         gardenPlantCommonNames.add(record.plantName!);
       } else {
          final plant = plants.where((p) => p.id == record.plantId).firstOrNull;
          if (plant != null) {
            gardenPlantCommonNames.add(plant.commonName);
          }
       }
     }
  }

  // Créer une liste des vitamines avec leurs valeurs
  final vitaminEntries = [
    MapEntry('A', vitaminDistribution['vitaminA']!),
    MapEntry('B', vitaminDistribution['vitaminB9']!),
    MapEntry('C', vitaminDistribution['vitaminC']!),
    MapEntry('E', vitaminDistribution['vitaminE']!),
    MapEntry('K', vitaminDistribution['vitaminK']!),
  ];

  // Trier par valeur croissante pour identifier les carences
  vitaminEntries.sort((a, b) => a.value.compareTo(b.value));

  // Identifier les vitamines déficitaires (valeurs les plus faibles)
  final deficientVitamins = <String>[];

  // Calculer le seuil de carence (moyenne des valeurs)
  final totalValue =
      vitaminEntries.fold(0.0, (sum, entry) => sum + entry.value);
  final averageValue = totalValue / vitaminEntries.length;

  // Considérer comme déficitaire si la valeur est inférieure à 50% de la moyenne
  for (final entry in vitaminEntries) {
    if (entry.value < averageValue * 0.5) {
      deficientVitamins.add(entry.key);
    }
  }

  // Si aucune carence détectée, retourner une liste vide
  if (deficientVitamins.isEmpty) {
    return [];
  }

  // Limiter à 3 vitamines déficitaires maximum
  final vitaminsToAddress = deficientVitamins.take(3).toList();

  final suggestions = <VitaminSuggestion>[];

  // --- LOGIQUE DE SCORING INTERNE ---
  
  double _getVitaminValue(Plant plant, String vitamin) {
    final nutrition = plant.nutritionPer100g;
    if (nutrition.isEmpty) return 0.0;
  
    switch (vitamin) {
      case 'A':
        return (nutrition['vitaminAmcg'] as num?)?.toDouble() ?? 0.0;
      case 'B':
        return (nutrition['vitaminB9ug'] as num?)?.toDouble() ?? 0.0;
      case 'C':
        return (nutrition['vitaminCmg'] as num?)?.toDouble() ?? 0.0;
      case 'E':
        return (nutrition['vitaminEmg'] as num?)?.toDouble() ?? 0.0;
      case 'K':
        return (nutrition['vitaminK1mcg'] as num?)?.toDouble() ?? 0.0;
      default:
        return 0.0;
    }
  }

  double scorePlant(Plant plant, String vitamin) {
    double score = _getVitaminValue(plant, vitamin);
    
    // Bonus si la plante est compagne d'une plante du jardin
    bool isCompanion = false;
    for (final gardenPlantName in gardenPlantCommonNames) {
      if (plant.beneficialCompanions.contains(gardenPlantName)) {
        isCompanion = true;
        break;
      }
    }

    if (isCompanion) {
      score *= 1.5; // Bonus de +50% pour les compagnons
    }
    
    return score;
  }

  List<Plant> getRichPlants(String vitamin) {
      final candidates = <Plant>[];
      for (final plant in plants) {
        if (_getVitaminValue(plant, vitamin) > 0) {
          candidates.add(plant);
        }
      }
      // Tri par score (Nutriments + Bonus Compagnon)
      candidates.sort((a, b) {
        return scorePlant(b, vitamin).compareTo(scorePlant(a, vitamin));
      });
      return candidates;
  }

  // --- GENERATION DES SUGGESTIONS ---

  if (vitaminsToAddress.length == 1) {
    // Un seul déficit -> 3 plantes
    final vitamin = vitaminsToAddress[0];
    final richPlants = getRichPlants(vitamin);
    for (int i = 0; i < 3 && i < richPlants.length; i++) {
      final plant = richPlants[i];
      final vitaminValue = _getVitaminValue(plant, vitamin);
      suggestions.add(VitaminSuggestion(
        plant: plant,
        vitaminKey: vitamin,
        vitaminValue: vitaminValue,
      ));
    }
  } else if (vitaminsToAddress.length == 2) {
    // Deux déficits -> 2 + 1
    final primaryVitamin = vitaminsToAddress[0];
    final secondaryVitamin = vitaminsToAddress[1];

    final primaryPlants = getRichPlants(primaryVitamin);
    for (int i = 0; i < 2 && i < primaryPlants.length; i++) {
      final plant = primaryPlants[i];
      final vitaminValue = _getVitaminValue(plant, primaryVitamin);
      suggestions.add(VitaminSuggestion(
        plant: plant,
        vitaminKey: primaryVitamin,
        vitaminValue: vitaminValue,
      ));
    }

    final secondaryPlants = getRichPlants(secondaryVitamin);
    if (secondaryPlants.isNotEmpty) {
      final plant = secondaryPlants[0];
      final vitaminValue = _getVitaminValue(plant, secondaryVitamin);
      suggestions.add(VitaminSuggestion(
        plant: plant,
        vitaminKey: secondaryVitamin,
        vitaminValue: vitaminValue,
      ));
    }
  } else {
    // Trois déficits+ -> 1 par vitamine
    for (final vitamin in vitaminsToAddress) {
      final richPlants = getRichPlants(vitamin);
      if (richPlants.isNotEmpty) {
        final plant = richPlants[0];
        final vitaminValue = _getVitaminValue(plant, vitamin);
        suggestions.add(VitaminSuggestion(
          plant: plant,
          vitaminKey: vitamin,
          vitaminValue: vitaminValue,
        ));
      }
    }
  }

  return suggestions;
});
