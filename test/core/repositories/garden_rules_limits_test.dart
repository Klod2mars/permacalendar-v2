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
      expect(result.errorMessage, 'limit_beds_reached_message');
    });

    test('validatePlantingCount allows below limit', () {
      final result = gardenRules.validatePlantingCount(5);
      expect(result.isValid, true);
    });

    test('validatePlantingCount blocks at limit', () {
      final result = gardenRules.validatePlantingCount(6);
      expect(result.isValid, false);
      // New expected message
      expect(result.errorMessage, 'limit_plantings_reached_message');
    });
  });
}
