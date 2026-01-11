import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/should_pulse_alert_usecase.dart';

import '../../../../core/services/open_meteo_service.dart' as om;

import '../../../../core/services/environment_service.dart';

import '../../../../core/utils/weather_icon_mapper.dart';

import '../../../../core/models/daily_weather_point.dart';
import '../../../../core/models/hourly_weather_point.dart';

import '../../../../core/providers/app_settings_provider.dart';

import '../../domain/models/weather_view_data.dart';

import '../../data/commune_storage.dart';

// WeatherViewData a été déplacé vers lib/features/climate/domain/models/weather_view_data.dart

// Utilisez l'import au-dessus pour utiliser le modèle unifié

import '../../domain/utils/weather_interpolation.dart';
import '../../../../core/utils/moon_utils.dart';
import '../../../../core/services/bio_moon_service.dart';
import 'weather_time_provider.dart';

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
  // DEBUG: verifier ce que retourne CommuneStorage au démarrage
  // debugPrint('PERSISTED PROVIDER: loading commune from CommuneStorage...');
  try {
    final (commune, lat, lon) = await CommuneStorage.loadCommune();
    // debugPrint('PERSISTED PROVIDER: CommuneStorage.loadCommune() -> commune=$commune, lat=$lat, lon=$lon');

    if (commune == null || lat == null || lon == null) return null;

    return om.Coordinates(
      latitude: lat,
      longitude: lon,
      resolvedName: commune,
    );
  } catch (e, st) {
    debugPrint('PERSISTED PROVIDER ERROR: $e\n$st');
    return null; // Fail safe
  }
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
  frost, // â „ï¸  Gel

  heatwave, // ðŸŒ¡ï¸  Canicule

  watering, // ðŸ’§ Arrosage intelligent (contextuel)

  protection, // ðŸ›¡ï¸  Protection
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
  om.Coordinates? effectiveCoords;

  // 1. Résolution des coordonnées
  try {
    final svc = om.OpenMeteoService.instance;

    // Utiliser en priorité les coordonnées persistées (Hive) si présentes,
    // sinon utiliser les coordonnées de la commune sélectionnée (ou défaut).
    final om.Coordinates? persistedCoords =
        await ref.watch(persistedCoordinatesProvider.future);

    if (persistedCoords != null) {
      effectiveCoords = persistedCoords;
    } else {
      effectiveCoords =
          await ref.watch(selectedCommuneCoordinatesProvider.future);
    }
  } catch (e, st) {
    debugPrint('CURRENT PROVIDER (COORDS) ERROR: $e\n$st');

    return WeatherViewData.fromUI(
      temperature: null,
      icon: WeatherIconMapper.getFallbackIcon(),
      description: 'Erreur localisation',
      timestamp: DateTime.now(),
      coordinates: null,
      errorMessage: 'Erreur localisation: $e',
    );
  }

  // Garantir que `coords` est non-nullable pour la suite
  final coords = effectiveCoords!;

  // DEBUG: indiquer quelles coordonnées sont réellement utilisées par le provider
  debugPrint(
      'CURRENT PROVIDER: using coords=${coords.latitude},${coords.longitude} (${coords.resolvedName})');

  // 2. Fetch Météo
  try {
    final svc = om.OpenMeteoService.instance;
    final result = await svc.fetchPrecipitation(
      latitude: coords.latitude,
      longitude: coords.longitude,
      pastDays: 1,
      forecastDays: 3,
    );

    // DEBUG: indiquer ce que renvoie OpenMeteoService
    debugPrint(
        'FETCH RESULT: hourly=${result.hourlyWeather.length}, currentTemp=${result.currentTemperatureC}');

    // Enrichir l'UI
    // Calculate moon phase for today (using CURRENT time or result date?)
    // result.currentWeatherCode is for "Now".
    // We should also update the daily list inside result if we want the UI list to be correct.
    // However, result.dailyWeather is a List<DailyWeatherPoint>.
    // To update it, we need to map it.

    final enrichedDaily = result.dailyWeather.map((d) {
      final phase = MoonUtils.calculateMoonPhase(d.date);
      // We can't easily change the Moonrise/set strings without real calculation, 
      // but we CAN fix the phase so the icon is correct.
      // We also update the 'enrich' method to accept moonPhase if we want to override it.
      // Actually DailyWeatherPoint.enrich() accepts moonPhase? Let's check model.
      // usage: return daily.enrich(...)
      
      // Let's look at DailyWeatherPoint.enrich in daily_weather_point.dart from Step 41
      // It DOES accept moonPhase, but we need to pass it.
      // It has named param `moonPhase`.

      // Calculate moon times
      final (rise, set) = BioMoonService.instance.getMoonTimes(d.date, coords.latitude, coords.longitude);
      
      // We need to pass these to enrich, but enrich might not accept them yet.
      // If enrich doesn't support them, we can use copyWith if it existed, or construct new object.
      // Easiest is to update DailyWeatherPoint.enrich first.
      // But for now, let's assume I will update it.
      return d.enrich(
        icon: d.weatherCode != null 
            ? WeatherIconMapper.getIconPath(d.weatherCode!) 
            : WeatherIconMapper.getFallbackIcon(),
        description: d.weatherCode != null 
            ? WeatherIconMapper.getWeatherDescription(d.weatherCode!) 
            : '—',
        moonPhase: phase,
        moonrise: rise?.toIso8601String(),
        moonset: set?.toIso8601String(),
      );
    }).toList();

    // Reconstruct result with enriched daily? 
    // WeatherViewData holds `result` which is OpenMeteoResult.
    // OpenMeteoResult holds `dailyWeather` list.
    // We need to update that list in the object passed to WeatherViewData.
    
    // Create new OpenMeteoResult with enriched daily
    final enrichedResult = om.OpenMeteoResult(
      latitude: result.latitude,
      longitude: result.longitude,
      hourlyWeather: result.hourlyWeather,
      dailyWeather: enrichedDaily,
      currentTemperatureC: result.currentTemperatureC,
      currentWeatherCode: result.currentWeatherCode,
      currentWindSpeed: result.currentWindSpeed,
      currentWindDirection: result.currentWindDirection,
    );

    final weatherView = WeatherViewData.fromDomain(
      locationLabel: coords.resolvedName ?? '—',
      coordinates: coords,
      result: enrichedResult,
    );
    
    // Final enrich for the "Main" view (current condition)
    final enriched = weatherView.enrich(
      icon: WeatherIconMapper.getIconPath(result.currentWeatherCode),
      description:
          WeatherIconMapper.getWeatherDescription(result.currentWeatherCode),
    );

    return enriched;
  } catch (e, st) {
    debugPrint('CURRENT PROVIDER (FETCH) ERROR: $e\n$st');

    // PLUS DE FALSIFICATION DE DONNEES (22.5°C)
    // On retourne un objet avec erreur et température null
    return WeatherViewData.fromUI(
      temperature: null,
      icon: WeatherIconMapper.getFallbackIcon(),
      description: 'Erreur météo',
      timestamp: DateTime.now(),
      coordinates: effectiveCoords,
      errorMessage: e.toString(),
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

    // Utiliser en priorité les coordonnées persistées (Hive) si présentes (restore),
    // sinon utiliser les coordonnées de la commune sélectionnée (ou défaut).
    final om.Coordinates? persistedCoords =
        await ref.watch(persistedCoordinatesProvider.future);

    // Garantir que `coords` est non-nullable pour éviter les accès `.latitude` / `.longitude`
    late final om.Coordinates coords;
    if (persistedCoords != null) {
      coords = persistedCoords;
    } else {
      coords = await ref.watch(selectedCommuneCoordinatesProvider.future);
    }

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
      
      // Calculate local moon phase
      final phase = MoonUtils.calculateMoonPhase(daily.date);

      // UPDATE: using enrich method that preserves new fields because it copies everything
      return daily.enrich(
        icon: icon,
        description: description,
        condition: condition.toString(),
        moonPhase: phase,
      );
    }).toList();
  } catch (e) {
    debugPrint('FORECAST PROVIDER ERROR: $e');
    // Return empty list on error

    return [];
  }
});

