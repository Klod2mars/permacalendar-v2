import 'dart:developer' as developer;
import 'package:permacalendar/core/services/garden_event_observer_service.dart';
import 'package:permacalendar/core/services/garden_data_aggregation_service.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';

/// Validateur du système d'événements jardin
///
/// Classe utilitaire pour vérifier que le hub d'événements
/// pour l'Intelligence Végétale fonctionne correctement.
///
/// **Usage :**
/// ```dart
/// final validator = GardenEventSystemValidator();
/// final report = await validator.validate();
/// print(report.toDetailedString());
/// ```
class GardenEventSystemValidator {
  static const String _logName = 'EventSystemValidator';

  /// Valide le système complet
  Future<ValidationReport> validate() async {
    developer.log('🔍 Début de la validation du système d\'événements',
        name: _logName);

    final checks = <ValidationCheck>[];

    // Check 1 : Initialisation du service d'observation
    checks.add(await _checkObserverInitialization());

    // Check 2 : Service d'agrégation disponible
    checks.add(_checkAggregationService());

    // Check 3 : Accès aux données Hive
    checks.add(await _checkHiveAccess());

    // Check 4 : Statistiques des événements
    checks.add(_checkEventStatistics());

    // Check 5 : Test de création de GardenContext
    checks.add(await _checkGardenContextCreation());

    // Calculer le résultat global
    final passedChecks = checks.where((c) => c.passed).length;
    final totalChecks = checks.length;
    final allPassed = passedChecks == totalChecks;

    final report = ValidationReport(
      checks: checks,
      passedCount: passedChecks,
      totalCount: totalChecks,
      allPassed: allPassed,
      timestamp: DateTime.now(),
    );

    developer.log(
      allPassed
          ? '✅ Validation réussie : $passedChecks/$totalChecks checks passés'
          : '⚠️ Validation partielle : $passedChecks/$totalChecks checks passés',
      name: _logName,
      level: allPassed ? 500 : 900,
    );

    return report;
  }

  /// Check 1 : Vérifier l'initialisation du service d'observation
  Future<ValidationCheck> _checkObserverInitialization() async {
    try {
      final isInitialized = GardenEventObserverService.instance.isInitialized;

      return ValidationCheck(
        name: 'Service d\'observation initialisé',
        passed: isInitialized,
        message: isInitialized
            ? 'GardenEventObserverService est initialisé'
            : 'GardenEventObserverService n\'est PAS initialisé - vérifier app_initializer.dart',
        severity: isInitialized
            ? ValidationSeverity.success
            : ValidationSeverity.critical,
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Service d\'observation initialisé',
        passed: false,
        message: 'Erreur lors de la vérification: $e',
        severity: ValidationSeverity.error,
      );
    }
  }

  /// Check 2 : Vérifier le service d'agrégation
  ValidationCheck _checkAggregationService() {
    try {
      final service = GardenDataAggregationService();

      return const ValidationCheck(
        name: 'Service d\'agrégation disponible',
        passed: true,
        message: 'GardenDataAggregationService instancié avec succès',
        severity: ValidationSeverity.success,
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Service d\'agrégation disponible',
        passed: false,
        message: 'Erreur lors de l\'instanciation: $e',
        severity: ValidationSeverity.critical,
      );
    }
  }

  /// Check 3 : Vérifier l'accès aux données Hive
  Future<ValidationCheck> _checkHiveAccess() async {
    try {
      // Tenter d'accéder aux boxes
      final gardensBox = GardenBoxes.gardens;
      final bedsBox = GardenBoxes.gardenBeds;
      final plantingsBox = GardenBoxes.plantings;

      final hasGardens = gardensBox.isNotEmpty;
      final hasBeds = bedsBox.isNotEmpty;
      final hasPlantings = plantingsBox.isNotEmpty;

      return ValidationCheck(
        name: 'Accès aux données Hive',
        passed: true,
        message: 'Boxes Hive accessibles : '
            '${gardensBox.length} jardins, '
            '${bedsBox.length} parcelles, '
            '${plantingsBox.length} plantations',
        severity: ValidationSeverity.success,
        metadata: {
          'gardensCount': gardensBox.length,
          'bedsCount': bedsBox.length,
          'plantingsCount': plantingsBox.length,
          'hasData': hasGardens || hasBeds || hasPlantings,
        },
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Accès aux données Hive',
        passed: false,
        message: 'Erreur d\'accès aux boxes Hive: $e',
        severity: ValidationSeverity.critical,
      );
    }
  }

