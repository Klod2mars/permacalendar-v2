// lib/features/plant_intelligence/domain/utils/plant_resolver.dart

import 'dart:developer' as developer;

import 'package:permacalendar/features/plant_catalog/data/repositories/plant_hive_repository.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_freezed.dart';
import 'package:permacalendar/core/errors/plant_exceptions.dart';

/// Service utilitaire léger pour résoudre une plante à partir de son ID.
///
/// - SRP : une seule responsabilité — trouver et retourner une instance PlantFreezed.
/// - Utilise le PlantHiveRepository (catalogue) pour charger la liste des plantes.
/// - Normalise l'ID recherché (trim + toLowerCase) pour éviter les problèmes de casse/espaces.
/// - Lève :
///    * [EmptyPlantCatalogException] si le catalogue est vide,
///    * [PlantNotFoundException] si l'ID n'est pas trouvé.
///
/// N'effectue aucune écriture et n'introduit pas de dépendance cyclique.
class PlantResolver {
  final PlantHiveRepository _catalog;

  PlantResolver({
    required PlantHiveRepository plantCatalogRepository,
  }) : _catalog = plantCatalogRepository;

  /// Résout une plante par son [plantId].
  ///
  /// Retourne la [PlantFreezed] correspondante si trouvée.
  /// Lance [EmptyPlantCatalogException] ou [PlantNotFoundException] en cas d'erreur reconnue.
  Future<PlantFreezed> resolve(String plantId) async {
    developer.log(
      '🔎 PlantResolver → Recherche plante "$plantId"',
      name: 'PlantResolver',
    );

    final normalizedId = plantId.trim().toLowerCase();

    try {
      // Charger le catalogue complet (repo encapsule la source)
      final allPlants = await _catalog.getAllPlants();

      developer.log(
        '📚 PlantResolver → Catalogue chargé (${allPlants.length} plantes)',
        name: 'PlantResolver',
      );

      if (allPlants.isEmpty) {
        developer.log(
          '⚠️ PlantResolver → Catalogue vide',
          name: 'PlantResolver',
          level: 900,
        );
        throw const EmptyPlantCatalogException(
          'Le catalogue de plantes est vide. Vérifiez que plants.json est chargé.',
        );
      }

      // Recherche précise (ID normalisé)
      for (final plant in allPlants) {
        if (plant.id.trim().toLowerCase() == normalizedId) {
          developer.log(
            '✔️ PlantResolver → Plante trouvée : ${plant.commonName} (${plant.id})',
            name: 'PlantResolver',
          );
          return plant;
        }
      }

      // Pas de correspondance exacte : essayer correspondance par "slug" ou nom commun (fallback non-bloquant)
      final byCommonName = allPlants.firstWhere(
        (p) => p.commonName.trim().toLowerCase() == normalizedId,
        orElse: () => null as PlantFreezed,
      );

      if (byCommonName != null) {
        developer.log(
          'ℹ️ PlantResolver → Correspondance trouvée par nom commun : ${byCommonName.commonName} (${byCommonName.id})',
          name: 'PlantResolver',
        );
        return byCommonName;
      }

      developer.log(
        '❌ PlantResolver → Plante introuvable pour ID="$plantId"',
        name: 'PlantResolver',
        level: 1000,
      );

      throw PlantNotFoundException(
        plantId: plantId,
        catalogSize: allPlants.length,
        searchedIds: allPlants.map((p) => p.id).toList(),
        message: 'Plante introuvable dans le catalogue.',
      );
    } catch (e) {
      // Remonter les exceptions connues telles quelles
      if (e is PlantNotFoundException || e is EmptyPlantCatalogException) {
        rethrow;
      }

      // Logger et encapsuler les erreurs non prévues
      developer.log(
        '❌ PlantResolver → Erreur inattendue lors de la résolution de la plante "$plantId": $e',
        name: 'PlantResolver',
        error: e,
        level: 1000,
      );

      throw Exception(
          'Erreur lors de la récupération de la plante "$plantId": $e');
    }
  }
}
