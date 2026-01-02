import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/models/app_settings.dart';

void main() {
  group('AppSettings', () {
    test('defaults() should create settings with default values', () {
      final settings = AppSettings.defaults();

      expect(settings.themeMode, 'system');
      expect(settings.showAnimations, true);
      expect(settings.selectedCommune, null);
      expect(settings.notificationsEnabled, true);
      expect(settings.alertThreshold, 0.7);
      expect(settings.temperatureUnit, 'celsius');
      expect(settings.weatherRadius, null);
      expect(settings.isRuralMode, false);
      expect(settings.lastLatitude, null);
      expect(settings.lastLongitude, null);
      expect(settings.analysisIntervalMinutes, 60);
      expect(settings.backupEnabled, false);
      expect(settings.gardenCalibrationEnabled, false);
    });

    test('copyWith should create a copy with updated fields', () {
      final original = AppSettings.defaults();
      final updated = original.copyWith(
        weatherRadius: 10.0,
        isRuralMode: true,
        lastLatitude: 48.8566,
        lastLongitude: 2.3522,
      );

      expect(updated.weatherRadius, 10.0);
      expect(updated.isRuralMode, true);
      expect(updated.lastLatitude, 48.8566);
      expect(updated.lastLongitude, 2.3522);

      // Other fields should remain unchanged
      expect(updated.themeMode, original.themeMode);
      expect(updated.selectedCommune, original.selectedCommune);
      expect(updated.temperatureUnit, original.temperatureUnit);
    });

    test('copyWith should preserve null values when updating other fields', () {
      final original = AppSettings.defaults();
      final updated = original.copyWith(
        themeMode: 'dark',
        weatherRadius: null, // Explicitly null
      );

      expect(updated.themeMode, 'dark');
      expect(updated.weatherRadius, null);
      expect(updated.isRuralMode, false); // Should keep default
    });

    test('toString should include all fields', () {
      final settings = AppSettings.defaults().copyWith(
        weatherRadius: 15.0,
        isRuralMode: true,
        lastLatitude: 48.8566,
        lastLongitude: 2.3522,
      );

      final str = settings.toString();
      expect(str, contains('weatherRadius: 15.0'));
      expect(str, contains('isRuralMode: true'));
      expect(str, contains('lastLatitude: 48.8566'));
      expect(str, contains('lastLongitude: 2.3522'));
    });

    test('weatherRadius should be nullable and optional', () {
      final settings1 = AppSettings.defaults();
      expect(settings1.weatherRadius, null);

      final settings2 = settings1.copyWith(weatherRadius: 20.0);
      expect(settings2.weatherRadius, 20.0);

      final settings3 = settings2.copyWith(weatherRadius: null);
      expect(settings3.weatherRadius, null);
    });

    test('isRuralMode should default to false', () {
      final settings = AppSettings.defaults();
      expect(settings.isRuralMode, false);

      final updated = settings.copyWith(isRuralMode: true);
      expect(updated.isRuralMode, true);
    });

    test('lastLatitude and lastLongitude should be nullable', () {
      final settings = AppSettings.defaults();
      expect(settings.lastLatitude, null);
      expect(settings.lastLongitude, null);

      final updated = settings.copyWith(
        lastLatitude: 48.8566,
        lastLongitude: 2.3522,
      );
      expect(updated.lastLatitude, 48.8566);
      expect(updated.lastLongitude, 2.3522);
    });

    test('themeModeEnum should convert string to ThemeMode', () {
      final settings1 = AppSettings.defaults().copyWith(themeMode: 'light');
      expect(settings1.themeModeEnum, equals(ThemeMode.light));

      final settings2 = AppSettings.defaults().copyWith(themeMode: 'dark');
      expect(settings2.themeModeEnum, equals(ThemeMode.dark));

      final settings3 = AppSettings.defaults().copyWith(themeMode: 'system');
      expect(settings3.themeModeEnum, equals(ThemeMode.system));
    });

    test('setThemeModeEnum should update theme mode from enum', () {
      final settings = AppSettings.defaults();
      settings.setThemeModeEnum(ThemeMode.light);
      expect(settings.themeMode, 'light');

      settings.setThemeModeEnum(ThemeMode.dark);
      expect(settings.themeMode, 'dark');

      settings.setThemeModeEnum(ThemeMode.system);
      expect(settings.themeMode, 'system');
    });
  });
}
