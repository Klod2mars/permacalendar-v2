import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/shared/widgets/quick_harvest_widget.dart';

void main() {
  group('QuickHarvestWidget', () {
    late List<Planting> mockReadyPlantings;

    setUp(() {
      mockReadyPlantings = [
        Planting(
          id: 'planting-1',
          plantId: 'plant-1',
          plantName: 'Tomate',
          gardenBedId: 'bed-1',
          plantedDate: DateTime.now().subtract(const Duration(days: 90)),
          quantity: 5,
          status: 'En cours',
          expectedHarvestStartDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Planting(
          id: 'planting-2',
          plantId: 'plant-2',
          plantName: 'Salade',
          gardenBedId: 'bed-1',
          plantedDate: DateTime.now().subtract(const Duration(days: 60)),
          quantity: 10,
          status: 'En cours',
          expectedHarvestStartDate: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Planting(
          id: 'planting-3',
          plantId: 'plant-3',
          plantName: 'Carotte',
          gardenBedId: 'bed-2',
          plantedDate: DateTime.now().subtract(const Duration(days: 100)),
          quantity: 20,
          status: 'En cours',
          expectedHarvestStartDate: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ];
    });

    Widget createTestWidget(List<Planting> readyPlantings) {
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

    testWidgets('displays widget title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      expect(find.text('Récolte rapide'), findsOneWidget);
    });

    testWidgets('displays close button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('close button dismisses dialog', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Widget should be dismissed
      expect(find.text('Récolte rapide'), findsNothing);
    });

    testWidgets('displays search field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Rechercher une plante...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('search field filters plantings', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Initially shows all plantings
      expect(find.text('Tomate'), findsOneWidget);
      expect(find.text('Salade'), findsOneWidget);
      expect(find.text('Carotte'), findsOneWidget);

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Tom');
      await tester.pumpAndSettle();

      // Should only show matching planting
      expect(find.text('Tomate'), findsOneWidget);
      expect(find.text('Salade'), findsNothing);
      expect(find.text('Carotte'), findsNothing);
    });

    testWidgets('clear search button appears when typing',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Enter text
      await tester.enterText(find.byType(TextField), 'Tom');
      await tester.pumpAndSettle();

      // Clear button should appear
      final clearButtons = find.descendant(
        of: find.byType(TextField),
        matching: find.byIcon(Icons.clear),
      );
      expect(clearButtons, findsOneWidget);

      // Tap clear button
      await tester.tap(clearButtons);
      await tester.pumpAndSettle();

      // Search field should be empty
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('displays list of ready plantings', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      expect(find.text('Tomate'), findsOneWidget);
      expect(find.text('Salade'), findsOneWidget);
      expect(find.text('Carotte'), findsOneWidget);

      // Should show quantity and days info
      expect(find.textContaining('Quantité:'), findsWidgets);
      expect(find.textContaining('j'), findsWidgets); // Days indicator
    });

    testWidgets('displays checkboxes for each planting',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      expect(find.byType(Checkbox), findsNWidgets(3));
    });

    testWidgets('can select individual plantings', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Initially no checkboxes should be checked
      final checkboxes = tester.widgetList<Checkbox>(find.byType(Checkbox));
      for (final checkbox in checkboxes) {
        expect(checkbox.value, isFalse);
      }

      // Tap first checkbox
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Selection counter should appear
      expect(find.textContaining('1 plante(s) sélectionnée(s)'), findsOneWidget);
    });

    testWidgets('displays select all button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      expect(find.text('Tout sélectionner'), findsOneWidget);
    });

    testWidgets('select all button selects all plantings',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Tap select all
      await tester.tap(find.text('Tout sélectionner'));
      await tester.pumpAndSettle();

      // Should show selection counter
      expect(find.textContaining('3 plante(s) sélectionnée(s)'), findsOneWidget);
      
      // Button text should change
      expect(find.text('Tout désélectionner'), findsOneWidget);
      expect(find.text('Tout sélectionner'), findsNothing);
    });

    testWidgets('displays harvest button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Harvest button with count
      expect(find.textContaining('Récolter'), findsWidgets);
    });

    testWidgets('harvest button is disabled when nothing selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Find the FilledButton with "Récolter"
      final harvestButtons = find.ancestor(
        of: find.textContaining('Récolter'),
        matching: find.byType(FilledButton),
      );
      
      final button = tester.widget<FilledButton>(harvestButtons.first);
      expect(button.onPressed, isNull);
    });

    testWidgets('harvest button is enabled when plantings selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Select one planting
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Find the FilledButton with "Récolter"
      final harvestButtons = find.ancestor(
        of: find.textContaining('Récolter (1)'),
        matching: find.byType(FilledButton),
      );
      
      final button = tester.widget<FilledButton>(harvestButtons.first);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('displays warning icon for overdue harvests',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Should show warning icons for overdue plantings
      expect(find.byIcon(Icons.warning), findsWidgets);
      expect(find.text('En retard de récolte!'), findsWidgets);
    });

    testWidgets('displays empty state when no plantings ready',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget([]));
      await tester.pumpAndSettle();

      expect(find.text('Aucune plante prête à récolter'), findsOneWidget);
      expect(
        find.text('Les plantes prêtes à être récoltées\napparaîtront ici'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.agriculture), findsWidgets);
    });

    testWidgets('displays icons for plantings', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Should have plant icons for each planting
      expect(find.byIcon(Icons.eco), findsWidgets);
    });

    testWidgets('tapping planting card toggles selection',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Find a planting card by its text
      final plantingCard = find.ancestor(
        of: find.text('Tomate'),
        matching: find.byType(InkWell),
      ).first;

      // Tap the card
      await tester.tap(plantingCard);
      await tester.pumpAndSettle();

      // Should show selection counter
      expect(find.textContaining('1 plante(s) sélectionnée(s)'), findsOneWidget);
    });

    testWidgets('deselect all works', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(mockReadyPlantings));
      await tester.pumpAndSettle();

      // Select all
      await tester.tap(find.text('Tout sélectionner'));
      await tester.pumpAndSettle();

      expect(find.text('Tout désélectionner'), findsOneWidget);

      // Deselect all
      await tester.tap(find.text('Tout désélectionner'));
      await tester.pumpAndSettle();

      // Selection counter should disappear
      expect(find.textContaining('plante(s) sélectionnée(s)'), findsNothing);
    });
  });

  group('QuickHarvestFAB', () {
    testWidgets('displays floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Test')),
            floatingActionButton: QuickHarvestFAB(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Récolte rapide'), findsOneWidget);
      expect(find.byIcon(Icons.agriculture), findsOneWidget);
    });

    testWidgets('FAB opens quick harvest dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plantingsReadyForHarvestProvider.overrideWith((ref) => []),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Test')),
              floatingActionButton: QuickHarvestFAB(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Dialog should open
      expect(find.byType(QuickHarvestWidget), findsOneWidget);
    });
  });
}

