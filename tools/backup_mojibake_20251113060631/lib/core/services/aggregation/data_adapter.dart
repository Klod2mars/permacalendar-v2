import '../../models/unified_garden_context.dart';

/// Interface pour les adaptateurs de données
///
/// Chaque système (Legacy/Moderne/Intelligence) implémente cette interface
/// pour fournir des données unifiées au Garden Aggregation Hub.
abstract class DataAdapter {
  /// Nom de l'adaptateur pour le logging
  String get adapterName;

  /// Vérifie si cet adaptateur est disponible et fonctionnel
  Future<bool> isAvailable();

  /// Récupère le contexte unifié d'un jardin
  Future<UnifiedGardenContext?> getGardenContext(String gardenId);

  /// Récupère les plantes actives d'un jardin
  Future<List<UnifiedPlantData>> getActivePlants(String gardenId);

  /// Récupère les plantes historiques d'un jardin
  Future<List<UnifiedPlantData>> getHistoricalPlants(String gardenId);

  /// Récupère une plante spécifique par son ID
  Future<UnifiedPlantData?> getPlantById(String plantId);

  /// Récupère les statistiques d'un jardin
  Future<UnifiedGardenStats?> getGardenStats(String gardenId);

  /// Récupère les activités récentes d'un jardin
  Future<List<UnifiedActivityHistory>> getRecentActivities(
    String gardenId, {
    int limit = 20,
  });

  /// Priorité de cet adaptateur (plus élevé = plus prioritaire)
  /// Modern > Legacy > Intelligence
  int get priority;
}

/// Exception levée par les adaptateurs
class DataAdapterException implements Exception {
  final String message;
  final String adapterName;
  final Object? originalError;

  const DataAdapterException(
    this.message,
    this.adapterName, {
    this.originalError,
  });

  @override
  String toString() => 'DataAdapterException[$adapterName]: $message';
}


