# [rehydrate] Fichier orphelin: lib/shared/widgets/recent_activities_widget.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../../core/providers/activity_tracker_v3_provider.dart';
    import '../../core/models/activity_v3.dart';
    
    /// Widget pour afficher les activités récentes
    class RecentActivitiesWidget extends ConsumerWidget {
      final int maxItems;
      final bool showOnlyImportant;
      final VoidCallback? onRefresh;
    
      const RecentActivitiesWidget({
        super.key,
        this.maxItems = 10,
        this.showOnlyImportant = false,
        this.onRefresh,
      });
    
      @override
      Widget build(BuildContext context, WidgetRef ref) {
        final theme = Theme.of(context);
    
        // Choisir le provider selon le type d'activités à afficher
        final activitiesProvider = showOnlyImportant
            ? importantActivitiesProvider
            : recentActivitiesProvider;
    
        final activitiesAsync = ref.watch(activitiesProvider);
    
        // Fonction de refresh
        void refreshActivities() {
          if (showOnlyImportant) {
            ref.read(importantActivitiesProvider.notifier).refresh();
          } else {
            ref.read(recentActivitiesProvider.notifier).refresh();
          }
        }
    
        return Card(
          margin: const EdgeInsets.all(16),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
