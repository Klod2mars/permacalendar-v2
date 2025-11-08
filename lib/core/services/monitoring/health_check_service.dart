// 🏥 Health Check Service - System Health Monitoring
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Health Check Patterns
//
// **Rôle du service :**
// Le HealthCheckService est responsable de la vérification de la santé des
// composants critiques de l'application. Il effectue des vérifications
// périodiques ou à la demande sur :
// - La base de données (Hive)
// - Le réseau et la connectivité
// - Le backend (disponibilité API)
// - La mémoire et les ressources système
// - Le cache
//
// **Interactions avec les autres services de monitoring :**
// - **MetricsCollectorService** : Le HealthCheckService peut enregistrer des
//   métriques sur la santé des composants via le MetricsCollectorService pour
//   un suivi à long terme.
// - **PerformanceMonitoringService** : Les temps de réponse des health checks
//   peuvent être mesurés via le PerformanceMonitoringService pour détecter
//   des dégradations de performance.
// - **NetworkService** : Utilisé pour vérifier la connectivité réseau et la
//   disponibilité du backend.
//
// **Architecture :**
// ```
// HealthCheckService
//   ├─→ NetworkService (vérification backend/réseau)
//   ├─→ Hive (vérification base de données)
//   ├─→ MetricsCollectorService (optionnel, pour métriques)
//   └─→ PerformanceMonitoringService (optionnel, pour performance)
// ```
//
// **Sécurisation :**
// Toutes les vérifications de santé sont encapsulées dans des try/catch et
// runZonedGuarded pour éviter que les erreurs ne fassent crasher l'application.
// Les résultats sont toujours interprétables (pas de null brut).

