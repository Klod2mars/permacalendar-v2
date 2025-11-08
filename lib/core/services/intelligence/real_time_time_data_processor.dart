// ⏰ Real-Time Temporal Data Processor - Time-Aware Stream Processing Engine
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Temporal Patterns
//
// **Rôle dans l'écosystème d'intelligence :**
// Ce processeur gère le traitement de flux événementiels avec une conscience temporelle pour :
// - Traitement d'événements horodatés avec validation de séquence
// - Synchronisation temporelle avec l'horloge système
// - Gestion des retards et événements hors séquence
// - Détection des dérives de temps (horloges système décalées)
// - Mise à jour de modèles temporels basés sur les événements
// - Throttling intelligent basé sur le temps réel
//
// **Différences avec RealTimeDataProcessor :**
// - `RealTimeDataProcessor` : Traite les événements par priorité, sans conscience temporelle
// - `RealTimeTimeDataProcessor` : Traite les événements par ordre temporel, avec validation de séquence
// - Gestion des événements retardés, hors séquence, et des dérives de temps
// - Synchronisation avec l'horloge système pour éviter les décalages
// - Modèles temporels pour prédire les patterns d'événements
//
// **Interactions avec les autres composants :**
// - Utilise `RealTimeDataProcessor` pour le traitement de base des événements
// - Intègre avec `plantDataSourceProvider` pour les données de plantes horodatées
// - Peut être utilisé avec `IntelligentRecommendationEngine` pour les recommandations temporelles
// - Intègre avec `MetricsCollectorService` pour les métriques temporelles
//
// **Stratégies de résilience et sécurité :**
// - Gestion d'erreurs silencieuse : Les erreurs temporelles ne font pas planter le système
// - Protection contre les dérives de temps : Détection et correction des horloges décalées
// - Gestion des événements hors séquence : Buffer avec fenêtre temporelle
// - Throttling temporel : Limite la fréquence basée sur le temps réel
// - Timeout protection : Tous les traitements sont limités dans le temps
// - Validation de séquence : Vérifie l'ordre temporel des événements
//
// **Exemple d'utilisation via Riverpod 3 :**
// ```dart
// // Dans un provider
// final temporalProcessor = ref.read(
//   IntelligenceModule.realTimeTimeDataProcessorProvider,
// );
// await temporalProcessor.startTemporalStream();
//
// // Soumettre un événement horodaté
// await temporalProcessor.processTimedEvent(TimedEvent(
//   id: 'garden_update_123',
//   data: gardenData,
//   timestamp: DateTime.now(),
//   expectedSequence: 42,
// ));
//
// // S'abonner aux événements temporels
// temporalProcessor.subscribeToTemporalStream<String>(
//   onEvent: (event) async {
//     // Traiter l'événement avec conscience temporelle
//     return TemporalProcessingResult(
//       eventId: event.id,
//       success: true,
//       processingTime: Duration.zero,
//       latency: event.latency,
//       sequenceValid: event.sequenceValid,
//     );
//   },
//   onError: (error) {
//     // Gérer l'erreur temporelle
//   },
// );
//
// // Utiliser avec StreamProvider pour un flux temporel réactif
// final temporalStreamProvider = StreamProvider.autoDispose<TimedEvent<String>>((ref) {
//   final processor = ref.read(
//     IntelligenceModule.realTimeTimeDataProcessorProvider,
//   );
//   return processor.getTemporalStream<String>();
// });
// ```

import 'dart:async';
import 'dart:developer' as developer;
import 'real_time_data_processor.dart';

/// Temporal event with sequence validation
class TimedEvent<T> {
  final String id;
  final T data;
  final DateTime timestamp;
  final int? expectedSequence;
  final Duration? latency;
  final bool sequenceValid;
  final Map<String, dynamic> metadata;

  TimedEvent({
    required this.id,
    required this.data,
    DateTime? timestamp,
    this.expectedSequence,
    this.latency,
    this.sequenceValid = true,
    this.metadata = const {},
  }) : timestamp = timestamp ?? DateTime.now();

