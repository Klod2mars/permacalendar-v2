/// Use case for rounding pH values to 0.5 step increments
///
/// pH values are rounded to the nearest 0.5 step within the valid range [0.0, 14.0].
/// This provides a practical granularity for soil pH measurements.
class RoundPhToStepUsecase {
  /// Round pH value to nearest 0.5 step within [0.0, 14.0]
  ///
  /// [value] The pH value to round
  ///
  /// Returns the rounded pH value
  ///
  /// Examples:
  /// - 6.24 â†’ 6.0
  /// - 6.26 â†’ 6.5
  /// - 6.75 â†’ 7.0
  /// - -1.0 â†’ 0.0 (clamped)
  /// - 15.0 â†’ 14.0 (clamped)
  double call(double value) {
    // Clamp to valid pH range [0.0, 14.0]
    final clamped = value.clamp(0.0, 14.0);

    // Round to nearest 0.5 step
    // Multiply by 2, round, then divide by 2
    return (clamped * 2).round() / 2.0;
  }

  /// Get the next higher pH step
  ///
  /// [value] Current pH value
  ///
  /// Returns the next 0.5 step up, or 14.0 if already at maximum
  double nextStep(double value) {
    final rounded = call(value);
    if (rounded >= 14.0) return 14.0;
    return rounded + 0.5;
  }

  /// Get the previous lower pH step
  ///
  /// [value] Current pH value
  ///
  /// Returns the previous 0.5 step down, or 0.0 if already at minimum
  double previousStep(double value) {
    final rounded = call(value);
    if (rounded <= 0.0) return 0.0;
    return rounded - 0.5;
  }

  /// Get all available pH steps
  ///
  /// Returns a list of all valid pH steps from 0.0 to 14.0
  List<double> getAllSteps() {
    final steps = <double>[];
    for (double i = 0.0; i <= 14.0; i += 0.5) {
      steps.add(i);
    }
    return steps;
  }

  /// Get pH steps within a range
  ///
  /// [min] Minimum pH value (inclusive)
  /// [max] Maximum pH value (inclusive)
  ///
  /// Returns a list of pH steps within the specified range
  List<double> getStepsInRange(double min, double max) {
    final clampedMin = min.clamp(0.0, 14.0);
    final clampedMax = max.clamp(0.0, 14.0);

    if (clampedMin > clampedMax) return [];

    final steps = <double>[];
    for (double i = clampedMin; i <= clampedMax; i += 0.5) {
      steps.add(i);
    }
    return steps;
  }

  /// Get the pH category description
  ///
  /// [value] The pH value
  ///
  /// Returns a human-readable description of the pH level
  String getCategory(double value) {
    final rounded = call(value);

    if (rounded < 5.5) return 'Très acide';
    if (rounded < 6.5) return 'Acide';
    if (rounded < 7.5) return 'Neutre';
    if (rounded < 8.5) return 'Alcalin';
    return 'Très alcalin';
  }

  /// Check if a pH value is within optimal range for most plants
  ///
  /// [value] The pH value to check
  ///
  /// Returns true if pH is in the optimal range (6.0-7.5)
  bool isOptimalForMostPlants(double value) {
    final rounded = call(value);
    return rounded >= 6.0 && rounded <= 7.5;
  }

  /// Get the distance to the nearest optimal pH step
  ///
  /// [value] Current pH value
  ///
  /// Returns the absolute difference to the nearest optimal step
  double distanceToOptimal(double value) {
    final rounded = call(value);
    final optimalSteps = getStepsInRange(6.0, 7.5);

    if (optimalSteps.isEmpty) return 0.0;

    double minDistance = double.infinity;
    for (final step in optimalSteps) {
      final distance = (rounded - step).abs();
      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }
}


