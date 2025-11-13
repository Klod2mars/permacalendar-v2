// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_v3.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivityV3 _$ActivityV3FromJson(Map<String, dynamic> json) {
  return _ActivityV3.fromJson(json);
}

/// @nodoc
mixin _$ActivityV3 {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get type => throw _privateConstructorUsedError;
  @HiveField(2)
  String get description => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime get timestamp => throw _privateConstructorUsedError;
  @HiveField(4)
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(6)
  int get priority => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityV3CopyWith<ActivityV3> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityV3CopyWith<$Res> {
  factory $ActivityV3CopyWith(
          ActivityV3 value, $Res Function(ActivityV3) then) =
      _$ActivityV3CopyWithImpl<$Res, ActivityV3>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String type,
      @HiveField(2) String description,
      @HiveField(3) DateTime timestamp,
      @HiveField(4) Map<String, dynamic>? metadata,
      @HiveField(5) bool isActive,
      @HiveField(6) int priority});
}

/// @nodoc
class _$ActivityV3CopyWithImpl<$Res, $Val extends ActivityV3>
    implements $ActivityV3CopyWith<$Res> {
  _$ActivityV3CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? description = null,
    Object? timestamp = null,
    Object? metadata = freezed,
    Object? isActive = null,
    Object? priority = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityV3ImplCopyWith<$Res>
    implements $ActivityV3CopyWith<$Res> {
  factory _$$ActivityV3ImplCopyWith(
          _$ActivityV3Impl value, $Res Function(_$ActivityV3Impl) then) =
      __$$ActivityV3ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String type,
      @HiveField(2) String description,
      @HiveField(3) DateTime timestamp,
      @HiveField(4) Map<String, dynamic>? metadata,
      @HiveField(5) bool isActive,
      @HiveField(6) int priority});
}

/// @nodoc
class __$$ActivityV3ImplCopyWithImpl<$Res>
    extends _$ActivityV3CopyWithImpl<$Res, _$ActivityV3Impl>
    implements _$$ActivityV3ImplCopyWith<$Res> {
  __$$ActivityV3ImplCopyWithImpl(
      _$ActivityV3Impl _value, $Res Function(_$ActivityV3Impl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? description = null,
    Object? timestamp = null,
    Object? metadata = freezed,
    Object? isActive = null,
    Object? priority = null,
  }) {
    return _then(_$ActivityV3Impl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityV3Impl implements _ActivityV3 {
  const _$ActivityV3Impl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.type,
      @HiveField(2) required this.description,
      @HiveField(3) required this.timestamp,
      @HiveField(4) final Map<String, dynamic>? metadata,
      @HiveField(5) this.isActive = true,
      @HiveField(6) this.priority = 0})
      : _metadata = metadata;

  factory _$ActivityV3Impl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityV3ImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String type;
  @override
  @HiveField(2)
  final String description;
  @override
  @HiveField(3)
  final DateTime timestamp;
  final Map<String, dynamic>? _metadata;
  @override
  @HiveField(4)
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  @HiveField(5)
  final bool isActive;
  @override
  @JsonKey()
  @HiveField(6)
  final int priority;

  @override
  String toString() {
    return 'ActivityV3(id: $id, type: $type, description: $description, timestamp: $timestamp, metadata: $metadata, isActive: $isActive, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityV3Impl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, description, timestamp,
      const DeepCollectionEquality().hash(_metadata), isActive, priority);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityV3ImplCopyWith<_$ActivityV3Impl> get copyWith =>
      __$$ActivityV3ImplCopyWithImpl<_$ActivityV3Impl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityV3ImplToJson(
      this,
    );
  }
}

abstract class _ActivityV3 implements ActivityV3 {
  const factory _ActivityV3(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String type,
      @HiveField(2) required final String description,
      @HiveField(3) required final DateTime timestamp,
      @HiveField(4) final Map<String, dynamic>? metadata,
      @HiveField(5) final bool isActive,
      @HiveField(6) final int priority}) = _$ActivityV3Impl;

  factory _ActivityV3.fromJson(Map<String, dynamic> json) =
      _$ActivityV3Impl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get type;
  @override
  @HiveField(2)
  String get description;
  @override
  @HiveField(3)
  DateTime get timestamp;
  @override
  @HiveField(4)
  Map<String, dynamic>? get metadata;
  @override
  @HiveField(5)
  bool get isActive;
  @override
  @HiveField(6)
  int get priority;
  @override
  @JsonKey(ignore: true)
  _$$ActivityV3ImplCopyWith<_$ActivityV3Impl> get copyWith =>
      throw _privateConstructorUsedError;
}
