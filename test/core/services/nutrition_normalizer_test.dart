
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/services/nutrition_normalizer.dart';

void main() {
  group('NutritionNormalizer', () {
    test('computeSnapshot empty or null', () {
      expect(NutritionNormalizer.computeSnapshot(null, 1.0), isEmpty);
      expect(NutritionNormalizer.computeSnapshot({}, 1.0), isEmpty);
      expect(NutritionNormalizer.computeSnapshot({'kcal': 100}, 0.0), isEmpty);
    });

    test('computeSnapshot standard case', () {
      final input = {
        'calories': 50, // -> calories_kcal
        'protein': 1.5, // -> protein_g
        'vitaminc': 10, // -> vitamin_c_mg
      };
      // 2 kg = 20 * 100g
      final snapshot = NutritionNormalizer.computeSnapshot(input, 2.0);
      
      expect(snapshot['calories_kcal'], 50 * 20); // 1000
      expect(snapshot['protein_g'], 1.5 * 20); // 30
      expect(snapshot['vitamin_c_mg'], 10 * 20); // 200
    });

    test('computeSnapshot key variations', () {
      final input = {
        'Kcal': 100, // -> calories_kcal
        'Proteines': 5, // -> protein_g
        'Vitamin A': 200, // -> vitamin_a_mcg (mapping: 'vitamina') 
        // Note: 'Vitamin A' with space might not be cleaned to 'vitamina'. 
        // Logic: .toLowerCase().replaceAll(r'[^a-z0-9]', '') -> 'vitamina'
        // So 'Vitamin A' -> 'vitamina' -> 'vitamin_a_mcg'
      };
      
      // 1 kg = 10 units
      final snapshot = NutritionNormalizer.computeSnapshot(input, 1.0);
      
      expect(snapshot['calories_kcal'], 1000);
      expect(snapshot['protein_g'], 50);
      expect(snapshot['vitamin_a_mcg'], 2000);
    });
    
    test('computeSnapshot ignores unknown keys', () {
       final input = {
         'unknown_thing': 123,
         'kcal': 10,
       };
       final snapshot = NutritionNormalizer.computeSnapshot(input, 1.0);
       expect(snapshot.containsKey('calories_kcal'), true);
       expect(snapshot.length, 1);
    });
  });
}
