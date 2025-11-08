import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:permacalendar/core/utils/position_persistence_ext.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PositionPersistenceExt.resetPrefsFactory();
  });

  tearDown(() {
    PositionPersistenceExt.resetPrefsFactory();
  });

  group('PositionPersistenceExt', () {
    test('saves and restores a normalized position', () async {
      const position = NormalizedPosition(
        x: 0.52,
        y: 0.31,
        size: 0.4,
        enabled: false,
      );

      await PositionPersistenceExt.savePosition('test', 'widget', position);
      final restored =
          await PositionPersistenceExt.restorePosition('test', 'widget');

      expect(restored, isNotNull);
      expect(restored!.toJson(), position.clamp().toJson());
    });

    test('returns fallback when persisted data is incomplete or corrupted',
        () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('test_widget_x', 0.7);
      await prefs.setDouble('test_widget_size', -0.5); // corrupted size

      const fallback = NormalizedPosition(x: 0.1, y: 0.1, size: 0.2);
      final restored = await PositionPersistenceExt.restorePosition(
        'test',
        'widget',
        fallback: fallback,
      );

      expect(restored, fallback);
    });

    test('clears persisted position keys', () async {
      await PositionPersistenceExt.savePosition(
        'test',
        'widget',
        const NormalizedPosition(x: 0.2, y: 0.3),
      );

      await PositionPersistenceExt.clearPosition('test', 'widget');
      final restored =
          await PositionPersistenceExt.restorePosition('test', 'widget');

      expect(restored, isNull);
    });

    test('serializes and deserializes JSON payload', () {
      const position = NormalizedPosition(
        x: 0.21,
        y: 0.67,
        size: 0.3,
        enabled: false,
      );

      final json = PositionPersistenceExt.toJson(position);
      final fromJson = PositionPersistenceExt.fromJson(json);

      expect(fromJson, position);
    });

    test('concurrent saves are serialized via mutex', () async {
      final firstFuture = PositionPersistenceExt.savePosition(
        'multi',
        'widget',
        const NormalizedPosition(x: 0.4, y: 0.2, size: 0.5),
      );
      final secondFuture = Future<void>(() async {
        await Future<void>.delayed(const Duration(milliseconds: 1));
        await PositionPersistenceExt.savePosition(
          'multi',
          'widget',
          const NormalizedPosition(x: 0.6, y: 0.4, size: 0.35),
        );
      });

      await Future.wait([firstFuture, secondFuture]);

      final restored =
          await PositionPersistenceExt.restorePosition('multi', 'widget');
      expect(restored, isNotNull);
      expect(restored!.x, closeTo(0.6, 1e-9));
      expect(restored.y, closeTo(0.4, 1e-9));
    });
  });
}

