import 'dart:developer' as developer;

import '../data/hive/garden_boxes.dart';

import '../models/planting.dart';





/// Service d'agrégation holistique des données du jardin

///

/// Ce service core réutilisable agrège TOUTES les données de l'application

/// pour un jardin spécifique : parcelles, plantations, activités, statistiques.

///

/// **Architecture :**

/// - Utilise uniquement `GardenBoxes` (legacy) pour éviter les dépendances circulaires

/// - Ne modifie aucune donnée (Single Responsibility : agrégation uniquement)

/// - Conçu pour être réutilisé par d'autres modules (Export, futurs dashboards)

///

/// **Responsabilités :**

/// - Agréger les parcelles d'un jardin

/// - Agréger les plantations actives et historiques

/// - Calculer les statistiques réelles du jardin

/// - Calculer les surfaces (totale, active)

/// - Analyser la distribution des types de sol

class GardenDataAggregationService {

  static const String _logName = 'GardenDataAggregationService';



  /// Récupère les IDs de toutes les plantes actives dans un jardin

  ///

  /// **Processus :**

  /// 1. Récupère toutes les parcelles du jardin

  /// 2. Pour chaque parcelle, récupère les plantations

  /// 3. Filtre les plantations actives (isActive == true)

  /// 4. Extrait les plantId sans doublons

  ///

  /// **Retourne :** Liste unique des IDs de plantes actives

  /// **En cas d'erreur :** Liste vide

  List<String> getActivePlantIds(String gardenId) {

    try {

      developer.log(

        'ðŸ” DIAGNOSTIC - Récupération des plantes actives pour jardin $gardenId',

        name: _logName,

        level: 500,

      );



      // Récupérer toutes les parcelles du jardin

      final beds = GardenBoxes.getGardenBeds(gardenId);



      developer.log(

        'ðŸ“¦ DIAGNOSTIC - Parcelles trouvées: ${beds.length}',

        name: _logName,

        level: 500,

      );



      if (beds.isEmpty) {

        developer.log(

          'âŒ DIAGNOSTIC - Aucune parcelle trouvée pour jardin $gardenId',

          name: _logName,

          level: 500,

        );

        return [];

      }



      // Set pour éviter les doublons

      final activePlantIds = <String>{};



      // Pour chaque parcelle, récupérer les plantations actives

      for (final bed in beds) {

        developer.log(

          'ðŸ“¦ DIAGNOSTIC - Parcelle: ${bed.name} (ID: ${bed.id})',

          name: _logName,

          level: 500,

        );



        final plantings = GardenBoxes.getPlantings(bed.id);



        developer.log(

          'ðŸŒ± DIAGNOSTIC - Plantations trouvées: ${plantings.length}',

          name: _logName,

          level: 500,

        );



        // Filtrer les plantations actives

        final activePlantings = plantings.where((p) => p.isActive).toList();



        developer.log(

          'ðŸŒ± DIAGNOSTIC - Plantations actives: ${activePlantings.length}',

          name: _logName,

          level: 500,

        );



        // Extraire les plantId

        for (final planting in activePlantings) {

          developer.log(

            'ðŸŒ± DIAGNOSTIC - Plantation active: ${planting.plantId}',

            name: _logName,

            level: 500,

          );

          activePlantIds.add(planting.plantId);

        }

      }



      final result = activePlantIds.toList();



      developer.log(

        'âœ… DIAGNOSTIC - Trouvé ${result.length} plantes actives pour jardin $gardenId',

        name: _logName,

        level: 500,

      );



      for (final plantId in result) {

        developer.log(

          'ðŸŒ± DIAGNOSTIC - Plante active finale: $plantId',

          name: _logName,

          level: 500,

        );

      }



      return result;

    } catch (e, stackTrace) {

      developer.log(

        'Erreur lors de la récupération des plantes actives',

        name: _logName,

        level: 1000,

        error: e,

        stackTrace: stackTrace,

      );

      return [];

    }

  }



  /// Récupère les IDs de toutes les plantes historiques dans un jardin

  ///

  /// **Processus :**

  /// 1. Récupère toutes les parcelles du jardin

