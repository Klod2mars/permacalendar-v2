// lib/core/models/app_settings.dart
import 'package:flutter/material.dart';

/// Modèle AppSettings simple, mutable et compatible avec les tests.
class AppSettings {
  // champs (mutables)
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
  });

  /// Valeurs par défaut attendues par les tests
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
      );

  // Sentinel pour distinguer "pas passé" de "valeur null passée explicitement"
  static const _sentinel = Object();

  /// copyWith capable d'accepter explicitement null pour les champs optionnels
  AppSettings copyWith({
    Object? themeMode = _sentinel,
    Object? showAnimations = _sentinel,
    Object? selectedCommune = _sentinel,
    Object? notificationsEnabled = _sentinel,
    Object? alertThreshold = _sentinel,
    Object? temperatureUnit = _sentinel,
    Object? weatherRadius = _sentinel,
    Object? isRuralMode = _sentinel,
    Object? lastLatitude = _sentinel,
    Object? lastLongitude = _sentinel,
    Object? analysisIntervalMinutes = _sentinel,
    Object? backupEnabled = _sentinel,
    Object? gardenCalibrationEnabled = _sentinel,
  }) {
    return AppSettings(
      themeMode: themeMode == _sentinel ? this.themeMode : (themeMode as String),
      showAnimations:
          showAnimations == _sentinel ? this.showAnimations : (showAnimations as bool),
      selectedCommune:
          selectedCommune == _sentinel ? this.selectedCommune : (selectedCommune as String?),
      notificationsEnabled: notificationsEnabled == _sentinel
          ? this.notificationsEnabled
          : (notificationsEnabled as bool),
      alertThreshold: alertThreshold == _sentinel ? this.alertThreshold : (alertThreshold as double),
      temperatureUnit:
          temperatureUnit == _sentinel ? this.temperatureUnit : (temperatureUnit as String),
      weatherRadius: weatherRadius == _sentinel ? this.weatherRadius : (weatherRadius as double?),
      isRuralMode: isRuralMode == _sentinel ? this.isRuralMode : (isRuralMode as bool),
      lastLatitude: lastLatitude == _sentinel ? this.lastLatitude : (lastLatitude as double?),
      lastLongitude: lastLongitude == _sentinel ? this.lastLongitude : (lastLongitude as double?),
      analysisIntervalMinutes: analysisIntervalMinutes == _sentinel
          ? this.analysisIntervalMinutes
          : (analysisIntervalMinutes as int),
      backupEnabled: backupEnabled == _sentinel ? this.backupEnabled : (backupEnabled as bool),
      gardenCalibrationEnabled: gardenCalibrationEnabled == _sentinel
          ? this.gardenCalibrationEnabled
          : (gardenCalibrationEnabled as bool),
    );
  }

  /// convertit la string en ThemeMode
  ThemeMode get themeModeEnum {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// méthode mutatrice simple (attendue par certains tests)
  void setThemeModeEnum(ThemeMode mode) {
    themeMode = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
  }

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, showAnimations: $showAnimations, selectedCommune: $selectedCommune, notificationsEnabled: $notificationsEnabled, alertThreshold: $alertThreshold, temperatureUnit: $temperatureUnit, weatherRadius: $weatherRadius, isRuralMode: $isRuralMode, lastLatitude: $lastLatitude, lastLongitude: $lastLongitude, analysisIntervalMinutes: $analysisIntervalMinutes, backupEnabled: $backupEnabled, gardenCalibrationEnabled: $gardenCalibrationEnabled)';
  }
}

