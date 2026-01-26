import 'package:flutter_riverpod/flutter_riverpod.dart';

// Metric Model
class WeatherEngineMetrics {
  final int particleCount;
  final double spawnRate;
  final int collisionRate; // smoothed
  
  const WeatherEngineMetrics({this.particleCount = 0, this.spawnRate = 0, this.collisionRate = 0});
}

// Notifier to broadcast metrics to UI (Replaces StateProvider for Riverpod 3 compatibility)
class WeatherMetricsNotifier extends Notifier<WeatherEngineMetrics> {
  @override
  WeatherEngineMetrics build() {
    return const WeatherEngineMetrics();
  }

  void updateMetrics(WeatherEngineMetrics metrics) {
    state = metrics;
  }
}

final weatherMetricsProvider = NotifierProvider<WeatherMetricsNotifier, WeatherEngineMetrics>(WeatherMetricsNotifier.new);
