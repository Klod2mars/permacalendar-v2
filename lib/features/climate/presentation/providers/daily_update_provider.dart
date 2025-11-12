import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'soil_temp_provider.dart';
import 'weather_providers.dart';

/// Provider for daily soil temperature update trigger
///
/// This provider handles the daily update of soil temperature based on air temperature.
/// It checks if the soil temperature was updated today and triggers an update if needed.
final dailyUpdateProvider = Provider<DailyUpdateController>((ref) {
  return DailyUpdateController(ref);
});

/// Controller for managing daily soil temperature updates
///
/// Handles the logic for checking if soil temperature needs to be updated
/// and triggering the update based on current air temperature.
class DailyUpdateController {
  final Ref _ref;

  DailyUpdateController(this._ref);

  /// Check if soil temperature needs daily update and trigger it if needed
  ///
  /// [scopeKey] Scope identifier for the soil temperature
  /// [forceUpdate] Force update even if already updated today
  ///
  /// Returns true if update was triggered, false if not needed
  Future<bool> checkAndUpdateSoilTemp(String scopeKey,
      {bool forceUpdate = false}) async {
    try {
      final soilTempController = _ref.read(soilTempProvider.notifier);

      // Check if already updated today
      if (!forceUpdate) {
        final isUpdatedToday =
            await soilTempController.isUpdatedToday(scopeKey);
        if (isUpdatedToday) {
          return false; // Already updated today
        }
      }

      // Get current air temperature
      final airTemp = _ref.read(currentAirTempProvider);
      if (airTemp == null) {
        // No air temperature available, skip update
        return false;
      }

      // Trigger soil temperature update
      await soilTempController.updateFromAirTemp(scopeKey, airTemp);
      return true;
    } catch (e) {
      print(
          '[DailyUpdateController] Error updating soil temp for $scopeKey: $e');
      return false;
    }
  }

  /// Check and update soil temperature for multiple scopes
  ///
  /// [scopeKeys] List of scope identifiers
  /// [forceUpdate] Force update even if already updated today
  ///
  /// Returns a map of scope keys to update results
  Future<Map<String, bool>> checkAndUpdateMultipleScopes(List<String> scopeKeys,
      {bool forceUpdate = false}) async {
    final results = <String, bool>{};

    for (final scopeKey in scopeKeys) {
      final result =
          await checkAndUpdateSoilTemp(scopeKey, forceUpdate: forceUpdate);
      results[scopeKey] = result;
    }

    return results;
  }

  /// Get soil temperature update status for a scope
  ///
  /// [scopeKey] Scope identifier
  ///
  /// Returns update status information
  Future<Map<String, dynamic>> getUpdateStatus(String scopeKey) async {
    try {
      final soilTempController = _ref.read(soilTempProvider.notifier);
      final isUpdatedToday = await soilTempController.isUpdatedToday(scopeKey);
      final airTemp = _ref.read(currentAirTempProvider);

      return {
        'scopeKey': scopeKey,
        'isUpdatedToday': isUpdatedToday,
        'airTempAvailable': airTemp != null,
        'airTemp': airTemp,
        'lastUpdate': null, // TODO: Access last update through public method
      };
    } catch (e) {
      return {
        'scopeKey': scopeKey,
        'error': e.toString(),
      };
    }
  }

  /// Force update soil temperature for a scope
  ///
  /// [scopeKey] Scope identifier
  ///
  /// Returns true if update was successful
  Future<bool> forceUpdateSoilTemp(String scopeKey) async {
    return await checkAndUpdateSoilTemp(scopeKey, forceUpdate: true);
  }

  /// Get thermal equilibrium information for a scope
  ///
  /// [scopeKey] Scope identifier
  ///
  /// Returns thermal equilibrium information
  Future<Map<String, dynamic>> getThermalEquilibriumInfo(
      String scopeKey) async {
    try {
      final soilTempController = _ref.read(soilTempProvider.notifier);
      final airTemp = _ref.read(currentAirTempProvider);

      if (airTemp == null) {
        return {
          'scopeKey': scopeKey,
          'error': 'No air temperature available',
        };
      }

      return await soilTempController.getThermalEquilibriumInfo(
          scopeKey, airTemp);
    } catch (e) {
      return {
        'scopeKey': scopeKey,
        'error': e.toString(),
      };
    }
  }
}

/// Provider for checking if daily update is needed
///
/// Returns true if any scope needs a daily update
final needsDailyUpdateProvider = Provider<bool>((ref) {
  // This would be implemented to check all active scopes
  // For now, return false as a stub
  return false;
});

/// Provider for daily update status
///
/// Returns the status of daily updates for all scopes
final dailyUpdateStatusProvider = Provider<Map<String, dynamic>>((ref) {
  // This would be implemented to provide status for all scopes
  // For now, return empty map as a stub
  return {};
});


