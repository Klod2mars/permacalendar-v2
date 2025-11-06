# [rehydrate] Fichier orphelin: lib/shared/widgets/size_slider_picker.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    // lib/shared/widgets/size_slider_picker.dart
    import 'package:flutter/material.dart';
    
    /// SizeSliderPicker
    /// - currentSize: normalized 0..1
    /// - onChanged: callback(double size)
    /// - onSave: optional callback to persist changes
    class SizeSliderPicker extends StatefulWidget {
      final double currentSize;
      final ValueChanged<double> onChanged;
      final VoidCallback? onSave;
      final String label;
    
      const SizeSliderPicker({
        super.key,
        required this.currentSize,
        required this.onChanged,
        this.onSave,
        this.label = 'Taille METEO',
      });
    
      @override
      State<SizeSliderPicker> createState() => _SizeSliderPickerState();
    }
    
    class _SizeSliderPickerState extends State<SizeSliderPicker> {
      late double _size;
    
      @override
      void initState() {
        super.initState();
        _size = widget.currentSize.clamp(0.05, 0.6);
      }
    
      @override
      Widget build(BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
