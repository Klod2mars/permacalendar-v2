import 'package:permacalendar/core/models/plant.dart' as plant_model;

/// Helper function to create simple Plant objects for testing
plant_model.Plant createTestPlant({
  String? id,
  String? commonName,
  String? scientificName,
  String? family,
}) {
  return plant_model.Plant(
    id: id,
    commonName: commonName ?? 'Test Plant',
    scientificName: scientificName ?? 'Test scientificName',
    family: family ?? 'Test Family',
    description: 'Test description',
    plantingSeason: 'spring',
    harvestSeason: 'summer',
    daysToMaturity: 60,
    spacing: 30.0,
    depth: 2.0,
    sunExposure: 'full sun',
    waterNeeds: 'moderate',
    sowingMonths: ['march', 'april'],
    harvestMonths: ['july', 'august'],
    marketPricePerKg: 5.0,
    defaultUnit: 'kg',
    nutritionPer100g: {},
    germination: {},
    growth: {},
    watering: {},
    thinning: {},
    weeding: {},
    culturalTips: [],
    biologicalControl: {},
    harvestTime: 'morning',
    companionPlanting: {},
    notificationSettings: {},
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    metadata: {},
    isActive: true,
  );
}


