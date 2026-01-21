// test/features/plant_catalog/presentation/widgets/sowing_picker_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/plant_catalog/presentation/widgets/sowing_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

void main() {
  // Widget wrappers for Riverpod + Localization
  Widget createWidgetUnderTest(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr')], // Test in French
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('SowingPicker displays toggles and opens results', (WidgetTester tester) async {
    final plant = PlantFreezed.create(
      commonName: 'Test Plant',
      scientificName: '', family: '', plantingSeason: '', harvestSeason: '',
      daysToMaturity: 1, spacing: 1, depth: 1, sunExposure: '', waterNeeds: '', description: '',
      sowingMonths: ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'], // All year
      harvestMonths: [],
      metadata: {'sowingMonths3': ['Jan-Dec']}
    );

    PlantFreezed? selected;

    await tester.pumpWidget(createWidgetUnderTest(
      SowingPicker(
        plants: [plant],
        onPlantSelected: (p) => selected = p,
      )
    ));
    await tester.pumpAndSettle();

    // Check toggles exist
    expect(find.text('Semer'), findsOneWidget);
    expect(find.text('Planter'), findsOneWidget);

    // Initial state: Semer is selected (checking based on ToggleButtons internal logic is hard, but we can tap)
    await tester.tap(find.text('Planter'));
    await tester.pumpAndSettle();

    // Open results
    await tester.tap(find.text('Afficher sélection'));
    await tester.pumpAndSettle(); // Animation for bottom sheet

    // Check bottom sheet content
    // 'Planter' appears in the ToggleButtons (background) and the Modal Title.
    expect(find.text('Planter'), findsAtLeastNWidgets(1)); 
    expect(find.text('Test Plant'), findsOneWidget);

    // Tap the plant
    await tester.tap(find.text('Test Plant'));
    await tester.pumpAndSettle();

    // Verify callback
    expect(selected, isNotNull);
    expect(selected!.commonName, 'Test Plant');
  });
}
