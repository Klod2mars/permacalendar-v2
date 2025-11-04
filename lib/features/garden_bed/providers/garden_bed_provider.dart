import 'package:riverpod/riverpod.dart';
import '../../../core/models/garden_bed.dart';
import '../../../core/data/hive/garden_boxes.dart';
import '../../../core/services/activity_observer_service.dart';
import '../../../core/events/garden_event_bus.dart';
import '../../../core/events/garden_events.dart';

// Garden Bed State
class GardenBedState {
  final List<GardenBed> gardenBeds;
  final bool isLoading;
  final String? error;
  final GardenBed? selectedGardenBed;

  const GardenBedState({
    this.gardenBeds = const [],
    this.isLoading = false,
    this.error,
    this.selectedGardenBed,
  });

  GardenBedState copyWith({
    List<GardenBed>? gardenBeds,
    bool? isLoading,
    String? error,
    GardenBed? selectedGardenBed,
  }) {
    return GardenBedState(
      gardenBeds: gardenBeds ?? this.gardenBeds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedGardenBed: selectedGardenBed ?? this.selectedGardenBed,
    );
  }
}

// Garden Bed Notifier
class GardenBedNotifier extends Notifier<GardenBedState> {
  @override
  GardenBedState build() => const GardenBedState();

  // Load garden beds for a specific garden
  Future<void> loadGardenBeds(String gardenId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load actual data from Hive
      final gardenBeds = GardenBoxes.getGardenBeds(gardenId);

      state = state.copyWith(
        gardenBeds: gardenBeds,
        isLoading: false,
      );
    } catch (e) {
      print('[GardenBedProvider] Erreur lors du chargement: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement des parcelles: $e',
      );
    }
  }

  // Create a new garden bed
  Future<bool> createGardenBed(GardenBed gardenBed) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Validate garden bed data
      final validationError = _validateGardenBed(gardenBed);
      if (validationError != null) {
        state = state.copyWith(
          isLoading: false,
          error: validationError,
        );
        return false;
      }

      // Save to Hive
      await GardenBoxes.saveGardenBed(gardenBed);

      // ✅ NOUVEAU : Tracking avec ActivityObserverService (observateur propre)
      await ActivityObserverService().captureGardenBedCreated(
        gardenBedId: gardenBed.id,
        gardenBedName: gardenBed.name,
        gardenId: gardenBed.gardenId,
        area: gardenBed.sizeInSquareMeters,
        soilType: gardenBed.soilType,
        exposure: gardenBed.exposure,
      );

      // ✅ REFACTORÉ (SYNC-2) : Émettre événement via GardenEventBus
      try {
        GardenEventBus().emit(
          GardenEvent.gardenContextUpdated(
            gardenId: gardenBed.gardenId,
            timestamp: DateTime.now(),
            metadata: {
              'action': 'bed_created',
              'bedId': gardenBed.id,
              'bedName': gardenBed.name,
            },
          ),
        );
      } catch (e) {
        print('Erreur émission événement: $e');
      }

      final updatedGardenBeds = [...state.gardenBeds, gardenBed];

      state = state.copyWith(
        gardenBeds: updatedGardenBeds,
        isLoading: false,
      );

      return true;
    } catch (e) {
      print('[GardenBedProvider] Erreur lors de la création: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la création de la parcelle: $e',
      );
      return false;
    }
  }

  // Update an existing garden bed
  Future<bool> updateGardenBed(GardenBed updatedGardenBed) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Validate garden bed data
      final validationError = _validateGardenBed(updatedGardenBed);
      if (validationError != null) {
        state = state.copyWith(
          isLoading: false,
          error: validationError,
        );
        return false;
      }

      // Update in Hive
      await GardenBoxes.saveGardenBed(updatedGardenBed);

      // ✅ NOUVEAU : Tracking avec ActivityObserverService
      await ActivityObserverService().captureGardenBedUpdated(
        gardenBedId: updatedGardenBed.id,
        gardenBedName: updatedGardenBed.name,
        gardenId: updatedGardenBed.gardenId,
        area: updatedGardenBed.sizeInSquareMeters,
        soilType: updatedGardenBed.soilType,
        exposure: updatedGardenBed.exposure,
      );

      // ✅ REFACTORÉ (SYNC-2) : Émettre événement via GardenEventBus
      try {
        GardenEventBus().emit(
          GardenEvent.gardenContextUpdated(
            gardenId: updatedGardenBed.gardenId,
            timestamp: DateTime.now(),
            metadata: {
              'action': 'bed_updated',
              'bedId': updatedGardenBed.id,
              'bedName': updatedGardenBed.name,
            },
          ),
        );
      } catch (e) {
        print('Erreur émission événement: $e');
      }

      final updatedGardenBeds = state.gardenBeds.map((bed) {
        return bed.id == updatedGardenBed.id ? updatedGardenBed : bed;
      }).toList();

      state = state.copyWith(
        gardenBeds: updatedGardenBeds,
        isLoading: false,
        selectedGardenBed: state.selectedGardenBed?.id == updatedGardenBed.id
            ? updatedGardenBed
            : state.selectedGardenBed,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la mise à jour de la parcelle: $e',
      );
      return false;
    }
  }

  // Delete a garden bed
  Future<bool> deleteGardenBed(String gardenBedId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Récupérer les détails de la parcelle avant suppression
      final bedToDelete = state.gardenBeds.firstWhere(
        (bed) => bed.id == gardenBedId,
        orElse: () => throw Exception('Parcelle non trouvée'),
      );

      // Delete from Hive
      await GardenBoxes.gardenBeds.delete(gardenBedId);

      // ✅ NOUVEAU : Tracking avec ActivityObserverService
      await ActivityObserverService().captureGardenBedDeleted(
        gardenBedId: bedToDelete.id,
        gardenBedName: bedToDelete.name,
        gardenId: bedToDelete.gardenId,
      );

      // ✅ REFACTORÉ (SYNC-2) : Émettre événement via GardenEventBus
      try {
        GardenEventBus().emit(
          GardenEvent.gardenContextUpdated(
            gardenId: bedToDelete.gardenId,
            timestamp: DateTime.now(),
            metadata: {
              'action': 'bed_deleted',
              'bedId': bedToDelete.id,
            },
          ),
        );
      } catch (e) {
        print('Erreur émission événement: $e');
      }

      final updatedGardenBeds =
          state.gardenBeds.where((bed) => bed.id != gardenBedId).toList();

      state = state.copyWith(
        gardenBeds: updatedGardenBeds,
        isLoading: false,
        selectedGardenBed: state.selectedGardenBed?.id == gardenBedId
            ? null
            : state.selectedGardenBed,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la suppression de la parcelle: $e',
      );
      return false;
    }
  }

  // Select a garden bed
  void selectGardenBed(GardenBed? gardenBed) {
    state = state.copyWith(selectedGardenBed: gardenBed);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Refresh garden beds
  Future<void> refresh(String gardenId) async {
    await loadGardenBeds(gardenId);
  }

  // Get garden beds by soil type
  List<GardenBed> getGardenBedsBySoilType(String soilType) {
    return state.gardenBeds.where((bed) => bed.soilType == soilType).toList();
  }

  // Get garden beds by exposure
  List<GardenBed> getGardenBedsByExposure(String exposure) {
    return state.gardenBeds.where((bed) => bed.exposure == exposure).toList();
  }

  // Validate garden bed data
  String? _validateGardenBed(GardenBed gardenBed) {
    if (gardenBed.name.trim().isEmpty) {
      return 'Le nom de la parcelle est requis';
    }

    if (gardenBed.name.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }

    if (gardenBed.name.trim().length > 50) {
      return 'Le nom ne peut pas dépasser 50 caractères';
    }

    if (gardenBed.sizeInSquareMeters <= 0) {
      return 'La superficie doit être positive';
    }

    if (gardenBed.sizeInSquareMeters > 1000) {
      return 'La superficie ne peut pas dépasser 1000 m²';
    }

    if (!GardenBed.soilTypes.contains(gardenBed.soilType)) {
      return 'Type de sol invalide';
    }

    if (!GardenBed.exposureTypes.contains(gardenBed.exposure)) {
      return 'Type d\'exposition invalide';
    }

    return null;
  }
}

