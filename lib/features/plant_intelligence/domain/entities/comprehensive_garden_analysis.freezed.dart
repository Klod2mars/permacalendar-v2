// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comprehensive_garden_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ComprehensiveGardenAnalysis _$ComprehensiveGardenAnalysisFromJson(
    Map<String, dynamic> json) {
  return _ComprehensiveGardenAnalysis.fromJson(json);
}

/// @nodoc
mixin _$ComprehensiveGardenAnalysis {
  String get gardenId => throw _privateConstructorUsedError;
  List<PlantIntelligenceReport> get plantReports =>
      throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  PestThreatAnalysis? get pestThreats => throw _privateConstructorUsedError;
  List<BioControlRecommendation> get bioControlRecommendations =>
      throw _privateConstructorUsedError;
  double get overallHealthScore => throw _privateConstructorUsedError; // 0-100
  DateTime get analyzedAt => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ComprehensiveGardenAnalysisCopyWith<ComprehensiveGardenAnalysis>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComprehensiveGardenAnalysisCopyWith<$Res> {
  factory $ComprehensiveGardenAnalysisCopyWith(
          ComprehensiveGardenAnalysis value,
          $Res Function(ComprehensiveGardenAnalysis) then) =
      _$ComprehensiveGardenAnalysisCopyWithImpl<$Res,
          ComprehensiveGardenAnalysis>;
  @useResult
  $Res call(
      {String gardenId,
      List<PlantIntelligenceReport> plantReports,
      @JsonKey(includeFromJson: false, includeToJson: false)
      PestThreatAnalysis? pestThreats,
      List<BioControlRecommendation> bioControlRecommendations,
      double overallHealthScore,
      DateTime analyzedAt,
      String summary,
      Map<String, dynamic>? metadata});

  $PestThreatAnalysisCopyWith<$Res>? get pestThreats;
}

/// @nodoc
class _$ComprehensiveGardenAnalysisCopyWithImpl<$Res,
        $Val extends ComprehensiveGardenAnalysis>
    implements $ComprehensiveGardenAnalysisCopyWith<$Res> {
  _$ComprehensiveGardenAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? plantReports = null,
    Object? pestThreats = freezed,
    Object? bioControlRecommendations = null,
    Object? overallHealthScore = null,
    Object? analyzedAt = null,
    Object? summary = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      plantReports: null == plantReports
          ? _value.plantReports
          : plantReports // ignore: cast_nullable_to_non_nullable
              as List<PlantIntelligenceReport>,
      pestThreats: freezed == pestThreats
          ? _value.pestThreats
          : pestThreats // ignore: cast_nullable_to_non_nullable
              as PestThreatAnalysis?,
      bioControlRecommendations: null == bioControlRecommendations
          ? _value.bioControlRecommendations
          : bioControlRecommendations // ignore: cast_nullable_to_non_nullable
              as List<BioControlRecommendation>,
      overallHealthScore: null == overallHealthScore
          ? _value.overallHealthScore
          : overallHealthScore // ignore: cast_nullable_to_non_nullable
              as double,
      analyzedAt: null == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PestThreatAnalysisCopyWith<$Res>? get pestThreats {
    if (_value.pestThreats == null) {
      return null;
    }

    return $PestThreatAnalysisCopyWith<$Res>(_value.pestThreats!, (value) {
      return _then(_value.copyWith(pestThreats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ComprehensiveGardenAnalysisImplCopyWith<$Res>
    implements $ComprehensiveGardenAnalysisCopyWith<$Res> {
  factory _$$ComprehensiveGardenAnalysisImplCopyWith(
          _$ComprehensiveGardenAnalysisImpl value,
          $Res Function(_$ComprehensiveGardenAnalysisImpl) then) =
      __$$ComprehensiveGardenAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gardenId,
      List<PlantIntelligenceReport> plantReports,
      @JsonKey(includeFromJson: false, includeToJson: false)
      PestThreatAnalysis? pestThreats,
      List<BioControlRecommendation> bioControlRecommendations,
      double overallHealthScore,
      DateTime analyzedAt,
      String summary,
      Map<String, dynamic>? metadata});

  @override
  $PestThreatAnalysisCopyWith<$Res>? get pestThreats;
}

/// @nodoc
class __$$ComprehensiveGardenAnalysisImplCopyWithImpl<$Res>
    extends _$ComprehensiveGardenAnalysisCopyWithImpl<$Res,
        _$ComprehensiveGardenAnalysisImpl>
    implements _$$ComprehensiveGardenAnalysisImplCopyWith<$Res> {
  __$$ComprehensiveGardenAnalysisImplCopyWithImpl(
      _$ComprehensiveGardenAnalysisImpl _value,
      $Res Function(_$ComprehensiveGardenAnalysisImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? plantReports = null,
    Object? pestThreats = freezed,
    Object? bioControlRecommendations = null,
    Object? overallHealthScore = null,
    Object? analyzedAt = null,
    Object? summary = null,
    Object? metadata = freezed,
  }) {
    return _then(_$ComprehensiveGardenAnalysisImpl(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      plantReports: null == plantReports
          ? _value._plantReports
          : plantReports // ignore: cast_nullable_to_non_nullable
              as List<PlantIntelligenceReport>,
      pestThreats: freezed == pestThreats
          ? _value.pestThreats
          : pestThreats // ignore: cast_nullable_to_non_nullable
              as PestThreatAnalysis?,
      bioControlRecommendations: null == bioControlRecommendations
          ? _value._bioControlRecommendations
          : bioControlRecommendations // ignore: cast_nullable_to_non_nullable
              as List<BioControlRecommendation>,
      overallHealthScore: null == overallHealthScore
          ? _value.overallHealthScore
          : overallHealthScore // ignore: cast_nullable_to_non_nullable
              as double,
      analyzedAt: null == analyzedAt
          ? _value.analyzedAt
          : analyzedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ComprehensiveGardenAnalysisImpl
    implements _ComprehensiveGardenAnalysis {
  const _$ComprehensiveGardenAnalysisImpl(
      {required this.gardenId,
      required final List<PlantIntelligenceReport> plantReports,
      @JsonKey(includeFromJson: false, includeToJson: false) this.pestThreats,
      required final List<BioControlRecommendation> bioControlRecommendations,
      required this.overallHealthScore,
      required this.analyzedAt,
      required this.summary,
      final Map<String, dynamic>? metadata})
      : _plantReports = plantReports,
        _bioControlRecommendations = bioControlRecommendations,
        _metadata = metadata;

  factory _$ComprehensiveGardenAnalysisImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ComprehensiveGardenAnalysisImplFromJson(json);

  @override
  final String gardenId;
  final List<PlantIntelligenceReport> _plantReports;
  @override
  List<PlantIntelligenceReport> get plantReports {
    if (_plantReports is EqualUnmodifiableListView) return _plantReports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plantReports);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final PestThreatAnalysis? pestThreats;
  final List<BioControlRecommendation> _bioControlRecommendations;
  @override
  List<BioControlRecommendation> get bioControlRecommendations {
    if (_bioControlRecommendations is EqualUnmodifiableListView)
      return _bioControlRecommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bioControlRecommendations);
  }

  @override
  final double overallHealthScore;
// 0-100
  @override
  final DateTime analyzedAt;
  @override
  final String summary;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ComprehensiveGardenAnalysis(gardenId: $gardenId, plantReports: $plantReports, pestThreats: $pestThreats, bioControlRecommendations: $bioControlRecommendations, overallHealthScore: $overallHealthScore, analyzedAt: $analyzedAt, summary: $summary, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComprehensiveGardenAnalysisImpl &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            const DeepCollectionEquality()
                .equals(other._plantReports, _plantReports) &&
            (identical(other.pestThreats, pestThreats) ||
                other.pestThreats == pestThreats) &&
            const DeepCollectionEquality().equals(
                other._bioControlRecommendations, _bioControlRecommendations) &&
            (identical(other.overallHealthScore, overallHealthScore) ||
                other.overallHealthScore == overallHealthScore) &&
            (identical(other.analyzedAt, analyzedAt) ||
                other.analyzedAt == analyzedAt) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      gardenId,
      const DeepCollectionEquality().hash(_plantReports),
      pestThreats,
      const DeepCollectionEquality().hash(_bioControlRecommendations),
      overallHealthScore,
      analyzedAt,
      summary,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ComprehensiveGardenAnalysisImplCopyWith<_$ComprehensiveGardenAnalysisImpl>
      get copyWith => __$$ComprehensiveGardenAnalysisImplCopyWithImpl<
          _$ComprehensiveGardenAnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComprehensiveGardenAnalysisImplToJson(
      this,
    );
  }
}

abstract class _ComprehensiveGardenAnalysis
    implements ComprehensiveGardenAnalysis {
  const factory _ComprehensiveGardenAnalysis(
      {required final String gardenId,
      required final List<PlantIntelligenceReport> plantReports,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final PestThreatAnalysis? pestThreats,
      required final List<BioControlRecommendation> bioControlRecommendations,
      required final double overallHealthScore,
      required final DateTime analyzedAt,
      required final String summary,
      final Map<String, dynamic>?
          metadata}) = _$ComprehensiveGardenAnalysisImpl;

  factory _ComprehensiveGardenAnalysis.fromJson(Map<String, dynamic> json) =
      _$ComprehensiveGardenAnalysisImpl.fromJson;

  @override
  String get gardenId;
  @override
  List<PlantIntelligenceReport> get plantReports;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  PestThreatAnalysis? get pestThreats;
  @override
  List<BioControlRecommendation> get bioControlRecommendations;
  @override
  double get overallHealthScore;
  @override // 0-100
  DateTime get analyzedAt;
  @override
  String get summary;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$ComprehensiveGardenAnalysisImplCopyWith<_$ComprehensiveGardenAnalysisImpl>
      get copyWith => throw _privateConstructorUsedError;
}
