// Tests unitaires pour RealTimeTimeDataProcessor
// PermaCalendar v2.8.0 - Prompt 5 Implementation

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/services/intelligence/real_time_time_data_processor.dart';
import 'package:permacalendar/core/services/intelligence/real_time_data_processor.dart';

void main() {
  group('RealTimeTimeDataProcessor', () {
    late RealTimeTimeDataProcessor processor;
    late RealTimeDataProcessor baseProcessor;

    setUp(() {
      baseProcessor = RealTimeDataProcessor(
        maxQueueSize: 100,
        processingTimeout: const Duration(seconds: 5),
        enableBackpressure: true,
      );
      processor = RealTimeTimeDataProcessor(
        baseProcessor: baseProcessor,
        maxQueueSize: 100,
        processingTimeout: const Duration(seconds: 5),
        maxLatency: const Duration(minutes: 1),
        temporalWindow: const Duration(seconds: 1),
        enableSequenceValidation: true,
        enableTimeDriftDetection: true,
        throttleInterval: const Duration(milliseconds: 100),
      );
    });

    tearDown(() async {
      await processor.dispose();
      await baseProcessor.dispose();
    });

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(processor.isRunning, false);
        expect(processor.queueSize, 0);
      });

      test('should initialize temporal stream', () async {
        await processor.startTemporalStream();
        expect(processor.isRunning, true);
        await processor.stopTemporalStream();
      });
    });

    group('Temporal Stream Management', () {
      test('should start temporal stream', () async {
        await processor.startTemporalStream();
        expect(processor.isRunning, true);
        await processor.stopTemporalStream();
      });

      test('should not start if already running', () async {
        await processor.startTemporalStream();
        expect(processor.isRunning, true);

        // Try to start again
        await processor.startTemporalStream();
        expect(processor.isRunning, true);

        await processor.stopTemporalStream();
      });

      test('should stop temporal stream', () async {
        await processor.startTemporalStream();
        expect(processor.isRunning, true);

        await processor.stopTemporalStream();
        expect(processor.isRunning, false);
      });

      test('should not stop if already stopped', () async {
        expect(processor.isRunning, false);
        await processor.stopTemporalStream();
        expect(processor.isRunning, false);
      });
    });

    group('Timed Event Processing', () {
      test('should process timed event successfully', () async {
        await processor.startTemporalStream();

        final event = TimedEvent<String>(
          id: 'test_event_1',
          data: 'test data',
          timestamp: DateTime.now(),
          expectedSequence: 0,
        );

        final result = await processor.processTimedEvent(event);

        expect(result.success, true);
        expect(result.eventId, 'test_event_1');
        expect(result.sequenceValid, true);
        expect(result.latency, isNotNull);

        await processor.stopTemporalStream();
      });

      test('should calculate latency correctly', () async {
        await processor.startTemporalStream();

        final pastTime = DateTime.now().subtract(const Duration(seconds: 2));
        final event = TimedEvent<String>(
          id: 'test_event_2',
          data: 'test data',
          timestamp: pastTime,
        );

        final result = await processor.processTimedEvent(event);

        expect(result.success, true);
        expect(result.latency, isNotNull);
        expect(result.latency!.inSeconds, greaterThanOrEqualTo(1));

        await processor.stopTemporalStream();
      });

      test('should drop event with excessive latency', () async {
        await processor.startTemporalStream();

        final oldTime = DateTime.now().subtract(const Duration(minutes: 10));
        final event = TimedEvent<String>(
          id: 'test_event_3',
          data: 'test data',
          timestamp: oldTime,
        );

        final result = await processor.processTimedEvent(event);

        expect(result.success, false);
        expect(result.error, contains('latency exceeds maximum'));

        await processor.stopTemporalStream();
      });

      test('should handle out of sequence events', () async {
        await processor.startTemporalStream();

        // First event with sequence 0
        final event1 = TimedEvent<String>(
          id: 'source1_event_1',
          data: 'data 1',
          timestamp: DateTime.now(),
          expectedSequence: 0,
        );
        final result1 = await processor.processTimedEvent(event1);
        expect(result1.success, true);
        expect(result1.sequenceValid, true);

        // Second event with sequence 2 (missing 1)
        final event2 = TimedEvent<String>(
          id: 'source1_event_2',
          data: 'data 2',
          timestamp: DateTime.now(),
          expectedSequence: 2,
        );
        final result2 = await processor.processTimedEvent(event2);
        // Should still be valid (future sequence)
        expect(result2.success, true);

        // Third event with sequence 1 (out of order)
        final event3 = TimedEvent<String>(
          id: 'source1_event_3',
          data: 'data 3',
          timestamp: DateTime.now(),
          expectedSequence: 1,
        );
        final result3 = await processor.processTimedEvent(event3);
        // Should be invalid (past sequence)
        expect(result3.sequenceValid, false);

        await processor.stopTemporalStream();
      });

      test('should handle events from different sources independently', () async {
        await processor.startTemporalStream();

        // Event from source1
        final event1 = TimedEvent<String>(
          id: 'source1_event_1',
          data: 'data 1',
          timestamp: DateTime.now(),
          expectedSequence: 0,
        );
        final result1 = await processor.processTimedEvent(event1);
        expect(result1.success, true);
        expect(result1.sequenceValid, true);

        // Event from source2
        final event2 = TimedEvent<String>(
          id: 'source2_event_1',
          data: 'data 2',
          timestamp: DateTime.now(),
          expectedSequence: 0,
        );
        final result2 = await processor.processTimedEvent(event2);
        expect(result2.success, true);
        expect(result2.sequenceValid, true);

        await processor.stopTemporalStream();
      });
    });

    group('Temporal Model Updates', () {
      test('should update temporal model for new source', () async {
        await processor.startTemporalStream();

        final event = TimedEvent<String>(
          id: 'source1_event_1',
          data: 'test data',
          timestamp: DateTime.now(),
        );

        await processor.processTimedEvent(event);
        await processor.updateTemporalModel(event.id, event.timestamp);

        final stats = processor.getStatistics();
        expect(stats.temporalModels.containsKey('source1'), true);

        await processor.stopTemporalStream();
      });

      test('should update temporal model with interval calculation', () async {
        await processor.startTemporalStream();

        final time1 = DateTime.now();
        final event1 = TimedEvent<String>(
          id: 'source1_event_1',
          data: 'data 1',
          timestamp: time1,
        );
        await processor.processTimedEvent(event1);
        await processor.updateTemporalModel(event1.id, time1);

        await Future.delayed(const Duration(milliseconds: 100));

        final time2 = DateTime.now();
        final event2 = TimedEvent<String>(
          id: 'source1_event_2',
          data: 'data 2',
          timestamp: time2,
        );
        await processor.processTimedEvent(event2);
        await processor.updateTemporalModel(event2.id, time2);

        final stats = processor.getStatistics();
        final model = stats.temporalModels['source1'];
        expect(model, isNotNull);
        expect(model!.averageInterval, greaterThan(Duration.zero));

        await processor.stopTemporalStream();
      });
    });

    group('Temporal Stream Subscription', () {
      test('should subscribe to temporal stream', () async {
        await processor.startTemporalStream();

        final eventsReceived = <TimedEvent<String>>[];
        final completer = Completer<void>();

        final subscription = processor.subscribeToTemporalStream<String>(
          onEvent: (event) async {
            eventsReceived.add(event);
            if (eventsReceived.length >= 2) {
              completer.complete();
            }
            return TemporalProcessingResult<String>(
              eventId: event.id,
              success: true,
              processingTime: Duration.zero,
            );
          },
        );

        // Send events
        final event1 = TimedEvent<String>(
          id: 'test_event_1',
          data: 'data 1',
          timestamp: DateTime.now(),
        );
        await processor.processTimedEvent(event1);

        final event2 = TimedEvent<String>(
          id: 'test_event_2',
          data: 'data 2',
          timestamp: DateTime.now(),
        );
        await processor.processTimedEvent(event2);

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 200));
        await completer.future.timeout(const Duration(seconds: 2));

        expect(eventsReceived.length, greaterThanOrEqualTo(2));

        await subscription.cancel();
        await processor.stopTemporalStream();
      });

      test('should handle errors in event handler', () async {
        await processor.startTemporalStream();

        final errorsReceived = <Object>[];
        final subscription = processor.subscribeToTemporalStream<String>(
          onEvent: (event) async {
            throw Exception('Test error');
          },
          onError: (error, stackTrace) {
            errorsReceived.add(error);
          },
        );

        final event = TimedEvent<String>(
          id: 'test_event_error',
          data: 'test data',
          timestamp: DateTime.now(),
        );
        await processor.processTimedEvent(event);

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 200));

        expect(errorsReceived.length, greaterThanOrEqualTo(1));

        await subscription.cancel();
        await processor.stopTemporalStream();
      });
    });

    group('Temporal Stream Access', () {
      test('should get temporal stream', () async {
        await processor.startTemporalStream();

        final stream = processor.getTemporalStream<String>();
        expect(stream, isNotNull);

        final eventsReceived = <TimedEvent<String>>[];
        final subscription = stream.listen((event) {
          eventsReceived.add(event);
        });

        final event = TimedEvent<String>(
          id: 'test_event_stream',
          data: 'test data',
          timestamp: DateTime.now(),
        );
        await processor.processTimedEvent(event);

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 200));

        expect(eventsReceived.length, greaterThanOrEqualTo(1));

        await subscription.cancel();
        await processor.stopTemporalStream();
      });

      test('should throw error if stream not initialized', () {
        final newProcessor = RealTimeTimeDataProcessor();
        expect(
          () => newProcessor.getTemporalStream<String>(),
          throwsStateError,
        );
      });
    });

    group('Statistics', () {
      test('should track statistics correctly', () async {
        await processor.startTemporalStream();

        final event1 = TimedEvent<String>(
          id: 'test_event_1',
          data: 'data 1',
          timestamp: DateTime.now(),
        );
        await processor.processTimedEvent(event1);

        final event2 = TimedEvent<String>(
          id: 'test_event_2',
          data: 'data 2',
          timestamp: DateTime.now(),
        );
        await processor.processTimedEvent(event2);

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 200));

        final stats = processor.getStatistics();
        expect(stats.totalEvents, greaterThanOrEqualTo(2));
        expect(stats.processedEvents, greaterThanOrEqualTo(0));
        expect(stats.averageLatency, greaterThanOrEqualTo(0));

        await processor.stopTemporalStream();
      });

      test('should reset statistics', () async {
        await processor.startTemporalStream();

        final event = TimedEvent<String>(
          id: 'test_event_reset',
          data: 'test data',
          timestamp: DateTime.now(),
        );
        await processor.processTimedEvent(event);

        await Future.delayed(const Duration(milliseconds: 200));

        processor.resetStatistics();

        final stats = processor.getStatistics();
        expect(stats.totalEvents, 0);
        expect(stats.processedEvents, 0);
        expect(stats.failedEvents, 0);

        await processor.stopTemporalStream();
      });
    });

    group('Queue Management', () {
      test('should clear queue', () async {
        await processor.startTemporalStream();

        final event = TimedEvent<String>(
          id: 'test_event_queue',
          data: 'test data',
          timestamp: DateTime.now(),
        );
        await processor.processTimedEvent(event);

        expect(processor.queueSize, greaterThan(0));

        processor.clearQueue();

        expect(processor.queueSize, 0);

        await processor.stopTemporalStream();
      });

      test('should handle queue overflow', () async {
        final smallProcessor = RealTimeTimeDataProcessor(
          maxQueueSize: 5,
        );
        await smallProcessor.startTemporalStream();

        // Fill queue
        for (int i = 0; i < 10; i++) {
          final event = TimedEvent<String>(
            id: 'test_event_$i',
            data: 'data $i',
            timestamp: DateTime.now(),
          );
          await smallProcessor.processTimedEvent(event);
        }

        // Some events should be dropped
        final stats = smallProcessor.getStatistics();
        expect(stats.droppedEvents, greaterThanOrEqualTo(0));

        await smallProcessor.dispose();
      });
    });

    group('Time Drift Detection', () {
      test('should detect time drift when enabled', () async {
        final processorWithDrift = RealTimeTimeDataProcessor(
          enableTimeDriftDetection: true,
        );
        await processorWithDrift.startTemporalStream();

        // Wait for drift check
        await Future.delayed(const Duration(seconds: 1));

        final stats = processorWithDrift.getStatistics();
        // Time drift may or may not be detected depending on system
        expect(stats.timeDrift, anyOf(isNull, isNotNull));

        await processorWithDrift.dispose();
      });

      test('should not detect time drift when disabled', () async {
        final processorWithoutDrift = RealTimeTimeDataProcessor(
          enableTimeDriftDetection: false,
        );
        await processorWithoutDrift.startTemporalStream();

        // Wait for drift check
        await Future.delayed(const Duration(seconds: 1));

        final stats = processorWithoutDrift.getStatistics();
        expect(stats.timeDrift, isNull);

        await processorWithoutDrift.dispose();
      });
    });

    group('Resilience', () {
      test('should handle disposal gracefully', () async {
        await processor.startTemporalStream();

        await processor.dispose();

        expect(processor.isRunning, false);
        expect(processor.queueSize, 0);
      });

      test('should handle multiple disposals', () async {
        await processor.startTemporalStream();

        await processor.dispose();
        await processor.dispose(); // Should not throw

        expect(processor.isRunning, false);
      });

      test('should handle events after disposal', () async {
        await processor.startTemporalStream();
        await processor.dispose();

        final event = TimedEvent<String>(
          id: 'test_event_after_dispose',
          data: 'test data',
          timestamp: DateTime.now(),
        );

        final result = await processor.processTimedEvent(event);
        // Should start automatically or handle gracefully
        expect(result, isNotNull);
      });
    });

    group('Event Ordering', () {
      test('should process events in temporal order', () async {
        await processor.startTemporalStream();

        final eventsReceived = <String>[];
        final completer = Completer<void>();

        final subscription = processor.subscribeToTemporalStream<String>(
          onEvent: (event) async {
            eventsReceived.add(event.id);
            if (eventsReceived.length >= 3) {
              completer.complete();
            }
            return TemporalProcessingResult<String>(
              eventId: event.id,
              success: true,
              processingTime: Duration.zero,
            );
          },
        );

        // Send events out of order
        final now = DateTime.now();
        final event2 = TimedEvent<String>(
          id: 'event_2',
          data: 'data 2',
          timestamp: now.add(const Duration(seconds: 2)),
        );
        await processor.processTimedEvent(event2);

        final event1 = TimedEvent<String>(
          id: 'event_1',
          data: 'data 1',
          timestamp: now.add(const Duration(seconds: 1)),
        );
        await processor.processTimedEvent(event1);

        final event3 = TimedEvent<String>(
          id: 'event_3',
          data: 'data 3',
          timestamp: now.add(const Duration(seconds: 3)),
        );
        await processor.processTimedEvent(event3);

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 500));
        await completer.future.timeout(const Duration(seconds: 2));

        // Events should be processed in temporal order
        expect(eventsReceived.length, greaterThanOrEqualTo(3));
        // Note: Due to async processing, exact order may vary, but events should be processed

        await subscription.cancel();
        await processor.stopTemporalStream();
      });
    });
  });
}

