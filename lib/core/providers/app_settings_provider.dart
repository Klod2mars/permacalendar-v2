import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

/// Provider minimal pour les réglages de l'application.
/// Fournit l'objet AppSettings.
final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<AppSettings> {
  static const String _keyShowNutritionInterpretation = 'app_settings_nutrition_interpretation';
  // Add other keys here if you want to persist more things progressively.

  @override
  AppSettings build() {
    _loadPersistence();
    return AppSettings.defaults();
  }

  Future<void> _loadPersistence() async {
    final prefs = await SharedPreferences.getInstance();
    final showInterpretation = prefs.getBool(_keyShowNutritionInterpretation) ?? false;
    
    state = state.copyWith(
      showNutritionInterpretation: showInterpretation,
    );
  }

  /// Sauvegarde des dernières coordonnées (utilisé par weather_providers)
  Future<void> setLastCoordinates(double latitude, double longitude) async {
    state = state.copyWith(lastLatitude: latitude, lastLongitude: longitude);
  }

  /// Setter pratique pour la commune sélectionnée si besoin ultérieur
  Future<void> setSelectedCommune(String? commune) async {
    state = state.copyWith(selectedCommune: commune);
  }

  void toggleShowAnimations(bool value) {
    state = state.copyWith(showAnimations: value);
  }

  void toggleShowMoonInOvoid(bool value) {
    state = state.copyWith(showMoonInOvoid: value);
  }

  Future<void> setShowHistoryHint(bool value) async {
    state = state.copyWith(showHistoryHint: value);
  }

  Future<void> toggleShowNutritionInterpretation(bool value) async {
    state = state.copyWith(showNutritionInterpretation: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowNutritionInterpretation, value);
  }
}
