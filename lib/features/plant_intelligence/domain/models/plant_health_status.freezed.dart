// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_health_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlantHealthComponent _$PlantHealthComponentFromJson(Map<String, dynamic> json) {
  return _PlantHealthComponent.fromJson(json);
}

/// @nodoc
mixin _$PlantHealthComponent {
  /// Facteur mesuré (humidité, lumière, etc.)
  @HiveField(0)
  PlantHealthFactor get factor => throw _privateConstructorUsedError;

  /// Score (0-100) issu de l'analyse
  @HiveField(1)
  double get score => throw _privateConstructorUsedError;

  /// Niveau de santé associé au score
  @HiveField(2)
  PlantHealthLevel get level => throw _privateConstructorUsedError;

  /// Valeur brute mesurée (ex: % humidité)
  @HiveField(3)
  double? get value => throw _privateConstructorUsedError;

  /// Valeur optimale attendue
  @HiveField(4)
  double? get optimalValue => throw _privateConstructorUsedError;

  /// Valeur minimale acceptable
  @HiveField(5)
  double? get minValue => throw _privateConstructorUsedError;

  /// Valeur maximale acceptable
  @HiveField(6)
  double? get maxValue => throw _privateConstructorUsedError;

  /// Unité de mesure (°, %, lux, etc.)
  @HiveField(7)
  String? get unit => throw _privateConstructorUsedError;

  /// Tendance textuelle (up, down, stable)
  @HiveField(8)
  String get trend => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlantHealthComponentCopyWith<PlantHealthComponent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantHealthComponentCopyWith<$Res> {
  factory $PlantHealthComponentCopyWith(PlantHealthComponent value,
          $Res Function(PlantHealthComponent) then) =
      _$PlantHealthComponentCopyWithImpl<$Res, PlantHealthComponent>;
  @useResult
  $Res call(
      {@HiveField(0) PlantHealthFactor factor,
      @HiveField(1) double score,
      @HiveField(2) PlantHealthLevel level,
      @HiveField(3) double? value,
      @HiveField(4) double? optimalValue,
      @HiveField(5) double? minValue,
      @HiveField(6) double? maxValue,
      @HiveField(7) String? unit,
      @HiveField(8) String trend});
}

/// @nodoc
class _$PlantHealthComponentCopyWithImpl<$Res,
        $Val extends PlantHealthComponent>
    implements $PlantHealthComponentCopyWith<$Res> {
  _$PlantHealthComponentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? factor = null,
    Object? score = null,
    Object? level = null,
    Object? value = freezed,
    Object? optimalValue = freezed,
    Object? minValue = freezed,
    Object? maxValue = freezed,
    Object? unit = freezed,
    Object? trend = null,
  }) {
    return _then(_value.copyWith(
      factor: null == factor
          ? _value.factor
          : factor // ignore: cast_nullable_to_non_nullable
              as PlantHealthFactor,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as PlantHealthLevel,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double?,
      optimalValue: freezed == optimalValue
          ? _value.optimalValue
          : optimalValue // ignore: cast_nullable_to_non_nullable
              as double?,
      minValue: freezed == minValue
          ? _value.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as double?,
      maxValue: freezed == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlantHealthComponentImplCopyWith<$Res>
    implements $PlantHealthComponentCopyWith<$Res> {
  factory _$$PlantHealthComponentImplCopyWith(_$PlantHealthComponentImpl value,
          $Res Function(_$PlantHealthComponentImpl) then) =
      __$$PlantHealthComponentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) PlantHealthFactor factor,
      @HiveField(1) double score,
      @HiveField(2) PlantHealthLevel level,
      @HiveField(3) double? value,
      @HiveField(4) double? optimalValue,
      @HiveField(5) double? minValue,
      @HiveField(6) double? maxValue,
      @HiveField(7) String? unit,
      @HiveField(8) String trend});
}