/// Transformer daily points into timeline UI points

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

// Helper for weather condition

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

String _getWeatherIcon(WeatherConditionType condition) {
  switch (condition) {
    case WeatherConditionType.sunny:
      return 'assets/weather_icons/clear_day.svg';
    case WeatherConditionType.rainy:
      return 'assets/weather_icons/rain.svg';
    case WeatherConditionType.hot:
      return 'assets/weather_icons/clear_day.svg'; // Hot uses sun
    case WeatherConditionType.snowOrFrost:
      return 'assets/weather_icons/snow.svg';
    case WeatherConditionType.cloudy:
      return 'assets/weather_icons/partly_cloudy.svg';
    case WeatherConditionType.stormy:
      return 'assets/weather_icons/thunderstorm.svg';
    case WeatherConditionType.other:
      return 'assets/weather_icons/default.svg';
  }
}

/// Provider qui renvoie la météo interpolée pour l'heure sélectionnée (Maintenant + Drag).
/// Permet à l'UI (Bulle, Graphiques) de suivre le curseur temporel en temps réel.
final projectedWeatherProvider = Provider<HourlyWeatherPoint?>((ref) {
  // 1. Écouter la météo brute
  final weatherAsync = ref.watch(currentWeatherProvider);

  // 2. Écouter le décalage temporel (Drag)
  final offsetHours = ref.watch(weatherTimeOffsetProvider);

  // Si les données ne sont pas encore chargées, on retourne null
  if (weatherAsync.value == null) return null;

  // 3. Calculer le temps cible
  // Note: offsetHours est un double (ex: 1.5 pour +1h30). On convertit en minutes.
  final projectedTime =
      DateTime.now().toUtc().add(Duration(minutes: (offsetHours * 60).round()));

  // 4. Utiliser l'utilitaire d'interpolation sur la liste horaire
  return WeatherInterpolation.getInterpolatedWeather(
      weatherAsync.value!.result.hourlyWeather, projectedTime);
});
