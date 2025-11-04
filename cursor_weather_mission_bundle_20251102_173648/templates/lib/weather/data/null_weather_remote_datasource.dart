abstract class WeatherRemoteDatasource {
  Future<Map<String, dynamic>?> fetch(double lat, double lon);
}

/// Null implementation: returns `null` (no network) to cut calls safely.
class NullWeatherRemoteDatasource implements WeatherRemoteDatasource {
  @override
  Future<Map<String, dynamic>?> fetch(double lat, double lon) async {
    return null; // Signals "no data" → repository should fallback to cache
  }
}
