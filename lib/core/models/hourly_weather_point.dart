/// Point de météo horaire (précip, vent, temp)
class HourlyWeatherPoint {
  final DateTime time;
  final double precipitationMm;
  final int precipitationProbability;
  final double temperatureC;
  final double apparentTemperatureC;
  final double windSpeedkmh; // windspeed_10m
  final int windDirection;   // winddirection_10m (degrés)
  final double windGustsKmh; // windgusts_10m
  final int weatherCode;
  final double? pressureMsl; // pressure_msl (hPa)

  HourlyWeatherPoint({
    required this.time,
    required this.precipitationMm,
    required this.precipitationProbability,
    required this.temperatureC,
    required this.apparentTemperatureC,
    required this.windSpeedkmh,
    required this.windDirection,
    required this.windGustsKmh,
    required this.weatherCode,
    this.pressureMsl,
  });

  @override
  String toString() {
    return 'HourlyWeatherPoint(time: $time, precip: ${precipitationMm}mm ($precipitationProbability%), temp: ${temperatureC}C, wind: ${windSpeedkmh}km/h)';
  }
}

// Alias pour compatibilité ascendante si nécessaire (ou deprecated)
@Deprecated('Use HourlyWeatherPoint instead')
typedef PrecipPoint = HourlyWeatherPoint;