/// @nodoc
class __$$PlantHealthComponentImplCopyWithImpl<$Res>
    extends _$PlantHealthComponentCopyWithImpl<$Res, _$PlantHealthComponentImpl>
    implements _$$PlantHealthComponentImplCopyWith<$Res> {
  __$$PlantHealthComponentImplCopyWithImpl(_$PlantHealthComponentImpl _value,
      $Res Function(_$PlantHealthComponentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? factor = null,
    Object? score = null,
    Object? level = null,
    Object? value = freezed,
    Object? optimalValue = freezed,
    Object? minValue = freezed,
    Object? maxValue = freezed,
    Object? unit = freezed,
    Object? trend = null,
  }) {
    return _then(_$PlantHealthComponentImpl(
      factor: null == factor
          ? _value.factor
          : factor // ignore: cast_nullable_to_non_nullable
              as PlantHealthFactor,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as PlantHealthLevel,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double?,
      optimalValue: freezed == optimalValue
          ? _value.optimalValue
          : optimalValue // ignore: cast_nullable_to_non_nullable
              as double?,
      minValue: freezed == minValue
          ? _value.minValue
          : minValue // ignore: cast_nullable_to_non_nullable
              as double?,
      maxValue: freezed == maxValue
          ? _value.maxValue
          : maxValue // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable()
@HiveType(typeId: 56, adapterName: 'PlantHealthComponentAdapter')
class _$PlantHealthComponentImpl extends _PlantHealthComponent {
  const _$PlantHealthComponentImpl(
      {@HiveField(0) required this.factor,
      @HiveField(1) required this.score,
      @HiveField(2) required this.level,
      @HiveField(3) this.value,
      @HiveField(4) this.optimalValue,
      @HiveField(5) this.minValue,
      @HiveField(6) this.maxValue,
      @HiveField(7) this.unit,
      @HiveField(8) this.trend = 'stable'})
      : super._();

  factory _$PlantHealthComponentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantHealthComponentImplFromJson(json);

  /// Facteur mesuré (humidité, lumière, etc.)
  @override
  @HiveField(0)
  final PlantHealthFactor factor;

  /// Score (0-100) issu de l'analyse
  @override
  @HiveField(1)
  final double score;

  /// Niveau de santé associé au score
  @override
  @HiveField(2)
  final PlantHealthLevel level;

  /// Valeur brute mesurée (ex: % humidité)
  @override
  @HiveField(3)
  final double? value;

  /// Valeur optimale attendue
  @override
  @HiveField(4)
  final double? optimalValue;

  /// Valeur minimale acceptable
  @override
  @HiveField(5)
  final double? minValue;

  /// Valeur maximale acceptable
  @override
  @HiveField(6)
  final double? maxValue;

  /// Unité de mesure (°, %, lux, etc.)
  @override
  @HiveField(7)
  final String? unit;

  /// Tendance textuelle (up, down, stable)
  @override
  @JsonKey()
  @HiveField(8)
  final String trend;

  @override
  String toString() {
    return 'PlantHealthComponent(factor: $factor, score: $score, level: $level, value: $value, optimalValue: $optimalValue, minValue: $minValue, maxValue: $maxValue, unit: $unit, trend: $trend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantHealthComponentImpl &&
            (identical(other.factor, factor) || other.factor == factor) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.optimalValue, optimalValue) ||
                other.optimalValue == optimalValue) &&
            (identical(other.minValue, minValue) ||
                other.minValue == minValue) &&
            (identical(other.maxValue, maxValue) ||
                other.maxValue == maxValue) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.trend, trend) || other.trend == trend));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, factor, score, level, value,
      optimalValue, minValue, maxValue, unit, trend);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantHealthComponentImplCopyWith<_$PlantHealthComponentImpl>
      get copyWith =>
          __$$PlantHealthComponentImplCopyWithImpl<_$PlantHealthComponentImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantHealthComponentImplToJson(
      this,
    );
  }
}