  /// Check 4 : Vérifier les statistiques des événements
  ValidationCheck _checkEventStatistics() {
    try {
      final stats = GardenEventObserverService.instance.getStats();

      final hasEvents = stats.totalEventsCount > 0;

      return ValidationCheck(
        name: 'Statistiques des événements',
        passed: true,
        message: hasEvents
            ? 'Événements détectés : ${stats.totalEventsCount} total '
                '(${stats.contextEventsCount} contextes, '
                '${stats.plantingEventsCount} plantations, '
                '${stats.activityEventsCount} activités)'
            : 'Aucun événement enregistré pour l\'instant (normal si première exécution)',
        severity:
            hasEvents ? ValidationSeverity.success : ValidationSeverity.info,
        metadata: {
          'totalEvents': stats.totalEventsCount,
          'successRate': stats.successRate,
          'errors': stats.analysisErrorCount,
        },
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Statistiques des événements',
        passed: false,
        message: 'Erreur lors de la récupération des stats: $e',
        severity: ValidationSeverity.error,
      );
    }
  }

  /// Check 5 : Test de création de GardenContext
  Future<ValidationCheck> _checkGardenContextCreation() async {
    try {
      final aggregationService = GardenDataAggregationService();

      // Récupérer le premier jardin disponible
      final gardens = GardenBoxes.gardens.values.toList();

      if (gardens.isEmpty) {
        return const ValidationCheck(
          name: 'Test création GardenContext',
          passed: true,
          message:
              'Aucun jardin existant pour tester (créez-en un pour validation complète)',
          severity: ValidationSeverity.info,
        );
      }

      final testGarden = gardens.first;

      // Tenter de créer un GardenContext
      final context = aggregationService.createGardenContext(testGarden);

      return ValidationCheck(
        name: 'Test création GardenContext',
        passed: true,
        message: 'GardenContext créé avec succès pour "${context.name}" : '
            '${context.activePlantIds.length} plantes actives, '
            '${context.stats.totalArea.toStringAsFixed(1)}m²',
        severity: ValidationSeverity.success,
        metadata: {
          'gardenId': context.gardenId,
          'gardenName': context.name,
          'activePlants': context.activePlantIds.length,
          'totalArea': context.stats.totalArea,
          'soilType': context.soil.type.toString(),
        },
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Test création GardenContext',
        passed: false,
        message: 'Erreur lors de la création du GardenContext: $e',
        severity: ValidationSeverity.error,
      );
    }
  }
}

/// Rapport de validation
class ValidationReport {
  final List<ValidationCheck> checks;
  final int passedCount;
  final int totalCount;
  final bool allPassed;
  final DateTime timestamp;

  const ValidationReport({
    required this.checks,
    required this.passedCount,
    required this.totalCount,
    required this.allPassed,
    required this.timestamp,
  });

  /// Retourne un résumé simple
  String toSimpleString() {
    return allPassed
        ? '✅ Validation réussie : $passedCount/$totalCount'
        : '⚠️ Validation partielle : $passedCount/$totalCount';
  }

  /// Retourne un rapport détaillé
  String toDetailedString() {
    final buffer = StringBuffer();
    buffer.writeln('📊 Rapport de Validation du Système d\'Événements');
    buffer.writeln('Timestamp: ${timestamp.toIso8601String()}');
    buffer.writeln('Résultat global: ${toSimpleString()}');
    buffer.writeln('');

    for (int i = 0; i < checks.length; i++) {
      final check = checks[i];
      buffer.writeln('${i + 1}. ${check.toString()}');
    }

    buffer.writeln('');
    buffer.writeln('Statistiques:');
    buffer.writeln('  - Checks passés: $passedCount');
    buffer.writeln('  - Checks échoués: ${totalCount - passedCount}');
    buffer.writeln(
        '  - Taux de réussite: ${(passedCount / totalCount * 100).toStringAsFixed(1)}%');

    return buffer.toString();
  }
}

/// Check de validation individuel
class ValidationCheck {
  final String name;
  final bool passed;
  final String message;
  final ValidationSeverity severity;
  final Map<String, dynamic>? metadata;

  const ValidationCheck({
    required this.name,
    required this.passed,
    required this.message,
    required this.severity,
    this.metadata,
  });

  @override
  String toString() {
    final icon =
        passed ? '✅' : (severity == ValidationSeverity.critical ? '❌' : '⚠️');
    return '$icon $name: $message';
  }
}

/// Sévérité d'un check
enum ValidationSeverity {
  success, // ✅ Tout va bien
  info, // ℹ️ Information
  warning, // ⚠️ Attention mais non bloquant
  error, // ❌ Erreur
  critical, // 🔴 Erreur critique
}


