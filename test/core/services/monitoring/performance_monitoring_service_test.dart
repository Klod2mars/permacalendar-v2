
import '../../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/services/monitoring/performance_monitoring_service.dart';

void main() {
  group('PerformanceMonitoringService', () {
    late PerformanceMonitoringService service;

    setUp(() {
      service = PerformanceMonitoringService(
        maxMeasurements: 100,
        enableLogging: false, // DÃ©sactiver les logs pour les tests
        reportInterval: const Duration(seconds: 1),
      );
    });

    tearDown(() {
      service.dispose();
    });

    group('Initialization', () {
      test('should initialize successfully', () {
        // Act
        service.initialize();

        // Assert
        expect(service, isNotNull);
      });

      test('should set app start time on initialization', () {
        // Act
        service.initialize();

        // Assert
        final metrics = service.getCurrentMetrics();
        expect(metrics, isNotNull);
        expect(metrics['totalMeasurements'], isA<int>());
      });
    });

    group('Measurement Recording', () {
      test('should start and end measurement successfully', () {
        // Arrange
        service.initialize();

        // Act
        final id = service.startMeasurement(
          type: MetricType.dataFetch,
          name: 'test_operation',
        );
        expect(id, isNotEmpty);

        // Wait a bit
        Future.delayed(const Duration(milliseconds: 10));

        final measurement = service.endMeasurement(id);

        // Assert
        expect(measurement, isNotNull);
        expect(measurement!.type, equals(MetricType.dataFetch));
        expect(measurement.name, isNotEmpty);
        expect(measurement.duration, isA<Duration>());
      });

      test('should return null when ending non-existent measurement', () {
        // Arrange
        service.initialize();

        // Act
        final measurement = service.endMeasurement('non_existent_id');

        // Assert
        expect(measurement, isNull);
      });

      test('should handle empty id from rate limiting', () {
        // Arrange
        service.initialize();

        // Act
        final measurement = service.endMeasurement('');

        // Assert
        expect(measurement, isNull);
      });

      test('should record app startup', () {
        // Arrange
        service.initialize();

        // Act
        service.recordAppStartup();

        // Assert
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], greaterThan(0));
      });

      test('should record screen load', () {
        // Arrange
        service.initialize();

        // Act
        service.recordScreenLoad('TestScreen', const Duration(milliseconds: 100));

        // Assert
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], greaterThan(0));
      });

      test('should record operation duration', () {
        // Arrange
        service.initialize();

        // Act
        service.recordOperationDuration(
          type: MetricType.dataWrite,
          name: 'test_write',
          duration: const Duration(milliseconds: 50),
        );

        // Assert
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], greaterThan(0));
      });

      test('should record memory usage', () {
        // Arrange
        service.initialize();

        // Act
        service.recordMemoryUsage(
          memoryBytes: 1024 * 1024, // 1 MB
        );

        // Assert
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], greaterThan(0));
      });
    });

    group('Async and Sync Measurement', () {
      test('should measure async operation', () async {
        // Arrange
        service.initialize();

        // Act
        final result = await service.measureAsync<int>(
          type: MetricType.computation,
          name: 'async_test',
          operation: () async {
            await Future.delayed(const Duration(milliseconds: 10));
            return 42;
          },
        );

        // Assert
        expect(result, equals(42));
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], greaterThan(0));
      });

      test('should measure sync operation', () {
        // Arrange
        service.initialize();

        // Act
        final result = service.measureSync<int>(
          type: MetricType.computation,
          name: 'sync_test',
          operation: () => 42,
        );

        // Assert
        expect(result, equals(42));
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], greaterThan(0));
      });

      test('should record error in async operation', () async {
        // Arrange
        service.initialize();

        // Act & Assert
        try {
          await service.measureAsync<void>(
            type: MetricType.computation,
            name: 'async_error_test',
            operation: () async {
              throw Exception('Test error');
            },
          );
          fail('Should have thrown an exception');
        } catch (e) {
          // L'erreur est attendue
          expect(e, isA<Exception>());
        }

        // VÃ©rifier que l'erreur a Ã©tÃ© enregistrÃ©e
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], greaterThan(0));
      });

      test('should record error in sync operation', () {
        // Arrange
        service.initialize();

        // Act & Assert
        expect(
          () => service.measureSync<void>(
            type: MetricType.computation,
            name: 'sync_error_test',
            operation: () {
              throw Exception('Test error');
            },
          ),
          throwsException,
        );

        // VÃ©rifier que l'erreur a Ã©tÃ© enregistrÃ©e
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], greaterThan(0));
      });
    });

    group('Performance Thresholds', () {
      test('should detect slow app startup', () {
        // Arrange
        service.initialize();

        // Act
        service.recordOperationDuration(
          type: MetricType.appStartup,
          name: 'slow_startup',
          duration: const Duration(seconds: 3), // > 2s threshold
        );

        // Assert
        final report = service.generateReport();
        expect(report.slowOperations, isNotEmpty);
      });

      test('should detect slow screen load', () {
        // Arrange
        service.initialize();

        // Act
        service.recordScreenLoad(
          'SlowScreen',
          const Duration(milliseconds: 600), // > 500ms threshold
        );

        // Assert
        final report = service.generateReport();
        expect(report.slowOperations, isNotEmpty);
      });

      test('should detect slow data fetch', () {
        // Arrange
        service.initialize();

        // Act
        service.recordOperationDuration(
          type: MetricType.dataFetch,
          name: 'slow_fetch',
          duration: const Duration(milliseconds: 300), // > 200ms threshold
        );

        // Assert
        final report = service.generateReport();
        expect(report.slowOperations, isNotEmpty);
      });
    });

    group('Report Generation', () {
      test('should generate report with measurements', () {
        // Arrange
        service.initialize();
        service.recordScreenLoad('TestScreen', const Duration(milliseconds: 100));
        service.recordOperationDuration(
          type: MetricType.dataFetch,
          name: 'test_fetch',
          duration: const Duration(milliseconds: 50),
        );

        // Act
        final report = service.generateReport();

        // Assert
        expect(report, isNotNull);
        expect(report.generatedAt, isA<DateTime>());
        expect(report.reportPeriod, isA<Duration>());
        expect(report.statsByType, isA<Map<MetricType, PerformanceStats>>());
        expect(report.slowOperations, isA<List<PerformanceMeasurement>>());
        expect(report.systemMetrics, isA<Map<String, dynamic>>());
      });

      test('should generate empty report when no measurements', () {
        // Arrange
        service.initialize();

        // Act
        final report = service.generateReport();

        // Assert
        expect(report, isNotNull);
        expect(report.statsByType, isEmpty);
        expect(report.slowOperations, isEmpty);
      });

      test('should filter measurements by period', () {
        // Arrange
        service.initialize();
        service.recordScreenLoad('TestScreen', const Duration(milliseconds: 100));

        // Act
        final report = service.generateReport(period: const Duration(seconds: 1));

        // Assert
        expect(report, isNotNull);
        expect(report.reportPeriod, equals(const Duration(seconds: 1)));
      });

      test('should calculate stats correctly', () {
        // Arrange
        service.initialize();
        // Enregistrer plusieurs mesures du mÃªme type
        for (int i = 0; i < 5; i++) {
          service.recordOperationDuration(
            type: MetricType.dataFetch,
            name: 'test_fetch_$i',
            duration: Duration(milliseconds: 50 + i * 10),
          );
        }

        // Act
        final report = service.generateReport();

        // Assert
        expect(report.statsByType.containsKey(MetricType.dataFetch), isTrue);
        final stats = report.statsByType[MetricType.dataFetch]!;
        expect(stats.count, equals(5));
        expect(stats.averageDuration, isA<Duration>());
        expect(stats.minDuration, isA<Duration>());
        expect(stats.maxDuration, isA<Duration>());
        expect(stats.slowCount, isA<int>());
        expect(stats.slowPercentage, isA<double>());
      });
    });

    group('Current Metrics', () {
      test('should return current metrics', () {
        // Arrange
        service.initialize();
        service.recordScreenLoad('TestScreen', const Duration(milliseconds: 100));

        // Act
        final metrics = service.getCurrentMetrics();

        // Assert
        expect(metrics, isA<Map<String, dynamic>>());
        expect(metrics['totalMeasurements'], isA<int>());
        expect(metrics['activeMeasurements'], isA<int>());
        expect(metrics['recentReport'], isA<Map<String, dynamic>>());
      });

      test('should track active measurements', () async {
        // Arrange
        service.initialize();

        // Act - Ajouter un petit dÃ©lai pour Ã©viter le rate limiting
        final id1 = service.startMeasurement(
          type: MetricType.dataFetch,
          name: 'test1',
        );
        await Future.delayed(const Duration(milliseconds: 2));
        final id2 = service.startMeasurement(
          type: MetricType.dataWrite,
          name: 'test2',
        );

        final metrics = service.getCurrentMetrics();

        // Assert - VÃ©rifier qu'au moins une mesure est active
        // (le rate limiting peut empÃªcher la deuxiÃ¨me)
        expect(metrics['activeMeasurements'], greaterThanOrEqualTo(1));

        // Cleanup
        if (id1.isNotEmpty) service.endMeasurement(id1);
        if (id2.isNotEmpty) service.endMeasurement(id2);
      });
    });

    group('Measurement Limits', () {
      test('should limit measurements to maxMeasurements', () {
        // Arrange
        service = PerformanceMonitoringService(
          maxMeasurements: 5,
          enableLogging: false,
        );
        service.initialize();

        // Act - Enregistrer plus de mesures que la limite
        for (int i = 0; i < 10; i++) {
          service.recordScreenLoad('Screen$i', const Duration(milliseconds: 100));
        }

        // Assert
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], lessThanOrEqualTo(5));
      });
    });

    group('Clear and Reset', () {
      test('should clear old measurements', () {
        // Arrange
        service.initialize();
        service.recordScreenLoad('TestScreen', const Duration(milliseconds: 100));

        // Act
        service.clearOldMeasurements(olderThan: const Duration(seconds: 1));

        // Assert
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], isA<int>());
      });

      test('should reset all measurements', () {
        // Arrange
        service.initialize();
        service.recordScreenLoad('TestScreen', const Duration(milliseconds: 100));
        service.recordAppStartup();

        // Act
        service.resetMeasurements();

        // Assert
        final metrics = service.getCurrentMetrics();
        expect(metrics['totalMeasurements'], equals(0));
        expect(metrics['activeMeasurements'], equals(0));
      });
    });

    group('Error Handling', () {
      test('should handle errors gracefully in recordAppStartup', () {
        // Arrange
        service = PerformanceMonitoringService(
          maxMeasurements: -1, // Invalid value to trigger error
          enableLogging: false,
        );

        // Act & Assert - Ne devrait pas crasher
        expect(() => service.recordAppStartup(), returnsNormally);
      });

      test('should handle errors gracefully in recordScreenLoad', () {
        // Arrange
        service.initialize();

        // Act & Assert - Ne devrait pas crasher mÃªme avec des valeurs invalides
        expect(
          () => service.recordScreenLoad('', const Duration(seconds: -1)),
          returnsNormally,
        );
      });

      test('should handle errors gracefully in generateReport', () {
        // Arrange
        service.initialize();

        // Act
        final report = service.generateReport(period: const Duration(seconds: -1));

        // Assert - Devrait retourner un rapport valide mÃªme en cas d'erreur
        expect(report, isNotNull);
        expect(report.statsByType, isA<Map<MetricType, PerformanceStats>>());
      });
    });

    group('Report Stream', () {
      test('should provide report stream when logging enabled', () async {
        // Arrange
        service = PerformanceMonitoringService(
          enableLogging: true,
          reportInterval: const Duration(milliseconds: 100),
        );
        service.initialize();

        // Act
        final stream = service.reportStream;

        // Assert
        expect(stream, isNotNull);

        // Attendre un rapport
        await Future.delayed(const Duration(milliseconds: 150));
      });

      test('should not provide report stream when logging disabled', () {
        // Arrange
        service = PerformanceMonitoringService(
          enableLogging: false,
        );
        service.initialize();

        // Act
        final stream = service.reportStream;

        // Assert
        expect(stream, isNull);
      });
    });

    group('System Metrics', () {
      test('should collect system metrics', () {
        // Arrange
        service.initialize();
        service.recordScreenLoad('TestScreen', const Duration(milliseconds: 100));

        // Act
        final report = service.generateReport();

        // Assert
        expect(report.systemMetrics, isA<Map<String, dynamic>>());
        expect(report.systemMetrics.containsKey('platform'), isTrue);
        expect(report.systemMetrics.containsKey('uptimeSeconds'), isTrue);
        expect(report.systemMetrics.containsKey('totalScreenLoads'), isTrue);
        expect(report.systemMetrics.containsKey('totalDataOperations'), isTrue);
      });
    });

    group('Disposal', () {
      test('should dispose resources correctly', () {
        // Arrange
        service.initialize();
        service.recordScreenLoad('TestScreen', const Duration(milliseconds: 100));

        // Act
        service.dispose();

        // Assert - Ne devrait pas crasher
        expect(service, isNotNull);
      });

      test('should handle multiple dispose calls', () {
        // Arrange
        service.initialize();

        // Act & Assert - Ne devrait pas crasher
        service.dispose();
        expect(() => service.dispose(), returnsNormally);
      });
    });

    group('PerformanceMeasurement', () {
      test('should calculate duration correctly', () {
        // Arrange
        final startTime = DateTime.now();
        final endTime = startTime.add(const Duration(milliseconds: 100));

        // Act
        final measurement = PerformanceMeasurement(
          id: 'test',
          type: MetricType.computation,
          name: 'test',
          startTime: startTime,
          endTime: endTime,
        );

        // Assert
        expect(measurement.duration, equals(const Duration(milliseconds: 100)));
      });

      test('should detect slow performance correctly', () {
        // Arrange
        final startTime = DateTime.now();
        final endTime = startTime.add(const Duration(seconds: 3)); // > 2s threshold

        // Act
        final measurement = PerformanceMeasurement(
          id: 'test',
          type: MetricType.appStartup,
          name: 'test',
          startTime: startTime,
          endTime: endTime,
        );

        // Assert
        expect(measurement.isSlowPerformance, isTrue);
      });

      test('should serialize to JSON correctly', () {
        // Arrange
        final startTime = DateTime.now();
        final endTime = startTime.add(const Duration(milliseconds: 100));

        // Act
        final measurement = PerformanceMeasurement(
          id: 'test',
          type: MetricType.computation,
          name: 'test',
          startTime: startTime,
          endTime: endTime,
          metadata: {'key': 'value'},
        );

        final json = measurement.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('test'));
        expect(json['name'], equals('test'));
        expect(json['durationMs'], equals(100));
        expect(json['isSlowPerformance'], isA<bool>());
        expect(json['metadata'], isA<Map<String, dynamic>>());
      });
    });

    group('PerformanceStats', () {
      test('should serialize to JSON correctly', () {
        // Arrange
        final stats = PerformanceStats(
          count: 10,
          totalDuration: const Duration(seconds: 1),
          averageDuration: const Duration(milliseconds: 100),
          minDuration: const Duration(milliseconds: 50),
          maxDuration: const Duration(milliseconds: 200),
          slowCount: 2,
          slowPercentage: 20.0,
        );

        // Act
        final json = stats.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['count'], equals(10));
        expect(json['totalDurationMs'], equals(1000));
        expect(json['averageDurationMs'], equals(100));
        expect(json['minDurationMs'], equals(50));
        expect(json['maxDurationMs'], equals(200));
        expect(json['slowCount'], equals(2));
        expect(json['slowPercentage'], equals(20.0));
      });
    });

    group('PerformanceReport', () {
      test('should serialize to JSON correctly', () {
        // Arrange
        final report = PerformanceReport(
          generatedAt: DateTime.now(),
          reportPeriod: const Duration(hours: 1),
          statsByType: {},
          slowOperations: [],
          systemMetrics: {'test': 'value'},
        );

        // Act
        final json = report.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['generatedAt'], isA<String>());
        expect(json['reportPeriodSeconds'], equals(3600));
        expect(json['statsByType'], isA<Map<String, dynamic>>());
        expect(json['slowOperationsCount'], equals(0));
        expect(json['systemMetrics'], isA<Map<String, dynamic>>());
      });
    });
  });
}


