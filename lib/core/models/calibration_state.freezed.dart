// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calibration_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CalibrationState _$CalibrationStateFromJson(Map<String, dynamic> json) {
  return _CalibrationState.fromJson(json);
}

/// @nodoc
mixin _$CalibrationState {
  @HiveField(0)
  @JsonKey(unknownEnumValue: CalibrationType.none)
  CalibrationType get activeType => throw _privateConstructorUsedError;
  @HiveField(1)
  bool get hasUnsavedChanges => throw _privateConstructorUsedError;

  /// Indique si le profil a été validé et appliqué sur l'appareil.
  @HiveField(2)
  bool get isCalibrated => throw _privateConstructorUsedError;

  /// Date de dernière calibration (UTC).
  @HiveField(3)
  @TimestampJsonConverter()
  DateTime? get calibrationDate => throw _privateConstructorUsedError;

  /// Progression globale de la calibration (0.0 – 1.0).
  @HiveField(4)
  double get calibrationLevel => throw _privateConstructorUsedError;

  /// Offsets en pourcentage pour les capteurs (ex : humidité, lumière).
  @HiveField(5)
  @DoubleMapJsonConverter()
  Map<String, double> get sensorOffsets => throw _privateConstructorUsedError;

  /// Offsets en degrés Celsius pour les capteurs de température.
  @HiveField(6)
  @DoubleMapJsonConverter()
  Map<String, double> get temperatureOffsets =>
      throw _privateConstructorUsedError;

  /// Zone ou profil ciblé par la calibration.
  @HiveField(7)
  String? get zoneId => throw _privateConstructorUsedError;

  /// Identifiant du profil migré (legacy ou V2).
  @HiveField(8)
  String? get profileId => throw _privateConstructorUsedError;

  /// Identifiant du device associé.
  @HiveField(9)
  String? get deviceId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CalibrationStateCopyWith<CalibrationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalibrationStateCopyWith<$Res> {
  factory $CalibrationStateCopyWith(
          CalibrationState value, $Res Function(CalibrationState) then) =
      _$CalibrationStateCopyWithImpl<$Res, CalibrationState>;
  @useResult
  $Res call(
      {@HiveField(0)
      @JsonKey(unknownEnumValue: CalibrationType.none)
      CalibrationType activeType,
      @HiveField(1) bool hasUnsavedChanges,
      @HiveField(2) bool isCalibrated,
      @HiveField(3) @TimestampJsonConverter() DateTime? calibrationDate,
      @HiveField(4) double calibrationLevel,
      @HiveField(5) @DoubleMapJsonConverter() Map<String, double> sensorOffsets,
      @HiveField(6)
      @DoubleMapJsonConverter()
      Map<String, double> temperatureOffsets,
      @HiveField(7) String? zoneId,
      @HiveField(8) String? profileId,
      @HiveField(9) String? deviceId});
}

/// @nodoc
class _$CalibrationStateCopyWithImpl<$Res, $Val extends CalibrationState>
    implements $CalibrationStateCopyWith<$Res> {
  _$CalibrationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeType = null,
    Object? hasUnsavedChanges = null,
    Object? isCalibrated = null,
    Object? calibrationDate = freezed,
    Object? calibrationLevel = null,
    Object? sensorOffsets = null,
    Object? temperatureOffsets = null,
    Object? zoneId = freezed,
    Object? profileId = freezed,
    Object? deviceId = freezed,
  }) {
    return _then(_value.copyWith(
      activeType: null == activeType
          ? _value.activeType
          : activeType // ignore: cast_nullable_to_non_nullable
              as CalibrationType,
      hasUnsavedChanges: null == hasUnsavedChanges
          ? _value.hasUnsavedChanges
          : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
              as bool,
      isCalibrated: null == isCalibrated
          ? _value.isCalibrated
          : isCalibrated // ignore: cast_nullable_to_non_nullable
              as bool,
      calibrationDate: freezed == calibrationDate
          ? _value.calibrationDate
          : calibrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      calibrationLevel: null == calibrationLevel
          ? _value.calibrationLevel
          : calibrationLevel // ignore: cast_nullable_to_non_nullable
              as double,
      sensorOffsets: null == sensorOffsets
          ? _value.sensorOffsets
          : sensorOffsets // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      temperatureOffsets: null == temperatureOffsets
          ? _value.temperatureOffsets
          : temperatureOffsets // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      zoneId: freezed == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as String?,
      profileId: freezed == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalibrationStateImplCopyWith<$Res>
    implements $CalibrationStateCopyWith<$Res> {
  factory _$$CalibrationStateImplCopyWith(_$CalibrationStateImpl value,
          $Res Function(_$CalibrationStateImpl) then) =
      __$$CalibrationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0)
      @JsonKey(unknownEnumValue: CalibrationType.none)
      CalibrationType activeType,
      @HiveField(1) bool hasUnsavedChanges,
      @HiveField(2) bool isCalibrated,
      @HiveField(3) @TimestampJsonConverter() DateTime? calibrationDate,
      @HiveField(4) double calibrationLevel,
      @HiveField(5) @DoubleMapJsonConverter() Map<String, double> sensorOffsets,
      @HiveField(6)
      @DoubleMapJsonConverter()
      Map<String, double> temperatureOffsets,
      @HiveField(7) String? zoneId,
      @HiveField(8) String? profileId,
      @HiveField(9) String? deviceId});
}

