import 'dart:developer' as developer;
import 'dart:math' as math;

import '../../../../core/models/plant_v2.dart';
import '../entities/analysis_result.dart';
import '../entities/intelligence_report.dart';
import '../entities/plant_condition.dart';
import '../entities/plant_evolution_report.dart';
import '../models/plant_health_status.dart';

/// 🌿 PlantEvolutionTrackerService (Riverpod 3 Ready)
///
/// Rôle dans la chaîne d'intelligence :
/// - Aggrège les rapports d'intelligence (`PlantIntelligenceReport`) avec les
///   statuts santé (`PlantHealthStatus`) pour produire un suivi d'évolution
///   exploitable par les providers Riverpod 3 (`plantEvolutionTrackerProvider`).
/// - Corrèle les mesures clés (température, humidité, lumière, nutriments,
///   stress hydrique) entre analyses et santé globale.
/// - Génère une tendance optimisée (moyenne glissante + taux journalier) et
///   nettoie les séries temporelles (limite par plante configurable, 90 jours).
///
/// Interactions :
/// - Consommé par les providers de santé (`plantHealthStatusProvider`) et les
///   suggestions intelligentes pour contextualiser les recommandations.
/// - Fonctionne sans état global : toutes les dépendances sont injectées via
///   Riverpod (`ref.read`/`ref.watch`).
///
/// Optimisations Riverpod 3 :
/// - Service pur immuable → compatible `Provider.autoDispose`.
/// - Historiques nettoyés pour limiter la mémoire dans les caches légers.
/// - Calculs protégés par `try/catch` pour éviter les erreurs en série temps
///   réel (capteurs manquants, timestamps incohérents).
class PlantEvolutionTrackerService {
  /// Threshold for considering score changes as stable
  /// Default: 1.0 point on a 0-100 scale (1%)
  final double stabilityThreshold;

  /// Enable debug logging
  final bool enableLogging;

  /// Maximum duration of history retained for a plant
  final Duration historyRetention;

  /// Number of points used for the rolling average trend
  final int trendWindowSize;

  const PlantEvolutionTrackerService({
    this.stabilityThreshold = 1.0,
    this.enableLogging = false,
    this.historyRetention = const Duration(days: 90),
    this.trendWindowSize = 5,
  });

  /// Entry-point to track the evolution of a plant using the latest
  /// intelligence report and health status.
  ///
  /// Returns a [PlantEvolutionTrackingResult] containing the delta report,
  /// correlated health comparison and sanitized histories. Returns `null` if no
  /// previous history exists yet.
  PlantEvolutionTrackingResult? trackEvolution({
    required Plant plant,
    required PlantIntelligenceReport currentReport,
    required PlantHealthStatus currentHealthStatus,
    List<PlantIntelligenceReport> intelligenceHistory = const [],
    List<PlantHealthStatus> healthHistory = const [],
  }) {
    _log('🔄 Tracking evolution for plant ${plant.id}');

    if (currentReport.plantId != plant.id) {
      throw ArgumentError('Report does not belong to plant ${plant.id}');
    }

    if (currentHealthStatus.plantId != plant.id) {
      throw ArgumentError('Health status does not belong to plant ${plant.id}');
    }

    final sanitizedReports = updateHistory<PlantIntelligenceReport>(
      history: intelligenceHistory,
      newEntry: currentReport,
      extractTimestamp: (report) => report.generatedAt,
    );

    final sanitizedHealth = updateHistory<PlantHealthStatus>(
      history: healthHistory,
      newEntry: currentHealthStatus,
      extractTimestamp: (status) => status.lastUpdated,
    );

    final previousReport = _findPrevious(
      sanitizedReports,
      currentReport,
      (report) => report.generatedAt,
    );

    if (previousReport == null) {
      _log('ℹ️ No previous report available – skipping evolution comparison');
      return null;
    }

    final previousHealth = _findPrevious(
      sanitizedHealth,
      currentHealthStatus,
      (status) => status.lastUpdated,
    );

    final evolutionReport = compareReports(
      previous: previousReport,
      current: currentReport,
    );

    final healthComparison = compareHealthStatus(
      current: currentHealthStatus,
      previous: previousHealth,
      currentAnalysis: currentReport.analysis,
      previousAnalysis: previousReport.analysis,
    );

    final trendMetrics = computeTrend(sanitizedHealth);

    return PlantEvolutionTrackingResult(
      plant: plant,
      evolution: evolutionReport,
      healthComparison: healthComparison,
      trend: trendMetrics,
      intelligenceHistory: sanitizedReports,
      healthHistory: sanitizedHealth,
    );
  }

