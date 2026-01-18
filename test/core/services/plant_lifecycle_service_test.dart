
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/services/plant_lifecycle_service.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

void main() {
  group('PlantLifecycleService', () {
    test('calculateLifecycle handles normal numeric inputs', () async {
      final plant = PlantFreezed(
        id: '1',
        commonName: 'Tomato',
        scientificName: 'Solanum lycopersicum',
        family: 'Solanaceae',
        plantingSeason: 'Spring',
        harvestSeason: 'Summer',
        daysToMaturity: 100,
        spacing: 50,
        depth: 1.0,
        sunExposure: 'Full Sun',
        waterNeeds: 'Medium',
        description: 'Test',
        sowingMonths: [],
        harvestMonths: [],
        germination: {'minDays': 5, 'maxDays': 10},
      );

      final result = await PlantLifecycleService.calculateLifecycle(
        plant,
        DateTime.now(),
      );

      expect(result['maturityDays'], 100);
      expect(result['germinationDays'], 5); // minDays takes precedence if valid
    });

    test('calculateLifecycle handles string inputs in germination map', () async {
      final plant = PlantFreezed(
        id: '2',
        commonName: 'Carrot',
        scientificName: 'Daucus carota',
        family: 'Apiaceae',
        plantingSeason: 'Spring',
        harvestSeason: 'Summer',
        daysToMaturity: 70,
        spacing: 5,
        depth: 1.0,
        sunExposure: 'Sun',
        waterNeeds: 'Medium',
        description: 'Test',
        sowingMonths: [],
        harvestMonths: [],
        germination: {'minDays': '7', 'maxDays': '14'}, // Strings here
      );

      final result = await PlantLifecycleService.calculateLifecycle(
        plant,
        DateTime.now(),
      );

      expect(result['germinationDays'], 7);
    });

    test('calculateLifecycle handles null values and robust defaults', () async {
      final plant = PlantFreezed(
        id: '3',
        commonName: 'Mystery Plant',
        scientificName: 'Unknown',
        family: 'Unknown',
        plantingSeason: 'Spring',
        harvestSeason: 'Fall',
        daysToMaturity: -5, // Invalid maturity
        spacing: 30,
        depth: 2.0,
        sunExposure: 'Sun',
        waterNeeds: 'Low',
        description: 'Test',
        sowingMonths: [],
        harvestMonths: [],
        germination: null, // No germination info
      );

      final result = await PlantLifecycleService.calculateLifecycle(
        plant,
        DateTime.now(),
      );

      // Should default to 60 for maturity
      expect(result['maturityDays'], 60);
      // Germination should be calculated from maturity (10% of 60 = 6 clamped to [5, 21]) => 6
      expect(result['germinationDays'], 6);
    });

    test('calculateLifecycle handles crash-prone growth map', () async {
       final plant = PlantFreezed(
        id: '4',
        commonName: 'Transplant Test',
        scientificName: 'Testus',
        family: 'Testaceae',
        plantingSeason: 'Spring',
        harvestSeason: 'Summer',
        daysToMaturity: 90,
        spacing: 40,
        depth: 1.0,
        sunExposure: 'Sun',
        waterNeeds: 'Medium',
        description: 'Test',
        sowingMonths: [],
        harvestMonths: [],
        growth: {'transplantInitialPercent': '0.4'}, // String value
      );

      final result = await PlantLifecycleService.calculateLifecycle(
        plant,
        DateTime.now(),
        plantingStatus: 'Planté',
      );

      expect(result['initialProgress'], 0.4);
    });
     test('calculateLifecycle handles corrupt growth map', () async {
       final plant = PlantFreezed(
        id: '5',
        commonName: 'Corrupt Plant',
        scientificName: 'Testus',
        family: 'Testaceae',
        plantingSeason: 'Spring',
        harvestSeason: 'Summer',
        daysToMaturity: 90,
        spacing: 40,
        depth: 1.0,
        sunExposure: 'Sun',
        waterNeeds: 'Medium',
        description: 'Test',
        sowingMonths: [],
        harvestMonths: [],
         // growth isn't a map of strings to dynamic exactly as expected sometimes, or values are weird
        growth: {'transplantInitialPercent': null}, 
      );

      final result = await PlantLifecycleService.calculateLifecycle(
        plant,
        DateTime.now(),
        plantingStatus: 'Planté',
      );

      // Should fallback to 0.3
      expect(result['initialProgress'], 0.3);
    });
  });
}
