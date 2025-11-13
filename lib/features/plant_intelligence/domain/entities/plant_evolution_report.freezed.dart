// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_evolution_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlantEvolutionReport _$PlantEvolutionReportFromJson(Map<String, dynamic> json) {
  return _PlantEvolutionReport.fromJson(json);
}

/// @nodoc
mixin _$PlantEvolutionReport {
  /// ID of the plant being compared
  String get plantId => throw _privateConstructorUsedError;

  /// Date of the previous report
  DateTime get previousDate => throw _privateConstructorUsedError;

  /// Date of the current report
  DateTime get currentDate => throw _privateConstructorUsedError;

  /// Previous intelligence score (0-100)
  double get previousScore => throw _privateConstructorUsedError;

  /// Current intelligence score (0-100)
  double get currentScore => throw _privateConstructorUsedError;

  /// Delta between current and previous score
  /// Positive = improvement, Negative = degradation
  double get deltaScore => throw _privateConstructorUsedError;

  /// Trend indicator: 'up', 'down', or 'stable'
  String get trend => throw _privateConstructorUsedError;

  /// List of condition names that improved
  /// (e.g., 'temperature', 'humidity', 'light', 'soil')
  List<String> get improvedConditions => throw _privateConstructorUsedError;

  /// List of condition names that degraded
  List<String> get degradedConditions => throw _privateConstructorUsedError;

  /// List of condition names that remained unchanged
  List<String> get unchangedConditions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlantEvolutionReportCopyWith<PlantEvolutionReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantEvolutionReportCopyWith<$Res> {
  factory $PlantEvolutionReportCopyWith(PlantEvolutionReport value,
          $Res Function(PlantEvolutionReport) then) =
      _$PlantEvolutionReportCopyWithImpl<$Res, PlantEvolutionReport>;
  @useResult
  $Res call(
      {String plantId,
      DateTime previousDate,
      DateTime currentDate,
      double previousScore,
      double currentScore,
      double deltaScore,
      String trend,
      List<String> improvedConditions,
      List<String> degradedConditions,
      List<String> unchangedConditions});
}

/// @nodoc
class _$PlantEvolutionReportCopyWithImpl<$Res,
        $Val extends PlantEvolutionReport>
    implements $PlantEvolutionReportCopyWith<$Res> {
  _$PlantEvolutionReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? previousDate = null,
    Object? currentDate = null,
    Object? previousScore = null,
    Object? currentScore = null,
    Object? deltaScore = null,
    Object? trend = null,
    Object? improvedConditions = null,
    Object? degradedConditions = null,
    Object? unchangedConditions = null,
  }) {
    return _then(_value.copyWith(
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      previousDate: null == previousDate
          ? _value.previousDate
          : previousDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentDate: null == currentDate
          ? _value.currentDate
          : currentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      previousScore: null == previousScore
          ? _value.previousScore
          : previousScore // ignore: cast_nullable_to_non_nullable
              as double,
      currentScore: null == currentScore
          ? _value.currentScore
          : currentScore // ignore: cast_nullable_to_non_nullable
              as double,
      deltaScore: null == deltaScore
          ? _value.deltaScore
          : deltaScore // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String,
      improvedConditions: null == improvedConditions
          ? _value.improvedConditions
          : improvedConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      degradedConditions: null == degradedConditions
          ? _value.degradedConditions
          : degradedConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      unchangedConditions: null == unchangedConditions
          ? _value.unchangedConditions
          : unchangedConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlantEvolutionReportImplCopyWith<$Res>
    implements $PlantEvolutionReportCopyWith<$Res> {
  factory _$$PlantEvolutionReportImplCopyWith(_$PlantEvolutionReportImpl value,
          $Res Function(_$PlantEvolutionReportImpl) then) =
      __$$PlantEvolutionReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String plantId,
      DateTime previousDate,
      DateTime currentDate,
      double previousScore,
      double currentScore,
      double deltaScore,
      String trend,
      List<String> improvedConditions,
      List<String> degradedConditions,
      List<String> unchangedConditions});
}

/// @nodoc
class __$$PlantEvolutionReportImplCopyWithImpl<$Res>
    extends _$PlantEvolutionReportCopyWithImpl<$Res, _$PlantEvolutionReportImpl>
    implements _$$PlantEvolutionReportImplCopyWith<$Res> {
  __$$PlantEvolutionReportImplCopyWithImpl(_$PlantEvolutionReportImpl _value,
      $Res Function(_$PlantEvolutionReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? previousDate = null,
    Object? currentDate = null,
    Object? previousScore = null,
    Object? currentScore = null,
    Object? deltaScore = null,
    Object? trend = null,
    Object? improvedConditions = null,
    Object? degradedConditions = null,
    Object? unchangedConditions = null,
  }) {
    return _then(_$PlantEvolutionReportImpl(
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      previousDate: null == previousDate
          ? _value.previousDate
          : previousDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentDate: null == currentDate
          ? _value.currentDate
          : currentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      previousScore: null == previousScore
          ? _value.previousScore
          : previousScore // ignore: cast_nullable_to_non_nullable
              as double,
      currentScore: null == currentScore
          ? _value.currentScore
          : currentScore // ignore: cast_nullable_to_non_nullable
              as double,
      deltaScore: null == deltaScore
          ? _value.deltaScore
          : deltaScore // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String,
      improvedConditions: null == improvedConditions
          ? _value._improvedConditions
          : improvedConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      degradedConditions: null == degradedConditions
          ? _value._degradedConditions
          : degradedConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      unchangedConditions: null == unchangedConditions
          ? _value._unchangedConditions
          : unchangedConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantEvolutionReportImpl implements _PlantEvolutionReport {
  const _$PlantEvolutionReportImpl(
      {required this.plantId,
      required this.previousDate,
      required this.currentDate,
      required this.previousScore,
      required this.currentScore,
      required this.deltaScore,
      required this.trend,
      final List<String> improvedConditions = const [],
      final List<String> degradedConditions = const [],
      final List<String> unchangedConditions = const []})
      : _improvedConditions = improvedConditions,
        _degradedConditions = degradedConditions,
        _unchangedConditions = unchangedConditions;

  factory _$PlantEvolutionReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantEvolutionReportImplFromJson(json);

  /// ID of the plant being compared
  @override
  final String plantId;

  /// Date of the previous report
  @override
  final DateTime previousDate;

  /// Date of the current report
  @override
  final DateTime currentDate;

  /// Previous intelligence score (0-100)
  @override
  final double previousScore;

  /// Current intelligence score (0-100)
  @override
  final double currentScore;

  /// Delta between current and previous score
  /// Positive = improvement, Negative = degradation
  @override
  final double deltaScore;

  /// Trend indicator: 'up', 'down', or 'stable'
  @override
  final String trend;

  /// List of condition names that improved
  /// (e.g., 'temperature', 'humidity', 'light', 'soil')
  final List<String> _improvedConditions;

  /// List of condition names that improved
  /// (e.g., 'temperature', 'humidity', 'light', 'soil')
  @override
  @JsonKey()
  List<String> get improvedConditions {
    if (_improvedConditions is EqualUnmodifiableListView)
      return _improvedConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_improvedConditions);
  }

  /// List of condition names that degraded
  final List<String> _degradedConditions;

  /// List of condition names that degraded
  @override
  @JsonKey()
  List<String> get degradedConditions {
    if (_degradedConditions is EqualUnmodifiableListView)
      return _degradedConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_degradedConditions);
  }

  /// List of condition names that remained unchanged
  final List<String> _unchangedConditions;

  /// List of condition names that remained unchanged
  @override
  @JsonKey()
  List<String> get unchangedConditions {
    if (_unchangedConditions is EqualUnmodifiableListView)
      return _unchangedConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unchangedConditions);
  }

  @override
  String toString() {
    return 'PlantEvolutionReport(plantId: $plantId, previousDate: $previousDate, currentDate: $currentDate, previousScore: $previousScore, currentScore: $currentScore, deltaScore: $deltaScore, trend: $trend, improvedConditions: $improvedConditions, degradedConditions: $degradedConditions, unchangedConditions: $unchangedConditions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantEvolutionReportImpl &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.previousDate, previousDate) ||
                other.previousDate == previousDate) &&
            (identical(other.currentDate, currentDate) ||
                other.currentDate == currentDate) &&
            (identical(other.previousScore, previousScore) ||
                other.previousScore == previousScore) &&
            (identical(other.currentScore, currentScore) ||
                other.currentScore == currentScore) &&
            (identical(other.deltaScore, deltaScore) ||
                other.deltaScore == deltaScore) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            const DeepCollectionEquality()
                .equals(other._improvedConditions, _improvedConditions) &&
            const DeepCollectionEquality()
                .equals(other._degradedConditions, _degradedConditions) &&
            const DeepCollectionEquality()
                .equals(other._unchangedConditions, _unchangedConditions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      plantId,
      previousDate,
      currentDate,
      previousScore,
      currentScore,
      deltaScore,
      trend,
      const DeepCollectionEquality().hash(_improvedConditions),
      const DeepCollectionEquality().hash(_degradedConditions),
      const DeepCollectionEquality().hash(_unchangedConditions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantEvolutionReportImplCopyWith<_$PlantEvolutionReportImpl>
      get copyWith =>
          __$$PlantEvolutionReportImplCopyWithImpl<_$PlantEvolutionReportImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantEvolutionReportImplToJson(
      this,
    );
  }
}

abstract class _PlantEvolutionReport implements PlantEvolutionReport {
  const factory _PlantEvolutionReport(
      {required final String plantId,
      required final DateTime previousDate,
      required final DateTime currentDate,
      required final double previousScore,
      required final double currentScore,
      required final double deltaScore,
      required final String trend,
      final List<String> improvedConditions,
      final List<String> degradedConditions,
      final List<String> unchangedConditions}) = _$PlantEvolutionReportImpl;

  factory _PlantEvolutionReport.fromJson(Map<String, dynamic> json) =
      _$PlantEvolutionReportImpl.fromJson;

  @override

  /// ID of the plant being compared
  String get plantId;
  @override

  /// Date of the previous report
  DateTime get previousDate;
  @override

  /// Date of the current report
  DateTime get currentDate;
  @override

  /// Previous intelligence score (0-100)
  double get previousScore;
  @override

  /// Current intelligence score (0-100)
  double get currentScore;
  @override

  /// Delta between current and previous score
  /// Positive = improvement, Negative = degradation
  double get deltaScore;
  @override

  /// Trend indicator: 'up', 'down', or 'stable'
  String get trend;
  @override

  /// List of condition names that improved
  /// (e.g., 'temperature', 'humidity', 'light', 'soil')
  List<String> get improvedConditions;
  @override

  /// List of condition names that degraded
  List<String> get degradedConditions;
  @override

  /// List of condition names that remained unchanged
  List<String> get unchangedConditions;
  @override
  @JsonKey(ignore: true)
  _$$PlantEvolutionReportImplCopyWith<_$PlantEvolutionReportImpl>
      get copyWith => throw _privateConstructorUsedError;
}
