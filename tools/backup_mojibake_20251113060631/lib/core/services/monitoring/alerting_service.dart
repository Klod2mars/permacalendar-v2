// 🚨 Alerting Service - Intelligent Alert Management
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Alert Management Patterns

import 'dart:async';
import 'dart:developer' as developer;

/// Alert severity
enum AlertSeverity {
  info,
  warning,
  error,
  critical,
}

/// Alert type
enum AlertType {
  performance,
  health,
  business,
  security,
  system,
}

/// Alert
class Alert {
  final String id;
  final String title;
  final String message;
  final AlertSeverity severity;
  final AlertType type;
  final DateTime createdAt;
  final Map<String, dynamic> context;
  final String? source;

  bool acknowledged;
  DateTime? acknowledgedAt;
  String? acknowledgedBy;

  Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.type,
    DateTime? createdAt,
    this.context = const {},
    this.source,
    this.acknowledged = false,
    this.acknowledgedAt,
    this.acknowledgedBy,
  }) : createdAt = createdAt ?? DateTime.now();

  void acknowledge({String? acknowledgedBy}) {
    acknowledged = true;
    acknowledgedAt = DateTime.now();
    this.acknowledgedBy = acknowledgedBy;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'severity': severity.toString(),
        'type': type.toString(),
        'createdAt': createdAt.toIso8601String(),
        'source': source,
        'acknowledged': acknowledged,
        'acknowledgedAt': acknowledgedAt?.toIso8601String(),
        'acknowledgedBy': acknowledgedBy,
        'context': context,
      };
}

/// Alert rule
class AlertRule {
  final String id;
  final String name;
  final AlertSeverity severity;
  final AlertType type;
  final bool Function(Map<String, dynamic> data) condition;
  final String Function(Map<String, dynamic> data) messageGenerator;
  final Duration? cooldown;

  DateTime? lastTriggered;

  AlertRule({
    required this.id,
    required this.name,
    required this.severity,
    required this.type,
    required this.condition,
    required this.messageGenerator,
    this.cooldown,
  });

  bool canTrigger() {
    if (cooldown == null || lastTriggered == null) return true;
    return DateTime.now().difference(lastTriggered!) > cooldown!;
  }

  void markTriggered() {
    lastTriggered = DateTime.now();
  }
}

/// Alerting service
class AlertingService {
  // Active alerts
  final List<Alert> _activeAlerts = [];
  final List<Alert> _acknowledgedAlerts = [];

  // Alert rules
  final List<AlertRule> _rules = [];

  // Configuration
  final int _maxActiveAlerts;
  final Duration _alertRetention;

  // Alert stream
  final StreamController<Alert> _alertController =
      StreamController<Alert>.broadcast();

  // Statistics
  int _totalAlerts = 0;
  final Map<AlertSeverity, int> _alertsBySeverity = {};
  final Map<AlertType, int> _alertsByType = {};

  AlertingService({
    int? maxActiveAlerts,
    Duration? alertRetention,
  })  : _maxActiveAlerts = maxActiveAlerts ?? 1000,
        _alertRetention = alertRetention ?? const Duration(days: 7) {
    _initializeCounters();
  }

  /// Initialize counters
  void _initializeCounters() {
    for (final severity in AlertSeverity.values) {
      _alertsBySeverity[severity] = 0;
    }
    for (final type in AlertType.values) {
      _alertsByType[type] = 0;
    }
  }

  /// Initialize alerting service
  void initialize() {
    // Register default alert rules
    _registerDefaultRules();

    // Start cleanup timer
    Timer.periodic(const Duration(hours: 1), (timer) {
      _cleanupOldAlerts();
    });

    _log('Alerting service initialized');
  }

  /// Register default alert rules
  void _registerDefaultRules() {
    // High error rate
    registerRule(AlertRule(
      id: 'high_error_rate',
      name: 'High Error Rate',
      severity: AlertSeverity.error,
      type: AlertType.system,
      condition: (data) {
        final errorRate = data['errorRate'] as double? ?? 0.0;
        return errorRate > 0.05; // 5% error rate
      },
      messageGenerator: (data) {
        final errorRate =
            ((data['errorRate'] as double) * 100).toStringAsFixed(1);
        return 'Error rate is high: $errorRate%';
      },
      cooldown: const Duration(minutes: 5),
    ));

    // Slow performance
    registerRule(AlertRule(
      id: 'slow_performance',
      name: 'Slow Performance',
      severity: AlertSeverity.warning,
      type: AlertType.performance,
      condition: (data) {
        final avgResponseTime = data['avgResponseTime'] as int? ?? 0;
        return avgResponseTime > 1000; // 1 second
      },
      messageGenerator: (data) {
        final avgResponseTime = data['avgResponseTime'] as int;
        return 'Average response time is slow: ${avgResponseTime}ms';
      },
      cooldown: const Duration(minutes: 5),
    ));

    // Low health score
    registerRule(AlertRule(
      id: 'low_health_score',
      name: 'Low System Health',
      severity: AlertSeverity.critical,
      type: AlertType.health,
      condition: (data) {
        final healthScore = data['healthScore'] as double? ?? 1.0;
        return healthScore < 0.5; // Below 50%
      },
      messageGenerator: (data) {
        final healthScore =
            ((data['healthScore'] as double) * 100).toStringAsFixed(1);
        return 'System health is low: $healthScore%';
      },
      cooldown: const Duration(minutes: 10),
    ));
  }

  /// Register an alert rule
  void registerRule(AlertRule rule) {
    _rules.add(rule);
    _log('Alert rule registered: ${rule.name}');
  }

