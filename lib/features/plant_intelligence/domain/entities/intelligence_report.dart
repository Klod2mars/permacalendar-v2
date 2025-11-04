import 'package:freezed_annotation/freezed_annotation.dart';
import 'analysis_result.dart';
import 'recommendation.dart';
import 'notification_alert.dart';

part 'intelligence_report.freezed.dart';
part 'intelligence_report.g.dart';

/// Rapport complet d'intelligence végétale pour une plante
///
/// Combine l'analyse des conditions, les recommandations, le timing de plantation,
/// et les alertes actives en un seul rapport cohérent
@freezed
class PlantIntelligenceReport with _$PlantIntelligenceReport {
  const factory PlantIntelligenceReport({
    /// ID unique du rapport
    required String id,

    /// ID de la plante
    required String plantId,

    /// Nom commun de la plante
    required String plantName,

    /// ID du jardin
    required String gardenId,

    /// Résultat de l'analyse des conditions
    required PlantAnalysisResult analysis,

    /// Liste des recommandations générées
    required List<Recommendation> recommendations,

    /// Évaluation du timing de plantation
    PlantingTimingEvaluation? plantingTiming,

    /// Alertes actives pour cette plante
    @Default([]) List<NotificationAlert> activeAlerts,

    /// Score global d'intelligence (0-100)
    required double intelligenceScore,

    /// Confiance globale du rapport (0-1)
    required double confidence,

    /// Date de génération du rapport
    required DateTime generatedAt,

    /// Date d'expiration du rapport (après laquelle il devrait être régénéré)
    required DateTime expiresAt,

    /// Métadonnées additionnelles
    @Default({}) Map<String, dynamic> metadata,
  }) = _PlantIntelligenceReport;

  factory PlantIntelligenceReport.fromJson(Map<String, dynamic> json) =>
      _$PlantIntelligenceReportFromJson(json);
}

/// Évaluation du timing de plantation
@freezed
class PlantingTimingEvaluation with _$PlantingTimingEvaluation {
  const factory PlantingTimingEvaluation({
    /// Est-ce le bon moment pour planter?
    required bool isOptimalTime,

    /// Score de timing (0-100)
    required double timingScore,

    /// Raison de la recommandation
    required String reason,

    /// Date optimale recommandée pour planter (si pas maintenant)
    DateTime? optimalPlantingDate,

    /// Facteurs favorables actuels
    @Default([]) List<String> favorableFactors,

    /// Facteurs défavorables actuels
    @Default([]) List<String> unfavorableFactors,

    /// Risques identifiés si plantation maintenant
    @Default([]) List<String> risks,
  }) = _PlantingTimingEvaluation;

  factory PlantingTimingEvaluation.fromJson(Map<String, dynamic> json) =>
      _$PlantingTimingEvaluationFromJson(json);
}

/// Extension pour faciliter l'utilisation du rapport
extension PlantIntelligenceReportExtension on PlantIntelligenceReport {
  /// Vérifie si le rapport nécessite une action urgente
  bool get requiresUrgentAction =>
      analysis.isCritical ||
      activeAlerts
          .any((alert) => alert.priority == NotificationPriority.critical);

  /// Récupère les recommandations par priorité
  List<Recommendation> getRecommendationsByPriority(
      RecommendationPriority priority) {
    return recommendations.where((r) => r.priority == priority).toList();
  }

  /// Récupère les recommandations non complétées
  List<Recommendation> get pendingRecommendations {
    return recommendations
        .where((r) => r.status != RecommendationStatus.completed)
        .toList();
  }

  /// Vérifie si le rapport est encore valide
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Durée de validité restante
  Duration get remainingValidity => expiresAt.difference(DateTime.now());
}
