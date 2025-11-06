# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/data/datasources/plant_intelligence_remote_datasource.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import '../../domain/entities/plant_condition.dart';
    import '../../domain/entities/recommendation.dart';
    import '../../domain/entities/weather_condition.dart';
    import '../../domain/entities/garden_context.dart';
    
    /// Interface pour la source de données distante de l'intelligence des plantes
    ///
    /// Définit les contrats pour l'accès aux données distantes via APIs externes
    /// pour l'intelligence des plantes. Actuellement utilisé comme placeholder
    /// pour de futures intégrations.
    abstract class PlantIntelligenceRemoteDataSource {
      // ==================== GESTION DES CONDITIONS ====================
    
      /// Synchronise les conditions d'une plante avec le serveur distant
      ///
      /// [condition] - Condition à synchroniser
      ///
      /// Retourne true si la synchronisation a réussi
      Future<bool> syncPlantCondition(PlantCondition condition);
    
      /// Récupère les conditions d'une plante depuis le serveur distant
      ///
      /// [plantId] - Identifiant de la plante
      ///
      /// Retourne les conditions distantes ou null si non trouvées
      Future<PlantCondition?> getRemotePlantCondition(String plantId);
    
      /// Récupère l'historique des conditions depuis le serveur distant
      ///
      /// [plantId] - Identifiant de la plante
      /// [startDate] - Date de début
      /// [endDate] - Date de fin
      ///
      /// Retourne la liste des conditions historiques distantes
      Future<List<PlantCondition>> getRemotePlantConditionHistory({
        required String plantId,
        DateTime? startDate,
        DateTime? endDate,
      });
    
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
