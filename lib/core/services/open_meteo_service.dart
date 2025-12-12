import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:permacalendar/core/models/daily_weather_point.dart';
import 'package:permacalendar/core/models/hourly_weather_point.dart';
// Export HourlyWeatherPoint and the alias for old code relying on PrecipPoint
export 'package:permacalendar/core/models/hourly_weather_point.dart';

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
      // hourly étendu : précip / temp / vent / direction / pression / visibilité
      'hourly': 'precipitation,precipitation_probability,temperature_2m,apparent_temperature,windspeed_10m,winddirection_10m,windgusts_10m,weathercode',
      // daily étendu : sunrise/sunset + moon + wind max
      'daily': 'precipitation_sum,temperature_2m_max,temperature_2m_min,weathercode,sunrise,sunset,moonrise,moonset,moon_phase,windspeed_10m_max,windgusts_10m_max',
      'past_days': pastDays,
      'forecast_days': forecastDays,
      'timezone': 'auto',
    });

    final data = res.data is Map<String, dynamic>
        ? res.data as Map<String, dynamic>
        : json.decode(res.data as String) as Map<String, dynamic>;

    final hourly = data['hourly'] as Map<String, dynamic>?;
    final daily = data['daily'] as Map<String, dynamic>?;

    // --- Parsing Hourly ---
    final hourlyTimes = (hourly?['time'] as List?)?.cast<String>() ?? const [];
    final hourlyPrecip = _toDoubleList(hourly?['precipitation']);
    final hourlyPrecipProb = _toIntList(hourly?['precipitation_probability']);
    final hourlyTemp = _toDoubleList(hourly?['temperature_2m']);
    final hourlyApparentTemp = _toDoubleList(hourly?['apparent_temperature']);
    final hourlyWindSpeed = _toDoubleList(hourly?['windspeed_10m']);
    final hourlyWindDir = _toIntList(hourly?['winddirection_10m']);
    final hourlyWindGusts = _toDoubleList(hourly?['windgusts_10m']);
    final hourlyCodes = _toIntList(hourly?['weathercode']);

    // Construire les points horaires
    final hourlyPoints = <HourlyWeatherPoint>[];
    final limit = hourlyTimes.length;
    
    for (var i = 0; i < limit; i++) {
        // Robustesse sur les longueurs de listes
        double getVal(List<double> list) => i < list.length ? list[i] : 0.0;
        int getInt(List<int> list) => i < list.length ? list[i] : 0;

      hourlyPoints.add(
        HourlyWeatherPoint(
          time: DateTime.parse(hourlyTimes[i]),
          precipitationMm: getVal(hourlyPrecip),
          precipitationProbability: getInt(hourlyPrecipProb),
          temperatureC: getVal(hourlyTemp),
          apparentTemperatureC: getVal(hourlyApparentTemp),
          windSpeedkmh: getVal(hourlyWindSpeed),
          windDirection: getInt(hourlyWindDir),
          windGustsKmh: getVal(hourlyWindGusts),
          weatherCode: getInt(hourlyCodes),
        ),
      );
    }

    // --- Parsing Daily ---
    final dailyTimes = (daily?['time'] as List?)?.cast<String>() ?? const [];
    final dailyPrecip = _toDoubleList(daily?['precipitation_sum']);
    final dailyTMax = _toDoubleList(daily?['temperature_2m_max']);
    final dailyTMin = _toDoubleList(daily?['temperature_2m_min']);
    final dailyCodes = _toIntList(daily?['weathercode']);
    
    final dailySunrise = (daily?['sunrise'] as List?)?.cast<String?>() ?? const [];
    final dailySunset = (daily?['sunset'] as List?)?.cast<String?>() ?? const [];
    final dailyMoonrise = (daily?['moonrise'] as List?)?.cast<String?>() ?? const [];
    final dailyMoonset = (daily?['moonset'] as List?)?.cast<String?>() ?? const [];
    final dailyMoonPhase = _toDoubleList(daily?['moon_phase']);
    final dailyWindSpeedMax = _toDoubleList(daily?['windspeed_10m_max']);
    final dailyWindGustsMax = _toDoubleList(daily?['windgusts_10m_max']);

    final dailyPoints = <DailyWeatherPoint>[];

    for (var i = 0; i < dailyTimes.length; i++) {
       // Robustesse
        double getVal(List<double> list) => i < list.length ? list[i] : 0.0;
        int? getIntNull(List<int> list) => i < list.length ? list[i] : null;
        String? getStr(List<String?> list) => i < list.length ? list[i] : null;
        double? getValNull(List<double> list) => i < list.length ? list[i] : null;

      dailyPoints.add(
        DailyWeatherPoint.fromRaw(
          date: DateTime.parse(dailyTimes[i]),
          precipMm: getVal(dailyPrecip),
          tMaxC: getValNull(dailyTMax),
          tMinC: getValNull(dailyTMin),
          weatherCode: getIntNull(dailyCodes),
          sunrise: getStr(dailySunrise),
          sunset: getStr(dailySunset),
          moonrise: getStr(dailyMoonrise),
          moonset: getStr(dailyMoonset),
          moonPhase: getValNull(dailyMoonPhase),
          windSpeedMax: getValNull(dailyWindSpeedMax),
          windGustsMax: getValNull(dailyWindGustsMax),
        ),
      );
    }

    // Température « actuelle » estimée par la dernière mesure horaire du PASSÉ ou du PRÉSENT proche
    // L'API renvoie ~24h/jour. On cherche l'élément le plus proche de maintenant.
    final now = DateTime.now();
    HourlyWeatherPoint? currentPoint;
    // Trouver le point horaire le plus proche
    if (hourlyPoints.isNotEmpty) {
      // Trier par écart de temps avec now
      // (Supposons que la liste est triée par temps, on peut chercher le premier dont le temps > now et prendre le précédent)
      /* Simplification : on prend le dernier point qui est <= now + 1h */
       try {
         // On cherche le point dont l'heure est la plus proche de l'heure courante (arrondie à l'heure)
         // api retourne ex: 12:00, 13:00. Si il est 12:40, on veut 13:00 ou 12:00 ? 
         // OpenMeteo weather_code à 12:00 est la prévision pour 12:00.
         // On va prendre l'heure courante arrondie.
         final match = hourlyPoints.firstWhere((p) => p.time.isAfter(now), orElse: () => hourlyPoints.last);
         final index = hourlyPoints.indexOf(match);
         if (index > 0) {
            // Check lequel est plus proche
            final prev = hourlyPoints[index - 1];
            if (now.difference(prev.time).abs() < match.time.difference(now).abs()) {
               currentPoint = prev;
            } else {
               currentPoint = match;
            }
         } else {
            currentPoint = match;
         }
       } catch (e) {
          currentPoint = hourlyPoints.isNotEmpty ? hourlyPoints.last : null;
       }
    }

    final currentTemp = currentPoint?.temperatureC;
    final currentWeatherCode = currentPoint?.weatherCode ?? (dailyPoints.isNotEmpty ? dailyPoints.first.weatherCode : null);

    return OpenMeteoResult(
      latitude: latitude,
      longitude: longitude,
      hourlyWeather: hourlyPoints, // Renommé de hourlyPrecipitation pour clarté, mais on garde getter pour compat
      dailyWeather: dailyPoints,
      currentTemperatureC: currentTemp,
      currentWeatherCode: currentWeatherCode,
      currentWindSpeed: currentPoint?.windSpeedkmh,
      currentWindDirection: currentPoint?.windDirection,
    );
  }

  // Helpers parsing
  List<double> _toDoubleList(dynamic list) {
    if (list is List) {
      return list.map((e) => (e as num?)?.toDouble() ?? 0.0).toList();
    }
    return [];
  }
   List<int> _toIntList(dynamic list) {
    if (list is List) {
      return list.map((e) => (e as num?)?.toInt() ?? 0).toList();
    }
    return [];
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

class OpenMeteoResult {
  final double latitude;
  final double longitude;
  final List<HourlyWeatherPoint> hourlyWeather;
  final List<DailyWeatherPoint> dailyWeather;
  final double? currentTemperatureC;
  final int? currentWeatherCode;
  
  // Extra fields for ease of access
  final double? currentWindSpeed;
  final int? currentWindDirection;

  // Compatibilty Getter
  List<HourlyWeatherPoint> get hourlyPrecipitation => hourlyWeather;

  OpenMeteoResult({
    required this.latitude,
    required this.longitude,
    required this.hourlyWeather,
    required this.dailyWeather,
    this.currentTemperatureC,
    this.currentWeatherCode,
    this.currentWindSpeed,
    this.currentWindDirection,
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
