
import '../../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/services/migration/migration_orchestrator.dart';
import 'package:permacalendar/core/services/migration/migration_models.dart';
import 'package:permacalendar/core/services/migration/dual_write_service.dart';
import 'package:permacalendar/core/services/migration/read_switch_service.dart';
import 'package:permacalendar/core/services/migration/data_integrity_validator.dart';
import 'package:permacalendar/core/services/migration/legacy_cleanup_service.dart';
import 'package:permacalendar/core/services/migration/data_archival_service.dart';
import 'package:permacalendar/core/services/migration/migration_health_checker.dart';

void main() {
  group('MigrationOrchestrator', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should be instantiable via provider', () {
      // Act
      final orchestrator = container.read(migrationOrchestratorProvider);

      // Assert
      expect(orchestrator, isNotNull);
      expect(orchestrator, isA<MigrationOrchestrator>());
    });

    test('should have default configuration', () {
      // Arrange
      final orchestrator = container.read(migrationOrchestratorProvider);

      // Assert
      expect(orchestrator.config, isNotNull);
      expect(orchestrator.config.batchSize, equals(10));
      expect(orchestrator.config.maxErrorRate, equals(0.2));
      expect(orchestrator.config.minSuccessRate, equals(0.95));
      expect(orchestrator.config.autoCleanupLegacy, isTrue);
    });

    test('should start in notStarted phase', () {
      // Arrange
      final orchestrator = container.read(migrationOrchestratorProvider);

      // Assert
      expect(orchestrator.currentPhase, equals(MigrationPhase.notStarted));
    });

    test('should allow custom configuration', () {
      // Arrange
      final customConfig = MigrationConfig.conservative();
      final orchestrator = MigrationOrchestrator(config: customConfig);

      // Assert
      expect(orchestrator.config.batchSize, equals(5));
      expect(orchestrator.config.maxErrorRate, equals(0.1));
      expect(orchestrator.config.minSuccessRate, equals(0.98));
      expect(orchestrator.config.autoCleanupLegacy, isFalse);
    });

    test('should have dual write disabled by default', () {
      // Arrange
      final orchestrator = container.read(migrationOrchestratorProvider);

      // Assert
      expect(orchestrator.isDualWriteEnabled, isFalse);
    });

    test('should have legacy reads by default', () {
      // Arrange
      final orchestrator = container.read(migrationOrchestratorProvider);

      // Assert
      expect(orchestrator.isReadingFromModern, isFalse);
    });

    test('should return progress with default values', () {
      // Arrange
      final orchestrator = container.read(migrationOrchestratorProvider);

      // Act
      final progress = orchestrator.getCurrentProgress();

      // Assert
      expect(progress, isNotNull);
      expect(progress.phase, equals(MigrationPhase.notStarted));
      expect(progress.totalItems, equals(0));
      expect(progress.processedItems, equals(0));
      expect(progress.successfulItems, equals(0));
      expect(progress.failedItems, equals(0));
      expect(progress.percentComplete, equals(0.0));
    });

    test('should allow dependency injection', () {
      // Arrange
      final customDualWrite = DualWriteService();
      final customReadSwitch = ReadSwitchService();
      final customValidator = DataIntegrityValidator();
      final customCleanup = LegacyCleanupService();
      final customArchival = DataArchivalService();
      final customHealth = MigrationHealthChecker();
      final customConfig = MigrationConfig.aggressive();

      // Act
      final orchestrator = MigrationOrchestrator(
        dualWriteService: customDualWrite,
        readSwitchService: customReadSwitch,
        integrityValidator: customValidator,
        cleanupService: customCleanup,
        archivalService: customArchival,
        healthChecker: customHealth,
        config: customConfig,
      );

      // Assert
      expect(orchestrator, isNotNull);
      expect(orchestrator.config.batchSize, equals(20));
      expect(orchestrator.config.autoCleanupLegacy, isTrue);
    });

    test('should provide health report asynchronously', () async {
      // Arrange
      final orchestrator = container.read(migrationOrchestratorProvider);

      // Act
      final healthReport = await orchestrator.getHealthReport();

      // Assert
      expect(healthReport, isNotNull);
      expect(healthReport, isA<MigrationHealthReport>());
      expect(healthReport.timestamp, isNotNull);
      expect(healthReport.legacySystemHealth, isA<SystemHealth>());
      expect(healthReport.modernSystemHealth, isA<SystemHealth>());
    });
  });
}


