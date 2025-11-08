import 'package:riverpod/riverpod.dart';
import '../services/monitoring/alerting_service.dart';
import '../services/monitoring/health_check_service.dart';
import '../services/monitoring/metrics_collector_service.dart';
import '../services/monitoring/performance_monitoring_service.dart';
import 'network_module.dart';
import '../services/network_service.dart';

/// Module d'injection de dépendances pour les services de monitoring
///
/// Ce module centralise la configuration et l'injection des services de
/// monitoring pour l'observabilité de l'application.
///
/// **Architecture :**
/// ```
/// MonitoringModule
///   ├─→ HealthCheckService (santé système)
///   │    ├─→ NetworkService (vérification backend/réseau)
///   │    ├─→ Hive (vérification base de données)
///   │    └─→ MetricsCollectorService (métriques de santé)
///   │
///   ├─→ MetricsCollectorService (collecte de métriques)
///   │    └─→ Collecte de métriques business, performance, système
///   │
///   └─→ PerformanceMonitoringService (monitoring performance)
///        └─→ Mesure des temps d'exécution et performances
/// ```
///
/// **Usage de base :**
/// ```dart
/// // Dans un widget ou un provider
/// final healthCheck = ref.read(MonitoringModule.healthCheckServiceProvider);
/// await healthCheck.initialize();
///
/// // Vérifier la santé du système
/// final report = await healthCheck.checkAllComponents();
/// print('Status: ${report.overallStatus}');
/// print('Health: ${report.healthPercentage}%');
/// ```
///
/// **Intégration avec les autres services :**
/// Le HealthCheckService peut être configuré pour utiliser les autres
/// services de monitoring pour enrichir ses rapports :
/// ```dart
/// final healthCheck = ref.read(MonitoringModule.healthCheckServiceProvider);
/// final metricsCollector = ref.read(MonitoringModule.metricsCollectorServiceProvider);
/// final performanceMonitor = ref.read(MonitoringModule.performanceMonitoringServiceProvider);
///
/// // Les services peuvent être utilisés indépendamment ou ensemble
/// ```
class MonitoringModule {
  MonitoringModule._(); // Private constructor pour empêcher l'instanciation

  /// Provider pour le service de health check
  ///
  /// **Responsabilité :**
  /// - Vérification de la santé des composants système
  /// - Monitoring de la base de données (Hive)
  /// - Monitoring du réseau et backend
  /// - Monitoring de la mémoire et du cache
  /// - Génération de rapports de santé globaux
  ///
  /// **Méthodes disponibles :**
  /// - `initialize()` : Initialise le service et enregistre les health checks par défaut
  /// - `checkAllComponents()` : Vérifie tous les composants et retourne un rapport
  /// - `checkComponent(name)` : Vérifie un composant spécifique
  /// - `registerHealthCheck(name, check)` : Enregistre un health check personnalisé
  /// - `getLastResult(name)` : Récupère le dernier résultat pour un composant
  ///
  /// **Health checks par défaut :**
  /// - `hive_database` : Vérifie l'état de la base de données Hive
  /// - `memory` : Vérifie l'utilisation mémoire (simplifié)
  /// - `cache` : Vérifie l'état du cache
  /// - `network` : Vérifie la connectivité réseau (si NetworkService disponible)
  /// - `backend` : Vérifie la disponibilité du backend (si NetworkService disponible)
  ///
  /// **Exemple complet :**
  /// ```dart
  /// class MyService {
  ///   final HealthCheckService _healthCheck;
  ///
  ///   MyService(this._healthCheck);
  ///
  ///   Future<void> checkSystemHealth() async {
  ///     await _healthCheck.initialize();
  ///     final report = await _healthCheck.checkAllComponents();
  ///
  ///     if (report.overallStatus == HealthStatus.unhealthy) {
  ///       // Gérer le cas où le système est en panne
  ///       print('Système en panne: ${report.unhealthyCount} composants défaillants');
  ///     }
  ///   }
  /// }
  ///
  /// // Dans un provider
  /// final myServiceProvider = Provider<MyService>((ref) {
  ///   final healthCheck = ref.read(MonitoringModule.healthCheckServiceProvider);
  ///   return MyService(healthCheck);
  /// });
  /// ```
  static final healthCheckServiceProvider = Provider<HealthCheckService>((ref) {
    final networkService = ref.read(NetworkModule.networkServiceProvider);
    return HealthCheckService(
      checkTimeout: const Duration(seconds: 10),
      enableAutoChecks: false, // Désactivé par défaut, peut être activé si nécessaire
      autoCheckInterval: const Duration(minutes: 5),
      networkService: networkService, // Injection du NetworkService
    );
  });

