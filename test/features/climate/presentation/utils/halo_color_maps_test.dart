import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/climate/presentation/utils/halo_color_maps.dart';
import 'package:permacalendar/features/climate/presentation/providers/weather_providers.dart';

void main() {
  group('HaloColorMaps', () {
    group('baseWeatherHue', () {
      test('returns correct colors for each weather condition', () {
        expect(
          HaloColorMaps.baseWeatherHue(WeatherConditionType.sunny),
          const Color(0xFFFFD54F), // Soft amber
        );

        expect(
          HaloColorMaps.baseWeatherHue(WeatherConditionType.rainy),
          const Color(0xFF64B5F6), // Soft blue
        );

        expect(
          HaloColorMaps.baseWeatherHue(WeatherConditionType.hot),
          const Color(0xFFFFB74D), // Soft orange
        );

        expect(
          HaloColorMaps.baseWeatherHue(WeatherConditionType.snowOrFrost),
          const Color(0xFFB3E5FC), // Soft light blue
        );

        expect(
          HaloColorMaps.baseWeatherHue(WeatherConditionType.cloudy),
          const Color(0xFFBDBDBD), // Soft grey
        );

        expect(
          HaloColorMaps.baseWeatherHue(WeatherConditionType.stormy),
          const Color(0xFFBA68C8), // Soft purple
        );

        expect(
          HaloColorMaps.baseWeatherHue(WeatherConditionType.other),
          const Color(0xFFE0E0E0), // Neutral light grey
        );
      });
    });

    group('dayPhaseFactor', () {
      test('returns correct phase factors for fixed time bands', () {
        // Night: 21-5
        expect(
          HaloColorMaps.dayPhaseFactor(DateTime(2024, 1, 1, 23)), // 11 PM
          equals(0.0),
        );
        expect(
          HaloColorMaps.dayPhaseFactor(DateTime(2024, 1, 1, 2)), // 2 AM
          equals(0.0),
        );

        // Dawn: 5-8
        expect(
          HaloColorMaps.dayPhaseFactor(DateTime(2024, 1, 1, 6)), // 6 AM
          greaterThan(0.0),
        );
        expect(
          HaloColorMaps.dayPhaseFactor(DateTime(2024, 1, 1, 6)),
          lessThan(0.3),
        );

        // Day: 8-17
        expect(
          HaloColorMaps.dayPhaseFactor(DateTime(2024, 1, 1, 12)), // Noon
          equals(0.8),
        );

        // Dusk: 17-21
        expect(
          HaloColorMaps.dayPhaseFactor(DateTime(2024, 1, 1, 19)), // 7 PM
          greaterThan(0.0),
        );
        expect(
          HaloColorMaps.dayPhaseFactor(DateTime(2024, 1, 1, 19)),
          lessThan(0.6),
        );
      });

      test('returns correct phase factors with sun times', () {
        final sunrise = DateTime(2024, 1, 1, 7); // 7 AM
        final sunset = DateTime(2024, 1, 1, 19); // 7 PM

        // Night
        expect(
          HaloColorMaps.dayPhaseFactor(
            DateTime(2024, 1, 1, 23),
            sunrise: sunrise,
            sunset: sunset,
          ),
          equals(0.0),
        );

        // Dawn
        expect(
          HaloColorMaps.dayPhaseFactor(
            DateTime(2024, 1, 1, 7), // Sunrise
            sunrise: sunrise,
            sunset: sunset,
          ),
          greaterThan(0.0),
        );

        // Day
        expect(
          HaloColorMaps.dayPhaseFactor(
            DateTime(2024, 1, 1, 12), // Noon
            sunrise: sunrise,
            sunset: sunset,
          ),
          equals(0.8),
        );

        // Dusk
        expect(
          HaloColorMaps.dayPhaseFactor(
            DateTime(2024, 1, 1, 19), // Sunset
            sunrise: sunrise,
            sunset: sunset,
          ),
          greaterThan(0.0),
        );
      });
    });

    group('blendWeatherWithDayPhase', () {
      test('adjusts lightness and opacity based on phase factor', () {
        const weatherHue = Color(0xFFFFD54F); // Sunny color

        // Night phase (factor = 0.0)
        final nightColor =
            HaloColorMaps.blendWeatherWithDayPhase(weatherHue, 0.0);
        expect(nightColor.opacity, equals(0.0));

        // Day phase (factor = 0.8)
        final dayColor =
            HaloColorMaps.blendWeatherWithDayPhase(weatherHue, 0.8);
        expect(dayColor.opacity, greaterThan(0.0));
        expect(
            dayColor.opacity, lessThanOrEqualTo(HaloColorMaps.maxHaloOpacity));

        // Dawn phase (factor = 0.3)
        final dawnColor =
            HaloColorMaps.blendWeatherWithDayPhase(weatherHue, 0.3);
        expect(dawnColor.opacity, greaterThan(0.0));
        expect(dawnColor.opacity, lessThan(dayColor.opacity));
      });

      test('never exceeds maximum opacity', () {
        const weatherHue = Color(0xFFFFD54F);

        // Even with factor > 1.0, opacity should be capped
        final highFactorColor =
            HaloColorMaps.blendWeatherWithDayPhase(weatherHue, 2.0);
        expect(highFactorColor.opacity,
            lessThanOrEqualTo(HaloColorMaps.maxHaloOpacity));
      });
    });

    group('getHaloColor', () {
      test('returns correct color for sunny condition at different times', () {
        final sunnyNoon = HaloColorMaps.getHaloColor(
          WeatherConditionType.sunny,
          DateTime(2024, 1, 1, 12), // Noon
        );

        final sunnyNight = HaloColorMaps.getHaloColor(
          WeatherConditionType.sunny,
          DateTime(2024, 1, 1, 2), // 2 AM
        );

        // Noon should be brighter than night
        expect(sunnyNoon.opacity, greaterThan(sunnyNight.opacity));
      });

      test('returns different colors for different weather conditions', () {
        final sunnyColor = HaloColorMaps.getHaloColor(
          WeatherConditionType.sunny,
          DateTime(2024, 1, 1, 12),
        );

        final rainyColor = HaloColorMaps.getHaloColor(
          WeatherConditionType.rainy,
          DateTime(2024, 1, 1, 12),
        );

        // Colors should be different
        expect(sunnyColor.value, isNot(equals(rainyColor.value)));
      });
    });

    group('getStaticHaloColor', () {
      test('returns static color for weather condition', () {
        final staticColor =
            HaloColorMaps.getStaticHaloColor(WeatherConditionType.sunny);

        expect(staticColor.opacity, greaterThan(0.0));
        expect(staticColor.opacity,
            lessThanOrEqualTo(HaloColorMaps.maxHaloOpacity));
      });

      test('returns transparent for null condition', () {
        final staticColor = HaloColorMaps.getStaticHaloColor(null);

        expect(staticColor, equals(Colors.transparent));
      });
    });
  });
}
