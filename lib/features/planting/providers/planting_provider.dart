import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import '../../../core/services/plant_progress_service.dart';
import '../../../core/models/planting.dart';
import '../../../core/data/hive/garden_boxes.dart';
import '../../../core/services/activity_observer_service.dart';
import '../../../core/events/garden_event_bus.dart';
import '../../../core/events/garden_events.dart';
import '../../../core/utils/calibration_storage.dart';
import '../../harvest/data/repositories/harvest_repository.dart';
import '../../harvest/domain/models/harvest_record.dart'; // Import HarvestRecord
import '../../harvest/application/harvest_records_provider.dart'; // Import HarvestRecordsProvider
import 'package:uuid/uuid.dart'; // Import Uuid
import '../../../core/services/nutrition_normalizer.dart';
import '../../plant_catalog/providers/plant_catalog_provider.dart';
import '../domain/plant_steps_generator.dart';
import '../../../core/models/activity.dart';
import '../../../core/models/plant.dart';
import '../../../core/services/notification_service.dart';

// Planting State
class PlantingState {
  final List<Planting> plantings;
  final bool isLoading;
  final String? error;
  final Planting? selectedPlanting;

  const PlantingState({
    this.plantings = const [],
    this.isLoading = false,
    this.error,
    this.selectedPlanting,
  });

  PlantingState copyWith({
    List<Planting>? plantings,
    bool? isLoading,
    String? error,
    Planting? selectedPlanting,
  }) {
    return PlantingState(
      plantings: plantings ?? this.plantings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedPlanting: selectedPlanting ?? this.selectedPlanting,
    );
  }
}

// Planting Notifier
class PlantingNotifier extends Notifier<PlantingState> {
  @override
  PlantingState build() => const PlantingState();

