// lib/features/plant_intelligence/domain/services/cache_invalidation_service.dart
import 'dart:developer' as developer;

import 'package:permacalendar/core/services/aggregation/garden_aggregation_hub.dart';

/// Service dédié à l’invalidation des caches internes.
class CacheInvalidationService {
  final GardenAggregationHub? _gardenAggregationHub;

  CacheInvalidationService({
    required GardenAggregationHub? gardenAggregationHub,
  }) : _gardenAggregationHub = gardenAggregationHub;

  /// Invalide tous les caches.
  ///
  /// Cette méthode ne doit JAMAIS échouer.
  Future<void> invalidateAll() async {
    developer.log(
      '🧹 CacheInvalidationService → Invalidation des caches…',
      name: 'CacheInvalidationService',
    );

    int invalidated = 0;

    // 1) GardenAggregationHub
    if (_gardenAggregationHub != null) {
      try {
        _gardenAggregationHub!.clearCache();
        invalidated++;
        developer.log(
          '✔️ Cache GardenAggregationHub invalidé',
          name: 'CacheInvalidationService',
        );
      } catch (e, st) {
        developer.log(
          '⚠️ Échec invalidation GardenAggregationHub: $e',
          name: 'CacheInvalidationService',
          error: e,
          stackTrace: st,
          level: 900,
        );
      }
    } else {
      developer.log(
        'ℹ️ Aucun GardenAggregationHub injecté',
        name: 'CacheInvalidationService',
      );
    }

    // → Place pour futurs invalidateurs de cache (ex: repos locaux)

    developer.log(
      '🏁 CacheInvalidationService → $invalidated service(s) invalidé(s)',
      name: 'CacheInvalidationService',
    );
  }
}
