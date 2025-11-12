// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'condition_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemperatureCondition _$TemperatureConditionFromJson(Map<String, dynamic> json) {
  return _TemperatureCondition.fromJson(json);
}

/// @nodoc
mixin _$TemperatureCondition {
  /// Température actuelle (°C)
  double get current => throw _privateConstructorUsedError;

  /// Température optimale pour la plante (°C)
  double get optimal => throw _privateConstructorUsedError;

  /// Température minimale tolérée (°C)
  double get min => throw _privateConstructorUsedError;

  /// Température maximale tolérée (°C)
  double get max => throw _privateConstructorUsedError;

  /// Indique si la température actuelle est dans la plage optimale
  bool get isOptimal => throw _privateConstructorUsedError;

  /// Description textuelle de l'état
  String get status => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TemperatureConditionCopyWith<TemperatureCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemperatureConditionCopyWith<$Res> {
  factory $TemperatureConditionCopyWith(TemperatureCondition value,
          $Res Function(TemperatureCondition) then) =
      _$TemperatureConditionCopyWithImpl<$Res, TemperatureCondition>;
  @useResult
  $Res call(
      {double current,
      double optimal,
      double min,
      double max,
      bool isOptimal,
      String status,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$TemperatureConditionCopyWithImpl<$Res,
        $Val extends TemperatureCondition>
    implements $TemperatureConditionCopyWith<$Res> {
  _$TemperatureConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? optimal = null,
    Object? min = null,
    Object? max = null,
    Object? isOptimal = null,
    Object? status = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      optimal: null == optimal
          ? _value.optimal
          : optimal // ignore: cast_nullable_to_non_nullable
              as double,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      isOptimal: null == isOptimal
          ? _value.isOptimal
          : isOptimal // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemperatureConditionImplCopyWith<$Res>
    implements $TemperatureConditionCopyWith<$Res> {
  factory _$$TemperatureConditionImplCopyWith(_$TemperatureConditionImpl value,
          $Res Function(_$TemperatureConditionImpl) then) =
      __$$TemperatureConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double current,
      double optimal,
      double min,
      double max,
      bool isOptimal,
      String status,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$TemperatureConditionImplCopyWithImpl<$Res>
    extends _$TemperatureConditionCopyWithImpl<$Res, _$TemperatureConditionImpl>
    implements _$$TemperatureConditionImplCopyWith<$Res> {
  __$$TemperatureConditionImplCopyWithImpl(_$TemperatureConditionImpl _value,
      $Res Function(_$TemperatureConditionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? optimal = null,
    Object? min = null,
    Object? max = null,
    Object? isOptimal = null,
    Object? status = null,
    Object? metadata = null,
  }) {
    return _then(_$TemperatureConditionImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      optimal: null == optimal
          ? _value.optimal
          : optimal // ignore: cast_nullable_to_non_nullable
              as double,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      isOptimal: null == isOptimal
          ? _value.isOptimal
          : isOptimal // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemperatureConditionImpl implements _TemperatureCondition {
  const _$TemperatureConditionImpl(
      {required this.current,
      required this.optimal,
      required this.min,
      required this.max,
      required this.isOptimal,
      required this.status,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$TemperatureConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemperatureConditionImplFromJson(json);

  /// Température actuelle (°C)
  @override
  final double current;

  /// Température optimale pour la plante (°C)
  @override
  final double optimal;

  /// Température minimale tolérée (°C)
  @override
  final double min;

  /// Température maximale tolérée (°C)
  @override
  final double max;

  /// Indique si la température actuelle est dans la plage optimale
  @override
  final bool isOptimal;

  /// Description textuelle de l'état
  @override
  final String status;

  /// Métadonnées additionnelles
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'TemperatureCondition(current: $current, optimal: $optimal, min: $min, max: $max, isOptimal: $isOptimal, status: $status, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemperatureConditionImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.optimal, optimal) || other.optimal == optimal) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.isOptimal, isOptimal) ||
                other.isOptimal == isOptimal) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, current, optimal, min, max,
      isOptimal, status, const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TemperatureConditionImplCopyWith<_$TemperatureConditionImpl>
      get copyWith =>
          __$$TemperatureConditionImplCopyWithImpl<_$TemperatureConditionImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemperatureConditionImplToJson(
      this,
    );
  }
}

abstract class _TemperatureCondition implements TemperatureCondition {
  const factory _TemperatureCondition(
      {required final double current,
      required final double optimal,
      required final double min,
      required final double max,
      required final bool isOptimal,
      required final String status,
      final Map<String, dynamic> metadata}) = _$TemperatureConditionImpl;

  factory _TemperatureCondition.fromJson(Map<String, dynamic> json) =
      _$TemperatureConditionImpl.fromJson;

  @override

  /// Température actuelle (°C)
  double get current;
  @override

  /// Température optimale pour la plante (°C)
  double get optimal;
  @override

  /// Température minimale tolérée (°C)
  double get min;
  @override

  /// Température maximale tolérée (°C)
  double get max;
  @override

  /// Indique si la température actuelle est dans la plage optimale
  bool get isOptimal;
  @override

  /// Description textuelle de l'état
  String get status;
  @override

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$TemperatureConditionImplCopyWith<_$TemperatureConditionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MoistureCondition _$MoistureConditionFromJson(Map<String, dynamic> json) {
  return _MoistureCondition.fromJson(json);
}

/// @nodoc
mixin _$MoistureCondition {
  /// Niveau d'humidité actuel (0-100%)
  double get current => throw _privateConstructorUsedError;

  /// Niveau d'humidité optimal (0-100%)
  double get optimal => throw _privateConstructorUsedError;

  /// Niveau minimum toléré (0-100%)
  double get min => throw _privateConstructorUsedError;

  /// Niveau maximum toléré (0-100%)
  double get max => throw _privateConstructorUsedError;

  /// Indique si l'humidité est dans la plage optimale
  bool get isOptimal => throw _privateConstructorUsedError;

  /// Description textuelle de l'état
  String get status => throw _privateConstructorUsedError;

  /// Type de mesure (sol, air, etc.)
  String get measurementType => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MoistureConditionCopyWith<MoistureCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoistureConditionCopyWith<$Res> {
  factory $MoistureConditionCopyWith(
          MoistureCondition value, $Res Function(MoistureCondition) then) =
      _$MoistureConditionCopyWithImpl<$Res, MoistureCondition>;
  @useResult
  $Res call(
      {double current,
      double optimal,
      double min,
      double max,
      bool isOptimal,
      String status,
      String measurementType,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$MoistureConditionCopyWithImpl<$Res, $Val extends MoistureCondition>
    implements $MoistureConditionCopyWith<$Res> {
  _$MoistureConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? optimal = null,
    Object? min = null,
    Object? max = null,
    Object? isOptimal = null,
    Object? status = null,
    Object? measurementType = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      optimal: null == optimal
          ? _value.optimal
          : optimal // ignore: cast_nullable_to_non_nullable
              as double,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      isOptimal: null == isOptimal
          ? _value.isOptimal
          : isOptimal // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      measurementType: null == measurementType
          ? _value.measurementType
          : measurementType // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoistureConditionImplCopyWith<$Res>
    implements $MoistureConditionCopyWith<$Res> {
  factory _$$MoistureConditionImplCopyWith(_$MoistureConditionImpl value,
          $Res Function(_$MoistureConditionImpl) then) =
      __$$MoistureConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double current,
      double optimal,
      double min,
      double max,
      bool isOptimal,
      String status,
      String measurementType,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$MoistureConditionImplCopyWithImpl<$Res>
    extends _$MoistureConditionCopyWithImpl<$Res, _$MoistureConditionImpl>
    implements _$$MoistureConditionImplCopyWith<$Res> {
  __$$MoistureConditionImplCopyWithImpl(_$MoistureConditionImpl _value,
      $Res Function(_$MoistureConditionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? optimal = null,
    Object? min = null,
    Object? max = null,
    Object? isOptimal = null,
    Object? status = null,
    Object? measurementType = null,
    Object? metadata = null,
  }) {
    return _then(_$MoistureConditionImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      optimal: null == optimal
          ? _value.optimal
          : optimal // ignore: cast_nullable_to_non_nullable
              as double,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      isOptimal: null == isOptimal
          ? _value.isOptimal
          : isOptimal // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      measurementType: null == measurementType
          ? _value.measurementType
          : measurementType // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoistureConditionImpl implements _MoistureCondition {
  const _$MoistureConditionImpl(
      {required this.current,
      required this.optimal,
      required this.min,
      required this.max,
      required this.isOptimal,
      required this.status,
      this.measurementType = 'soil',
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$MoistureConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoistureConditionImplFromJson(json);

  /// Niveau d'humidité actuel (0-100%)
  @override
  final double current;

  /// Niveau d'humidité optimal (0-100%)
  @override
  final double optimal;

  /// Niveau minimum toléré (0-100%)
  @override
  final double min;

  /// Niveau maximum toléré (0-100%)
  @override
  final double max;

  /// Indique si l'humidité est dans la plage optimale
  @override
  final bool isOptimal;

  /// Description textuelle de l'état
  @override
  final String status;

  /// Type de mesure (sol, air, etc.)
  @override
  @JsonKey()
  final String measurementType;

  /// Métadonnées additionnelles
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'MoistureCondition(current: $current, optimal: $optimal, min: $min, max: $max, isOptimal: $isOptimal, status: $status, measurementType: $measurementType, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoistureConditionImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.optimal, optimal) || other.optimal == optimal) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.isOptimal, isOptimal) ||
                other.isOptimal == isOptimal) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.measurementType, measurementType) ||
                other.measurementType == measurementType) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      current,
      optimal,
      min,
      max,
      isOptimal,
      status,
      measurementType,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoistureConditionImplCopyWith<_$MoistureConditionImpl> get copyWith =>
      __$$MoistureConditionImplCopyWithImpl<_$MoistureConditionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoistureConditionImplToJson(
      this,
    );
  }
}

abstract class _MoistureCondition implements MoistureCondition {
  const factory _MoistureCondition(
      {required final double current,
      required final double optimal,
      required final double min,
      required final double max,
      required final bool isOptimal,
      required final String status,
      final String measurementType,
      final Map<String, dynamic> metadata}) = _$MoistureConditionImpl;

  factory _MoistureCondition.fromJson(Map<String, dynamic> json) =
      _$MoistureConditionImpl.fromJson;

  @override

  /// Niveau d'humidité actuel (0-100%)
  double get current;
  @override

  /// Niveau d'humidité optimal (0-100%)
  double get optimal;
  @override

  /// Niveau minimum toléré (0-100%)
  double get min;
  @override

  /// Niveau maximum toléré (0-100%)
  double get max;
  @override

  /// Indique si l'humidité est dans la plage optimale
  bool get isOptimal;
  @override

  /// Description textuelle de l'état
  String get status;
  @override

  /// Type de mesure (sol, air, etc.)
  String get measurementType;
  @override

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$MoistureConditionImplCopyWith<_$MoistureConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LightCondition _$LightConditionFromJson(Map<String, dynamic> json) {
  return _LightCondition.fromJson(json);
}

/// @nodoc
mixin _$LightCondition {
  /// Intensité lumineuse actuelle (lux)
  double get current => throw _privateConstructorUsedError;

  /// Intensité optimale (lux)
  double get optimal => throw _privateConstructorUsedError;

  /// Intensité minimale tolérée (lux)
  double get min => throw _privateConstructorUsedError;

  /// Intensité maximale tolérée (lux)
  double get max => throw _privateConstructorUsedError;

  /// Heures de lumière directe par jour
  double get dailyHours => throw _privateConstructorUsedError;

  /// Heures optimales de lumière par jour
  double get optimalHours => throw _privateConstructorUsedError;

  /// Indique si la luminosité est optimale
  bool get isOptimal => throw _privateConstructorUsedError;

  /// Description textuelle de l'état
  String get status => throw _privateConstructorUsedError;

  /// Type d'exposition requis
  ExposureType get exposureType => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LightConditionCopyWith<LightCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LightConditionCopyWith<$Res> {
  factory $LightConditionCopyWith(
          LightCondition value, $Res Function(LightCondition) then) =
      _$LightConditionCopyWithImpl<$Res, LightCondition>;
  @useResult
  $Res call(
      {double current,
      double optimal,
      double min,
      double max,
      double dailyHours,
      double optimalHours,
      bool isOptimal,
      String status,
      ExposureType exposureType,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$LightConditionCopyWithImpl<$Res, $Val extends LightCondition>
    implements $LightConditionCopyWith<$Res> {
  _$LightConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? optimal = null,
    Object? min = null,
    Object? max = null,
    Object? dailyHours = null,
    Object? optimalHours = null,
    Object? isOptimal = null,
    Object? status = null,
    Object? exposureType = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      optimal: null == optimal
          ? _value.optimal
          : optimal // ignore: cast_nullable_to_non_nullable
              as double,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      dailyHours: null == dailyHours
          ? _value.dailyHours
          : dailyHours // ignore: cast_nullable_to_non_nullable
              as double,
      optimalHours: null == optimalHours
          ? _value.optimalHours
          : optimalHours // ignore: cast_nullable_to_non_nullable
              as double,
      isOptimal: null == isOptimal
          ? _value.isOptimal
          : isOptimal // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      exposureType: null == exposureType
          ? _value.exposureType
          : exposureType // ignore: cast_nullable_to_non_nullable
              as ExposureType,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LightConditionImplCopyWith<$Res>
    implements $LightConditionCopyWith<$Res> {
  factory _$$LightConditionImplCopyWith(_$LightConditionImpl value,
          $Res Function(_$LightConditionImpl) then) =
      __$$LightConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double current,
      double optimal,
      double min,
      double max,
      double dailyHours,
      double optimalHours,
      bool isOptimal,
      String status,
      ExposureType exposureType,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$LightConditionImplCopyWithImpl<$Res>
    extends _$LightConditionCopyWithImpl<$Res, _$LightConditionImpl>
    implements _$$LightConditionImplCopyWith<$Res> {
  __$$LightConditionImplCopyWithImpl(
      _$LightConditionImpl _value, $Res Function(_$LightConditionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? optimal = null,
    Object? min = null,
    Object? max = null,
    Object? dailyHours = null,
    Object? optimalHours = null,
    Object? isOptimal = null,
    Object? status = null,
    Object? exposureType = null,
    Object? metadata = null,
  }) {
    return _then(_$LightConditionImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      optimal: null == optimal
          ? _value.optimal
          : optimal // ignore: cast_nullable_to_non_nullable
              as double,
      min: null == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double,
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double,
      dailyHours: null == dailyHours
          ? _value.dailyHours
          : dailyHours // ignore: cast_nullable_to_non_nullable
              as double,
      optimalHours: null == optimalHours
          ? _value.optimalHours
          : optimalHours // ignore: cast_nullable_to_non_nullable
              as double,
      isOptimal: null == isOptimal
          ? _value.isOptimal
          : isOptimal // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      exposureType: null == exposureType
          ? _value.exposureType
          : exposureType // ignore: cast_nullable_to_non_nullable
              as ExposureType,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LightConditionImpl implements _LightCondition {
  const _$LightConditionImpl(
      {required this.current,
      required this.optimal,
      required this.min,
      required this.max,
      required this.dailyHours,
      required this.optimalHours,
      required this.isOptimal,
      required this.status,
      required this.exposureType,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$LightConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$LightConditionImplFromJson(json);

  /// Intensité lumineuse actuelle (lux)
  @override
  final double current;

  /// Intensité optimale (lux)
  @override
  final double optimal;

  /// Intensité minimale tolérée (lux)
  @override
  final double min;

  /// Intensité maximale tolérée (lux)
  @override
  final double max;

  /// Heures de lumière directe par jour
  @override
  final double dailyHours;

  /// Heures optimales de lumière par jour
  @override
  final double optimalHours;

  /// Indique si la luminosité est optimale
  @override
  final bool isOptimal;

  /// Description textuelle de l'état
  @override
  final String status;

  /// Type d'exposition requis
  @override
  final ExposureType exposureType;

  /// Métadonnées additionnelles
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'LightCondition(current: $current, optimal: $optimal, min: $min, max: $max, dailyHours: $dailyHours, optimalHours: $optimalHours, isOptimal: $isOptimal, status: $status, exposureType: $exposureType, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LightConditionImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.optimal, optimal) || other.optimal == optimal) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.dailyHours, dailyHours) ||
                other.dailyHours == dailyHours) &&
            (identical(other.optimalHours, optimalHours) ||
                other.optimalHours == optimalHours) &&
            (identical(other.isOptimal, isOptimal) ||
                other.isOptimal == isOptimal) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.exposureType, exposureType) ||
                other.exposureType == exposureType) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      current,
      optimal,
      min,
      max,
      dailyHours,
      optimalHours,
      isOptimal,
      status,
      exposureType,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LightConditionImplCopyWith<_$LightConditionImpl> get copyWith =>
      __$$LightConditionImplCopyWithImpl<_$LightConditionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LightConditionImplToJson(
      this,
    );
  }
}

abstract class _LightCondition implements LightCondition {
  const factory _LightCondition(
      {required final double current,
      required final double optimal,
      required final double min,
      required final double max,
      required final double dailyHours,
      required final double optimalHours,
      required final bool isOptimal,
      required final String status,
      required final ExposureType exposureType,
      final Map<String, dynamic> metadata}) = _$LightConditionImpl;

  factory _LightCondition.fromJson(Map<String, dynamic> json) =
      _$LightConditionImpl.fromJson;

  @override

  /// Intensité lumineuse actuelle (lux)
  double get current;
  @override

  /// Intensité optimale (lux)
  double get optimal;
  @override

  /// Intensité minimale tolérée (lux)
  double get min;
  @override

  /// Intensité maximale tolérée (lux)
  double get max;
  @override

  /// Heures de lumière directe par jour
  double get dailyHours;
  @override

  /// Heures optimales de lumière par jour
  double get optimalHours;
  @override

  /// Indique si la luminosité est optimale
  bool get isOptimal;
  @override

  /// Description textuelle de l'état
  String get status;
  @override

  /// Type d'exposition requis
  ExposureType get exposureType;
  @override

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$LightConditionImplCopyWith<_$LightConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SoilCondition _$SoilConditionFromJson(Map<String, dynamic> json) {
  return _SoilCondition.fromJson(json);
}

/// @nodoc
mixin _$SoilCondition {
  /// pH actuel du sol
  double get ph => throw _privateConstructorUsedError;

  /// pH optimal pour la plante
  double get optimalPh => throw _privateConstructorUsedError;

  /// pH minimum toléré
  double get minPh => throw _privateConstructorUsedError;

  /// pH maximum toléré
  double get maxPh => throw _privateConstructorUsedError;

  /// Type de sol
  SoilType get soilType => throw _privateConstructorUsedError;

  /// Niveau de nutriments (0-100%)
  double get nutrientLevel => throw _privateConstructorUsedError;

  /// Niveau de drainage (0-100%)
  double get drainageLevel => throw _privateConstructorUsedError;

  /// Niveau de compaction (0-100%, 0 = pas compacté)
  double get compactionLevel => throw _privateConstructorUsedError;

  /// Indique si les conditions du sol sont optimales
  bool get isOptimal => throw _privateConstructorUsedError;

  /// Description textuelle de l'état
  String get status => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles (analyses, amendements, etc.)
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SoilConditionCopyWith<SoilCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoilConditionCopyWith<$Res> {
  factory $SoilConditionCopyWith(
          SoilCondition value, $Res Function(SoilCondition) then) =
      _$SoilConditionCopyWithImpl<$Res, SoilCondition>;
  @useResult
  $Res call(
      {double ph,
      double optimalPh,
      double minPh,
      double maxPh,
      SoilType soilType,
      double nutrientLevel,
      double drainageLevel,
      double compactionLevel,
      bool isOptimal,
      String status,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$SoilConditionCopyWithImpl<$Res, $Val extends SoilCondition>
    implements $SoilConditionCopyWith<$Res> {
  _$SoilConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ph = null,
    Object? optimalPh = null,
    Object? minPh = null,
    Object? maxPh = null,
    Object? soilType = null,
    Object? nutrientLevel = null,
    Object? drainageLevel = null,
    Object? compactionLevel = null,
    Object? isOptimal = null,
    Object? status = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      ph: null == ph
          ? _value.ph
          : ph // ignore: cast_nullable_to_non_nullable
              as double,
      optimalPh: null == optimalPh
          ? _value.optimalPh
          : optimalPh // ignore: cast_nullable_to_non_nullable
              as double,
      minPh: null == minPh
          ? _value.minPh
          : minPh // ignore: cast_nullable_to_non_nullable
              as double,
      maxPh: null == maxPh
          ? _value.maxPh
          : maxPh // ignore: cast_nullable_to_non_nullable
              as double,
      soilType: null == soilType
          ? _value.soilType
          : soilType // ignore: cast_nullable_to_non_nullable
              as SoilType,
      nutrientLevel: null == nutrientLevel
          ? _value.nutrientLevel
          : nutrientLevel // ignore: cast_nullable_to_non_nullable
              as double,
      drainageLevel: null == drainageLevel
          ? _value.drainageLevel
          : drainageLevel // ignore: cast_nullable_to_non_nullable
              as double,
      compactionLevel: null == compactionLevel
          ? _value.compactionLevel
          : compactionLevel // ignore: cast_nullable_to_non_nullable
              as double,
      isOptimal: null == isOptimal
          ? _value.isOptimal
          : isOptimal // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SoilConditionImplCopyWith<$Res>
    implements $SoilConditionCopyWith<$Res> {
  factory _$$SoilConditionImplCopyWith(
          _$SoilConditionImpl value, $Res Function(_$SoilConditionImpl) then) =
      __$$SoilConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double ph,
      double optimalPh,
      double minPh,
      double maxPh,
      SoilType soilType,
      double nutrientLevel,
      double drainageLevel,
      double compactionLevel,
      bool isOptimal,
      String status,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$SoilConditionImplCopyWithImpl<$Res>
    extends _$SoilConditionCopyWithImpl<$Res, _$SoilConditionImpl>
    implements _$$SoilConditionImplCopyWith<$Res> {
  __$$SoilConditionImplCopyWithImpl(
      _$SoilConditionImpl _value, $Res Function(_$SoilConditionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ph = null,
    Object? optimalPh = null,
    Object? minPh = null,
    Object? maxPh = null,
    Object? soilType = null,
    Object? nutrientLevel = null,
    Object? drainageLevel = null,
    Object? compactionLevel = null,
    Object? isOptimal = null,
    Object? status = null,
    Object? metadata = null,
  }) {
    return _then(_$SoilConditionImpl(
      ph: null == ph
          ? _value.ph
          : ph // ignore: cast_nullable_to_non_nullable
              as double,
      optimalPh: null == optimalPh
          ? _value.optimalPh
          : optimalPh // ignore: cast_nullable_to_non_nullable
              as double,
      minPh: null == minPh
          ? _value.minPh
          : minPh // ignore: cast_nullable_to_non_nullable
              as double,
      maxPh: null == maxPh
          ? _value.maxPh
          : maxPh // ignore: cast_nullable_to_non_nullable
              as double,
      soilType: null == soilType
          ? _value.soilType
          : soilType // ignore: cast_nullable_to_non_nullable
              as SoilType,
      nutrientLevel: null == nutrientLevel
          ? _value.nutrientLevel
          : nutrientLevel // ignore: cast_nullable_to_non_nullable
              as double,
      drainageLevel: null == drainageLevel
          ? _value.drainageLevel
          : drainageLevel // ignore: cast_nullable_to_non_nullable
              as double,
      compactionLevel: null == compactionLevel
          ? _value.compactionLevel
          : compactionLevel // ignore: cast_nullable_to_non_nullable
              as double,
      isOptimal: null == isOptimal
          ? _value.isOptimal
          : isOptimal // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SoilConditionImpl implements _SoilCondition {
  const _$SoilConditionImpl(
      {required this.ph,
      required this.optimalPh,
      required this.minPh,
      required this.maxPh,
      required this.soilType,
      required this.nutrientLevel,
      required this.drainageLevel,
      required this.compactionLevel,
      required this.isOptimal,
      required this.status,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$SoilConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SoilConditionImplFromJson(json);

  /// pH actuel du sol
  @override
  final double ph;

  /// pH optimal pour la plante
  @override
  final double optimalPh;

  /// pH minimum toléré
  @override
  final double minPh;

  /// pH maximum toléré
  @override
  final double maxPh;

  /// Type de sol
  @override
  final SoilType soilType;

  /// Niveau de nutriments (0-100%)
  @override
  final double nutrientLevel;

  /// Niveau de drainage (0-100%)
  @override
  final double drainageLevel;

  /// Niveau de compaction (0-100%, 0 = pas compacté)
  @override
  final double compactionLevel;

  /// Indique si les conditions du sol sont optimales
  @override
  final bool isOptimal;

  /// Description textuelle de l'état
  @override
  final String status;

  /// Métadonnées additionnelles (analyses, amendements, etc.)
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles (analyses, amendements, etc.)
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'SoilCondition(ph: $ph, optimalPh: $optimalPh, minPh: $minPh, maxPh: $maxPh, soilType: $soilType, nutrientLevel: $nutrientLevel, drainageLevel: $drainageLevel, compactionLevel: $compactionLevel, isOptimal: $isOptimal, status: $status, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SoilConditionImpl &&
            (identical(other.ph, ph) || other.ph == ph) &&
            (identical(other.optimalPh, optimalPh) ||
                other.optimalPh == optimalPh) &&
            (identical(other.minPh, minPh) || other.minPh == minPh) &&
            (identical(other.maxPh, maxPh) || other.maxPh == maxPh) &&
            (identical(other.soilType, soilType) ||
                other.soilType == soilType) &&
            (identical(other.nutrientLevel, nutrientLevel) ||
                other.nutrientLevel == nutrientLevel) &&
            (identical(other.drainageLevel, drainageLevel) ||
                other.drainageLevel == drainageLevel) &&
            (identical(other.compactionLevel, compactionLevel) ||
                other.compactionLevel == compactionLevel) &&
            (identical(other.isOptimal, isOptimal) ||
                other.isOptimal == isOptimal) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      ph,
      optimalPh,
      minPh,
      maxPh,
      soilType,
      nutrientLevel,
      drainageLevel,
      compactionLevel,
      isOptimal,
      status,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SoilConditionImplCopyWith<_$SoilConditionImpl> get copyWith =>
      __$$SoilConditionImplCopyWithImpl<_$SoilConditionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SoilConditionImplToJson(
      this,
    );
  }
}

abstract class _SoilCondition implements SoilCondition {
  const factory _SoilCondition(
      {required final double ph,
      required final double optimalPh,
      required final double minPh,
      required final double maxPh,
      required final SoilType soilType,
      required final double nutrientLevel,
      required final double drainageLevel,
      required final double compactionLevel,
      required final bool isOptimal,
      required final String status,
      final Map<String, dynamic> metadata}) = _$SoilConditionImpl;

  factory _SoilCondition.fromJson(Map<String, dynamic> json) =
      _$SoilConditionImpl.fromJson;

  @override

  /// pH actuel du sol
  double get ph;
  @override

  /// pH optimal pour la plante
  double get optimalPh;
  @override

  /// pH minimum toléré
  double get minPh;
  @override

  /// pH maximum toléré
  double get maxPh;
  @override

  /// Type de sol
  SoilType get soilType;
  @override

  /// Niveau de nutriments (0-100%)
  double get nutrientLevel;
  @override

  /// Niveau de drainage (0-100%)
  double get drainageLevel;
  @override

  /// Niveau de compaction (0-100%, 0 = pas compacté)
  double get compactionLevel;
  @override

  /// Indique si les conditions du sol sont optimales
  bool get isOptimal;
  @override

  /// Description textuelle de l'état
  String get status;
  @override

  /// Métadonnées additionnelles (analyses, amendements, etc.)
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$SoilConditionImplCopyWith<_$SoilConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RiskFactor _$RiskFactorFromJson(Map<String, dynamic> json) {
  return _RiskFactor.fromJson(json);
}

/// @nodoc
mixin _$RiskFactor {
  /// Identifiant unique du risque
  String get id => throw _privateConstructorUsedError;

  /// Type de risque (maladie, parasite, météo, etc.)
  String get type => throw _privateConstructorUsedError;

  /// Nom du risque
  String get name => throw _privateConstructorUsedError;

  /// Description du risque
  String get description => throw _privateConstructorUsedError;

  /// Niveau de risque (0.0 à 1.0)
  double get severity => throw _privateConstructorUsedError;

  /// Probabilité d'occurrence (0.0 à 1.0)
  double get probability => throw _privateConstructorUsedError;

  /// Actions préventives recommandées
  List<String> get preventiveActions => throw _privateConstructorUsedError;

  /// Conditions favorisant ce risque
  List<String> get favoringConditions => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RiskFactorCopyWith<RiskFactor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiskFactorCopyWith<$Res> {
  factory $RiskFactorCopyWith(
          RiskFactor value, $Res Function(RiskFactor) then) =
      _$RiskFactorCopyWithImpl<$Res, RiskFactor>;
  @useResult
  $Res call(
      {String id,
      String type,
      String name,
      String description,
      double severity,
      double probability,
      List<String> preventiveActions,
      List<String> favoringConditions,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$RiskFactorCopyWithImpl<$Res, $Val extends RiskFactor>
    implements $RiskFactorCopyWith<$Res> {
  _$RiskFactorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? severity = null,
    Object? probability = null,
    Object? preventiveActions = null,
    Object? favoringConditions = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as double,
      probability: null == probability
          ? _value.probability
          : probability // ignore: cast_nullable_to_non_nullable
              as double,
      preventiveActions: null == preventiveActions
          ? _value.preventiveActions
          : preventiveActions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      favoringConditions: null == favoringConditions
          ? _value.favoringConditions
          : favoringConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RiskFactorImplCopyWith<$Res>
    implements $RiskFactorCopyWith<$Res> {
  factory _$$RiskFactorImplCopyWith(
          _$RiskFactorImpl value, $Res Function(_$RiskFactorImpl) then) =
      __$$RiskFactorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String name,
      String description,
      double severity,
      double probability,
      List<String> preventiveActions,
      List<String> favoringConditions,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$RiskFactorImplCopyWithImpl<$Res>
    extends _$RiskFactorCopyWithImpl<$Res, _$RiskFactorImpl>
    implements _$$RiskFactorImplCopyWith<$Res> {
  __$$RiskFactorImplCopyWithImpl(
      _$RiskFactorImpl _value, $Res Function(_$RiskFactorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? severity = null,
    Object? probability = null,
    Object? preventiveActions = null,
    Object? favoringConditions = null,
    Object? metadata = null,
  }) {
    return _then(_$RiskFactorImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as double,
      probability: null == probability
          ? _value.probability
          : probability // ignore: cast_nullable_to_non_nullable
              as double,
      preventiveActions: null == preventiveActions
          ? _value._preventiveActions
          : preventiveActions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      favoringConditions: null == favoringConditions
          ? _value._favoringConditions
          : favoringConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RiskFactorImpl implements _RiskFactor {
  const _$RiskFactorImpl(
      {required this.id,
      required this.type,
      required this.name,
      required this.description,
      required this.severity,
      required this.probability,
      required final List<String> preventiveActions,
      required final List<String> favoringConditions,
      final Map<String, dynamic> metadata = const {}})
      : _preventiveActions = preventiveActions,
        _favoringConditions = favoringConditions,
        _metadata = metadata;

  factory _$RiskFactorImpl.fromJson(Map<String, dynamic> json) =>
      _$$RiskFactorImplFromJson(json);

  /// Identifiant unique du risque
  @override
  final String id;

  /// Type de risque (maladie, parasite, météo, etc.)
  @override
  final String type;

  /// Nom du risque
  @override
  final String name;

  /// Description du risque
  @override
  final String description;

  /// Niveau de risque (0.0 à 1.0)
  @override
  final double severity;

  /// Probabilité d'occurrence (0.0 à 1.0)
  @override
  final double probability;

  /// Actions préventives recommandées
  final List<String> _preventiveActions;

  /// Actions préventives recommandées
  @override
  List<String> get preventiveActions {
    if (_preventiveActions is EqualUnmodifiableListView)
      return _preventiveActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preventiveActions);
  }

  /// Conditions favorisant ce risque
  final List<String> _favoringConditions;

  /// Conditions favorisant ce risque
  @override
  List<String> get favoringConditions {
    if (_favoringConditions is EqualUnmodifiableListView)
      return _favoringConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoringConditions);
  }

  /// Métadonnées additionnelles
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'RiskFactor(id: $id, type: $type, name: $name, description: $description, severity: $severity, probability: $probability, preventiveActions: $preventiveActions, favoringConditions: $favoringConditions, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiskFactorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.probability, probability) ||
                other.probability == probability) &&
            const DeepCollectionEquality()
                .equals(other._preventiveActions, _preventiveActions) &&
            const DeepCollectionEquality()
                .equals(other._favoringConditions, _favoringConditions) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      name,
      description,
      severity,
      probability,
      const DeepCollectionEquality().hash(_preventiveActions),
      const DeepCollectionEquality().hash(_favoringConditions),
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RiskFactorImplCopyWith<_$RiskFactorImpl> get copyWith =>
      __$$RiskFactorImplCopyWithImpl<_$RiskFactorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RiskFactorImplToJson(
      this,
    );
  }
}

abstract class _RiskFactor implements RiskFactor {
  const factory _RiskFactor(
      {required final String id,
      required final String type,
      required final String name,
      required final String description,
      required final double severity,
      required final double probability,
      required final List<String> preventiveActions,
      required final List<String> favoringConditions,
      final Map<String, dynamic> metadata}) = _$RiskFactorImpl;

  factory _RiskFactor.fromJson(Map<String, dynamic> json) =
      _$RiskFactorImpl.fromJson;

  @override

  /// Identifiant unique du risque
  String get id;
  @override

  /// Type de risque (maladie, parasite, météo, etc.)
  String get type;
  @override

  /// Nom du risque
  String get name;
  @override

  /// Description du risque
  String get description;
  @override

  /// Niveau de risque (0.0 à 1.0)
  double get severity;
  @override

  /// Probabilité d'occurrence (0.0 à 1.0)
  double get probability;
  @override

  /// Actions préventives recommandées
  List<String> get preventiveActions;
  @override

  /// Conditions favorisant ce risque
  List<String> get favoringConditions;
  @override

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$RiskFactorImplCopyWith<_$RiskFactorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Opportunity _$OpportunityFromJson(Map<String, dynamic> json) {
  return _Opportunity.fromJson(json);
}

/// @nodoc
mixin _$Opportunity {
  /// Identifiant unique de l'opportunité
  String get id => throw _privateConstructorUsedError;

  /// Type d'opportunité (plantation, récolte, traitement, etc.)
  String get type => throw _privateConstructorUsedError;

  /// Nom de l'opportunité
  String get name => throw _privateConstructorUsedError;

  /// Description de l'opportunité
  String get description => throw _privateConstructorUsedError;

  /// Bénéfice potentiel (0.0 à 1.0)
  double get benefit => throw _privateConstructorUsedError;

  /// Facilité de mise en œuvre (0.0 à 1.0)
  double get feasibility => throw _privateConstructorUsedError;

  /// Actions recommandées pour saisir l'opportunité
  List<String> get recommendedActions => throw _privateConstructorUsedError;

  /// Fenêtre temporelle optimale
  String get timeWindow => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OpportunityCopyWith<Opportunity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpportunityCopyWith<$Res> {
  factory $OpportunityCopyWith(
          Opportunity value, $Res Function(Opportunity) then) =
      _$OpportunityCopyWithImpl<$Res, Opportunity>;
  @useResult
  $Res call(
      {String id,
      String type,
      String name,
      String description,
      double benefit,
      double feasibility,
      List<String> recommendedActions,
      String timeWindow,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$OpportunityCopyWithImpl<$Res, $Val extends Opportunity>
    implements $OpportunityCopyWith<$Res> {
  _$OpportunityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? benefit = null,
    Object? feasibility = null,
    Object? recommendedActions = null,
    Object? timeWindow = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      benefit: null == benefit
          ? _value.benefit
          : benefit // ignore: cast_nullable_to_non_nullable
              as double,
      feasibility: null == feasibility
          ? _value.feasibility
          : feasibility // ignore: cast_nullable_to_non_nullable
              as double,
      recommendedActions: null == recommendedActions
          ? _value.recommendedActions
          : recommendedActions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timeWindow: null == timeWindow
          ? _value.timeWindow
          : timeWindow // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpportunityImplCopyWith<$Res>
    implements $OpportunityCopyWith<$Res> {
  factory _$$OpportunityImplCopyWith(
          _$OpportunityImpl value, $Res Function(_$OpportunityImpl) then) =
      __$$OpportunityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String name,
      String description,
      double benefit,
      double feasibility,
      List<String> recommendedActions,
      String timeWindow,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$OpportunityImplCopyWithImpl<$Res>
    extends _$OpportunityCopyWithImpl<$Res, _$OpportunityImpl>
    implements _$$OpportunityImplCopyWith<$Res> {
  __$$OpportunityImplCopyWithImpl(
      _$OpportunityImpl _value, $Res Function(_$OpportunityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? benefit = null,
    Object? feasibility = null,
    Object? recommendedActions = null,
    Object? timeWindow = null,
    Object? metadata = null,
  }) {
    return _then(_$OpportunityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      benefit: null == benefit
          ? _value.benefit
          : benefit // ignore: cast_nullable_to_non_nullable
              as double,
      feasibility: null == feasibility
          ? _value.feasibility
          : feasibility // ignore: cast_nullable_to_non_nullable
              as double,
      recommendedActions: null == recommendedActions
          ? _value._recommendedActions
          : recommendedActions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timeWindow: null == timeWindow
          ? _value.timeWindow
          : timeWindow // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpportunityImpl implements _Opportunity {
  const _$OpportunityImpl(
      {required this.id,
      required this.type,
      required this.name,
      required this.description,
      required this.benefit,
      required this.feasibility,
      required final List<String> recommendedActions,
      required this.timeWindow,
      final Map<String, dynamic> metadata = const {}})
      : _recommendedActions = recommendedActions,
        _metadata = metadata;

  factory _$OpportunityImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpportunityImplFromJson(json);

  /// Identifiant unique de l'opportunité
  @override
  final String id;

  /// Type d'opportunité (plantation, récolte, traitement, etc.)
  @override
  final String type;

  /// Nom de l'opportunité
  @override
  final String name;

  /// Description de l'opportunité
  @override
  final String description;

  /// Bénéfice potentiel (0.0 à 1.0)
  @override
  final double benefit;

  /// Facilité de mise en œuvre (0.0 à 1.0)
  @override
  final double feasibility;

  /// Actions recommandées pour saisir l'opportunité
  final List<String> _recommendedActions;

  /// Actions recommandées pour saisir l'opportunité
  @override
  List<String> get recommendedActions {
    if (_recommendedActions is EqualUnmodifiableListView)
      return _recommendedActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedActions);
  }

  /// Fenêtre temporelle optimale
  @override
  final String timeWindow;

  /// Métadonnées additionnelles
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'Opportunity(id: $id, type: $type, name: $name, description: $description, benefit: $benefit, feasibility: $feasibility, recommendedActions: $recommendedActions, timeWindow: $timeWindow, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpportunityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.benefit, benefit) || other.benefit == benefit) &&
            (identical(other.feasibility, feasibility) ||
                other.feasibility == feasibility) &&
            const DeepCollectionEquality()
                .equals(other._recommendedActions, _recommendedActions) &&
            (identical(other.timeWindow, timeWindow) ||
                other.timeWindow == timeWindow) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      name,
      description,
      benefit,
      feasibility,
      const DeepCollectionEquality().hash(_recommendedActions),
      timeWindow,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OpportunityImplCopyWith<_$OpportunityImpl> get copyWith =>
      __$$OpportunityImplCopyWithImpl<_$OpportunityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpportunityImplToJson(
      this,
    );
  }
}

abstract class _Opportunity implements Opportunity {
  const factory _Opportunity(
      {required final String id,
      required final String type,
      required final String name,
      required final String description,
      required final double benefit,
      required final double feasibility,
      required final List<String> recommendedActions,
      required final String timeWindow,
      final Map<String, dynamic> metadata}) = _$OpportunityImpl;

  factory _Opportunity.fromJson(Map<String, dynamic> json) =
      _$OpportunityImpl.fromJson;

  @override

  /// Identifiant unique de l'opportunité
  String get id;
  @override

  /// Type d'opportunité (plantation, récolte, traitement, etc.)
  String get type;
  @override

  /// Nom de l'opportunité
  String get name;
  @override

  /// Description de l'opportunité
  String get description;
  @override

  /// Bénéfice potentiel (0.0 à 1.0)
  double get benefit;
  @override

  /// Facilité de mise en œuvre (0.0 à 1.0)
  double get feasibility;
  @override

  /// Actions recommandées pour saisir l'opportunité
  List<String> get recommendedActions;
  @override

  /// Fenêtre temporelle optimale
  String get timeWindow;
  @override

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$OpportunityImplCopyWith<_$OpportunityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) {
  return _WeatherForecast.fromJson(json);
}

/// @nodoc
mixin _$WeatherForecast {
  /// Date de la prévision
  DateTime get date => throw _privateConstructorUsedError;

  /// Température minimale (°C)
  double get minTemperature => throw _privateConstructorUsedError;

  /// Température maximale (°C)
  double get maxTemperature => throw _privateConstructorUsedError;

  /// Humidité relative (%)
  double get humidity => throw _privateConstructorUsedError;

  /// Précipitations prévues (mm)
  double get precipitation => throw _privateConstructorUsedError;

  /// Probabilité de précipitations (%)
  double get precipitationProbability => throw _privateConstructorUsedError;

  /// Vitesse du vent (km/h)
  double get windSpeed => throw _privateConstructorUsedError;

  /// Couverture nuageuse (%)
  int get cloudCover => throw _privateConstructorUsedError;

  /// Condition météorologique générale
  String get condition => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeatherForecastCopyWith<WeatherForecast> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherForecastCopyWith<$Res> {
  factory $WeatherForecastCopyWith(
          WeatherForecast value, $Res Function(WeatherForecast) then) =
      _$WeatherForecastCopyWithImpl<$Res, WeatherForecast>;
  @useResult
  $Res call(
      {DateTime date,
      double minTemperature,
      double maxTemperature,
      double humidity,
      double precipitation,
      double precipitationProbability,
      double windSpeed,
      int cloudCover,
      String condition,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$WeatherForecastCopyWithImpl<$Res, $Val extends WeatherForecast>
    implements $WeatherForecastCopyWith<$Res> {
  _$WeatherForecastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? minTemperature = null,
    Object? maxTemperature = null,
    Object? humidity = null,
    Object? precipitation = null,
    Object? precipitationProbability = null,
    Object? windSpeed = null,
    Object? cloudCover = null,
    Object? condition = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      minTemperature: null == minTemperature
          ? _value.minTemperature
          : minTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      maxTemperature: null == maxTemperature
          ? _value.maxTemperature
          : maxTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as double,
      precipitation: null == precipitation
          ? _value.precipitation
          : precipitation // ignore: cast_nullable_to_non_nullable
              as double,
      precipitationProbability: null == precipitationProbability
          ? _value.precipitationProbability
          : precipitationProbability // ignore: cast_nullable_to_non_nullable
              as double,
      windSpeed: null == windSpeed
          ? _value.windSpeed
          : windSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      cloudCover: null == cloudCover
          ? _value.cloudCover
          : cloudCover // ignore: cast_nullable_to_non_nullable
              as int,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeatherForecastImplCopyWith<$Res>
    implements $WeatherForecastCopyWith<$Res> {
  factory _$$WeatherForecastImplCopyWith(_$WeatherForecastImpl value,
          $Res Function(_$WeatherForecastImpl) then) =
      __$$WeatherForecastImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      double minTemperature,
      double maxTemperature,
      double humidity,
      double precipitation,
      double precipitationProbability,
      double windSpeed,
      int cloudCover,
      String condition,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$WeatherForecastImplCopyWithImpl<$Res>
    extends _$WeatherForecastCopyWithImpl<$Res, _$WeatherForecastImpl>
    implements _$$WeatherForecastImplCopyWith<$Res> {
  __$$WeatherForecastImplCopyWithImpl(
      _$WeatherForecastImpl _value, $Res Function(_$WeatherForecastImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? minTemperature = null,
    Object? maxTemperature = null,
    Object? humidity = null,
    Object? precipitation = null,
    Object? precipitationProbability = null,
    Object? windSpeed = null,
    Object? cloudCover = null,
    Object? condition = null,
    Object? metadata = null,
  }) {
    return _then(_$WeatherForecastImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      minTemperature: null == minTemperature
          ? _value.minTemperature
          : minTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      maxTemperature: null == maxTemperature
          ? _value.maxTemperature
          : maxTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as double,
      precipitation: null == precipitation
          ? _value.precipitation
          : precipitation // ignore: cast_nullable_to_non_nullable
              as double,
      precipitationProbability: null == precipitationProbability
          ? _value.precipitationProbability
          : precipitationProbability // ignore: cast_nullable_to_non_nullable
              as double,
      windSpeed: null == windSpeed
          ? _value.windSpeed
          : windSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      cloudCover: null == cloudCover
          ? _value.cloudCover
          : cloudCover // ignore: cast_nullable_to_non_nullable
              as int,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherForecastImpl implements _WeatherForecast {
  const _$WeatherForecastImpl(
      {required this.date,
      required this.minTemperature,
      required this.maxTemperature,
      required this.humidity,
      required this.precipitation,
      required this.precipitationProbability,
      required this.windSpeed,
      required this.cloudCover,
      required this.condition,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$WeatherForecastImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherForecastImplFromJson(json);

  /// Date de la prévision
  @override
  final DateTime date;

  /// Température minimale (°C)
  @override
  final double minTemperature;

  /// Température maximale (°C)
  @override
  final double maxTemperature;

  /// Humidité relative (%)
  @override
  final double humidity;

  /// Précipitations prévues (mm)
  @override
  final double precipitation;

  /// Probabilité de précipitations (%)
  @override
  final double precipitationProbability;

  /// Vitesse du vent (km/h)
  @override
  final double windSpeed;

  /// Couverture nuageuse (%)
  @override
  final int cloudCover;

  /// Condition météorologique générale
  @override
  final String condition;

  /// Métadonnées additionnelles
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'WeatherForecast(date: $date, minTemperature: $minTemperature, maxTemperature: $maxTemperature, humidity: $humidity, precipitation: $precipitation, precipitationProbability: $precipitationProbability, windSpeed: $windSpeed, cloudCover: $cloudCover, condition: $condition, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherForecastImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.minTemperature, minTemperature) ||
                other.minTemperature == minTemperature) &&
            (identical(other.maxTemperature, maxTemperature) ||
                other.maxTemperature == maxTemperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.precipitation, precipitation) ||
                other.precipitation == precipitation) &&
            (identical(
                    other.precipitationProbability, precipitationProbability) ||
                other.precipitationProbability == precipitationProbability) &&
            (identical(other.windSpeed, windSpeed) ||
                other.windSpeed == windSpeed) &&
            (identical(other.cloudCover, cloudCover) ||
                other.cloudCover == cloudCover) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      minTemperature,
      maxTemperature,
      humidity,
      precipitation,
      precipitationProbability,
      windSpeed,
      cloudCover,
      condition,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherForecastImplCopyWith<_$WeatherForecastImpl> get copyWith =>
      __$$WeatherForecastImplCopyWithImpl<_$WeatherForecastImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherForecastImplToJson(
      this,
    );
  }
}

abstract class _WeatherForecast implements WeatherForecast {
  const factory _WeatherForecast(
      {required final DateTime date,
      required final double minTemperature,
      required final double maxTemperature,
      required final double humidity,
      required final double precipitation,
      required final double precipitationProbability,
      required final double windSpeed,
      required final int cloudCover,
      required final String condition,
      final Map<String, dynamic> metadata}) = _$WeatherForecastImpl;

  factory _WeatherForecast.fromJson(Map<String, dynamic> json) =
      _$WeatherForecastImpl.fromJson;

  @override

  /// Date de la prévision
  DateTime get date;
  @override

  /// Température minimale (°C)
  double get minTemperature;
  @override

  /// Température maximale (°C)
  double get maxTemperature;
  @override

  /// Humidité relative (%)
  double get humidity;
  @override

  /// Précipitations prévues (mm)
  double get precipitation;
  @override

  /// Probabilité de précipitations (%)
  double get precipitationProbability;
  @override

  /// Vitesse du vent (km/h)
  double get windSpeed;
  @override

  /// Couverture nuageuse (%)
  int get cloudCover;
  @override

  /// Condition météorologique générale
  String get condition;
  @override

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$WeatherForecastImplCopyWith<_$WeatherForecastImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanionPlant _$CompanionPlantFromJson(Map<String, dynamic> json) {
  return _CompanionPlant.fromJson(json);
}

/// @nodoc
mixin _$CompanionPlant {
  /// Identifiant de la plante compagne
  String get plantId => throw _privateConstructorUsedError;

  /// Nom de la plante compagne
  String get name => throw _privateConstructorUsedError;

  /// Type de relation (bénéfique, neutre, défavorable)
  String get relationshipType => throw _privateConstructorUsedError;

  /// Bénéfices de l'association
  List<String> get benefits => throw _privateConstructorUsedError;

  /// Distance recommandée (cm)
  double get recommendedDistance => throw _privateConstructorUsedError;

  /// Période d'association optimale
  String get optimalPeriod => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanionPlantCopyWith<CompanionPlant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanionPlantCopyWith<$Res> {
  factory $CompanionPlantCopyWith(
          CompanionPlant value, $Res Function(CompanionPlant) then) =
      _$CompanionPlantCopyWithImpl<$Res, CompanionPlant>;
  @useResult
  $Res call(
      {String plantId,
      String name,
      String relationshipType,
      List<String> benefits,
      double recommendedDistance,
      String optimalPeriod,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$CompanionPlantCopyWithImpl<$Res, $Val extends CompanionPlant>
    implements $CompanionPlantCopyWith<$Res> {
  _$CompanionPlantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? name = null,
    Object? relationshipType = null,
    Object? benefits = null,
    Object? recommendedDistance = null,
    Object? optimalPeriod = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipType: null == relationshipType
          ? _value.relationshipType
          : relationshipType // ignore: cast_nullable_to_non_nullable
              as String,
      benefits: null == benefits
          ? _value.benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendedDistance: null == recommendedDistance
          ? _value.recommendedDistance
          : recommendedDistance // ignore: cast_nullable_to_non_nullable
              as double,
      optimalPeriod: null == optimalPeriod
          ? _value.optimalPeriod
          : optimalPeriod // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanionPlantImplCopyWith<$Res>
    implements $CompanionPlantCopyWith<$Res> {
  factory _$$CompanionPlantImplCopyWith(_$CompanionPlantImpl value,
          $Res Function(_$CompanionPlantImpl) then) =
      __$$CompanionPlantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String plantId,
      String name,
      String relationshipType,
      List<String> benefits,
      double recommendedDistance,
      String optimalPeriod,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$CompanionPlantImplCopyWithImpl<$Res>
    extends _$CompanionPlantCopyWithImpl<$Res, _$CompanionPlantImpl>
    implements _$$CompanionPlantImplCopyWith<$Res> {
  __$$CompanionPlantImplCopyWithImpl(
      _$CompanionPlantImpl _value, $Res Function(_$CompanionPlantImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? name = null,
    Object? relationshipType = null,
    Object? benefits = null,
    Object? recommendedDistance = null,
    Object? optimalPeriod = null,
    Object? metadata = null,
  }) {
    return _then(_$CompanionPlantImpl(
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipType: null == relationshipType
          ? _value.relationshipType
          : relationshipType // ignore: cast_nullable_to_non_nullable
              as String,
      benefits: null == benefits
          ? _value._benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendedDistance: null == recommendedDistance
          ? _value.recommendedDistance
          : recommendedDistance // ignore: cast_nullable_to_non_nullable
              as double,
      optimalPeriod: null == optimalPeriod
          ? _value.optimalPeriod
          : optimalPeriod // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanionPlantImpl implements _CompanionPlant {
  const _$CompanionPlantImpl(
      {required this.plantId,
      required this.name,
      required this.relationshipType,
      required final List<String> benefits,
      required this.recommendedDistance,
      required this.optimalPeriod,
      final Map<String, dynamic> metadata = const {}})
      : _benefits = benefits,
        _metadata = metadata;

  factory _$CompanionPlantImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanionPlantImplFromJson(json);

  /// Identifiant de la plante compagne
  @override
  final String plantId;

  /// Nom de la plante compagne
  @override
  final String name;

  /// Type de relation (bénéfique, neutre, défavorable)
  @override
  final String relationshipType;

  /// Bénéfices de l'association
  final List<String> _benefits;

  /// Bénéfices de l'association
  @override
  List<String> get benefits {
    if (_benefits is EqualUnmodifiableListView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_benefits);
  }

  /// Distance recommandée (cm)
  @override
  final double recommendedDistance;

  /// Période d'association optimale
  @override
  final String optimalPeriod;

  /// Métadonnées additionnelles
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'CompanionPlant(plantId: $plantId, name: $name, relationshipType: $relationshipType, benefits: $benefits, recommendedDistance: $recommendedDistance, optimalPeriod: $optimalPeriod, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanionPlantImpl &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.relationshipType, relationshipType) ||
                other.relationshipType == relationshipType) &&
            const DeepCollectionEquality().equals(other._benefits, _benefits) &&
            (identical(other.recommendedDistance, recommendedDistance) ||
                other.recommendedDistance == recommendedDistance) &&
            (identical(other.optimalPeriod, optimalPeriod) ||
                other.optimalPeriod == optimalPeriod) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      plantId,
      name,
      relationshipType,
      const DeepCollectionEquality().hash(_benefits),
      recommendedDistance,
      optimalPeriod,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanionPlantImplCopyWith<_$CompanionPlantImpl> get copyWith =>
      __$$CompanionPlantImplCopyWithImpl<_$CompanionPlantImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanionPlantImplToJson(
      this,
    );
  }
}

abstract class _CompanionPlant implements CompanionPlant {
  const factory _CompanionPlant(
      {required final String plantId,
      required final String name,
      required final String relationshipType,
      required final List<String> benefits,
      required final double recommendedDistance,
      required final String optimalPeriod,
      final Map<String, dynamic> metadata}) = _$CompanionPlantImpl;

  factory _CompanionPlant.fromJson(Map<String, dynamic> json) =
      _$CompanionPlantImpl.fromJson;

  @override

  /// Identifiant de la plante compagne
  String get plantId;
  @override

  /// Nom de la plante compagne
  String get name;
  @override

  /// Type de relation (bénéfique, neutre, défavorable)
  String get relationshipType;
  @override

  /// Bénéfices de l'association
  List<String> get benefits;
  @override

  /// Distance recommandée (cm)
  double get recommendedDistance;
  @override

  /// Période d'association optimale
  String get optimalPeriod;
  @override

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$CompanionPlantImplCopyWith<_$CompanionPlantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

