import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/soil_metrics_repository.dart';
import '../../data/datasources/soil_metrics_local_ds.dart';
import '../../domain/usecases/compute_soil_temp_next_day_usecase.dart';
import 'soil_metrics_repository_provider.dart';
import 'weather_providers.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../../core/models/daily_weather_point.dart';

/// State for soil temperature by scope
class SoilTempState {
  final Map<String, AsyncValue<SoilMetricsDto?>> temperatures;

  const SoilTempState({
    required this.temperatures,
  });

  SoilTempState copyWith({
    Map<String, AsyncValue<SoilMetricsDto?>>? temperatures,
  }) {
    return SoilTempState(
      temperatures: temperatures ?? this.temperatures,
    );
  }

  AsyncValue<SoilMetricsDto?> getMetrics(String scopeKey) {
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

  // --- Guard to avoid concurrent loads for same scope
  final Set<String> _loadingScopes = {};

  @override
  SoilTempState build() {
    return const SoilTempState(temperatures: {});
  }

  /// Load soil temperature from repository
  ///
  /// Recalculates estimated temperature if necessary based on anchor.
  Future<void> load(String scopeKey) async {
    // If a load for this scopeKey is already in-progress, return early.
    if (_loadingScopes.contains(scopeKey)) return;
    _loadingScopes.add(scopeKey);
    print('[SoilTempController] Loading for scope: $scopeKey');
    try {
      final updated = Map<String, AsyncValue<SoilMetricsDto?>>.from(state.temperatures);
      updated[scopeKey] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);
      
      final metricsMap = await _repo.getAllMetrics(scopeKey);
      print('[SoilTempController] Loaded metricsMap: $metricsMap');
      
      SoilMetricsDto? dto;
      if (metricsMap != null) {
         dto = SoilMetricsDto.create(
           soilTempEstimatedC: metricsMap['soilTempEstimatedC'] as double? ?? metricsMap['soilTempC'] as double?,
           soilPH: metricsMap['soilPH'] as double?,
           lastComputed: metricsMap['lastComputed'] as DateTime? ?? metricsMap['lastUpdated'] as DateTime?,
           anchorTempC: metricsMap['anchorTempC'] as double?,
           anchorTimestamp: metricsMap['anchorTimestamp'] as DateTime?,
         );
         print('[SoilTempController] Parsed DTO: $dto');
      } else {
         print('[SoilTempController] No metrics found for $scopeKey');
      }

      if (dto != null) {
        // Re-computation Logic
        if (dto.anchorTimestamp != null && dto.lastComputed != null) {
           final today = DateTime.now();
           final todayDate = DateTime(today.year, today.month, today.day);
           final lastComputedDate = DateTime(dto.lastComputed!.year, dto.lastComputed!.month, dto.lastComputed!.day);

           if (lastComputedDate.isBefore(todayDate)) {
             print('[SoilTempController] Catch-up needed. Last computed: $lastComputedDate');
             // Need to catch up
             double currentSoil = dto.soilTempEstimatedC ?? dto.anchorTempC ?? 0.0;
             // If last computed is far behind, we might want to start from anchor if anchor is more recent than last computed?
             // Usually lastComputed >= anchorTimestamp.
             
             // Get historical/forecast data
             // We need data from lastComputedDate + 1 day UNTIL today.
             final catchUpDays = todayDate.difference(lastComputedDate).inDays;
             
             if (catchUpDays > 0) {
               final forecastPoints = await ref.read(forecastProvider.future); 
               // Note: reading provider inside async method.
               
               DateTime simulationDate = lastComputedDate;
               
               for (int i = 0; i < catchUpDays; i++) {
                 simulationDate = simulationDate.add(const Duration(days: 1));
                 
                 // Find air temp for simulationDate
                 // Simple lookup
                 final point = forecastPoints.firstWhere(
                   (p) => p.date.year == simulationDate.year && 
                          p.date.month == simulationDate.month && 
                          p.date.day == simulationDate.day,
                   orElse: () => forecastPoints.isNotEmpty ? forecastPoints.first : (throw "No weather data"), // Fallback?
                 );
                 
                 // If we found a point (or fallback)
                 if (forecastPoints.contains(point)) {
                    final tMin = point.tMinC ?? point.tMaxC ?? 15.0;
                    final tMax = point.tMaxC ?? point.tMinC ?? 15.0;
                    final meanAir = (tMin + tMax) / 2;
                    
                    currentSoil = _compute(
                      soilTempC: currentSoil, 
                      airTempC: meanAir, 
                      alpha: 0.15
                    );
                 }
               }
               
               print('[SoilTempController] Catch-up done. New Estimated: $currentSoil');

               // Update DTO
               dto = dto.copyWith(
                 soilTempEstimatedC: currentSoil,
                 lastComputed: DateTime.now(),
               );
               
               // Persist updated estimation
               await _repo.setEstimatedTemp(scopeKey, currentSoil, DateTime.now());
             }
           }
        }
      }

      updated[scopeKey] = AsyncValue.data(dto);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      print('[SoilTempController] Error loading: $e');
      final updated = Map<String, AsyncValue<SoilMetricsDto?>>.from(state.temperatures);
      updated[scopeKey] = AsyncValue.error(e, st);
      state = state.copyWith(temperatures: updated);
    } finally {
      _loadingScopes.remove(scopeKey);
    }
  }

