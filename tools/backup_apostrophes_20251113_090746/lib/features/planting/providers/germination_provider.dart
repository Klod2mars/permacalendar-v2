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

/// Provider pour obtenir un événement de germination par ID
final germinationEventProvider =
    FutureProvider.family<GerminationEvent?, String>((ref, eventId) async {
  final service = ref.watch(germinationServiceProvider);
  return await service.getGerminationEvent(eventId);
});

/// Async notifier pour gérer les actions de germination
class GerminationNotifier extends AsyncNotifier<List<GerminationEvent>> {
  @override
  Future<List<GerminationEvent>> build() async {
    final service = ref.read(germinationServiceProvider);
    return await service.getAllGerminationEvents();
  }

  /// Ajoute un nouvel événement de germination
  Future<void> addGerminationEvent(GerminationEvent event) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(germinationServiceProvider);
      await service.addGerminationEvent(event);
      final events = await service.getAllGerminationEvents();
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Confirme la germination d'une plantation
  Future<void> confirmGermination({
    required String plantingId,
    DateTime? confirmedDate,
    double? userSoilTemp,
    String? notes,
    Map<String, dynamic>? weatherContext,
  }) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(germinationServiceProvider);
      final event = GerminationEvent.create(
        plantingId: plantingId,
        confirmedDate: confirmedDate ?? DateTime.now(),
        userSoilTemp: userSoilTemp,
        notes: notes,
        weatherContext: weatherContext,
      );

      await service.addGerminationEvent(event);

      // Récupérer les informations de la plantation pour le tracking
      final plantingService = ref.read(plantingProvider.notifier);
      final planting = plantingService.state.plantings.firstWhere(
        (p) => p.id == plantingId,
        orElse: () => throw Exception('Plantation non trouvée'),
      );

      // Tracker l'activité via ActivityObserverService
      final bed = GardenBoxes.getGardenBedById(planting.gardenBedId);
      if (bed != null) {
        await ActivityObserverService().captureMaintenanceCompleted(
          gardenBedId: planting.gardenBedId,
          gardenBedName: bed.name,
          gardenId: bed.gardenId,
          maintenanceType: 'Germination confirmée',
          description:
              'Germination de "${planting.plantName}" confirmée le ${event.confirmedDate.day}/${event.confirmedDate.month}/${event.confirmedDate.year}',
        );
      }

      final events = await service.getAllGerminationEvents();
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Met à jour un événement de germination
  Future<void> updateGerminationEvent(GerminationEvent event) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(germinationServiceProvider);
      await service.updateGerminationEvent(event);
      final events = await service.getAllGerminationEvents();
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Supprime un événement de germination
  Future<void> deleteGerminationEvent(String eventId) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(germinationServiceProvider);
      await service.deleteGerminationEvent(eventId);
      final events = await service.getAllGerminationEvents();
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Supprime tous les événements de germination pour une plantation
  Future<void> deleteGerminationEventsForPlanting(String plantingId) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(germinationServiceProvider);
      await service.deleteGerminationEventsForPlanting(plantingId);
      final events = await service.getAllGerminationEvents();
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Rafraîchit la liste des événements
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(germinationServiceProvider);
      final events = await service.getAllGerminationEvents();
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider pour le notifier de germination
final germinationNotifierProvider =
    AsyncNotifierProvider<GerminationNotifier, List<GerminationEvent>>(() {
  return GerminationNotifier();
});

/// Provider pour obtenir les événements de germination actifs
final activeGerminationEventsProvider = Provider<List<GerminationEvent>>((ref) {
  final germinationState = ref.watch(germinationNotifierProvider);
  return germinationState.when(
    data: (events) => events.where((event) => event.isActive).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider pour obtenir le nombre d'événements de germination
final germinationEventsCountProvider = Provider<int>((ref) {
  final events = ref.watch(activeGerminationEventsProvider);
  return events.length;
});

/// Provider pour obtenir les événements de germination récents (7 derniers jours)
final recentGerminationEventsProvider = Provider<List<GerminationEvent>>((ref) {
  final events = ref.watch(activeGerminationEventsProvider);
  final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

  return events
      .where((event) => event.confirmedDate.isAfter(sevenDaysAgo))
      .toList()
    ..sort((a, b) => b.confirmedDate.compareTo(a.confirmedDate));
});