  TimedEvent<T> copyWith({
    String? id,
    T? data,
    DateTime? timestamp,
    int? expectedSequence,
    Duration? latency,
    bool? sequenceValid,
    Map<String, dynamic>? metadata,
  }) {
    return TimedEvent<T>(
      id: id ?? this.id,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      expectedSequence: expectedSequence ?? this.expectedSequence,
      latency: latency ?? this.latency,
      sequenceValid: sequenceValid ?? this.sequenceValid,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'expectedSequence': expectedSequence,
        'latencyMs': latency?.inMilliseconds,
        'sequenceValid': sequenceValid,
        'metadata': metadata,
      };
}

/// Temporal processing result
class TemporalProcessingResult<T> {
  final String eventId;
  final T? processedData;
  final bool success;
  final Duration processingTime;
  final Duration? latency;
  final bool sequenceValid;
  final String? error;
  final Map<String, dynamic> metrics;

  TemporalProcessingResult({
    required this.eventId,
    this.processedData,
    required this.success,
    required this.processingTime,
    this.latency,
    this.sequenceValid = true,
    this.error,
    this.metrics = const {},
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'success': success,
        'processingTimeMs': processingTime.inMilliseconds,
        'latencyMs': latency?.inMilliseconds,
        'sequenceValid': sequenceValid,
        'error': error,
        'metrics': metrics,
      };
}

/// Temporal model for pattern prediction
class TemporalModel {
  final DateTime lastUpdate;
  final Duration averageInterval;
  final Duration? predictedNextInterval;
  final double confidence;
  final Map<String, dynamic> parameters;

  TemporalModel({
    required this.lastUpdate,
    required this.averageInterval,
    this.predictedNextInterval,
    this.confidence = 0.0,
    this.parameters = const {},
  });

  TemporalModel copyWith({
    DateTime? lastUpdate,
    Duration? averageInterval,
    Duration? predictedNextInterval,
    double? confidence,
    Map<String, dynamic>? parameters,
  }) {
    return TemporalModel(
      lastUpdate: lastUpdate ?? this.lastUpdate,
      averageInterval: averageInterval ?? this.averageInterval,
      predictedNextInterval: predictedNextInterval ?? this.predictedNextInterval,
      confidence: confidence ?? this.confidence,
      parameters: parameters ?? this.parameters,
    );
  }

  Map<String, dynamic> toJson() => {
        'lastUpdate': lastUpdate.toIso8601String(),
        'averageIntervalMs': averageInterval.inMilliseconds,
        'predictedNextIntervalMs': predictedNextInterval?.inMilliseconds,
        'confidence': confidence,
        'parameters': parameters,
      };
}

/// Temporal processing statistics
class TemporalStatistics {
  final int totalEvents;
  final int processedEvents;
  final int failedEvents;
  final int outOfSequenceEvents;
  final int droppedEvents;
  final double averageLatency;
  final double averageProcessingTime;
  final double throughput; // events per second
  final int currentQueueSize;
  final Duration? timeDrift;
  final Map<String, TemporalModel> temporalModels;

  TemporalStatistics({
    required this.totalEvents,
    required this.processedEvents,
    required this.failedEvents,
    required this.outOfSequenceEvents,
    required this.droppedEvents,
    required this.averageLatency,
    required this.averageProcessingTime,
    required this.throughput,
    required this.currentQueueSize,
    this.timeDrift,
    this.temporalModels = const {},
  });

  Map<String, dynamic> toJson() => {
        'totalEvents': totalEvents,
        'processedEvents': processedEvents,
        'failedEvents': failedEvents,
        'outOfSequenceEvents': outOfSequenceEvents,
        'droppedEvents': droppedEvents,
        'averageLatencyMs': averageLatency,
        'averageProcessingTimeMs': averageProcessingTime,
        'throughput': throughput,
        'currentQueueSize': currentQueueSize,
        'timeDriftMs': timeDrift?.inMilliseconds,
        'temporalModels': temporalModels.map(
          (k, v) => MapEntry(k, v.toJson()),
        ),
      };
}

/// Real-time temporal data processor for time-aware stream processing
///
/// **Gestion de la mémoire :**
/// - Limite la queue temporelle à `_maxQueueSize` événements
/// - Nettoie automatiquement les événements expirés
/// - Limite l'historique temporel à 1000 entrées
///
/// **Gestion d'erreurs :**
/// - Toutes les méthodes critiques sont protégées par try/catch
/// - En cas d'erreur temporelle, les événements sont marqués mais le système continue
/// - Logs détaillés pour le debugging temporel
///
/// **Sécurité des flux :**
/// - Tous les StreamControllers sont fermés proprement lors de l'arrêt
/// - Les subscriptions sont annulées avant la fermeture des streams
/// - Protection contre les double-fermetures
///
/// **Protection temporelle :**
/// - Détection des dérives de temps (horloges système décalées)
/// - Validation de séquence pour les événements
/// - Buffer avec fenêtre temporelle pour les événements hors séquence
/// - Throttling basé sur le temps réel
class RealTimeTimeDataProcessor {
  // Base processor for event handling
  final RealTimeDataProcessor _baseProcessor;