  // Load plantings for a specific garden bed
  Future<void> loadPlantings(String gardenBedId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final plantings = GardenBoxes.getPlantings(gardenBedId);
      state = state.copyWith(
        plantings: plantings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement des plantations: $e',
      );
    }
  }

  // Load all plantings
  Future<void> loadAllPlantings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final allPlantings = GardenBoxes.plantings.values.toList();
      state = state.copyWith(
        plantings: allPlantings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement des plantations: $e',
      );
    }
  }

  // Create a new planting
  // NOTE: Accept status & metadata so callers (UI) can provide planting status
  // and an initial growth percentage without requiring a Hive migration.
  Future<bool> createPlanting({
    required String gardenBedId,
    required String plantId,
    required String plantName,
    required DateTime plantedDate,
    DateTime? expectedHarvestStartDate,
    DateTime? expectedHarvestEndDate,
    required int quantity,
    String? notes,
    String status = 'Planté', // propagate the user's choice (Semé / Planté)
    Map<String, dynamic>?
        metadata, // contains 'initialGrowthPercent' when applicable
  }) async {
    try {
      // Normaliser les métadonnées et garantir initialGrowthPercent
      final Map<String, dynamic> metaFinal =
          Map<String, dynamic>.from(metadata ?? {});
      if (!metaFinal.containsKey('initialGrowthPercent')) {
        // Par défaut : Planté => 0.3, Semé => 0.0
        metaFinal['initialGrowthPercent'] = (status == 'Planté') ? 0.3 : 0.0;
      }

      final planting = Planting(
        gardenBedId: gardenBedId,
        plantId: plantId,
        plantName: plantName,
        plantedDate: plantedDate,
        expectedHarvestStartDate: expectedHarvestStartDate,
        expectedHarvestEndDate: expectedHarvestEndDate,
        quantity: quantity,
        status: status,
        notes: notes,
        metadata: metaFinal,
      );

      if (!_validatePlanting(planting)) {
        state = state.copyWith(error: 'Données de plantation invalides');
        return false;
      }

      await GardenBoxes.savePlanting(planting);

      // ✅ Tracker l'activité via ActivityObserverService
      final bed = GardenBoxes.getGardenBedById(gardenBedId);
      if (bed != null) {
        await ActivityObserverService().capturePlantingCreated(
          plantingId: planting.id,
          plantName: planting.plantName,
          gardenBedId: gardenBedId,
          gardenBedName: bed.name,
          gardenId: bed.gardenId,
          plantingDate: planting.plantedDate,
          quantity: planting.quantity,
        );
      }

      // ✅ NOUVEAU (Prompt 6) : Émettre événement via GardenEventBus
      try {
        final bed = GardenBoxes.getGardenBedById(gardenBedId);
        if (bed != null) {
          GardenEventBus().emit(
            GardenEvent.plantingAdded(
              gardenId: bed.gardenId,
              plantingId: planting.id,
              plantId: plantId,
              timestamp: DateTime.now(),
              metadata: {
                'plantName': plantName,
                'quantity': quantity,
                'plantedDate': plantedDate.toIso8601String(),
              },
            ),
          );
        }
      } catch (e) {
        // Mode silencieux : ne pas faire échouer la Création
        print('Erreur émission événement GardenEventBus: $e');
      }

      // ✅ AUTOMATION (Feature 4 & 5): Générer Activités & Notifications
      try {
        final catalog = ref.read(plantCatalogProvider);
        // On suppose que catalog.plants contient la liste complète ou on utilise une méthode de service
        final plant = catalog.plants.where((p) => p.id == plantId).firstOrNull;

        if (plant != null) {
          // Convert PlantFreezed to Plant for generateSteps
          final plantModel = Plant.fromJson(plant.toJson());
          final steps = generateSteps(plantModel, planting);

          for (final step in steps) {
            if (step.scheduledDate != null &&
                step.scheduledDate!.isAfter(DateTime.now())) {
              // Créer l'activité planifiée
              final activity = Activity(
                  id: const Uuid().v4(),
                  type: ActivityType.careActionAdded, // Generic care/task
                  title: step.title,
                  description: step.description,
                  entityId: planting.id,
                  entityType: EntityType.planting,
                  timestamp: DateTime.now(), // Created at
                  metadata: {
                    'status': 'planned',
                    'scheduledDate': step.scheduledDate!.toIso8601String(),
                    'isAutomated': true,
                    'stepId': step.id,
                    'category': step.category,
                  });

              await GardenBoxes.activities.put(activity.id, activity);

              // Programmer Notification
              // On utilise un ID unique int pour la notif (hashCode de l'ID activité)
              final notifId = activity.id.hashCode.abs();
              await NotificationService().scheduleNotification(
                id: notifId,
                title: 'Jardin: ${step.title}',
                body: '${plantName}: ${step.description}',
                scheduledDate: step.scheduledDate!,
                payload:
                    '/plantings/${planting.id}', // Deep link payload logic if implemented
              );
            }
          }
        }
      } catch (e) {
        print('Erreur lors de la génération automatique des tâches: $e');
      }

      // Update state with new planting
      final updatedPlantings = [...state.plantings, planting];
      state = state.copyWith(
        plantings: updatedPlantings,
        error: null,
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: 'Erreur lors de la Création: $e');
      return false;
    }
  }

  // Update an existing planting
  Future<bool> updatePlanting(Planting updatedPlanting) async {
    try {
      if (!_validatePlanting(updatedPlanting)) {
        state = state.copyWith(error: 'Données de plantation invalides');
        return false;
      }

      await GardenBoxes.savePlanting(updatedPlanting);

      // ✅ Tracker l'activité via ActivityObserverService
      final bed = GardenBoxes.getGardenBedById(updatedPlanting.gardenBedId);
      if (bed != null) {
        await ActivityObserverService().capturePlantingUpdated(
          plantingId: updatedPlanting.id,
          plantName: updatedPlanting.plantName,
          gardenBedId: updatedPlanting.gardenBedId,
          gardenBedName: bed.name,
          gardenId: bed.gardenId,
          status: updatedPlanting.status,
        );
      }

      // ✅ REFACTORÉ (SYNC-2) : Émettre événement via GardenEventBus
      try {
        final bed = GardenBoxes.getGardenBedById(updatedPlanting.gardenBedId);
        if (bed != null) {
          GardenEventBus().emit(
            GardenEvent.activityPerformed(
              gardenId: bed.gardenId,
              activityType: 'planting_updated',
              targetId: updatedPlanting.id,
              timestamp: DateTime.now(),
              metadata: {
                'plantId': updatedPlanting.plantId,
              },
            ),
          );
        }
      } catch (e) {
        print('Erreur émission événement: $e');
      }

      // Update state
      final updatedPlantings = state.plantings.map((planting) {
        return planting.id == updatedPlanting.id ? updatedPlanting : planting;
      }).toList();

      state = state.copyWith(
        plantings: updatedPlantings,
        error: null,
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: 'Erreur lors de la mise à jour: $e');
      return false;
    }
  }

  // Delete a planting
  Future<bool> deletePlanting(String plantingId) async {
    try {
      // Récupérer les détails de la plantation avant suppression
      final plantingToDelete = state.plantings.firstWhere(
        (planting) => planting.id == plantingId,
        orElse: () => throw Exception('Plantation non trouvée'),
      );

      await GardenBoxes.deletePlanting(plantingId);

      // ✅ Tracker l'activité via ActivityObserverService
      final bed = GardenBoxes.getGardenBedById(plantingToDelete.gardenBedId);
      if (bed != null) {
        await ActivityObserverService().captureGardenBedDeleted(
          gardenBedId: plantingToDelete.id,
          gardenBedName: plantingToDelete.plantName,
          gardenId: bed.gardenId,
          gardenName: bed.name,
        );
      }

      // ✅ REFACTORÉ (SYNC-2) : Émettre événement via GardenEventBus
      try {
        final bed = GardenBoxes.getGardenBedById(plantingToDelete.gardenBedId);
        if (bed != null) {
          GardenEventBus().emit(
            GardenEvent.activityPerformed(
              gardenId: bed.gardenId,
              activityType: 'planting_deleted',
              targetId: plantingToDelete.id,
              timestamp: DateTime.now(),
            ),
          );
        }
      } catch (e) {
        print('Erreur émission événement: $e');
      }

      // Update state
      final updatedPlantings = state.plantings
          .where((planting) => planting.id != plantingId)
          .toList();

      state = state.copyWith(
        plantings: updatedPlantings,
        error: null,
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: 'Erreur lors de la suppression: $e');
      return false;
    }
  }

  // Update planting status
  Future<bool> updatePlantingStatus(String plantingId, String newStatus) async {
    try {
      final planting = state.plantings.firstWhere((p) => p.id == plantingId);

      // Synchroniser metadata pour éviter incohérences Semé <-> Planté
      final meta = Map<String, dynamic>.from(planting.metadata ?? {});

      if (newStatus == 'Planté') {
        // Si aucune valeur initiale, poser un défaut sûr (0.3)
        if (!meta.containsKey('initialGrowthPercent') ||
            (meta['initialGrowthPercent'] is num &&
                (meta['initialGrowthPercent'] as num).toDouble() == 0.0) ||
            (meta['initialGrowthPercent'] is String &&
                double.tryParse(meta['initialGrowthPercent']) == 0.0)) {
          meta['initialGrowthPercent'] = 0.3;
        }
        // Init progressReference à plantedDate si absent
        if (!meta.containsKey('progressReference')) {
          meta['progressReference'] =
              PlantProgressService.buildProgressReferenceMap(
                  planting.plantedDate,
                  (meta['initialGrowthPercent'] is num)
                      ? (meta['initialGrowthPercent'] as num).toDouble()
                      : double.tryParse(
                              meta['initialGrowthPercent']?.toString() ?? '') ??
                          0.3);
        }
      } else if (newStatus == 'Semé') {
        // Semé => forcer 0.0 et update reference
        meta['initialGrowthPercent'] = 0.0;
        meta['progressReference'] =
            PlantProgressService.buildProgressReferenceMap(
                planting.plantedDate, 0.0);
      }

      final updatedPlanting =
          planting.copyWith(status: newStatus, metadata: meta);

      return await updatePlanting(updatedPlanting);
    } catch (e) {
      state =
          state.copyWith(error: 'Erreur lors de la mise à jour du statut: $e');
      return false;
    }
  }

  // Add care action to a planting
  Future<bool> addCareAction({
    required String plantingId,
    required String actionType,
    required DateTime date,
    String? notes,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final planting = state.plantings.firstWhere(
        (p) => p.id == plantingId,
        orElse: () => throw Exception('Plantation non trouvée'),
      );

      // Add care action to planting (as string with timestamp)
      final careActionString = '$actionType - ${date.toIso8601String()}';
      final updatedPlanting = planting.copyWith(
        careActions: [...planting.careActions, careActionString],
      );

      await GardenBoxes.savePlanting(updatedPlanting);

      // ✅ Tracker l'activité via ActivityObserverService
      final bed = GardenBoxes.getGardenBedById(planting.gardenBedId);
      if (bed != null) {
        await ActivityObserverService().captureMaintenanceCompleted(
          gardenBedId: planting.gardenBedId,
          gardenBedName: bed.name,
          gardenId: bed.gardenId,
          maintenanceType: actionType,
          description: notes,
        );
      }

      // Update state
      final updatedPlantings = state.plantings.map((p) {
        return p.id == plantingId ? updatedPlanting : p;
      }).toList();

      state = state.copyWith(
        plantings: updatedPlantings,
        error: null,
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: 'Erreur lors de l\'ajout du soin: $e');
      return false;
    }
  }

  /// Enregistre une récolte pour une planting donnée.
  /// Ne change PAS le statut de la plantation — on considère la récolte
  /// comme un événement (historique) attaché à la plantation.
  /// Enregistre une récolte complète (avec poids et prix) et met à jour le statut
  Future<bool> recordHarvest(
    String plantingId,
    DateTime date, {
    required double weightKg,
    required double pricePerKg,
    String? notes,
  }) async {
    debugPrint(
        '[PlantingNotifier.recordHarvest] START plantingId=$plantingId weightKg=$weightKg price=$pricePerKg notes=${notes ?? ''}');
    try {
      final planting = state.plantings.firstWhere((p) => p.id == plantingId,
          orElse: () => throw Exception('Planting not found'));

      // LOG BEFORE
      debugPrint(
          '[recordHarvest] BEFORE update: plantName="${planting.plantName}" status="${planting.status}" metadata=${planting.metadata}');

      final bed = GardenBoxes.getGardenBedById(planting.gardenBedId);
      String gardenId = bed?.gardenId ?? 'unknown';

      // FIX: If garden is unknown (orphaned planting), fallback to the first available garden
      // to ensure statistics are visible.
      // FIX: Improved Orphan Handling
      // If the bed is deleted or not found, we try to attach to the first available garden.
      if (gardenId == 'unknown') {
        final allGardens = GardenBoxes.getAllGardens();
        if (allGardens.isNotEmpty) {
          gardenId = allGardens.first.id;
          debugPrint(
              '[recordHarvest] Warning: Bed ${planting.gardenBedId} not found. Re-attaching to garden $gardenId (${allGardens.first.name})');
        } else {
          // Extreme edge case: No gardens exist at all.
          // We create a virtual "Lost & Found" garden ID to allow saving.
          gardenId = 'orphaned_harvests_garden';
          debugPrint(
              '[recordHarvest] Critical: No gardens found. Saving to virtual garden "orphaned_harvests_garden".');
        }
      }

      // 3.5) Compute Nutrition Snapshot
      Map<String, double>? nutritionSnapshot;
      try {
        final catalog = ref.read(plantCatalogProvider);
        // Find plant safely. We iterate manually or use firstWhere with nullable return if possible,
        // but List.firstWhere throws if not found without orElse.
        // We assume 'plants' is a List<Plant>.
        final plant =
            catalog.plants.where((p) => p.id == planting.plantId).firstOrNull;

        if (plant != null) {
          // We assume plant.nutritionPer100g exists and is Map<String, dynamic>
          // If 'plant' logic is different, we might need adjustments.
          nutritionSnapshot = NutritionNormalizer.computeSnapshot(
              plant.nutritionPer100g, weightKg);
          debugPrint(
              '[recordHarvest] Nutrition snapshot computed: ${nutritionSnapshot.keys.length} keys');
        } else {
          debugPrint(
              '[recordHarvest] Warning: Plant ${planting.plantId} not found in catalog for nutrition snapshot');
        }
      } catch (e) {
        debugPrint('[recordHarvest] Nutrition snapshot error: $e');
      }

      final record = HarvestRecord(
        id: const Uuid().v4(),
        gardenId: gardenId,
        plantId: planting.plantId,
        plantName: planting.plantName,
        quantityKg: weightKg,
        pricePerKg: pricePerKg,
        date: date,
        notes: notes,
        nutritionSnapshot: nutritionSnapshot,
      );

      // 4) Persister HarvestRecord
      await HarvestRepository().saveHarvest(record);
      debugPrint('[PlantingNotifier] recordHarvest saved id=${record.id}');

      // 5) Mémoriser le prix
      try {
        final prev =
            await CalibrationStorage.loadProfile('userHarvestPrices') ??
                <String, dynamic>{};
        prev[planting.plantId] = pricePerKg;
        await CalibrationStorage.saveProfile('userHarvestPrices', prev);
      } catch (e) {
        debugPrint('Warning: unable to save userHarvestPrices: $e');
      }

      // Tracking + Events
      try {
        if (bed != null) {
          await ActivityObserverService().captureHarvestCompleted(
            gardenBedId: planting.gardenBedId,
            gardenBedName: bed.name,
            gardenId: bed.gardenId,
            plantingId: plantingId,
            plantName: planting.plantName,
            quantity: weightKg,
          );

          // Refresh harvest records
          try {
            await ref.read(harvestRecordsProvider.notifier).refresh();
          } catch (e) {
            debugPrint(
                'Warning: failed to refresh harvest records provider: $e');
          }

          GardenEventBus().emit(
            GardenEvent.plantingHarvested(
              gardenId: gardenId,
              plantingId: plantingId,
              harvestYield: weightKg,
              timestamp: date,
              metadata: {
                'pricePerKg': pricePerKg,
                'harvestId': record.id,
                'notes': notes,
              },
            ),
          );
        }
      } catch (e) {
        debugPrint('[recordHarvest] tracking/event error: $e');
      }

      // 6) Mise à jour de la plantation (Status + Date)
      // Force status to 'Récolté' and ensure plantName is preserved
      final updatedPlanting = planting.copyWith(
        actualHarvestDate: date,
        // status: 'Récolté', // REMOVED: Do not force status change
      );

      // CHECK INTEGRITY
      if (updatedPlanting.plantName.trim().isEmpty) {
        debugPrint(
            '[recordHarvest] CRITICAL: plantName became empty! Original was "${planting.plantName}"');
      }
      debugPrint(
          '[recordHarvest] AFTER update: plantName="${updatedPlanting.plantName}" status="${updatedPlanting.status}"');

      await GardenBoxes.savePlanting(updatedPlanting);

      final updatedPlantings = state.plantings
          .map((p) => p.id == plantingId ? updatedPlanting : p)
          .toList();
      state = state.copyWith(plantings: updatedPlantings, error: null);

      return true;
    } catch (e, st) {
      debugPrint('[recordHarvest] error: $e\n$st');
      state = state.copyWith(error: 'Erreur lors de la récolte: $e');
      return false;
    }
  }

  // Harvest a planting (Quick Harvest fallback)
  // Utilise recordHarvest avec des valeurs par défaut
  Future<bool> harvestPlanting(String plantingId, DateTime harvestDate) async {
    try {
      final planting = state.plantings.firstWhere(
        (p) => p.id == plantingId,
        orElse: () => throw Exception('Plantation non trouvée'),
      );

      // 1. Tenter de récupérer le prix utilisateur
      double price = 0.0;
      try {
        final userPrices =
            await CalibrationStorage.loadProfile('userHarvestPrices');
        if (userPrices != null && userPrices.containsKey(planting.plantId)) {
          price = (userPrices[planting.plantId] as num).toDouble();
        }
      } catch (e) {
        // Ignorer erreur de lecture pref
      }

      // 2. Utiliser recordHarvest
      // Fallback quantity: on utilise la quantité de la plantation (souvent en pièces)
      // comme estimation. Idéalement l'utilisateur devrait corriger via le dialogue.
      return await recordHarvest(
        plantingId,
        harvestDate,
        weightKg: planting.quantity.toDouble(),
        pricePerKg: price,
        notes: 'Récolte rapide',
      );
    } catch (e) {
      state = state.copyWith(error: 'Erreur lors de la récolte rapide: $e');
      return false;
    }
  }

  // Select a planting
  void selectPlanting(Planting? planting) {
    state = state.copyWith(selectedPlanting: planting);
  }

  // Refresh plantings
  Future<void> refresh(String? gardenBedId) async {
    if (gardenBedId != null) {
      await loadPlantings(gardenBedId);
    } else {
      await loadAllPlantings();
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Get plantings by status
  List<Planting> getPlantingsByStatus(String status) {
    return state.plantings
        .where((planting) => planting.status == status)
        .toList();
  }

  // Get plantings by garden bed
  List<Planting> getPlantingsByGardenBed(String gardenBedId) {
    return state.plantings
        .where((planting) => planting.gardenBedId == gardenBedId)
        .toList();
  }

  // Get plantings by plant
  List<Planting> getPlantingsByPlant(String plantId) {
    return state.plantings
        .where((planting) => planting.plantId == plantId)
        .toList();
  }

  // Get plantings ready for harvest
  List<Planting> getPlantingsReadyForHarvest() {
    final now = DateTime.now();
    return state.plantings.where((planting) {
      return planting.expectedHarvestStartDate != null &&
          planting.expectedHarvestStartDate!.isBefore(now) &&
          planting.status != 'Récolté' &&
          planting.status != 'Échoué';
    }).toList();
  }

  // Get overdue plantings
  List<Planting> getOverduePlantings() {
    final now = DateTime.now();
    return state.plantings.where((planting) {
      return planting.expectedHarvestEndDate != null &&
          planting.expectedHarvestEndDate!
              .isBefore(now.subtract(const Duration(days: 7))) &&
          planting.status != 'Récolté' &&
          planting.status != 'Échoué';
    }).toList();
  }

  // Validation
  bool _validatePlanting(Planting planting) {
    if (planting.plantName.trim().isEmpty) return false;
    if (planting.quantity <= 0) return false;
    if (!Planting.statusOptions.contains(planting.status)) return false;

    // Check if planted date is not in the future
    if (planting.plantedDate.isAfter(DateTime.now())) return false;

    // Check if harvest start date is after planted date
    if (planting.expectedHarvestStartDate != null &&
        planting.expectedHarvestStartDate!.isBefore(planting.plantedDate)) {
      return false;
    }

    // Check if harvest end date is after start date
    if (planting.expectedHarvestStartDate != null &&
        planting.expectedHarvestEndDate != null &&
        planting.expectedHarvestEndDate!
            .isBefore(planting.expectedHarvestStartDate!)) {
      return false;
    }

    return true;
  }

  // Generate mock data for testing
  Future<void> generateMockData(String gardenBedId) async {
    final mockPlantings = [
      Planting(
        gardenBedId: gardenBedId,
        plantId: 'plant_1',
        plantName: 'Tomates cerises',
        plantedDate: DateTime.now().subtract(const Duration(days: 45)),
        expectedHarvestStartDate: DateTime.now().add(const Duration(days: 30)),
        expectedHarvestEndDate: DateTime.now().add(const Duration(days: 60)),
        quantity: 6,
        status: 'Planté',
        notes: 'Variété très productive',
        careActions: ['Arrosage', 'Tuteurage'],
      ),
      Planting(
        gardenBedId: gardenBedId,
        plantId: 'plant_2',
        plantName: 'Basilic',
        plantedDate: DateTime.now().subtract(const Duration(days: 30)),
        expectedHarvestStartDate: DateTime.now().add(const Duration(days: 15)),
        expectedHarvestEndDate: DateTime.now().add(const Duration(days: 45)),
        quantity: 4,
        status: 'Planté',
        notes: 'Croissance rapide',
        careActions: ['Arrosage', 'Pincement'],
      ),
      Planting(
        gardenBedId: gardenBedId,
        plantId: 'plant_3',
        plantName: 'Radis',
        plantedDate: DateTime.now().subtract(const Duration(days: 60)),
        expectedHarvestStartDate:
            DateTime.now().subtract(const Duration(days: 20)),
        expectedHarvestEndDate:
            DateTime.now().subtract(const Duration(days: 10)),
        quantity: 20,
        status: 'Planté',
        notes: 'Excellente récolte',
        actualHarvestDate: DateTime.now().subtract(const Duration(days: 5)),
        careActions: ['Arrosage', 'Éclaircissage'],
      ),
    ];

    for (final planting in mockPlantings) {
      await GardenBoxes.savePlanting(planting);
    }

    await loadPlantings(gardenBedId);
  }
}

// Providers
final plantingProvider = NotifierProvider<PlantingNotifier, PlantingState>(
  PlantingNotifier.new,
);

// Computed providers
final plantingsListProvider = Provider<List<Planting>>((ref) {
  return ref.watch(plantingProvider).plantings;
});

// ✅ CORRECTION : Provider spécifique pour les plantations d'une parcelle
final plantingsByGardenBedProvider =
    Provider.family<List<Planting>, String>((ref, gardenBedId) {
  final allPlantings = ref.watch(plantingProvider).plantings;
  return allPlantings.where((p) => p.gardenBedId == gardenBedId).toList();
});

final selectedPlantingProvider = Provider<Planting?>((ref) {
  return ref.watch(plantingProvider).selectedPlanting;
});

final plantingLoadingProvider = Provider<bool>((ref) {
  return ref.watch(plantingProvider).isLoading;
});

final plantingErrorProvider = Provider<String?>((ref) {
  return ref.watch(plantingProvider).error;
});

// Planting statistics provider
final plantingStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final plantings = ref.watch(plantingsListProvider);

  final statusDistribution = <String, int>{};
  final plantDistribution = <String, int>{};

  for (final planting in plantings) {
    statusDistribution[planting.status] =
        (statusDistribution[planting.status] ?? 0) + 1;
    plantDistribution[planting.plantName] =
        (plantDistribution[planting.plantName] ?? 0) + planting.quantity;
  }

  final totalQuantity = plantings.fold<int>(
    0,
    (sum, planting) => sum + planting.quantity,
  );

  final harvestedPlantings =
      plantings.where((p) => p.status == 'Récolté').length;
  final successRate =
      plantings.isEmpty ? 0.0 : (harvestedPlantings / plantings.length) * 100;

  return {
    'totalPlantings': plantings.length,
    'totalQuantity': totalQuantity,
    'successRate': successRate,
    'statusDistribution': statusDistribution,
    'plantDistribution': plantDistribution,
    'readyForHarvest':
        plantings.where((p) => p.status == 'Prêt à récolter').length,
    'inGrowth': plantings.where((p) => p.status == 'En croissance').length,
  };
});

