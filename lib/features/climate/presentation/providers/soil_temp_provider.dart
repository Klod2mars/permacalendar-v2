import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/soil_metrics_repository.dart';
import '../../domain/usecases/compute_soil_temp_next_day_usecase.dart';
import 'soil_metrics_repository_provider.dart';

/// State for soil temperature by scope
class SoilTempState {
  final Map<String, AsyncValue<double?>> temperatures;

  const SoilTempState({
    required this.temperatures,
  });

  SoilTempState copyWith({
    Map<String, AsyncValue<double?>>? temperatures,
  }) {
    return SoilTempState(
      temperatures: temperatures ?? this.temperatures,
    );
  }

  AsyncValue<double?> getTemp(String scopeKey) {
    return temperatures[scopeKey] ?? const AsyncValue.loading();
  }
}

/// Controller for managing soil temperature state
///
/// Handles loading, setting, and updating soil temperature values
/// with automatic daily updates based on air temperature.
class SoilTempController extends Notifier<SoilTempState> {
  SoilTempController(this.scopeKey);

  /// Family argument passed through the provider
  final String? scopeKey;

  SoilMetricsRepository get _repo => ref.watch(soilMetricsRepositoryProvider);
  final _compute = ComputeSoilTempNextDayUsecase();

  @override
  SoilTempState build() {
    if (scopeKey != null) {
      return SoilTempState(
        temperatures: {
          scopeKey!: const AsyncValue.loading(),
        },
      );
    }
    return const SoilTempState(temperatures: {});
  }

  String _resolveScopeKey(String key) {
    return key.isNotEmpty ? key : (scopeKey ?? (throw StateError('scopeKey is required')));
  }

  /// Load soil temperature from repository
  Future<void> load(String scopeKey) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[resolvedScope] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      final temp = await _repo.getSoilTempC(resolvedScope);

      updated[resolvedScope] = AsyncValue.data(temp);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[resolvedScope] = AsyncValue.error(e, st);
      state = state.copyWith(temperatures: updated);
    }
  }

  /// Set manual soil temperature
  ///
  /// [scopeKey] Scope identifier
  /// [tempC] Temperature in Celsius
  Future<void> setManual(String scopeKey, double tempC) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[resolvedScope] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      await _repo.setSoilTempC(resolvedScope, tempC);
      await _repo.setLastUpdated(resolvedScope, DateTime.now());

      updated[resolvedScope] = AsyncValue.data(tempC);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[resolvedScope] = AsyncValue.error(e, st);
      state = state.copyWith(temperatures: updated);
    }
  }

  /// Update soil temperature from air temperature
  ///
  /// Uses thermal diffusion model to compute next day soil temperature
  /// based on current air temperature.
  ///
  /// [scopeKey] Scope identifier
  /// [airTempC] Current air temperature in Celsius
  /// [alpha] Thermal diffusion coefficient (default: 0.15)
  Future<void> updateFromAirTemp(String scopeKey, double airTempC,
      {double alpha = 0.15}) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[resolvedScope] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      // Get current soil temperature, fallback to air temperature if not available
      final currentSoilTemp = state.temperatures[resolvedScope]?.value ??
          (await _repo.getSoilTempC(resolvedScope)) ??
          airTempC;

      // Compute next day soil temperature
      final nextTemp = _compute(
        soilTempC: currentSoilTemp,
        airTempC: airTempC,
        alpha: alpha,
      );

      // Save the computed temperature
      await _repo.setSoilTempC(resolvedScope, nextTemp);
      await _repo.setLastUpdated(resolvedScope, DateTime.now());

      updated[resolvedScope] = AsyncValue.data(nextTemp);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[resolvedScope] = AsyncValue.error(e, st);
      state = state.copyWith(temperatures: updated);
    }
  }

  /// Check if soil temperature was updated today
  Future<bool> isUpdatedToday(String scopeKey) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final lastUpdated = await _repo.getLastUpdated(resolvedScope);
      if (lastUpdated == null) return false;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastUpdate = DateTime(
        lastUpdated.year,
        lastUpdated.month,
        lastUpdated.day,
      );

      return today.isAtSameMomentAs(lastUpdate);
    } catch (e) {
      return false;
    }
  }

  /// Get thermal equilibrium information
  ///
  /// [scopeKey] Scope identifier
  /// [airTempC] Current air temperature
  /// [alpha] Thermal diffusion coefficient
  ///
  /// Returns information about thermal equilibrium
  Future<Map<String, dynamic>> getThermalEquilibriumInfo(
      String scopeKey, double airTempC,
      {double alpha = 0.15}) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final currentTemp = state.temperatures[resolvedScope]?.value ??
          (await _repo.getSoilTempC(resolvedScope)) ??
          airTempC;
      final daysToEquilibrium = _compute.daysToEquilibrium(
        soilTempC: currentTemp,
        airTempC: airTempC,
        alpha: alpha,
      );

      return {
        'currentTemp': currentTemp,
        'airTemp': airTempC,
        'daysToEquilibrium': daysToEquilibrium,
        'temperatureDifference': (airTempC - currentTemp).abs(),
      };
    } catch (e) {
      return {
        'error': e.toString(),
      };
    }
  }

  /// Refresh soil temperature from repository
  Future<void> refresh(String scopeKey) async {
    await load(scopeKey);
  }

  /// Reset soil temperature to null
  Future<void> reset(String scopeKey) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[resolvedScope] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      await _repo.deleteMetrics(resolvedScope);

      updated[resolvedScope] = const AsyncValue.data(null);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[resolvedScope] = AsyncValue.error(e, st);
      state = state.copyWith(temperatures: updated);
    }
  }
}

/// Provider for soil temperature controller (family per scope)
final soilTempProvider =
    NotifierProvider.family<SoilTempController, SoilTempState, String?>(
  SoilTempController.new,
);

/// Provider that exposes the temperature for a specific scope
final soilTempProviderByScope =
    Provider.family<AsyncValue<double?>, String>((ref, scopeKey) {
  final controller = ref.watch(soilTempProvider(scopeKey));
  final temp = controller.getTemp(scopeKey);

  // Load data if not already loaded
  if (temp.isLoading) {
    Future.microtask(() {
      ref.read(soilTempProvider(scopeKey).notifier).load(scopeKey);
    });
  }

  return temp;
});