abstract class _PlantHealthComponent extends PlantHealthComponent {
  const factory _PlantHealthComponent(
      {@HiveField(0) required final PlantHealthFactor factor,
      @HiveField(1) required final double score,
      @HiveField(2) required final PlantHealthLevel level,
      @HiveField(3) final double? value,
      @HiveField(4) final double? optimalValue,
      @HiveField(5) final double? minValue,
      @HiveField(6) final double? maxValue,
      @HiveField(7) final String? unit,
      @HiveField(8) final String trend}) = _$PlantHealthComponentImpl;
  const _PlantHealthComponent._() : super._();

  factory _PlantHealthComponent.fromJson(Map<String, dynamic> json) =
      _$PlantHealthComponentImpl.fromJson;

  @override

  /// Facteur mesuré (humidité, lumière, etc.)
  @HiveField(0)
  PlantHealthFactor get factor;
  @override

  /// Score (0-100) issu de l'analyse
  @HiveField(1)
  double get score;
  @override

  /// Niveau de santé associé au score
  @HiveField(2)
  PlantHealthLevel get level;
  @override

  /// Valeur brute mesurée (ex: % humidité)
  @HiveField(3)
  double? get value;
  @override

  /// Valeur optimale attendue
  @HiveField(4)
  double? get optimalValue;
  @override

  /// Valeur minimale acceptable
  @HiveField(5)
  double? get minValue;
  @override

  /// Valeur maximale acceptable
  @HiveField(6)
  double? get maxValue;
  @override

  /// Unité de mesure (°, %, lux, etc.)
  @HiveField(7)
  String? get unit;
  @override