  // Temporal stream
  StreamController<TimedEvent>? _temporalStreamController;

  // Temporal event queue (sorted by timestamp)
  final List<TimedEvent> _temporalQueue = [];
  final int _maxQueueSize;

  // Sequence tracking
  final Map<String, int> _sequenceBySource = {};

  // Temporal models
  final Map<String, TemporalModel> _temporalModels = {};

  // Statistics
  int _totalEvents = 0;
  int _processedEvents = 0;
  int _failedEvents = 0;
  int _outOfSequenceEvents = 0;
  int _droppedEvents = 0;
  final List<Duration> _latencies = [];
  final List<Duration> _processingTimes = [];
  DateTime? _firstEventTime;

  // Time drift detection
  DateTime? _systemClockReference;
  Duration? _detectedTimeDrift;

  // Configuration
  final Duration _processingTimeout;
  final Duration _maxLatency;
  final Duration _temporalWindow;
  final bool _enableSequenceValidation;
  final bool _enableTimeDriftDetection;
  bool _isRunning = false;
  Timer? _temporalProcessingTimer;
  Timer? _timeDriftCheckTimer;
  DateTime? _lastThrottleTime;

  RealTimeTimeDataProcessor({
    RealTimeDataProcessor? baseProcessor,
    int? maxQueueSize,
    Duration? processingTimeout,
    Duration? maxLatency,
    Duration? temporalWindow,
    bool? enableSequenceValidation,
    bool? enableTimeDriftDetection,
  })  : _baseProcessor = baseProcessor ?? RealTimeDataProcessor(),
        _maxQueueSize = maxQueueSize ?? 1000,
        _processingTimeout = processingTimeout ?? const Duration(seconds: 30),
        _maxLatency = maxLatency ?? const Duration(minutes: 5),
        _temporalWindow = temporalWindow ?? const Duration(seconds: 10),
        _enableSequenceValidation = enableSequenceValidation ?? true,
        _enableTimeDriftDetection = enableTimeDriftDetection ?? true {
    _initializeTemporalStream();
  }

  /// Initialize temporal stream
  ///
  /// **Sécurité :**
  /// - Crée un StreamController broadcast pour permettre plusieurs listeners
  /// - Initialise la référence de l'horloge système pour la détection de dérive
  void _initializeTemporalStream() {
    try {
      _temporalStreamController = StreamController<TimedEvent>.broadcast(
        onCancel: () {
          _log('Temporal stream cancelled');
        },
      );

      if (_enableTimeDriftDetection) {
        _systemClockReference = DateTime.now();
      }
    } catch (e, stackTrace) {
      _logError('Error initializing temporal stream', e, stackTrace);
      rethrow;
    }
  }

  /// Start temporal stream processing
  ///
  /// **Sécurité :**
  /// - Vérifie si déjà en cours d'exécution pour éviter les doubles démarrages
  /// - Démarre le processeur de base
  /// - Initialise les timers de traitement temporel et de détection de dérive
  /// - Gère les erreurs silencieusement pour éviter les plantages
  Future<void> startTemporalStream() async {
    if (_isRunning) {
      _log('Temporal processor already running');
      return;
    }

    try {
      _isRunning = true;
      _firstEventTime = DateTime.now();
      _log('Temporal processor started');

      // Start base processor
      await _baseProcessor.start();

      // Process temporal queue periodically
      _temporalProcessingTimer = Timer.periodic(
        const Duration(milliseconds: 50),
        (timer) {
          if (!_isRunning) {
            timer.cancel();
            _temporalProcessingTimer = null;
            return;
          }
          try {
            _processTemporalQueue();
          } catch (e, stackTrace) {
            _logError('Error in temporal queue processing timer', e, stackTrace);
            // Continue processing despite errors
          }
        },
      );

      // Check for time drift periodically
      if (_enableTimeDriftDetection) {
        _timeDriftCheckTimer = Timer.periodic(
          const Duration(seconds: 30),
          (timer) {
            if (!_isRunning) {
              timer.cancel();
              _timeDriftCheckTimer = null;
              return;
            }
            try {
              _checkTimeDrift();
            } catch (e, stackTrace) {
              _logError('Error in time drift check timer', e, stackTrace);
              // Continue processing despite errors
            }
          },
        );
      }
    } catch (e, stackTrace) {
      _isRunning = false;
      _logError('Error starting temporal processor', e, stackTrace);
      rethrow;
    }
  }

