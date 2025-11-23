import 'dart:developer' as developer;

import '../../../../core/services/aggregation/garden_aggregation_hub.dart';

/// Service dédié à l’invalidation des caches internes.
/// 
/// SRP strict :
///   👉 Efface uniquement les caches mémoire des services dépendants.
///   👉 Ne touche à aucune box Hive.
///   👉 Ne lance aucune exception (toutes sont absorbées et loguées).
///   👉 Est totalement idempotente.
/// 
/// Utilisé par l’Orchestrateur et par initializeForGarden().
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
      name: 'Cac
