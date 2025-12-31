import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/soil_metrics_repository.dart';
import '../../domain/usecases/compute_soil_temp_next_day_usecase.dart';
import 'soil_metrics_repository_provider.dart';
import 'weather_providers.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';

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
  SoilMetricsRepository get _repo => ref.watch(soilMetricsRepositoryProvider);
  final _compute = ComputeSoilTempNextDayUsecase();

  @override
  SoilTempState build() {
    return const SoilTempState(temperatures: {});
  }

  /// Load soil temperature from repository
  Future<void> load(String scopeKey) async {
    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[scopeKey] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      final temp = await _repo.getSoilTempC(scopeKey);

      updated[scopeKey] = AsyncValue.data(temp);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[scopeKey] = AsyncValue.error(e, st);
      state = state.copyWith(temperatures: updated);
    }
  }

  /// Set manual soil temperature with 'Soft Recalibration'
  ///
  /// [scopeKey] Scope identifier
  /// [tempC] Temperature in Celsius
  Future<void> setManual(String scopeKey, double tempC) async {
    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[scopeKey] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      // Direct override with measured value (explicit user measurement).
      final double finalTemp = tempC;

      await _repo.setSoilTempC(scopeKey, finalTemp);
      await _repo.setLastUpdated(scopeKey, DateTime.now());

      updated[scopeKey] = AsyncValue.data(finalTemp);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[scopeKey] = AsyncValue.error(e, st);
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
    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[scopeKey] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      // Get current soil temperature, fallback to air temperature if not available
      final currentSoilTemp = state.temperatures[scopeKey]?.value ??
          (await _repo.getSoilTempC(scopeKey)) ??
          airTempC;

      // Compute next day soil temperature
      final nextTemp = _compute(
        soilTempC: currentSoilTemp,
        airTempC: airTempC,
        alpha: alpha,
      );

      // Save the computed temperature
      await _repo.setSoilTempC(scopeKey, nextTemp);
      await _repo.setLastUpdated(scopeKey, DateTime.now());

      updated[scopeKey] = AsyncValue.data(nextTemp);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[scopeKey] = AsyncValue.error(e, st);
      state = state.copyWith(temperatures: updated);
    }
  }

  /// Check if soil temperature was updated today
  Future<bool> isUpdatedToday(String scopeKey) async {
    try {
      final lastUpdated = await _repo.getLastUpdated(scopeKey);
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
    try {
      final currentTemp = state.temperatures[scopeKey]?.value ??
          (await _repo.getSoilTempC(scopeKey)) ??
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
    try {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[scopeKey] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      await _repo.deleteMetrics(scopeKey);

      updated[scopeKey] = const AsyncValue.data(null);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<double?>>.from(state.temperatures);
      updated[scopeKey] = AsyncValue.error(e, st);
      state = state.copyWith(temperatures: updated);
    }
  }
}

/// Provider for soil temperature controller
final soilTempProvider =
    NotifierProvider<SoilTempController, SoilTempState>(SoilTempController.new);

/// Provider that exposes the temperature for a specific scope
final soilTempProviderByScope =
    Provider.family<AsyncValue<double?>, String>((ref, scopeKey) {
  final controller = ref.watch(soilTempProvider);
  final temp = controller.getTemp(scopeKey);

  // Load data if not already loaded
  if (temp.isLoading) {
    Future.microtask(() {
      ref.read(soilTempProvider.notifier).load(scopeKey);
    });
  }

  return temp;
});

// --- Forecast & Advice Logic ---

/// Data point for soil temperature forecast
class SoilTempForecastPoint {
  final DateTime date;
  final double tempC;

  SoilTempForecastPoint({required this.date, required this.tempC});
}

/// Computes 7-day soil temperature forecast based on current soil temp and air temp forecast
final soilTempForecastProvider =
    FutureProvider.family<List<SoilTempForecastPoint>, String>(
        (ref, scopeKey) async {
  // 1. Get current soil temperature
  // Lecture réactive de l'état du soilTempProvider.
  // Si la donnée est en cours de chargement, on demande un load en arrière-plan
  // via Future.microtask afin de ne pas modifier un autre provider pendant
  // l'initialisation du présent provider (évite l'assertion Riverpod).
  final soilState = ref.watch(soilTempProvider);
  final tempAsync = soilState.getTemp(scopeKey);

  if (tempAsync.isLoading) {
    // Demande asynchrone non bloquante du chargement.
    Future.microtask(() => ref.read(soilTempProvider.notifier).load(scopeKey));
  }

  final startSoilTemp = tempAsync.value ?? 0.0;

  // 2. Get air temperature forecast
  final forecastPoints = await ref.watch(forecastProvider.future);

  // 3. Compute trajectory
  final computeUsecase = ComputeSoilTempNextDayUsecase();
  final result = <SoilTempForecastPoint>[];

  // Initial point (Today/Now)
  result.add(SoilTempForecastPoint(date: DateTime.now(), tempC: startSoilTemp));

  double currentSoilC = startSoilTemp;
  final sortedForecast = List.of(forecastPoints)
    ..sort((a, b) => a.date.compareTo(b.date));

  for (final dayPoint in sortedForecast) {
    // Air temp for the day: arithmetic mean of min and max
    final tMin = dayPoint.tMinC ?? dayPoint.tMaxC ?? 15.0;
    final tMax = dayPoint.tMaxC ?? dayPoint.tMinC ?? 15.0;
    final meanAirTemp = (tMin + tMax) / 2;

    // Apply inertia model
    currentSoilC = computeUsecase(
      soilTempC: currentSoilC,
      airTempC: meanAirTemp,
      alpha: 0.15, // Default for loam, TODO: Make dynamic
    );

    result.add(SoilTempForecastPoint(date: dayPoint.date, tempC: currentSoilC));
  }

  return result;
});

/// Sowing advice status
enum SowingStatus {
  sowNow, // Prêt à semer
  sowSoon, // Bientôt prêt
  wait, // Attendre
  ideal // Optimal
}

/// Advice data wrapper
class SowingAdvice {
  final PlantFreezed plant;
  final SowingStatus status;
  final String reason;

  SowingAdvice({
    required this.plant,
    required this.status,
    required this.reason,
  });
}

/// Computes sowing advice for all plants based on soil temp forecast
final sowingAdviceProvider =
    FutureProvider.family<List<SowingAdvice>, String>((ref, scopeKey) async {
  final forecast = await ref.watch(soilTempForecastProvider(scopeKey).future);
  final plants = ref.watch(plantsListProvider);

  if (forecast.isEmpty) return [];

  final currentTemp = forecast.first.tempC;
  // Get 2-day min (Day 0, 1, 2)
  final nextDays = forecast.take(3).map((e) => e.tempC).toList();
  final minNext2Days =
      nextDays.isEmpty ? currentTemp : nextDays.reduce((a, b) => a < b ? a : b);

  final adviceList = <SowingAdvice>[];

  for (final plant in plants) {
    if (plant.germination == null) continue;
    final minGerm = plant.minGerminationTemperature;
    if (minGerm == null) continue;

    // Logic rules
    final optimalRange = plant.germination!['optimalTemperature'];
    double? optMin, optMax;
    if (optimalRange is Map) {
      optMin = (optimalRange['min'] as num?)?.toDouble();
      optMax = (optimalRange['max'] as num?)?.toDouble();
    }

    SowingStatus status = SowingStatus.wait;
    String reason =
        "Trop froid (${currentTemp.toStringAsFixed(1)}°C < $minGerm°C)";

    // Check Optimal
    if (optMin != null && optMax != null) {
      if (currentTemp >= optMin && currentTemp <= optMax) {
        status = SowingStatus.ideal;
        reason = "Température idéale ($optMin-$optMax°C)";
      }
    }

    // Check "Now" (if not already ideal)
    if (status != SowingStatus.ideal) {
      if (currentTemp >= minGerm && minNext2Days >= minGerm) {
        status = SowingStatus.sowNow;
        reason = "Conditions favorables (> $minGerm°C)";
      }
    }

    // Check "Soon"
    if (status == SowingStatus.wait) {
      // Check if forecast crosses threshold in 3-5 days
      // indices 3, 4, 5 (Day 3, 4, 5) if available
      bool crosses = false;
      for (int i = 3; i <= 5 && i < forecast.length; i++) {
        if (forecast[i].tempC >= minGerm) {
          crosses = true;
          break;
        }
      }
      if (crosses) {
        status = SowingStatus.sowSoon;
        reason = "Bientôt favorable (dans 3-5 jours)";
      }
    }

    adviceList.add(SowingAdvice(plant: plant, status: status, reason: reason));
  }

  // Sort: Ideal/Now first
  adviceList.sort((a, b) {
    final rankA = _rankStatus(a.status);
    final rankB = _rankStatus(b.status);
    return rankA.compareTo(rankB);
  });

  return adviceList;
});

int _rankStatus(SowingStatus s) {
  switch (s) {
    case SowingStatus.ideal:
      return 0;
    case SowingStatus.sowNow:
      return 1;
    case SowingStatus.sowSoon:
      return 2;
    case SowingStatus.wait:
      return 3;
  }
}
