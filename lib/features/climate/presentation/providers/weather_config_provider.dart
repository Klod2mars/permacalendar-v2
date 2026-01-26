import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/weather_config.dart';

// ==========================================
// Weather Config Notifier
// ==========================================

class WeatherConfigNotifier extends Notifier<WeatherConfig> {
  @override
  WeatherConfig build() {
    return WeatherConfig.defaults();
  }

  void update(WeatherConfig Function(WeatherConfig prev) cb) {
    state = cb(state);
  }
}

/// Holds the current configuration for the weather engine.
final weatherConfigProvider =
    NotifierProvider<WeatherConfigNotifier, WeatherConfig>(
        WeatherConfigNotifier.new);


