import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/statistics/application/economy_details_provider.dart';
import 'package:permacalendar/features/harvest/application/harvest_records_provider.dart';
import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/features/harvest/domain/models/harvest_record.dart';

class _StaticHarvestNotifier extends HarvestRecordsNotifier {
  final List<HarvestRecord> _records;
  _StaticHarvestNotifier(this._records);
  @override
  HarvestRecordsState build() => HarvestRecordsState(records: _records, isLoading: false);
}

class _StaticPlantingNotifier extends PlantingNotifier {
  @override
  PlantingState build() => const PlantingState(plantings: [], isLoading: false);
}

void main() {
  test('EconomyDetails calculates totals correctly', () {
    // Setup records
    final records = [
      HarvestRecord(
        id: '1',
        gardenId: 'g1',
        plantId: 'ail',
        plantName: 'Ail',
        quantityKg: 3.5,
        pricePerKg: 4.50,
        date: DateTime(2023, 6, 1),
      ), // 15.75
      HarvestRecord(
        id: '2',
        gardenId: 'g1',
        plantId: 'roquette',
        plantName: 'Roquette',
        quantityKg: 0.5,
        pricePerKg: 22.00,
        date: DateTime(2023, 6, 2),
      ), // 11.00
      HarvestRecord(
        id: '3',
        gardenId: 'g1',
        plantId: 'laitue',
        plantName: 'Laitue',
        quantityKg: 2.0,
        pricePerKg: 4.20,
        date: DateTime(2023, 6, 3),
      ), // 8.40
      HarvestRecord(
        id: '4',
        gardenId: 'g1',
        plantId: 'feves',
        plantName: 'Fèves',
        quantityKg: 1.0,
        pricePerKg: 2.20,
        date: DateTime(2023, 6, 4),
      ), // 2.20
    ];

    final container = ProviderContainer(
      overrides: [
        harvestRecordsProvider.overrideWith(() => _StaticHarvestNotifier(records)),
        plantingProvider.overrideWith(() => _StaticPlantingNotifier()),
      ],
    );

    final params = EconomyQueryParams(
      startDate: DateTime(2023, 1, 1),
      endDate: DateTime(2023, 12, 31),
    );

    final details = container.read(economyDetailsProvider(params));

    expect(details.totalKg, 7.0);
    // 15.75 + 11.00 + 8.40 + 2.20 = 37.35
    expect(details.totalValue, closeTo(37.35, 0.001));
    
    // Weighted Avg = 37.35 / 7.0 = 5.335714...
    expect(details.weightedAvgPrice, closeTo(5.3357, 0.0001));
  });
}