  /// Compares two PlantIntelligenceReport instances and returns an evolution report
  ///
  /// [previous] - The older report to compare from
  /// [current] - The newer report to compare to
  ///
  /// Returns a [PlantEvolutionReport] with all detected changes
  ///
  /// Throws [ArgumentError] if reports are for different plants
  PlantEvolutionReport compareReports({
    required PlantIntelligenceReport previous,
    required PlantIntelligenceReport current,
  }) {
    _log('🔄 Starting evolution comparison for plant ${current.plantId}');

    // Validation: ensure we're comparing the same plant
    if (previous.plantId != current.plantId) {
      throw ArgumentError(
        'Cannot compare reports for different plants: '
        '${previous.plantId} vs ${current.plantId}',
      );
    }

    // Calculate score delta
    final deltaScore = current.intelligenceScore - previous.intelligenceScore;

    _log('  📊 Score delta: ${deltaScore.toStringAsFixed(2)} '
        '(previous: ${previous.intelligenceScore}, current: ${current.intelligenceScore})');

    // Determine trend based on threshold
    final trend = _determineTrend(deltaScore);

    _log('  📈 Trend: $trend');

    _ConditionChanges conditionChanges;

    try {
      // Compare individual conditions
      conditionChanges = _compareConditions(
        previous.analysis,
        current.analysis,
      );
    } catch (error, stackTrace) {
      _log('  ⚠️ Error while comparing conditions: $error');
      _log('  ⚠️ Stack: $stackTrace');
      conditionChanges = _ConditionChanges.empty();
    }

    _log('  ✅ Comparison complete');
    _log('    ➕ Improved: ${conditionChanges.improved.length}');
    _log('    ➖ Degraded: ${conditionChanges.degraded.length}');
    _log('    ➡️ Unchanged: ${conditionChanges.unchanged.length}');

    return PlantEvolutionReport(
      plantId: current.plantId,
      previousDate: previous.generatedAt,
      currentDate: current.generatedAt,
      previousScore: previous.intelligenceScore,
      currentScore: current.intelligenceScore,
      deltaScore: deltaScore,
      trend: trend,
      improvedConditions: conditionChanges.improved,
      degradedConditions: conditionChanges.degraded,
      unchangedConditions: conditionChanges.unchanged,
    );
  }

  // ==================== PRIVATE HELPER METHODS ====================

  /// Determines trend based on score delta and threshold
  ///
  /// Returns:
  /// - 'stable' if delta is within ±threshold
  /// - 'up' if delta > threshold
  /// - 'down' if delta < -threshold
  String _determineTrend(double deltaScore) {
    if (deltaScore.abs() < stabilityThreshold) {
      return 'stable';
    } else if (deltaScore > 0) {
      return 'up';
    } else {
      return 'down';
    }
  }

