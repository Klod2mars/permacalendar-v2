ï»¿import 'package:flutter/material.dart';
import '../providers/hourly_weather_provider.dart';

/// Pure helper functions for day phase calculations and blending
/// All functions are testable and have no side effects
class DayPhaseBlend {
  DayPhaseBlend._(); // Private constructor for utility class

  /// Check if current time is in dawn phase
  static bool isDawn(DateTime now, {DateTime? sunrise, DateTime? sunset}) {
    final phase = _getDayPhase(now, sunrise, sunset);
    return phase == DayPhase.dawn;
  }

  /// Check if current time is in day phase
  static bool isDay(DateTime now, {DateTime? sunrise, DateTime? sunset}) {
    final phase = _getDayPhase(now, sunrise, sunset);
    return phase == DayPhase.day;
  }

  /// Check if current time is in dusk phase
  static bool isDusk(DateTime now, {DateTime? sunrise, DateTime? sunset}) {
    final phase = _getDayPhase(now, sunrise, sunset);
    return phase == DayPhase.dusk;
  }

  /// Check if current time is in night phase
  static bool isNight(DateTime now, {DateTime? sunrise, DateTime? sunset}) {
    final phase = _getDayPhase(now, sunrise, sunset);
    return phase == DayPhase.night;
  }

  /// Get current day phase
  static DayPhase getCurrentPhase(DateTime now,
      {DateTime? sunrise, DateTime? sunset}) {
    return _getDayPhase(now, sunrise, sunset);
  }

  /// Get day phase from hour and sun times
  static DayPhase _getDayPhase(
      DateTime now, DateTime? sunrise, DateTime? sunset) {
    final hour = now.hour;

    if (sunrise != null && sunset != null) {
      return _getPhaseWithSunTimes(hour, sunrise, sunset);
    }

    // Fallback to fixed time bands
    return _getPhaseFixed(hour);
  }

  /// Get phase using actual sunrise/sunset times
  static DayPhase _getPhaseWithSunTimes(
      int hour, DateTime sunrise, DateTime sunset) {
    final sunriseHour = sunrise.hour + sunrise.minute / 60.0;
    final sunsetHour = sunset.hour + sunset.minute / 60.0;
    final currentHour = hour + DateTime.now().minute / 60.0;

    // Night phase (after sunset + 1h to before sunrise - 1h)
    if (currentHour >= sunsetHour + 1 || currentHour < sunriseHour - 1) {
      return DayPhase.night;
    }

    // Dawn phase (sunrise - 1h to sunrise + 2h)
    if (currentHour >= sunriseHour - 1 && currentHour < sunriseHour + 2) {
      return DayPhase.dawn;
    }

    // Day phase (sunrise + 2h to sunset - 2h)
    if (currentHour >= sunriseHour + 2 && currentHour < sunsetHour - 2) {
      return DayPhase.day;
    }

    // Dusk phase (sunset - 2h to sunset + 1h)
    if (currentHour >= sunsetHour - 2 && currentHour < sunsetHour + 1) {
      return DayPhase.dusk;
    }

    return DayPhase.night; // Default
  }

  /// Get phase using fixed time bands
  static DayPhase _getPhaseFixed(int hour) {
    if (hour >= 6 && hour < 9) {
      return DayPhase.dawn;
    } else if (hour >= 9 && hour < 17) {
      return DayPhase.day;
    } else if (hour >= 17 && hour < 21) {
      return DayPhase.dusk;
    } else {
      return DayPhase.night;
    }
  }

  /// Get phase transition progress (0.0 to 1.0) within current phase
  static double getPhaseProgress(DateTime now,
      {DateTime? sunrise, DateTime? sunset}) {
    final hour = now.hour;
    final minute = now.minute;
    final currentHour = hour + minute / 60.0;

    if (sunrise != null && sunset != null) {
      return _getProgressWithSunTimes(currentHour, sunrise, sunset);
    }

    return _getProgressFixed(currentHour);
  }

  /// Get progress within current phase using sun times
  static double _getProgressWithSunTimes(
      double currentHour, DateTime sunrise, DateTime sunset) {
    final sunriseHour = sunrise.hour + sunrise.minute / 60.0;
    final sunsetHour = sunset.hour + sunset.minute / 60.0;

    // Night phase
    if (currentHour >= sunsetHour + 1 || currentHour < sunriseHour - 1) {
      return 0.0; // No progress in night phase
    }

    // Dawn phase (3 hours)
    if (currentHour >= sunriseHour - 1 && currentHour < sunriseHour + 2) {
      final phaseStart = sunriseHour - 1;
      return (currentHour - phaseStart) / 3.0;
    }

    // Day phase
    if (currentHour >= sunriseHour + 2 && currentHour < sunsetHour - 2) {
      return 0.5; // Mid-day
    }

    // Dusk phase (3 hours)
    if (currentHour >= sunsetHour - 2 && currentHour < sunsetHour + 1) {
      final phaseStart = sunsetHour - 2;
      return (currentHour - phaseStart) / 3.0;
    }

    return 0.0;
  }

