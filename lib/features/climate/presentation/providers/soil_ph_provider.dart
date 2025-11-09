import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/soil_metrics_repository.dart';
import '../../domain/usecases/round_ph_to_step_usecase.dart';
import 'soil_metrics_repository_provider.dart';

/// State for soil pH by scope
class SoilPHState {
  final Map<String, AsyncValue<double?>> phValues;

  const SoilPHState({
    required this.phValues,
  });

  SoilPHState copyWith({
    Map<String, AsyncValue<double?>>? phValues,
  }) {
    return SoilPHState(
      phValues: phValues ?? this.phValues,
    );
  }

  AsyncValue<double?> getPH(String scopeKey) {
    return phValues[scopeKey] ?? const AsyncValue.loading();
  }
}

/// Controller for managing soil pH state
///
/// Handles loading, setting, and rounding soil pH values
/// with automatic rounding to 0.5 step increments.
class SoilPHController extends Notifier<SoilPHState> {
  SoilPHController(this.scopeKey);

  /// Family argument passed through the provider
  final String? scopeKey;

  SoilMetricsRepository get _repo => ref.watch(soilMetricsRepositoryProvider);
  final _round = RoundPhToStepUsecase();

  @override
  SoilPHState build() {
    if (scopeKey != null) {
      return SoilPHState(
        phValues: {
          scopeKey!: const AsyncValue.loading(),
        },
      );
    }

    return const SoilPHState(phValues: {});
  }

  String _resolveScopeKey(String key) {
    return key.isNotEmpty ? key : (scopeKey ?? (throw StateError('scopeKey is required')));
  }

  /// Load soil pH from repository
  Future<void> load(String scopeKey) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.phValues);
      updated[resolvedScope] = const AsyncValue.loading();
      state = state.copyWith(phValues: updated);

      final ph = await _repo.getSoilPH(resolvedScope);

      updated[resolvedScope] = AsyncValue.data(ph);
      state = state.copyWith(phValues: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.phValues);
      updated[resolvedScope] = AsyncValue.error(e, st);
      state = state.copyWith(phValues: updated);
    }
  }

  /// Set soil pH value
  ///
  /// [scopeKey] Scope identifier
  /// [value] pH value (will be automatically rounded to 0.5 step)
  Future<void> setPH(String scopeKey, double value) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.phValues);
      updated[resolvedScope] = const AsyncValue.loading();
      state = state.copyWith(phValues: updated);

      final rounded = _round(value);
      await _repo.setSoilPH(resolvedScope, rounded);

      updated[resolvedScope] = AsyncValue.data(rounded);
      state = state.copyWith(phValues: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.phValues);
      updated[resolvedScope] = AsyncValue.error(e, st);
      state = state.copyWith(phValues: updated);
    }
  }

  /// Adjust pH by a specific amount
  ///
  /// [scopeKey] Scope identifier
  /// [adjustment] Amount to adjust pH by (can be positive or negative)
  Future<void> adjustPH(String scopeKey, double adjustment) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final currentPH = state.phValues[resolvedScope]?.value ??
          (await _repo.getSoilPH(resolvedScope)) ??
          6.5;
      final newPH = currentPH + adjustment;
      await setPH(resolvedScope, newPH);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.phValues);
      updated[resolvedScope] = AsyncValue.error(e, st);
      state = state.copyWith(phValues: updated);
    }
  }

  /// Get next pH step up
  Future<void> nextStep(String scopeKey) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final currentPH = state.phValues[resolvedScope]?.value ??
          (await _repo.getSoilPH(resolvedScope)) ??
          6.5;
      final nextPH = _round.nextStep(currentPH);
      await setPH(resolvedScope, nextPH);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.phValues);
      updated[resolvedScope] = AsyncValue.error(e, st);
      state = state.copyWith(phValues: updated);
    }
  }

  /// Get previous pH step down
  Future<void> previousStep(String scopeKey) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final currentPH = state.phValues[resolvedScope]?.value ??
          (await _repo.getSoilPH(resolvedScope)) ??
          6.5;
      final prevPH = _round.previousStep(currentPH);
      await setPH(resolvedScope, prevPH);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.phValues);
      updated[resolvedScope] = AsyncValue.error(e, st);
      state = state.copyWith(phValues: updated);
    }
  }

  /// Get pH category description
  String getCategory(String scopeKey) {
    final resolvedScope = _resolveScopeKey(scopeKey);
    final currentPH = state.phValues[resolvedScope]?.value ?? 6.5;
    return _round.getCategory(currentPH);
  }

  /// Check if pH is optimal for most plants
  bool isOptimalForMostPlants(String scopeKey) {
    final resolvedScope = _resolveScopeKey(scopeKey);
    final currentPH = state.phValues[resolvedScope]?.value ?? 6.5;
    return _round.isOptimalForMostPlants(currentPH);
  }

  /// Get distance to nearest optimal pH step
  double getDistanceToOptimal(String scopeKey) {
    final resolvedScope = _resolveScopeKey(scopeKey);
    final currentPH = state.phValues[resolvedScope]?.value ?? 6.5;
    return _round.distanceToOptimal(currentPH);
  }

  /// Get all available pH steps
  List<double> getAllSteps() {
    return _round.getAllSteps();
  }

  /// Get pH steps within a range
  List<double> getStepsInRange(double min, double max) {
    return _round.getStepsInRange(min, max);
  }

  /// Get pH information summary
  Map<String, dynamic> getPHInfo(String scopeKey) {
    final resolvedScope = _resolveScopeKey(scopeKey);
    final currentPH = state.phValues[resolvedScope]?.value ?? 6.5;
    return {
      'currentPH': currentPH,
      'roundedPH': _round(currentPH),
      'category': _round.getCategory(currentPH),
      'isOptimal': _round.isOptimalForMostPlants(currentPH),
      'distanceToOptimal': _round.distanceToOptimal(currentPH),
      'nextStep': _round.nextStep(currentPH),
      'previousStep': _round.previousStep(currentPH),
    };
  }

  /// Refresh soil pH from repository
  Future<void> refresh(String scopeKey) async {
    await load(scopeKey);
  }

  /// Reset soil pH to null
  Future<void> reset(String scopeKey) async {
    final resolvedScope = _resolveScopeKey(scopeKey);

    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.phValues);
      updated[resolvedScope] = const AsyncValue.loading();
      state = state.copyWith(phValues: updated);

      await _repo.deleteMetrics(resolvedScope);

      updated[resolvedScope] = const AsyncValue.data(null);
      state = state.copyWith(phValues: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.phValues);
      updated[resolvedScope] = AsyncValue.error(e, st);
      state = state.copyWith(phValues: updated);
    }
  }
}

/// Provider for soil pH controller (family per scope)
final soilPHProvider =
    NotifierProvider.family<SoilPHController, SoilPHState, String?>(
  SoilPHController.new,
);

/// Provider that exposes the pH for a specific scope
final soilPHProviderByScope =
    Provider.family<AsyncValue<double?>, String>((ref, scopeKey) {
  final controller = ref.watch(soilPHProvider(scopeKey));
  final ph = controller.getPH(scopeKey);

  // Load data if not already loaded
  if (ph.isLoading) {
    Future.microtask(() {
      ref.read(soilPHProvider(scopeKey).notifier).load(scopeKey);
    });
  }

  return ph;
});
