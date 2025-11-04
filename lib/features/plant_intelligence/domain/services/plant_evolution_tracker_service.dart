import 'dart:developer' as developer;
import '../entities/intelligence_report.dart';
import '../entities/plant_evolution_report.dart';
import '../entities/plant_condition.dart';

/// 🔄 CURSOR PROMPT A5 - Plant Evolution Tracker Service
///
/// Compares two PlantIntelligenceReport instances and computes a structured
/// evolution delta (PlantEvolutionReport). This service helps track:
/// - Score progression/regression
/// - Individual condition changes
/// - Overall health trends
///
/// **Philosophy:**
/// This is a pure, stateless service with no side effects.
/// It uses defensive programming to handle missing/null values gracefully.
///
/// **Threshold Logic:**
/// - Changes within ±1.0 point are considered "stable"
/// - Changes > 1.0 are "up" (improvement)
/// - Changes < -1.0 are "down" (degradation)
///
/// **Architecture:**
/// - Pure domain service with no external dependencies
/// - Immutable data structures
/// - Fully testable
class PlantEvolutionTrackerService {
  /// Threshold for considering score changes as stable
  /// Default: 1.0 point on a 0-100 scale (1%)
  final double stabilityThreshold;

  /// Enable debug logging
  final bool enableLogging;

  PlantEvolutionTrackerService({
    this.stabilityThreshold = 1.0,
    this.enableLogging = false,
  });

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

    // Compare individual conditions
    final conditionChanges = _compareConditions(
      previous.analysis,
      current.analysis,
    );

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
}