  /// Get progress within current phase using fixed times
  static double _getProgressFixed(double currentHour) {
    // Dawn phase (6-9, 3 hours)
    if (currentHour >= 6 && currentHour < 9) {
      return (currentHour - 6) / 3.0;
    }

    // Day phase (9-17, 8 hours)
    if (currentHour >= 9 && currentHour < 17) {
      return (currentHour - 9) / 8.0;
    }

    // Dusk phase (17-21, 4 hours)
    if (currentHour >= 17 && currentHour < 21) {
      return (currentHour - 17) / 4.0;
    }

    // Night phase
    return 0.0;
  }

  /// Apply easing curve to progress value
  static double applyEasing(double progress, Curve curve) {
    return curve.transform(progress.clamp(0.0, 1.0));
  }

  /// Get smooth transition between two values based on phase progress
  static double lerpWithPhase(
    double startValue,
    double endValue,
    DateTime now, {
    DateTime? sunrise,
    DateTime? sunset,
    Curve curve = Curves.easeInOut,
  }) {
    final progress = getPhaseProgress(now, sunrise: sunrise, sunset: sunset);
    final easedProgress = applyEasing(progress, curve);

    return startValue + (endValue - startValue) * easedProgress;
  }

  /// Get color transition between two colors based on phase progress
  static Color lerpColorWithPhase(
    Color startColor,
    Color endColor,
    DateTime now, {
    DateTime? sunrise,
    DateTime? sunset,
    Curve curve = Curves.easeInOut,
  }) {
    final progress = getPhaseProgress(now, sunrise: sunrise, sunset: sunset);
    final easedProgress = applyEasing(progress, curve);

    return Color.lerp(startColor, endColor, easedProgress) ?? startColor;
  }

  /// Get phase description for debugging/logging
  static String getPhaseDescription(DateTime now,
      {DateTime? sunrise, DateTime? sunset}) {
    final phase = _getDayPhase(now, sunrise, sunset);
    final progress = getPhaseProgress(now, sunrise: sunrise, sunset: sunset);

    return '${phase.name} (${(progress * 100).toStringAsFixed(1)}%)';
  }

  /// Get time until next phase transition
  static Duration getTimeToNextPhase(DateTime now,
      {DateTime? sunrise, DateTime? sunset}) {
    final currentPhase = _getDayPhase(now, sunrise, sunset);
    final currentHour = now.hour + now.minute / 60.0;

    if (sunrise != null && sunset != null) {
      return _getTimeToNextPhaseWithSunTimes(
          currentHour, currentPhase, sunrise, sunset);
    }

    return _getTimeToNextPhaseFixed(currentHour, currentPhase);
  }

  /// Get time to next phase using sun times
  static Duration _getTimeToNextPhaseWithSunTimes(
    double currentHour,
    DayPhase currentPhase,
    DateTime sunrise,
    DateTime sunset,
  ) {
    final sunriseHour = sunrise.hour + sunrise.minute / 60.0;
    final sunsetHour = sunset.hour + sunset.minute / 60.0;

    switch (currentPhase) {
      case DayPhase.night:
        // Next: dawn (sunrise - 1h)
        final nextDawn = sunriseHour - 1;
        final hoursToDawn = nextDawn > currentHour
            ? nextDawn - currentHour
            : (24 - currentHour) + nextDawn;
        return Duration(minutes: (hoursToDawn * 60).round());

      case DayPhase.dawn:
        // Next: day (sunrise + 2h)
        final nextDay = sunriseHour + 2;
        final hoursToDay = nextDay - currentHour;
        return Duration(minutes: (hoursToDay * 60).round());

      case DayPhase.day:
        // Next: dusk (sunset - 2h)
        final nextDusk = sunsetHour - 2;
        final hoursToDusk = nextDusk - currentHour;
        return Duration(minutes: (hoursToDusk * 60).round());

      case DayPhase.dusk:
        // Next: night (sunset + 1h)
        final nextNight = sunsetHour + 1;
        final hoursToNight = nextNight - currentHour;
        return Duration(minutes: (hoursToNight * 60).round());
    }
  }

  /// Get time to next phase using fixed times
  static Duration _getTimeToNextPhaseFixed(
      double currentHour, DayPhase currentPhase) {
    switch (currentPhase) {
      case DayPhase.night:
        // Next: dawn (6 AM)
        final hoursToDawn =
            currentHour < 6 ? 6 - currentHour : (24 - currentHour) + 6;
        return Duration(minutes: (hoursToDawn * 60).round());

      case DayPhase.dawn:
        // Next: day (9 AM)
        final hoursToDay = 9 - currentHour;
        return Duration(minutes: (hoursToDay * 60).round());

      case DayPhase.day:
        // Next: dusk (5 PM)
        final hoursToDusk = 17 - currentHour;
        return Duration(minutes: (hoursToDusk * 60).round());

      case DayPhase.dusk:
        // Next: night (9 PM)
        final hoursToNight = 21 - currentHour;
        return Duration(minutes: (hoursToNight * 60).round());
    }
  }
}


