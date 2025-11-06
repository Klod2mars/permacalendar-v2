# [rehydrate] Fichier orphelin: lib/features/climate/presentation/experimental/cellular_rosace_v3/cellular_rosace_integration_example.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'cellular_rosace_widget.dart';
    import '../../providers/weather_providers.dart';
    import '../../providers/soil_temp_provider.dart';
    import '../../providers/soil_ph_provider.dart';
    
    /// Integration Example: Cellular Rosace with Real Climate Data
    ///
    /// This example shows how to integrate the Cellular Rosace V3 with
    /// existing Riverpod providers for real climate data.
    class CellularRosaceIntegrationExample extends ConsumerWidget {
      const CellularRosaceIntegrationExample({super.key});
    
      @override
      Widget build(BuildContext context, WidgetRef ref) {
        // Watch providers for real data
        const scopeKey = "garden:demo"; // TODO: Get from current garden selection
    
        final hasAlerts = ref.watch(shouldPulseAlertProvider);
        final currentWeather = ref.watch(currentWeatherProvider);
        final forecast = ref.watch(forecastProvider);
        final soilTempAsync = ref.watch(soilTempProviderByScope(scopeKey));
        final soilPHAsync = ref.watch(soilPHProviderByScope(scopeKey));
    
        // Extract values with fallbacks
        final minTemp =
            currentWeather.hasValue ? currentWeather.value!.minTemp : null;
        final maxTemp =
            currentWeather.hasValue ? currentWeather.value!.maxTemp : null;
        final weatherCondition =
            currentWeather.hasValue ? currentWeather.value!.condition : null;
    
        final soilTemp =
            soilTempAsync.hasValue ? (soilTempAsync.value ?? 18.3) : 18.3;
        final soilPH = soilPHAsync.hasValue ? (soilPHAsync.value ?? 6.8) : 6.8;
    
        // Get J+1 forecast data
        final tomorrowForecast = forecast.hasValue && forecast.value!.isNotEmpty
            ? forecast.value!.first
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
