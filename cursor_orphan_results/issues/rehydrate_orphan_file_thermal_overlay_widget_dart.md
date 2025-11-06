# [rehydrate] Fichier orphelin: lib/core/widgets/thermal_overlay_widget.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../providers/thermal_theme_provider.dart';
    import '../../shared/presentation/widgets/thermal_transition_widget.dart';
    
    /// Widget overlay halo global subtil pour ambiance thermique
    /// Overlay jamais agressif (max 8% opacity)
    class ThermalOverlayWidget extends StatelessWidget {
      final Widget child;
      final Color overlayColor;
      final double intensity;
    
      const ThermalOverlayWidget({
        super.key,
        required this.child,
        required this.overlayColor,
        this.intensity = 1.0,
      });
    
      @override
      Widget build(BuildContext context) {
        return Stack(
          children: [
            // Contenu principal
            child,
    
            // Overlay thermique subtil (seulement si couleur définie)
            if (overlayColor != Colors.transparent)
              Positioned.fill(
                child: IgnorePointer(
                  // Pas d'interaction avec l'overlay
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.5,
                        colors: [
                          overlayColor
                              .withOpacity(0.02 * intensity), // Centre très subtil
                          overlayColor.withOpacity(
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
