# Provider family suggestions


## plantEvolutionHistoryProvider

- usages: 19
- defined_in: C:\Users\roman\Documents\apppklod\permacalendarv2\lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:25

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final plantEvolutionHistoryProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final plantEvolutionHistoryProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## soilTempProvider

- usages: 14
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final soilTempProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final soilTempProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## gardenBedProvider

- usages: 13
- defined_in: C:\Users\roman\Documents\apppklod\permacalendarv2\lib\features\garden_bed\providers\garden_bed_provider.dart:311

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final gardenBedProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final gardenBedProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## latestEvolutionProvider

- usages: 10
- defined_in: C:\Users\roman\Documents\apppklod\permacalendarv2\lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:77

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final latestEvolutionProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final latestEvolutionProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## soilPHProvider

- usages: 7
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final soilPHProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final soilPHProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## weatherAlertsProvider

- usages: 6
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final weatherAlertsProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final weatherAlertsProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## communeSearchProvider

- usages: 5
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final communeSearchProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final communeSearchProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## thermalThemeProvider

- usages: 5
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final thermalThemeProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final thermalThemeProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## gardenTotalAreaProvider

- usages: 3
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final gardenTotalAreaProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final gardenTotalAreaProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## filteredEvolutionHistoryProvider

- usages: 3
- defined_in: C:\Users\roman\Documents\apppklod\permacalendarv2\lib\features\plant_intelligence\presentation\providers\plant_evolution_providers.dart:43

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final filteredEvolutionHistoryProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final filteredEvolutionHistoryProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## unifiedGardenContextProvider

- usages: 3
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final unifiedGardenContextProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final unifiedGardenContextProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## gardenActivePlantsProvider

- usages: 2
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final gardenActivePlantsProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final gardenActivePlantsProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## gardenDetailProvider

- usages: 2
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final gardenDetailProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final gardenDetailProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## gardenBedCountProvider

- usages: 2
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final gardenBedCountProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final gardenBedCountProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## gardenBedDetailProvider

- usages: 2
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final gardenBedDetailProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final gardenBedDetailProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## plantingByIdProvider

- usages: 2
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final plantingByIdProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final plantingByIdProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## gardenActivitiesProvider

- usages: 2
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final gardenActivitiesProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final gardenActivitiesProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## currentGlowColorProvider

- usages: 2
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final currentGlowColorProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final currentGlowColorProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## plantingsByGardenBedProvider

- usages: 1
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final plantingsByGardenBedProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final plantingsByGardenBedProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## _sharedPreferencesProvider

- usages: 1
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final _sharedPreferencesProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final _sharedPreferencesProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## weatherByCommuneProvider

- usages: 1
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final weatherByCommuneProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final weatherByCommuneProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## currentThermalColorSchemeProvider

- usages: 1
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final currentThermalColorSchemeProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final currentThermalColorSchemeProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## currentOverlayColorProvider

- usages: 1
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final currentOverlayColorProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final currentOverlayColorProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## currentThermalIntensityProvider

- usages: 1
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final currentThermalIntensityProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final currentThermalIntensityProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## gardenHistoricalPlantsProvider

- usages: 1
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final gardenHistoricalPlantsProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final gardenHistoricalPlantsProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## currentPaletteNameProvider

- usages: 1
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final currentPaletteNameProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final currentPaletteNameProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## invalidateGardenCacheProvider

- usages: 1
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final invalidateGardenCacheProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final invalidateGardenCacheProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


## generateComprehensiveGardenAnalysisProvider

- usages: 1
- defined_in: :

### Suggested transformation (example for NotifierProvider):

```dart
// Before:
// final generateComprehensiveGardenAnalysisProvider = NotifierProvider<SomeController, SomeState>((ref) => SomeController());
// After:
// final generateComprehensiveGardenAnalysisProvider = NotifierProvider.family<SomeController, SomeState, String?>((ref, param) => SomeController());
```


