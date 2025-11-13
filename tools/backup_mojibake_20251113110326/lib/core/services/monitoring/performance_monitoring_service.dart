// 📊 Performance Monitoring Service - Real-Time Performance Tracking
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Observability Patterns

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io' show Platform;

/// Performance metric type
enum MetricType {
  appStartup,
  screenLoad,
  dataFetch,
  dataWrite,
  cacheHit,
  cacheMiss,
  queryExecution,
  apiCall,
  computation,
  rendering,
}

/// Performance measurement
class PerformanceMeasurement {
  final String id;
  final MetricType type;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final Map<String, dynamic> metadata;

  PerformanceMeasurement({
    required this.id,
    required this.type,
    required this.name,
    required this.startTime,
    required this.endTime,
    Map<String, dynamic>? metadata,
  })  : duration = endTime.difference(startTime),
        metadata = metadata ?? {};

  bool get isSlowPerformance => duration > _getThreshold(type);

  static Duration _getThreshold(MetricType type) {
    switch (type) {
      case MetricType.appStartup:
        return const Duration(seconds: 2);
      case MetricType.screenLoad:
        return const Duration(milliseconds: 500);
      case MetricType.dataFetch:
        return const Duration(milliseconds: 200);
      case MetricType.dataWrite:
        return const Duration(milliseconds: 100);
      case MetricType.cacheHit:
        return const Duration(milliseconds: 10);
      case MetricType.cacheMiss:
        return const Duration(milliseconds: 100);
      case MetricType.queryExecution:
        return const Duration(milliseconds: 50);
      case MetricType.apiCall:
        return const Duration(seconds: 3);
      case MetricType.computation:
        return const Duration(milliseconds: 100);
      case MetricType.rendering:
        return const Duration(milliseconds: 16); // 60 FPS
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toString(),
        'name': name,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'durationMs': duration.inMilliseconds,
        'isSlowPerformance': isSlowPerformance,
        'metadata': metadata,
      };
}

/// Performance report
class PerformanceReport {
  final DateTime generatedAt;
  final Duration reportPeriod;
  final Map<MetricType, PerformanceStats> statsByType;
  final List<PerformanceMeasurement> slowOperations;
  final Map<String, dynamic> systemMetrics;

  PerformanceReport({
    required this.generatedAt,
    required this.reportPeriod,
    required this.statsByType,
    required this.slowOperations,
    required this.systemMetrics,
  });

  Map<String, dynamic> toJson() => {
        'generatedAt': generatedAt.toIso8601String(),
        'reportPeriodSeconds': reportPeriod.inSeconds,
        'statsByType': statsByType.map(
          (k, v) => MapEntry(k.toString(), v.toJson()),
        ),
        'slowOperationsCount': slowOperations.length,
        'systemMetrics': systemMetrics,
      };
}

/// Performance statistics by type
class PerformanceStats {
  final int count;
  final Duration totalDuration;
  final Duration averageDuration;
  final Duration minDuration;
  final Duration maxDuration;
  final int slowCount;
  final double slowPercentage;

  PerformanceStats({
    required this.count,
    required this.totalDuration,
    required this.averageDuration,
    required this.minDuration,
    required this.maxDuration,
    required this.slowCount,
    required this.slowPercentage,
  });

  Map<String, dynamic> toJson() => {
        'count': count,
        'totalDurationMs': totalDuration.inMilliseconds,
        'averageDurationMs': averageDuration.inMilliseconds,
        'minDurationMs': minDuration.inMilliseconds,
        'maxDurationMs': maxDuration.inMilliseconds,
        'slowCount': slowCount,
        'slowPercentage': slowPercentage,
      };
}

/// Performance monitoring service
class PerformanceMonitoringService {
  // Measurements storage
  final List<PerformanceMeasurement> _measurements = [];
  final Map<String, DateTime> _activeTimers = {};

  // Configuration
  final int _maxMeasurements;
  final bool _enableLogging;
  final Duration _reportInterval;

  // Report generation
  Timer? _reportTimer;
  StreamController<PerformanceReport>? _reportController;

  // System metrics
  DateTime? _appStartTime;
  int _totalScreenLoads = 0;
  int _totalDataOperations = 0;

