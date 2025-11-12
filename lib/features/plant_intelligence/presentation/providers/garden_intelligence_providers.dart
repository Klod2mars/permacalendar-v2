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

    try {
      // Pour l'instant, créer des données par défaut
      // La persistance Hive sera implémentée en A40-4

      final memory = GardenIntelligenceMemory(
        gardenId: gardenId,
        totalReportsGenerated: 0,
        totalAnalysesPerformed: 0,
        lastReportGeneratedAt: DateTime.now(),
        memoryCreatedAt: DateTime.now(),
        memoryUpdatedAt: DateTime.now(),
      );

      final settings = GardenIntelligenceSettings(
        gardenId: gardenId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        memory: memory,
        settings: settings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Mettre à jour la mémoire
  void updateMemory(GardenIntelligenceMemory memory) {
    state = state.copyWith(
      memory: memory,
    );
  }

  /// Mettre à jour les paramètres
  void updateSettings(GardenIntelligenceSettings settings) {
    state = state.copyWith(
      settings: settings,
    );
  }

  /// Recharger l'intelligence depuis la source
  Future<void> reload() async {
    final activeGardenId = ref.read(activeGardenIdProvider);
    if (activeGardenId != null) {
      await _initialize(activeGardenId);
    }
  }
}

/// Provider pour l'intelligence du jardin actif
final activeGardenIntelligenceProvider =
    NotifierProvider<GardenIntelligenceNotifier, GardenIntelligenceState>(
        GardenIntelligenceNotifier.new);

