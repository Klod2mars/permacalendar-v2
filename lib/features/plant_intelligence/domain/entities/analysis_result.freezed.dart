// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlantAnalysisResult _$PlantAnalysisResultFromJson(Map<String, dynamic> json) {
  return _PlantAnalysisResult.fromJson(json);
}

/// @nodoc
mixin _$PlantAnalysisResult {
  /// ID unique de l'analyse
  String get id => throw _privateConstructorUsedError;

  /// ID de la plante analysée
  String get plantId => throw _privateConstructorUsedError;

  /// Condition de température
  PlantCondition get temperature => throw _privateConstructorUsedError;

  /// Condition d'humidité
  PlantCondition get humidity => throw _privateConstructorUsedError;

  /// Condition de luminosité
  PlantCondition get light => throw _privateConstructorUsedError;

  /// Condition du sol
  PlantCondition get soil => throw _privateConstructorUsedError;

  /// État de santé global calculé (excellent, good, fair, poor, critical)
  ConditionStatus get overallHealth => throw _privateConstructorUsedError;

  /// Score de santé (0-100)
  double get healthScore => throw _privateConstructorUsedError;

  /// Liste des avertissements détectés
  List<String> get warnings => throw _privateConstructorUsedError;

  /// Liste des points positifs
  List<String> get strengths => throw _privateConstructorUsedError;

  /// Recommandations d'action prioritaires
  List<String> get priorityActions => throw _privateConstructorUsedError;

  /// Confidence de l'analyse (0-1)
  double get confidence => throw _privateConstructorUsedError;

  /// Date de l'analyse
  DateTime get analyzedAt => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlantAnalysisResultCopyWith<PlantAnalysisResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantAnalysisResultCopyWith<$Res> {
  factory $PlantAnalysisResultCopyWith(
          PlantAnalysisResult value, $Res Function(PlantAnalysisResult) then) =
      _$PlantAnalysisResultCopyWithImpl<$Res, PlantAnalysisResult>;
  @useResult
  $Res call(
      {String id,
      String plantId,
      PlantCondition temperature,
      PlantCondition humidity,
      PlantCondition light,
      PlantCondition soil,
      ConditionStatus overallHealth,
      double healthScore,
      List<String> warnings,
      List<String> strengths,
      List<String> priorityActions,
      double confidence,
      DateTime analyzedAt,
      Map<String, dynamic> metadata});

  $PlantConditionCopyWith<$Res> get temperature;
  $PlantConditionCopyWith<$Res> get humidity;
  $PlantConditionCopyWith<$Res> get light;
  $PlantConditionCopyWith<$Res> get soil;
}

/// @nodoc
class _$PlantAnalysisResultCopyWithImpl<$Res, $Val extends PlantAnalysisResult>
    implements $PlantAnalysisResultCopyWith<$Res> {
  _$PlantAnalysisResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plantId = null,
    Object? temperature = null,
    Object? humidity = null,
    Object? light = null,
    Object? soil = null,
    Object? overallHealth = null,
    Object? healthScore = null,
    Object? warnings = null,
    Object? strengths = null,
    Object? priorityActions = null,
    Object? confidence = null,
    Object? analyzedAt = null,
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
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as PlantCondition,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as PlantCondition,
      light: null == light
          ? _value.light
          : light // ignore: cast_nullable_to_non_nullable
              as PlantCondition,
      soil: null == soil
          ? _value.soil
          : soil // ignore: cast_nullable_to_non_nullable
              as PlantCondition,
      overallHealth: null == overallHealth
          ? _value.overallHealth
          : overallHealth // ignore: cast_nullable_to_non_nullable
              as ConditionStatus,
      healthScore: null == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as double,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      strengths: null == strengths
          ? _value.strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priorityActions: null == priorityActions
          ? _value.priorityActions
          : priorityActions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      analyzedAt: null == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantConditionCopyWith<$Res> get temperature {
    return $PlantConditionCopyWith<$Res>(_value.temperature, (value) {
      return _then(_value.copyWith(temperature: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantConditionCopyWith<$Res> get humidity {
    return $PlantConditionCopyWith<$Res>(_value.humidity, (value) {
      return _then(_value.copyWith(humidity: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantConditionCopyWith<$Res> get light {
    return $PlantConditionCopyWith<$Res>(_value.light, (value) {
      return _then(_value.copyWith(light: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantConditionCopyWith<$Res> get soil {
    return $PlantConditionCopyWith<$Res>(_value.soil, (value) {
      return _then(_value.copyWith(soil: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlantAnalysisResultImplCopyWith<$Res>
    implements $PlantAnalysisResultCopyWith<$Res> {
  factory _$$PlantAnalysisResultImplCopyWith(_$PlantAnalysisResultImpl value,
          $Res Function(_$PlantAnalysisResultImpl) then) =
      __$$PlantAnalysisResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String plantId,
      PlantCondition temperature,
      PlantCondition humidity,
      PlantCondition light,
      PlantCondition soil,
      ConditionStatus overallHealth,
      double healthScore,
      List<String> warnings,
      List<String> strengths,
      List<String> priorityActions,
      double confidence,
      DateTime analyzedAt,
      Map<String, dynamic> metadata});

  @override
  $PlantConditionCopyWith<$Res> get temperature;
  @override
  $PlantConditionCopyWith<$Res> get humidity;
  @override
  $PlantConditionCopyWith<$Res> get light;
  @override
  $PlantConditionCopyWith<$Res> get soil;
}

/// @nodoc
class __$$PlantAnalysisResultImplCopyWithImpl<$Res>
    extends _$PlantAnalysisResultCopyWithImpl<$Res, _$PlantAnalysisResultImpl>
    implements _$$PlantAnalysisResultImplCopyWith<$Res> {
  __$$PlantAnalysisResultImplCopyWithImpl(_$PlantAnalysisResultImpl _value,
      $Res Function(_$PlantAnalysisResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plantId = null,
    Object? temperature = null,
    Object? humidity = null,
    Object? light = null,
    Object? soil = null,
    Object? overallHealth = null,
    Object? healthScore = null,
    Object? warnings = null,
    Object? strengths = null,
    Object? priorityActions = null,
    Object? confidence = null,
    Object? analyzedAt = null,
    Object? metadata = null,
  }) {
    return _then(_$PlantAnalysisResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as PlantCondition,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as PlantCondition,
      light: null == light
          ? _value.light
          : light // ignore: cast_nullable_to_non_nullable
              as PlantCondition,
      soil: null == soil
          ? _value.soil
          : soil // ignore: cast_nullable_to_non_nullable
              as PlantCondition,
      overallHealth: null == overallHealth
          ? _value.overallHealth
          : overallHealth // ignore: cast_nullable_to_non_nullable
              as ConditionStatus,
      healthScore: null == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as double,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      strengths: null == strengths
          ? _value._strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priorityActions: null == priorityActions
          ? _value._priorityActions
          : priorityActions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      analyzedAt: null == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantAnalysisResultImpl implements _PlantAnalysisResult {
  const _$PlantAnalysisResultImpl(
      {required this.id,
      required this.plantId,
      required this.temperature,
      required this.humidity,
      required this.light,
      required this.soil,
      required this.overallHealth,
      required this.healthScore,
      required final List<String> warnings,
      required final List<String> strengths,
      required final List<String> priorityActions,
      required this.confidence,
      required this.analyzedAt,
      final Map<String, dynamic> metadata = const {}})
      : _warnings = warnings,
        _strengths = strengths,
        _priorityActions = priorityActions,
        _metadata = metadata;

  factory _$PlantAnalysisResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantAnalysisResultImplFromJson(json);

  /// ID unique de l'analyse
  @override
  final String id;

  /// ID de la plante analysée
  @override
  final String plantId;

  /// Condition de température
  @override
  final PlantCondition temperature;

  /// Condition d'humidité
  @override
  final PlantCondition humidity;

  /// Condition de luminosité
  @override
  final PlantCondition light;

  /// Condition du sol
  @override
  final PlantCondition soil;

  /// État de santé global calculé (excellent, good, fair, poor, critical)
  @override
  final ConditionStatus overallHealth;

  /// Score de santé (0-100)
  @override
  final double healthScore;

  /// Liste des avertissements détectés
  final List<String> _warnings;

  /// Liste des avertissements détectés
  @override
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  /// Liste des points positifs
  final List<String> _strengths;

  /// Liste des points positifs
  @override
  List<String> get strengths {
    if (_strengths is EqualUnmodifiableListView) return _strengths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strengths);
  }

  /// Recommandations d'action prioritaires
  final List<String> _priorityActions;

  /// Recommandations d'action prioritaires
  @override
  List<String> get priorityActions {
    if (_priorityActions is EqualUnmodifiableListView) return _priorityActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_priorityActions);
  }

  /// Confidence de l'analyse (0-1)
  @override
  final double confidence;

  /// Date de l'analyse
  @override
  final DateTime analyzedAt;

  /// Métadonnées additionnelles
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'PlantAnalysisResult(id: $id, plantId: $plantId, temperature: $temperature, humidity: $humidity, light: $light, soil: $soil, overallHealth: $overallHealth, healthScore: $healthScore, warnings: $warnings, strengths: $strengths, priorityActions: $priorityActions, confidence: $confidence, analyzedAt: $analyzedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantAnalysisResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.light, light) || other.light == light) &&
            (identical(other.soil, soil) || other.soil == soil) &&
            (identical(other.overallHealth, overallHealth) ||
                other.overallHealth == overallHealth) &&
            (identical(other.healthScore, healthScore) ||
                other.healthScore == healthScore) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            const DeepCollectionEquality()
                .equals(other._strengths, _strengths) &&
            const DeepCollectionEquality()
                .equals(other._priorityActions, _priorityActions) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.analyzedAt, analyzedAt) ||
                other.analyzedAt == analyzedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      plantId,
      temperature,
      humidity,
      light,
      soil,
      overallHealth,
      healthScore,
      const DeepCollectionEquality().hash(_warnings),
      const DeepCollectionEquality().hash(_strengths),
      const DeepCollectionEquality().hash(_priorityActions),
      confidence,
      analyzedAt,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantAnalysisResultImplCopyWith<_$PlantAnalysisResultImpl> get copyWith =>
      __$$PlantAnalysisResultImplCopyWithImpl<_$PlantAnalysisResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantAnalysisResultImplToJson(
      this,
    );
  }
}

abstract class _PlantAnalysisResult implements PlantAnalysisResult {
  const factory _PlantAnalysisResult(
      {required final String id,
      required final String plantId,
      required final PlantCondition temperature,
      required final PlantCondition humidity,
      required final PlantCondition light,
      required final PlantCondition soil,
      required final ConditionStatus overallHealth,
      required final double healthScore,
      required final List<String> warnings,
      required final List<String> strengths,
      required final List<String> priorityActions,
      required final double confidence,
      required final DateTime analyzedAt,
      final Map<String, dynamic> metadata}) = _$PlantAnalysisResultImpl;

  factory _PlantAnalysisResult.fromJson(Map<String, dynamic> json) =
      _$PlantAnalysisResultImpl.fromJson;

  @override

  /// ID unique de l'analyse
  String get id;
  @override

  /// ID de la plante analysée
  String get plantId;
  @override

  /// Condition de température
  PlantCondition get temperature;
  @override

  /// Condition d'humidité
  PlantCondition get humidity;
  @override

  /// Condition de luminosité
  PlantCondition get light;
  @override

  /// Condition du sol
  PlantCondition get soil;
  @override

  /// État de santé global calculé (excellent, good, fair, poor, critical)
  ConditionStatus get overallHealth;
  @override

  /// Score de santé (0-100)
  double get healthScore;
  @override

  /// Liste des avertissements détectés
  List<String> get warnings;
  @override

  /// Liste des points positifs
  List<String> get strengths;
  @override

  /// Recommandations d'action prioritaires
  List<String> get priorityActions;
  @override

  /// Confidence de l'analyse (0-1)
  double get confidence;
  @override

  /// Date de l'analyse
  DateTime get analyzedAt;
  @override

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$PlantAnalysisResultImplCopyWith<_$PlantAnalysisResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
