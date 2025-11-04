import 'package:http/http.dart' as http;
import '../open_meteo_service.dart';
import '../local/hive_cache.dart';
import 'weather_repository.dart';
import 'null_weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherCache cache;
  final OpenMeteoService openMeteo;
  final WeatherRemoteDatasource remote; // can be NullWeatherRemoteDatasource
  final bool featureEnabled;

  WeatherRepositoryImpl({
    required this.cache,
    required this.openMeteo,
    required this.remote,
    required this.featureEnabled,
  });

  @override
  Future<Map<String, dynamic>> getCurrent(double lat, double lon) async {
    if (!featureEnabled) {
      // Feature disabled → rely on cache only.
      final cached = await cache.load(lat, lon);
      if (cached != null) return cached;
      throw Exception('Weather feature disabled and no cache available');
    }

    // When feature enabled, try remote first (Open-Meteo), fallback to cache.
    try {
      // prefer OpenMeteo service when enabled
      final data = await openMeteo.fetchWeather(lat, lon);
      await cache.store(lat, lon, data);
      return data;
    } catch (_) {
      final cached = await cache.load(lat, lon);
      if (cached != null) return cached;
      rethrow;
    }
  }
}
