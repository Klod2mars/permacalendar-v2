// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bio_control_recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BioControlAction _$BioControlActionFromJson(Map<String, dynamic> json) {
  return _BioControlAction.fromJson(json);
}

/// @nodoc
mixin _$BioControlAction {
  String get description => throw _privateConstructorUsedError;
  String get timing =>
      throw _privateConstructorUsedError; // "Immediately", "Next spring", etc.
  List<String> get resources =>
      throw _privateConstructorUsedError; // Required resources (ladybugs, seeds, etc.)
  String? get detailedInstructions => throw _privateConstructorUsedError;
  int? get estimatedCostEuros => throw _privateConstructorUsedError;
  int? get estimatedTimeMinutes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BioControlActionCopyWith<BioControlAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BioControlActionCopyWith<$Res> {
  factory $BioControlActionCopyWith(
          BioControlAction value, $Res Function(BioControlAction) then) =
      _$BioControlActionCopyWithImpl<$Res, BioControlAction>;
  @useResult
  $Res call(
      {String description,
      String timing,
      List<String> resources,
      String? detailedInstructions,
      int? estimatedCostEuros,
      int? estimatedTimeMinutes});
}

/// @nodoc
class _$BioControlActionCopyWithImpl<$Res, $Val extends BioControlAction>
    implements $BioControlActionCopyWith<$Res> {
  _$BioControlActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? timing = null,
    Object? resources = null,
    Object? detailedInstructions = freezed,
    Object? estimatedCostEuros = freezed,
    Object? estimatedTimeMinutes = freezed,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timing: null == timing
          ? _value.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as String,
      resources: null == resources
          ? _value.resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<String>,
      detailedInstructions: freezed == detailedInstructions
          ? _value.detailedInstructions
          : detailedInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedCostEuros: freezed == estimatedCostEuros
          ? _value.estimatedCostEuros
          : estimatedCostEuros // ignore: cast_nullable_to_non_nullable
              as int?,
      estimatedTimeMinutes: freezed == estimatedTimeMinutes
          ? _value.estimatedTimeMinutes
          : estimatedTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BioControlActionImplCopyWith<$Res>
    implements $BioControlActionCopyWith<$Res> {
  factory _$$BioControlActionImplCopyWith(_$BioControlActionImpl value,
          $Res Function(_$BioControlActionImpl) then) =
      __$$BioControlActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String description,
      String timing,
      List<String> resources,
      String? detailedInstructions,
      int? estimatedCostEuros,
      int? estimatedTimeMinutes});
}

