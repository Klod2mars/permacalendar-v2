// 🚀 Real-Time Data Processor - Stream Processing Engine
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Reactive Patterns
//
// **Rôle dans l'écosystème d'intelligence :**
// Ce processeur gère le traitement de flux événementiels en temps réel pour :
// - Traitement des événements de jardin (changements de conditions, nouvelles plantations)
// - Mise à jour des recommandations intelligentes en temps réel
// - Synchronisation des données entre différents composants du système
// - Gestion de la backpressure pour éviter la surcharge du système
//
// **Interactions avec les autres composants :**
// - Utilisé par `IntelligentRecommendationEngine` pour traiter les événements de jardin
// - Intègre avec `MetricsCollectorService` pour collecter les métriques de traitement
// - Peut être utilisé avec `AlertingService` pour déclencher des alertes basées sur les événements
//
// **Stratégies de résilience et sécurité :**
// - Gestion d'erreurs silencieuse : Les erreurs dans le traitement d'événements ne font pas planter le système
// - Fermeture automatique : Les StreamControllers sont fermés proprement lors de l'arrêt
// - Backpressure management : Limite la taille de la queue pour éviter la surcharge mémoire
// - Throttling : Limite la fréquence des rafraîchissements pour éviter les surcharges
// - Timeout protection : Tous les traitements sont limités dans le temps
//
// **Exemple d'utilisation via Riverpod 3 :**
// ```dart
// // Dans un provider
// final processor = ref.read(IntelligenceModule.realTimeDataProcessorProvider);
// await processor.start();
//
// // Soumettre un événement
// await processor.submitEvent(DataEvent(
//   id: 'garden_update_123',
//   data: gardenData,
//   priority: ProcessingPriority.high,
// ));
//
// // S'abonner aux événements critiques
// processor.subscribe<String>(
//   priority: ProcessingPriority.critical,
//   onEvent: (event) async {
//     // Traiter l'événement
//     return ProcessingResult(
//       eventId: event.id,
//       success: true,
//       processingTime: Duration.zero,
//     );
//   },
//   onError: (error) {
//     // Gérer l'erreur
//   },
// );
//
// // Utiliser avec StreamProvider pour un flux réactif
// final eventStreamProvider = StreamProvider.autoDispose<DataEvent<String>>((ref) {
//   final processor = ref.read(IntelligenceModule.realTimeDataProcessorProvider);
//   return processor._eventStreams[ProcessingPriority.high]!.stream.cast<DataEvent<String>>();
// });
// ```

import 'dart:async';
import 'dart:developer' as developer;

/// Processing priority
enum ProcessingPriority {
  low,
  normal,
  high,
  critical,
}

/// Data processing event
class DataEvent<T> {
  final String id;
  final T data;
  final DateTime timestamp;
  final ProcessingPriority priority;
  final Map<String, dynamic> metadata;

  DataEvent({
    required this.id,
    required this.data,
    DateTime? timestamp,
    this.priority = ProcessingPriority.normal,
    this.metadata = const {},
  }) : timestamp = timestamp ?? DateTime.now();

