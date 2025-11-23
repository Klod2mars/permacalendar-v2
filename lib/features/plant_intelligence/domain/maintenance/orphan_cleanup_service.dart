import 'dart:developer' as developer;

import '../repositories/i_plant_condition_repository.dart';
import 'package:permacalendar/features/plant_catalog/data/repositories/plant_hive_repository.dart';

/// Service dédié au nettoyage des conditions orphelines.
/// ...
class OrphanCleanupService {
  final IPlantConditionRepository _conditionRepo;
  final PlantHiveRepository _plantCatalog;

  OrphanCleanupService({
    required IPlantConditionRepository conditionRepository,
    required PlantHiveRepository plantCatalogRepository,
  })  : _conditionRepo = conditionRepository,
        _plantCatalog = plantCatalogRepository;

  /// Nettoie les conditions orphelines.
  /// Retourne le nombre de conditions supprimées.
  Future<int> clean() async {
    developer.log(
      '🧽 OrphanCleanupService → Nettoyage conditions orphelines…',
      name: 'OrphanCleanupService',
    );

    int deleted = 0;

    try {
      // 1. Récupérer toutes les plantes
      final allPlants = await _plantCatalog.getAllPlants();
      final activePlantIds = allPlants
          .where((p) => p.isActive)
          .map((p) => p.id)
          .toSet(); // Set pour O(1)

      developer.log(
        '📋 ${activePlantIds.length} plante(s) active(s) détectée(s)',
        name: 'OrphanCleanupService',
      );

      // 2. Récupérer toutes les conditions (par plante)
      final orphanIds = <String>[];

      for (final plant in allPlants) {
        try {
          final history =
              await _conditionRepo.getPlantConditionHistory(plantId: plant.id);

          for (final cond in history) {
            if (!activePlantIds.contains(plant.id)) {
              orphanIds.add(cond.id);
            }
          }
        } catch (e) {
          developer.log(
            '⚠️ Erreur récupération conditions pour ${plant.id}: $e',
            name: 'OrphanCleanupService',
            level: 900,
          );
        }
      }

      developer.log(
        '🔍 ${orphanIds.length} condition(s) orpheline(s) détectée(s)',
        name: 'OrphanCleanupService',
      );

      // 3. Supprimer les orphelines
      for (final id in orphanIds) {
        try {
          final success = await _conditionRepo.deletePlantCondition(id);
          if (success) deleted++;
        } catch (e) {
          developer.log(
            '⚠️ Erreur suppression condition $id: $e',
            name: 'OrphanCleanupService',
            level: 900,
          );
        }
      }

      developer.log(
        '✅ $deleted condition(s) orpheline(s) supprimée(s)',
        name: 'OrphanCleanupService',
      );

      return deleted;
    } catch (e, st) {
      developer.log(
        '❌ OrphanCleanupService → Échec global (non bloquant): $e',
        name: 'OrphanCleanupService',
        error: e,
        stackTrace: st,
        level: 1000,
      );
      return deleted;
    }
  }
}
