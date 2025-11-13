import 'dart:developer' as developer;
import '../../models/unified_garden_context.dart';
import 'data_adapter.dart';

/// Data Consistency Manager
///
/// Garantit la cohérence des données entre les 3 systèmes (Legacy/Moderne/Intelligence)
/// en détectant et résolvant les incohérences.
///
/// **Responsabilités :**
/// - Comparer les données entre systèmes
/// - Détecter les incohérences
/// - Proposer des stratégies de résolution
/// - Logger les problèmes de cohérence
class DataConsistencyManager {
  static const String _logName = 'DataConsistencyManager';

  /// Vérifie la cohérence des données pour un jardin entre tous les adaptateurs
  Future<ConsistencyReport> checkGardenConsistency({
    required String gardenId,
    required List<DataAdapter> adapters,
  }) async {
    developer.log(
      '🔍 Vérification cohérence pour jardin $gardenId',
      name: _logName,
      level: 500,
    );

    final report = ConsistencyReport(gardenId: gardenId);
    final contexts = <DataAdapter, UnifiedGardenContext?>{};

    // Récupérer les contextes depuis tous les adaptateurs disponibles
    for (final adapter in adapters) {
      try {
        if (await adapter.isAvailable()) {
          final context = await adapter.getGardenContext(gardenId);
          contexts[adapter] = context;

          if (context != null) {
            report.availableAdapters.add(adapter.adapterName);
          }
        }
      } catch (e) {
        report.errors[adapter.adapterName] = e.toString();
      }
    }

    // Comparer les contextes
    if (contexts.values.where((c) => c != null).length >= 2) {
      _compareContexts(contexts, report);
    }

    developer.log(
      '✅ Rapport de cohérence : ${report.inconsistencies.length} incohérences détectées',
      name: _logName,
      level: 500,
    );

    return report;
  }

  /// Compare les contextes et détecte les incohérences
  void _compareContexts(
    Map<DataAdapter, UnifiedGardenContext?> contexts,
    ConsistencyReport report,
  ) {
    final validContexts =
        contexts.entries.where((entry) => entry.value != null).toList();

    if (validContexts.length < 2) return;

    // Comparer les noms
    final names = validContexts.map((e) => e.value!.name).toSet();
    if (names.length > 1) {
      report.inconsistencies.add(Inconsistency(
        field: 'name',
        values: validContexts
            .map((e) => {
                  'adapter': e.key.adapterName,
                  'value': e.value!.name,
                })
            .toList(),
        severity: InconsistencySeverity.low,
      ));
    }

    // Comparer le nombre de plantes actives
    final activePlantCounts =
        validContexts.map((e) => e.value!.activePlants.length).toSet();
    if (activePlantCounts.length > 1) {
      report.inconsistencies.add(Inconsistency(
        field: 'activePlants.length',
        values: validContexts
            .map((e) => {
                  'adapter': e.key.adapterName,
                  'value': e.value!.activePlants.length,
                })
            .toList(),
        severity: InconsistencySeverity.medium,
      ));
    }

    // Comparer les surfaces totales
    final totalAreas = validContexts.map((e) => e.value!.totalArea).toSet();
    if (totalAreas.length > 1) {
      report.inconsistencies.add(Inconsistency(
        field: 'totalArea',
        values: validContexts
            .map((e) => {
                  'adapter': e.key.adapterName,
                  'value': e.value!.totalArea,
                })
            .toList(),
        severity: InconsistencySeverity.high,
      ));
    }
  }

  /// Résout les incohérences selon une stratégie
  Future<void> resolveInconsistencies({
    required ConsistencyReport report,
    required ResolutionStrategy strategy,
  }) async {
    developer.log(
      '🔧 Résolution de ${report.inconsistencies.length} incohérences avec stratégie: ${strategy.name}',
      name: _logName,
      level: 500,
    );

    for (final inconsistency in report.inconsistencies) {
      developer.log(
        '  - ${inconsistency.field}: ${inconsistency.severity.name}',
        name: _logName,
        level: 500,
      );
    }

    // TODO: Implémenter les stratégies de résolution
    // Pour l'instant, on log seulement
  }
}

/// Rapport de cohérence
class ConsistencyReport {
  final String gardenId;
  final DateTime timestamp = DateTime.now();
  final List<String> availableAdapters = [];
  final List<Inconsistency> inconsistencies = [];
  final Map<String, String> errors = {};

  ConsistencyReport({required this.gardenId});

  bool get isConsistent => inconsistencies.isEmpty;

  int get criticalCount => inconsistencies
      .where((i) => i.severity == InconsistencySeverity.critical)
      .length;

  int get highCount => inconsistencies
      .where((i) => i.severity == InconsistencySeverity.high)
      .length;

  int get mediumCount => inconsistencies
      .where((i) => i.severity == InconsistencySeverity.medium)
      .length;

  int get lowCount => inconsistencies
      .where((i) => i.severity == InconsistencySeverity.low)
      .length;

  Map<String, dynamic> toJson() => {
        'gardenId': gardenId,
        'timestamp': timestamp.toIso8601String(),
        'availableAdapters': availableAdapters,
        'isConsistent': isConsistent,
        'inconsistencies': inconsistencies.map((i) => i.toJson()).toList(),
        'errors': errors,
        'summary': {
          'total': inconsistencies.length,
          'critical': criticalCount,
          'high': highCount,
          'medium': mediumCount,
          'low': lowCount,
        },
      };
}

/// Incohérence détectée
class Inconsistency {
  final String field;
  final List<Map<String, dynamic>> values;
  final InconsistencySeverity severity;

  Inconsistency({
    required this.field,
    required this.values,
    required this.severity,
  });

  Map<String, dynamic> toJson() => {
        'field': field,
        'values': values,
        'severity': severity.name,
      };
}

/// Sévérité d'une incohérence
enum InconsistencySeverity {
  low,
  medium,
  high,
  critical,
}

/// Stratégie de résolution
enum ResolutionStrategy {
  preferModern, // Toujours préférer le système Moderne
  preferLegacy, // Toujours préférer le système Legacy
  preferIntelligence, // Toujours préférer le système Intelligence
  manual, // Résolution manuelle requise
  automatic, // Résolution automatique selon règles
}


