## plantEvolutionHistoryProvider
defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:25
usages: 19
provider_type: FutureProvider

### Before (excerpt)
`dart
/// - RÃ©cupÃ©rer l'historique complet depuis IAnalyticsRepository
/// - GÃ©rer les Ã©tats: loading, data, error
/// - Mise en cache automatique par Riverpod
/// - Auto-refresh possible via ref.invalidate()
final plantEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, String>((ref, plantId) async {
  final analyticsRepo =
      ref.read(IntelligenceModule.analyticsRepositoryProvider);
  return await analyticsRepo.getEvolutionReports(plantId);
});

/// Provider pour filtrer les Ã©volutions par pÃ©riode
///
`"
  ## plantEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:25 usages: 19 provider_type: FutureProvider  ### Before (excerpt) `dart /// - RÃ©cupÃ©rer l'historique complet depuis IAnalyticsRepository
/// - GÃ©rer les Ã©tats: loading, data, error
/// - Mise en cache automatique par Riverpod
/// - Auto-refresh possible via ref.invalidate()
final plantEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, String>((ref, plantId) async {
  final analyticsRepo =
      ref.read(IntelligenceModule.analyticsRepositoryProvider);
  return await analyticsRepo.getEvolutionReports(plantId);
});

/// Provider pour filtrer les Ã©volutions par pÃ©riode
/// += "

  if (/// **Usage:**
/// ```dart
/// final evolutionsAsync = ref.watch(plantEvolutionHistoryProvider('plantId'));
///
/// evolutionsAsync.when(
///   data: (evolutions) => PlantEvolutionTimeline(evolutions: evolutions),) {
    ## plantEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:25 usages: 19 provider_type: FutureProvider  ### Before (excerpt) `dart /// - RÃ©cupÃ©rer l'historique complet depuis IAnalyticsRepository
/// - GÃ©rer les Ã©tats: loading, data, error
/// - Mise en cache automatique par Riverpod
/// - Auto-refresh possible via ref.invalidate()
final plantEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, String>((ref, plantId) async {
  final analyticsRepo =
      ref.read(IntelligenceModule.analyticsRepositoryProvider);
  return await analyticsRepo.getEvolutionReports(plantId);
});

/// Provider pour filtrer les Ã©volutions par pÃ©riode
/// += 
_first call_: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:11
`dart
/// **Usage:**
/// ```dart
/// final evolutionsAsync = ref.watch(plantEvolutionHistoryProvider('plantId'));
///
/// evolutionsAsync.when(
///   data: (evolutions) => PlantEvolutionTimeline(evolutions: evolutions),
`"
    ## plantEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:25 usages: 19 provider_type: FutureProvider  ### Before (excerpt) `dart /// - RÃ©cupÃ©rer l'historique complet depuis IAnalyticsRepository
/// - GÃ©rer les Ã©tats: loading, data, error
/// - Mise en cache automatique par Riverpod
/// - Auto-refresh possible via ref.invalidate()
final plantEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, String>((ref, plantId) async {
  final analyticsRepo =
      ref.read(IntelligenceModule.analyticsRepositoryProvider);
  return await analyticsRepo.getEvolutionReports(plantId);
});

/// Provider pour filtrer les Ã©volutions par pÃ©riode
/// `"
  ## plantEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:25 usages: 19 provider_type: FutureProvider  ### Before (excerpt) `dart /// - RÃ©cupÃ©rer l'historique complet depuis IAnalyticsRepository
/// - GÃ©rer les Ã©tats: loading, data, error
/// - Mise en cache automatique par Riverpod
/// - Auto-refresh possible via ref.invalidate()
final plantEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, String>((ref, plantId) async {
  final analyticsRepo =
      ref.read(IntelligenceModule.analyticsRepositoryProvider);
  return await analyticsRepo.getEvolutionReports(plantId);
});

/// Provider pour filtrer les Ã©volutions par pÃ©riode
/// += "

  if (/// **Usage:**
/// ```dart
/// final evolutionsAsync = ref.watch(plantEvolutionHistoryProvider('plantId'));
///
/// evolutionsAsync.when(
///   data: (evolutions) => PlantEvolutionTimeline(evolutions: evolutions),) {
    ## plantEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:25 usages: 19 provider_type: FutureProvider  ### Before (excerpt) `dart /// - RÃ©cupÃ©rer l'historique complet depuis IAnalyticsRepository
/// - GÃ©rer les Ã©tats: loading, data, error
/// - Mise en cache automatique par Riverpod
/// - Auto-refresh possible via ref.invalidate()
final plantEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, String>((ref, plantId) async {
  final analyticsRepo =
      ref.read(IntelligenceModule.analyticsRepositoryProvider);
  return await analyticsRepo.getEvolutionReports(plantId);
});

/// Provider pour filtrer les Ã©volutions par pÃ©riode
/// +=  _first call_: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:11 `dart /// **Usage:**
/// ```dart
/// final evolutionsAsync = ref.watch(plantEvolutionHistoryProvider('plantId'));
///
/// evolutionsAsync.when(
///   data: (evolutions) => PlantEvolutionTimeline(evolutions: evolutions), += "
  }

  ## plantEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:25 usages: 19 provider_type: FutureProvider  ### Before (excerpt) `dart /// - RÃ©cupÃ©rer l'historique complet depuis IAnalyticsRepository
/// - GÃ©rer les Ã©tats: loading, data, error
/// - Mise en cache automatique par Riverpod
/// - Auto-refresh possible via ref.invalidate()
final plantEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, String>((ref, plantId) async {
  final analyticsRepo =
      ref.read(IntelligenceModule.analyticsRepositoryProvider);
  return await analyticsRepo.getEvolutionReports(plantId);
});

/// Provider pour filtrer les Ã©volutions par pÃ©riode
/// `"
  ## plantEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:25 usages: 19 provider_type: FutureProvider  ### Before (excerpt) `dart /// - RÃ©cupÃ©rer l'historique complet depuis IAnalyticsRepository
/// - GÃ©rer les Ã©tats: loading, data, error
/// - Mise en cache automatique par Riverpod
/// - Auto-refresh possible via ref.invalidate()
final plantEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, String>((ref, plantId) async {
  final analyticsRepo =
      ref.read(IntelligenceModule.analyticsRepositoryProvider);
  return await analyticsRepo.getEvolutionReports(plantId);
});

/// Provider pour filtrer les Ã©volutions par pÃ©riode
/// += "

  if (/// **Usage:**
/// ```dart
/// final evolutionsAsync = ref.watch(plantEvolutionHistoryProvider('plantId'));
///
/// evolutionsAsync.when(
///   data: (evolutions) => PlantEvolutionTimeline(evolutions: evolutions),) {
    ## plantEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:25 usages: 19 provider_type: FutureProvider  ### Before (excerpt) `dart /// - RÃ©cupÃ©rer l'historique complet depuis IAnalyticsRepository
/// - GÃ©rer les Ã©tats: loading, data, error
/// - Mise en cache automatique par Riverpod
/// - Auto-refresh possible via ref.invalidate()
final plantEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, String>((ref, plantId) async {
  final analyticsRepo =
      ref.read(IntelligenceModule.analyticsRepositoryProvider);
  return await analyticsRepo.getEvolutionReports(plantId);
});

/// Provider pour filtrer les Ã©volutions par pÃ©riode
/// +=  _first call_: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:11 `dart /// **Usage:**
/// ```dart
/// final evolutionsAsync = ref.watch(plantEvolutionHistoryProvider('plantId'));
///
/// evolutionsAsync.when(
///   data: (evolutions) => PlantEvolutionTimeline(evolutions: evolutions), += 
1. Convert the provider definition to $familyType and add a positional parameter in the closure: (ref, param) => ....
2. Thread the new parameter through the provider logic (state, repository lookups, keys) so each invocation is scoped correctly.
3. Update every ef.watch/ef.read call to pass the parameter explicitly (e.g. ef.watch(plantEvolutionHistoryProvider(param))).
4. Adjust any helper methods or widgets that previously consumed $prov to accept and forward the parameter.
5. Add or update tests that cover at least two parameter values to confirm the .family conversion.

### Review checklist
- [ ] Ensure the parameter type is explicit in the .family generics.
- [ ] Confirm no lingering zero-argument usages remain.
- [ ] Consider memoization or caching impacts after .family migration.

