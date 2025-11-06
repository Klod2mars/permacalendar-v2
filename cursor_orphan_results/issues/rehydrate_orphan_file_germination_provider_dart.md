# [rehydrate] Fichier orphelin: lib/features/planting/providers/germination_provider.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:riverpod/riverpod.dart';
    import '../../../core/services/germination_service.dart';
    import '../../../core/services/activity_observer_service.dart';
    import '../../../core/models/germination_event.dart';
    import '../../../core/data/hive/garden_boxes.dart';
    import '../providers/planting_provider.dart';
    
    /// Provider pour le service de gestion des événements de germination
    final germinationServiceProvider = Provider<GerminationService>((ref) {
      return GerminationService();
    });
    
    /// Provider pour obtenir tous les événements de germination
    final allGerminationEventsProvider =
        FutureProvider<List<GerminationEvent>>((ref) async {
      final service = ref.watch(germinationServiceProvider);
      return await service.getAllGerminationEvents();
    });
    
    /// Provider pour obtenir les événements de germination d'une plantation spécifique
    final germinationEventsForPlantingProvider =
        FutureProvider.family<List<GerminationEvent>, String>(
            (ref, plantingId) async {
      final service = ref.watch(germinationServiceProvider);
      return await service.getGerminationEventsForPlanting(plantingId);
    });
    
    /// Provider pour vérifier si une plantation a déjà un événement de germination
    final hasGerminationEventProvider =
        FutureProvider.family<bool, String>((ref, plantingId) async {
      final service = ref.watch(germinationServiceProvider);
      return await service.hasGerminationEvent(plantingId);
    });
    
    /// Provider pour obtenir un événement de germination pour une plantation spécifique
    final germinationEventForPlantingProvider =
        FutureProvider.family<GerminationEvent?, String>((ref, plantingId) async {
      final service = ref.watch(germinationServiceProvider);
      return await service.getGerminationEventForPlanting(plantingId);
    });
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