  /// 2. Pour chaque parcelle, récupère les plantations

  /// 3. Filtre les plantations NON actives (isActive == false)

  /// 4. Exclut les plantes déjà actives

  /// 5. Extrait les plantId sans doublons

  ///

  /// **Retourne :** Liste unique des IDs de plantes historiques (non actives)

  /// **En cas d'erreur :** Liste vide

  List<String> getHistoricalPlantIds(String gardenId) {

    try {

      developer.log(

        'Récupération des plantes historiques pour jardin $gardenId',

        name: _logName,

        level: 500,

      );



      // Récupérer les plantes actives pour les exclure

      final activePlantIds = getActivePlantIds(gardenId).toSet();



      // Récupérer toutes les parcelles du jardin

      final beds = GardenBoxes.getGardenBeds(gardenId);



      if (beds.isEmpty) {

        return [];

      }



      // Set pour éviter les doublons

      final historicalPlantIds = <String>{};



      // Pour chaque parcelle, récupérer les plantations inactives

      for (final bed in beds) {

        final plantings = GardenBoxes.getPlantings(bed.id);



        // Filtrer les plantations inactives

        final inactivePlantings = plantings.where((p) => !p.isActive).toList();



        // Extraire les plantId (en excluant les plantes actives)

        for (final planting in inactivePlantings) {

          if (!activePlantIds.contains(planting.plantId)) {

            historicalPlantIds.add(planting.plantId);

          }

        }

      }



      developer.log(

        'Trouvé ${historicalPlantIds.length} plantes historiques pour jardin $gardenId',

        name: _logName,

        level: 500,

      );



      return historicalPlantIds.toList();

    } catch (e, stackTrace) {

      developer.log(

        'Erreur lors de la récupération des plantes historiques',

        name: _logName,

        level: 1000,

        error: e,

        stackTrace: stackTrace,

      );

      return [];

    }

  }



  /// Extrait l'ID du jardin

  String _extractGardenId(dynamic garden) {

    try {

      return garden.id as String;

    } catch (e) {

      throw ArgumentError('Garden must have an id property of type String');

    }

  }



  /// Extrait le nom du jardin

  String _extractGardenName(dynamic garden) {

    try {

      return garden.name as String? ?? 'Jardin sans nom';

    } catch (e) {

      return 'Jardin sans nom';

    }

  }



  /// Extrait la description du jardin

  String? _extractGardenDescription(dynamic garden) {

    try {

      return garden.description as String?;

    } catch (e) {

      return null;

    }

  }



  /// Extrait la localisation du jardin

  String _extractGardenLocation(dynamic garden) {

    try {

      return garden.location as String? ?? 'Localisation non spécifiée';

    } catch (e) {

      return 'Localisation non spécifiée';

    }

  }



  /// Extrait la date de Création

  DateTime? _extractCreatedAt(dynamic garden) {

    try {

      return garden.createdAt as DateTime?;

    } catch (e) {

      return null;

    }

  }



  // ==================== Méthodes de Création de Valeurs par Défaut ====================



  /// Crée des conditions climatiques par défaut pour la France métropolitaine

  ClimateConditions _createDefaultClimateConditions() {

    return const ClimateConditions(

      averageTemperature: 15.0,

      minTemperature: -5.0,

      maxTemperature: 35.0,

      averagePrecipitation: 800.0,

      averageHumidity: 70.0,

      frostDays: 30,

      growingSeasonLength: 250,

      dominantWindDirection: 'Ouest',

      averageWindSpeed: 10.0,

      averageSunshineHours: 8.0,

    );

  }



  /// Crée des préférences de culture par défaut orientées permaculture

  CultivationPreferences _createDefaultCultivationPreferences() {

    return const CultivationPreferences(

      method: CultivationMethod.permaculture,

      usePesticides: false,

      useChemicalFertilizers: false,

      useOrganicFertilizers: true,

      cropRotation: true,

      companionPlanting: true,

      mulching: true,

      automaticIrrigation: false,

      regularMonitoring: true,

      objectives: [

        'Production de légumes',

        'Autonomie alimentaire',

        'Biodiversité'

      ],

    );

  }

}




