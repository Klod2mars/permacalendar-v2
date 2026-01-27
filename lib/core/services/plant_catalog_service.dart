import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/plant.dart';

/// Service pour gérer le catalogue de plantes depuis plants.json

class PlantCatalogService {
  static const String _plantsAssetPath = 'assets/data/plants_merged_clean.json';

  static List<Plant>? _cachedPlants;

  static DateTime? _lastLoadTime;

  static const Duration _cacheValidityDuration = Duration(hours: 1);

  /// Charge toutes les plantes depuis le fichier JSON

  ///

  /// âœ… REFACTORÉ - Support multi-format :

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

      // âœ… NOUVEAU : Détection automatique du format

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
          print('ðŸŒ± PlantCatalogService: Format v$schemaVersion détecté');

          print('   - Version: ${metadata['version']}');

          print('   - Total plantes: ${metadata['total_plants']}');

          print('   - Source: ${metadata['source']}');

          print('   - mise à jour: ${metadata['updated_at']}');
        }
      } else {
        throw PlantCatalogException(
            'Format JSON invalide : Attendu List ou Map, reçu ${jsonData.runtimeType}');
      }

      // Convertir en objets Plant

      final List<Plant> plants = jsonList.map((jsonItem) {
        final Map<String, dynamic> obj =
            Map<String, dynamic>.from(jsonItem as Map<String, dynamic>);

        if (obj.containsKey('sowingMonths3') && obj['sowingMonths3'] is List) {
          try {
            obj['sowingMonths'] =
                List<String>.from(obj['sowingMonths3'] as List);
          } catch (_) {
            // Ignore on failure and keep the original sowingMonths
          }
        }

        if (obj.containsKey('harvestMonths3') &&
            obj['harvestMonths3'] is List) {
          try {
            obj['harvestMonths'] =
                List<String>.from(obj['harvestMonths3'] as List);
          } catch (_) {
            // Ignore on failure and keep the original harvestMonths
          }
        }

        return Plant.fromJson(obj);
      }).toList();

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

  /// Filtre les plantes à croissance rapide (â‰¤ 45 jours)

  static Future<List<Plant>> getQuickGrowingPlants() async {
    final plants = await loadPlants();

    return plants.where((plant) => plant.isQuickGrowing).toList();
  }

  /// Filtre les plantes à croissance lente (â‰¥ 90 jours)

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

  /// Obtient les plantes plantables ce mois-ci
  static Future<List<Plant>> getPlantableThisMonth() async {
    final plants = await loadPlants();
    final currentMonth = DateTime.now().month;
    return plants.where((plant) => _isMonthInList(plant.sowingMonths, currentMonth)).toList();
  }

  /// Obtient les plantes récoltables ce mois-ci

  /// Obtient les plantes récoltables ce mois-ci
  static Future<List<Plant>> getHarvestablePlants() async {
    final plants = await loadPlants();
    final currentMonth = DateTime.now().month;
    return plants.where((plant) => _isMonthInList(plant.harvestMonths, currentMonth)).toList();
  }

  /// Obtient l'abréviation du mois actuel

  /// Vérifie si un mois donné (1..12) est dans la liste des tokens (supporte formats legacy & v2)
  static bool _isMonthInList(List<String> months, int targetMonth) {
    for (final token in months) {
      if (_tokenMatchesMonth(token, targetMonth)) return true;
    }
    return false;
  }

  static bool _tokenMatchesMonth(String token, int month) {
    final t = token.trim();
    if (t.isEmpty) return false;
    
    // 1. Numeric check
    final n = int.tryParse(t);
    if (n != null) return n == month;

    // 2. Canonical 3-letter check (or full)
    if (t.length >= 3) {
      final three = t.substring(0,3).toLowerCase();
      switch (month) {
        case 1: return three == 'jan';
        case 2: return three == 'fev' || three == 'fév' || three == 'feb';
        case 3: return three == 'mar';
        case 4: return three == 'avr' || three == 'apr';
        case 5: return three == 'mai' || three == 'may';
        case 6: return three == 'jui' || three == 'jun'; 
        case 7: return three == 'jui' || three == 'jul'; 
        case 8: return three == 'aou' || three == 'aoû' || three == 'aug';
        case 9: return three == 'sep';
        case 10: return three == 'oct';
        case 11: return three == 'nov';
        case 12: return three == 'déc' || three == 'dec';
      }
      if (three == 'jui') {
         if (month == 6) return t.toLowerCase().startsWith('juin') || t == 'Jui';
         if (month == 7) return t.toLowerCase().startsWith('juil') || t == 'Jui';
      }
    }

    // 3. Legacy Single Letter (Ambiguous expansion)
    if (t.length == 1) {
      final c = t.toUpperCase();
      switch (c) {
        case 'J': return month == 1 || month == 6 || month == 7;
        case 'F': return month == 2;
        case 'M': return month == 3 || month == 5;
        case 'A': return month == 4 || month == 8;
        case 'S': return month == 9;
        case 'O': return month == 10;
        case 'N': return month == 11;
        case 'D': return month == 12;
      }
    }
    return false;
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
