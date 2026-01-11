/// Modèle unifié DailyWeatherPoint
///
/// Fusion de:
/// - Version brute (open_meteo_service.dart): date, precipMm, tMaxC, tMinC, weatherCode, sun/moon/wind
/// - Version enrichie (weather_providers.dart): date, minTemp, maxTemp, icon, description, precipitation, condition, weatherCode
///
/// Supporte à la fois les données brutes d'OpenMeteo et les données enrichies pour l'UI
class DailyWeatherPoint {
  final DateTime date;

  // Champs bruts (depuis OpenMeteo)
  final double precipMm;
  final double? tMaxC;
  final double? tMinC;
  final int? weatherCode;

  // Nouveaux champs bruts (Open-Meteo V2)
  final String? sunrise;
  final String? sunset;
  final String? moonrise;
  final String? moonset;
  final double? moonPhase; // 0.0 = New Moon, 0.5 = Full Moon, 1.0 = New Moon
  final double? windSpeedMax; // km/h
  final double? windGustsMax; // km/h

  // Champs enrichis (pour l'UI)
  final double? minTemp;
  final double? maxTemp;
  final String? icon;
  final String? description;
  final double? precipitation; // Alias de precipMm pour compatibilité
  final String? condition; // WeatherConditionType en string

  /// Constructeur principal avec tous les champs
  DailyWeatherPoint({
    required this.date,
    this.precipMm = 0.0,
    this.tMaxC,
    this.tMinC,
    this.weatherCode,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.windSpeedMax,
    this.windGustsMax,
    this.minTemp,
    this.maxTemp,
    this.icon,
    this.description,
    double? precipitation,
    this.condition,
  }) : precipitation = precipitation ?? precipMm;

  /// Constructeur depuis données brutes OpenMeteo
  factory DailyWeatherPoint.fromRaw({
    required DateTime date,
    required double precipMm,
    double? tMaxC,
    double? tMinC,
    int? weatherCode,
    String? sunrise,
    String? sunset,
    String? moonrise,
    String? moonset,
    double? moonPhase,
    double? windSpeedMax,
    double? windGustsMax,
  }) {
    return DailyWeatherPoint(
      date: date,
      precipMm: precipMm,
      tMaxC: tMaxC,
      tMinC: tMinC,
      weatherCode: weatherCode,
      sunrise: sunrise,
      sunset: sunset,
      moonrise: moonrise,
      moonset: moonset,
      moonPhase: moonPhase,
      windSpeedMax: windSpeedMax,
      windGustsMax: windGustsMax,
    );
  }

  /// Constructeur depuis données enrichies UI
  factory DailyWeatherPoint.fromEnriched({
    required DateTime date,
    double? minTemp,
    double? maxTemp,
    required String icon,
    required String description,
    double? precipitation,
    String? condition,
    int? weatherCode,
    String? sunrise,
    String? sunset,
    double? moonPhase,
    double? windSpeedMax,
  }) {
    return DailyWeatherPoint(
      date: date,
      precipMm: precipitation ?? 0.0,
      tMaxC: maxTemp,
      tMinC: minTemp,
      minTemp: minTemp,
      maxTemp: maxTemp,
      icon: icon,
      description: description,
      precipitation: precipitation,
      condition: condition,
      weatherCode: weatherCode,
      sunrise: sunrise,
      sunset: sunset,
      moonPhase: moonPhase,
      windSpeedMax: windSpeedMax,
    );
  }

  DailyWeatherPoint enrich({
    required String icon,
    required String description,
    String? condition,
    double? moonPhase,
    String? moonrise,
    String? moonset,
  }) {
    // Crée une copie en préservant tous les champs bruts et en ajoutant les champs UI
    return DailyWeatherPoint(
      date: date,
      precipMm: precipMm,
      tMaxC: tMaxC,
      tMinC: tMinC,
      weatherCode: weatherCode,
      sunrise: sunrise,
      sunset: sunset,
      moonrise: moonrise ?? this.moonrise,
      moonset: moonset ?? this.moonset,
      moonPhase: moonPhase ?? this.moonPhase,
      windSpeedMax: windSpeedMax,
      windGustsMax: windGustsMax,
      minTemp: tMinC,
      maxTemp: tMaxC,
      icon: icon,
      description: description,
      precipitation: precipMm,
      condition: condition,
    );
  }

  @override
  String toString() {
    return 'DailyWeatherPoint(date: $date, precipMm: $precipMm, tMaxC: $tMaxC, tMinC: $tMinC, weatherCode: $weatherCode, userFields: [$minTemp, $maxTemp, $icon], sun: $sunrise/$sunset)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyWeatherPoint &&
        other.date == date &&
        other.precipMm == precipMm &&
        other.tMaxC == tMaxC &&
        other.tMinC == tMinC &&
        other.weatherCode == weatherCode;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        precipMm.hashCode ^
        (tMaxC?.hashCode ?? 0) ^
        (tMinC?.hashCode ?? 0) ^
        (weatherCode?.hashCode ?? 0);
  }
}
