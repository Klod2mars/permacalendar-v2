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

/// @nodoc
mixin _$CalibrationState {
  CalibrationType get activeType => throw _privateConstructorUsedError;
  bool get hasUnsavedChanges => throw _privateConstructorUsedError;

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
  $Res call({CalibrationType activeType, bool hasUnsavedChanges});
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
  $Res call({CalibrationType activeType, bool hasUnsavedChanges});
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
    ));
  }
}

/// @nodoc

class _$CalibrationStateImpl
    with DiagnosticableTreeMixin
    implements _CalibrationState {
  const _$CalibrationStateImpl(
      {this.activeType = CalibrationType.none, this.hasUnsavedChanges = false});

  @override
  @JsonKey()
  final CalibrationType activeType;
  @override
  @JsonKey()
  final bool hasUnsavedChanges;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CalibrationState(activeType: $activeType, hasUnsavedChanges: $hasUnsavedChanges)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CalibrationState'))
      ..add(DiagnosticsProperty('activeType', activeType))
      ..add(DiagnosticsProperty('hasUnsavedChanges', hasUnsavedChanges));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalibrationStateImpl &&
            (identical(other.activeType, activeType) ||
                other.activeType == activeType) &&
            (identical(other.hasUnsavedChanges, hasUnsavedChanges) ||
                other.hasUnsavedChanges == hasUnsavedChanges));
  }

  @override
  int get hashCode => Object.hash(runtimeType, activeType, hasUnsavedChanges);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalibrationStateImplCopyWith<_$CalibrationStateImpl> get copyWith =>
      __$$CalibrationStateImplCopyWithImpl<_$CalibrationStateImpl>(
          this, _$identity);
}

abstract class _CalibrationState implements CalibrationState {
  const factory _CalibrationState(
      {final CalibrationType activeType,
      final bool hasUnsavedChanges}) = _$CalibrationStateImpl;

  @override
  CalibrationType get activeType;
  @override
  bool get hasUnsavedChanges;
  @override
  @JsonKey(ignore: true)
  _$$CalibrationStateImplCopyWith<_$CalibrationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

