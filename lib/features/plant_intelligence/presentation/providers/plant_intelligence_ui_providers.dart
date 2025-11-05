import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== PROVIDERS D'AFFICHAGE ====================

/// Provider pour les préférences d'affichage
final displayPreferencesProvider =
    NotifierProvider<DisplayPreferencesNotifier, DisplayPreferences>(
        DisplayPreferencesNotifier.new);

/// Provider pour les paramètres des graphiques
final chartSettingsProvider =
    NotifierProvider<ChartSettingsNotifier, ChartSettings>(
        ChartSettingsNotifier.new);

/// Notifier pour le mode de vue sélectionné
class ViewModeNotifier extends Notifier<ViewMode> {
  @override
  ViewMode build() => ViewMode.dashboard;
}

/// Provider pour le mode de vue sélectionné
final viewModeProvider =
    NotifierProvider<ViewModeNotifier, ViewMode>(ViewModeNotifier.new);

/// Notifier pour le filtre de plantes sélectionné
class SelectedPlantFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
}

/// Provider pour le filtre de plantes sélectionné
final selectedPlantFilterProvider =
    NotifierProvider<SelectedPlantFilterNotifier, String?>(
        SelectedPlantFilterNotifier.new);

/// Notifier pour le filtre de jardin sélectionné
class SelectedGardenFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
}

/// Provider pour le filtre de jardin sélectionné
final selectedGardenFilterProvider =
    NotifierProvider<SelectedGardenFilterNotifier, String?>(
        SelectedGardenFilterNotifier.new);

/// Notifier pour la période de visualisation
class VisualizationPeriodNotifier extends Notifier<VisualizationPeriod> {
  @override
  VisualizationPeriod build() => VisualizationPeriod.week;
}

/// Provider pour la période de visualisation
final visualizationPeriodProvider =
    NotifierProvider<VisualizationPeriodNotifier, VisualizationPeriod>(
        VisualizationPeriodNotifier.new);

// ==================== CLASSES DE DONNÉES ====================

/// Préférences d'affichage
class DisplayPreferences {
  final bool darkMode;
  final bool showAnimations;
  final bool showDetailedMetrics;
  final String temperatureUnit;
  final String distanceUnit;
  final String language;

  const DisplayPreferences({
    this.darkMode = false,
    this.showAnimations = true,
    this.showDetailedMetrics = false,
    this.temperatureUnit = 'celsius',
    this.distanceUnit = 'metric',
    this.language = 'fr',
  });

  DisplayPreferences copyWith({
    bool? darkMode,
    bool? showAnimations,
    bool? showDetailedMetrics,
    String? temperatureUnit,
    String? distanceUnit,
    String? language,
  }) {
    return DisplayPreferences(
      darkMode: darkMode ?? this.darkMode,
      showAnimations: showAnimations ?? this.showAnimations,
      showDetailedMetrics: showDetailedMetrics ?? this.showDetailedMetrics,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      language: language ?? this.language,
    );
  }
}

/// Paramètres des graphiques
class ChartSettings {
  final bool showTemperature;
  final bool showHumidity;
  final bool showLight;
  final bool showSoil;
  final bool showTrends;

  const ChartSettings({
    this.showTemperature = true,
    this.showHumidity = true,
    this.showLight = true,
    this.showSoil = true,
    this.showTrends = false,
  });

  ChartSettings copyWith({
    bool? showTemperature,
    bool? showHumidity,
    bool? showLight,
    bool? showSoil,
    bool? showTrends,
  }) {
    return ChartSettings(
      showTemperature: showTemperature ?? this.showTemperature,
      showHumidity: showHumidity ?? this.showHumidity,
      showLight: showLight ?? this.showLight,
      showSoil: showSoil ?? this.showSoil,
      showTrends: showTrends ?? this.showTrends,
    );
  }
}

/// Mode de vue
enum ViewMode {
  dashboard,
  list,
  grid,
  timeline,
}

/// Période de visualisation
enum VisualizationPeriod {
  day,
  week,
  month,
  year,
}

// ==================== NOTIFIERS ====================

/// Notifier pour les préférences d'affichage
class DisplayPreferencesNotifier extends Notifier<DisplayPreferences> {
  @override
  DisplayPreferences build() => const DisplayPreferences();

  void toggleDarkMode() {
    state = state.copyWith(darkMode: !state.darkMode);
  }

  void toggleAnimations() {
    state = state.copyWith(showAnimations: !state.showAnimations);
  }

  void toggleDetailedMetrics() {
    state = state.copyWith(showDetailedMetrics: !state.showDetailedMetrics);
  }

  void updateTemperatureUnit(String unit) {
    state = state.copyWith(temperatureUnit: unit);
  }

  void updateDistanceUnit(String unit) {
    state = state.copyWith(distanceUnit: unit);
  }

  void updateLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void resetToDefaults() {
    state = const DisplayPreferences();
  }
}

/// Notifier pour les paramètres des graphiques
class ChartSettingsNotifier extends Notifier<ChartSettings> {
  @override
  ChartSettings build() => const ChartSettings();

  void toggleTemperature() {
    state = state.copyWith(showTemperature: !state.showTemperature);
  }

  void toggleHumidity() {
    state = state.copyWith(showHumidity: !state.showHumidity);
  }

  void toggleLight() {
    state = state.copyWith(showLight: !state.showLight);
  }

  void toggleSoil() {
    state = state.copyWith(showSoil: !state.showSoil);
  }

  void toggleTrends() {
    state = state.copyWith(showTrends: !state.showTrends);
  }

  void reset() {
    state = const ChartSettings();
  }
}

// ==================== MINIMAL COMPATIBILITY PROVIDERS FOR MIGRATION ====================
// Minimal compatibility providers for migration (Notifier-backed)

class CurrentIntelligenceGardenIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;
}

final currentIntelligenceGardenIdProvider =
    NotifierProvider<CurrentIntelligenceGardenIdNotifier, String?>(
        CurrentIntelligenceGardenIdNotifier.new);

class IntelligentAlertsState {
  final List<String> activeAlerts;

  IntelligentAlertsState({this.activeAlerts = const []});
}

class IntelligentAlertsNotifier extends Notifier<IntelligentAlertsState> {
  @override
  IntelligentAlertsState build() => IntelligentAlertsState();
}

final intelligentAlertsProvider =
    NotifierProvider<IntelligentAlertsNotifier, IntelligentAlertsState>(
        IntelligentAlertsNotifier.new);

class ContextualRecommendationsState {
  final List<dynamic> contextualRecommendations;

  ContextualRecommendationsState({this.contextualRecommendations = const []});
}

class ContextualRecommendationsNotifier
    extends Notifier<ContextualRecommendationsState> {
  @override
  ContextualRecommendationsState build() => ContextualRecommendationsState();
}

final contextualRecommendationsProvider =
    NotifierProvider<ContextualRecommendationsNotifier,
            ContextualRecommendationsState>(
        ContextualRecommendationsNotifier.new);

class RealTimeAnalysisState {
  final bool isRunning;

  RealTimeAnalysisState({this.isRunning = false});
}

class RealTimeAnalysisNotifier extends Notifier<RealTimeAnalysisState> {
  @override
  RealTimeAnalysisState build() => RealTimeAnalysisState();
}

final realTimeAnalysisProvider =
    NotifierProvider<RealTimeAnalysisNotifier, RealTimeAnalysisState>(
        RealTimeAnalysisNotifier.new);