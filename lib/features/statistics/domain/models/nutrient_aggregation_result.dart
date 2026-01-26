
class NutrientAggregate {
  final String key;
  /// Total amount available in the harvested mass (units from key, e.g. mg)
  final double sumAvailable;
  /// Total mass of produce that *had* this data point (kg)
  final double massWithDataKg;
  /// Number of harvest records contributing to this data point
  final int contributingRecords;
  /// Ratio of massWithDataKg / totalHarvestMass (0.0 to 1.0)
  final double dataConfidence;
  /// Percent of DRI covered (0.0 to 100+)
  final double coveragePercent;
  /// Lower bound coverage (conservative, assume missing = 0)
  final double lowerBoundCoverage;
  /// Upper bound coverage (optimistic, assume missing = average) - optional
  final double? upperBoundCoverage;

  const NutrientAggregate({
    required this.key,
    required this.sumAvailable,
    required this.massWithDataKg,
    required this.contributingRecords,
    required this.dataConfidence,
    required this.coveragePercent,
    required this.lowerBoundCoverage,
    this.upperBoundCoverage,
  });
}

class NutrientAggregationResult {
  final DateTime startDate;
  final DateTime endDate;
  final int daysInPeriod;
  final double totalMassKg;
  final int totalRecords;
  
  /// Aggregates by nutrient key
  final Map<String, NutrientAggregate> byNutrient;
  
  /// Monthly totals for trending (key -> monthly sum)
  final Map<int, Map<String, double>> monthlyTotals;
  final Map<int, int> monthlyRecordCounts;
  final Map<int, double> monthlyMassKg;

  const NutrientAggregationResult({
    required this.startDate,
    required this.endDate,
    required this.daysInPeriod,
    required this.totalMassKg,
    required this.totalRecords,
    required this.byNutrient,
    required this.monthlyTotals,
    required this.monthlyRecordCounts,
    required this.monthlyMassKg,
  });

  /// Helper to get a safe aggregate or empty
  NutrientAggregate getAggregate(String key) {
    return byNutrient[key] ??
        NutrientAggregate(
          key: key,
          sumAvailable: 0,
          massWithDataKg: 0,
          contributingRecords: 0,
          dataConfidence: 0,
          coveragePercent: 0,
          lowerBoundCoverage: 0,
        );
  }
}
