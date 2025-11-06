# [rehydrate] Fichier orphelin: lib/features/climate/presentation/widgets/garden_climate_panel.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'dart:ui';
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    
    import '../../../../features/climate/presentation/providers/weather_providers.dart'
        as weather_providers;
    import '../../../../features/climate/domain/models/weather_view_data.dart';
    import '../../../../core/models/daily_weather_point.dart';
    import '../../../../core/providers/app_settings_provider.dart';
    import '../../../../features/garden/providers/garden_provider.dart';
    import '../../../../shared/widgets/loading_widgets.dart';
    import '../../../../core/theme/app_icons.dart';
    
    /// Widget autonome pour l'affichage du climat du jardin
    ///
    /// Ce widget extrait la fonctionnalité météo de home_screen.dart
    /// et la rend disponible comme composant réutilisable.
    ///
    /// Phase P2: Grille de mini-cartes météo (J0, J+1, J+2) avec responsive
    class GardenClimatePanel extends ConsumerWidget {
      const GardenClimatePanel({super.key});
    
      @override
      Widget build(BuildContext context, WidgetRef ref) {
        final gardenState = ref.watch(gardenProvider);
        final theme = Theme.of(context);
        // Use unified providers
        final currentAsync = ref.watch(weather_providers.currentWeatherProvider);
        final forecastAsync = ref.watch(weather_providers.forecastProvider);
    
        return _FrostCard(
          emphasis: FrostEmphasis.normal,
          child: Column(
            children: [
              // Header "Climat du Jardin"
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(12),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
