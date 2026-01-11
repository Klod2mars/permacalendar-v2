import 'package:flutter/material.dart';
export 'package:flutter/material.dart' show ThemeMode;

/// ModÃƒÂ¨le minimal AppSettings utilisÃƒÂ© par les tests.
/// ImplÃƒÂ©mentation simple, mutable, et compatible avec les attentes des tests.
class AppSettings {
  String themeMode;
  bool showAnimations;
  String? selectedCommune;
  bool notificationsEnabled;
  double alertThreshold;
  String temperatureUnit;
  double? weatherRadius;
  bool isRuralMode;
  double? lastLatitude;
  double? lastLongitude;
  int analysisIntervalMinutes;
  bool backupEnabled;
  bool gardenCalibrationEnabled;
  bool showMoonInOvoid;
  bool showHistoryHint;

  AppSettings({
    required this.themeMode,
    required this.showAnimations,
    this.selectedCommune,
    required this.notificationsEnabled,
    required this.alertThreshold,
    required this.temperatureUnit,
    this.weatherRadius,
    required this.isRuralMode,
    this.lastLatitude,
    this.lastLongitude,
    required this.analysisIntervalMinutes,
    required this.backupEnabled,
    required this.gardenCalibrationEnabled,
    required this.showMoonInOvoid,
    required this.showHistoryHint,
  });

  /// Valeurs par défaut (conformes aux tests)
  factory AppSettings.defaults() => AppSettings(
        themeMode: 'system',
        showAnimations: true,
        selectedCommune: null,
        notificationsEnabled: true,
        alertThreshold: 0.7,
        temperatureUnit: 'celsius',
        weatherRadius: null,
        isRuralMode: false,
        lastLatitude: null,
        lastLongitude: null,
        analysisIntervalMinutes: 60,
        backupEnabled: false,
        gardenCalibrationEnabled: false,
        showMoonInOvoid: false,
        showHistoryHint: true,
      );

  /// CopyWith (immutable-style)
  AppSettings copyWith({
    String? themeMode,
    bool? showAnimations,
    String? selectedCommune,
    bool? notificationsEnabled,
    double? alertThreshold,
    String? temperatureUnit,
    double? weatherRadius,
    bool? isRuralMode,
    double? lastLatitude,
    double? lastLongitude,
    int? analysisIntervalMinutes,
    bool? backupEnabled,
    bool? gardenCalibrationEnabled,
    bool? showMoonInOvoid,
    bool? showHistoryHint,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      showAnimations: showAnimations ?? this.showAnimations,
      selectedCommune: selectedCommune ?? this.selectedCommune,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      weatherRadius: weatherRadius ?? this.weatherRadius,
      isRuralMode: isRuralMode ?? this.isRuralMode,
      lastLatitude: lastLatitude ?? this.lastLatitude,
      lastLongitude: lastLongitude ?? this.lastLongitude,
      analysisIntervalMinutes:
          analysisIntervalMinutes ?? this.analysisIntervalMinutes,
      backupEnabled: backupEnabled ?? this.backupEnabled,
      gardenCalibrationEnabled:
          gardenCalibrationEnabled ?? this.gardenCalibrationEnabled,
      showMoonInOvoid: showMoonInOvoid ?? this.showMoonInOvoid,
      showHistoryHint: showHistoryHint ?? this.showHistoryHint,
    );
  }

  /// Convertir string -> ThemeMode
  ThemeMode get themeModeEnum {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Mettre à jour en place depuis un ThemeMode (les tests appellent cela)
  void setThemeModeEnum(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        themeMode = 'light';
        break;
      case ThemeMode.dark:
        themeMode = 'dark';
        break;
      case ThemeMode.system:
      default:
        themeMode = 'system';
        break;
    }
  }

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, showAnimations: $showAnimations, selectedCommune: $selectedCommune, notificationsEnabled: $notificationsEnabled, alertThreshold: $alertThreshold, temperatureUnit: $temperatureUnit, weatherRadius: $weatherRadius, isRuralMode: $isRuralMode, lastLatitude: $lastLatitude, lastLongitude: $lastLongitude, analysisIntervalMinutes: $analysisIntervalMinutes, backupEnabled: $backupEnabled, gardenCalibrationEnabled: $gardenCalibrationEnabled, showMoonInOvoid: $showMoonInOvoid, showHistoryHint: $showHistoryHint)';
  }
}
