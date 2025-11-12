import 'dart:developer' as developer;
import 'dart:async';
import 'package:permacalendar/features/plant_intelligence/domain/services/plant_intelligence_orchestrator.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/notification_alert.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/core/events/garden_event_bus.dart';
import 'package:permacalendar/core/events/garden_events.dart';

/// Service d'observation des événements du jardin
///
/// **REFACTORÉ - Prompt 6 : Event Bus**
///
/// **Architecture :**
/// - Écoute le GardenEventBus pour les événements du jardin
/// - Déclenche des analyses via PlantIntelligenceOrchestrator
/// - Pattern Observer pour respecter la Clean Architecture
/// - Communication asynchrone via EventBus
///
/// **Responsabilités :**
/// - S'abonner au GardenEventBus
/// - Réagir aux événements pertinents (plantation, météo, activités)
/// - Déclencher des analyses automatiques
/// - Maintenir des statistiques
///
/// **Utilisation :**
/// ```dart
/// // Initialiser avec l'orchestrateur
/// GardenEventObserverService.instance.initialize(
///   orchestrator: plantIntelligenceOrchestrator,
/// );
///
/// // Les événements sont émis via GardenEventBus
/// GardenEventBus().emit(
///   GardenEvent.plantingAdded(
///     gardenId: 'garden_1',
///     plantingId: 'planting_1',
///     plantId: 'tomato',
///     timestamp: DateTime.now(),
///   ),
/// );
/// ```
class GardenEventObserverService {
  static const String _logName = 'GardenEventObserver';

  /// Singleton instance
  static final GardenEventObserverService _instance =
      GardenEventObserverService._internal();
  static GardenEventObserverService get instance => _instance;

  /// Factory constructor pour accès au singleton
  factory GardenEventObserverService() {
    return _instance;
  }

  /// Constructeur privé
  GardenEventObserverService._internal();

  // Services injectés
  PlantIntelligenceOrchestrator? _orchestrator;
  StreamSubscription<GardenEvent>? _eventSubscription;

  // Statistiques d'événements
  int _plantingEventsCount = 0;
  int _weatherEventsCount = 0;
  int _activityEventsCount = 0;
  int _harvestEventsCount = 0;
  int _contextEventsCount = 0;
  int _analysisTriggeredCount = 0;
  int _analysisErrorCount = 0;

  /// Initialise le service avec l'orchestrateur
  ///
  /// S'abonne au GardenEventBus et commence à écouter les événements.
  ///
  /// **Appelé depuis `app_initializer.dart` après la création de l'orchestrateur**
  void initialize({
    required PlantIntelligenceOrchestrator orchestrator,
  }) {
    _orchestrator = orchestrator;

    // S'abonner aux événements du bus
    _eventSubscription = GardenEventBus().events.listen(_handleEvent);

    developer.log(
      '✅ GardenEventObserverService initialisé et écoute les événements',
      name: _logName,
      level: 500,
    );
  }

  /// Vérifie si le service est correctement initialisé
  bool get isInitialized => _orchestrator != null && _eventSubscription != null;

  // ==================== GESTION DES ÉVÉNEMENTS ====================

