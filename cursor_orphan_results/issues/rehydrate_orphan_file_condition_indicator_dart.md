# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/presentation/widgets/indicators/condition_indicator.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    
    /// Indicateur pour une condition spécifique (température, humidité, etc.)
    class ConditionIndicator extends StatelessWidget {
      final String label;
      final double value;
      final double maxValue;
      final String unit;
      final IconData icon;
      final Color? color;
      final bool showValue;
      final bool showProgress;
      final VoidCallback? onTap;
    
      const ConditionIndicator({
        super.key,
        required this.label,
        required this.value,
        required this.maxValue,
        required this.unit,
        required this.icon,
        this.color,
        this.showValue = true,
        this.showProgress = true,
        this.onTap,
      });
    
      @override
      Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final indicatorColor = color ?? _getConditionColor(theme, value, maxValue);
        final percentage = (value / maxValue).clamp(0.0, 1.0);
    
        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