  /// Compares individual conditions between two analyses
  ///
  /// Conditions are compared based on their ConditionStatus enum value.
  /// Status ordering:
  /// - excellent (0) < good (1) < fair (2) < poor (3) < critical (4)
  ///
  /// A condition is considered:
  /// - Improved: if status index decreased (better condition)
  /// - Degraded: if status index increased (worse condition)
  /// - Unchanged: if status index stayed the same
  _ConditionChanges _compareConditions(
    dynamic previousAnalysis,
    dynamic currentAnalysis,
  ) {
    // Handle null analysis gracefully
    if (previousAnalysis == null || currentAnalysis == null) {
      _log('  ⚠️ One or both analyses are null, returning empty changes');
      return _ConditionChanges(
        improved: [],
        degraded: [],
        unchanged: [],
      );
    }

    final improved = <String>[];
    final degraded = <String>[];
    final unchanged = <String>[];

    // Compare each condition type
    _compareCondition(
      'temperature',
      previousAnalysis.temperature,
      currentAnalysis.temperature,
      improved,
      degraded,
      unchanged,
    );

    _compareCondition(
      'humidity',
      previousAnalysis.humidity,
      currentAnalysis.humidity,
      improved,
      degraded,
      unchanged,
    );

    _compareCondition(
      'light',
      previousAnalysis.light,
      currentAnalysis.light,
      improved,
      degraded,
      unchanged,
    );

    _compareCondition(
      'soil',
      previousAnalysis.soil,
      currentAnalysis.soil,
      improved,
      degraded,
      unchanged,
    );

    return _ConditionChanges(
      improved: improved,
      degraded: degraded,
      unchanged: unchanged,
    );
  }

  /// Cleans and updates a history list with retention policy and robust error handling
  List<T> updateHistory<T>({
    required List<T> history,
    required T newEntry,
    required DateTime Function(T entry) extractTimestamp,
  }) {
    try {
      final combined = [...history, newEntry];
      combined.sort((a, b) => extractTimestamp(a).compareTo(
            extractTimestamp(b),
          ));

      final referenceDate = extractTimestamp(newEntry);
      final cutoff = referenceDate.subtract(historyRetention);

      final pruned = combined
          .where((entry) => !extractTimestamp(entry).isBefore(cutoff))
          .toList();

      return List.unmodifiable(pruned);
    } catch (error, stackTrace) {
      _log('⚠️ Failed to update history: $error');
      _log('⚠️ Stack: $stackTrace');
      return [newEntry];
    }
  }

  /// Computes trend metrics (rolling average, rate of change, volatility)
  EvolutionTrendMetrics computeTrend(List<PlantHealthStatus> history) {
    if (history.length < 2) {
      return EvolutionTrendMetrics.empty();
    }

    try {
      final sorted = [...history]
        ..sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));

      final latest = sorted.last;
      final previous = sorted[sorted.length - 2];

      final delta = latest.overallScore - previous.overallScore;
      final direction = _determineTrend(delta);

      final window = sorted.length < trendWindowSize
          ? sorted
          : sorted.sublist(sorted.length - trendWindowSize);

      final rollingAverage = window
              .map((e) => e.overallScore)
              .fold<double>(0.0, (sum, score) => sum + score) /
          window.length;

      final duration = latest.lastUpdated.difference(previous.lastUpdated);
      final days = duration.inMinutes <= 0
          ? 1.0
          : duration.inMinutes / (60 * 24);
      final ratePerDay = delta / days;

      final mean = window.fold<double>(0.0, (sum, status) => sum + status.overallScore) /
          window.length;
      final variance = window.isEmpty
          ? 0.0
          : window
                  .map((status) => math.pow(status.overallScore - mean, 2))
                  .fold<double>(0.0, (sum, value) => sum + (value as num).toDouble()) /
              window.length;
      final volatility = math.sqrt(variance);

      final hasAnomaly = delta.abs() >= stabilityThreshold * 3 ||
          ratePerDay.abs() > stabilityThreshold * 1.5;

