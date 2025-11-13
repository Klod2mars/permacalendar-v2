import 'dart:developer' as developer;
import '../data/hive/garden_boxes.dart';
import '../models/planting.dart';
import '../../features/plant_intelligence/domain/entities/garden_context.dart';

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
        '🔍 DIAGNOSTIC - Récupération des plantes actives pour jardin $gardenId',
        name: _logName,
        level: 500,
      );

      // Récupérer toutes les parcelles du jardin
      final beds = GardenBoxes.getGardenBeds(gardenId);

      developer.log(
        '📦 DIAGNOSTIC - Parcelles trouvées: ${beds.length}',
        name: _logName,
        level: 500,
      );

      if (beds.isEmpty) {
        developer.log(
          '❌ DIAGNOSTIC - Aucune parcelle trouvée pour jardin $gardenId',
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
          '📦 DIAGNOSTIC - Parcelle: ${bed.name} (ID: ${bed.id})',
          name: _logName,
          level: 500,
        );

        final plantings = GardenBoxes.getPlantings(bed.id);

        developer.log(
          '🌱 DIAGNOSTIC - Plantations trouvées: ${plantings.length}',
          name: _logName,
          level: 500,
        );

        // Filtrer les plantations actives
        final activePlantings = plantings.where((p) => p.isActive).toList();

        developer.log(
          '🌱 DIAGNOSTIC - Plantations actives: ${activePlantings.length}',
          name: _logName,
          level: 500,
        );

        // Extraire les plantId
        for (final planting in activePlantings) {
          developer.log(
            '🌱 DIAGNOSTIC - Plantation active: ${planting.plantId}',
            name: _logName,
            level: 500,
          );
          activePlantIds.add(planting.plantId);
        }
      }

      final result = activePlantIds.toList();

      developer.log(
        '✅ DIAGNOSTIC - Trouvé ${result.length} plantes actives pour jardin $gardenId',
        name: _logName,
        level: 500,
      );

      for (final plantId in result) {
        developer.log(
          '🌱 DIAGNOSTIC - Plante active finale: $plantId',
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

  /// Calcule les statistiques réelles d'un jardin
  ///
  /// **Statistiques calculées :**
  /// - `totalArea` : Somme des surfaces de toutes les parcelles (m²)
  /// - `activeArea` : Somme des surfaces des parcelles actives (m²)
  /// - `totalPlants` : Nombre total de plantations
  /// - `activePlants` : Nombre de plantations actives
  /// - `plantingsThisYear` : Plantations créées cette année
  /// - `harvestsThisYear` : Plantations récoltées cette année
  /// - `successRate` : Taux de réussite (harvestsThisYear / plantingsThisYear * 100)
  ///
  /// **Notes :**
  /// - Les champs de rendement (totalYield, etc.) sont à 0.0 pour l'instant
  /// - Évolution future : intégrer les données de récolte réelles
  ///
  /// **Retourne :** Objet `GardenStats` avec statistiques réelles
  GardenStats calculateGardenStats(String gardenId) {
    try {
      developer.log(
        'Calcul des statistiques pour jardin $gardenId',
        name: _logName,
        level: 500,
      );

      // Récupérer toutes les parcelles du jardin
      final beds = GardenBoxes.getGardenBeds(gardenId);

      // Calculer les surfaces
      double totalArea = 0.0;
      double activeArea = 0.0;

      for (final bed in beds) {
        totalArea += bed.sizeInSquareMeters;
        if (bed.isActive) {
          activeArea += bed.sizeInSquareMeters;
        }
      }

      // Récupérer toutes les plantations
      final allPlantings = <Planting>[];
      for (final bed in beds) {
        allPlantings.addAll(GardenBoxes.getPlantings(bed.id));
      }

      // Calculer les compteurs
      final totalPlants = allPlantings.length;
      final activePlants = allPlantings.where((p) => p.isActive).length;

      // Plantations de l'année en cours
      final currentYear = DateTime.now().year;
      final plantingsThisYear =
          allPlantings.where((p) => p.plantedDate.year == currentYear).length;

      // Récoltes de l'année en cours (plantations récoltées cette année)
      final harvestsThisYear = allPlantings
          .where((p) =>
              p.actualHarvestDate != null &&
              p.actualHarvestDate!.year == currentYear)
          .length;

      // Calculer le taux de réussite
      double successRate = 0.0;
      if (plantingsThisYear > 0) {
        successRate = (harvestsThisYear / plantingsThisYear) * 100;
      }

      developer.log(
        'Statistiques calculées : $totalPlants plantations, $activePlants actives, '
        '${totalArea.toStringAsFixed(2)}m² total, ${activeArea.toStringAsFixed(2)}m² actifs',
        name: _logName,
        level: 500,
      );

      return GardenStats(
        totalPlants: totalPlants,
        activePlants: activePlants,
        totalArea: totalArea,
        activeArea: activeArea,
        totalYield: 0.0, // TODO: Intégrer données de récolte réelles
        currentYearYield: 0.0, // TODO: Intégrer données de récolte réelles
        harvestsThisYear: harvestsThisYear,
        plantingsThisYear: plantingsThisYear,
        successRate: successRate,
        totalInputCosts: 0.0, // TODO: Intégrer système de coûts
        totalHarvestValue: 0.0, // TODO: Intégrer système de valorisation
      );
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors du calcul des statistiques',
        name: _logName,
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );

      // Retourner statistiques par défaut en cas d'erreur
      return const GardenStats(
        totalPlants: 0,
        activePlants: 0,
        totalArea: 0.0,
        activeArea: 0.0,
        totalYield: 0.0,
        currentYearYield: 0.0,
        harvestsThisYear: 0,
        plantingsThisYear: 0,
        successRate: 0.0,
        totalInputCosts: 0.0,
        totalHarvestValue: 0.0,
      );
    }
  }

  /// Agrège les informations de sol d'un jardin
  ///
  /// **Processus :**
  /// 1. Récupère toutes les parcelles du jardin
  /// 2. Analyse la distribution des types de sol
  /// 3. Sélectionne le type de sol majoritaire (le plus fréquent)
  /// 4. Mappe les types de sol français vers les enums `SoilType`
  /// 5. Crée un objet `SoilInfo` avec valeurs par défaut raisonnables
  ///
  /// **Mapping des types de sol :**
  /// - "Argileux" → SoilType.clay
  /// - "Sableux" → SoilType.sandy
  /// - "Limoneux" → SoilType.loamy
  /// - "Humifère" → SoilType.peaty
  /// - "Calcaire" → SoilType.chalky
  /// - "Mixte" → SoilType.loamy (par défaut)
  ///
  /// **Retourne :** Objet `SoilInfo` avec type de sol majoritaire et valeurs par défaut
  SoilInfo aggregateSoilInfo(String gardenId) {
    try {
      developer.log(
        'Agrégation des informations de sol pour jardin $gardenId',
        name: _logName,
        level: 500,
      );

      // Récupérer toutes les parcelles du jardin
      final beds = GardenBoxes.getGardenBeds(gardenId);

      if (beds.isEmpty) {
        developer.log(
          'Aucune parcelle pour jardin $gardenId, retour sol par défaut',
          name: _logName,
          level: 500,
        );
        return _getDefaultSoilInfo();
      }

      // Analyser la distribution des types de sol
      final soilTypeDistribution = <String, int>{};
      for (final bed in beds) {
        final soilType = bed.soilType;
        soilTypeDistribution[soilType] =
            (soilTypeDistribution[soilType] ?? 0) + 1;
      }

      // Sélectionner le type de sol majoritaire
      String majorSoilType = 'Mixte';
      int maxCount = 0;

      soilTypeDistribution.forEach((soilType, count) {
        if (count > maxCount) {
          maxCount = count;
          majorSoilType = soilType;
        }
      });

      // Mapper vers le type SoilType
      final soilType = _mapFrenchSoilTypeToEnum(majorSoilType);

      developer.log(
        'Type de sol majoritaire : $majorSoilType → $soilType',
        name: _logName,
        level: 500,
      );

      // Créer l'objet SoilInfo avec le type détecté
      return SoilInfo(
        type: soilType,
        ph: 7.0, // pH neutre par défaut
        texture: _getSoilTextureForType(soilType),
        organicMatter: 3.0, // Valeur raisonnable par défaut (%)
        waterRetention: _getWaterRetentionForType(soilType),
        drainage: _getSoilDrainageForType(soilType),
        depth: 30.0, // 30 cm de profondeur par défaut
        nutrients: const NutrientLevels(
          nitrogen: NutrientLevel.adequate,
          phosphorus: NutrientLevel.adequate,
          potassium: NutrientLevel.adequate,
          calcium: NutrientLevel.adequate,
          magnesium: NutrientLevel.adequate,
          sulfur: NutrientLevel.adequate,
          micronutrients: {},
        ),
        biologicalActivity: BiologicalActivity.moderate,
        contaminants: null,
      );
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de l\'agrégation des informations de sol',
        name: _logName,
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      return _getDefaultSoilInfo();
    }
  }

  // ==================== Méthodes Privées ====================

  /// Mappe les types de sol français vers les enums SoilType
  SoilType _mapFrenchSoilTypeToEnum(String frenchSoilType) {
    switch (frenchSoilType) {
      case 'Argileux':
        return SoilType.clay;
      case 'Sableux':
        return SoilType.sandy;
      case 'Limoneux':
        return SoilType.loamy;
      case 'Humifère':
        return SoilType.peaty;
      case 'Calcaire':
        return SoilType.chalky;
      case 'Mixte':
      default:
        return SoilType.loamy; // Défaut : limoneux équilibré
    }
  }

  /// Retourne la texture du sol adaptée au type
  SoilTexture _getSoilTextureForType(SoilType type) {
    switch (type) {
      case SoilType.clay:
        return SoilTexture.fine;
      case SoilType.sandy:
        return SoilTexture.coarse;
      case SoilType.loamy:
      case SoilType.silty:
        return SoilTexture.medium;
      case SoilType.peaty:
        return SoilTexture.fine;
      case SoilType.chalky:
      case SoilType.rocky:
        return SoilTexture.coarse;
    }
  }

  /// Retourne la capacité de rétention d'eau adaptée au type
  double _getWaterRetentionForType(SoilType type) {
    switch (type) {
      case SoilType.clay:
        return 80.0; // Argile retient beaucoup d'eau
      case SoilType.sandy:
        return 30.0; // Sable retient peu d'eau
      case SoilType.loamy:
      case SoilType.silty:
        return 60.0; // Équilibré
      case SoilType.peaty:
        return 90.0; // Très forte rétention
      case SoilType.chalky:
        return 40.0;
      case SoilType.rocky:
        return 20.0;
    }
  }

  /// Retourne le drainage adapté au type
  SoilDrainage _getSoilDrainageForType(SoilType type) {
    switch (type) {
      case SoilType.clay:
        return SoilDrainage.poor; // Argile draine mal
      case SoilType.sandy:
        return SoilDrainage.excellent; // Sable draine très bien
      case SoilType.loamy:
      case SoilType.silty:
        return SoilDrainage.good; // Équilibré
      case SoilType.peaty:
        return SoilDrainage.moderate;
      case SoilType.chalky:
      case SoilType.rocky:
        return SoilDrainage.excellent;
    }
  }

  /// Retourne un objet SoilInfo par défaut
  SoilInfo _getDefaultSoilInfo() {
    return const SoilInfo(
      type: SoilType.loamy,
      ph: 7.0,
      texture: SoilTexture.medium,
      organicMatter: 3.0,
      waterRetention: 60.0,
      drainage: SoilDrainage.good,
      depth: 30.0,
      nutrients: NutrientLevels(
        nitrogen: NutrientLevel.adequate,
        phosphorus: NutrientLevel.adequate,
        potassium: NutrientLevel.adequate,
        calcium: NutrientLevel.adequate,
        magnesium: NutrientLevel.adequate,
        sulfur: NutrientLevel.adequate,
        micronutrients: {},
      ),
      biologicalActivity: BiologicalActivity.moderate,
      contaminants: null,
    );
  }

  /// Crée un GardenContext complet à partir d'un jardin
  ///
  /// **Méthode publique centrale** pour l'Intelligence Végétale
  ///
  /// **Processus :**
  /// 1. Récupère les données réelles du jardin via les autres méthodes du service
  /// 2. Assemble toutes les informations dans un GardenContext
  /// 3. Utilisée par PlantIntelligenceRepositoryImpl pour créer/mettre à jour le contexte
  ///
  /// **Paramètres :**
  /// - `garden` : Objet jardin (GardenHive, Garden ou dynamic avec les propriétés minimales)
  ///
  /// **Retourne :** GardenContext complet avec données réelles agrégées
  GardenContext createGardenContext(dynamic garden) {
    try {
      developer.log(
        '🏗️ Création GardenContext pour jardin ${_extractGardenId(garden)}',
        name: _logName,
        level: 500,
      );

      final gardenId = _extractGardenId(garden);
      final gardenName = _extractGardenName(garden);
      final gardenDescription = _extractGardenDescription(garden);
      final gardenLocation = _extractGardenLocation(garden);
      final createdAt = _extractCreatedAt(garden);

      // Agréger les données réelles
      final activePlantIds = getActivePlantIds(gardenId);
      final historicalPlantIds = getHistoricalPlantIds(gardenId);
      final stats = calculateGardenStats(gardenId);
      final soil = aggregateSoilInfo(gardenId);

      developer.log(
        '✅ GardenContext créé: ${activePlantIds.length} plantes actives, '
        '${stats.activePlants} plantations, ${stats.totalArea.toStringAsFixed(2)}m²',
        name: _logName,
        level: 500,
      );

      return GardenContext(
        gardenId: gardenId,
        name: gardenName,
        description: gardenDescription,
        location: GardenLocation(
          latitude:
              48.8566, // Paris par défaut (TODO: récupérer vraie localisation)
          longitude: 2.3522,
          altitude: 100.0,
          address: gardenLocation,
          city: null,
          postalCode: null,
          country: 'France',
          usdaZone: '8b', // Zone par défaut pour France métropolitaine
          exposure: null,
        ),
        climate: _createDefaultClimateConditions(),
        soil: soil,
        activePlantIds: activePlantIds,
        historicalPlantIds: historicalPlantIds,
        stats: stats,
        preferences: _createDefaultCultivationPreferences(),
        createdAt: createdAt,
        updatedAt: DateTime.now(),
        metadata: {},
      );
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la création du GardenContext',
        name: _logName,
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // ==================== Méthodes d'Extraction de Données ====================

  /// Extrait l'ID du jardin depuis un objet dynamique
  String _extractGardenId(dynamic garden) {
    if (garden == null) throw ArgumentError('Garden cannot be null');

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

  /// Extrait la date de création
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