  /// Provider pour le service de collecte de métriques
  ///
  /// **Responsabilité :**
  /// - Collecte de métriques business, performance, système, utilisateur, erreur
  /// - Agrégation de métriques sur des périodes
  /// - Génération de rapports de métriques
  /// - Gestion de surcharge (limitation automatique du buffer)
  /// - Persistance optionnelle dans Hive
  /// - Envoi réseau optionnel avec file tampon en cas d'échec
  ///
  /// **Méthodes disponibles :**
  /// - `initialize()` : Initialise le service (async, doit être appelé après création)
  /// - `recordMetric(...)` : Enregistre une métrique
  /// - `incrementCounter(...)` : Incrémente un compteur
  /// - `recordGauge(...)` : Enregistre une valeur de gauge
  /// - `recordHistogram(...)` : Enregistre une valeur d'histogramme
  /// - `recordTimer(...)` : Enregistre une durée
  /// - `recordError(...)` : Enregistre une erreur
  /// - `generateReport(...)` : Génère un rapport de métriques
  /// - `flush()` : Vide le buffer et envoie les métriques (async)
  /// - `getStatistics()` : Récupère les statistiques du service
  /// - `purgeFailedUploads()` : Purge la file d'échecs réseau
  ///
  /// **Sécurisation :**
  /// Toutes les méthodes sont encapsulées dans des try/catch pour éviter
  /// que les erreurs ne fassent crasher l'application. Le service continue
  /// de fonctionner même en cas d'échec de persistance ou d'envoi réseau.
  ///
  /// **Exemple d'utilisation :**
  /// ```dart
  /// final metricsCollector = ref.read(MonitoringModule.metricsCollectorServiceProvider);
  /// await metricsCollector.initialize();
  ///
  /// // Enregistrer des métriques
  /// metricsCollector.incrementCounter('plantations');
  /// metricsCollector.recordGauge('health_score', 0.85);
  /// metricsCollector.recordTimer('query_time', duration);
  ///
  /// // Générer un rapport
  /// final report = metricsCollector.generateReport();
  /// print('Total metrics: ${report.metrics.length}');
  ///
  /// // Obtenir les statistiques
  /// final stats = metricsCollector.getStatistics();
  /// print('Total collected: ${stats['totalMetricsCollected']}');
  /// ```
  static final metricsCollectorServiceProvider =
      Provider<MetricsCollectorService>((ref) {
    return MetricsCollectorService(
      maxBufferSize: 10000,
      maxTotalBufferSize: 50000,
      flushInterval: const Duration(minutes: 1),
      enableAutoFlush: true,
      enablePersistence: false, // Désactivé par défaut, peut être activé si nécessaire
      enableNetworkUpload: false, // Désactivé par défaut, nécessite NetworkService
      maxFailedUploadsQueueSize: 100,
    );
  });

