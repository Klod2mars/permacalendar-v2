import 'dart:math' as math;
import '../../../../core/models/hourly_weather_point.dart';
import '../models/weather_config.dart';

class WeatherAestheticMapper {

  static const List<int> stormCodes = [95, 96, 99];

  /// Retourne l'AestheticParams correspondant au point horaire.
  /// - Override ORAGE : si code ∈ stormCodes -> WeatherPresets.storm
  /// - Sinon : utilise effectiveMm = precipitationMm * sqrt(precipProb/100)
  ///   puis applique les seuils :
  ///    <= 0.02 -> null
  ///    <= 0.5  -> drizzle
  ///    <= 3.0  -> lightRain
  ///    <= 8.0  -> moderateRain
  ///    <=20.0  -> heavyRain
  static AestheticParams? getAesthetic(HourlyWeatherPoint point) {
    final code = point.weatherCode;
    final precipMm = point.precipitationMm;
    final precipProb = (point.precipitationProbability).clamp(0, 100);

    // 1) ORAGE override : priorité absolue
    if (stormCodes.contains(code)) {
      return WeatherPresets.storm;
    }

    // 2) Seuil minimal global (cohérent avec GeneralConfig.precipThresholdMm = 0.02)
    const minShowMm = 0.02;
    if (precipMm <= minShowMm) return null;

    // 3) Atténuation par probabilité (sqrt pour obtenir une atténuation douce)
    final probFactor = math.sqrt((precipProb / 100.0).clamp(0.0, 1.0));
    final effectiveMm = precipMm * probFactor;

    // 4) Classification par paliers (discrets)
    if (effectiveMm <= 0.5) {
      return WeatherPresets.drizzle;
    } else if (effectiveMm <= 3.0) {
      return WeatherPresets.lightRain; // sanctuarisé
    } else if (effectiveMm <= 8.0) {
      return WeatherPresets.moderateRain;
    } else {
      // >= 8.0 (cap à 20.0 dans UI) -> heavyRain (sanctuarisé, pluie forte)
      return WeatherPresets.heavyRain;
    }
  }
}
