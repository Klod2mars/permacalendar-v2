// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlantFreezed _$PlantFreezedFromJson(Map<String, dynamic> json) {
  return _PlantFreezed.fromJson(json);
}

/// @nodoc
mixin _$PlantFreezed {
  /// Identifiant unique de la plante
  String get id => throw _privateConstructorUsedError;

  /// Nom commun de la plante
  String get commonName => throw _privateConstructorUsedError;

  /// Nom scientifique de la plante
  String get scientificName => throw _privateConstructorUsedError;

  /// Famille botanique
  String get family => throw _privateConstructorUsedError;

  /// Saison de plantation
  String get plantingSeason => throw _privateConstructorUsedError;

  /// Saison de récolte
  String get harvestSeason => throw _privateConstructorUsedError;

  /// Nombre de jours jusqu'à maturité
  int get daysToMaturity => throw _privateConstructorUsedError;

  /// Espacement entre plants (en cm)
  int get spacing => throw _privateConstructorUsedError;

  /// Profondeur de plantation (en cm)
  double get depth => throw _privateConstructorUsedError;

  /// Exposition au soleil requise
  String get sunExposure => throw _privateConstructorUsedError;

  /// Besoins en eau
  String get waterNeeds => throw _privateConstructorUsedError;

  /// Description de la plante
  String get description => throw _privateConstructorUsedError;

  /// Mois de semis (codes courts: F, M, A, etc.)
  List<String> get sowingMonths => throw _privateConstructorUsedError;

  /// Mois de récolte (codes courts: F, M, A, etc.)
  List<String> get harvestMonths => throw _privateConstructorUsedError;

  /// Prix du marché par kg
  double? get marketPricePerKg => throw _privateConstructorUsedError;

  /// Unité par défaut (kg, pièce, etc.)
  String? get defaultUnit => throw _privateConstructorUsedError;

  /// Informations nutritionnelles pour 100g
  Map<String, dynamic>? get nutritionPer100g =>
      throw _privateConstructorUsedError;

  /// Informations sur la germination
  Map<String, dynamic>? get germination => throw _privateConstructorUsedError;

  /// Informations sur la croissance
  Map<String, dynamic>? get growth => throw _privateConstructorUsedError;

  /// Informations sur l'arrosage
  Map<String, dynamic>? get watering => throw _privateConstructorUsedError;

  /// Informations sur l'éclaircissement
  Map<String, dynamic>? get thinning => throw _privateConstructorUsedError;

  /// Informations sur le désherbage
  Map<String, dynamic>? get weeding => throw _privateConstructorUsedError;

  /// Conseils culturaux
  List<String>? get culturalTips => throw _privateConstructorUsedError;

  /// Contrôle biologique
  Map<String, dynamic>? get biologicalControl =>
      throw _privateConstructorUsedError;

  /// Temps de récolte
  String? get harvestTime => throw _privateConstructorUsedError;

  /// Associations de plantes
  Map<String, dynamic>? get companionPlanting =>
      throw _privateConstructorUsedError;

  /// Paramètres de notification
  Map<String, dynamic>? get notificationSettings =>
      throw _privateConstructorUsedError;

  /// Variétés recommandées
  Map<String, dynamic>? get varieties => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles flexibles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Date de création
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Date de dernière mise à jour
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Indique si la plante est active
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlantFreezedCopyWith<PlantFreezed> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantFreezedCopyWith<$Res> {
  factory $PlantFreezedCopyWith(
          PlantFreezed value, $Res Function(PlantFreezed) then) =
      _$PlantFreezedCopyWithImpl<$Res, PlantFreezed>;
  @useResult
  $Res call(
      {String id,
      String commonName,
      String scientificName,
      String family,
      String plantingSeason,
      String harvestSeason,
      int daysToMaturity,
      int spacing,
      double depth,
      String sunExposure,
      String waterNeeds,
      String description,
      List<String> sowingMonths,
      List<String> harvestMonths,
      double? marketPricePerKg,
      String? defaultUnit,
      Map<String, dynamic>? nutritionPer100g,
      Map<String, dynamic>? germination,
      Map<String, dynamic>? growth,
      Map<String, dynamic>? watering,
      Map<String, dynamic>? thinning,
      Map<String, dynamic>? weeding,
      List<String>? culturalTips,
      Map<String, dynamic>? biologicalControl,
      String? harvestTime,
      Map<String, dynamic>? companionPlanting,
      Map<String, dynamic>? notificationSettings,
      Map<String, dynamic>? varieties,
      Map<String, dynamic> metadata,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isActive});
}

/// @nodoc
class _$PlantFreezedCopyWithImpl<$Res, $Val extends PlantFreezed>
    implements $PlantFreezedCopyWith<$Res> {
  _$PlantFreezedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commonName = null,
    Object? scientificName = null,
    Object? family = null,
    Object? plantingSeason = null,
    Object? harvestSeason = null,
    Object? daysToMaturity = null,
    Object? spacing = null,
    Object? depth = null,
    Object? sunExposure = null,
    Object? waterNeeds = null,
    Object? description = null,
    Object? sowingMonths = null,
    Object? harvestMonths = null,
    Object? marketPricePerKg = freezed,
    Object? defaultUnit = freezed,
    Object? nutritionPer100g = freezed,
    Object? germination = freezed,
    Object? growth = freezed,
    Object? watering = freezed,
    Object? thinning = freezed,
    Object? weeding = freezed,
    Object? culturalTips = freezed,
    Object? biologicalControl = freezed,
    Object? harvestTime = freezed,
    Object? companionPlanting = freezed,
    Object? notificationSettings = freezed,
    Object? varieties = freezed,
    Object? metadata = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      commonName: null == commonName
          ? _value.commonName
          : commonName // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: null == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String,
      family: null == family
          ? _value.family
          : family // ignore: cast_nullable_to_non_nullable
              as String,
      plantingSeason: null == plantingSeason
          ? _value.plantingSeason
          : plantingSeason // ignore: cast_nullable_to_non_nullable
              as String,
      harvestSeason: null == harvestSeason
          ? _value.harvestSeason
          : harvestSeason // ignore: cast_nullable_to_non_nullable
              as String,
      daysToMaturity: null == daysToMaturity
          ? _value.daysToMaturity
          : daysToMaturity // ignore: cast_nullable_to_non_nullable
              as int,
      spacing: null == spacing
          ? _value.spacing
          : spacing // ignore: cast_nullable_to_non_nullable
              as int,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double,
      sunExposure: null == sunExposure
          ? _value.sunExposure
          : sunExposure // ignore: cast_nullable_to_non_nullable
              as String,
      waterNeeds: null == waterNeeds
          ? _value.waterNeeds
          : waterNeeds // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sowingMonths: null == sowingMonths
          ? _value.sowingMonths
          : sowingMonths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      harvestMonths: null == harvestMonths
          ? _value.harvestMonths
          : harvestMonths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      marketPricePerKg: freezed == marketPricePerKg
          ? _value.marketPricePerKg
          : marketPricePerKg // ignore: cast_nullable_to_non_nullable
              as double?,
      defaultUnit: freezed == defaultUnit
          ? _value.defaultUnit
          : defaultUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionPer100g: freezed == nutritionPer100g
          ? _value.nutritionPer100g
          : nutritionPer100g // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      germination: freezed == germination
          ? _value.germination
          : germination // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      growth: freezed == growth
          ? _value.growth
          : growth // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      watering: freezed == watering
          ? _value.watering
          : watering // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      thinning: freezed == thinning
          ? _value.thinning
          : thinning // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      weeding: freezed == weeding
          ? _value.weeding
          : weeding // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      culturalTips: freezed == culturalTips
          ? _value.culturalTips
          : culturalTips // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      biologicalControl: freezed == biologicalControl
          ? _value.biologicalControl
          : biologicalControl // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      harvestTime: freezed == harvestTime
          ? _value.harvestTime
          : harvestTime // ignore: cast_nullable_to_non_nullable
              as String?,
      companionPlanting: freezed == companionPlanting
          ? _value.companionPlanting
          : companionPlanting // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      notificationSettings: freezed == notificationSettings
          ? _value.notificationSettings
          : notificationSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      varieties: freezed == varieties
          ? _value.varieties
          : varieties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlantFreezedImplCopyWith<$Res>
    implements $PlantFreezedCopyWith<$Res> {
  factory _$$PlantFreezedImplCopyWith(
          _$PlantFreezedImpl value, $Res Function(_$PlantFreezedImpl) then) =
      __$$PlantFreezedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String commonName,
      String scientificName,
      String family,
      String plantingSeason,
      String harvestSeason,
      int daysToMaturity,
      int spacing,
      double depth,
      String sunExposure,
      String waterNeeds,
      String description,
      List<String> sowingMonths,
      List<String> harvestMonths,
      double? marketPricePerKg,
      String? defaultUnit,
      Map<String, dynamic>? nutritionPer100g,
      Map<String, dynamic>? germination,
      Map<String, dynamic>? growth,
      Map<String, dynamic>? watering,
      Map<String, dynamic>? thinning,
      Map<String, dynamic>? weeding,
      List<String>? culturalTips,
      Map<String, dynamic>? biologicalControl,
      String? harvestTime,
      Map<String, dynamic>? companionPlanting,
      Map<String, dynamic>? notificationSettings,
      Map<String, dynamic>? varieties,
      Map<String, dynamic> metadata,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isActive});
}

