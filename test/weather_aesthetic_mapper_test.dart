import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/climate/domain/utils/weather_aesthetic_mapper.dart';
import 'package:permacalendar/features/climate/domain/models/weather_config.dart';
import 'package:permacalendar/core/models/hourly_weather_point.dart';

HourlyWeatherPoint createPoint({
  required double precipitationMm,
  required int precipitationProbability,
  int weatherCode = 0,
}) {
  return HourlyWeatherPoint(
    time: DateTime.now(),
    precipitationMm: precipitationMm,
    precipitationProbability: precipitationProbability,
    temperatureC: 20.0,
    apparentTemperatureC: 20.0,
    windSpeedkmh: 10.0,
    windDirection: 0,
    windGustsKmh: 15.0,
    weatherCode: weatherCode,
  );
}

void main() {
  group('WeatherAestheticMapper Tests', () {
    test('<= 0.02 mm returns null (no rain)', () {
      final p = createPoint(precipitationMm: 0.01, precipitationProbability: 100);
      final a = WeatherAestheticMapper.getAesthetic(p);
      expect(a, isNull);
    });

    test('0.4 mm @100% -> veryLightRain (new preset)', () {
      // effectiveMm = 0.4 * sqrt(1.0) = 0.4 which is <= 0.5
      final p = createPoint(precipitationMm: 0.4, precipitationProbability: 100);
      final a = WeatherAestheticMapper.getAesthetic(p);
      expect(a, equals(WeatherPresets.veryLightRain));
    });

    test('1.5 mm @100% -> drizzle (shifted)', () {
      // effectiveMm = 1.5 * sqrt(1.0) = 1.5 which is > 0.5 and <= 3.0
      final p = createPoint(precipitationMm: 1.5, precipitationProbability: 100);
      final a = WeatherAestheticMapper.getAesthetic(p);
      expect(a, equals(WeatherPresets.drizzle));
    });

    test('5.0 mm @100% -> lightRain', () {
      // effectiveMm = 5.0 which is > 3.0 and <= 8.0
      final p = createPoint(precipitationMm: 5.0, precipitationProbability: 100);
      final a = WeatherAestheticMapper.getAesthetic(p);
      expect(a, equals(WeatherPresets.lightRain));
    });

    test('12.0 mm @100% -> moderateRain', () {
      // effectiveMm = 12.0 which is > 8.0 and <= 20.0
      final p = createPoint(precipitationMm: 12.0, precipitationProbability: 100);
      final a = WeatherAestheticMapper.getAesthetic(p);
      expect(a, equals(WeatherPresets.moderateRain));
    });

    test('> 20.0 mm @100% -> heavyRain', () {
      // effectiveMm = 20.1 which is > 20.0
      final p = createPoint(precipitationMm: 20.1, precipitationProbability: 100);
      final a = WeatherAestheticMapper.getAesthetic(p);
      expect(a, equals(WeatherPresets.heavyRain));
    });

    test('Storm codes override everything (95, 96, 99)', () {
      for (final code in [95, 96, 99]) {
        final p = createPoint(
          weatherCode: code, 
          precipitationMm: 0.1, // Even low precip
          precipitationProbability: 50
        );
        final a = WeatherAestheticMapper.getAesthetic(p);
        expect(a, equals(WeatherPresets.storm), reason: 'Code $code should return storm');
      }
    });

    test('Probability attenuation reduces effective mm', () {
      // Precip = 1.0 mm.
      // At 100% prop -> effective = 1.0 -> drizzle (>0.5)
      // At 16% prob -> sqrt(0.16) = 0.4. effective = 1.0 * 0.4 = 0.4 -> veryLightRain (<=0.5)
      
      final pHighProb = createPoint(precipitationMm: 1.0, precipitationProbability: 100);
      expect(WeatherAestheticMapper.getAesthetic(pHighProb), equals(WeatherPresets.drizzle));

      final pLowProb = createPoint(precipitationMm: 1.0, precipitationProbability: 16);
      expect(WeatherAestheticMapper.getAesthetic(pLowProb), equals(WeatherPresets.veryLightRain));
    });
  });
}
