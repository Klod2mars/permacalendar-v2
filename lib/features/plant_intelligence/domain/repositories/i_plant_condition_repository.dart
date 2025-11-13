ï»¿import '../entities/plant_condition.dart';

/// Interface spécialisée pour la gestion des conditions de plantes
///
/// Respecte le principe ISP (Interface Segregation Principle) en ne définissant
/// que les méthodes liées à la gestion des conditions de plantes.
///
/// **Responsabilités :**
/// - CRUD des PlantCondition
/// - Historique des conditions
abstract class IPlantConditionRepository {
  /// Sauvegarde les conditions d'une plante
  ///
  /// [plantId] - Identifiant unique de la plante
  /// [condition] - Conditions actuelles de la plante
  ///
  /// Retourne l'ID de l'enregistrement Créé
  Future<String> savePlantCondition({
    required String plantId,
    required PlantCondition condition,
  });

  /// Récupère les conditions actuelles d'une plante
  ///
  /// [plantId] - Identifiant unique de la plante
  ///
  /// Retourne les conditions actuelles ou null si non trouvées
  Future<PlantCondition?> getCurrentPlantCondition(String plantId);

  /// Récupère l'historique des conditions d'une plante
  ///
  /// [plantId] - Identifiant unique de la plante
  /// [startDate] - Date de début de la période (optionnel)
  /// [endDate] - Date de fin de la période (optionnel)
  /// [limit] - Nombre maximum d'enregistrements à retourner
  ///
  /// Retourne la liste des conditions historiques
  Future<List<PlantCondition>> getPlantConditionHistory({
    required String plantId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  });

  /// Met à jour les conditions d'une plante
  ///
  /// [conditionId] - Identifiant de l'enregistrement de condition
  /// [condition] - Nouvelles conditions
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> updatePlantCondition({
    required String conditionId,
    required PlantCondition condition,
  });

  /// Supprime un enregistrement de condition
  ///
  /// [conditionId] - Identifiant de l'enregistrement à supprimer
  ///
  /// Retourne true si la suppression a réussi
  Future<bool> deletePlantCondition(String conditionId);
}


