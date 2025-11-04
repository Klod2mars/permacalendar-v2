/// Modèle unifié DailyWeatherPoint
///
/// Fusion de:
/// - Version brute (open_meteo_service.dart): date, precipMm, tMaxC, tMinC, weatherCode
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
  }) {
    return DailyWeatherPoint(
      date: date,
      precipMm: precipMm,
      tMaxC: tMaxC,
      tMinC: tMinC,
      weatherCode: weatherCode,
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
    );
  }

  /// Convertit les données brutes en enrichies
  DailyWeatherPoint enrich({
    required String icon,
    required String description,
    String? condition,
  }) {
    return DailyWeatherPoint(
      date: date,
      precipMm: precipMm,
      tMaxC: tMaxC,
      tMinC: tMinC,
      weatherCode: weatherCode,
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
    return 'DailyWeatherPoint(date: $date, precipMm: $precipMm, tMaxC: $tMaxC, tMinC: $tMinC, weatherCode: $weatherCode, minTemp: $minTemp, maxTemp: $maxTemp, icon: $icon, description: $description, precipitation: $precipitation, condition: $condition)';
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
