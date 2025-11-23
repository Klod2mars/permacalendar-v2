import '../entities/plant_condition.dart';

/// Mapping centralisé de l'ordre des ConditionStatus.
///
/// SRP strict :
///   👉 Définir un ordre pour comparer les conditions
///   👉 Éviter la duplication dans d'autres services
///
/// Échelle :
///   critical < poor < suboptimal < good < optimal
class StatusOrder {
  static const Map<ConditionStatus, int> order = {
    ConditionStatus.critical: 0,
    ConditionStatus.poor: 1,
    ConditionStatus.suboptimal: 2,
    ConditionStatus.good: 3,
    ConditionStatus.optimal: 4,
  };

  /// Retourne true si le `newStatus` est meilleur que `oldStatus`.
  static bool isBetter(ConditionStatus oldStatus, ConditionStatus newStatus) {
    return (order[newStatus] ?? 0) > (order[oldStatus] ?? 0);
  }

  /// Retourne true si le `newStatus` est pire.
  static bool isWorse(ConditionStatus oldStatus, ConditionStatus newStatus) {
    return (order[newStatus] ?? 0) < (order[oldStatus] ?? 0);
  }

  /// Retourne true si identique.
  static bool isSame(ConditionStatus oldStatus, ConditionStatus newStatus) {
    return (order[newStatus] ?? 0) == (order[oldStatus] ?? 0);
  }
}