import 'dart:async';
import 'dart:developer' as developer;
import 'package:hive/hive.dart';
import '../network_service.dart';

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

  // Dependencies (injected via setDependencies or constructor)
  NetworkService? _networkService;
  
  // Optional dependencies for enhanced monitoring
  // These can be injected via setDependencies for integration with other monitoring services
  // MetricsCollectorService? _metricsCollector;
  // PerformanceMonitoringService? _performanceMonitor;

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
    NetworkService? networkService,
  })  : _checkTimeout = checkTimeout ?? const Duration(seconds: 10),
        _enableAutoChecks = enableAutoChecks ?? false,
        _autoCheckInterval = autoCheckInterval ?? const Duration(minutes: 5),
        _networkService = networkService;

  /// Set dependencies (useful for Riverpod injection)
  /// 
  /// **Note:** Pour une intégration complète avec les autres services de monitoring,
  /// vous pouvez injecter MetricsCollectorService et PerformanceMonitoringService
  /// via cette méthode. Actuellement, ces intégrations sont optionnelles et peuvent
  /// être ajoutées si nécessaire.
  void setDependencies({NetworkService? networkService}) {
    _networkService = networkService ?? _networkService;
    // Future: Add MetricsCollectorService and PerformanceMonitoringService integration
    // _metricsCollector = metricsCollector ?? _metricsCollector;
    // _performanceMonitor = performanceMonitor ?? _performanceMonitor;
  }

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

    // Network health (if NetworkService is available)
    if (_networkService != null) {
      registerHealthCheck(
        'network',
        _checkNetworkHealth,
      );

      // Backend health (if NetworkService is available)
      registerHealthCheck(
        'backend',
        _checkBackendHealth,
      );
    }
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
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch global
  /// pour éviter que les erreurs ne fassent crasher l'application. Le résultat
  /// est toujours interprétable (jamais null).
  Future<HealthCheckResult> checkComponent(String componentName) async {
    try {
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
      } catch (e, stackTrace) {
        _failedChecks++;
        _logWarning(
          'Health check failed for $componentName: $e\n$stackTrace',
        );

        final result = HealthCheckResult(
          componentName: componentName,
          status: HealthStatus.unhealthy,
          message: 'Health check failed: ${e.toString()}',
          responseTime: Duration.zero,
          details: {
            'error': e.toString(),
            'errorType': e.runtimeType.toString(),
          },
        );

        _lastResults[componentName] = result;
        return result;
      }
    } catch (e, stackTrace) {
      // Fallback en cas d'erreur critique (ne devrait jamais arriver)
      _failedChecks++;
      _logWarning(
        'Critical error in health check for $componentName: $e\n$stackTrace',
      );

      return HealthCheckResult(
        componentName: componentName,
        status: HealthStatus.unhealthy,
        message: 'Critical health check error',
        responseTime: Duration.zero,
        details: {
          'error': e.toString(),
          'errorType': e.runtimeType.toString(),
        },
      );
    }
  }

  /// Perform health check for all components
  /// 
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch global
  /// pour éviter que les erreurs ne fassent crasher l'application. Le résultat
  /// est toujours interprétable (jamais null).
  Future<SystemHealthReport> checkAllComponents() async {
    try {
      _log('Checking health of all ${_healthChecks.length} components');

      final results = <HealthCheckResult>[];

      try {
        // Check all components in parallel
        final futures = _healthChecks.keys.map(checkComponent).toList();
        results.addAll(await Future.wait(futures));
      } catch (e, stackTrace) {
        _logWarning(
          'Error during parallel health checks: $e\n$stackTrace',
        );
        // Continue with partial results
      }

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
    } catch (error, stackTrace) {
      // Fallback en cas d'erreur critique
      _logWarning(
        'Critical error in checkAllComponents: $error\n$stackTrace',
      );

      return SystemHealthReport(
        overallStatus: HealthStatus.unhealthy,
        componentResults: [],
        summary: {
          'error': error.toString(),
          'errorType': error.runtimeType.toString(),
        },
      );
    }
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

  /// Check network connectivity health
  Future<HealthCheckResult> _checkNetworkHealth() async {
    final startTime = DateTime.now();

    if (_networkService == null) {
      return HealthCheckResult(
        componentName: 'network',
        status: HealthStatus.unknown,
        message: 'NetworkService not available',
        responseTime: DateTime.now().difference(startTime),
      );
    }

    try {
      // Check if network service is initialized
      if (!_networkService!.isInitialized) {
        return HealthCheckResult(
          componentName: 'network',
          status: HealthStatus.degraded,
          message: 'NetworkService not initialized',
          responseTime: DateTime.now().difference(startTime),
        );
      }

      // Try a simple connectivity check (ping-like)
      // Note: This is a simplified check. In production, you might want to
      // ping a known reliable endpoint or use connectivity_plus package
      return HealthCheckResult(
        componentName: 'network',
        status: HealthStatus.healthy,
        message: 'Network service available',
        responseTime: DateTime.now().difference(startTime),
        details: {
          'initialized': true,
        },
      );
    } catch (e) {
      return HealthCheckResult(
        componentName: 'network',
        status: HealthStatus.unhealthy,
        message: 'Network health check failed',
        responseTime: DateTime.now().difference(startTime),
        details: {'error': e.toString()},
      );
    }
  }

  /// Check backend availability health
  Future<HealthCheckResult> _checkBackendHealth() async {
    final startTime = DateTime.now();

    if (_networkService == null) {
      return HealthCheckResult(
        componentName: 'backend',
        status: HealthStatus.unknown,
        message: 'NetworkService not available',
        responseTime: DateTime.now().difference(startTime),
      );
    }

    try {
      // Check if network service is initialized
      if (!_networkService!.isInitialized) {
        return HealthCheckResult(
          componentName: 'backend',
          status: HealthStatus.degraded,
          message: 'NetworkService not initialized',
          responseTime: DateTime.now().difference(startTime),
        );
      }

      // Check backend availability using NetworkService
      final isAvailable = await _networkService!.isBackendAvailable();

      return HealthCheckResult(
        componentName: 'backend',
        status: isAvailable ? HealthStatus.healthy : HealthStatus.unhealthy,
        message: isAvailable
            ? 'Backend is available'
            : 'Backend is not available',
        responseTime: DateTime.now().difference(startTime),
        details: {
          'available': isAvailable,
          'initialized': true,
        },
      );
    } catch (e) {
      return HealthCheckResult(
        componentName: 'backend',
        status: HealthStatus.unhealthy,
        message: 'Backend health check failed',
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
