# [rehydrate] Fichier orphelin: lib/features/climate/presentation/widgets/climate_mini_card.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'dart:ui';
    import 'package:flutter/material.dart';
    import '../../../../core/models/daily_weather_point.dart';
    
    /// Widget réutilisable pour afficher une mini-carte météo
    ///
    /// Phase P2: Mini-carte simple avec icône, températures, précipitations et date
    /// Utilisé dans la grille du GardenClimatePanel
    class ClimateMiniCard extends StatelessWidget {
      const ClimateMiniCard({
        super.key,
        required this.weatherPoint,
        required this.isToday,
        this.onTap,
      });
    
      final DailyWeatherPoint weatherPoint;
      final bool isToday;
      final VoidCallback? onTap;
    
      @override
      Widget build(BuildContext context) {
        final theme = Theme.of(context);
    
        return GestureDetector(
          onTap: onTap,
          child: _FrostCard(
            emphasis: isToday ? FrostEmphasis.high : FrostEmphasis.normal,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header avec date et accent pour aujourd'hui
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _getDateLabel(),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
