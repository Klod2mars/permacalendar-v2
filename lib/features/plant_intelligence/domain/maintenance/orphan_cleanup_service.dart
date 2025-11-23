import 'dart:developer' as developer;

import '../repositories/i_plant_condition_repository.dart';
import '../../plant_catalog/data/repositories/plant_hive_repository.dart';

/// Service dédié au nettoyage des conditions orphelines.
/// 
/// SRP strict :
///   👉 Identifier les conditions liées à des plantes inactives
///   👉 Les supprimer en toute sécurité
///   👉 Ne jamais remonter d’erreur bloquante
///
/// IMPORTANT SANCTUAIRE :
///   - Aucune écriture dans garden_*
///   - On supprime UNIQUEMENT des conditions IA (modern boxes)
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
      final plants = await _plantCatalog.getAllPlants();_
