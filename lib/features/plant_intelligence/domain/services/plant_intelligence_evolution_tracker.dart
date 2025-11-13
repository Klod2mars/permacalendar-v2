import 'dart:developer' as developer;
import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/intelligence_report.dart';
import '../entities/recommendation.dart';

part 'plant_intelligence_evolution_tracker.freezed.dart';
part 'plant_intelligence_evolution_tracker.g.dart';

/// ðŸ”„ CURSOR PROMPT A3 - Intelligence Evolution Tracker
///
/// Tracks changes between two intelligence analysis sessions for the same garden
/// to detect plant health evolution.
///
/// **Philosophy:**
/// This service provides pure comparison logic without side effects.
/// It's designed to help users understand how their plants are progressing over time.
///
/// **Responsibilities:**
/// - Compare two IntelligenceReport objects (old vs new)
/// - Detect health improvements or degradations
/// - Track recommendation changes
/// - Calculate evolution metrics
///
/// **Architecture:**
/// - Pure domain service with no dependencies
/// - Immutable data structures
/// - Optional debug logging
class PlantIntelligenceEvolutionTracker {
  /// Enable/disable debug logging
  final bool enableLogging;

  /// Tolerance threshold for ignoring minor deltas (0-1)
  final double toleranceThreshold;

  PlantIntelligenceEvolutionTracker({
    this.enableLogging = false,
    this.toleranceThreshold = 0.01, // 1% by default
  });

  /// Compares two intelligence reports and returns a summary of changes
  ///
  /// [oldReport] - Previous intelligence report
  /// [newReport] - Current intelligence report
  ///
  /// Returns an [IntelligenceEvolutionSummary] with all detected changes
  ///
  /// Throws [ArgumentError] if reports are for different plants
  IntelligenceEvolutionSummary compareReports(
    PlantIntelligenceReport oldReport,
    PlantIntelligenceReport newReport,
  ) {
    _log('ðŸ”„ Starting report comparison for plant ${newReport.plantId}');

    // Validation: ensure we're comparing the same plant
    if (oldReport.plantId != newReport.plantId) {
      throw ArgumentError(
        'Cannot compare reports for different plants: '
        '${oldReport.plantId} vs ${newReport.plantId}',
      );
    }

    // Calculate score delta
    final scoreDelta =
        newReport.intelligenceScore - oldReport.intelligenceScore;
    final normalizedScoreDelta = _applyTolerance(scoreDelta);

    _log('  ðŸ“Š Score delta: ${scoreDelta.toStringAsFixed(2)} '
        '(${normalizedScoreDelta == 0 ? "within tolerance" : normalizedScoreDelta > 0 ? "improved" : "degraded"})');

    // Calculate confidence delta
    final confidenceDelta = newReport.confidence - oldReport.confidence;
    final normalizedConfidenceDelta = _applyTolerance(confidenceDelta);

    _log('  ðŸŽ¯ Confidence delta: ${confidenceDelta.toStringAsFixed(3)} '
        '(${normalizedConfidenceDelta == 0 ? "stable" : normalizedConfidenceDelta > 0 ? "increased" : "decreased"})');

    // Compare recommendations
    final recommendationChanges = _compareRecommendations(
      oldReport.recommendations,
      newReport.recommendations,
    );

    // Compare timing
    final timingShift = _compareTimingEvaluations(
      oldReport.plantingTiming,
      newReport.plantingTiming,
    );

    // Determine overall improvement
    final isImproved = normalizedScoreDelta > 0;
    final isStable = normalizedScoreDelta == 0 &&
        recommendationChanges.addedRecommendations.isEmpty &&
        recommendationChanges.removedRecommendations.isEmpty;
    final isDegraded = normalizedScoreDelta < 0;

    _log(
        '  âœ… Evolution status: ${isImproved ? "IMPROVED" : isStable ? "STABLE" : "DEGRADED"}');

    final summary = IntelligenceEvolutionSummary(
      plantId: newReport.plantId,
      plantName: newReport.plantName,
      scoreDelta: normalizedScoreDelta,
      confidenceDelta: normalizedConfidenceDelta,
      addedRecommendations: recommendationChanges.addedRecommendations,
      removedRecommendations: recommendationChanges.removedRecommendations,
      modifiedRecommendations: recommendationChanges.modifiedRecommendations,
      isImproved: isImproved,
      isStable: isStable,
      isDegraded: isDegraded,
      timingScoreShift: timingShift,
      oldReport: oldReport,
      newReport: newReport,
      comparedAt: DateTime.now(),
    );

    _log('ðŸŽ‰ Comparison complete for ${summary.plantName}');

    return summary;
  }

