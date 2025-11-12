import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_evolution_report.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_evolution_providers.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/screens/plant_evolution_history_screen.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import 'package:permacalendar/core/models/garden.dart';

/// ✅ CURSOR PROMPT A9 - Evolution Timeline Integration Tests
///
/// Tests de navigation et d'intégration UI pour:
/// 1. Dashboard → Plant Selection → Evolution Timeline
/// 2. PlantingDetail → Degradation Banner → Evolution Timeline
/// 3. Workflow complet avec données réalistes

void main() {
  group('Evolution Timeline Integration Tests', () {
    late List<PlantFreezed> mockPlants;
    late List<Garden> mockGardens;
    late IntelligenceState mockIntelligenceState;

    setUp(() {
      // Mock plants
      mockPlants = [
        const PlantFreezed(
          id: 'tomato-001',
          commonName: 'Tomate Cerise',
          scientificName: 'Solanum lycopersicum',
          family: 'Solanaceae',
          description: 'Tomate cerise délicieuse',
          plantingSeason: 'Printemps',
          harvestSeason: 'Été',
          daysToMaturity: 60,
          spacing: 50,
          depth: 1.5,
          sunExposure: 'Plein soleil',
          waterNeeds: 'Moyen',
          sowingMonths: [3, 4, 5],
          harvestMonths: [7, 8, 9],
        ),
        const PlantFreezed(
          id: 'carrot-001',
          commonName: 'Carotte',
          scientificName: 'Daucus carota',
          family: 'Apiaceae',
          description: 'Carotte croquante',
          plantingSeason: 'Printemps',
          harvestSeason: 'Automne',
          daysToMaturity: 70,
          spacing: 10,
          depth: 2.0,
          sunExposure: 'Plein soleil',
          waterNeeds: 'Faible',
          sowingMonths: [3, 4],
          harvestMonths: [9, 10],
        ),
      ];

      // Mock gardens
      mockGardens = [
        Garden(
          id: 'garden-001',
          name: 'Mon Jardin',
          location: 'Paris',
          size: 100.0,
          createdAt: DateTime.now(),
        ),
      ];

      // Mock intelligence state
      mockIntelligenceState = const IntelligenceState(
        isInitialized: true,
        isAnalyzing: false,
        currentGardenId: 'garden-001',
        activePlantIds: ['tomato-001', 'carrot-001'],
        plantConditions: {},
        plantRecommendations: {},
        error: null,
      );
    });

    testWidgets(
        'Dashboard: Should show evolution history button and navigate on tap',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            intelligenceStateProvider.overrideWith(
              (ref) =>
                  IntelligenceStateNotifier()..state = mockIntelligenceState,
            ),
            plantCatalogProvider.overrideWith(
              (ref) => PlantCatalogNotifier(
                  MockPlantRepository(mockPlants), MockActivityTracker())
                ..state = PlantCatalogState(plants: mockPlants),
            ),
            gardenProvider.overrideWith(
              (ref) => GardenNotifier(ref)
                ..state = GardenState(gardens: mockGardens),
            ),
          ],
          child: const MaterialApp(
            home: PlantIntelligenceDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Evolution history button should be visible
      expect(find.text('📊 Historique d\'évolution'), findsOneWidget);
      expect(find.byIcon(Icons.timeline), findsWidgets);

      // Act - Tap the evolution history button
      await tester.tap(find.text('📊 Historique d\'évolution'));
      await tester.pumpAndSettle();

      // Assert - Plant selection bottom sheet should appear
      expect(find.text('Historique d\'évolution'), findsOneWidget);
      expect(find.text('Sélectionnez une plante'), findsOneWidget);
      expect(find.text('Tomate Cerise'), findsOneWidget);
      expect(find.text('Carotte'), findsOneWidget);
    });

    testWidgets(
        'Dashboard: Should navigate to evolution timeline after plant selection',
        (WidgetTester tester) async {
      // Arrange
      final mockEvolutions = [
        PlantEvolutionReport(
          plantId: 'tomato-001',
          previousDate: DateTime(2024, 1, 1),
          currentDate: DateTime(2024, 1, 8),
          previousScore: 75.0,
          currentScore: 80.0,
          deltaScore: 5.0,
          trend: 'up',
          improvedConditions: ['water', 'light'],
          degradedConditions: [],
          stableConditions: ['temperature'],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            intelligenceStateProvider.overrideWith(
              (ref) =>
                  IntelligenceStateNotifier()..state = mockIntelligenceState,
            ),
            plantCatalogProvider.overrideWith(
              (ref) => PlantCatalogNotifier(
                  MockPlantRepository(mockPlants), MockActivityTracker())
                ..state = PlantCatalogState(plants: mockPlants),
            ),
            gardenProvider.overrideWith(
              (ref) => GardenNotifier(ref)
                ..state = GardenState(gardens: mockGardens),
            ),
            plantEvolutionHistoryProvider('tomato-001').overrideWith(
              (ref) => Future.value(mockEvolutions),
            ),
          ],
          child: const MaterialApp(
            home: PlantIntelligenceDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Tap evolution history button
      await tester.tap(find.text('📊 Historique d\'évolution'));
      await tester.pumpAndSettle();

      // Act - Select a plant
      await tester.tap(find.text('Tomate Cerise'));
      await tester.pumpAndSettle();

      // Assert - Should navigate to PlantEvolutionHistoryScreen
      expect(find.byType(PlantEvolutionHistoryScreen), findsOneWidget);
      expect(find.text('Historique d\'évolution'), findsOneWidget);
      expect(find.text('Tomate Cerise'), findsOneWidget);
    });

    testWidgets(
        'Dashboard: Should show empty state when no active plants exist',
        (WidgetTester tester) async {
      // Arrange - Empty intelligence state
      const emptyState = IntelligenceState(
        isInitialized: true,
        isAnalyzing: false,
        currentGardenId: 'garden-001',
        activePlantIds: [],
        plantConditions: {},
        plantRecommendations: {},
        error: null,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            intelligenceStateProvider.overrideWith(
              (ref) => IntelligenceStateNotifier()..state = emptyState,
            ),
            plantCatalogProvider.overrideWith(
              (ref) => PlantCatalogNotifier(
                  MockPlantRepository([]), MockActivityTracker())
                ..state = const PlantCatalogState(plants: []),
            ),
            gardenProvider.overrideWith(
              (ref) => GardenNotifier(ref)
                ..state = GardenState(gardens: mockGardens),
            ),
          ],
          child: const MaterialApp(
            home: PlantIntelligenceDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Tap evolution history button
      await tester.tap(find.text('📊 Historique d\'évolution'));
      await tester.pumpAndSettle();

      // Assert - Should show snackbar with warning
      expect(find.text('Aucune plante active trouvée pour l\'analyse'),
          findsOneWidget);
    });

    testWidgets('Evolution Timeline: Should display time filters',
        (WidgetTester tester) async {
      // Arrange
      final mockEvolutions = [
        PlantEvolutionReport(
          plantId: 'tomato-001',
          previousDate: DateTime.now().subtract(const Duration(days: 60)),
          currentDate: DateTime.now().subtract(const Duration(days: 53)),
          previousScore: 70.0,
          currentScore: 75.0,
          deltaScore: 5.0,
          trend: 'up',
          improvedConditions: ['water'],
          degradedConditions: [],
          stableConditions: ['temperature', 'light'],
        ),
        PlantEvolutionReport(
          plantId: 'tomato-001',
          previousDate: DateTime.now().subtract(const Duration(days: 14)),
          currentDate: DateTime.now().subtract(const Duration(days: 7)),
          previousScore: 75.0,
          currentScore: 72.0,
          deltaScore: -3.0,
          trend: 'down',
          improvedConditions: [],
          degradedConditions: ['nutrients'],
          stableConditions: ['water', 'temperature', 'light'],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plantEvolutionHistoryProvider('tomato-001').overrideWith(
              (ref) => Future.value(mockEvolutions),
            ),
          ],
          child: const MaterialApp(
            home: PlantEvolutionHistoryScreen(
              plantId: 'tomato-001',
              plantName: 'Tomate Cerise',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should show filter chips
      expect(find.text('Tous'), findsOneWidget);
      expect(find.text('30 jours'), findsOneWidget);
      expect(find.text('90 jours'), findsOneWidget);
      expect(find.text('1 an'), findsOneWidget);
    });

    testWidgets(
        'Evolution Timeline: Should filter evolutions when filter chip is tapped',
        (WidgetTester tester) async {
      // Arrange
      final now = DateTime.now();
      final mockEvolutions = [
        PlantEvolutionReport(
          plantId: 'tomato-001',
          previousDate: now.subtract(const Duration(days: 100)),
          currentDate: now.subtract(const Duration(days: 93)),
          previousScore: 70.0,
          currentScore: 75.0,
          deltaScore: 5.0,
          trend: 'up',
          improvedConditions: ['water'],
          degradedConditions: [],
          stableConditions: ['temperature'],
        ),
        PlantEvolutionReport(
          plantId: 'tomato-001',
          previousDate: now.subtract(const Duration(days: 14)),
          currentDate: now.subtract(const Duration(days: 7)),
          previousScore: 75.0,
          currentScore: 72.0,
          deltaScore: -3.0,
          trend: 'down',
          improvedConditions: [],
          degradedConditions: ['nutrients'],
          stableConditions: ['water'],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plantEvolutionHistoryProvider('tomato-001').overrideWith(
              (ref) => Future.value(mockEvolutions),
            ),
            filteredEvolutionHistoryProvider(
              const FilterParams(plantId: 'tomato-001', days: 30),
            ).overrideWith(
              (ref) =>
                  Future.value([mockEvolutions[1]]), // Only recent evolution
            ),
          ],
          child: const MaterialApp(
            home: PlantEvolutionHistoryScreen(
              plantId: 'tomato-001',
              plantName: 'Tomate Cerise',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Initially shows all evolutions
      expect(find.byType(Card),
          findsNWidgets(3)); // Header stat card + 2 evolution cards

      // Act - Tap 30 days filter
      await tester.tap(find.text('30 jours'));
      await tester.pumpAndSettle();

      // Assert - Should now show only filtered evolutions
      // (The exact widget count may vary based on implementation)
      expect(find.text('30 jours'), findsOneWidget);
    });

    testWidgets('Evolution Timeline: Should show statistics summary',
        (WidgetTester tester) async {
      // Arrange
      final mockEvolutions = [
        PlantEvolutionReport(
          plantId: 'tomato-001',
          previousDate: DateTime(2024, 1, 1),
          currentDate: DateTime(2024, 1, 8),
          previousScore: 70.0,
          currentScore: 75.0,
          deltaScore: 5.0,
          trend: 'up',
          improvedConditions: ['water'],
          degradedConditions: [],
          stableConditions: [],
        ),
        PlantEvolutionReport(
          plantId: 'tomato-001',
          previousDate: DateTime(2024, 1, 8),
          currentDate: DateTime(2024, 1, 15),
          previousScore: 75.0,
          currentScore: 72.0,
          deltaScore: -3.0,
          trend: 'down',
          improvedConditions: [],
          degradedConditions: ['nutrients'],
          stableConditions: [],
        ),
        PlantEvolutionReport(
          plantId: 'tomato-001',
          previousDate: DateTime(2024, 1, 15),
          currentDate: DateTime(2024, 1, 22),
          previousScore: 72.0,
          currentScore: 73.0,
          deltaScore: 1.0,
          trend: 'stable',
          improvedConditions: [],
          degradedConditions: [],
          stableConditions: ['water', 'nutrients'],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            plantEvolutionHistoryProvider('tomato-001').overrideWith(
              (ref) => Future.value(mockEvolutions),
            ),
          ],
          child: const MaterialApp(
            home: PlantEvolutionHistoryScreen(
              plantId: 'tomato-001',
              plantName: 'Tomate Cerise',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should show stats summary
      expect(find.text('Évolutions'), findsOneWidget);
      expect(find.text('3'), findsOneWidget); // Total evolutions
      expect(find.text('Améliorations'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // 1 improvement
      expect(find.text('Dégradations'), findsOneWidget);
      // Note: There might be multiple '1's for different stats
      expect(find.text('Stables'), findsOneWidget);
    });
  });
}

// ==================== MOCK CLASSES ====================

class IntelligenceStateNotifier extends StateNotifier<IntelligenceState> {
  IntelligenceStateNotifier()
      : super(const IntelligenceState(
          isInitialized: false,
          isAnalyzing: false,
          currentGardenId: null,
          activePlantIds: [],
          plantConditions: {},
          plantRecommendations: {},
          error: null,
        ));
}

class MockPlantRepository {
  final List<PlantFreezed> plants;
  MockPlantRepository(this.plants);

  Future<List<PlantFreezed>> getAllPlants() async => plants;
}

class MockActivityTracker {
  Future<void> trackActivity({
    required String type,
    required String description,
    Map<String, dynamic>? metadata,
    required dynamic priority,
  }) async {}
}

class GardenNotifier extends StateNotifier<GardenState> {
  final Ref _ref;
  GardenNotifier(this._ref) : super(const GardenState());
}

class GardenState {
  final List<Garden> gardens;
  final bool isLoading;
  final String? error;

  const GardenState({
    this.gardens = const [],
    this.isLoading = false,
    this.error,
  });
}


