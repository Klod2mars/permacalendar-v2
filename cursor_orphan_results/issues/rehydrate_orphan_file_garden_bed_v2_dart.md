# [rehydrate] Fichier orphelin: lib/core/models/garden_bed_v2.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:hive/hive.dart';
    import 'package:uuid/uuid.dart';
    
    part 'garden_bed_v2.g.dart';
    
    @HiveType(typeId: 11)
    class GardenBed extends HiveObject {
      @HiveField(0)
      final String id;
    
      @HiveField(1)
      final String name;
    
      @HiveField(2)
      final double sizeInSquareMeters;
    
      @HiveField(3)
      final String gardenId;
    
      @HiveField(4)
      final List<String> plantings;
    
      GardenBed({
        required this.id,
        required this.name,
        required this.sizeInSquareMeters,
        required this.gardenId,
        required this.plantings,
      });
    
      // Factory constructor pour créer une nouvelle planche avec ID généré
      factory GardenBed.create({
        required String name,
        required double sizeInSquareMeters,
        required String gardenId,
        List<String>? plantings,
      }) {
        return GardenBed(
          id: const Uuid().v4(),
          name: name,
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
