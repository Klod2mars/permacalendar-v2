
import '../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/models/calibration_state.dart';

void main() {
  group('CalibrationStateNotifier', () {
    test(
        'enableTapZonesCalibration sets activeType to tapZones and resets flag',
        () {
      final notifier = CalibrationStateNotifier();
      expect(notifier.state.activeType, CalibrationType.none);

      // Simuler une modification prÃ©alable
      notifier.markAsModified();
      expect(notifier.state.hasUnsavedChanges, true);

      // Activer le mode TAP
      notifier.enableTapZonesCalibration();

      expect(notifier.state.activeType, CalibrationType.tapZones);
      expect(notifier.state.hasUnsavedChanges, false);
    });

    test('disableCalibration switches to none and clears unsaved changes', () {
      final notifier = CalibrationStateNotifier();
      notifier.enableTapZonesCalibration();
      notifier.markAsModified();
      expect(notifier.state.hasUnsavedChanges, true);

      notifier.disableCalibration();
      expect(notifier.state.activeType, CalibrationType.none);
      expect(notifier.state.hasUnsavedChanges, false);
    });
  });
}

