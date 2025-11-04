import '../entities/intelligence_report.dart';
import '../entities/plant_evolution_report.dart';

/// Interface spécialisée pour l'analytics et les statistiques
///
/// Respecte le principe ISP (Interface Segregation Principle) en ne définissant
/// que les méthodes liées aux analyses, statistiques et métriques.
///
/// **Responsabilités :**
/// - Sauvegarde des résultats d'analyse
/// - Statistiques de santé
/// - Métriques de performance
/// - Données de tendances
/// - Gestion des alertes
/// - Persistence des rapports d'intelligence (CURSOR PROMPT A4)
abstract class IAnalyticsRepository {
  // ==================== GESTION DES ANALYSES ====================

  /// Sauvegarde le résultat d'une analyse
  ///
  /// [plantId] - Identifiant de la plante
  /// [analysisType] - Type d'analyse (condition, weather, intelligence)
  /// [result] - Résultat de l'analyse (JSON)
  /// [confidence] - Niveau de confiance de l'analyse
  ///
  /// Retourne l'ID de l'enregistrement créé
  Future<String> saveAnalysisResult({
    required String plantId,
    required String analysisType,
    required Map<String, dynamic> result,
    required double confidence,
  });

  /// Récupère la dernière analyse d'un type pour une plante
  ///
  /// [plantId] - Identifiant de la plante
  /// [analysisType] - Type d'analyse recherché
  ///
  /// Retourne le résultat de la dernière analyse
  Future<Map<String, dynamic>?> getLatestAnalysis({
    required String plantId,
    required String analysisType,
  });

  /// Récupère l'historique des analyses
  ///
  /// [plantId] - Identifiant de la plante
  /// [analysisType] - Type d'analyse (optionnel)
  /// [startDate] - Date de début de la période (optionnel)
  /// [endDate] - Date de fin de la période (optionnel)
  /// [limit] - Nombre maximum d'enregistrements à retourner
  ///
  /// Retourne la liste des résultats d'analyses historiques
  Future<List<Map<String, dynamic>>> getAnalysisHistory({
    required String plantId,
    String? analysisType,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  });

  // ==================== STATISTIQUES ET MÉTRIQUES ====================

  /// Récupère les statistiques de santé d'une plante
  ///
  /// [plantId] - Identifiant de la plante
  /// [period] - Période d'analyse en jours (par défaut 30)
  ///
  /// Retourne les statistiques de santé
  Future<Map<String, dynamic>> getPlantHealthStats({
    required String plantId,
    int period = 30,
  });

  /// Récupère les métriques de performance du jardin
  ///
  /// [gardenId] - Identifiant du jardin
  /// [period] - Période d'analyse en jours (par défaut 30)
  ///
  /// Retourne les métriques de performance
  Future<Map<String, dynamic>> getGardenPerformanceMetrics({
    required String gardenId,
    int period = 30,
  });

  /// Récupère les tendances d'évolution
  ///
  /// [plantId] - Identifiant de la plante
  /// [metric] - Métrique à analyser (health, growth, etc.)
  /// [period] - Période d'analyse en jours (par défaut 90)
  ///
  /// Retourne les données de tendance
  Future<List<Map<String, dynamic>>> getTrendData({
    required String plantId,
    required String metric,
    int period = 90,
  });

  // ==================== GESTION DES ALERTES ====================

  /// Sauvegarde une alerte
  ///
  /// [plantId] - Identifiant de la plante
  /// [alertType] - Type d'alerte
  /// [severity] - Niveau de sévérité
  /// [message] - Message de l'alerte
  /// [data] - Données additionnelles (optionnel)
  ///
  /// Retourne l'ID de l'enregistrement créé
  Future<String> saveAlert({
    required String plantId,
    required String alertType,
    required String severity,
    required String message,
    Map<String, dynamic>? data,
  });

  /// Récupère les alertes actives
  ///
  /// [plantId] - Identifiant de la plante (optionnel)
  /// [gardenId] - Identifiant du jardin (optionnel)
  /// [severity] - Niveau de sévérité minimum (optionnel)
  ///
  /// Retourne la liste des alertes actives
  Future<List<Map<String, dynamic>>> getActiveAlerts({
    String? plantId,
    String? gardenId,
    String? severity,
  });

  /// Marque une alerte comme résolue
  ///
  /// [alertId] - Identifiant de l'alerte
  /// [resolvedAt] - Date de résolution (optionnel, par défaut maintenant)
  /// [resolution] - Description de la résolution (optionnel)
  ///
  /// Retourne true si la mise à jour a réussi
  Future<bool> resolveAlert({
    required String alertId,
    DateTime? resolvedAt,
    String? resolution,
  });

  // ==================== CURSOR PROMPT A4 - REPORT PERSISTENCE ====================

