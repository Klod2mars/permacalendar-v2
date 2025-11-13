ï»¿/// Repository abstraction for soil metrics data access
///
/// Defines the contract for soil temperature and pH data operations.
/// Scope-based operations allow for garden-specific or bed-specific metrics.
abstract class SoilMetricsRepository {
  /// Get soil temperature for a specific scope
  ///
  /// [scopeKey] Scope identifier (e.g., "garden:gardenId" or "garden:gardenId:bed:bedId")
  ///
  /// Returns the soil temperature in Celsius, or null if not available
  Future<double?> getSoilTempC(String scopeKey);

  /// Get soil pH for a specific scope
  ///
  /// [scopeKey] Scope identifier (e.g., "garden:gardenId" or "garden:gardenId:bed:bedId")
  ///
  /// Returns the soil pH value, or null if not available
  Future<double?> getSoilPH(String scopeKey);

  /// Set soil temperature for a specific scope
  ///
  /// [scopeKey] Scope identifier
  /// [tempC] Temperature in Celsius
  Future<void> setSoilTempC(String scopeKey, double tempC);

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

  /// Get all soil metrics for a specific scope
  ///
  /// [scopeKey] Scope identifier
  ///
  /// Returns a map with all available metrics, or null if no data exists
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
}


