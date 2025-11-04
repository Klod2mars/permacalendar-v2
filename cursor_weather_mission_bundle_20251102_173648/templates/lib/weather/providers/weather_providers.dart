import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../open_meteo_service.dart';
import '../local/hive_cache.dart';
import '../data/weather_repository.dart';
import '../data/null_weather_remote_datasource.dart';
import '../infrastructure/weather_repository_impl.dart';
import '../../config/feature_flags.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final openMeteoServiceProvider = Provider<OpenMeteoService>((ref) {
  final client = ref.read(httpClientProvider);
  return OpenMeteoService(httpClient: client);
});

final weatherCacheProvider = Provider<WeatherCache>((ref) => WeatherCache());

final nullRemoteDatasourceProvider = Provider<NullWeatherRemoteDatasource>(
    (ref) => NullWeatherRemoteDatasource());

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    cache: ref.read(weatherCacheProvider),
    openMeteo: ref.read(openMeteoServiceProvider),
    remote: ref.read(nullRemoteDatasourceProvider),
    featureEnabled: FeatureFlags.weatherV2Enabled,
  );
});
