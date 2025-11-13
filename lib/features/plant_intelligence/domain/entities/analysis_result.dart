import 'package:freezed_annotation/freezed_annotation.dart';
import 'plant_condition.dart';

part 'analysis_result.freezed.dart';
part 'analysis_result.g.dart';

/// Résultat complet d'une analyse de plante
///
/// Encapsule toutes les conditions analysées (température, humidité, lumière, sol)
/// ainsi qu'un état de santé global calculé
@freezed
class PlantAnalysisResult with _$PlantAnalysisResult {
  const factory PlantAnalysisResult({
    /// ID unique de l'analyse
    required String id,

    /// ID de la plante analysée
    required String plantId,

    /// Condition de température
    required PlantCondition temperature,

    /// Condition d'humidité
    required PlantCondition humidity,

    /// Condition de luminosité
    required PlantCondition light,

    /// Condition du sol
    required PlantCondition soil,

    /// État de santé global calculé (excellent, good, fair, poor, critical)
    required ConditionStatus overallHealth,

    /// Score de santé (0-100)
    required double healthScore,

    /// Liste des avertissements détectés
    required List<String> warnings,

    /// Liste des points positifs
    required List<String> strengths,

    /// Recommandations d'action prioritaires
    required List<String> priorityActions,

    /// Confidence de l'analyse (0-1)
    required double confidence,

    /// Date de l'analyse
    required DateTime analyzedAt,

    /// Métadonnées additionnelles
    @Default({}) Map<String, dynamic> metadata,
  }) = _PlantAnalysisResult;

  factory PlantAnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$PlantAnalysisResultFromJson(json);
}

/// Extension pour calculer des métriques dérivées
extension PlantAnalysisResultExtension on PlantAnalysisResult {
  /// Vérifie si l'analyse indique un état critique nécessitant action immédiate
  bool get isCritical =>
      overallHealth == ConditionStatus.critical ||
      overallHealth == ConditionStatus.poor;

  /// Vérifie si la plante est en bonne santé
  bool get isHealthy =>
      overallHealth == ConditionStatus.excellent ||
      overallHealth == ConditionStatus.good;

  /// Nombre total de conditions critiques
  int get criticalConditionsCount {
    int count = 0;
    if (temperature.status == ConditionStatus.critical) count++;
    if (humidity.status == ConditionStatus.critical) count++;
    if (light.status == ConditionStatus.critical) count++;
    if (soil.status == ConditionStatus.critical) count++;
    return count;
  }

  /// Récupère la condition la plus critique
  PlantCondition get mostCriticalCondition {
    final conditions = [temperature, humidity, light, soil];
    // Trier par status décroissant (critical = index 4 en premier)
    conditions.sort((a, b) => b.status.index.compareTo(a.status.index));
    return conditions.first;
  }
}