/// @nodoc
class __$$BioControlActionImplCopyWithImpl<$Res>
    extends _$BioControlActionCopyWithImpl<$Res, _$BioControlActionImpl>
    implements _$$BioControlActionImplCopyWith<$Res> {
  __$$BioControlActionImplCopyWithImpl(_$BioControlActionImpl _value,
      $Res Function(_$BioControlActionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? timing = null,
    Object? resources = null,
    Object? detailedInstructions = freezed,
    Object? estimatedCostEuros = freezed,
    Object? estimatedTimeMinutes = freezed,
  }) {
    return _then(_$BioControlActionImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timing: null == timing
          ? _value.timing
          : timing // ignore: cast_nullable_to_non_nullable
              as String,
      resources: null == resources
          ? _value._resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<String>,
      detailedInstructions: freezed == detailedInstructions
          ? _value.detailedInstructions
          : detailedInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedCostEuros: freezed == estimatedCostEuros
          ? _value.estimatedCostEuros
          : estimatedCostEuros // ignore: cast_nullable_to_non_nullable
              as int?,
      estimatedTimeMinutes: freezed == estimatedTimeMinutes
          ? _value.estimatedTimeMinutes
          : estimatedTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BioControlActionImpl implements _BioControlAction {
  const _$BioControlActionImpl(
      {required this.description,
      required this.timing,
      required final List<String> resources,
      this.detailedInstructions,
      this.estimatedCostEuros,
      this.estimatedTimeMinutes})
      : _resources = resources;

  factory _$BioControlActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$BioControlActionImplFromJson(json);

  @override
  final String description;
  @override
  final String timing;
// "Immediately", "Next spring", etc.
  final List<String> _resources;
// "Immediately", "Next spring", etc.
  @override
  List<String> get resources {
    if (_resources is EqualUnmodifiableListView) return _resources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resources);
  }

// Required resources (ladybugs, seeds, etc.)
  @override
  final String? detailedInstructions;
  @override
  final int? estimatedCostEuros;
  @override
  final int? estimatedTimeMinutes;

  @override
  String toString() {
    return 'BioControlAction(description: $description, timing: $timing, resources: $resources, detailedInstructions: $detailedInstructions, estimatedCostEuros: $estimatedCostEuros, estimatedTimeMinutes: $estimatedTimeMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BioControlActionImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timing, timing) || other.timing == timing) &&
            const DeepCollectionEquality()
                .equals(other._resources, _resources) &&
            (identical(other.detailedInstructions, detailedInstructions) ||
                other.detailedInstructions == detailedInstructions) &&
            (identical(other.estimatedCostEuros, estimatedCostEuros) ||
                other.estimatedCostEuros == estimatedCostEuros) &&
            (identical(other.estimatedTimeMinutes, estimatedTimeMinutes) ||
                other.estimatedTimeMinutes == estimatedTimeMinutes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      description,
      timing,
      const DeepCollectionEquality().hash(_resources),
      detailedInstructions,
      estimatedCostEuros,
      estimatedTimeMinutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BioControlActionImplCopyWith<_$BioControlActionImpl> get copyWith =>
      __$$BioControlActionImplCopyWithImpl<_$BioControlActionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BioControlActionImplToJson(
      this,
    );
  }
}

abstract class _BioControlAction implements BioControlAction {
  const factory _BioControlAction(
      {required final String description,
      required final String timing,
      required final List<String> resources,
      final String? detailedInstructions,
      final int? estimatedCostEuros,
      final int? estimatedTimeMinutes}) = _$BioControlActionImpl;

  factory _BioControlAction.fromJson(Map<String, dynamic> json) =
      _$BioControlActionImpl.fromJson;

  @override
  String get description;
  @override
  String get timing;
  @override // "Immediately", "Next spring", etc.
  List<String> get resources;
  @override // Required resources (ladybugs, seeds, etc.)
  String? get detailedInstructions;
  @override
  int? get estimatedCostEuros;
  @override
  int? get estimatedTimeMinutes;
  @override
  @JsonKey(ignore: true)
  _$$BioControlActionImplCopyWith<_$BioControlActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BioControlRecommendation _$BioControlRecommendationFromJson(
    Map<String, dynamic> json) {
  return _BioControlRecommendation.fromJson(json);
}

/// @nodoc
mixin _$BioControlRecommendation {
  String get id => throw _privateConstructorUsedError;
  String get pestObservationId => throw _privateConstructorUsedError;
  BioControlType get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<BioControlAction> get actions => throw _privateConstructorUsedError;
  int get priority =>
      throw _privateConstructorUsedError; // 1 (urgent) to 5 (preventive)
  double get effectivenessScore => throw _privateConstructorUsedError; // 0-100%
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get targetBeneficialId =>
      throw _privateConstructorUsedError; // For introduceBeneficial type
  String? get targetPlantId =>
      throw _privateConstructorUsedError; // For plantCompanion type
  bool? get isApplied =>
      throw _privateConstructorUsedError; // Whether user applied this recommendation
  DateTime? get appliedAt => throw _privateConstructorUsedError;
  String? get userFeedback => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BioControlRecommendationCopyWith<BioControlRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BioControlRecommendationCopyWith<$Res> {
  factory $BioControlRecommendationCopyWith(BioControlRecommendation value,
          $Res Function(BioControlRecommendation) then) =
      _$BioControlRecommendationCopyWithImpl<$Res, BioControlRecommendation>;
  @useResult
  $Res call(
      {String id,
      String pestObservationId,
      BioControlType type,
      String description,
      List<BioControlAction> actions,
      int priority,
      double effectivenessScore,
      DateTime? createdAt,
      String? targetBeneficialId,
      String? targetPlantId,
      bool? isApplied,
      DateTime? appliedAt,
      String? userFeedback});
}

/// @nodoc
class _$BioControlRecommendationCopyWithImpl<$Res,
        $Val extends BioControlRecommendation>
    implements $BioControlRecommendationCopyWith<$Res> {
  _$BioControlRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pestObservationId = null,
    Object? type = null,
    Object? description = null,
    Object? actions = null,
    Object? priority = null,
    Object? effectivenessScore = null,
    Object? createdAt = freezed,
    Object? targetBeneficialId = freezed,
    Object? targetPlantId = freezed,
    Object? isApplied = freezed,
    Object? appliedAt = freezed,
    Object? userFeedback = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pestObservationId: null == pestObservationId
          ? _value.pestObservationId
          : pestObservationId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BioControlType,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      actions: null == actions
          ? _value.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<BioControlAction>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      effectivenessScore: null == effectivenessScore
          ? _value.effectivenessScore
          : effectivenessScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      targetBeneficialId: freezed == targetBeneficialId
          ? _value.targetBeneficialId
          : targetBeneficialId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetPlantId: freezed == targetPlantId
          ? _value.targetPlantId
          : targetPlantId // ignore: cast_nullable_to_non_nullable
              as String?,
      isApplied: freezed == isApplied
          ? _value.isApplied
          : isApplied // ignore: cast_nullable_to_non_nullable
              as bool?,
      appliedAt: freezed == appliedAt
          ? _value.appliedAt
          : appliedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userFeedback: freezed == userFeedback
          ? _value.userFeedback
          : userFeedback // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BioControlRecommendationImplCopyWith<$Res>
    implements $BioControlRecommendationCopyWith<$Res> {
  factory _$$BioControlRecommendationImplCopyWith(
          _$BioControlRecommendationImpl value,
          $Res Function(_$BioControlRecommendationImpl) then) =
      __$$BioControlRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pestObservationId,
      BioControlType type,
      String description,
      List<BioControlAction> actions,
      int priority,
      double effectivenessScore,
      DateTime? createdAt,
      String? targetBeneficialId,
      String? targetPlantId,
      bool? isApplied,
      DateTime? appliedAt,
      String? userFeedback});
}

/// @nodoc
class __$$BioControlRecommendationImplCopyWithImpl<$Res>
    extends _$BioControlRecommendationCopyWithImpl<$Res,
        _$BioControlRecommendationImpl>
    implements _$$BioControlRecommendationImplCopyWith<$Res> {
  __$$BioControlRecommendationImplCopyWithImpl(
      _$BioControlRecommendationImpl _value,
      $Res Function(_$BioControlRecommendationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pestObservationId = null,
    Object? type = null,
    Object? description = null,
    Object? actions = null,
    Object? priority = null,
    Object? effectivenessScore = null,
    Object? createdAt = freezed,
    Object? targetBeneficialId = freezed,
    Object? targetPlantId = freezed,
    Object? isApplied = freezed,
    Object? appliedAt = freezed,
    Object? userFeedback = freezed,
  }) {
    return _then(_$BioControlRecommendationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pestObservationId: null == pestObservationId
          ? _value.pestObservationId
          : pestObservationId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BioControlType,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      actions: null == actions
          ? _value._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<BioControlAction>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      effectivenessScore: null == effectivenessScore
          ? _value.effectivenessScore
          : effectivenessScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      targetBeneficialId: freezed == targetBeneficialId
          ? _value.targetBeneficialId
          : targetBeneficialId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetPlantId: freezed == targetPlantId
          ? _value.targetPlantId
          : targetPlantId // ignore: cast_nullable_to_non_nullable
              as String?,
      isApplied: freezed == isApplied
          ? _value.isApplied
          : isApplied // ignore: cast_nullable_to_non_nullable
              as bool?,
      appliedAt: freezed == appliedAt
          ? _value.appliedAt
          : appliedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userFeedback: freezed == userFeedback
          ? _value.userFeedback
          : userFeedback // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BioControlRecommendationImpl implements _BioControlRecommendation {
  const _$BioControlRecommendationImpl(
      {required this.id,
      required this.pestObservationId,
      required this.type,
      required this.description,
      required final List<BioControlAction> actions,
      required this.priority,
      required this.effectivenessScore,
      this.createdAt,
      this.targetBeneficialId,
      this.targetPlantId,
      this.isApplied,
      this.appliedAt,
      this.userFeedback})
      : _actions = actions;

  factory _$BioControlRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$BioControlRecommendationImplFromJson(json);

  @override
  final String id;
  @override
  final String pestObservationId;
  @override
  final BioControlType type;
  @override
  final String description;
  final List<BioControlAction> _actions;
  @override
  List<BioControlAction> get actions {
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actions);
  }

  @override
  final int priority;
// 1 (urgent) to 5 (preventive)
  @override
  final double effectivenessScore;
// 0-100%
  @override
  final DateTime? createdAt;
  @override
  final String? targetBeneficialId;
// For introduceBeneficial type
  @override
  final String? targetPlantId;
// For plantCompanion type
  @override
  final bool? isApplied;
// Whether user applied this recommendation
  @override
  final DateTime? appliedAt;
  @override
  final String? userFeedback;

  @override
  String toString() {
    return 'BioControlRecommendation(id: $id, pestObservationId: $pestObservationId, type: $type, description: $description, actions: $actions, priority: $priority, effectivenessScore: $effectivenessScore, createdAt: $createdAt, targetBeneficialId: $targetBeneficialId, targetPlantId: $targetPlantId, isApplied: $isApplied, appliedAt: $appliedAt, userFeedback: $userFeedback)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BioControlRecommendationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pestObservationId, pestObservationId) ||
                other.pestObservationId == pestObservationId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._actions, _actions) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.effectivenessScore, effectivenessScore) ||
                other.effectivenessScore == effectivenessScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.targetBeneficialId, targetBeneficialId) ||
                other.targetBeneficialId == targetBeneficialId) &&
            (identical(other.targetPlantId, targetPlantId) ||
                other.targetPlantId == targetPlantId) &&
            (identical(other.isApplied, isApplied) ||
                other.isApplied == isApplied) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt) &&
            (identical(other.userFeedback, userFeedback) ||
                other.userFeedback == userFeedback));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      pestObservationId,
      type,
      description,
      const DeepCollectionEquality().hash(_actions),
      priority,
      effectivenessScore,
      createdAt,
      targetBeneficialId,
      targetPlantId,
      isApplied,
      appliedAt,
      userFeedback);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BioControlRecommendationImplCopyWith<_$BioControlRecommendationImpl>
      get copyWith => __$$BioControlRecommendationImplCopyWithImpl<
          _$BioControlRecommendationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BioControlRecommendationImplToJson(
      this,
    );
  }
}

