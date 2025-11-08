// 🚨 Alerting Service - Intelligent Alert Management
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Alert Management Patterns
//
// **Rôle du service :**
// Le AlertingService est responsable de la gestion intelligente des alertes
// système. Il évalue des règles d'alerte configurables, déclenche des alertes
// basées sur des seuils et conditions, et gère leur cycle de vie (création,
// acknowledgment, nettoyage).
//
// **Fonctionnalités principales :**
// - Évaluation de règles d'alerte configurables avec conditions et seuils
// - Déclenchement d'alertes avec 4 niveaux de sévérité (info, warning, error, critical)
// - Gestion de cooldown pour éviter le spam d'alertes identiques
// - Acknowledgment tracking pour suivre les alertes traitées
// - Stream d'alertes en temps réel pour notifications
// - Nettoyage automatique des alertes anciennes
// - Statistiques complètes sur les alertes
//
// **Interactions avec les autres services de monitoring :**
// - **HealthCheckService** : Le AlertingService peut être utilisé pour déclencher
//   des alertes basées sur les résultats des health checks (ex: système dégradé)
// - **MetricsCollectorService** : Les métriques collectées peuvent être évaluées
//   via evaluateRules() pour déclencher des alertes (ex: taux d'erreur élevé)
// - **PerformanceMonitoringService** : Les métriques de performance peuvent être
//   évaluées pour déclencher des alertes (ex: performance lente)
//
// **Architecture :**
// ```
// AlertingService
//   ├─→ AlertRules (règles configurables avec conditions et cooldown)
//   ├─→ ActiveAlerts (liste des alertes actives)
//   ├─→ AcknowledgedAlerts (liste des alertes traitées)
//   ├─→ AlertStream (stream pour notifications en temps réel)
//   └─→ CleanupTimer (nettoyage périodique des alertes anciennes)
// ```
//
// **Sécurisation :**
// Toutes les méthodes critiques sont encapsulées dans des try/catch pour
// éviter que les erreurs ne fassent crasher l'application. Le service continue
// de fonctionner même en cas d'erreur lors de l'évaluation de règles ou du
// déclenchement d'alertes.
//
// **Gestion du spam :**
// Le service utilise un système de cooldown au niveau des règles pour éviter
// le spam d'alertes identiques. Chaque règle peut avoir un cooldown configuré
// qui empêche le déclenchement répété de la même alerte pendant une période
// donnée.
//
// **Points d'extension :**
// - Ajout de règles personnalisées via `registerRule()`
// - Personnalisation des seuils via modification des règles par défaut
// - Intégration avec systèmes de notification externes via `alertStream`
// - Persistance optionnelle des alertes (peut être ajoutée si nécessaire)

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

  // Cleanup timer
  Timer? _cleanupTimer;

  // Statistics
  int _totalAlerts = 0;
  final Map<AlertSeverity, int> _alertsBySeverity = {};
  final Map<AlertType, int> _alertsByType = {};

  // Debounce tracking for duplicate alerts (same title + severity)
  final Map<String, DateTime> _lastAlertByKey = {};
  static const Duration _defaultDebounceDuration = Duration(seconds: 30);

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
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void initialize() {
    try {
      // Register default alert rules
      _registerDefaultRules();

      // Start cleanup timer
      _cleanupTimer = Timer.periodic(const Duration(hours: 1), (timer) {
        _cleanupOldAlerts();
      });

      _log('Alerting service initialized');
    } catch (e, stackTrace) {
      _logError('Error initializing alerting service', e, stackTrace);
    }
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
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void registerRule(AlertRule rule) {
    try {
      // Check if rule with same ID already exists
      if (_rules.any((r) => r.id == rule.id)) {
        _log('Warning: Rule with ID ${rule.id} already exists, replacing it');
        _rules.removeWhere((r) => r.id == rule.id);
      }

      _rules.add(rule);
      _log('Alert rule registered: ${rule.name}');
    } catch (e, stackTrace) {
      _logError('Error registering alert rule: ${rule.name}', e, stackTrace);
    }
  }

  /// Unregister an alert rule
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void unregisterRule(String ruleId) {
    try {
      final removed = _rules.removeWhere((rule) => rule.id == ruleId);
      if (removed > 0) {
        _log('Alert rule unregistered: $ruleId');
      } else {
        _log('Warning: Rule with ID $ruleId not found');
      }
    } catch (e, stackTrace) {
      _logError('Error unregistering alert rule: $ruleId', e, stackTrace);
    }
  }

  /// Trigger alert manually
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  ///
  /// **Debounce :** Les alertes avec le même titre et sévérité sont debounced
  /// pour éviter le spam. Par défaut, une alerte identique ne peut être
  /// déclenchée qu'une fois toutes les 30 secondes.
  void triggerAlert({
    required String title,
    required String message,
    required AlertSeverity severity,
    required AlertType type,
    String? source,
    Map<String, dynamic>? context,
    Duration? debounceDuration,
  }) {
    try {
      // Debounce check: prevent duplicate alerts with same title and severity
      final alertKey = '${title}_${severity.toString()}';
      final lastTriggered = _lastAlertByKey[alertKey];
      final debounce = debounceDuration ?? _defaultDebounceDuration;

      if (lastTriggered != null) {
        final timeSinceLastAlert = DateTime.now().difference(lastTriggered);
        if (timeSinceLastAlert < debounce) {
          _log(
            'Alert debounced: $title (severity: $severity) - '
            'last triggered ${timeSinceLastAlert.inSeconds}s ago',
          );
          return;
        }
      }

      final alert = Alert(
        id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        message: message,
        severity: severity,
        type: type,
        source: source,
        context: context ?? {},
      );

      // Update debounce tracking
      _lastAlertByKey[alertKey] = DateTime.now();

      _addAlert(alert);
    } catch (e, stackTrace) {
      _logError('Error triggering alert: $title', e, stackTrace);
    }
  }

  /// Evaluate rules against data
  ///
  /// **Sécurisation :** Cette méthode évalue toutes les règles de manière
  /// sécurisée. Si une règle échoue, les autres règles continuent d'être
  /// évaluées. Chaque règle est encapsulée dans un try/catch individuel.
  ///
  /// **Usage :**
  /// ```dart
  /// final alertingService = ref.read(MonitoringModule.alertingServiceProvider);
  /// await alertingService.initialize();
  ///
  /// // Évaluer les règles avec des données de métriques
  /// alertingService.evaluateRules({
  ///   'errorRate': 0.08, // 8% d'erreur
  ///   'avgResponseTime': 1200, // 1.2s
  ///   'healthScore': 0.4, // 40%
  /// }, source: 'MetricsCollectorService');
  /// ```
  void evaluateRules(Map<String, dynamic> data, {String? source}) {
    try {
      for (final rule in _rules) {
        // Skip if rule is in cooldown
        if (!rule.canTrigger()) continue;

        try {
          // Evaluate condition
          if (rule.condition(data)) {
            try {
              // Generate message
              final message = rule.messageGenerator(data);

              // Trigger alert (with debounce)
              triggerAlert(
                title: rule.name,
                message: message,
                severity: rule.severity,
                type: rule.type,
                source: source,
                context: data,
              );

              // Mark rule as triggered (updates cooldown)
              rule.markTriggered();
            } catch (e, stackTrace) {
              _logError(
                'Error generating message for rule: ${rule.name}',
                e,
                stackTrace,
              );
            }
          }
        } catch (e, stackTrace) {
          _logError('Error evaluating rule condition: ${rule.name}', e, stackTrace);
        }
      }
    } catch (e, stackTrace) {
      _logError('Error in evaluateRules', e, stackTrace);
    }
  }

  /// Add alert to active list
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application. Si l'émission
  /// du stream échoue, l'alerte est quand même ajoutée à la liste.
  void _addAlert(Alert alert) {
    try {
      _activeAlerts.add(alert);
      _totalAlerts++;

      _alertsBySeverity[alert.severity] =
          (_alertsBySeverity[alert.severity] ?? 0) + 1;
      _alertsByType[alert.type] = (_alertsByType[alert.type] ?? 0) + 1;

      // Trim if exceeding max
      if (_activeAlerts.length > _maxActiveAlerts) {
        try {
          final removed = _activeAlerts.removeAt(0);
          if (removed.acknowledged) {
            _acknowledgedAlerts.add(removed);
          }
        } catch (e, stackTrace) {
          _logError('Error trimming alerts', e, stackTrace);
        }
      }

      // Emit alert (with error handling)
      try {
        if (!_alertController.isClosed) {
          _alertController.add(alert);
        }
      } catch (e, stackTrace) {
        _logError('Error emitting alert to stream', e, stackTrace);
        // Continue: alert is still added to the list
      }

      _log('Alert triggered: ${alert.title} (severity: ${alert.severity})');

      // Log critical alerts with higher priority
      if (alert.severity == AlertSeverity.critical) {
        _logError(
          'CRITICAL ALERT: ${alert.title}',
          alert.message,
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      _logError('Error adding alert: ${alert.title}', e, stackTrace);
    }
  }

  /// Acknowledge an alert
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void acknowledgeAlert(String alertId, {String? acknowledgedBy}) {
    try {
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
      } else {
        _log('Warning: Alert with ID $alertId not found');
      }
    } catch (e, stackTrace) {
      _logError('Error acknowledging alert: $alertId', e, stackTrace);
    }
  }

  /// Acknowledge all alerts
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void acknowledgeAll({String? acknowledgedBy}) {
    try {
      int acknowledgedCount = 0;
      for (final alert in _activeAlerts.where((a) => !a.acknowledged)) {
        try {
          alert.acknowledge(acknowledgedBy: acknowledgedBy);
          acknowledgedCount++;
        } catch (e, stackTrace) {
          _logError(
            'Error acknowledging alert: ${alert.id}',
            e,
            stackTrace,
          );
        }
      }
      _log('All alerts acknowledged ($acknowledgedCount alerts)');
    } catch (e, stackTrace) {
      _logError('Error acknowledging all alerts', e, stackTrace);
    }
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
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application.
  void _cleanupOldAlerts() {
    try {
      final cutoffTime = DateTime.now().subtract(_alertRetention);
      final initialCount = _acknowledgedAlerts.length;

      _acknowledgedAlerts.removeWhere(
        (alert) => alert.acknowledgedAt?.isBefore(cutoffTime) ?? false,
      );

      final removedCount = initialCount - _acknowledgedAlerts.length;
      if (removedCount > 0) {
        _log('Old alerts cleaned up ($removedCount alerts removed)');
      }
    } catch (e, stackTrace) {
      _logError('Error cleaning up old alerts', e, stackTrace);
    }
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
  ///
  /// **Sécurisation :** Cette méthode est encapsulée dans un try/catch pour
  /// éviter que les erreurs ne fassent crasher l'application lors du nettoyage.
  void dispose() {
    try {
      // Cancel cleanup timer
      _cleanupTimer?.cancel();
      _cleanupTimer = null;

      // Close stream controller
      if (!_alertController.isClosed) {
        _alertController.close();
      }

      // Clear all data
      _activeAlerts.clear();
      _acknowledgedAlerts.clear();
      _rules.clear();
      _lastAlertByKey.clear();

      _log('Alerting service disposed');
    } catch (e, stackTrace) {
      _logError('Error disposing alerting service', e, stackTrace);
    }
  }
}
