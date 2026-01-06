import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/shared/widgets/active_garden_aura.dart';
import 'package:permacalendar/shared/widgets/garden_bubble_widget.dart';

void main() {
  testWidgets('GardenBubbleWidget shows active aura and semantics when active',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GardenBubbleWidget(
            gardenName: 'Potager',
            radius: 50.0,
            onTap: () {},
            isActive: true,
            assetPath: 'assets/images/dashboard/bubbles/bubble_garden.webp',
          ),
        ),
      ),
    );

    // Verify Semantics
    expect(find.bySemanticsLabel('Potager — jardin actif'), findsOneWidget);

    // Verify ActiveGardenAura is present
    expect(find.byType(ActiveGardenAura), findsOneWidget);
  });

  testWidgets('GardenBubbleWidget hides aura when not active',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GardenBubbleWidget(
            gardenName: 'Potager',
            radius: 50.0,
            onTap: () {},
            isActive: false,
            assetPath: 'assets/images/dashboard/bubbles/bubble_garden.webp',
          ),
        ),
      ),
    );

    // Verify Semantics label is just the name (default behavior of container/text usually)
    // Note: GardenBubbleWidget wraps Container in Semantics only?
    // Looking at code:
    // child: Semantics(
    //    label: isActive ? '$gardenName — jardin actif' : gardenName,
    
    expect(find.bySemanticsLabel('Potager'), findsOneWidget);
    expect(find.bySemanticsLabel('Potager — jardin actif'), findsNothing);

    // Verify ActiveGardenAura is NOT present
    expect(find.byType(ActiveGardenAura), findsNothing);
  });
}
