import 'dart:developer' as developer;

import '../../plant_catalog/data/repositories/plant_hive_repository.dart';
import '../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../../core/errors/plant_exceptions.dart';

/// Service utilitaire dédié à la résolution d’une plante.
///
/// Remplace entièrement `_getPlant()` dans l’ancien orchestrateur.
///
/// SRP strict :
///   👉 Récupérer une plante depuis le catalogue Hive
///   👉 Normaliser l’ID
///   👉 Lever les exceptions propres
///   👉 Logger avant/après
///
/// Aucun accès GardenBoxes.
/// Aucun autre rôle.
class PlantResolver {
  final PlantHiveRepository _catalog;

  PlantResolver({
    required PlantHiveRepository plantCatalogRepository,
  }) : _catalog = plantCatalogRepository;

  /// Résout une plante par son ID.
  Future<PlantFreezed> resolve(String plantId) async {
    developer.log(
      '🔎 PlantResolver → Recherche plante "$plantId"',
      name: 'PlantResolver',
    );

    try {
      final normalized = plantId.trim().toLowerCase();

      // 1) Charger catalogue entier
      final all = await _catalog.getAllPlants();

      developer.log(
        '📚 Catalogue chargé (${all.length} plantes)',
        name: 'PlantResolver',
      );

      if (all.isEmpty) {
        throw const EmptyPlantCatalogException(
          'Catalogue vide : vérifiez plants.json',
        );
      }

      // 2) Rechercher match exact normalisé
      for (final plant in all) {
        if (plant.id.trim().toLowerCase() == normalized) {
          developer.log(
            '✔️ PlantResolver → Plante trouvée : ${plant.commonName}',
            name: 'PlantResolver',
          );
          return plant;
        }
      }

      // 3) Aucun match
      developer.log(
        '❌ PlantResolver → Plante "$plantId" introuvable',
        name: 'PlantResolver',
        level: 1000,
      );

      throw PlantNotFoundException(
        plantId: plantId,
        catalogSize: all.length,
        searchedIds: all.map((p) => p.id).toList(),
        message: 'ID non trouvé dans le catalogue.',
      );
    } catch (e) {
      // Si déjà une exception catalog/plante → remontée telle quelle
      if (e is PlantNotFoundException || e is EmptyPlantCatalogException) {
        rethrow;
      }

      // Sinon : erreur générique (faute de catalogue ?)
      developer.log(
        '❌ PlantResolver → Erreur inattendue : $e',
        name: 'PlantResolver',
        level: 1000,
      );

      throw PlantIntelligenceOrchestratorException(
        'Erreur lors de la récupération de la plante $plantId: $e',
      );
    }
  }
}