// Main NotifierProvider for garden beds
final gardenBedProvider = NotifierProvider<GardenBedNotifier, GardenBedState>(
  GardenBedNotifier.new,
);

// StateNotifierProvider for garden beds list (corrected implementation)
final gardenBedsListProvider = Provider<List<GardenBed>>((ref) {
  return ref.watch(gardenBedProvider).gardenBeds;
});

// Computed providers for specific aspects of the state
final selectedGardenBedProvider = Provider<GardenBed?>((ref) {
  return ref.watch(gardenBedProvider).selectedGardenBed;
});

final gardenBedLoadingProvider = Provider<bool>((ref) {
  return ref.watch(gardenBedProvider).isLoading;
});

final gardenBedErrorProvider = Provider<String?>((ref) {
  return ref.watch(gardenBedProvider).error;
});

// Garden bed statistics provider (computed from the main state)
final gardenBedStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final gardenBeds = ref.watch(gardenBedProvider).gardenBeds;

  final totalArea = gardenBeds.fold<double>(
    0.0,
    (sum, bed) => sum + bed.sizeInSquareMeters,
  );

  final soilTypeDistribution = <String, int>{};
  final exposureDistribution = <String, int>{};

  for (final bed in gardenBeds) {
    soilTypeDistribution[bed.soilType] =
        (soilTypeDistribution[bed.soilType] ?? 0) + 1;
    exposureDistribution[bed.exposure] =
        (exposureDistribution[bed.exposure] ?? 0) + 1;
  }

  return {
    'totalBeds': gardenBeds.length,
    'totalArea': totalArea,
    'averageArea': gardenBeds.isEmpty ? 0.0 : totalArea / gardenBeds.length,
    'soilTypeDistribution': soilTypeDistribution,
    'exposureDistribution': exposureDistribution,
  };
});

// Family provider for scoped garden bed operations (by garden ID)
final gardenBedByGardenProvider =
    FutureProvider.family<List<GardenBed>, String>((ref, gardenId) async {
  final notifier = ref.watch(gardenBedProvider.notifier);
  await notifier.loadGardenBeds(gardenId);
  return ref.watch(gardenBedProvider).gardenBeds;
});

// Provider for a specific garden bed by ID
final gardenBedByIdProvider = Provider.family<GardenBed?, String>((ref, bedId) {
  final gardenBeds = ref.watch(gardenBedProvider).gardenBeds;
  try {
    return gardenBeds.firstWhere((bed) => bed.id == bedId);
  } catch (e) {
    return null;
  }
});
