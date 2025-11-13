ï»¿import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calibration_state.freezed.dart';

/// Type d'ÃƒÂ©lÃƒÂ©ment en calibration (unifiÃƒÂ©)
enum CalibrationType {
  none, // Pas de calibration active
  organic, // Calibration organique unifiée
  tapZones, // Calibration par zones tactiles (nouveau)
}

/// Ãƒâ€°tat de calibration unifiÃƒÂ©
@freezed
class CalibrationState with _$CalibrationState {
  const factory CalibrationState({
    @Default(CalibrationType.none) CalibrationType activeType,
    @Default(false) bool hasUnsavedChanges,
  }) = _CalibrationState;
}

/// Provider unifiÃƒÂ© pour la calibration
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

  /// DÃƒÂ©sactiver toute calibration
  void disableCalibration() {
    if (kDebugMode) {
      debugPrint('Ã°Å¸”Â§ disableCalibration() - ${state.activeType} ââ€ ’ none');
    }
    state = state.copyWith(
      activeType: CalibrationType.none,
      hasUnsavedChanges: false,
    );
  }

  /// Marquer comme modifiÃƒÂ©
  void markAsModified() {
    state = state.copyWith(hasUnsavedChanges: true);
  }

  /// VÃƒÂ©rifier si calibration active
  bool get isCalibrating => state.activeType != CalibrationType.none;

  /// VÃƒÂ©rifier si calibration organique active
  bool get isOrganicCalibrating => state.activeType == CalibrationType.organic;
}

// Provider de compatibilitÃƒÂ© (dÃƒÂ©prÃƒÂ©ciÃƒÂ©)
@Deprecated('Utilisez calibrationStateProvider ÃƒÂ  la place')
final gardenCalibrationEnabledProvider = Provider<bool>((ref) {
  return ref.watch(calibrationStateProvider).activeType ==
      CalibrationType.organic;
});






