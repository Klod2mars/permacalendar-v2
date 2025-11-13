import 'package:riverpod/riverpod.dart';
import '../../domain/models/vitamin_suggestion.dart';
import 'vitamin_distribution_provider.dart';
import '../../../../core/services/plant_catalog_service.dart';
import '../../../../core/models/plant.dart';

/// Provider pour les recommandations de plantes pour rééquilibrer les carences vitaminiques
///
/// Ce provider analyse les carences détectées dans la distribution vitaminique
/// et propose 3 plantes pour rééquilibrer les apports selon les règles :
///
/// - Un seul déficit dominant â†’ 3 plantes riches en cette vitamine
/// - Deux déficits â†’ 2 plantes riches en la plus basse + 1 pour la suivante
/// - Trois déficits â†’ 1 plante par vitamine (3 plantes = 3 vitamines)
/// - 4 ou 5 déficits â†’ ne garder que les 3 plus bas
final vitaminRecommendationProvider =
    FutureProvider<List<VitaminSuggestion>>((ref) async {
  final vitaminDistribution =
      await ref.watch(vitaminDistributionProvider.future);

  // Charger le catalogue de plantes
  final plants = await PlantCatalogService.loadPlants();

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

  // Générer les suggestions selon les règles
  if (vitaminsToAddress.length == 1) {
    // Un seul déficit â†’ 3 plantes riches en cette vitamine
    final vitamin = vitaminsToAddress[0];
    final richPlants = _getPlantsRichInVitamin(plants, vitamin);
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
    // Deux déficits â†’ 2 plantes pour la plus basse + 1 pour la suivante
    final primaryVitamin = vitaminsToAddress[0];
    final secondaryVitamin = vitaminsToAddress[1];

    // 2 plantes pour la vitamine la plus déficitaire
    final primaryPlants = _getPlantsRichInVitamin(plants, primaryVitamin);
    for (int i = 0; i < 2 && i < primaryPlants.length; i++) {
      final plant = primaryPlants[i];
      final vitaminValue = _getVitaminValue(plant, primaryVitamin);
      suggestions.add(VitaminSuggestion(
        plant: plant,
        vitaminKey: primaryVitamin,
        vitaminValue: vitaminValue,
      ));
    }

    // 1 plante pour la vitamine secondaire
    final secondaryPlants = _getPlantsRichInVitamin(plants, secondaryVitamin);
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
    // Trois déficits ou plus â†’ 1 plante par vitamine
    for (final vitamin in vitaminsToAddress) {
      final richPlants = _getPlantsRichInVitamin(plants, vitamin);
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

/// Trouve les plantes les plus riches en une vitamine donnée
List<Plant> _getPlantsRichInVitamin(List<Plant> plants, String vitamin) {
  final plantsWithVitamin = <Plant>[];

  for (final plant in plants) {
    final nutrition = plant.nutritionPer100g;
    if (nutrition.isEmpty) continue;

    final vitaminValue = _getVitaminValue(plant, vitamin);
    if (vitaminValue > 0) {
      plantsWithVitamin.add(plant);
    }
  }

  // Trier par valeur décroissante
  plantsWithVitamin.sort((a, b) {
    final valueA = _getVitaminValue(a, vitamin);
    final valueB = _getVitaminValue(b, vitamin);
    return valueB.compareTo(valueA);
  });

  return plantsWithVitamin;
}

/// Récupère la valeur d'une vitamine pour une plante donnée
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


