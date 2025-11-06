# [rehydrate] Fichier orphelin: lib/core/services/plant_condition_analyzer.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'dart:developer' as developer;
    import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart'
        show GardenContext, SoilInfo, GardenLocation;
    import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart'
        as garden_ctx;
    import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
    import 'package:permacalendar/features/plant_intelligence/domain/entities/condition_enums.dart'
        show SoilType, ExposureType;
    import 'package:permacalendar/core/services/models/composite_weather_data.dart';
    
    // NOTE Prompt 4: Utilisation de modèles composites helper temporaires
    // TODO Prompt futur: Remplacer par entités domain composites officielles
    // Import sélectif pour éviter conflit SoilType entre condition_enums et garden_context
    
    /// Service d'analyse des conditions biologiques des plantes
    ///
    /// Service optimisé pour production avec:
    /// - Algorithmes d'analyse affinés basés sur données réelles plants.json
    /// - Système de scoring précis et pondéré
    /// - Recommandations concrètes et actionnables
    /// - Logging détaillé pour debugging
    class PlantConditionAnalyzer {
      const PlantConditionAnalyzer();
    
      /// Système de logging pour debugging
      static bool _loggingEnabled = true;
    
      /// Analyse complète des conditions d'une plante
      ///
      /// [plant] - La plante à analyser
      /// [condition] - Les conditions composites actuelles de la plante
      /// [weather] - Les conditions météorologiques composites
      /// [garden] - Le contexte du jardin
      ///
      /// Retourne un [ConditionAnalysisResult] avec l'évaluation complète
      ///
      /// NOTE Prompt 4: Utilise modèles composites helper temporaires
      Future<ConditionAnalysisResult> analyzeConditions({
        required PlantFreezed plant,
        required CompositePlantCondition condition,
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
