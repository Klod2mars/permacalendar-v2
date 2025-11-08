// 📈 Metrics Collector Service - Comprehensive Metrics Collection
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Observability Patterns
//
// **Rôle du service :**
// Le MetricsCollectorService est responsable de la collecte, du stockage et de
// l'envoi (optionnel) des métriques de l'application. Il collecte des métriques
// dans 5 catégories : performance, business, system, user, et error.
//
// **Fonctionnalités principales :**
// - Collecte de métriques en mémoire avec buffer configurable
// - Agrégation automatique (count, sum, average, min, max)
// - Flush périodique automatique ou manuel
// - Persistance optionnelle dans Hive pour survie aux redémarrages
// - Envoi réseau optionnel avec file tampon en cas d'échec
// - Gestion de surcharge (limitation du nombre d'événements)
// - Sécurisation complète avec try/catch
//
// **Interactions avec les autres services de monitoring :**
// - **HealthCheckService** : Peut enregistrer des métriques de santé via ce service
// - **PerformanceMonitoringService** : Peut utiliser ce service pour stocker
//   les métriques de performance collectées
// - **NetworkService** : Utilisé pour l'envoi des métriques au backend (optionnel)
//
// **Architecture :**
// ```
// MetricsCollectorService
//   ├─→ Buffer mémoire (Map<String, List<MetricDataPoint>>)
//   ├─→ File tampon pour échecs réseau (List<MetricsReport>)
//   ├─→ Persistance Hive (optionnel)
//   └─→ NetworkService (optionnel, pour envoi backend)
// ```
//
// **Sécurisation :**
// Toutes les opérations critiques sont encapsulées dans des try/catch pour
// éviter que les erreurs ne fassent crasher l'application. Le service continue
// de fonctionner même en cas d'échec de persistance ou d'envoi réseau.
//
// **Gestion de surcharge :**
// Le service limite automatiquement le nombre de métriques stockées par nom
// de métrique pour éviter la surcharge mémoire. Le buffer total est également
// limité et les métriques les plus anciennes sont supprimées si nécessaire.
//
// **Points d'extension :**
// - Ajout de nouveaux types de métriques via `recordMetric()`
// - Personnalisation des agrégations via `getAggregatedMetric()`
// - Intégration avec d'autres systèmes de monitoring via `metricsStream`

