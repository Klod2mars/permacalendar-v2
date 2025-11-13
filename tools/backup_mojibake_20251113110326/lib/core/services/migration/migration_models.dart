import 'package:freezed_annotation/freezed_annotation.dart';

part 'migration_models.freezed.dart';

/// Phases de la migration
enum MigrationPhase {
  notStarted,
  preparation,
  validation,
  transition,
  switching,
  cleanup,
  completed,
  rolledBack,
  failed,
}

/// État de santé du système
enum SystemHealth {
  healthy,
  degraded,
  unhealthy,
  unknown,
}

/// Configuration de la migration
@freezed
class MigrationConfig with _$MigrationConfig {
  const factory MigrationConfig({
    @Default(10) int batchSize,
    @Default(Duration(seconds: 2)) Duration pauseBetweenBatches,
    @Default(0.2) double maxErrorRate,
    @Default(0.95) double minSuccessRate,
    @Default(Duration(hours: 24)) Duration monitoringPeriod,
    @Default(true) bool autoCleanupLegacy,
    @Default(true) bool enableRollback,
    @Default(true) bool validateAfterEachBatch,
  }) = _MigrationConfig;

  factory MigrationConfig.defaultConfig() => const MigrationConfig();

  factory MigrationConfig.conservative() => const MigrationConfig(
        batchSize: 5,
        pauseBetweenBatches: Duration(seconds: 5),
        maxErrorRate: 0.1,
        minSuccessRate: 0.98,
        monitoringPeriod: Duration(hours: 48),
        autoCleanupLegacy: false,
      );

  factory MigrationConfig.aggressive() => const MigrationConfig(
        batchSize: 20,
        pauseBetweenBatches: Duration(seconds: 1),
        maxErrorRate: 0.3,
        minSuccessRate: 0.90,
        monitoringPeriod: Duration(hours: 12),
        autoCleanupLegacy: true,
      );
}

/// Résultat d'une migration
@freezed
class MigrationResult with _$MigrationResult {
  const factory MigrationResult({
    required bool success,
    required MigrationPhase phase,
    required String message,
    required Duration duration,
    required Map<String, dynamic> details,
    required DateTime timestamp,
  }) = _MigrationResult;

  const MigrationResult._();

  Map<String, dynamic> toJson() => {
        'success': success,
        'phase': phase.toString(),
        'message': message,
        'duration': duration.inMilliseconds,
        'details': details,
        'timestamp': timestamp.toIso8601String(),
      };
}

/// Résultat d'une phase de migration
@freezed
class PhaseResult with _$PhaseResult {
  const factory PhaseResult({
    required bool success,
    required MigrationPhase phase,
    required String message,
    required Duration duration,
    Map<String, dynamic>? details,
  }) = _PhaseResult;

  const PhaseResult._();

  Map<String, dynamic> toJson() => {
        'success': success,
        'phase': phase.toString(),
        'message': message,
        'duration': duration.inMilliseconds,
        'details': details,
      };
}

/// Résultat d'une migration par batch
@freezed
class MigrationBatchResult with _$MigrationBatchResult {
  const factory MigrationBatchResult({
    required int totalItems,
    required List<String> successfulMigrations,
    required Map<String, String> failedMigrations,
    required Duration duration,
    required double successRate,
    String? error,
  }) = _MigrationBatchResult;

  const MigrationBatchResult._();

  Map<String, dynamic> toJson() => {
        'totalItems': totalItems,
        'successfulMigrations': successfulMigrations,
        'failedMigrations': failedMigrations,
        'duration': duration.inMilliseconds,
        'successRate': successRate,
        'error': error,
      };
}

/// Progression de la migration
@freezed
class MigrationProgress with _$MigrationProgress {
  const factory MigrationProgress({
    required MigrationPhase phase,
    required int totalItems,
    required int processedItems,
    required int successfulItems,
    required int failedItems,
    required double percentComplete,
    required Duration estimatedTimeRemaining,
  }) = _MigrationProgress;

  const MigrationProgress._();

  Map<String, dynamic> toJson() => {
        'phase': phase.toString(),
        'totalItems': totalItems,
        'processedItems': processedItems,
        'successfulItems': successfulItems,
        'failedItems': failedItems,
        'percentComplete': percentComplete,
        'estimatedTimeRemaining': estimatedTimeRemaining.inSeconds,
      };
}

/// Rapport de santé de la migration
@freezed
class MigrationHealthReport with _$MigrationHealthReport {
  const factory MigrationHealthReport({
    required bool isHealthy,
    required DateTime timestamp,
    required SystemHealth legacySystemHealth,
    required SystemHealth modernSystemHealth,
    required double dataCoherence,
    required double errorRate,
    required List<String> issues,
    Map<String, dynamic>? metrics,
  }) = _MigrationHealthReport;

  const MigrationHealthReport._();

  Map<String, dynamic> toJson() => {
        'isHealthy': isHealthy,
        'timestamp': timestamp.toIso8601String(),
        'legacySystemHealth': legacySystemHealth.toString(),
        'modernSystemHealth': modernSystemHealth.toString(),
        'dataCoherence': dataCoherence,
        'errorRate': errorRate,
        'issues': issues,
        'metrics': metrics,
      };
}

/// Résultat de validation de cohérence
@freezed
class CoherenceResult with _$CoherenceResult {
  const factory CoherenceResult({
    required bool isCoherent,
    required int checkedItems,
    required int coherentItems,
    required int incoherentItems,
    required List<String> issues,
    required double coherencePercentage,
  }) = _CoherenceResult;

  const CoherenceResult._();

  int get issuesCount => issues.length;

  Map<String, dynamic> toJson() => {
        'isCoherent': isCoherent,
        'checkedItems': checkedItems,
        'coherentItems': coherentItems,
        'incoherentItems': incoherentItems,
        'issues': issues,
        'coherencePercentage': coherencePercentage,
      };
}

/// Événement de migration pour le monitoring
@freezed
class MigrationEvent with _$MigrationEvent {
  const factory MigrationEvent({
    required String eventType,
    required DateTime timestamp,
    required MigrationPhase phase,
    String? gardenId,
    String? message,
    Map<String, dynamic>? metadata,
  }) = _MigrationEvent;

  const MigrationEvent._();

  Map<String, dynamic> toJson() => {
        'eventType': eventType,
        'timestamp': timestamp.toIso8601String(),
        'phase': phase.toString(),
        'gardenId': gardenId,
        'message': message,
        'metadata': metadata,
      };
}


