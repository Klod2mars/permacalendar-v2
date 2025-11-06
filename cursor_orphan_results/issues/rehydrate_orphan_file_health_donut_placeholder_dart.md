# [rehydrate] Fichier orphelin: lib/features/statistics/presentation/widgets/placeholders/health_donut_placeholder.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:fl_chart/fl_chart.dart';
    
    /// Placeholder visuel pour le pilier Santé
    ///
    /// Affiche un donut chart vide avec un seul secteur gris neutre
    /// Prêt pour l'intégration de données de santé en Phase 4
    class HealthDonutPlaceholder extends StatelessWidget {
      const HealthDonutPlaceholder({super.key});
    
      @override
      Widget build(BuildContext context) {
        return SizedBox(
          height: 120,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  color: Colors.grey.withValues(alpha: 0.3),
                  value: 100,
                  title: '',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
