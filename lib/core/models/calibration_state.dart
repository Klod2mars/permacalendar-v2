import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'calibration_state.freezed.dart';
part 'calibration_state.g.dart';

/// # CalibrationState
///
/// Rôle :
/// - Pilote l'état courant de la calibration organique (activation, statut, métadonnées).
/// - Centralise les offsets capteurs (legacy + V2) ainsi que le niveau d'achèvement.
/// - Sert de façade unique à Hive pour persister les profils calculés par `calibration_migration.dart`.
///
/// Intégration :
/// - Aligné sur les profils migrés (`CalibrationV2Profile`) et exploité par `calibration_migration.dart`.
/// - Stocke les identifiants de zone afin d'orchestrer les layouts gérés par `position_persistence_ext.dart`.
///
/// Providers Riverpod 3 :
/// - Distribué via `NotifierProvider` (`calibrationStateProvider`) et utilisable dans les widgets ou services.
/// - Les mutations doivent passer par `CalibrationStateNotifier` qui applique `validate()` avant publication.
@JsonEnum(alwaysCreate: true)
@HiveType(typeId: 61, adapterName: 'CalibrationTypeAdapter')
enum CalibrationType {
  @HiveField(0)
  none,
  @HiveField(1)
  organic;

  String toJson() => _$CalibrationTypeEnumMap[this]!;

  static CalibrationType fromJson(Object? json) =>
      _$CalibrationTypeEnumMap.entries
          .firstWhere(
            (entry) => entry.value == json,
            orElse: () => const MapEntry(CalibrationType.none, 'none'),
          )
          .key;
}

const _defaultCalibrationLevel = 0.0;
const _maxPercentOffset = 100.0;
const _maxTemperatureOffset = 10.0;

@freezed
class CalibrationState with _$CalibrationState {
  const CalibrationState._();

  @JsonSerializable(explicitToJson: true)
  @HiveType(typeId: 60, adapterName: 'CalibrationStateAdapter')
  const factory CalibrationState({
    @HiveField(0)
    @JsonKey(unknownEnumValue: CalibrationType.none)
    @Default(CalibrationType.none)
    CalibrationType activeType,
    @HiveField(1) @Default(false) bool hasUnsavedChanges,

    /// Indique si le profil a été validé et appliqué sur l'appareil.
    @HiveField(2) @Default(false) bool isCalibrated,

    /// Date de dernière calibration (UTC).
    @HiveField(3) @TimestampJsonConverter() DateTime? calibrationDate,

    /// Progression globale de la calibration (0.0 – 1.0).
    @HiveField(4) @Default(_defaultCalibrationLevel) double calibrationLevel,

    /// Offsets en pourcentage pour les capteurs (ex : humidité, lumière).
    @HiveField(5)
    @DoubleMapJsonConverter()
    @Default(<String, double>{})
    Map<String, double> sensorOffsets,

    /// Offsets en degrés Celsius pour les capteurs de température.
    @HiveField(6)
    @DoubleMapJsonConverter()
    @Default(<String, double>{})
    Map<String, double> temperatureOffsets,

    /// Zone ou profil ciblé par la calibration.
    @HiveField(7) String? zoneId,

    /// Identifiant du profil migré (legacy ou V2).
    @HiveField(8) String? profileId,

    /// Identifiant du device associé.
    @HiveField(9) String? deviceId,
  }) = _CalibrationState;

  factory CalibrationState.fromJson(Map<String, dynamic> json) =>
      _$CalibrationStateFromJson(json);

  /// Valide et nettoie les données afin d'éviter les valeurs corrompues.
  CalibrationState validate() {
    final sanitizedSensorOffsets =
        _sanitizeOffsets(sensorOffsets, maxMagnitude: _maxPercentOffset);
    final sanitizedTemperatureOffsets = _sanitizeOffsets(temperatureOffsets,
        maxMagnitude: _maxTemperatureOffset);

    final sanitizedLevel = calibrationLevel.isNaN || !calibrationLevel.isFinite
        ? _defaultCalibrationLevel
        : calibrationLevel.clamp(0.0, 1.0);

    final sanitizedDate = calibrationDate?.toUtc();

    return copyWith(
      calibrationLevel: sanitizedLevel,
      sensorOffsets: sanitizedSensorOffsets,
      temperatureOffsets: sanitizedTemperatureOffsets,
      calibrationDate: sanitizedDate,
    );
  }

  Map<String, double> _sanitizeOffsets(
    Map<String, double> source, {
    required double maxMagnitude,
  }) {
    final sanitized = <String, double>{};
    for (final entry in source.entries) {
      final key = entry.key.trim();
      final value = entry.value;
      if (key.isEmpty) continue;
      if (value.isNaN || !value.isFinite) continue;
      sanitized[key] = value.clamp(-maxMagnitude, maxMagnitude).toDouble();
    }
    return sanitized;
  }
}

/// Provider unifié pour la calibration (Riverpod 3 - StateNotifier).
final calibrationStateProvider =
    NotifierProvider<CalibrationStateNotifier, CalibrationState>(
  CalibrationStateNotifier.new,
);