      return EvolutionTrendMetrics(
        direction: direction,
        delta: delta,
        rollingAverage: rollingAverage,
        ratePerDay: ratePerDay,
        volatility: volatility,
        hasAnomaly: hasAnomaly,
      );
    } catch (error, stackTrace) {
      _log('⚠️ Failed to compute trend: $error');
      _log('⚠️ Stack: $stackTrace');
      return EvolutionTrendMetrics.empty();
    }
  }

  /// Compares two PlantHealthStatus instances and correlates factors with analysis
  HealthStatusComparison compareHealthStatus({
    required PlantHealthStatus current,
    PlantHealthStatus? previous,
    PlantAnalysisResult? currentAnalysis,
    PlantAnalysisResult? previousAnalysis,
  }) {
    final improved = <PlantHealthFactor>[];
    final degraded = <PlantHealthFactor>[];
    final stable = <PlantHealthFactor>[];
    final scoreDeltas = <PlantHealthFactor, double>{};
    final conditionStatuses = <PlantHealthFactor, ConditionStatus?>{};
    final conditionValues = <PlantHealthFactor, double?>{};

    final previousComponents = {
      if (previous != null)
        for (final component in previous.components) component.factor: component,
    };

    for (final component in current.components) {
      final factor = component.factor;
      final previousComponent = previousComponents[factor];
      final delta = previousComponent == null
          ? 0.0
          : component.score - previousComponent.score;

      scoreDeltas[factor] = delta;

      if (previousComponent == null || delta.abs() < stabilityThreshold) {
        stable.add(factor);
      } else if (delta > 0) {
        improved.add(factor);
      } else {
        degraded.add(factor);
      }

      final currentCondition = _conditionForFactor(factor, currentAnalysis);
      conditionStatuses[factor] = currentCondition?.status;
      conditionValues[factor] = currentCondition?.value;
    }

    return HealthStatusComparison(
      currentLevel: current.level,
      previousLevel: previous?.level,
      improvedFactors: improved,
      degradedFactors: degraded,
      stableFactors: stable,
      scoreDeltas: scoreDeltas,
      conditionStatuses: conditionStatuses,
      conditionValues: conditionValues,
      previousAnalysisTimestamp: previousAnalysis?.analyzedAt,
      currentAnalysisTimestamp: currentAnalysis?.analyzedAt,
    );
  }

  /// Compares a single condition and categorizes it
  void _compareCondition(
    String conditionName,
    PlantCondition? previousCondition,
    PlantCondition? currentCondition,
    List<String> improved,
    List<String> degraded,
    List<String> unchanged,
  ) {
    // Handle null conditions gracefully
    if (previousCondition == null || currentCondition == null) {
      _log('  ⚠️ $conditionName: null condition detected, skipping comparison');
      return;
    }

    // Compare status indices
    // ConditionStatus enum: excellent (0) < good (1) < fair (2) < poor (3) < critical (4)
    // Lower index = better condition, higher index = worse condition
    final previousIndex = previousCondition.status.index;
    final currentIndex = currentCondition.status.index;

    _log(
        '  🔍 $conditionName: ${previousCondition.status.name} ($previousIndex) → '
        '${currentCondition.status.name} ($currentIndex)');

    if (currentIndex < previousIndex) {
      // Index decreased = condition improved (went from worse to better)
      improved.add(conditionName);
      _log('    ✅ $conditionName improved');
    } else if (currentIndex > previousIndex) {
      // Index increased = condition degraded (went from better to worse)
      degraded.add(conditionName);
      _log('    ⚠️ $conditionName degraded');
    } else {
      unchanged.add(conditionName);
      _log('    ➡️ $conditionName unchanged');
    }
  }

  T? _findPrevious<T>(
    List<T> items,
    T current,
    DateTime Function(T entry) extractTimestamp,
  ) {
    if (items.length < 2) {
      return null;
    }

    final sorted = [...items]
      ..sort((a, b) => extractTimestamp(a).compareTo(
            extractTimestamp(b),
          ));

    final currentIndex = sorted.indexWhere(
      (element) => identical(element, current) ||
          extractTimestamp(element) == extractTimestamp(current),
    );

    if (currentIndex <= 0) {
      return null;
    }

    return sorted[currentIndex - 1];
  }

  PlantCondition? _conditionForFactor(
    PlantHealthFactor factor,
    PlantAnalysisResult? analysis,
  ) {
    if (analysis == null) {
      return null;
    }

    switch (factor) {
      case PlantHealthFactor.humidity:
        return analysis.humidity;
      case PlantHealthFactor.light:
        return analysis.light;
      case PlantHealthFactor.temperature:
        return analysis.temperature;
      case PlantHealthFactor.nutrients:
        return analysis.soil;
      case PlantHealthFactor.soilMoisture:
        return analysis.soil;
      case PlantHealthFactor.waterStress:
        return analysis.humidity;
      case PlantHealthFactor.pestPressure:
        return null;
    }
  }

  /// Logs a message if logging is enabled
  void _log(String message) {
    if (enableLogging) {
      developer.log(
        message,
        name: 'PlantEvolutionTrackerService',
      );
    }
  }
}

