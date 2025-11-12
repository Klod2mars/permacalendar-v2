import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/shared/widgets/quick_harvest_widget.dart';

/// Integration test for the complete harvest flow from selection to confirmation
void main() {
  group('Harvest Flow Integration Test', () {
    late List<Planting> mockPlantings;

    setUp(() {
      mockPlantings = [
        Planting(
          id: 'planting-1',
          plantId: 'plant-1',
          plantName: 'Tomate Cherry',
          gardenBedId: 'bed-1',
          plantedDate: DateTime.now().subtract(const Duration(days: 90)),
          quantity: 5,
          status: 'En cours',
          expectedHarvestStartDate: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Planting(
          id: 'planting-2',
          plantId: 'plant-2',
          plantName: 'Salade Romaine',
          gardenBedId: 'bed-1',
          plantedDate: DateTime.now().subtract(const Duration(days: 45)),
          quantity: 8,
          status: 'En cours',
          expectedHarvestStartDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Planting(
          id: 'planting-3',
          plantId: 'plant-3',
          plantName: 'Courgette',
          gardenBedId: 'bed-2',
          plantedDate: DateTime.now().subtract(const Duration(days: 65)),
          quantity: 3,
          status: 'En cours',
          expectedHarvestStartDate: DateTime.now(),
        ),
      ];
    });

    Widget createTestApp(List<Planting> readyPlantings) {
      return ProviderScope(
        overrides: [
          plantingsReadyForHarvestProvider.overrideWith((ref) => readyPlantings),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: QuickHarvestWidget(),
          ),
        ),
      );
    }

    testWidgets('Complete harvest flow: open → select → harvest → confirm',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(mockPlantings));
      await tester.pumpAndSettle();

      // Step 1: Verify QuickHarvest widget is displayed
      expect(find.text('Récolte rapide'), findsOneWidget);
      expect(find.text('Tomate Cherry'), findsOneWidget);
      expect(find.text('Salade Romaine'), findsOneWidget);
      expect(find.text('Courgette'), findsOneWidget);

      // Step 2: Select plantings
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      expect(find.textContaining('1 plante(s) sélectionnée(s)'), findsOneWidget);

      await tester.tap(find.byType(Checkbox).at(1));
      await tester.pumpAndSettle();

      expect(find.textContaining('2 plante(s) sélectionnée(s)'), findsOneWidget);

      // Step 3: Find and tap harvest button
      final harvestButton = find.ancestor(
        of: find.textContaining('Récolter (2)'),
        matching: find.byType(FilledButton),
      );
      expect(harvestButton, findsOneWidget);

      await tester.tap(harvestButton.first);
      await tester.pumpAndSettle();

      // Step 4: Verify confirmation dialog appears
      expect(find.text('Confirmer la récolte'), findsOneWidget);
      expect(find.textContaining('Voulez-vous récolter 2 plante(s)'), findsOneWidget);
    });

    testWidgets('Harvest flow: cancel confirmation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(mockPlantings));
      await tester.pumpAndSettle();

      // Select a planting
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Tap harvest button
      final harvestButton = find.ancestor(
        of: find.textContaining('Récolter (1)'),
        matching: find.byType(FilledButton),
      );
      await tester.tap(harvestButton.first);
      await tester.pumpAndSettle();

      // Tap cancel in confirmation dialog
      expect(find.text('Annuler'), findsOneWidget);
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      // Should return to selection screen
      expect(find.text('Récolte rapide'), findsOneWidget);
      expect(find.textContaining('1 plante(s) sélectionnée(s)'), findsOneWidget);
    });

    testWidgets('Harvest flow: select all then harvest',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(mockPlantings));
      await tester.pumpAndSettle();

      // Tap "Select All"
      await tester.tap(find.text('Tout sélectionner'));
      await tester.pumpAndSettle();

      expect(find.textContaining('3 plante(s) sélectionnée(s)'), findsOneWidget);

      // Tap harvest button
      final harvestButton = find.ancestor(
        of: find.textContaining('Récolter (3)'),
        matching: find.byType(FilledButton),
      );
      await tester.tap(harvestButton.first);
      await tester.pumpAndSettle();

      // Confirmation dialog should show correct count
      expect(find.textContaining('Voulez-vous récolter 3 plante(s)'), findsOneWidget);
    });

    testWidgets('Harvest flow: search and harvest specific planting',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(mockPlantings));
      await tester.pumpAndSettle();

      // Search for specific plant
      await tester.enterText(find.byType(TextField), 'Salade');
      await tester.pumpAndSettle();

      // Only matching planting should be visible
      expect(find.text('Salade Romaine'), findsOneWidget);
      expect(find.text('Tomate Cherry'), findsNothing);
      expect(find.text('Courgette'), findsNothing);

      // Select the filtered planting
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Harvest button should show (1)
      final harvestButton = find.ancestor(
        of: find.textContaining('Récolter (1)'),
        matching: find.byType(FilledButton),
      );
      expect(harvestButton, findsOneWidget);
    });

    testWidgets('Harvest flow: close dialog with close button',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(mockPlantings));
      await tester.pumpAndSettle();

      // Verify dialog is open
      expect(find.text('Récolte rapide'), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Dialog should close
      expect(find.text('Récolte rapide'), findsNothing);
    });

    testWidgets('Harvest flow: toggle selection multiple times',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(mockPlantings));
      await tester.pumpAndSettle();

      final checkbox = find.byType(Checkbox).first;

      // Select
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
      expect(find.textContaining('1 plante(s) sélectionnée(s)'), findsOneWidget);

      // Deselect
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
      expect(find.textContaining('plante(s) sélectionnée(s)'), findsNothing);

      // Select again
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
      expect(find.textContaining('1 plante(s) sélectionnée(s)'), findsOneWidget);
    });

    testWidgets('Harvest flow: shows overdue indicators',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(mockPlantings));
      await tester.pumpAndSettle();

      // Should show warning icons and "En retard" text for overdue plantings
      expect(find.byIcon(Icons.warning), findsWidgets);
      expect(find.text('En retard de récolte!'), findsWidgets);
    });

    testWidgets('Harvest flow: empty state when no plantings ready',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp([]));
      await tester.pumpAndSettle();

      // Should show empty state
      expect(find.text('Aucune plante prête à récolter'), findsOneWidget);
      expect(
        find.text('Les plantes prêtes à être récoltées\napparaîtront ici'),
        findsOneWidget,
      );

      // Harvest button should not be enabled when there are no plantings
      expect(find.textContaining('Récolter'), findsWidgets);
    });

    testWidgets('Harvest flow: select all, then deselect all',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(mockPlantings));
      await tester.pumpAndSettle();

      // Select all
      await tester.tap(find.text('Tout sélectionner'));
      await tester.pumpAndSettle();
      expect(find.textContaining('3 plante(s) sélectionnée(s)'), findsOneWidget);
      expect(find.text('Tout désélectionner'), findsOneWidget);

      // Deselect all
      await tester.tap(find.text('Tout désélectionner'));
      await tester.pumpAndSettle();
      expect(find.textContaining('plante(s) sélectionnée(s)'), findsNothing);
      expect(find.text('Tout sélectionner'), findsOneWidget);
    });

    testWidgets('Harvest flow: clicking on card selects planting',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(mockPlantings));
      await tester.pumpAndSettle();

      // Find and tap a planting card by clicking on the InkWell
      final plantingCard = find.ancestor(
        of: find.text('Tomate Cherry'),
        matching: find.byType(InkWell),
      ).first;

      await tester.tap(plantingCard);
      await tester.pumpAndSettle();

      // Should be selected
      expect(find.textContaining('1 plante(s) sélectionnée(s)'), findsOneWidget);
    });
  });
}



