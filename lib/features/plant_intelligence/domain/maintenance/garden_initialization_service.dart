import 'dart:developer' as developer;

import 'cache_invalidation_service.dart';
import 'orphan_cleanup_service.dart';

/// Service d’initialisation d’un jardin.
///
/// SRP strict :
///   👉 Nettoyer les données obsolètes (conditions orphelines)
///   👉 Invalider tous les caches internes
///   👉 Ne jamais lancer d'exception
///   👉 Produire un rapport JSON-like des opérations
///
/// Sanctuaire :
///   - Aucune écriture dans garden_*
///   - Suppression autorisée uniquement dans les modern boxes IA
class GardenInitializationService {
  final OrphanCleanupService _cleanupService;
  final CacheInvalidationService _cacheService;

  GardenInitializationService({
    required OrphanCleanupService cleanupService,
    required CacheInvalidationService cacheService,
  })  : _cleanupService = cleanupService,
        _cacheService = cacheService;

  /// Initialise un jardin avant une session d'analyse.
  ///
  /// Retourne un Map<String, dynamic> avec :
  ///   - gardenId
  ///   - orphanedRemoved
  ///   - cleanupSuccess
  ///   - cacheInvalidationSuccess
  ///   - errors[]
  ///
  /// 100% non-bloquant.
  Future<Map<String, dynamic>> initialize({
    required String gardenId,
  }) async {
    developer.log(
      '🚀 InitService → Initialisation jardin $gardenId',
      name: 'GardenInitializationService',
    );

    final stats = <String, dynamic>{
      'gardenId': gardenId,
      'orphanedRemoved': 0,
      'cleanupSuccess': false,
      'cacheInvalidationSuccess': false,
      'errors': <String>[],
    };

    // ──────────────────────────────────────────────
    // 1) Nettoyage conditions orphelines
    // ──────────────────────────────────────────────
    try {
      final removed = await _cleanupService.clean();
      stats['orphanedRemoved'] = removed;
      stats['cleanupSuccess'] = true;

      developer.log(
        '✔️ InitService → $removed condition(s) orpheline(s) supprimée(s)',
        name: 'GardenInitializationService',
      );
    } catch (e, st) {
      final msg = 'Erreur nettoyage orphelines: $e';
      stats['errors'].add(msg);

      developer.log(
        '⚠️ InitService → $msg',
        name: 'GardenInitializationService',
        error: e,
        stackTrace: st,
        level: 900,
      );
    }

    // ──────────────────────────────────────────────
    // 2) Invalidation caches
    // ──────────────────────────────────────────────
    try {
      await _cacheService.invalidateAll();
      stats['cacheInvalidationSuccess'] = true;

      developer.log(
        '✔️ InitService → Caches invalidés',
        name: 'GardenInitializationService',
      );
    } catch (e, st) {
      final msg = 'Erreur invalidation cache: $e';
      stats['errors'].add(msg);

      developer.log(
        '⚠️ InitService → $msg',
        name: 'GardenInitializationService',
        error: e,
        stackTrace: st,
        level: 900,
      );
    }

    // ──────────────────────────────────────────────
    // 3) Résumé
    // ──────────────────────────────────────────────
    developer.log(
      '🏁 InitService → Initialisation terminée '
      '(${stats["cleanupSuccess"] == true ? 1 : 0}'
      '/${stats["cacheInvalidationSuccess"] == true ? 1 : 0} étapes réussies)',
      name: 'GardenInitializationService',
    );

    return stats;
  }
}
