// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) {
  return _Recommendation.fromJson(json);
}

/// @nodoc
mixin _$Recommendation {
  /// Identifiant unique de la recommandation
  String get id => throw _privateConstructorUsedError;

  /// ID de la plante concernée
  String get plantId => throw _privateConstructorUsedError;

  /// ID du jardin (pour le multi-garden)
  String get gardenId => throw _privateConstructorUsedError;

  /// Type de recommandation
  RecommendationType get type => throw _privateConstructorUsedError;

  /// Priorité de la recommandation
  RecommendationPriority get priority => throw _privateConstructorUsedError;

  /// Titre de la recommandation
  String get title => throw _privateConstructorUsedError;

  /// Description détaillée
  String get description => throw _privateConstructorUsedError;

  /// Instructions spécifiques
  List<String> get instructions => throw _privateConstructorUsedError;

  /// Raison de la recommandation
  String? get reason => throw _privateConstructorUsedError;

  /// Impact attendu (0-100)
  double get expectedImpact => throw _privateConstructorUsedError;

  /// Effort requis (0-100)
  double get effortRequired => throw _privateConstructorUsedError;

  /// Coût estimé (0-100)
  double get estimatedCost => throw _privateConstructorUsedError;

  /// Durée estimée pour appliquer la recommandation
  Duration? get estimatedDuration => throw _privateConstructorUsedError;

  /// Date limite pour appliquer la recommandation
  DateTime? get deadline => throw _privateConstructorUsedError;

  /// Conditions météorologiques optimales
  List<String>? get optimalConditions => throw _privateConstructorUsedError;

  /// Outils ou matériaux nécessaires
  List<String>? get requiredTools => throw _privateConstructorUsedError;

  /// Statut actuel de la recommandation
  RecommendationStatus get status => throw _privateConstructorUsedError;

  /// Date de création
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Date de dernière mise à jour
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Date de completion
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Notes additionnelles
  String? get notes => throw _privateConstructorUsedError;

  /// Métadonnées flexibles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecommendationCopyWith<Recommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationCopyWith<$Res> {
  factory $RecommendationCopyWith(
          Recommendation value, $Res Function(Recommendation) then) =
      _$RecommendationCopyWithImpl<$Res, Recommendation>;
  @useResult
  $Res call(
      {String id,
      String plantId,
      String gardenId,
      RecommendationType type,
      RecommendationPriority priority,
      String title,
      String description,
      List<String> instructions,
      String? reason,
      double expectedImpact,
      double effortRequired,
      double estimatedCost,
      Duration? estimatedDuration,
      DateTime? deadline,
      List<String>? optimalConditions,
      List<String>? requiredTools,
      RecommendationStatus status,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? completedAt,
      String? notes,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$RecommendationCopyWithImpl<$Res, $Val extends Recommendation>
    implements $RecommendationCopyWith<$Res> {
  _$RecommendationCopyWithImpl(this._value, this._then);

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
    Object? priority = null,
    Object? title = null,
    Object? description = null,
    Object? instructions = null,
    Object? reason = freezed,
    Object? expectedImpact = null,
    Object? effortRequired = null,
    Object? estimatedCost = null,
    Object? estimatedDuration = freezed,
    Object? deadline = freezed,
    Object? optimalConditions = freezed,
    Object? requiredTools = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? completedAt = freezed,
    Object? notes = freezed,
    Object? metadata = null,
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
              as RecommendationType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as RecommendationPriority,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedImpact: null == expectedImpact
          ? _value.expectedImpact
          : expectedImpact // ignore: cast_nullable_to_non_nullable
              as double,
      effortRequired: null == effortRequired
          ? _value.effortRequired
          : effortRequired // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedCost: null == estimatedCost
          ? _value.estimatedCost
          : estimatedCost // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      optimalConditions: freezed == optimalConditions
          ? _value.optimalConditions
          : optimalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      requiredTools: freezed == requiredTools
          ? _value.requiredTools
          : requiredTools // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecommendationStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationImplCopyWith<$Res>
    implements $RecommendationCopyWith<$Res> {
  factory _$$RecommendationImplCopyWith(_$RecommendationImpl value,
          $Res Function(_$RecommendationImpl) then) =
      __$$RecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String plantId,
      String gardenId,
      RecommendationType type,
      RecommendationPriority priority,
      String title,
      String description,
      List<String> instructions,
      String? reason,
      double expectedImpact,
      double effortRequired,
      double estimatedCost,
      Duration? estimatedDuration,
      DateTime? deadline,
      List<String>? optimalConditions,
      List<String>? requiredTools,
      RecommendationStatus status,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? completedAt,
      String? notes,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$RecommendationImplCopyWithImpl<$Res>
    extends _$RecommendationCopyWithImpl<$Res, _$RecommendationImpl>
    implements _$$RecommendationImplCopyWith<$Res> {
  __$$RecommendationImplCopyWithImpl(
      _$RecommendationImpl _value, $Res Function(_$RecommendationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plantId = null,
    Object? gardenId = null,
    Object? type = null,
    Object? priority = null,
    Object? title = null,
    Object? description = null,
    Object? instructions = null,
    Object? reason = freezed,
    Object? expectedImpact = null,
    Object? effortRequired = null,
    Object? estimatedCost = null,
    Object? estimatedDuration = freezed,
    Object? deadline = freezed,
    Object? optimalConditions = freezed,
    Object? requiredTools = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? completedAt = freezed,
    Object? notes = freezed,
    Object? metadata = null,
  }) {
    return _then(_$RecommendationImpl(
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
              as RecommendationType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as RecommendationPriority,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      instructions: null == instructions
          ? _value._instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedImpact: null == expectedImpact
          ? _value.expectedImpact
          : expectedImpact // ignore: cast_nullable_to_non_nullable
              as double,
      effortRequired: null == effortRequired
          ? _value.effortRequired
          : effortRequired // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedCost: null == estimatedCost
          ? _value.estimatedCost
          : estimatedCost // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      optimalConditions: freezed == optimalConditions
          ? _value._optimalConditions
          : optimalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      requiredTools: freezed == requiredTools
          ? _value._requiredTools
          : requiredTools // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecommendationStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationImpl implements _Recommendation {
  const _$RecommendationImpl(
      {required this.id,
      required this.plantId,
      required this.gardenId,
      required this.type,
      required this.priority,
      required this.title,
      required this.description,
      required final List<String> instructions,
      this.reason,
      required this.expectedImpact,
      required this.effortRequired,
      required this.estimatedCost,
      this.estimatedDuration,
      this.deadline,
      final List<String>? optimalConditions,
      final List<String>? requiredTools,
      this.status = RecommendationStatus.pending,
      this.createdAt,
      this.updatedAt,
      this.completedAt,
      this.notes,
      final Map<String, dynamic> metadata = const {}})
      : _instructions = instructions,
        _optimalConditions = optimalConditions,
        _requiredTools = requiredTools,
        _metadata = metadata;

  factory _$RecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationImplFromJson(json);

  /// Identifiant unique de la recommandation
  @override
  final String id;

  /// ID de la plante concernée
  @override
  final String plantId;

  /// ID du jardin (pour le multi-garden)
  @override
  final String gardenId;

  /// Type de recommandation
  @override
  final RecommendationType type;

  /// Priorité de la recommandation
  @override
  final RecommendationPriority priority;

  /// Titre de la recommandation
  @override
  final String title;

  /// Description détaillée
  @override
  final String description;

  /// Instructions spécifiques
  final List<String> _instructions;

  /// Instructions spécifiques
  @override
  List<String> get instructions {
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_instructions);
  }

  /// Raison de la recommandation
  @override
  final String? reason;

  /// Impact attendu (0-100)
  @override
  final double expectedImpact;

  /// Effort requis (0-100)
  @override
  final double effortRequired;

  /// Coût estimé (0-100)
  @override
  final double estimatedCost;

  /// Durée estimée pour appliquer la recommandation
  @override
  final Duration? estimatedDuration;

  /// Date limite pour appliquer la recommandation
  @override
  final DateTime? deadline;

  /// Conditions météorologiques optimales
  final List<String>? _optimalConditions;

  /// Conditions météorologiques optimales
  @override
  List<String>? get optimalConditions {
    final value = _optimalConditions;
    if (value == null) return null;
    if (_optimalConditions is EqualUnmodifiableListView)
      return _optimalConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Outils ou matériaux nécessaires
  final List<String>? _requiredTools;

  /// Outils ou matériaux nécessaires
  @override
  List<String>? get requiredTools {
    final value = _requiredTools;
    if (value == null) return null;
    if (_requiredTools is EqualUnmodifiableListView) return _requiredTools;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Statut actuel de la recommandation
  @override
  @JsonKey()
  final RecommendationStatus status;

  /// Date de création
  @override
  final DateTime? createdAt;

  /// Date de dernière mise à jour
  @override
  final DateTime? updatedAt;

  /// Date de completion
  @override
  final DateTime? completedAt;

  /// Notes additionnelles
  @override
  final String? notes;

  /// Métadonnées flexibles
  final Map<String, dynamic> _metadata;

  /// Métadonnées flexibles
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'Recommendation(id: $id, plantId: $plantId, gardenId: $gardenId, type: $type, priority: $priority, title: $title, description: $description, instructions: $instructions, reason: $reason, expectedImpact: $expectedImpact, effortRequired: $effortRequired, estimatedCost: $estimatedCost, estimatedDuration: $estimatedDuration, deadline: $deadline, optimalConditions: $optimalConditions, requiredTools: $requiredTools, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, notes: $notes, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._instructions, _instructions) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.expectedImpact, expectedImpact) ||
                other.expectedImpact == expectedImpact) &&
            (identical(other.effortRequired, effortRequired) ||
                other.effortRequired == effortRequired) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            const DeepCollectionEquality()
                .equals(other._optimalConditions, _optimalConditions) &&
            const DeepCollectionEquality()
                .equals(other._requiredTools, _requiredTools) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        plantId,
        gardenId,
        type,
        priority,
        title,
        description,
        const DeepCollectionEquality().hash(_instructions),
        reason,
        expectedImpact,
        effortRequired,
        estimatedCost,
        estimatedDuration,
        deadline,
        const DeepCollectionEquality().hash(_optimalConditions),
        const DeepCollectionEquality().hash(_requiredTools),
        status,
        createdAt,
        updatedAt,
        completedAt,
        notes,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationImplCopyWith<_$RecommendationImpl> get copyWith =>
      __$$RecommendationImplCopyWithImpl<_$RecommendationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationImplToJson(
      this,
    );
  }
}

abstract class _Recommendation implements Recommendation {
  const factory _Recommendation(
      {required final String id,
      required final String plantId,
      required final String gardenId,
      required final RecommendationType type,
      required final RecommendationPriority priority,
      required final String title,
      required final String description,
      required final List<String> instructions,
      final String? reason,
      required final double expectedImpact,
      required final double effortRequired,
      required final double estimatedCost,
      final Duration? estimatedDuration,
      final DateTime? deadline,
      final List<String>? optimalConditions,
      final List<String>? requiredTools,
      final RecommendationStatus status,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? completedAt,
      final String? notes,
      final Map<String, dynamic> metadata}) = _$RecommendationImpl;

  factory _Recommendation.fromJson(Map<String, dynamic> json) =
      _$RecommendationImpl.fromJson;

  @override

  /// Identifiant unique de la recommandation
  String get id;
  @override

  /// ID de la plante concernée
  String get plantId;
  @override

  /// ID du jardin (pour le multi-garden)
  String get gardenId;
  @override

  /// Type de recommandation
  RecommendationType get type;
  @override

  /// Priorité de la recommandation
  RecommendationPriority get priority;
  @override

  /// Titre de la recommandation
  String get title;
  @override

  /// Description détaillée
  String get description;
  @override

  /// Instructions spécifiques
  List<String> get instructions;
  @override

  /// Raison de la recommandation
  String? get reason;
  @override

  /// Impact attendu (0-100)
  double get expectedImpact;
  @override

  /// Effort requis (0-100)
  double get effortRequired;
  @override

  /// Coût estimé (0-100)
  double get estimatedCost;
  @override

  /// Durée estimée pour appliquer la recommandation
  Duration? get estimatedDuration;
  @override

  /// Date limite pour appliquer la recommandation
  DateTime? get deadline;
  @override

  /// Conditions météorologiques optimales
  List<String>? get optimalConditions;
  @override

  /// Outils ou matériaux nécessaires
  List<String>? get requiredTools;
  @override

  /// Statut actuel de la recommandation
  RecommendationStatus get status;
  @override

  /// Date de création
  DateTime? get createdAt;
  @override

  /// Date de dernière mise à jour
  DateTime? get updatedAt;
  @override

  /// Date de completion
  DateTime? get completedAt;
  @override

  /// Notes additionnelles
  String? get notes;
  @override

  /// Métadonnées flexibles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$RecommendationImplCopyWith<_$RecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
