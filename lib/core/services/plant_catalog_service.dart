import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/plant.dart';

/// Service pour gérer le catalogue de plantes depuis plants.json
class PlantCatalogService {
  static const String _plantsAssetPath = 'assets/data/plants.json';

  static List<Plant>? _cachedPlants;
  static DateTime? _lastLoadTime;
  static const Duration _cacheValidityDuration = Duration(hours: 1);

  /// Charge toutes les plantes depuis le fichier JSON
  ///
  /// ✅ REFACTORÉ - Support multi-format :
  /// - Legacy (array-only) : `[{plant1}, {plant2}, ...]`
  /// - v2.1.0 (structured) : `{ schema_version, metadata, plants: [...] }`
  ///
  /// Détection automatique du format
  static Future<List<Plant>> loadPlants({bool forceReload = false}) async {
    // Vérifier le cache
    if (!forceReload &&
        _cachedPlants != null &&
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!) < _cacheValidityDuration) {
      return _cachedPlants!;
    }

    try {
      // Charger le fichier JSON
      final String jsonString = await rootBundle.loadString(_plantsAssetPath);
      final dynamic jsonData = json.decode(jsonString);

      // ✅ NOUVEAU : Détection automatique du format
      List<dynamic> jsonList;

      if (jsonData is List) {
        // Format Legacy (array-only)
        jsonList = jsonData;
      } else if (jsonData is Map<String, dynamic>) {
        // Format v2.1.0+ (structured avec schema_version)
        final schemaVersion = jsonData['schema_version'] as String?;

        if (schemaVersion == null) {
          throw const PlantCatalogException(
              'Format JSON invalide : Object sans schema_version (attendu: array ou object avec schema_version)');
        }

        // Extraire la liste des plantes
        jsonList = jsonData['plants'] as List? ?? [];

        // Logger les métadonnées si disponibles
        final metadata = jsonData['metadata'] as Map<String, dynamic>?;
        if (metadata != null) {
          print('🌱 PlantCatalogService: Format v$schemaVersion détecté');
          print('   - Version: ${metadata['version']}');
          print('   - Total plantes: ${metadata['total_plants']}');
          print('   - Source: ${metadata['source']}');
          print('   - Mise à jour: ${metadata['updated_at']}');
        }
      } else {
        throw PlantCatalogException(
            'Format JSON invalide : Attendu List ou Map, reçu ${jsonData.runtimeType}');
      }

      // Convertir en objets Plant
      final List<Plant> plants = jsonList
          .map((json) => Plant.fromJson(json as Map<String, dynamic>))
          .toList();

      // Mettre en cache
      _cachedPlants = plants;
      _lastLoadTime = DateTime.now();

      return plants;
    } catch (e) {
      throw PlantCatalogException('Erreur lors du chargement des plantes: $e');
    }
  }

  /// Recherche une plante par ID
  static Future<Plant?> getPlantById(String id) async {
    final plants = await loadPlants();
    try {
      return plants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Recherche des plantes par nom commun ou scientifique
  static Future<List<Plant>> searchPlants(String query) async {
    if (query.isEmpty) return [];

    final plants = await loadPlants();
    final lowerQuery = query.toLowerCase();

    return plants.where((plant) {
      return plant.commonName.toLowerCase().contains(lowerQuery) ||
          plant.scientificName.toLowerCase().contains(lowerQuery) ||
          plant.family.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Filtre les plantes par famille
  static Future<List<Plant>> getPlantsByFamily(String family) async {
    final plants = await loadPlants();
    return plants.where((plant) => plant.family == family).toList();
  }

  /// Filtre les plantes par catégorie
  static Future<List<Plant>> getPlantsByCategory(String category) async {
    final plants = await loadPlants();
    return plants.where((plant) => plant.category == category).toList();
  }

  /// Filtre les plantes par saison de plantation
  static Future<List<Plant>> getPlantsByPlantingSeason(String season) async {
    final plants = await loadPlants();
    return plants
        .where((plant) => plant.plantingSeason.contains(season))
        .toList();
  }

  /// Filtre les plantes par difficulté
  static Future<List<Plant>> getPlantsByDifficulty(String difficulty) async {
    final plants = await loadPlants();
    return plants.where((plant) => plant.difficulty == difficulty).toList();
  }

  /// Filtre les plantes à croissance rapide (≤ 45 jours)
  static Future<List<Plant>> getQuickGrowingPlants() async {
    final plants = await loadPlants();
    return plants.where((plant) => plant.isQuickGrowing).toList();
  }

  /// Filtre les plantes à croissance lente (≥ 90 jours)
  static Future<List<Plant>> getSlowGrowingPlants() async {
    final plants = await loadPlants();
    return plants.where((plant) => plant.isSlowGrowing).toList();
  }

  /// Obtient les plantes compagnes d'une plante donnée
  static Future<List<Plant>> getCompanionPlants(String plantId) async {
    final plant = await getPlantById(plantId);
    if (plant == null) return [];

    final allPlants = await loadPlants();
    final companionIds = plant.beneficialCompanions;

    return allPlants.where((p) => companionIds.contains(p.id)).toList();
  }

  /// Obtient les plantes incompatibles avec une plante donnée
  static Future<List<Plant>> getIncompatiblePlants(String plantId) async {
    final plant = await getPlantById(plantId);
    if (plant == null) return [];

    final allPlants = await loadPlants();
    final incompatibleIds = plant.incompatiblePlants;

    return allPlants.where((p) => incompatibleIds.contains(p.id)).toList();
  }

  /// Obtient les statistiques du catalogue
  static Future<Map<String, dynamic>> getCatalogStats() async {
    final plants = await loadPlants();

    // Répartition par famille
    final Map<String, int> familyDistribution = {};
    for (final plant in plants) {
      familyDistribution[plant.family] =
          (familyDistribution[plant.family] ?? 0) + 1;
    }

    // Répartition par catégorie
    final Map<String, int> categoryDistribution = {};
    for (final plant in plants) {
      categoryDistribution[plant.category] =
          (categoryDistribution[plant.category] ?? 0) + 1;
    }

    // Répartition par difficulté
    final Map<String, int> difficultyDistribution = {};
    for (final plant in plants) {
      difficultyDistribution[plant.difficulty] =
          (difficultyDistribution[plant.difficulty] ?? 0) + 1;
    }

    // Moyennes
    final avgDaysToMaturity = plants.isNotEmpty
        ? plants.fold<int>(0, (sum, plant) => sum + plant.daysToMaturity) /
            plants.length
        : 0;

    final avgSpacing = plants.isNotEmpty
        ? plants.fold<double>(0, (sum, plant) => sum + plant.spacing) /
            plants.length
        : 0;

    return {
      'totalPlants': plants.length,
      'familyDistribution': familyDistribution,
      'categoryDistribution': categoryDistribution,
      'difficultyDistribution': difficultyDistribution,
      'avgDaysToMaturity': avgDaysToMaturity.round(),
      'avgSpacing': avgSpacing.round(),
      'quickGrowingPlants': plants.where((p) => p.isQuickGrowing).length,
      'slowGrowingPlants': plants.where((p) => p.isSlowGrowing).length,
      'easyPlants': plants
          .where(
              (p) => p.difficulty == 'Très facile' || p.difficulty == 'Facile')
          .length,
    };
  }

  /// Obtient les plantes plantables ce mois-ci
  static Future<List<Plant>> getPlantableThisMonth() async {
    final plants = await loadPlants();
    final currentMonth = _getCurrentMonthAbbreviation();

    return plants
        .where((plant) => plant.sowingMonths.contains(currentMonth))
        .toList();
  }

  /// Obtient les plantes récoltables ce mois-ci
  static Future<List<Plant>> getHarvestablePlants() async {
    final plants = await loadPlants();
    final currentMonth = _getCurrentMonthAbbreviation();

    return plants
        .where((plant) => plant.harvestMonths.contains(currentMonth))
        .toList();
  }

  /// Obtient l'abréviation du mois actuel
  static String _getCurrentMonthAbbreviation() {
    final monthAbbreviations = [
      'J',
      'F',
      'M',
      'A',
      'M',
      'J',
      'J',
      'A',
      'S',
      'O',
      'N',
      'D'
    ];
    return monthAbbreviations[DateTime.now().month - 1];
  }

  /// Vide le cache
  static void clearCache() {
    _cachedPlants = null;
    _lastLoadTime = null;
  }

  /// Valide la structure d'une plante
  static bool validatePlantData(Map<String, dynamic> plantJson) {
    final requiredFields = [
      'id',
      'commonName',
      'scientificName',
      'family',
      'description',
      'plantingSeason',
      'harvestSeason',
      'daysToMaturity',
      'spacing',
      'depth',
      'sunExposure',
      'waterNeeds',
      'sowingMonths',
      'harvestMonths',
      'marketPricePerKg',
      'defaultUnit',
      'nutritionPer100g',
      'germination',
      'growth',
      'watering',
      'thinning',
      'weeding',
      'culturalTips',
      'biologicalControl',
      'harvestTime',
      'companionPlanting',
      'notificationSettings'
    ];

    for (final field in requiredFields) {
      if (!plantJson.containsKey(field)) {
        return false;
      }
    }
    return true;
  }
}

/// Exception personnalisée pour les erreurs du catalogue de plantes
class PlantCatalogException implements Exception {
  final String message;

  const PlantCatalogException(this.message);

  @override
  String toString() => 'PlantCatalogException: $message';
}

