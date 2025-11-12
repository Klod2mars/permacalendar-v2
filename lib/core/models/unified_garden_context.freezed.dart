// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unified_garden_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UnifiedGardenContext _$UnifiedGardenContextFromJson(Map<String, dynamic> json) {
  return _UnifiedGardenContext.fromJson(json);
}

/// @nodoc
mixin _$UnifiedGardenContext {
  String get gardenId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  double? get totalArea => throw _privateConstructorUsedError;
  List<UnifiedPlantData> get activePlants => throw _privateConstructorUsedError;
  List<UnifiedPlantData> get historicalPlants =>
      throw _privateConstructorUsedError;
  UnifiedGardenStats get stats => throw _privateConstructorUsedError;
  UnifiedSoilInfo get soil => throw _privateConstructorUsedError;
  UnifiedClimate get climate => throw _privateConstructorUsedError;
  UnifiedCultivationPreferences get preferences =>
      throw _privateConstructorUsedError;
  List<UnifiedActivityHistory> get recentActivities =>
      throw _privateConstructorUsedError;
  DataSource get primarySource =>
      throw _privateConstructorUsedError; // Source de données utilisée (Legacy/Moderne/Intelligence)
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnifiedGardenContextCopyWith<UnifiedGardenContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnifiedGardenContextCopyWith<$Res> {
  factory $UnifiedGardenContextCopyWith(UnifiedGardenContext value,
          $Res Function(UnifiedGardenContext) then) =
      _$UnifiedGardenContextCopyWithImpl<$Res, UnifiedGardenContext>;
  @useResult
  $Res call(
      {String gardenId,
      String name,
      String? description,
      String? location,
      double? totalArea,
      List<UnifiedPlantData> activePlants,
      List<UnifiedPlantData> historicalPlants,
      UnifiedGardenStats stats,
      UnifiedSoilInfo soil,
      UnifiedClimate climate,
      UnifiedCultivationPreferences preferences,
      List<UnifiedActivityHistory> recentActivities,
      DataSource primarySource,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, dynamic>? metadata});

  $UnifiedGardenStatsCopyWith<$Res> get stats;
  $UnifiedSoilInfoCopyWith<$Res> get soil;
  $UnifiedClimateCopyWith<$Res> get climate;
  $UnifiedCultivationPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class _$UnifiedGardenContextCopyWithImpl<$Res,
        $Val extends UnifiedGardenContext>
    implements $UnifiedGardenContextCopyWith<$Res> {
  _$UnifiedGardenContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? name = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? totalArea = freezed,
    Object? activePlants = null,
    Object? historicalPlants = null,
    Object? stats = null,
    Object? soil = null,
    Object? climate = null,
    Object? preferences = null,
    Object? recentActivities = null,
    Object? primarySource = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      totalArea: freezed == totalArea
          ? _value.totalArea
          : totalArea // ignore: cast_nullable_to_non_nullable
              as double?,
      activePlants: null == activePlants
          ? _value.activePlants
          : activePlants // ignore: cast_nullable_to_non_nullable
              as List<UnifiedPlantData>,
      historicalPlants: null == historicalPlants
          ? _value.historicalPlants
          : historicalPlants // ignore: cast_nullable_to_non_nullable
              as List<UnifiedPlantData>,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as UnifiedGardenStats,
      soil: null == soil
          ? _value.soil
          : soil // ignore: cast_nullable_to_non_nullable
              as UnifiedSoilInfo,
      climate: null == climate
          ? _value.climate
          : climate // ignore: cast_nullable_to_non_nullable
              as UnifiedClimate,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as UnifiedCultivationPreferences,
      recentActivities: null == recentActivities
          ? _value.recentActivities
          : recentActivities // ignore: cast_nullable_to_non_nullable
              as List<UnifiedActivityHistory>,
      primarySource: null == primarySource
          ? _value.primarySource
          : primarySource // ignore: cast_nullable_to_non_nullable
              as DataSource,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UnifiedGardenStatsCopyWith<$Res> get stats {
    return $UnifiedGardenStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UnifiedSoilInfoCopyWith<$Res> get soil {
    return $UnifiedSoilInfoCopyWith<$Res>(_value.soil, (value) {
      return _then(_value.copyWith(soil: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UnifiedClimateCopyWith<$Res> get climate {
    return $UnifiedClimateCopyWith<$Res>(_value.climate, (value) {
      return _then(_value.copyWith(climate: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UnifiedCultivationPreferencesCopyWith<$Res> get preferences {
    return $UnifiedCultivationPreferencesCopyWith<$Res>(_value.preferences,
        (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UnifiedGardenContextImplCopyWith<$Res>
    implements $UnifiedGardenContextCopyWith<$Res> {
  factory _$$UnifiedGardenContextImplCopyWith(_$UnifiedGardenContextImpl value,
          $Res Function(_$UnifiedGardenContextImpl) then) =
      __$$UnifiedGardenContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gardenId,
      String name,
      String? description,
      String? location,
      double? totalArea,
      List<UnifiedPlantData> activePlants,
      List<UnifiedPlantData> historicalPlants,
      UnifiedGardenStats stats,
      UnifiedSoilInfo soil,
      UnifiedClimate climate,
      UnifiedCultivationPreferences preferences,
      List<UnifiedActivityHistory> recentActivities,
      DataSource primarySource,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, dynamic>? metadata});

  @override
  $UnifiedGardenStatsCopyWith<$Res> get stats;
  @override
  $UnifiedSoilInfoCopyWith<$Res> get soil;
  @override
  $UnifiedClimateCopyWith<$Res> get climate;
  @override
  $UnifiedCultivationPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class __$$UnifiedGardenContextImplCopyWithImpl<$Res>
    extends _$UnifiedGardenContextCopyWithImpl<$Res, _$UnifiedGardenContextImpl>
    implements _$$UnifiedGardenContextImplCopyWith<$Res> {
  __$$UnifiedGardenContextImplCopyWithImpl(_$UnifiedGardenContextImpl _value,
      $Res Function(_$UnifiedGardenContextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? name = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? totalArea = freezed,
    Object? activePlants = null,
    Object? historicalPlants = null,
    Object? stats = null,
    Object? soil = null,
    Object? climate = null,
    Object? preferences = null,
    Object? recentActivities = null,
    Object? primarySource = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? metadata = freezed,
  }) {
    return _then(_$UnifiedGardenContextImpl(
      gardenId: null == gardenId
          ? _value.gardenId
          : gardenId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      totalArea: freezed == totalArea
          ? _value.totalArea
          : totalArea // ignore: cast_nullable_to_non_nullable
              as double?,
      activePlants: null == activePlants
          ? _value._activePlants
          : activePlants // ignore: cast_nullable_to_non_nullable
              as List<UnifiedPlantData>,
      historicalPlants: null == historicalPlants
          ? _value._historicalPlants
          : historicalPlants // ignore: cast_nullable_to_non_nullable
              as List<UnifiedPlantData>,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as UnifiedGardenStats,
      soil: null == soil
          ? _value.soil
          : soil // ignore: cast_nullable_to_non_nullable
              as UnifiedSoilInfo,
      climate: null == climate
          ? _value.climate
          : climate // ignore: cast_nullable_to_non_nullable
              as UnifiedClimate,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as UnifiedCultivationPreferences,
      recentActivities: null == recentActivities
          ? _value._recentActivities
          : recentActivities // ignore: cast_nullable_to_non_nullable
              as List<UnifiedActivityHistory>,
      primarySource: null == primarySource
          ? _value.primarySource
          : primarySource // ignore: cast_nullable_to_non_nullable
              as DataSource,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnifiedGardenContextImpl implements _UnifiedGardenContext {
  const _$UnifiedGardenContextImpl(
      {required this.gardenId,
      required this.name,
      this.description,
      this.location,
      this.totalArea,
      required final List<UnifiedPlantData> activePlants,
      required final List<UnifiedPlantData> historicalPlants,
      required this.stats,
      required this.soil,
      required this.climate,
      required this.preferences,
      required final List<UnifiedActivityHistory> recentActivities,
      required this.primarySource,
      required this.createdAt,
      required this.updatedAt,
      final Map<String, dynamic>? metadata})
      : _activePlants = activePlants,
        _historicalPlants = historicalPlants,
        _recentActivities = recentActivities,
        _metadata = metadata;

  factory _$UnifiedGardenContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnifiedGardenContextImplFromJson(json);

  @override
  final String gardenId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? location;
  @override
  final double? totalArea;
  final List<UnifiedPlantData> _activePlants;
  @override
  List<UnifiedPlantData> get activePlants {
    if (_activePlants is EqualUnmodifiableListView) return _activePlants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activePlants);
  }

  final List<UnifiedPlantData> _historicalPlants;
  @override
  List<UnifiedPlantData> get historicalPlants {
    if (_historicalPlants is EqualUnmodifiableListView)
      return _historicalPlants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_historicalPlants);
  }

  @override
  final UnifiedGardenStats stats;
  @override
  final UnifiedSoilInfo soil;
  @override
  final UnifiedClimate climate;
  @override
  final UnifiedCultivationPreferences preferences;
  final List<UnifiedActivityHistory> _recentActivities;
  @override
  List<UnifiedActivityHistory> get recentActivities {
    if (_recentActivities is EqualUnmodifiableListView)
      return _recentActivities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivities);
  }

  @override
  final DataSource primarySource;
// Source de données utilisée (Legacy/Moderne/Intelligence)
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
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
    return 'UnifiedGardenContext(gardenId: $gardenId, name: $name, description: $description, location: $location, totalArea: $totalArea, activePlants: $activePlants, historicalPlants: $historicalPlants, stats: $stats, soil: $soil, climate: $climate, preferences: $preferences, recentActivities: $recentActivities, primarySource: $primarySource, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnifiedGardenContextImpl &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.totalArea, totalArea) ||
                other.totalArea == totalArea) &&
            const DeepCollectionEquality()
                .equals(other._activePlants, _activePlants) &&
            const DeepCollectionEquality()
                .equals(other._historicalPlants, _historicalPlants) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.soil, soil) || other.soil == soil) &&
            (identical(other.climate, climate) || other.climate == climate) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences) &&
            const DeepCollectionEquality()
                .equals(other._recentActivities, _recentActivities) &&
            (identical(other.primarySource, primarySource) ||
                other.primarySource == primarySource) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      gardenId,
      name,
      description,
      location,
      totalArea,
      const DeepCollectionEquality().hash(_activePlants),
      const DeepCollectionEquality().hash(_historicalPlants),
      stats,
      soil,
      climate,
      preferences,
      const DeepCollectionEquality().hash(_recentActivities),
      primarySource,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnifiedGardenContextImplCopyWith<_$UnifiedGardenContextImpl>
      get copyWith =>
          __$$UnifiedGardenContextImplCopyWithImpl<_$UnifiedGardenContextImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnifiedGardenContextImplToJson(
      this,
    );
  }
}

abstract class _UnifiedGardenContext implements UnifiedGardenContext {
  const factory _UnifiedGardenContext(
      {required final String gardenId,
      required final String name,
      final String? description,
      final String? location,
      final double? totalArea,
      required final List<UnifiedPlantData> activePlants,
      required final List<UnifiedPlantData> historicalPlants,
      required final UnifiedGardenStats stats,
      required final UnifiedSoilInfo soil,
      required final UnifiedClimate climate,
      required final UnifiedCultivationPreferences preferences,
      required final List<UnifiedActivityHistory> recentActivities,
      required final DataSource primarySource,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final Map<String, dynamic>? metadata}) = _$UnifiedGardenContextImpl;

  factory _UnifiedGardenContext.fromJson(Map<String, dynamic> json) =
      _$UnifiedGardenContextImpl.fromJson;

  @override
  String get gardenId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get location;
  @override
  double? get totalArea;
  @override
  List<UnifiedPlantData> get activePlants;
  @override
  List<UnifiedPlantData> get historicalPlants;
  @override
  UnifiedGardenStats get stats;
  @override
  UnifiedSoilInfo get soil;
  @override
  UnifiedClimate get climate;
  @override
  UnifiedCultivationPreferences get preferences;
  @override
  List<UnifiedActivityHistory> get recentActivities;
  @override
  DataSource get primarySource;
  @override // Source de données utilisée (Legacy/Moderne/Intelligence)
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$UnifiedGardenContextImplCopyWith<_$UnifiedGardenContextImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UnifiedPlantData _$UnifiedPlantDataFromJson(Map<String, dynamic> json) {
  return _UnifiedPlantData.fromJson(json);
}

/// @nodoc
mixin _$UnifiedPlantData {
  String get plantId => throw _privateConstructorUsedError;
  String get commonName => throw _privateConstructorUsedError;
  String get scientificName => throw _privateConstructorUsedError;
  String? get family => throw _privateConstructorUsedError;
  String? get variety => throw _privateConstructorUsedError;
  List<String> get plantingSeason => throw _privateConstructorUsedError;
  List<String> get harvestSeason => throw _privateConstructorUsedError;
  String? get growthCycle => throw _privateConstructorUsedError;
  String? get sunExposure => throw _privateConstructorUsedError;
  String? get waterNeeds => throw _privateConstructorUsedError;
  String? get soilType => throw _privateConstructorUsedError;
  double? get spacingInCm => throw _privateConstructorUsedError;
  double? get depthInCm => throw _privateConstructorUsedError;
  String? get companionPlants => throw _privateConstructorUsedError;
  String? get incompatiblePlants => throw _privateConstructorUsedError;
  String? get diseases => throw _privateConstructorUsedError;
  String? get pests => throw _privateConstructorUsedError;
  String? get benefits => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DataSource get source =>
      throw _privateConstructorUsedError; // Source de la plante (Legacy/Moderne/Catalog)
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnifiedPlantDataCopyWith<UnifiedPlantData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnifiedPlantDataCopyWith<$Res> {
  factory $UnifiedPlantDataCopyWith(
          UnifiedPlantData value, $Res Function(UnifiedPlantData) then) =
      _$UnifiedPlantDataCopyWithImpl<$Res, UnifiedPlantData>;
  @useResult
  $Res call(
      {String plantId,
      String commonName,
      String scientificName,
      String? family,
      String? variety,
      List<String> plantingSeason,
      List<String> harvestSeason,
      String? growthCycle,
      String? sunExposure,
      String? waterNeeds,
      String? soilType,
      double? spacingInCm,
      double? depthInCm,
      String? companionPlants,
      String? incompatiblePlants,
      String? diseases,
      String? pests,
      String? benefits,
      String? notes,
      String? imageUrl,
      DataSource source,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$UnifiedPlantDataCopyWithImpl<$Res, $Val extends UnifiedPlantData>
    implements $UnifiedPlantDataCopyWith<$Res> {
  _$UnifiedPlantDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? commonName = null,
    Object? scientificName = null,
    Object? family = freezed,
    Object? variety = freezed,
    Object? plantingSeason = null,
    Object? harvestSeason = null,
    Object? growthCycle = freezed,
    Object? sunExposure = freezed,
    Object? waterNeeds = freezed,
    Object? soilType = freezed,
    Object? spacingInCm = freezed,
    Object? depthInCm = freezed,
    Object? companionPlants = freezed,
    Object? incompatiblePlants = freezed,
    Object? diseases = freezed,
    Object? pests = freezed,
    Object? benefits = freezed,
    Object? notes = freezed,
    Object? imageUrl = freezed,
    Object? source = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      commonName: null == commonName
          ? _value.commonName
          : commonName // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: null == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String,
      family: freezed == family
          ? _value.family
          : family // ignore: cast_nullable_to_non_nullable
              as String?,
      variety: freezed == variety
          ? _value.variety
          : variety // ignore: cast_nullable_to_non_nullable
              as String?,
      plantingSeason: null == plantingSeason
          ? _value.plantingSeason
          : plantingSeason // ignore: cast_nullable_to_non_nullable
              as List<String>,
      harvestSeason: null == harvestSeason
          ? _value.harvestSeason
          : harvestSeason // ignore: cast_nullable_to_non_nullable
              as List<String>,
      growthCycle: freezed == growthCycle
          ? _value.growthCycle
          : growthCycle // ignore: cast_nullable_to_non_nullable
              as String?,
      sunExposure: freezed == sunExposure
          ? _value.sunExposure
          : sunExposure // ignore: cast_nullable_to_non_nullable
              as String?,
      waterNeeds: freezed == waterNeeds
          ? _value.waterNeeds
          : waterNeeds // ignore: cast_nullable_to_non_nullable
              as String?,
      soilType: freezed == soilType
          ? _value.soilType
          : soilType // ignore: cast_nullable_to_non_nullable
              as String?,
      spacingInCm: freezed == spacingInCm
          ? _value.spacingInCm
          : spacingInCm // ignore: cast_nullable_to_non_nullable
              as double?,
      depthInCm: freezed == depthInCm
          ? _value.depthInCm
          : depthInCm // ignore: cast_nullable_to_non_nullable
              as double?,
      companionPlants: freezed == companionPlants
          ? _value.companionPlants
          : companionPlants // ignore: cast_nullable_to_non_nullable
              as String?,
      incompatiblePlants: freezed == incompatiblePlants
          ? _value.incompatiblePlants
          : incompatiblePlants // ignore: cast_nullable_to_non_nullable
              as String?,
      diseases: freezed == diseases
          ? _value.diseases
          : diseases // ignore: cast_nullable_to_non_nullable
              as String?,
      pests: freezed == pests
          ? _value.pests
          : pests // ignore: cast_nullable_to_non_nullable
              as String?,
      benefits: freezed == benefits
          ? _value.benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as DataSource,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnifiedPlantDataImplCopyWith<$Res>
    implements $UnifiedPlantDataCopyWith<$Res> {
  factory _$$UnifiedPlantDataImplCopyWith(_$UnifiedPlantDataImpl value,
          $Res Function(_$UnifiedPlantDataImpl) then) =
      __$$UnifiedPlantDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String plantId,
      String commonName,
      String scientificName,
      String? family,
      String? variety,
      List<String> plantingSeason,
      List<String> harvestSeason,
      String? growthCycle,
      String? sunExposure,
      String? waterNeeds,
      String? soilType,
      double? spacingInCm,
      double? depthInCm,
      String? companionPlants,
      String? incompatiblePlants,
      String? diseases,
      String? pests,
      String? benefits,
      String? notes,
      String? imageUrl,
      DataSource source,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UnifiedPlantDataImplCopyWithImpl<$Res>
    extends _$UnifiedPlantDataCopyWithImpl<$Res, _$UnifiedPlantDataImpl>
    implements _$$UnifiedPlantDataImplCopyWith<$Res> {
  __$$UnifiedPlantDataImplCopyWithImpl(_$UnifiedPlantDataImpl _value,
      $Res Function(_$UnifiedPlantDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plantId = null,
    Object? commonName = null,
    Object? scientificName = null,
    Object? family = freezed,
    Object? variety = freezed,
    Object? plantingSeason = null,
    Object? harvestSeason = null,
    Object? growthCycle = freezed,
    Object? sunExposure = freezed,
    Object? waterNeeds = freezed,
    Object? soilType = freezed,
    Object? spacingInCm = freezed,
    Object? depthInCm = freezed,
    Object? companionPlants = freezed,
    Object? incompatiblePlants = freezed,
    Object? diseases = freezed,
    Object? pests = freezed,
    Object? benefits = freezed,
    Object? notes = freezed,
    Object? imageUrl = freezed,
    Object? source = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UnifiedPlantDataImpl(
      plantId: null == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String,
      commonName: null == commonName
          ? _value.commonName
          : commonName // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: null == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String,
      family: freezed == family
          ? _value.family
          : family // ignore: cast_nullable_to_non_nullable
              as String?,
      variety: freezed == variety
          ? _value.variety
          : variety // ignore: cast_nullable_to_non_nullable
              as String?,
      plantingSeason: null == plantingSeason
          ? _value._plantingSeason
          : plantingSeason // ignore: cast_nullable_to_non_nullable
              as List<String>,
      harvestSeason: null == harvestSeason
          ? _value._harvestSeason
          : harvestSeason // ignore: cast_nullable_to_non_nullable
              as List<String>,
      growthCycle: freezed == growthCycle
          ? _value.growthCycle
          : growthCycle // ignore: cast_nullable_to_non_nullable
              as String?,
      sunExposure: freezed == sunExposure
          ? _value.sunExposure
          : sunExposure // ignore: cast_nullable_to_non_nullable
              as String?,
      waterNeeds: freezed == waterNeeds
          ? _value.waterNeeds
          : waterNeeds // ignore: cast_nullable_to_non_nullable
              as String?,
      soilType: freezed == soilType
          ? _value.soilType
          : soilType // ignore: cast_nullable_to_non_nullable
              as String?,
      spacingInCm: freezed == spacingInCm
          ? _value.spacingInCm
          : spacingInCm // ignore: cast_nullable_to_non_nullable
              as double?,
      depthInCm: freezed == depthInCm
          ? _value.depthInCm
          : depthInCm // ignore: cast_nullable_to_non_nullable
              as double?,
      companionPlants: freezed == companionPlants
          ? _value.companionPlants
          : companionPlants // ignore: cast_nullable_to_non_nullable
              as String?,
      incompatiblePlants: freezed == incompatiblePlants
          ? _value.incompatiblePlants
          : incompatiblePlants // ignore: cast_nullable_to_non_nullable
              as String?,
      diseases: freezed == diseases
          ? _value.diseases
          : diseases // ignore: cast_nullable_to_non_nullable
              as String?,
      pests: freezed == pests
          ? _value.pests
          : pests // ignore: cast_nullable_to_non_nullable
              as String?,
      benefits: freezed == benefits
          ? _value.benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as DataSource,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnifiedPlantDataImpl implements _UnifiedPlantData {
  const _$UnifiedPlantDataImpl(
      {required this.plantId,
      required this.commonName,
      required this.scientificName,
      this.family,
      this.variety,
      required final List<String> plantingSeason,
      required final List<String> harvestSeason,
      this.growthCycle,
      this.sunExposure,
      this.waterNeeds,
      this.soilType,
      this.spacingInCm,
      this.depthInCm,
      this.companionPlants,
      this.incompatiblePlants,
      this.diseases,
      this.pests,
      this.benefits,
      this.notes,
      this.imageUrl,
      required this.source,
      required this.createdAt,
      this.updatedAt})
      : _plantingSeason = plantingSeason,
        _harvestSeason = harvestSeason;

  factory _$UnifiedPlantDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnifiedPlantDataImplFromJson(json);

  @override
  final String plantId;
  @override
  final String commonName;
  @override
  final String scientificName;
  @override
  final String? family;
  @override
  final String? variety;
  final List<String> _plantingSeason;
  @override
  List<String> get plantingSeason {
    if (_plantingSeason is EqualUnmodifiableListView) return _plantingSeason;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plantingSeason);
  }

  final List<String> _harvestSeason;
  @override
  List<String> get harvestSeason {
    if (_harvestSeason is EqualUnmodifiableListView) return _harvestSeason;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_harvestSeason);
  }

  @override
  final String? growthCycle;
  @override
  final String? sunExposure;
  @override
  final String? waterNeeds;
  @override
  final String? soilType;
  @override
  final double? spacingInCm;
  @override
  final double? depthInCm;
  @override
  final String? companionPlants;
  @override
  final String? incompatiblePlants;
  @override
  final String? diseases;
  @override
  final String? pests;
  @override
  final String? benefits;
  @override
  final String? notes;
  @override
  final String? imageUrl;
  @override
  final DataSource source;
// Source de la plante (Legacy/Moderne/Catalog)
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UnifiedPlantData(plantId: $plantId, commonName: $commonName, scientificName: $scientificName, family: $family, variety: $variety, plantingSeason: $plantingSeason, harvestSeason: $harvestSeason, growthCycle: $growthCycle, sunExposure: $sunExposure, waterNeeds: $waterNeeds, soilType: $soilType, spacingInCm: $spacingInCm, depthInCm: $depthInCm, companionPlants: $companionPlants, incompatiblePlants: $incompatiblePlants, diseases: $diseases, pests: $pests, benefits: $benefits, notes: $notes, imageUrl: $imageUrl, source: $source, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnifiedPlantDataImpl &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.commonName, commonName) ||
                other.commonName == commonName) &&
            (identical(other.scientificName, scientificName) ||
                other.scientificName == scientificName) &&
            (identical(other.family, family) || other.family == family) &&
            (identical(other.variety, variety) || other.variety == variety) &&
            const DeepCollectionEquality()
                .equals(other._plantingSeason, _plantingSeason) &&
            const DeepCollectionEquality()
                .equals(other._harvestSeason, _harvestSeason) &&
            (identical(other.growthCycle, growthCycle) ||
                other.growthCycle == growthCycle) &&
            (identical(other.sunExposure, sunExposure) ||
                other.sunExposure == sunExposure) &&
            (identical(other.waterNeeds, waterNeeds) ||
                other.waterNeeds == waterNeeds) &&
            (identical(other.soilType, soilType) ||
                other.soilType == soilType) &&
            (identical(other.spacingInCm, spacingInCm) ||
                other.spacingInCm == spacingInCm) &&
            (identical(other.depthInCm, depthInCm) ||
                other.depthInCm == depthInCm) &&
            (identical(other.companionPlants, companionPlants) ||
                other.companionPlants == companionPlants) &&
            (identical(other.incompatiblePlants, incompatiblePlants) ||
                other.incompatiblePlants == incompatiblePlants) &&
            (identical(other.diseases, diseases) ||
                other.diseases == diseases) &&
            (identical(other.pests, pests) || other.pests == pests) &&
            (identical(other.benefits, benefits) ||
                other.benefits == benefits) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        plantId,
        commonName,
        scientificName,
        family,
        variety,
        const DeepCollectionEquality().hash(_plantingSeason),
        const DeepCollectionEquality().hash(_harvestSeason),
        growthCycle,
        sunExposure,
        waterNeeds,
        soilType,
        spacingInCm,
        depthInCm,
        companionPlants,
        incompatiblePlants,
        diseases,
        pests,
        benefits,
        notes,
        imageUrl,
        source,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnifiedPlantDataImplCopyWith<_$UnifiedPlantDataImpl> get copyWith =>
      __$$UnifiedPlantDataImplCopyWithImpl<_$UnifiedPlantDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnifiedPlantDataImplToJson(
      this,
    );
  }
}

abstract class _UnifiedPlantData implements UnifiedPlantData {
  const factory _UnifiedPlantData(
      {required final String plantId,
      required final String commonName,
      required final String scientificName,
      final String? family,
      final String? variety,
      required final List<String> plantingSeason,
      required final List<String> harvestSeason,
      final String? growthCycle,
      final String? sunExposure,
      final String? waterNeeds,
      final String? soilType,
      final double? spacingInCm,
      final double? depthInCm,
      final String? companionPlants,
      final String? incompatiblePlants,
      final String? diseases,
      final String? pests,
      final String? benefits,
      final String? notes,
      final String? imageUrl,
      required final DataSource source,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$UnifiedPlantDataImpl;

  factory _UnifiedPlantData.fromJson(Map<String, dynamic> json) =
      _$UnifiedPlantDataImpl.fromJson;

  @override
  String get plantId;
  @override
  String get commonName;
  @override
  String get scientificName;
  @override
  String? get family;
  @override
  String? get variety;
  @override
  List<String> get plantingSeason;
  @override
  List<String> get harvestSeason;
  @override
  String? get growthCycle;
  @override
  String? get sunExposure;
  @override
  String? get waterNeeds;
  @override
  String? get soilType;
  @override
  double? get spacingInCm;
  @override
  double? get depthInCm;
  @override
  String? get companionPlants;
  @override
  String? get incompatiblePlants;
  @override
  String? get diseases;
  @override
  String? get pests;
  @override
  String? get benefits;
  @override
  String? get notes;
  @override
  String? get imageUrl;
  @override
  DataSource get source;
  @override // Source de la plante (Legacy/Moderne/Catalog)
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UnifiedPlantDataImplCopyWith<_$UnifiedPlantDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnifiedGardenStats _$UnifiedGardenStatsFromJson(Map<String, dynamic> json) {
  return _UnifiedGardenStats.fromJson(json);
}

/// @nodoc
mixin _$UnifiedGardenStats {
  int get totalPlants => throw _privateConstructorUsedError;
  int get activePlants => throw _privateConstructorUsedError;
  int get historicalPlants => throw _privateConstructorUsedError;
  double get totalArea => throw _privateConstructorUsedError;
  double get activeArea => throw _privateConstructorUsedError;
  int get totalBeds => throw _privateConstructorUsedError;
  int get activeBeds => throw _privateConstructorUsedError;
  int get plantingsThisYear => throw _privateConstructorUsedError;
  int get harvestsThisYear => throw _privateConstructorUsedError;
  double get successRate => throw _privateConstructorUsedError;
  double get totalYield => throw _privateConstructorUsedError;
  double get currentYearYield => throw _privateConstructorUsedError;
  double get averageHealth =>
      throw _privateConstructorUsedError; // Santé moyenne des plantes (0-100)
  int get activeRecommendations =>
      throw _privateConstructorUsedError; // Recommandations IA actives
  int get activeAlerts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnifiedGardenStatsCopyWith<UnifiedGardenStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnifiedGardenStatsCopyWith<$Res> {
  factory $UnifiedGardenStatsCopyWith(
          UnifiedGardenStats value, $Res Function(UnifiedGardenStats) then) =
      _$UnifiedGardenStatsCopyWithImpl<$Res, UnifiedGardenStats>;
  @useResult
  $Res call(
      {int totalPlants,
      int activePlants,
      int historicalPlants,
      double totalArea,
      double activeArea,
      int totalBeds,
      int activeBeds,
      int plantingsThisYear,
      int harvestsThisYear,
      double successRate,
      double totalYield,
      double currentYearYield,
      double averageHealth,
      int activeRecommendations,
      int activeAlerts});
}

/// @nodoc
class _$UnifiedGardenStatsCopyWithImpl<$Res, $Val extends UnifiedGardenStats>
    implements $UnifiedGardenStatsCopyWith<$Res> {
  _$UnifiedGardenStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPlants = null,
    Object? activePlants = null,
    Object? historicalPlants = null,
    Object? totalArea = null,
    Object? activeArea = null,
    Object? totalBeds = null,
    Object? activeBeds = null,
    Object? plantingsThisYear = null,
    Object? harvestsThisYear = null,
    Object? successRate = null,
    Object? totalYield = null,
    Object? currentYearYield = null,
    Object? averageHealth = null,
    Object? activeRecommendations = null,
    Object? activeAlerts = null,
  }) {
    return _then(_value.copyWith(
      totalPlants: null == totalPlants
          ? _value.totalPlants
          : totalPlants // ignore: cast_nullable_to_non_nullable
              as int,
      activePlants: null == activePlants
          ? _value.activePlants
          : activePlants // ignore: cast_nullable_to_non_nullable
              as int,
      historicalPlants: null == historicalPlants
          ? _value.historicalPlants
          : historicalPlants // ignore: cast_nullable_to_non_nullable
              as int,
      totalArea: null == totalArea
          ? _value.totalArea
          : totalArea // ignore: cast_nullable_to_non_nullable
              as double,
      activeArea: null == activeArea
          ? _value.activeArea
          : activeArea // ignore: cast_nullable_to_non_nullable
              as double,
      totalBeds: null == totalBeds
          ? _value.totalBeds
          : totalBeds // ignore: cast_nullable_to_non_nullable
              as int,
      activeBeds: null == activeBeds
          ? _value.activeBeds
          : activeBeds // ignore: cast_nullable_to_non_nullable
              as int,
      plantingsThisYear: null == plantingsThisYear
          ? _value.plantingsThisYear
          : plantingsThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      harvestsThisYear: null == harvestsThisYear
          ? _value.harvestsThisYear
          : harvestsThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalYield: null == totalYield
          ? _value.totalYield
          : totalYield // ignore: cast_nullable_to_non_nullable
              as double,
      currentYearYield: null == currentYearYield
          ? _value.currentYearYield
          : currentYearYield // ignore: cast_nullable_to_non_nullable
              as double,
      averageHealth: null == averageHealth
          ? _value.averageHealth
          : averageHealth // ignore: cast_nullable_to_non_nullable
              as double,
      activeRecommendations: null == activeRecommendations
          ? _value.activeRecommendations
          : activeRecommendations // ignore: cast_nullable_to_non_nullable
              as int,
      activeAlerts: null == activeAlerts
          ? _value.activeAlerts
          : activeAlerts // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnifiedGardenStatsImplCopyWith<$Res>
    implements $UnifiedGardenStatsCopyWith<$Res> {
  factory _$$UnifiedGardenStatsImplCopyWith(_$UnifiedGardenStatsImpl value,
          $Res Function(_$UnifiedGardenStatsImpl) then) =
      __$$UnifiedGardenStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalPlants,
      int activePlants,
      int historicalPlants,
      double totalArea,
      double activeArea,
      int totalBeds,
      int activeBeds,
      int plantingsThisYear,
      int harvestsThisYear,
      double successRate,
      double totalYield,
      double currentYearYield,
      double averageHealth,
      int activeRecommendations,
      int activeAlerts});
}

/// @nodoc
class __$$UnifiedGardenStatsImplCopyWithImpl<$Res>
    extends _$UnifiedGardenStatsCopyWithImpl<$Res, _$UnifiedGardenStatsImpl>
    implements _$$UnifiedGardenStatsImplCopyWith<$Res> {
  __$$UnifiedGardenStatsImplCopyWithImpl(_$UnifiedGardenStatsImpl _value,
      $Res Function(_$UnifiedGardenStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPlants = null,
    Object? activePlants = null,
    Object? historicalPlants = null,
    Object? totalArea = null,
    Object? activeArea = null,
    Object? totalBeds = null,
    Object? activeBeds = null,
    Object? plantingsThisYear = null,
    Object? harvestsThisYear = null,
    Object? successRate = null,
    Object? totalYield = null,
    Object? currentYearYield = null,
    Object? averageHealth = null,
    Object? activeRecommendations = null,
    Object? activeAlerts = null,
  }) {
    return _then(_$UnifiedGardenStatsImpl(
      totalPlants: null == totalPlants
          ? _value.totalPlants
          : totalPlants // ignore: cast_nullable_to_non_nullable
              as int,
      activePlants: null == activePlants
          ? _value.activePlants
          : activePlants // ignore: cast_nullable_to_non_nullable
              as int,
      historicalPlants: null == historicalPlants
          ? _value.historicalPlants
          : historicalPlants // ignore: cast_nullable_to_non_nullable
              as int,
      totalArea: null == totalArea
          ? _value.totalArea
          : totalArea // ignore: cast_nullable_to_non_nullable
              as double,
      activeArea: null == activeArea
          ? _value.activeArea
          : activeArea // ignore: cast_nullable_to_non_nullable
              as double,
      totalBeds: null == totalBeds
          ? _value.totalBeds
          : totalBeds // ignore: cast_nullable_to_non_nullable
              as int,
      activeBeds: null == activeBeds
          ? _value.activeBeds
          : activeBeds // ignore: cast_nullable_to_non_nullable
              as int,
      plantingsThisYear: null == plantingsThisYear
          ? _value.plantingsThisYear
          : plantingsThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      harvestsThisYear: null == harvestsThisYear
          ? _value.harvestsThisYear
          : harvestsThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalYield: null == totalYield
          ? _value.totalYield
          : totalYield // ignore: cast_nullable_to_non_nullable
              as double,
      currentYearYield: null == currentYearYield
          ? _value.currentYearYield
          : currentYearYield // ignore: cast_nullable_to_non_nullable
              as double,
      averageHealth: null == averageHealth
          ? _value.averageHealth
          : averageHealth // ignore: cast_nullable_to_non_nullable
              as double,
      activeRecommendations: null == activeRecommendations
          ? _value.activeRecommendations
          : activeRecommendations // ignore: cast_nullable_to_non_nullable
              as int,
      activeAlerts: null == activeAlerts
          ? _value.activeAlerts
          : activeAlerts // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnifiedGardenStatsImpl implements _UnifiedGardenStats {
  const _$UnifiedGardenStatsImpl(
      {required this.totalPlants,
      required this.activePlants,
      required this.historicalPlants,
      required this.totalArea,
      required this.activeArea,
      required this.totalBeds,
      required this.activeBeds,
      required this.plantingsThisYear,
      required this.harvestsThisYear,
      required this.successRate,
      required this.totalYield,
      required this.currentYearYield,
      required this.averageHealth,
      required this.activeRecommendations,
      required this.activeAlerts});

  factory _$UnifiedGardenStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnifiedGardenStatsImplFromJson(json);

  @override
  final int totalPlants;
  @override
  final int activePlants;
  @override
  final int historicalPlants;
  @override
  final double totalArea;
  @override
  final double activeArea;
  @override
  final int totalBeds;
  @override
  final int activeBeds;
  @override
  final int plantingsThisYear;
  @override
  final int harvestsThisYear;
  @override
  final double successRate;
  @override
  final double totalYield;
  @override
  final double currentYearYield;
  @override
  final double averageHealth;
// Santé moyenne des plantes (0-100)
  @override
  final int activeRecommendations;
// Recommandations IA actives
  @override
  final int activeAlerts;

  @override
  String toString() {
    return 'UnifiedGardenStats(totalPlants: $totalPlants, activePlants: $activePlants, historicalPlants: $historicalPlants, totalArea: $totalArea, activeArea: $activeArea, totalBeds: $totalBeds, activeBeds: $activeBeds, plantingsThisYear: $plantingsThisYear, harvestsThisYear: $harvestsThisYear, successRate: $successRate, totalYield: $totalYield, currentYearYield: $currentYearYield, averageHealth: $averageHealth, activeRecommendations: $activeRecommendations, activeAlerts: $activeAlerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnifiedGardenStatsImpl &&
            (identical(other.totalPlants, totalPlants) ||
                other.totalPlants == totalPlants) &&
            (identical(other.activePlants, activePlants) ||
                other.activePlants == activePlants) &&
            (identical(other.historicalPlants, historicalPlants) ||
                other.historicalPlants == historicalPlants) &&
            (identical(other.totalArea, totalArea) ||
                other.totalArea == totalArea) &&
            (identical(other.activeArea, activeArea) ||
                other.activeArea == activeArea) &&
            (identical(other.totalBeds, totalBeds) ||
                other.totalBeds == totalBeds) &&
            (identical(other.activeBeds, activeBeds) ||
                other.activeBeds == activeBeds) &&
            (identical(other.plantingsThisYear, plantingsThisYear) ||
                other.plantingsThisYear == plantingsThisYear) &&
            (identical(other.harvestsThisYear, harvestsThisYear) ||
                other.harvestsThisYear == harvestsThisYear) &&
            (identical(other.successRate, successRate) ||
                other.successRate == successRate) &&
            (identical(other.totalYield, totalYield) ||
                other.totalYield == totalYield) &&
            (identical(other.currentYearYield, currentYearYield) ||
                other.currentYearYield == currentYearYield) &&
            (identical(other.averageHealth, averageHealth) ||
                other.averageHealth == averageHealth) &&
            (identical(other.activeRecommendations, activeRecommendations) ||
                other.activeRecommendations == activeRecommendations) &&
            (identical(other.activeAlerts, activeAlerts) ||
                other.activeAlerts == activeAlerts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalPlants,
      activePlants,
      historicalPlants,
      totalArea,
      activeArea,
      totalBeds,
      activeBeds,
      plantingsThisYear,
      harvestsThisYear,
      successRate,
      totalYield,
      currentYearYield,
      averageHealth,
      activeRecommendations,
      activeAlerts);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnifiedGardenStatsImplCopyWith<_$UnifiedGardenStatsImpl> get copyWith =>
      __$$UnifiedGardenStatsImplCopyWithImpl<_$UnifiedGardenStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnifiedGardenStatsImplToJson(
      this,
    );
  }
}

abstract class _UnifiedGardenStats implements UnifiedGardenStats {
  const factory _UnifiedGardenStats(
      {required final int totalPlants,
      required final int activePlants,
      required final int historicalPlants,
      required final double totalArea,
      required final double activeArea,
      required final int totalBeds,
      required final int activeBeds,
      required final int plantingsThisYear,
      required final int harvestsThisYear,
      required final double successRate,
      required final double totalYield,
      required final double currentYearYield,
      required final double averageHealth,
      required final int activeRecommendations,
      required final int activeAlerts}) = _$UnifiedGardenStatsImpl;

  factory _UnifiedGardenStats.fromJson(Map<String, dynamic> json) =
      _$UnifiedGardenStatsImpl.fromJson;

  @override
  int get totalPlants;
  @override
  int get activePlants;
  @override
  int get historicalPlants;
  @override
  double get totalArea;
  @override
  double get activeArea;
  @override
  int get totalBeds;
  @override
  int get activeBeds;
  @override
  int get plantingsThisYear;
  @override
  int get harvestsThisYear;
  @override
  double get successRate;
  @override
  double get totalYield;
  @override
  double get currentYearYield;
  @override
  double get averageHealth;
  @override // Santé moyenne des plantes (0-100)
  int get activeRecommendations;
  @override // Recommandations IA actives
  int get activeAlerts;
  @override
  @JsonKey(ignore: true)
  _$$UnifiedGardenStatsImplCopyWith<_$UnifiedGardenStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnifiedSoilInfo _$UnifiedSoilInfoFromJson(Map<String, dynamic> json) {
  return _UnifiedSoilInfo.fromJson(json);
}

/// @nodoc
mixin _$UnifiedSoilInfo {
  String get type => throw _privateConstructorUsedError; // Type de sol dominant
  double get ph => throw _privateConstructorUsedError;
  String get texture => throw _privateConstructorUsedError;
  double get organicMatter => throw _privateConstructorUsedError;
  double get waterRetention => throw _privateConstructorUsedError;
  String get drainage => throw _privateConstructorUsedError;
  double get depth => throw _privateConstructorUsedError;
  Map<String, String> get nutrients => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnifiedSoilInfoCopyWith<UnifiedSoilInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnifiedSoilInfoCopyWith<$Res> {
  factory $UnifiedSoilInfoCopyWith(
          UnifiedSoilInfo value, $Res Function(UnifiedSoilInfo) then) =
      _$UnifiedSoilInfoCopyWithImpl<$Res, UnifiedSoilInfo>;
  @useResult
  $Res call(
      {String type,
      double ph,
      String texture,
      double organicMatter,
      double waterRetention,
      String drainage,
      double depth,
      Map<String, String> nutrients});
}

/// @nodoc
class _$UnifiedSoilInfoCopyWithImpl<$Res, $Val extends UnifiedSoilInfo>
    implements $UnifiedSoilInfoCopyWith<$Res> {
  _$UnifiedSoilInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? ph = null,
    Object? texture = null,
    Object? organicMatter = null,
    Object? waterRetention = null,
    Object? drainage = null,
    Object? depth = null,
    Object? nutrients = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      ph: null == ph
          ? _value.ph
          : ph // ignore: cast_nullable_to_non_nullable
              as double,
      texture: null == texture
          ? _value.texture
          : texture // ignore: cast_nullable_to_non_nullable
              as String,
      organicMatter: null == organicMatter
          ? _value.organicMatter
          : organicMatter // ignore: cast_nullable_to_non_nullable
              as double,
      waterRetention: null == waterRetention
          ? _value.waterRetention
          : waterRetention // ignore: cast_nullable_to_non_nullable
              as double,
      drainage: null == drainage
          ? _value.drainage
          : drainage // ignore: cast_nullable_to_non_nullable
              as String,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double,
      nutrients: null == nutrients
          ? _value.nutrients
          : nutrients // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnifiedSoilInfoImplCopyWith<$Res>
    implements $UnifiedSoilInfoCopyWith<$Res> {
  factory _$$UnifiedSoilInfoImplCopyWith(_$UnifiedSoilInfoImpl value,
          $Res Function(_$UnifiedSoilInfoImpl) then) =
      __$$UnifiedSoilInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      double ph,
      String texture,
      double organicMatter,
      double waterRetention,
      String drainage,
      double depth,
      Map<String, String> nutrients});
}

/// @nodoc
class __$$UnifiedSoilInfoImplCopyWithImpl<$Res>
    extends _$UnifiedSoilInfoCopyWithImpl<$Res, _$UnifiedSoilInfoImpl>
    implements _$$UnifiedSoilInfoImplCopyWith<$Res> {
  __$$UnifiedSoilInfoImplCopyWithImpl(
      _$UnifiedSoilInfoImpl _value, $Res Function(_$UnifiedSoilInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? ph = null,
    Object? texture = null,
    Object? organicMatter = null,
    Object? waterRetention = null,
    Object? drainage = null,
    Object? depth = null,
    Object? nutrients = null,
  }) {
    return _then(_$UnifiedSoilInfoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      ph: null == ph
          ? _value.ph
          : ph // ignore: cast_nullable_to_non_nullable
              as double,
      texture: null == texture
          ? _value.texture
          : texture // ignore: cast_nullable_to_non_nullable
              as String,
      organicMatter: null == organicMatter
          ? _value.organicMatter
          : organicMatter // ignore: cast_nullable_to_non_nullable
              as double,
      waterRetention: null == waterRetention
          ? _value.waterRetention
          : waterRetention // ignore: cast_nullable_to_non_nullable
              as double,
      drainage: null == drainage
          ? _value.drainage
          : drainage // ignore: cast_nullable_to_non_nullable
              as String,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double,
      nutrients: null == nutrients
          ? _value._nutrients
          : nutrients // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnifiedSoilInfoImpl implements _UnifiedSoilInfo {
  const _$UnifiedSoilInfoImpl(
      {required this.type,
      required this.ph,
      required this.texture,
      required this.organicMatter,
      required this.waterRetention,
      required this.drainage,
      required this.depth,
      required final Map<String, String> nutrients})
      : _nutrients = nutrients;

  factory _$UnifiedSoilInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnifiedSoilInfoImplFromJson(json);

  @override
  final String type;
// Type de sol dominant
  @override
  final double ph;
  @override
  final String texture;
  @override
  final double organicMatter;
  @override
  final double waterRetention;
  @override
  final String drainage;
  @override
  final double depth;
  final Map<String, String> _nutrients;
  @override
  Map<String, String> get nutrients {
    if (_nutrients is EqualUnmodifiableMapView) return _nutrients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutrients);
  }

  @override
  String toString() {
    return 'UnifiedSoilInfo(type: $type, ph: $ph, texture: $texture, organicMatter: $organicMatter, waterRetention: $waterRetention, drainage: $drainage, depth: $depth, nutrients: $nutrients)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnifiedSoilInfoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.ph, ph) || other.ph == ph) &&
            (identical(other.texture, texture) || other.texture == texture) &&
            (identical(other.organicMatter, organicMatter) ||
                other.organicMatter == organicMatter) &&
            (identical(other.waterRetention, waterRetention) ||
                other.waterRetention == waterRetention) &&
            (identical(other.drainage, drainage) ||
                other.drainage == drainage) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            const DeepCollectionEquality()
                .equals(other._nutrients, _nutrients));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      ph,
      texture,
      organicMatter,
      waterRetention,
      drainage,
      depth,
      const DeepCollectionEquality().hash(_nutrients));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnifiedSoilInfoImplCopyWith<_$UnifiedSoilInfoImpl> get copyWith =>
      __$$UnifiedSoilInfoImplCopyWithImpl<_$UnifiedSoilInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnifiedSoilInfoImplToJson(
      this,
    );
  }
}

abstract class _UnifiedSoilInfo implements UnifiedSoilInfo {
  const factory _UnifiedSoilInfo(
      {required final String type,
      required final double ph,
      required final String texture,
      required final double organicMatter,
      required final double waterRetention,
      required final String drainage,
      required final double depth,
      required final Map<String, String> nutrients}) = _$UnifiedSoilInfoImpl;

  factory _UnifiedSoilInfo.fromJson(Map<String, dynamic> json) =
      _$UnifiedSoilInfoImpl.fromJson;

  @override
  String get type;
  @override // Type de sol dominant
  double get ph;
  @override
  String get texture;
  @override
  double get organicMatter;
  @override
  double get waterRetention;
  @override
  String get drainage;
  @override
  double get depth;
  @override
  Map<String, String> get nutrients;
  @override
  @JsonKey(ignore: true)
  _$$UnifiedSoilInfoImplCopyWith<_$UnifiedSoilInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnifiedClimate _$UnifiedClimateFromJson(Map<String, dynamic> json) {
  return _UnifiedClimate.fromJson(json);
}

/// @nodoc
mixin _$UnifiedClimate {
  double get averageTemperature => throw _privateConstructorUsedError;
  double get minTemperature => throw _privateConstructorUsedError;
  double get maxTemperature => throw _privateConstructorUsedError;
  double get averagePrecipitation => throw _privateConstructorUsedError;
  double get averageHumidity => throw _privateConstructorUsedError;
  int get frostDays => throw _privateConstructorUsedError;
  int get growingSeasonLength => throw _privateConstructorUsedError;
  String get dominantWindDirection => throw _privateConstructorUsedError;
  double get averageWindSpeed => throw _privateConstructorUsedError;
  double get averageSunshineHours => throw _privateConstructorUsedError;
  String? get usdaZone => throw _privateConstructorUsedError;
  String? get climateType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnifiedClimateCopyWith<UnifiedClimate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnifiedClimateCopyWith<$Res> {
  factory $UnifiedClimateCopyWith(
          UnifiedClimate value, $Res Function(UnifiedClimate) then) =
      _$UnifiedClimateCopyWithImpl<$Res, UnifiedClimate>;
  @useResult
  $Res call(
      {double averageTemperature,
      double minTemperature,
      double maxTemperature,
      double averagePrecipitation,
      double averageHumidity,
      int frostDays,
      int growingSeasonLength,
      String dominantWindDirection,
      double averageWindSpeed,
      double averageSunshineHours,
      String? usdaZone,
      String? climateType});
}

/// @nodoc
class _$UnifiedClimateCopyWithImpl<$Res, $Val extends UnifiedClimate>
    implements $UnifiedClimateCopyWith<$Res> {
  _$UnifiedClimateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageTemperature = null,
    Object? minTemperature = null,
    Object? maxTemperature = null,
    Object? averagePrecipitation = null,
    Object? averageHumidity = null,
    Object? frostDays = null,
    Object? growingSeasonLength = null,
    Object? dominantWindDirection = null,
    Object? averageWindSpeed = null,
    Object? averageSunshineHours = null,
    Object? usdaZone = freezed,
    Object? climateType = freezed,
  }) {
    return _then(_value.copyWith(
      averageTemperature: null == averageTemperature
          ? _value.averageTemperature
          : averageTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      minTemperature: null == minTemperature
          ? _value.minTemperature
          : minTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      maxTemperature: null == maxTemperature
          ? _value.maxTemperature
          : maxTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      averagePrecipitation: null == averagePrecipitation
          ? _value.averagePrecipitation
          : averagePrecipitation // ignore: cast_nullable_to_non_nullable
              as double,
      averageHumidity: null == averageHumidity
          ? _value.averageHumidity
          : averageHumidity // ignore: cast_nullable_to_non_nullable
              as double,
      frostDays: null == frostDays
          ? _value.frostDays
          : frostDays // ignore: cast_nullable_to_non_nullable
              as int,
      growingSeasonLength: null == growingSeasonLength
          ? _value.growingSeasonLength
          : growingSeasonLength // ignore: cast_nullable_to_non_nullable
              as int,
      dominantWindDirection: null == dominantWindDirection
          ? _value.dominantWindDirection
          : dominantWindDirection // ignore: cast_nullable_to_non_nullable
              as String,
      averageWindSpeed: null == averageWindSpeed
          ? _value.averageWindSpeed
          : averageWindSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      averageSunshineHours: null == averageSunshineHours
          ? _value.averageSunshineHours
          : averageSunshineHours // ignore: cast_nullable_to_non_nullable
              as double,
      usdaZone: freezed == usdaZone
          ? _value.usdaZone
          : usdaZone // ignore: cast_nullable_to_non_nullable
              as String?,
      climateType: freezed == climateType
          ? _value.climateType
          : climateType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnifiedClimateImplCopyWith<$Res>
    implements $UnifiedClimateCopyWith<$Res> {
  factory _$$UnifiedClimateImplCopyWith(_$UnifiedClimateImpl value,
          $Res Function(_$UnifiedClimateImpl) then) =
      __$$UnifiedClimateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double averageTemperature,
      double minTemperature,
      double maxTemperature,
      double averagePrecipitation,
      double averageHumidity,
      int frostDays,
      int growingSeasonLength,
      String dominantWindDirection,
      double averageWindSpeed,
      double averageSunshineHours,
      String? usdaZone,
      String? climateType});
}

/// @nodoc
class __$$UnifiedClimateImplCopyWithImpl<$Res>
    extends _$UnifiedClimateCopyWithImpl<$Res, _$UnifiedClimateImpl>
    implements _$$UnifiedClimateImplCopyWith<$Res> {
  __$$UnifiedClimateImplCopyWithImpl(
      _$UnifiedClimateImpl _value, $Res Function(_$UnifiedClimateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageTemperature = null,
    Object? minTemperature = null,
    Object? maxTemperature = null,
    Object? averagePrecipitation = null,
    Object? averageHumidity = null,
    Object? frostDays = null,
    Object? growingSeasonLength = null,
    Object? dominantWindDirection = null,
    Object? averageWindSpeed = null,
    Object? averageSunshineHours = null,
    Object? usdaZone = freezed,
    Object? climateType = freezed,
  }) {
    return _then(_$UnifiedClimateImpl(
      averageTemperature: null == averageTemperature
          ? _value.averageTemperature
          : averageTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      minTemperature: null == minTemperature
          ? _value.minTemperature
          : minTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      maxTemperature: null == maxTemperature
          ? _value.maxTemperature
          : maxTemperature // ignore: cast_nullable_to_non_nullable
              as double,
      averagePrecipitation: null == averagePrecipitation
          ? _value.averagePrecipitation
          : averagePrecipitation // ignore: cast_nullable_to_non_nullable
              as double,
      averageHumidity: null == averageHumidity
          ? _value.averageHumidity
          : averageHumidity // ignore: cast_nullable_to_non_nullable
              as double,
      frostDays: null == frostDays
          ? _value.frostDays
          : frostDays // ignore: cast_nullable_to_non_nullable
              as int,
      growingSeasonLength: null == growingSeasonLength
          ? _value.growingSeasonLength
          : growingSeasonLength // ignore: cast_nullable_to_non_nullable
              as int,
      dominantWindDirection: null == dominantWindDirection
          ? _value.dominantWindDirection
          : dominantWindDirection // ignore: cast_nullable_to_non_nullable
              as String,
      averageWindSpeed: null == averageWindSpeed
          ? _value.averageWindSpeed
          : averageWindSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      averageSunshineHours: null == averageSunshineHours
          ? _value.averageSunshineHours
          : averageSunshineHours // ignore: cast_nullable_to_non_nullable
              as double,
      usdaZone: freezed == usdaZone
          ? _value.usdaZone
          : usdaZone // ignore: cast_nullable_to_non_nullable
              as String?,
      climateType: freezed == climateType
          ? _value.climateType
          : climateType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnifiedClimateImpl implements _UnifiedClimate {
  const _$UnifiedClimateImpl(
      {required this.averageTemperature,
      required this.minTemperature,
      required this.maxTemperature,
      required this.averagePrecipitation,
      required this.averageHumidity,
      required this.frostDays,
      required this.growingSeasonLength,
      required this.dominantWindDirection,
      required this.averageWindSpeed,
      required this.averageSunshineHours,
      this.usdaZone,
      this.climateType});

  factory _$UnifiedClimateImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnifiedClimateImplFromJson(json);

  @override
  final double averageTemperature;
  @override
  final double minTemperature;
  @override
  final double maxTemperature;
  @override
  final double averagePrecipitation;
  @override
  final double averageHumidity;
  @override
  final int frostDays;
  @override
  final int growingSeasonLength;
  @override
  final String dominantWindDirection;
  @override
  final double averageWindSpeed;
  @override
  final double averageSunshineHours;
  @override
  final String? usdaZone;
  @override
  final String? climateType;

  @override
  String toString() {
    return 'UnifiedClimate(averageTemperature: $averageTemperature, minTemperature: $minTemperature, maxTemperature: $maxTemperature, averagePrecipitation: $averagePrecipitation, averageHumidity: $averageHumidity, frostDays: $frostDays, growingSeasonLength: $growingSeasonLength, dominantWindDirection: $dominantWindDirection, averageWindSpeed: $averageWindSpeed, averageSunshineHours: $averageSunshineHours, usdaZone: $usdaZone, climateType: $climateType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnifiedClimateImpl &&
            (identical(other.averageTemperature, averageTemperature) ||
                other.averageTemperature == averageTemperature) &&
            (identical(other.minTemperature, minTemperature) ||
                other.minTemperature == minTemperature) &&
            (identical(other.maxTemperature, maxTemperature) ||
                other.maxTemperature == maxTemperature) &&
            (identical(other.averagePrecipitation, averagePrecipitation) ||
                other.averagePrecipitation == averagePrecipitation) &&
            (identical(other.averageHumidity, averageHumidity) ||
                other.averageHumidity == averageHumidity) &&
            (identical(other.frostDays, frostDays) ||
                other.frostDays == frostDays) &&
            (identical(other.growingSeasonLength, growingSeasonLength) ||
                other.growingSeasonLength == growingSeasonLength) &&
            (identical(other.dominantWindDirection, dominantWindDirection) ||
                other.dominantWindDirection == dominantWindDirection) &&
            (identical(other.averageWindSpeed, averageWindSpeed) ||
                other.averageWindSpeed == averageWindSpeed) &&
            (identical(other.averageSunshineHours, averageSunshineHours) ||
                other.averageSunshineHours == averageSunshineHours) &&
            (identical(other.usdaZone, usdaZone) ||
                other.usdaZone == usdaZone) &&
            (identical(other.climateType, climateType) ||
                other.climateType == climateType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      averageTemperature,
      minTemperature,
      maxTemperature,
      averagePrecipitation,
      averageHumidity,
      frostDays,
      growingSeasonLength,
      dominantWindDirection,
      averageWindSpeed,
      averageSunshineHours,
      usdaZone,
      climateType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnifiedClimateImplCopyWith<_$UnifiedClimateImpl> get copyWith =>
      __$$UnifiedClimateImplCopyWithImpl<_$UnifiedClimateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnifiedClimateImplToJson(
      this,
    );
  }
}

abstract class _UnifiedClimate implements UnifiedClimate {
  const factory _UnifiedClimate(
      {required final double averageTemperature,
      required final double minTemperature,
      required final double maxTemperature,
      required final double averagePrecipitation,
      required final double averageHumidity,
      required final int frostDays,
      required final int growingSeasonLength,
      required final String dominantWindDirection,
      required final double averageWindSpeed,
      required final double averageSunshineHours,
      final String? usdaZone,
      final String? climateType}) = _$UnifiedClimateImpl;

  factory _UnifiedClimate.fromJson(Map<String, dynamic> json) =
      _$UnifiedClimateImpl.fromJson;

  @override
  double get averageTemperature;
  @override
  double get minTemperature;
  @override
  double get maxTemperature;
  @override
  double get averagePrecipitation;
  @override
  double get averageHumidity;
  @override
  int get frostDays;
  @override
  int get growingSeasonLength;
  @override
  String get dominantWindDirection;
  @override
  double get averageWindSpeed;
  @override
  double get averageSunshineHours;
  @override
  String? get usdaZone;
  @override
  String? get climateType;
  @override
  @JsonKey(ignore: true)
  _$$UnifiedClimateImplCopyWith<_$UnifiedClimateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnifiedCultivationPreferences _$UnifiedCultivationPreferencesFromJson(
    Map<String, dynamic> json) {
  return _UnifiedCultivationPreferences.fromJson(json);
}

/// @nodoc
mixin _$UnifiedCultivationPreferences {
  String get method =>
      throw _privateConstructorUsedError; // permaculture, organic, conventional, etc.
  bool get usePesticides => throw _privateConstructorUsedError;
  bool get useChemicalFertilizers => throw _privateConstructorUsedError;
  bool get useOrganicFertilizers => throw _privateConstructorUsedError;
  bool get cropRotation => throw _privateConstructorUsedError;
  bool get companionPlanting => throw _privateConstructorUsedError;
  bool get mulching => throw _privateConstructorUsedError;
  bool get automaticIrrigation => throw _privateConstructorUsedError;
  bool get regularMonitoring => throw _privateConstructorUsedError;
  List<String> get objectives => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnifiedCultivationPreferencesCopyWith<UnifiedCultivationPreferences>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnifiedCultivationPreferencesCopyWith<$Res> {
  factory $UnifiedCultivationPreferencesCopyWith(
          UnifiedCultivationPreferences value,
          $Res Function(UnifiedCultivationPreferences) then) =
      _$UnifiedCultivationPreferencesCopyWithImpl<$Res,
          UnifiedCultivationPreferences>;
  @useResult
  $Res call(
      {String method,
      bool usePesticides,
      bool useChemicalFertilizers,
      bool useOrganicFertilizers,
      bool cropRotation,
      bool companionPlanting,
      bool mulching,
      bool automaticIrrigation,
      bool regularMonitoring,
      List<String> objectives});
}

/// @nodoc
class _$UnifiedCultivationPreferencesCopyWithImpl<$Res,
        $Val extends UnifiedCultivationPreferences>
    implements $UnifiedCultivationPreferencesCopyWith<$Res> {
  _$UnifiedCultivationPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? usePesticides = null,
    Object? useChemicalFertilizers = null,
    Object? useOrganicFertilizers = null,
    Object? cropRotation = null,
    Object? companionPlanting = null,
    Object? mulching = null,
    Object? automaticIrrigation = null,
    Object? regularMonitoring = null,
    Object? objectives = null,
  }) {
    return _then(_value.copyWith(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      usePesticides: null == usePesticides
          ? _value.usePesticides
          : usePesticides // ignore: cast_nullable_to_non_nullable
              as bool,
      useChemicalFertilizers: null == useChemicalFertilizers
          ? _value.useChemicalFertilizers
          : useChemicalFertilizers // ignore: cast_nullable_to_non_nullable
              as bool,
      useOrganicFertilizers: null == useOrganicFertilizers
          ? _value.useOrganicFertilizers
          : useOrganicFertilizers // ignore: cast_nullable_to_non_nullable
              as bool,
      cropRotation: null == cropRotation
          ? _value.cropRotation
          : cropRotation // ignore: cast_nullable_to_non_nullable
              as bool,
      companionPlanting: null == companionPlanting
          ? _value.companionPlanting
          : companionPlanting // ignore: cast_nullable_to_non_nullable
              as bool,
      mulching: null == mulching
          ? _value.mulching
          : mulching // ignore: cast_nullable_to_non_nullable
              as bool,
      automaticIrrigation: null == automaticIrrigation
          ? _value.automaticIrrigation
          : automaticIrrigation // ignore: cast_nullable_to_non_nullable
              as bool,
      regularMonitoring: null == regularMonitoring
          ? _value.regularMonitoring
          : regularMonitoring // ignore: cast_nullable_to_non_nullable
              as bool,
      objectives: null == objectives
          ? _value.objectives
          : objectives // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnifiedCultivationPreferencesImplCopyWith<$Res>
    implements $UnifiedCultivationPreferencesCopyWith<$Res> {
  factory _$$UnifiedCultivationPreferencesImplCopyWith(
          _$UnifiedCultivationPreferencesImpl value,
          $Res Function(_$UnifiedCultivationPreferencesImpl) then) =
      __$$UnifiedCultivationPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String method,
      bool usePesticides,
      bool useChemicalFertilizers,
      bool useOrganicFertilizers,
      bool cropRotation,
      bool companionPlanting,
      bool mulching,
      bool automaticIrrigation,
      bool regularMonitoring,
      List<String> objectives});
}

/// @nodoc
class __$$UnifiedCultivationPreferencesImplCopyWithImpl<$Res>
    extends _$UnifiedCultivationPreferencesCopyWithImpl<$Res,
        _$UnifiedCultivationPreferencesImpl>
    implements _$$UnifiedCultivationPreferencesImplCopyWith<$Res> {
  __$$UnifiedCultivationPreferencesImplCopyWithImpl(
      _$UnifiedCultivationPreferencesImpl _value,
      $Res Function(_$UnifiedCultivationPreferencesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? usePesticides = null,
    Object? useChemicalFertilizers = null,
    Object? useOrganicFertilizers = null,
    Object? cropRotation = null,
    Object? companionPlanting = null,
    Object? mulching = null,
    Object? automaticIrrigation = null,
    Object? regularMonitoring = null,
    Object? objectives = null,
  }) {
    return _then(_$UnifiedCultivationPreferencesImpl(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      usePesticides: null == usePesticides
          ? _value.usePesticides
          : usePesticides // ignore: cast_nullable_to_non_nullable
              as bool,
      useChemicalFertilizers: null == useChemicalFertilizers
          ? _value.useChemicalFertilizers
          : useChemicalFertilizers // ignore: cast_nullable_to_non_nullable
              as bool,
      useOrganicFertilizers: null == useOrganicFertilizers
          ? _value.useOrganicFertilizers
          : useOrganicFertilizers // ignore: cast_nullable_to_non_nullable
              as bool,
      cropRotation: null == cropRotation
          ? _value.cropRotation
          : cropRotation // ignore: cast_nullable_to_non_nullable
              as bool,
      companionPlanting: null == companionPlanting
          ? _value.companionPlanting
          : companionPlanting // ignore: cast_nullable_to_non_nullable
              as bool,
      mulching: null == mulching
          ? _value.mulching
          : mulching // ignore: cast_nullable_to_non_nullable
              as bool,
      automaticIrrigation: null == automaticIrrigation
          ? _value.automaticIrrigation
          : automaticIrrigation // ignore: cast_nullable_to_non_nullable
              as bool,
      regularMonitoring: null == regularMonitoring
          ? _value.regularMonitoring
          : regularMonitoring // ignore: cast_nullable_to_non_nullable
              as bool,
      objectives: null == objectives
          ? _value._objectives
          : objectives // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnifiedCultivationPreferencesImpl
    implements _UnifiedCultivationPreferences {
  const _$UnifiedCultivationPreferencesImpl(
      {required this.method,
      required this.usePesticides,
      required this.useChemicalFertilizers,
      required this.useOrganicFertilizers,
      required this.cropRotation,
      required this.companionPlanting,
      required this.mulching,
      required this.automaticIrrigation,
      required this.regularMonitoring,
      required final List<String> objectives})
      : _objectives = objectives;

  factory _$UnifiedCultivationPreferencesImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UnifiedCultivationPreferencesImplFromJson(json);

  @override
  final String method;
// permaculture, organic, conventional, etc.
  @override
  final bool usePesticides;
  @override
  final bool useChemicalFertilizers;
  @override
  final bool useOrganicFertilizers;
  @override
  final bool cropRotation;
  @override
  final bool companionPlanting;
  @override
  final bool mulching;
  @override
  final bool automaticIrrigation;
  @override
  final bool regularMonitoring;
  final List<String> _objectives;
  @override
  List<String> get objectives {
    if (_objectives is EqualUnmodifiableListView) return _objectives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_objectives);
  }

  @override
  String toString() {
    return 'UnifiedCultivationPreferences(method: $method, usePesticides: $usePesticides, useChemicalFertilizers: $useChemicalFertilizers, useOrganicFertilizers: $useOrganicFertilizers, cropRotation: $cropRotation, companionPlanting: $companionPlanting, mulching: $mulching, automaticIrrigation: $automaticIrrigation, regularMonitoring: $regularMonitoring, objectives: $objectives)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnifiedCultivationPreferencesImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.usePesticides, usePesticides) ||
                other.usePesticides == usePesticides) &&
            (identical(other.useChemicalFertilizers, useChemicalFertilizers) ||
                other.useChemicalFertilizers == useChemicalFertilizers) &&
            (identical(other.useOrganicFertilizers, useOrganicFertilizers) ||
                other.useOrganicFertilizers == useOrganicFertilizers) &&
            (identical(other.cropRotation, cropRotation) ||
                other.cropRotation == cropRotation) &&
            (identical(other.companionPlanting, companionPlanting) ||
                other.companionPlanting == companionPlanting) &&
            (identical(other.mulching, mulching) ||
                other.mulching == mulching) &&
            (identical(other.automaticIrrigation, automaticIrrigation) ||
                other.automaticIrrigation == automaticIrrigation) &&
            (identical(other.regularMonitoring, regularMonitoring) ||
                other.regularMonitoring == regularMonitoring) &&
            const DeepCollectionEquality()
                .equals(other._objectives, _objectives));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      method,
      usePesticides,
      useChemicalFertilizers,
      useOrganicFertilizers,
      cropRotation,
      companionPlanting,
      mulching,
      automaticIrrigation,
      regularMonitoring,
      const DeepCollectionEquality().hash(_objectives));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnifiedCultivationPreferencesImplCopyWith<
          _$UnifiedCultivationPreferencesImpl>
      get copyWith => __$$UnifiedCultivationPreferencesImplCopyWithImpl<
          _$UnifiedCultivationPreferencesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnifiedCultivationPreferencesImplToJson(
      this,
    );
  }
}

abstract class _UnifiedCultivationPreferences
    implements UnifiedCultivationPreferences {
  const factory _UnifiedCultivationPreferences(
          {required final String method,
          required final bool usePesticides,
          required final bool useChemicalFertilizers,
          required final bool useOrganicFertilizers,
          required final bool cropRotation,
          required final bool companionPlanting,
          required final bool mulching,
          required final bool automaticIrrigation,
          required final bool regularMonitoring,
          required final List<String> objectives}) =
      _$UnifiedCultivationPreferencesImpl;

  factory _UnifiedCultivationPreferences.fromJson(Map<String, dynamic> json) =
      _$UnifiedCultivationPreferencesImpl.fromJson;

  @override
  String get method;
  @override // permaculture, organic, conventional, etc.
  bool get usePesticides;
  @override
  bool get useChemicalFertilizers;
  @override
  bool get useOrganicFertilizers;
  @override
  bool get cropRotation;
  @override
  bool get companionPlanting;
  @override
  bool get mulching;
  @override
  bool get automaticIrrigation;
  @override
  bool get regularMonitoring;
  @override
  List<String> get objectives;
  @override
  @JsonKey(ignore: true)
  _$$UnifiedCultivationPreferencesImplCopyWith<
          _$UnifiedCultivationPreferencesImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UnifiedActivityHistory _$UnifiedActivityHistoryFromJson(
    Map<String, dynamic> json) {
  return _UnifiedActivityHistory.fromJson(json);
}

/// @nodoc
mixin _$UnifiedActivityHistory {
  String get activityId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get plantId => throw _privateConstructorUsedError;
  String? get bedId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnifiedActivityHistoryCopyWith<UnifiedActivityHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnifiedActivityHistoryCopyWith<$Res> {
  factory $UnifiedActivityHistoryCopyWith(UnifiedActivityHistory value,
          $Res Function(UnifiedActivityHistory) then) =
      _$UnifiedActivityHistoryCopyWithImpl<$Res, UnifiedActivityHistory>;
  @useResult
  $Res call(
      {String activityId,
      String type,
      String description,
      DateTime timestamp,
      String? plantId,
      String? bedId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$UnifiedActivityHistoryCopyWithImpl<$Res,
        $Val extends UnifiedActivityHistory>
    implements $UnifiedActivityHistoryCopyWith<$Res> {
  _$UnifiedActivityHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
    Object? type = null,
    Object? description = null,
    Object? timestamp = null,
    Object? plantId = freezed,
    Object? bedId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      plantId: freezed == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String?,
      bedId: freezed == bedId
          ? _value.bedId
          : bedId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnifiedActivityHistoryImplCopyWith<$Res>
    implements $UnifiedActivityHistoryCopyWith<$Res> {
  factory _$$UnifiedActivityHistoryImplCopyWith(
          _$UnifiedActivityHistoryImpl value,
          $Res Function(_$UnifiedActivityHistoryImpl) then) =
      __$$UnifiedActivityHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String activityId,
      String type,
      String description,
      DateTime timestamp,
      String? plantId,
      String? bedId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$UnifiedActivityHistoryImplCopyWithImpl<$Res>
    extends _$UnifiedActivityHistoryCopyWithImpl<$Res,
        _$UnifiedActivityHistoryImpl>
    implements _$$UnifiedActivityHistoryImplCopyWith<$Res> {
  __$$UnifiedActivityHistoryImplCopyWithImpl(
      _$UnifiedActivityHistoryImpl _value,
      $Res Function(_$UnifiedActivityHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
    Object? type = null,
    Object? description = null,
    Object? timestamp = null,
    Object? plantId = freezed,
    Object? bedId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$UnifiedActivityHistoryImpl(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      plantId: freezed == plantId
          ? _value.plantId
          : plantId // ignore: cast_nullable_to_non_nullable
              as String?,
      bedId: freezed == bedId
          ? _value.bedId
          : bedId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnifiedActivityHistoryImpl implements _UnifiedActivityHistory {
  const _$UnifiedActivityHistoryImpl(
      {required this.activityId,
      required this.type,
      required this.description,
      required this.timestamp,
      this.plantId,
      this.bedId,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$UnifiedActivityHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnifiedActivityHistoryImplFromJson(json);

  @override
  final String activityId;
  @override
  final String type;
  @override
  final String description;
  @override
  final DateTime timestamp;
  @override
  final String? plantId;
  @override
  final String? bedId;
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
    return 'UnifiedActivityHistory(activityId: $activityId, type: $type, description: $description, timestamp: $timestamp, plantId: $plantId, bedId: $bedId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnifiedActivityHistoryImpl &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.plantId, plantId) || other.plantId == plantId) &&
            (identical(other.bedId, bedId) || other.bedId == bedId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      activityId,
      type,
      description,
      timestamp,
      plantId,
      bedId,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnifiedActivityHistoryImplCopyWith<_$UnifiedActivityHistoryImpl>
      get copyWith => __$$UnifiedActivityHistoryImplCopyWithImpl<
          _$UnifiedActivityHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnifiedActivityHistoryImplToJson(
      this,
    );
  }
}

abstract class _UnifiedActivityHistory implements UnifiedActivityHistory {
  const factory _UnifiedActivityHistory(
      {required final String activityId,
      required final String type,
      required final String description,
      required final DateTime timestamp,
      final String? plantId,
      final String? bedId,
      final Map<String, dynamic>? metadata}) = _$UnifiedActivityHistoryImpl;

  factory _UnifiedActivityHistory.fromJson(Map<String, dynamic> json) =
      _$UnifiedActivityHistoryImpl.fromJson;

  @override
  String get activityId;
  @override
  String get type;
  @override
  String get description;
  @override
  DateTime get timestamp;
  @override
  String? get plantId;
  @override
  String? get bedId;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$UnifiedActivityHistoryImplCopyWith<_$UnifiedActivityHistoryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