/// Internal class to hold condition comparison results
class _ConditionChanges {
  final List<String> improved;
  final List<String> degraded;
  final List<String> unchanged;

  _ConditionChanges({
    required this.improved,
    required this.degraded,
    required this.unchanged,
  });

  factory _ConditionChanges.empty() => _ConditionChanges(
        improved: const [],
        degraded: const [],
        unchanged: const [],
      );
}

/// Result object returned by [trackEvolution]
class PlantEvolutionTrackingResult {
  final Plant plant;
  final PlantEvolutionReport evolution;
  final HealthStatusComparison healthComparison;
  final EvolutionTrendMetrics trend;
  final List<PlantIntelligenceReport> intelligenceHistory;
  final List<PlantHealthStatus> healthHistory;

  const PlantEvolutionTrackingResult({
    required this.plant,
    required this.evolution,
    required this.healthComparison,
    required this.trend,
    required this.intelligenceHistory,
    required this.healthHistory,
  });

  bool get hasHistory => intelligenceHistory.length > 1;
}

/// Comparative metrics between two health statuses
class HealthStatusComparison {
  final PlantHealthLevel currentLevel;
  final PlantHealthLevel? previousLevel;
  final List<PlantHealthFactor> improvedFactors;
  final List<PlantHealthFactor> degradedFactors;
  final List<PlantHealthFactor> stableFactors;
  final Map<PlantHealthFactor, double> scoreDeltas;
  final Map<PlantHealthFactor, ConditionStatus?> conditionStatuses;
  final Map<PlantHealthFactor, double?> conditionValues;
  final DateTime? previousAnalysisTimestamp;
  final DateTime? currentAnalysisTimestamp;

  const HealthStatusComparison({
    required this.currentLevel,
    required this.previousLevel,
    required this.improvedFactors,
    required this.degradedFactors,
    required this.stableFactors,
    required this.scoreDeltas,
    required this.conditionStatuses,
    required this.conditionValues,
    required this.previousAnalysisTimestamp,
    required this.currentAnalysisTimestamp,
  });

  bool get hasLevelChanged =>
      previousLevel != null && previousLevel != currentLevel;
}

/// Trend metrics computed on sanitized health history
class EvolutionTrendMetrics {
  final String direction;
  final double delta;
  final double rollingAverage;
  final double ratePerDay;
  final double volatility;
  final bool hasAnomaly;

  const EvolutionTrendMetrics({
    required this.direction,
    required this.delta,
    required this.rollingAverage,
    required this.ratePerDay,
    required this.volatility,
    required this.hasAnomaly,
  });

  factory EvolutionTrendMetrics.empty() => const EvolutionTrendMetrics(
        direction: 'unknown',
        delta: 0.0,
        rollingAverage: 0.0,
        ratePerDay: 0.0,
        volatility: 0.0,
        hasAnomaly: false,
      );
}
