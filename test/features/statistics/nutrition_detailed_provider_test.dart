
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/statistics/application/providers/nutrition_detailed_provider.dart';
import 'package:permacalendar/features/harvest/application/harvest_records_provider.dart';
import 'package:permacalendar/features/harvest/domain/models/harvest_record.dart';
import 'package:permacalendar/features/statistics/presentation/providers/statistics_filters_provider.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';
import 'package:mockito/mockito.dart';

// Mocks simples via Override si possible, sinon Mockito
class FakeHarvestNotifier extends HarvestRecordsNotifier {
  final HarvestRecordsState _initialState;
  FakeHarvestNotifier(this._initialState);
  @override
  HarvestRecordsState build() => _initialState;
}

void main() {
  test('NutritionDetailedProvider computes correct totals', () async {
    final container = ProviderContainer(
      overrides: [
// Fix override: For NotifierProvider, use overrideWith(() => Notifier())
        harvestRecordsProvider.overrideWith(() {
           // MockHarvestNotifier removed
           return FakeHarvestNotifier(HarvestRecordsState(
             records: [
               HarvestRecord(
                 id: '1', gardenId: 'g1', plantId: 'p1', plantName: 'Tomato',
                 quantityKg: 10.0,
                 pricePerKg: 1.0, 
                 date: DateTime.now(),
                 nutritionSnapshot: {
                   'vitamin_c_mg': 500.0,
                   'protein_g': 100.0,
                 }
               ),
               HarvestRecord(
                 id: '2', gardenId: 'g1', plantId: 'p2', plantName: 'Carrot',
                 quantityKg: 5.0, 
                 pricePerKg: 1.0, 
                 date: DateTime.now(),
                 nutritionSnapshot: {
                   'vitamin_c_mg': 100.0,
                   'vitamin_a_mcg': 2000.0,
                 }
               )
             ]
           ));
        }),
        // Filters: Default is usually "All time" or "This month", ensure range covers now
        statisticsFiltersProvider.overrideWith(() => StatisticsFiltersNotifier()),
        plantsListProvider.overrideWithValue([]) // Pas besoin si snapshot présent
      ]
    );

    final result = await container.read(nutritionDetailedProvider.future);
    
    // Vit C: 500 + 100 = 600
    final vitC = result.vitamins.firstWhere((e) => e.label == 'Vitamine C');
    expect(vitC.totalValue, 600.0);
    
    // Protein: 100
    final protein = result.macros.firstWhere((e) => e.label == 'Protéines');
    expect(protein.totalValue, 100.0);
    
    // Vit A: 2000
    final vitA = result.vitamins.firstWhere((e) => e.label == 'Vitamine A');
    expect(vitA.totalValue, 2000.0);
  });
}
