
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/models/plant.dart';

void main() {
  group('Plant.fromJson Hardening Verification', () {
    test('Should not crash when list fields are null', () {
      final Map<String, dynamic> badJson = {
        'id': 'test_1',
        'commonName': 'Test Plant',
        'scientificName': 'Testus plantus',
        'family': 'Testaceae',
        'description': 'A test plant',
        'plantingSeason': 'Spring',
        'harvestSeason': 'Summer',
        'daysToMaturity': 60,
        'spacing': 30,
        'depth': 1.0,
        'sunExposure': 'Sun',
        'waterNeeds': 'Medium',
        'sowingMonths': null, // <--- Null list
        'harvestMonths': null, // <--- Null list
        'marketPricePerKg': 0,
        'defaultUnit': 'kg',
        'nutritionPer100g': null, // <--- Null map
        'germination': null,
        'growth': null,
        'watering': null,
        'thinning': null,
        'weeding': null,
        'culturalTips': null, // <--- Null list (Main culprit)
        'biologicalControl': null,
        'harvestTime': 'July',
        'companionPlanting': null, // <--- Null map
        'notificationSettings': null,
        'metadata': null,
        'isActive': true,
        'notes': null,
      };

      try {
        final plant = Plant.fromJson(badJson);
        expect(plant.culturalTips, isEmpty);
        expect(plant.sowingMonths, isEmpty);
        expect(plant.companionPlanting, isEmpty);
        expect(plant.notificationSettings, isEmpty);
        print('Success: Plant created without crashing!');
      } catch (e) {
        fail('Plant.fromJson crashed with error: $e');
      }
    });

    test('Should handle fields present but null values inside lists? (Optional check)', () {
       // Our implementation filters nulls usually or handles them
    });
  });
}
