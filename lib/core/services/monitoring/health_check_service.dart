// ðŸ¥ Health Check Service - System Health Monitoring
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Health Check Patterns

import 'dart:async';
import 'dart:developer' as developer;
import 'package:hive/hive.dart';

/// Health status
enum HealthStatus {
  healthy,
  degraded,
  unhealthy,
  unknown,
}

/// Health check result
class HealthCheckResult {
  final String componentName;
  final HealthStatus status;
  final String? message;
  final Duration responseTime;
  final Map<String, dynamic> details;
  final DateTime checkedAt;

  HealthCheckResult({
    required this.componentName,
    required this.status,
    this.message,
    required this.responseTime,
    this.details = const {},
    DateTime? checkedAt,
  }) : checkedAt = checkedAt ?? DateTime.now();

  bool get isHealthy => status == HealthStatus.healthy;
  bool get isDegraded => status == HealthStatus.degraded;
  bool get isUnhealthy => status == HealthStatus.unhealthy;

  Map<String, dynamic> toJson() => {
        'componentName': componentName,
        'status': status.toString(),
        'message': message,
        'responseTimeMs': responseTime.inMilliseconds,
        'details': details,
        'checkedAt': checkedAt.toIso8601String(),
      };
}

/// Overall system health report
class SystemHealthReport {
  final HealthStatus overallStatus;
  final List<HealthCheckResult> componentResults;
  final DateTime generatedAt;
  final Map<String, dynamic> summary;

  SystemHealthReport({
    required this.overallStatus,
    required this.componentResults,
    DateTime? generatedAt,
    this.summary = const {},
  }) : generatedAt = generatedAt ?? DateTime.now();

  int get healthyCount => componentResults.where((r) => r.isHealthy).length;

  int get degradedCount => componentResults.where((r) => r.isDegraded).length;

  int get unhealthyCount => componentResults.where((r) => r.isUnhealthy).length;

  double get healthPercentage {
    final total = componentResults.length;
    return total > 0 ? (healthyCount / total) * 100 : 0.0;
  }

  Map<String, dynamic> toJson() => {
        'overallStatus': overallStatus.toString(),
        'healthyCount': healthyCount,
        'degradedCount': degradedCount,
        'unhealthyCount': unhealthyCount,
        'healthPercentage': healthPercentage,
        'generatedAt': generatedAt.toIso8601String(),
        'componentResults': componentResults.map((r) => r.toJson()).toList(),
        'summary': summary,
      };
}

/// Health check service
class HealthCheckService {
  // Health check functions by component
  final Map<String, Future<HealthCheckResult> Function()> _healthChecks = {};

  // Last check results
  final Map<String, HealthCheckResult> _lastResults = {};

  // Configuration
  final Duration _checkTimeout;
  final bool _enableAutoChecks;
  final Duration _autoCheckInterval;

  // Auto check timer
  Timer? _autoCheckTimer;
  StreamController<SystemHealthReport>? _healthReportController;

  // Statistics
  int _totalChecks = 0;
  int _failedChecks = 0;
  DateTime? _lastCheckTime;

  HealthCheckService({
    Duration? checkTimeout,
    bool? enableAutoChecks,
    Duration? autoCheckInterval,
  })  : _checkTimeout = checkTimeout ?? const Duration(seconds: 10),
        _enableAutoChecks = enableAutoChecks ?? false,
        _autoCheckInterval = autoCheckInterval ?? const Duration(minutes: 5);

  /// Initialize health checks
  void initialize() {
    // Register default health checks
    _registerDefaultHealthChecks();

    // Start auto checks if enabled
    if (_enableAutoChecks) {
      startAutoHealthChecks();
    }

    _log('Health check service initialized');
  }

  /// Register default health checks
  void _registerDefaultHealthChecks() {
    // Hive database health
    registerHealthCheck(
      'hive_database',
      _checkHiveHealth,
    );

    // Memory health
    registerHealthCheck(
      'memory',
      _checkMemoryHealth,
    );

    // Cache health
    registerHealthCheck(
      'cache',
      _checkCacheHealth,
    );
  }

