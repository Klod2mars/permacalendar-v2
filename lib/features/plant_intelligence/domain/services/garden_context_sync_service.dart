import 'dart:developer' as developer;
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
import 'package:permacalendar/features/plant_intelligence/data/datasources/plant_intelligence_local_datasource.dart';
import 'package:permacalendar/core/models/garden_freezed.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';

/// Service pour synchroniser le GardenContext avec les données du jardin et des plantations
class GardenContextSyncService {
  final PlantIntelligenceLocalDataSource _dataSource;

  GardenContextSyncService(this._dataSource);

  /// Synchronise le GardenContext pour un jardin donné
  /// Récupère les plantes actives depuis les plantations et met à jour le contexte
  Future<GardenContext?> syncGardenContext(
    String gardenId,
    GardenFreezed garden,
  ) async {
    try {
      developer.log(
          '🔄 SYNC - Synchronisation GardenContext pour jardin: $gardenId',
          name: 'GardenContextSyncService');

      // Récupérer le contexte existant ou en créer un nouveau
      GardenContext? existingContext =
          await _dataSource.getGardenContext(gardenId);

      // Récupérer les plantes actives depuis les plantations
      final activePlantIds = await _getActivePlantIdsFromPlantings(gardenId);
      developer.log(
          '🔄 SYNC - Plantes actives trouvées: ${activePlantIds.length} - $activePlantIds',
          name: 'GardenContextSyncService');

      // Créer ou mettre à jour le contexte
      final gardenContext = existingContext?.copyWith(
            name: garden.name,
            description: garden.description,
            location: garden.location,
            activePlantIds: activePlantIds,
            updatedAt: DateTime.now(),
          ) ??
          GardenContext(
            gardenId: gardenId,
            name: garden.name,
            description: garden.description,
            location: garden.location,
            climate: 'Temperate', // Valeur par défaut
            soil: 'Loam', // Valeur par défaut
            activePlantIds: activePlantIds,
            historicalPlantIds: existingContext?.historicalPlantIds ?? [],
            stats: existingContext?.stats ??
                GardenStats(
                  totalPlants: activePlantIds.length,
                  activePlants: activePlantIds.length,
                  totalArea: garden.totalAreaInSquareMeters,
                  activeArea: garden.totalAreaInSquareMeters,
                ),
            preferences: existingContext?.preferences ??
                CultivationPreferences(
                  organic: true,
                  companionPlanting: true,
                  cropRotation: true,
                ),
            createdAt: existingContext?.createdAt ?? DateTime.now(),
            updatedAt: DateTime.now(),
          );

      // Sauvegarder le contexte mis à jour
      await _dataSource.updateGardenContext(gardenContext);

      developer.log(
          '✅ SYNC - GardenContext synchronisé avec succès: ${activePlantIds.length} plantes actives',
          name: 'GardenContextSyncService');

      return gardenContext;
    } catch (e, stackTrace) {
      developer.log('❌ SYNC - Erreur synchronisation GardenContext: $e',
          name: 'GardenContextSyncService');
      developer.log('❌ SYNC - StackTrace: $stackTrace',
          name: 'GardenContextSyncService');
      return null;
    }
  }

  /// Récupère les IDs des plantes actives depuis les plantations
  Future<List<String>> _getActivePlantIdsFromPlantings(String gardenId) async {
    try {
      // Récupérer toutes les plantations actives pour ce jardin
      final plantings = GardenBoxes.getActivePlantingsForGarden(gardenId);

      // Extraire les IDs des plantes uniques
      final plantIds = plantings
          .map((planting) => planting.plantId)
          .toSet() // Éliminer les doublons
          .toList();

      developer.log(
          '🔄 SYNC - Plantations trouvées: ${plantings.length}, Plantes uniques: ${plantIds.length}',
          name: 'GardenContextSyncService');

      return plantIds;
    } catch (e) {
      developer.log('❌ SYNC - Erreur récupération plantations: $e',
          name: 'GardenContextSyncService');
      return [];
    }
  }

  /// Synchronise tous les jardins actifs
  Future<Map<String, GardenContext>> syncAllGardenContexts() async {
    try {
      final allGardens = GardenBoxes.getAllGardens();
      final activeGardens =
          allGardens.where((garden) => garden.isActive).toList();

      developer.log(
          '🔄 SYNC - Synchronisation de ${activeGardens.length} jardins actifs',
          name: 'GardenContextSyncService');

      final Map<String, GardenContext> syncedContexts = {};

      for (final garden in activeGardens) {
        final context = await syncGardenContext(garden.id, garden);
        if (context != null) {
          syncedContexts[garden.id] = context;
        }
      }

      developer.log(
          '✅ SYNC - ${syncedContexts.length} contextes synchronisés avec succès',
          name: 'GardenContextSyncService');

      return syncedContexts;
    } catch (e, stackTrace) {
      developer.log('❌ SYNC - Erreur synchronisation globale: $e',
          name: 'GardenContextSyncService');
      developer.log('❌ SYNC - StackTrace: $stackTrace',
          name: 'GardenContextSyncService');
      return {};
    }
  }
}