  /// Provider pour le service de monitoring de performance
  ///
  /// **Responsabilité :**
  /// - Mesure des temps d'exécution (startup, écrans, opérations)
  /// - Détection des opérations lentes avec seuils configurables
  /// - Génération de rapports de performance périodiques
  /// - Suivi de l'utilisation mémoire (optionnel)
  /// - Collecte de métriques système (uptime, charges d'écran, etc.)
  ///
  /// **Méthodes principales :**
  /// - `initialize()` : Initialise le service (doit être appelé après création)
  /// - `recordAppStartup()` : Enregistre le temps de démarrage de l'application
  /// - `recordScreenLoad(screenName, loadTime)` : Enregistre le temps de chargement d'un écran
  /// - `recordOperationDuration(...)` : Enregistre la durée d'une opération
  /// - `recordMemoryUsage(memoryBytes)` : Enregistre l'utilisation mémoire
  /// - `startMeasurement(...)` / `endMeasurement(id)` : Mesure manuelle start/end
  /// - `measureAsync(...)` : Mesure une opération asynchrone (wrapper)
  /// - `measureSync(...)` : Mesure une opération synchrone (wrapper)
  /// - `generateReport(period)` : Génère un rapport de performance
  /// - `getCurrentMetrics()` : Récupère les métriques actuelles
  /// - `clearOldMeasurements(olderThan)` : Nettoie les mesures anciennes
  /// - `resetMeasurements()` : Réinitialise toutes les mesures
  /// - `dispose()` : Libère les ressources
  ///
  /// **Sécurisation :**
  /// Toutes les méthodes sont encapsulées dans des try/catch pour éviter
  /// que les erreurs ne fassent crasher l'application. Le service continue
  /// de fonctionner même en cas d'erreur lors de la collecte ou de la génération
  /// de rapports.
  ///
  /// **Gestion de surcharge :**
  /// Le service limite automatiquement le nombre de mesures stockées (maxMeasurements)
  /// pour éviter la surcharge mémoire. Un rate limiting est également appliqué
  /// pour éviter une collecte excessive.
  ///
  /// **Intégration avec les autres services :**
  /// - **MetricsCollectorService** : Peut être intégré pour stocker les métriques
  ///   à long terme (intégration optionnelle, commentée dans le code)
  /// - **HealthCheckService** : Les métriques de performance peuvent être utilisées
  ///   pour évaluer la santé globale du système
  ///
  /// **Exemple d'utilisation :**
  /// ```dart
  /// final performanceMonitor = ref.read(MonitoringModule.performanceMonitoringServiceProvider);
  /// await performanceMonitor.initialize();
  ///
  /// // Enregistrer le démarrage de l'application
  /// performanceMonitor.recordAppStartup();
  ///
  /// // Mesurer une opération asynchrone
  /// final result = await performanceMonitor.measureAsync<String>(
  ///   type: MetricType.dataFetch,
  ///   name: 'fetch_plants',
  ///   operation: () async {
  ///     return await repository.fetchPlants();
  ///   },
  /// );
  ///
  /// // Enregistrer le chargement d'un écran
  /// performanceMonitor.recordScreenLoad('PlantListScreen', loadDuration);
  ///
  /// // Générer un rapport
  /// final report = performanceMonitor.generateReport(period: Duration(hours: 1));
  /// print('Slow operations: ${report.slowOperations.length}');
  ///
  /// // Obtenir les métriques actuelles
  /// final metrics = performanceMonitor.getCurrentMetrics();
  /// print('Total measurements: ${metrics['totalMeasurements']}');
  /// ```
  ///
  /// **Types de métriques disponibles :**
  /// - `appStartup` : Temps de démarrage de l'application (seuil: 2s)
  /// - `screenLoad` : Temps de chargement des écrans (seuil: 500ms)
  /// - `dataFetch` : Temps de récupération de données (seuil: 200ms)
  /// - `dataWrite` : Temps d'écriture de données (seuil: 100ms)
  /// - `cacheHit` : Temps d'accès au cache (hit) (seuil: 10ms)
  /// - `cacheMiss` : Temps d'accès au cache (miss) (seuil: 100ms)
  /// - `queryExecution` : Temps d'exécution de requêtes (seuil: 50ms)
  /// - `apiCall` : Temps d'appels API (seuil: 3s)
  /// - `computation` : Temps de calculs (seuil: 100ms)
  /// - `rendering` : Temps de rendu (seuil: 16ms pour 60 FPS)
  static final performanceMonitoringServiceProvider =
      Provider<PerformanceMonitoringService>((ref) {
    return PerformanceMonitoringService(
      maxMeasurements: 1000,
      enableLogging: true,
      reportInterval: const Duration(minutes: 5),
    );
  });