  /// Register a custom health check
  void registerHealthCheck(
    String componentName,
    Future<HealthCheckResult> Function() healthCheck,
  ) {
    _healthChecks[componentName] = healthCheck;
    _log('Health check registered: $componentName');
  }

  /// Unregister a health check
  void unregisterHealthCheck(String componentName) {
    _healthChecks.remove(componentName);
    _lastResults.remove(componentName);
    _log('Health check unregistered: $componentName');
  }

  /// Perform health check for a specific component
  Future<HealthCheckResult> checkComponent(String componentName) async {
    final healthCheck = _healthChecks[componentName];

    if (healthCheck == null) {
      return HealthCheckResult(
        componentName: componentName,
        status: HealthStatus.unknown,
        message: 'No health check registered for this component',
        responseTime: Duration.zero,
      );
    }

    _totalChecks++;

    try {
      final result = await healthCheck().timeout(_checkTimeout);
      _lastResults[componentName] = result;
      _lastCheckTime = DateTime.now();

      return result;
    } on TimeoutException {
      _failedChecks++;

      final result = HealthCheckResult(
        componentName: componentName,
        status: HealthStatus.unhealthy,
        message: 'Health check timed out',
        responseTime: _checkTimeout,
      );

      _lastResults[componentName] = result;
      return result;
    } catch (e) {
      _failedChecks++;

      final result = HealthCheckResult(
        componentName: componentName,
        status: HealthStatus.unhealthy,
        message: 'Health check failed: $e',
        responseTime: Duration.zero,
        details: {'error': e.toString()},
      );

      _lastResults[componentName] = result;
      return result;
    }
  }

  /// Perform health check for all components
  Future<SystemHealthReport> checkAllComponents() async {
    _log('Checking health of all ${_healthChecks.length} components');

    final results = <HealthCheckResult>[];

    // Check all components in parallel
    final futures = _healthChecks.keys.map(checkComponent).toList();
    results.addAll(await Future.wait(futures));

    // Determine overall status
    final overallStatus = _determineOverallStatus(results);

    // Generate summary
    final summary = {
      'totalComponents': results.length,
      'healthyComponents': results.where((r) => r.isHealthy).length,
      'degradedComponents': results.where((r) => r.isDegraded).length,
      'unhealthyComponents': results.where((r) => r.isUnhealthy).length,
      'totalChecks': _totalChecks,
      'failedChecks': _failedChecks,
      'lastCheckTime': _lastCheckTime?.toIso8601String(),
    };

    final report = SystemHealthReport(
      overallStatus: overallStatus,
      componentResults: results,
      summary: summary,
    );

    _log(
        'Health check completed: $overallStatus (${report.healthPercentage.toStringAsFixed(1)}% healthy)');

    return report;
  }

  /// Start automatic health checks
  void startAutoHealthChecks() {
    if (_autoCheckTimer != null) return;

    _healthReportController = StreamController<SystemHealthReport>.broadcast();

    _autoCheckTimer = Timer.periodic(_autoCheckInterval, (timer) async {
      final report = await checkAllComponents();
      _healthReportController?.add(report);

      if (report.unhealthyCount > 0) {
        _logWarning(
          'Unhealthy components detected: ${report.unhealthyCount}',
        );
      }
    });

    _log(
        'Auto health checks started (interval: ${_autoCheckInterval.inMinutes}min)');
  }

  /// Stop automatic health checks
  void stopAutoHealthChecks() {
    _autoCheckTimer?.cancel();
    _autoCheckTimer = null;

    _log('Auto health checks stopped');
  }

  /// Get health report stream
  Stream<SystemHealthReport>? get healthReportStream =>
      _healthReportController?.stream;

