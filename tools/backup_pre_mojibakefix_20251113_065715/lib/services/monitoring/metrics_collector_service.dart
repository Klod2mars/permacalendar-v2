ï»¿// ðŸ“ˆ Metrics Collector Service - Comprehensive Metrics Collection
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Observability Patterns

import 'dart:async';
import 'dart:developer' as developer;

/// Metric type
enum MetricCategory {
  performance,
  business,
  system,
  user,
  error,
}

/// Metric data point
class MetricDataPoint {
  final String metricName;
  final MetricCategory category;
  final dynamic value;
  final DateTime timestamp;
  final Map<String, String> tags;

  MetricDataPoint({
    required this.metricName,
    required this.category,
    required this.value,
    DateTime? timestamp,
    this.tags = const {},
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'metricName': metricName,
        'category': category.toString(),
        'value': value,
        'timestamp': timestamp.toIso8601String(),
        'tags': tags,
      };
}

/// Aggregated metric
class AggregatedMetric {
  final String metricName;
  final int count;
  final double sum;
  final double average;
  final double min;
  final double max;
  final DateTime periodStart;
  final DateTime periodEnd;

  AggregatedMetric({
    required this.metricName,
    required this.count,
    required this.sum,
    required this.average,
    required this.min,
    required this.max,
    required this.periodStart,
    required this.periodEnd,
  });

  Map<String, dynamic> toJson() => {
        'metricName': metricName,
        'count': count,
        'sum': sum,
        'average': average,
        'min': min,
        'max': max,
        'periodStart': periodStart.toIso8601String(),
        'periodEnd': periodEnd.toIso8601String(),
      };
}

/// Metrics report
class MetricsReport {
  final DateTime generatedAt;
  final Map<String, AggregatedMetric> metrics;
  final Map<MetricCategory, int> countByCategory;

  MetricsReport({
    required this.generatedAt,
    required this.metrics,
    required this.countByCategory,
  });

  Map<String, dynamic> toJson() => {
        'generatedAt': generatedAt.toIso8601String(),
        'totalMetrics': metrics.length,
        'metrics': metrics.map((k, v) => MapEntry(k, v.toJson())),
        'countByCategory': countByCategory.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
      };
}

/// Metrics collector service
class MetricsCollectorService {
  // Metrics storage
  final Map<String, List<MetricDataPoint>> _metricsBuffer = {};

  // Configuration
  final int _maxBufferSize;
  final Duration _flushInterval;
  final bool _enableAutoFlush;

  // Flush timer
  Timer? _flushTimer;
  StreamController<MetricsReport>? _metricsController;

  // Statistics
  int _totalMetricsCollected = 0;
  int _totalFlushes = 0;
  final Map<MetricCategory, int> _metricsByCategory = {};

  MetricsCollectorService({
    int? maxBufferSize,
    Duration? flushInterval,
    bool? enableAutoFlush,
  })  : _maxBufferSize = maxBufferSize ?? 10000,
        _flushInterval = flushInterval ?? const Duration(minutes: 1),
        _enableAutoFlush = enableAutoFlush ?? true {
    _initializeCategories();
  }

  /// Initialize category counters
  void _initializeCategories() {
    for (final category in MetricCategory.values) {
      _metricsByCategory[category] = 0;
    }
  }

  /// Initialize metrics collector
  void initialize() {
    if (_enableAutoFlush) {
      startAutoFlush();
    }

    _log('Metrics collector initialized');
  }

  /// Record a metric
  void recordMetric({
    required String metricName,
    required MetricCategory category,
    required dynamic value,
    Map<String, String>? tags,
  }) {
    final dataPoint = MetricDataPoint(
      metricName: metricName,
      category: category,
      value: value,
      tags: tags ?? {},
    );

    _metricsBuffer[metricName] = _metricsBuffer[metricName] ?? [];
    _metricsBuffer[metricName]!.add(dataPoint);

    _totalMetricsCollected++;
    _metricsByCategory[category] = (_metricsByCategory[category] ?? 0) + 1;

    // Check buffer size
    if (_metricsBuffer[metricName]!.length > _maxBufferSize) {
      _metricsBuffer[metricName]!.removeAt(0);
    }
  }

  /// Record counter increment
  void incrementCounter(String counterName,
      {int amount = 1, Map<String, String>? tags}) {
    recordMetric(
      metricName: counterName,
      category: MetricCategory.business,
      value: amount,
      tags: tags,
    );
  }

