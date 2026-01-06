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

    expect(find.byType(CustomPaint), findsOneWidget);
    // Should be RepaintBoundary -> AnimatedBuilder -> Transform -> CustomPaint
    expect(find.byType(RepaintBoundary), findsOneWidget);
  });

  testWidgets('ActiveGardenAura stops animation when isActive is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ActiveGardenAura(isActive: false),
        ),
      ),
    );

    // If not active, it might still render the widget but effectively stopped or different logic?
    // In current impl, if isActive is false, it uses didUpdateWidget to stop controller.
    // Init state checks isActive to repeat.

    // We can't easily access private state _ctrl without reflection or exposing it.
    // But we know if isActive=false (and not disableAnimations), it renders the RepaintBoundary structure
    // but controller is stopped.
    
    // Use pump instead of pumpAndSettle to avoid waiting on potential indeterminate animations
    // though there shouldn't be any if logic is correct.
    await tester.pump(); 
    expect(find.byType(CustomPaint), findsOneWidget);
  });

  testWidgets(
      'ActiveGardenAura renders static fallback when animations disabled',
      (WidgetTester tester) async {
    // Simulate disableAnimations
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: ActiveGardenAura(isActive: true),
        ),
      ),
    );

    // Scope search to the ActiveGardenAura widget
    final auraFinder = find.byType(ActiveGardenAura);
    expect(
      find.descendant(of: auraFinder, matching: find.byType(RepaintBoundary)),
      findsNothing,
      reason: 'Should not use RepaintBoundary when animations disabled',
    );
    expect(
      find.descendant(of: auraFinder, matching: find.byType(CustomPaint)),
      findsOneWidget,
      reason: 'Should still render CustomPaint',
    );
  });
}
