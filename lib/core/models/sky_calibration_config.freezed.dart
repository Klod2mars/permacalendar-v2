// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sky_calibration_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SkyCalibrationConfig _$SkyCalibrationConfigFromJson(Map<String, dynamic> json) {
  return _SkyCalibrationConfig.fromJson(json);
}

/// @nodoc
mixin _$SkyCalibrationConfig {
  @HiveField(0)
  double get cx => throw _privateConstructorUsedError; // Centre X
  @HiveField(1)
  double get cy => throw _privateConstructorUsedError; // Centre Y
  @HiveField(2)
  double get rx => throw _privateConstructorUsedError; // Rayon X
  @HiveField(3)
  double get ry => throw _privateConstructorUsedError; // Rayon Y
  @HiveField(4)
  double get rotation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SkyCalibrationConfigCopyWith<SkyCalibrationConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkyCalibrationConfigCopyWith<$Res> {
  factory $SkyCalibrationConfigCopyWith(SkyCalibrationConfig value,
          $Res Function(SkyCalibrationConfig) then) =
      _$SkyCalibrationConfigCopyWithImpl<$Res, SkyCalibrationConfig>;
  @useResult
  $Res call(
      {@HiveField(0) double cx,
      @HiveField(1) double cy,
      @HiveField(2) double rx,
      @HiveField(3) double ry,
      @HiveField(4) double rotation});
}

/// @nodoc
class _$SkyCalibrationConfigCopyWithImpl<$Res,
        $Val extends SkyCalibrationConfig>
    implements $SkyCalibrationConfigCopyWith<$Res> {
  _$SkyCalibrationConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cx = null,
    Object? cy = null,
    Object? rx = null,
    Object? ry = null,
    Object? rotation = null,
  }) {
    return _then(_value.copyWith(
      cx: null == cx
          ? _value.cx
          : cx // ignore: cast_nullable_to_non_nullable
              as double,
      cy: null == cy
          ? _value.cy
          : cy // ignore: cast_nullable_to_non_nullable
              as double,
      rx: null == rx
          ? _value.rx
          : rx // ignore: cast_nullable_to_non_nullable
              as double,
      ry: null == ry
          ? _value.ry
          : ry // ignore: cast_nullable_to_non_nullable
              as double,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkyCalibrationConfigImplCopyWith<$Res>
    implements $SkyCalibrationConfigCopyWith<$Res> {
  factory _$$SkyCalibrationConfigImplCopyWith(_$SkyCalibrationConfigImpl value,
          $Res Function(_$SkyCalibrationConfigImpl) then) =
      __$$SkyCalibrationConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) double cx,
      @HiveField(1) double cy,
      @HiveField(2) double rx,
      @HiveField(3) double ry,
      @HiveField(4) double rotation});
}

/// @nodoc
class __$$SkyCalibrationConfigImplCopyWithImpl<$Res>
    extends _$SkyCalibrationConfigCopyWithImpl<$Res, _$SkyCalibrationConfigImpl>
    implements _$$SkyCalibrationConfigImplCopyWith<$Res> {
  __$$SkyCalibrationConfigImplCopyWithImpl(_$SkyCalibrationConfigImpl _value,
      $Res Function(_$SkyCalibrationConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cx = null,
    Object? cy = null,
    Object? rx = null,
    Object? ry = null,
    Object? rotation = null,
  }) {
    return _then(_$SkyCalibrationConfigImpl(
      cx: null == cx
          ? _value.cx
          : cx // ignore: cast_nullable_to_non_nullable
              as double,
      cy: null == cy
          ? _value.cy
          : cy // ignore: cast_nullable_to_non_nullable
              as double,
      rx: null == rx
          ? _value.rx
          : rx // ignore: cast_nullable_to_non_nullable
              as double,
      ry: null == ry
          ? _value.ry
          : ry // ignore: cast_nullable_to_non_nullable
              as double,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkyCalibrationConfigImpl
    with DiagnosticableTreeMixin
    implements _SkyCalibrationConfig {
  const _$SkyCalibrationConfigImpl(
      {@HiveField(0) this.cx = 0.5,
      @HiveField(1) this.cy = 0.35,
      @HiveField(2) this.rx = 0.4,
      @HiveField(3) this.ry = 0.3,
      @HiveField(4) this.rotation = 0.0});

  factory _$SkyCalibrationConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkyCalibrationConfigImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final double cx;
// Centre X
  @override
  @JsonKey()
  @HiveField(1)
  final double cy;
// Centre Y
  @override
  @JsonKey()
  @HiveField(2)
  final double rx;
// Rayon X
  @override
  @JsonKey()
  @HiveField(3)
  final double ry;
// Rayon Y
  @override
  @JsonKey()
  @HiveField(4)
  final double rotation;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SkyCalibrationConfig(cx: $cx, cy: $cy, rx: $rx, ry: $ry, rotation: $rotation)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SkyCalibrationConfig'))
      ..add(DiagnosticsProperty('cx', cx))
      ..add(DiagnosticsProperty('cy', cy))
      ..add(DiagnosticsProperty('rx', rx))
      ..add(DiagnosticsProperty('ry', ry))
      ..add(DiagnosticsProperty('rotation', rotation));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkyCalibrationConfigImpl &&
            (identical(other.cx, cx) || other.cx == cx) &&
            (identical(other.cy, cy) || other.cy == cy) &&
            (identical(other.rx, rx) || other.rx == rx) &&
            (identical(other.ry, ry) || other.ry == ry) &&
            (identical(other.rotation, rotation) ||
                other.rotation == rotation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, cx, cy, rx, ry, rotation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SkyCalibrationConfigImplCopyWith<_$SkyCalibrationConfigImpl>
      get copyWith =>
          __$$SkyCalibrationConfigImplCopyWithImpl<_$SkyCalibrationConfigImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkyCalibrationConfigImplToJson(
      this,
    );
  }
}

abstract class _SkyCalibrationConfig implements SkyCalibrationConfig {
  const factory _SkyCalibrationConfig(
      {@HiveField(0) final double cx,
      @HiveField(1) final double cy,
      @HiveField(2) final double rx,
      @HiveField(3) final double ry,
      @HiveField(4) final double rotation}) = _$SkyCalibrationConfigImpl;

  factory _SkyCalibrationConfig.fromJson(Map<String, dynamic> json) =
      _$SkyCalibrationConfigImpl.fromJson;

  @override
  @HiveField(0)
  double get cx;
  @override // Centre X
  @HiveField(1)
  double get cy;
  @override // Centre Y
  @HiveField(2)
  double get rx;
  @override // Rayon X
  @HiveField(3)
  double get ry;
  @override // Rayon Y
  @HiveField(4)
  double get rotation;
  @override
  @JsonKey(ignore: true)
  _$$SkyCalibrationConfigImplCopyWith<_$SkyCalibrationConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}