  /// Set manual soil temperature with 'Soft Recalibration'
  ///
  /// [scopeKey] Scope identifier
  /// [tempC] Temperature in Celsius
  Future<void> setManual(String scopeKey, double tempC) async {
    print('[SoilTempController] setting Manual Anchor: $tempC for $scopeKey');
    try {
      final updated = Map<String, AsyncValue<SoilMetricsDto?>>.from(state.temperatures);
      updated[scopeKey] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      // Direct override with measured value (explicit user measurement).
      final double finalTemp = tempC;
      final now = DateTime.now();

      await _repo.setManualAnchor(scopeKey, finalTemp, now);

      // Construct new DTO for state
      final newDto = SoilMetricsDto(
        soilTempEstimatedC: finalTemp,
        anchorTempC: finalTemp,
        anchorTimestamp: now,
        lastComputed: now,
      );

      updated[scopeKey] = AsyncValue.data(newDto);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      print('[SoilTempController] Error setting manual: $e');
      final updated = Map<String, AsyncValue<SoilMetricsDto?>>.from(state.temperatures);
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
      final updated = Map<String, AsyncValue<SoilMetricsDto?>>.from(state.temperatures);
      updated[scopeKey] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      // Get current soil temperature from state or repo
      var dto = state.temperatures[scopeKey]?.value;
      if (dto == null) {
         final map = await _repo.getAllMetrics(scopeKey);
         if (map != null) {
            dto = SoilMetricsDto.create(
               soilTempEstimatedC: map['soilTempEstimatedC'] as double?,
               lastComputed: map['lastComputed'] as DateTime?,
               anchorTempC: map['anchorTempC'] as double?,
               anchorTimestamp: map['anchorTimestamp'] as DateTime?,
            );
         }
      }

      final currentSoilTemp = dto?.soilTempEstimatedC ?? airTempC;

      // Compute next day soil temperature
      final nextTemp = _compute(
        soilTempC: currentSoilTemp,
        airTempC: airTempC,
        alpha: alpha,
      );

      // Save the computed temperature
      await _repo.setEstimatedTemp(scopeKey, nextTemp, DateTime.now());
      
      // Update internal state
      final newDto = dto?.copyWith(
         soilTempEstimatedC: nextTemp,
         lastComputed: DateTime.now(),
      ) ?? SoilMetricsDto.create(
         soilTempEstimatedC: nextTemp,
         lastComputed: DateTime.now(),
      );

      updated[scopeKey] = AsyncValue.data(newDto);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<SoilMetricsDto?>>.from(state.temperatures);
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
       // Need to resolve current temp properly
       var temp = state.temperatures[scopeKey]?.value?.soilTempEstimatedC;
       if (temp == null) {
         final map = await _repo.getAllMetrics(scopeKey);
         temp = map?['soilTempEstimatedC'] as double?;
       }
       
      final currentTemp = temp ?? airTempC;
          
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
      final updated = Map<String, AsyncValue<SoilMetricsDto?>>.from(state.temperatures);
      updated[scopeKey] = const AsyncValue.loading();
      state = state.copyWith(temperatures: updated);

      await _repo.deleteMetrics(scopeKey);

      updated[scopeKey] = const AsyncValue.data(null);
      state = state.copyWith(temperatures: updated);
    } catch (e, st) {
      final updated = Map<String, AsyncValue<SoilMetricsDto?>>.from(state.temperatures);
      updated[scopeKey] = AsyncValue.error(e, st);
      state = state.copyWith(temperatures: updated);
    }
  }
}

/// Provider for soil temperature controller
final soilTempProvider =
    NotifierProvider<SoilTempController, SoilTempState>(SoilTempController.new);

/// Provider that exposes the temperature for a specific scope (Estimated)
final soilTempProviderByScope =
    Provider.family<AsyncValue<double?>, String>((ref, scopeKey) {
  final controller = ref.watch(soilTempProvider);
  final dtoAsync = controller.getMetrics(scopeKey);

  // Load data only once: schedule load only if we don't yet have an entry
  // in the controller state for this scopeKey. We call load immediately
  // (not via microtask) — the controller itself guards concurrent invocations.
  if (!controller.temperatures.containsKey(scopeKey)) {
    ref.read(soilTempProvider.notifier).load(scopeKey);
  }
  
  return dtoAsync.whenData((dto) => dto?.soilTempEstimatedC);
});

// --- Forecast & Advice Logic ---
// ... (Forecast logic needs to adapt to reading DTO)


// --- Forecast & Advice Logic ---

