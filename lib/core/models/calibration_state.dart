import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calibration_state.freezed.dart';

/// Type d'Ã©lÃ©ment en calibration (unifiÃ©)
enum CalibrationType {
  none, // Pas de calibration active
  organic, // Calibration organique unifiée
  tapZones, // Calibration par zones tactiles (nouveau)
}

/// Ã‰tat de calibration unifiÃ©
@freezed
class CalibrationState with _$CalibrationState {
  const factory CalibrationState({
    @Default(CalibrationType.none) CalibrationType activeType,
    @Default(false) bool hasUnsavedChanges,
  }) = _CalibrationState;
}

/// Provider unifiÃ© pour la calibration
final calibrationStateProvider =
    NotifierProvider<CalibrationStateNotifier, CalibrationState>(() {
  return CalibrationStateNotifier();
});

class CalibrationStateNotifier extends Notifier<CalibrationState> {
  @override
  CalibrationState build() => const CalibrationState();

  /// Activer calibration organique
  void enableOrganicCalibration() {
    state = const CalibrationState(
      activeType: CalibrationType.organic,
      hasUnsavedChanges: false,
    );
  }

  /// Activer calibration TAP/ZONES
  void enableTapZonesCalibration() {
    state = const CalibrationState(
      activeType: CalibrationType.tapZones,
      hasUnsavedChanges: false,
    );
  }

  /// DÃ©sactiver toute calibration
  void disableCalibration() {
    if (kDebugMode) {
      debugPrint('ðŸ”§ disableCalibration() - ${state.activeType} â†’ none');
    }
    state = state.copyWith(
      activeType: CalibrationType.none,
      hasUnsavedChanges: false,
    );
  }

  /// Marquer comme modifiÃ©
  void markAsModified() {
    state = state.copyWith(hasUnsavedChanges: true);
  }

  /// VÃ©rifier si calibration active
  bool get isCalibrating => state.activeType != CalibrationType.none;

  /// VÃ©rifier si calibration organique active
  bool get isOrganicCalibrating => state.activeType == CalibrationType.organic;
}

// Provider de compatibilitÃ© (dÃ©prÃ©ciÃ©)
@Deprecated('Utilisez calibrationStateProvider Ã  la place')
final gardenCalibrationEnabledProvider = Provider<bool>((ref) {
  return ref.watch(calibrationStateProvider).activeType ==
      CalibrationType.organic;
});