  /// Gère un événement reçu du GardenEventBus
  ///
  /// Méthode privée appelée automatiquement pour chaque événement.
  Future<void> _handleEvent(GardenEvent event) async {
    developer.log(
      '📥 Événement reçu: ${event.runtimeType}',
      name: _logName,
      level: 500,
    );

    if (!isInitialized) {
      developer.log(
        '⚠️ Service non initialisé, événement ignoré',
        name: _logName,
        level: 800,
      );
      return;
    }

    try {
      // Utiliser le pattern when() de Freezed pour gérer les différents types d'événements
      await event.when(
        plantingAdded: _handlePlantingAdded,
        plantingHarvested: _handlePlantingHarvested,
        weatherChanged: _handleWeatherChanged,
        activityPerformed: _handleActivityPerformed,
        gardenContextUpdated: _handleGardenContextUpdated,
      );
    } catch (e, stackTrace) {
      _analysisErrorCount++;
      developer.log(
        'Erreur lors du traitement de l\'événement',
        name: _logName,
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ==================== HANDLERS D'ÉVÉNEMENTS ====================

  /// Gère l'événement : Plantation ajoutée
  Future<void> _handlePlantingAdded(
    String gardenId,
    String plantingId,
    String plantId,
    DateTime timestamp,
    Map<String, dynamic>? metadata,
  ) async {
    _plantingEventsCount++;

    developer.log(
      '🌱 Nouvelle plantation détectée: plantId=$plantId, gardenId=$gardenId',
      name: _logName,
      level: 500,
    );

    try {
      // Déclencher une analyse complète pour cette nouvelle plante
      developer.log(
        '🔍 Déclenchement analyse Intelligence Végétale...',
        name: _logName,
        level: 500,
      );

      final report = await _orchestrator!.generateIntelligenceReport(
        plantId: plantId,
        gardenId: gardenId,
      );

      _analysisTriggeredCount++;

      // Vérifier si actions urgentes (analyse critique ou alertes critiques)
      final hasUrgentAction =
          (report.analysis.overallHealth == ConditionStatus.critical ||
                  report.analysis.overallHealth == ConditionStatus.poor) ||
              report.activeAlerts
                  .any((a) => a.priority == NotificationPriority.critical);

      developer.log(
        '✅ Analyse terminée - Score: ${report.intelligenceScore.toStringAsFixed(1)}/100, '
        'Recommandations: ${report.recommendations.length}, '
        'Actions urgentes: ${hasUrgentAction ? "OUI" : "NON"}',
        name: _logName,
        level: 500,
      );
    } catch (e) {
      _analysisErrorCount++;
      developer.log(
        'Erreur lors de l\'analyse de la plantation $plantId: $e',
        name: _logName,
        level: 1000,
        error: e,
      );
    }
  }

  /// Gère l'événement : Plantation récoltée
  Future<void> _handlePlantingHarvested(
    String gardenId,
    String plantingId,
    double harvestYield,
    DateTime timestamp,
    Map<String, dynamic>? metadata,
  ) async {
    _harvestEventsCount++;

    developer.log(
      '🌾 Récolte enregistrée: plantingId=$plantingId, rendement=${harvestYield}kg',
      name: _logName,
      level: 500,
    );

    // Pas d'analyse nécessaire pour une récolte
    // Les statistiques sont déjà enregistrées ailleurs
  }

  /// Gère l'événement : Changement météorologique
  Future<void> _handleWeatherChanged(
    String gardenId,
    double previousTemperature,
    double currentTemperature,
    DateTime timestamp,
    Map<String, dynamic>? metadata,
  ) async {
    _weatherEventsCount++;

    final tempDiff = (currentTemperature - previousTemperature).abs();

    developer.log(
      '🌡️ Changement météo: ${previousTemperature.toStringAsFixed(1)}°C → '
      '${currentTemperature.toStringAsFixed(1)}°C (Δ ${tempDiff.toStringAsFixed(1)}°C)',
      name: _logName,
      level: 500,
    );

    // Si changement significatif (> 5°C), analyser toutes les plantes du jardin
    if (tempDiff > 5.0) {
      developer.log(
        '⚠️ Changement météo significatif (> 5°C) - Analyse de toutes les plantes du jardin',
        name: _logName,
        level: 700,
      );

      try {
        final reports = await _orchestrator!.generateGardenIntelligenceReport(
          gardenId: gardenId,
        );

        _analysisTriggeredCount += reports.length;

        // Compter les plantes nécessitant une action urgente
        final urgentCount = reports.where((r) {
          return (r.analysis.overallHealth == ConditionStatus.critical ||
                  r.analysis.overallHealth == ConditionStatus.poor) ||
              r.activeAlerts
                  .any((a) => a.priority == NotificationPriority.critical);
        }).length;

        developer.log(
          '✅ Analyses terminées: ${reports.length} plantes, '
          '$urgentCount nécessitent une action urgente',
          name: _logName,
          level: urgentCount > 0 ? 900 : 500,
        );
      } catch (e) {
        _analysisErrorCount++;
        developer.log(
          'Erreur lors de l\'analyse du jardin après changement météo: $e',
          name: _logName,
          level: 1000,
          error: e,
        );
      }
    }
  }

  /// Gère l'événement : Activité utilisateur effectuée
  Future<void> _handleActivityPerformed(
    String gardenId,
    String activityType,
    String? targetId,
    DateTime timestamp,
    Map<String, dynamic>? metadata,
  ) async {
    _activityEventsCount++;

    developer.log(
      '👤 Activité effectuée: type=$activityType, target=$targetId',
      name: _logName,
      level: 500,
    );

    // Certaines activités déclenchent une analyse
    final analysisTriggered =
        ['watering', 'fertilizing', 'pruning'].contains(activityType);

    if (analysisTriggered && targetId != null) {
      developer.log(
        '🔍 Activité "$activityType" détectée - Analyse de mise à jour',
        name: _logName,
        level: 500,
      );

      // Note: targetId pourrait être un plantingId
      // TODO: Implémenter la résolution plantingId → plantId si nécessaire

      // Pour l'instant, on log simplement
      developer.log(
        'ℹ️ Analyse post-activité non implémentée (nécessite résolution plantingId → plantId)',
        name: _logName,
        level: 600,
      );
    }
  }

  /// Gère l'événement : Contexte jardin mis à jour
  Future<void> _handleGardenContextUpdated(
    String gardenId,
    DateTime timestamp,
    Map<String, dynamic>? metadata,
  ) async {
    _contextEventsCount++;

    developer.log(
      '🔄 Contexte jardin mis à jour: gardenId=$gardenId',
      name: _logName,
      level: 500,
    );

    // Le contexte est déjà mis à jour par le repository
    // Pas d'action supplémentaire nécessaire ici
  }

  // ==================== NETTOYAGE ====================

  /// Nettoie les ressources (annule l'abonnement au bus)
  void dispose() {
    developer.log(
      '🔒 Fermeture du GardenEventObserverService',
      name: _logName,
      level: 500,
    );

    _eventSubscription?.cancel();
    _eventSubscription = null;
    _orchestrator = null;
  }

  // ==================== STATISTIQUES ====================

  /// Obtient les statistiques d'événements
  EventObserverStats getStats() {
    final totalEvents = _plantingEventsCount +
        _weatherEventsCount +
        _activityEventsCount +
        _harvestEventsCount +
        _contextEventsCount;

    return EventObserverStats(
      plantingEventsCount: _plantingEventsCount,
      weatherEventsCount: _weatherEventsCount,
      activityEventsCount: _activityEventsCount,
      harvestEventsCount: _harvestEventsCount,
      contextEventsCount: _contextEventsCount,
      totalEventsCount: totalEvents,
      analysisTriggeredCount: _analysisTriggeredCount,
      analysisErrorCount: _analysisErrorCount,
      successRate: totalEvents > 0
          ? ((_analysisTriggeredCount - _analysisErrorCount) /
              _analysisTriggeredCount *
              100)
          : 0.0,
    );
  }

  /// Réinitialise les statistiques
  void resetStats() {
    developer.log('🔄 Réinitialisation des statistiques',
        name: _logName, level: 500);
    _plantingEventsCount = 0;
    _weatherEventsCount = 0;
    _activityEventsCount = 0;
    _harvestEventsCount = 0;
    _contextEventsCount = 0;
    _analysisTriggeredCount = 0;
    _analysisErrorCount = 0;
  }

  /// Affiche un rapport des statistiques dans les logs
  void logStats() {
    final stats = getStats();
    developer.log(
      '📊 Statistiques GardenEventObserver:\n'
      '  - Plantations: ${stats.plantingEventsCount}\n'
      '  - Météo: ${stats.weatherEventsCount}\n'
      '  - Activités: ${stats.activityEventsCount}\n'
      '  - Récoltes: ${stats.harvestEventsCount}\n'
      '  - Contexte: ${stats.contextEventsCount}\n'
      '  - Total événements: ${stats.totalEventsCount}\n'
      '  - Analyses déclenchées: ${stats.analysisTriggeredCount}\n'
      '  - Erreurs: ${stats.analysisErrorCount}\n'
      '  - Taux de succès: ${stats.successRate.toStringAsFixed(1)}%',
      name: _logName,
      level: 500,
    );
  }
}

/// Statistiques du service d'observation
class EventObserverStats {
  final int plantingEventsCount;
  final int weatherEventsCount;
  final int activityEventsCount;
  final int harvestEventsCount;
  final int contextEventsCount;
  final int totalEventsCount;
  final int analysisTriggeredCount;
  final int analysisErrorCount;
  final double successRate;

  const EventObserverStats({
    required this.plantingEventsCount,
    required this.weatherEventsCount,
    required this.activityEventsCount,
    required this.harvestEventsCount,
    required this.contextEventsCount,
    required this.totalEventsCount,
    required this.analysisTriggeredCount,
    required this.analysisErrorCount,
    required this.successRate,
  });

  @override
  String toString() {
    return 'EventObserverStats(total: $totalEventsCount, '
        'analyses: $analysisTriggeredCount, errors: $analysisErrorCount, '
        'rate: ${successRate.toStringAsFixed(1)}%)';
  }
}

