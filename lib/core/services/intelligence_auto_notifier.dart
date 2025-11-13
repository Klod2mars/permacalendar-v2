ï»¿import 'dart:async';
import 'dart:developer' as developer;
import 'package:riverpod/riverpod.dart';
import '../../features/plant_intelligence/domain/entities/plant_condition.dart';
import '../../features/plant_intelligence/domain/entities/weather_condition.dart';
import '../../features/plant_intelligence/data/services/plant_notification_service.dart';
import '../providers/intelligence_runtime_providers.dart';
import '../../features/plant_intelligence/domain/entities/intelligence_state.dart';
import '../../features/plant_intelligence/presentation/providers/intelligence_state_providers.dart';

/// âœ… NOUVEAU - Phase 1 : Connexion Fonctionnelle
///
/// Service d'écoute pour générer des alertes automatiquement
///
/// Écoute les changements d'état de l'intelligence végétale et déclenche
/// la génération de notifications automatiques pour :
/// - Conditions critiques détectées
/// - Conditions optimales atteintes
/// - Changements météo significatifs
///
/// **Architecture** :
/// - Couche Core (services infrastructure)
/// - Utilise PlantNotificationService (data layer)
/// - Écoute IntelligenceState (presentation layer)
///
/// **Principe** :
/// Observer pattern - Réagit aux changements sans modifier l'état
class IntelligenceAutoNotifier {
  final Ref _ref;
  final PlantNotificationService _notificationService;

  ProviderSubscription<IntelligenceState>? _stateSubscription;
  ProviderSubscription<String?>? _gardenIdSubscription;
  bool _isInitialized = false;

  // Cache pour éviter les notifications en double
  final Map<String, DateTime> _lastNotificationTime = {};
  static const _notificationCooldown = Duration(hours: 6);

  IntelligenceAutoNotifier(this._ref, this._notificationService);

  /// Initialise les écouteurs
  Future<void> initialize() async {
    if (_isInitialized) {
      developer.log('ðŸ”” IntelligenceAutoNotifier déjà initialisé',
          name: 'AutoNotifier');
      return;
    }

    developer.log('ðŸ”” Initialisation IntelligenceAutoNotifier',
        name: 'AutoNotifier');

    // Listen to current garden id and subscribe to the correct family instance
    _gardenIdSubscription = _ref.listen<String?>(
      currentIntelligenceGardenIdProvider,
      (previousGardenId, nextGardenId) {
        _stateSubscription?.close();
        _stateSubscription = null;
        if (nextGardenId != null) {
          _stateSubscription = _ref.listen<IntelligenceState>(
            intelligenceStateProvider(nextGardenId),
            (previous, next) {
              if (previous != null) _handleIntelligenceStateChange(previous, next);
            },
          );
        }
      },
    );
    final initialGardenId = _ref.read(currentIntelligenceGardenIdProvider);
    if (initialGardenId != null) {
      _stateSubscription = _ref.listen<IntelligenceState>(
        intelligenceStateProvider(initialGardenId),
        (previous, next) {
          if (previous != null) _handleIntelligenceStateChange(previous, next);
        },
      );
    }

    _isInitialized = true;
    developer.log('âœ… IntelligenceAutoNotifier initialisé',
        name: 'AutoNotifier');
  }

