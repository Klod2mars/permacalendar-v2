// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intelligence_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlantIntelligenceReport _$PlantIntelligenceReportFromJson(
    Map<String, dynamic> json) {
  return _PlantIntelligenceReport.fromJson(json);
}

/// @nodoc
mixin _$PlantIntelligenceReport {
  /// ID unique du rapport
  String get id => throw _privateConstructorUsedError;

  /// ID de la plante
  String get plantId => throw _privateConstructorUsedError;

  /// Nom commun de la plante
  String get plantName => throw _privateConstructorUsedError;

  /// ID du jardin
  String get gardenId => throw _privateConstructorUsedError;

  /// Résultat de l'analyse des conditions
  PlantAnalysisResult get analysis => throw _privateConstructorUsedError;

  /// Liste des recommandations générées
  List<Recommendation> get recommendations =>
      throw _privateConstructorUsedError;

  /// Évaluation du timing de plantation
  PlantingTimingEvaluation? get plantingTiming =>
      throw _privateConstructorUsedError;

  /// Alertes actives pour cette plante
  List<NotificationAlert> get activeAlerts =>
      throw _privateConstructorUsedError;

  /// Score global d'intelligence (0-100)
  double get intelligenceScore => throw _privateConstructorUsedError;

  /// Confiance globale du rapport (0-1)
  double get confidence => throw _privateConstructorUsedError;

  /// Date de génération du rapport
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// Date d'expiration du rapport (après laquelle il devrait être régénéré)
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlantIntelligenceReportCopyWith<PlantIntelligenceReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantIntelligenceReportCopyWith<$Res> {
  factory $PlantIntelligenceReportCopyWith(PlantIntelligenceReport value,
          $Res Function(PlantIntelligenceReport) then) =
      _$PlantIntelligenceReportCopyWithImpl<$Res, PlantIntelligenceReport>;
  @useResult
  $Res call(
      {String id,
      String plantId,
      String plantName,
      String gardenId,
      PlantAnalysisResult analysis,
      List<Recommendation> recommendations,
      PlantingTimingEvaluation? plantingTiming,
      List<NotificationAlert> activeAlerts,
      double intelligenceScore,
      double confidence,
      DateTime generatedAt,
      DateTime expiresAt,
      Map<String, dynamic> metadata});

  $PlantAnalysisResultCopyWith<$Res> get analysis;
  $PlantingTimingEvaluationCopyWith<$Res>? get plantingTiming;
}

/// @nodoc
class _$PlantIntelligenceReportCopyWithImpl<$Res,
        $Val extends PlantIntelligenceReport>
    implements $PlantIntelligenceReportCopyWith<$Res> {
  _$PlantIntelligenceReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plantId = null,
    Object? plantName = null,
    Object? gardenId = null,
    Object? analysis = null,
    Object? recommendations = null,
    Object? plantingTiming = freezed,
    Object? activeAlerts = null,
    Object? intelligenceScore = null,
    Object? confidence = null,
    Object? generatedAt = null,
    Object? expiresAt = null,
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
      plantName: null == plantName
          ? _value.plantName
          : plantName // ignore: cast_nullable_to_non_nullable
              as String,
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      analysis: null == analysis
          ? _value.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as PlantAnalysisResult,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<Recommendation>,
      plantingTiming: freezed == plantingTiming
          ? _value.plantingTiming
          : plantingTiming // ignore: cast_nullable_to_non_nullable
              as PlantingTimingEvaluation?,
      activeAlerts: null == activeAlerts
          ? _value.activeAlerts
          : activeAlerts // ignore: cast_nullable_to_non_nullable
              as List<NotificationAlert>,
      intelligenceScore: null == intelligenceScore
          ? _value.intelligenceScore
          : intelligenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantAnalysisResultCopyWith<$Res> get analysis {
    return $PlantAnalysisResultCopyWith<$Res>(_value.analysis, (value) {
      return _then(_value.copyWith(analysis: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantingTimingEvaluationCopyWith<$Res>? get plantingTiming {
    if (_value.plantingTiming == null) {
      return null;
    }

    return $PlantingTimingEvaluationCopyWith<$Res>(_value.plantingTiming!,
        (value) {
      return _then(_value.copyWith(plantingTiming: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlantIntelligenceReportImplCopyWith<$Res>
    implements $PlantIntelligenceReportCopyWith<$Res> {
  factory _$$PlantIntelligenceReportImplCopyWith(
          _$PlantIntelligenceReportImpl value,
          $Res Function(_$PlantIntelligenceReportImpl) then) =
      __$$PlantIntelligenceReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String plantId,
      String plantName,
      String gardenId,
      PlantAnalysisResult analysis,
      List<Recommendation> recommendations,
      PlantingTimingEvaluation? plantingTiming,
      List<NotificationAlert> activeAlerts,
      double intelligenceScore,
      double confidence,
      DateTime generatedAt,
      DateTime expiresAt,
      Map<String, dynamic> metadata});

  @override
  $PlantAnalysisResultCopyWith<$Res> get analysis;
  @override
  $PlantingTimingEvaluationCopyWith<$Res>? get plantingTiming;
}

/// @nodoc
class __$$PlantIntelligenceReportImplCopyWithImpl<$Res>
    extends _$PlantIntelligenceReportCopyWithImpl<$Res,
        _$PlantIntelligenceReportImpl>
    implements _$$PlantIntelligenceReportImplCopyWith<$Res> {
  __$$PlantIntelligenceReportImplCopyWithImpl(
      _$PlantIntelligenceReportImpl _value,
      $Res Function(_$PlantIntelligenceReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plantId = null,
    Object? plantName = null,
    Object? gardenId = null,
    Object? analysis = null,
    Object? recommendations = null,
    Object? plantingTiming = freezed,
    Object? activeAlerts = null,
    Object? intelligenceScore = null,
    Object? confidence = null,
    Object? generatedAt = null,
    Object? expiresAt = null,
    Object? metadata = null,
  }) {
    return _then(_$PlantIntelligenceReportImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      plantName: null == plantName
          ? _value.plantName
          : plantName // ignore: cast_nullable_to_non_nullable
              as String,
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      analysis: null == analysis
          ? _value.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as PlantAnalysisResult,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<Recommendation>,
      plantingTiming: freezed == plantingTiming
          ? _value.plantingTiming
          : plantingTiming // ignore: cast_nullable_to_non_nullable
              as PlantingTimingEvaluation?,
      activeAlerts: null == activeAlerts
          ? _value._activeAlerts
          : activeAlerts // ignore: cast_nullable_to_non_nullable
              as List<NotificationAlert>,
      intelligenceScore: null == intelligenceScore
          ? _value.intelligenceScore
          : intelligenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
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
class _$PlantIntelligenceReportImpl implements _PlantIntelligenceReport {
  const _$PlantIntelligenceReportImpl(
      {required this.id,
      required this.plantId,
      required this.plantName,
      required this.gardenId,
      required this.analysis,
      required final List<Recommendation> recommendations,
      this.plantingTiming,
      final List<NotificationAlert> activeAlerts = const [],
      required this.intelligenceScore,
      required this.confidence,
      required this.generatedAt,
      required this.expiresAt,
      final Map<String, dynamic> metadata = const {}})
      : _recommendations = recommendations,
        _activeAlerts = activeAlerts,
        _metadata = metadata;

  factory _$PlantIntelligenceReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantIntelligenceReportImplFromJson(json);

  /// ID unique du rapport
  @override
  final String id;

  /// ID de la plante
  @override
  final String plantId;

  /// Nom commun de la plante
  @override
  final String plantName;

  /// ID du jardin
  @override
  final String gardenId;

  /// Résultat de l'analyse des conditions
  @override
  final PlantAnalysisResult analysis;

  /// Liste des recommandations générées
  final List<Recommendation> _recommendations;

  /// Liste des recommandations générées
  @override
  List<Recommendation> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  /// Évaluation du timing de plantation
  @override
  final PlantingTimingEvaluation? plantingTiming;

  /// Alertes actives pour cette plante
  final List<NotificationAlert> _activeAlerts;

  /// Alertes actives pour cette plante
  @override
  @JsonKey()
  List<NotificationAlert> get activeAlerts {
    if (_activeAlerts is EqualUnmodifiableListView) return _activeAlerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeAlerts);
  }

  /// Score global d'intelligence (0-100)
  @override
  final double intelligenceScore;

  /// Confiance globale du rapport (0-1)
  @override
  final double confidence;

  /// Date de génération du rapport
  @override
  final DateTime generatedAt;

  /// Date d'expiration du rapport (après laquelle il devrait être régénéré)
  @override
  final DateTime expiresAt;

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
    return 'PlantIntelligenceReport(id: $id, plantId: $plantId, plantName: $plantName, gardenId: $gardenId, analysis: $analysis, recommendations: $recommendations, plantingTiming: $plantingTiming, activeAlerts: $activeAlerts, intelligenceScore: $intelligenceScore, confidence: $confidence, generatedAt: $generatedAt, expiresAt: $expiresAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantIntelligenceReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.plantName, plantName) ||
                other.plantName == plantName) &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.plantingTiming, plantingTiming) ||
                other.plantingTiming == plantingTiming) &&
            const DeepCollectionEquality()
                .equals(other._activeAlerts, _activeAlerts) &&
            (identical(other.intelligenceScore, intelligenceScore) ||
                other.intelligenceScore == intelligenceScore) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      plantId,
      plantName,
      gardenId,
      analysis,
      const DeepCollectionEquality().hash(_recommendations),
      plantingTiming,
      const DeepCollectionEquality().hash(_activeAlerts),
      intelligenceScore,
      confidence,
      generatedAt,
      expiresAt,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantIntelligenceReportImplCopyWith<_$PlantIntelligenceReportImpl>
      get copyWith => __$$PlantIntelligenceReportImplCopyWithImpl<
          _$PlantIntelligenceReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantIntelligenceReportImplToJson(
      this,
    );
  }
}

abstract class _PlantIntelligenceReport implements PlantIntelligenceReport {
  const factory _PlantIntelligenceReport(
      {required final String id,
      required final String plantId,
      required final String plantName,
      required final String gardenId,
      required final PlantAnalysisResult analysis,
      required final List<Recommendation> recommendations,
      final PlantingTimingEvaluation? plantingTiming,
      final List<NotificationAlert> activeAlerts,
      required final double intelligenceScore,
      required final double confidence,
      required final DateTime generatedAt,
      required final DateTime expiresAt,
      final Map<String, dynamic> metadata}) = _$PlantIntelligenceReportImpl;

  factory _PlantIntelligenceReport.fromJson(Map<String, dynamic> json) =
      _$PlantIntelligenceReportImpl.fromJson;

  @override

  /// ID unique du rapport
  String get id;
  @override

  /// ID de la plante
  String get plantId;
  @override

  /// Nom commun de la plante
  String get plantName;
  @override

  /// ID du jardin
  String get gardenId;
  @override

  /// Résultat de l'analyse des conditions
  PlantAnalysisResult get analysis;
  @override

  /// Liste des recommandations générées
  List<Recommendation> get recommendations;
  @override

  /// Évaluation du timing de plantation
  PlantingTimingEvaluation? get plantingTiming;
  @override

  /// Alertes actives pour cette plante
  List<NotificationAlert> get activeAlerts;
  @override

  /// Score global d'intelligence (0-100)
  double get intelligenceScore;
  @override

  /// Confiance globale du rapport (0-1)
  double get confidence;
  @override

  /// Date de génération du rapport
  DateTime get generatedAt;
  @override

  /// Date d'expiration du rapport (après laquelle il devrait être régénéré)
  DateTime get expiresAt;
  @override

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$PlantIntelligenceReportImplCopyWith<_$PlantIntelligenceReportImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PlantingTimingEvaluation _$PlantingTimingEvaluationFromJson(
    Map<String, dynamic> json) {
  return _PlantingTimingEvaluation.fromJson(json);
}

/// @nodoc
mixin _$PlantingTimingEvaluation {
  /// Est-ce le bon moment pour planter?
  bool get isOptimalTime => throw _privateConstructorUsedError;

  /// Score de timing (0-100)
  double get timingScore => throw _privateConstructorUsedError;

  /// Raison de la recommandation
  String get reason => throw _privateConstructorUsedError;

  /// Date optimale recommandée pour planter (si pas maintenant)
  DateTime? get optimalPlantingDate => throw _privateConstructorUsedError;

  /// Facteurs favorables actuels
  List<String> get favorableFactors => throw _privateConstructorUsedError;

  /// Facteurs défavorables actuels
  List<String> get unfavorableFactors => throw _privateConstructorUsedError;

  /// Risques identifiés si plantation maintenant
  List<String> get risks => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlantingTimingEvaluationCopyWith<PlantingTimingEvaluation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantingTimingEvaluationCopyWith<$Res> {
  factory $PlantingTimingEvaluationCopyWith(PlantingTimingEvaluation value,
          $Res Function(PlantingTimingEvaluation) then) =
      _$PlantingTimingEvaluationCopyWithImpl<$Res, PlantingTimingEvaluation>;
  @useResult
  $Res call(
      {bool isOptimalTime,
      double timingScore,
      String reason,
      DateTime? optimalPlantingDate,
      List<String> favorableFactors,
      List<String> unfavorableFactors,
      List<String> risks});
}

/// @nodoc
class _$PlantingTimingEvaluationCopyWithImpl<$Res,
        $Val extends PlantingTimingEvaluation>
    implements $PlantingTimingEvaluationCopyWith<$Res> {
  _$PlantingTimingEvaluationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOptimalTime = null,
    Object? timingScore = null,
    Object? reason = null,
    Object? optimalPlantingDate = freezed,
    Object? favorableFactors = null,
    Object? unfavorableFactors = null,
    Object? risks = null,
  }) {
    return _then(_value.copyWith(
      isOptimalTime: null == isOptimalTime
          ? _value.isOptimalTime
          : isOptimalTime // ignore: cast_nullable_to_non_nullable
              as bool,
      timingScore: null == timingScore
          ? _value.timingScore
          : timingScore // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      optimalPlantingDate: freezed == optimalPlantingDate
          ? _value.optimalPlantingDate
          : optimalPlantingDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      favorableFactors: null == favorableFactors
          ? _value.favorableFactors
          : favorableFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      unfavorableFactors: null == unfavorableFactors
          ? _value.unfavorableFactors
          : unfavorableFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      risks: null == risks
          ? _value.risks
          : risks // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlantingTimingEvaluationImplCopyWith<$Res>
    implements $PlantingTimingEvaluationCopyWith<$Res> {
  factory _$$PlantingTimingEvaluationImplCopyWith(
          _$PlantingTimingEvaluationImpl value,
          $Res Function(_$PlantingTimingEvaluationImpl) then) =
      __$$PlantingTimingEvaluationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isOptimalTime,
      double timingScore,
      String reason,
      DateTime? optimalPlantingDate,
      List<String> favorableFactors,
      List<String> unfavorableFactors,
      List<String> risks});
}

/// @nodoc
class __$$PlantingTimingEvaluationImplCopyWithImpl<$Res>
    extends _$PlantingTimingEvaluationCopyWithImpl<$Res,
        _$PlantingTimingEvaluationImpl>
    implements _$$PlantingTimingEvaluationImplCopyWith<$Res> {
  __$$PlantingTimingEvaluationImplCopyWithImpl(
      _$PlantingTimingEvaluationImpl _value,
      $Res Function(_$PlantingTimingEvaluationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOptimalTime = null,
    Object? timingScore = null,
    Object? reason = null,
    Object? optimalPlantingDate = freezed,
    Object? favorableFactors = null,
    Object? unfavorableFactors = null,
    Object? risks = null,
  }) {
    return _then(_$PlantingTimingEvaluationImpl(
      isOptimalTime: null == isOptimalTime
          ? _value.isOptimalTime
          : isOptimalTime // ignore: cast_nullable_to_non_nullable
              as bool,
      timingScore: null == timingScore
          ? _value.timingScore
          : timingScore // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      optimalPlantingDate: freezed == optimalPlantingDate
          ? _value.optimalPlantingDate
          : optimalPlantingDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      favorableFactors: null == favorableFactors
          ? _value._favorableFactors
          : favorableFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      unfavorableFactors: null == unfavorableFactors
          ? _value._unfavorableFactors
          : unfavorableFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      risks: null == risks
          ? _value._risks
          : risks // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantingTimingEvaluationImpl implements _PlantingTimingEvaluation {
  const _$PlantingTimingEvaluationImpl(
      {required this.isOptimalTime,
      required this.timingScore,
      required this.reason,
      this.optimalPlantingDate,
      final List<String> favorableFactors = const [],
      final List<String> unfavorableFactors = const [],
      final List<String> risks = const []})
      : _favorableFactors = favorableFactors,
        _unfavorableFactors = unfavorableFactors,
        _risks = risks;

  factory _$PlantingTimingEvaluationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantingTimingEvaluationImplFromJson(json);

  /// Est-ce le bon moment pour planter?
  @override
  final bool isOptimalTime;

  /// Score de timing (0-100)
  @override
  final double timingScore;

  /// Raison de la recommandation
  @override
  final String reason;

  /// Date optimale recommandée pour planter (si pas maintenant)
  @override
  final DateTime? optimalPlantingDate;

  /// Facteurs favorables actuels
  final List<String> _favorableFactors;

  /// Facteurs favorables actuels
  @override
  @JsonKey()
  List<String> get favorableFactors {
    if (_favorableFactors is EqualUnmodifiableListView)
      return _favorableFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favorableFactors);
  }

  /// Facteurs défavorables actuels
  final List<String> _unfavorableFactors;

  /// Facteurs défavorables actuels
  @override
  @JsonKey()
  List<String> get unfavorableFactors {
    if (_unfavorableFactors is EqualUnmodifiableListView)
      return _unfavorableFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unfavorableFactors);
  }

  /// Risques identifiés si plantation maintenant
  final List<String> _risks;

  /// Risques identifiés si plantation maintenant
  @override
  @JsonKey()
  List<String> get risks {
    if (_risks is EqualUnmodifiableListView) return _risks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_risks);
  }

  @override
  String toString() {
    return 'PlantingTimingEvaluation(isOptimalTime: $isOptimalTime, timingScore: $timingScore, reason: $reason, optimalPlantingDate: $optimalPlantingDate, favorableFactors: $favorableFactors, unfavorableFactors: $unfavorableFactors, risks: $risks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantingTimingEvaluationImpl &&
            (identical(other.isOptimalTime, isOptimalTime) ||
                other.isOptimalTime == isOptimalTime) &&
            (identical(other.timingScore, timingScore) ||
                other.timingScore == timingScore) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.optimalPlantingDate, optimalPlantingDate) ||
                other.optimalPlantingDate == optimalPlantingDate) &&
            const DeepCollectionEquality()
                .equals(other._favorableFactors, _favorableFactors) &&
            const DeepCollectionEquality()
                .equals(other._unfavorableFactors, _unfavorableFactors) &&
            const DeepCollectionEquality().equals(other._risks, _risks));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isOptimalTime,
      timingScore,
      reason,
      optimalPlantingDate,
      const DeepCollectionEquality().hash(_favorableFactors),
      const DeepCollectionEquality().hash(_unfavorableFactors),
      const DeepCollectionEquality().hash(_risks));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantingTimingEvaluationImplCopyWith<_$PlantingTimingEvaluationImpl>
      get copyWith => __$$PlantingTimingEvaluationImplCopyWithImpl<
          _$PlantingTimingEvaluationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantingTimingEvaluationImplToJson(
      this,
    );
  }
}

abstract class _PlantingTimingEvaluation implements PlantingTimingEvaluation {
  const factory _PlantingTimingEvaluation(
      {required final bool isOptimalTime,
      required final double timingScore,
      required final String reason,
      final DateTime? optimalPlantingDate,
      final List<String> favorableFactors,
      final List<String> unfavorableFactors,
      final List<String> risks}) = _$PlantingTimingEvaluationImpl;

  factory _PlantingTimingEvaluation.fromJson(Map<String, dynamic> json) =
      _$PlantingTimingEvaluationImpl.fromJson;

  @override

  /// Est-ce le bon moment pour planter?
  bool get isOptimalTime;
  @override

  /// Score de timing (0-100)
  double get timingScore;
  @override

  /// Raison de la recommandation
  String get reason;
  @override

  /// Date optimale recommandée pour planter (si pas maintenant)
  DateTime? get optimalPlantingDate;
  @override

  /// Facteurs favorables actuels
  List<String> get favorableFactors;
  @override

  /// Facteurs défavorables actuels
  List<String> get unfavorableFactors;
  @override

  /// Risques identifiés si plantation maintenant
  List<String> get risks;
  @override
  @JsonKey(ignore: true)
  _$$PlantingTimingEvaluationImplCopyWith<_$PlantingTimingEvaluationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
