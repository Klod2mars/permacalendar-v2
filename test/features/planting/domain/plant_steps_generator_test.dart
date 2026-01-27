import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/models/plant.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/features/planting/domain/plant_steps_generator.dart';

void main() {
  final plant = Plant(
    commonName: 'Tomate',
    scientificName: 'Solanum lycopersicum',
    family: 'Solanaceae',
    description: '',
    plantingSeason: 'Printemps',
    harvestSeason: 'Été',
    daysToMaturity: 90,
    spacing: 0.0,
    depth: 0.0,
    sunExposure: 'Plein soleil',
    waterNeeds: 'Moyen',
    sowingMonths: [],
    harvestMonths: [],
    marketPricePerKg: 0.0,
    defaultUnit: 'pièce',
    nutritionPer100g: {},
    germination: {
      'germinationTime': {'min': 7, 'max': 14}
    },
    growth: {},
    watering: {'amount': 'modéré'},
    thinning: {'daysAfterPlanting': 21, 'when': 'Après repiquage'},
    weeding: {},
    culturalTips: [],
    biologicalControl: {},
    harvestTime: '',
    companionPlanting: {},
    notificationSettings: {},
  );

  test('Semé => contient germination et éclaircissage', () {
    final plantingSeeded = Planting(
      gardenBedId: 'bed1',
      plantId: 'p1',
      plantName: 'Tomate',
      plantedDate: DateTime.now(),
      quantity: 2,
      status: 'Semé',
    );

    final steps = generateSteps(plant, plantingSeeded);
    expect(steps.any((s) => s.id == 'germination'), isTrue);
    expect(steps.any((s) => s.id == 'thinning'), isTrue);
  });

  test('Planté => n\'inclut pas germination ni éclaircissage', () {
    final plantingPlanted = Planting(
      gardenBedId: 'bed1',
      plantId: 'p1',
      plantName: 'Tomate',
      plantedDate: DateTime.now(),
      quantity: 2,
      status: 'Planté',
      metadata: {'initialGrowthPercent': 0.3},
    );

    final steps = generateSteps(plant, plantingPlanted);
    expect(steps.any((s) => s.id == 'germination'), isFalse);
    expect(steps.any((s) => s.id == 'thinning'), isFalse);
  });


  test('Harvest Date: Semé vs Planté differences', () {
    final now = DateTime.now();
    // Cas 1 : Semé -> 90 jours
    final plantingSeeded = Planting(
      gardenBedId: 'bed1',
      plantId: 'p1',
      plantName: 'Tomate',
      plantedDate: now,
      quantity: 1,
      status: 'Semé',
    );
    final stepsSeeded = generateSteps(plant, plantingSeeded);
    final harvestStepSeeded = stepsSeeded.firstWhere((s) => s.id == 'harvest_estimated');
    // ~90 jours
    final expectedSeededDate = now.add(const Duration(days: 90));
    // on accepte une marge d'erreur de 1 jour (heures/minutes) ou exact date match
    expect(
      harvestStepSeeded.scheduledDate!.year == expectedSeededDate.year &&
      harvestStepSeeded.scheduledDate!.month == expectedSeededDate.month &&
      harvestStepSeeded.scheduledDate!.day == expectedSeededDate.day, 
      isTrue,
      reason: 'Semé harvest should be ~90 days after planting'
    );
    // Vérif méta
    expect(harvestStepSeeded.meta!['effectiveMaturityDays'], 90);


    // Cas 2 : Planté (default 30% progress) -> 90 * (1 - 0.3) = 63 jours
    final plantingPlanted = Planting(
      gardenBedId: 'bed1',
      plantId: 'p1',
      plantName: 'Tomate',
      plantedDate: now,
      quantity: 1,
      status: 'Planté',
      // metadata null ou explicit
      metadata: {'initialGrowthPercent': 0.3}
    );
    final stepsPlanted = generateSteps(plant, plantingPlanted);
    final harvestStepPlanted = stepsPlanted.firstWhere((s) => s.id == 'harvest_estimated');
    // ~63 jours
    final expectedPlantedDate = now.add(const Duration(days: 63));
    
    expect(
      harvestStepPlanted.scheduledDate!.year == expectedPlantedDate.year &&
      harvestStepPlanted.scheduledDate!.month == expectedPlantedDate.month &&
      harvestStepPlanted.scheduledDate!.day == expectedPlantedDate.day, 
      isTrue,
      reason: 'Planté harvest should be ~63 days after planting'
    );
    expect(harvestStepPlanted.meta!['effectiveMaturityDays'], 63);
  });
}
