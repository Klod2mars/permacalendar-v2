// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pest_observation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PestObservation _$PestObservationFromJson(Map<String, dynamic> json) {
  return _PestObservation.fromJson(json);
}

/// @nodoc
mixin _$PestObservation {
  String get id => throw _privateConstructorUsedError;
  String get pestId => throw _privateConstructorUsedError;
  String get plantId => throw _privateConstructorUsedError;
  String get gardenId => throw _privateConstructorUsedError;
  DateTime get observedAt => throw _privateConstructorUsedError;
  PestSeverity get severity => throw _privateConstructorUsedError;
  String? get bedId =>
      throw _privateConstructorUsedError; // Optional: specific bed where observed
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get photoUrls => throw _privateConstructorUsedError;
  bool? get isActive =>
      throw _privateConstructorUsedError; // Whether the observation is still active
  DateTime? get resolvedAt =>
      throw _privateConstructorUsedError; // When the pest issue was resolved
  String? get resolutionMethod => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PestObservationCopyWith<PestObservation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PestObservationCopyWith<$Res> {
  factory $PestObservationCopyWith(
          PestObservation value, $Res Function(PestObservation) then) =
      _$PestObservationCopyWithImpl<$Res, PestObservation>;
  @useResult
  $Res call(
      {String id,
      String pestId,
      String plantId,
      String gardenId,
      DateTime observedAt,
      PestSeverity severity,
      String? bedId,
      String? notes,
      List<String>? photoUrls,
      bool? isActive,
      DateTime? resolvedAt,
      String? resolutionMethod});
}

/// @nodoc
class _$PestObservationCopyWithImpl<$Res, $Val extends PestObservation>
    implements $PestObservationCopyWith<$Res> {
  _$PestObservationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pestId = null,
    Object? plantId = null,
    Object? gardenId = null,
    Object? observedAt = null,
    Object? severity = null,
    Object? bedId = freezed,
    Object? notes = freezed,
    Object? photoUrls = freezed,
    Object? isActive = freezed,
    Object? resolvedAt = freezed,
    Object? resolutionMethod = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pestId: null == pestId
          ? _value.pestId
          : pestId // ignore: cast_nullable_to_non_nullable
              as String,
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      observedAt: null == observedAt
          ? _value.observedAt
          : observedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as PestSeverity,
      bedId: freezed == bedId
          ? _value.bedId
          : bedId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: freezed == photoUrls
          ? _value.photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolutionMethod: freezed == resolutionMethod
          ? _value.resolutionMethod
          : resolutionMethod // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PestObservationImplCopyWith<$Res>
    implements $PestObservationCopyWith<$Res> {
  factory _$$PestObservationImplCopyWith(_$PestObservationImpl value,
          $Res Function(_$PestObservationImpl) then) =
      __$$PestObservationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pestId,
      String plantId,
      String gardenId,
      DateTime observedAt,
      PestSeverity severity,
      String? bedId,
      String? notes,
      List<String>? photoUrls,
      bool? isActive,
      DateTime? resolvedAt,
      String? resolutionMethod});
}

/// @nodoc
class __$$PestObservationImplCopyWithImpl<$Res>
    extends _$PestObservationCopyWithImpl<$Res, _$PestObservationImpl>
    implements _$$PestObservationImplCopyWith<$Res> {
  __$$PestObservationImplCopyWithImpl(
      _$PestObservationImpl _value, $Res Function(_$PestObservationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pestId = null,
    Object? plantId = null,
    Object? gardenId = null,
    Object? observedAt = null,
    Object? severity = null,
    Object? bedId = freezed,
    Object? notes = freezed,
    Object? photoUrls = freezed,
    Object? isActive = freezed,
    Object? resolvedAt = freezed,
    Object? resolutionMethod = freezed,
  }) {
    return _then(_$PestObservationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pestId: null == pestId
          ? _value.pestId
          : pestId // ignore: cast_nullable_to_non_nullable
              as String,
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      observedAt: null == observedAt
          ? _value.observedAt
          : observedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as PestSeverity,
      bedId: freezed == bedId
          ? _value.bedId
          : bedId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: freezed == photoUrls
          ? _value._photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolutionMethod: freezed == resolutionMethod
          ? _value.resolutionMethod
          : resolutionMethod // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PestObservationImpl implements _PestObservation {
  const _$PestObservationImpl(
      {required this.id,
      required this.pestId,
      required this.plantId,
      required this.gardenId,
      required this.observedAt,
      required this.severity,
      this.bedId,
      this.notes,
      final List<String>? photoUrls,
      this.isActive,
      this.resolvedAt,
      this.resolutionMethod})
      : _photoUrls = photoUrls;

  factory _$PestObservationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PestObservationImplFromJson(json);

  @override
  final String id;
  @override
  final String pestId;
  @override
  final String plantId;
  @override
  final String gardenId;
  @override
  final DateTime observedAt;
  @override
  final PestSeverity severity;
  @override
  final String? bedId;
// Optional: specific bed where observed
  @override
  final String? notes;
  final List<String>? _photoUrls;
  @override
  List<String>? get photoUrls {
    final value = _photoUrls;
    if (value == null) return null;
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? isActive;
// Whether the observation is still active
  @override
  final DateTime? resolvedAt;
// When the pest issue was resolved
  @override
  final String? resolutionMethod;

  @override
  String toString() {
    return 'PestObservation(id: $id, pestId: $pestId, plantId: $plantId, gardenId: $gardenId, observedAt: $observedAt, severity: $severity, bedId: $bedId, notes: $notes, photoUrls: $photoUrls, isActive: $isActive, resolvedAt: $resolvedAt, resolutionMethod: $resolutionMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PestObservationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pestId, pestId) || other.pestId == pestId) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.observedAt, observedAt) ||
                other.observedAt == observedAt) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.bedId, bedId) || other.bedId == bedId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._photoUrls, _photoUrls) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.resolutionMethod, resolutionMethod) ||
                other.resolutionMethod == resolutionMethod));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      pestId,
      plantId,
      gardenId,
      observedAt,
      severity,
      bedId,
      notes,
      const DeepCollectionEquality().hash(_photoUrls),
      isActive,
      resolvedAt,
      resolutionMethod);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PestObservationImplCopyWith<_$PestObservationImpl> get copyWith =>
      __$$PestObservationImplCopyWithImpl<_$PestObservationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PestObservationImplToJson(
      this,
    );
  }
}

abstract class _PestObservation implements PestObservation {
  const factory _PestObservation(
      {required final String id,
      required final String pestId,
      required final String plantId,
      required final String gardenId,
      required final DateTime observedAt,
      required final PestSeverity severity,
      final String? bedId,
      final String? notes,
      final List<String>? photoUrls,
      final bool? isActive,
      final DateTime? resolvedAt,
      final String? resolutionMethod}) = _$PestObservationImpl;

  factory _PestObservation.fromJson(Map<String, dynamic> json) =
      _$PestObservationImpl.fromJson;

  @override
  String get id;
  @override
  String get pestId;
  @override
  String get plantId;
  @override
  String get gardenId;
  @override
  DateTime get observedAt;
  @override
  PestSeverity get severity;
  @override
  String? get bedId;
  @override // Optional: specific bed where observed
  String? get notes;
  @override
  List<String>? get photoUrls;
  @override
  bool? get isActive;
  @override // Whether the observation is still active
  DateTime? get resolvedAt;
  @override // When the pest issue was resolved
  String? get resolutionMethod;
  @override
  @JsonKey(ignore: true)
  _$$PestObservationImplCopyWith<_$PestObservationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