class CalibrationStateNotifier extends Notifier<CalibrationState> {
  @override
  CalibrationState build() => const CalibrationState();

  void setActiveCalibration(CalibrationType type) {
    state = state.copyWith(
      activeType: type,
      hasUnsavedChanges: false,
    );
  }

  /// Active la calibration organique et réinitialise les offsets.
  void enableOrganicCalibration() {
    state = state
        .copyWith(
          activeType: CalibrationType.organic,
          calibrationLevel: 0.2,
          hasUnsavedChanges: false,
          isCalibrated: false,
        )
        .validate();
  }

  /// Désactive la calibration en cours.
  void disableCalibration() {
    if (kDebugMode) {
      debugPrint('🔧 disableCalibration() - ${state.activeType} → none');
    }
    state = state
        .copyWith(
          activeType: CalibrationType.none,
          hasUnsavedChanges: false,
          isCalibrated: false,
          calibrationLevel: _defaultCalibrationLevel,
        )
        .validate();
  }

  /// Marque l'état comme modifié après une action utilisateur.
  void markAsModified() {
    state = state.copyWith(hasUnsavedChanges: true).validate();
  }

  /// Finalise la calibration.
  void completeCalibration({DateTime? completedAt}) {
    state = state
        .copyWith(
          isCalibrated: true,
          calibrationLevel: 1.0,
          calibrationDate: (completedAt ?? DateTime.now()).toUtc(),
          hasUnsavedChanges: false,
        )
        .validate();
  }

  /// Met à jour l'offset d'un capteur générique (-100% / +100%).
  void setSensorOffset(String sensorId, double offset) {
    state = state.copyWith(
      sensorOffsets: {
        ...state.sensorOffsets,
        sensorId: offset,
      },
      hasUnsavedChanges: true,
    ).validate();
  }

  /// Met à jour l'offset d'un capteur de température (-10°C / +10°C).
  void setTemperatureOffset(String sensorId, double offset) {
    state = state.copyWith(
      temperatureOffsets: {
        ...state.temperatureOffsets,
        sensorId: offset,
      },
      hasUnsavedChanges: true,
    ).validate();
  }

  void removeSensorOffset(String sensorId) {
    final updated = Map<String, double>.from(state.sensorOffsets)
      ..remove(sensorId);
    state = state.copyWith(sensorOffsets: updated).validate();
  }

  void removeTemperatureOffset(String sensorId) {
    final updated = Map<String, double>.from(state.temperatureOffsets)
      ..remove(sensorId);
    state = state.copyWith(temperatureOffsets: updated).validate();
  }

  void attachZone(String? zoneId) {
    state = state
        .copyWith(
          zoneId: zoneId,
          hasUnsavedChanges: true,
        )
        .validate();
  }

  void attachProfile({
    String? profileId,
    String? deviceId,
  }) {
    state = state
        .copyWith(
          profileId: profileId,
          deviceId: deviceId,
          hasUnsavedChanges: true,
        )
        .validate();
  }

  void resetOffsets() {
    state = state.copyWith(
      sensorOffsets: const <String, double>{},
      temperatureOffsets: const <String, double>{},
      calibrationLevel: _defaultCalibrationLevel,
      hasUnsavedChanges: true,
    ).validate();
  }

  bool get isCalibrating => state.activeType != CalibrationType.none;

  bool get isOrganicCalibrating => state.activeType == CalibrationType.organic;
}

// Provider de compatibilité (déprécié)
@Deprecated('Utilisez calibrationStateProvider à la place')
final gardenCalibrationEnabledProvider = Provider<bool>((ref) {
  return ref.watch(
          calibrationStateProvider.select((state) => state.activeType)) ==
      CalibrationType.organic;
});

/// Convertit des timestamps JSON vers des DateTime UTC.
class TimestampJsonConverter extends JsonConverter<DateTime?, Object?> {
  const TimestampJsonConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json is String) {
      final parsed = DateTime.tryParse(json);
      return parsed?.toUtc();
    }
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json, isUtc: true);
    }
    if (json is double) {
      return DateTime.fromMillisecondsSinceEpoch(json.toInt(), isUtc: true);
    }
    return null;
  }

  @override
  Object? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}

/// Convertisseur JSON pour Map<String, double> robuste.
class DoubleMapJsonConverter
    extends JsonConverter<Map<String, double>, Map<String, dynamic>?> {
  const DoubleMapJsonConverter();

  @override
  Map<String, double> fromJson(Map<String, dynamic>? json) {
    if (json == null) return const <String, double>{};
    final result = <String, double>{};
    json.forEach((key, value) {
      final trimmedKey = key.trim();
      if (trimmedKey.isEmpty) {
        return;
      }
      final doubleValue = _asDouble(value);
      if (doubleValue == null) {
        return;
      }
      result[trimmedKey] = doubleValue;
    });
    return result;
  }

  @override
  Map<String, dynamic> toJson(Map<String, double> object) {
    return object.map((key, value) => MapEntry(key, value));
  }

  double? _asDouble(Object? value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
