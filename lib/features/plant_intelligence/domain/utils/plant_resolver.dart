// lib/features/plant_intelligence/domain/utils/plant_resolver.dart
import 'dart:developer' as developer;

import 'package:permacalendar/features/plant_catalog/data/repositories/plant_hive_repository.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/core/errors/plant_exceptions.dart';

/// Résout une plante à partir du catalogue. Ne crée pas de dépendances cycliques.
class PlantResolver {
  final PlantHiveRepository _catalog;

  PlantResolver({
    required PlantHiveRepository plantCatalogRepository,
  }) : _catalog = plantCatalogRepository;

  Future<PlantFreezed> resolve(String plantId) async {
    developer.log('🔎 PlantResolver → Recherche plante "$plantId"',
        name: 'PlantResolver');

    final normalizedId = plantId.trim().toLowerCase();

    try {
      final allPlants = await _catalog.getAllPlants();
      developer.log(
          '📚 PlantResolver → Catalogue chargé (${allPlants.length} plantes)',
          name: 'PlantResolver');

      if (allPlants.isEmpty) {
        developer.log('⚠️ PlantResolver → Catalogue vide',
            name: 'PlantResolver', level: 900);
        throw const EmptyPlantCatalogException(
            'Le catalogue de plantes est vide. Vérifiez que plants.json est chargé.');
      }

      // 1) correspondance exacte ID
      for (final plant in allPlants) {
        if (plant.id.trim().toLowerCase() == normalizedId) {
          developer.log(
              '✔️ PlantResolver → Plante trouvée : ${plant.commonName} (${plant.id})',
              name: 'PlantResolver');
          return plant;
        }
      }

      // 2) fallback par nom commun (safe)
      final byCommonName = allPlants
          .where((p) => p.commonName.trim().toLowerCase() == normalizedId)
          .toList();
      if (byCommonName.isNotEmpty) {
        final p = byCommonName.first;
        developer.log(
            'ℹ️ PlantResolver → Correspondance trouvée par nom commun : ${p.commonName} (${p.id})',
            name: 'PlantResolver');
        return p;
      }

      developer.log('❌ PlantResolver → Plante introuvable pour ID="$plantId"',
          name: 'PlantResolver', level: 1000);
      throw PlantNotFoundException(
        plantId: plantId,
        catalogSize: allPlants.length,
        searchedIds: allPlants.map((p) => p.id).toList(),
        message: 'Plante introuvable dans le catalogue.',
      );
    } catch (e) {
      if (e is PlantNotFoundException || e is EmptyPlantCatalogException)
        rethrow;
      developer.log('❌ PlantResolver → Erreur inattendue: $e',
          name: 'PlantResolver', level: 1000);
      throw Exception(
          'Erreur lors de la récupération de la plante "$plantId": $e');
    }
  }
}
