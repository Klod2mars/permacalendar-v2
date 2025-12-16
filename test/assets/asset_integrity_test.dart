import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/utils/weather_icon_mapper.dart';

void main() {
  test('All mapped weather icons should exist on filesystem', () {
    // List of all weather codes to test
    final codes = [
      0, 1, 2, 3, 45, 48, 51, 53, 55, 61, 63, 65,
      66, 67, 80, 81, 82, 71, 73, 75, 77, 85, 86,
      95, 96, 99, 20, 29, 999 // 999 for default/unknown
    ];

    // Check mapping and existence
    for (final code in codes) {
      // Use null for default if code is "unknown" for test purposes 
      // But getIconPath takes nullable int.
      final path = WeatherIconMapper.getIconPath(code == 999 ? null : code);
      
      // The path returned is like 'assets/weather_icons/thunderstorm.png'
      // We need to resolve this relative to the project root for the test to see it.
      // Tests run from project root usually.
      final file = File(path);
      
      // Print for debugging
      print('Checking code $code -> $path');
      
      expect(file.existsSync(), isTrue, reason: 'Icon for code $code ($path) does not exist');
    }
  });

  test('All specific asset files required by README should exist', () {
    final requiredFiles = [
      'assets/weather_icons/clear_day.svg',
      'assets/weather_icons/partly_cloudy.svg',
      'assets/weather_icons/fog.svg',
      'assets/weather_icons/drizzle.svg',
      'assets/weather_icons/rain.svg',
      'assets/weather_icons/freezing_rain.svg',
      'assets/weather_icons/showers.svg',
      'assets/weather_icons/snow.svg',
      'assets/weather_icons/snow_showers.svg',
      'assets/weather_icons/thunderstorm.svg',
      'assets/weather_icons/wind.svg',
      'assets/weather_icons/default.svg',
    ];

    for (final path in requiredFiles) {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: 'Required asset $path missing');
    }
  });
}
