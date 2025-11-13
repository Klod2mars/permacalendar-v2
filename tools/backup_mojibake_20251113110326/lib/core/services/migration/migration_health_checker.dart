import 'dart:developer' as developer;
import '../../data/hive/garden_boxes.dart';
import '../../repositories/garden_hive_repository.dart';
import 'migration_models.dart';

/// Migration Health Checker - Vérificateur de Santé de Migration
///
/// **Architecture Enterprise - Design Pattern: Observer + Strategy**
///
/// Ce service monitore la santé globale du système pendant la migration :
/// - Vérification de santé Legacy et Moderne
/// - Détection des problèmes de performance
/// - Monitoring de la cohérence des données
/// - Alertes en cas de dégradation
///
/// **Critères de Santé :**
/// 1. **Disponibilité** : Systèmes accessibles et réactifs
/// 2. **Performance** : Temps de réponse acceptables
/// 3. **Cohérence** : Données cohérentes entre systèmes
/// 4. **Stabilité** : Pas d'erreurs critiques
///
/// **Standards :**
/// - Clean Architecture
/// - SOLID (Open/Closed)
/// - Observability (monitoring complet)
class MigrationHealthChecker {
  static const String _logName = 'MigrationHealthChecker';

  final GardenHiveRepository _modernRepository = GardenHiveRepository();

  // Seuils de santé
  static const Duration _maxResponseTime = Duration(milliseconds: 500);
  static const double _minAvailabilityRate = 0.95; // 95%
  static const double _minCoherenceRate = 0.90; // 90%

  // Statistiques
  int _healthChecksPerformed = 0;
  int _healthyChecks = 0;
  int _degradedChecks = 0;
  int _unhealthyChecks = 0;

  /// Constructeur
  MigrationHealthChecker() {
    _log('🏗️ Migration Health Checker créé', level: 500);
  }

  // ==================== VÉRIFICATION DE SANTÉ ====================

