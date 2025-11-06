# [rehydrate] Fichier orphelin: lib/core/models/garden_v2.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:hive/hive.dart';
    import 'package:uuid/uuid.dart';
    
    part 'garden_v2.g.dart';
    
    /// ⚠️ DÉPRÉCIÉ : Utilisez GardenFreezed à la place
    ///
    /// Ce modèle Garden (v2, HiveType 10) est déprécié et sera supprimé dans la v3.0.
    ///
    /// **Migration :**
    /// ```dart
    /// // Ancien code
    /// final garden = Garden.create(name: 'Mon Jardin', ...);
    ///
    /// // Nouveau code
    /// final garden = GardenFreezed.create(name: 'Mon Jardin', ...);
    ///
    /// // Ou pour migrer un jardin existant
    /// final modernGarden = GardenMigrationAdapters.fromV2(v2Garden);
    /// ```
    ///
    /// **Raisons de la dépréciation :**
    /// - Modèle incomplet (manque totalAreaInSquareMeters, updatedAt, etc.)
    /// - Pas de support Freezed
    /// - Duplication avec les autres modèles Garden
    /// - Nom de classe ambigu (Garden existe aussi dans garden.dart)
    ///
    /// **Perte de données lors de la migration :**
    /// - `totalAreaInSquareMeters` : sera recalculé après migration des beds
    /// - `updatedAt` : initialisé à createdDate
    /// - `imageUrl` : sera null (pas disponible dans v2)
    ///
    /// **Références :**
    /// - Guide de migration : `lib/core/adapters/garden_migration_adapters.dart`
    /// - Nouveau modèle : `lib/core/models/garden_freezed.dart`
    /// - Prompt 7 : RETABLISSEMENT_PERMACALENDAR.md
    @Deprecated('Utilisez GardenFreezed à la place. '
        'Utilisez GardenMigrationAdapters.fromV2() pour migrer. '
        'Sera supprimé dans la v3.0')
    @HiveType(typeId: 10)
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
