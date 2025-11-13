ï»¿import '../../../../core/services/open_meteo_service.dart'
    show Coordinates, OpenMeteoResult;
import '../../../../core/models/daily_weather_point.dart';

/// Modèle unifié WeatherViewData
///
/// Fusion de:
/// - Version domaine (weather_view_data.dart): locationLabel, coordinates, result
/// - Version UI (weather_providers.dart): temperature, minTemp, maxTemp, icon, description, timestamp, condition, weatherCode
///
/// Privilégie la version domaine tout en supportant les champs UI pour compatibilité
class WeatherViewData {
  // Champs domaine (priorité)
  final String locationLabel;
  final Coordinates coordinates;
  final OpenMeteoResult result;

  // Champs UI (pour compatibilité)
  final double? temperature;
  final double? minTemp;
  final double? maxTemp;
  final String? icon;
  final String? description;
  final DateTime timestamp;
  final String? condition; // WeatherConditionType en string
  final int? weatherCode;

  // Getters pour accès simplifié
  double? get currentTemperatureC => temperature ?? result.currentTemperatureC;
  List<DailyWeatherPoint> get dailyWeather => result.dailyWeather;
  String? get resolvedName => coordinates.resolvedName;

  /// Constructeur principal avec tous les champs
  WeatherViewData({
    required this.locationLabel,
    required this.coordinates,
    required this.result,
    this.temperature,
    this.minTemp,
    this.maxTemp,
    this.icon,
    this.description,
    DateTime? timestamp,
    this.condition,
    this.weatherCode,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Constructeur depuis données domaine uniquement
  factory WeatherViewData.fromDomain({
    required String locationLabel,
    required Coordinates coordinates,
    required OpenMeteoResult result,
  }) {
    return WeatherViewData(
      locationLabel: locationLabel,
      coordinates: coordinates,
      result: result,
    );
  }

  /// Constructeur depuis données UI uniquement (compatibilité)
  factory WeatherViewData.fromUI({
    required double temperature,
    double? minTemp,
    double? maxTemp,
    required String icon,
    required String description,
    required DateTime timestamp,
    String? condition,
    int? weatherCode,
  }) {
    // Créer des coordonnées par défaut et un résultat minimal
    final coords = Coordinates(
      latitude: 0.0,
      longitude: 0.0,
    );

    final minimalResult = OpenMeteoResult(
      latitude: 0.0,
      longitude: 0.0,
      hourlyPrecipitation: [],
      dailyWeather: [],
      currentTemperatureC: temperature,
      currentWeatherCode: weatherCode,
    );

    return WeatherViewData(
      locationLabel: 'Unknown',
      coordinates: coords,
      result: minimalResult,
      temperature: temperature,
      minTemp: minTemp,
      maxTemp: maxTemp,
      icon: icon,
      description: description,
      timestamp: timestamp,
      condition: condition,
      weatherCode: weatherCode,
    );
  }

  /// Enrichit les données domaine avec des informations UI
  WeatherViewData enrich({
    required String icon,
    required String description,
    String? condition,
  }) {
    return WeatherViewData(
      locationLabel: locationLabel,
      coordinates: coordinates,
      result: result,
      temperature: currentTemperatureC,
      minTemp: minTemp,
      maxTemp: maxTemp,
      icon: icon,
      description: description,
      timestamp: timestamp,
      condition: condition,
      weatherCode: weatherCode ?? result.currentWeatherCode,
    );
  }

  @override
  String toString() {
    return 'WeatherViewData(locationLabel: $locationLabel, coordinates: $coordinates, result: $result, temperature: $temperature, minTemp: $minTemp, maxTemp: $maxTemp, icon: $icon, description: $description, timestamp: $timestamp, condition: $condition, weatherCode: $weatherCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherViewData &&
        other.locationLabel == locationLabel &&
        other.coordinates.latitude == coordinates.latitude &&
        other.coordinates.longitude == coordinates.longitude;
  }

  @override
  int get hashCode {
    return locationLabel.hashCode ^
        coordinates.latitude.hashCode ^
        coordinates.longitude.hashCode;
  }
}


