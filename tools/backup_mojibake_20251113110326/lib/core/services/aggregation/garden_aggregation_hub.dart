import 'dart:developer' as developer;
import '../../models/unified_garden_context.dart';
import 'data_adapter.dart';
import 'legacy_data_adapter.dart';
import 'modern_data_adapter.dart';
import 'intelligence_data_adapter.dart';
import '../../../features/plant_intelligence/domain/repositories/plant_intelligence_repository.dart';

/// Garden Aggregation Hub - Hub Central Unifié
///
/// **Architecture First - Design Pattern: Strategy + Adapter + Facade**
///
/// Ce hub central résout naturellement les conflits Hive en :
/// - Centralisant l'accès aux données via des adaptateurs
/// - Découplant les consommateurs des détails d'implémentation
/// - Fournissant une stratégie de résolution intelligente (Moderne > Legacy > IA)
/// - Garantissant la cohérence des données par l'interface unifiée
///
/// **Bénéfices :**
/// - Plus de double ouverture de boxes Hive
/// - Plus de conflits de types
/// - Une seule source de vérité
/// - Performance optimisée par cache intelligent
/// - Évolutivité : facile d'ajouter de nouveaux systèmes
///
/// **Stratégie de Résolution :**
/// 1. Tenter Modern (priorité 3) → Système cible
/// 2. Fallback Legacy (priorité 2) → Système historique
/// 3. Fallback Intelligence (priorité 1) → Enrichissement IA
/// 4. Fallback valeurs par défaut → Garantir résilience
/// Cache entry pour l'intelligence d'un jardin
///
/// **PROMPT A15 - Multi-Garden Intelligence Cache**
class GardenIntelligenceCache {
  final String gardenId;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  DateTime lastAccessedAt;

  GardenIntelligenceCache({
    required this.gardenId,
    required this.data,
    required this.createdAt,
    required this.lastAccessedAt,
  });

  /// Marque le cache comme accédé
  void markAccessed() {
    lastAccessedAt = DateTime.now();
  }

  /// Vérifie si le cache est encore valide
  bool isValid(Duration validityDuration) {
    return DateTime.now().difference(createdAt) < validityDuration;
  }
}

class GardenAggregationHub {
  final List<DataAdapter> _adapters;
  final Map<String, dynamic> _cache = {};
  final Duration _cacheValidityDuration = const Duration(minutes: 10);

  /// **PROMPT A15 - Multi-Garden Intelligence**
  /// Cache per-garden pour l'intelligence végétale
  final Map<String, GardenIntelligenceCache> _intelligenceCaches = {};
  final int _maxIntelligenceCaches = 5; // LRU: garder max 5 jardins en cache

  static const String _logName = 'GardenAggregationHub';

  /// Constructeur avec injection des adaptateurs
  GardenAggregationHub({
    LegacyDataAdapter? legacyAdapter,
    ModernDataAdapter? modernAdapter,
    IntelligenceDataAdapter? intelligenceAdapter,
  }) : _adapters = [] {
    // Ajouter les adaptateurs fournis ou créer les défauts
    _adapters.add(legacyAdapter ?? LegacyDataAdapter());
    _adapters.add(modernAdapter ?? ModernDataAdapter());

    // Intelligence adapter nécessite une injection explicite (dépendance)
    if (intelligenceAdapter != null) {
      _adapters.add(intelligenceAdapter);
    }

    // Trier les adaptateurs par priorité (du plus haut au plus bas)
    _adapters.sort((a, b) => b.priority.compareTo(a.priority));

    developer.log(
      '🏗️ Garden Aggregation Hub initialisé avec ${_adapters.length} adaptateurs',
      name: _logName,
      level: 500,
    );

    for (final adapter in _adapters) {
      developer.log(
        '  - ${adapter.adapterName} (priorité: ${adapter.priority})',
        name: _logName,
        level: 500,
      );
    }
  }

  /// Factory méthode pour créer le hub avec tous les adaptateurs
  factory GardenAggregationHub.withIntelligence({
    required PlantIntelligenceRepository intelligenceRepository,
  }) {
    return GardenAggregationHub(
      legacyAdapter: LegacyDataAdapter(),
      modernAdapter: ModernDataAdapter(),
      intelligenceAdapter: IntelligenceDataAdapter(
        intelligenceRepository: intelligenceRepository,
      ),
    );
  }

