// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_intelligence_evolution_tracker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IntelligenceEvolutionSummary _$IntelligenceEvolutionSummaryFromJson(
    Map<String, dynamic> json) {
  return _IntelligenceEvolutionSummary.fromJson(json);
}

/// @nodoc
mixin _$IntelligenceEvolutionSummary {
  /// ID of the plant being compared
  String get plantId => throw _privateConstructorUsedError;

  /// Name of the plant
  String get plantName => throw _privateConstructorUsedError;

  /// Change in intelligence score (positive = improvement)
  double get scoreDelta => throw _privateConstructorUsedError;

  /// Change in confidence level (positive = more confident)
  double get confidenceDelta => throw _privateConstructorUsedError;

  /// List of new recommendations that were added
  List<String> get addedRecommendations => throw _privateConstructorUsedError;

  /// List of recommendations that were removed
  List<String> get removedRecommendations => throw _privateConstructorUsedError;

  /// List of recommendations that were modified (priority or status changed)
  List<String> get modifiedRecommendations =>
      throw _privateConstructorUsedError;

  /// True if the plant's health improved
  bool get isImproved => throw _privateConstructorUsedError;

  /// True if the plant's health remained stable
  bool get isStable => throw _privateConstructorUsedError;

  /// True if the plant's health degraded
  bool get isDegraded => throw _privateConstructorUsedError;

  /// Change in timing score (e.g., seasonality changes)
  double get timingScoreShift => throw _privateConstructorUsedError;

  /// Reference to old report (for detailed analysis)
  PlantIntelligenceReport get oldReport => throw _privateConstructorUsedError;

  /// Reference to new report (for detailed analysis)
  PlantIntelligenceReport get newReport => throw _privateConstructorUsedError;

  /// When this comparison was performed
  DateTime get comparedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IntelligenceEvolutionSummaryCopyWith<IntelligenceEvolutionSummary>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntelligenceEvolutionSummaryCopyWith<$Res> {
  factory $IntelligenceEvolutionSummaryCopyWith(
          IntelligenceEvolutionSummary value,
          $Res Function(IntelligenceEvolutionSummary) then) =
      _$IntelligenceEvolutionSummaryCopyWithImpl<$Res,
          IntelligenceEvolutionSummary>;
  @useResult
  $Res call(
      {String plantId,
      String plantName,
      double scoreDelta,
      double confidenceDelta,
      List<String> addedRecommendations,
      List<String> removedRecommendations,
      List<String> modifiedRecommendations,
      bool isImproved,
      bool isStable,
      bool isDegraded,
      double timingScoreShift,
      PlantIntelligenceReport oldReport,
      PlantIntelligenceReport newReport,
      DateTime comparedAt});

  $PlantIntelligenceReportCopyWith<$Res> get oldReport;
  $PlantIntelligenceReportCopyWith<$Res> get newReport;
}

/// @nodoc
class _$IntelligenceEvolutionSummaryCopyWithImpl<$Res,
        $Val extends IntelligenceEvolutionSummary>
    implements $IntelligenceEvolutionSummaryCopyWith<$Res> {
  _$IntelligenceEvolutionSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? plantName = null,
    Object? scoreDelta = null,
    Object? confidenceDelta = null,
    Object? addedRecommendations = null,
    Object? removedRecommendations = null,
    Object? modifiedRecommendations = null,
    Object? isImproved = null,
    Object? isStable = null,
    Object? isDegraded = null,
    Object? timingScoreShift = null,
    Object? oldReport = null,
    Object? newReport = null,
    Object? comparedAt = null,
  }) {
    return _then(_value.copyWith(
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      plantName: null == plantName
          ? _value.plantName
          : plantName // ignore: cast_nullable_to_non_nullable
              as String,
      scoreDelta: null == scoreDelta
          ? _value.scoreDelta
          : scoreDelta // ignore: cast_nullable_to_non_nullable
              as double,
      confidenceDelta: null == confidenceDelta
          ? _value.confidenceDelta
          : confidenceDelta // ignore: cast_nullable_to_non_nullable
              as double,
      addedRecommendations: null == addedRecommendations
          ? _value.addedRecommendations
          : addedRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      removedRecommendations: null == removedRecommendations
          ? _value.removedRecommendations
          : removedRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      modifiedRecommendations: null == modifiedRecommendations
          ? _value.modifiedRecommendations
          : modifiedRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isImproved: null == isImproved
          ? _value.isImproved
          : isImproved // ignore: cast_nullable_to_non_nullable
              as bool,
      isStable: null == isStable
          ? _value.isStable
          : isStable // ignore: cast_nullable_to_non_nullable
              as bool,
      isDegraded: null == isDegraded
          ? _value.isDegraded
          : isDegraded // ignore: cast_nullable_to_non_nullable
              as bool,
      timingScoreShift: null == timingScoreShift
          ? _value.timingScoreShift
          : timingScoreShift // ignore: cast_nullable_to_non_nullable
              as double,
      oldReport: null == oldReport
          ? _value.oldReport
          : oldReport // ignore: cast_nullable_to_non_nullable
              as PlantIntelligenceReport,
      newReport: null == newReport
          ? _value.newReport
          : newReport // ignore: cast_nullable_to_non_nullable
              as PlantIntelligenceReport,
      comparedAt: null == comparedAt
          ? _value.comparedAt
          : comparedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantIntelligenceReportCopyWith<$Res> get oldReport {
    return $PlantIntelligenceReportCopyWith<$Res>(_value.oldReport, (value) {
      return _then(_value.copyWith(oldReport: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantIntelligenceReportCopyWith<$Res> get newReport {
    return $PlantIntelligenceReportCopyWith<$Res>(_value.newReport, (value) {
      return _then(_value.copyWith(newReport: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IntelligenceEvolutionSummaryImplCopyWith<$Res>
    implements $IntelligenceEvolutionSummaryCopyWith<$Res> {
  factory _$$IntelligenceEvolutionSummaryImplCopyWith(
          _$IntelligenceEvolutionSummaryImpl value,
          $Res Function(_$IntelligenceEvolutionSummaryImpl) then) =
      __$$IntelligenceEvolutionSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String plantId,
      String plantName,
      double scoreDelta,
      double confidenceDelta,
      List<String> addedRecommendations,
      List<String> removedRecommendations,
      List<String> modifiedRecommendations,
      bool isImproved,
      bool isStable,
      bool isDegraded,
      double timingScoreShift,
      PlantIntelligenceReport oldReport,
      PlantIntelligenceReport newReport,
      DateTime comparedAt});

  @override
  $PlantIntelligenceReportCopyWith<$Res> get oldReport;
  @override
  $PlantIntelligenceReportCopyWith<$Res> get newReport;
}

/// @nodoc
class __$$IntelligenceEvolutionSummaryImplCopyWithImpl<$Res>
    extends _$IntelligenceEvolutionSummaryCopyWithImpl<$Res,
        _$IntelligenceEvolutionSummaryImpl>
    implements _$$IntelligenceEvolutionSummaryImplCopyWith<$Res> {
  __$$IntelligenceEvolutionSummaryImplCopyWithImpl(
      _$IntelligenceEvolutionSummaryImpl _value,
      $Res Function(_$IntelligenceEvolutionSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? plantName = null,
    Object? scoreDelta = null,
    Object? confidenceDelta = null,
    Object? addedRecommendations = null,
    Object? removedRecommendations = null,
    Object? modifiedRecommendations = null,
    Object? isImproved = null,
    Object? isStable = null,
    Object? isDegraded = null,
    Object? timingScoreShift = null,
    Object? oldReport = null,
    Object? newReport = null,
    Object? comparedAt = null,
  }) {
    return _then(_$IntelligenceEvolutionSummaryImpl(
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      plantName: null == plantName
          ? _value.plantName
          : plantName // ignore: cast_nullable_to_non_nullable
              as String,
      scoreDelta: null == scoreDelta
          ? _value.scoreDelta
          : scoreDelta // ignore: cast_nullable_to_non_nullable
              as double,
      confidenceDelta: null == confidenceDelta
          ? _value.confidenceDelta
          : confidenceDelta // ignore: cast_nullable_to_non_nullable
              as double,
      addedRecommendations: null == addedRecommendations
          ? _value._addedRecommendations
          : addedRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      removedRecommendations: null == removedRecommendations
          ? _value._removedRecommendations
          : removedRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      modifiedRecommendations: null == modifiedRecommendations
          ? _value._modifiedRecommendations
          : modifiedRecommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isImproved: null == isImproved
          ? _value.isImproved
          : isImproved // ignore: cast_nullable_to_non_nullable
              as bool,
      isStable: null == isStable
          ? _value.isStable
          : isStable // ignore: cast_nullable_to_non_nullable
              as bool,
      isDegraded: null == isDegraded
          ? _value.isDegraded
          : isDegraded // ignore: cast_nullable_to_non_nullable
              as bool,
      timingScoreShift: null == timingScoreShift
          ? _value.timingScoreShift
          : timingScoreShift // ignore: cast_nullable_to_non_nullable
              as double,
      oldReport: null == oldReport
          ? _value.oldReport
          : oldReport // ignore: cast_nullable_to_non_nullable
              as PlantIntelligenceReport,
      newReport: null == newReport
          ? _value.newReport
          : newReport // ignore: cast_nullable_to_non_nullable
              as PlantIntelligenceReport,
      comparedAt: null == comparedAt
          ? _value.comparedAt
          : comparedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IntelligenceEvolutionSummaryImpl
    implements _IntelligenceEvolutionSummary {
  const _$IntelligenceEvolutionSummaryImpl(
      {required this.plantId,
      required this.plantName,
      required this.scoreDelta,
      required this.confidenceDelta,
      required final List<String> addedRecommendations,
      required final List<String> removedRecommendations,
      required final List<String> modifiedRecommendations,
      required this.isImproved,
      required this.isStable,
      required this.isDegraded,
      this.timingScoreShift = 0.0,
      required this.oldReport,
      required this.newReport,
      required this.comparedAt})
      : _addedRecommendations = addedRecommendations,
        _removedRecommendations = removedRecommendations,
        _modifiedRecommendations = modifiedRecommendations;

  factory _$IntelligenceEvolutionSummaryImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$IntelligenceEvolutionSummaryImplFromJson(json);

  /// ID of the plant being compared
  @override
  final String plantId;

  /// Name of the plant
  @override
  final String plantName;

  /// Change in intelligence score (positive = improvement)
  @override
  final double scoreDelta;

  /// Change in confidence level (positive = more confident)
  @override
  final double confidenceDelta;

  /// List of new recommendations that were added
  final List<String> _addedRecommendations;

  /// List of new recommendations that were added
  @override
  List<String> get addedRecommendations {
    if (_addedRecommendations is EqualUnmodifiableListView)
      return _addedRecommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addedRecommendations);
  }

  /// List of recommendations that were removed
  final List<String> _removedRecommendations;

  /// List of recommendations that were removed
  @override
  List<String> get removedRecommendations {
    if (_removedRecommendations is EqualUnmodifiableListView)
      return _removedRecommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_removedRecommendations);
  }

  /// List of recommendations that were modified (priority or status changed)
  final List<String> _modifiedRecommendations;

  /// List of recommendations that were modified (priority or status changed)
  @override
  List<String> get modifiedRecommendations {
    if (_modifiedRecommendations is EqualUnmodifiableListView)
      return _modifiedRecommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modifiedRecommendations);
  }

  /// True if the plant's health improved
  @override
  final bool isImproved;

  /// True if the plant's health remained stable
  @override
  final bool isStable;

  /// True if the plant's health degraded
  @override
  final bool isDegraded;

  /// Change in timing score (e.g., seasonality changes)
  @override
  @JsonKey()
  final double timingScoreShift;

  /// Reference to old report (for detailed analysis)
  @override
  final PlantIntelligenceReport oldReport;

  /// Reference to new report (for detailed analysis)
  @override
  final PlantIntelligenceReport newReport;

  /// When this comparison was performed
  @override
  final DateTime comparedAt;

  @override
  String toString() {
    return 'IntelligenceEvolutionSummary(plantId: $plantId, plantName: $plantName, scoreDelta: $scoreDelta, confidenceDelta: $confidenceDelta, addedRecommendations: $addedRecommendations, removedRecommendations: $removedRecommendations, modifiedRecommendations: $modifiedRecommendations, isImproved: $isImproved, isStable: $isStable, isDegraded: $isDegraded, timingScoreShift: $timingScoreShift, oldReport: $oldReport, newReport: $newReport, comparedAt: $comparedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntelligenceEvolutionSummaryImpl &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.plantName, plantName) ||
                other.plantName == plantName) &&
            (identical(other.scoreDelta, scoreDelta) ||
                other.scoreDelta == scoreDelta) &&
            (identical(other.confidenceDelta, confidenceDelta) ||
                other.confidenceDelta == confidenceDelta) &&
            const DeepCollectionEquality()
                .equals(other._addedRecommendations, _addedRecommendations) &&
            const DeepCollectionEquality().equals(
                other._removedRecommendations, _removedRecommendations) &&
            const DeepCollectionEquality().equals(
                other._modifiedRecommendations, _modifiedRecommendations) &&
            (identical(other.isImproved, isImproved) ||
                other.isImproved == isImproved) &&
            (identical(other.isStable, isStable) ||
                other.isStable == isStable) &&
            (identical(other.isDegraded, isDegraded) ||
                other.isDegraded == isDegraded) &&
            (identical(other.timingScoreShift, timingScoreShift) ||
                other.timingScoreShift == timingScoreShift) &&
            (identical(other.oldReport, oldReport) ||
                other.oldReport == oldReport) &&
            (identical(other.newReport, newReport) ||
                other.newReport == newReport) &&
            (identical(other.comparedAt, comparedAt) ||
                other.comparedAt == comparedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      plantId,
      plantName,
      scoreDelta,
      confidenceDelta,
      const DeepCollectionEquality().hash(_addedRecommendations),
      const DeepCollectionEquality().hash(_removedRecommendations),
      const DeepCollectionEquality().hash(_modifiedRecommendations),
      isImproved,
      isStable,
      isDegraded,
      timingScoreShift,
      oldReport,
      newReport,
      comparedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IntelligenceEvolutionSummaryImplCopyWith<
          _$IntelligenceEvolutionSummaryImpl>
      get copyWith => __$$IntelligenceEvolutionSummaryImplCopyWithImpl<
          _$IntelligenceEvolutionSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IntelligenceEvolutionSummaryImplToJson(
      this,
    );
  }
}

abstract class _IntelligenceEvolutionSummary
    implements IntelligenceEvolutionSummary {
  const factory _IntelligenceEvolutionSummary(
      {required final String plantId,
      required final String plantName,
      required final double scoreDelta,
      required final double confidenceDelta,
      required final List<String> addedRecommendations,
      required final List<String> removedRecommendations,
      required final List<String> modifiedRecommendations,
      required final bool isImproved,
      required final bool isStable,
      required final bool isDegraded,
      final double timingScoreShift,
      required final PlantIntelligenceReport oldReport,
      required final PlantIntelligenceReport newReport,
      required final DateTime comparedAt}) = _$IntelligenceEvolutionSummaryImpl;

  factory _IntelligenceEvolutionSummary.fromJson(Map<String, dynamic> json) =
      _$IntelligenceEvolutionSummaryImpl.fromJson;

  @override

  /// ID of the plant being compared
  String get plantId;
  @override

  /// Name of the plant
  String get plantName;
  @override

  /// Change in intelligence score (positive = improvement)
  double get scoreDelta;
  @override

  /// Change in confidence level (positive = more confident)
  double get confidenceDelta;
  @override

  /// List of new recommendations that were added
  List<String> get addedRecommendations;
  @override

  /// List of recommendations that were removed
  List<String> get removedRecommendations;
  @override

  /// List of recommendations that were modified (priority or status changed)
  List<String> get modifiedRecommendations;
  @override

  /// True if the plant's health improved
  bool get isImproved;
  @override

  /// True if the plant's health remained stable
  bool get isStable;
  @override

  /// True if the plant's health degraded
  bool get isDegraded;
  @override

  /// Change in timing score (e.g., seasonality changes)
  double get timingScoreShift;
  @override

  /// Reference to old report (for detailed analysis)
  PlantIntelligenceReport get oldReport;
  @override

  /// Reference to new report (for detailed analysis)
  PlantIntelligenceReport get newReport;
  @override

  /// When this comparison was performed
  DateTime get comparedAt;
  @override
  @JsonKey(ignore: true)
  _$$IntelligenceEvolutionSummaryImplCopyWith<
          _$IntelligenceEvolutionSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
