# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/presentation/widgets/summaries/garden_overview_widget.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
    import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
    import '../cards/alert_banner.dart';
    
    /// Widget pour afficher une vue d'ensemble du jardin
    class GardenOverviewWidget extends StatelessWidget {
      final GardenContext gardenContext;
      final WeatherCondition? currentWeather;
      final List<AlertData>? alerts;
      final VoidCallback? onTap;
      final bool showAlerts;
      final bool showWeather;
    
      const GardenOverviewWidget({
        super.key,
        required this.gardenContext,
        this.currentWeather,
        this.alerts,
        this.onTap,
        this.showAlerts = true,
        this.showWeather = true,
      });
    
      @override
      Widget build(BuildContext context) {
        final theme = Theme.of(context);
    
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(theme),
                  const SizedBox(height: 16),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
