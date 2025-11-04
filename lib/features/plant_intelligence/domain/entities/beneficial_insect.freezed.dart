// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beneficial_insect.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HabitatRequirements _$HabitatRequirementsFromJson(Map<String, dynamic> json) {
  return _HabitatRequirements.fromJson(json);
}

/// @nodoc
mixin _$HabitatRequirements {
  bool get needsWater => throw _privateConstructorUsedError;
  bool get needsShelter => throw _privateConstructorUsedError;
  List<String> get favorableConditions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HabitatRequirementsCopyWith<HabitatRequirements> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitatRequirementsCopyWith<$Res> {
  factory $HabitatRequirementsCopyWith(
          HabitatRequirements value, $Res Function(HabitatRequirements) then) =
      _$HabitatRequirementsCopyWithImpl<$Res, HabitatRequirements>;
  @useResult
  $Res call(
      {bool needsWater, bool needsShelter, List<String> favorableConditions});
}

/// @nodoc
class _$HabitatRequirementsCopyWithImpl<$Res, $Val extends HabitatRequirements>
    implements $HabitatRequirementsCopyWith<$Res> {
  _$HabitatRequirementsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? needsWater = null,
    Object? needsShelter = null,
    Object? favorableConditions = null,
  }) {
    return _then(_value.copyWith(
      needsWater: null == needsWater
          ? _value.needsWater
          : needsWater // ignore: cast_nullable_to_non_nullable
              as bool,
      needsShelter: null == needsShelter
          ? _value.needsShelter
          : needsShelter // ignore: cast_nullable_to_non_nullable
              as bool,
      favorableConditions: null == favorableConditions
          ? _value.favorableConditions
          : favorableConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HabitatRequirementsImplCopyWith<$Res>
    implements $HabitatRequirementsCopyWith<$Res> {
  factory _$$HabitatRequirementsImplCopyWith(_$HabitatRequirementsImpl value,
          $Res Function(_$HabitatRequirementsImpl) then) =
      __$$HabitatRequirementsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool needsWater, bool needsShelter, List<String> favorableConditions});
}

/// @nodoc
class __$$HabitatRequirementsImplCopyWithImpl<$Res>
    extends _$HabitatRequirementsCopyWithImpl<$Res, _$HabitatRequirementsImpl>
    implements _$$HabitatRequirementsImplCopyWith<$Res> {
  __$$HabitatRequirementsImplCopyWithImpl(_$HabitatRequirementsImpl _value,
      $Res Function(_$HabitatRequirementsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? needsWater = null,
    Object? needsShelter = null,
    Object? favorableConditions = null,
  }) {
    return _then(_$HabitatRequirementsImpl(
      needsWater: null == needsWater
          ? _value.needsWater
          : needsWater // ignore: cast_nullable_to_non_nullable
              as bool,
      needsShelter: null == needsShelter
          ? _value.needsShelter
          : needsShelter // ignore: cast_nullable_to_non_nullable
              as bool,
      favorableConditions: null == favorableConditions
          ? _value._favorableConditions
          : favorableConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitatRequirementsImpl implements _HabitatRequirements {
  const _$HabitatRequirementsImpl(
      {required this.needsWater,
      required this.needsShelter,
      required final List<String> favorableConditions})
      : _favorableConditions = favorableConditions;

  factory _$HabitatRequirementsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitatRequirementsImplFromJson(json);

  @override
  final bool needsWater;
  @override
  final bool needsShelter;
  final List<String> _favorableConditions;
  @override
  List<String> get favorableConditions {
    if (_favorableConditions is EqualUnmodifiableListView)
      return _favorableConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favorableConditions);
  }

  @override
  String toString() {
    return 'HabitatRequirements(needsWater: $needsWater, needsShelter: $needsShelter, favorableConditions: $favorableConditions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitatRequirementsImpl &&
            (identical(other.needsWater, needsWater) ||
                other.needsWater == needsWater) &&
            (identical(other.needsShelter, needsShelter) ||
                other.needsShelter == needsShelter) &&
            const DeepCollectionEquality()
                .equals(other._favorableConditions, _favorableConditions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, needsWater, needsShelter,
      const DeepCollectionEquality().hash(_favorableConditions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitatRequirementsImplCopyWith<_$HabitatRequirementsImpl> get copyWith =>
      __$$HabitatRequirementsImplCopyWithImpl<_$HabitatRequirementsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitatRequirementsImplToJson(
      this,
    );
  }
}

abstract class _HabitatRequirements implements HabitatRequirements {
  const factory _HabitatRequirements(
          {required final bool needsWater,
          required final bool needsShelter,
          required final List<String> favorableConditions}) =
      _$HabitatRequirementsImpl;

  factory _HabitatRequirements.fromJson(Map<String, dynamic> json) =
      _$HabitatRequirementsImpl.fromJson;

  @override
  bool get needsWater;
  @override
  bool get needsShelter;
  @override
  List<String> get favorableConditions;
  @override
  @JsonKey(ignore: true)
  _$$HabitatRequirementsImplCopyWith<_$HabitatRequirementsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BeneficialInsect _$BeneficialInsectFromJson(Map<String, dynamic> json) {
  return _BeneficialInsect.fromJson(json);
}

/// @nodoc
mixin _$BeneficialInsect {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get scientificName => throw _privateConstructorUsedError;
  List<String> get preyPests =>
      throw _privateConstructorUsedError; // Pest IDs that this insect preys on
  List<String> get attractiveFlowers =>
      throw _privateConstructorUsedError; // Plant IDs that attract this insect
  HabitatRequirements get habitat => throw _privateConstructorUsedError;
  String get lifeCycle => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int? get effectiveness => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BeneficialInsectCopyWith<BeneficialInsect> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BeneficialInsectCopyWith<$Res> {
  factory $BeneficialInsectCopyWith(
          BeneficialInsect value, $Res Function(BeneficialInsect) then) =
      _$BeneficialInsectCopyWithImpl<$Res, BeneficialInsect>;
  @useResult
  $Res call(
      {String id,
      String name,
      String scientificName,
      List<String> preyPests,
      List<String> attractiveFlowers,
      HabitatRequirements habitat,
      String lifeCycle,
      String? description,
      String? imageUrl,
      int? effectiveness});

  $HabitatRequirementsCopyWith<$Res> get habitat;
}

/// @nodoc
class _$BeneficialInsectCopyWithImpl<$Res, $Val extends BeneficialInsect>
    implements $BeneficialInsectCopyWith<$Res> {
  _$BeneficialInsectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? scientificName = null,
    Object? preyPests = null,
    Object? attractiveFlowers = null,
    Object? habitat = null,
    Object? lifeCycle = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? effectiveness = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: null == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String,
      preyPests: null == preyPests
          ? _value.preyPests
          : preyPests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attractiveFlowers: null == attractiveFlowers
          ? _value.attractiveFlowers
          : attractiveFlowers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      habitat: null == habitat
          ? _value.habitat
          : habitat // ignore: cast_nullable_to_non_nullable
              as HabitatRequirements,
      lifeCycle: null == lifeCycle
          ? _value.lifeCycle
          : lifeCycle // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      effectiveness: freezed == effectiveness
          ? _value.effectiveness
          : effectiveness // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HabitatRequirementsCopyWith<$Res> get habitat {
    return $HabitatRequirementsCopyWith<$Res>(_value.habitat, (value) {
      return _then(_value.copyWith(habitat: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BeneficialInsectImplCopyWith<$Res>
    implements $BeneficialInsectCopyWith<$Res> {
  factory _$$BeneficialInsectImplCopyWith(_$BeneficialInsectImpl value,
          $Res Function(_$BeneficialInsectImpl) then) =
      __$$BeneficialInsectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String scientificName,
      List<String> preyPests,
      List<String> attractiveFlowers,
      HabitatRequirements habitat,
      String lifeCycle,
      String? description,
      String? imageUrl,
      int? effectiveness});

  @override
  $HabitatRequirementsCopyWith<$Res> get habitat;
}

/// @nodoc
class __$$BeneficialInsectImplCopyWithImpl<$Res>
    extends _$BeneficialInsectCopyWithImpl<$Res, _$BeneficialInsectImpl>
    implements _$$BeneficialInsectImplCopyWith<$Res> {
  __$$BeneficialInsectImplCopyWithImpl(_$BeneficialInsectImpl _value,
      $Res Function(_$BeneficialInsectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? scientificName = null,
    Object? preyPests = null,
    Object? attractiveFlowers = null,
    Object? habitat = null,
    Object? lifeCycle = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? effectiveness = freezed,
  }) {
    return _then(_$BeneficialInsectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: null == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String,
      preyPests: null == preyPests
          ? _value._preyPests
          : preyPests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attractiveFlowers: null == attractiveFlowers
          ? _value._attractiveFlowers
          : attractiveFlowers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      habitat: null == habitat
          ? _value.habitat
          : habitat // ignore: cast_nullable_to_non_nullable
              as HabitatRequirements,
      lifeCycle: null == lifeCycle
          ? _value.lifeCycle
          : lifeCycle // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      effectiveness: freezed == effectiveness
          ? _value.effectiveness
          : effectiveness // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BeneficialInsectImpl implements _BeneficialInsect {
  const _$BeneficialInsectImpl(
      {required this.id,
      required this.name,
      required this.scientificName,
      required final List<String> preyPests,
      required final List<String> attractiveFlowers,
      required this.habitat,
      required this.lifeCycle,
      this.description,
      this.imageUrl,
      this.effectiveness})
      : _preyPests = preyPests,
        _attractiveFlowers = attractiveFlowers;

  factory _$BeneficialInsectImpl.fromJson(Map<String, dynamic> json) =>
      _$$BeneficialInsectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String scientificName;
  final List<String> _preyPests;
  @override
  List<String> get preyPests {
    if (_preyPests is EqualUnmodifiableListView) return _preyPests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preyPests);
  }

// Pest IDs that this insect preys on
  final List<String> _attractiveFlowers;
// Pest IDs that this insect preys on
  @override
  List<String> get attractiveFlowers {
    if (_attractiveFlowers is EqualUnmodifiableListView)
      return _attractiveFlowers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attractiveFlowers);
  }

// Plant IDs that attract this insect
  @override
  final HabitatRequirements habitat;
  @override
  final String lifeCycle;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final int? effectiveness;

  @override
  String toString() {
    return 'BeneficialInsect(id: $id, name: $name, scientificName: $scientificName, preyPests: $preyPests, attractiveFlowers: $attractiveFlowers, habitat: $habitat, lifeCycle: $lifeCycle, description: $description, imageUrl: $imageUrl, effectiveness: $effectiveness)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficialInsectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.scientificName, scientificName) ||
                other.scientificName == scientificName) &&
            const DeepCollectionEquality()
                .equals(other._preyPests, _preyPests) &&
            const DeepCollectionEquality()
                .equals(other._attractiveFlowers, _attractiveFlowers) &&
            (identical(other.habitat, habitat) || other.habitat == habitat) &&
            (identical(other.lifeCycle, lifeCycle) ||
                other.lifeCycle == lifeCycle) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.effectiveness, effectiveness) ||
                other.effectiveness == effectiveness));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      scientificName,
      const DeepCollectionEquality().hash(_preyPests),
      const DeepCollectionEquality().hash(_attractiveFlowers),
      habitat,
      lifeCycle,
      description,
      imageUrl,
      effectiveness);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficialInsectImplCopyWith<_$BeneficialInsectImpl> get copyWith =>
      __$$BeneficialInsectImplCopyWithImpl<_$BeneficialInsectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BeneficialInsectImplToJson(
      this,
    );
  }
}

abstract class _BeneficialInsect implements BeneficialInsect {
  const factory _BeneficialInsect(
      {required final String id,
      required final String name,
      required final String scientificName,
      required final List<String> preyPests,
      required final List<String> attractiveFlowers,
      required final HabitatRequirements habitat,
      required final String lifeCycle,
      final String? description,
      final String? imageUrl,
      final int? effectiveness}) = _$BeneficialInsectImpl;

  factory _BeneficialInsect.fromJson(Map<String, dynamic> json) =
      _$BeneficialInsectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get scientificName;
  @override
  List<String> get preyPests;
  @override // Pest IDs that this insect preys on
  List<String> get attractiveFlowers;
  @override // Plant IDs that attract this insect
  HabitatRequirements get habitat;
  @override
  String get lifeCycle;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  int? get effectiveness;
  @override
  @JsonKey(ignore: true)
  _$$BeneficialInsectImplCopyWith<_$BeneficialInsectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
