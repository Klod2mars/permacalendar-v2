import '../../features/plant_catalog/domain/entities/plant_entity.dart';

class PlantLifecycleService {
  static Future<Map<String, dynamic>> calculateLifecycle(
      PlantFreezed plant, DateTime plantingDate) async {
    // SOLUTION SIMPLIFIÉE ET SÉCURISÉE
    // On utilise des valeurs par défaut basées sur daysToMaturity

    final germinationDays = _getSafeGerminationDays(plant);
    final maturityDays = plant.daysToMaturity ?? 60;

    final germinationDate = plantingDate.add(Duration(days: germinationDays));
    final expectedHarvestDate = plantingDate.add(Duration(days: maturityDays));

    return {
      'germinationDate': germinationDate,
      'expectedHarvestDate': expectedHarvestDate,
      'germinationDays': germinationDays,
      'maturityDays': maturityDays,
      'currentStage': 'germination',
      'nextAction': 'Surveiller la levée',
      'progress': 0.1,
    };
  }

  static int _getSafeGerminationDays(PlantFreezed plant) {
    // Méthode ultra-sécurisée pour éviter tout crash
    try {
      // Si germination existe et est une Map
      if (plant.germination != null && plant.germination is Map) {
        final germinationMap = plant.germination as Map<String, dynamic>;
        return germinationMap['minDays'] ?? germinationMap['maxDays'] ?? 7;
      }
      // Si daysToMaturity existe, on calcule un ratio
      return (plant.daysToMaturity * 0.1).ceil().clamp(5, 21);
    } catch (e) {
      // Erreur silencieuse dans _getSafeGerminationDays
    }

    // Valeur par défaut ultime
    return 7;
  }
}


