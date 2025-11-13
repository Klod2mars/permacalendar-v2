import '../entities/recommendation.dart';

/// Interface spécialisée pour la gestion des recommandations
///
/// Respecte le principe ISP (Interface Segregation Principle) en ne définissant
/// que les méthodes liées à la gestion des recommandations.
///
/// **Responsabilités :**
/// - CRUD des Recommendation
/// - Filtrage par priorité
/// - Marquage (appliquée, ignorée)
abstract class IRecommendationRepository {
  /// Sauvegarde une recommandation
  ///
  /// [plantId] - Identifiant de la plante
  /// [recommendation] - Recommandation à sauvegarder
  ///
  /// Retourne l'ID de l'enregistrement créé
  Future<String> saveRecommendation({
    required String plantId,
    required Recommendation recommendation,
  });

  /// Récupère les recommandations actives pour une plante
  ///
  /// [plantId] - Identifiant de la plante
  /// [limit] - Nombre maximum de recommandations à retourner
  ///
  /// Retourne la liste des recommandations actives
  Future<List<Recommendation>> getActiveRecommendations({
    required String plantId,
    int limit = 10,
  });

  /// Récupère les recommandations par priorité
  ///
  /// [plantId] - Identifiant de la plante
  /// [priority] - Niveau de priorité recherché
  ///
  /// Retourne la liste des recommandations de la priorité spécifiée
  Future<List<Recommendation>> getRecommendationsByPriority({
    required String plantId,
    required String priority,
  });

  /// Marque une recommandation comme appliquée
  ///
  /// [recommendationId] - Identifiant de la recommandation
  /// [appliedAt] - Date d'application (optionnel, par défaut maintenant)
  /// [notes] - Notes sur l'application (optionnel)
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> markRecommendationAsApplied({
    required String recommendationId,
    DateTime? appliedAt,
    String? notes,
  });

  /// Marque une recommandation comme ignorée
  ///
  /// [recommendationId] - Identifiant de la recommandation
  /// [reason] - Raison de l'ignorance (optionnel)
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> markRecommendationAsIgnored({
    required String recommendationId,
    String? reason,
  });

  /// Supprime une recommandation
  ///
  /// [recommendationId] - Identifiant de la recommandation à supprimer
  ///
  /// Retourne true si la suppression a réussi
  Future<bool> deleteRecommendation(String recommendationId);

  /// Filtre les recommandations par critères
  ///
  /// [criteria] - Critères de filtrage
  ///
  /// Retourne la liste des recommandations filtrées
  Future<List<Recommendation>> filterRecommendations(
      Map<String, dynamic> criteria);
}


