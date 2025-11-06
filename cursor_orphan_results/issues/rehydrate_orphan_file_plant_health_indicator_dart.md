# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/presentation/widgets/indicators/plant_health_indicator.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    
    /// Indicateur de santé visuel pour une plante
    class PlantHealthIndicator extends StatefulWidget {
      final double healthScore;
      final String? label;
      final double size;
      final bool showLabel;
      final bool showAnimation;
      final VoidCallback? onTap;
    
      const PlantHealthIndicator({
        super.key,
        required this.healthScore,
        this.label,
        this.size = 100,
        this.showLabel = true,
        this.showAnimation = true,
        this.onTap,
      });
    
      @override
      State<PlantHealthIndicator> createState() => _PlantHealthIndicatorState();
    }
    
    class _PlantHealthIndicatorState extends State<PlantHealthIndicator>
        with SingleTickerProviderStateMixin {
      late AnimationController _animationController;
      late Animation<double> _animation;
    
      @override
      void initState() {
        super.initState();
        _animationController = AnimationController(
          duration: const Duration(milliseconds: 1200),
          vsync: this,
        );
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
