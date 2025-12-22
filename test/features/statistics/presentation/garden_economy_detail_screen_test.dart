import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/statistics/application/economy_details_provider.dart';
import 'package:permacalendar/features/statistics/presentation/screens/garden_economy_detail_screen.dart';
import 'package:permacalendar/features/harvest/application/harvest_records_provider.dart';
import 'package:permacalendar/features/statistics/presentation/providers/statistics_filters_provider.dart';

// Mocks
class MockHarvestRecordsNotifier extends HarvestRecordsNotifier {
   @override
  HarvestRecordsState build() => const HarvestRecordsState(isLoading: false, records: []);

  @override
  Future<void> refresh() async {}
}

class MockStatisticsFiltersNotifier extends StatisticsFiltersNotifier {
  @override
  StatisticsFiltersState build() {
    return const StatisticsFiltersState();
  }
}

void main() {
  testWidgets('GardenEconomyDetailScreen smoke test', (WidgetTester tester) async {
    // Override providers
    final mockDetails = EconomyDetails.empty();
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          harvestRecordsProvider.overrideWith(MockHarvestRecordsNotifier.new),
          statisticsFiltersProvider.overrideWith(MockStatisticsFiltersNotifier.new),
          // We override the family provider to return empty details for ANY params
          economyDetailsProvider.overrideWith((ref, params) => mockDetails),
        ],
        child: const MaterialApp(
          home: GardenEconomyDetailScreen(),
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Économie du Jardin'), findsOneWidget);
    expect(find.text('Revenu Total'), findsOneWidget);
    
    // Check if refresh indicator can be pulled
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 300));
    await tester.pumpAndSettle();
  });
}
