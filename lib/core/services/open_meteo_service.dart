import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:permacalendar/core/models/daily_weather_point.dart';

/// Service d'intégration Open-Meteo (sans clé API)
/// Fournit la récupération des précipitations historiques et des prévisions en mm
class OpenMeteoService {
  OpenMeteoService._();
  static final OpenMeteoService instance = OpenMeteoService._();

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 20),
    headers: {
      'Accept': 'application/json',
    },
  ));

  /// Résout des coordonnées (lat/lon) à partir du nom d'une commune.
  /// Retourne null si non trouvé.
  Future<Coordinates?> resolveCoordinates(String? communeName) async {
    if (communeName == null || communeName.trim().isEmpty) return null;
    const url = 'https://geocoding-api.open-meteo.com/v1/search';
    final res = await _dio.get(url, queryParameters: {
      'name': communeName,
      'count': 1,
      'language': 'fr',
      'format': 'json',
    });

    final data = res.data is Map<String, dynamic>
        ? res.data as Map<String, dynamic>
        : json.decode(res.data as String) as Map<String, dynamic>;
    final results = (data['results'] as List?) ?? [];
    if (results.isEmpty) return null;
    final first = results.first as Map<String, dynamic>;
    return Coordinates(
      latitude: (first['latitude'] as num).toDouble(),
      longitude: (first['longitude'] as num).toDouble(),
      resolvedName: (first['name'] as String?) ?? communeName,
    );
  }

  /// Recherche des localités (communes) via l'API de géocodage Open-Meteo
  /// Retourne jusqu'à [count] suggestions
  Future<List<PlaceSuggestion>> searchPlaces(String query,
      {int count = 10}) async {
    if (query.trim().isEmpty) return const [];
    const url = 'https://geocoding-api.open-meteo.com/v1/search';
    final res = await _dio.get(url, queryParameters: {
      'name': query,
      'count': count,
      'language': 'fr',
      'format': 'json',
    });

    final data = res.data is Map<String, dynamic>
        ? res.data as Map<String, dynamic>
        : json.decode(res.data as String) as Map<String, dynamic>;
    final results = (data['results'] as List?) ?? [];
    return results.map((e) {
      final m = e as Map<String, dynamic>;
      return PlaceSuggestion(
        name: (m['name'] as String?) ?? '—',
        admin1: (m['admin1'] as String?) ?? '',
        country: (m['country'] as String?) ?? '',
        latitude: (m['latitude'] as num).toDouble(),
        longitude: (m['longitude'] as num).toDouble(),
      );
    }).toList();
  }

  /// Récupère les données météo pertinentes (précipitations historiques et prévisions)
  /// - `pastDays`: nombre de jours d'historique (par défaut 14)
  /// - `forecastDays`: nombre de jours de prévisions (par défaut 7)
  Future<OpenMeteoResult> fetchPrecipitation({
    required double latitude,
    required double longitude,
    int pastDays = 14,
    int forecastDays = 7,
  }) async {
    const url = 'https://api.open-meteo.com/v1/forecast';
    final res = await _dio.get(url, queryParameters: {
      'latitude': latitude,
      'longitude': longitude,
      'hourly': 'precipitation,temperature_2m',
      'daily': 'precipitation_sum,temperature_2m_max,temperature_2m_min,weathercode',
      'past_days': pastDays,
      'forecast_days': forecastDays,
      'timezone': 'auto',
    });

    final data = res.data is Map<String, dynamic>
        ? res.data as Map<String, dynamic>
        : json.decode(res.data as String) as Map<String, dynamic>;

    final hourly = data['hourly'] as Map<String, dynamic>?;
    final daily = data['daily'] as Map<String, dynamic>?;

    final hourlyTimes = (hourly?['time'] as List?)?.cast<String>() ?? const [];
    final hourlyPrecip = (hourly?['precipitation'] as List?)
            ?.map((e) => (e as num?)?.toDouble() ?? 0.0)
            .toList() ??
        const <double>[];
    final hourlyTemp = (hourly?['temperature_2m'] as List?)
            ?.map((e) => (e as num?)?.toDouble() ?? 0.0)
            .toList() ??
        const <double>[];

    final dailyTimes = (daily?['time'] as List?)?.cast<String>() ?? const [];
    final dailyPrecip = (daily?['precipitation_sum'] as List?)
            ?.map((e) => (e as num?)?.toDouble() ?? 0.0)
            .toList() ??
        const <double>[];
    final dailyTMax = (daily?['temperature_2m_max'] as List?)
            ?.map((e) => (e as num?)?.toDouble() ?? 0.0)
            .toList() ??
        const <double>[];
    final dailyTMin = (daily?['temperature_2m_min'] as List?)
            ?.map((e) => (e as num?)?.toDouble() ?? 0.0)
            .toList() ??
        const <double>[];

    // Construire les points horaires
    final hourlyPoints = <PrecipPoint>[];
    for (var i = 0; i < hourlyTimes.length && i < hourlyPrecip.length; i++) {
      hourlyPoints.add(
        PrecipPoint(
          time: DateTime.parse(hourlyTimes[i]),
          millimeters: hourlyPrecip[i],
        ),
      );
    }

    // Construire les points journaliers
    final dailyWeatherCodes = (daily?['weathercode'] as List?)
            ?.map((e) => (e as num?)?.toInt())
            .toList() ??
        const <int>[];

    final dailyPoints = <DailyWeatherPoint>[];

    for (var i = 0; i < dailyTimes.length && i < dailyPrecip.length; i++) {
      final code = i < dailyWeatherCodes.length ? dailyWeatherCodes[i] : null;
      dailyPoints.add(
        DailyWeatherPoint.fromRaw(
          date: DateTime.parse(dailyTimes[i]),
          precipMm: dailyPrecip[i],
          tMaxC: i < dailyTMax.length ? dailyTMax[i] : null,
          tMinC: i < dailyTMin.length ? dailyTMin[i] : null,
          weatherCode: code,
        ),
      );
    }

    // Température « actuelle » estimée par la dernière mesure horaire
    final currentTemp = hourlyTemp.isNotEmpty ? hourlyTemp.last : null;
    final currentWeatherCode = dailyPoints.isNotEmpty ? dailyPoints.first.weatherCode : null;

    return OpenMeteoResult(
      latitude: latitude,
      longitude: longitude,
      hourlyPrecipitation: hourlyPoints,
      dailyWeather: dailyPoints,
      currentTemperatureC: currentTemp,
      currentWeatherCode: currentWeatherCode,
    );
  }
}