  /// Sauvegarde le dernier rapport d'intelligence pour une plante
  ///
  /// **CURSOR PROMPT A4 - Intelligence Report Persistence**
  ///
  /// Cette méthode permet de persister le rapport complet d'intelligence
  /// pour permettre les comparaisons futures et le suivi d'évolution.
  ///
  /// **Responsabilités :**
  /// - Sauvegarder le rapport complet en JSON dans Hive
  /// - Utiliser le plantId comme clé pour un accès rapide
  /// - Écraser automatiquement l'ancien rapport (un seul rapport par plante)
  /// - Logger les opérations de sauvegarde pour la traçabilité
  /// - Gérer les erreurs de sérialisation de manière défensive
  ///
  /// **Stratégie de stockage :**
  /// - Un seul rapport par plante (le plus récent)
  /// - Stockage en JSON pour la flexibilité
  /// - Clé = plantId pour un accès O(1)
  ///
  /// [report] - Le rapport d'intelligence complet à sauvegarder
  ///
  /// Retourne Future<void> - Ne lance pas d'exception en cas d'erreur
  /// (programmation défensive : la persistence ne doit jamais bloquer l'analyse)
  Future<void> saveLatestReport(PlantIntelligenceReport report);

  /// Récupère le dernier rapport d'intelligence sauvegardé pour une plante
  ///
  /// **CURSOR PROMPT A4 - Intelligence Report Persistence**
  ///
  /// Cette méthode permet de récupérer le dernier rapport connu pour une plante
  /// afin de permettre les comparaisons d'évolution et l'affichage de l'historique.
  ///
  /// **Responsabilités :**
  /// - Récupérer le rapport depuis Hive via le plantId
  /// - Désérialiser le JSON en PlantIntelligenceReport
  /// - Retourner null si aucun rapport n'existe ou en cas d'erreur
  /// - Logger les opérations de lecture pour la traçabilité
  /// - Gérer les erreurs de désérialisation de manière défensive
  ///
  /// **Utilisation :**
  /// - Récupéré avant une nouvelle analyse pour comparaison
  /// - Utilisé par l'EvolutionTracker pour calculer les deltas
  /// - Peut être affiché dans l'UI pour montrer l'historique
  ///
  /// [plantId] - ID de la plante dont on veut récupérer le dernier rapport
  ///
  /// Retourne le dernier rapport connu, ou null si aucun n'existe ou en cas d'erreur
  /// (programmation défensive : ne jamais crasher si le rapport ne peut être chargé)
  Future<PlantIntelligenceReport?> getLastReport(String plantId);

  // ==================== CURSOR PROMPT A7 - EVOLUTION HISTORY PERSISTENCE ====================

  /// Sauvegarde un rapport d'évolution pour une plante
  ///
  /// **CURSOR PROMPT A7 - Evolution History Persistence**
  ///
  /// Cette méthode permet de persister l'historique des évolutions d'une plante
  /// pour permettre l'analyse de tendances à long terme et la visualisation.
  ///
  /// **Responsabilités :**
  /// - Sauvegarder le rapport d'évolution en JSON dans Hive
  /// - Utiliser une clé composée : plantId + timestamp pour permettre l'historique
  /// - Ne jamais écraser les anciens rapports (historique complet)
  /// - Logger les opérations de sauvegarde pour la traçabilité
  /// - Gérer les erreurs de sérialisation de manière défensive
  ///
  /// **Stratégie de stockage :**
  /// - Plusieurs rapports par plante (historique complet)
  /// - Stockage en JSON pour la flexibilité
  /// - Clé = plantId_timestamp pour un accès et tri rapides
  ///
  /// [report] - Le rapport d'évolution à sauvegarder (PlantEvolutionReport)
  ///
  /// Retourne Future<void> - Ne lance pas d'exception en cas d'erreur
  /// (programmation défensive : la persistence ne doit jamais bloquer l'analyse)
  Future<void> saveEvolutionReport(PlantEvolutionReport report);

  /// Récupère l'historique des rapports d'évolution pour une plante
  ///
  /// **CURSOR PROMPT A7 - Evolution History Persistence**
  ///
  /// Cette méthode permet de récupérer l'historique complet des évolutions
  /// d'une plante pour permettre l'analyse de tendances et la visualisation.
  ///
  /// **Responsabilités :**
  /// - Récupérer tous les rapports d'évolution depuis Hive pour le plantId
  /// - Désérialiser chaque JSON en PlantEvolutionReport
  /// - Trier par timestamp (ordre chronologique)
  /// - Retourner liste vide si aucun rapport ou en cas d'erreur
  /// - Gérer les erreurs de désérialisation de manière défensive (skip corrupted)
  /// - Logger les opérations de lecture pour la traçabilité
  ///
  /// **Utilisation :**
  /// - Afficher l'historique d'évolution dans l'UI
  /// - Générer des graphiques de tendances
  /// - Analyser la santé à long terme
  /// - Détecter les patterns cycliques
  ///
  /// [plantId] - ID de la plante dont on veut récupérer l'historique
  ///
  /// Retourne la liste des rapports d'évolution triés par date (vide si aucun)
  /// (programmation défensive : ne jamais crasher, skip les rapports corrompus)
  Future<List<PlantEvolutionReport>> getEvolutionReports(String plantId);
}
