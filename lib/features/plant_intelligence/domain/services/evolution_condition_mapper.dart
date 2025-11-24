import '../entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/services/plant_intelligence_evolution_tracker.dart';

import 'dart:developer' as developer;

import '../entities/intelligence_report.dart';

/// Service dédié à la comparaison fine des conditions (température,
/// humidité, lumière, sol) entre deux rapports d’intelligence.
///
/// SRP strict : logique pure de comparaison.
///
/// Utilisé par :
///   → EvolutionPipeline
class EvolutionConditionMapper {
  /// Conditions améliorées
  List<String> extractImproved(IntelligenceEvolutionSummary summary) {
    developer.log(
      '🔼 EvolutionConditionMapper → conditions améliorées…',
      name: 'EvolutionConditionMapper',
    );

    final improved = <String>[];

    final oldA = summary.oldReport.analysis;
    final newA = summary.newReport.analysis;

    if (_isBetter(oldA.temperature.status, newA.temperature.status)) {
      improved.add('temperature');
    }
    if (_isBetter(oldA.humidity.status, newA.humidity.status)) {
      improved.add('humidity');
    }
    if (_isBetter(oldA.light.status, newA.light.status)) {
      improved.add('light');
    }
    if (_isBetter(oldA.soil.status, newA.soil.status)) {
      improved.add('soil');
    }

    return improved;
  }

  /// Conditions dégradées
  List<String> extractDegraded(IntelligenceEvolutionSummary summary) {
    developer.log(
      '🔽 EvolutionConditionMapper → conditions dégradées…',
      name: 'EvolutionConditionMapper',
    );

    final degraded = <String>[];

    final oldA = summary.oldReport.analysis;
    final newA = summary.newReport.analysis;

    if (_isWorse(oldA.temperature.status, newA.temperature.status)) {
      degraded.add('temperature');
    }
    if (_isWorse(oldA.humidity.status, newA.humidity.status)) {
      degraded.add('humidity');
    }
    if (_isWorse(oldA.light.status, newA.light.status)) {
      degraded.add('light');
    }
    if (_isWorse(oldA.soil.status, newA.soil.status)) {
      degraded.add('soil');
    }

    return degraded;
  }

  /// Conditions inchangées
  List<String> extractUnchanged(IntelligenceEvolutionSummary summary) {
    developer.log(
      '⏺️ EvolutionConditionMapper → conditions inchangées…',
      name: 'EvolutionConditionMapper',
    );

    final unchanged = <String>[];

    final oldA = summary.oldReport.analysis;
    final newA = summary.newReport.analysis;

    if (!_isBetter(oldA.temperature.status, newA.temperature.status) &&
        !_isWorse(oldA.temperature.status, newA.temperature.status)) {
      unchanged.add('temperature');
    }
    if (!_isBetter(oldA.humidity.status, newA.humidity.status) &&
        !_isWorse(oldA.humidity.status, newA.humidity.status)) {
      unchanged.add('humidity');
    }
    if (!_isBetter(oldA.light.status, newA.light.status) &&
        !_isWorse(oldA.light.status, newA.light.status)) {
      unchanged.add('light');
    }
    if (!_isBetter(oldA.soil.status, newA.soil.status) &&
        !_isWorse(oldA.soil.status, newA.soil.status)) {
      unchanged.add('soil');
    }

    return unchanged;
  }

  // ============================================================
  // Helpers privés — aucune dépendance externe
  // ============================================================

  static const _statusOrder = {
    ConditionStatus.critical: 0,
    ConditionStatus.poor: 1,
    ConditionStatus.suboptimal: 2,
    ConditionStatus.good: 3,
    ConditionStatus.optimal: 4,
  };

  bool _isBetter(ConditionStatus oldStatus, ConditionStatus newStatus) {
    return (_statusOrder[newStatus] ?? 0) > (_statusOrder[oldStatus] ?? 0);
  }

  bool _isWorse(ConditionStatus oldStatus, ConditionStatus newStatus) {
    return (_statusOrder[newStatus] ?? 0) < (_statusOrder[oldStatus] ?? 0);
  }
}
