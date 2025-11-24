import 'dart:developer' as developer;
import 'package:permacalendar/core/services/aggregation/garden_aggregation_hub.dart';

/// Service dédié à l’invalidation des caches internes.
class CacheInvalidationService {
  final GardenAggregationHub? _gardenAggregationHub;

  CacheInvalidationService({
    required GardenAggregationHub? gardenAggregationHub,
  }) : _gardenAggregationHub = gardenAggregationHub;

  Future<void> invalidateAll() async {
    developer.log(
      '🧹 CacheInvalidationService → Invalidation des caches…',
      name: 'CacheInvalidationService',
    );
    int invalidated = 0;

    if (_gardenAggregationHub != null) {
      try {
        _gardenAggregationHub!.clearCache();
        invalidated++;
        developer.log(
          '✔️ Cache GardenAggregationHub invalidé',
          name: 'CacheInvalidationService',
        );
      } catch (e) {
        developer.log(
          '⚠️ Échec invalidation GardenAggregationHub: $e',
          name: 'CacheInvalidationService',
          level: 900,
        );
      }
    } else {
      developer.log(
        'ℹ️ Aucun GardenAggregationHub injecté',
        name: 'CacheInvalidationService',
      );
    }

    developer.log(
      '🏁 CacheInvalidationService → $invalidated service(s) invalidé(s)',
      name: 'CacheInvalidationService',
    );
  }
}

class GardenInitializationService {
  /// Initialisation minimale pour un jardin.
  /// Stub temporaire — remplacer par la vraie logique d'initialisation.
  Future<void> initialize({required String gardenId}) async {
    developer.log(
      'GardenInitializationService → initialisation pour $gardenId',
      name: 'GardenInitializationService',
    );
    // no-op minimal pour permettre la compilation et l'exécution.
    await Future<void>.value();
  }
}
