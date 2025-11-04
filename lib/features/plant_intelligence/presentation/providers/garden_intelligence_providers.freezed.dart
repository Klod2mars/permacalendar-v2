// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'garden_intelligence_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GardenIntelligenceState {
  String get gardenId => throw _privateConstructorUsedError;
  GardenIntelligenceMemory? get memory => throw _privateConstructorUsedError;
  GardenIntelligenceContext? get context => throw _privateConstructorUsedError;
  GardenIntelligenceSettings? get settings =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GardenIntelligenceStateCopyWith<GardenIntelligenceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GardenIntelligenceStateCopyWith<$Res> {
  factory $GardenIntelligenceStateCopyWith(GardenIntelligenceState value,
          $Res Function(GardenIntelligenceState) then) =
      _$GardenIntelligenceStateCopyWithImpl<$Res, GardenIntelligenceState>;
  @useResult
  $Res call(
      {String gardenId,
      GardenIntelligenceMemory? memory,
      GardenIntelligenceContext? context,
      GardenIntelligenceSettings? settings,
      bool isLoading,
      String? error});

  $GardenIntelligenceMemoryCopyWith<$Res>? get memory;
  $GardenIntelligenceContextCopyWith<$Res>? get context;
  $GardenIntelligenceSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class _$GardenIntelligenceStateCopyWithImpl<$Res,
        $Val extends GardenIntelligenceState>
    implements $GardenIntelligenceStateCopyWith<$Res> {
  _$GardenIntelligenceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? memory = freezed,
    Object? context = freezed,
    Object? settings = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      memory: freezed == memory
          ? _value.memory
          : memory // ignore: cast_nullable_to_non_nullable
              as GardenIntelligenceMemory?,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as GardenIntelligenceContext?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as GardenIntelligenceSettings?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GardenIntelligenceMemoryCopyWith<$Res>? get memory {
    if (_value.memory == null) {
      return null;
    }

    return $GardenIntelligenceMemoryCopyWith<$Res>(_value.memory!, (value) {
      return _then(_value.copyWith(memory: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GardenIntelligenceContextCopyWith<$Res>? get context {
    if (_value.context == null) {
      return null;
    }

    return $GardenIntelligenceContextCopyWith<$Res>(_value.context!, (value) {
      return _then(_value.copyWith(context: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GardenIntelligenceSettingsCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $GardenIntelligenceSettingsCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GardenIntelligenceStateImplCopyWith<$Res>
    implements $GardenIntelligenceStateCopyWith<$Res> {
  factory _$$GardenIntelligenceStateImplCopyWith(
          _$GardenIntelligenceStateImpl value,
          $Res Function(_$GardenIntelligenceStateImpl) then) =
      __$$GardenIntelligenceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gardenId,
      GardenIntelligenceMemory? memory,
      GardenIntelligenceContext? context,
      GardenIntelligenceSettings? settings,
      bool isLoading,
      String? error});

  @override
  $GardenIntelligenceMemoryCopyWith<$Res>? get memory;
  @override
  $GardenIntelligenceContextCopyWith<$Res>? get context;
  @override
  $GardenIntelligenceSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$GardenIntelligenceStateImplCopyWithImpl<$Res>
    extends _$GardenIntelligenceStateCopyWithImpl<$Res,
        _$GardenIntelligenceStateImpl>
    implements _$$GardenIntelligenceStateImplCopyWith<$Res> {
  __$$GardenIntelligenceStateImplCopyWithImpl(
      _$GardenIntelligenceStateImpl _value,
      $Res Function(_$GardenIntelligenceStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? memory = freezed,
    Object? context = freezed,
    Object? settings = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$GardenIntelligenceStateImpl(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      memory: freezed == memory
          ? _value.memory
          : memory // ignore: cast_nullable_to_non_nullable
              as GardenIntelligenceMemory?,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as GardenIntelligenceContext?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as GardenIntelligenceSettings?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GardenIntelligenceStateImpl implements _GardenIntelligenceState {
  const _$GardenIntelligenceStateImpl(
      {required this.gardenId,
      this.memory,
      this.context,
      this.settings,
      this.isLoading = false,
      this.error});

  @override
  final String gardenId;
  @override
  final GardenIntelligenceMemory? memory;
  @override
  final GardenIntelligenceContext? context;
  @override
  final GardenIntelligenceSettings? settings;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'GardenIntelligenceState(gardenId: $gardenId, memory: $memory, context: $context, settings: $settings, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GardenIntelligenceStateImpl &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.memory, memory) || other.memory == memory) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, gardenId, memory, context, settings, isLoading, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GardenIntelligenceStateImplCopyWith<_$GardenIntelligenceStateImpl>
      get copyWith => __$$GardenIntelligenceStateImplCopyWithImpl<
          _$GardenIntelligenceStateImpl>(this, _$identity);
}

abstract class _GardenIntelligenceState implements GardenIntelligenceState {
  const factory _GardenIntelligenceState(
      {required final String gardenId,
      final GardenIntelligenceMemory? memory,
      final GardenIntelligenceContext? context,
      final GardenIntelligenceSettings? settings,
      final bool isLoading,
      final String? error}) = _$GardenIntelligenceStateImpl;

  @override
  String get gardenId;
  @override
  GardenIntelligenceMemory? get memory;
  @override
  GardenIntelligenceContext? get context;
  @override
  GardenIntelligenceSettings? get settings;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$GardenIntelligenceStateImplCopyWith<_$GardenIntelligenceStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
