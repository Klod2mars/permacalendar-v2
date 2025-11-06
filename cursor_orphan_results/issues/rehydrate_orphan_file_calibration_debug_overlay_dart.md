# [rehydrate] Fichier orphelin: lib/shared/widgets/calibration_debug_overlay.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    // lib/shared/widgets/calibration_debug_overlay.dart
    import 'package:flutter/material.dart';
    
    /// Overlay debug pour afficher une zone normalisée (Offset + size en 0..1).
    /// Permet de visualiser les zones de calibration pendant les tests.
    class CalibrationDebugOverlay extends StatelessWidget {
      final Offset position; // normalized (0..1)
      final double size; // normalized diameter (0..1) or box side
      final Color color;
      final double strokeWidth;
      final bool circular;
    
      const CalibrationDebugOverlay({
        super.key,
        required this.position,
        required this.size,
        this.color = Colors.white,
        this.strokeWidth = 2.0,
        this.circular = true,
      });
    
      @override
      Widget build(BuildContext context) {
        return LayoutBuilder(builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final left = (position.dx * w).clamp(0.0, w);
          final top = (position.dy * h).clamp(0.0, h);
          final side = (size * (w < h ? w : h)).clamp(8.0, (w < h ? w : h));
    
          return Stack(children: [
            Positioned(
              left: left - side / 2,
              top: top - side / 2,
              width: side,
              height: side,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.06),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