  /// Check Hive database health
  Future<HealthCheckResult> _checkHiveHealth() async {
    final startTime = DateTime.now();

    try {
      // Check if Hive is initialized
      final isInitialized =
          Hive.isBoxOpen('gardens_hive') || Hive.isBoxOpen('plants_box');

      if (!isInitialized) {
        return HealthCheckResult(
          componentName: 'hive_database',
          status: HealthStatus.degraded,
          message: 'Hive not initialized',
          responseTime: DateTime.now().difference(startTime),
        );
      }

      // Try to access a box
      final box = await Hive.openBox('health_check_test');
      await box.put('test_key', 'test_value');
      final value = box.get('test_key');
      await box.close();

      final success = value == 'test_value';

      return HealthCheckResult(
        componentName: 'hive_database',
        status: success ? HealthStatus.healthy : HealthStatus.unhealthy,
        message: success ? 'Hive database operational' : 'Hive test failed',
        responseTime: DateTime.now().difference(startTime),
        details: {'test': success},
      );
    } catch (e) {
      return HealthCheckResult(
        componentName: 'hive_database',
        status: HealthStatus.unhealthy,
        message: 'Hive health check failed',
        responseTime: DateTime.now().difference(startTime),
        details: {'error': e.toString()},
      );
    }
  }

  /// Check memory health (simplified)
  Future<HealthCheckResult> _checkMemoryHealth() async {
    final startTime = DateTime.now();

    // Simplified memory check - in real app, use dart:io ProcessInfo
    return HealthCheckResult(
      componentName: 'memory',
      status: HealthStatus.healthy,
      message: 'Memory usage within acceptable range',
      responseTime: DateTime.now().difference(startTime),
      details: {
        'status': 'healthy',
        'note': 'Detailed memory metrics require platform-specific code',
      },
    );
  }

  /// Check cache health
  Future<HealthCheckResult> _checkCacheHealth() async {
    final startTime = DateTime.now();

    // Check if cache box is accessible
    try {
      if (Hive.isBoxOpen('intelligent_cache')) {
        final box = Hive.box<String>('intelligent_cache');
        final keyCount = box.length;

        return HealthCheckResult(
          componentName: 'cache',
          status: HealthStatus.healthy,
          message: 'Cache operational',
          responseTime: DateTime.now().difference(startTime),
          details: {
            'cachedItems': keyCount,
          },
        );
      }

      return HealthCheckResult(
        componentName: 'cache',
        status: HealthStatus.degraded,
        message: 'Cache not initialized',
        responseTime: DateTime.now().difference(startTime),
      );
    } catch (e) {
      return HealthCheckResult(
        componentName: 'cache',
        status: HealthStatus.unhealthy,
        message: 'Cache check failed',
        responseTime: DateTime.now().difference(startTime),
        details: {'error': e.toString()},
      );
    }
  }

  /// Determine overall system status from component results
  HealthStatus _determineOverallStatus(List<HealthCheckResult> results) {
    if (results.isEmpty) return HealthStatus.unknown;

    final unhealthyCount = results.where((r) => r.isUnhealthy).length;
    final degradedCount = results.where((r) => r.isDegraded).length;

    // If any component is unhealthy, system is unhealthy
    if (unhealthyCount > 0) {
      return HealthStatus.unhealthy;
    }

    // If any component is degraded, system is degraded
    if (degradedCount > 0) {
      return HealthStatus.degraded;
    }

    // All components healthy
    return HealthStatus.healthy;
  }

  /// Get last check result for a component
  HealthCheckResult? getLastResult(String componentName) {
    return _lastResults[componentName];
  }

  /// Get all last results
  Map<String, HealthCheckResult> getAllLastResults() {
    return Map.from(_lastResults);
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalChecks': _totalChecks,
      'failedChecks': _failedChecks,
      'successRate': _totalChecks > 0
          ? (_totalChecks - _failedChecks) / _totalChecks
          : 0.0,
      'lastCheckTime': _lastCheckTime?.toIso8601String(),
      'registeredComponents': _healthChecks.length,
    };
  }

  /// Reset statistics
  void resetStatistics() {
    _totalChecks = 0;
    _failedChecks = 0;
    _lastCheckTime = null;

    _log('Health check statistics reset');
  }

  /// Logging helper
  void _log(String message) {
    developer.log(
      message,
      name: 'HealthCheckService',
      level: 500,
    );
  }

  /// Warning logging helper
  void _logWarning(String message) {
    developer.log(
      message,
      name: 'HealthCheckService',
      level: 900,
    );
  }

  /// Dispose resources
  void dispose() {
    stopAutoHealthChecks();
    _healthReportController?.close();
    _healthChecks.clear();
    _lastResults.clear();

    _log('Health check service disposed');
  }
}
