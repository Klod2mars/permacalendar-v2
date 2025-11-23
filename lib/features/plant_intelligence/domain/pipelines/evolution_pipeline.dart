import 'dart:developer' as developer;

import '../entities/intelligence_report.dart';
import '../entities/plant_evolution_report.dart';
import '../repositories/i_analytics_repository.dart';
import '../services/evolution_condition_mapper.dart';
import '../services/plant_intelligence_evolution_tracker.dart';

/// Pipeline dédiée à la comparaison de rapports d'intelligence.
///
/// SRP :
///   👉 Récupérer le rapport précédent
///   👉 Comparer avec le nouveau rapport
///   👉 Générer un résumé d’évolution
///   👉 Persister le PlantEvolutionReport
///
/// Aucun impact sur jardins, conditions, recommandations.
///
class EvolutionPipeline {
  final IAnalyticsRepository _analyticsRepository;
  final PlantIntelligenceEvolutionTracker _tracker;
  final EvolutionConditionMapper _conditionMapper;

  EvolutionPipeline({
    required IAnalyticsRepository analyticsRepository,
    required PlantIntelligenceEvolutionTracker tracker,
    required EvolutionConditionMapper conditionMapper,
  })  : _analyticsRepository = analyticsRepository,
        _tracker = tracker,
        _conditionMapper = conditionMapper;

  /// Exécute la comparaison entre ancien et nouveau rapport.
  ///
  /// Retourne `null` si aucun rapport précédent n'est disponible.
  Future<PlantEvolutionReport?> run({
    required PlantIntelligenceReport current,
  }) async {
    developer.log(
      '📈 EvolutionPipeline → Analyse de l’évolution pour plante ${current.plantId}',
      name: 'EvolutionPipeline',
    );

    // 1. Récupérer le rapport précédent
    PlantIntelligenceReport? previous;
    try {
      previous = await _analyticsRepository.getLastReport(current.plantId);
    } catch (e) {
      developer.log(
        '⚠️ EvolutionPipeline → Échec récupération rapport précédent: $e',
        name: 'EvolutionPipeline',
        level: 900,
      );
    }

    if (previous == null) {
      developer.log(
        'ℹ️ EvolutionPipeline → Aucun rapport précédent, première analyse',
        name: 'EvolutionPipeline',
      );
      return null;
    }

    // 2. Comparer via le tracker
    final summary = _tracker.compareReports(previous, current);

    final trend = summary.isImproved
        ? 'up'
        : summary.isDegraded
            ? 'down'
            : 'stable';

    developer.log(
      '📊 EvolutionPipeline → Trend = $trend (Δ ${summary.scoreDelta.toStringAsFixed(2)})',
      name: 'EvolutionPipeline',
    );

    // 3. Mapper conditions améliorées/dégradées/inchangées
    final improved = _conditionMapper.extractImproved(summary);
    final degraded = _conditionMapper.extractDegraded(summary);
    final unchanged = _conditionMapper.extractUnchanged(summary);

    // 4. Construire le rapport d’évolution
    final evolutionReport = PlantEvolutionReport(
      plantId: current.plantId,
      previousDate: previous.generatedAt,
      currentDate: current.generatedAt,
      previousScore: previous.intelligenceScore,
      currentScore: current.intelligenceScore,
      deltaScore: summary.scoreDelta,
      trend: trend,
      improvedConditions: improved,
      degradedConditions: degraded,
      unchangedConditions: unchanged,
    );

    // 5. Persister
    try {
      await _analyticsRepository.saveEvolutionReport(evolutionReport);
      developer.log(
        '✅ EvolutionPipeline → Rapport d’évolution sauvegardé',
        name: 'EvolutionPipeline',
      );
    } catch (e) {
      developer.log(
        '⚠️ EvolutionPipeline → Échec sauvegarde evolution: $e',
        name: 'EvolutionPipeline',
        level: 900,
      );
    }

    return evolutionReport;
  }
}
