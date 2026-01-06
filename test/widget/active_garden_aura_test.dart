import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/shared/widgets/active_garden_aura.dart';

void main() {
  testWidgets('ActiveGardenAura renders CustomPaint when active',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ActiveGardenAura(isActive: true),
        ),
      ),
    );

    final auraFinder = find.byType(ActiveGardenAura);
    expect(
      find.descendant(of: auraFinder, matching: find.byType(CustomPaint)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: auraFinder, matching: find.byType(RepaintBoundary)),
      findsOneWidget,
    );
  });

  testWidgets('ActiveGardenAura respects reduced motion',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: ActiveGardenAura(isActive: true),
        ),
      ),
    );

    // When reduced motion is active, we expect NO RepaintBoundary (which wraps the animation)
    expect(find.byType(RepaintBoundary), findsNothing);
    // But CustomPaint should be there (static fallback)
    expect(find.byType(CustomPaint), findsOneWidget);
  });
}
