# [rehydrate] Fichier orphelin: lib/features/plant_intelligence/presentation/providers/garden_intelligence_providers.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:freezed_annotation/freezed_annotation.dart';
    import 'package:permacalendar/core/providers/active_garden_provider.dart';
    import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_intelligence_memory.dart';
    import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_intelligence_context.dart';
    import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_intelligence_settings.dart';
    
    part 'garden_intelligence_providers.freezed.dart';
    
    /// État de l'intelligence d'un jardin
    @freezed
    class GardenIntelligenceState with _$GardenIntelligenceState {
      const factory GardenIntelligenceState({
        required String gardenId,
        GardenIntelligenceMemory? memory,
        GardenIntelligenceContext? context,
        GardenIntelligenceSettings? settings,
        @Default(false) bool isLoading,
        String? error,
      }) = _GardenIntelligenceState;
    
      factory GardenIntelligenceState.initial(String gardenId) =>
          GardenIntelligenceState(gardenId: gardenId);
    }
    
    /// Notifier pour gérer l'intelligence d'un jardin
    class GardenIntelligenceNotifier extends Notifier<GardenIntelligenceState> {
      @override
      GardenIntelligenceState build() {
        final activeGardenId = ref.watch(activeGardenIdProvider);
        if (activeGardenId == null) {
          return GardenIntelligenceState.initial('');
        }
        _initialize(activeGardenId);
        return GardenIntelligenceState.initial(activeGardenId);
      }
    
      Future<void> _initialize(String gardenId) async {
        state = state.copyWith(isLoading: true);
    
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
