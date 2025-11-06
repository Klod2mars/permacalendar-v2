# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/data/migration/multi_garden_migration.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'dart:developer' as developer;
    import 'package:hive_flutter/hive_flutter.dart';
    import '../../domain/entities/plant_condition_hive.dart';
    import '../../domain/entities/recommendation_hive.dart';
    import '../../../../core/data/hive/garden_boxes.dart';
    
    /// Migration script pour ajouter gardenId aux données existantes
    ///
    /// **Prompt A15 - Multi-Garden Migration**
    ///
    /// Cette migration ajoute le champ `gardenId` à toutes les conditions et recommandations
    /// existantes en inférant le gardenId depuis la relation plant → gardenBed → garden.
    ///
    /// **Stratégie :**
    /// 1. Pour chaque PlantCondition/Recommendation existante sans gardenId
    /// 2. Récupérer toutes les plantations (Planting) associées au plantId
    /// 3. Récupérer le gardenBed de la plantation
    /// 4. Récupérer le gardenId du gardenBed
    /// 5. Mettre à jour la condition/recommandation avec le gardenId inféré
    ///
    /// **Sécurité :**
    /// - La migration est idempotente (peut être exécutée plusieurs fois)
    /// - Les erreurs ne bloquent pas la migration des autres entités
    /// - Un rapport détaillé est généré
    class MultiGardenMigration {
      static const String _conditionsBoxName = 'plant_conditions';
      static const String _recommendationsBoxName = 'plant_recommendations';
    
      /// Exécute la migration complète
      ///
      /// Retourne un rapport de migration avec statistiques
      static Future<MigrationReport> execute() async {
        developer.log(
          '🔄 MIGRATION - Début de la migration multi-garden',
          name: 'MultiGardenMigration',
        );
    
        final report = MigrationReport();
        final startTime = DateTime.now();
    
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
