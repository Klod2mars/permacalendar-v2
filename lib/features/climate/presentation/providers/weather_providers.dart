ï»¿import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/should_pulse_alert_usecase.dart';
import '../../../../core/services/open_meteo_service.dart' as om;
import '../../../../core/services/environment_service.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../../../core/models/daily_weather_point.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../domain/models/weather_view_data.dart';
import '../../data/commune_storage.dart';

// WeatherViewData a été déplacé vers lib/features/climate/domain/models/weather_view_data.dart
// Utilisez l'import au-dessus pour utiliser le modèle unifié

/// Provider dérivé pour obtenir des coordonnées depuis le nom de commune choisi
/// Résout le nom de commune sélectionné en coordonnées via géocodage OpenMeteo
/// Fallback sur les coordonnées stockées si le géocodage échoue ou si le mode hors ligne est actif
final selectedCommuneCoordinatesProvider =
    FutureProvider<om.Coordinates>((ref) async {
  final settings = ref.watch(appSettingsProvider);
  final name = settings.selectedCommune;
  final svc = om.OpenMeteoService.instance;
  final notifier = ref.read(appSettingsProvider.notifier);

  // Si aucune commune n'est sélectionnée, utiliser les coordonnées stockées ou défaut
  if (name == null || name.isEmpty) {
    if (settings.lastLatitude != null && settings.lastLongitude != null) {
      return om.Coordinates(
        latitude: settings.lastLatitude!,
        longitude: settings.lastLongitude!,
        resolvedName: EnvironmentService.defaultCommuneName,
      );
    }
    return om.Coordinates(
      latitude: EnvironmentService.defaultLatitude,
      longitude: EnvironmentService.defaultLongitude,
      resolvedName: EnvironmentService.defaultCommuneName,
    );
  }

  // Si les coordonnées stockées correspondent à la commune actuelle, utiliser celles-ci en priorité
  // (optimisation pour mode hors ligne)
  if (settings.lastLatitude != null && settings.lastLongitude != null) {
    // Essayer d'abord le géocodage pour obtenir des coordonnées fraÃ®ches
    try {
      final results = await svc.searchPlaces(name, count: 1);
      if (results.isNotEmpty) {
        final p = results.first;
        final coords = om.Coordinates(
          latitude: p.latitude,
          longitude: p.longitude,
          resolvedName: p.name,
        );
        // âœ… FIX : Ne sauvegarder que si les coordonnées ont vraiment changé (évite boucle infinie)
        final latChanged = (settings.lastLatitude! - p.latitude).abs() > 0.001;
        final lonChanged =
            (settings.lastLongitude! - p.longitude).abs() > 0.001;
        if (latChanged || lonChanged) {
          await notifier.setLastCoordinates(p.latitude, p.longitude);
        }
        return coords;
      }
    } catch (e) {
      // En cas d'erreur réseau, utiliser les coordonnées stockées
      return om.Coordinates(
        latitude: settings.lastLatitude!,
        longitude: settings.lastLongitude!,
        resolvedName: name,
      );
    }
  }

  // Fallback: essayer le géocodage même sans coordonnées stockées
  try {
    final results = await svc.searchPlaces(name, count: 1);
    if (results.isEmpty) {
      // Si le géocodage ne trouve rien, utiliser les coordonnées stockées ou défaut
      if (settings.lastLatitude != null && settings.lastLongitude != null) {
        return om.Coordinates(
          latitude: settings.lastLatitude!,
          longitude: settings.lastLongitude!,
          resolvedName: name,
        );
      }
      return om.Coordinates(
        latitude: EnvironmentService.defaultLatitude,
        longitude: EnvironmentService.defaultLongitude,
        resolvedName: name,
      );
    }
    final p = results.first;
    final coords = om.Coordinates(
      latitude: p.latitude,
      longitude: p.longitude,
      resolvedName: p.name,
    );
    // âœ… FIX : Ne sauvegarder que si les coordonnées ont vraiment changé (évite boucle infinie)
    if (settings.lastLatitude == null || settings.lastLongitude == null) {
      // Pas de coordonnées stockées, sauvegarder
      await notifier.setLastCoordinates(p.latitude, p.longitude);
    } else {
      // Vérifier si changement significatif (> 0.001 degré = ~100m)
      final latChanged = (settings.lastLatitude! - p.latitude).abs() > 0.001;
      final lonChanged = (settings.lastLongitude! - p.longitude).abs() > 0.001;
      if (latChanged || lonChanged) {
        await notifier.setLastCoordinates(p.latitude, p.longitude);
      }
    }
    return coords;
  } catch (e) {
    // Fallback sur coordonnées stockées ou défaut en cas d'erreur de résolution
    if (settings.lastLatitude != null && settings.lastLongitude != null) {
      return om.Coordinates(
        latitude: settings.lastLatitude!,
        longitude: settings.lastLongitude!,
        resolvedName: name,
      );
    }
    return om.Coordinates(
      latitude: EnvironmentService.defaultLatitude,
      longitude: EnvironmentService.defaultLongitude,
      resolvedName: name,
    );
  }
});

