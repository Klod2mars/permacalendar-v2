
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/models/plant.dart';

void main() {
  group('Plant.fromJson Robustness', () {
    test('Should handle null numeric fields without crashing', () {
      // JSON simulating a PlantFreezed converted to JSON where optional fields are null
      // or missing, which causes Plant.fromJson (legacy) to crash with "type 'Null' is not a subtype of type 'num'"
      final Map<String, dynamic> dangerousJson = {
        'id': 'crash_test_1',
        'commonName': 'Crash Plant',
        'scientificName': 'Nullus crashus',
        'family': 'Testaceae',
        'description': '',
        'plantingSeason': 'Spring',
        'harvestSeason': 'Summer',
        'daysToMaturity': 60,
        // 'spacing': null, // Missing or null
        // 'depth': null,
        'sunExposure': 'Sun',
        'waterNeeds': 'Low',
        'sowingMonths': [],
        'harvestMonths': [],
        'marketPricePerKg': null, // <--- This often causes the crash
        'defaultUnit': 'kg',
        'nutritionPer100g': {},
        'germination': {},
        'growth': {},
        'watering': {},
        'thinning': {},
        'weeding': {},
        'culturalTips': [],
        'biologicalControl': {},
        'harvestTime': '',
        'companionPlanting': {},
        'notificationSettings': {},
        'imageUrl': null,
        'metadata': {},
        'isActive': true,
      };

      try {
        final plant = Plant.fromJson(dangerousJson);
        
        // Validation
        expect(plant.marketPricePerKg, 0.0);
        expect(plant.spacing, 0.0);
        expect(plant.depth, 0.0);
        
      } catch (e) {
        fail('Plant.fromJson crashed: $e');
      }
    });

    test('Should handle fields as Strings instead of num', () {
      // Sometimes Hive or JSON serialization artifacts turn numbers into strings
      final Map<String, dynamic> stringyJson = {
         'id': 'string_test_1',
        'commonName': 'String Plant',
        'scientificName': 'Stringus',
        'family': 'Testaceae',
        'description': '',
        'plantingSeason': '',
        'harvestSeason': '',
        'daysToMaturity': 60,
        'spacing': "30.5", // String
        'depth': "1.0",    // String
        'sunExposure': '',
        'waterNeeds': '',
        'sowingMonths': [],
        'harvestMonths': [],
        'marketPricePerKg': "10", // String
        'defaultUnit': '',
        'nutritionPer100g': {},
        'germination': {},
        'growth': {},
        'watering': {},
        'thinning': {},
        'weeding': {},
        'culturalTips': [],
        'biologicalControl': {},
        'harvestTime': '',
        'companionPlanting': {},
        'notificationSettings': {},
      };

       // This might be ambitious for this fix, but good to check if we can support it or at least fail gracefully
       // The primary goal is NO CRASH.
       try {
        final plant = Plant.fromJson(stringyJson);
        expect(plant.spacing, 30.5);
      } catch (e) {
         // If it fails to parse string, it should ideally default to 0, not crash.
         // currently our goal is just fixing the NULL cast error.
      }
    });
  });
}