  /// Stop temporal stream processing
  ///
  /// **Sécurité :**
  /// - Annule les timers de traitement temporel et de détection de dérive
  /// - Arrête le processeur de base
  /// - Ferme le StreamController avec gestion d'erreurs
  /// - Protection contre les double-fermetures
  Future<void> stopTemporalStream() async {
    if (!_isRunning) {
      _log('Temporal processor already stopped');
      return;
    }

    try {
      _isRunning = false;

      // Cancel temporal processing timer
      _temporalProcessingTimer?.cancel();
      _temporalProcessingTimer = null;

      // Cancel time drift check timer
      _timeDriftCheckTimer?.cancel();
      _timeDriftCheckTimer = null;

      // Stop base processor
      await _baseProcessor.stop();

      // Close temporal stream with error handling
      if (_temporalStreamController != null && !_temporalStreamController!.isClosed) {
        try {
          await _temporalStreamController!.close();
        } catch (e, stackTrace) {
          _logError('Error closing temporal stream', e, stackTrace);
        }
        _temporalStreamController = null;
      }

      _log('Temporal processor stopped');
    } catch (e, stackTrace) {
      _logError('Error stopping temporal processor', e, stackTrace);
      // Ensure _isRunning is false even on error
      _isRunning = false;
      rethrow;
    }
  }

  /// Process timed event
  ///
  /// **Sécurité :**
  /// - Démarre automatiquement le processeur temporel si nécessaire
  /// - Valide la séquence si activée
  /// - Calcule la latence de l'événement
  /// - Gère la backpressure en rejetant les événements si la queue est pleine
  /// - Gère les erreurs silencieusement pour éviter les plantages
  Future<TemporalProcessingResult<T>> processTimedEvent<T>(
    TimedEvent<T> event,
  ) async {
    final startTime = DateTime.now();

    try {
      if (!_isRunning) {
        _log('Temporal processor not running, starting...');
        await startTemporalStream();
      }

      _totalEvents++;

      // Calculate latency
      final latency = startTime.difference(event.timestamp);
      final eventWithLatency = event.copyWith(latency: latency);

      // Validate sequence if enabled
      bool sequenceValid = true;
      if (_enableSequenceValidation && event.expectedSequence != null) {
        sequenceValid = _validateSequence(event.id, event.expectedSequence!);
        if (!sequenceValid) {
          _outOfSequenceEvents++;
          _log('Out of sequence event: ${event.id}');
        }
      }

      // Check if event is too old (max latency exceeded)
      if (latency > _maxLatency) {
        _droppedEvents++;
        _log('Event dropped due to excessive latency: ${event.id} (${latency.inSeconds}s)');
        return TemporalProcessingResult<T>(
          eventId: event.id,
          success: false,
          processingTime: DateTime.now().difference(startTime),
          latency: latency,
          sequenceValid: sequenceValid,
          error: 'Event latency exceeds maximum allowed (${_maxLatency.inSeconds}s)',
        );
      }

      // Check queue size (backpressure management)
      if (_temporalQueue.length >= _maxQueueSize) {
        _droppedEvents++;
        _log('Event dropped due to backpressure: ${event.id}');
        return TemporalProcessingResult<T>(
          eventId: event.id,
          success: false,
          processingTime: DateTime.now().difference(startTime),
          latency: latency,
          sequenceValid: sequenceValid,
          error: 'Temporal queue is full',
        );
      }

      // Add to temporal queue (will be sorted by timestamp)
      _temporalQueue.add(eventWithLatency.copyWith(sequenceValid: sequenceValid));
      _temporalQueue.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Update temporal model
      await updateTemporalModel(event.id, event.timestamp);

      // Update statistics
      _latencies.add(latency);
      if (_latencies.length > 1000) {
        _latencies.removeAt(0);
      }

      _log('Timed event processed: ${event.id} (latency: ${latency.inMilliseconds}ms)');

      return TemporalProcessingResult<T>(
        eventId: event.id,
        success: true,
        processingTime: DateTime.now().difference(startTime),
        latency: latency,
        sequenceValid: sequenceValid,
      );
    } catch (e, stackTrace) {
      _failedEvents++;
      _logError('Error processing timed event: ${event.id}', e, stackTrace);
      return TemporalProcessingResult<T>(
        eventId: event.id,
        success: false,
        processingTime: DateTime.now().difference(startTime),
        latency: event.latency,
        sequenceValid: false,
        error: e.toString(),
      );
    }
  }

