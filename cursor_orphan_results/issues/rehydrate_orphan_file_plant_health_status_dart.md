# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/domain/models/plant_health_status.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    enum PlantHealthStatus {
      excellent,
      good,
      fair,
      poor,
      critical,
    }
    
    extension PlantHealthStatusExtension on PlantHealthStatus {
      String get displayName {
        switch (this) {
          case PlantHealthStatus.excellent:
            return 'Excellent';
          case PlantHealthStatus.good:
            return 'Good';
          case PlantHealthStatus.fair:
            return 'Fair';
          case PlantHealthStatus.poor:
            return 'Poor';
          case PlantHealthStatus.critical:
            return 'Critical';
        }
      }
    
      double get scoreThreshold {
        switch (this) {
          case PlantHealthStatus.excellent:
            return 0.9;
          case PlantHealthStatus.good:
            return 0.7;
          case PlantHealthStatus.fair:
            return 0.5;
          case PlantHealthStatus.poor:
            return 0.3;
          case PlantHealthStatus.critical:
            return 0.0;
        }
      }
    }
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
