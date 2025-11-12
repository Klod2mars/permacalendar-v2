import '../../domain/entities/weather_condition.dart';
import '../../../../core/services/open_meteo_service.dart';

/// Interface pour la source de données météorologiques
///
/// Définit les contrats pour l'accès aux données météorologiques
/// via l'intégration avec OpenMeteoService
abstract class WeatherDataSource {
  /// Récupère les conditions météorologiques actuelles
  ///
  /// [gardenId] - Identifiant du jardin
  /// [latitude] - Latitude de la localisation
  /// [longitude] - Longitude de la localisation
  ///
  /// Retourne les conditions météorologiques actuelles
  Future<WeatherCondition?> getCurrentWeather({
    required String gardenId,
    required double latitude,
    required double longitude,
  });

  /// Récupère l'historique météorologique
  ///
  /// [gardenId] - Identifiant du jardin
  /// [latitude] - Latitude de la localisation
  /// [longitude] - Longitude de la localisation
  /// [pastDays] - Nombre de jours d'historique à récupérer
  ///
  /// Retourne la liste des conditions météorologiques historiques
  Future<List<WeatherCondition>> getWeatherHistory({
    required String gardenId,
    required double latitude,
    required double longitude,
    int pastDays = 14,
  });

  /// Récupère les prévisions météorologiques
  ///
  /// [gardenId] - Identifiant du jardin
  /// [latitude] - Latitude de la localisation
  /// [longitude] - Longitude de la localisation
  /// [forecastDays] - Nombre de jours de prévisions à récupérer
  ///
  /// Retourne la liste des prévisions météorologiques
  Future<List<WeatherCondition>> getWeatherForecast({
    required String gardenId,
    required double latitude,
    required double longitude,
    int forecastDays = 7,
  });

  /// Récupère les données météorologiques complètes (historique + prévisions)
  ///
  /// [gardenId] - Identifiant du jardin
  /// [latitude] - Latitude de la localisation
  /// [longitude] - Longitude de la localisation
  /// [pastDays] - Nombre de jours d'historique
  /// [forecastDays] - Nombre de jours de prévisions
  ///
  /// Retourne un objet contenant l'historique et les prévisions
  Future<WeatherDataResult> getCompleteWeatherData({
    required String gardenId,
    required double latitude,
    required double longitude,
    int pastDays = 14,
    int forecastDays = 7,
  });
}

/// Résultat des données météorologiques complètes
class WeatherDataResult {
  final List<WeatherCondition> history;
  final List<WeatherCondition> forecast;
  final WeatherCondition? current;
  final DateTime fetchTimestamp;

  const WeatherDataResult({
    required this.history,
    required this.forecast,
    this.current,
    required this.fetchTimestamp,
  });
}

/// Implémentation concrète de la source de données météorologiques avec OpenMeteoService
class WeatherDataSourceImpl implements WeatherDataSource {
  final OpenMeteoService _openMeteoService;

  WeatherDataSourceImpl(this._openMeteoService);

