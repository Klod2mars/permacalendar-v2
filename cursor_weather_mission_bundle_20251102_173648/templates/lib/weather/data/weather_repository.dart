abstract class WeatherRepository {
  /// Returns a map with weather data. May be cache when network fails.
  /// Throws on fatal errors and when no cache is available.
  Future<Map<String, dynamic>> getCurrent(double lat, double lon);
}
