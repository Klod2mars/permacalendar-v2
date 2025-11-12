import 'package:hive_flutter/hive_flutter.dart';
import '../datasources/soil_metrics_local_ds.dart';

/// Initialization service for soil metrics Hive adapters
///
/// This service handles the registration of Hive TypeAdapters
/// for soil metrics data models.
class SoilMetricsInitialization {
  static bool _isInitialized = false;

  /// Initialize soil metrics Hive adapters
  ///
  /// This method should be called during app startup to register
  /// the Hive TypeAdapters for soil metrics.
  static Future<void> initialize() async {
    if (_isInitialized) {
      print('[SoilMetricsInitialization] Already initialized, skipping...');
      return;
    }

    try {
      // Register the SoilMetricsDto adapter
      if (!Hive.isAdapterRegistered(28)) {
        // kTypeIdSoilMetrics
        Hive.registerAdapter(SoilMetricsDtoAdapter());
        print(
            '[SoilMetricsInitialization] SoilMetricsDtoAdapter registered (typeId: 28)');
      } else {
        print(
            '[SoilMetricsInitialization] SoilMetricsDtoAdapter already registered');
      }

      _isInitialized = true;
      print(
          '[SoilMetricsInitialization] Initialization completed successfully');
    } catch (e) {
      print('[SoilMetricsInitialization] Error during initialization: $e');
      rethrow;
    }
  }

  /// Check if soil metrics initialization is complete
  static bool get isInitialized => _isInitialized;

  /// Reset initialization state (for testing)
  static void reset() {
    _isInitialized = false;
  }
}

