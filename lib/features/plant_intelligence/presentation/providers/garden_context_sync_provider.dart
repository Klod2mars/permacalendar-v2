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
      state = true;
      final garden = GardenBoxes.getGardenById(gardenId);
      if (garden != null) {
        final syncService = ref.read(gardenContextSyncServiceProvider);
        return await syncService.syncGardenContext(gardenId, garden);
      }
      return null;
    } finally {
      state = false;
    }
  }

  /// Synchronise tous les jardins
  Future<Map<String, GardenContext>> syncAllGardens() async {
    try {
      state = true;
      final syncService = ref.read(gardenContextSyncServiceProvider);
      return await syncService.syncAllGardenContexts();
    } finally {
      state = false;
    }
  }
}

/// Provider pour le notifier de synchronisation
final gardenContextSyncNotifierProvider =
    NotifierProvider<GardenContextSyncNotifier, bool>(
        GardenContextSyncNotifier.new);