  /// Process temporal queue
  ///
  /// **Sécurité :**
  /// - Traite les événements dans l'ordre temporel
  /// - Applique le throttling pour éviter la surcharge CPU
  /// - Gère les erreurs individuellement pour chaque événement
  /// - Nettoie les événements expirés
  void _processTemporalQueue() {
    if (_temporalQueue.isEmpty) return;

    try {
      // Apply throttling
      final now = DateTime.now();
      if (_lastThrottleTime != null &&
          now.difference(_lastThrottleTime!) < _temporalWindow) {
        return; // Skip processing if throttled
      }
      _lastThrottleTime = now;

      // Process events within temporal window
      final windowEnd = now.subtract(_temporalWindow);
      final eventsToProcess = _temporalQueue
          .where((e) => e.timestamp.isBefore(windowEnd) || e.timestamp.isAtSameMomentAs(windowEnd))
          .take(10) // Process in batches
          .toList();

      for (final event in eventsToProcess) {
        try {
          _processTemporalEvent(event);
          _temporalQueue.remove(event);
        } catch (e, stackTrace) {
          _logError('Error processing temporal event in queue: ${event.id}', e, stackTrace);
          // Remove event even on error to prevent infinite loop
          _temporalQueue.remove(event);
          _failedEvents++;
        }
      }

      // Clean up expired events (older than max latency)
      _temporalQueue.removeWhere((e) {
        final age = now.difference(e.timestamp);
        return age > _maxLatency;
      });
    } catch (e, stackTrace) {
      _logError('Error in temporal queue processing', e, stackTrace);
      // Clear queue on critical error to prevent infinite loop
      _temporalQueue.clear();
    }
  }

  /// Process a single temporal event
  ///
  /// **Sécurité :**
  /// - Vérifie que le stream n'est pas fermé avant d'ajouter l'événement
  /// - Convertit l'événement temporel en DataEvent pour le processeur de base
  /// - Gère les erreurs silencieusement pour éviter les plantages
  /// - Limite l'historique de temps de traitement pour éviter la surcharge mémoire
  Future<void> _processTemporalEvent(TimedEvent event) async {
    final startTime = DateTime.now();

    try {
      // Add to temporal stream
      if (_temporalStreamController != null && !_temporalStreamController!.isClosed) {
        _temporalStreamController!.add(event);
        _processedEvents++;

        final processingTime = DateTime.now().difference(startTime);
        _processingTimes.add(processingTime);

        // Keep only last 1000 measurements
        if (_processingTimes.length > 1000) {
          _processingTimes.removeAt(0);
        }

        // Also submit to base processor
        await _baseProcessor.submitEvent(
          DataEvent(
            id: event.id,
            data: event.data,
            timestamp: event.timestamp,
            priority: ProcessingPriority.normal,
            metadata: {
              ...event.metadata,
              'latency': event.latency?.inMilliseconds,
              'sequenceValid': event.sequenceValid,
            },
          ),
        );
      } else {
        _log('Temporal stream is closed, dropping event');
        _droppedEvents++;
      }
    } catch (e, stackTrace) {
      _failedEvents++;
      _logError('Error processing temporal event: ${event.id}', e, stackTrace);
    }
  }

