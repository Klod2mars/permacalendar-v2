// 🚀 Real-Time Data Processor - Stream Processing Engine
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Reactive Patterns

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
  void _initializeStreams() {
    for (final priority in ProcessingPriority.values) {
      _eventStreams[priority] = StreamController<DataEvent>.broadcast();
      _eventsByPriority[priority] = 0;
    }
  }

  /// Start the processor
  Future<void> start() async {
    if (_isRunning) return;

    _isRunning = true;
    _firstEventTime = DateTime.now();
    _log('Real-time processor started');

    // Process queue periodically
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isRunning) {
        timer.cancel();
        return;
      }
      _processQueue();
    });
  }

  /// Stop the processor
  Future<void> stop() async {
    if (!_isRunning) return;

    _isRunning = false;

    // Cancel all subscriptions
    for (final subscription in _subscriptions.values) {
      await subscription.cancel();
    }
    _subscriptions.clear();

    // Close all streams
    for (final stream in _eventStreams.values) {
      await stream.close();
    }
    _eventStreams.clear();

    _log('Real-time processor stopped');
  }

  /// Submit event for processing
  Future<void> submitEvent<T>(DataEvent<T> event) async {
    if (!_isRunning) {
      _log('Processor not running, starting...');
      await start();
    }

    _totalEvents++;
    _eventsByPriority[event.priority] =
        (_eventsByPriority[event.priority] ?? 0) + 1;

    // Check queue size
    if (_enableBackpressure && _eventQueue.length >= _maxQueueSize) {
      _droppedEvents++;
      _log('Event dropped due to backpressure: ${event.id}');
      return;
    }

    // Add to queue
    _eventQueue.add(event);

    _log('Event submitted: ${event.id} (priority: ${event.priority})');
  }

  /// Process queued events
  void _processQueue() {
    if (_eventQueue.isEmpty) return;

    // Sort queue by priority (critical first)
    _eventQueue.sort((a, b) {
      return b.priority.index.compareTo(a.priority.index);
    });

    // Process events in batches
    const batchSize = 10;
    final batch = _eventQueue.take(batchSize).toList();

    for (final event in batch) {
      _processEvent(event);
      _eventQueue.remove(event);
    }
  }

  /// Process a single event
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
      }
    } catch (e, stackTrace) {
      _failedEvents++;
      _logError('Error processing event: ${event.id}', e, stackTrace);
    }
  }

  /// Subscribe to events of a specific priority
  StreamSubscription<DataEvent<T>> subscribe<T>({
    required ProcessingPriority priority,
    required Future<ProcessingResult<T>> Function(DataEvent<T>) onEvent,
    Function(Object error)? onError,
  }) {
    final stream = _eventStreams[priority];
    if (stream == null) {
      throw StateError('Stream for priority $priority not initialized');
    }

    final subscription = stream.stream.cast<DataEvent<T>>().listen(
      (event) async {
        try {
          await onEvent(event).timeout(_processingTimeout);
        } catch (e) {
          if (onError != null) {
            onError(e);
          }
          _failedEvents++;
        }
      },
      onError: onError,
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
  Stream<T> debounceStream<T>({
    required Stream<T> source,
    required Duration debounceDuration,
  }) {
    late StreamController<T> controller;
    Timer? debounceTimer;

    controller = StreamController<T>(
      onListen: () {
        source.listen(
          (event) {
            debounceTimer?.cancel();
            debounceTimer = Timer(debounceDuration, () {
              controller.add(event);
            });
          },
          onError: (error, stackTrace) =>
              controller.addError(error, stackTrace),
          onDone: () {
            debounceTimer?.cancel();
            controller.close();
          },
        );
      },
      onCancel: () {
        debounceTimer?.cancel();
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
  Future<void> dispose() async {
    await stop();
    _eventQueue.clear();
    _log('Real-time processor disposed');
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


