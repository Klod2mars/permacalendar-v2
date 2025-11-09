## filteredEvolutionHistoryProvider
defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:43
usages: 3
provider_type: FutureProvider

### Before (excerpt)
`dart
/// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
final filteredEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, FilterParams>((ref, params) async {
  final allEvolutions =
      await ref.watch(plantEvolutionHistoryProvider(params.plantId).future);

  if (params.days == null) {
    return allEvolutions;
  }

`"
  ## filteredEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:43 usages: 3 provider_type: FutureProvider  ### Before (excerpt) `dart /// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
final filteredEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, FilterParams>((ref, params) async {
  final allEvolutions =
      await ref.watch(plantEvolutionHistoryProvider(params.plantId).future);

  if (params.days == null) {
    return allEvolutions;
  }
 += "

  if (/// **Usage:**
/// ```dart
/// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```) {
    ## filteredEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:43 usages: 3 provider_type: FutureProvider  ### Before (excerpt) `dart /// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
final filteredEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, FilterParams>((ref, params) async {
  final allEvolutions =
      await ref.watch(plantEvolutionHistoryProvider(params.plantId).future);

  if (params.days == null) {
    return allEvolutions;
  }
 += 
_first call_: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:39
`dart
/// **Usage:**
/// ```dart
/// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
`"
    ## filteredEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:43 usages: 3 provider_type: FutureProvider  ### Before (excerpt) `dart /// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
final filteredEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, FilterParams>((ref, params) async {
  final allEvolutions =
      await ref.watch(plantEvolutionHistoryProvider(params.plantId).future);

  if (params.days == null) {
    return allEvolutions;
  }
 `"
  ## filteredEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:43 usages: 3 provider_type: FutureProvider  ### Before (excerpt) `dart /// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
final filteredEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, FilterParams>((ref, params) async {
  final allEvolutions =
      await ref.watch(plantEvolutionHistoryProvider(params.plantId).future);

  if (params.days == null) {
    return allEvolutions;
  }
 += "

  if (/// **Usage:**
/// ```dart
/// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```) {
    ## filteredEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:43 usages: 3 provider_type: FutureProvider  ### Before (excerpt) `dart /// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
final filteredEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, FilterParams>((ref, params) async {
  final allEvolutions =
      await ref.watch(plantEvolutionHistoryProvider(params.plantId).future);

  if (params.days == null) {
    return allEvolutions;
  }
 +=  _first call_: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:39 `dart /// **Usage:**
/// ```dart
/// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ``` += "
  }

  ## filteredEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:43 usages: 3 provider_type: FutureProvider  ### Before (excerpt) `dart /// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
final filteredEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, FilterParams>((ref, params) async {
  final allEvolutions =
      await ref.watch(plantEvolutionHistoryProvider(params.plantId).future);

  if (params.days == null) {
    return allEvolutions;
  }
 `"
  ## filteredEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:43 usages: 3 provider_type: FutureProvider  ### Before (excerpt) `dart /// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
final filteredEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, FilterParams>((ref, params) async {
  final allEvolutions =
      await ref.watch(plantEvolutionHistoryProvider(params.plantId).future);

  if (params.days == null) {
    return allEvolutions;
  }
 += "

  if (/// **Usage:**
/// ```dart
/// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```) {
    ## filteredEvolutionHistoryProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:43 usages: 3 provider_type: FutureProvider  ### Before (excerpt) `dart /// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
final filteredEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, FilterParams>((ref, params) async {
  final allEvolutions =
      await ref.watch(plantEvolutionHistoryProvider(params.plantId).future);

  if (params.days == null) {
    return allEvolutions;
  }
 +=  _first call_: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:39 `dart /// **Usage:**
/// ```dart
/// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ``` += 
1. Convert the provider definition to $familyType and add a positional parameter in the closure: (ref, param) => ....
2. Thread the new parameter through the provider logic (state, repository lookups, keys) so each invocation is scoped correctly.
3. Update every ef.watch/ef.read call to pass the parameter explicitly (e.g. ef.watch(filteredEvolutionHistoryProvider(param))).
4. Adjust any helper methods or widgets that previously consumed $prov to accept and forward the parameter.
5. Add or update tests that cover at least two parameter values to confirm the .family conversion.

### Review checklist
- [ ] Ensure the parameter type is explicit in the .family generics.
- [ ] Confirm no lingering zero-argument usages remain.
- [ ] Consider memoization or caching impacts after .family migration.

