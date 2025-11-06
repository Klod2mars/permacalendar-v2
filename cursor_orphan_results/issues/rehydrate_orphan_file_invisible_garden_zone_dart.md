# [rehydrate] Fichier orphelin: lib/features/home/widgets/invisible_garden_zone.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:go_router/go_router.dart';
    import 'package:flutter/services.dart';
    
    import '../../../core/providers/active_garden_provider.dart';
    import '../../../features/garden/providers/garden_provider.dart';
    import '../../../core/models/garden_freezed.dart';
    import '../../../shared/presentation/themes/organic_palettes.dart';
    import '../../../shared/widgets/animations/insect_awakening_widget.dart';
    
    /// Widget de zone interactive invisible pour un slot jardin
    /// Remplace GardenBubbleWidget avec une approche "invisible + lueur"
    class InvisibleGardenZone extends ConsumerStatefulWidget {
      final int slotNumber;
      final Rect zone; // Position et taille en pixels absolus
      final Color glowColor; // Couleur de la lueur pour ce jardin
    
      // ✅ NOUVEAUX PARAMÈTRES pour calibration
      final bool isCalibrationMode;
      final Function(String zoneId, DragStartDetails details)? onPanStart;
      final Function(String zoneId, DragUpdateDetails details, double screenWidth,
          double screenHeight)? onPanUpdate;
      final Function(String zoneId, DragEndDetails details)? onPanEnd;
    
      const InvisibleGardenZone({
        super.key,
        required this.slotNumber,
        required this.zone,
        required this.glowColor,
        this.isCalibrationMode = false,
        this.onPanStart,
        this.onPanUpdate,
        this.onPanEnd,
      });
    
      @override
      ConsumerState<InvisibleGardenZone> createState() =>
          _InvisibleGardenZoneState();
    }
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
