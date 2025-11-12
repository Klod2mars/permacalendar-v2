import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_evolution_report.freezed.dart';
part 'plant_evolution_report.g.dart';

/// 🔄 CURSOR PROMPT A5 - Plant Evolution Report
///
/// Represents the evolution delta between two PlantIntelligenceReport instances.
/// This report tracks how plant health has changed over time by comparing:
/// - Global intelligence scores
/// - Individual condition statuses (temperature, humidity, light, soil)
///
/// **Philosophy:**
/// This model provides a structured way to understand plant progression,
/// regression or stability over time without side effects.
@freezed
class PlantEvolutionReport with _$PlantEvolutionReport {
  const factory PlantEvolutionReport({
    /// ID of the plant being compared
    required String plantId,

    /// Date of the previous report
    required DateTime previousDate,

    /// Date of the current report
    required DateTime currentDate,

    /// Previous intelligence score (0-100)
    required double previousScore,

    /// Current intelligence score (0-100)
    required double currentScore,

    /// Delta between current and previous score
    /// Positive = improvement, Negative = degradation
    required double deltaScore,

    /// Trend indicator: 'up', 'down', or 'stable'
    required String trend,

    /// List of condition names that improved
    /// (e.g., 'temperature', 'humidity', 'light', 'soil')
    @Default([]) List<String> improvedConditions,

    /// List of condition names that degraded
    @Default([]) List<String> degradedConditions,

    /// List of condition names that remained unchanged
    @Default([]) List<String> unchangedConditions,
  }) = _PlantEvolutionReport;

  factory PlantEvolutionReport.fromJson(Map<String, dynamic> json) =>
      _$PlantEvolutionReportFromJson(json);
}

/// Extension for PlantEvolutionReport with helpful utilities
extension PlantEvolutionReportExtension on PlantEvolutionReport {
  /// Returns true if the plant's health improved
  bool get hasImproved => trend == 'up';

  /// Returns true if the plant's health degraded
  bool get hasDegraded => trend == 'down';

  /// Returns true if the plant's health is stable
  bool get isStable => trend == 'stable';

  /// Returns a human-readable description of the evolution
  String get description {
    final buffer = StringBuffer();

    if (hasImproved) {
      buffer
          .write('📈 Amélioration : +${deltaScore.toStringAsFixed(1)} points');
    } else if (hasDegraded) {
      buffer.write('📉 Dégradation : ${deltaScore.toStringAsFixed(1)} points');
    } else {
      buffer.write('➡️ Stable : pas de changement significatif');
    }

    if (improvedConditions.isNotEmpty) {
      buffer.write(' | ${improvedConditions.length} condition(s) améliorée(s)');
    }

    if (degradedConditions.isNotEmpty) {
      buffer.write(' | ${degradedConditions.length} condition(s) dégradée(s)');
    }

    return buffer.toString();
  }

  /// Returns the duration between the two reports
  Duration get timeBetweenReports => currentDate.difference(previousDate);

  /// Returns true if there are any condition changes
  bool get hasConditionChanges =>
      improvedConditions.isNotEmpty || degradedConditions.isNotEmpty;

  /// Returns the total number of conditions tracked
  int get totalConditions =>
      improvedConditions.length +
      degradedConditions.length +
      unchangedConditions.length;

  /// Returns a percentage of improved conditions
  double get improvementRate {
    if (totalConditions == 0) return 0.0;
    return (improvedConditions.length / totalConditions) * 100;
  }

  /// Returns a percentage of degraded conditions
  double get degradationRate {
    if (totalConditions == 0) return 0.0;
    return (degradedConditions.length / totalConditions) * 100;
  }
}


