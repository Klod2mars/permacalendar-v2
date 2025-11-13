// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pest_threat_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PestThreat {
  PestObservation get observation => throw _privateConstructorUsedError;
  Pest get pest => throw _privateConstructorUsedError;
  PlantFreezed get affectedPlant => throw _privateConstructorUsedError;
  ThreatLevel get threatLevel => throw _privateConstructorUsedError;
  double? get impactScore =>
      throw _privateConstructorUsedError; // 0-100 estimated impact
  String? get threatDescription => throw _privateConstructorUsedError;
  List<String>? get potentialConsequences => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PestThreatCopyWith<PestThreat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PestThreatCopyWith<$Res> {
  factory $PestThreatCopyWith(
          PestThreat value, $Res Function(PestThreat) then) =
      _$PestThreatCopyWithImpl<$Res, PestThreat>;
  @useResult
  $Res call(
      {PestObservation observation,
      Pest pest,
      PlantFreezed affectedPlant,
      ThreatLevel threatLevel,
      double? impactScore,
      String? threatDescription,
      List<String>? potentialConsequences});

  $PestObservationCopyWith<$Res> get observation;
  $PestCopyWith<$Res> get pest;
  $PlantFreezedCopyWith<$Res> get affectedPlant;
}

/// @nodoc
class _$PestThreatCopyWithImpl<$Res, $Val extends PestThreat>
    implements $PestThreatCopyWith<$Res> {
  _$PestThreatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? observation = null,
    Object? pest = null,
    Object? affectedPlant = null,
    Object? threatLevel = null,
    Object? impactScore = freezed,
    Object? threatDescription = freezed,
    Object? potentialConsequences = freezed,
  }) {
    return _then(_value.copyWith(
      observation: null == observation
          ? _value.observation
          : observation // ignore: cast_nullable_to_non_nullable
              as PestObservation,
      pest: null == pest
          ? _value.pest
          : pest // ignore: cast_nullable_to_non_nullable
              as Pest,
      affectedPlant: null == affectedPlant
          ? _value.affectedPlant
          : affectedPlant // ignore: cast_nullable_to_non_nullable
              as PlantFreezed,
      threatLevel: null == threatLevel
          ? _value.threatLevel
          : threatLevel // ignore: cast_nullable_to_non_nullable
              as ThreatLevel,
      impactScore: freezed == impactScore
          ? _value.impactScore
          : impactScore // ignore: cast_nullable_to_non_nullable
              as double?,
      threatDescription: freezed == threatDescription
          ? _value.threatDescription
          : threatDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      potentialConsequences: freezed == potentialConsequences
          ? _value.potentialConsequences
          : potentialConsequences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PestObservationCopyWith<$Res> get observation {
    return $PestObservationCopyWith<$Res>(_value.observation, (value) {
      return _then(_value.copyWith(observation: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PestCopyWith<$Res> get pest {
    return $PestCopyWith<$Res>(_value.pest, (value) {
      return _then(_value.copyWith(pest: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantFreezedCopyWith<$Res> get affectedPlant {
    return $PlantFreezedCopyWith<$Res>(_value.affectedPlant, (value) {
      return _then(_value.copyWith(affectedPlant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PestThreatImplCopyWith<$Res>
    implements $PestThreatCopyWith<$Res> {
  factory _$$PestThreatImplCopyWith(
          _$PestThreatImpl value, $Res Function(_$PestThreatImpl) then) =
      __$$PestThreatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PestObservation observation,
      Pest pest,
      PlantFreezed affectedPlant,
      ThreatLevel threatLevel,
      double? impactScore,
      String? threatDescription,
      List<String>? potentialConsequences});

  @override
  $PestObservationCopyWith<$Res> get observation;
  @override
  $PestCopyWith<$Res> get pest;
  @override
  $PlantFreezedCopyWith<$Res> get affectedPlant;
}

/// @nodoc
class __$$PestThreatImplCopyWithImpl<$Res>
    extends _$PestThreatCopyWithImpl<$Res, _$PestThreatImpl>
    implements _$$PestThreatImplCopyWith<$Res> {
  __$$PestThreatImplCopyWithImpl(
      _$PestThreatImpl _value, $Res Function(_$PestThreatImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? observation = null,
    Object? pest = null,
    Object? affectedPlant = null,
    Object? threatLevel = null,
    Object? impactScore = freezed,
    Object? threatDescription = freezed,
    Object? potentialConsequences = freezed,
  }) {
    return _then(_$PestThreatImpl(
      observation: null == observation
          ? _value.observation
          : observation // ignore: cast_nullable_to_non_nullable
              as PestObservation,
      pest: null == pest
          ? _value.pest
          : pest // ignore: cast_nullable_to_non_nullable
              as Pest,
      affectedPlant: null == affectedPlant
          ? _value.affectedPlant
          : affectedPlant // ignore: cast_nullable_to_non_nullable
              as PlantFreezed,
      threatLevel: null == threatLevel
          ? _value.threatLevel
          : threatLevel // ignore: cast_nullable_to_non_nullable
              as ThreatLevel,
      impactScore: freezed == impactScore
          ? _value.impactScore
          : impactScore // ignore: cast_nullable_to_non_nullable
              as double?,
      threatDescription: freezed == threatDescription
          ? _value.threatDescription
          : threatDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      potentialConsequences: freezed == potentialConsequences
          ? _value._potentialConsequences
          : potentialConsequences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$PestThreatImpl implements _PestThreat {
  const _$PestThreatImpl(
      {required this.observation,
      required this.pest,
      required this.affectedPlant,
      required this.threatLevel,
      this.impactScore,
      this.threatDescription,
      final List<String>? potentialConsequences})
      : _potentialConsequences = potentialConsequences;

  @override
  final PestObservation observation;
  @override
  final Pest pest;
  @override
  final PlantFreezed affectedPlant;
  @override
  final ThreatLevel threatLevel;
  @override
  final double? impactScore;
// 0-100 estimated impact
  @override
  final String? threatDescription;
  final List<String>? _potentialConsequences;
  @override
  List<String>? get potentialConsequences {
    final value = _potentialConsequences;
    if (value == null) return null;
    if (_potentialConsequences is EqualUnmodifiableListView)
      return _potentialConsequences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PestThreat(observation: $observation, pest: $pest, affectedPlant: $affectedPlant, threatLevel: $threatLevel, impactScore: $impactScore, threatDescription: $threatDescription, potentialConsequences: $potentialConsequences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PestThreatImpl &&
            (identical(other.observation, observation) ||
                other.observation == observation) &&
            (identical(other.pest, pest) || other.pest == pest) &&
            (identical(other.affectedPlant, affectedPlant) ||
                other.affectedPlant == affectedPlant) &&
            (identical(other.threatLevel, threatLevel) ||
                other.threatLevel == threatLevel) &&
            (identical(other.impactScore, impactScore) ||
                other.impactScore == impactScore) &&
            (identical(other.threatDescription, threatDescription) ||
                other.threatDescription == threatDescription) &&
            const DeepCollectionEquality()
                .equals(other._potentialConsequences, _potentialConsequences));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      observation,
      pest,
      affectedPlant,
      threatLevel,
      impactScore,
      threatDescription,
      const DeepCollectionEquality().hash(_potentialConsequences));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PestThreatImplCopyWith<_$PestThreatImpl> get copyWith =>
      __$$PestThreatImplCopyWithImpl<_$PestThreatImpl>(this, _$identity);
}

abstract class _PestThreat implements PestThreat {
  const factory _PestThreat(
      {required final PestObservation observation,
      required final Pest pest,
      required final PlantFreezed affectedPlant,
      required final ThreatLevel threatLevel,
      final double? impactScore,
      final String? threatDescription,
      final List<String>? potentialConsequences}) = _$PestThreatImpl;

  @override
  PestObservation get observation;
  @override
  Pest get pest;
  @override
  PlantFreezed get affectedPlant;
  @override
  ThreatLevel get threatLevel;
  @override
  double? get impactScore;
  @override // 0-100 estimated impact
  String? get threatDescription;
  @override
  List<String>? get potentialConsequences;
  @override
  @JsonKey(ignore: true)
  _$$PestThreatImplCopyWith<_$PestThreatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PestThreatAnalysis {
  String get gardenId => throw _privateConstructorUsedError;
  List<PestThreat> get threats => throw _privateConstructorUsedError;
  int get totalThreats => throw _privateConstructorUsedError;
  int get criticalThreats => throw _privateConstructorUsedError;
  int get highThreats => throw _privateConstructorUsedError;
  int get moderateThreats => throw _privateConstructorUsedError;
  int get lowThreats => throw _privateConstructorUsedError;
  double get overallThreatScore => throw _privateConstructorUsedError; // 0-100
  DateTime? get analyzedAt => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PestThreatAnalysisCopyWith<PestThreatAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PestThreatAnalysisCopyWith<$Res> {
  factory $PestThreatAnalysisCopyWith(
          PestThreatAnalysis value, $Res Function(PestThreatAnalysis) then) =
      _$PestThreatAnalysisCopyWithImpl<$Res, PestThreatAnalysis>;
  @useResult
  $Res call(
      {String gardenId,
      List<PestThreat> threats,
      int totalThreats,
      int criticalThreats,
      int highThreats,
      int moderateThreats,
      int lowThreats,
      double overallThreatScore,
      DateTime? analyzedAt,
      String? summary});
}

/// @nodoc
class _$PestThreatAnalysisCopyWithImpl<$Res, $Val extends PestThreatAnalysis>
    implements $PestThreatAnalysisCopyWith<$Res> {
  _$PestThreatAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? threats = null,
    Object? totalThreats = null,
    Object? criticalThreats = null,
    Object? highThreats = null,
    Object? moderateThreats = null,
    Object? lowThreats = null,
    Object? overallThreatScore = null,
    Object? analyzedAt = freezed,
    Object? summary = freezed,
  }) {
    return _then(_value.copyWith(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      threats: null == threats
          ? _value.threats
          : threats // ignore: cast_nullable_to_non_nullable
              as List<PestThreat>,
      totalThreats: null == totalThreats
          ? _value.totalThreats
          : totalThreats // ignore: cast_nullable_to_non_nullable
              as int,
      criticalThreats: null == criticalThreats
          ? _value.criticalThreats
          : criticalThreats // ignore: cast_nullable_to_non_nullable
              as int,
      highThreats: null == highThreats
          ? _value.highThreats
          : highThreats // ignore: cast_nullable_to_non_nullable
              as int,
      moderateThreats: null == moderateThreats
          ? _value.moderateThreats
          : moderateThreats // ignore: cast_nullable_to_non_nullable
              as int,
      lowThreats: null == lowThreats
          ? _value.lowThreats
          : lowThreats // ignore: cast_nullable_to_non_nullable
              as int,
      overallThreatScore: null == overallThreatScore
          ? _value.overallThreatScore
          : overallThreatScore // ignore: cast_nullable_to_non_nullable
              as double,
      analyzedAt: freezed == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PestThreatAnalysisImplCopyWith<$Res>
    implements $PestThreatAnalysisCopyWith<$Res> {
  factory _$$PestThreatAnalysisImplCopyWith(_$PestThreatAnalysisImpl value,
          $Res Function(_$PestThreatAnalysisImpl) then) =
      __$$PestThreatAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gardenId,
      List<PestThreat> threats,
      int totalThreats,
      int criticalThreats,
      int highThreats,
      int moderateThreats,
      int lowThreats,
      double overallThreatScore,
      DateTime? analyzedAt,
      String? summary});
}

/// @nodoc
class __$$PestThreatAnalysisImplCopyWithImpl<$Res>
    extends _$PestThreatAnalysisCopyWithImpl<$Res, _$PestThreatAnalysisImpl>
    implements _$$PestThreatAnalysisImplCopyWith<$Res> {
  __$$PestThreatAnalysisImplCopyWithImpl(_$PestThreatAnalysisImpl _value,
      $Res Function(_$PestThreatAnalysisImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? threats = null,
    Object? totalThreats = null,
    Object? criticalThreats = null,
    Object? highThreats = null,
    Object? moderateThreats = null,
    Object? lowThreats = null,
    Object? overallThreatScore = null,
    Object? analyzedAt = freezed,
    Object? summary = freezed,
  }) {
    return _then(_$PestThreatAnalysisImpl(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      threats: null == threats
          ? _value._threats
          : threats // ignore: cast_nullable_to_non_nullable
              as List<PestThreat>,
      totalThreats: null == totalThreats
          ? _value.totalThreats
          : totalThreats // ignore: cast_nullable_to_non_nullable
              as int,
      criticalThreats: null == criticalThreats
          ? _value.criticalThreats
          : criticalThreats // ignore: cast_nullable_to_non_nullable
              as int,
      highThreats: null == highThreats
          ? _value.highThreats
          : highThreats // ignore: cast_nullable_to_non_nullable
              as int,
      moderateThreats: null == moderateThreats
          ? _value.moderateThreats
          : moderateThreats // ignore: cast_nullable_to_non_nullable
              as int,
      lowThreats: null == lowThreats
          ? _value.lowThreats
          : lowThreats // ignore: cast_nullable_to_non_nullable
              as int,
      overallThreatScore: null == overallThreatScore
          ? _value.overallThreatScore
          : overallThreatScore // ignore: cast_nullable_to_non_nullable
              as double,
      analyzedAt: freezed == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PestThreatAnalysisImpl implements _PestThreatAnalysis {
  const _$PestThreatAnalysisImpl(
      {required this.gardenId,
      required final List<PestThreat> threats,
      required this.totalThreats,
      required this.criticalThreats,
      required this.highThreats,
      required this.moderateThreats,
      required this.lowThreats,
      required this.overallThreatScore,
      this.analyzedAt,
      this.summary})
      : _threats = threats;

  @override
  final String gardenId;
  final List<PestThreat> _threats;
  @override
  List<PestThreat> get threats {
    if (_threats is EqualUnmodifiableListView) return _threats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_threats);
  }

  @override
  final int totalThreats;
  @override
  final int criticalThreats;
  @override
  final int highThreats;
  @override
  final int moderateThreats;
  @override
  final int lowThreats;
  @override
  final double overallThreatScore;
// 0-100
  @override
  final DateTime? analyzedAt;
  @override
  final String? summary;

  @override
  String toString() {
    return 'PestThreatAnalysis(gardenId: $gardenId, threats: $threats, totalThreats: $totalThreats, criticalThreats: $criticalThreats, highThreats: $highThreats, moderateThreats: $moderateThreats, lowThreats: $lowThreats, overallThreatScore: $overallThreatScore, analyzedAt: $analyzedAt, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PestThreatAnalysisImpl &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            const DeepCollectionEquality().equals(other._threats, _threats) &&
            (identical(other.totalThreats, totalThreats) ||
                other.totalThreats == totalThreats) &&
            (identical(other.criticalThreats, criticalThreats) ||
                other.criticalThreats == criticalThreats) &&
            (identical(other.highThreats, highThreats) ||
                other.highThreats == highThreats) &&
            (identical(other.moderateThreats, moderateThreats) ||
                other.moderateThreats == moderateThreats) &&
            (identical(other.lowThreats, lowThreats) ||
                other.lowThreats == lowThreats) &&
            (identical(other.overallThreatScore, overallThreatScore) ||
                other.overallThreatScore == overallThreatScore) &&
            (identical(other.analyzedAt, analyzedAt) ||
                other.analyzedAt == analyzedAt) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      gardenId,
      const DeepCollectionEquality().hash(_threats),
      totalThreats,
      criticalThreats,
      highThreats,
      moderateThreats,
      lowThreats,
      overallThreatScore,
      analyzedAt,
      summary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PestThreatAnalysisImplCopyWith<_$PestThreatAnalysisImpl> get copyWith =>
      __$$PestThreatAnalysisImplCopyWithImpl<_$PestThreatAnalysisImpl>(
          this, _$identity);
}

abstract class _PestThreatAnalysis implements PestThreatAnalysis {
  const factory _PestThreatAnalysis(
      {required final String gardenId,
      required final List<PestThreat> threats,
      required final int totalThreats,
      required final int criticalThreats,
      required final int highThreats,
      required final int moderateThreats,
      required final int lowThreats,
      required final double overallThreatScore,
      final DateTime? analyzedAt,
      final String? summary}) = _$PestThreatAnalysisImpl;

  @override
  String get gardenId;
  @override
  List<PestThreat> get threats;
  @override
  int get totalThreats;
  @override
  int get criticalThreats;
  @override
  int get highThreats;
  @override
  int get moderateThreats;
  @override
  int get lowThreats;
  @override
  double get overallThreatScore;
  @override // 0-100
  DateTime? get analyzedAt;
  @override
  String? get summary;
  @override
  @JsonKey(ignore: true)
  _$$PestThreatAnalysisImplCopyWith<_$PestThreatAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