class Coordinates {
  final double latitude;
  final double longitude;
  final String? resolvedName;
  Coordinates({
    required this.latitude,
    required this.longitude,
    this.resolvedName,
  });
}

class PrecipPoint {
  final DateTime time;
  final double millimeters;
  PrecipPoint({required this.time, required this.millimeters});
}

class OpenMeteoResult {
  final double latitude;
  final double longitude;
  final List<PrecipPoint> hourlyPrecipitation;
  final List<DailyWeatherPoint> dailyWeather;
  final double? currentTemperatureC;
  final int? currentWeatherCode;

  OpenMeteoResult({
    required this.latitude,
    required this.longitude,
    required this.hourlyPrecipitation,
    required this.dailyWeather,
    this.currentTemperatureC,
    this.currentWeatherCode,
  });

  /// Découpe les points journaliers en deux listes: historique (dates passées) et prévisions (dates futures)
  (List<DailyWeatherPoint> past, List<DailyWeatherPoint> forecast)
      splitByToday() {
    final nowDate = DateTime.now();
    final today = DateTime(nowDate.year, nowDate.month, nowDate.day);
    final past = <DailyWeatherPoint>[];
    final forecast = <DailyWeatherPoint>[];
    for (final p in dailyWeather) {
      final d = DateTime(p.date.year, p.date.month, p.date.day);
      if (d.isBefore(today)) {
        past.add(p);
      } else {
        forecast.add(p);
      }
    }
    return (past, forecast);
  }
}

class PlaceSuggestion {
  final String name;
  final String admin1;
  final String country;
  final double latitude;
  final double longitude;
  PlaceSuggestion({
    required this.name,
    required this.admin1,
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}
