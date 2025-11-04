import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_evolution_report.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_evolution_providers.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/widgets/plant_health_degradation_banner.dart';

void main() {
  group('PlantHealthDegradationBanner', () {
    testWidgets('should not display when no evolution data exists',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            latestEvolutionProvider('test-plant-id').overrideWith(
              (ref) => Future.value(null),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PlantHealthDegradationBanner(
                plantId: 'test-plant-id',
                plantName: 'Test Plant',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PlantHealthDegradationBanner), findsOneWidget);
      expect(find.text('⚠️'),
          findsNothing); // Banner content should not be visible
    });

    testWidgets('should not display when evolution shows improvement',
        (WidgetTester tester) async {
      // Arrange - Evolution with positive delta
      final evolution = PlantEvolutionReport(
        plantId: 'test-plant-id',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 8),
        previousScore: 70.0,
        currentScore: 75.0,
        deltaScore: 5.0,
        trend: 'up',
        improvedConditions: ['water', 'light'],
        degradedConditions: [],
        stableConditions: ['temperature'],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            latestEvolutionProvider('test-plant-id').overrideWith(
              (ref) => Future.value(evolution),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PlantHealthDegradationBanner(
                plantId: 'test-plant-id',
                plantName: 'Test Plant',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('⚠️'), findsNothing);
      expect(find.text('Santé en baisse'), findsNothing);
    });

    testWidgets('should display banner when deltaScore < -1.0',
        (WidgetTester tester) async {
      // Arrange - Evolution with significant degradation
      final evolution = PlantEvolutionReport(
        plantId: 'test-plant-id',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 8),
        previousScore: 80.0,
        currentScore: 75.0,
        deltaScore: -5.0,
        trend: 'down',
        improvedConditions: [],
        degradedConditions: ['water', 'nutrients'],
        stableConditions: ['temperature'],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            latestEvolutionProvider('test-plant-id').overrideWith(
              (ref) => Future.value(evolution),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PlantHealthDegradationBanner(
                plantId: 'test-plant-id',
                plantName: 'Test Plant',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('⚠️'), findsOneWidget);
      expect(find.text('Santé en baisse'), findsOneWidget);
      expect(
          find.text('Score baissé de 5.0 points en 7 jours'), findsOneWidget);
    });

    testWidgets('should display banner when trend is down',
        (WidgetTester tester) async {
      // Arrange - Evolution with down trend but small delta
      final evolution = PlantEvolutionReport(
        plantId: 'test-plant-id',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 5),
        previousScore: 75.0,
        currentScore: 74.0,
        deltaScore: -1.0,
        trend: 'down',
        improvedConditions: [],
        degradedConditions: ['light'],
        stableConditions: ['water', 'temperature'],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            latestEvolutionProvider('test-plant-id').overrideWith(
              (ref) => Future.value(evolution),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PlantHealthDegradationBanner(
                plantId: 'test-plant-id',
                plantName: 'Test Plant',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('⚠️'), findsOneWidget);
      expect(find.text('Santé en baisse'), findsOneWidget);
    });

    testWidgets('should show expanded content when banner is tapped',
        (WidgetTester tester) async {
      // Arrange
      final evolution = PlantEvolutionReport(
        plantId: 'test-plant-id',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 8),
        previousScore: 80.0,
        currentScore: 72.0,
        deltaScore: -8.0,
        trend: 'down',
        improvedConditions: [],
        degradedConditions: ['water', 'nutrients', 'light'],
        stableConditions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            latestEvolutionProvider('test-plant-id').overrideWith(
              (ref) => Future.value(evolution),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PlantHealthDegradationBanner(
                plantId: 'test-plant-id',
                plantName: 'Test Plant',
                isExpandable: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Expanded content should be visible initially
      expect(find.text('Score actuel'), findsOneWidget);
      expect(find.text('Variation'), findsOneWidget);
      expect(find.text('72.0'), findsOneWidget);
      expect(find.text('-8.0 pts'), findsOneWidget);
      expect(find.text('Conditions affectées:'), findsOneWidget);
      expect(find.text('Eau'), findsOneWidget);
      expect(find.text('Nutriments'), findsOneWidget);
      expect(find.text('Lumière'), findsOneWidget);

      // Act - Tap to collapse
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Assert - Content should be collapsed
      expect(find.text('Score actuel'), findsNothing);
      expect(find.text('Conditions affectées:'), findsNothing);
    });

    testWidgets('should display CTA button with correct text',
        (WidgetTester tester) async {
      // Arrange
      final evolution = PlantEvolutionReport(
        plantId: 'test-plant-id',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 8),
        previousScore: 80.0,
        currentScore: 75.0,
        deltaScore: -5.0,
        trend: 'down',
        improvedConditions: [],
        degradedConditions: ['water'],
        stableConditions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            latestEvolutionProvider('test-plant-id').overrideWith(
              (ref) => Future.value(evolution),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PlantHealthDegradationBanner(
                plantId: 'test-plant-id',
                plantName: 'Test Plant',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Voir l\'historique complet'), findsOneWidget);
      expect(
          find.widgetWithIcon(ElevatedButton, Icons.timeline), findsOneWidget);
    });

    testWidgets('should format condition names correctly',
        (WidgetTester tester) async {
      // Arrange - Test French translations
      final evolution = PlantEvolutionReport(
        plantId: 'test-plant-id',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 8),
        previousScore: 80.0,
        currentScore: 70.0,
        deltaScore: -10.0,
        trend: 'down',
        improvedConditions: [],
        degradedConditions: ['temperature', 'humidity', 'soil'],
        stableConditions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            latestEvolutionProvider('test-plant-id').overrideWith(
              (ref) => Future.value(evolution),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PlantHealthDegradationBanner(
                plantId: 'test-plant-id',
                plantName: 'Test Plant',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Check French translations
      expect(find.text('Température'), findsOneWidget);
      expect(find.text('Humidité'), findsOneWidget);
      expect(find.text('Sol'), findsOneWidget);
    });

    testWidgets('should not be expandable when isExpandable is false',
        (WidgetTester tester) async {
      // Arrange
      final evolution = PlantEvolutionReport(
        plantId: 'test-plant-id',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 8),
        previousScore: 80.0,
        currentScore: 75.0,
        deltaScore: -5.0,
        trend: 'down',
        improvedConditions: [],
        degradedConditions: ['water'],
        stableConditions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            latestEvolutionProvider('test-plant-id').overrideWith(
              (ref) => Future.value(evolution),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PlantHealthDegradationBanner(
                plantId: 'test-plant-id',
                plantName: 'Test Plant',
                isExpandable: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should not show expand/collapse icon
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);

      // Should not show expanded content
      expect(find.text('Score actuel'), findsNothing);
      expect(find.text('Conditions affectées:'), findsNothing);
    });

    testWidgets('should display correct color scheme for degradation',
        (WidgetTester tester) async {
      // Arrange
      final evolution = PlantEvolutionReport(
        plantId: 'test-plant-id',
        previousDate: DateTime(2024, 1, 1),
        currentDate: DateTime(2024, 1, 8),
        previousScore: 80.0,
        currentScore: 75.0,
        deltaScore: -5.0,
        trend: 'down',
        improvedConditions: [],
        degradedConditions: ['water'],
        stableConditions: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            latestEvolutionProvider('test-plant-id').overrideWith(
              (ref) => Future.value(evolution),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PlantHealthDegradationBanner(
                plantId: 'test-plant-id',
                plantName: 'Test Plant',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should find orange-themed widgets
      final card = tester.widget<Card>(find.byType(Card).first);
      expect(card.color, equals(Colors.orange.shade50));

      // Should find trending_down icon
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });
  });
}
