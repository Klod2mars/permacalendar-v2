
import '../../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/services/monitoring/alerting_service.dart';
import 'dart:async';

void main() {
  group('AlertingService', () {
    late AlertingService alertingService;

    setUp(() {
      alertingService = AlertingService(
        maxActiveAlerts: 100,
        alertRetention: const Duration(days: 1),
      );
    });

    tearDown(() {
      alertingService.dispose();
    });

    group('Initialization', () {
      test('should initialize successfully', () {
        // Act
        alertingService.initialize();

        // Assert
        expect(alertingService, isNotNull);
        final stats = alertingService.getStatistics();
        expect(stats['registeredRules'], greaterThan(0));
      });

      test('should register default alert rules', () {
        // Act
        alertingService.initialize();

        // Assert
        final stats = alertingService.getStatistics();
        expect(stats['registeredRules'], equals(3)); // 3 rÃ¨gles par dÃ©faut
      });
    });

    group('Alert Rules', () {
      test('should register a custom alert rule', () {
        // Arrange
        final rule = AlertRule(
          id: 'test_rule',
          name: 'Test Rule',
          severity: AlertSeverity.warning,
          type: AlertType.system,
          condition: (data) => data['value'] as int? ?? 0 > 10,
          messageGenerator: (data) => 'Test message',
        );

        // Act
        alertingService.registerRule(rule);

        // Assert
        final stats = alertingService.getStatistics();
        expect(stats['registeredRules'], equals(1));
      });

      test('should replace existing rule with same ID', () {
        // Arrange
        final rule1 = AlertRule(
          id: 'test_rule',
          name: 'Test Rule 1',
          severity: AlertSeverity.warning,
          type: AlertType.system,
          condition: (data) => true,
          messageGenerator: (data) => 'Message 1',
        );

        final rule2 = AlertRule(
          id: 'test_rule',
          name: 'Test Rule 2',
          severity: AlertSeverity.error,
          type: AlertType.system,
          condition: (data) => true,
          messageGenerator: (data) => 'Message 2',
        );

        // Act
        alertingService.registerRule(rule1);
        alertingService.registerRule(rule2);

        // Assert
        final stats = alertingService.getStatistics();
        expect(stats['registeredRules'], equals(1));
      });

      test('should unregister an alert rule', () {
        // Arrange
        final rule = AlertRule(
          id: 'test_rule',
          name: 'Test Rule',
          severity: AlertSeverity.warning,
          type: AlertType.system,
          condition: (data) => true,
          messageGenerator: (data) => 'Test message',
        );
        alertingService.registerRule(rule);

        // Act
        alertingService.unregisterRule('test_rule');

        // Assert
        final stats = alertingService.getStatistics();
        expect(stats['registeredRules'], equals(0));
      });

      test('should handle unregistering non-existent rule', () {
        // Act & Assert - should not throw
        expect(
          () => alertingService.unregisterRule('non_existent'),
          returnsNormally,
        );
      });
    });

    group('Trigger Alert', () {
      test('should trigger an alert manually', () {
        // Act
        alertingService.triggerAlert(
          title: 'Test Alert',
          message: 'This is a test alert',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );

        // Assert
        final alerts = alertingService.getActiveAlerts();
        expect(alerts.length, equals(1));
        expect(alerts.first.title, equals('Test Alert'));
        expect(alerts.first.severity, equals(AlertSeverity.warning));
        expect(alerts.first.acknowledged, isFalse);
      });

      test('should debounce duplicate alerts', () async {
        // Act
        alertingService.triggerAlert(
          title: 'Test Alert',
          message: 'First alert',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );

        // Trigger same alert immediately (should be debounced)
        alertingService.triggerAlert(
          title: 'Test Alert',
          message: 'Second alert',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );

        // Assert
        final alerts = alertingService.getActiveAlerts();
        expect(alerts.length, equals(1)); // Only one alert should be created
      });

      test('should allow duplicate alerts after debounce period', () async {
        // Arrange
        alertingService.triggerAlert(
          title: 'Test Alert',
          message: 'First alert',
          severity: AlertSeverity.warning,
          type: AlertType.system,
          debounceDuration: const Duration(milliseconds: 100),
        );

        // Wait for debounce period to expire
        await Future.delayed(const Duration(milliseconds: 150));

        // Act
        alertingService.triggerAlert(
          title: 'Test Alert',
          message: 'Second alert',
          severity: AlertSeverity.warning,
          type: AlertType.system,
          debounceDuration: const Duration(milliseconds: 100),
        );

        // Assert
        final alerts = alertingService.getActiveAlerts();
        expect(alerts.length, equals(2)); // Both alerts should be created
      });

      test('should emit alert to stream', () async {
        // Arrange
        final alertsReceived = <Alert>[];
        final subscription = alertingService.alertStream.listen((alert) {
          alertsReceived.add(alert);
        });

        // Act
        alertingService.triggerAlert(
          title: 'Stream Test',
          message: 'Testing stream',
          severity: AlertSeverity.info,
          type: AlertType.system,
        );

        // Wait for stream to emit
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(alertsReceived.length, equals(1));
        expect(alertsReceived.first.title, equals('Stream Test'));

        // Cleanup
        await subscription.cancel();
      });
    });

    group('Evaluate Rules', () {
      test('should trigger alert when rule condition is met', () {
        // Arrange
        alertingService.initialize();

        // Act
        alertingService.evaluateRules({
          'errorRate': 0.08, // 8% - above threshold of 5%
        });

        // Assert
        final alerts = alertingService.getActiveAlerts();
        expect(alerts.length, greaterThan(0));
        expect(
          alerts.any((a) => a.title == 'High Error Rate'),
          isTrue,
        );
      });

      test('should not trigger alert when rule condition is not met', () {
        // Arrange
        alertingService.initialize();

        // Act
        alertingService.evaluateRules({
          'errorRate': 0.03, // 3% - below threshold of 5%
        });

        // Assert
        final alerts = alertingService.getActiveAlerts();
        expect(
          alerts.any((a) => a.title == 'High Error Rate'),
          isFalse,
        );
      });

      test('should respect rule cooldown', () {
        // Arrange
        alertingService.initialize();

        // Act - trigger alert first time
        alertingService.evaluateRules({
          'errorRate': 0.08,
        });

        // Trigger again immediately (should be blocked by cooldown)
        alertingService.evaluateRules({
          'errorRate': 0.08,
        });

        // Assert
        final alerts = alertingService.getActiveAlerts();
        // Should only have one alert due to cooldown
        final highErrorRateAlerts = alerts.where(
          (a) => a.title == 'High Error Rate',
        );
        expect(highErrorRateAlerts.length, equals(1));
      });

      test('should handle errors in rule condition gracefully', () {
        // Arrange
        final rule = AlertRule(
          id: 'error_rule',
          name: 'Error Rule',
          severity: AlertSeverity.error,
          type: AlertType.system,
          condition: (data) {
            throw Exception('Condition error');
          },
          messageGenerator: (data) => 'Should not reach here',
        );
        alertingService.registerRule(rule);

        // Act & Assert - should not throw
        expect(
          () => alertingService.evaluateRules({'test': 'value'}),
          returnsNormally,
        );

        // No alerts should be created due to error
        final alerts = alertingService.getActiveAlerts();
        expect(alerts.isEmpty, isTrue);
      });

      test('should handle errors in message generator gracefully', () {
        // Arrange
        final rule = AlertRule(
          id: 'error_rule',
          name: 'Error Rule',
          severity: AlertSeverity.error,
          type: AlertType.system,
          condition: (data) => true,
          messageGenerator: (data) {
            throw Exception('Message generator error');
          },
        );
        alertingService.registerRule(rule);

        // Act & Assert - should not throw
        expect(
          () => alertingService.evaluateRules({'test': 'value'}),
          returnsNormally,
        );

        // No alerts should be created due to error
        final alerts = alertingService.getActiveAlerts();
        expect(alerts.isEmpty, isTrue);
      });
    });

    group('Acknowledge Alerts', () {
      test('should acknowledge a specific alert', () {
        // Arrange
        alertingService.triggerAlert(
          title: 'Test Alert',
          message: 'Test message',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );

        final alerts = alertingService.getActiveAlerts();
        final alertId = alerts.first.id;

        // Act
        alertingService.acknowledgeAlert(alertId, acknowledgedBy: 'user_123');

        // Assert
        final updatedAlerts = alertingService.getActiveAlerts();
        final acknowledgedAlert = updatedAlerts.firstWhere(
          (a) => a.id == alertId,
        );
        expect(acknowledgedAlert.acknowledged, isTrue);
        expect(acknowledgedAlert.acknowledgedBy, equals('user_123'));
        expect(acknowledgedAlert.acknowledgedAt, isNotNull);
      });

      test('should handle acknowledging non-existent alert', () {
        // Act & Assert - should not throw
        expect(
          () => alertingService.acknowledgeAlert('non_existent'),
          returnsNormally,
        );
      });

      test('should acknowledge all alerts', () {
        // Arrange
        alertingService.triggerAlert(
          title: 'Alert 1',
          message: 'Message 1',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );
        alertingService.triggerAlert(
          title: 'Alert 2',
          message: 'Message 2',
          severity: AlertSeverity.error,
          type: AlertType.system,
        );

        // Act
        alertingService.acknowledgeAll(acknowledgedBy: 'user_123');

        // Assert
        final alerts = alertingService.getActiveAlerts();
        expect(alerts.every((a) => a.acknowledged), isTrue);
        expect(alerts.every((a) => a.acknowledgedBy == 'user_123'), isTrue);
      });
    });

    group('Get Active Alerts', () {
      test('should filter alerts by severity', () {
        // Arrange
        alertingService.triggerAlert(
          title: 'Warning Alert',
          message: 'Warning',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );
        alertingService.triggerAlert(
          title: 'Error Alert',
          message: 'Error',
          severity: AlertSeverity.error,
          type: AlertType.system,
        );

        // Act
        final warningAlerts = alertingService.getActiveAlerts(
          severity: AlertSeverity.warning,
        );

        // Assert
        expect(warningAlerts.length, equals(1));
        expect(warningAlerts.first.severity, equals(AlertSeverity.warning));
      });

      test('should filter alerts by type', () {
        // Arrange
        alertingService.triggerAlert(
          title: 'Performance Alert',
          message: 'Performance',
          severity: AlertSeverity.warning,
          type: AlertType.performance,
        );
        alertingService.triggerAlert(
          title: 'Health Alert',
          message: 'Health',
          severity: AlertSeverity.warning,
          type: AlertType.health,
        );

        // Act
        final performanceAlerts = alertingService.getActiveAlerts(
          type: AlertType.performance,
        );

        // Assert
        expect(performanceAlerts.length, equals(1));
        expect(performanceAlerts.first.type, equals(AlertType.performance));
      });

      test('should exclude acknowledged alerts when requested', () {
        // Arrange
        alertingService.triggerAlert(
          title: 'Alert 1',
          message: 'Message 1',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );
        alertingService.triggerAlert(
          title: 'Alert 2',
          message: 'Message 2',
          severity: AlertSeverity.error,
          type: AlertType.system,
        );

        final alerts = alertingService.getActiveAlerts();
        alertingService.acknowledgeAlert(alerts.first.id);

        // Act
        final unacknowledgedAlerts = alertingService.getActiveAlerts(
          includeAcknowledged: false,
        );

        // Assert
        expect(unacknowledgedAlerts.length, equals(1));
        expect(unacknowledgedAlerts.first.acknowledged, isFalse);
      });

      test('should sort alerts by severity and creation time', () {
        // Arrange
        alertingService.triggerAlert(
          title: 'Info Alert',
          message: 'Info',
          severity: AlertSeverity.info,
          type: AlertType.system,
        );
        alertingService.triggerAlert(
          title: 'Critical Alert',
          message: 'Critical',
          severity: AlertSeverity.critical,
          type: AlertType.system,
        );
        alertingService.triggerAlert(
          title: 'Warning Alert',
          message: 'Warning',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );

        // Act
        final alerts = alertingService.getActiveAlerts();

        // Assert
        expect(alerts.length, equals(3));
        // Critical should be first
        expect(alerts.first.severity, equals(AlertSeverity.critical));
      });

      test('should get critical alerts only', () {
        // Arrange
        alertingService.triggerAlert(
          title: 'Critical Alert',
          message: 'Critical',
          severity: AlertSeverity.critical,
          type: AlertType.system,
        );
        alertingService.triggerAlert(
          title: 'Warning Alert',
          message: 'Warning',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );

        // Act
        final criticalAlerts = alertingService.getCriticalAlerts();

        // Assert
        expect(criticalAlerts.length, equals(1));
        expect(criticalAlerts.first.severity, equals(AlertSeverity.critical));
      });
    });

    group('Statistics', () {
      test('should return correct statistics', () {
        // Arrange
        alertingService.initialize();
        alertingService.triggerAlert(
          title: 'Warning Alert',
          message: 'Warning',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );
        alertingService.triggerAlert(
          title: 'Error Alert',
          message: 'Error',
          severity: AlertSeverity.error,
          type: AlertType.system,
        );

        // Act
        final stats = alertingService.getStatistics();

        // Assert
        expect(stats['totalAlerts'], equals(2));
        expect(stats['activeAlerts'], equals(2));
        expect(stats['unacknowledgedAlerts'], equals(2));
        expect(stats['acknowledgedAlerts'], equals(0));
        expect(stats['registeredRules'], equals(3));
      });

      test('should reset statistics', () {
        // Arrange
        alertingService.triggerAlert(
          title: 'Test Alert',
          message: 'Test',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );

        // Act
        alertingService.resetStatistics();

        // Assert
        final stats = alertingService.getStatistics();
        expect(stats['totalAlerts'], equals(0));
        // Active alerts should still be there (only counters reset)
        expect(stats['activeAlerts'], equals(1));
      });

      test('should get unacknowledged count', () {
        // Arrange
        alertingService.triggerAlert(
          title: 'Alert 1',
          message: 'Message 1',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );
        alertingService.triggerAlert(
          title: 'Alert 2',
          message: 'Message 2',
          severity: AlertSeverity.error,
          type: AlertType.system,
        );

        final alerts = alertingService.getActiveAlerts();
        alertingService.acknowledgeAlert(alerts.first.id);

        // Act
        final unacknowledgedCount = alertingService.getUnacknowledgedCount();

        // Assert
        expect(unacknowledgedCount, equals(1));
      });
    });

    group('Cleanup', () {
      test('should clear all alerts', () {
        // Arrange
        alertingService.triggerAlert(
          title: 'Alert 1',
          message: 'Message 1',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );
        alertingService.triggerAlert(
          title: 'Alert 2',
          message: 'Message 2',
          severity: AlertSeverity.error,
          type: AlertType.system,
        );

        // Act
        alertingService.clearAll();

        // Assert
        final alerts = alertingService.getActiveAlerts();
        expect(alerts.length, equals(0));
      });

      test('should dispose resources correctly', () {
        // Arrange
        alertingService.initialize();
        alertingService.triggerAlert(
          title: 'Test Alert',
          message: 'Test',
          severity: AlertSeverity.warning,
          type: AlertType.system,
        );

        // Act
        alertingService.dispose();

        // Assert
        // Stream should be closed
        expect(
          () => alertingService.alertStream.listen((_) {}),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('Error Handling', () {
      test('should handle errors in triggerAlert gracefully', () {
        // Act & Assert - should not throw even with invalid data
        expect(
          () => alertingService.triggerAlert(
            title: '',
            message: '',
            severity: AlertSeverity.info,
            type: AlertType.system,
          ),
          returnsNormally,
        );
      });

      test('should handle errors in evaluateRules gracefully', () {
        // Arrange
        alertingService.initialize();

        // Act & Assert - should not throw even with invalid data
        expect(
          () => alertingService.evaluateRules(null as dynamic),
          returnsNormally,
        );
      });
    });

    group('Max Active Alerts', () {
      test('should trim alerts when exceeding max', () {
        // Arrange
        final service = AlertingService(maxActiveAlerts: 5);
        for (int i = 0; i < 10; i++) {
          service.triggerAlert(
            title: 'Alert $i',
            message: 'Message $i',
            severity: AlertSeverity.info,
            type: AlertType.system,
          );
        }

        // Act
        final alerts = service.getActiveAlerts();

        // Assert
        expect(alerts.length, lessThanOrEqualTo(5));

        // Cleanup
        service.dispose();
      });
    });
  });
}


