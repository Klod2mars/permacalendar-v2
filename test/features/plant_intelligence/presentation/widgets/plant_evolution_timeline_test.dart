import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_evolution_report.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_evolution_providers.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/widgets/evolution/plant_evolution_timeline.dart';

/// 🧪 CURSOR PROMPT A8 - PlantEvolutionTimeline Widget Tests
/// 
/// Tests pour le widget PlantEvolutionTimeline
/// 
/// **Scénarios testés :**
/// - État vide (pas d'évolutions)
/// - État de chargement
/// - État d'erreur
/// - Affichage d'évolutions multiples
/// - Filtres temporels
void main() {
  group('PlantEvolutionTimeline Widget Tests', () {
    
    // Helper pour créer un PlantEvolutionReport de test
    PlantEvolutionReport createTestEvolution({
      required String plantId,
      required DateTime previousDate,
      required DateTime currentDate,
      required double previousScore,
      required double currentScore,
      required String trend,
      List<String> improvedConditions = const [],
      List<String> degradedConditions = const [],
    }) {
      return PlantEvolutionReport(
        plantId: plantId,
        previousDate: previousDate,
        currentDate: currentDate,
        previousScore: previousScore,
        currentScore: currentScore,
        deltaScore: currentScore - previousScore,
        trend: trend,
        improvedConditions: improvedConditions,
        degradedConditions: degradedConditions,
        unchangedConditions: const [],
      );
    }

    testWidgets('Affiche l\'état vide quand aucune évolution n\'existe', (tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          plantEvolutionHistoryProvider('test-plant').overrideWith(
            (ref) => Future.value([]),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PlantEvolutionTimeline(plantId: 'test-plant'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Aucune évolution enregistrée'), findsOneWidget);
      expect(find.byIcon(Icons.timeline), findsOneWidget);
      expect(find.text('Les évolutions de santé apparaîtront ici après votre première analyse d\'intelligence végétale.'), findsOneWidget);
    });

    testWidgets('Affiche l\'indicateur de chargement pendant la récupération', (tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          plantEvolutionHistoryProvider('test-plant').overrideWith(
            (ref) => Future.delayed(
              const Duration(seconds: 10),
              () => [],
            ),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PlantEvolutionTimeline(plantId: 'test-plant'),
            ),
          ),
        ),
      );
      
      // Wait for first frame
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Chargement de l\'historique...'), findsOneWidget);
    });

    testWidgets('Affiche l\'état d\'erreur en cas d\'échec', (tester) async {
      // Arrange
      const errorMessage = 'Erreur de connexion';
      final container = ProviderContainer(
        overrides: [
          plantEvolutionHistoryProvider('test-plant').overrideWith(
            (ref) => Future.error(Exception(errorMessage)),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PlantEvolutionTimeline(plantId: 'test-plant'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Erreur de chargement'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.textContaining('Impossible de récupérer l\'historique'), findsOneWidget);
    });

    testWidgets('Affiche correctement une liste d\'évolutions', (tester) async {
      // Arrange
      final now = DateTime.now();
      final evolutions = [
        createTestEvolution(
          plantId: 'test-plant',
          previousDate: now.subtract(const Duration(days: 14)),
          currentDate: now.subtract(const Duration(days: 7)),
          previousScore: 70.0,
          currentScore: 80.0,
          trend: 'up',
          improvedConditions: ['temperature', 'humidity'],
        ),
        createTestEvolution(
          plantId: 'test-plant',
          previousDate: now.subtract(const Duration(days: 7)),
          currentDate: now,
          previousScore: 80.0,
          currentScore: 85.0,
          trend: 'up',
          improvedConditions: ['light'],
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          plantEvolutionHistoryProvider('test-plant').overrideWith(
            (ref) => Future.value(evolutions),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PlantEvolutionTimeline(plantId: 'test-plant'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - vérifie que les évolutions sont affichées
      expect(find.byType(Card), findsAtLeastNWidgets(2));
      expect(find.byIcon(Icons.trending_up), findsAtLeastNWidgets(2));
    });

    testWidgets('Affiche les icônes de tendance correctes', (tester) async {
      // Arrange
      final now = DateTime.now();
      final evolutions = [
        createTestEvolution(
          plantId: 'test-plant',
          previousDate: now.subtract(const Duration(days: 7)),
          currentDate: now,
          previousScore: 80.0,
          currentScore: 85.0,
          trend: 'up',
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          plantEvolutionHistoryProvider('test-plant').overrideWith(
            (ref) => Future.value(evolutions),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PlantEvolutionTimeline(plantId: 'test-plant'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - vérifie l'icône de tendance à la hausse
      expect(find.byIcon(Icons.trending_up), findsWidgets);
      expect(find.text('📈'), findsOneWidget);
    });

    testWidgets('Affiche les filtres temporels quand showTimeFilter est true', (tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          plantEvolutionHistoryProvider('test-plant').overrideWith(
            (ref) => Future.value([]),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PlantEvolutionTimeline(
                plantId: 'test-plant',
                showTimeFilter: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Tous'), findsOneWidget);
      expect(find.text('30 jours'), findsOneWidget);
      expect(find.text('90 jours'), findsOneWidget);
      expect(find.text('1 an'), findsOneWidget);
    });

    testWidgets('Le filtre temporel change l\'état sélectionné', (tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          plantEvolutionHistoryProvider('test-plant').overrideWith(
            (ref) => Future.value([]),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PlantEvolutionTimeline(
                plantId: 'test-plant',
                showTimeFilter: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap sur le filtre "30 jours"
      await tester.tap(find.text('30 jours'));
      await tester.pumpAndSettle();

      // Assert - le provider devrait être mis à jour
      final selectedPeriod = container.read(selectedTimePeriodProvider);
      expect(selectedPeriod, 30);
    });

    testWidgets('Affiche les conditions améliorées et dégradées', (tester) async {
      // Arrange
      final now = DateTime.now();
      final evolutions = [
        createTestEvolution(
          plantId: 'test-plant',
          previousDate: now.subtract(const Duration(days: 7)),
          currentDate: now,
          previousScore: 70.0,
          currentScore: 80.0,
          trend: 'up',
          improvedConditions: ['temperature', 'humidity'],
          degradedConditions: ['soil'],
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          plantEvolutionHistoryProvider('test-plant').overrideWith(
            (ref) => Future.value(evolutions),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PlantEvolutionTimeline(plantId: 'test-plant'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Conditions améliorées'), findsOneWidget);
      expect(find.text('Conditions dégradées'), findsOneWidget);
      
      // Vérifie que les chips de conditions sont affichés
      expect(find.byType(Chip), findsAtLeastNWidgets(3)); // 2 améliorées + 1 dégradée
    });

    testWidgets('Cache les filtres temporels quand showTimeFilter est false', (tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          plantEvolutionHistoryProvider('test-plant').overrideWith(
            (ref) => Future.value([]),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PlantEvolutionTimeline(
                plantId: 'test-plant',
                showTimeFilter: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Tous'), findsNothing);
      expect(find.text('30 jours'), findsNothing);
    });

    testWidgets('Affiche les scores et deltas correctement', (tester) async {
      // Arrange
      final now = DateTime.now();
      final evolutions = [
        createTestEvolution(
          plantId: 'test-plant',
          previousDate: now.subtract(const Duration(days: 7)),
          currentDate: now,
          previousScore: 70.0,
          currentScore: 82.5,
          trend: 'up',
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          plantEvolutionHistoryProvider('test-plant').overrideWith(
            (ref) => Future.value(evolutions),
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: PlantEvolutionTimeline(plantId: 'test-plant'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('82.5'), findsOneWidget); // Score actuel
      expect(find.textContaining('+12.5 pts'), findsOneWidget); // Delta
    });
  });
}



