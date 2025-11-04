import 'dart:developer' as developer;

/// Migration Progress Tracker
///
/// Suit la progression de la migration du système Legacy vers le système Moderne.
///
/// **Responsabilités :**
/// - Tracker l'état de migration de chaque jardin
/// - Calculer les métriques de progression globale
/// - Fournir des rapports de migration
/// - Identifier les blocages et problèmes
class MigrationProgressTracker {
  final Map<String, MigrationStatus> _gardenStatuses = {};
  static const String _logName = 'MigrationProgressTracker';

  /// Enregistre le statut de migration pour un jardin
  void trackGardenMigration({
    required String gardenId,
    required MigrationStatus status,
  }) {
    _gardenStatuses[gardenId] = status;

    developer.log(
      '📊 Jardin $gardenId: ${status.phase.name} (${status.progressPercent}%)',
      name: _logName,
      level: 500,
    );
  }

  /// Récupère le statut de migration d'un jardin
  MigrationStatus? getGardenStatus(String gardenId) {
    return _gardenStatuses[gardenId];
  }

  /// Calcule les métriques globales de migration
  MigrationMetrics calculateMetrics() {
    final metrics = MigrationMetrics();

    for (final status in _gardenStatuses.values) {
      metrics.totalGardens++;

      switch (status.phase) {
        case MigrationPhase.notStarted:
          metrics.notStarted++;
          break;
        case MigrationPhase.inProgress:
          metrics.inProgress++;
          break;
        case MigrationPhase.completed:
          metrics.completed++;
          break;
        case MigrationPhase.failed:
          metrics.failed++;
          break;
      }

      metrics.totalProgressPercent += status.progressPercent;
    }

    if (metrics.totalGardens > 0) {
      metrics.averageProgressPercent =
          metrics.totalProgressPercent / metrics.totalGardens;
    }

    developer.log(
      '📈 Métriques migration: ${metrics.completed}/${metrics.totalGardens} jardins migrés (${metrics.averageProgressPercent.toStringAsFixed(1)}%)',
      name: _logName,
      level: 500,
    );

    return metrics;
  }

  /// Génère un rapport détaillé de migration
  MigrationReport generateReport() {
    final metrics = calculateMetrics();
    final report = MigrationReport(
      timestamp: DateTime.now(),
      metrics: metrics,
      gardenStatuses: Map.from(_gardenStatuses),
    );

    return report;
  }

  /// Marque le début de migration pour un jardin
  void startMigration(String gardenId) {
    trackGardenMigration(
      gardenId: gardenId,
      status: MigrationStatus(
        phase: MigrationPhase.inProgress,
        progressPercent: 0.0,
        startedAt: DateTime.now(),
      ),
    );
  }

  /// Met à jour la progression de migration pour un jardin
  void updateProgress(String gardenId, double progressPercent) {
    final currentStatus = _gardenStatuses[gardenId];
    if (currentStatus != null) {
      trackGardenMigration(
        gardenId: gardenId,
        status: currentStatus.copyWith(
          progressPercent: progressPercent,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Marque la migration comme complétée pour un jardin
  void completeMigration(String gardenId) {
    final currentStatus = _gardenStatuses[gardenId];
    if (currentStatus != null) {
      trackGardenMigration(
        gardenId: gardenId,
        status: currentStatus.copyWith(
          phase: MigrationPhase.completed,
          progressPercent: 100.0,
          completedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Marque la migration comme échouée pour un jardin
  void failMigration(String gardenId, String error) {
    final currentStatus = _gardenStatuses[gardenId];
    if (currentStatus != null) {
      trackGardenMigration(
        gardenId: gardenId,
        status: currentStatus.copyWith(
          phase: MigrationPhase.failed,
          error: error,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }
}

/// Phase de migration
enum MigrationPhase {
  notStarted,
  inProgress,
  completed,
  failed,
}

/// Statut de migration d'un jardin
class MigrationStatus {
  final MigrationPhase phase;
  final double progressPercent;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? updatedAt;
  final String? error;

  MigrationStatus({
    required this.phase,
    required this.progressPercent,
    this.startedAt,
    this.completedAt,
    this.updatedAt,
    this.error,
  });

  MigrationStatus copyWith({
    MigrationPhase? phase,
    double? progressPercent,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? updatedAt,
    String? error,
  }) {
    return MigrationStatus(
      phase: phase ?? this.phase,
      progressPercent: progressPercent ?? this.progressPercent,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() => {
        'phase': phase.name,
        'progressPercent': progressPercent,
        'startedAt': startedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'error': error,
      };
}

/// Métriques globales de migration
class MigrationMetrics {
  int totalGardens = 0;
  int notStarted = 0;
  int inProgress = 0;
  int completed = 0;
  int failed = 0;
  double totalProgressPercent = 0.0;
  double averageProgressPercent = 0.0;

  double get completionRate =>
      totalGardens > 0 ? (completed / totalGardens) * 100 : 0.0;

  double get failureRate =>
      totalGardens > 0 ? (failed / totalGardens) * 100 : 0.0;

  Map<String, dynamic> toJson() => {
        'totalGardens': totalGardens,
        'notStarted': notStarted,
        'inProgress': inProgress,
        'completed': completed,
        'failed': failed,
        'averageProgressPercent': averageProgressPercent,
        'completionRate': completionRate,
        'failureRate': failureRate,
      };
}

/// Rapport de migration
class MigrationReport {
  final DateTime timestamp;
  final MigrationMetrics metrics;
  final Map<String, MigrationStatus> gardenStatuses;

  MigrationReport({
    required this.timestamp,
    required this.metrics,
    required this.gardenStatuses,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'metrics': metrics.toJson(),
        'gardenStatuses': gardenStatuses.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
      };
}
