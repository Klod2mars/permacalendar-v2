// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Pest _$PestFromJson(Map<String, dynamic> json) {
  return _Pest.fromJson(json);
}

/// @nodoc
mixin _$Pest {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get scientificName => throw _privateConstructorUsedError;
  List<String> get affectedPlants =>
      throw _privateConstructorUsedError; // Plant IDs that this pest targets
  PestSeverity get defaultSeverity =>
      throw _privateConstructorUsedError; // Default severity level
  List<String> get symptoms =>
      throw _privateConstructorUsedError; // Visible symptoms
  List<String> get naturalPredators =>
      throw _privateConstructorUsedError; // Beneficial insect IDs that prey on this pest
  List<String> get repellentPlants =>
      throw _privateConstructorUsedError; // Plant IDs that repel this pest
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get preventionTips => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PestCopyWith<Pest> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PestCopyWith<$Res> {
  factory $PestCopyWith(Pest value, $Res Function(Pest) then) =
      _$PestCopyWithImpl<$Res, Pest>;
  @useResult
  $Res call(
      {String id,
      String name,
      String scientificName,
      List<String> affectedPlants,
      PestSeverity defaultSeverity,
      List<String> symptoms,
      List<String> naturalPredators,
      List<String> repellentPlants,
      String? description,
      String? imageUrl,
      String? preventionTips});
}

/// @nodoc
class _$PestCopyWithImpl<$Res, $Val extends Pest>
    implements $PestCopyWith<$Res> {
  _$PestCopyWithImpl(this._value, this._then);

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
    Object? affectedPlants = null,
    Object? defaultSeverity = null,
    Object? symptoms = null,
    Object? naturalPredators = null,
    Object? repellentPlants = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? preventionTips = freezed,
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
      affectedPlants: null == affectedPlants
          ? _value.affectedPlants
          : affectedPlants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defaultSeverity: null == defaultSeverity
          ? _value.defaultSeverity
          : defaultSeverity // ignore: cast_nullable_to_non_nullable
              as PestSeverity,
      symptoms: null == symptoms
          ? _value.symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      naturalPredators: null == naturalPredators
          ? _value.naturalPredators
          : naturalPredators // ignore: cast_nullable_to_non_nullable
              as List<String>,
      repellentPlants: null == repellentPlants
          ? _value.repellentPlants
          : repellentPlants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      preventionTips: freezed == preventionTips
          ? _value.preventionTips
          : preventionTips // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PestImplCopyWith<$Res> implements $PestCopyWith<$Res> {
  factory _$$PestImplCopyWith(
          _$PestImpl value, $Res Function(_$PestImpl) then) =
      __$$PestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String scientificName,
      List<String> affectedPlants,
      PestSeverity defaultSeverity,
      List<String> symptoms,
      List<String> naturalPredators,
      List<String> repellentPlants,
      String? description,
      String? imageUrl,
      String? preventionTips});
}

