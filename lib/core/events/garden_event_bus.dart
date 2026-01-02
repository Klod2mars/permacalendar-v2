import 'dart:async';
import 'dart:developer' as developer;
import 'garden_events.dart';

/// Event Bus simple pour les événements du jardin
///
/// **Architecture :**
/// - Pattern Publish-Subscribe pour découpler les features
/// - Communication asynchrone via Streams
/// - Singleton pour accès global
///
/// **Utilisation :**
/// ```dart
/// // Émettre un événement
/// GardenEventBus().emit(
///   GardenEvent.plantingAdded(
///     gardenId: 'garden_1',
///     plantingId: 'planting_1',
///     plantId: 'tomato',
///     timestamp: DateTime.now(),
///   ),
/// );
///
/// // Écouter les événements
/// GardenEventBus().events.listen((event) {
///   event.when(
///     plantingAdded: (gardenId, plantingId, plantId, timestamp, metadata) {
///       // Réagir à l'événement
///     },
///     // ... autres événements
///   );
/// });
/// ```
class GardenEventBus {
  static const String _logName = 'GardenEventBus';

  /// Singleton instance
  static final GardenEventBus _instance = GardenEventBus._internal();

  /// Factory constructor pour accès au singleton
  factory GardenEventBus() => _instance;

  /// Constructeur privé
  GardenEventBus._internal() {
    developer.log(
      'ðŸšŒ GardenEventBus Créé',
      name: _logName,
      level: 500,
    );
  }

  /// Controller du stream d'événements (broadcast pour plusieurs listeners)
  final _controller = StreamController<GardenEvent>.broadcast();

  /// Compteur d'événements pour statistiques
  int _eventCount = 0;

  /// Stream des événements (lecture seule)
  ///
  /// Permet aux observers de s'abonner aux événements
  Stream<GardenEvent> get events => _controller.stream;

  /// Nombre total d'événements émis
  int get eventCount => _eventCount;

  /// Nombre de listeners actifs
  int get listenerCount => _controller.hasListener ? 1 : 0;

  /// Émet un événement dans le bus
  ///
  /// Tous les listeners recevront cet événement de manière asynchrone.
  ///
  /// **Exemple :**
  /// ```dart
  /// GardenEventBus().emit(
  ///   GardenEvent.plantingAdded(
  ///     gardenId: 'garden_1',
  ///     plantingId: 'planting_1',
  ///     plantId: 'tomato',
  ///     timestamp: DateTime.now(),
  ///   ),
  /// );
  /// ```
  void emit(GardenEvent event) {
    if (_controller.isClosed) {
      developer.log(
        'âš ï¸ Tentative d\'émission d\'événement sur un bus fermé',
        name: _logName,
        level: 900,
      );
      return;
    }

    _eventCount++;

    developer.log(
      'ðŸ“¡ Événement émis (#$_eventCount): ${event.runtimeType}',
      name: _logName,
      level: 500,
    );

    _controller.add(event);
  }

  /// Ferme le bus (cleanup)
  ///
  /// À appeler lors de la fermeture de l'application pour libérer les ressources.
  ///
  /// **Note :** Une fois fermé, le bus ne peut plus émettre d'événements.
  void dispose() {
    developer.log(
      'ðŸ”’ Fermeture du GardenEventBus ($_eventCount événements émis)',
      name: _logName,
      level: 500,
    );

    _controller.close();
  }

  /// Réinitialise les statistiques
  void resetStats() {
    _eventCount = 0;
    developer.log(
      'ðŸ”„ Statistiques réinitialisées',
      name: _logName,
      level: 500,
    );
  }

  /// Affiche les statistiques dans les logs
  void logStats() {
    developer.log(
      'ðŸ“Š Statistiques GardenEventBus:\n'
      '  - Événements émis: $_eventCount\n'
      '  - Listeners actifs: $listenerCount\n'
      '  - Bus actif: ${!_controller.isClosed}',
      name: _logName,
      level: 500,
    );
  }
}
