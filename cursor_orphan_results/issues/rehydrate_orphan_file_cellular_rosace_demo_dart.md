# [rehydrate] Fichier orphelin: lib/features/climate/presentation/experimental/cellular_rosace_v3/cellular_rosace_demo.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/material.dart';
    import 'cellular_rosace_widget.dart';
    
    /// Demo screen for Cellular Rosace V3
    ///
    /// This demo showcases the living cellular tissue with different
    /// data hierarchies and custom color schemes.
    class CellularRosaceDemo extends StatefulWidget {
      const CellularRosaceDemo({super.key});
    
      @override
      State<CellularRosaceDemo> createState() => _CellularRosaceDemoState();
    }
    
    class _CellularRosaceDemoState extends State<CellularRosaceDemo> {
      int _currentDemo = 0;
    
      final List<DemoConfiguration> _demos = [
        const DemoConfiguration(
          title: 'Default Configuration',
          description: 'Standard cellular layout with balanced importance',
          dataHierarchy: {
            'ph_core': 1.0,
            'weather_current': 0.9,
            'soil_temp': 0.7,
            'weather_forecast': 0.6,
            'alerts': 0.5,
          },
        ),
        const DemoConfiguration(
          title: 'Weather Focused',
          description: 'Emphasizes weather data with larger cells',
          dataHierarchy: {
            'weather_current': 1.0,
            'ph_core': 0.8,
            'weather_forecast': 0.7,
            'soil_temp': 0.5,
            'alerts': 0.4,
          },
        ),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