// âœ… Patch v1.2 — ajout provider persistant via CommuneStorage
// ðŸ”„ Persistent commune restore
// When app starts, load the last commune from Hive and provide its coordinates.
final persistedCoordinatesProvider =
    FutureProvider<om.Coordinates?>((ref) async {
  final (commune, lat, lon) = await CommuneStorage.loadCommune();
  if (commune == null || lat == null || lon == null) return null;
  return om.Coordinates(
    latitude: lat,
    longitude: lon,
    resolvedName: commune,
  );
});

/// Weather condition types for halo mapping
enum WeatherConditionType {
  sunny,
  rainy,
  hot,
  snowOrFrost,
  cloudy,
  stormy,
  other,
}

/// Timeline point with past/future flag for history + forecast
class TimelineWeatherPoint {
  final DateTime date;
  final double? minTemp;
  final double? maxTemp;
  final String icon;
  final String description;
  final double? precipitation;
  final WeatherConditionType? condition;
  final int? weatherCode;
  final bool isPast; // true for history (J-), false for forecast (J0/J+)

  const TimelineWeatherPoint({
    required this.date,
    this.minTemp,
    this.maxTemp,
    required this.icon,
    required this.description,
    this.precipitation,
    this.condition,
    this.weatherCode,
    required this.isPast,
  });
}

/// Weather alert types for intelligent detection
enum WeatherAlertType {
  frost, // â„ï¸ Gel
  heatwave, // ðŸŒ¡ï¸ Canicule
  watering, // ðŸ’§ Arrosage intelligent (contextuel)
  protection, // ðŸ›¡ï¸ Protection
}

/// Alert severity levels
enum AlertSeverity {
  info, // Information
  warning, // Attention
  critical, // Critique
}

/// Enhanced weather alert model with intelligent recommendations
class WeatherAlert {
  final String id;
  final WeatherAlertType type;
  final AlertSeverity severity;
  final String title;
  final String description;
  final DateTime validFrom;
  final DateTime validUntil;
  final double? temperature;
  final List<String> recommendations;
  final String iconPath;
  final List<String> affectedPlants; // Plantes concernées
  final bool isMeteoDependent; // Dépendant météo
  final DateTime timestamp;