/// @nodoc
class __$$PlantFreezedImplCopyWithImpl<$Res>
    extends _$PlantFreezedCopyWithImpl<$Res, _$PlantFreezedImpl>
    implements _$$PlantFreezedImplCopyWith<$Res> {
  __$$PlantFreezedImplCopyWithImpl(
      _$PlantFreezedImpl _value, $Res Function(_$PlantFreezedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commonName = null,
    Object? scientificName = null,
    Object? family = null,
    Object? plantingSeason = null,
    Object? harvestSeason = null,
    Object? daysToMaturity = null,
    Object? spacing = null,
    Object? depth = null,
    Object? sunExposure = null,
    Object? waterNeeds = null,
    Object? description = null,
    Object? sowingMonths = null,
    Object? harvestMonths = null,
    Object? marketPricePerKg = freezed,
    Object? defaultUnit = freezed,
    Object? nutritionPer100g = freezed,
    Object? germination = freezed,
    Object? growth = freezed,
    Object? watering = freezed,
    Object? thinning = freezed,
    Object? weeding = freezed,
    Object? culturalTips = freezed,
    Object? biologicalControl = freezed,
    Object? harvestTime = freezed,
    Object? companionPlanting = freezed,
    Object? notificationSettings = freezed,
    Object? varieties = freezed,
    Object? metadata = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_$PlantFreezedImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      commonName: null == commonName
          ? _value.commonName
          : commonName // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: null == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String,
      family: null == family
          ? _value.family
          : family // ignore: cast_nullable_to_non_nullable
              as String,
      plantingSeason: null == plantingSeason
          ? _value.plantingSeason
          : plantingSeason // ignore: cast_nullable_to_non_nullable
              as String,
      harvestSeason: null == harvestSeason
          ? _value.harvestSeason
          : harvestSeason // ignore: cast_nullable_to_non_nullable
              as String,
      daysToMaturity: null == daysToMaturity
          ? _value.daysToMaturity
          : daysToMaturity // ignore: cast_nullable_to_non_nullable
              as int,
      spacing: null == spacing
          ? _value.spacing
          : spacing // ignore: cast_nullable_to_non_nullable
              as int,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double,
      sunExposure: null == sunExposure
          ? _value.sunExposure
          : sunExposure // ignore: cast_nullable_to_non_nullable
              as String,
      waterNeeds: null == waterNeeds
          ? _value.waterNeeds
          : waterNeeds // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sowingMonths: null == sowingMonths
          ? _value._sowingMonths
          : sowingMonths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      harvestMonths: null == harvestMonths
          ? _value._harvestMonths
          : harvestMonths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      marketPricePerKg: freezed == marketPricePerKg
          ? _value.marketPricePerKg
          : marketPricePerKg // ignore: cast_nullable_to_non_nullable
              as double?,
      defaultUnit: freezed == defaultUnit
          ? _value.defaultUnit
          : defaultUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionPer100g: freezed == nutritionPer100g
          ? _value._nutritionPer100g
          : nutritionPer100g // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      germination: freezed == germination
          ? _value._germination
          : germination // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      growth: freezed == growth
          ? _value._growth
          : growth // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      watering: freezed == watering
          ? _value._watering
          : watering // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      thinning: freezed == thinning
          ? _value._thinning
          : thinning // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      weeding: freezed == weeding
          ? _value._weeding
          : weeding // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      culturalTips: freezed == culturalTips
          ? _value._culturalTips
          : culturalTips // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      biologicalControl: freezed == biologicalControl
          ? _value._biologicalControl
          : biologicalControl // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      harvestTime: freezed == harvestTime
          ? _value.harvestTime
          : harvestTime // ignore: cast_nullable_to_non_nullable
              as String?,
      companionPlanting: freezed == companionPlanting
          ? _value._companionPlanting
          : companionPlanting // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      notificationSettings: freezed == notificationSettings
          ? _value._notificationSettings
          : notificationSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      varieties: freezed == varieties
          ? _value._varieties
          : varieties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantFreezedImpl implements _PlantFreezed {
  const _$PlantFreezedImpl(
      {required this.id,
      required this.commonName,
      required this.scientificName,
      required this.family,
      required this.plantingSeason,
      required this.harvestSeason,
      required this.daysToMaturity,
      required this.spacing,
      required this.depth,
      required this.sunExposure,
      required this.waterNeeds,
      required this.description,
      required final List<String> sowingMonths,
      required final List<String> harvestMonths,
      this.marketPricePerKg,
      this.defaultUnit,
      final Map<String, dynamic>? nutritionPer100g,
      final Map<String, dynamic>? germination,
      final Map<String, dynamic>? growth,
      final Map<String, dynamic>? watering,
      final Map<String, dynamic>? thinning,
      final Map<String, dynamic>? weeding,
      final List<String>? culturalTips,
      final Map<String, dynamic>? biologicalControl,
      this.harvestTime,
      final Map<String, dynamic>? companionPlanting,
      final Map<String, dynamic>? notificationSettings,
      final Map<String, dynamic>? varieties,
      final Map<String, dynamic> metadata = const {},
      this.createdAt,
      this.updatedAt,
      this.isActive = true})
      : _sowingMonths = sowingMonths,
        _harvestMonths = harvestMonths,
        _nutritionPer100g = nutritionPer100g,
        _germination = germination,
        _growth = growth,
        _watering = watering,
        _thinning = thinning,
        _weeding = weeding,
        _culturalTips = culturalTips,
        _biologicalControl = biologicalControl,
        _companionPlanting = companionPlanting,
        _notificationSettings = notificationSettings,
        _varieties = varieties,
        _metadata = metadata;

  factory _$PlantFreezedImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantFreezedImplFromJson(json);

  /// Identifiant unique de la plante
  @override
  final String id;

  /// Nom commun de la plante
  @override
  final String commonName;

  /// Nom scientifique de la plante
  @override
  final String scientificName;

  /// Famille botanique
  @override
  final String family;

  /// Saison de plantation
  @override
  final String plantingSeason;

  /// Saison de récolte
  @override
  final String harvestSeason;

  /// Nombre de jours jusqu'à maturité
  @override
  final int daysToMaturity;

  /// Espacement entre plants (en cm)
  @override
  final int spacing;

  /// Profondeur de plantation (en cm)
  @override
  final double depth;

  /// Exposition au soleil requise
  @override
  final String sunExposure;

  /// Besoins en eau
  @override
  final String waterNeeds;

  /// Description de la plante
  @override
  final String description;

  /// Mois de semis (codes courts: F, M, A, etc.)
  final List<String> _sowingMonths;

  /// Mois de semis (codes courts: F, M, A, etc.)
  @override
  List<String> get sowingMonths {
    if (_sowingMonths is EqualUnmodifiableListView) return _sowingMonths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sowingMonths);
  }

  /// Mois de récolte (codes courts: F, M, A, etc.)
  final List<String> _harvestMonths;

  /// Mois de récolte (codes courts: F, M, A, etc.)
  @override
  List<String> get harvestMonths {
    if (_harvestMonths is EqualUnmodifiableListView) return _harvestMonths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_harvestMonths);
  }

  /// Prix du marché par kg
  @override
  final double? marketPricePerKg;

  /// Unité par défaut (kg, pièce, etc.)
  @override
  final String? defaultUnit;

  /// Informations nutritionnelles pour 100g
  final Map<String, dynamic>? _nutritionPer100g;

  /// Informations nutritionnelles pour 100g
  @override
  Map<String, dynamic>? get nutritionPer100g {
    final value = _nutritionPer100g;
    if (value == null) return null;
    if (_nutritionPer100g is EqualUnmodifiableMapView) return _nutritionPer100g;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Informations sur la germination
  final Map<String, dynamic>? _germination;

  /// Informations sur la germination
  @override
  Map<String, dynamic>? get germination {
    final value = _germination;
    if (value == null) return null;
    if (_germination is EqualUnmodifiableMapView) return _germination;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Informations sur la croissance
  final Map<String, dynamic>? _growth;

  /// Informations sur la croissance
  @override
  Map<String, dynamic>? get growth {
    final value = _growth;
    if (value == null) return null;
    if (_growth is EqualUnmodifiableMapView) return _growth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Informations sur l'arrosage
  final Map<String, dynamic>? _watering;

  /// Informations sur l'arrosage
  @override
  Map<String, dynamic>? get watering {
    final value = _watering;
    if (value == null) return null;
    if (_watering is EqualUnmodifiableMapView) return _watering;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Informations sur l'éclaircissement
  final Map<String, dynamic>? _thinning;

  /// Informations sur l'éclaircissement
  @override
  Map<String, dynamic>? get thinning {
    final value = _thinning;
    if (value == null) return null;
    if (_thinning is EqualUnmodifiableMapView) return _thinning;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Informations sur le désherbage
  final Map<String, dynamic>? _weeding;

  /// Informations sur le désherbage
  @override
  Map<String, dynamic>? get weeding {
    final value = _weeding;
    if (value == null) return null;
    if (_weeding is EqualUnmodifiableMapView) return _weeding;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Conseils culturaux
  final List<String>? _culturalTips;

  /// Conseils culturaux
  @override
  List<String>? get culturalTips {
    final value = _culturalTips;
    if (value == null) return null;
    if (_culturalTips is EqualUnmodifiableListView) return _culturalTips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Contrôle biologique
  final Map<String, dynamic>? _biologicalControl;

  /// Contrôle biologique
  @override
  Map<String, dynamic>? get biologicalControl {
    final value = _biologicalControl;
    if (value == null) return null;
    if (_biologicalControl is EqualUnmodifiableMapView)
      return _biologicalControl;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Temps de récolte
  @override
  final String? harvestTime;

  /// Associations de plantes
  final Map<String, dynamic>? _companionPlanting;

  /// Associations de plantes
  @override
  Map<String, dynamic>? get companionPlanting {
    final value = _companionPlanting;
    if (value == null) return null;
    if (_companionPlanting is EqualUnmodifiableMapView)
      return _companionPlanting;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Paramètres de notification
  final Map<String, dynamic>? _notificationSettings;

  /// Paramètres de notification
  @override
  Map<String, dynamic>? get notificationSettings {
    final value = _notificationSettings;
    if (value == null) return null;
    if (_notificationSettings is EqualUnmodifiableMapView)
      return _notificationSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Variétés recommandées
  final Map<String, dynamic>? _varieties;

  /// Variétés recommandées
  @override
  Map<String, dynamic>? get varieties {
    final value = _varieties;
    if (value == null) return null;
    if (_varieties is EqualUnmodifiableMapView) return _varieties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Métadonnées additionnelles flexibles
  final Map<String, dynamic> _metadata;

  /// Métadonnées additionnelles flexibles
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  /// Date de création
  @override
  final DateTime? createdAt;

  /// Date de dernière mise à jour
  @override
  final DateTime? updatedAt;

  /// Indique si la plante est active
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'PlantFreezed(id: $id, commonName: $commonName, scientificName: $scientificName, family: $family, plantingSeason: $plantingSeason, harvestSeason: $harvestSeason, daysToMaturity: $daysToMaturity, spacing: $spacing, depth: $depth, sunExposure: $sunExposure, waterNeeds: $waterNeeds, description: $description, sowingMonths: $sowingMonths, harvestMonths: $harvestMonths, marketPricePerKg: $marketPricePerKg, defaultUnit: $defaultUnit, nutritionPer100g: $nutritionPer100g, germination: $germination, growth: $growth, watering: $watering, thinning: $thinning, weeding: $weeding, culturalTips: $culturalTips, biologicalControl: $biologicalControl, harvestTime: $harvestTime, companionPlanting: $companionPlanting, notificationSettings: $notificationSettings, varieties: $varieties, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantFreezedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.commonName, commonName) ||
                other.commonName == commonName) &&
            (identical(other.scientificName, scientificName) ||
                other.scientificName == scientificName) &&
            (identical(other.family, family) || other.family == family) &&
            (identical(other.plantingSeason, plantingSeason) ||
                other.plantingSeason == plantingSeason) &&
            (identical(other.harvestSeason, harvestSeason) ||
                other.harvestSeason == harvestSeason) &&
            (identical(other.daysToMaturity, daysToMaturity) ||
                other.daysToMaturity == daysToMaturity) &&
            (identical(other.spacing, spacing) || other.spacing == spacing) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.sunExposure, sunExposure) ||
                other.sunExposure == sunExposure) &&
            (identical(other.waterNeeds, waterNeeds) ||
                other.waterNeeds == waterNeeds) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._sowingMonths, _sowingMonths) &&
            const DeepCollectionEquality()
                .equals(other._harvestMonths, _harvestMonths) &&
            (identical(other.marketPricePerKg, marketPricePerKg) ||
                other.marketPricePerKg == marketPricePerKg) &&
            (identical(other.defaultUnit, defaultUnit) ||
                other.defaultUnit == defaultUnit) &&
            const DeepCollectionEquality()
                .equals(other._nutritionPer100g, _nutritionPer100g) &&
            const DeepCollectionEquality()
                .equals(other._germination, _germination) &&
            const DeepCollectionEquality().equals(other._growth, _growth) &&
            const DeepCollectionEquality().equals(other._watering, _watering) &&
            const DeepCollectionEquality().equals(other._thinning, _thinning) &&
            const DeepCollectionEquality().equals(other._weeding, _weeding) &&
            const DeepCollectionEquality()
                .equals(other._culturalTips, _culturalTips) &&
            const DeepCollectionEquality()
                .equals(other._biologicalControl, _biologicalControl) &&
            (identical(other.harvestTime, harvestTime) ||
                other.harvestTime == harvestTime) &&
            const DeepCollectionEquality()
                .equals(other._companionPlanting, _companionPlanting) &&
            const DeepCollectionEquality()
                .equals(other._notificationSettings, _notificationSettings) &&
            const DeepCollectionEquality()
                .equals(other._varieties, _varieties) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        commonName,
        scientificName,
        family,
        plantingSeason,
        harvestSeason,
        daysToMaturity,
        spacing,
        depth,
        sunExposure,
        waterNeeds,
        description,
        const DeepCollectionEquality().hash(_sowingMonths),
        const DeepCollectionEquality().hash(_harvestMonths),
        marketPricePerKg,
        defaultUnit,
        const DeepCollectionEquality().hash(_nutritionPer100g),
        const DeepCollectionEquality().hash(_germination),
        const DeepCollectionEquality().hash(_growth),
        const DeepCollectionEquality().hash(_watering),
        const DeepCollectionEquality().hash(_thinning),
        const DeepCollectionEquality().hash(_weeding),
        const DeepCollectionEquality().hash(_culturalTips),
        const DeepCollectionEquality().hash(_biologicalControl),
        harvestTime,
        const DeepCollectionEquality().hash(_companionPlanting),
        const DeepCollectionEquality().hash(_notificationSettings),
        const DeepCollectionEquality().hash(_varieties),
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt,
        isActive
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantFreezedImplCopyWith<_$PlantFreezedImpl> get copyWith =>
      __$$PlantFreezedImplCopyWithImpl<_$PlantFreezedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantFreezedImplToJson(
      this,
    );
  }
}

abstract class _PlantFreezed implements PlantFreezed {
  const factory _PlantFreezed(
      {required final String id,
      required final String commonName,
      required final String scientificName,
      required final String family,
      required final String plantingSeason,
      required final String harvestSeason,
      required final int daysToMaturity,
      required final int spacing,
      required final double depth,
      required final String sunExposure,
      required final String waterNeeds,
      required final String description,
      required final List<String> sowingMonths,
      required final List<String> harvestMonths,
      final double? marketPricePerKg,
      final String? defaultUnit,
      final Map<String, dynamic>? nutritionPer100g,
      final Map<String, dynamic>? germination,
      final Map<String, dynamic>? growth,
      final Map<String, dynamic>? watering,
      final Map<String, dynamic>? thinning,
      final Map<String, dynamic>? weeding,
      final List<String>? culturalTips,
      final Map<String, dynamic>? biologicalControl,
      final String? harvestTime,
      final Map<String, dynamic>? companionPlanting,
      final Map<String, dynamic>? notificationSettings,
      final Map<String, dynamic>? varieties,
      final Map<String, dynamic> metadata,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final bool isActive}) = _$PlantFreezedImpl;

  factory _PlantFreezed.fromJson(Map<String, dynamic> json) =
      _$PlantFreezedImpl.fromJson;

  @override

  /// Identifiant unique de la plante
  String get id;
  @override

  /// Nom commun de la plante
  String get commonName;
  @override

  /// Nom scientifique de la plante
  String get scientificName;
  @override

  /// Famille botanique
  String get family;
  @override

  /// Saison de plantation
  String get plantingSeason;
  @override

  /// Saison de récolte
  String get harvestSeason;
  @override

  /// Nombre de jours jusqu'à maturité
  int get daysToMaturity;
  @override

  /// Espacement entre plants (en cm)
  int get spacing;
  @override

  /// Profondeur de plantation (en cm)
  double get depth;
  @override

  /// Exposition au soleil requise
  String get sunExposure;
  @override

  /// Besoins en eau
  String get waterNeeds;
  @override

  /// Description de la plante
  String get description;
  @override

  /// Mois de semis (codes courts: F, M, A, etc.)
  List<String> get sowingMonths;
  @override

  /// Mois de récolte (codes courts: F, M, A, etc.)
  List<String> get harvestMonths;
  @override

  /// Prix du marché par kg
  double? get marketPricePerKg;
  @override

  /// Unité par défaut (kg, pièce, etc.)
  String? get defaultUnit;
  @override

  /// Informations nutritionnelles pour 100g
  Map<String, dynamic>? get nutritionPer100g;
  @override

  /// Informations sur la germination
  Map<String, dynamic>? get germination;
  @override

  /// Informations sur la croissance
  Map<String, dynamic>? get growth;
  @override

  /// Informations sur l'arrosage
  Map<String, dynamic>? get watering;
  @override

  /// Informations sur l'éclaircissement
  Map<String, dynamic>? get thinning;
  @override

  /// Informations sur le désherbage
  Map<String, dynamic>? get weeding;
  @override

  /// Conseils culturaux
  List<String>? get culturalTips;
  @override

  /// Contrôle biologique
  Map<String, dynamic>? get biologicalControl;
  @override

  /// Temps de récolte
  String? get harvestTime;
  @override

  /// Associations de plantes
  Map<String, dynamic>? get companionPlanting;
  @override

  /// Paramètres de notification
  Map<String, dynamic>? get notificationSettings;
  @override

  /// Variétés recommandées
  Map<String, dynamic>? get varieties;
  @override

  /// Métadonnées additionnelles flexibles
  Map<String, dynamic> get metadata;
  @override

  /// Date de création
  DateTime? get createdAt;
  @override

  /// Date de dernière mise à jour
  DateTime? get updatedAt;
  @override

  /// Indique si la plante est active
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$PlantFreezedImplCopyWith<_$PlantFreezedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