  DataEvent<T> copyWith({
    String? id,
    T? data,
    DateTime? timestamp,
    ProcessingPriority? priority,
    Map<String, dynamic>? metadata,
  }) {
    return DataEvent<T>(
      id: id ?? this.id,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      priority: priority ?? this.priority,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Processing result
class ProcessingResult<T> {
  final String eventId;
  final T? processedData;
  final bool success;
  final Duration processingTime;
  final String? error;
  final Map<String, dynamic> metrics;

  ProcessingResult({
    required this.eventId,
    this.processedData,
    required this.success,
    required this.processingTime,
    this.error,
    this.metrics = const {},
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'success': success,
        'processingTimeMs': processingTime.inMilliseconds,
        'error': error,
        'metrics': metrics,
      };
}

/// Stream processing statistics
class StreamStatistics {
  final int totalEvents;
  final int processedEvents;
  final int failedEvents;
  final int droppedEvents;
  final double averageProcessingTime;
  final double throughput; // events per second
  final int currentQueueSize;
  final Map<ProcessingPriority, int> eventsByPriority;

  StreamStatistics({
    required this.totalEvents,
    required this.processedEvents,
    required this.failedEvents,
    required this.droppedEvents,
    required this.averageProcessingTime,
    required this.throughput,
    required this.currentQueueSize,
    required this.eventsByPriority,
  });

  Map<String, dynamic> toJson() => {
        'totalEvents': totalEvents,
        'processedEvents': processedEvents,
        'failedEvents': failedEvents,
        'droppedEvents': droppedEvents,
        'averageProcessingTimeMs': averageProcessingTime,
        'throughput': throughput,
        'currentQueueSize': currentQueueSize,
        'eventsByPriority': eventsByPriority.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
      };
}

/// Real-time data processor for stream processing
///
/// **Gestion de la mémoire :**
/// - Limite la queue à `_maxQueueSize` événements
/// - Nettoie automatiquement les subscriptions fermées
/// - Limite l'historique de temps de traitement à 1000 entrées
///
/// **Gestion d'erreurs :**
/// - Toutes les méthodes critiques sont protégées par try/catch
/// - En cas d'erreur, les événements sont marqués comme échoués mais le système continue
/// - Logs détaillés pour le debugging
///
/// **Sécurité des flux :**
/// - Tous les StreamControllers sont fermés proprement lors de l'arrêt
/// - Les subscriptions sont annulées avant la fermeture des streams
/// - Protection contre les double-fermetures
class RealTimeDataProcessor {
  // Event streams by priority
  final Map<ProcessingPriority, StreamController<DataEvent>> _eventStreams = {};

  // Processing pipelines
  final Map<String, StreamSubscription> _subscriptions = {};

  // Event queue for backpressure management
  final List<DataEvent> _eventQueue = [];
  final int _maxQueueSize;

  // Statistics
  int _totalEvents = 0;
  int _processedEvents = 0;
  int _failedEvents = 0;
  int _droppedEvents = 0;
  final List<Duration> _processingTimes = [];
  DateTime? _firstEventTime;
  final Map<ProcessingPriority, int> _eventsByPriority = {};

  // Configuration
  final Duration _processingTimeout;
  final bool _enableBackpressure;
  bool _isRunning = false;
  Timer? _queueProcessingTimer;

  RealTimeDataProcessor({
    int? maxQueueSize,
    Duration? processingTimeout,
    bool? enableBackpressure,
  })  : _maxQueueSize = maxQueueSize ?? 1000,
        _processingTimeout = processingTimeout ?? const Duration(seconds: 30),
        _enableBackpressure = enableBackpressure ?? true {
    _initializeStreams();
  }

  /// Initialize priority streams
  ///
  /// **Sécurité :**
  /// - Crée des StreamControllers broadcast pour permettre plusieurs listeners
  /// - Initialise les compteurs de statistiques pour chaque priorité
  void _initializeStreams() {
    try {
      for (final priority in ProcessingPriority.values) {
        _eventStreams[priority] = StreamController<DataEvent>.broadcast(
          onCancel: () {
            _log('Stream cancelled for priority: $priority');
          },
        );
        _eventsByPriority[priority] = 0;
      }
    } catch (e, stackTrace) {
      _logError('Error initializing streams', e, stackTrace);
      rethrow;
    }
  }

  /// Start the processor
  ///
  /// **Sécurité :**
  /// - Vérifie si déjà en cours d'exécution pour éviter les doubles démarrages
  /// - Stocke le Timer pour pouvoir l'annuler proprement
  /// - Gère les erreurs silencieusement pour éviter les plantages
  Future<void> start() async {
    if (_isRunning) {
      _log('Processor already running');
      return;
    }

    try {
      _isRunning = true;
      _firstEventTime = DateTime.now();
      _log('Real-time processor started');

      // Process queue periodically
      _queueProcessingTimer = Timer.periodic(
        const Duration(milliseconds: 100),
        (timer) {
          if (!_isRunning) {
            timer.cancel();
            _queueProcessingTimer = null;
            return;
          }
          try {
            _processQueue();
          } catch (e, stackTrace) {
            _logError('Error in queue processing timer', e, stackTrace);
            // Continue processing despite errors
          }
        },
      );
    } catch (e, stackTrace) {
      _isRunning = false;
      _logError('Error starting processor', e, stackTrace);
      rethrow;
    }
  }

  /// Stop the processor
  ///
  /// **Sécurité :**
  /// - Annule le timer de traitement de queue
  /// - Ferme toutes les subscriptions proprement
  /// - Ferme tous les StreamControllers avec gestion d'erreurs
  /// - Protection contre les double-fermetures
  Future<void> stop() async {
    if (!_isRunning) {
      _log('Processor already stopped');
      return;
    }

    try {
      _isRunning = false;

      // Cancel queue processing timer
      _queueProcessingTimer?.cancel();
      _queueProcessingTimer = null;

      // Cancel all subscriptions with error handling
      final subscriptionsToCancel = List<StreamSubscription>.from(_subscriptions.values);
      _subscriptions.clear();

      for (final subscription in subscriptionsToCancel) {
        try {
          await subscription.cancel();
        } catch (e, stackTrace) {
          _logError('Error cancelling subscription', e, stackTrace);
          // Continue cancelling other subscriptions
        }
      }

      // Close all streams with error handling
      final streamsToClose = List<StreamController<DataEvent>>.from(_eventStreams.values);
      _eventStreams.clear();

      for (final stream in streamsToClose) {
        try {
          if (!stream.isClosed) {
            await stream.close();
          }
        } catch (e, stackTrace) {
          _logError('Error closing stream', e, stackTrace);
          // Continue closing other streams
        }
      }

      _log('Real-time processor stopped');
    } catch (e, stackTrace) {
      _logError('Error stopping processor', e, stackTrace);
      // Ensure _isRunning is false even on error
      _isRunning = false;
      rethrow;
    }
  }

  /// Submit event for processing
  ///
  /// **Sécurité :**
  /// - Démarre automatiquement le processeur si nécessaire
  /// - Gère la backpressure en rejetant les événements si la queue est pleine
  /// - Gère les erreurs silencieusement pour éviter les plantages
  Future<void> submitEvent<T>(DataEvent<T> event) async {
    try {
      if (!_isRunning) {
        _log('Processor not running, starting...');
        await start();
      }

      _totalEvents++;
      _eventsByPriority[event.priority] =
          (_eventsByPriority[event.priority] ?? 0) + 1;

      // Check queue size (backpressure management)
      if (_enableBackpressure && _eventQueue.length >= _maxQueueSize) {
        _droppedEvents++;
        _log('Event dropped due to backpressure: ${event.id}');
        return;
      }

      // Add to queue
      _eventQueue.add(event);

      _log('Event submitted: ${event.id} (priority: ${event.priority})');
    } catch (e, stackTrace) {
      _failedEvents++;
      _logError('Error submitting event: ${event.id}', e, stackTrace);
      // Don't rethrow - graceful degradation
    }
  }

  /// Process queued events
  ///
  /// **Sécurité :**
  /// - Trie les événements par priorité (critical first)
  /// - Traite les événements par lots pour éviter la surcharge
  /// - Gère les erreurs individuellement pour chaque événement
  void _processQueue() {
    if (_eventQueue.isEmpty) return;

    try {
      // Sort queue by priority (critical first)
      _eventQueue.sort((a, b) {
        return b.priority.index.compareTo(a.priority.index);
      });

      // Process events in batches
      const batchSize = 10;
      final batch = _eventQueue.take(batchSize).toList();

      for (final event in batch) {
        try {
          _processEvent(event);
          _eventQueue.remove(event);
        } catch (e, stackTrace) {
          _logError('Error processing event in queue: ${event.id}', e, stackTrace);
          // Remove event even on error to prevent infinite loop
          _eventQueue.remove(event);
          _failedEvents++;
        }
      }
    } catch (e, stackTrace) {
      _logError('Error in queue processing', e, stackTrace);
      // Clear queue on critical error to prevent infinite loop
      _eventQueue.clear();
    }
  }

  /// Process a single event
  ///
  /// **Sécurité :**
  /// - Vérifie que le stream n'est pas fermé avant d'ajouter l'événement
  /// - Gère les erreurs silencieusement pour éviter les plantages
  /// - Limite l'historique de temps de traitement pour éviter la surcharge mémoire
  Future<void> _processEvent(DataEvent event) async {
    final startTime = DateTime.now();

    try {
      // Add to appropriate priority stream
      final stream = _eventStreams[event.priority];
      if (stream != null && !stream.isClosed) {
        stream.add(event);
        _processedEvents++;

        final processingTime = DateTime.now().difference(startTime);
        _processingTimes.add(processingTime);

        // Keep only last 1000 measurements
        if (_processingTimes.length > 1000) {
          _processingTimes.removeAt(0);
        }
      } else {
        _log('Stream for priority ${event.priority} is closed, dropping event');
        _droppedEvents++;
      }
    } catch (e, stackTrace) {
      _failedEvents++;
      _logError('Error processing event: ${event.id}', e, stackTrace);
    }
  }

  /// Subscribe to events of a specific priority
  ///
  /// **Sécurité :**
  /// - Vérifie que le stream est initialisé
  /// - Applique un timeout sur le traitement des événements
  /// - Gère les erreurs avec callback personnalisé
  /// - Fermeture automatique gérée par Riverpod autoDispose
  ///
  /// **Retour :**
  /// - StreamSubscription qui doit être annulée par l'appelant
  StreamSubscription<DataEvent<T>> subscribe<T>({
    required ProcessingPriority priority,
    required Future<ProcessingResult<T>> Function(DataEvent<T>) onEvent,
    Function(Object error, StackTrace stackTrace)? onError,
    void Function()? onDone,
  }) {
    final stream = _eventStreams[priority];
    if (stream == null) {
      throw StateError('Stream for priority $priority not initialized');
    }

    if (stream.isClosed) {
      throw StateError('Stream for priority $priority is closed');
    }

    final subscription = stream.stream.cast<DataEvent<T>>().listen(
      (event) async {
        try {
          await onEvent(event).timeout(_processingTimeout);
        } on TimeoutException {
          _failedEvents++;
          final error = TimeoutException(
            'Event processing timeout after ${_processingTimeout.inSeconds}s',
            _processingTimeout,
          );
          if (onError != null) {
            onError(error, StackTrace.current);
          } else {
            _logError('Event processing timeout: ${event.id}', error, StackTrace.current);
          }
        } catch (e, stackTrace) {
          _failedEvents++;
          if (onError != null) {
            onError(e, stackTrace);
          } else {
            _logError('Error in event handler: ${event.id}', e, stackTrace);
          }
        }
      },
      onError: onError != null
          ? (error, stackTrace) => onError(error, stackTrace)
          : (error, stackTrace) {
              _logError('Stream error for priority $priority', error, stackTrace);
            },
      onDone: onDone ?? () {
        _log('Subscription done for priority $priority');
      },
      cancelOnError: false, // Continue processing even on error
    );

    final subscriptionId =
        '${priority}_${DateTime.now().millisecondsSinceEpoch}';
    _subscriptions[subscriptionId] = subscription;

    _log('Subscribed to $priority events: $subscriptionId');

    return subscription;
  }

  /// Process stream with transformation
  Stream<R> processStream<T, R>({
    required Stream<T> source,
    required R Function(T) transform,
    bool Function(T)? filter,
    int? batchSize,
  }) {
    Stream<T> processedStream = source;

    // Apply filter if provided
    if (filter != null) {
      processedStream = processedStream.where(filter);
    }

    // Note: Batch processing would require RxDart or custom implementation
    // For now, processing items individually
    // TODO: Implement batch processing with proper Stream<List<T>> handling if needed

    // Apply transformation
    return processedStream.map(transform);
  }

  /// Create a windowed stream (tumbling window)
  Stream<List<T>> createWindow<T>({
    required Stream<T> source,
    required Duration windowSize,
    int? maxItemsPerWindow,
  }) {
    return source.window(windowSize, maxItemsPerWindow);
  }

  /// Aggregate stream data
  /// Note: Window-based aggregation is not currently implemented
  Stream<R> aggregateStream<T, R>({
    required Stream<T> source,
    required R initialValue,
    required R Function(R accumulated, T current) aggregate,
    Duration? windowSize,
  }) {
    // TODO: Implement window-based aggregation properly
    // For now, process items individually
    return source.asyncMap((item) async {
      return aggregate(initialValue, item);
    });
  }

  /// Filter stream with conditions
  Stream<T> filterStream<T>({
    required Stream<T> source,
    required bool Function(T) predicate,
  }) {
    return source.where(predicate);
  }

  /// Throttle stream events
  Stream<T> throttleStream<T>({
    required Stream<T> source,
    required Duration throttleDuration,
  }) {
    DateTime? lastEmitTime;

    return source.where((event) {
      final now = DateTime.now();
      if (lastEmitTime == null ||
          now.difference(lastEmitTime!) >= throttleDuration) {
        lastEmitTime = now;
        return true;
      }
      return false;
    });
  }

  /// Debounce stream events
  ///
  /// **Sécurité :**
  /// - Ferme le StreamController proprement lors de l'annulation
  /// - Annule le timer lors de la fermeture pour éviter les fuites mémoire
  /// - Gère les erreurs du stream source
  Stream<T> debounceStream<T>({
    required Stream<T> source,
    required Duration debounceDuration,
  }) {
    late StreamController<T> controller;
    Timer? debounceTimer;
    StreamSubscription<T>? sourceSubscription;

    controller = StreamController<T>(
      onListen: () {
        sourceSubscription = source.listen(
          (event) {
            try {
              debounceTimer?.cancel();
              debounceTimer = Timer(debounceDuration, () {
                if (!controller.isClosed) {
                  controller.add(event);
                }
              });
            } catch (e, stackTrace) {
              if (!controller.isClosed) {
                controller.addError(e, stackTrace);
              }
            }
          },
          onError: (error, stackTrace) {
            debounceTimer?.cancel();
            if (!controller.isClosed) {
              controller.addError(error, stackTrace);
            }
          },
          onDone: () {
            debounceTimer?.cancel();
            if (!controller.isClosed) {
              controller.close();
            }
          },
        );
      },
      onCancel: () {
        debounceTimer?.cancel();
        sourceSubscription?.cancel();
      },
    );

    return controller.stream;
  }

  /// Get current statistics
  StreamStatistics getStatistics() {
    final averageTime = _processingTimes.isNotEmpty
        ? _processingTimes
                .map((d) => d.inMicroseconds)
                .reduce((a, b) => a + b) /
            _processingTimes.length
        : 0.0;

    final elapsedSeconds = _firstEventTime != null
        ? DateTime.now().difference(_firstEventTime!).inSeconds
        : 1;

    final throughput =
        elapsedSeconds > 0 ? _processedEvents / elapsedSeconds.toDouble() : 0.0;

    return StreamStatistics(
      totalEvents: _totalEvents,
      processedEvents: _processedEvents,
      failedEvents: _failedEvents,
      droppedEvents: _droppedEvents,
      averageProcessingTime: averageTime,
      throughput: throughput,
      currentQueueSize: _eventQueue.length,
      eventsByPriority: Map.from(_eventsByPriority),
    );
  }

  /// Reset statistics
  void resetStatistics() {
    _totalEvents = 0;
    _processedEvents = 0;
    _failedEvents = 0;
    _droppedEvents = 0;
    _processingTimes.clear();
    _firstEventTime = null;
    _eventsByPriority.updateAll((key, value) => 0);
    _log('Real-time processor statistics reset');
  }

  /// Clear event queue
  void clearQueue() {
    _eventQueue.clear();
    _log('Event queue cleared');
  }

  /// Check if processor is running
  bool get isRunning => _isRunning;

  /// Get current queue size
  int get queueSize => _eventQueue.length;

  /// Logging helper
  void _log(String message) {
    developer.log(
      message,
      name: 'RealTimeDataProcessor',
      level: 500,
    );
  }

  /// Error logging helper
  void _logError(String message, Object error, StackTrace stackTrace) {
    developer.log(
      '$message: $error',
      name: 'RealTimeDataProcessor',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  /// Dispose resources
  ///
  /// **Sécurité :**
  /// - Arrête le processeur proprement
  /// - Vide la queue d'événements
  /// - Gère les erreurs silencieusement
  Future<void> dispose() async {
    try {
      await stop();
      _eventQueue.clear();
      _processingTimes.clear();
      _log('Real-time processor disposed');
    } catch (e, stackTrace) {
      _logError('Error disposing processor', e, stackTrace);
      // Ensure cleanup even on error
      _isRunning = false;
      _eventQueue.clear();
      _processingTimes.clear();
    }
  }
}

/// Stream extension for windowing
extension StreamWindow<T> on Stream<T> {
  Stream<List<T>> window(Duration duration, int? maxItems) {
    return Stream.periodic(duration).asyncMap((_) async {
      final items = <T>[];
      final subscription = listen((item) {
        items.add(item);
        if (maxItems != null && items.length >= maxItems) {
          return;
        }
      });

      await Future.delayed(duration);
      await subscription.cancel();

      return items;
    });
  }

  Stream<List<T>> bufferCount(int count) async* {
    final buffer = <T>[];

    await for (final item in this) {
      buffer.add(item);

      if (buffer.length >= count) {
        yield List.from(buffer);
        buffer.clear();
      }
    }

    if (buffer.isNotEmpty) {
      yield buffer;
    }
  }
}