  /// Compares multiple pairs of reports for a whole garden
  ///
  /// [oldReports] - List of previous intelligence reports
  /// [newReports] - List of current intelligence reports
  ///
  /// Returns a list of [IntelligenceEvolutionSummary], one per plant
  ///
  /// Only compares plants that exist in both lists
  List<IntelligenceEvolutionSummary> compareGardenReports(
    List<PlantIntelligenceReport> oldReports,
    List<PlantIntelligenceReport> newReports,
  ) {
    _log(
        'ðŸ”„ Comparing garden reports: ${oldReports.length} old, ${newReports.length} new');

    final summaries = <IntelligenceEvolutionSummary>[];

    // Create a map for quick lookup
    final oldReportMap = {
      for (var report in oldReports) report.plantId: report
    };

    // Compare each new report with its old counterpart
    for (final newReport in newReports) {
      final oldReport = oldReportMap[newReport.plantId];

      if (oldReport != null) {
        try {
          final summary = compareReports(oldReport, newReport);
          summaries.add(summary);
        } catch (e) {
          _log('âš ï¸ Error comparing reports for plant ${newReport.plantId}: $e');
          // Continue with other plants
        }
      } else {
        _log(
            'â„¹ï¸ No previous report found for plant ${newReport.plantId} (new plant)');
      }
    }

    _log('âœ… Garden comparison complete: ${summaries.length} plants compared');

    return summaries;
  }

  // ==================== PRIVATE HELPER METHODS ====================

  /// Applies tolerance threshold to a numeric delta
  /// Returns 0 if delta is within tolerance, otherwise returns the original delta
  double _applyTolerance(double delta) {
    if (delta.abs() < toleranceThreshold) {
      return 0.0;
    }
    return delta;
  }

  /// Compares two lists of recommendations and identifies changes
  _RecommendationChanges _compareRecommendations(
    List<Recommendation> oldRecommendations,
    List<Recommendation> newRecommendations,
  ) {
    _log(
        '  ðŸ“‹ Comparing recommendations: ${oldRecommendations.length} old, ${newRecommendations.length} new');

    // Create maps for quick lookup by title (recommendations with same title are considered "same")
    final oldRecMap = {for (var rec in oldRecommendations) rec.title: rec};
    final newRecMap = {for (var rec in newRecommendations) rec.title: rec};

    // Find added recommendations (in new but not in old)
    final added = <String>[];
    for (final newRec in newRecommendations) {
      if (!oldRecMap.containsKey(newRec.title)) {
        added.add(newRec.title);
      }
    }

    // Find removed recommendations (in old but not in new)
    final removed = <String>[];
    for (final oldRec in oldRecommendations) {
      if (!newRecMap.containsKey(oldRec.title)) {
        removed.add(oldRec.title);
      }
    }

    // Find modified recommendations (same title, but different priority or status)
    final modified = <String>[];
    for (final newRec in newRecommendations) {
      final oldRec = oldRecMap[newRec.title];
      if (oldRec != null) {
        // Check if priority or status changed
        if (oldRec.priority != newRec.priority ||
            oldRec.status != newRec.status) {
          modified.add(newRec.title);
        }
      }
    }

    _log('    âž• Added: ${added.length}');
    _log('    âž– Removed: ${removed.length}');
    _log('    ðŸ”„ Modified: ${modified.length}');

    return _RecommendationChanges(
      addedRecommendations: added,
      removedRecommendations: removed,
      modifiedRecommendations: modified,
    );
  }

  /// Compares timing evaluations and calculates score shift
  double _compareTimingEvaluations(
    PlantingTimingEvaluation? oldTiming,
    PlantingTimingEvaluation? newTiming,
  ) {
    if (oldTiming == null || newTiming == null) {
      _log('  ðŸ“… Timing comparison: N/A (missing data)');
      return 0.0;
    }

    final shift = newTiming.timingScore - oldTiming.timingScore;
    final normalizedShift = _applyTolerance(shift);

    _log('  ðŸ“… Timing score shift: ${shift.toStringAsFixed(2)} '
        '(${normalizedShift == 0 ? "stable" : normalizedShift > 0 ? "improved" : "degraded"})');

    return normalizedShift;
  }

