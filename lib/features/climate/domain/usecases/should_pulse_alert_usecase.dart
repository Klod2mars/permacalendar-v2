/// Use case for determining if alert pulse animation should be active
///
/// Simple logic to check if alerts are present and should trigger
/// the pulse animation in the climate rosace panel.
class ShouldPulseAlertUsecase {
  /// Check if alerts should trigger pulse animation
  ///
  /// [alerts] List of alerts (can be null or empty)
  ///
  /// Returns true if alerts are present and non-empty
  bool call(List<dynamic>? alerts) {
    return alerts != null && alerts.isNotEmpty;
  }

  /// Check if alerts should trigger pulse animation with count
  ///
  /// [alerts] List of alerts (can be null or empty)
  ///
  /// Returns the number of alerts if present, 0 otherwise
  int getAlertCount(List<dynamic>? alerts) {
    return alerts?.length ?? 0;
  }

  /// Check if alerts should trigger pulse animation with severity filter
  ///
  /// [alerts] List of alerts (can be null or empty)
  /// [minSeverity] Minimum severity level to consider (optional)
  ///
  /// Returns true if alerts meet the severity threshold
  bool callWithSeverity(List<dynamic>? alerts, {String? minSeverity}) {
    if (alerts == null || alerts.isEmpty) return false;

    if (minSeverity == null) return true;

    // Check if any alert has the minimum severity or higher
    // This assumes alerts have a 'severity' field
    for (final alert in alerts) {
      if (alert is Map<String, dynamic>) {
        final severity = alert['severity'] as String?;
        if (severity != null &&
            _isSeverityHigherOrEqual(severity, minSeverity)) {
          return true;
        }
      }
    }

    return false;
  }

  /// Check if alerts should trigger pulse animation with type filter
  ///
  /// [alerts] List of alerts (can be null or empty)
  /// [alertType] Specific alert type to check for (optional)
  ///
  /// Returns true if alerts of the specified type are present
  bool callWithType(List<dynamic>? alerts, {String? alertType}) {
    if (alerts == null || alerts.isEmpty) return false;

    if (alertType == null) return true;

    // Check if any alert has the specified type
    for (final alert in alerts) {
      if (alert is Map<String, dynamic>) {
        final type = alert['type'] as String?;
        if (type == alertType) {
          return true;
        }
      }
    }

    return false;
  }

  /// Get the highest severity level among alerts
  ///
  /// [alerts] List of alerts (can be null or empty)
  ///
  /// Returns the highest severity level, or null if no alerts
  String? getHighestSeverity(List<dynamic>? alerts) {
    if (alerts == null || alerts.isEmpty) return null;

    String? highestSeverity;

    for (final alert in alerts) {
      if (alert is Map<String, dynamic>) {
        final severity = alert['severity'] as String?;
        if (severity != null) {
          if (highestSeverity == null ||
              _isSeverityHigherOrEqual(severity, highestSeverity)) {
            highestSeverity = severity;
          }
        }
      }
    }

    return highestSeverity;
  }

  /// Check if severity level is higher or equal to another
  ///
  /// [severity1] First severity level
  /// [severity2] Second severity level
  ///
  /// Returns true if severity1 is higher or equal to severity2
  bool _isSeverityHigherOrEqual(String severity1, String severity2) {
    const severityLevels = ['low', 'medium', 'high', 'critical'];

    final index1 = severityLevels.indexOf(severity1.toLowerCase());
    final index2 = severityLevels.indexOf(severity2.toLowerCase());

    // If either severity is not recognized, consider them equal
    if (index1 == -1 || index2 == -1) return severity1 == severity2;

    return index1 >= index2;
  }

  /// Get alerts summary for display
  ///
  /// [alerts] List of alerts (can be null or empty)
  ///
  /// Returns a summary string of alerts
  String getAlertsSummary(List<dynamic>? alerts) {
    final count = getAlertCount(alerts);
    if (count == 0) return 'Aucune alerte';
    if (count == 1) return '1 alerte';
    return '$count alertes';
  }
}
