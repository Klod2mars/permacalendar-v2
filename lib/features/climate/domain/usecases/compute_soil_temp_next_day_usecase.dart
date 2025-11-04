/// Use case for computing soil temperature for the next day
///
/// Implements the thermal diffusion model:
/// Tsoil(n+1) = Tsoil(n) + alpha * (Tair(n) - Tsoil(n))
///
/// Where:
/// - alpha: thermal diffusion coefficient (0.1-0.2)
/// - Tsoil(n): current soil temperature
/// - Tair(n): current air temperature
/// - Tsoil(n+1): next day soil temperature
class ComputeSoilTempNextDayUsecase {
  /// Compute next day soil temperature using thermal diffusion model
  ///
  /// [soilTempC] Current soil temperature in Celsius
  /// [airTempC] Current air temperature in Celsius
  /// [alpha] Thermal diffusion coefficient (default: 0.15, range: 0.1-0.2)
  /// [minC] Minimum temperature bound (default: -10.0°C)
  /// [maxC] Maximum temperature bound (default: 40.0°C)
  ///
  /// Returns the computed next day soil temperature, clamped to bounds
  double call({
    required double soilTempC,
    required double airTempC,
    double alpha = 0.15,
    double minC = -10.0,
    double maxC = 40.0,
  }) {
    // Validate inputs
    if (alpha < 0.1 || alpha > 0.2) {
      throw ArgumentError('Alpha must be between 0.1 and 0.2, got $alpha');
    }

    if (minC >= maxC) {
      throw ArgumentError(
          'minC must be less than maxC, got minC=$minC, maxC=$maxC');
    }

    // Apply thermal diffusion model
    final temperatureDifference = airTempC - soilTempC;
    final nextTemp = soilTempC + alpha * temperatureDifference;

    // Clamp to reasonable bounds
    if (nextTemp < minC) return minC;
    if (nextTemp > maxC) return maxC;

    return nextTemp;
  }

  /// Compute soil temperature for multiple days ahead
  ///
  /// [soilTempC] Initial soil temperature
  /// [airTempC] Air temperature (assumed constant)
  /// [days] Number of days to project
  /// [alpha] Thermal diffusion coefficient
  /// [minC] Minimum temperature bound
  /// [maxC] Maximum temperature bound
  ///
  /// Returns list of temperatures for each day
  List<double> computeMultipleDays({
    required double soilTempC,
    required double airTempC,
    required int days,
    double alpha = 0.15,
    double minC = -10.0,
    double maxC = 40.0,
  }) {
    if (days <= 0) {
      throw ArgumentError('Days must be positive, got $days');
    }

    final temperatures = <double>[];
    double currentTemp = soilTempC;

    for (int day = 0; day < days; day++) {
      currentTemp = call(
        soilTempC: currentTemp,
        airTempC: airTempC,
        alpha: alpha,
        minC: minC,
        maxC: maxC,
      );
      temperatures.add(currentTemp);
    }

    return temperatures;
  }

  /// Get the thermal equilibrium temperature
  ///
  /// When soil temperature reaches equilibrium with air temperature,
  /// the difference becomes negligible. This method calculates
  /// how many days it would take to reach 95% of equilibrium.
  ///
  /// [soilTempC] Initial soil temperature
  /// [airTempC] Target air temperature
  /// [alpha] Thermal diffusion coefficient
  /// [tolerance] Convergence tolerance (default: 0.05 = 5%)
  ///
  /// Returns the number of days to reach equilibrium
  int daysToEquilibrium({
    required double soilTempC,
    required double airTempC,
    double alpha = 0.15,
    double tolerance = 0.05,
  }) {
    if (tolerance <= 0 || tolerance >= 1) {
      throw ArgumentError('Tolerance must be between 0 and 1, got $tolerance');
    }

    final targetDifference = (airTempC - soilTempC).abs() * tolerance;
    double currentTemp = soilTempC;
    int days = 0;
    const maxDays = 365; // Prevent infinite loops

    while (days < maxDays) {
      final difference = (airTempC - currentTemp).abs();
      if (difference <= targetDifference) {
        return days;
      }

      currentTemp = call(
        soilTempC: currentTemp,
        airTempC: airTempC,
        alpha: alpha,
      );
      days++;
    }

    return maxDays; // Return max days if equilibrium not reached
  }
}
