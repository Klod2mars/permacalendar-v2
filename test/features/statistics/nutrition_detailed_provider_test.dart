import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/statistics/application/providers/nutrition_detailed_provider.dart';
import 'package:permacalendar/features/harvest/application/harvest_records_provider.dart';
import 'package:permacalendar/features/harvest/domain/models/harvest_record.dart';
import 'package:permacalendar/features/statistics/presentation/providers/statistics_filters_provider.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';

class FakeHarvestNotifier extends HarvestRecordsNotifier {
  final HarvestRecordsState _initialState;
  FakeHarvestNotifier(this._initialState);
  @override
  HarvestRecordsState build() => _initialState;
}

void main() {
  test('SeasonalNutritionProvider aggregates by month correctly', () async {
    final now = DateTime.now();
    final currentMonth = now.month;

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
          // Record 2: Current Month (Aggregate)
          HarvestRecord(
              id: '2',
              gardenId: 'g1',
              plantId: 'p2',
              plantName: 'Lettuce',
              quantityKg: 2.0,
              pricePerKg: 1.0,
              date: now,
              nutritionSnapshot: {
                'vitamin_c_mg': 50.0,
                'calcium_mg': 50.0,
              }),
          // Record 3: Previous Month (Different Bucket)
          HarvestRecord(
              id: '3',
              gardenId: 'g1',
              plantId: 'p3',
              plantName: 'Carrot',
              quantityKg: 5.0,
              pricePerKg: 1.0,
              date: now.subtract(const Duration(days: 40)), // ~Last month
              nutritionSnapshot: {
                'vitamin_c_mg': 100.0,
              })
        ]));
      }),
      statisticsFiltersProvider.overrideWith(() => StatisticsFiltersNotifier()),
      plantsListProvider.overrideWithValue([])
    ]);

    final result = await container.read(seasonalNutritionProvider.future);

    // Check Current Month Aggregation
    final currentStats = result.monthlyStats[currentMonth]!;
    expect(currentStats.contributionCount, 2);
    expect(currentStats.getTotal('vitamin_c_mg'), 550.0); // 500 + 50
    expect(currentStats.getTotal('calcium_mg'), 150.0); // 100 + 50

    // Check Previous Month
    final prevDate = now.subtract(const Duration(days: 40));
    final prevMonth = prevDate.month;
    final prevStats = result.monthlyStats[prevMonth]!;
    expect(prevStats.contributionCount, 1);
    expect(prevStats.getTotal('vitamin_c_mg'), 100.0);

    // Check Annual Total
    // Totals: Vit C = 550 + 100 = 650. Calcium = 150.
    expect(result.annualTotals['vitamin_c_mg'], 650.0);
    expect(result.annualTotals['calcium_mg'], 150.0);
  });
}
