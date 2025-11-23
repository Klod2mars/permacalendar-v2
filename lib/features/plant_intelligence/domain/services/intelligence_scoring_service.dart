import 'dart:developer' as developer;

import '../entities/analysis_result.dart';
import '../entities/recommendation.dart';
import '../entities/intelligence_report.dart';

/// Service dédié au calcul du score d’intelligence.
///
/// SRP strict :
///   👉 Convertir analysis + timing + recos → score (0-100)
///   👉 Aucune persistance
///   👉 Aucun accès box
///
/// Dépendances minimales : aucune.
///
class IntelligenceScoringService {
  /// Calcule le score global d’intelligence.
  ///
  /// Formule actuelle :
  ///   - 60% : score santé
  ///   - 20% : timing plantation
  ///   - 20% : pénalité si trop de recommandations critiques
  ///
  /// (Tu pourras plus tard plugger ici un modèle ML ou une heuristique évoluée)
  double compute({
    required PlantAnalysisResult analysis,
    required List<Recommendation> recommendations,
    required PlantingTimingEvaluation timing,
  }) {
    developer.log(
      '📐 ScoringService → Calcul score…',
      name: 'IntelligenceScoringService',
    );

    double score = 0.0;

    // 1. Santé (60%)
    score += analysis.healthScore * 0.6;

    // 2. Timing de plantation (20%)
    score += timing.timingScore * 0.2;

    // 3. Bonus / malus lié aux recos critiques (20%)
    final criticalCount = recommendations
        .where((r) => r.priority == RecommendationPriority.critical)
        .length;

    double bonus;
    if (criticalCount == 0) {
      bonus = 20.0;
    } else {
      bonus = (20.0 - (criticalCount * 5.0)).clamp(0.0, 20.0);
    }

    score += bonus;

    // Clamp final
    final normalized = score.clamp(0.0, 100.0);

    developer.log(
      '✅ ScoringService → Score final = ${normalized.toStringAsFixed(1)}',
      name: 'IntelligenceScoringService',
    );

    return normalized;
  }
}