  // ==================== API PUBLIQUE ====================

  /// Récupère le contexte unifié d'un jardin avec stratégie de résolution
  ///
  /// **Stratégie :**
  /// 1. Essayer Modern adapter (priorité haute)
  /// 2. Fallback Legacy adapter si Modern échoue
  /// 3. Fallback Intelligence adapter si Legacy échoue
  /// 4. Enrichir avec données IA si disponibles
  /// 5. Retourner contexte par défaut si tout échoue
  Future<UnifiedGardenContext> getUnifiedContext(String gardenId) async {
    try {
      developer.log(
        '🔍 Hub: Récupération contexte unifié pour jardin $gardenId',
        name: _logName,
        level: 500,
      );

      // Vérifier le cache
      final cacheKey = 'garden_context_$gardenId';
      if (_isCacheValid(cacheKey)) {
        developer.log(
          '📦 Hub: Contexte trouvé dans le cache',
          name: _logName,
          level: 500,
        );
        return _cache[cacheKey];
      }

      // Stratégie de résolution avec fallback
      UnifiedGardenContext? context;

      for (final adapter in _adapters) {
        try {
          // Vérifier si l'adaptateur est disponible
          final isAvailable = await adapter.isAvailable();
          if (!isAvailable) {
            developer.log(
              '⚠️ Hub: ${adapter.adapterName} non disponible, passage au suivant',
              name: _logName,
              level: 900,
            );
            continue;
          }

          // Tenter de récupérer le contexte
          developer.log(
            '🔄 Hub: Tentative ${adapter.adapterName}...',
            name: _logName,
            level: 500,
          );

          context = await adapter.getGardenContext(gardenId);

          if (context != null) {
            developer.log(
              '✅ Hub: Contexte récupéré depuis ${adapter.adapterName}',
              name: _logName,
              level: 500,
            );
            break;
          }
        } catch (e) {
          developer.log(
            '❌ Hub: ${adapter.adapterName} a échoué: $e',
            name: _logName,
            level: 900,
            error: e,
          );
          // Continuer avec le prochain adaptateur
        }
      }

      // Si aucun adaptateur n'a réussi, retourner un contexte par défaut
      if (context == null) {
        developer.log(
          '⚠️ Hub: Aucun adaptateur disponible, création contexte par défaut',
          name: _logName,
          level: 1000,
        );
        context = _createDefaultContext(gardenId);
      }

      // Enrichir le contexte avec les données IA si disponibles
      context = await _enrichWithIntelligence(context);

      // Mettre en cache
      _cache[cacheKey] = context;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      developer.log(
        '🎯 Hub: Contexte unifié créé avec succès',
        name: _logName,
        level: 500,
      );

      return context;
    } catch (e, stackTrace) {
      developer.log(
        '❌ ERREUR CRITIQUE Hub: Impossible de créer le contexte unifié',
        name: _logName,
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );

      // En dernier recours, retourner un contexte minimal
      return _createDefaultContext(gardenId);
    }
  }

  /// Récupère les plantes actives d'un jardin avec stratégie de résolution
  Future<List<UnifiedPlantData>> getActivePlants(String gardenId) async {
    try {
      final cacheKey = 'active_plants_$gardenId';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      // Stratégie de résolution : essayer chaque adaptateur
      for (final adapter in _adapters) {
        try {
          if (await adapter.isAvailable()) {
            final plants = await adapter.getActivePlants(gardenId);
            if (plants.isNotEmpty) {
              _cache[cacheKey] = plants;
              _cache['${cacheKey}_timestamp'] = DateTime.now();

              developer.log(
                '${plants.length} plantes actives depuis ${adapter.adapterName}',
                name: _logName,
                level: 500,
              );

              return plants;
            }
          }
        } catch (e) {
          developer.log(
            'Erreur ${adapter.adapterName} getActivePlants: $e',
            name: _logName,
            level: 900,
          );
        }
      }

      return [];
    } catch (e) {
      developer.log(
        'Erreur Hub getActivePlants: $e',
        name: _logName,
        level: 1000,
        error: e,
      );
      return [];
    }
  }

