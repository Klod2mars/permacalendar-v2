import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/repositories/garden_rules.dart';
import 'package:permacalendar/core/services/environment_service.dart';

void main() {
  group('GardenRules - Limits Validation', () {
    final gardenRules = GardenRules();

    test('validateGardenBedCount allows below limit', () {
      final result = gardenRules.validateGardenBedCount(99);
      expect(result.isValid, true);
    });

    test('validateGardenBedCount blocks at limit', () {
      final result = gardenRules.validateGardenBedCount(100);
      expect(result.isValid, false);
      expect(result.errorMessage, contains('Pour garantir une fluidité parfaite'));
    });

    test('validatePlantingCount allows below limit', () {
      final result = gardenRules.validatePlantingCount(5);
      expect(result.isValid, true);
    });

    test('validatePlantingCount blocks at limit', () {
      final result = gardenRules.validatePlantingCount(6);
      expect(result.isValid, false);
      // New expected message
      expect(result.errorMessage, contains('Limite de 6 plantes atteinte.'));
      expect(result.errorMessage, contains('Veuillez retirer une plante'));
    });
  });
}