  /// Record gauge value
  void recordGauge(String gaugeName, double value,
      {Map<String, String>? tags}) {
    recordMetric(
      metricName: gaugeName,
      category: MetricCategory.system,
      value: value,
      tags: tags,
    );
  }

  /// Record histogram value
  void recordHistogram(String histogramName, double value,
      {Map<String, String>? tags}) {
    recordMetric(
      metricName: histogramName,
      category: MetricCategory.performance,
      value: value,
      tags: tags,
    );
  }

  /// Record timer/duration
  void recordTimer(String timerName, Duration duration,
      {Map<String, String>? tags}) {
    recordMetric(
      metricName: timerName,
      category: MetricCategory.performance,
      value: duration.inMilliseconds,
      tags: tags,
    );
  }

  /// Record error
  void recordError(String errorName,
      {String? message, Map<String, String>? tags}) {
    final errorTags = {...?tags, if (message != null) 'message': message};

    recordMetric(
      metricName: errorName,
      category: MetricCategory.error,
      value: 1,
      tags: errorTags,
    );
  }

  /// Get aggregated metrics for a specific metric name
  AggregatedMetric? getAggregatedMetric(
    String metricName, {
    Duration? period,
  }) {
    final dataPoints = _metricsBuffer[metricName];
    if (dataPoints == null || dataPoints.isEmpty) return null;

    // Filter by period if specified
    List<MetricDataPoint> filtered = dataPoints;
    if (period != null) {
      final cutoffTime = DateTime.now().subtract(period);
      filtered =
          dataPoints.where((p) => p.timestamp.isAfter(cutoffTime)).toList();
    }

    if (filtered.isEmpty) return null;

    // Calculate aggregations
    final values = filtered.map((p) => (p.value as num).toDouble()).toList();
    final sum = values.reduce((a, b) => a + b);
    final average = sum / values.length;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);

    return AggregatedMetric(
      metricName: metricName,
      count: filtered.length,
      sum: sum,
      average: average,
      min: min,
      max: max,
      periodStart: filtered.first.timestamp,
      periodEnd: filtered.last.timestamp,
    );
  }

  /// Generate metrics report
  MetricsReport generateReport({Duration? period}) {
    final aggregatedMetrics = <String, AggregatedMetric>{};

    for (final metricName in _metricsBuffer.keys) {
      final aggregated = getAggregatedMetric(metricName, period: period);
      if (aggregated != null) {
        aggregatedMetrics[metricName] = aggregated;
      }
    }

    return MetricsReport(
      generatedAt: DateTime.now(),
      metrics: aggregatedMetrics,
      countByCategory: Map.from(_metricsByCategory),
    );
  }

  /// Flush metrics (clear buffer)
  void flush() {
    final report = generateReport();

    _metricsController?.add(report);
    _totalFlushes++;

    _log('Metrics flushed: ${report.metrics.length} metrics');

    // Clear buffer
    _metricsBuffer.clear();
  }

  /// Start auto flush
  void startAutoFlush() {
    if (_flushTimer != null) return;

    _metricsController = StreamController<MetricsReport>.broadcast();

    _flushTimer = Timer.periodic(_flushInterval, (timer) {
      flush();
    });

    _log('Auto flush started (interval: ${_flushInterval.inSeconds}s)');
  }

  /// Stop auto flush
  void stopAutoFlush() {
    _flushTimer?.cancel();
    _flushTimer = null;

    _log('Auto flush stopped');
  }

  /// Get metrics stream
  Stream<MetricsReport>? get metricsStream => _metricsController?.stream;

  /// Get current buffer size
  int getBufferSize() {
    return _metricsBuffer.values.fold(0, (sum, list) => sum + list.length);
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalMetricsCollected': _totalMetricsCollected,
      'totalFlushes': _totalFlushes,
      'currentBufferSize': getBufferSize(),
      'metricsByCategory': _metricsByCategory.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      'uniqueMetrics': _metricsBuffer.length,
    };
  }

  /// Reset statistics
  void resetStatistics() {
    _totalMetricsCollected = 0;
    _totalFlushes = 0;
    _metricsByCategory.updateAll((key, value) => 0);

    _log('Metrics collector statistics reset');
  }

  /// Clear all metrics
  void clearAll() {
    _metricsBuffer.clear();
    _log('All metrics cleared');
  }

  /// Logging helper
  void _log(String message) {
    developer.log(
      message,
      name: 'MetricsCollectorService',
      level: 500,
    );
  }

  /// Dispose resources
  void dispose() {
    stopAutoFlush();
    _metricsController?.close();
    _metricsBuffer.clear();

    _log('Metrics collector service disposed');
  }
}