  @override
  Future<WeatherCondition?> getCurrentWeather({
    required String gardenId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Récupérer les données météorologiques avec 1 jour d'historique pour avoir les données actuelles
      final result = await _openMeteoService.fetchPrecipitation(
        latitude: latitude,
        longitude: longitude,
        pastDays: 1,
        forecastDays: 1,
      );

      if (result.dailyWeather.isEmpty) return null;

      // Utiliser les données journalières les plus récentes
      final latestDaily = result.dailyWeather.last;

      // Créer la condition météorologique
      return WeatherCondition(
        id: '${gardenId}_current_${DateTime.now().millisecondsSinceEpoch}',
        type: WeatherType.temperature,
        value: result.currentTemperatureC ?? 20.0,
        unit: '°C',
        description: _getWeatherDescription(
            latestDaily.precipMm, result.currentTemperatureC ?? 20.0),
        measuredAt: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      // En cas d'erreur, retourner null
      return null;
    }
  }

  @override
  Future<List<WeatherCondition>> getWeatherHistory({
    required String gardenId,
    required double latitude,
    required double longitude,
    int pastDays = 14,
  }) async {
    try {
      final result = await _openMeteoService.fetchPrecipitation(
        latitude: latitude,
        longitude: longitude,
        pastDays: pastDays,
        forecastDays: 0,
      );

      final (pastData, _) = result.splitByToday();

      return pastData
          .map((daily) => _convertDailyToWeatherCondition(
                gardenId: gardenId,
                daily: daily,
                latitude: latitude,
                longitude: longitude,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<WeatherCondition>> getWeatherForecast({
    required String gardenId,
    required double latitude,
    required double longitude,
    int forecastDays = 7,
  }) async {
    try {
      final result = await _openMeteoService.fetchPrecipitation(
        latitude: latitude,
        longitude: longitude,
        pastDays: 0,
        forecastDays: forecastDays,
      );

      final (_, forecastData) = result.splitByToday();

      return forecastData
          .map((daily) => _convertDailyToWeatherCondition(
                gardenId: gardenId,
                daily: daily,
                latitude: latitude,
                longitude: longitude,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<WeatherDataResult> getCompleteWeatherData({
    required String gardenId,
    required double latitude,
    required double longitude,
    int pastDays = 14,
    int forecastDays = 7,
  }) async {
    try {
      final result = await _openMeteoService.fetchPrecipitation(
        latitude: latitude,
        longitude: longitude,
        pastDays: pastDays,
        forecastDays: forecastDays,
      );

      final (pastData, forecastData) = result.splitByToday();

      final history = pastData
          .map((daily) => _convertDailyToWeatherCondition(
                gardenId: gardenId,
                daily: daily,
                latitude: latitude,
                longitude: longitude,
              ))
          .toList();

      final forecast = forecastData
          .map((daily) => _convertDailyToWeatherCondition(
                gardenId: gardenId,
                daily: daily,
                latitude: latitude,
                longitude: longitude,
              ))
          .toList();

      // Créer la condition actuelle à partir des données les plus récentes
      WeatherCondition? current;
      if (pastData.isNotEmpty) {
        current = _convertDailyToWeatherCondition(
          gardenId: gardenId,
          daily: pastData.last,
          latitude: latitude,
          longitude: longitude,
        );
      }

      return WeatherDataResult(
        history: history,
        forecast: forecast,
        current: current,
        fetchTimestamp: DateTime.now(),
      );
    } catch (e) {
      return WeatherDataResult(
        history: [],
        forecast: [],
        current: null,
        fetchTimestamp: DateTime.now(),
      );
    }
  }

  /// Convertit les données journalières d'OpenMeteo en WeatherCondition
  WeatherCondition _convertDailyToWeatherCondition({
    required String gardenId,
    required DailyWeatherPoint daily,
    required double latitude,
    required double longitude,
  }) {
    final temperature = daily.tMaxC != null && daily.tMinC != null
        ? (daily.tMaxC! + daily.tMinC!) / 2
        : 20.0;

    return WeatherCondition(
      id: '${gardenId}_${daily.date.millisecondsSinceEpoch}',
      type: WeatherType.temperature,
      value: temperature,
      unit: '°C',
      description: _getWeatherDescription(daily.precipMm, temperature),
      measuredAt: daily.date,
      latitude: latitude,
      longitude: longitude,
      createdAt: DateTime.now(),
    );
  }

  /// Génère une description météo basée sur les précipitations et la température
  String _getWeatherDescription(double precipitation, double temperature) {
    if (precipitation > 10.0) return 'Pluie forte';
    if (precipitation > 5.0) return 'Pluie modérée';
    if (precipitation > 2.0) return 'Pluie légère';
    if (precipitation > 0.5) return 'Bruine';
    if (precipitation > 0.0) return 'Quelques gouttes';

    // Temps sec
    if (temperature < 0.0) return 'Très froid';
    if (temperature < 5.0) return 'Froid';
    if (temperature < 15.0) return 'Fraîcheur';
    if (temperature < 25.0) return 'Temps doux';
    if (temperature < 30.0) return 'Chaleur agréable';
    return 'Très chaud';
  }
}

/// Exception pour les erreurs de la source de données météorologiques
class WeatherDataSourceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const WeatherDataSourceException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    final codeStr = code != null ? ' [$code]' : '';
    return 'WeatherDataSourceException$codeStr: $message';
  }
}

