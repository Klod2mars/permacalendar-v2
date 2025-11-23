import 'dart:developer' as developer;

import '../entities/analysis_result.dart';
import '../entities/weather_condition.dart';

/// Service dédié au calcul de la confiance globale.
///
/// SRP strict :
///   👉 Calculer une confiance (0.0 - 1.0) en fonction :
///       - de la confiance intrinsèque de l’analyse
///       - de l’âge des données météo
///   👉 Aucune persistance
///   👉 Aucun accès aux boxes
///
class ConfidenceService {
  /// Calcule la confiance finale dans le rapport.
  ///
  /// Règles actuelles :
  ///   - On part de analysis.confidence (0-1)
  ///   - Si données météo > 12h → pénalité 20%
  ///   - Si données météo > 24h → pénalité supplémentaire 30%
  ///
  /// Et on clamp entre 0 et 1.
  double compute({
    required PlantAnalysisResult analysis,
    required WeatherCondition weather,
  }) {
    developer.log(
      '🔍 ConfidenceService → Calcul confiance…',
      name: 'ConfidenceService',
    );

    double confidence = analysis.confidence;

    final hours = DateTime.now().difference(weather.measuredAt).inHours;

    if (hours > 12) {
      confidence *= 0.8;
    }
    if (hours > 24) {
      confidence *= 0.7;
    }

    final normalized = confidence.clamp(0.0, 1.0);

    developer.log(
      '✅ ConfidenceService → Confiance finale = ${normalized.toStringAsFixed(3)}',
      name: 'ConfidenceService',
    );

    return normalized;
  }
}
