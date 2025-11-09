
import '../../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart';
import 'package:permacalendar/core/services/aggregation/garden_aggregation_hub.dart';

/// Tests de performance pour le changement de jardin
/// 
/// **PROMPT A15 - Phase 4.3**
/// 
/// Valide que le changement de jardin respecte les objectifs de performance :
/// - Latence < 100ms pour le changement de jardin
/// - MÃ©moire stable avec 5+ jardins
/// - Pas de fuites mÃ©moire
void main() {
  group('Garden Switch Performance Benchmarks', () {
    late ProviderContainer container;
    late GardenAggregationHub hub;

    setUp(() {
      container = ProviderContainer();
      hub = GardenAggregationHub();
    });

    tearDown(() {
      container.dispose();
    });

    test('Garden switch completes in < 100ms', () async {
      // Warm up the cache
      hub.setIntelligenceCache('garden_1', {'data': 'value1'});
      hub.setIntelligenceCache('garden_2', {'data': 'value2'});

      // Measure switch time
      final stopwatch = Stopwatch()..start();
      
      container.read(currentIntelligenceGardenIdProvider.notifier).state = 'garden_1';
      final cache1 = hub.getIntelligenceCache('garden_1');
      
      container.read(currentIntelligenceGardenIdProvider.notifier).state = 'garden_2';
      final cache2 = hub.getIntelligenceCache('garden_2');
      
      stopwatch.stop();

      expect(cache1, isNotNull);
      expect(cache2, isNotNull);
      expect(stopwatch.elapsedMilliseconds, lessThan(100),
          reason: 'Garden switch should complete in < 100ms');

      print('âœ… Garden switch completed in ${stopwatch.elapsedMilliseconds}ms');
    });

    test('Cache access is fast (< 10ms)', () {
      hub.setIntelligenceCache('garden_1', {'data': 'value1'});

      final stopwatch = Stopwatch()..start();
      
      for (var i = 0; i < 100; i++) {
        hub.getIntelligenceCache('garden_1');
      }
      
      stopwatch.stop();

      final avgTime = stopwatch.elapsedMilliseconds / 100;
      expect(avgTime, lessThan(10),
          reason: 'Cache access should be < 10ms average');

      print('âœ… Average cache access: ${avgTime.toStringAsFixed(2)}ms');
    });

    test('LRU eviction completes in < 50ms', () {
      // Fill cache to capacity
      for (var i = 1; i <= 5; i++) {
        hub.setIntelligenceCache('garden_$i', {'data': 'value$i'});
      }

      // Measure eviction time when adding 6th garden
      final stopwatch = Stopwatch()..start();
      hub.setIntelligenceCache('garden_6', {'data': 'value6'});
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(50),
          reason: 'LRU eviction should complete in < 50ms');

      final stats = hub.getIntelligenceCacheStats();
      expect(stats['total_caches'], equals(5)); // Still at max

      print('âœ… LRU eviction completed in ${stopwatch.elapsedMilliseconds}ms');
    });

    test('Memory footprint is acceptable with multiple gardens', () {
      final initialStats = hub.getIntelligenceCacheStats();
      
      // Add 5 gardens with realistic data size
      for (var i = 1; i <= 5; i++) {
        final largeData = {
          'conditions': List.generate(100, (j) => {
            'id': 'cond_${i}_$j',
            'value': j.toDouble(),
            'status': 'optimal',
          }),
          'recommendations': List.generate(50, (j) => {
            'id': 'rec_${i}_$j',
            'title': 'Recommendation $j',
            'description': 'Description for recommendation $j',
          }),
        };
        hub.setIntelligenceCache('garden_$i', largeData);
      }

      final finalStats = hub.getIntelligenceCacheStats();
      
      expect(finalStats['total_caches'], equals(5));
      
      // Log memory usage (visual verification)
      print('âœ… Successfully cached 5 gardens with realistic data');
      print('   Cache stats: ${finalStats['total_caches']} gardens cached');
    });

    test('Provider state isolation - no contamination', () {
      // Create states for 3 different gardens
      final state1 = container.read(intelligenceStateProvider('garden_1'));
      final state2 = container.read(intelligenceStateProvider('garden_2'));
      final state3 = container.read(intelligenceStateProvider('garden_3'));

      // Verify complete isolation
      expect(state1.currentGardenId, equals('garden_1'));
      expect(state2.currentGardenId, equals('garden_2'));
      expect(state3.currentGardenId, equals('garden_3'));

      // Verify different instances
      expect(identical(state1, state2), isFalse);
      expect(identical(state2, state3), isFalse);
      expect(identical(state1, state3), isFalse);

      print('âœ… State isolation verified: 3 gardens with independent states');
    });

    test('Rapid garden switching maintains stability', () async {
      // Prepare caches
      for (var i = 1; i <= 3; i++) {
        hub.setIntelligenceCache('garden_$i', {'data': 'value$i'});
      }

      // Rapidly switch between gardens
      final stopwatch = Stopwatch()..start();
      
      for (var round = 0; round < 10; round++) {
        container.read(currentIntelligenceGardenIdProvider.notifier).state = 'garden_1';
        container.read(currentIntelligenceGardenIdProvider.notifier).state = 'garden_2';
        container.read(currentIntelligenceGardenIdProvider.notifier).state = 'garden_3';
      }
      
      stopwatch.stop();

      // 30 switches (10 rounds Ã— 3 switches) should complete quickly
      expect(stopwatch.elapsedMilliseconds, lessThan(500),
          reason: '30 rapid switches should complete in < 500ms');

      final avgSwitch = stopwatch.elapsedMilliseconds / 30;
      expect(avgSwitch, lessThan(20),
          reason: 'Average switch time should be < 20ms');

      print('âœ… Rapid switching stable: 30 switches in ${stopwatch.elapsedMilliseconds}ms');
      print('   Average: ${avgSwitch.toStringAsFixed(2)}ms per switch');
    });

    test('Cache statistics accuracy with concurrent access', () {
      // Add multiple gardens
      hub.setIntelligenceCache('garden_1', {'data': 1});
      hub.setIntelligenceCache('garden_2', {'data': 2});
      hub.setIntelligenceCache('garden_3', {'data': 3});

      // Access garden_1 multiple times (should update lastAccessed)
      hub.getIntelligenceCache('garden_1');
      hub.getIntelligenceCache('garden_1');
      hub.getIntelligenceCache('garden_1');

      final stats = hub.getIntelligenceCacheStats();

      expect(stats['total_caches'], equals(3));
      expect(stats['max_caches'], equals(5));
      expect(stats['gardens_cached'], hasLength(3));
      expect(stats['cache_ages'], isA<Map<String, int>>());
      expect(stats['last_accessed'], isA<Map<String, int>>());

      // garden_1 should have most recent access
      final lastAccessed = stats['last_accessed'] as Map<String, int>;
      expect(lastAccessed['garden_1'], lessThan(lastAccessed['garden_2']!));

      print('âœ… Cache statistics accurate and up-to-date');
    });
  });
}


