import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/activities/application/providers/garden_history_provider.dart';
import 'package:permacalendar/features/activities/domain/models/garden_history.dart';
import 'package:permacalendar/features/activities/presentation/widgets/garden_history_widget.dart';

void main() {
  testWidgets('GardenHistoryWidget displays years and beds correctly', (draft) async {
    final history = GardenHistory(
      gardenId: 'g1',
      gardenName: 'Test Garden',
      years: [
        YearPage(
          year: 2026,
          beds: [
            BedYearHistory(
              bedId: 'b1',
              bedName: 'Bed 1',
              year: 2026,
              plants: [
                PlantHistory(plantId: 'p1', plantName: 'Tomato'),
              ],
            ),
          ],
        ),
        YearPage(
          year: 2025,
          beds: [
            BedYearHistory(
              bedId: 'b1',
              bedName: 'Bed 1',
              year: 2025,
              plants: [],
            ),
          ],
        ),
      ],
    );

    await draft.pumpWidget(
      ProviderScope(
        overrides: [
          gardenHistoryProvider('g1').overrideWith((ref) => Future.value(history)),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: GardenHistoryWidget(gardenId: 'g1'),
          ),
        ),
      ),
    );

    // Initial load might be async, pump
    await draft.pump(const Duration(milliseconds: 100)); // Allow Future to complete
    await draft.pump();

    // Checks
    expect(find.text('Année 2026'), findsOneWidget);
    expect(find.text('Bed 1'), findsOneWidget);
    expect(find.text('Tomato'), findsOneWidget);

    // Swipe to next page (previous year 2025)
    // Actually using buttons arrow_back/forward
    // Arrow back (left) -> next page (older)? Or previous?
    // In code:
    // Left arrow: _pageController.nextPage (duration...)
    // Right arrow: _pageController.previousPage
    
    // Tap left arrow (back in time?) logic in code:
    // arrow_back_ios onPressed: nextPage.
    // PageView uses index 0, 1, 2.
    // index 0 = 2026. index 1 = 2025.
    // nextPage goes to 2025.
    
    await draft.tap(find.byIcon(Icons.arrow_back_ios));
    await draft.pumpAndSettle();

    expect(find.text('Année 2025'), findsOneWidget);
    expect(find.text('Aucune plantation'), findsOneWidget);
  });
}
