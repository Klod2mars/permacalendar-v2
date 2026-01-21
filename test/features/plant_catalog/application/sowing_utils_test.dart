// test/features/plant_catalog/application/sowing_utils_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_catalog/application/sowing_utils.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

void main() {
  group('SowingUtils', () {
    test('normalizeMonthTokens handles various formats', () {
      expect(normalizeMonthTokens(['Mar', 'Apr']), {3, 4});
      expect(normalizeMonthTokens(['3', '4']), {3, 4});
      expect(normalizeMonthTokens(['Mar-May']), {3, 4, 5});
      expect(normalizeMonthTokens(['Mar–May']), {3, 4, 5}); // en dash
      expect(normalizeMonthTokens(['Unknown', '']), isEmpty);
      expect(normalizeMonthTokens(['Jan', 'Dec']), {1, 12});
    });

    test('parseSeasonStringToMonths handles typical seasons', () {
      expect(parseSeasonStringToMonths('Spring'), {3, 4, 5});
      expect(parseSeasonStringToMonths('Printemps'), {3, 4, 5});
      expect(parseSeasonStringToMonths('Summer'), {6, 7, 8});
      expect(parseSeasonStringToMonths('Hiver'), {12, 1, 2});
      expect(parseSeasonStringToMonths('Unknown'), isEmpty);
    });

    test('computeSeasonInfoForPlant status calculation', () {
      final plant = PlantFreezed.create(
        commonName: 'Test Plant',
        scientificName: 'Testus',
        family: 'Testaceae',
        plantingSeason: 'Spring',
        harvestSeason: 'Summer',
        daysToMaturity: 60,
        spacing: 30,
        depth: 1,
        sunExposure: 'Sun',
        waterNeeds: 'Medium',
        description: 'Desc',
        sowingMonths: [], // Not used if metadata present in sowing_utils logic if checking meta first
        harvestMonths: [],
        metadata: {
          'sowingMonths3': ['Mar', 'Apr']
        }
      );

      // March (exact match) -> Green
      var info = computeSeasonInfoForPlant(
        plant: plant,
        date: DateTime(2023, 3, 15),
        action: ActionType.sow
      );
      expect(info.status, SeasonStatus.green);
      expect(info.distance, 0);

      // February (dist 1) -> Orange (default near threshold is 1)
      info = computeSeasonInfoForPlant(
        plant: plant,
        date: DateTime(2023, 2, 15),
        action: ActionType.sow
      );
      expect(info.status, SeasonStatus.orange);
      expect(info.distance, 1);

      // May (dist 1) -> Orange
      info = computeSeasonInfoForPlant(
        plant: plant, 
        date: DateTime(2023, 5, 15), 
        action: ActionType.sow
      );
      expect(info.status, SeasonStatus.orange);
      expect(info.distance, 1);

      // June (dist 2) -> Red
      info = computeSeasonInfoForPlant(
        plant: plant,
        date: DateTime(2023, 6, 15),
        action: ActionType.sow
      );
      expect(info.status, SeasonStatus.red);
      expect(info.distance, 2);
    });

    test('computeSeasonInfoForPlant long season tolerance', () {
       // Long season: March-July (5 months)
       // normalizeMonthTokens(['Mar-Jul']) -> {3,4,5,6,7}
       final plant = PlantFreezed.create(
        commonName: 'Long Season Plant',
        scientificName: '', family: '', plantingSeason: '', harvestSeason: '',
        daysToMaturity: 1, spacing: 1, depth: 1, sunExposure: '', waterNeeds: '', description: '',
        sowingMonths: [], harvestMonths: [],
        metadata: {
          'sowingMonths3': ['Mar-Jul']
        }
      );

      // August (dist 1 from July) -> Orange (normal)
      
      // September (dist 2) -> Orange? 
      // Rule: if contiguous >= 3, nearThreshold -> near+1.
      // Default near is 1. new near is 2.
      // 3,4,5,6,7. Target 9 (Sep).
      // 9 -> 7 (Backward) dist is 2.
      // So Sep should be Orange.

      var info = computeSeasonInfoForPlant(
        plant: plant,
        date: DateTime(2023, 9, 15),
        action: ActionType.sow
      );
      expect(info.status, SeasonStatus.orange); // Because of long season bonus
      expect(info.distance, 2);

      // October (dist 3) -> Red
      info = computeSeasonInfoForPlant(
        plant: plant,
        date: DateTime(2023, 10, 15),
        action: ActionType.sow
      );
      expect(info.status, SeasonStatus.red);
    });

    test('computeSeasonInfoForPlant unknown data', () {
      final plant = PlantFreezed.create(
        commonName: 'No Data',
        scientificName: '', family: '', plantingSeason: '', harvestSeason: '',
        daysToMaturity: 1, spacing: 1, depth: 1, sunExposure: '', waterNeeds: '', description: '',
        sowingMonths: [], harvestMonths: [],
        metadata: {} // Empty
      );

      final info = computeSeasonInfoForPlant(
        plant: plant,
        date: DateTime.now(),
        action: ActionType.sow
      );
      expect(info.status, SeasonStatus.unknown);
    });
  });
}