  /// Unregister an alert rule
  void unregisterRule(String ruleId) {
    _rules.removeWhere((rule) => rule.id == ruleId);
    _log('Alert rule unregistered: $ruleId');
  }

  /// Trigger alert manually
  void triggerAlert({
    required String title,
    required String message,
    required AlertSeverity severity,
    required AlertType type,
    String? source,
    Map<String, dynamic>? context,
  }) {
    final alert = Alert(
      id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      severity: severity,
      type: type,
      source: source,
      context: context ?? {},
    );

    _addAlert(alert);
  }

  /// Evaluate rules against data
  void evaluateRules(Map<String, dynamic> data, {String? source}) {
    for (final rule in _rules) {
      if (!rule.canTrigger()) continue;

      try {
        if (rule.condition(data)) {
          final message = rule.messageGenerator(data);

          triggerAlert(
            title: rule.name,
            message: message,
            severity: rule.severity,
            type: rule.type,
            source: source,
            context: data,
          );

          rule.markTriggered();
        }
      } catch (e, stackTrace) {
        _logError('Error evaluating rule: ${rule.name}', e, stackTrace);
      }
    }
  }

  /// Add alert to active list
  void _addAlert(Alert alert) {
    _activeAlerts.add(alert);
    _totalAlerts++;

    _alertsBySeverity[alert.severity] =
        (_alertsBySeverity[alert.severity] ?? 0) + 1;
    _alertsByType[alert.type] = (_alertsByType[alert.type] ?? 0) + 1;

    // Trim if exceeding max
    if (_activeAlerts.length > _maxActiveAlerts) {
      final removed = _activeAlerts.removeAt(0);
      if (removed.acknowledged) {
        _acknowledgedAlerts.add(removed);
      }
    }

    // Emit alert
    _alertController.add(alert);

    _log('Alert triggered: ${alert.title} (severity: ${alert.severity})');

    // Log critical alerts
    if (alert.severity == AlertSeverity.critical) {
      _logError(
        'CRITICAL ALERT: ${alert.title}',
        alert.message,
        StackTrace.current,
      );
    }
  }

  /// Acknowledge an alert
  void acknowledgeAlert(String alertId, {String? acknowledgedBy}) {
    final alert = _activeAlerts.firstWhere(
      (a) => a.id == alertId,
      orElse: () => Alert(
        id: '',
        title: '',
        message: '',
        severity: AlertSeverity.info,
        type: AlertType.system,
      ),
    );

    if (alert.id.isNotEmpty) {
      alert.acknowledge(acknowledgedBy: acknowledgedBy);
      _log('Alert acknowledged: ${alert.title}');
    }
  }

  /// Acknowledge all alerts
  void acknowledgeAll({String? acknowledgedBy}) {
    for (final alert in _activeAlerts.where((a) => !a.acknowledged)) {
      alert.acknowledge(acknowledgedBy: acknowledgedBy);
    }
    _log('All alerts acknowledged');
  }

  /// Get active alerts
  List<Alert> getActiveAlerts({
    AlertSeverity? severity,
    AlertType? type,
    bool includeAcknowledged = true,
  }) {
    var filtered = _activeAlerts.where((alert) {
      if (!includeAcknowledged && alert.acknowledged) return false;
      if (severity != null && alert.severity != severity) return false;
      if (type != null && alert.type != type) return false;
      return true;
    }).toList();

    // Sort by severity and creation time
    filtered.sort((a, b) {
      if (a.severity != b.severity) {
        return b.severity.index.compareTo(a.severity.index);
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  /// Get critical alerts
  List<Alert> getCriticalAlerts() {
    return getActiveAlerts(
      severity: AlertSeverity.critical,
      includeAcknowledged: false,
    );
  }

  /// Get unacknowledged alerts count
  int getUnacknowledgedCount() {
    return _activeAlerts.where((a) => !a.acknowledged).length;
  }

  /// Get alert stream
  Stream<Alert> get alertStream => _alertController.stream;

  /// Cleanup old alerts
  void _cleanupOldAlerts() {
    final cutoffTime = DateTime.now().subtract(_alertRetention);

    _acknowledgedAlerts.removeWhere(
      (alert) => alert.acknowledgedAt?.isBefore(cutoffTime) ?? false,
    );

    _log('Old alerts cleaned up');
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalAlerts': _totalAlerts,
      'activeAlerts': _activeAlerts.length,
      'unacknowledgedAlerts': getUnacknowledgedCount(),
      'acknowledgedAlerts': _acknowledgedAlerts.length,
      'alertsBySeverity': _alertsBySeverity.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      'alertsByType': _alertsByType.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      'registeredRules': _rules.length,
    };
  }

  /// Reset statistics
  void resetStatistics() {
    _totalAlerts = 0;
    _alertsBySeverity.updateAll((key, value) => 0);
    _alertsByType.updateAll((key, value) => 0);

    _log('Alerting service statistics reset');
  }

  /// Clear all alerts
  void clearAll() {
    _activeAlerts.clear();
    _acknowledgedAlerts.clear();

    _log('All alerts cleared');
  }

  /// Logging helper
  void _log(String message) {
    developer.log(
      message,
      name: 'AlertingService',
      level: 500,
    );
  }

  /// Error logging helper
  void _logError(String message, Object error, StackTrace stackTrace) {
    developer.log(
      '$message: $error',
      name: 'AlertingService',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  /// Dispose resources
  void dispose() {
    _alertController.close();
    _activeAlerts.clear();
    _acknowledgedAlerts.clear();
    _rules.clear();

    _log('Alerting service disposed');
  }
}


