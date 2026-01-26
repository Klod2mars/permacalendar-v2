
import '../../../../core/models/hourly_weather_point.dart';
import '../models/weather_config.dart';

/// Maps real weather data (WMO, Intensity, etc.) to Sacred Aesthetic Presets (V5).
/// Logic is STRICT: No algorithmic interpolation for visual parameters.
/// We pick the exact preset that was validated by the user.
class WeatherAestheticMapper {

  /// Returns the appropriate AestheticParams for the given weather point.
  /// If it's snow, returns snow params. If rain, rain params.
  /// The caller should decide where to apply it (snow vs rain slot),
  /// but usually we just want "The Active Precip Aesthetic".
  /// 
  /// Returns null if no precipitation (Clear/Cloudy).
  static AestheticParams? getAesthetic(HourlyWeatherPoint point) {
    // 1. WMO Code Logic
    final code = point.weatherCode;
    
    // -------------------------------------------------------------------------
    // RAIN
    // -------------------------------------------------------------------------
    
    // Light Rain (51, 61, 80)
    // + Moderate (53, 63, 81) -> DECISION: Map to Light Rain for safety (Validation V5)
    //   Unless intensity is very high? No, user said "Mapper sur les presets exacts".
    //   Moderate is better represented by Light Rain (Visuals 0.35) than Heavy (0.6).
    const lightRainCodes = [51, 61, 80, 53, 63, 81];
    if (lightRainCodes.contains(code)) {
      return WeatherPresets.lightRain;
    }
    
    // Heavy Rain (55, 65, 82)
    const heavyRainCodes = [55, 65, 82];
    if (heavyRainCodes.contains(code)) {
      return WeatherPresets.heavyRain;
    }
    
    // Storm (95, 96, 99)
    const stormCodes = [95, 96, 99];
    if (stormCodes.contains(code)) {
      return WeatherPresets.storm;
    }
    
    // -------------------------------------------------------------------------
    // SNOW
    // -------------------------------------------------------------------------
    
    // Light Snow (71, 85)
    const lightSnowCodes = [71, 85];
    if (lightSnowCodes.contains(code)) {
      return WeatherPresets.lightSnow;
    }
    
    // Dense Snow (73, 75, 86)
    const denseSnowCodes = [73, 75, 86];
    if (denseSnowCodes.contains(code)) {
      return WeatherPresets.denseSnow;
    }
    
    // -------------------------------------------------------------------------
    // FALLBACK / INTENSITY BASED
    // -------------------------------------------------------------------------
    // If code is missing or generic, check precip intensity?
    // But WMO is usually reliable.
    // If code is 0, 1, 2, 3 -> No precip.
    if (code <= 3) return null; // Clear/Cloudy
    
    // Handle Rain vs Snow based on basic logic if code is weird (e.g. 56, 57 Freezing Drizzle)
    // Freezing drizzle (56, 57) -> Light Rain visuals usually fit better than Snow, or maybe Light Rain.
    if ([56, 57, 66, 67].contains(code)) {
       // Freezing rain acts like rain visually until it hits ground.
       return WeatherPresets.lightRain; 
    }
    
    return null; // Default to clear
  }
}
