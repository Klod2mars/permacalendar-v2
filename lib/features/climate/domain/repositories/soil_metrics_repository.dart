/// Repository abstraction for soil metrics data access
///
/// Defines the contract for soil temperature and pH data operations.
/// Scope-based operations allow for garden-specific or bed-specific metrics.
abstract class SoilMetricsRepository {
  /// Get soil temperature for a specific scope
  ///
  /// [scopeKey] Scope identifier (e.g., "garden:gardenId" or "garden:gardenId:bed:bedId")
  ///
  /// Returns the soil temperature in Celsius (Estimated), or null if not available
  Future<double?> getSoilTempC(String scopeKey);

  /// Get soil pH for a specific scope
  ///
  /// [scopeKey] Scope identifier (e.g., "garden:gardenId" or "garden:gardenId:bed:bedId")
  ///
  /// Returns the soil pH value, or null if not available
  Future<double?> getSoilPH(String scopeKey);

  /// Set manual anchor soil temperature
  ///
  /// [scopeKey] Scope identifier
  /// [anchorTempC] Measured temperature
  /// [timestamp] Date of measurement (usually now)
  ///
  /// This will also reset the estimated temperature to this anchor value
  Future<void> setManualAnchor(String scopeKey, double anchorTempC, DateTime timestamp);

  /// Set estimated soil temperature
  ///
  /// [scopeKey] Scope identifier
  /// [estimated] Calculated temperature
  /// [computedAt] Date of computation
  Future<void> setEstimatedTemp(String scopeKey, double estimated, DateTime computedAt);

  /// Set soil pH for a specific scope
  ///
  /// [scopeKey] Scope identifier
  /// [ph] pH value
  Future<void> setSoilPH(String scopeKey, double ph);

  /// Get last update timestamp for a specific scope
  ///
  /// [scopeKey] Scope identifier
  ///
  /// Returns the last update timestamp, or null if not available
  Future<DateTime?> getLastUpdated(String scopeKey);

  /// Set last update timestamp for a specific scope
  ///
  /// [scopeKey] Scope identifier
  /// [timestamp] Update timestamp
  Future<void> setLastUpdated(String scopeKey, DateTime timestamp);

  /// Get all soil metrics data object for a specific scope
  ///
  /// [scopeKey] Scope identifier
  ///
  /// Returns the full DTO (including anchor info), or null if no data exists
  // We need to import the DTO in the interface file or return a generic Map/Object if we want to keep layers strict.
  // However, for simplicity in this project, we often return domain objects or Maps. 
  // The user requested `Future<SoilMetricsDto?> getMetrics(String scopeKey);` 
  // but DTO is in data layer. To respect Clean Arch, we should return a Domain Entity or Map.
  // The current interface uses `getAllMetrics` returning `Map<String, dynamic>?`.
  // I will stick to extending `getAllMetrics` or adding a new method that returns a Domain Entity if one existed.
  // Given the current state, `SoilMetricsDto` is used in Data Source.
  // The user explicitly asked for `Future<SoilMetricsDto?> getMetrics(String scopeKey);` in the prompt's analysis section,
  // but usually Repository returns Entities.
  // I will check if there is a `SoilMetrics` entity.
  // Looking at the file list, there isn't a specific `SoilMetrics` entity file, just `SoilMetricsRepository`.
  // I will use `Map<String, dynamic>` for `getAllMetrics` as it was before, ensuring it includes new fields.
  Future<Map<String, dynamic>?> getAllMetrics(String scopeKey);

  /// Set multiple soil metrics for a specific scope
  ///
  /// [scopeKey] Scope identifier
  /// [metrics] Map of metrics to set
  Future<void> setAllMetrics(String scopeKey, Map<String, dynamic> metrics);

  /// Delete all soil metrics for a specific scope
  ///
  /// [scopeKey] Scope identifier
  Future<void> deleteMetrics(String scopeKey);

  /// Check if metrics exist for a specific scope
  ///
  /// [scopeKey] Scope identifier
  ///
  /// Returns true if any metrics exist for the scope
  Future<bool> hasMetrics(String scopeKey);

  /// Get all scope keys that have metrics
  ///
  /// Returns a list of all scope keys with data
  Future<List<String>> getAllScopeKeys();

  /// Get metrics for multiple scopes
  ///
  /// [scopeKeys] List of scope identifiers
  ///
  /// Returns a map of scope keys to their metrics
  Future<Map<String, Map<String, dynamic>>> getMetricsForScopes(
      List<String> scopeKeys);

  /// Clear all metrics (for testing/reset purposes)
  Future<void> clearAllMetrics();

  @Deprecated('Use setManualAnchor or setEstimatedTemp instead')
  Future<void> setSoilTempC(String scopeKey, double tempC);
}
