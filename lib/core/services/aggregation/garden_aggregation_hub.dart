import 'dart:async';
import 'dart:developer' as developer;

import '../../models/unified_garden_context.dart';
import 'data_adapter.dart';
import 'legacy_data_adapter.dart';
import 'modern_data_adapter.dart';

/// Service central d'agrégation des données du jardin
///
/// Ce hub est responsable de :
/// 1. Collecter les données de différentes sources (Hive, Weather, Sensors)
/// 2. Unifier ces données dans un format standard (UnifiedGardenContext)
/// 3. Gérer le cache et les mises à jour
/// 4. Fournir une source unique de vérité pour les widgets UI
class GardenAggregationHub {
  final LegacyDataAdapter legacyAdapter;
  final ModernDataAdapter modernAdapter;
  
  final Map<String, dynamic> _cache = {};
  static const Duration _cacheValidityDuration = Duration(minutes: 5);
  static const String _logName = 'GardenAggregationHub';

  GardenAggregationHub({
    required this.legacyAdapter,
    required this.modernAdapter,
  });

  /// Liste des adaptateurs triés par priorité
  List<DataAdapter> get _adapters => [modernAdapter, legacyAdapter]..sort((a, b) => b.priority.compareTo(a.priority));

  /// Récupère le contexte unifié d'un jardin
  Future<UnifiedGardenContext> getUnifiedContext(String gardenId) async {
     if (_isCacheValid(gardenId)) {
       final cached = _cache['garden_$gardenId'];
       if (cached is UnifiedGardenContext) return cached;
     }

     for (final adapter in _adapters) {
       if (await adapter.isAvailable()) {
         try {
           final context = await adapter.getGardenContext(gardenId);
           if (context != null) {
             _updateCache(gardenId, context);
             return context;
           }
         } catch (e) {
           developer.log('Erreur avec adaptateur ${adapter.adapterName}: $e', name: _logName);
         }
       }
     }

     return _createDefaultContext(gardenId);
  }

  /// Récupère les plantes actives d'un jardin
  Future<List<UnifiedPlantData>> getActivePlants(String gardenId) async {
    for (final adapter in _adapters) {
       if (await adapter.isAvailable()) {
         final result = await adapter.getActivePlants(gardenId);
         if (result.isNotEmpty) return result;
       }
    }
    return [];
  }

  /// Récupère les plantes historiques d'un jardin
  Future<List<UnifiedPlantData>> getHistoricalPlants(String gardenId) async {
    for (final adapter in _adapters) {
       if (await adapter.isAvailable()) {
         final result = await adapter.getHistoricalPlants(gardenId);
         if (result.isNotEmpty) return result;
       }
    }
    return [];
  }

  /// Récupère les statistiques d'un jardin
  Future<UnifiedGardenStats> getGardenStats(String gardenId) async {
    for (final adapter in _adapters) {
       if (await adapter.isAvailable()) {
         final result = await adapter.getGardenStats(gardenId);
         if (result != null) return result;
       }
    }
    return _getDefaultStats();
  }

  /// Récupère une plante par son ID
  Future<UnifiedPlantData?> getPlantById(String plantId) async {
    for (final adapter in _adapters) {
       if (await adapter.isAvailable()) {
         final result = await adapter.getPlantById(plantId);
         if (result != null) return result;
       }
    }
    return null;
  }

  /// Récupère les activités récentes d'un jardin
  Future<List<UnifiedActivityHistory>> getRecentActivities(String gardenId, {int limit = 20}) async {
    for (final adapter in _adapters) {
       if (await adapter.isAvailable()) {
         final result = await adapter.getRecentActivities(gardenId, limit: limit);
         if (result.isNotEmpty) return result;
       }
    }
    return [];
  }

  /// Invalide le cache pour un jardin
  void invalidateCache(String gardenId) {
    _cache.remove('garden_$gardenId');
    _cache.remove('garden_${gardenId}_timestamp');
    developer.log('Cache invalidé pour jardin $gardenId', name: _logName);
  }

  /// Vide tout le cache
  void clearCache() {
    _cache.clear();
    developer.log('Tout le cache a été vidé', name: _logName);
  }

  /// Vérifie la santé du hub et des adaptateurs
  Future<Map<String, dynamic>> healthCheck() async {
    final status = <String, dynamic>{
      'hub': 'active',
      'cacheSize': _cache.length,
      'adapters': {},
    };

    for (final adapter in _adapters) {
      status['adapters'][adapter.adapterName] = await adapter.isAvailable();
    }

    return status;
  }

  // ==================== PRIVATE METHODS ====================

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

  /// Met à jour le cache
  void _updateCache(String gardenId, UnifiedGardenContext context) {
    final cacheKey = 'garden_$gardenId';
    final timestampKey = '${cacheKey}_timestamp';
    
    _cache[cacheKey] = context;
    _cache[timestampKey] = DateTime.now();
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
