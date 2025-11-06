# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/presentation/providers/garden_context_sync_provider.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../../domain/services/garden_context_sync_service.dart';
    import '../../data/datasources/plant_intelligence_local_datasource.dart';
    import '../../../core/models/garden_freezed.dart';
    
    /// Provider pour le service de synchronisation du GardenContext
    final gardenContextSyncServiceProvider =
        Provider<GardenContextSyncService>((ref) {
      final dataSource = ref.read(plantIntelligenceLocalDataSourceProvider);
      return GardenContextSyncService(dataSource);
    });
    
    /// Provider pour synchroniser un jardin spécifique
    final syncGardenContextProvider =
        FutureProvider.family<GardenContext?, String>((ref, gardenId) async {
      final syncService = ref.read(gardenContextSyncServiceProvider);
      final garden = GardenBoxes.getGardenById(gardenId);
    
      if (garden == null) {
        return null;
      }
    
      return await syncService.syncGardenContext(gardenId, garden);
    });
    
    /// Provider pour synchroniser tous les jardins
    final syncAllGardenContextsProvider =
        FutureProvider<Map<String, GardenContext>>((ref) async {
      final syncService = ref.read(gardenContextSyncServiceProvider);
      return await syncService.syncAllGardenContexts();
    });
    
    /// Notifier pour gérer la synchronisation en temps réel
    class GardenContextSyncNotifier extends Notifier<bool> {
      @override
      bool build() => false;
    
      /// Synchronise un jardin spécifique
      Future<GardenContext?> syncGarden(String gardenId) async {
        try {
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
