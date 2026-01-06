import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/activities/application/providers/garden_history_provider.dart';

// Mocks simples pour le test
class TestBed {
  final String id;
  final String name;
  final DateTime createdAt;
  TestBed(this.id, this.name, {DateTime? createdAt}) : this.createdAt = createdAt ?? DateTime.now();
  // Mimic Hive object if needed? No, dynamic access in function might rely on property access.
  // Wait, in Dart 'dynamic' property access works if the runtime type has the property.
}

class TestPlanting {
  final String id;
  final String plantId;
  final String plantName;
  final DateTime? plantedDate;
  final DateTime? actualHarvestDate;
  TestPlanting({
    required this.id,
    required this.plantId,
    required this.plantName,
    this.plantedDate,
    this.actualHarvestDate,
  });
}

void main() {
  group('transformToHistory', () {
    test('Should return correct history structure with years from creation to current', () {
      final now = DateTime.now();
      final currentYear = now.year;
      final gardenCreated = DateTime(currentYear - 2, 5, 10);
      
      final beds = [
        TestBed('bed1', 'Bed 1'),
        TestBed('bed2', 'Bed 2'),
      ];

      // Planting in current year
      final p1 = TestPlanting(id: 'p1', plantId: 'plant1', plantName: 'Tomate', plantedDate: DateTime(currentYear, 3, 15));
      // Planting last year
      final p2 = TestPlanting(id: 'p2', plantId: 'plant2', plantName: 'Carotte', plantedDate: DateTime(currentYear - 1, 4, 10));
      // Planting 2 years ago
      final p3 = TestPlanting(id: 'p3', plantId: 'plant3', plantName: 'Poireau', plantedDate: DateTime(currentYear - 2, 11, 5));

      final plantingsMap = {
        'bed1': [p1, p3],
        'bed2': [p2],
      };

      final history = transformToHistory(
        'garden1',
        'My Garden',
        gardenCreated,
        beds,
        plantingsMap,
      );

      expect(history.gardenId, 'garden1');
      expect(history.years.length, 3); // current, current-1, current-2
      expect(history.years[0].year, currentYear);
      expect(history.years[1].year, currentYear - 1);
      expect(history.years[2].year, currentYear - 2);

      // Verify current year contents
      final yearCurrent = history.years[0];
      final bed1Current = yearCurrent.beds.firstWhere((b) => b.bedId == 'bed1');
      expect(bed1Current.plants.length, 1);
      expect(bed1Current.plants.first.plantName, 'Tomate');
      
      final bed2Current = yearCurrent.beds.firstWhere((b) => b.bedId == 'bed2', orElse: () => bed1Current); // Should be empty or present?
      // Logic: putIfAbsent creates list. Then we lookup bed. If not found, we create empty BedYearHistory if logic allows?
      // Logic check:
      /*
        var existing = list.firstWhere(..., orElse: ...);
        if (existing.plants.isEmpty && !list.contains(existing)) { list.add(existing); }
      */
      // So yes, empty beds are added if we iterate them.
      // beds loop runs for every bed.
      
      // Verify Bed 2 in current year (should be empty as it has no planting this year)
      // Actually, my mock p2 is last year.
      // So bed2 in Current Year should be empty list of plants.
      final bed2InCurrent = yearCurrent.beds.firstWhere((b) => b.bedId == 'bed2');
      expect(bed2InCurrent.plants, isEmpty);

      // Verify Last Year
      final yearLast = history.years[1];
      final bed2Last = yearLast.beds.firstWhere((b) => b.bedId == 'bed2');
      expect(bed2Last.plants.length, 1);
      expect(bed2Last.plants.first.plantName, 'Carotte');
    });

    test('Should handle empty garden correctly', () {
      final now = DateTime.now();
      final gardenCreated = DateTime(now.year, 1, 1);
      
      final history = transformToHistory(
        'garden1',
        'Empty Garden',
        gardenCreated,
        [],
        {},
      );

      expect(history.years.length, 1);
      expect(history.years[0].beds, isEmpty);
    });
  });
}
