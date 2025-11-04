==========================================
🟢 PermaCalendar - RUN SEUL
==========================================

🚀 Lancement immédiat de l'application sur ton téléphone (Android)...
(Appareil attendu : SM A356B)
==========================================

Found 4 connected devices:
  SM A356B (mobile) • RFCX513N58B • android-arm64  • Android 15 (API 35)
  Windows (desktop) • windows     • windows-x64    • Microsoft Windows [version 10.0.26100.6899]
  Chrome (web)      • chrome      • web-javascript • Google Chrome 142.0.7444.59
  Edge (web)        • edge        • web-javascript • Microsoft Edge 140.0.3485.94

Run "flutter emulators" to list and start any available device emulators.

If you expected another device to be detected, please run "flutter doctor" to diagnose potential issues. You may also
try increasing the time to wait for connected devices with the "--device-timeout" flag. Visit https://flutter.dev/setup/
for troubleshooting tips.
Launching lib\main.dart on SM A356B in debug mode...
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:463:41: Error: Type 'StateNotifier' not found.
class IntelligenceStateNotifier extends StateNotifier<IntelligenceState> {
                                        ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:753:40: Error: Type 'StateNotifier' not found.
class RealTimeAnalysisNotifier extends StateNotifier<RealTimeAnalysisState> {
                                       ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:837:41: Error: Type 'StateNotifier' not found.
class IntelligentAlertsNotifier extends StateNotifier<IntelligentAlertsState> {
                                        ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:896:49: Error: Type 'StateNotifier' not found.
class ContextualRecommendationsNotifier extends StateNotifier<ContextualRecommendationsState> {
                                                ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:956:32: Error: Type 'StateNotifier' not found.
class ForecastNotifier extends StateNotifier<ForecastState> {
                               ^^^^^^^^^^^^^
lib/features/garden/providers/garden_provider.dart:12:30: Error: Type 'StateNotifier' not found.
class GardenNotifier extends StateNotifier<GardenState> {
                             ^^^^^^^^^^^^^
lib/features/planting/providers/planting_provider.dart:41:32: Error: Type 'StateNotifier' not found.
class PlantingNotifier extends StateNotifier<PlantingState> {
                               ^^^^^^^^^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:39:36: Error: Type 'StateNotifier' not found.
class PlantCatalogNotifier extends StateNotifier<PlantCatalogState> {
                                   ^^^^^^^^^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:38:33: Error: Type 'StateNotifier' not found.
class GardenBedNotifier extends StateNotifier<GardenBedState> {
                                ^^^^^^^^^^^^^
lib/core/providers/activity_tracker_v3_provider.dart:23:40: Error: Type 'StateNotifier' not found.
class RecentActivitiesNotifier extends StateNotifier<AsyncValue<List<ActivityV3>>> {
                                       ^^^^^^^^^^^^^
lib/core/providers/activity_tracker_v3_provider.dart:52:43: Error: Type 'StateNotifier' not found.
class ImportantActivitiesNotifier extends StateNotifier<AsyncValue<List<ActivityV3>>> {
                                          ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:614:42: Error: Type 'StateNotifier' not found.
class AlertNotificationsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
                                         ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:644:51: Error: Type 'StateNotifier' not found.
class RecommendationNotificationsNotifier extends StateNotifier<List<Recommendation>> {
                                                  ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:688:35: Error: Type 'StateNotifier' not found.
class AppSettingsNotifier extends StateNotifier<Map<String, dynamic>> {
                                  ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:103:40: Error: Type 'StateNotifier' not found.
class NotificationListNotifier extends StateNotifier<AsyncValue<List<NotificationAlert>>> {
                                       ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:166:47: Error: Type 'StateNotifier' not found.
class NotificationPreferencesNotifier extends StateNotifier<Map<String, dynamic>> {
                                              ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:118:42: Error: Type 'StateNotifier' not found.
class DisplayPreferencesNotifier extends StateNotifier<DisplayPreferences> {
                                         ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:151:37: Error: Type 'StateNotifier' not found.
class ChartSettingsNotifier extends StateNotifier<ChartSettings> {
                                    ^^^^^^^^^^^^^
lib/features/weather/providers/commune_provider.dart:9:39: Error: Type 'StateNotifier' not found.
class SelectedCommuneNotifier extends StateNotifier<String?> {
                                      ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:24:45: Error: Method not found: 'StateProvider'.
final currentIntelligenceGardenIdProvider = StateProvider<String?>((ref) => null);
                                            ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:42:35: Error: Undefined name 'StateNotifierProvider'.
final intelligenceStateProvider = StateNotifierProvider.family<IntelligenceStateNotifier, IntelligenceState, String>(
                                  ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:49:34: Error: Method not found: 'StateNotifierProvider'.
final realTimeAnalysisProvider = StateNotifierProvider<RealTimeAnalysisNotifier, RealTimeAnalysisState>((ref) {
                                 ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:54:35: Error: Method not found: 'StateNotifierProvider'.
final intelligentAlertsProvider = StateNotifierProvider<IntelligentAlertsNotifier, IntelligentAlertsState>((ref) {
                                  ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:59:43: Error: Method not found: 'StateNotifierProvider'.
final contextualRecommendationsProvider = StateNotifierProvider<ContextualRecommendationsNotifier, ContextualRecommendationsState>((ref) {
                                          ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:64:26: Error: Method not found: 'StateNotifierProvider'.
final forecastProvider = StateNotifierProvider<ForecastNotifier, ForecastState>((ref) {
                         ^^^^^^^^^^^^^^^^^^^^^
lib/features/garden/providers/garden_provider.dart:204:24: Error: Method not found: 'StateNotifierProvider'.
final gardenProvider = StateNotifierProvider<GardenNotifier, GardenState>((ref) {
                       ^^^^^^^^^^^^^^^^^^^^^
lib/features/planting/providers/planting_provider.dart:548:26: Error: Method not found: 'StateNotifierProvider'.
final plantingProvider = StateNotifierProvider<PlantingNotifier, PlantingState>(
                         ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:208:30: Error: Method not found: 'StateNotifierProvider'.
final plantCatalogProvider = StateNotifierProvider<PlantCatalogNotifier, PlantCatalogState>((ref) {
                             ^^^^^^^^^^^^^^^^^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:317:27: Error: Method not found: 'StateNotifierProvider'.
final gardenBedProvider = StateNotifierProvider<GardenBedNotifier, GardenBedState>(
                          ^^^^^^^^^^^^^^^^^^^^^
lib/core/providers/activity_tracker_v3_provider.dart:11:34: Error: Method not found: 'StateNotifierProvider'.
final recentActivitiesProvider = StateNotifierProvider<RecentActivitiesNotifier, AsyncValue<List<ActivityV3>>>((ref) {
                                 ^^^^^^^^^^^^^^^^^^^^^
lib/core/providers/activity_tracker_v3_provider.dart:17:37: Error: Method not found: 'StateNotifierProvider'.
final importantActivitiesProvider = StateNotifierProvider<ImportantActivitiesNotifier, AsyncValue<List<ActivityV3>>>((ref) {
                                    ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:226:42: Error: Method not found: 'StateProvider'.
final plantIntelligenceLoadingProvider = StateProvider<bool>((ref) => false);
                                         ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:229:40: Error: Method not found: 'StateProvider'.
final plantIntelligenceErrorProvider = StateProvider<String?>((ref) => null);
                                       ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:394:36: Error: Method not found: 'StateNotifierProvider'.
final alertNotificationsProvider = StateNotifierProvider<AlertNotificationsNotifier, List<Map<String, dynamic>>>((ref) {
                                   ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:399:45: Error: Method not found: 'StateNotifierProvider'.
final recommendationNotificationsProvider = StateNotifierProvider<RecommendationNotificationsNotifier, List<Recommendation>>((ref) {
                                            ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:683:29: Error: Method not found: 'StateNotifierProvider'.
final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, Map<String, dynamic>>((ref) {
                            ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:157:42: Error: Method not found: 'StateNotifierProvider'.
final notificationListNotifierProvider = StateNotifierProvider<
                                         ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:236:49: Error: Method not found: 'StateNotifierProvider'.
final notificationPreferencesNotifierProvider = StateNotifierProvider<
                                                ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:6:36: Error: Method not found: 'StateNotifierProvider'.
final displayPreferencesProvider = StateNotifierProvider<DisplayPreferencesNotifier, DisplayPreferences>((ref) {
                                   ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:11:31: Error: Method not found: 'StateNotifierProvider'.
final chartSettingsProvider = StateNotifierProvider<ChartSettingsNotifier, ChartSettings>((ref) {
                              ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:16:26: Error: Method not found: 'StateProvider'.
final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.dashboard);
                         ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:19:37: Error: Method not found: 'StateProvider'.
final selectedPlantFilterProvider = StateProvider<String?>((ref) => null);
                                    ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:22:38: Error: Method not found: 'StateProvider'.
final selectedGardenFilterProvider = StateProvider<String?>((ref) => null);
                                     ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:25:37: Error: Method not found: 'StateProvider'.
final visualizationPeriodProvider = StateProvider<VisualizationPeriod>((ref) => VisualizationPeriod.week);
                                    ^^^^^^^^^^^^^
lib/features/weather/providers/commune_provider.dart:5:33: Error: Method not found: 'StateNotifierProvider'.
final selectedCommuneProvider = StateNotifierProvider<SelectedCommuneNotifier, String?>((ref) {
                                ^^^^^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/plant_evolution_providers.dart:63:36: Error: Undefined name 'StateProvider'.
final selectedTimePeriodProvider = StateProvider.autoDispose<int?>((ref) => null);
                                   ^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart:2749:62: Error: The getter 'intelligenceState' isn't defined for the type '_PlantIntelligenceDashboardScreenState'.
 - '_PlantIntelligenceDashboardScreenState' is from 'package:permacalendar/features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart' ('lib/features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'intelligenceState'.
                    _showPlantSelectionForEvolution(context, intelligenceState)
                                                             ^^^^^^^^^^^^^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:468:14: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
      : super(IntelligenceState(currentGardenId: _gardenId));
             ^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:478:13: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isAnalyzing: true, error: null);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:478:5: Error: The setter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isAnalyzing: true, error: null);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:515:13: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        if (state.plantConditions.containsKey(plantId)) {
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:516:40: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          cleanedConditions[plantId] = state.plantConditions[plantId]!;
                                       ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:518:13: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        if (state.plantRecommendations.containsKey(plantId)) {
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:519:45: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          cleanedRecommendations[plantId] = state.plantRecommendations[plantId]!;
                                            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:523:33: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final removedConditions = state.plantConditions.length - cleanedConditions.length;
                                ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:530:15: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:530:7: Error: The setter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:559:15: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:559:7: Error: The setter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:564:64: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      print('🔴 [DIAGNOSTIC PROVIDER] plantConditions.length=${state.plantConditions.length}');
                                                               ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:565:69: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      print('🔴 [DIAGNOSTIC PROVIDER] plantRecommendations.length=${state.plantRecommendations.length}');
                                                                    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:566:70: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      developer.log('✅ DIAGNOSTIC - Toutes les analyses terminées: ${state.plantConditions.length} conditions, ${state.plantRecommendations.length} plantes avec recommandations', name: 'IntelligenceStateNotifier');
                                                                     ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:566:114: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      developer.log('✅ DIAGNOSTIC - Toutes les analyses terminées: ${state.plantConditions.length} conditions, ${state.plantRecommendations.length} plantes avec recommandations', name: 'IntelligenceStateNotifier');
                                                                                          ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:573:46: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      developer.log('📊 Analyses générées: ${state.plantConditions.length}/${activePlants.length}', name: 'IntelligenceStateNotifier');
                                             ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:597:15: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:597:7: Error: The setter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:607:45: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    developer.log('🔬 V2 - Jardin actuel: ${state.currentGardenId}', name: 'IntelligenceStateNotifier');
                                            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:609:13: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isAnalyzing: true);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:609:5: Error: The setter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isAnalyzing: true);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:613:11: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      if (state.currentGardenId == null) {
          ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:644:96: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      developer.log('🔬 V2 - Génération rapport intelligence pour plantId=$plantId, gardenId=${state.currentGardenId}...', name: 'IntelligenceStateNotifier');
                                                                                          ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:647:19: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        gardenId: state.currentGardenId!,
                  ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:660:15: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:662:14: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          ...state.plantConditions,
             ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:666:14: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          ...state.plantRecommendations,
             ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:660:7: Error: The setter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:671:80: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      developer.log('✅ DIAGNOSTIC - State mis à jour: plantConditions.length=${state.plantConditions.length}', name: 'IntelligenceStateNotifier');
                                                                               ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:676:11: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      if (state.currentGardenId != null) {
          ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:679:56: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          _ref.invalidate(unifiedGardenContextProvider(state.currentGardenId!));
                                                       ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:680:54: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          _ref.invalidate(gardenActivePlantsProvider(state.currentGardenId!));
                                                     ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:681:47: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          _ref.invalidate(gardenStatsProvider(state.currentGardenId!));
                                              ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:682:52: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          _ref.invalidate(gardenActivitiesProvider(state.currentGardenId!));
                                                   ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:693:15: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:693:7: Error: The setter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:738:13: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(currentWeather: weather);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:738:5: Error: The setter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(currentWeather: weather);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:743:13: Error: The getter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(error: null);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:743:5: Error: The setter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(error: null);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:748:5: Error: The setter 'state' isn't defined for the type 'IntelligenceStateNotifier'.
 - 'IntelligenceStateNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = const IntelligenceState();
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:756:46: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  RealTimeAnalysisNotifier(this._ref) : super(const RealTimeAnalysisState());
                                             ^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:760:13: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isRunning: true);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:760:5: Error: The setter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isRunning: true);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:766:13: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isRunning: false);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:766:5: Error: The setter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isRunning: false);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:771:13: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:773:12: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        ...state.isUpdating,
           ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:777:12: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        ...state.updateErrors,
           ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:771:5: Error: The setter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:785:15: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:787:14: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          ...state.lastUpdates,
             ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:791:14: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          ...state.isUpdating,
             ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:785:7: Error: The setter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:796:15: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:798:14: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          ...state.isUpdating,
             ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:802:14: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
          ...state.updateErrors,
             ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:796:7: Error: The setter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:811:10: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    if (!state.isRunning) return;
         ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:813:20: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    Future.delayed(state.updateInterval, () {
                   ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:814:11: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      if (state.isRunning) {
          ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:832:13: Error: The getter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(updateInterval: interval);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:832:5: Error: The setter 'state' isn't defined for the type 'RealTimeAnalysisNotifier'.
 - 'RealTimeAnalysisNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(updateInterval: interval);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:840:47: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  IntelligentAlertsNotifier(this._ref) : super(const IntelligentAlertsState());
                                              ^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:844:13: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:845:25: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      activeAlerts: [...state.activeAlerts, alert],
                        ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:844:5: Error: The setter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:851:19: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    final alert = state.activeAlerts.firstWhere(
                  ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:856:13: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:857:21: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      activeAlerts: state.activeAlerts.where((a) => a.id != alertId).toList(),
                    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:858:28: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      dismissedAlerts: [...state.dismissedAlerts, alert],
                           ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:856:5: Error: The setter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:864:13: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:865:24: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      dismissedAlerts: state.dismissedAlerts.where((a) => a.id != alertId).toList(),
                       ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:864:5: Error: The setter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:871:13: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:873:12: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        ...state.alertSettings,
           ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:871:5: Error: The setter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:881:13: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:882:30: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      notificationsEnabled: !state.notificationsEnabled,
                             ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:881:5: Error: The setter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:888:13: Error: The getter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:888:5: Error: The setter 'state' isn't defined for the type 'IntelligentAlertsNotifier'.
 - 'IntelligentAlertsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:899:55: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  ContextualRecommendationsNotifier(this._ref) : super(const ContextualRecommendationsState());
                                                      ^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:903:13: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:904:38: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      contextualRecommendations: [...state.contextualRecommendations, ...recommendations],
                                     ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:903:5: Error: The setter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:910:13: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:912:12: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        ...state.appliedRecommendations,
           ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:916:12: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        ...state.recommendationHistory,
           ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:910:5: Error: The setter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:924:13: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:926:12: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        ...state.dismissedRecommendations,
           ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:930:12: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        ...state.recommendationHistory,
           ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:924:5: Error: The setter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:938:13: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:939:34: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      contextualRecommendations: state.contextualRecommendations
                                 ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:938:5: Error: The setter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:947:13: Error: The getter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:947:5: Error: The setter 'state' isn't defined for the type 'ContextualRecommendationsNotifier'.
 - 'ContextualRecommendationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:959:38: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  ForecastNotifier(this._ref) : super(const ForecastState());
                                     ^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:963:13: Error: The getter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:965:12: Error: The getter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        ...state.weatherForecasts,
           ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:963:5: Error: The setter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:974:13: Error: The getter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:976:12: Error: The getter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        ...state.plantForecasts,
           ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:974:5: Error: The setter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:985:13: Error: The getter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isUpdating: true);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:985:5: Error: The setter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isUpdating: true);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:990:13: Error: The getter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isUpdating: false);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:990:5: Error: The setter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isUpdating: false);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:995:73: Error: The getter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    final newWeatherForecasts = Map<String, List<WeatherForecast>>.from(state.weatherForecasts);
                                                                        ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:998:13: Error: The getter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(weatherForecasts: newWeatherForecasts);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart:998:5: Error: The setter 'state' isn't defined for the type 'ForecastNotifier'.
 - 'ForecastNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart' ('lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(weatherForecasts: newWeatherForecasts);
    ^^^^^
lib/features/garden/providers/garden_provider.dart:15:43: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  GardenNotifier(this._repository) : super(GardenState.initial()) {
                                          ^
lib/features/garden/providers/garden_provider.dart:23:7: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = GardenState.loading();
      ^^^^^
lib/features/garden/providers/garden_provider.dart:25:7: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = GardenState.loaded(gardens);
      ^^^^^
lib/features/garden/providers/garden_provider.dart:27:7: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = GardenState.error('Erreur lors du chargement des jardins: $e');
      ^^^^^
lib/features/garden/providers/garden_provider.dart:36:12: Error: The getter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      if (!state.canAddGarden) {
           ^^^^^
lib/features/garden/providers/garden_provider.dart:37:9: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
        state = GardenState.error('Limite de 5 jardins atteinte');
        ^^^^^
lib/features/garden/providers/garden_provider.dart:68:9: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
        state = GardenState.error('Échec de la création du jardin');
        ^^^^^
lib/features/garden/providers/garden_provider.dart:72:7: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = GardenState.error('Erreur lors de la création: $e');
      ^^^^^
lib/features/garden/providers/garden_provider.dart:108:9: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
        state = GardenState.error('Échec de la mise à jour du jardin');
        ^^^^^
lib/features/garden/providers/garden_provider.dart:112:7: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = GardenState.error('Erreur lors de la mise à jour: $e');
      ^^^^^
lib/features/garden/providers/garden_provider.dart:122:22: Error: The getter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final garden = state.findGardenById(gardenId);
                     ^^^^^
lib/features/garden/providers/garden_provider.dart:150:9: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
        state = GardenState.error('Échec de la suppression du jardin');
        ^^^^^
lib/features/garden/providers/garden_provider.dart:154:7: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = GardenState.error('Erreur lors de la suppression: $e');
      ^^^^^
lib/features/garden/providers/garden_provider.dart:163:22: Error: The getter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final garden = state.findGardenById(gardenId);
                     ^^^^^
lib/features/garden/providers/garden_provider.dart:165:9: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
        state = GardenState.error('Jardin non trouvé');
        ^^^^^
lib/features/garden/providers/garden_provider.dart:176:7: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = GardenState.error('Erreur lors du changement de statut: $e');
      ^^^^^
lib/features/garden/providers/garden_provider.dart:183:20: Error: The getter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    final garden = state.findGardenById(gardenId);
                   ^^^^^
lib/features/garden/providers/garden_provider.dart:185:15: Error: The getter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(selectedGarden: garden);
              ^^^^^
lib/features/garden/providers/garden_provider.dart:185:7: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(selectedGarden: garden);
      ^^^^^
lib/features/garden/providers/garden_provider.dart:191:13: Error: The getter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(selectedGarden: null);
            ^^^^^
lib/features/garden/providers/garden_provider.dart:191:5: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(selectedGarden: null);
    ^^^^^
lib/features/garden/providers/garden_provider.dart:196:9: Error: The getter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    if (state.hasError) {
        ^^^^^
lib/features/garden/providers/garden_provider.dart:197:15: Error: The getter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(error: null);
              ^^^^^
lib/features/garden/providers/garden_provider.dart:197:7: Error: The setter 'state' isn't defined for the type 'GardenNotifier'.
 - 'GardenNotifier' is from 'package:permacalendar/features/garden/providers/garden_provider.dart' ('lib/features/garden/providers/garden_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(error: null);
      ^^^^^
lib/features/planting/providers/planting_provider.dart:44:38: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  PlantingNotifier(this._ref) : super(const PlantingState());
                                     ^
lib/features/planting/providers/planting_provider.dart:48:13: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
            ^^^^^
lib/features/planting/providers/planting_provider.dart:48:5: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
    ^^^^^
lib/features/planting/providers/planting_provider.dart:52:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/planting/providers/planting_provider.dart:52:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/planting/providers/planting_provider.dart:57:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/planting/providers/planting_provider.dart:57:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/planting/providers/planting_provider.dart:66:13: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
            ^^^^^
lib/features/planting/providers/planting_provider.dart:66:5: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
    ^^^^^
lib/features/planting/providers/planting_provider.dart:70:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/planting/providers/planting_provider.dart:70:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/planting/providers/planting_provider.dart:75:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/planting/providers/planting_provider.dart:75:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/planting/providers/planting_provider.dart:106:17: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        state = state.copyWith(error: 'Données de plantation invalides');
                ^^^^^
lib/features/planting/providers/planting_provider.dart:106:9: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
        state = state.copyWith(error: 'Données de plantation invalides');
        ^^^^^
lib/features/planting/providers/planting_provider.dart:150:36: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final updatedPlantings = [...state.plantings, planting];
                                   ^^^^^
lib/features/planting/providers/planting_provider.dart:151:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/planting/providers/planting_provider.dart:151:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/planting/providers/planting_provider.dart:158:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de la création: $e');
              ^^^^^
lib/features/planting/providers/planting_provider.dart:158:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de la création: $e');
      ^^^^^
lib/features/planting/providers/planting_provider.dart:167:17: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        state = state.copyWith(error: 'Données de plantation invalides');
                ^^^^^
lib/features/planting/providers/planting_provider.dart:167:9: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
        state = state.copyWith(error: 'Données de plantation invalides');
        ^^^^^
lib/features/planting/providers/planting_provider.dart:207:32: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final updatedPlantings = state.plantings.map((planting) {
                               ^^^^^
lib/features/planting/providers/planting_provider.dart:211:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/planting/providers/planting_provider.dart:211:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/planting/providers/planting_provider.dart:218:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de la mise à jour: $e');
              ^^^^^
lib/features/planting/providers/planting_provider.dart:218:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de la mise à jour: $e');
      ^^^^^
lib/features/planting/providers/planting_provider.dart:227:32: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final plantingToDelete = state.plantings.firstWhere(
                               ^^^^^
lib/features/planting/providers/planting_provider.dart:263:32: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final updatedPlantings = state.plantings
                               ^^^^^
lib/features/planting/providers/planting_provider.dart:267:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/planting/providers/planting_provider.dart:267:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/planting/providers/planting_provider.dart:274:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de la suppression: $e');
              ^^^^^
lib/features/planting/providers/planting_provider.dart:274:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de la suppression: $e');
      ^^^^^
lib/features/planting/providers/planting_provider.dart:282:24: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final planting = state.plantings.firstWhere((p) => p.id == plantingId);
                       ^^^^^
lib/features/planting/providers/planting_provider.dart:287:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de la mise à jour du statut: $e');
              ^^^^^
lib/features/planting/providers/planting_provider.dart:287:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de la mise à jour du statut: $e');
      ^^^^^
lib/features/planting/providers/planting_provider.dart:301:24: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final planting = state.plantings.firstWhere(
                       ^^^^^
lib/features/planting/providers/planting_provider.dart:327:32: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final updatedPlantings = state.plantings.map((p) {
                               ^^^^^
lib/features/planting/providers/planting_provider.dart:331:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/planting/providers/planting_provider.dart:331:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/planting/providers/planting_provider.dart:338:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de l\'ajout du soin: $e');
              ^^^^^
lib/features/planting/providers/planting_provider.dart:338:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de l\'ajout du soin: $e');
      ^^^^^
lib/features/planting/providers/planting_provider.dart:346:24: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final planting = state.plantings.firstWhere(
                       ^^^^^
lib/features/planting/providers/planting_provider.dart:394:32: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final updatedPlantings = state.plantings.map((p) {
                               ^^^^^
lib/features/planting/providers/planting_provider.dart:398:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/planting/providers/planting_provider.dart:398:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/planting/providers/planting_provider.dart:405:15: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de la récolte: $e');
              ^^^^^
lib/features/planting/providers/planting_provider.dart:405:7: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(error: 'Erreur lors de la récolte: $e');
      ^^^^^
lib/features/planting/providers/planting_provider.dart:412:13: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(selectedPlanting: planting);
            ^^^^^
lib/features/planting/providers/planting_provider.dart:412:5: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(selectedPlanting: planting);
    ^^^^^
lib/features/planting/providers/planting_provider.dart:426:13: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(error: null);
            ^^^^^
lib/features/planting/providers/planting_provider.dart:426:5: Error: The setter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(error: null);
    ^^^^^
lib/features/planting/providers/planting_provider.dart:431:12: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    return state.plantings
           ^^^^^
lib/features/planting/providers/planting_provider.dart:438:12: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    return state.plantings
           ^^^^^
lib/features/planting/providers/planting_provider.dart:445:12: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    return state.plantings
           ^^^^^
lib/features/planting/providers/planting_provider.dart:453:12: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    return state.plantings.where((planting) {
           ^^^^^
lib/features/planting/providers/planting_provider.dart:464:12: Error: The getter 'state' isn't defined for the type 'PlantingNotifier'.
 - 'PlantingNotifier' is from 'package:permacalendar/features/planting/providers/planting_provider.dart' ('lib/features/planting/providers/planting_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    return state.plantings.where((planting) {
           ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:43:77: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  PlantCatalogNotifier(this._plantRepository, this._activityTracker) : super(const PlantCatalogState());
                                                                            ^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:48:15: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(isLoading: true, error: null);
              ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:48:7: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(isLoading: true, error: null);
      ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:53:15: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:53:7: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:58:15: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:58:7: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:68:15: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(isLoading: true, error: null);
              ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:68:7: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(isLoading: true, error: null);
      ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:90:15: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:90:7: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:100:15: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(isLoading: true, error: null);
              ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:100:7: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(isLoading: true, error: null);
      ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:123:15: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:123:7: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:133:15: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(isLoading: true, error: null);
              ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:133:7: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(isLoading: true, error: null);
      ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:161:15: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:161:7: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:179:31: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    if (query.isEmpty) return state.plants;
                              ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:181:12: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    return state.plants.where((plant) =>
           ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:190:36: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    if (season == 'Toutes') return state.plants;
                                   ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:191:12: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    return state.plants.where((plant) =>
           ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:198:13: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(selectedPlant: plant);
            ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:198:5: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(selectedPlant: plant);
    ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:203:13: Error: The getter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(error: null);
            ^^^^^
lib/features/plant_catalog/providers/plant_catalog_provider.dart:203:5: Error: The setter 'state' isn't defined for the type 'PlantCatalogNotifier'.
 - 'PlantCatalogNotifier' is from 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart' ('lib/features/plant_catalog/providers/plant_catalog_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(error: null);
    ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:41:51: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  GardenBedNotifier(this._activityService) : super(const GardenBedState());
                                                  ^
lib/features/garden_bed/providers/garden_bed_provider.dart:45:13: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
            ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:45:5: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
    ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:51:15: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:51:7: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:57:15: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:57:7: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:66:13: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
            ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:66:5: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
    ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:72:17: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        state = state.copyWith(
                ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:72:9: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
        state = state.copyWith(
        ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:109:37: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final updatedGardenBeds = [...state.gardenBeds, gardenBed];
                                    ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:111:15: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:111:7: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:119:15: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:119:7: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:129:13: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
            ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:129:5: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
    ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:135:17: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        state = state.copyWith(
                ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:135:9: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
        state = state.copyWith(
        ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:172:33: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final updatedGardenBeds = state.gardenBeds.map((bed) {
                                ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:176:15: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:179:28: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        selectedGardenBed: state.selectedGardenBed?.id == updatedGardenBed.id
                           ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:181:15: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
            : state.selectedGardenBed,
              ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:176:7: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:186:15: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:186:7: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:196:13: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
            ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:196:5: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(isLoading: true, error: null);
    ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:200:27: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final bedToDelete = state.gardenBeds.firstWhere(
                          ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:231:33: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      final updatedGardenBeds = state.gardenBeds
                                ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:235:15: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:238:28: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
        selectedGardenBed: state.selectedGardenBed?.id == gardenBedId
                           ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:240:15: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
            : state.selectedGardenBed,
              ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:235:7: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:245:15: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
      state = state.copyWith(
              ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:245:7: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = state.copyWith(
      ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:255:13: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(selectedGardenBed: gardenBed);
            ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:255:5: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(selectedGardenBed: gardenBed);
    ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:260:13: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(error: null);
            ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:260:5: Error: The setter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(error: null);
    ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:270:12: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    return state.gardenBeds
           ^^^^^
lib/features/garden_bed/providers/garden_bed_provider.dart:277:12: Error: The getter 'state' isn't defined for the type 'GardenBedNotifier'.
 - 'GardenBedNotifier' is from 'package:permacalendar/features/garden_bed/providers/garden_bed_provider.dart' ('lib/features/garden_bed/providers/garden_bed_provider.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    return state.gardenBeds
           ^^^^^
lib/core/providers/activity_tracker_v3_provider.dart:26:50: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  RecentActivitiesNotifier(this._tracker) : super(const AsyncValue.loading()) {
                                                 ^
lib/core/providers/activity_tracker_v3_provider.dart:32:7: Error: The setter 'state' isn't defined for the type 'RecentActivitiesNotifier'.
 - 'RecentActivitiesNotifier' is from 'package:permacalendar/core/providers/activity_tracker_v3_provider.dart' ('lib/core/providers/activity_tracker_v3_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = const AsyncValue.loading();
      ^^^^^
lib/core/providers/activity_tracker_v3_provider.dart:34:7: Error: The setter 'state' isn't defined for the type 'RecentActivitiesNotifier'.
 - 'RecentActivitiesNotifier' is from 'package:permacalendar/core/providers/activity_tracker_v3_provider.dart' ('lib/core/providers/activity_tracker_v3_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = AsyncValue.data(activities);
      ^^^^^
lib/core/providers/activity_tracker_v3_provider.dart:36:7: Error: The setter 'state' isn't defined for the type 'RecentActivitiesNotifier'.
 - 'RecentActivitiesNotifier' is from 'package:permacalendar/core/providers/activity_tracker_v3_provider.dart' ('lib/core/providers/activity_tracker_v3_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = AsyncValue.error(error, stackTrace);
      ^^^^^
lib/core/providers/activity_tracker_v3_provider.dart:55:53: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  ImportantActivitiesNotifier(this._tracker) : super(const AsyncValue.loading()) {
                                                    ^
lib/core/providers/activity_tracker_v3_provider.dart:61:7: Error: The setter 'state' isn't defined for the type 'ImportantActivitiesNotifier'.
 - 'ImportantActivitiesNotifier' is from 'package:permacalendar/core/providers/activity_tracker_v3_provider.dart' ('lib/core/providers/activity_tracker_v3_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = const AsyncValue.loading();
      ^^^^^
lib/core/providers/activity_tracker_v3_provider.dart:66:7: Error: The setter 'state' isn't defined for the type 'ImportantActivitiesNotifier'.
 - 'ImportantActivitiesNotifier' is from 'package:permacalendar/core/providers/activity_tracker_v3_provider.dart' ('lib/core/providers/activity_tracker_v3_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = AsyncValue.data(activities);
      ^^^^^
lib/core/providers/activity_tracker_v3_provider.dart:68:7: Error: The setter 'state' isn't defined for the type 'ImportantActivitiesNotifier'.
 - 'ImportantActivitiesNotifier' is from 'package:permacalendar/core/providers/activity_tracker_v3_provider.dart' ('lib/core/providers/activity_tracker_v3_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = AsyncValue.error(error, stackTrace);
      ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:615:39: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  AlertNotificationsNotifier() : super([]);
                                      ^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:619:17: Error: The getter 'state' isn't defined for the type 'AlertNotificationsNotifier'.
 - 'AlertNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = [...state, alert];
                ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:619:5: Error: The setter 'state' isn't defined for the type 'AlertNotificationsNotifier'.
 - 'AlertNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = [...state, alert];
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:624:13: Error: The getter 'state' isn't defined for the type 'AlertNotificationsNotifier'.
 - 'AlertNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.where((alert) => alert['id'] != alertId).toList();
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:624:5: Error: The setter 'state' isn't defined for the type 'AlertNotificationsNotifier'.
 - 'AlertNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.where((alert) => alert['id'] != alertId).toList();
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:629:13: Error: The getter 'state' isn't defined for the type 'AlertNotificationsNotifier'.
 - 'AlertNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.map((alert) {
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:629:5: Error: The setter 'state' isn't defined for the type 'AlertNotificationsNotifier'.
 - 'AlertNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.map((alert) {
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:639:5: Error: The setter 'state' isn't defined for the type 'AlertNotificationsNotifier'.
 - 'AlertNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = [];
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:645:48: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  RecommendationNotificationsNotifier() : super([]);
                                               ^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:649:17: Error: The getter 'state' isn't defined for the type 'RecommendationNotificationsNotifier'.
 - 'RecommendationNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = [...state, recommendation];
                ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:649:5: Error: The setter 'state' isn't defined for the type 'RecommendationNotificationsNotifier'.
 - 'RecommendationNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = [...state, recommendation];
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:654:13: Error: The getter 'state' isn't defined for the type 'RecommendationNotificationsNotifier'.
 - 'RecommendationNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.where((rec) => rec.id != recommendationId).toList();
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:654:5: Error: The setter 'state' isn't defined for the type 'RecommendationNotificationsNotifier'.
 - 'RecommendationNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.where((rec) => rec.id != recommendationId).toList();
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:666:5: Error: The setter 'state' isn't defined for the type 'RecommendationNotificationsNotifier'.
 - 'RecommendationNotificationsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = [];
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:689:32: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  AppSettingsNotifier() : super({
                               ^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:699:17: Error: The getter 'state' isn't defined for the type 'AppSettingsNotifier'.
 - 'AppSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = {...state, key: value};
                ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:699:5: Error: The setter 'state' isn't defined for the type 'AppSettingsNotifier'.
 - 'AppSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = {...state, key: value};
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart:704:5: Error: The setter 'state' isn't defined for the type 'AppSettingsNotifier'.
 - 'AppSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = {
    ^^^^^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:106:50: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  NotificationListNotifier(this._service) : super(const AsyncValue.loading()) {
                                                 ^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:112:7: Error: The setter 'state' isn't defined for the type 'NotificationListNotifier'.
 - 'NotificationListNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/notification_providers.dart' ('lib/features/plant_intelligence/presentation/providers/notification_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = const AsyncValue.loading();
      ^^^^^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:114:7: Error: The setter 'state' isn't defined for the type 'NotificationListNotifier'.
 - 'NotificationListNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/notification_providers.dart' ('lib/features/plant_intelligence/presentation/providers/notification_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = AsyncValue.data(notifications);
      ^^^^^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:116:7: Error: The setter 'state' isn't defined for the type 'NotificationListNotifier'.
 - 'NotificationListNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/notification_providers.dart' ('lib/features/plant_intelligence/presentation/providers/notification_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = AsyncValue.error(error, stackTrace);
      ^^^^^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:169:57: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  NotificationPreferencesNotifier(this._service) : super({}) {
                                                        ^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:176:7: Error: The setter 'state' isn't defined for the type 'NotificationPreferencesNotifier'.
 - 'NotificationPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/notification_providers.dart' ('lib/features/plant_intelligence/presentation/providers/notification_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = preferences;
      ^^^^^
lib/features/plant_intelligence/presentation/providers/notification_providers.dart:179:7: Error: The setter 'state' isn't defined for the type 'NotificationPreferencesNotifier'.
 - 'NotificationPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/notification_providers.dart' ('lib/features/plant_intelligence/presentation/providers/notification_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = {};
      ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:119:39: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  DisplayPreferencesNotifier() : super(const DisplayPreferences());
                                      ^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:122:13: Error: The getter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(darkMode: !state.darkMode);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:122:39: Error: The getter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(darkMode: !state.darkMode);
                                      ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:122:5: Error: The setter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(darkMode: !state.darkMode);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:126:13: Error: The getter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showAnimations: !state.showAnimations);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:126:45: Error: The getter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showAnimations: !state.showAnimations);
                                            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:126:5: Error: The setter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(showAnimations: !state.showAnimations);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:130:13: Error: The getter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showDetailedMetrics: !state.showDetailedMetrics);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:130:50: Error: The getter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showDetailedMetrics: !state.showDetailedMetrics);
                                                 ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:130:5: Error: The setter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(showDetailedMetrics: !state.showDetailedMetrics);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:134:13: Error: The getter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(temperatureUnit: unit);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:134:5: Error: The setter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(temperatureUnit: unit);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:138:13: Error: The getter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(distanceUnit: unit);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:138:5: Error: The setter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(distanceUnit: unit);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:142:13: Error: The getter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(language: language);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:142:5: Error: The setter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(language: language);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:146:5: Error: The setter 'state' isn't defined for the type 'DisplayPreferencesNotifier'.
 - 'DisplayPreferencesNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = const DisplayPreferences();
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:152:34: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  ChartSettingsNotifier() : super(const ChartSettings());
                                 ^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:155:13: Error: The getter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showTemperature: !state.showTemperature);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:155:46: Error: The getter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showTemperature: !state.showTemperature);
                                             ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:155:5: Error: The setter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(showTemperature: !state.showTemperature);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:159:13: Error: The getter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showHumidity: !state.showHumidity);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:159:43: Error: The getter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showHumidity: !state.showHumidity);
                                          ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:159:5: Error: The setter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(showHumidity: !state.showHumidity);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:163:13: Error: The getter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showLight: !state.showLight);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:163:40: Error: The getter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showLight: !state.showLight);
                                       ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:163:5: Error: The setter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(showLight: !state.showLight);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:167:13: Error: The getter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showSoil: !state.showSoil);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:167:39: Error: The getter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showSoil: !state.showSoil);
                                      ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:167:5: Error: The setter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(showSoil: !state.showSoil);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:171:13: Error: The getter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showTrends: !state.showTrends);
            ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:171:41: Error: The getter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'state'.
    state = state.copyWith(showTrends: !state.showTrends);
                                        ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:171:5: Error: The setter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = state.copyWith(showTrends: !state.showTrends);
    ^^^^^
lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart:175:5: Error: The setter 'state' isn't defined for the type 'ChartSettingsNotifier'.
 - 'ChartSettingsNotifier' is from 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart' ('lib/features/plant_intelligence/presentation/providers/plant_intelligence_ui_providers.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = const ChartSettings();
    ^^^^^
lib/features/weather/providers/commune_provider.dart:10:36: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  SelectedCommuneNotifier() : super(null);
                                   ^
lib/features/weather/providers/commune_provider.dart:21:7: Error: The setter 'state' isn't defined for the type 'SelectedCommuneNotifier'.
 - 'SelectedCommuneNotifier' is from 'package:permacalendar/features/weather/providers/commune_provider.dart' ('lib/features/weather/providers/commune_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
      state = saved;
      ^^^^^
lib/features/weather/providers/commune_provider.dart:28:5: Error: The setter 'state' isn't defined for the type 'SelectedCommuneNotifier'.
 - 'SelectedCommuneNotifier' is from 'package:permacalendar/features/weather/providers/commune_provider.dart' ('lib/features/weather/providers/commune_provider.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'state'.
    state = communeName;
    ^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command 'C:\src\flutter\bin\flutter.bat'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 23s
Running Gradle task 'assembleDebug'...                             23,9s
Error: Gradle task assembleDebug failed with exit code 1

==========================================
✅ Application déployée sur ton téléphone.
==========================================
Appuyez sur une touche pour continuer...