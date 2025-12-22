import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:permacalendar/features/statistics/application/economy_details_provider.dart';
import 'package:permacalendar/features/harvest/application/harvest_records_provider.dart';
import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/features/harvest/domain/models/harvest_record.dart';
import 'package:permacalendar/core/models/planting.dart';

// Mock implementations
class MockHarvestRecordsNotifier extends HarvestRecordsNotifier {
  @override
  HarvestRecordsState build() => const HarvestRecordsState();
  
  void setRecords(List<HarvestRecord> records) {
    state = HarvestRecordsState(records: records, isLoading: false, error: state.error);
  }
}

class MockPlantingNotifier extends PlantingNotifier {
  @override
  PlantingState build() => const PlantingState();
  
  void setPlantings(List<Planting> plantings) {
    state = state.copyWith(plantings: plantings, isLoading: false);
  }
}

void main() {
  late ProviderContainer container;
  
  setUp(() {
    container = ProviderContainer(
      overrides: [
        harvestRecordsProvider.overrideWith(MockHarvestRecordsNotifier.new),
        plantingProvider.overrideWith(MockPlantingNotifier.new),
      ],
    );
  });
  
  tearDown(() {
    container.dispose();
  });

  HarvestRecord createRecord(String id, String plantId, String plantName, DateTime date, double totalValue, double kg, {String gardenId = 'g1'}) {
    return HarvestRecord(
        id: id,
        gardenId: gardenId,
        plantId: plantId,
        plantName: plantName,
        date: date,
        quantityKg: kg,
        pricePerKg: kg > 0 ? totalValue / kg : 0, 
        notes: '',
        // Assuming totalValue is calculated or getter. 
        // NOTE: HarvestRecord typically has quantityKg and pricePerKg. 
        // totalValue is usually a getter => quantityKg * pricePerKg.
    );
  }

  test('Empty state returns default values', () {
    final params = EconomyQueryParams(startDate: DateTime(2025, 1, 1), endDate: DateTime(2025, 12, 31));
    final details = container.read(economyDetailsProvider(params));
    
    expect(details.totalValue, 0.0);
    expect(details.harvestCount, 0);
    expect(details.topPlants, isEmpty);
  });

  test('Totals and basic metrics calculation', () {
    final r1 = createRecord('1', 'p1', 'Tomate', DateTime(2025, 6, 15), 100.0, 10.0); // 10€/kg
    final r2 = createRecord('2', 'p2', 'Basilic', DateTime(2025, 6, 20), 50.0, 1.0);  // 50€/kg
    
    (container.read(harvestRecordsProvider.notifier) as MockHarvestRecordsNotifier).setRecords([r1, r2]);
    
    final params = EconomyQueryParams(startDate: DateTime(2025, 1, 1), endDate: DateTime(2025, 12, 31));
    final details = container.read(economyDetailsProvider(params));
    
    expect(details.totalValue, 150.0);
    expect(details.totalKg, 11.0);
    expect(details.harvestCount, 2);
    expect(details.weightedAvgPrice, 150.0 / 11.0);
  });

  test('Filtering by date works correctly', () {
    final r1 = createRecord('1', 'p1', 'Tomate', DateTime(2025, 5, 1), 10.0, 1.0); // Before
    final r2 = createRecord('2', 'p1', 'Tomate', DateTime(2025, 6, 1), 20.0, 2.0); // Inside
    final r3 = createRecord('3', 'p1', 'Tomate', DateTime(2025, 8, 1), 30.0, 3.0); // After
    
    (container.read(harvestRecordsProvider.notifier) as MockHarvestRecordsNotifier).setRecords([r1, r2, r3]);
    
    final params = EconomyQueryParams(startDate: DateTime(2025, 5, 15), endDate: DateTime(2025, 7, 15));
    final details = container.read(economyDetailsProvider(params));
    
    expect(details.totalValue, 20.0);
    expect(details.harvestCount, 1);
  });

  test('Ranking logic is correct (descending by value)', () {
    final r1 = createRecord('1', 'p1', 'LowVal', DateTime(2025, 6, 1), 10.0, 10.0);
    final r2 = createRecord('2', 'p2', 'HighVal', DateTime(2025, 6, 1), 100.0, 5.0);
    final r3 = createRecord('3', 'p3', 'MidVal', DateTime(2025, 6, 1), 50.0, 5.0);
    
    (container.read(harvestRecordsProvider.notifier) as MockHarvestRecordsNotifier).setRecords([r1, r2, r3]);
    
    final params = EconomyQueryParams(startDate: DateTime(2025, 1, 1), endDate: DateTime(2025, 12, 31));
    final details = container.read(economyDetailsProvider(params));
    
    expect(details.topPlants.length, 3);
    expect(details.topPlants[0].plantName, 'HighVal');
    expect(details.topPlants[0].totalValue, 100.0);
    expect(details.topPlants[1].plantName, 'MidVal');
    expect(details.topPlants[1].totalValue, 50.0);
    expect(details.topPlants[2].plantName, 'LowVal');
  });

  test('Monthly revenue and Top Plant Per Month', () {
    // June: 50
    final r1 = createRecord('1', 'p1', 'P1', DateTime(2025, 6, 10), 20.0, 1.0);
    final r2 = createRecord('2', 'p2', 'P2', DateTime(2025, 6, 20), 30.0, 1.0); // Top in June
    // July: 10
    final r3 = createRecord('3', 'p1', 'P1', DateTime(2025, 7, 5), 10.0, 1.0); // Top in July
    
    (container.read(harvestRecordsProvider.notifier) as MockHarvestRecordsNotifier).setRecords([r1, r2, r3]);
    
    final params = EconomyQueryParams(startDate: DateTime(2025, 1, 1), endDate: DateTime(2025, 12, 31));
    final details = container.read(economyDetailsProvider(params));
    
    expect(details.monthlyRevenue.length, 2);
    expect(details.monthlyRevenue[0].month, 6);
    expect(details.monthlyRevenue[0].totalValue, 50.0);
    expect(details.monthlyRevenue[1].month, 7);
    expect(details.monthlyRevenue[1].totalValue, 10.0);
    
    final topJune = details.topPlantPerMonth[202506];
    expect(topJune, isNotNull);
    expect(topJune!.plantName, 'P2');
    expect(topJune.totalValue, 30.0);
  });

  test('Diversity Index (HHI) logic', () {
    // Case 1: 1 plant -> Monopoly -> HHI=1 -> Diversity=0
    final r1 = createRecord('1', 'p1', 'P1', DateTime(2025, 6, 1), 100.0, 10.0);
    (container.read(harvestRecordsProvider.notifier) as MockHarvestRecordsNotifier).setRecords([r1]);
    
    var details = container.read(economyDetailsProvider(EconomyQueryParams(startDate: DateTime(2025,1,1), endDate: DateTime(2025,12,31))));
    // HHI = 1.0 -> diversity 0.0
    // Float comparison might be tricky, allow small epsilon
    expect(details.diversityIndex, closeTo(0.0, 0.001));

    // Case 2: 2 plants with equal share -> 50/50 -> HHI = 0.5^2 + 0.5^2 = 0.5 -> Diversity = 0.5
    final r2 = createRecord('2', 'p2', 'P2', DateTime(2025, 6, 1), 100.0, 10.0);
    (container.read(harvestRecordsProvider.notifier) as MockHarvestRecordsNotifier).setRecords([r1, r2]);
    
    details = container.read(economyDetailsProvider(EconomyQueryParams(startDate: DateTime(2025,1,1), endDate: DateTime(2025,12,31))));
    expect(details.diversityIndex, closeTo(0.5, 0.001));
  });

  test('Fast vs Long term logic with matching planting', () {
    // Plant 'Radis' planted 30 days ago
    final plantingDate = DateTime(2025, 5, 1);
    final harvestDate = DateTime(2025, 5, 31); // 30 days
    
    final planting = Planting(
      id: 'pl1',
      gardenBedId: 'b1',
      plantId: 'radis_id',
      plantName: 'Radis',
      plantedDate: plantingDate,
      quantity: 1,
      status: 'Semé',
    );
    
    final r1 = createRecord('1', 'radis_id', 'Radis', harvestDate, 5.0, 1.0);
    
    (container.read(plantingProvider.notifier) as MockPlantingNotifier).setPlantings([planting]);
    (container.read(harvestRecordsProvider.notifier) as MockHarvestRecordsNotifier).setRecords([r1]);
    
    final params = EconomyQueryParams(startDate: DateTime(2025, 1, 1), endDate: DateTime(2025, 12, 31));
    final details = container.read(economyDetailsProvider(params));
    
    expect(details.fastVsLongTerm.length, 1);
    final metric = details.fastVsLongTerm.first;
    expect(metric.plantName, 'Radis');
    expect(metric.avgDaysToHarvest, 30.0);
    expect(metric.classification, 'Rapide');
  });
}