abstract class _BioControlRecommendation implements BioControlRecommendation {
  const factory _BioControlRecommendation(
      {required final String id,
      required final String pestObservationId,
      required final BioControlType type,
      required final String description,
      required final List<BioControlAction> actions,
      required final int priority,
      required final double effectivenessScore,
      final DateTime? createdAt,
      final String? targetBeneficialId,
      final String? targetPlantId,
      final bool? isApplied,
      final DateTime? appliedAt,
      final String? userFeedback}) = _$BioControlRecommendationImpl;

  factory _BioControlRecommendation.fromJson(Map<String, dynamic> json) =
      _$BioControlRecommendationImpl.fromJson;

  @override
  String get id;
  @override
  String get pestObservationId;
  @override
  BioControlType get type;
  @override
  String get description;
  @override
  List<BioControlAction> get actions;
  @override
  int get priority;
  @override // 1 (urgent) to 5 (preventive)
  double get effectivenessScore;
  @override // 0-100%
  DateTime? get createdAt;
  @override
  String? get targetBeneficialId;
  @override // For introduceBeneficial type
  String? get targetPlantId;
  @override // For plantCompanion type
  bool? get isApplied;
  @override // Whether user applied this recommendation
  DateTime? get appliedAt;
  @override
  String? get userFeedback;
  @override
  @JsonKey(ignore: true)
  _$$BioControlRecommendationImplCopyWith<_$BioControlRecommendationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