  /// Provider pour le service d'alertes
  ///
  /// **Responsabilité :**
  /// - Gestion intelligente des alertes système avec règles configurables
  /// - Évaluation de règles d'alerte basées sur des seuils et conditions
  /// - Déclenchement d'alertes avec 4 niveaux de sévérité (info, warning, error, critical)
  /// - Gestion de cooldown et debounce pour éviter le spam
  /// - Acknowledgment tracking pour suivre les alertes traitées
  /// - Stream d'alertes en temps réel pour notifications
  /// - Nettoyage automatique des alertes anciennes
  /// - Statistiques complètes sur les alertes
  ///
  /// **Méthodes principales :**
  /// - `initialize()` : Initialise le service et enregistre les règles par défaut
  /// - `registerRule(rule)` : Enregistre une règle d'alerte personnalisée
  /// - `unregisterRule(ruleId)` : Supprime une règle d'alerte
  /// - `triggerAlert(...)` : Déclenche une alerte manuellement
  /// - `evaluateRules(data, source)` : Évalue les règles contre des données
  /// - `acknowledgeAlert(alertId)` : Marque une alerte comme traitée
  /// - `acknowledgeAll()` : Marque toutes les alertes comme traitées
  /// - `getActiveAlerts(...)` : Récupère les alertes actives (avec filtres)
  /// - `getCriticalAlerts()` : Récupère uniquement les alertes critiques
  /// - `getUnacknowledgedCount()` : Compte les alertes non traitées
  /// - `getStatistics()` : Récupère les statistiques du service
  /// - `alertStream` : Stream d'alertes en temps réel
  /// - `dispose()` : Libère les ressources
  ///
  /// **Règles par défaut :**
  /// - `high_error_rate` : Alerte si taux d'erreur > 5% (cooldown: 5 min)
  /// - `slow_performance` : Alerte si temps de réponse moyen > 1s (cooldown: 5 min)
  /// - `low_health_score` : Alerte si santé système < 50% (cooldown: 10 min)
  ///
  /// **Sécurisation :**
  /// Toutes les méthodes sont encapsulées dans des try/catch pour éviter
  /// que les erreurs ne fassent crasher l'application. Le service continue
  /// de fonctionner même en cas d'erreur lors de l'évaluation de règles ou du
  /// déclenchement d'alertes.
  ///
  /// **Gestion du spam :**
  /// Le service utilise un système de cooldown au niveau des règles et un
  /// debounce au niveau des alertes pour éviter le spam. Par défaut, une
  /// alerte identique ne peut être déclenchée qu'une fois toutes les 30 secondes.
  ///
  /// **Intégration avec les autres services :**
  /// - **HealthCheckService** : Peut être utilisé pour déclencher des alertes
  ///   basées sur les résultats des health checks
  /// - **MetricsCollectorService** : Les métriques collectées peuvent être
  ///   évaluées via `evaluateRules()` pour déclencher des alertes
  /// - **PerformanceMonitoringService** : Les métriques de performance peuvent
  ///   être évaluées pour déclencher des alertes
  ///
  /// **Exemple d'utilisation :**
  /// ```dart
  /// final alertingService = ref.read(MonitoringModule.alertingServiceProvider);
  /// await alertingService.initialize();
  ///
  /// // Écouter les alertes en temps réel
  /// alertingService.alertStream.listen((alert) {
  ///   print('New alert: ${alert.title} - ${alert.message}');
  ///   if (alert.severity == AlertSeverity.critical) {
  ///     // Gérer l'alerte critique
  ///   }
  /// });
  ///
  /// // Évaluer les règles avec des données de métriques
  /// alertingService.evaluateRules({
  ///   'errorRate': 0.08, // 8% d'erreur
  ///   'avgResponseTime': 1200, // 1.2s
  ///   'healthScore': 0.4, // 40%
  /// }, source: 'MetricsCollectorService');
  ///
  /// // Déclencher une alerte manuellement
  /// alertingService.triggerAlert(
  ///   title: 'Custom Alert',
  ///   message: 'Something went wrong',
  ///   severity: AlertSeverity.warning,
  ///   type: AlertType.system,
  ///   source: 'MyService',
  /// );
  ///
  /// // Récupérer les alertes actives
  /// final criticalAlerts = alertingService.getCriticalAlerts();
  /// final unacknowledgedCount = alertingService.getUnacknowledgedCount();
  ///
  /// // Marquer une alerte comme traitée
  /// if (criticalAlerts.isNotEmpty) {
  ///   alertingService.acknowledgeAlert(
  ///     criticalAlerts.first.id,
  ///     acknowledgedBy: 'user_123',
  ///   );
  /// }
  ///
  /// // Obtenir les statistiques
  /// final stats = alertingService.getStatistics();
  /// print('Total alerts: ${stats['totalAlerts']}');
  /// print('Active alerts: ${stats['activeAlerts']}');
  /// ```
  ///
  /// **Extension avec règles personnalisées :**
  /// ```dart
  /// final alertingService = ref.read(MonitoringModule.alertingServiceProvider);
  /// await alertingService.initialize();
  ///
  /// // Ajouter une règle personnalisée
  /// alertingService.registerRule(AlertRule(
  ///   id: 'high_memory_usage',
  ///   name: 'High Memory Usage',
  ///   severity: AlertSeverity.warning,
  ///   type: AlertType.system,
  ///   condition: (data) {
  ///     final memoryUsage = data['memoryUsage'] as double? ?? 0.0;
  ///     return memoryUsage > 0.9; // 90% d'utilisation mémoire
  ///   },
  ///   messageGenerator: (data) {
  ///     final memoryUsage = ((data['memoryUsage'] as double) * 100).toStringAsFixed(1);
  ///     return 'Memory usage is high: $memoryUsage%';
  ///   },
  ///   cooldown: const Duration(minutes: 5),
  /// ));
  ///
  /// // Évaluer avec des données de mémoire
  /// alertingService.evaluateRules({
  ///   'memoryUsage': 0.95, // 95% d'utilisation
  /// }, source: 'MemoryMonitor');
  /// ```
  static final alertingServiceProvider = Provider<AlertingService>((ref) {
    return AlertingService(
      maxActiveAlerts: 1000,
      alertRetention: const Duration(days: 7),
    );
  });
}

