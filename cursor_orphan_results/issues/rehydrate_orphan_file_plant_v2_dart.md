# [rehydrate] Fichier orphelin: lib/core/models/plant_v2.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:hive/hive.dart';
    import 'package:uuid/uuid.dart';
    
    part 'plant_v2.g.dart';
    
    @HiveType(typeId: 12)
    class Plant extends HiveObject {
      @HiveField(0)
      final String id;
    
      @HiveField(1)
      final String name;
    
      @HiveField(2)
      final String species;
    
      @HiveField(3)
      final String family;
    
      @HiveField(4)
      final List<String> growthCycles;
    
      Plant({
        required this.id,
        required this.name,
        required this.species,
        required this.family,
        required this.growthCycles,
      });
    
      // Factory constructor pour créer une nouvelle plante avec ID généré
      factory Plant.create({
        required String name,
        required String species,
        required String family,
        List<String>? growthCycles,
      }) {
        return Plant(
          id: const Uuid().v4(),
          name: name,
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
