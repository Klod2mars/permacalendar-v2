import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/services/open_meteo_service.dart';
import 'package:permacalendar/core/models/hourly_weather_point.dart';
import 'package:permacalendar/core/models/daily_weather_point.dart';

void main() {
  group('OpenMeteoService Parsing Logic', () {
    test('Should handle empty hourly points gracefully', () {
      final result = OpenMeteoResult(
        latitude: 0,
        longitude: 0,
        hourlyWeather: [],
        dailyWeather: [],
        currentTemperatureC: null,
      );

      expect(result.currentTemperatureC, null);
      expect(result.hourlyWeather, isEmpty);
    });

    test('Should correctly identify current point from hourly list', () {
      final now = DateTime.now();
      // Points: -1h, +1h. Should pick closest? Or just based on logic?
      // Service logic: "Prendre le dernier point où time <= now" ou "le plus proche"
      // Let's verify what the service actually does with my fix.
    });
  });
}
