import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/harvest/application/harvest_records_provider.dart';
import 'package:permacalendar/features/harvest/domain/models/harvest_record.dart';
import 'package:permacalendar/features/statistics/application/providers/economy_providers.dart';
import 'package:permacalendar/features/statistics/presentation/providers/statistics_filters_provider.dart';

// Mock Notifier to control state
class MockHarvestRecordsNotifier extends HarvestRecordsNotifier {
  final List<HarvestRecord> _initialRecords;

  MockHarvestRecordsNotifier(this._initialRecords);

  @override
  HarvestRecordsState build() {
    return HarvestRecordsState(records: _initialRecords, isLoading: false);
  }
}

void main() {
  test('Economy aggregation for two harvests', () {
    // 1. Setup Data
    final record1 = HarvestRecord(
      id: '1',
      gardenId: 'garden1',
      plantId: 'carrot',
      plantName: 'Carrot',
      quantityKg: 2.0,
      pricePerKg: 2.5,
      date: DateTime(2023, 10, 1),
    );

    final record2 = HarvestRecord(
      id: '2',
      gardenId: 'garden1',
      plantId: 'carrot',
      plantName: 'Carrot',
      quantityKg: 11.0,
      pricePerKg: 2.1,
      date: DateTime(2023, 10, 2),
    );

    final allRecords = [record1, record2];

    // 2. Setup Container with Overrides
    final container = ProviderContainer(
      overrides: [
        harvestRecordsProvider.overrideWith(() => MockHarvestRecordsNotifier(allRecords)),
      ],
    );

    // Ensure filters cover the dates (default is current year, let's assume test runs in 2023 or we force filters)
    // Actually default filter is current year. If test runs in 2025, 2023 is excluded.
    // So we must update filters to include 2023.
    // OR update records to be "now".
    // Let's update records to be "now".
    final now = DateTime.now();
    final r1 = HarvestRecord(
      id: record1.id,
      gardenId: record1.gardenId,
      plantId: record1.plantId,
      plantName: record1.plantName,
      quantityKg: record1.quantityKg,
      pricePerKg: record1.pricePerKg,
      date: now,
    );
    final r2 = HarvestRecord(
      id: record2.id,
      gardenId: record2.gardenId,
      plantId: record2.plantId,
      plantName: record2.plantName,
      quantityKg: record2.quantityKg,
      pricePerKg: record2.pricePerKg,
      date: now.add(const Duration(hours: 1)),
    );
    
    // Re-create container with correct dates
    final containerNow = ProviderContainer(
      overrides: [
         harvestRecordsProvider.overrideWith(() => MockHarvestRecordsNotifier([r1, r2])),
      ],
    );

    // 3. Verify
    final totalValue = containerNow.read(totalValueProvider);
    // 2*2.5 = 5.0
    // 11*2.1 = 23.1
    // Total = 28.1
    expect(totalValue, closeTo(28.1, 0.0001));

    final totalKg = containerNow.read(totalKgProvider);
    // 2+11 = 13
    expect(totalKg, 13.0);

    final avg = containerNow.read(weightedAvgPriceProvider);
    // 28.1 / 13.0 = 2.161538...
    expect(avg, closeTo(2.161538, 0.00001));
    
    addTearDown(container.dispose);
    addTearDown(containerNow.dispose);
  });
}
