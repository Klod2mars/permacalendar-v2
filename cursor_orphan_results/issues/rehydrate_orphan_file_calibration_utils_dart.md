# [rehydrate] Fichier orphelin: lib/shared/utils/calibration_utils.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    // lib/shared/utils/calibration_utils.dart
    import 'package:flutter/widgets.dart';
    
    class RelativeRectData {
      final double left;
      final double top;
      final double width;
      final double height;
    
      const RelativeRectData({
        required this.left,
        required this.top,
        required this.width,
        required this.height,
      });
    
      Map<String, double> toJson() => {
            'left': left,
            'top': top,
            'width': width,
            'height': height,
          };
    
      factory RelativeRectData.fromJson(Map<String, dynamic> json) {
        return RelativeRectData(
          left: (json['left'] as num).toDouble(),
          top: (json['top'] as num).toDouble(),
          width: (json['width'] as num).toDouble(),
          height: (json['height'] as num).toDouble(),
        );
      }
    }
    
    /// Convertit un Rect global (en coordonnées écran) en relatif [0..1] par rapport
    /// au conteneur identifié par [containerKey].
    RelativeRectData toRelativeRect(Rect globalRect, GlobalKey containerKey) {
      final RenderBox box =
          containerKey.currentContext!.findRenderObject() as RenderBox;
      final origin = box.localToGlobal(Offset.zero);
      final Size size = box.size;
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
