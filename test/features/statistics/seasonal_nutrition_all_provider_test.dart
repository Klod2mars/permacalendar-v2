import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/statistics/application/providers/nutrition_detailed_provider.dart';
import 'package:permacalendar/features/harvest/application/harvest_records_provider.dart';
import 'package:permacalendar/features/harvest/domain/models/harvest_record.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';
import 'package:permacalendar/features/statistics/presentation/providers/statistics_filters_provider.dart';

class FakeHarvestNotifier extends HarvestRecordsNotifier {
  final HarvestRecordsState _initialState;
  FakeHarvestNotifier(this._initialState);
  @override
  HarvestRecordsState build() => _initialState;
}

void main() {
  test('SeasonalNutritionAllProvider aggregates all records including past year', () async {
    final now = DateTime.now();
    final currentMonth = now.month;
    final lastYearDate = now.subtract(const Duration(days: 400)); // Definitely last year
    final lastYearMonth = lastYearDate.month;

    final container = ProviderContainer(overrides: [
      harvestRecordsProvider.overrideWith(() {
        return FakeHarvestNotifier(HarvestRecordsState(records: [
          // Record 1: Current Month
          HarvestRecord(
              id: '1',
              gardenId: 'g1',
              plantId: 'p1',
              plantName: 'Tomato',
              quantityKg: 10.0,
              pricePerKg: 1.0,
              date: now,
              nutritionSnapshot: {
                'vitamin_c_mg': 500.0,
                'calcium_mg': 100.0,
              }),
          // Record 2: Last Year (Should be included in AllProvider)
          HarvestRecord(
              id: '2',
              gardenId: 'g1',
              plantId: 'p2',
              plantName: 'Carrot',
              quantityKg: 5.0,
              pricePerKg: 1.0,
              date: lastYearDate,
              nutritionSnapshot: {
                'vitamin_c_mg': 100.0,
              }),
           // Record 3: No Nutrition (Should NOT be counted)
           HarvestRecord(
              id: '3',
              gardenId: 'g1',
              plantId: 'p3',
              plantName: 'Stone',
              quantityKg: 5.0,
              pricePerKg: 1.0,
              date: now,
              nutritionSnapshot: {} // Empty
              )
        ]));
      }),
      plantsListProvider.overrideWithValue([])
    ]);

    final result = await container.read(seasonalNutritionAllProvider.future);

    // Check Current Month Aggregation
    final currentStats = result.monthlyStats[currentMonth]!;
    // Record 1 is counted. Record 3 is NOT counted (empty nutrition).
    expect(currentStats.contributionCount, 1, reason: "Should ignore records with no nutrition");
    expect(currentStats.getTotal('vitamin_c_mg'), 500.0);

    // Check Last Year Month
    final prevStats = result.monthlyStats[lastYearMonth]!;
    expect(prevStats.contributionCount, 1, reason: "Should include last year records");
    expect(prevStats.getTotal('vitamin_c_mg'), 100.0);
  });
}
