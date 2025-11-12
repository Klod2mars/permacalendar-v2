import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/open_meteo_service.dart';
import '../../../../core/services/environment_service.dart';
import 'weather_providers.dart';
import '../../domain/models/weather_view_data.dart';

/// Snapshot of current hourly weather data for narrative mode
class HourlyWeatherSnapshot {
  final DateTime now;
  final int hour; // 0-23
  final WeatherConditionType condition;
  final double tempC;
  final DateTime? sunrise;
  final DateTime? sunset;

  const HourlyWeatherSnapshot({
    required this.now,
    required this.hour,
    required this.condition,
    required this.tempC,
    this.sunrise,
    this.sunset,
  });

  @override
  String toString() {
    return 'HourlyWeatherSnapshot(now: $now, hour: $hour, condition: $condition, tempC: $tempC, sunrise: $sunrise, sunset: $sunset)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HourlyWeatherSnapshot &&
        other.now == now &&
        other.hour == hour &&
        other.condition == condition &&
        other.tempC == tempC &&
        other.sunrise == sunrise &&
        other.sunset == sunset;
  }

  @override
  int get hashCode {
    return now.hashCode ^
        hour.hashCode ^
        condition.hashCode ^
        tempC.hashCode ^
        sunrise.hashCode ^
        sunset.hashCode;
  }
}

/// Provider for current hourly weather snapshot
/// Updates every 5 minutes and on weather data changes
final hourlyWeatherProvider =
    FutureProvider<HourlyWeatherSnapshot>((ref) async {
  // Get current weather data
  final currentWeather = await ref.watch(currentWeatherProvider.future);

  // Get coordinates from environment (using static methods)
  final coordinates = await _getCurrentCoordinates();

  if (coordinates == null) {
    // Fallback to static data if no coordinates
    return _createFallbackSnapshot(currentWeather);
  }

  // Fetch hourly data from OpenMeteo
  final openMeteoService = OpenMeteoService.instance;
  final result = await openMeteoService.fetchPrecipitation(
    latitude: coordinates.latitude,
    longitude: coordinates.longitude,
    pastDays: 1, // Only need current day
    forecastDays: 1,
  );

  return _createSnapshotFromOpenMeteo(result, currentWeather);
});

/// Helper to convert condition string to WeatherConditionType
WeatherConditionType _parseCondition(String? conditionStr) {
  if (conditionStr == null) return WeatherConditionType.other;
  try {
    return WeatherConditionType.values.firstWhere(
      (e) => e.toString() == 'WeatherConditionType.$conditionStr',
      orElse: () => WeatherConditionType.other,
    );
  } catch (_) {
    return WeatherConditionType.other;
  }
}

/// Create fallback snapshot when coordinates are unavailable
HourlyWeatherSnapshot _createFallbackSnapshot(WeatherViewData currentWeather) {
  final now = DateTime.now();
  return HourlyWeatherSnapshot(
    now: now,
    hour: now.hour,
    condition: _parseCondition(currentWeather.condition),
    tempC: currentWeather.temperature ??
        currentWeather.currentTemperatureC ??
        20.0,
    // Use fixed time bands as fallback
    sunrise: DateTime(now.year, now.month, now.day, 7), // 7 AM
    sunset: DateTime(now.year, now.month, now.day, 19), // 7 PM
  );
}

/// Create snapshot from OpenMeteo data
HourlyWeatherSnapshot _createSnapshotFromOpenMeteo(
  OpenMeteoResult result,
  WeatherViewData currentWeather,
) {
  final now = DateTime.now();

  // Find current hour in hourly data
  final currentHourData = result.hourlyPrecipitation
      .where((point) => point.time.hour == now.hour)
      .firstOrNull;

  // Map weather condition from current weather data
  final condition = _parseCondition(currentWeather.condition);

  // Use current temperature from OpenMeteo or fallback to current weather
  final tempC = result.currentTemperatureC ??
      currentWeather.temperature ??
      currentWeather.currentTemperatureC ??
      20.0;

  // Calculate sunrise/sunset (simplified - in real implementation, use proper calculation)
  final sunrise = DateTime(now.year, now.month, now.day, 7); // 7 AM
  final sunset = DateTime(now.year, now.month, now.day, 19); // 7 PM

  return HourlyWeatherSnapshot(
    now: now,
    hour: now.hour,
    condition: condition,
    tempC: tempC,
    sunrise: sunrise,
    sunset: sunset,
  );
}

/// Provider for hourly weather with automatic refresh every 5 minutes
final hourlyWeatherWithRefreshProvider =
    StreamProvider<HourlyWeatherSnapshot>((ref) {
  return Stream.periodic(
    const Duration(minutes: 5),
    (_) => ref.read(hourlyWeatherProvider.future),
  ).asyncMap((future) => future);
});

/// Provider for current hour phase (dawn/day/dusk/night)
final currentHourPhaseProvider = Provider<DayPhase>((ref) {
  final hourlyWeather = ref.watch(hourlyWeatherProvider);
  return hourlyWeather.when(
    data: (snapshot) =>
        _getDayPhase(snapshot.hour, snapshot.sunrise, snapshot.sunset),
    loading: () => DayPhase.day, // Default fallback
    error: (_, __) => DayPhase.day, // Default fallback
  );
});

/// Day phases for color blending
enum DayPhase {
  night, // 21-5
  dawn, // 6-8
  day, // 9-16
  dusk, // 17-20
}

/// Determine day phase from hour and sun times
DayPhase _getDayPhase(int hour, DateTime? sunrise, DateTime? sunset) {
  if (sunrise != null && sunset != null) {
    final sunriseHour = sunrise.hour;
    final sunsetHour = sunset.hour;

    if (hour >= sunriseHour - 1 && hour < sunriseHour + 2) {
      return DayPhase.dawn;
    } else if (hour >= sunriseHour + 2 && hour < sunsetHour - 2) {
      return DayPhase.day;
    } else if (hour >= sunsetHour - 2 && hour < sunsetHour + 1) {
      return DayPhase.dusk;
    } else {
      return DayPhase.night;
    }
  }

  // Fallback to fixed time bands
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

/// Helper method to get current coordinates
Future<Coordinates?> _getCurrentCoordinates() async {
  // For now, use default coordinates from environment
  // TODO: In future, integrate with location service
  return Coordinates(
    latitude: EnvironmentService.defaultLatitude,
    longitude: EnvironmentService.defaultLongitude,
    resolvedName: EnvironmentService.defaultCommuneName,
  );
}