/// @nodoc
class __$$PestImplCopyWithImpl<$Res>
    extends _$PestCopyWithImpl<$Res, _$PestImpl>
    implements _$$PestImplCopyWith<$Res> {
  __$$PestImplCopyWithImpl(_$PestImpl _value, $Res Function(_$PestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? scientificName = null,
    Object? affectedPlants = null,
    Object? defaultSeverity = null,
    Object? symptoms = null,
    Object? naturalPredators = null,
    Object? repellentPlants = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? preventionTips = freezed,
  }) {
    return _then(_$PestImpl(
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
      affectedPlants: null == affectedPlants
          ? _value._affectedPlants
          : affectedPlants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defaultSeverity: null == defaultSeverity
          ? _value.defaultSeverity
          : defaultSeverity // ignore: cast_nullable_to_non_nullable
              as PestSeverity,
      symptoms: null == symptoms
          ? _value._symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      naturalPredators: null == naturalPredators
          ? _value._naturalPredators
          : naturalPredators // ignore: cast_nullable_to_non_nullable
              as List<String>,
      repellentPlants: null == repellentPlants
          ? _value._repellentPlants
          : repellentPlants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      preventionTips: freezed == preventionTips
          ? _value.preventionTips
          : preventionTips // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PestImpl implements _Pest {
  const _$PestImpl(
      {required this.id,
      required this.name,
      required this.scientificName,
      required final List<String> affectedPlants,
      required this.defaultSeverity,
      required final List<String> symptoms,
      required final List<String> naturalPredators,
      required final List<String> repellentPlants,
      this.description,
      this.imageUrl,
      this.preventionTips})
      : _affectedPlants = affectedPlants,
        _symptoms = symptoms,
        _naturalPredators = naturalPredators,
        _repellentPlants = repellentPlants;

  factory _$PestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PestImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String scientificName;
  final List<String> _affectedPlants;
  @override
  List<String> get affectedPlants {
    if (_affectedPlants is EqualUnmodifiableListView) return _affectedPlants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_affectedPlants);
  }

// Plant IDs that this pest targets
  @override
  final PestSeverity defaultSeverity;
// Default severity level
  final List<String> _symptoms;
// Default severity level
  @override
  List<String> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

// Visible symptoms
  final List<String> _naturalPredators;
// Visible symptoms
  @override
  List<String> get naturalPredators {
    if (_naturalPredators is EqualUnmodifiableListView)
      return _naturalPredators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_naturalPredators);
  }

// Beneficial insect IDs that prey on this pest
  final List<String> _repellentPlants;
// Beneficial insect IDs that prey on this pest
  @override
  List<String> get repellentPlants {
    if (_repellentPlants is EqualUnmodifiableListView) return _repellentPlants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_repellentPlants);
  }

// Plant IDs that repel this pest
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? preventionTips;

  @override
  String toString() {
    return 'Pest(id: $id, name: $name, scientificName: $scientificName, affectedPlants: $affectedPlants, defaultSeverity: $defaultSeverity, symptoms: $symptoms, naturalPredators: $naturalPredators, repellentPlants: $repellentPlants, description: $description, imageUrl: $imageUrl, preventionTips: $preventionTips)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.scientificName, scientificName) ||
                other.scientificName == scientificName) &&
            const DeepCollectionEquality()
                .equals(other._affectedPlants, _affectedPlants) &&
            (identical(other.defaultSeverity, defaultSeverity) ||
                other.defaultSeverity == defaultSeverity) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            const DeepCollectionEquality()
                .equals(other._naturalPredators, _naturalPredators) &&
            const DeepCollectionEquality()
                .equals(other._repellentPlants, _repellentPlants) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.preventionTips, preventionTips) ||
                other.preventionTips == preventionTips));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      scientificName,
      const DeepCollectionEquality().hash(_affectedPlants),
      defaultSeverity,
      const DeepCollectionEquality().hash(_symptoms),
      const DeepCollectionEquality().hash(_naturalPredators),
      const DeepCollectionEquality().hash(_repellentPlants),
      description,
      imageUrl,
      preventionTips);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PestImplCopyWith<_$PestImpl> get copyWith =>
      __$$PestImplCopyWithImpl<_$PestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PestImplToJson(
      this,
    );
  }
}

abstract class _Pest implements Pest {
  const factory _Pest(
      {required final String id,
      required final String name,
      required final String scientificName,
      required final List<String> affectedPlants,
      required final PestSeverity defaultSeverity,
      required final List<String> symptoms,
      required final List<String> naturalPredators,
      required final List<String> repellentPlants,
      final String? description,
      final String? imageUrl,
      final String? preventionTips}) = _$PestImpl;

  factory _Pest.fromJson(Map<String, dynamic> json) = _$PestImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get scientificName;
  @override
  List<String> get affectedPlants;
  @override // Plant IDs that this pest targets
  PestSeverity get defaultSeverity;
  @override // Default severity level
  List<String> get symptoms;
  @override // Visible symptoms
  List<String> get naturalPredators;
  @override // Beneficial insect IDs that prey on this pest
  List<String> get repellentPlants;
  @override // Plant IDs that repel this pest
  String? get description;
  @override
  String? get imageUrl;
  @override
  String? get preventionTips;
  @override
  @JsonKey(ignore: true)
  _$$PestImplCopyWith<_$PestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
