import 'package:flutter/material.dart';
import '../providers/weather_providers.dart';
import '../providers/hourly_weather_provider.dart';

/// Pure functions for computing halo colors from weather conditions and day phases
/// All functions are testable and have no side effects
class HaloColorMaps {
  HaloColorMaps._(); // Private constructor for utility class

  /// Maximum opacity for halo colors (performance constraint)
  static const double maxHaloOpacity = 0.15;

  /// Base weather hue mapping - returns soft, muted colors
  static Color baseWeatherHue(WeatherConditionType condition) {
    switch (condition) {
      case WeatherConditionType.sunny:
        // Jaune-vert doux pour soleil
        return const Color(0xFFD4E157); // Lime 400
      case WeatherConditionType.rainy:
        return const Color(0xFF64B5F6); // Soft blue
      case WeatherConditionType.hot:
        return const Color(0xFFFFB74D); // Soft orange
      case WeatherConditionType.snowOrFrost:
        // Cyan pour froid (gel/neige)
        return const Color(0xFF4DD0E1); // Cyan 300
      case WeatherConditionType.cloudy:
        return const Color(0xFFBDBDBD); // Soft grey
      case WeatherConditionType.stormy:
        return const Color(0xFFBA68C8); // Soft purple
      case WeatherConditionType.other:
        return const Color(0xFFE0E0E0); // Neutral light grey
    }
  }

  /// Calculate day phase factor (0.0 to 1.0) for smooth transitions
  static double dayPhaseFactor(DateTime now,
      {DateTime? sunrise, DateTime? sunset}) {
    final hour = now.hour;

    if (sunrise != null && sunset != null) {
      return _calculatePhaseFactorWithSunTimes(hour, sunrise, sunset);
    }

    // Fallback to fixed time bands with smooth transitions
    return _calculatePhaseFactorFixed(hour);
  }

  /// Calculate phase factor using actual sunrise/sunset times
  static double _calculatePhaseFactorWithSunTimes(
      int hour, DateTime sunrise, DateTime sunset) {
    final sunriseHour = sunrise.hour + sunrise.minute / 60.0;
    final sunsetHour = sunset.hour + sunset.minute / 60.0;
    final currentHour = hour + DateTime.now().minute / 60.0;

    // Night phase (after sunset + 1h to before sunrise - 1h)
    if (currentHour >= sunsetHour + 1 || currentHour < sunriseHour - 1) {
      return 0.0; // Darkest
    }

    // Dawn phase (sunrise - 1h to sunrise + 2h)
    if (currentHour >= sunriseHour - 1 && currentHour < sunriseHour + 2) {
      final progress = (currentHour - (sunriseHour - 1)) / 3.0; // 3-hour dawn
      return _smoothCurve(progress) * 0.3; // Gentle dawn glow
    }

    // Day phase (sunrise + 2h to sunset - 2h)
    if (currentHour >= sunriseHour + 2 && currentHour < sunsetHour - 2) {
      return 0.8; // Bright day
    }

    // Dusk phase (sunset - 2h to sunset + 1h)
    if (currentHour >= sunsetHour - 2 && currentHour < sunsetHour + 1) {
      final progress = (currentHour - (sunsetHour - 2)) / 3.0; // 3-hour dusk
      return (1.0 - _smoothCurve(progress)) * 0.6; // Dimming dusk
    }

    return 0.0; // Default to night
  }

  /// Calculate phase factor using fixed time bands
  static double _calculatePhaseFactorFixed(int hour) {
    // Night: 21-5 (8 hours)
    if (hour >= 21 || hour < 5) {
      return 0.0;
    }

    // Dawn: 5-8 (3 hours)
    if (hour >= 5 && hour < 8) {
      final progress = (hour - 5) / 3.0;
      return _smoothCurve(progress) * 0.3;
    }

    // Day: 8-17 (9 hours)
    if (hour >= 8 && hour < 17) {
      return 0.8;
    }

    // Dusk: 17-21 (4 hours)
    if (hour >= 17 && hour < 21) {
      final progress = (hour - 17) / 4.0;
      return (1.0 - _smoothCurve(progress)) * 0.6;
    }

    return 0.0;
  }

  /// Smooth curve for natural transitions (ease-in-out)
  static double _smoothCurve(double t) {
    // Clamp to [0, 1]
    t = t.clamp(0.0, 1.0);

    // Smooth step function (3t² - 2t³)
    return 3 * t * t - 2 * t * t * t;
  }

  /// Blend weather color with day phase factor
  static Color blendWeatherWithDayPhase(Color weatherHue, double phaseFactor) {
    // Adjust lightness based on day phase (clamp to valid range)
    final lightness = (0.3 + (phaseFactor * 0.4)).clamp(0.0, 1.0);

    // Convert to HSL, adjust lightness, convert back
    final hsl = HSLColor.fromColor(weatherHue);
    final adjustedHsl = hsl.withLightness(lightness);

    // Apply opacity cap
    return adjustedHsl.toColor().withOpacity(
          (phaseFactor * maxHaloOpacity).clamp(0.0, maxHaloOpacity),
        );
  }

  /// Get final halo color for a given weather condition and time
  static Color getHaloColor(
    WeatherConditionType condition,
    DateTime now, {
    DateTime? sunrise,
    DateTime? sunset,
  }) {
    final weatherHue = baseWeatherHue(condition);
    final phaseFactor = dayPhaseFactor(now, sunrise: sunrise, sunset: sunset);

    return blendWeatherWithDayPhase(weatherHue, phaseFactor);
  }

  /// Get halo color from hourly weather snapshot
  static Color getHaloColorFromSnapshot(HourlyWeatherSnapshot snapshot) {
    return getHaloColor(
      snapshot.condition,
      snapshot.now,
      sunrise: snapshot.sunrise,
      sunset: snapshot.sunset,
    );
  }

  /// Get static halo color (Phase 3 fallback)
  static Color getStaticHaloColor(WeatherConditionType? condition) {
    if (condition == null) return Colors.transparent;

    final weatherHue = baseWeatherHue(condition);
    // Static halo uses fixed day phase (0.6) for consistent visibility
    return blendWeatherWithDayPhase(weatherHue, 0.6);
  }
}

