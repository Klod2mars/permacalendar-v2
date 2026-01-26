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

// ==========================================
// Calibration State Notifier
// ==========================================

/// State for the Calibration Mode itself
class WeatherCalibrationState {
  final bool isCalibrationMode;
  final int? forcedWeatherCode;
  final double? forcedPrecipMm;
  final double? forcedWindSpeed;
  final double? forcedCloudCover;

  const WeatherCalibrationState({
    this.isCalibrationMode = false,
    this.forcedWeatherCode,
    this.forcedPrecipMm,
    this.forcedWindSpeed,
    this.forcedCloudCover,
  });

  WeatherCalibrationState copyWith({
    bool? isCalibrationMode,
    int? forcedWeatherCode,
    double? forcedPrecipMm,
    double? forcedWindSpeed,
    double? forcedCloudCover,
  }) {
    return WeatherCalibrationState(
      isCalibrationMode: isCalibrationMode ?? this.isCalibrationMode,
      forcedWeatherCode: forcedWeatherCode ?? this.forcedWeatherCode,
      forcedPrecipMm: forcedPrecipMm ?? this.forcedPrecipMm,
      forcedWindSpeed: forcedWindSpeed ?? this.forcedWindSpeed,
      forcedCloudCover: forcedCloudCover ?? this.forcedCloudCover,
    );
  }
}

class WeatherCalibrationNotifier extends Notifier<WeatherCalibrationState> {
  @override
  WeatherCalibrationState build() {
    return const WeatherCalibrationState();
  }

  void update(WeatherCalibrationState Function(WeatherCalibrationState prev) cb) {
    state = cb(state);
  }
}

/// Provider for the calibration state
final weatherCalibrationStateProvider =
    NotifierProvider<WeatherCalibrationNotifier, WeatherCalibrationState>(
        WeatherCalibrationNotifier.new);
