import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:permacalendar/core/models/calibration_state.dart';
import 'package:test/test.dart';

void main() {
  group('CalibrationState model', () {
    test('provides safe defaults', () {
      const state = CalibrationState();
      expect(state.activeType, CalibrationType.none);
      expect(state.hasUnsavedChanges, isFalse);
      expect(state.isCalibrated, isFalse);
      expect(state.calibrationDate, isNull);
      expect(state.calibrationLevel, closeTo(0.0, 1e-6));
      expect(state.sensorOffsets, isEmpty);
      expect(state.temperatureOffsets, isEmpty);
      expect(state.zoneId, isNull);
    });

    test('serialises to and from JSON', () {
      final now = DateTime.utc(2024, 01, 01, 12, 30);
      final state = CalibrationState(
        activeType: CalibrationType.organic,
        hasUnsavedChanges: true,
        isCalibrated: true,
        calibrationDate: now,
        calibrationLevel: 0.75,
        sensorOffsets: const {'humidity': 12.5},
        temperatureOffsets: const {'ambient': 1.5},
        zoneId: 'zone-42',
        profileId: 'profile-A',
        deviceId: 'device-XYZ',
      ).validate();

      final json = state.toJson();
      final restored = CalibrationState.fromJson(json);

      expect(restored, equals(state));
    });

    test('validate() clamps offsets and level', () {
      final state = CalibrationState(
        calibrationLevel: 4.2,
        sensorOffsets: const {
          'humidity': 120.0,
          'noise': double.nan,
        },
        temperatureOffsets: const {
          'ambient': -12.0,
          'spike': double.infinity,
        },
      );

      final sanitized = state.validate();

      expect(sanitized.calibrationLevel, closeTo(1.0, 1e-6));
      expect(sanitized.sensorOffsets, equals({'humidity': 100.0}));
      expect(sanitized.temperatureOffsets, equals({'ambient': -10.0}));
    });

    test('copyWith maintains equality semantics', () {
      const base = CalibrationState(sensorOffsets: {'humidity': 5.0});
      final same = base.copyWith();
      final modified = base.copyWith(sensorOffsets: const {'humidity': 6.0});

      expect(same, equals(base));
      expect(modified, isNot(equals(base)));
      expect(modified.sensorOffsets['humidity'], 6.0);
    });
  });

  group('CalibrationStateNotifier', () {
    test('enables and finalises calibration safely', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(calibrationStateProvider.notifier);

      notifier.enableOrganicCalibration();
      expect(notifier.state.activeType, CalibrationType.organic);
      expect(notifier.state.isCalibrated, isFalse);

      notifier.setSensorOffset('humidity', 200);
      notifier.setTemperatureOffset('ambient', -15);
      notifier.completeCalibration();

      expect(notifier.state.isCalibrated, isTrue);
      expect(notifier.state.calibrationLevel, closeTo(1.0, 1e-6));
      expect(notifier.state.sensorOffsets['humidity'], 100.0);
      expect(notifier.state.temperatureOffsets['ambient'], -10.0);
    });
  });

  group('Hive round-trip', () {
    late Directory tempDir;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('calibration_state_test');
      Hive.init(tempDir.path);
      if (!Hive.isAdapterRegistered(61)) {
        Hive.registerAdapter(CalibrationTypeAdapter());
      }
      if (!Hive.isAdapterRegistered(60)) {
        Hive.registerAdapter(CalibrationStateAdapter());
      }
    });

    tearDownAll(() async {
      await Hive.close();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('stores and restores CalibrationState instances', () async {
      final box =
          await Hive.openBox<CalibrationState>('calibration_state_test');
      final state = CalibrationState(
        activeType: CalibrationType.organic,
        isCalibrated: true,
        calibrationLevel: 0.6,
        sensorOffsets: const {'humidity': 25.0},
        temperatureOffsets: const {'ambient': 2.5},
        zoneId: 'zone-9',
        profileId: 'profile-9',
        deviceId: 'device-9',
      ).validate();

      await box.put('state', state);
      final restored = box.get('state');

      expect(restored, equals(state));

      await box.close();
    });
  });
}
