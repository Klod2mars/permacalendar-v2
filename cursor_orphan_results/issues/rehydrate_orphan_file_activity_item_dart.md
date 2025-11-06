# [rehydrate] Fichier orphelin: lib/shared/widgets/activity_item.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:intl/intl.dart';
    import '../../core/models/activity.dart';
    
    /// Widget réutilisable pour afficher une activité de manière uniforme
    class ActivityItem extends StatelessWidget {
      final Activity activity;
      final VoidCallback? onTap;
      final bool showDate;
      final bool compact;
    
      const ActivityItem({
        super.key,
        required this.activity,
        this.onTap,
        this.showDate = true,
        this.compact = false,
      });
    
      @override
      Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final icon = _getActivityIcon(activity.type);
        final color = _getActivityColor(activity.type);
    
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(compact ? 8.0 : 12.0),
            child: Row(
              children: [
                // Icône avec couleur de fond
                Container(
                  padding: EdgeInsets.all(compact ? 6 : 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