  /// Tendance textuelle (up, down, stable)
  @HiveField(8)
  String get trend;
  @override
  @JsonKey(ignore: true)
  _$$PlantHealthComponentImplCopyWith<_$PlantHealthComponentImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PlantHealthStatus _$PlantHealthStatusFromJson(Map<String, dynamic> json) {
  return _PlantHealthStatus.fromJson(json);
}

/// @nodoc
mixin _$PlantHealthStatus {
  /// Identifiant unique de la plante
  @HiveField(0)
  String get plantId => throw _privateConstructorUsedError;

  /// Identifiant du jardin pour le multi-garden
  @HiveField(1)
  String get gardenId => throw _privateConstructorUsedError;

  /// Score global de santé (0-100)
  @HiveField(2)
  double get overallScore => throw _privateConstructorUsedError;

  /// Niveau global calculé selon le score
  @HiveField(3)
  PlantHealthLevel get level => throw _privateConstructorUsedError;

  /// Analyse de l'humidité
  @HiveField(4)
  PlantHealthComponent get humidity => throw _privateConstructorUsedError;

  /// Analyse de la lumière
  @HiveField(5)
  PlantHealthComponent get light => throw _privateConstructorUsedError;

  /// Analyse de la température
  @HiveField(6)
  PlantHealthComponent get temperature => throw _privateConstructorUsedError;

  /// Analyse des nutriments
  @HiveField(7)
  PlantHealthComponent get nutrients => throw _privateConstructorUsedError;

  /// Analyse de l'humidité du sol
  @HiveField(8)
  PlantHealthComponent? get soilMoisture => throw _privateConstructorUsedError;

  /// Analyse du stress hydrique
  @HiveField(9)
  PlantHealthComponent? get waterStress => throw _privateConstructorUsedError;

  /// Analyse de la pression des nuisibles
  @HiveField(10)
  PlantHealthComponent? get pestPressure => throw _privateConstructorUsedError;

  /// Dernière mise à jour du calcul
  @HiveField(11)
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Date de dernière synchronisation avec les capteurs
  @HiveField(12)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;

  /// Liste d'alertes actives pour l'utilisateur
  @HiveField(13)
  List<String> get activeAlerts => throw _privateConstructorUsedError;

  /// Actions recommandées par l'intelligence
  @HiveField(14)
  List<String> get recommendedActions => throw _privateConstructorUsedError;

  /// Tendance globale sur 7/30 jours (`improving`, `declining`, `stable`)
  @HiveField(15)
  String get healthTrend => throw _privateConstructorUsedError;

  /// Scores de tendances par facteur (clé = facteur)
  @HiveField(16)
  Map<String, double> get factorTrends => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles (source, version modèle, etc.)
  @HiveField(17)
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlantHealthStatusCopyWith<PlantHealthStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantHealthStatusCopyWith<$Res> {
  factory $PlantHealthStatusCopyWith(
          PlantHealthStatus value, $Res Function(PlantHealthStatus) then) =
      _$PlantHealthStatusCopyWithImpl<$Res, PlantHealthStatus>;
  @useResult
  $Res call(
      {@HiveField(0) String plantId,
      @HiveField(1) String gardenId,
      @HiveField(2) double overallScore,
      @HiveField(3) PlantHealthLevel level,
      @HiveField(4) PlantHealthComponent humidity,
      @HiveField(5) PlantHealthComponent light,
      @HiveField(6) PlantHealthComponent temperature,
      @HiveField(7) PlantHealthComponent nutrients,
      @HiveField(8) PlantHealthComponent? soilMoisture,
      @HiveField(9) PlantHealthComponent? waterStress,
      @HiveField(10) PlantHealthComponent? pestPressure,
      @HiveField(11) DateTime lastUpdated,
      @HiveField(12) DateTime? lastSyncedAt,
      @HiveField(13) List<String> activeAlerts,
      @HiveField(14) List<String> recommendedActions,
      @HiveField(15) String healthTrend,
      @HiveField(16) Map<String, double> factorTrends,
      @HiveField(17) Map<String, dynamic> metadata});

  $PlantHealthComponentCopyWith<$Res> get humidity;
  $PlantHealthComponentCopyWith<$Res> get light;
  $PlantHealthComponentCopyWith<$Res> get temperature;
  $PlantHealthComponentCopyWith<$Res> get nutrients;
  $PlantHealthComponentCopyWith<$Res>? get soilMoisture;
  $PlantHealthComponentCopyWith<$Res>? get waterStress;
  $PlantHealthComponentCopyWith<$Res>? get pestPressure;
}

/// @nodoc
class _$PlantHealthStatusCopyWithImpl<$Res, $Val extends PlantHealthStatus>
    implements $PlantHealthStatusCopyWith<$Res> {
  _$PlantHealthStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? gardenId = null,
    Object? overallScore = null,
    Object? level = null,
    Object? humidity = null,
    Object? light = null,
    Object? temperature = null,
    Object? nutrients = null,
    Object? soilMoisture = freezed,
    Object? waterStress = freezed,
    Object? pestPressure = freezed,
    Object? lastUpdated = null,
    Object? lastSyncedAt = freezed,
    Object? activeAlerts = null,
    Object? recommendedActions = null,
    Object? healthTrend = null,
    Object? factorTrends = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as double,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as PlantHealthLevel,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent,
      light: null == light
          ? _value.light
          : light // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent,
      nutrients: null == nutrients
          ? _value.nutrients
          : nutrients // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent,
      soilMoisture: freezed == soilMoisture
          ? _value.soilMoisture
          : soilMoisture // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent?,
      waterStress: freezed == waterStress
          ? _value.waterStress
          : waterStress // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent?,
      pestPressure: freezed == pestPressure
          ? _value.pestPressure
          : pestPressure // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent?,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      activeAlerts: null == activeAlerts
          ? _value.activeAlerts
          : activeAlerts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendedActions: null == recommendedActions
          ? _value.recommendedActions
          : recommendedActions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      healthTrend: null == healthTrend
          ? _value.healthTrend
          : healthTrend // ignore: cast_nullable_to_non_nullable
              as String,
      factorTrends: null == factorTrends
          ? _value.factorTrends
          : factorTrends // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantHealthComponentCopyWith<$Res> get humidity {
    return $PlantHealthComponentCopyWith<$Res>(_value.humidity, (value) {
      return _then(_value.copyWith(humidity: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantHealthComponentCopyWith<$Res> get light {
    return $PlantHealthComponentCopyWith<$Res>(_value.light, (value) {
      return _then(_value.copyWith(light: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantHealthComponentCopyWith<$Res> get temperature {
    return $PlantHealthComponentCopyWith<$Res>(_value.temperature, (value) {
      return _then(_value.copyWith(temperature: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantHealthComponentCopyWith<$Res> get nutrients {
    return $PlantHealthComponentCopyWith<$Res>(_value.nutrients, (value) {
      return _then(_value.copyWith(nutrients: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantHealthComponentCopyWith<$Res>? get soilMoisture {
    if (_value.soilMoisture == null) {
      return null;
    }

    return $PlantHealthComponentCopyWith<$Res>(_value.soilMoisture!, (value) {
      return _then(_value.copyWith(soilMoisture: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantHealthComponentCopyWith<$Res>? get waterStress {
    if (_value.waterStress == null) {
      return null;
    }

    return $PlantHealthComponentCopyWith<$Res>(_value.waterStress!, (value) {
      return _then(_value.copyWith(waterStress: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlantHealthComponentCopyWith<$Res>? get pestPressure {
    if (_value.pestPressure == null) {
      return null;
    }

    return $PlantHealthComponentCopyWith<$Res>(_value.pestPressure!, (value) {
      return _then(_value.copyWith(pestPressure: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlantHealthStatusImplCopyWith<$Res>
    implements $PlantHealthStatusCopyWith<$Res> {
  factory _$$PlantHealthStatusImplCopyWith(_$PlantHealthStatusImpl value,
          $Res Function(_$PlantHealthStatusImpl) then) =
      __$$PlantHealthStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String plantId,
      @HiveField(1) String gardenId,
      @HiveField(2) double overallScore,
      @HiveField(3) PlantHealthLevel level,
      @HiveField(4) PlantHealthComponent humidity,
      @HiveField(5) PlantHealthComponent light,
      @HiveField(6) PlantHealthComponent temperature,
      @HiveField(7) PlantHealthComponent nutrients,
      @HiveField(8) PlantHealthComponent? soilMoisture,
      @HiveField(9) PlantHealthComponent? waterStress,
      @HiveField(10) PlantHealthComponent? pestPressure,
      @HiveField(11) DateTime lastUpdated,
      @HiveField(12) DateTime? lastSyncedAt,
      @HiveField(13) List<String> activeAlerts,
      @HiveField(14) List<String> recommendedActions,
      @HiveField(15) String healthTrend,
      @HiveField(16) Map<String, double> factorTrends,
      @HiveField(17) Map<String, dynamic> metadata});

  @override
  $PlantHealthComponentCopyWith<$Res> get humidity;
  @override
  $PlantHealthComponentCopyWith<$Res> get light;
  @override
  $PlantHealthComponentCopyWith<$Res> get temperature;
  @override
  $PlantHealthComponentCopyWith<$Res> get nutrients;
  @override
  $PlantHealthComponentCopyWith<$Res>? get soilMoisture;
  @override
  $PlantHealthComponentCopyWith<$Res>? get waterStress;
  @override
  $PlantHealthComponentCopyWith<$Res>? get pestPressure;
}

/// @nodoc
class __$$PlantHealthStatusImplCopyWithImpl<$Res>
    extends _$PlantHealthStatusCopyWithImpl<$Res, _$PlantHealthStatusImpl>
    implements _$$PlantHealthStatusImplCopyWith<$Res> {
  __$$PlantHealthStatusImplCopyWithImpl(_$PlantHealthStatusImpl _value,
      $Res Function(_$PlantHealthStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? gardenId = null,
    Object? overallScore = null,
    Object? level = null,
    Object? humidity = null,
    Object? light = null,
    Object? temperature = null,
    Object? nutrients = null,
    Object? soilMoisture = freezed,
    Object? waterStress = freezed,
    Object? pestPressure = freezed,
    Object? lastUpdated = null,
    Object? lastSyncedAt = freezed,
    Object? activeAlerts = null,
    Object? recommendedActions = null,
    Object? healthTrend = null,
    Object? factorTrends = null,
    Object? metadata = null,
  }) {
    return _then(_$PlantHealthStatusImpl(
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as double,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as PlantHealthLevel,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent,
      light: null == light
          ? _value.light
          : light // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent,
      nutrients: null == nutrients
          ? _value.nutrients
          : nutrients // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent,
      soilMoisture: freezed == soilMoisture
          ? _value.soilMoisture
          : soilMoisture // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent?,
      waterStress: freezed == waterStress
          ? _value.waterStress
          : waterStress // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent?,
      pestPressure: freezed == pestPressure
          ? _value.pestPressure
          : pestPressure // ignore: cast_nullable_to_non_nullable
              as PlantHealthComponent?,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      activeAlerts: null == activeAlerts
          ? _value._activeAlerts
          : activeAlerts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recommendedActions: null == recommendedActions
          ? _value._recommendedActions
          : recommendedActions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      healthTrend: null == healthTrend
          ? _value.healthTrend
          : healthTrend // ignore: cast_nullable_to_non_nullable
              as String,
      factorTrends: null == factorTrends
          ? _value._factorTrends
          : factorTrends // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 57, adapterName: 'PlantHealthStatusAdapter')
class _$PlantHealthStatusImpl extends _PlantHealthStatus {
  const _$PlantHealthStatusImpl(
      {@HiveField(0) required this.plantId,
      @HiveField(1) required this.gardenId,
      @HiveField(2) required this.overallScore,
      @HiveField(3) required this.level,
      @HiveField(4) required this.humidity,
      @HiveField(5) required this.light,
      @HiveField(6) required this.temperature,
      @HiveField(7) required this.nutrients,
      @HiveField(8) this.soilMoisture,
      @HiveField(9) this.waterStress,
      @HiveField(10) this.pestPressure,
      @HiveField(11) required this.lastUpdated,
      @HiveField(12) this.lastSyncedAt,
      @HiveField(13) final List<String> activeAlerts = const <String>[],
      @HiveField(14) final List<String> recommendedActions = const <String>[],
      @HiveField(15) this.healthTrend = 'unknown',
      @HiveField(16)
      final Map<String, double> factorTrends = const <String, double>{},
      @HiveField(17)
      final Map<String, dynamic> metadata = const <String, dynamic>{}})
      : _activeAlerts = activeAlerts,
        _recommendedActions = recommendedActions,
        _factorTrends = factorTrends,
        _metadata = metadata,
        super._();

  factory _$PlantHealthStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantHealthStatusImplFromJson(json);

  /// Identifiant unique de la plante
  @override
  @HiveField(0)
  final String plantId;

  /// Identifiant du jardin pour le multi-garden
  @override
  @HiveField(1)
  final String gardenId;

  /// Score global de santé (0-100)
  @override
  @HiveField(2)
  final double overallScore;

  /// Niveau global calculé selon le score
  @override
  @HiveField(3)
  final PlantHealthLevel level;

  /// Analyse de l'humidité
  @override
  @HiveField(4)
  final PlantHealthComponent humidity;

  /// Analyse de la lumière
  @override
  @HiveField(5)
  final PlantHealthComponent light;

  /// Analyse de la température
  @override
  @HiveField(6)
  final PlantHealthComponent temperature;

  /// Analyse des nutriments
  @override
  @HiveField(7)
  final PlantHealthComponent nutrients;

  /// Analyse de l'humidité du sol
  @override
  @HiveField(8)
  final PlantHealthComponent? soilMoisture;

  /// Analyse du stress hydrique
  @override
  @HiveField(9)
  final PlantHealthComponent? waterStress;

  /// Analyse de la pression des nuisibles
  @override
  @HiveField(10)
  final PlantHealthComponent? pestPressure;

  /// Dernière mise à jour du calcul
  @override
  @HiveField(11)
  final DateTime lastUpdated;

  /// Date de dernière synchronisation avec les capteurs
  @override
  @HiveField(12)
  final DateTime? lastSyncedAt;

  /// Liste d'alertes actives pour l'utilisateur
  final List<String> _activeAlerts;

  /// Liste d'alertes actives pour l'utilisateur
  @override
  @JsonKey()
  @HiveField(13)
  List<String> get activeAlerts {
    if (_activeAlerts is EqualUnmodifiableListView) return _activeAlerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeAlerts);
  }

  /// Actions recommandées par l'intelligence
  final List<String> _recommendedActions;

  /// Actions recommandées par l'intelligence
  @override
  @JsonKey()
  @HiveField(14)
  List<String> get recommendedActions {
    if (_recommendedActions is EqualUnmodifiableListView)
      return _recommendedActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedActions);
  }

  /// Tendance globale sur 7/30 jours (`improving`, `declining`, `stable`)
  @override
  @JsonKey()
  @HiveField(15)
  final String healthTrend;

  /// Scores de tendances par facteur (clé = facteur)
  final Map<String, double> _factorTrends;

  /// Scores de tendances par facteur (clé = facteur)
  @override
  @JsonKey()
  @HiveField(16)
  Map<String, double> get factorTrends {
    if (_factorTrends is EqualUnmodifiableMapView) return _factorTrends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_factorTrends);
  }

  /// Métadonnées additionnelles (source, version modèle, etc.)
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles (source, version modèle, etc.)
  @override
  @JsonKey()
  @HiveField(17)
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'PlantHealthStatus._data(plantId: $plantId, gardenId: $gardenId, overallScore: $overallScore, level: $level, humidity: $humidity, light: $light, temperature: $temperature, nutrients: $nutrients, soilMoisture: $soilMoisture, waterStress: $waterStress, pestPressure: $pestPressure, lastUpdated: $lastUpdated, lastSyncedAt: $lastSyncedAt, activeAlerts: $activeAlerts, recommendedActions: $recommendedActions, healthTrend: $healthTrend, factorTrends: $factorTrends, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantHealthStatusImpl &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.overallScore, overallScore) ||
                other.overallScore == overallScore) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.light, light) || other.light == light) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.nutrients, nutrients) ||
                other.nutrients == nutrients) &&
            (identical(other.soilMoisture, soilMoisture) ||
                other.soilMoisture == soilMoisture) &&
            (identical(other.waterStress, waterStress) ||
                other.waterStress == waterStress) &&
            (identical(other.pestPressure, pestPressure) ||
                other.pestPressure == pestPressure) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            const DeepCollectionEquality()
                .equals(other._activeAlerts, _activeAlerts) &&
            const DeepCollectionEquality()
                .equals(other._recommendedActions, _recommendedActions) &&
            (identical(other.healthTrend, healthTrend) ||
                other.healthTrend == healthTrend) &&
            const DeepCollectionEquality()
                .equals(other._factorTrends, _factorTrends) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      plantId,
      gardenId,
      overallScore,
      level,
      humidity,
      light,
      temperature,
      nutrients,
      soilMoisture,
      waterStress,
      pestPressure,
      lastUpdated,
      lastSyncedAt,
      const DeepCollectionEquality().hash(_activeAlerts),
      const DeepCollectionEquality().hash(_recommendedActions),
      healthTrend,
      const DeepCollectionEquality().hash(_factorTrends),
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantHealthStatusImplCopyWith<_$PlantHealthStatusImpl> get copyWith =>
      __$$PlantHealthStatusImplCopyWithImpl<_$PlantHealthStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantHealthStatusImplToJson(
      this,
    );
  }
}

abstract class _PlantHealthStatus extends PlantHealthStatus {
  const factory _PlantHealthStatus(
          {@HiveField(0) required final String plantId,
          @HiveField(1) required final String gardenId,
          @HiveField(2) required final double overallScore,
          @HiveField(3) required final PlantHealthLevel level,
          @HiveField(4) required final PlantHealthComponent humidity,
          @HiveField(5) required final PlantHealthComponent light,
          @HiveField(6) required final PlantHealthComponent temperature,
          @HiveField(7) required final PlantHealthComponent nutrients,
          @HiveField(8) final PlantHealthComponent? soilMoisture,
          @HiveField(9) final PlantHealthComponent? waterStress,
          @HiveField(10) final PlantHealthComponent? pestPressure,
          @HiveField(11) required final DateTime lastUpdated,
          @HiveField(12) final DateTime? lastSyncedAt,
          @HiveField(13) final List<String> activeAlerts,
          @HiveField(14) final List<String> recommendedActions,
          @HiveField(15) final String healthTrend,
          @HiveField(16) final Map<String, double> factorTrends,
          @HiveField(17) final Map<String, dynamic> metadata}) =
      _$PlantHealthStatusImpl;
  const _PlantHealthStatus._() : super._();

  factory _PlantHealthStatus.fromJson(Map<String, dynamic> json) =
      _$PlantHealthStatusImpl.fromJson;

  @override

  /// Identifiant unique de la plante
  @HiveField(0)
  String get plantId;
  @override

  /// Identifiant du jardin pour le multi-garden
  @HiveField(1)
  String get gardenId;
  @override

  /// Score global de santé (0-100)
  @HiveField(2)
  double get overallScore;
  @override

  /// Niveau global calculé selon le score
  @HiveField(3)
  PlantHealthLevel get level;
  @override

  /// Analyse de l'humidité
  @HiveField(4)
  PlantHealthComponent get humidity;
  @override

  /// Analyse de la lumière
  @HiveField(5)
  PlantHealthComponent get light;
  @override

  /// Analyse de la température
  @HiveField(6)
  PlantHealthComponent get temperature;
  @override

  /// Analyse des nutriments
  @HiveField(7)
  PlantHealthComponent get nutrients;
  @override

  /// Analyse de l'humidité du sol
  @HiveField(8)
  PlantHealthComponent? get soilMoisture;
  @override

  /// Analyse du stress hydrique
  @HiveField(9)
  PlantHealthComponent? get waterStress;
  @override

  /// Analyse de la pression des nuisibles
  @HiveField(10)
  PlantHealthComponent? get pestPressure;
  @override

  /// Dernière mise à jour du calcul
  @HiveField(11)
  DateTime get lastUpdated;
  @override

  /// Date de dernière synchronisation avec les capteurs
  @HiveField(12)
  DateTime? get lastSyncedAt;
  @override

  /// Liste d'alertes actives pour l'utilisateur
  @HiveField(13)
  List<String> get activeAlerts;
  @override

  /// Actions recommandées par l'intelligence
  @HiveField(14)
  List<String> get recommendedActions;
  @override

  /// Tendance globale sur 7/30 jours (`improving`, `declining`, `stable`)
  @HiveField(15)
  String get healthTrend;
  @override

  /// Scores de tendances par facteur (clé = facteur)
  @HiveField(16)
  Map<String, double> get factorTrends;
  @override

  /// Métadonnées additionnelles (source, version modèle, etc.)
  @HiveField(17)
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$PlantHealthStatusImplCopyWith<_$PlantHealthStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