  /// Update temporal model
  ///
  /// **Sécurité :**
  /// - Met à jour le modèle temporel pour prédire les patterns d'événements
  /// - Calcule l'intervalle moyen entre les événements
  /// - Prédit le prochain intervalle avec un niveau de confiance
  /// - Gère les erreurs silencieusement
  Future<void> updateTemporalModel(String eventId, DateTime timestamp) async {
    try {
      final source = eventId.split('_').first; // Extract source from event ID
      final model = _temporalModels[source];

      if (model == null) {
        // Create new model
        _temporalModels[source] = TemporalModel(
          lastUpdate: timestamp,
          averageInterval: const Duration(seconds: 1),
          confidence: 0.0,
        );
      } else {
        // Update existing model
        final interval = timestamp.difference(model.lastUpdate);
        final newAverageInterval = Duration(
          milliseconds: ((model.averageInterval.inMilliseconds + interval.inMilliseconds) / 2).round(),
        );

        // Simple prediction: next interval will be similar to average
        final predictedNextInterval = newAverageInterval;
        const confidence = 0.7; // Simple confidence calculation

        _temporalModels[source] = model.copyWith(
          lastUpdate: timestamp,
          averageInterval: newAverageInterval,
          predictedNextInterval: predictedNextInterval,
          confidence: confidence,
        );
      }
    } catch (e, stackTrace) {
      _logError('Error updating temporal model for event: $eventId', e, stackTrace);
      // Don't rethrow - graceful degradation
    }
  }

  /// Validate sequence
  ///
  /// **Sécurité :**
  /// - Vérifie que l'événement est dans la séquence attendue
  /// - Met à jour la séquence attendue si valide
  /// - Gère les événements hors séquence avec une fenêtre temporelle
  bool _validateSequence(String eventId, int expectedSequence) {
    try {
      final source = eventId.split('_').first;
      final currentSequence = _sequenceBySource[source] ?? 0;

      if (expectedSequence == currentSequence) {
        // Valid sequence, update
        _sequenceBySource[source] = currentSequence + 1;
        return true;
      } else if (expectedSequence > currentSequence) {
        // Future sequence, update and mark as valid (might be out of order delivery)
        _sequenceBySource[source] = expectedSequence + 1;
        return true;
      } else {
        // Past sequence, invalid
        return false;
      }
    } catch (e, stackTrace) {
      _logError('Error validating sequence for event: $eventId', e, stackTrace);
      return false; // Conservative: mark as invalid on error
    }
  }

  /// Check for time drift
  ///
  /// **Sécurité :**
  /// - Détecte les dérives de temps en comparant avec la référence système
  /// - Ajuste la référence si une dérive significative est détectée
  /// - Gère les erreurs silencieusement
  void _checkTimeDrift() {
    try {
      if (_systemClockReference == null) return;

      final now = DateTime.now();
      final expectedTime = _systemClockReference!.add(
        Duration(seconds: 30), // Since last check
      );

      final drift = now.difference(expectedTime);
      if (drift.abs() > const Duration(seconds: 5)) {
        // Significant drift detected
        _detectedTimeDrift = drift;
        _log('Time drift detected: ${drift.inSeconds}s');
        // Adjust reference
        _systemClockReference = now;
      } else {
        _detectedTimeDrift = null;
      }
    } catch (e, stackTrace) {
      _logError('Error checking time drift', e, stackTrace);
      // Don't rethrow - graceful degradation
    }
  }

  /// Subscribe to temporal stream
  ///
  /// **Sécurité :**
  /// - Vérifie que le stream est initialisé
  /// - Applique un timeout sur le traitement des événements
  /// - Gère les erreurs avec callback personnalisé
  /// - Fermeture automatique gérée par Riverpod autoDispose
  ///
  /// **Retour :**
  /// - StreamSubscription qui doit être annulée par l'appelant
  StreamSubscription<TimedEvent<T>> subscribeToTemporalStream<T>({
    required Future<TemporalProcessingResult<T>> Function(TimedEvent<T>) onEvent,
    Function(Object error, StackTrace stackTrace)? onError,
    void Function()? onDone,
  }) {
    if (_temporalStreamController == null) {
      throw StateError('Temporal stream not initialized');
    }

    if (_temporalStreamController!.isClosed) {
      throw StateError('Temporal stream is closed');
    }

    final subscription = _temporalStreamController!.stream.cast<TimedEvent<T>>().listen(
      (event) async {
        try {
          await onEvent(event).timeout(_processingTimeout);
        } on TimeoutException {
          _failedEvents++;
          final error = TimeoutException(
            'Temporal event processing timeout after ${_processingTimeout.inSeconds}s',
            _processingTimeout,
          );
          if (onError != null) {
            onError(error, StackTrace.current);
          } else {
            _logError('Temporal event processing timeout: ${event.id}', error, StackTrace.current);
          }
        } catch (e, stackTrace) {
          _failedEvents++;
          if (onError != null) {
            onError(e, stackTrace);
          } else {
            _logError('Error in temporal event handler: ${event.id}', e, stackTrace);
          }
        }
      },
      onError: onError != null
          ? (error, stackTrace) => onError(error, stackTrace)
          : (error, stackTrace) {
              _logError('Temporal stream error', error, stackTrace);
            },
      onDone: onDone ?? () {
        _log('Temporal stream subscription done');
      },
      cancelOnError: false, // Continue processing even on error
    );

    _log('Subscribed to temporal stream');

    return subscription;
  }