  PerformanceMonitoringService({
    int? maxMeasurements,
    bool? enableLogging,
    Duration? reportInterval,
  })  : _maxMeasurements = maxMeasurements ?? 1000,
        _enableLogging = enableLogging ?? true,
        _reportInterval = reportInterval ?? const Duration(minutes: 5);

  /// Initialize monitoring
  void initialize() {
    _appStartTime = DateTime.now();

    // Start periodic reporting if enabled
    if (_enableLogging) {
      _startPeriodicReporting();
    }

    _log('Performance monitoring initialized');
  }

  /// Start a performance measurement
  String startMeasurement({
    required MetricType type,
    required String name,
    Map<String, dynamic>? metadata,
  }) {
    final id = '${type.name}_${DateTime.now().millisecondsSinceEpoch}';
    _activeTimers[id] = DateTime.now();

    _log('Started measurement: $name (type: $type)');

    return id;
  }

  /// End a performance measurement
  PerformanceMeasurement? endMeasurement(
    String id, {
    Map<String, dynamic>? additionalMetadata,
  }) {
    final startTime = _activeTimers.remove(id);
    if (startTime == null) {
      _logWarning('No active timer found for measurement: $id');
      return null;
    }

    final endTime = DateTime.now();

    // Extract type from id
    final typeName = id.split('_').first;
    final type = MetricType.values.firstWhere(
      (t) => t.name == typeName,
      orElse: () => MetricType.computation,
    );

    final measurement = PerformanceMeasurement(
      id: id,
      type: type,
      name: id.split('_')[0],
      startTime: startTime,
      endTime: endTime,
      metadata: additionalMetadata,
    );

    _measurements.add(measurement);

    // Trim measurements if exceeding max
    if (_measurements.length > _maxMeasurements) {
      _measurements.removeAt(0);
    }

    // Log slow operations
    if (measurement.isSlowPerformance) {
      _logWarning(
        'Slow operation detected: ${measurement.name} '
        '(${measurement.duration.inMilliseconds}ms)',
      );
    }

    _log(
      'Ended measurement: ${measurement.name} '
      '(${measurement.duration.inMilliseconds}ms)',
    );

    return measurement;
  }

  /// Measure a function execution
  Future<T> measureAsync<T>({
    required MetricType type,
    required String name,
    required Future<T> Function() operation,
    Map<String, dynamic>? metadata,
  }) async {
    final id = startMeasurement(type: type, name: name, metadata: metadata);

    try {
      final result = await operation();
      endMeasurement(id);
      return result;
    } catch (e) {
      endMeasurement(id, additionalMetadata: {'error': e.toString()});
      rethrow;
    }
  }

  /// Measure a synchronous function execution
  T measureSync<T>({
    required MetricType type,
    required String name,
    required T Function() operation,
    Map<String, dynamic>? metadata,
  }) {
    final id = startMeasurement(type: type, name: name, metadata: metadata);

    try {
      final result = operation();
      endMeasurement(id);
      return result;
    } catch (e) {
      endMeasurement(id, additionalMetadata: {'error': e.toString()});
      rethrow;
    }
  }

  /// Record app startup time
  void recordAppStartup() {
    if (_appStartTime != null) {
      final startupDuration = DateTime.now().difference(_appStartTime!);

      _measurements.add(PerformanceMeasurement(
        id: 'app_startup',
        type: MetricType.appStartup,
        name: 'Application Startup',
        startTime: _appStartTime!,
        endTime: DateTime.now(),
        metadata: {
          'platform': Platform.operatingSystem,
        },
      ));

      _log('App startup recorded: ${startupDuration.inMilliseconds}ms');
    }
  }

  /// Record screen load
  void recordScreenLoad(String screenName, Duration loadTime) {
    _totalScreenLoads++;

    _measurements.add(PerformanceMeasurement(
      id: 'screen_load_${DateTime.now().millisecondsSinceEpoch}',
      type: MetricType.screenLoad,
      name: screenName,
      startTime: DateTime.now().subtract(loadTime),
      endTime: DateTime.now(),
      metadata: {
        'screenName': screenName,
      },
    ));
  }

