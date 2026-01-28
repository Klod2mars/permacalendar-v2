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
  /// Retourne l'AestheticParams correspondant au point horaire.
  /// - Override ORAGE : si code ∈ stormCodes -> WeatherPresets.storm
  /// - Sinon : utilise precipitationMm pour déterminer le preset de base.
  /// - Puis applique la logique de downgrade si precipProb < seuil.
  static AestheticParams? getAesthetic(
    HourlyWeatherPoint point, {
    double precipProbThreshold = 30.0,
    bool downgradeOnLowProb = true,
  }) {
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

    // 3) Classification initiale sur le volume RÉEL (sans atténuation proba)
    AestheticParams basePreset;
    if (precipMm <= 0.5) {
      basePreset = WeatherPresets.veryLightRain;
    } else if (precipMm <= 3.0) {
      basePreset = WeatherPresets.drizzle;
    } else if (precipMm <= 8.0) {
      basePreset = WeatherPresets.lightRain;
    } else if (precipMm <= 20.0) {
      basePreset = WeatherPresets.moderateRain;
    } else {
      basePreset = WeatherPresets.heavyRain;
    }

    // 4) Gating / downgrade par probabilité
    if (precipProb < precipProbThreshold) {
      if (!downgradeOnLowProb) {
        // Trop incertain -> on ne montre rien
        return null;
      } else {
        // Downgrade d'un pas : retourne le preset immédiatement inférieur.
        AestheticParams stepDown(AestheticParams p) {
          if (identical(p, WeatherPresets.emptyPrecip)) return WeatherPresets.emptyPrecip;
          if (identical(p, WeatherPresets.veryLightRain)) return WeatherPresets.emptyPrecip;
          if (identical(p, WeatherPresets.drizzle)) return WeatherPresets.veryLightRain;
          if (identical(p, WeatherPresets.lightRain)) return WeatherPresets.drizzle;
          if (identical(p, WeatherPresets.moderateRain)) return WeatherPresets.lightRain;
          if (identical(p, WeatherPresets.heavyRain)) return WeatherPresets.moderateRain;
          return p;
        }
        return stepDown(basePreset);
      }
    }

    return basePreset;
  }
}
