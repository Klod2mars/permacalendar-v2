// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_condition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeatherCondition _$WeatherConditionFromJson(Map<String, dynamic> json) {
  return _WeatherCondition.fromJson(json);
}

/// @nodoc
mixin _$WeatherCondition {
  /// Identifiant unique de la condition météo
  String get id => throw _privateConstructorUsedError;

  /// Type de condition météorologique
  WeatherType get type => throw _privateConstructorUsedError;

  /// Valeur de la condition
  double get value => throw _privateConstructorUsedError;

  /// Unité de mesure
  String get unit => throw _privateConstructorUsedError;

  /// Description de la condition
  String? get description => throw _privateConstructorUsedError;

  /// Impact sur les plantes (positif, négatif, neutre)
  WeatherImpact? get impact => throw _privateConstructorUsedError;

  /// Date de la mesure
  DateTime get measuredAt => throw _privateConstructorUsedError;

  /// Coordonnées géographiques (latitude)
  double? get latitude => throw _privateConstructorUsedError;

  /// Coordonnées géographiques (longitude)
  double? get longitude => throw _privateConstructorUsedError;

  /// Date de création
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Date de dernière mise à jour
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeatherConditionCopyWith<WeatherCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherConditionCopyWith<$Res> {
  factory $WeatherConditionCopyWith(
          WeatherCondition value, $Res Function(WeatherCondition) then) =
      _$WeatherConditionCopyWithImpl<$Res, WeatherCondition>;
  @useResult
  $Res call(
      {String id,
      WeatherType type,
      double value,
      String unit,
      String? description,
      WeatherImpact? impact,
      DateTime measuredAt,
      double? latitude,
      double? longitude,
      DateTime? createdAt,
      DateTime? updatedAt});

  $WeatherImpactCopyWith<$Res>? get impact;
}

/// @nodoc
class _$WeatherConditionCopyWithImpl<$Res, $Val extends WeatherCondition>
    implements $WeatherConditionCopyWith<$Res> {
  _$WeatherConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? value = null,
    Object? unit = null,
    Object? description = freezed,
    Object? impact = freezed,
    Object? measuredAt = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WeatherType,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      impact: freezed == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as WeatherImpact?,
      measuredAt: null == measuredAt
          ? _value.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WeatherImpactCopyWith<$Res>? get impact {
    if (_value.impact == null) {
      return null;
    }

    return $WeatherImpactCopyWith<$Res>(_value.impact!, (value) {
      return _then(_value.copyWith(impact: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WeatherConditionImplCopyWith<$Res>
    implements $WeatherConditionCopyWith<$Res> {
  factory _$$WeatherConditionImplCopyWith(_$WeatherConditionImpl value,
          $Res Function(_$WeatherConditionImpl) then) =
      __$$WeatherConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      WeatherType type,
      double value,
      String unit,
      String? description,
      WeatherImpact? impact,
      DateTime measuredAt,
      double? latitude,
      double? longitude,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $WeatherImpactCopyWith<$Res>? get impact;
}

/// @nodoc
class __$$WeatherConditionImplCopyWithImpl<$Res>
    extends _$WeatherConditionCopyWithImpl<$Res, _$WeatherConditionImpl>
    implements _$$WeatherConditionImplCopyWith<$Res> {
  __$$WeatherConditionImplCopyWithImpl(_$WeatherConditionImpl _value,
      $Res Function(_$WeatherConditionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? value = null,
    Object? unit = null,
    Object? description = freezed,
    Object? impact = freezed,
    Object? measuredAt = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WeatherConditionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WeatherType,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      impact: freezed == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as WeatherImpact?,
      measuredAt: null == measuredAt
          ? _value.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherConditionImpl implements _WeatherCondition {
  const _$WeatherConditionImpl(
      {required this.id,
      required this.type,
      required this.value,
      required this.unit,
      this.description,
      this.impact,
      required this.measuredAt,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt});

  factory _$WeatherConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherConditionImplFromJson(json);

  /// Identifiant unique de la condition météo
  @override
  final String id;

  /// Type de condition météorologique
  @override
  final WeatherType type;

  /// Valeur de la condition
  @override
  final double value;

  /// Unité de mesure
  @override
  final String unit;

  /// Description de la condition
  @override
  final String? description;

  /// Impact sur les plantes (positif, négatif, neutre)
  @override
  final WeatherImpact? impact;

  /// Date de la mesure
  @override
  final DateTime measuredAt;

  /// Coordonnées géographiques (latitude)
  @override
  final double? latitude;

  /// Coordonnées géographiques (longitude)
  @override
  final double? longitude;

  /// Date de création
  @override
  final DateTime? createdAt;

  /// Date de dernière mise à jour
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WeatherCondition(id: $id, type: $type, value: $value, unit: $unit, description: $description, impact: $impact, measuredAt: $measuredAt, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherConditionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.impact, impact) || other.impact == impact) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      value,
      unit,
      description,
      impact,
      measuredAt,
      latitude,
      longitude,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherConditionImplCopyWith<_$WeatherConditionImpl> get copyWith =>
      __$$WeatherConditionImplCopyWithImpl<_$WeatherConditionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherConditionImplToJson(
      this,
    );
  }
}

abstract class _WeatherCondition implements WeatherCondition {
  const factory _WeatherCondition(
      {required final String id,
      required final WeatherType type,
      required final double value,
      required final String unit,
      final String? description,
      final WeatherImpact? impact,
      required final DateTime measuredAt,
      final double? latitude,
      final double? longitude,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$WeatherConditionImpl;

  factory _WeatherCondition.fromJson(Map<String, dynamic> json) =
      _$WeatherConditionImpl.fromJson;

  @override

  /// Identifiant unique de la condition météo
  String get id;
  @override

  /// Type de condition météorologique
  WeatherType get type;
  @override

  /// Valeur de la condition
  double get value;
  @override

  /// Unité de mesure
  String get unit;
  @override

  /// Description de la condition
  String? get description;
  @override

  /// Impact sur les plantes (positif, négatif, neutre)
  WeatherImpact? get impact;
  @override

  /// Date de la mesure
  DateTime get measuredAt;
  @override

  /// Coordonnées géographiques (latitude)
  double? get latitude;
  @override

  /// Coordonnées géographiques (longitude)
  double? get longitude;
  @override

  /// Date de création
  DateTime? get createdAt;
  @override

  /// Date de dernière mise à jour
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WeatherConditionImplCopyWith<_$WeatherConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeatherImpact _$WeatherImpactFromJson(Map<String, dynamic> json) {
  return _WeatherImpact.fromJson(json);
}

/// @nodoc
mixin _$WeatherImpact {
  /// Type d'impact
  ImpactType get type => throw _privateConstructorUsedError;

  /// Intensité de l'impact (0-100)
  double get intensity => throw _privateConstructorUsedError;

  /// Description de l'impact
  String get description => throw _privateConstructorUsedError;

  /// Plantes affectées
  List<String>? get affectedPlants => throw _privateConstructorUsedError;

  /// Recommandations pour atténuer l'impact
  List<String>? get recommendations => throw _privateConstructorUsedError;

  /// Durée estimée de l'impact
  Duration? get duration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeatherImpactCopyWith<WeatherImpact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherImpactCopyWith<$Res> {
  factory $WeatherImpactCopyWith(
          WeatherImpact value, $Res Function(WeatherImpact) then) =
      _$WeatherImpactCopyWithImpl<$Res, WeatherImpact>;
  @useResult
  $Res call(
      {ImpactType type,
      double intensity,
      String description,
      List<String>? affectedPlants,
      List<String>? recommendations,
      Duration? duration});
}

/// @nodoc
class _$WeatherImpactCopyWithImpl<$Res, $Val extends WeatherImpact>
    implements $WeatherImpactCopyWith<$Res> {
  _$WeatherImpactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? intensity = null,
    Object? description = null,
    Object? affectedPlants = freezed,
    Object? recommendations = freezed,
    Object? duration = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ImpactType,
      intensity: null == intensity
          ? _value.intensity
          : intensity // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      affectedPlants: freezed == affectedPlants
          ? _value.affectedPlants
          : affectedPlants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      recommendations: freezed == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeatherImpactImplCopyWith<$Res>
    implements $WeatherImpactCopyWith<$Res> {
  factory _$$WeatherImpactImplCopyWith(
          _$WeatherImpactImpl value, $Res Function(_$WeatherImpactImpl) then) =
      __$$WeatherImpactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ImpactType type,
      double intensity,
      String description,
      List<String>? affectedPlants,
      List<String>? recommendations,
      Duration? duration});
}

/// @nodoc
class __$$WeatherImpactImplCopyWithImpl<$Res>
    extends _$WeatherImpactCopyWithImpl<$Res, _$WeatherImpactImpl>
    implements _$$WeatherImpactImplCopyWith<$Res> {
  __$$WeatherImpactImplCopyWithImpl(
      _$WeatherImpactImpl _value, $Res Function(_$WeatherImpactImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? intensity = null,
    Object? description = null,
    Object? affectedPlants = freezed,
    Object? recommendations = freezed,
    Object? duration = freezed,
  }) {
    return _then(_$WeatherImpactImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ImpactType,
      intensity: null == intensity
          ? _value.intensity
          : intensity // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      affectedPlants: freezed == affectedPlants
          ? _value._affectedPlants
          : affectedPlants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      recommendations: freezed == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherImpactImpl implements _WeatherImpact {
  const _$WeatherImpactImpl(
      {required this.type,
      required this.intensity,
      required this.description,
      final List<String>? affectedPlants,
      final List<String>? recommendations,
      this.duration})
      : _affectedPlants = affectedPlants,
        _recommendations = recommendations;

  factory _$WeatherImpactImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherImpactImplFromJson(json);

  /// Type d'impact
  @override
  final ImpactType type;

  /// Intensité de l'impact (0-100)
  @override
  final double intensity;

  /// Description de l'impact
  @override
  final String description;

  /// Plantes affectées
  final List<String>? _affectedPlants;

  /// Plantes affectées
  @override
  List<String>? get affectedPlants {
    final value = _affectedPlants;
    if (value == null) return null;
    if (_affectedPlants is EqualUnmodifiableListView) return _affectedPlants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Recommandations pour atténuer l'impact
  final List<String>? _recommendations;

  /// Recommandations pour atténuer l'impact
  @override
  List<String>? get recommendations {
    final value = _recommendations;
    if (value == null) return null;
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Durée estimée de l'impact
  @override
  final Duration? duration;

  @override
  String toString() {
    return 'WeatherImpact(type: $type, intensity: $intensity, description: $description, affectedPlants: $affectedPlants, recommendations: $recommendations, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherImpactImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._affectedPlants, _affectedPlants) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      intensity,
      description,
      const DeepCollectionEquality().hash(_affectedPlants),
      const DeepCollectionEquality().hash(_recommendations),
      duration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherImpactImplCopyWith<_$WeatherImpactImpl> get copyWith =>
      __$$WeatherImpactImplCopyWithImpl<_$WeatherImpactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherImpactImplToJson(
      this,
    );
  }
}

abstract class _WeatherImpact implements WeatherImpact {
  const factory _WeatherImpact(
      {required final ImpactType type,
      required final double intensity,
      required final String description,
      final List<String>? affectedPlants,
      final List<String>? recommendations,
      final Duration? duration}) = _$WeatherImpactImpl;

  factory _WeatherImpact.fromJson(Map<String, dynamic> json) =
      _$WeatherImpactImpl.fromJson;

  @override

  /// Type d'impact
  ImpactType get type;
  @override

  /// Intensité de l'impact (0-100)
  double get intensity;
  @override

  /// Description de l'impact
  String get description;
  @override

  /// Plantes affectées
  List<String>? get affectedPlants;
  @override

  /// Recommandations pour atténuer l'impact
  List<String>? get recommendations;
  @override

  /// Durée estimée de l'impact
  Duration? get duration;
  @override
  @JsonKey(ignore: true)
  _$$WeatherImpactImplCopyWith<_$WeatherImpactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

