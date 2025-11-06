# [rehydrate] Fichier orphelin: lib/shared/widgets/weather_bubble.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    // lib/shared/widgets/weather_bubble.dart
    import 'package:flutter/material.dart';
    import 'package:auto_size_text/auto_size_text.dart';
    
    class WeatherBubble extends StatelessWidget {
      final String dateLabel;
      final String conditionLabel;
      final double tMin;
      final double tMax;
      final IconData weatherIcon;
      final Color? backgroundColor;
    
      const WeatherBubble({
        super.key,
        required this.dateLabel,
        required this.conditionLabel,
        required this.tMin,
        required this.tMax,
        required this.weatherIcon,
        this.backgroundColor,
      });
    
      @override
      Widget build(BuildContext context) {
        return LayoutBuilder(builder: (context, constraints) {
          final diameter = constraints.maxWidth;
          final padding = diameter * 0.10;
          final iconSize = diameter * 0.18;
          final maxFont = diameter * 0.09;
          const minFont = 10.0;
    
          return Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (backgroundColor ?? Colors.greenAccent).withValues(alpha: 0.18),
                  (backgroundColor ?? Colors.greenAccent).withValues(alpha: 0.06),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
