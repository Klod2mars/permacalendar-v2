import '../entities/garden_context.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';

/// Interface spécialisée pour la gestion du contexte jardin
///
/// Respecte le principe ISP (Interface Segregation Principle) en ne définissant
/// que les méthodes liées à la gestion des jardins.
///
/// **Responsabilités :**
/// - CRUD des GardenContext
/// - Récupération des plantes d'un jardin
/// - Recherche de plantes
abstract class IGardenContextRepository {
  /// Sauvegarde le contexte d'un jardin
  ///
  /// [garden] - Contexte du jardin
  ///
  /// Retourne l'ID de l'enregistrement créé
  Future<String> saveGardenContext(GardenContext garden);

  /// Récupère le contexte d'un jardin
  ///
  /// [gardenId] - Identifiant du jardin
  ///
  /// Retourne le contexte du jardin
  Future<GardenContext?> getGardenContext(String gardenId);

  /// Met à jour le contexte d'un jardin
  ///
  /// [garden] - Nouveau contexte du jardin
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> updateGardenContext(GardenContext garden);

  /// Récupère tous les jardins d'un utilisateur
  ///
  /// [userId] - Identifiant de l'utilisateur
  ///
  /// Retourne la liste des contextes de jardins
  Future<List<GardenContext>> getUserGardens(String userId);

  /// Récupère toutes les plantes d'un jardin spécifique
  ///
  /// [gardenId] - Identifiant du jardin
  ///
  /// Retourne la liste des plantes actives du jardin
  Future<List<PlantFreezed>> getGardenPlants(String gardenId);

  /// Recherche des plantes par critères
  ///
  /// [criteria] - Critères de recherche
  ///
  /// Retourne la liste des plantes correspondantes
  Future<List<PlantFreezed>> searchPlants(Map<String, dynamic> criteria);
}
