import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calibration_state.freezed.dart';

/// Type d'élément en calibration (unifié)
enum CalibrationType {
  none, // Pas de calibration active
  organic, // Calibration organique unifiée
}

/// État de calibration unifié
@freezed
class CalibrationState with _$CalibrationState {
  const factory CalibrationState({
    @Default(CalibrationType.none) CalibrationType activeType,
    @Default(false) bool hasUnsavedChanges,
  }) = _CalibrationState;
}

/// Provider unifié pour la calibration
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

  /// Désactiver toute calibration
  void disableCalibration() {
    if (kDebugMode) {
      debugPrint('🔧 disableCalibration() - ${state.activeType} → none');
    }
    state = state.copyWith(
      activeType: CalibrationType.none,
      hasUnsavedChanges: false,
    );
  }

  /// Marquer comme modifié
  void markAsModified() {
    state = state.copyWith(hasUnsavedChanges: true);
  }

  /// Vérifier si calibration active
  bool get isCalibrating => state.activeType != CalibrationType.none;

  /// Vérifier si calibration organique active
  bool get isOrganicCalibrating => state.activeType == CalibrationType.organic;
}

// Provider de compatibilité (déprécié)
@Deprecated('Utilisez calibrationStateProvider à la place')
final gardenCalibrationEnabledProvider = Provider<bool>((ref) {
  return ref.watch(calibrationStateProvider).activeType ==
      CalibrationType.organic;
});
