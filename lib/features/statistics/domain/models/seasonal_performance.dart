ï»¿import 'package:freezed_annotation/freezed_annotation.dart';

part 'seasonal_performance.freezed.dart';

/// Modèle pour les données de performance saisonnière
@freezed
class SeasonalPerformance with _$SeasonalPerformance {
  const factory SeasonalPerformance({
    required int year,
    required int totalCulturesStarted,
    required int totalCulturesCompleted,
    required double averageMaturationDuration,
    required double totalHarvestValue,
    required double averageYieldPerCulture,
    required double completionRate,
  }) = _SeasonalPerformance;

  const SeasonalPerformance._();

  /// Calcule le taux de complétion en pourcentage
  double get completionRatePercentage => completionRate * 100;

  /// Calcule la durée moyenne de maturation en jours
  int get averageMaturationDurationInDays => averageMaturationDuration.round();

  /// Formate la valeur totale des récoltes
  String get formattedTotalValue => '${totalHarvestValue.toStringAsFixed(2)} â‚¬';

  /// Formate le rendement moyen par culture
  String get formattedAverageYield =>
      '${averageYieldPerCulture.toStringAsFixed(2)} kg';
}

/// Modèle pour la comparaison entre saisons
@freezed
class SeasonalComparison with _$SeasonalComparison {
  const factory SeasonalComparison({
    required SeasonalPerformance currentSeason,
    required SeasonalPerformance? previousSeason,
    required bool hasPreviousSeason,
    required double completionRateImprovement,
    required double maturationDurationImprovement,
    required double harvestValueImprovement,
    required double yieldImprovement,
    required double overallScore,
  }) = _SeasonalComparison;

  const SeasonalComparison._();

  /// Calcule l'amélioration du taux de complétion en points de pourcentage
  double get completionRateImprovementPercentage =>
      completionRateImprovement * 100;

  /// Calcule l'amélioration de la durée de maturation en jours
  int get maturationDurationImprovementInDays =>
      maturationDurationImprovement.round();

  /// Calcule l'amélioration de la valeur des récoltes en pourcentage
  double get harvestValueImprovementPercentage => harvestValueImprovement * 100;

  /// Calcule l'amélioration du rendement en pourcentage
  double get yieldImprovementPercentage => yieldImprovement * 100;

  /// Score global de performance (0-100)
  int get overallScorePercentage => overallScore.round();

  /// Détermine si la performance s'améliore
  bool get isImproving => overallScore > 0;

  /// Détermine si la performance se dégrade
  bool get isDeclining => overallScore < 0;

  /// Détermine si la performance est stable
  bool get isStable => overallScore == 0;
}


