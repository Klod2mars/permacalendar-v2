import 'dart:async';
import 'dart:developer' as developer;

import '../../models/unified_garden_context.dart';

/// Service central d'agrégation des données du jardin
///
/// Ce hub est responsable de :
/// 1. Collecter les données de différentes sources (Hive, Weather, Sensors)
/// 2. Unifier ces données dans un format standard (UnifiedGardenContext)
/// 3. Gérer le cache et les mises à jour
/// 4. Fournir une source unique de vérité pour les widgets UI
class GardenAggregationHub {
  final Map<String, dynamic> _cache = {};
  static const Duration _cacheValidityDuration = Duration(minutes: 5);
  static const String _logName = 'GardenAggregationHub';

  /// Vérifie si le cache est valide pour un jardin donné
  bool _isCacheValid(String gardenId) {
    final cacheKey = 'garden_$gardenId';
    final timestampKey = '${cacheKey}_timestamp';

    if (!_cache.containsKey(cacheKey) || !_cache.containsKey(timestampKey)) {
      return false;
    }

    final timestamp = _cache[timestampKey] as DateTime;
    return DateTime.now().difference(timestamp) < _cacheValidityDuration;
  }

  /// Crée un contexte par défaut pour un jardin
  UnifiedGardenContext _createDefaultContext(String gardenId) {
    return UnifiedGardenContext(
      gardenId: gardenId,
      name: 'Jardin $gardenId',
      description: null,
      location: null,
      totalArea: 0.0,
      activePlants: [],
      historicalPlants: [],
      stats: _getDefaultStats(),
      soil: _getDefaultSoilInfo(),
      climate: _getDefaultClimate(),
      preferences: _getDefaultPreferences(),
      recentActivities: [],
      primarySource: DataSource.fallback,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      metadata: {
        'source': 'fallback',
        'reason': 'Aucun adaptateur disponible',
      },
    );
  }

  UnifiedGardenStats _getDefaultStats() {
    return const UnifiedGardenStats(
      totalPlants: 0,
      activePlants: 0,
      historicalPlants: 0,
      totalArea: 0.0,
      activeArea: 0.0,
      totalBeds: 0,
      activeBeds: 0,
      plantingsThisYear: 0,
      harvestsThisYear: 0,
      successRate: 0.0,
      totalYield: 0.0,
      currentYearYield: 0.0,
      averageHealth: 0.0,
      activeRecommendations: 0,
      activeAlerts: 0,
    );
  }

  UnifiedSoilInfo _getDefaultSoilInfo() {
    return const UnifiedSoilInfo(
      type: 'Unknown',
      ph: 7.0,
      texture: 'medium',
      organicMatter: 0.0,
      waterRetention: 0.0,
      drainage: 'unknown',
      depth: 0.0,
      nutrients: {},
    );
  }

  UnifiedClimate _getDefaultClimate() {
    return const UnifiedClimate(
      averageTemperature: 0.0,
      minTemperature: 0.0,
      maxTemperature: 0.0,
      averagePrecipitation: 0.0,
      averageHumidity: 0.0,
      frostDays: 0,
      growingSeasonLength: 0,
      dominantWindDirection: 'Unknown',
      averageWindSpeed: 0.0,
      averageSunshineHours: 0.0,
    );
  }

  UnifiedCultivationPreferences _getDefaultPreferences() {
    return const UnifiedCultivationPreferences(
      method: 'unknown',
      usePesticides: false,
      useChemicalFertilizers: false,
      useOrganicFertilizers: false,
      cropRotation: false,
      companionPlanting: false,
      mulching: false,
      automaticIrrigation: false,
      regularMonitoring: false,
      objectives: [],
    );
  }
}

/// Exception levée par le Hub
class GardenAggregationHubException implements Exception {
  final String message;
  final Object? originalError;

  const GardenAggregationHubException(this.message, {this.originalError});

  @override
  String toString() => 'GardenAggregationHubException: $message';
}
