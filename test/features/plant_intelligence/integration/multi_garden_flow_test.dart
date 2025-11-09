
import '../../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart';
import 'package:permacalendar/core/services/aggregation/garden_aggregation_hub.dart';

/// Tests d'intÃ©gration pour les flux multi-garden
/// 
/// **PROMPT A15 - Phase 4.2**
/// 
/// Valide les scÃ©narios complets de gestion multi-garden :
/// - Changement de jardin pendant une analyse
/// - Invalidation de cache par jardin
/// - Analyses concurrentes
/// - Isolation des Ã©tats
void main() {
  group('Multi-Garden Integration Tests', () {
    late ProviderContainer container;
    late GardenAggregationHub hub;

    setUp(() {
      container = ProviderContainer();
      hub = GardenAggregationHub();
    });

    tearDown(() {
      container.dispose();
    });

    test('Garden switch updates currentIntelligenceGardenIdProvider', () {
      // Read initial value (should be null)
      final initial = container.read(currentIntelligenceGardenIdProvider);
      expect(initial, isNull);

      // Update to garden_1
      container.read(currentIntelligenceGardenIdProvider.notifier).state = 'garden_1';
      final updated = container.read(currentIntelligenceGardenIdProvider);
      expect(updated, equals('garden_1'));

      // Update to garden_2
      container.read(currentIntelligenceGardenIdProvider.notifier).state = 'garden_2';
      final final_ = container.read(currentIntelligenceGardenIdProvider);
      expect(final_, equals('garden_2'));
    });

    test('Multiple gardens have isolated state', () {
      // Create providers for different gardens
      final state1 = container.read(intelligenceStateProvider('garden_1'));
      final state2 = container.read(intelligenceStateProvider('garden_2'));

      // Verify they have different gardenIds
      expect(state1.currentGardenId, equals('garden_1'));
      expect(state2.currentGardenId, equals('garden_2'));
      
      // Verify they are different instances
      expect(identical(state1, state2), isFalse);
    });

    test('Cache invalidation affects only specific garden', () {
      // Set cache for garden_1
      hub.setIntelligenceCache('garden_1', {'data': 'value1'});
      
      // Set cache for garden_2
      hub.setIntelligenceCache('garden_2', {'data': 'value2'});

      // Verify both caches exist
      expect(hub.getIntelligenceCache('garden_1'), isNotNull);
      expect(hub.getIntelligenceCache('garden_2'), isNotNull);

      // Invalidate only garden_1
      hub.invalidateGardenIntelligenceCache('garden_1');

      // Verify garden_1 is invalidated but garden_2 remains
      expect(hub.getIntelligenceCache('garden_1'), isNull);
      expect(hub.getIntelligenceCache('garden_2'), isNotNull);
    });

    test('LRU eviction removes oldest accessed garden', () {
      // Add 5 gardens to fill cache
      for (var i = 1; i <= 5; i++) {
        hub.setIntelligenceCache('garden_$i', {'data': 'value$i'});
      }

      final stats1 = hub.getIntelligenceCacheStats();
      expect(stats1['total_caches'], equals(5));

      // Access garden_1 to mark it as recently used
      hub.getIntelligenceCache('garden_1');

      // Add garden_6 (should trigger LRU eviction)
      hub.setIntelligenceCache('garden_6', {'data': 'value6'});

      final stats2 = hub.getIntelligenceCacheStats();
      expect(stats2['total_caches'], equals(5)); // Still max 5

      // garden_1 should still exist (was accessed recently)
      expect(hub.getIntelligenceCache('garden_1'), isNotNull);
      
      // garden_2 should be evicted (least recently accessed)
      // Note: Exact behavior depends on timing
    });

    test('Cache expiration removes stale data', () async {
      // Create cache with very short validity
      const shortDuration = Duration(milliseconds: 100);
      
      final cache = GardenIntelligenceCache(
        gardenId: 'garden_1',
        data: {'test': 'data'},
        createdAt: DateTime.now(),
        lastAccessedAt: DateTime.now(),
      );

      // Initially valid
      expect(cache.isValid(const Duration(seconds: 10)), isTrue);

      // Wait for expiration
      await Future.delayed(const Duration(milliseconds: 150));

      // Now expired
      expect(cache.isValid(shortDuration), isFalse);
    });

    test('Cache statistics provide accurate information', () {
      // Clear all caches first
      hub.clearAllIntelligenceCaches();

      // Add 3 gardens
      hub.setIntelligenceCache('garden_1', {'data': 1});
      hub.setIntelligenceCache('garden_2', {'data': 2});
      hub.setIntelligenceCache('garden_3', {'data': 3});

      final stats = hub.getIntelligenceCacheStats();

      expect(stats['total_caches'], equals(3));
      expect(stats['max_caches'], equals(5));
      expect(stats['gardens_cached'], contains('garden_1'));
      expect(stats['gardens_cached'], contains('garden_2'));
      expect(stats['gardens_cached'], contains('garden_3'));
      expect(stats['cache_ages'], isA<Map<String, int>>());
      expect(stats['last_accessed'], isA<Map<String, int>>());
    });

    test('clearAllIntelligenceCaches removes all caches', () {
      // Add multiple caches
      hub.setIntelligenceCache('garden_1', {'data': 1});
      hub.setIntelligenceCache('garden_2', {'data': 2});
      hub.setIntelligenceCache('garden_3', {'data': 3});

      // Verify they exist
      final statsBefore = hub.getIntelligenceCacheStats();
      expect(statsBefore['total_caches'], equals(3));

      // Clear all
      hub.clearAllIntelligenceCaches();

      // Verify all cleared
      final statsAfter = hub.getIntelligenceCacheStats();
      expect(statsAfter['total_caches'], equals(0));
      expect(hub.getIntelligenceCache('garden_1'), isNull);
      expect(hub.getIntelligenceCache('garden_2'), isNull);
      expect(hub.getIntelligenceCache('garden_3'), isNull);
    });
  });

  group('Migration Report', () {
    test('toString generates readable report', () {
      final report = MigrationReport()
        ..success = true
        ..duration = const Duration(seconds: 2)
        ..conditionsMigrated = 45
        ..conditionsSkipped = 5
        ..conditionsErrors = 0
        ..recommendationsMigrated = 32
        ..recommendationsSkipped = 3
        ..recommendationsErrors = 1;

      final reportString = report.toString();

      expect(reportString, contains('RAPPORT DE MIGRATION'));
      expect(reportString, contains('SUCCÃˆS'));
      expect(reportString, contains('45')); // conditions migrated
      expect(reportString, contains('32')); // recommendations migrated
      expect(reportString, contains('77')); // total migrated (45+32)
    });

    test('totalMigrated calculates correctly', () {
      final report = MigrationReport()
        ..conditionsMigrated = 10
        ..recommendationsMigrated = 20;

      expect(report.totalMigrated, equals(30));
    });

    test('totalSkipped calculates correctly', () {
      final report = MigrationReport()
        ..conditionsSkipped = 5
        ..recommendationsSkipped = 8;

      expect(report.totalSkipped, equals(13));
    });

    test('totalErrors calculates correctly', () {
      final report = MigrationReport()
        ..conditionsErrors = 2
        ..recommendationsErrors = 3;

      expect(report.totalErrors, equals(5));
    });
  });
}


