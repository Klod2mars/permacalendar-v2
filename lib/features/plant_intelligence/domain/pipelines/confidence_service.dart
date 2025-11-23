// lib/features/plant_intelligence/domain/services/confidence_service.dart
import 'dart:developer' as developer;

import '../entities/analysis_result.dart';
import '../entities/weather_condition.dart';

/// Calcul de la confiance globale (0.0 - 1.0)
class ConfidenceService {
  double compute({
    required PlantAnalysisResult analysis,
    required WeatherCondition weather,
  }) {
    developer.log('🔍 ConfidenceService → Calcul confiance…',
        name: 'ConfidenceService');

    double confidence = analysis.confidence;

    final hours = DateTime.now().difference(weather.measuredAt).inHours;
    if (hours > 12) confidence *= 0.8;
    if (hours > 24) confidence *= 0.7;

    final normalized = confidence.clamp(0.0, 1.0);
    developer.log(
      '✅ ConfidenceService → Confiance finale = ${normalized.toStringAsFixed(3)}',
      name: 'ConfidenceService',
    );
    return normalized;
  }
}