// Plantings by status providers
final plantingsByStatusProvider =
    Provider.family<List<Planting>, String>((ref, status) {
  return ref
      .watch(plantingsListProvider)
      .where((p) => p.status == status)
      .toList();
});

// Plantings ready for harvest provider
final plantingsReadyForHarvestProvider = Provider<List<Planting>>((ref) {
  final plantings = ref.watch(plantingsListProvider);
  final now = DateTime.now();

  return plantings.where((planting) {
    return planting.expectedHarvestStartDate != null &&
        planting.expectedHarvestStartDate!.isBefore(now) &&
        planting.status != 'Récolté' &&
        planting.status != 'Échoué';
  }).toList();
});

// Overdue plantings provider
final overduePlantingsProvider = Provider<List<Planting>>((ref) {
  final plantings = ref.watch(plantingsListProvider);
  final now = DateTime.now();

  return plantings.where((planting) {
    return planting.expectedHarvestEndDate != null &&
        planting.expectedHarvestEndDate!
            .isBefore(now.subtract(const Duration(days: 7))) &&
        planting.status != 'Récolté' &&
        planting.status != 'Échoué';
  }).toList();
});

// Provider for getting a specific planting by ID
final plantingByIdProvider =
    Provider.family<AsyncValue<Planting?>, String>((ref, plantingId) {
  final plantings = ref.watch(plantingsListProvider);
  try {
    final planting = plantings.firstWhere((p) => p.id == plantingId);
    return AsyncValue.data(planting);
  } catch (e) {
    return const AsyncValue.data(null);
  }
});
