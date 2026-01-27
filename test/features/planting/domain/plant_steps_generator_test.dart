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
}
