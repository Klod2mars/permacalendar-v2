import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendarv2/core/models/app_settings.dart';
import 'package:permacalendarv2/core/models/garden_v2.dart';
import 'package:permacalendarv2/core/providers/activity_tracker_v3_provider.dart';
import 'package:permacalendarv2/core/providers/app_settings_provider.dart';
import 'package:permacalendarv2/core/providers/garden_aggregation_providers.dart';
import 'package:permacalendarv2/features/activities/presentation/screens/activities_screen.dart';
import 'package:permacalendarv2/features/activities/presentation/widgets/history_hint_card.dart';
import 'package:permacalendarv2/features/garden/providers/garden_provider.dart';
import 'package:permacalendarv2/features/garden/state/garden_state.dart';

// Mock implementations
class MockAppSettingsNotifier extends AppSettingsNotifier {
  @override
  AppSettings build() => AppSettings.defaults();

  @override
  Future<void> setShowHistoryHint(bool value) async {
    state = state.copyWith(showHistoryHint: value);
  }
}

class MockGardenNotifier extends GardenNotifier {
  final GardenState _initialState;
  
  MockGardenNotifier(this._initialState);

  @override
  GardenState build() {
    return _initialState;
  }
  
  @override
  Future<void> loadGardens() async {}
}

class MockRecentActivitiesNotifier extends RecentActivitiesNotifier {
  @override
  Future<List<ActivityV3>> build() async => [];
  
  @override
  Future<void> refresh() async {}
  
  @override 
  Future<void> addActivity(ActivityV3 activity) async {}
}

void main() {
  testWidgets('HistoryHintCard shows when garden not selected and setting is true', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWith(MockAppSettingsNotifier.new),
           gardenProvider.overrideWith(() => MockGardenNotifier(GardenState(gardens: [], selectedGarden: null, isLoading: false))),
           recentActivitiesProvider.overrideWith(MockRecentActivitiesNotifier.new),
        ],
        child: const MaterialApp(home: ActivitiesScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(HistoryHintCard), findsOneWidget);
    expect(find.text('Pour consulter l’historique d’un jardin'), findsOneWidget);
  });

  testWidgets('HistoryHintCard hides when setting is false', (tester) async {
    final mockAppSettings = AppSettings.defaults().copyWith(showHistoryHint: false);
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
           appSettingsProvider.overrideWith(() => MockAppSettingsNotifier()..state = mockAppSettings),
           gardenProvider.overrideWith(() => MockGardenNotifier(GardenState(gardens: [], selectedGarden: null, isLoading: false))),
           recentActivitiesProvider.overrideWith(MockRecentActivitiesNotifier.new),
        ],
        child: const MaterialApp(home: ActivitiesScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(HistoryHintCard), findsNothing);
  });

  testWidgets('Dismissing HistoryHintCard updates setting', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWith(MockAppSettingsNotifier.new),
           gardenProvider.overrideWith(() => MockGardenNotifier(GardenState(gardens: [], selectedGarden: null, isLoading: false))),
           recentActivitiesProvider.overrideWith(MockRecentActivitiesNotifier.new),
        ],
        child: const MaterialApp(home: ActivitiesScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Find and tap close button
    final closeButton = find.byIcon(Icons.close);
    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    expect(find.byType(HistoryHintCard), findsNothing);
  });
  
  testWidgets('History tab shows fallback when no garden selected', (tester) async {
     await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWith(MockAppSettingsNotifier.new),
           gardenProvider.overrideWith(() => MockGardenNotifier(GardenState(gardens: [], selectedGarden: null, isLoading: false))),
           recentActivitiesProvider.overrideWith(MockRecentActivitiesNotifier.new),
        ],
        child: const MaterialApp(home: ActivitiesScreen()),
      ),
    );
    await tester.pumpAndSettle();
    
    // Tap History tab
    await tester.tap(find.text('Historique'));
    await tester.pumpAndSettle();
    
    expect(find.textContains('Aucun jardin sélectionné'), findsOneWidget);
  });
}
