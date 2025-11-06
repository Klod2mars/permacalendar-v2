# [rehydrate] Fichier orphelin: lib/features/statistics/presentation/widgets/placeholders/finance_bubble_placeholder.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    
    /// Placeholder visuel pour le pilier Finance
    ///
    /// Affiche des bulles de différentes tailles pour représenter les flux financiers
    /// Design neutre avec des cercles gris de tailles variées
    class FinanceBubblePlaceholder extends StatelessWidget {
      const FinanceBubblePlaceholder({super.key});
    
      @override
      Widget build(BuildContext context) {
        return SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Bulle principale (centre)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
              ),
              // Bulle gauche (plus petite)
              Positioned(
                left: 20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Bulle droite (plus petite)
              Positioned(
                right: 20,
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