  /// Logs a message if logging is enabled
  void _log(String message) {
    if (enableLogging) {
      developer.log(
        message,
        name: 'PlantIntelligenceEvolutionTracker',
      );
    }
  }
}

/// Internal class to hold recommendation comparison results
class _RecommendationChanges {
  final List<String> addedRecommendations;
  final List<String> removedRecommendations;
  final List<String> modifiedRecommendations;

  _RecommendationChanges({
    required this.addedRecommendations,
    required this.removedRecommendations,
    required this.modifiedRecommendations,
  });
}

/// Summary of intelligence evolution between two analysis sessions
///
/// Contains all detected changes and metrics to help users understand
/// how their plant health has evolved over time.
@freezed
class IntelligenceEvolutionSummary with _$IntelligenceEvolutionSummary {
  const factory IntelligenceEvolutionSummary({
    /// ID of the plant being compared
    required String plantId,

    /// Name of the plant
    required String plantName,

    /// Change in intelligence score (positive = improvement)
    required double scoreDelta,

    /// Change in confidence level (positive = more confident)
    required double confidenceDelta,

    /// List of new recommendations that were added
    required List<String> addedRecommendations,

    /// List of recommendations that were removed
    required List<String> removedRecommendations,

    /// List of recommendations that were modified (priority or status changed)
    required List<String> modifiedRecommendations,

    /// True if the plant's health improved
    required bool isImproved,

    /// True if the plant's health remained stable
    required bool isStable,

    /// True if the plant's health degraded
    required bool isDegraded,

    /// Change in timing score (e.g., seasonality changes)
    @Default(0.0) double timingScoreShift,

    /// Reference to old report (for detailed analysis)
    required PlantIntelligenceReport oldReport,

    /// Reference to new report (for detailed analysis)
    required PlantIntelligenceReport newReport,

    /// When this comparison was performed
    required DateTime comparedAt,
  }) = _IntelligenceEvolutionSummary;

  factory IntelligenceEvolutionSummary.fromJson(Map<String, dynamic> json) =>
      _$IntelligenceEvolutionSummaryFromJson(json);
}

/// Extension for IntelligenceEvolutionSummary with helpful utilities
extension IntelligenceEvolutionSummaryExtension
    on IntelligenceEvolutionSummary {
  /// Returns a human-readable status string
  String get statusText {
    if (isImproved) return 'Amélioration';
    if (isDegraded) return 'Dégradation';
    return 'Stable';
  }

  /// Returns an emoji representing the evolution status
  String get statusEmoji {
    if (isImproved) return 'ðŸ“ˆ';
    if (isDegraded) return 'ðŸ“‰';
    return 'âž¡ï¸';
  }

  /// Returns a human-readable description of the evolution
  String get description {
    final buffer = StringBuffer();

    buffer.write('$statusEmoji $plantName : ');

    if (isImproved) {
      buffer.write('Santé en amélioration ! ');
      buffer.write('Score : +${scoreDelta.toStringAsFixed(1)} points. ');
    } else if (isDegraded) {
      buffer.write('Nécessite attention. ');
      buffer.write('Score : ${scoreDelta.toStringAsFixed(1)} points. ');
    } else {
      buffer.write('État stable. ');
    }

    if (addedRecommendations.isNotEmpty) {
      buffer.write(
          '${addedRecommendations.length} nouvelle(s) recommandation(s). ');
    }

    if (removedRecommendations.isNotEmpty) {
      buffer.write(
          '${removedRecommendations.length} recommandation(s) résolue(s). ');
    }

    return buffer.toString().trim();
  }

  /// Returns true if there are any significant changes
  bool get hasSignificantChanges {
    return scoreDelta != 0 ||
        addedRecommendations.isNotEmpty ||
        removedRecommendations.isNotEmpty ||
        modifiedRecommendations.isNotEmpty;
  }

  /// Returns the time between the two reports
  Duration get timeBetweenReports {
    return newReport.generatedAt.difference(oldReport.generatedAt);
  }

  /// Returns a formatted string of the time between reports
  String get timeBetweenReportsText {
    final duration = timeBetweenReports;
    final days = duration.inDays;
    final hours = duration.inHours % 24;

    if (days > 0) {
      return '$days jour${days > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '$hours heure${hours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minutes';
    }
  }
}