/// Data point for soil temperature forecast
class SoilTempForecastPoint {
  final DateTime date;
  final double tempC;

  SoilTempForecastPoint({required this.date, required this.tempC});
}

/// Provider producing a list of SoilTempForecastPoint for charting
final soilTempForecastProvider =
    FutureProvider.family<List<SoilTempForecastPoint>, String>((ref, scopeKey) async {
  // 1) Ensure we have the current estimated soil temp (or anchor)
  final soilTempAsync = ref.watch(soilTempProviderByScope(scopeKey));
  final SoilMetricsDto? dto = ref.watch(soilTempProvider).getMetrics(scopeKey).value;
  // If the DTO isn't ready yet, wait for it explicitly so we have the starting point.
  double? startSoil = soilTempAsync.value;
  if (startSoil == null && dto == null) {
    // Force load if needed
    Future.microtask(() => ref.read(soilTempProvider.notifier).load(scopeKey));
    // We might not get it immediately, but let's try reading again or wait?
    // User suggestion used await ref.read(...).load(). 
    // load() is async Future<void>. So we can await it.
    await ref.read(soilTempProvider.notifier).load(scopeKey);
    // Refresh local reading
    startSoil = ref.read(soilTempProvider).getMetrics(scopeKey).value?.soilTempEstimatedC;
  }
  
  // Now get fresh DTO/value
  final SoilMetricsDto? finalDto = ref.read(soilTempProvider).getMetrics(scopeKey).value;
  startSoil = startSoil ?? finalDto?.soilTempEstimatedC ?? finalDto?.anchorTempC;

  // 2) If still null, fallback to today's air mean temp
  final forecastPoints = await ref.read(forecastProvider.future); // existing provider
  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);

  double startingSoilTemp;
  if (startSoil != null) {
    startingSoilTemp = startSoil;
  } else {
    if (forecastPoints.isEmpty) {
       // Total fallback if no weather
       return [SoilTempForecastPoint(date: todayDate, tempC: 10.0)];
    }
    // compute today's mean air temp from forecast
    final todayPoint = forecastPoints.firstWhere(
      (p) => p.date.year == todayDate.year && p.date.month == todayDate.month && p.date.day == todayDate.day,
      orElse: () => forecastPoints.first
    );
    final tMin = todayPoint.tMinC ?? todayPoint.tMaxC ?? 15.0;
    final tMax = todayPoint.tMaxC ?? todayPoint.tMinC ?? 15.0;
    startingSoilTemp = (tMin + tMax) / 2;
  }

  // 3) Build N days forecast starting from today using compute usecase
  const int days = 7;
  final compute = ComputeSoilTempNextDayUsecase();
  final List<SoilTempForecastPoint> out = [];

  // Add the first point = today with startingSoilTemp
  out.add(SoilTempForecastPoint(date: todayDate, tempC: startingSoilTemp));

  double currentSoil = startingSoilTemp;

  for (int i = 1; i < days; i++) {
    final simulationDate = todayDate.add(Duration(days: i));
    // find forecast point for that date
    final point = forecastPoints.firstWhere(
      (p) => p.date.year == simulationDate.year && p.date.month == simulationDate.month && p.date.day == simulationDate.day,
      orElse: () => forecastPoints.isNotEmpty ? forecastPoints.last : DailyWeatherPoint(date: simulationDate), // fallback
    );
     // Note: forecastPoints are likely SoilWeatherPoint or similar from weather_providers.dart? 
     // Checking Step 55 view_file: weather_providers.dart usage. 
     // The type is implicit in `ref.watch(forecastProvider.future)`.
     // If `forecastProvider` returns `List<DailyWeatherPoint>` (likely naming), then `tMinC` exists.
     // In Step 55, line 402 access `dayPoint.tMinC`.
     // I assume `forecastPoints` items have `tMinC`.

    double meanAir;
    // Check if point is valid (dummy check if fallback returned dummy)
    if (point.tMinC != null || point.tMaxC != null) {
      final tMin = point.tMinC ?? point.tMaxC ?? 15.0;
      final tMax = point.tMaxC ?? point.tMinC ?? 15.0;
      meanAir = (tMin + tMax) / 2;
    } else {
      // fallback if no weather data found/valid
      meanAir = currentSoil; // no change
    }

    // compute next day soil temperature using same alpha as controller (0.15)
    currentSoil = compute(soilTempC: currentSoil, airTempC: meanAir, alpha: 0.15);

    out.add(SoilTempForecastPoint(date: simulationDate, tempC: currentSoil));
  }

  return out;
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
    if (plant.germination == null) {
      // DEBUG: Inclure quand meme pour voir si la plante existe
      adviceList.add(SowingAdvice(plant: plant, status: SowingStatus.wait, reason: "Données de germination manquantes"));
      continue;
    }
    final minGerm = plant.minGerminationTemperature;
    if (minGerm == null) {
       adviceList.add(SowingAdvice(plant: plant, status: SowingStatus.wait, reason: "Température min. non définie"));
       continue;
    }

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