  /// Vérifie la santé globale du système
  Future<MigrationHealthReport> checkSystemHealth() async {
    try {
      _log('🏥 Vérification santé globale du système', level: 500);
      _healthChecksPerformed++;

      final startTime = DateTime.now();

      // Vérifier Legacy
      final legacyHealth = await _checkLegacySystemHealth();

      // Vérifier Moderne
      final modernHealth = await checkModernSystemHealth();

      // Vérifier cohérence
      final coherence = await _checkDataCoherence();

      // Calculer le taux d'erreur global
      final errorRate = await _calculateErrorRate();

      // Collecter les problèmes
      final issues = <String>[];
      if (legacyHealth != SystemHealth.healthy) {
        issues.add('Système Legacy dégradé ou non sain');
      }
      if (modernHealth != SystemHealth.healthy) {
        issues.add('Système Moderne dégradé ou non sain');
      }
      if (coherence < _minCoherenceRate) {
        issues.add('Cohérence des données insuffisante ($coherence%)');
      }
      if (errorRate > 0.05) {
        issues.add('Taux d\'erreur élevé ($errorRate%)');
      }

      // Déterminer l'état de santé global
      final isHealthy = legacyHealth == SystemHealth.healthy &&
          modernHealth == SystemHealth.healthy &&
          coherence >= _minCoherenceRate &&
          errorRate <= 0.05;

      if (isHealthy) {
        _healthyChecks++;
      } else if (issues.length <= 2) {
        _degradedChecks++;
      } else {
        _unhealthyChecks++;
      }

      final duration = DateTime.now().difference(startTime);

      _log(
        '📊 Santé système: ${isHealthy ? "✅ Sain" : "⚠️ Problèmes"} (${duration.inMilliseconds}ms)',
        level: isHealthy ? 500 : 900,
      );

      return MigrationHealthReport(
        isHealthy: isHealthy,
        timestamp: DateTime.now(),
        legacySystemHealth: legacyHealth,
        modernSystemHealth: modernHealth,
        dataCoherence: coherence,
        errorRate: errorRate,
        issues: issues,
        metrics: {
          'checkDuration': duration.inMilliseconds,
          'healthChecksTotal': _healthChecksPerformed,
          'healthyRate': _healthChecksPerformed > 0
              ? (_healthyChecks / _healthChecksPerformed) * 100
              : 0.0,
        },
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur vérification santé', e, stackTrace);
      _unhealthyChecks++;

      return MigrationHealthReport(
        isHealthy: false,
        timestamp: DateTime.now(),
        legacySystemHealth: SystemHealth.unknown,
        modernSystemHealth: SystemHealth.unknown,
        dataCoherence: 0.0,
        errorRate: 1.0,
        issues: ['Erreur critique : $e'],
      );
    }
  }

  /// Vérifie la santé du système Legacy
  Future<SystemHealth> _checkLegacySystemHealth() async {
    try {
      final startTime = DateTime.now();

      // Test de lecture
      GardenBoxes.getAllGardens();

      final duration = DateTime.now().difference(startTime);

      // Vérifier performance
      if (duration > _maxResponseTime) {
        _log('⚠️ Système Legacy lent (${duration.inMilliseconds}ms)',
            level: 900);
        return SystemHealth.degraded;
      }

      _log('✅ Système Legacy sain (${duration.inMilliseconds}ms)', level: 500);
      return SystemHealth.healthy;
    } catch (e) {
      _log('❌ Système Legacy non sain: $e', level: 1000);
      return SystemHealth.unhealthy;
    }
  }

  /// Vérifie la santé du système Moderne
  Future<SystemHealth> checkModernSystemHealth() async {
    try {
      final startTime = DateTime.now();

      // Test de lecture
      await _modernRepository.getAllGardens();

      final duration = DateTime.now().difference(startTime);

      // Vérifier performance
      if (duration > _maxResponseTime) {
        _log('⚠️ Système Moderne lent (${duration.inMilliseconds}ms)',
            level: 900);
        return SystemHealth.degraded;
      }

      _log('✅ Système Moderne sain (${duration.inMilliseconds}ms)', level: 500);
      return SystemHealth.healthy;
    } catch (e) {
      _log('❌ Système Moderne non sain: $e', level: 1000);
      return SystemHealth.unhealthy;
    }
  }

  /// Vérifie la cohérence des données entre Legacy et Moderne
  Future<double> _checkDataCoherence() async {
    try {
      // Compter les jardins dans chaque système
      final legacyCount = GardenBoxes.getAllGardens().length;
      final modernCount = (await _modernRepository.getAllGardens()).length;

      // Si les deux sont vides, cohérence parfaite
      if (legacyCount == 0 && modernCount == 0) {
        return 100.0;
      }

      // Si un seul système a des données, cohérence nulle
      if (legacyCount == 0 || modernCount == 0) {
        return 0.0;
      }

      // Calculer le pourcentage de cohérence
      final minCount = legacyCount < modernCount ? legacyCount : modernCount;
      final maxCount = legacyCount > modernCount ? legacyCount : modernCount;

      final coherence = (minCount / maxCount) * 100;

      _log('📊 Cohérence: ${coherence.toStringAsFixed(1)}%', level: 500);
      return coherence;
    } catch (e) {
      _log('❌ Erreur calcul cohérence: $e', level: 1000);
      return 0.0;
    }
  }

  /// Calcule le taux d'erreur global
  Future<double> _calculateErrorRate() async {
    // Pour l'instant, estimation simple basée sur les checks
    // Dans une vraie implémentation, on monitorerait les erreurs réelles

    final totalChecks = _healthChecksPerformed;
    if (totalChecks == 0) return 0.0;

    final errorChecks = _unhealthyChecks;
    return (errorChecks / totalChecks) * 100;
  }

  // ==================== RAPPORT COMPLET ====================

  /// Génère un rapport de santé complet
  Future<MigrationHealthReport> generateFullReport() async {
    try {
      _log('📋 Génération rapport santé complet', level: 500);

      final startTime = DateTime.now();

      // Vérifications détaillées
      final legacyHealth = await _checkLegacySystemHealth();
      final modernHealth = await checkModernSystemHealth();
      final coherence = await _checkDataCoherence();
      final errorRate = await _calculateErrorRate();

      // Performance checks
      final legacyPerf = await _measureLegacyPerformance();
      final modernPerf = await _measureModernPerformance();

      // Collecter les problèmes
      final issues = <String>[];

      if (legacyHealth == SystemHealth.unhealthy) {
        issues.add('Système Legacy non sain');
      } else if (legacyHealth == SystemHealth.degraded) {
        issues.add('Système Legacy dégradé');
      }

      if (modernHealth == SystemHealth.unhealthy) {
        issues.add('Système Moderne non sain');
      } else if (modernHealth == SystemHealth.degraded) {
        issues.add('Système Moderne dégradé');
      }

      if (coherence < _minCoherenceRate * 100) {
        issues.add('Cohérence insuffisante (${coherence.toStringAsFixed(1)}%)');
      }

      if (legacyPerf > _maxResponseTime.inMilliseconds) {
        issues.add('Performance Legacy dégradée (${legacyPerf}ms)');
      }

      if (modernPerf > _maxResponseTime.inMilliseconds) {
        issues.add('Performance Moderne dégradée (${modernPerf}ms)');
      }

      final isHealthy = issues.isEmpty;

      final duration = DateTime.now().difference(startTime);

      _log(
        '📊 Rapport complet: ${isHealthy ? "✅ Sain" : "⚠️ ${issues.length} problèmes"} (${duration.inMilliseconds}ms)',
        level: isHealthy ? 500 : 900,
      );

      return MigrationHealthReport(
        isHealthy: isHealthy,
        timestamp: DateTime.now(),
        legacySystemHealth: legacyHealth,
        modernSystemHealth: modernHealth,
        dataCoherence: coherence,
        errorRate: errorRate / 100, // Convertir en decimal
        issues: issues,
        metrics: {
          'reportDuration': duration.inMilliseconds,
          'legacyPerformance': legacyPerf,
          'modernPerformance': modernPerf,
          'healthChecksTotal': _healthChecksPerformed,
          'healthyChecks': _healthyChecks,
          'degradedChecks': _degradedChecks,
          'unhealthyChecks': _unhealthyChecks,
        },
      );
    } catch (e, stackTrace) {
      _logError('❌ Erreur génération rapport', e, stackTrace);

      return MigrationHealthReport(
        isHealthy: false,
        timestamp: DateTime.now(),
        legacySystemHealth: SystemHealth.unknown,
        modernSystemHealth: SystemHealth.unknown,
        dataCoherence: 0.0,
        errorRate: 1.0,
        issues: ['Erreur génération rapport: $e'],
      );
    }
  }

  // ==================== MESURE DE PERFORMANCE ====================

  Future<int> _measureLegacyPerformance() async {
    try {
      final startTime = DateTime.now();
      GardenBoxes.getAllGardens();
      return DateTime.now().difference(startTime).inMilliseconds;
    } catch (e) {
      return 999999; // Temps très élevé si erreur
    }
  }

  Future<int> _measureModernPerformance() async {
    try {
      final startTime = DateTime.now();
      await _modernRepository.getAllGardens();
      return DateTime.now().difference(startTime).inMilliseconds;
    } catch (e) {
      return 999999; // Temps très élevé si erreur
    }
  }

  // ==================== MONITORING CONTINU ====================

  /// Lance un monitoring continu pendant une période donnée
  ///
  /// **Paramètres :**
  /// - duration : Durée du monitoring
  /// - checkInterval : Intervalle entre chaque check
  /// - onHealthChange : Callback appelé si changement de santé
  Future<List<MigrationHealthReport>> continuousMonitoring({
    required Duration duration,
    Duration checkInterval = const Duration(minutes: 5),
    Function(MigrationHealthReport)? onHealthChange,
  }) async {
    _log(
      '🔄 Monitoring continu démarré (${duration.inHours}h, check chaque ${checkInterval.inMinutes}min)',
      level: 500,
    );

    final reports = <MigrationHealthReport>[];
    final endTime = DateTime.now().add(duration);
    MigrationHealthReport? previousReport;

    while (DateTime.now().isBefore(endTime)) {
      try {
        // Effectuer un check de santé
        final report = await checkSystemHealth();
        reports.add(report);

        // Détecter changement de santé
        if (previousReport != null &&
            report.isHealthy != previousReport.isHealthy) {
          _log(
            '⚠️ Changement de santé détecté: ${previousReport.isHealthy} → ${report.isHealthy}',
            level: 900,
          );

          if (onHealthChange != null) {
            onHealthChange(report);
          }
        }

        previousReport = report;

        // Attendre avant le prochain check
        await Future.delayed(checkInterval);
      } catch (e) {
        _log('❌ Erreur pendant monitoring: $e', level: 1000);
      }
    }

    _log('✅ Monitoring continu terminé - ${reports.length} rapports',
        level: 500);
    return reports;
  }

  // ==================== STATISTIQUES ====================

  Map<String, dynamic> getStatistics() {
    return {
      'healthChecksPerformed': _healthChecksPerformed,
      'healthyChecks': _healthyChecks,
      'degradedChecks': _degradedChecks,
      'unhealthyChecks': _unhealthyChecks,
      'healthyRate': _healthChecksPerformed > 0
          ? (_healthyChecks / _healthChecksPerformed) * 100
          : 0.0,
    };
  }

  void resetStatistics() {
    _healthChecksPerformed = 0;
    _healthyChecks = 0;
    _degradedChecks = 0;
    _unhealthyChecks = 0;
    _log('📊 Statistiques santé réinitialisées', level: 500);
  }

  // ==================== UTILITAIRES ====================

  void _log(String message, {int level = 500}) {
    developer.log(message, name: _logName, level: level);
    print('[$_logName] $message');
  }

  void _logError(String message, Object error, [StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _logName,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    print('[$_logName] ERROR: $message - $error');
  }

  // ==================== GETTERS ====================

  int get healthChecksPerformed => _healthChecksPerformed;
  double get healthyRate => _healthChecksPerformed > 0
      ? (_healthyChecks / _healthChecksPerformed) * 100
      : 0.0;
}

/// Exception de health check
class HealthCheckException implements Exception {
  final String message;
  const HealthCheckException(this.message);

  @override
  String toString() => 'HealthCheckException: $message';
}


