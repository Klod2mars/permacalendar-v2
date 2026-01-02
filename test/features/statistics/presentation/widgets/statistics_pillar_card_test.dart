import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/statistics/presentation/widgets/statistics_pillar_card.dart';
import 'package:permacalendar/features/statistics/presentation/enums/pillar_type.dart';
import 'package:permacalendar/features/harvest/application/harvest_records_provider.dart';
import 'package:permacalendar/features/statistics/application/providers/statistics_kpi_providers.dart';
import 'package:permacalendar/features/harvest/domain/models/harvest_record.dart';

// Mock Providers or use overrides
void main() {
  group('StatisticsPillarCard - Economy Pillar', () {
    testWidgets('Displays "--" when no harvest records exist', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            harvestRecordsProvider.overrideWith(
                () => MockHarvestRecordsNotifier(initialRecords: [])),
            totalEconomyKpiProvider.overrideWithValue(0.0),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: StatisticsPillarCard(type: PillarType.economieVivante),
            ),
          ),
        ),
      );

      // Verify the circle is present
      expect(find.byType(StatisticsPillarCard), findsOneWidget);
      // Verify "--" is displayed
      expect(find.text('--'), findsOneWidget);
    });

    testWidgets('Displays value when harvest records exist', (tester) async {
      final mockRecords = [
        HarvestRecord(
            id: '1',
            gardenId: 'g1',
            plantId: 'p1',
            plantName: 'Tomato',
            quantityKg: 10,
            pricePerKg: 2.0,
            date: DateTime.now())
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            harvestRecordsProvider.overrideWith(
                () => MockHarvestRecordsNotifier(initialRecords: mockRecords)),
            totalEconomyKpiProvider
                .overrideWithValue(20.0), // Mocked calc result
            // Mock top3PlantsValueRankingProvider as it is watched in the widget
            top3PlantsValueRankingProvider.overrideWithValue([])
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: StatisticsPillarCard(type: PillarType.economieVivante),
            ),
          ),
        ),
      );

      // Verify "20 €" is displayed
      expect(find.text('20 €'), findsOneWidget);
    });
  });
}

class MockHarvestRecordsNotifier extends HarvestRecordsNotifier {
  final List<HarvestRecord> initialRecords;
  MockHarvestRecordsNotifier({required this.initialRecords});

  @override
  HarvestRecordsState build() {
    return HarvestRecordsState(records: initialRecords, isLoading: false);
  }
}