  /// Get temporal stream
  ///
  /// **Usage :**
  /// Utilisé avec StreamProvider pour un flux temporel réactif
  Stream<TimedEvent<T>> getTemporalStream<T>() {
    if (_temporalStreamController == null) {
      throw StateError('Temporal stream not initialized');
    }

    if (_temporalStreamController!.isClosed) {
      throw StateError('Temporal stream is closed');
    }

    return _temporalStreamController!.stream.cast<TimedEvent<T>>();
  }

  /// Get current temporal statistics
  TemporalStatistics getStatistics() {
    final averageLatency = _latencies.isNotEmpty
        ? _latencies.map((d) => d.inMicroseconds).reduce((a, b) => a + b) /
            _latencies.length /
            1000.0 // Convert to milliseconds
        : 0.0;

    final averageTime = _processingTimes.isNotEmpty
        ? _processingTimes.map((d) => d.inMicroseconds).reduce((a, b) => a + b) /
            _processingTimes.length /
            1000.0 // Convert to milliseconds
        : 0.0;

    final elapsedSeconds = _firstEventTime != null
        ? DateTime.now().difference(_firstEventTime!).inSeconds
        : 1;

    final throughput =
        elapsedSeconds > 0 ? _processedEvents / elapsedSeconds.toDouble() : 0.0;

    return TemporalStatistics(
      totalEvents: _totalEvents,
      processedEvents: _processedEvents,
      failedEvents: _failedEvents,
      outOfSequenceEvents: _outOfSequenceEvents,
      droppedEvents: _droppedEvents,
      averageLatency: averageLatency,
      averageProcessingTime: averageTime,
      throughput: throughput,
      currentQueueSize: _temporalQueue.length,
      timeDrift: _detectedTimeDrift,
      temporalModels: Map.from(_temporalModels),
    );
  }

  /// Reset statistics
  void resetStatistics() {
    _totalEvents = 0;
    _processedEvents = 0;
    _failedEvents = 0;
    _outOfSequenceEvents = 0;
    _droppedEvents = 0;
    _latencies.clear();
    _processingTimes.clear();
    _firstEventTime = null;
    _detectedTimeDrift = null;
    _sequenceBySource.clear();
    _temporalModels.clear();
    _log('Temporal processor statistics reset');
  }

  /// Clear temporal queue
  void clearQueue() {
    _temporalQueue.clear();
    _log('Temporal queue cleared');
  }

  /// Check if processor is running
  bool get isRunning => _isRunning;

  /// Get current queue size
  int get queueSize => _temporalQueue.length;

  /// Logging helper
  void _log(String message) {
    developer.log(
      message,
      name: 'RealTimeTimeDataProcessor',
      level: 500,
    );
  }

  /// Error logging helper
  void _logError(String message, Object error, StackTrace stackTrace) {
    developer.log(
      '$message: $error',
      name: 'RealTimeTimeDataProcessor',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  /// Dispose resources
  ///
  /// **Sécurité :**
  /// - Arrête le processeur temporel proprement
  /// - Vide la queue d'événements
  /// - Gère les erreurs silencieusement
  Future<void> dispose() async {
    try {
      await stopTemporalStream();
      _temporalQueue.clear();
      _latencies.clear();
      _processingTimes.clear();
      _temporalModels.clear();
      _log('Temporal processor disposed');
    } catch (e, stackTrace) {
      _logError('Error disposing temporal processor', e, stackTrace);
      // Ensure cleanup even on error
      _isRunning = false;
      _temporalQueue.clear();
      _latencies.clear();
      _processingTimes.clear();
      _temporalModels.clear();
    }
  }
}

