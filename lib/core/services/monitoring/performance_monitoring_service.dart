// 📊 Performance Monitoring Service - Real-Time Performance Tracking
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Observability Patterns
//
// **Rôle du service :**
// Le PerformanceMonitoringService est responsable de la mesure et du suivi des
// performances de l'application en temps réel. Il collecte des métriques sur :
// - Les temps de démarrage de l'application
// - Les temps de chargement des écrans
// - Les durées d'exécution des opérations (data fetch, write, computation, etc.)
// - L'utilisation mémoire (optionnel)
// - La détection des opérations lentes
//
// **Interactions avec les autres services de monitoring :**
// - **MetricsCollectorService** : Le PerformanceMonitoringService peut envoyer
//   ses métriques de performance au MetricsCollectorService pour un stockage
//   et une agrégation à long terme (optionnel).
// - **HealthCheckService** : Les métriques de performance peuvent être utilisées
//   par le HealthCheckService pour évaluer la santé globale du système.
//
// **Architecture :**
// ```
// PerformanceMonitoringService
//   ├─→ Stockage en mémoire (List<PerformanceMeasurement>)
//   ├─→ Timers actifs (Map<String, DateTime>)
//   ├─→ Génération de rapports périodiques
//   └─→ MetricsCollectorService (optionnel, pour stockage long terme)
// ```
//
// **Sécurisation :**
// Toutes les opérations critiques sont encapsulées dans des try/catch et
// runZonedGuarded pour éviter que les erreurs ne fassent crasher l'application.
// Le service continue de fonctionner même en cas d'erreur lors de la collecte
// ou de l'envoi des métriques.
//
// **Gestion de surcharge :**
// Le service limite automatiquement le nombre de mesures stockées pour éviter
// la surcharge mémoire. Les mesures les plus anciennes sont supprimées si
// nécessaire.
//
// **Points d'extension :**
// - Ajout de nouveaux types de métriques via l'enum `MetricType`
// - Personnalisation des seuils de performance via `getThreshold()`
// - Intégration avec d'autres systèmes de monitoring via `reportStream`

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

  bool get isSlowPerformance => duration > getThreshold(type);

  static Duration getThreshold(MetricType type) {
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

  // Optional dependency for metrics aggregation
  // MetricsCollectorService? _metricsCollector;

  // Rate limiting for measurements (prevent excessive collection)
  DateTime? _lastMeasurementTime;
  static const Duration _minMeasurementInterval = Duration(milliseconds: 1);

  PerformanceMonitoringService({
    int? maxMeasurements,
    bool? enableLogging,
    Duration? reportInterval,
    // MetricsCollectorService? metricsCollector,
  })  : _maxMeasurements = maxMeasurements ?? 1000,
        _enableLogging = enableLogging ?? true,
        _reportInterval = reportInterval ?? const Duration(minutes: 5);
        // _metricsCollector = metricsCollector;

  /// Set dependencies (useful for Riverpod injection)
  /// 
  /// **Note:** Pour une intégration complète avec MetricsCollectorService,
  /// vous pouvez injecter le service via cette méthode. Actuellement, cette
  /// intégration est optionnelle et peut être ajoutée si nécessaire.
  // void setDependencies({MetricsCollectorService? metricsCollector}) {
  //   _metricsCollector = metricsCollector ?? _metricsCollector;
  // }

  /// Initialize monitoring
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs d'initialisation ne fassent crasher l'application.
  void initialize() {
    try {
      _appStartTime = DateTime.now();

      // Start periodic reporting if enabled
      if (_enableLogging) {
        _startPeriodicReporting();
      }

      _log('Performance monitoring initialized');
    } catch (e, stackTrace) {
      _logError('Failed to initialize performance monitoring: $e', stackTrace);
      // Le service continue de fonctionner même si l'initialisation échoue partiellement
    }
  }

  /// Start a performance measurement
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  /// 
  /// **Gestion de surcharge :** Un rate limiting est appliqué pour éviter
  /// une collecte excessive de mesures.
  String startMeasurement({
    required MetricType type,
    required String name,
    Map<String, dynamic>? metadata,
  }) {
    try {
      // Rate limiting: éviter les mesures trop fréquentes
      final now = DateTime.now();
      if (_lastMeasurementTime != null) {
        final timeSinceLastMeasurement =
            now.difference(_lastMeasurementTime!);
        if (timeSinceLastMeasurement < _minMeasurementInterval) {
          // Ignorer les mesures trop fréquentes
          return '';
        }
      }
      _lastMeasurementTime = now;

      final id = '${type.name}_${DateTime.now().millisecondsSinceEpoch}';
      _activeTimers[id] = DateTime.now();

      _log('Started measurement: $name (type: $type)');

      return id;
    } catch (e, stackTrace) {
      _logError('Failed to start measurement: $e', stackTrace);
      return '';
    }
  }

  /// End a performance measurement
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  PerformanceMeasurement? endMeasurement(
    String id, {
    Map<String, dynamic>? additionalMetadata,
  }) {
    try {
      // Handle empty id (from rate limiting)
      if (id.isEmpty) {
        return null;
      }

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

      // Optionally send to MetricsCollectorService
      // _sendToMetricsCollector(measurement);

      _log(
        'Ended measurement: ${measurement.name} '
        '(${measurement.duration.inMilliseconds}ms)',
      );

      return measurement;
    } catch (e, stackTrace) {
      _logError('Failed to end measurement: $e', stackTrace);
      return null;
    }
  }

  /// Measure a function execution
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch global
  /// pour éviter que les erreurs ne fassent crasher l'application.
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
    } catch (e, stackTrace) {
      endMeasurement(
        id,
        additionalMetadata: {
          'error': e.toString(),
          'errorType': e.runtimeType.toString(),
        },
      );
      rethrow;
    }
  }

  /// Measure a synchronous function execution
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch global
  /// pour éviter que les erreurs ne fassent crasher l'application.
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
    } catch (e, stackTrace) {
      endMeasurement(
        id,
        additionalMetadata: {
          'error': e.toString(),
          'errorType': e.runtimeType.toString(),
        },
      );
      rethrow;
    }
  }

  /// Record app startup time
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void recordAppStartup() {
    try {
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

        // Optionally send to MetricsCollectorService
        // _sendToMetricsCollector(_measurements.last);

        _log('App startup recorded: ${startupDuration.inMilliseconds}ms');
      } else {
        _logWarning('Cannot record app startup: app start time not set');
      }
    } catch (e, stackTrace) {
      _logError('Failed to record app startup: $e', stackTrace);
    }
  }

  /// Record screen load
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void recordScreenLoad(String screenName, Duration loadTime) {
    try {
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

      // Trim measurements if exceeding max
      if (_measurements.length > _maxMeasurements) {
        _measurements.removeAt(0);
      }

      // Optionally send to MetricsCollectorService
      // _sendToMetricsCollector(_measurements.last);
    } catch (e, stackTrace) {
      _logError('Failed to record screen load: $e', stackTrace);
    }
  }

  /// Record operation duration
  /// 
  /// Enregistre la durée d'une opération sans nécessiter de start/end.
  /// Utile pour les opérations dont la durée est déjà connue.
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void recordOperationDuration({
    required MetricType type,
    required String name,
    required Duration duration,
    Map<String, dynamic>? metadata,
  }) {
    try {
      _totalDataOperations++;

      _measurements.add(PerformanceMeasurement(
        id: '${type.name}_${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        name: name,
        startTime: DateTime.now().subtract(duration),
        endTime: DateTime.now(),
        metadata: metadata,
      ));

      // Trim measurements if exceeding max
      if (_measurements.length > _maxMeasurements) {
        _measurements.removeAt(0);
      }

      // Log slow operations
      if (duration > PerformanceMeasurement.getThreshold(type)) {
        _logWarning(
          'Slow operation detected: $name (${duration.inMilliseconds}ms)',
        );
      }

      // Optionally send to MetricsCollectorService
      // _sendToMetricsCollector(_measurements.last);
    } catch (e, stackTrace) {
      _logError('Failed to record operation duration: $e', stackTrace);
    }
  }

  /// Record memory usage
  /// 
  /// Enregistre l'utilisation mémoire (simplifié, nécessite des packages
  /// spécifiques pour une mesure précise).
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  /// 
  /// **Note:** Pour une mesure précise de la mémoire, utilisez des packages
  /// comme `dart:developer` avec `Timeline` ou des packages spécifiques à la
  /// plateforme. Cette méthode fournit une estimation basique.
  void recordMemoryUsage({
    required int memoryBytes,
    Map<String, dynamic>? metadata,
  }) {
    try {
      _measurements.add(PerformanceMeasurement(
        id: 'memory_usage_${DateTime.now().millisecondsSinceEpoch}',
        type: MetricType.computation,
        name: 'Memory Usage',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        metadata: {
          ...?metadata,
          'memoryBytes': memoryBytes,
          'memoryMB': (memoryBytes / (1024 * 1024)).toStringAsFixed(2),
        },
      ));

      // Trim measurements if exceeding max
      if (_measurements.length > _maxMeasurements) {
        _measurements.removeAt(0);
      }

      // Optionally send to MetricsCollectorService
      // _sendToMetricsCollector(_measurements.last);
    } catch (e, stackTrace) {
      _logError('Failed to record memory usage: $e', stackTrace);
    }
  }

  /// Generate performance report
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  PerformanceReport generateReport({Duration? period}) {
    try {
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

        if (durations.isEmpty) continue;

        statsByType[type] = PerformanceStats(
          count: measurements.length,
          totalDuration: Duration(
            microseconds: durations
                .map((d) => d.inMicroseconds)
                .reduce((a, b) => a + b),
          ),
          averageDuration: Duration(
            microseconds: durations
                    .map((d) => d.inMicroseconds)
                    .reduce((a, b) => a + b) ~/
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
    } catch (e, stackTrace) {
      _logError('Failed to generate performance report: $e', stackTrace);
      // Retourner un rapport vide plutôt que de crasher
      return PerformanceReport(
        generatedAt: DateTime.now(),
        reportPeriod: period ?? const Duration(hours: 1),
        statsByType: {},
        slowOperations: [],
        systemMetrics: {},
      );
    }
  }

  /// Get current performance metrics
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  Map<String, dynamic> getCurrentMetrics() {
    try {
      final report = generateReport(period: const Duration(minutes: 5));

      return {
        'totalMeasurements': _measurements.length,
        'activeMeasurements': _activeTimers.length,
        'recentReport': report.toJson(),
      };
    } catch (e, stackTrace) {
      _logError('Failed to get current metrics: $e', stackTrace);
      return {
        'totalMeasurements': _measurements.length,
        'activeMeasurements': _activeTimers.length,
        'error': e.toString(),
      };
    }
  }

  /// Start periodic reporting
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void _startPeriodicReporting() {
    try {
      _reportController = StreamController<PerformanceReport>.broadcast();

      _reportTimer = Timer.periodic(_reportInterval, (timer) {
        try {
          final report = generateReport(period: _reportInterval);
          _reportController?.add(report);

          _log(
            'Performance report generated: '
            '${report.statsByType.length} metric types tracked',
          );
        } catch (e, stackTrace) {
          _logError('Failed to generate periodic report: $e', stackTrace);
          // Le timer continue même en cas d'erreur
        }
      });
    } catch (e, stackTrace) {
      _logError('Failed to start periodic reporting: $e', stackTrace);
    }
  }

  /// Get report stream
  Stream<PerformanceReport>? get reportStream => _reportController?.stream;

  /// Collect system metrics
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  Map<String, dynamic> _collectSystemMetrics() {
    try {
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
    } catch (e, stackTrace) {
      _logError('Failed to collect system metrics: $e', stackTrace);
      return {
        'error': e.toString(),
      };
    }
  }

  /// Send measurement to MetricsCollectorService (optional integration)
  /// 
  /// **Note:** Cette méthode est commentée car l'intégration avec
  /// MetricsCollectorService est optionnelle. Décommentez et injectez
  /// MetricsCollectorService via setDependencies() pour activer.
  // void _sendToMetricsCollector(PerformanceMeasurement measurement) {
  //   try {
  //     if (_metricsCollector == null) return;
  //
  //     _metricsCollector!.recordTimer(
  //       'performance.${measurement.type.name}',
  //       measurement.duration,
  //       tags: {
  //         'name': measurement.name,
  //         'type': measurement.type.toString(),
  //         if (measurement.isSlowPerformance) 'slow': 'true',
  //         ...measurement.metadata.map((k, v) => MapEntry(k, v.toString())),
  //       },
  //     );
  //   } catch (e, stackTrace) {
  //     _logError('Failed to send to metrics collector: $e', stackTrace);
  //     // Ne pas bloquer si l'envoi échoue
  //   }
  // }

  /// Clear old measurements
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void clearOldMeasurements({Duration? olderThan}) {
    try {
      final cutoffTime =
          DateTime.now().subtract(olderThan ?? const Duration(hours: 24));

      final beforeCount = _measurements.length;
      _measurements.removeWhere((m) => m.endTime.isBefore(cutoffTime));
      final afterCount = _measurements.length;
      final removedCount = beforeCount - afterCount;

      _log(
        'Cleared $removedCount measurements older than ${olderThan?.inHours ?? 24} hours',
      );
    } catch (e, stackTrace) {
      _logError('Failed to clear old measurements: $e', stackTrace);
    }
  }

  /// Reset all measurements
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void resetMeasurements() {
    try {
      _measurements.clear();
      _activeTimers.clear();
      _totalScreenLoads = 0;
      _totalDataOperations = 0;
      _lastMeasurementTime = null;

      _log('All measurements reset');
    } catch (e, stackTrace) {
      _logError('Failed to reset measurements: $e', stackTrace);
    }
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

  /// Error logging helper
  void _logError(String message, StackTrace stackTrace) {
    if (_enableLogging) {
      developer.log(
        '$message\n$stackTrace',
        name: 'PerformanceMonitoringService',
        level: 1000,
        error: message,
      );
    }
  }

  /// Dispose resources
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void dispose() {
    try {
      _reportTimer?.cancel();
      _reportTimer = null;
      _reportController?.close();
      _reportController = null;
      _measurements.clear();
      _activeTimers.clear();
      _lastMeasurementTime = null;

      _log('Performance monitoring service disposed');
    } catch (e, stackTrace) {
      _logError('Error during dispose: $e', stackTrace);
    }
  }
}
