## latestEvolutionProvider
defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:77
usages: 10
provider_type: FutureProvider

### Before (excerpt)
`dart

/// Provider pour obtenir la derniÃ¨re Ã©volution d'une plante
///
/// Pratique pour afficher uniquement le dernier changement dÃ©tectÃ©.
final latestEvolutionProvider = FutureProvider.autoDispose
    .family<PlantEvolutionReport?, String>((ref, plantId) async {
  final evolutions =
      await ref.watch(plantEvolutionHistoryProvider(plantId).future);

  if (evolutions.isEmpty) return null;

  // Les Ã©volutions sont dÃ©jÃ  triÃ©es par date dans le repository
  return evolutions.last;
`"
  ## latestEvolutionProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:77 usages: 10 provider_type: FutureProvider  ### Before (excerpt) `dart 
/// Provider pour obtenir la derniÃ¨re Ã©volution d'une plante
///
/// Pratique pour afficher uniquement le dernier changement dÃ©tectÃ©.
final latestEvolutionProvider = FutureProvider.autoDispose
    .family<PlantEvolutionReport?, String>((ref, plantId) async {
  final evolutions =
      await ref.watch(plantEvolutionHistoryProvider(plantId).future);

  if (evolutions.isEmpty) return null;

  // Les Ã©volutions sont dÃ©jÃ  triÃ©es par date dans le repository
  return evolutions.last; += "

  if (  Widget build(BuildContext context) {
    final latestEvolutionAsync =
        ref.watch(latestEvolutionProvider(widget.plantId));

    return latestEvolutionAsync.when(
      data: (latestEvolution) {) {
    ## latestEvolutionProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:77 usages: 10 provider_type: FutureProvider  ### Before (excerpt) `dart 
/// Provider pour obtenir la derniÃ¨re Ã©volution d'une plante
///
/// Pratique pour afficher uniquement le dernier changement dÃ©tectÃ©.
final latestEvolutionProvider = FutureProvider.autoDispose
    .family<PlantEvolutionReport?, String>((ref, plantId) async {
  final evolutions =
      await ref.watch(plantEvolutionHistoryProvider(plantId).future);

  if (evolutions.isEmpty) return null;

  // Les Ã©volutions sont dÃ©jÃ  triÃ©es par date dans le repository
  return evolutions.last; += 
_first call_: lib\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner.dart:76
`dart
  Widget build(BuildContext context) {
    final latestEvolutionAsync =
        ref.watch(latestEvolutionProvider(widget.plantId));

    return latestEvolutionAsync.when(
      data: (latestEvolution) {
`"
    ## latestEvolutionProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:77 usages: 10 provider_type: FutureProvider  ### Before (excerpt) `dart 
/// Provider pour obtenir la derniÃ¨re Ã©volution d'une plante
///
/// Pratique pour afficher uniquement le dernier changement dÃ©tectÃ©.
final latestEvolutionProvider = FutureProvider.autoDispose
    .family<PlantEvolutionReport?, String>((ref, plantId) async {
  final evolutions =
      await ref.watch(plantEvolutionHistoryProvider(plantId).future);

  if (evolutions.isEmpty) return null;

  // Les Ã©volutions sont dÃ©jÃ  triÃ©es par date dans le repository
  return evolutions.last; `"
  ## latestEvolutionProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:77 usages: 10 provider_type: FutureProvider  ### Before (excerpt) `dart 
/// Provider pour obtenir la derniÃ¨re Ã©volution d'une plante
///
/// Pratique pour afficher uniquement le dernier changement dÃ©tectÃ©.
final latestEvolutionProvider = FutureProvider.autoDispose
    .family<PlantEvolutionReport?, String>((ref, plantId) async {
  final evolutions =
      await ref.watch(plantEvolutionHistoryProvider(plantId).future);

  if (evolutions.isEmpty) return null;

  // Les Ã©volutions sont dÃ©jÃ  triÃ©es par date dans le repository
  return evolutions.last; += "

  if (  Widget build(BuildContext context) {
    final latestEvolutionAsync =
        ref.watch(latestEvolutionProvider(widget.plantId));

    return latestEvolutionAsync.when(
      data: (latestEvolution) {) {
    ## latestEvolutionProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:77 usages: 10 provider_type: FutureProvider  ### Before (excerpt) `dart 
/// Provider pour obtenir la derniÃ¨re Ã©volution d'une plante
///
/// Pratique pour afficher uniquement le dernier changement dÃ©tectÃ©.
final latestEvolutionProvider = FutureProvider.autoDispose
    .family<PlantEvolutionReport?, String>((ref, plantId) async {
  final evolutions =
      await ref.watch(plantEvolutionHistoryProvider(plantId).future);

  if (evolutions.isEmpty) return null;

  // Les Ã©volutions sont dÃ©jÃ  triÃ©es par date dans le repository
  return evolutions.last; +=  _first call_: lib\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner.dart:76 `dart   Widget build(BuildContext context) {
    final latestEvolutionAsync =
        ref.watch(latestEvolutionProvider(widget.plantId));

    return latestEvolutionAsync.when(
      data: (latestEvolution) { += "
  }

  ## latestEvolutionProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:77 usages: 10 provider_type: FutureProvider  ### Before (excerpt) `dart 
/// Provider pour obtenir la derniÃ¨re Ã©volution d'une plante
///
/// Pratique pour afficher uniquement le dernier changement dÃ©tectÃ©.
final latestEvolutionProvider = FutureProvider.autoDispose
    .family<PlantEvolutionReport?, String>((ref, plantId) async {
  final evolutions =
      await ref.watch(plantEvolutionHistoryProvider(plantId).future);

  if (evolutions.isEmpty) return null;

  // Les Ã©volutions sont dÃ©jÃ  triÃ©es par date dans le repository
  return evolutions.last; `"
  ## latestEvolutionProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:77 usages: 10 provider_type: FutureProvider  ### Before (excerpt) `dart 
/// Provider pour obtenir la derniÃ¨re Ã©volution d'une plante
///
/// Pratique pour afficher uniquement le dernier changement dÃ©tectÃ©.
final latestEvolutionProvider = FutureProvider.autoDispose
    .family<PlantEvolutionReport?, String>((ref, plantId) async {
  final evolutions =
      await ref.watch(plantEvolutionHistoryProvider(plantId).future);

  if (evolutions.isEmpty) return null;

  // Les Ã©volutions sont dÃ©jÃ  triÃ©es par date dans le repository
  return evolutions.last; += "

  if (  Widget build(BuildContext context) {
    final latestEvolutionAsync =
        ref.watch(latestEvolutionProvider(widget.plantId));

    return latestEvolutionAsync.when(
      data: (latestEvolution) {) {
    ## latestEvolutionProvider defined_in: lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:77 usages: 10 provider_type: FutureProvider  ### Before (excerpt) `dart 
/// Provider pour obtenir la derniÃ¨re Ã©volution d'une plante
///
/// Pratique pour afficher uniquement le dernier changement dÃ©tectÃ©.
final latestEvolutionProvider = FutureProvider.autoDispose
    .family<PlantEvolutionReport?, String>((ref, plantId) async {
  final evolutions =
      await ref.watch(plantEvolutionHistoryProvider(plantId).future);

  if (evolutions.isEmpty) return null;

  // Les Ã©volutions sont dÃ©jÃ  triÃ©es par date dans le repository
  return evolutions.last; +=  _first call_: lib\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner.dart:76 `dart   Widget build(BuildContext context) {
    final latestEvolutionAsync =
        ref.watch(latestEvolutionProvider(widget.plantId));

    return latestEvolutionAsync.when(
      data: (latestEvolution) { += 
1. Convert the provider definition to $familyType and add a positional parameter in the closure: (ref, param) => ....
2. Thread the new parameter through the provider logic (state, repository lookups, keys) so each invocation is scoped correctly.
3. Update every ef.watch/ef.read call to pass the parameter explicitly (e.g. ef.watch(latestEvolutionProvider(param))).
4. Adjust any helper methods or widgets that previously consumed $prov to accept and forward the parameter.
5. Add or update tests that cover at least two parameter values to confirm the .family conversion.

### Review checklist
- [ ] Ensure the parameter type is explicit in the .family generics.
- [ ] Confirm no lingering zero-argument usages remain.
- [ ] Consider memoization or caching impacts after .family migration.

