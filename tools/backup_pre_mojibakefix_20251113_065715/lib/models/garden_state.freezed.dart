// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'garden_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GardenState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<GardenFreezed> get gardens => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  GardenFreezed? get selectedGarden => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GardenStateCopyWith<GardenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GardenStateCopyWith<$Res> {
  factory $GardenStateCopyWith(
          GardenState value, $Res Function(GardenState) then) =
      _$GardenStateCopyWithImpl<$Res, GardenState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<GardenFreezed> gardens,
      String? error,
      GardenFreezed? selectedGarden});

  $GardenFreezedCopyWith<$Res>? get selectedGarden;
}

/// @nodoc
class _$GardenStateCopyWithImpl<$Res, $Val extends GardenState>
    implements $GardenStateCopyWith<$Res> {
  _$GardenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? gardens = null,
    Object? error = freezed,
    Object? selectedGarden = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      gardens: null == gardens
          ? _value.gardens
          : gardens // ignore: cast_nullable_to_non_nullable
              as List<GardenFreezed>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedGarden: freezed == selectedGarden
          ? _value.selectedGarden
          : selectedGarden // ignore: cast_nullable_to_non_nullable
              as GardenFreezed?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GardenFreezedCopyWith<$Res>? get selectedGarden {
    if (_value.selectedGarden == null) {
      return null;
    }

    return $GardenFreezedCopyWith<$Res>(_value.selectedGarden!, (value) {
      return _then(_value.copyWith(selectedGarden: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GardenStateImplCopyWith<$Res>
    implements $GardenStateCopyWith<$Res> {
  factory _$$GardenStateImplCopyWith(
          _$GardenStateImpl value, $Res Function(_$GardenStateImpl) then) =
      __$$GardenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<GardenFreezed> gardens,
      String? error,
      GardenFreezed? selectedGarden});

  @override
  $GardenFreezedCopyWith<$Res>? get selectedGarden;
}

/// @nodoc
class __$$GardenStateImplCopyWithImpl<$Res>
    extends _$GardenStateCopyWithImpl<$Res, _$GardenStateImpl>
    implements _$$GardenStateImplCopyWith<$Res> {
  __$$GardenStateImplCopyWithImpl(
      _$GardenStateImpl _value, $Res Function(_$GardenStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? gardens = null,
    Object? error = freezed,
    Object? selectedGarden = freezed,
  }) {
    return _then(_$GardenStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      gardens: null == gardens
          ? _value._gardens
          : gardens // ignore: cast_nullable_to_non_nullable
              as List<GardenFreezed>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedGarden: freezed == selectedGarden
          ? _value.selectedGarden
          : selectedGarden // ignore: cast_nullable_to_non_nullable
              as GardenFreezed?,
    ));
  }
}

/// @nodoc

class _$GardenStateImpl extends _GardenState {
  const _$GardenStateImpl(
      {this.isLoading = false,
      final List<GardenFreezed> gardens = const [],
      this.error,
      this.selectedGarden})
      : _gardens = gardens,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  final List<GardenFreezed> _gardens;
  @override
  @JsonKey()
  List<GardenFreezed> get gardens {
    if (_gardens is EqualUnmodifiableListView) return _gardens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gardens);
  }

  @override
  final String? error;
  @override
  final GardenFreezed? selectedGarden;

  @override
  String toString() {
    return 'GardenState(isLoading: $isLoading, gardens: $gardens, error: $error, selectedGarden: $selectedGarden)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GardenStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._gardens, _gardens) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedGarden, selectedGarden) ||
                other.selectedGarden == selectedGarden));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_gardens), error, selectedGarden);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GardenStateImplCopyWith<_$GardenStateImpl> get copyWith =>
      __$$GardenStateImplCopyWithImpl<_$GardenStateImpl>(this, _$identity);
}

abstract class _GardenState extends GardenState {
  const factory _GardenState(
      {final bool isLoading,
      final List<GardenFreezed> gardens,
      final String? error,
      final GardenFreezed? selectedGarden}) = _$GardenStateImpl;
  const _GardenState._() : super._();

  @override
  bool get isLoading;
  @override
  List<GardenFreezed> get gardens;
  @override
  String? get error;
  @override
  GardenFreezed? get selectedGarden;
  @override
  @JsonKey(ignore: true)
  _$$GardenStateImplCopyWith<_$GardenStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
