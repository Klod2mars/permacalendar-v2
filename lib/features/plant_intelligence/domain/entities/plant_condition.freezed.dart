// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_condition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlantCondition _$PlantConditionFromJson(Map<String, dynamic> json) {
  return _PlantCondition.fromJson(json);
}

/// @nodoc
mixin _$PlantCondition {
  /// Identifiant unique de la condition
  String get id => throw _privateConstructorUsedError;

  /// ID de la plante concernée
  String get plantId => throw _privateConstructorUsedError;

  /// ID du jardin (pour le multi-garden)
  String get gardenId => throw _privateConstructorUsedError;

  /// Type de condition mesurée
  ConditionType get type => throw _privateConstructorUsedError;

  /// Statut actuel de la condition
  ConditionStatus get status => throw _privateConstructorUsedError;

  /// Valeur numérique de la condition (0-100)
  double get value => throw _privateConstructorUsedError;

  /// Valeur optimale pour cette plante
  double get optimalValue => throw _privateConstructorUsedError;

  /// Valeur minimale acceptable
  double get minValue => throw _privateConstructorUsedError;

  /// Valeur maximale acceptable
  double get maxValue => throw _privateConstructorUsedError;

  /// Unité de mesure (CÂ°, %, lux, etc.)
  String get unit => throw _privateConstructorUsedError;

  /// Description de la condition
  String? get description => throw _privateConstructorUsedError;

  /// Recommandations pour améliorer cette condition
  List<String>? get recommendations => throw _privateConstructorUsedError;

  /// Date de la mesure
  DateTime get measuredAt => throw _privateConstructorUsedError;

  /// Date de Création
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Date de dernière mise à jour
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlantConditionCopyWith<PlantCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantConditionCopyWith<$Res> {
  factory $PlantConditionCopyWith(
          PlantCondition value, $Res Function(PlantCondition) then) =
      _$PlantConditionCopyWithImpl<$Res, PlantCondition>;
  @useResult
  $Res call(
      {String id,
      String plantId,
      String gardenId,
      ConditionType type,
      ConditionStatus status,
      double value,
      double optimalValue,
      double minValue,
      double maxValue,
      String unit,
      String? description,
      List<String>? recommendations,
      DateTime measuredAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$PlantConditionCopyWithImpl<$Res, $Val extends PlantCondition>
    implements $PlantConditionCopyWith<$Res> {
  _$PlantConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plantId = null,
    Object? gardenId = null,
    Object? type = null,
    Object? status = null,
    Object? value = null,
    Object? optimalValue = null,
    Object? minValue = null,
    Object? maxValue = null,
    Object? unit = null,
    Object? description = freezed,
    Object? recommendations = freezed,
    Object? measuredAt = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ConditionType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConditionStatus,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      optimalValue: null == optimalValue
          ? _value.optimalValue
          : optimalValue // ignore: cast_nullable_to_non_nullable
              as double,
      minValue: null == minValue
          ? _value.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxValue: null == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      recommendations: freezed == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      measuredAt: null == measuredAt
          ? _value.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
}

/// @nodoc
abstract class _$$PlantConditionImplCopyWith<$Res>
    implements $PlantConditionCopyWith<$Res> {
  factory _$$PlantConditionImplCopyWith(_$PlantConditionImpl value,
          $Res Function(_$PlantConditionImpl) then) =
      __$$PlantConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String plantId,
      String gardenId,
      ConditionType type,
      ConditionStatus status,
      double value,
      double optimalValue,
      double minValue,
      double maxValue,
      String unit,
      String? description,
      List<String>? recommendations,
      DateTime measuredAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$PlantConditionImplCopyWithImpl<$Res>
    extends _$PlantConditionCopyWithImpl<$Res, _$PlantConditionImpl>
    implements _$$PlantConditionImplCopyWith<$Res> {
  __$$PlantConditionImplCopyWithImpl(
      _$PlantConditionImpl _value, $Res Function(_$PlantConditionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plantId = null,
    Object? gardenId = null,
    Object? type = null,
    Object? status = null,
    Object? value = null,
    Object? optimalValue = null,
    Object? minValue = null,
    Object? maxValue = null,
    Object? unit = null,
    Object? description = freezed,
    Object? recommendations = freezed,
    Object? measuredAt = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PlantConditionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ConditionType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConditionStatus,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      optimalValue: null == optimalValue
          ? _value.optimalValue
          : optimalValue // ignore: cast_nullable_to_non_nullable
              as double,
      minValue: null == minValue
          ? _value.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxValue: null == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      recommendations: freezed == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      measuredAt: null == measuredAt
          ? _value.measuredAt
          : measuredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
class _$PlantConditionImpl implements _PlantCondition {
  const _$PlantConditionImpl(
      {required this.id,
      required this.plantId,
      required this.gardenId,
      required this.type,
      required this.status,
      required this.value,
      required this.optimalValue,
      required this.minValue,
      required this.maxValue,
      required this.unit,
      this.description,
      final List<String>? recommendations,
      required this.measuredAt,
      this.createdAt,
      this.updatedAt})
      : _recommendations = recommendations;

  factory _$PlantConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantConditionImplFromJson(json);

  /// Identifiant unique de la condition
  @override
  final String id;

  /// ID de la plante concernée
  @override
  final String plantId;

  /// ID du jardin (pour le multi-garden)
  @override
  final String gardenId;

  /// Type de condition mesurée
  @override
  final ConditionType type;

  /// Statut actuel de la condition
  @override
  final ConditionStatus status;

  /// Valeur numérique de la condition (0-100)
  @override
  final double value;

  /// Valeur optimale pour cette plante
  @override
  final double optimalValue;

  /// Valeur minimale acceptable
  @override
  final double minValue;

  /// Valeur maximale acceptable
  @override
  final double maxValue;

  /// Unité de mesure (CÂ°, %, lux, etc.)
  @override
  final String unit;

  /// Description de la condition
  @override
  final String? description;

  /// Recommandations pour améliorer cette condition
  final List<String>? _recommendations;

  /// Recommandations pour améliorer cette condition
  @override
  List<String>? get recommendations {
    final value = _recommendations;
    if (value == null) return null;
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Date de la mesure
  @override
  final DateTime measuredAt;

  /// Date de Création
  @override
  final DateTime? createdAt;

  /// Date de dernière mise à jour
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PlantCondition(id: $id, plantId: $plantId, gardenId: $gardenId, type: $type, status: $status, value: $value, optimalValue: $optimalValue, minValue: $minValue, maxValue: $maxValue, unit: $unit, description: $description, recommendations: $recommendations, measuredAt: $measuredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantConditionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.optimalValue, optimalValue) ||
                other.optimalValue == optimalValue) &&
            (identical(other.minValue, minValue) ||
                other.minValue == minValue) &&
            (identical(other.maxValue, maxValue) ||
                other.maxValue == maxValue) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt) &&
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
      plantId,
      gardenId,
      type,
      status,
      value,
      optimalValue,
      minValue,
      maxValue,
      unit,
      description,
      const DeepCollectionEquality().hash(_recommendations),
      measuredAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantConditionImplCopyWith<_$PlantConditionImpl> get copyWith =>
      __$$PlantConditionImplCopyWithImpl<_$PlantConditionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantConditionImplToJson(
      this,
    );
  }
}

abstract class _PlantCondition implements PlantCondition {
  const factory _PlantCondition(
      {required final String id,
      required final String plantId,
      required final String gardenId,
      required final ConditionType type,
      required final ConditionStatus status,
      required final double value,
      required final double optimalValue,
      required final double minValue,
      required final double maxValue,
      required final String unit,
      final String? description,
      final List<String>? recommendations,
      required final DateTime measuredAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$PlantConditionImpl;

  factory _PlantCondition.fromJson(Map<String, dynamic> json) =
      _$PlantConditionImpl.fromJson;

  @override

  /// Identifiant unique de la condition
  String get id;
  @override

  /// ID de la plante concernée
  String get plantId;
  @override

  /// ID du jardin (pour le multi-garden)
  String get gardenId;
  @override

  /// Type de condition mesurée
  ConditionType get type;
  @override

  /// Statut actuel de la condition
  ConditionStatus get status;
  @override

  /// Valeur numérique de la condition (0-100)
  double get value;
  @override

  /// Valeur optimale pour cette plante
  double get optimalValue;
  @override

  /// Valeur minimale acceptable
  double get minValue;
  @override

  /// Valeur maximale acceptable
  double get maxValue;
  @override

  /// Unité de mesure (CÂ°, %, lux, etc.)
  String get unit;
  @override

  /// Description de la condition
  String? get description;
  @override

  /// Recommandations pour améliorer cette condition
  List<String>? get recommendations;
  @override

  /// Date de la mesure
  DateTime get measuredAt;
  @override

  /// Date de Création
  DateTime? get createdAt;
  @override

  /// Date de dernière mise à jour
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PlantConditionImplCopyWith<_$PlantConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