/// @nodoc
class __$$CalibrationStateImplCopyWithImpl<$Res>
    extends _$CalibrationStateCopyWithImpl<$Res, _$CalibrationStateImpl>
    implements _$$CalibrationStateImplCopyWith<$Res> {
  __$$CalibrationStateImplCopyWithImpl(_$CalibrationStateImpl _value,
      $Res Function(_$CalibrationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeType = null,
    Object? hasUnsavedChanges = null,
    Object? isCalibrated = null,
    Object? calibrationDate = freezed,
    Object? calibrationLevel = null,
    Object? sensorOffsets = null,
    Object? temperatureOffsets = null,
    Object? zoneId = freezed,
    Object? profileId = freezed,
    Object? deviceId = freezed,
  }) {
    return _then(_$CalibrationStateImpl(
      activeType: null == activeType
          ? _value.activeType
          : activeType // ignore: cast_nullable_to_non_nullable
              as CalibrationType,
      hasUnsavedChanges: null == hasUnsavedChanges
          ? _value.hasUnsavedChanges
          : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
              as bool,
      isCalibrated: null == isCalibrated
          ? _value.isCalibrated
          : isCalibrated // ignore: cast_nullable_to_non_nullable
              as bool,
      calibrationDate: freezed == calibrationDate
          ? _value.calibrationDate
          : calibrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      calibrationLevel: null == calibrationLevel
          ? _value.calibrationLevel
          : calibrationLevel // ignore: cast_nullable_to_non_nullable
              as double,
      sensorOffsets: null == sensorOffsets
          ? _value._sensorOffsets
          : sensorOffsets // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      temperatureOffsets: null == temperatureOffsets
          ? _value._temperatureOffsets
          : temperatureOffsets // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      zoneId: freezed == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as String?,
      profileId: freezed == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 60, adapterName: 'CalibrationStateAdapter')
class _$CalibrationStateImpl extends _CalibrationState
    with DiagnosticableTreeMixin {
  const _$CalibrationStateImpl(
      {@HiveField(0)
      @JsonKey(unknownEnumValue: CalibrationType.none)
      this.activeType = CalibrationType.none,
      @HiveField(1) this.hasUnsavedChanges = false,
      @HiveField(2) this.isCalibrated = false,
      @HiveField(3) @TimestampJsonConverter() this.calibrationDate,
      @HiveField(4) this.calibrationLevel = _defaultCalibrationLevel,
      @HiveField(5)
      @DoubleMapJsonConverter()
      final Map<String, double> sensorOffsets = const <String, double>{},
      @HiveField(6)
      @DoubleMapJsonConverter()
      final Map<String, double> temperatureOffsets = const <String, double>{},
      @HiveField(7) this.zoneId,
      @HiveField(8) this.profileId,
      @HiveField(9) this.deviceId})
      : _sensorOffsets = sensorOffsets,
        _temperatureOffsets = temperatureOffsets,
        super._();

  factory _$CalibrationStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalibrationStateImplFromJson(json);

  @override
  @HiveField(0)
  @JsonKey(unknownEnumValue: CalibrationType.none)
  final CalibrationType activeType;
  @override
  @JsonKey()
  @HiveField(1)
  final bool hasUnsavedChanges;

  /// Indique si le profil a été validé et appliqué sur l'appareil.
  @override
  @JsonKey()
  @HiveField(2)
  final bool isCalibrated;

  /// Date de dernière calibration (UTC).
  @override
  @HiveField(3)
  @TimestampJsonConverter()
  final DateTime? calibrationDate;

  /// Progression globale de la calibration (0.0 – 1.0).
  @override
  @JsonKey()
  @HiveField(4)
  final double calibrationLevel;

  /// Offsets en pourcentage pour les capteurs (ex : humidité, lumière).
  final Map<String, double> _sensorOffsets;

  /// Offsets en pourcentage pour les capteurs (ex : humidité, lumière).
  @override
  @JsonKey()
  @HiveField(5)
  @DoubleMapJsonConverter()
  Map<String, double> get sensorOffsets {
    if (_sensorOffsets is EqualUnmodifiableMapView) return _sensorOffsets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sensorOffsets);
  }

  /// Offsets en degrés Celsius pour les capteurs de température.
  final Map<String, double> _temperatureOffsets;

  /// Offsets en degrés Celsius pour les capteurs de température.
  @override
  @JsonKey()
  @HiveField(6)
  @DoubleMapJsonConverter()
  Map<String, double> get temperatureOffsets {
    if (_temperatureOffsets is EqualUnmodifiableMapView)
      return _temperatureOffsets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_temperatureOffsets);
  }

  /// Zone ou profil ciblé par la calibration.
  @override
  @HiveField(7)
  final String? zoneId;

  /// Identifiant du profil migré (legacy ou V2).
  @override
  @HiveField(8)
  final String? profileId;

  /// Identifiant du device associé.
  @override
  @HiveField(9)
  final String? deviceId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CalibrationState(activeType: $activeType, hasUnsavedChanges: $hasUnsavedChanges, isCalibrated: $isCalibrated, calibrationDate: $calibrationDate, calibrationLevel: $calibrationLevel, sensorOffsets: $sensorOffsets, temperatureOffsets: $temperatureOffsets, zoneId: $zoneId, profileId: $profileId, deviceId: $deviceId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CalibrationState'))
      ..add(DiagnosticsProperty('activeType', activeType))
      ..add(DiagnosticsProperty('hasUnsavedChanges', hasUnsavedChanges))
      ..add(DiagnosticsProperty('isCalibrated', isCalibrated))
      ..add(DiagnosticsProperty('calibrationDate', calibrationDate))
      ..add(DiagnosticsProperty('calibrationLevel', calibrationLevel))
      ..add(DiagnosticsProperty('sensorOffsets', sensorOffsets))
      ..add(DiagnosticsProperty('temperatureOffsets', temperatureOffsets))
      ..add(DiagnosticsProperty('zoneId', zoneId))
      ..add(DiagnosticsProperty('profileId', profileId))
      ..add(DiagnosticsProperty('deviceId', deviceId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalibrationStateImpl &&
            (identical(other.activeType, activeType) ||
                other.activeType == activeType) &&
            (identical(other.hasUnsavedChanges, hasUnsavedChanges) ||
                other.hasUnsavedChanges == hasUnsavedChanges) &&
            (identical(other.isCalibrated, isCalibrated) ||
                other.isCalibrated == isCalibrated) &&
            (identical(other.calibrationDate, calibrationDate) ||
                other.calibrationDate == calibrationDate) &&
            (identical(other.calibrationLevel, calibrationLevel) ||
                other.calibrationLevel == calibrationLevel) &&
            const DeepCollectionEquality()
                .equals(other._sensorOffsets, _sensorOffsets) &&
            const DeepCollectionEquality()
                .equals(other._temperatureOffsets, _temperatureOffsets) &&
            (identical(other.zoneId, zoneId) || other.zoneId == zoneId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      activeType,
      hasUnsavedChanges,
      isCalibrated,
      calibrationDate,
      calibrationLevel,
      const DeepCollectionEquality().hash(_sensorOffsets),
      const DeepCollectionEquality().hash(_temperatureOffsets),
      zoneId,
      profileId,
      deviceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalibrationStateImplCopyWith<_$CalibrationStateImpl> get copyWith =>
      __$$CalibrationStateImplCopyWithImpl<_$CalibrationStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalibrationStateImplToJson(
      this,
    );
  }
}

abstract class _CalibrationState extends CalibrationState {
  const factory _CalibrationState(
      {@HiveField(0)
      @JsonKey(unknownEnumValue: CalibrationType.none)
      final CalibrationType activeType,
      @HiveField(1) final bool hasUnsavedChanges,
      @HiveField(2) final bool isCalibrated,
      @HiveField(3) @TimestampJsonConverter() final DateTime? calibrationDate,
      @HiveField(4) final double calibrationLevel,
      @HiveField(5)
      @DoubleMapJsonConverter()
      final Map<String, double> sensorOffsets,
      @HiveField(6)
      @DoubleMapJsonConverter()
      final Map<String, double> temperatureOffsets,
      @HiveField(7) final String? zoneId,
      @HiveField(8) final String? profileId,
      @HiveField(9) final String? deviceId}) = _$CalibrationStateImpl;
  const _CalibrationState._() : super._();

  factory _CalibrationState.fromJson(Map<String, dynamic> json) =
      _$CalibrationStateImpl.fromJson;

  @override
  @HiveField(0)
  @JsonKey(unknownEnumValue: CalibrationType.none)
  CalibrationType get activeType;
  @override
  @HiveField(1)
  bool get hasUnsavedChanges;
  @override

  /// Indique si le profil a été validé et appliqué sur l'appareil.
  @HiveField(2)
  bool get isCalibrated;
  @override

  /// Date de dernière calibration (UTC).
  @HiveField(3)
  @TimestampJsonConverter()
  DateTime? get calibrationDate;
  @override

  /// Progression globale de la calibration (0.0 – 1.0).
  @HiveField(4)
  double get calibrationLevel;
  @override

  /// Offsets en pourcentage pour les capteurs (ex : humidité, lumière).
  @HiveField(5)
  @DoubleMapJsonConverter()
  Map<String, double> get sensorOffsets;
  @override

  /// Offsets en degrés Celsius pour les capteurs de température.
  @HiveField(6)
  @DoubleMapJsonConverter()
  Map<String, double> get temperatureOffsets;
  @override

  /// Zone ou profil ciblé par la calibration.
  @HiveField(7)
  String? get zoneId;
  @override

  /// Identifiant du profil migré (legacy ou V2).
  @HiveField(8)
  String? get profileId;
  @override

  /// Identifiant du device associé.
  @HiveField(9)
  String? get deviceId;
  @override
  @JsonKey(ignore: true)
  _$$CalibrationStateImplCopyWith<_$CalibrationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
