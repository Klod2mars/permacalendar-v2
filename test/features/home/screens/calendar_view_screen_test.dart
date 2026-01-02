import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
// import 'package:mockito/mockito.dart'; // Unused
import 'package:permacalendar/features/home/screens/calendar_view_screen.dart';
import 'package:permacalendar/features/home/providers/calendar_aggregation_provider.dart';
import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/features/calendar/presentation/providers/calendar_filter_provider.dart';

// Mock Notifier
class MockPlantingNotifier extends PlantingNotifier {
  MockPlantingNotifier() : super();

  @override
  Future<PlantingState> build() async {
    return PlantingState(
      plantings: [],
      isLoading: false,
      error: null,
      selectedPlanting: null,
    );
  }

  @override
  Future<void> loadAllPlantings() async {
    // No-op
  }
}

void main() {
  testWidgets('CalendarViewScreen displays aggregated icons correctly',
      (WidgetTester tester) async {
    // Current month for test
    final now = DateTime.now();
    final testMonth = DateTime(now.year, now.month);

    // Mock Aggregated Data
    final Map<String, Map<String, dynamic>> mockAggData = {};
    // Populate for today
    final todayKey = DateFormat('yyyy-MM-dd').format(now);
    mockAggData[todayKey] = {
      'plantingCount': 2,
      'wateringCount': 1,
      'harvestCount': 0,
      'overdueCount': 0,
      'frost': false,
    };

    // Test App
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override aggregation provider for current month
          calendarAggregationProvider(testMonth)
              .overrideWith((ref) => Future.value(mockAggData)),
          // Override planting provider to avoid real logic
          plantingProvider.overrideWith(() => MockPlantingNotifier()),
          plantingsListProvider.overrideWithValue([]),
        ],
        child: MaterialApp(
          home: const CalendarViewScreen(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          ),
        ),
      ),
    );

    // Pump frames to resolve future
    await tester.pumpAndSettle();

    // Verify
    // Find text '2'
    expect(find.text('2'), findsOneWidget);
    // Find Eco icon
    expect(find.byIcon(Icons.eco), findsWidgets);

    // Find text '1'
    expect(find.text('1'), findsOneWidget);
    // Find Water icon
    expect(find.byIcon(Icons.water_drop), findsWidgets);
  });
}
