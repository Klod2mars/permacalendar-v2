# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/presentation/widgets/summaries/intelligence_summary.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
    import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
    import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
    import '../cards/alert_banner.dart';
    
    /// Résumé de l'intelligence végétale pour un jardin
    class IntelligenceSummary extends StatelessWidget {
      final List<PlantCondition> plantConditions;
      final List<Recommendation> recommendations;
      final WeatherCondition? currentWeather;
      final List<AlertData>? alerts;
      final String gardenName;
      final VoidCallback? onTap;
      final bool showDetails;
    
      const IntelligenceSummary({
        super.key,
        required this.plantConditions,
        required this.recommendations,
        this.currentWeather,
        this.alerts,
        required this.gardenName,
        this.onTap,
        this.showDetails = true,
      });
    
      @override
      Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final stats = _calculateStats();
    
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
