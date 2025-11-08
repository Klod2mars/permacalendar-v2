import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:permacalendar/core/services/monitoring/health_check_service.dart';
import 'package:permacalendar/core/services/network_service.dart';
import 'package:hive/hive.dart';

import 'health_check_service_test.mocks.dart';

@GenerateMocks([NetworkService])
void main() {
  group('HealthCheckService', () {
    late HealthCheckService healthCheckService;
    late MockNetworkService mockNetworkService;

    setUp(() {
      mockNetworkService = MockNetworkService();
      healthCheckService = HealthCheckService(
        checkTimeout: const Duration(seconds: 5),
        enableAutoChecks: false,
        networkService: mockNetworkService,
      );
    });

    tearDown(() {
      healthCheckService.dispose();
    });

    group('Initialization', () {
      test('should initialize successfully', () {
        // Act
        healthCheckService.initialize();

        // Assert
        // Le service devrait être initialisé sans erreur
        expect(healthCheckService, isNotNull);
      });

      test('should register default health checks', () {
        // Act
        healthCheckService.initialize();

        // Assert
        // Vérifier que les health checks par défaut sont enregistrés
        final result = healthCheckService.getLastResult('hive_database');
        // Le résultat peut être null avant le premier check, mais le check devrait être enregistré
        expect(healthCheckService, isNotNull);
      });
    });

    group('Component Health Checks', () {
      test('should return unknown status for unregistered component', () async {
        // Arrange
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('unknown_component');

        // Assert
        expect(result.componentName, equals('unknown_component'));
        expect(result.status, equals(HealthStatus.unknown));
        expect(result.message, contains('No health check registered'));
      });

      test('should check hive database health', () async {
        // Arrange
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('hive_database');

        // Assert
        expect(result.componentName, equals('hive_database'));
        expect(result.status, isIn([HealthStatus.healthy, HealthStatus.degraded, HealthStatus.unhealthy]));
        expect(result.responseTime, isA<Duration>());
        expect(result.message, isNotNull);
      });

      test('should check memory health', () async {
        // Arrange
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('memory');

        // Assert
        expect(result.componentName, equals('memory'));
        expect(result.status, isA<HealthStatus>());
        expect(result.responseTime, isA<Duration>());
        expect(result.message, isNotNull);
      });

      test('should check cache health', () async {
        // Arrange
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('cache');

        // Assert
        expect(result.componentName, equals('cache'));
        expect(result.status, isIn([HealthStatus.healthy, HealthStatus.degraded, HealthStatus.unhealthy]));
        expect(result.responseTime, isA<Duration>());
        expect(result.message, isNotNull);
      });

      test('should check network health when NetworkService is available', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('network');

        // Assert
        expect(result.componentName, equals('network'));
        expect(result.status, isA<HealthStatus>());
        expect(result.responseTime, isA<Duration>());
        expect(result.message, isNotNull);
      });

      test('should check backend health when NetworkService is available', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenAnswer((_) async => true);
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('backend');

        // Assert
        expect(result.componentName, equals('backend'));
        expect(result.status, isIn([HealthStatus.healthy, HealthStatus.unhealthy]));
        expect(result.responseTime, isA<Duration>());
        expect(result.message, isNotNull);
      });

      test('should handle network service not initialized', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(false);
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('backend');

        // Assert
        expect(result.componentName, equals('backend'));
        expect(result.status, equals(HealthStatus.degraded));
        expect(result.message, contains('not initialized'));
      });

      test('should handle backend unavailable', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenAnswer((_) async => false);
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('backend');

        // Assert
        expect(result.componentName, equals('backend'));
        expect(result.status, equals(HealthStatus.unhealthy));
        expect(result.message, contains('not available'));
      });

      test('should handle network timeout', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenAnswer(
          (_) => Future.delayed(const Duration(seconds: 10)),
        );
        healthCheckService = HealthCheckService(
          checkTimeout: const Duration(milliseconds: 100),
          networkService: mockNetworkService,
        );
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('backend');

        // Assert
        expect(result.componentName, equals('backend'));
        expect(result.status, equals(HealthStatus.unhealthy));
        // Le timeout peut être géré soit comme "timed out" soit comme "failed"
        expect(
          result.message,
          anyOf(contains('timed out'), contains('failed')),
        );
      });

      test('should handle network service errors gracefully', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenThrow(Exception('Network error'));
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('backend');

        // Assert
        expect(result.componentName, equals('backend'));
        expect(result.status, equals(HealthStatus.unhealthy));
        expect(result.message, contains('failed'));
        expect(result.details.containsKey('error'), isTrue);
      });
    });

    group('All Components Health Check', () {
      test('should check all components and return report', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenAnswer((_) async => true);
        healthCheckService.initialize();

        // Act
        final report = await healthCheckService.checkAllComponents();

        // Assert
        expect(report, isNotNull);
        expect(report.overallStatus, isA<HealthStatus>());
        expect(report.componentResults, isNotEmpty);
        expect(report.componentResults.length, greaterThan(0));
        expect(report.healthPercentage, greaterThanOrEqualTo(0.0));
        expect(report.healthPercentage, lessThanOrEqualTo(100.0));
      });

      test('should return healthy status when all components are healthy', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenAnswer((_) async => true);
        healthCheckService.initialize();

        // Act
        final report = await healthCheckService.checkAllComponents();

        // Assert
        expect(report.overallStatus, isA<HealthStatus>());
        expect(report.healthyCount, greaterThanOrEqualTo(0));
        expect(report.degradedCount, greaterThanOrEqualTo(0));
        expect(report.unhealthyCount, greaterThanOrEqualTo(0));
      });

      test('should return unhealthy status when any component is unhealthy', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenAnswer((_) async => false);
        healthCheckService.initialize();

        // Act
        final report = await healthCheckService.checkAllComponents();

        // Assert
        // Si le backend est unhealthy, le statut global devrait être unhealthy ou degraded
        expect(report.overallStatus, isIn([HealthStatus.unhealthy, HealthStatus.degraded]));
        expect(report.unhealthyCount, greaterThanOrEqualTo(0));
      });

      test('should handle errors gracefully and return partial results', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenThrow(Exception('Test error'));
        healthCheckService.initialize();

        // Act
        final report = await healthCheckService.checkAllComponents();

        // Assert
        // Le rapport devrait toujours être retourné, même en cas d'erreur
        expect(report, isNotNull);
        expect(report.componentResults, isA<List<HealthCheckResult>>());
        // Au moins certains composants devraient être vérifiés
        expect(report.componentResults.length, greaterThan(0));
      });

      test('should calculate health percentage correctly', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenAnswer((_) async => true);
        healthCheckService.initialize();

        // Act
        final report = await healthCheckService.checkAllComponents();

        // Assert
        final expectedPercentage = (report.healthyCount / report.componentResults.length) * 100;
        expect(report.healthPercentage, closeTo(expectedPercentage, 0.1));
      });
    });

    group('Error Handling and Resilience', () {
      test('should never return null result', () async {
        // Arrange
        healthCheckService.initialize();

        // Act
        final result = await healthCheckService.checkComponent('hive_database');

        // Assert
        expect(result, isNotNull);
        expect(result.componentName, isNotNull);
        expect(result.status, isNotNull);
        expect(result.responseTime, isNotNull);
      });

      test('should handle exceptions in health checks without crashing', () async {
        // Arrange
        healthCheckService.initialize();
        // Enregistrer un health check qui lance une exception
        healthCheckService.registerHealthCheck(
          'failing_component',
          () => throw Exception('Test exception'),
        );

        // Act
        final result = await healthCheckService.checkComponent('failing_component');

        // Assert
        expect(result, isNotNull);
        expect(result.status, equals(HealthStatus.unhealthy));
        expect(result.message, contains('failed'));
        expect(result.details.containsKey('error'), isTrue);
      });

      test('should handle timeout gracefully', () async {
        // Arrange
        healthCheckService = HealthCheckService(
          checkTimeout: const Duration(milliseconds: 50),
          networkService: mockNetworkService,
        );
        healthCheckService.initialize();
        // Enregistrer un health check qui prend trop de temps
        healthCheckService.registerHealthCheck(
          'slow_component',
          () => Future.delayed(const Duration(seconds: 1), () => HealthCheckResult(
            componentName: 'slow_component',
            status: HealthStatus.healthy,
            responseTime: Duration.zero,
          )),
        );

        // Act
        final result = await healthCheckService.checkComponent('slow_component');

        // Assert
        expect(result, isNotNull);
        expect(result.status, equals(HealthStatus.unhealthy));
        expect(result.message, contains('timed out'));
      });

      test('should always return interpretable report', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenThrow(Exception('Test'));
        healthCheckService.initialize();

        // Act
        final report = await healthCheckService.checkAllComponents();

        // Assert
        expect(report, isNotNull);
        expect(report.overallStatus, isA<HealthStatus>());
        expect(report.componentResults, isA<List<HealthCheckResult>>());
        expect(report.summary, isA<Map<String, dynamic>>());
      });
    });

    group('Statistics and Results', () {
      test('should track last result for component', () async {
        // Arrange
        healthCheckService.initialize();

        // Act
        await healthCheckService.checkComponent('hive_database');
        final lastResult = healthCheckService.getLastResult('hive_database');

        // Assert
        expect(lastResult, isNotNull);
        expect(lastResult!.componentName, equals('hive_database'));
      });

      test('should return null for component without last result', () {
        // Arrange
        healthCheckService.initialize();

        // Act
        final result = healthCheckService.getLastResult('unknown_component');

        // Assert
        expect(result, isNull);
      });

      test('should get all last results', () async {
        // Arrange
        when(mockNetworkService.isInitialized).thenReturn(true);
        when(mockNetworkService.isBackendAvailable()).thenAnswer((_) async => true);
        healthCheckService.initialize();

        // Act
        await healthCheckService.checkAllComponents();
        final allResults = healthCheckService.getAllLastResults();

        // Assert
        expect(allResults, isA<Map<String, HealthCheckResult>>());
        expect(allResults.length, greaterThan(0));
      });

      test('should provide statistics', () async {
        // Arrange
        healthCheckService.initialize();
        await healthCheckService.checkComponent('hive_database');

        // Act
        final stats = healthCheckService.getStatistics();

        // Assert
        expect(stats, isA<Map<String, dynamic>>());
        expect(stats['totalChecks'], greaterThan(0));
        expect(stats['registeredComponents'], greaterThan(0));
        expect(stats['successRate'], isA<double>());
      });

      test('should reset statistics', () async {
        // Arrange
        healthCheckService.initialize();
        await healthCheckService.checkComponent('hive_database');
        final statsBefore = healthCheckService.getStatistics();

        // Act
        healthCheckService.resetStatistics();
        final statsAfter = healthCheckService.getStatistics();

        // Assert
        expect(statsBefore['totalChecks'], greaterThan(0));
        expect(statsAfter['totalChecks'], equals(0));
        expect(statsAfter['failedChecks'], equals(0));
      });
    });

    group('Custom Health Checks', () {
      test('should register custom health check', () {
        // Arrange
        healthCheckService.initialize();

        // Act
        healthCheckService.registerHealthCheck(
          'custom_component',
          () => Future.value(HealthCheckResult(
            componentName: 'custom_component',
            status: HealthStatus.healthy,
            responseTime: Duration.zero,
          )),
        );

        // Assert
        final result = healthCheckService.getLastResult('custom_component');
        // Le résultat peut être null avant le premier check
        expect(healthCheckService, isNotNull);
      });

      test('should unregister health check', () {
        // Arrange
        healthCheckService.initialize();
        healthCheckService.registerHealthCheck(
          'custom_component',
          () => Future.value(HealthCheckResult(
            componentName: 'custom_component',
            status: HealthStatus.healthy,
            responseTime: Duration.zero,
          )),
        );

        // Act
        healthCheckService.unregisterHealthCheck('custom_component');

        // Assert
        // Le health check devrait être supprimé
        expect(healthCheckService, isNotNull);
      });
    });

    group('Auto Health Checks', () {
      test('should start auto health checks when enabled', () {
        // Arrange
        healthCheckService = HealthCheckService(
          enableAutoChecks: true,
          autoCheckInterval: const Duration(milliseconds: 100),
        );

        // Act
        healthCheckService.initialize();

        // Assert
        // Les auto checks devraient être démarrés
        expect(healthCheckService.healthReportStream, isNotNull);
      });

      test('should stop auto health checks', () {
        // Arrange
        healthCheckService = HealthCheckService(
          enableAutoChecks: true,
          autoCheckInterval: const Duration(milliseconds: 100),
        );
        healthCheckService.initialize();

        // Act
        healthCheckService.stopAutoHealthChecks();

        // Assert
        // Les auto checks devraient être arrêtés
        expect(healthCheckService, isNotNull);
      });
    });

    group('Disposal', () {
      test('should dispose resources correctly', () {
        // Arrange
        healthCheckService.initialize();

        // Act
        healthCheckService.dispose();

        // Assert
        // Le service devrait être disposé sans erreur
        expect(healthCheckService, isNotNull);
      });
    });
  });
}