  /// Récupère les plantes historiques d'un jardin avec stratégie de résolution
  Future<List<UnifiedPlantData>> getHistoricalPlants(String gardenId) async {
    try {
      final cacheKey = 'historical_plants_$gardenId';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      // Stratégie de résolution
      for (final adapter in _adapters) {
        try {
          if (await adapter.isAvailable()) {
            final plants = await adapter.getHistoricalPlants(gardenId);
            if (plants.isNotEmpty) {
              _cache[cacheKey] = plants;
              _cache['${cacheKey}_timestamp'] = DateTime.now();
              return plants;
            }
          }
        } catch (e) {
          developer.log(
            'Erreur ${adapter.adapterName} getHistoricalPlants: $e',
            name: _logName,
            level: 900,
          );
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Récupère une plante spécifique par son ID
  Future<UnifiedPlantData?> getPlantById(String plantId) async {
    try {
      final cacheKey = 'plant_$plantId';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      // Stratégie de résolution
      for (final adapter in _adapters) {
        try {
          if (await adapter.isAvailable()) {
            final plant = await adapter.getPlantById(plantId);
            if (plant != null) {
              _cache[cacheKey] = plant;
              _cache['${cacheKey}_timestamp'] = DateTime.now();
              return plant;
            }
          }
        } catch (e) {
          developer.log(
            'Erreur ${adapter.adapterName} getPlantById: $e',
            name: _logName,
            level: 900,
          );
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Récupère les statistiques d'un jardin avec agrégation intelligente
  Future<UnifiedGardenStats> getGardenStats(String gardenId) async {
    try {
      final cacheKey = 'garden_stats_$gardenId';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      // Agréger les statistiques depuis plusieurs sources si possible
      UnifiedGardenStats? stats;

      for (final adapter in _adapters) {
        try {
          if (await adapter.isAvailable()) {
            final adapterStats = await adapter.getGardenStats(gardenId);
            if (adapterStats != null) {
              // Si on a déjà des stats, les fusionner intelligemment
              if (stats != null) {
                stats = _mergeStats(stats, adapterStats);
              } else {
                stats = adapterStats;
              }
            }
          }
        } catch (e) {
          developer.log(
            'Erreur ${adapter.adapterName} getGardenStats: $e',
            name: _logName,
            level: 900,
          );
        }
      }

      final finalStats = stats ?? _getDefaultStats();
      _cache[cacheKey] = finalStats;
      _cache['${cacheKey}_timestamp'] = DateTime.now();

      return finalStats;
    } catch (e) {
      return _getDefaultStats();
    }
  }

  /// Récupère les activités récentes d'un jardin
  Future<List<UnifiedActivityHistory>> getRecentActivities(
    String gardenId, {
    int limit = 20,
  }) async {
    try {
      final cacheKey = 'activities_${gardenId}_$limit';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey];
      }

      // Stratégie de résolution
      for (final adapter in _adapters) {
        try {
          if (await adapter.isAvailable()) {
            final activities =
                await adapter.getRecentActivities(gardenId, limit: limit);
            if (activities.isNotEmpty) {
              _cache[cacheKey] = activities;
              _cache['${cacheKey}_timestamp'] = DateTime.now();
              return activities;
            }
          }
        } catch (e) {
          developer.log(
            'Erreur ${adapter.adapterName} getRecentActivities: $e',
            name: _logName,
            level: 900,
          );
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Invalide le cache pour un jardin spécifique
  void invalidateCache(String gardenId) {
    final keysToRemove = <String>[];
    for (final key in _cache.keys) {
      if (key.contains(gardenId)) {
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      _cache.remove(key);
      _cache.remove('${key}_timestamp');
    }

    developer.log(
      'Cache invalidé pour jardin $gardenId (${keysToRemove.length} entrées)',
      name: _logName,
      level: 500,
    );
  }

  /// Efface tout le cache
  void clearCache() {
    _cache.clear();
    developer.log('Cache Hub entièrement effacé', name: _logName, level: 500);
  }

  // ==================== PROMPT A15 - MULTI-GARDEN INTELLIGENCE CACHE ====================

  /// Récupère le cache d'intelligence pour un jardin
  ///
  /// Retourne null si le cache n'existe pas ou est invalide.
  /// Met à jour lastAccessedAt si le cache est valide (pour LRU).
  Map<String, dynamic>? getIntelligenceCache(String gardenId) {
    final cache = _intelligenceCaches[gardenId];

    if (cache == null) {
      return null;
    }

    if (!cache.isValid(_cacheValidityDuration)) {
      // Cache expiré, le supprimer
      _intelligenceCaches.remove(gardenId);
      developer.log(
        '⏰ Cache intelligence expiré pour jardin $gardenId',
        name: _logName,
        level: 500,
      );
      return null;
    }

    // Cache valide, marquer comme accédé et retourner
    cache.markAccessed();
    developer.log(
      '✅ Cache intelligence trouvé pour jardin $gardenId',
      name: _logName,
      level: 500,
    );

    return cache.data;
  }

  /// Définit le cache d'intelligence pour un jardin
  ///
  /// Applique la stratégie LRU si le nombre max de caches est atteint.
  void setIntelligenceCache(String gardenId, Map<String, dynamic> data) {
    // Vérifier si on dépasse la limite
    if (_intelligenceCaches.length >= _maxIntelligenceCaches &&
        !_intelligenceCaches.containsKey(gardenId)) {
      _evictLRUIntelligenceCache();
    }

    final now = DateTime.now();
    _intelligenceCaches[gardenId] = GardenIntelligenceCache(
      gardenId: gardenId,
      data: data,
      createdAt: now,
      lastAccessedAt: now,
    );

    developer.log(
      '💾 Cache intelligence sauvegardé pour jardin $gardenId (${_intelligenceCaches.length}/$_maxIntelligenceCaches)',
      name: _logName,
      level: 500,
    );
  }

  /// Invalide le cache d'intelligence pour un jardin spécifique
  ///
  /// Utilisé lors de la génération d'un nouveau rapport ou d'une mise à jour.
  void invalidateGardenIntelligenceCache(String gardenId) {
    if (_intelligenceCaches.remove(gardenId) != null) {
      developer.log(
        '🗑️ Cache intelligence invalidé pour jardin $gardenId',
        name: _logName,
        level: 500,
      );
    }
  }

  /// Évacue le cache le moins récemment utilisé (LRU eviction)
  ///
  /// Trouve le cache avec le lastAccessedAt le plus ancien et le supprime.
  void _evictLRUIntelligenceCache() {
    if (_intelligenceCaches.isEmpty) return;

    // Trouver le cache le moins récemment utilisé
    String? lruGardenId;
    DateTime? oldestAccess;

    for (final entry in _intelligenceCaches.entries) {
      if (oldestAccess == null ||
          entry.value.lastAccessedAt.isBefore(oldestAccess)) {
        oldestAccess = entry.value.lastAccessedAt;
        lruGardenId = entry.key;
      }
    }

    if (lruGardenId != null) {
      _intelligenceCaches.remove(lruGardenId);
      developer.log(
        '♻️ LRU: Éviction du cache intelligence pour jardin $lruGardenId (dernier accès: $oldestAccess)',
        name: _logName,
        level: 500,
      );
    }
  }

  /// Efface tous les caches d'intelligence
  void clearAllIntelligenceCaches() {
    final count = _intelligenceCaches.length;
    _intelligenceCaches.clear();
    developer.log(
      '🗑️ Tous les caches intelligence effacés ($count jardins)',
      name: _logName,
      level: 500,
    );
  }

  /// Retourne des statistiques sur les caches d'intelligence
  Map<String, dynamic> getIntelligenceCacheStats() {
    return {
      'total_caches': _intelligenceCaches.length,
      'max_caches': _maxIntelligenceCaches,
      'gardens_cached': _intelligenceCaches.keys.toList(),
      'cache_ages': _intelligenceCaches.map((key, value) => MapEntry(
            key,
            DateTime.now().difference(value.createdAt).inSeconds,
          )),
      'last_accessed': _intelligenceCaches.map((key, value) => MapEntry(
            key,
            DateTime.now().difference(value.lastAccessedAt).inSeconds,
          )),
    };
  }

  /// Vérifie la santé du hub et de tous les adaptateurs
  Future<Map<String, dynamic>> healthCheck() async {
    final health = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'adapters': <Map<String, dynamic>>[],
    };

    for (final adapter in _adapters) {
      try {
        final isAvailable = await adapter.isAvailable();
        health['adapters'].add({
          'name': adapter.adapterName,
          'priority': adapter.priority,
          'available': isAvailable,
        });
      } catch (e) {
        health['adapters'].add({
          'name': adapter.adapterName,
          'priority': adapter.priority,
          'available': false,
          'error': e.toString(),
        });
      }
    }

    return health;
  }

  // ==================== MÉTHODES PRIVÉES ====================

  /// Enrichit le contexte avec les données d'Intelligence si disponibles
  Future<UnifiedGardenContext> _enrichWithIntelligence(
    UnifiedGardenContext context,
  ) async {
    try {
      // Trouver l'adaptateur Intelligence
      final intelligenceAdapter = _adapters.firstWhere(
        (adapter) => adapter is IntelligenceDataAdapter,
        orElse: () => throw StateError('Intelligence adapter non disponible'),
      );

      if (await intelligenceAdapter.isAvailable()) {
        // Récupérer les stats enrichies avec IA
        final intelligenceStats =
            await intelligenceAdapter.getGardenStats(context.gardenId);

        if (intelligenceStats != null) {
          // Fusionner les stats en priorisant les données IA pour certains champs
          final enrichedStats = context.stats.copyWith(
            averageHealth: intelligenceStats.averageHealth,
            activeRecommendations: intelligenceStats.activeRecommendations,
            activeAlerts: intelligenceStats.activeAlerts,
          );

          developer.log(
            '🌟 Hub: Contexte enrichi avec Intelligence (${intelligenceStats.activeRecommendations} recommandations)',
            name: _logName,
            level: 500,
          );

          return context.copyWith(stats: enrichedStats);
        }
      }
    } catch (e) {
      developer.log(
        'Enrichissement Intelligence échoué (non critique): $e',
        name: _logName,
        level: 700,
      );
    }

    return context;
  }

  /// Fusionne intelligemment deux statistiques
  UnifiedGardenStats _mergeStats(
    UnifiedGardenStats stats1,
    UnifiedGardenStats stats2,
  ) {
    // Prendre le maximum ou la somme selon le champ
    return UnifiedGardenStats(
      totalPlants:
          stats1.totalPlants > 0 ? stats1.totalPlants : stats2.totalPlants,
      activePlants:
          stats1.activePlants > 0 ? stats1.activePlants : stats2.activePlants,
      historicalPlants: stats1.historicalPlants > 0
          ? stats1.historicalPlants
          : stats2.historicalPlants,
      totalArea: stats1.totalArea > 0 ? stats1.totalArea : stats2.totalArea,
      activeArea: stats1.activeArea > 0 ? stats1.activeArea : stats2.activeArea,
      totalBeds: stats1.totalBeds > 0 ? stats1.totalBeds : stats2.totalBeds,
      activeBeds: stats1.activeBeds > 0 ? stats1.activeBeds : stats2.activeBeds,
      plantingsThisYear: stats1.plantingsThisYear > 0
          ? stats1.plantingsThisYear
          : stats2.plantingsThisYear,
      harvestsThisYear: stats1.harvestsThisYear > 0
          ? stats1.harvestsThisYear
          : stats2.harvestsThisYear,
      successRate:
          stats1.successRate > 0 ? stats1.successRate : stats2.successRate,
      totalYield: stats1.totalYield > 0 ? stats1.totalYield : stats2.totalYield,
      currentYearYield: stats1.currentYearYield > 0
          ? stats1.currentYearYield
          : stats2.currentYearYield,
      // Prioriser les données IA pour ces champs
      averageHealth: stats2.averageHealth > 0
          ? stats2.averageHealth
          : stats1.averageHealth,
      activeRecommendations: stats2.activeRecommendations > 0
          ? stats2.activeRecommendations
          : stats1.activeRecommendations,
      activeAlerts:
          stats2.activeAlerts > 0 ? stats2.activeAlerts : stats1.activeAlerts,
    );
  }

  /// Vérifie si une entrée du cache est encore valide
  bool _isCacheValid(String cacheKey) {
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


