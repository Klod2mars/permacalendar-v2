import 'dart:developer' as developer;

/// Service d'analytics ultra-léger pour tracker l'usage des nouvelles fonctionnalités UI
///
/// Utilise `dart:developer` pour commencer (logs développeur).
/// Peut être facilement étendu pour intégrer Firebase Analytics, Mixpanel, etc.
class UIAnalytics {
  static const String _prefix = '[UI_ANALYTICS]';

  /// Activer/désactiver les logs
  static bool enabled = true;

  /// Log un événement avec des paramètres optionnels
  static void logEvent(String eventName, [Map<String, dynamic>? parameters]) {
    if (!enabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final paramsStr = parameters != null ? ' | ${parameters.toString()}' : '';

    developer.log(
      '$eventName$paramsStr',
      name: _prefix,
      time: DateTime.now(),
    );
  }

  // ========================================
  // ÉVÉNEMENTS HOME SCREEN V2
  // ========================================

  /// Home V2 ouvert
  static void homeV2Opened() {
    logEvent('home_v2_opened');
  }

  /// Tuile d'action rapide cliquée
  static void quickActionTapped(String actionName) {
    logEvent('quick_action_tapped', {'action': actionName});
  }

  /// Jardin sélectionné dans le carrousel
  static void gardenCarouselTapped(String gardenId, String gardenName) {
    logEvent('garden_carousel_tapped', {
      'garden_id': gardenId,
      'garden_name': gardenName,
    });
  }

  /// Menu de création rapide ouvert
  static void quickCreateMenuOpened() {
    logEvent('quick_create_menu_opened');
  }

  // ========================================
  // ÉVÉNEMENTS CALENDRIER
  // ========================================

  /// Calendrier ouvert
  static void calendarOpened({
    required int month,
    required int year,
  }) {
    logEvent('calendar_opened', {
      'month': month,
      'year': year,
    });
  }

  /// Navigation vers un autre mois
  static void calendarMonthChanged({
    required int fromMonth,
    required int fromYear,
    required int toMonth,
    required int toYear,
  }) {
    logEvent('calendar_month_changed', {
      'from': '$fromMonth/$fromYear',
      'to': '$toMonth/$toYear',
    });
  }

  /// Date sélectionnée dans le calendrier
  static void calendarDateSelected({
    required DateTime date,
    required int plantingCount,
    required int harvestCount,
  }) {
    logEvent('calendar_date_selected', {
      'date': date.toIso8601String(),
      'planting_count': plantingCount,
      'harvest_count': harvestCount,
    });
  }

  /// Plantation cliquée depuis les détails du jour
  static void calendarPlantingTapped(String plantingId) {
    logEvent('calendar_planting_tapped', {'planting_id': plantingId});
  }

  // ========================================
  // ÉVÉNEMENTS RÉCOLTE RAPIDE
  // ========================================

  /// Widget de récolte rapide ouvert
  static void quickHarvestOpened({
    required int readyPlantsCount,
  }) {
    logEvent('quick_harvest_opened', {
      'ready_plants_count': readyPlantsCount,
    });
  }

  /// Recherche utilisée dans le widget
  static void quickHarvestSearchUsed(String query) {
    logEvent('quick_harvest_search_used', {'query': query});
  }

  /// Plante sélectionnée/désélectionnée
  static void quickHarvestPlantToggled({
    required String plantingId,
    required bool isSelected,
  }) {
    logEvent('quick_harvest_plant_toggled', {
      'planting_id': plantingId,
      'is_selected': isSelected,
    });
  }

  /// Tout sélectionner / Tout désélectionner
  static void quickHarvestSelectAll(bool selectAll) {
    logEvent('quick_harvest_select_all', {'select_all': selectAll});
  }

  /// Récolte confirmée
  static void quickHarvestConfirmed({
    required int count,
    required int successCount,
    required int errorCount,
  }) {
    logEvent('quick_harvest_confirmed', {
      'count': count,
      'success_count': successCount,
      'error_count': errorCount,
    });
  }

  /// Widget fermé sans récolter
  static void quickHarvestCancelled() {
    logEvent('quick_harvest_cancelled');
  }

  // ========================================
  // ÉVÉNEMENTS MULTI-JARDIN
  // ========================================

  /// Jardin changé (contexte global)
  static void gardenSwitched({
    required String fromGardenId,
    required String toGardenId,
  }) {
    logEvent('garden_switched', {
      'from_garden_id': fromGardenId,
      'to_garden_id': toGardenId,
    });
  }

  // ========================================
  // ÉVÉNEMENTS INTELLIGENCE VÉGÉTALE
  // ========================================

  /// Dashboard d'intelligence ouvert
  static void intelligenceDashboardOpened({
    String? gardenId,
  }) {
    logEvent('intelligence_dashboard_opened', {
      if (gardenId != null) 'garden_id': gardenId,
    });
  }

  // ========================================
  // MÉTRIQUES DE PERFORMANCE
  // ========================================

  /// Mesurer le temps d'une opération
  static Future<T> measureOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();
      logEvent('${operationName}_completed', {
        'duration_ms': stopwatch.elapsedMilliseconds,
      });
      return result;
    } catch (e) {
      stopwatch.stop();
      logEvent('${operationName}_failed', {
        'duration_ms': stopwatch.elapsedMilliseconds,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  // ========================================
  // UTILITAIRES
  // ========================================

  /// Clear logs (pour tests)
  static void clear() {
    developer.log('Analytics cleared', name: _prefix);
  }

  /// Désactiver temporairement
  static void disable() {
    enabled = false;
    developer.log('Analytics disabled', name: _prefix);
  }

  /// Réactiver
  static void enable() {
    enabled = true;
    developer.log('Analytics enabled', name: _prefix);
  }
}

/// Extension pour faciliter le tracking depuis les widgets
extension UIAnalyticsContext on Object {
  /// Log un événement avec le nom de la classe comme contexte
  void logUIEvent(String eventName, [Map<String, dynamic>? parameters]) {
    final className = runtimeType.toString();
    UIAnalytics.logEvent('$className.$eventName', parameters);
  }
}


