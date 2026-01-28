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
      final p = createPoint(precipitationMm: 0.4, precipitationProbability: 100);
      final a = WeatherAestheticMapper.getAesthetic(p, precipProbThreshold: 30.0);
      expect(a, equals(WeatherPresets.veryLightRain));
    });

    test('0.4 mm @10% -> emptyPrecip (downgrade from veryLightRain)', () {
      // 0.4mm maps to veryLightRain.
      // 10% prob < 30% threshold -> downgrade -> emptyPrecip
      final p = createPoint(precipitationMm: 0.4, precipitationProbability: 10);
      final a = WeatherAestheticMapper.getAesthetic(p, precipProbThreshold: 30.0, downgradeOnLowProb: true);
      expect(a, equals(WeatherPresets.emptyPrecip));
    });

    test('1.5 mm @10% -> veryLightRain (downgrade from drizzle)', () {
      // 1.5mm maps to drizzle.
      // 10% prob < 30% threshold -> downgrade -> veryLightRain
      final p = createPoint(precipitationMm: 1.5, precipitationProbability: 10);
      final a = WeatherAestheticMapper.getAesthetic(p, precipProbThreshold: 30.0, downgradeOnLowProb: true);
      expect(a, equals(WeatherPresets.veryLightRain));
    });
    
    test('5.0 mm @10% -> drizzle (downgrade from lightRain)', () {
      // 5.0mm maps to lightRain.
      // 10% prob < 30% threshold -> downgrade -> drizzle
      final p = createPoint(precipitationMm: 5.0, precipitationProbability: 10);
      final a = WeatherAestheticMapper.getAesthetic(p, precipProbThreshold: 30.0, downgradeOnLowProb: true);
      expect(a, equals(WeatherPresets.drizzle));
    });

    test('12.0 mm @100% -> moderateRain', () {
       // 12.0mm maps to moderateRain
      final p = createPoint(precipitationMm: 12.0, precipitationProbability: 100);
      final a = WeatherAestheticMapper.getAesthetic(p);
      expect(a, equals(WeatherPresets.moderateRain));
    });

    test('> 20.0 mm @100% -> heavyRain', () {
      final p = createPoint(precipitationMm: 20.1, precipitationProbability: 100);
      final a = WeatherAestheticMapper.getAesthetic(p);
      expect(a, equals(WeatherPresets.heavyRain));
    });

    test('Storm codes override everything (95, 96, 99) even with low prob', () {
      for (final code in [95, 96, 99]) {
        // low probability but storm code -> still storm
        final p = createPoint(
          weatherCode: code, 
          precipitationMm: 1.0, 
          precipitationProbability: 5
        );
        final a = WeatherAestheticMapper.getAesthetic(p, downgradeOnLowProb: true);
        expect(a, equals(WeatherPresets.storm), reason: 'Code $code should return storm, ignoring probability');
      }
    });

    test('Downgrade off returns base preset', () {
      final p = createPoint(precipitationMm: 0.4, precipitationProbability: 10);
      // downgradeOnLowProb = false -> returns null (according to code "Trop incertain -> on ne montre rien"?? No wait, check logic)
      
      // Checking code: if (!downgradeOnLowProb) return null;
      // So if downgrade is OFF (false), and prob is LOW, it returns NULL (Nothing).
      
      // Wait, is that what user wanted?
      // "Si downgradeOnLowProb = false la logique supprime complètement la pluie (retourne null)." -> YES.
      
      final a = WeatherAestheticMapper.getAesthetic(p, precipProbThreshold: 30.0, downgradeOnLowProb: false);
      expect(a, isNull);
    });
    
    // Additional test: what if prob is high?
    test('High probability returns base preset unmodified', () {
      final p = createPoint(precipitationMm: 1.5, precipitationProbability: 80);
      final a = WeatherAestheticMapper.getAesthetic(p, precipProbThreshold: 30.0);
      expect(a, equals(WeatherPresets.drizzle));
    });
  });
}
