import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

/// Provider minimal pour les réglages de l'application.
/// Fournit l'objet AppSettings.
final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<AppSettings> {
  static const String _keyShowNutritionInterpretation = 'app_settings_nutrition_interpretation';
  static const String _keyCustomZoneId = 'app_settings_custom_zone_id';
  static const String _keyCustomLastFrostDate = 'app_settings_custom_last_frost_date';

  @override
  AppSettings build() {
    _loadPersistence();
    return AppSettings.defaults();
  }

  Future<void> _loadPersistence() async {
    final prefs = await SharedPreferences.getInstance();
    final showInterpretation = prefs.getBool(_keyShowNutritionInterpretation) ?? false;
    final zoneId = prefs.getString(_keyCustomZoneId);
    final frostStr = prefs.getString(_keyCustomLastFrostDate);
    DateTime? frostDate;
    if (frostStr != null) {
      frostDate = DateTime.tryParse(frostStr);
    }
    
    state = state.copyWith(
      showNutritionInterpretation: showInterpretation,
      customZoneId: zoneId,
      customLastFrostDate: frostDate,
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

  Future<void> setCustomZoneId(String? zoneId) async {
    state = state.copyWith(customZoneId: zoneId);
    final prefs = await SharedPreferences.getInstance();
    if (zoneId != null) {
      await prefs.setString(_keyCustomZoneId, zoneId);
    } else {
      await prefs.remove(_keyCustomZoneId);
    }
  }

  Future<void> setCustomLastFrostDate(DateTime? date) async {
    state = state.copyWith(customLastFrostDate: date);
    final prefs = await SharedPreferences.getInstance();
    if (date != null) {
      await prefs.setString(_keyCustomLastFrostDate, date.toIso8601String());
    } else {
      await prefs.remove(_keyCustomLastFrostDate);
    }
  }
}