  /// Generate performance report
  PerformanceReport generateReport({Duration? period}) {
    final reportPeriod = period ?? const Duration(hours: 1);
    final cutoffTime = DateTime.now().subtract(reportPeriod);

    // Filter measurements within period
    final recentMeasurements =
        _measurements.where((m) => m.endTime.isAfter(cutoffTime)).toList();

    // Calculate stats by type
    final statsByType = <MetricType, PerformanceStats>{};

    for (final type in MetricType.values) {
      final measurements =
          recentMeasurements.where((m) => m.type == type).toList();

      if (measurements.isEmpty) continue;

      final durations = measurements.map((m) => m.duration).toList();
      final slowCount = measurements.where((m) => m.isSlowPerformance).length;

      statsByType[type] = PerformanceStats(
        count: measurements.length,
        totalDuration: Duration(
          microseconds:
              durations.map((d) => d.inMicroseconds).reduce((a, b) => a + b),
        ),
        averageDuration: Duration(
          microseconds:
              durations.map((d) => d.inMicroseconds).reduce((a, b) => a + b) ~/
                  durations.length,
        ),
        minDuration: durations.reduce(
          (a, b) => a < b ? a : b,
        ),
        maxDuration: durations.reduce(
          (a, b) => a > b ? a : b,
        ),
        slowCount: slowCount,
        slowPercentage: (slowCount / measurements.length) * 100,
      );
    }

    // Collect slow operations
    final slowOperations = recentMeasurements
        .where((m) => m.isSlowPerformance)
        .toList()
      ..sort((a, b) => b.duration.compareTo(a.duration));

    // Collect system metrics
    final systemMetrics = _collectSystemMetrics();

    return PerformanceReport(
      generatedAt: DateTime.now(),
      reportPeriod: reportPeriod,
      statsByType: statsByType,
      slowOperations: slowOperations.take(20).toList(),
      systemMetrics: systemMetrics,
    );
  }

  /// Get current performance metrics
  Map<String, dynamic> getCurrentMetrics() {
    final report = generateReport(period: const Duration(minutes: 5));

    return {
      'totalMeasurements': _measurements.length,
      'activeMeasurements': _activeTimers.length,
      'recentReport': report.toJson(),
    };
  }

  /// Start periodic reporting
  void _startPeriodicReporting() {
    _reportController = StreamController<PerformanceReport>.broadcast();

    _reportTimer = Timer.periodic(_reportInterval, (timer) {
      final report = generateReport(period: _reportInterval);
      _reportController?.add(report);

      _log(
        'Performance report generated: '
        '${report.statsByType.length} metric types tracked',
      );
    });
  }

  /// Get report stream
  Stream<PerformanceReport>? get reportStream => _reportController?.stream;

  /// Collect system metrics
  Map<String, dynamic> _collectSystemMetrics() {
    final uptime = _appStartTime != null
        ? DateTime.now().difference(_appStartTime!)
        : Duration.zero;

    return {
      'platform': Platform.operatingSystem,
      'uptimeSeconds': uptime.inSeconds,
      'totalScreenLoads': _totalScreenLoads,
      'totalDataOperations': _totalDataOperations,
      'measurementsCount': _measurements.length,
      'activeTimersCount': _activeTimers.length,
    };
  }

  /// Clear old measurements
  void clearOldMeasurements({Duration? olderThan}) {
    final cutoffTime =
        DateTime.now().subtract(olderThan ?? const Duration(hours: 24));

    _measurements.removeWhere((m) => m.endTime.isBefore(cutoffTime));

    _log('Cleared measurements older than ${olderThan?.inHours ?? 24} hours');
  }

  /// Reset all measurements
  void resetMeasurements() {
    _measurements.clear();
    _activeTimers.clear();
    _totalScreenLoads = 0;
    _totalDataOperations = 0;

    _log('All measurements reset');
  }

  /// Logging helper
  void _log(String message) {
    if (_enableLogging) {
      developer.log(
        message,
        name: 'PerformanceMonitoringService',
        level: 500,
      );
    }
  }

  /// Warning logging helper
  void _logWarning(String message) {
    if (_enableLogging) {
      developer.log(
        message,
        name: 'PerformanceMonitoringService',
        level: 900,
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _reportTimer?.cancel();
    _reportController?.close();
    _measurements.clear();
    _activeTimers.clear();

    _log('Performance monitoring service disposed');
  }
}