  /// Gère les changements d'état intelligence
  Future<void> _handleIntelligenceStateChange(
    IntelligenceState previous,
    IntelligenceState next,
  ) async {
    try {
      // Vérifier les nouvelles conditions critiques
      await _checkCriticalConditions(previous, next);

      // Vérifier les conditions optimales
      await _checkOptimalConditions(previous, next);

      // Vérifier les changements météo
      await _checkWeatherChanges(previous, next);
    } catch (e, stackTrace) {
      developer.log(
        'âŒ Erreur traitement changement état',
        name: 'AutoNotifier',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Vérifie et génère des alertes pour les conditions critiques
  Future<void> _checkCriticalConditions(
    IntelligenceState previous,
    IntelligenceState next,
  ) async {
    for (final entry in next.plantConditions.entries) {
      final plantId = entry.key;
      final condition = entry.value;
      final previousCondition = previous.plantConditions[plantId];

      // Nouvelle condition critique détectée
      if (_isCritical(condition) && !_isCritical(previousCondition)) {
        // Vérifier cooldown
        if (_isInCooldown(plantId, condition.type)) {
          continue;
        }

        developer.log('âš ï¸ Condition critique détectée pour $plantId',
            name: 'AutoNotifier');

        // Récupérer le nom de la plante (à partir du state ou provider)
        final plantName = await _getPlantName(plantId, next);
        final gardenId = next.currentGardenId ?? '';

        await _notificationService.generateCriticalConditionAlert(
          plantId: plantId,
          plantName: plantName,
          gardenId: gardenId,
          conditionType: condition.type,
          conditionStatus: condition.status,
          currentValue: condition.value,
          unit: condition.unit,
          recommendation: condition.recommendations?.join(', '),
        );

        // Mettre à jour le cache cooldown
        _updateCooldown(plantId, condition.type);
      }
    }
  }

  /// Vérifie et génère des alertes pour les conditions optimales
  Future<void> _checkOptimalConditions(
    IntelligenceState previous,
    IntelligenceState next,
  ) async {
    for (final entry in next.plantConditions.entries) {
      final plantId = entry.key;
      final condition = entry.value;
      final previousCondition = previous.plantConditions[plantId];

      // Condition optimale atteinte
      if (_isOptimal(condition) && !_isOptimal(previousCondition)) {
        // Vérifier cooldown (notifications optimales moins urgentes)
        if (_isInCooldown(plantId, condition.type)) {
          continue;
        }

        developer.log('âœ… Condition optimale atteinte pour $plantId',
            name: 'AutoNotifier');

        final plantName = await _getPlantName(plantId, next);
        final gardenId = next.currentGardenId ?? '';

        await _notificationService.generateOptimalConditionAlert(
          plantId: plantId,
          plantName: plantName,
          gardenId: gardenId,
          conditionType: condition.type,
          currentValue: condition.value,
          unit: condition.unit,
        );

        _updateCooldown(plantId, condition.type);
      }
    }
  }

  /// Vérifie et génère des alertes pour les changements météo
  Future<void> _checkWeatherChanges(
    IntelligenceState previous,
    IntelligenceState next,
  ) async {
    if (next.currentWeather == null || previous.currentWeather == null) {
      return;
    }

    final prevWeather = previous.currentWeather!;
    final currWeather = next.currentWeather!;
    final gardenId = next.currentGardenId ?? '';

    // Récupérer la température depuis WeatherCondition
    final prevTemp = _getTemperatureFromWeather(prevWeather);
    final currTemp = _getTemperatureFromWeather(currWeather);

    if (prevTemp == null || currTemp == null) return;

    // Changement significatif de température (> 10Â°C)
    final tempDiff = (currTemp - prevTemp).abs();
    if (tempDiff > 10) {
      developer.log(
          'ðŸŒ¡ï¸ Changement température important: ${tempDiff.toStringAsFixed(1)}Â°C',
          name: 'AutoNotifier');
      await _notificationService.generateWeatherAlerts(
        gardenId: gardenId,
        temperature: currTemp,
        humidity: _getHumidityFromWeather(currWeather),
        windSpeed: _getWindSpeedFromWeather(currWeather),
        affectedPlantIds: next.activePlantIds,
      );
    }

    // Passage au gel
    if (currTemp < 0 && prevTemp >= 0) {
      developer.log('â„ï¸ Alerte gel détectée', name: 'AutoNotifier');
      await _notificationService.generateWeatherAlerts(
        gardenId: gardenId,
        temperature: currTemp,
        humidity: _getHumidityFromWeather(currWeather),
        windSpeed: _getWindSpeedFromWeather(currWeather),
        affectedPlantIds: next.activePlantIds,
      );
    }

    // Passage en canicule
    if (currTemp > 35 && prevTemp <= 35) {
      developer.log('ðŸ”¥ Alerte canicule détectée', name: 'AutoNotifier');
      await _notificationService.generateWeatherAlerts(
        gardenId: gardenId,
        temperature: currTemp,
        humidity: _getHumidityFromWeather(currWeather),
        windSpeed: _getWindSpeedFromWeather(currWeather),
        affectedPlantIds: next.activePlantIds,
      );
    }
  }

  /// Extrait la température depuis WeatherCondition
  double? _getTemperatureFromWeather(WeatherCondition weather) {
    if (weather.type == WeatherType.temperature) {
      return weather.value;
    }
    return null;
  }

  /// Extrait l'humidité depuis WeatherCondition (si disponible)
  double? _getHumidityFromWeather(WeatherCondition weather) {
    if (weather.type == WeatherType.humidity) {
      return weather.value;
    }
    return null;
  }

  /// Extrait la vitesse du vent depuis WeatherCondition (si disponible)
  double? _getWindSpeedFromWeather(WeatherCondition weather) {
    if (weather.type == WeatherType.windSpeed) {
      return weather.value;
    }
    return null;
  }

  // ==================== HELPERS ====================

  /// Vérifie si une condition est critique
  bool _isCritical(PlantCondition? condition) {
    if (condition == null) return false;
    return condition.status == ConditionStatus.critical ||
        condition.status == ConditionStatus.poor ||
        condition.healthScore < 30;
  }

  /// Vérifie si une condition est optimale
  bool _isOptimal(PlantCondition? condition) {
    if (condition == null) return false;
    return condition.status == ConditionStatus.excellent &&
        condition.healthScore >= 90;
  }

  /// Vérifie si une notification est en période de cooldown
  bool _isInCooldown(String plantId, ConditionType type) {
    final key = '$plantId-${type.name}';
    final lastTime = _lastNotificationTime[key];

    if (lastTime == null) return false;

    final elapsed = DateTime.now().difference(lastTime);
    return elapsed < _notificationCooldown;
  }

  /// Met à jour le timestamp de dernière notification
  void _updateCooldown(String plantId, ConditionType type) {
    final key = '$plantId-${type.name}';
    _lastNotificationTime[key] = DateTime.now();
  }

  /// Récupère le nom d'une plante (fallback sur plantId si non trouvé)
  Future<String> _getPlantName(String plantId, IntelligenceState state) async {
    try {
      // Essayer de récupérer depuis les rapports ou le state
      // Pour l'instant, utiliser plantId comme fallback
      return plantId;
    } catch (e) {
      return plantId;
    }
  }

  /// Arrête les écouteurs et libère les ressources
  void dispose() {
    developer.log('ðŸ›‘ Arrêt IntelligenceAutoNotifier', name: 'AutoNotifier');
    _stateSubscription?.close();
    _gardenIdSubscription?.close();
    _lastNotificationTime.clear();
    _isInitialized = false;
  }
}

/// Provider pour le service de notifications plantes
///
/// âœ… NOUVEAU - Phase 1 : Connexion Fonctionnelle
final plantNotificationServiceProvider =
    Provider<PlantNotificationService>((ref) {
  return PlantNotificationService();
});

/// Provider pour le notifier automatique
///
/// âœ… NOUVEAU - Phase 1 : Connexion Fonctionnelle
/// S'initialise automatiquement et écoute les changements d'état
final intelligenceAutoNotifierProvider =
    Provider<IntelligenceAutoNotifier>((ref) {
  final notificationService = ref.read(plantNotificationServiceProvider);
  final notifier = IntelligenceAutoNotifier(ref, notificationService);

  // Initialiser automatiquement au premier accès
  notifier.initialize();

  // Nettoyer à la destruction du provider
  ref.onDispose(() => notifier.dispose());

  return notifier;
});