  const WeatherAlert({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    required this.validFrom,
    required this.validUntil,
    this.temperature,
    this.recommendations = const [],
    required this.iconPath,
    this.affectedPlants = const [],
    this.isMeteoDependent = false,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'WeatherAlert(id: $id, type: $type, severity: $severity, title: $title, description: $description, validFrom: $validFrom, validUntil: $validUntil, temperature: $temperature, recommendations: $recommendations, iconPath: $iconPath, affectedPlants: $affectedPlants, isMeteoDependent: $isMeteoDependent, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherAlert &&
        other.id == id &&
        other.type == type &&
        other.severity == severity &&
        other.title == title &&
        other.description == description &&
        other.validFrom == validFrom &&
        other.validUntil == validUntil &&
        other.temperature == temperature &&
        other.recommendations == recommendations &&
        other.iconPath == iconPath &&
        other.affectedPlants == affectedPlants &&
        other.isMeteoDependent == isMeteoDependent &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        severity.hashCode ^
        title.hashCode ^
        description.hashCode ^
        validFrom.hashCode ^
        validUntil.hashCode ^
        temperature.hashCode ^
        recommendations.hashCode ^
        iconPath.hashCode ^
        affectedPlants.hashCode ^
        isMeteoDependent.hashCode ^
        timestamp.hashCode;
  }
}

// DailyWeatherPoint a été déplacé vers lib/core/models/daily_weather_point.dart
// Utilisez l'import au-dessus pour utiliser le modèle unifié

/// Provider for current weather data from OpenMeteo
final currentWeatherProvider = FutureProvider<WeatherViewData>((ref) async {
  try {
    final svc = om.OpenMeteoService.instance;

    // Utiliser les coordonnées de la commune sélectionnée (ou défaut)
    final coords = await ref.watch(selectedCommuneCoordinatesProvider.future);

    final result = await svc.fetchPrecipitation(
      latitude: coords.latitude,
      longitude: coords.longitude,
      pastDays: 1,
      forecastDays: 1,
    );

    // Get current temperature from hourly data or daily data
    final currentTemp = result.currentTemperatureC ??
        (result.dailyWeather.isNotEmpty
            ? (result.dailyWeather.first.tMaxC ?? 20.0)
            : 20.0);

    // Get current weather code
    final currentWeatherCode = result.currentWeatherCode;

    // Get today's min/max from daily data
    final today =
        result.dailyWeather.isNotEmpty ? result.dailyWeather.first : null;
    final minTemp = today?.tMinC;
    final maxTemp = today?.tMaxC;

    // Determine weather condition and icon based on weather code or fallback to temperature/precipitation
    final condition =
        _determineWeatherCondition(currentTemp, today?.precipMm ?? 0.0);
    final icon = currentWeatherCode != null
        ? WeatherIconMapper.getIconPath(currentWeatherCode)
        : _getWeatherIcon(condition);
    final description = currentWeatherCode != null
        ? WeatherIconMapper.getWeatherDescription(currentWeatherCode)
        : _getWeatherDescription(condition);

    return WeatherViewData.fromUI(
      temperature: currentTemp,
      minTemp: minTemp,
      maxTemp: maxTemp,
      icon: icon,
      description: description,
      timestamp: DateTime.now(),
      condition: condition.toString(),
      weatherCode: currentWeatherCode,
    );
  } catch (e) {
    // Fallback to default data on error
    return WeatherViewData.fromUI(
      temperature: 22.5,
      icon: WeatherIconMapper.getIconPath(0), // Code 0 = ciel clair
      description: 'Ensoleillé',
      timestamp: DateTime.now(),
      condition: WeatherConditionType.sunny.toString(),
      weatherCode: 0,
    );
  }
});

/// Provider for weather alerts from weather impact analyzer
final alertsProvider = FutureProvider<List<WeatherAlert>>((ref) async {
  try {
    final weatherData = await ref.watch(currentWeatherProvider.future);

    // For now, create simple alerts based on temperature thresholds
    // TODO: Integrate with full WeatherImpactAnalyzer when GardenContext is properly configured
    final alerts = <WeatherAlert>[];

    final temp =
        weatherData.temperature ?? weatherData.currentTemperatureC ?? 20.0;
    if (temp < 5) {
      alerts.add(WeatherAlert(
        id: 'frost_${DateTime.now().millisecondsSinceEpoch}',
        type: WeatherAlertType.frost,
        severity: AlertSeverity.warning,
        title: 'Risque de gel',
        description: 'Température: ${temp.toStringAsFixed(1)}Â°C',
        validFrom: DateTime.now(),
        validUntil: DateTime.now().add(const Duration(hours: 12)),
        iconPath: 'assets/weather_icons/frost_alert.png',
        timestamp: DateTime.now(),
      ));
    }

    if (temp > 32) {
      alerts.add(WeatherAlert(
        id: 'heat_${DateTime.now().millisecondsSinceEpoch}',
        type: WeatherAlertType.heatwave,
        severity: AlertSeverity.critical,
        title: 'Canicule',
        description: 'Température: ${temp.toStringAsFixed(1)}Â°C',
        validFrom: DateTime.now(),
        validUntil: DateTime.now().add(const Duration(days: 1)),
        iconPath: 'assets/weather_icons/heat_alert.png',
        timestamp: DateTime.now(),
      ));
    }

    return alerts;
  } catch (e) {
    // Return empty list on error
    return [];
  }
});

/// Provider for weather forecast data from OpenMeteo
final forecastProvider = FutureProvider<List<DailyWeatherPoint>>((ref) async {
  try {
    final svc = om.OpenMeteoService.instance;

    // Utiliser les coordonnées de la commune sélectionnée (ou défaut)
    final coords = await ref.watch(selectedCommuneCoordinatesProvider.future);

    final result = await svc.fetchPrecipitation(
      latitude: coords.latitude,
      longitude: coords.longitude,
      pastDays: 0,
      forecastDays: 7,
    );

    // Get forecast data (future days)
    final (_, forecastData) = result.splitByToday();

    return forecastData.map((daily) {
      final condition =
          _determineWeatherCondition((daily.tMaxC ?? 20.0), daily.precipMm);
      final icon = daily.weatherCode != null
          ? WeatherIconMapper.getIconPath(daily.weatherCode)
          : _getWeatherIcon(condition);
      final description = daily.weatherCode != null
          ? WeatherIconMapper.getWeatherDescription(daily.weatherCode)
          : _getWeatherDescription(condition);

      return DailyWeatherPoint.fromEnriched(
        date: daily.date,
        minTemp: daily.tMinC,
        maxTemp: daily.tMaxC,
        icon: icon,
        description: description,
        precipitation: daily.precipMm,
        condition: condition.toString(),
        weatherCode: daily.weatherCode,
      );
    }).toList();
  } catch (e) {
    // Return empty list on error
    return [];
  }
});

/// Combined forecast + history provider (J-14 â†’ J+7)
final forecastHistoryProvider =
    FutureProvider<List<TimelineWeatherPoint>>((ref) async {
  try {
    final svc = om.OpenMeteoService.instance;
    // Utiliser les coordonnées de la commune sélectionnée (ou défaut)
    final coords = await ref.watch(selectedCommuneCoordinatesProvider.future);

    final result = await svc.fetchPrecipitation(
      latitude: coords.latitude,
      longitude: coords.longitude,
      pastDays: 14,
      forecastDays: 7,
    );

    final (past, forecast) = result.splitByToday();

    List<TimelineWeatherPoint> mapList(List<DailyWeatherPoint> src,
        {required bool pastFlag}) {
      return src.map((daily) {
        final condition = _determineWeatherCondition(
          (daily.tMaxC ?? 20.0),
          daily.precipMm,
        );
        final icon = daily.weatherCode != null
            ? WeatherIconMapper.getIconPath(daily.weatherCode!)
            : _getWeatherIcon(condition);
        final description = daily.weatherCode != null
            ? WeatherIconMapper.getWeatherDescription(daily.weatherCode!)
            : _getWeatherDescription(condition);

        return TimelineWeatherPoint(
          date: daily.date,
          minTemp: daily.tMinC,
          maxTemp: daily.tMaxC,
          icon: icon,
          description: description,
          precipitation: daily.precipMm,
          condition: condition,
          weatherCode: daily.weatherCode,
          isPast: pastFlag,
        );
      }).toList();
    }

    final timeline = <TimelineWeatherPoint>[
      ...mapList(past, pastFlag: true),
      ...mapList(forecast, pastFlag: false),
    ];
    return timeline;
  } catch (e) {
    return [];
  }
});

/// Provider for determining if alert pulse should be active
///
/// Uses the ShouldPulseAlertUsecase to determine if alerts are present
/// and should trigger the pulse animation.
final shouldPulseAlertProvider = Provider<bool>((ref) {
  final alerts = ref.watch(alertsProvider).value;
  return ShouldPulseAlertUsecase().call(alerts);
});

/// Provider for alert count
///
/// Returns the number of active alerts.
final alertCountProvider = Provider<int>((ref) {
  final alerts = ref.watch(alertsProvider).value;
  return ShouldPulseAlertUsecase().getAlertCount(alerts);
});

/// Provider for alerts summary
///
/// Returns a human-readable summary of alerts.
final alertsSummaryProvider = Provider<String>((ref) {
  final alerts = ref.watch(alertsProvider).value;
  return ShouldPulseAlertUsecase().getAlertsSummary(alerts);
});

/// Provider for forecast availability
///
/// Returns true if forecast data is available.
final forecastAvailableProvider = Provider<bool>((ref) {
  final forecast = ref.watch(forecastProvider);
  return forecast.hasValue && forecast.value!.isNotEmpty;
});

/// Provider for forecast days count
///
/// Returns the number of forecast days available.
final forecastDaysCountProvider = Provider<int>((ref) {
  final forecast = ref.watch(forecastProvider);
  return forecast.hasValue ? forecast.value!.length : 0;
});

/// Provider for current air temperature
///
/// Extracts the current air temperature from weather data.
/// This is used for soil temperature calculations.
final currentAirTempProvider = Provider<double?>((ref) {
  final weather = ref.watch(currentWeatherProvider);
  return weather.hasValue ? weather.value!.temperature : null;
});

/// Provider for weather data freshness
///
/// Returns true if weather data is fresh (less than 1 hour old).
final weatherDataFreshProvider = Provider<bool>((ref) {
  final weather = ref.watch(currentWeatherProvider);
  if (!weather.hasValue) return false;

  final timestamp = weather.value!.timestamp;

  final now = DateTime.now();
  final difference = now.difference(timestamp);
  return difference.inHours < 1;
});

// ============================================================================
// HELPER FUNCTIONS FOR WEATHER CONDITION DETERMINATION
// ============================================================================

/// Determines weather condition based on temperature and precipitation
WeatherConditionType _determineWeatherCondition(
    double temperature, double precipitation) {
  if (precipitation > 5.0) {
    return WeatherConditionType.rainy;
  } else if (temperature < 0) {
    return WeatherConditionType.snowOrFrost;
  } else if (temperature > 32) {
    return WeatherConditionType.hot;
  } else if (precipitation > 1.0) {
    return WeatherConditionType.cloudy;
  } else if (temperature > 25) {
    return WeatherConditionType.sunny;
  } else {
    return WeatherConditionType.other;
  }
}

/// Gets weather icon based on condition
String _getWeatherIcon(WeatherConditionType condition) {
  switch (condition) {
    case WeatherConditionType.sunny:
      return 'â˜€ï¸';
    case WeatherConditionType.rainy:
      return 'ðŸŒ§ï¸';
    case WeatherConditionType.hot:
      return 'ðŸ”¥';
    case WeatherConditionType.snowOrFrost:
      return 'â„ï¸';
    case WeatherConditionType.cloudy:
      return 'â›…';
    case WeatherConditionType.stormy:
      return 'â›ˆï¸';
    case WeatherConditionType.other:
      return 'ðŸŒ¤ï¸';
  }
}

/// Gets weather description based on condition
String _getWeatherDescription(WeatherConditionType condition) {
  switch (condition) {
    case WeatherConditionType.sunny:
      return 'Ensoleillé';
    case WeatherConditionType.rainy:
      return 'Pluvieux';
    case WeatherConditionType.hot:
      return 'Canicule';
    case WeatherConditionType.snowOrFrost:
      return 'Gel/Neige';
    case WeatherConditionType.cloudy:
      return 'Nuageux';
    case WeatherConditionType.stormy:
      return 'Orageux';
    case WeatherConditionType.other:
      return 'Variable';
  }
}


