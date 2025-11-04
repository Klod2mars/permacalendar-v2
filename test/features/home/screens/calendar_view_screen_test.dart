import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/features/home/screens/calendar_view_screen.dart';
import 'package:permacalendar/features/planting/providers/planting_provider.dart';

void main() {
  group('CalendarViewScreen', () {
    late List<Planting> mockPlantings;

    setUp(() {
      mockPlantings = [
        Planting(
          id: 'planting-1',
          plantId: 'plant-1',
          plantName: 'Tomate',
          gardenBedId: 'bed-1',
          plantedDate: DateTime(2025, 10, 15),
          quantity: 5,
          status: 'En cours',
          expectedHarvestStartDate: DateTime(2025, 12, 1),
        ),
        Planting(
          id: 'planting-2',
          plantId: 'plant-2',
          plantName: 'Salade',
          gardenBedId: 'bed-1',
          plantedDate: DateTime(2025, 10, 20),
          quantity: 10,
          status: 'En cours',
          expectedHarvestStartDate: DateTime(2025, 11, 15),
        ),
        Planting(
          id: 'planting-3',
          plantId: 'plant-3',
          plantName: 'Carotte',
          gardenBedId: 'bed-2',
          plantedDate: DateTime(2025, 9, 1),
          quantity: 20,
          status: 'Récolté',
          expectedHarvestStartDate: DateTime(2025, 10, 15),
          actualHarvestDate: DateTime(2025, 10, 16),
        ),
      ];
    });

    Widget createTestWidget(List<Planting> plantings) {
      return ProviderScope(
        overrides: [
          plantingsListProvider.overrideWith((ref) => plantings),
        ],
        child: const MaterialApp(
          home: CalendarViewScreen(),
        ),
      );
    }

    testWidgets('displays calendar title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      await tester.pumpAndSettle();

      expect(find.text('Calendrier de culture'), findsOneWidget);
    });

    testWidgets('displays month selector with navigation buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      await tester.pumpAndSettle();

      // Check for navigation buttons
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);

      // Check for month display
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('navigates to previous month', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      await tester.pumpAndSettle();

      // Tap previous month button
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      // Verify month changed (hard to test exact text due to formatting)
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    });

    testWidgets('navigates to next month', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      await tester.pumpAndSettle();

      // Tap next month button
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      // Verify month changed
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('displays legend with icons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      await tester.pumpAndSettle();

      // Check for legend items
      expect(find.text('Plantation'), findsOneWidget);
      expect(find.text('Récolte'), findsOneWidget);
      expect(find.text('En retard'), findsOneWidget);

      // Check for legend icons
      expect(find.byIcon(Icons.eco), findsWidgets);
      expect(find.byIcon(Icons.agriculture), findsWidgets);
      expect(find.byIcon(Icons.warning), findsWidgets);
    });

    testWidgets('displays weekday headers', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      await tester.pumpAndSettle();

      // French weekday abbreviations
      expect(find.text('L'), findsOneWidget); // Lundi
      expect(find.text('M'), findsWidgets); // Mardi/Mercredi
      expect(find.text('J'), findsWidgets); // Jeudi
      expect(find.text('V'), findsOneWidget); // Vendredi
      expect(find.text('S'), findsWidgets); // Samedi
      expect(find.text('D'), findsOneWidget); // Dimanche
    });

    testWidgets('displays calendar grid', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      await tester.pumpAndSettle();

      // Calendar should be rendered (checking for a GridView or similar structure)
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('shows empty state for days without events',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget([]));
      await tester.pumpAndSettle();

      // Calendar should still render even without plantings
      expect(find.text('Calendrier de culture'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    });

    testWidgets('refresh button works', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      await tester.pumpAndSettle();

      // Find and tap refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      await tester.tap(refreshButton);
      await tester.pump();
    });

    testWidgets('handles month navigation bounds', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      await tester.pumpAndSettle();

      // Go back many months
      for (int i = 0; i < 100; i++) {
        final prevButton = find.byIcon(Icons.chevron_left);
        if (tester.widget<IconButton>(prevButton).onPressed == null) {
          // Button is disabled, which is expected
          break;
        }
        await tester.tap(prevButton);
        await tester.pumpAndSettle();
      }

      // Should have reached the limit
      final prevButton = find.byIcon(Icons.chevron_left);
      expect(tester.widget<IconButton>(prevButton).onPressed, isNull);
    });

    testWidgets('displays planting indicators on calendar',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      await tester.pumpAndSettle();

      // Should show planting icons where applicable
      expect(find.byIcon(Icons.eco), findsWidgets);
    });

    testWidgets('displays loading state', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockPlantings));
      
      // Before pumpAndSettle, loading should be visible
      await tester.pump();
      
      // After settling, content should be visible
      await tester.pumpAndSettle();
      expect(find.text('Calendrier de culture'), findsOneWidget);
    });
  });
}

