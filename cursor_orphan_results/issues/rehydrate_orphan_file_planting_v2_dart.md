# [rehydrate] Fichier orphelin: lib/core/models/planting_v2.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:hive/hive.dart';
    import 'package:uuid/uuid.dart';
    
    part 'planting_v2.g.dart';
    
    @HiveType(typeId: 14)
    class Planting extends HiveObject {
      @HiveField(0)
      final String id;
    
      @HiveField(1)
      final String plantId;
    
      @HiveField(2)
      final String gardenBedId;
    
      @HiveField(3)
      final DateTime plantingDate;
    
      @HiveField(4)
      final String status;
    
      Planting({
        required this.id,
        required this.plantId,
        required this.gardenBedId,
        required this.plantingDate,
        required this.status,
      });
    
      // Factory constructor pour créer une nouvelle plantation avec ID généré
      factory Planting.create({
        required String plantId,
        required String gardenBedId,
        required DateTime plantingDate,
        required String status,
      }) {
        return Planting(
          id: const Uuid().v4(),
          plantId: plantId,
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
