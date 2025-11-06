# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/presentation/widgets/indicators/optimal_timing_widget.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    
    /// Widget pour afficher le timing optimal pour les actions de jardinage
    class OptimalTimingWidget extends StatelessWidget {
      final OptimalTiming timing;
      final VoidCallback? onTap;
      final bool showDetails;
    
      const OptimalTimingWidget({
        super.key,
        required this.timing,
        this.onTap,
        this.showDetails = true,
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
                  const SizedBox(height: 12),
                  _buildTimingInfo(theme),
                  if (showDetails) ...[
                    const SizedBox(height: 12),
                    _buildDetails(theme),
                  ],
                ],
              ),
            ),
          ),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