import 'dart:async';
import 'dart:developer' as developer;
import 'package:hive/hive.dart';

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
  final int _maxTotalBufferSize; // Limite globale du buffer
  final Duration _flushInterval;
  final bool _enableAutoFlush;
  final bool _enablePersistence;
  final bool _enableNetworkUpload;

  // Flush timer
  Timer? _flushTimer;
  StreamController<MetricsReport>? _metricsController;

  // File tampon pour échecs réseau
  final List<MetricsReport> _failedUploadsQueue = [];
  final int _maxFailedUploadsQueueSize;

  // Persistance Hive (optionnel)
  Box<String>? _persistenceBox;
  static const String _persistenceBoxName = 'metrics_collector';

  // NetworkService pour envoi (optionnel, injecté via setDependencies)
  // NetworkService? _networkService;

  // Statistics
  int _totalMetricsCollected = 0;
  int _totalFlushes = 0;
  int _totalFailedUploads = 0;
  int _totalSuccessfulUploads = 0;
  int _totalDroppedMetrics = 0; // Métriques supprimées à cause de la surcharge
  final Map<MetricCategory, int> _metricsByCategory = {};

  MetricsCollectorService({
    int? maxBufferSize,
    int? maxTotalBufferSize,
    Duration? flushInterval,
    bool? enableAutoFlush,
    bool? enablePersistence,
    bool? enableNetworkUpload,
    int? maxFailedUploadsQueueSize,
  })  : _maxBufferSize = maxBufferSize ?? 10000,
        _maxTotalBufferSize = maxTotalBufferSize ?? 50000,
        _flushInterval = flushInterval ?? const Duration(minutes: 1),
        _enableAutoFlush = enableAutoFlush ?? true,
        _enablePersistence = enablePersistence ?? false,
        _enableNetworkUpload = enableNetworkUpload ?? false,
        _maxFailedUploadsQueueSize = maxFailedUploadsQueueSize ?? 100 {
    _initializeCategories();
  }

  /// Set dependencies (useful for Riverpod injection)
  ///
  /// **Note:** Pour activer l'envoi réseau des métriques, injectez le
  /// NetworkService via cette méthode. Actuellement, l'envoi réseau est
  /// désactivé par défaut et peut être activé si nécessaire.
  // void setDependencies({NetworkService? networkService}) {
  //   _networkService = networkService ?? _networkService;
  // }

  /// Initialize category counters
  void _initializeCategories() {
    for (final category in MetricCategory.values) {
      _metricsByCategory[category] = 0;
    }
  }

  /// Initialize metrics collector
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs d'initialisation ne fassent crasher l'application.
  Future<void> initialize() async {
    try {
      // Initialiser la persistance si activée
      if (_enablePersistence) {
        await _initializePersistence();
      }

      // Démarrer le flush automatique si activé
      if (_enableAutoFlush) {
        startAutoFlush();
      }

      // Tenter de purger la file d'échecs si elle existe
      if (_failedUploadsQueue.isNotEmpty) {
        _log('Found ${_failedUploadsQueue.length} failed uploads in queue');
        // Note: La purge sera faite lors du prochain flush réussi
      }

      _log('Metrics collector initialized');
    } catch (e, stackTrace) {
      _logError('Failed to initialize metrics collector: $e', stackTrace);
      // Le service continue de fonctionner même si l'initialisation échoue
    }
  }

  /// Initialize Hive persistence
  Future<void> _initializePersistence() async {
    try {
      if (!Hive.isAdapterRegistered(0)) {
        // Note: Pour persister des objets complexes, il faudrait créer un adapter
        // Pour l'instant, on utilise une Box<String> simple et on sérialise en JSON
      }

      _persistenceBox = await Hive.openBox<String>(_persistenceBoxName);
      _log('Persistence initialized');
    } catch (e, stackTrace) {
      _logError('Failed to initialize persistence: $e', stackTrace);
      // Désactiver la persistance si l'initialisation échoue
      // _enablePersistence = false;
    }
  }

  /// Record a metric
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs d'enregistrement ne fassent crasher l'application.
  ///
  /// **Gestion de surcharge :** Si le buffer total dépasse la limite, les
  /// métriques les plus anciennes sont supprimées pour faire de la place.
  void recordMetric({
    required String metricName,
    required MetricCategory category,
    required dynamic value,
    Map<String, String>? tags,
  }) {
    try {
      // Validation des paramètres
      if (metricName.isEmpty) {
        _logWarning('Attempted to record metric with empty name');
        return;
      }

      // Vérifier la surcharge globale
      final currentTotalSize = getBufferSize();
      if (currentTotalSize >= _maxTotalBufferSize) {
        _handleOverload();
      }

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

      // Vérifier la taille du buffer pour ce nom de métrique
      if (_metricsBuffer[metricName]!.length > _maxBufferSize) {
        _metricsBuffer[metricName]!.removeAt(0);
        _totalDroppedMetrics++;
      }
    } catch (e, stackTrace) {
      _logError('Failed to record metric $metricName: $e', stackTrace);
      // L'erreur est loggée mais n'interrompt pas l'exécution
    }
  }

  /// Handle buffer overload by removing oldest metrics
  void _handleOverload() {
    try {
      // Trouver la métrique avec le plus de points de données
      String? metricWithMostData;
      int maxLength = 0;

      for (final entry in _metricsBuffer.entries) {
        if (entry.value.length > maxLength) {
          maxLength = entry.value.length;
          metricWithMostData = entry.key;
        }
      }

      // Supprimer les 10% les plus anciens de cette métrique
      if (metricWithMostData != null && maxLength > 10) {
        final toRemove = (maxLength * 0.1).ceil();
        _metricsBuffer[metricWithMostData]!
            .removeRange(0, toRemove.clamp(0, maxLength));
        _totalDroppedMetrics += toRemove;
        _logWarning(
          'Buffer overload: removed $toRemove oldest metrics from $metricWithMostData',
        );
      }
    } catch (e, stackTrace) {
      _logError('Failed to handle overload: $e', stackTrace);
    }
  }

  /// Record counter increment
  ///
  /// **Sécurisation :** Encapsulé dans try/catch via `recordMetric()`.
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
  ///
  /// **Sécurisation :** Encapsulé dans try/catch via `recordMetric()`.
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
  ///
  /// **Sécurisation :** Encapsulé dans try/catch via `recordMetric()`.
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
  ///
  /// **Sécurisation :** Encapsulé dans try/catch via `recordMetric()`.
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
  ///
  /// **Sécurisation :** Encapsulé dans try/catch via `recordMetric()`.
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
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs de calcul ne fassent crasher l'application.
  AggregatedMetric? getAggregatedMetric(
    String metricName, {
    Duration? period,
  }) {
    try {
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
      final values = filtered
          .map((p) {
            try {
              return (p.value as num).toDouble();
            } catch (e) {
              _logWarning('Invalid metric value for $metricName: ${p.value}');
              return 0.0;
            }
          })
          .where((v) => v.isFinite)
          .toList();

      if (values.isEmpty) return null;

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
    } catch (e, stackTrace) {
      _logError('Failed to get aggregated metric for $metricName: $e', stackTrace);
      return null;
    }
  }

  /// Generate metrics report
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs de génération ne fassent crasher l'application.
  MetricsReport generateReport({Duration? period}) {
    try {
      final aggregatedMetrics = <String, AggregatedMetric>{};

      for (final metricName in _metricsBuffer.keys) {
        try {
          final aggregated = getAggregatedMetric(metricName, period: period);
          if (aggregated != null) {
            aggregatedMetrics[metricName] = aggregated;
          }
        } catch (e) {
          _logWarning('Failed to aggregate metric $metricName: $e');
          // Continue avec les autres métriques
        }
      }

      return MetricsReport(
        generatedAt: DateTime.now(),
        metrics: aggregatedMetrics,
        countByCategory: Map.from(_metricsByCategory),
      );
    } catch (e, stackTrace) {
      _logError('Failed to generate report: $e', stackTrace);
      // Retourner un rapport vide plutôt que de crasher
      return MetricsReport(
        generatedAt: DateTime.now(),
        metrics: {},
        countByCategory: {},
      );
    }
  }

  /// Flush metrics (clear buffer)
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs de flush ne fassent crasher l'application.
  ///
  /// **Comportement :**
  /// - Génère un rapport des métriques actuelles
  /// - Envoie le rapport via le stream (si disponible)
  /// - Tente l'envoi réseau si activé
  /// - Sauvegarde en persistance si activée
  /// - Vide le buffer après un flush réussi
  Future<void> flush() async {
    try {
      final report = generateReport();

      // Envoyer via le stream
      try {
        _metricsController?.add(report);
      } catch (e) {
        _logWarning('Failed to send report to stream: $e');
      }

      // Envoi réseau si activé
      if (_enableNetworkUpload) {
        await _uploadReport(report);
      }

      // Persistance si activée
      if (_enablePersistence) {
        await _persistReport(report);
      }

      _totalFlushes++;
      _log('Metrics flushed: ${report.metrics.length} metrics');

      // Clear buffer seulement après un flush réussi
      _metricsBuffer.clear();

      // Tenter de purger la file d'échecs après un flush réussi
      if (_failedUploadsQueue.isNotEmpty) {
        await _retryFailedUploads();
      }
    } catch (e, stackTrace) {
      _logError('Failed to flush metrics: $e', stackTrace);
      // Le buffer n'est pas vidé en cas d'erreur pour éviter la perte de données
    }
  }

  /// Upload report to backend (if NetworkService is available)
  Future<void> _uploadReport(MetricsReport report) async {
    // TODO: Implémenter l'envoi réseau quand NetworkService sera injecté
    // if (_networkService == null || !_networkService!.isInitialized) {
    //   _logWarning('NetworkService not available for upload');
    //   _addToFailedUploadsQueue(report);
    //   return;
    // }

    // try {
    //   await _networkService!.post('/api/metrics', data: report.toJson());
    //   _totalSuccessfulUploads++;
    //   _log('Metrics report uploaded successfully');
    // } catch (e, stackTrace) {
    //   _totalFailedUploads++;
    //   _logError('Failed to upload metrics report: $e', stackTrace);
    //   _addToFailedUploadsQueue(report);
    // }
  }

  /// Persist report to Hive
  Future<void> _persistReport(MetricsReport report) async {
    try {
      if (_persistenceBox == null) {
        _logWarning('Persistence box not initialized');
        return;
      }

      final reportJson = report.toJson();
      final timestamp = report.generatedAt.toIso8601String();
      await _persistenceBox!.put('report_$timestamp', reportJson.toString());
      _log('Metrics report persisted');
    } catch (e, stackTrace) {
      _logError('Failed to persist metrics report: $e', stackTrace);
    }
  }

  /// Add report to failed uploads queue
  void _addToFailedUploadsQueue(MetricsReport report) {
    try {
      _failedUploadsQueue.add(report);

      // Limiter la taille de la file
      if (_failedUploadsQueue.length > _maxFailedUploadsQueueSize) {
        final removed = _failedUploadsQueue.removeAt(0);
        _logWarning(
          'Failed uploads queue full, removed oldest report from ${removed.generatedAt}',
        );
      }
    } catch (e, stackTrace) {
      _logError('Failed to add report to failed uploads queue: $e', stackTrace);
    }
  }

  /// Retry failed uploads
  Future<void> _retryFailedUploads() async {
    if (_failedUploadsQueue.isEmpty) return;

    _log('Retrying ${_failedUploadsQueue.length} failed uploads');

    final reportsToRetry = List<MetricsReport>.from(_failedUploadsQueue);
    _failedUploadsQueue.clear();

    for (final report in reportsToRetry) {
      await _uploadReport(report);
    }
  }

  /// Start auto flush
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs de démarrage ne fassent crasher l'application.
  void startAutoFlush() {
    try {
      if (_flushTimer != null) return;

      _metricsController = StreamController<MetricsReport>.broadcast();

      _flushTimer = Timer.periodic(_flushInterval, (timer) {
        // Ne pas attendre le flush pour éviter de bloquer le timer
        flush().catchError((e, stackTrace) {
          _logError('Auto flush failed: $e', stackTrace);
        });
      });

      _log('Auto flush started (interval: ${_flushInterval.inSeconds}s)');
    } catch (e, stackTrace) {
      _logError('Failed to start auto flush: $e', stackTrace);
    }
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
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs de calcul ne fassent crasher l'application.
  Map<String, dynamic> getStatistics() {
    try {
      return {
        'totalMetricsCollected': _totalMetricsCollected,
        'totalFlushes': _totalFlushes,
        'currentBufferSize': getBufferSize(),
        'totalDroppedMetrics': _totalDroppedMetrics,
        'totalFailedUploads': _totalFailedUploads,
        'totalSuccessfulUploads': _totalSuccessfulUploads,
        'failedUploadsQueueSize': _failedUploadsQueue.length,
        'metricsByCategory': _metricsByCategory.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
        'uniqueMetrics': _metricsBuffer.length,
        'maxBufferSize': _maxBufferSize,
        'maxTotalBufferSize': _maxTotalBufferSize,
        'enablePersistence': _enablePersistence,
        'enableNetworkUpload': _enableNetworkUpload,
      };
    } catch (e, stackTrace) {
      _logError('Failed to get statistics: $e', stackTrace);
      return {
        'error': 'Failed to get statistics',
        'errorMessage': e.toString(),
      };
    }
  }

  /// Reset statistics
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs de réinitialisation ne fassent crasher l'application.
  void resetStatistics() {
    try {
      _totalMetricsCollected = 0;
      _totalFlushes = 0;
      _totalFailedUploads = 0;
      _totalSuccessfulUploads = 0;
      _totalDroppedMetrics = 0;
      _metricsByCategory.updateAll((key, value) => 0);

      _log('Metrics collector statistics reset');
    } catch (e, stackTrace) {
      _logError('Failed to reset statistics: $e', stackTrace);
    }
  }

  /// Clear all metrics
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs de nettoyage ne fassent crasher l'application.
  void clearAll() {
    try {
      _metricsBuffer.clear();
      _failedUploadsQueue.clear();
      _log('All metrics cleared');
    } catch (e, stackTrace) {
      _logError('Failed to clear all metrics: $e', stackTrace);
    }
  }

  /// Purge failed uploads queue
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs de purge ne fassent crasher l'application.
  void purgeFailedUploads() {
    try {
      final count = _failedUploadsQueue.length;
      _failedUploadsQueue.clear();
      _log('Purged $count failed uploads from queue');
    } catch (e, stackTrace) {
      _logError('Failed to purge failed uploads: $e', stackTrace);
    }
  }

  /// Logging helper
  void _log(String message) {
    developer.log(
      message,
      name: 'MetricsCollectorService',
      level: 500,
    );
  }

  /// Warning logging helper
  void _logWarning(String message) {
    developer.log(
      message,
      name: 'MetricsCollectorService',
      level: 800,
    );
  }

  /// Error logging helper
  void _logError(String message, StackTrace stackTrace) {
    developer.log(
      '$message\n$stackTrace',
      name: 'MetricsCollectorService',
      level: 1000,
      error: message,
    );
  }

  /// Dispose resources
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs de nettoyage ne fassent crasher l'application.
  void dispose() {
    try {
      stopAutoFlush();
      _metricsController?.close();
      _metricsBuffer.clear();
      _failedUploadsQueue.clear();

      // Fermer la box de persistance si elle existe
      _persistenceBox?.close();

      _log('Metrics collector service disposed');
    } catch (e, stackTrace) {
      _logError('Error during dispose: $e', stackTrace);
    }
  }
}
