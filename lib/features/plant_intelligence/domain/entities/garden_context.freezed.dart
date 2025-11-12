// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'garden_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GardenContext _$GardenContextFromJson(Map<String, dynamic> json) {
  return _GardenContext.fromJson(json);
}

/// @nodoc
mixin _$GardenContext {
  /// Identifiant unique du jardin
  String get gardenId => throw _privateConstructorUsedError;

  /// Nom du jardin
  String get name => throw _privateConstructorUsedError;

  /// Description du jardin
  String? get description => throw _privateConstructorUsedError;

  /// Emplacement du jardin
  GardenLocation get location => throw _privateConstructorUsedError;

  /// Conditions climatiques générales
  ClimateConditions get climate => throw _privateConstructorUsedError;

  /// Informations sur le sol
  SoilInfo get soil => throw _privateConstructorUsedError;

  /// Plantes actuellement dans le jardin
  List<String> get activePlantIds => throw _privateConstructorUsedError;

  /// Historique des plantations
  List<String> get historicalPlantIds => throw _privateConstructorUsedError;

  /// Statistiques du jardin
  GardenStats get stats => throw _privateConstructorUsedError;

  /// Préférences de culture
  CultivationPreferences get preferences => throw _privateConstructorUsedError;

  /// Date de création
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Date de dernière mise à jour
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GardenContextCopyWith<GardenContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GardenContextCopyWith<$Res> {
  factory $GardenContextCopyWith(
          GardenContext value, $Res Function(GardenContext) then) =
      _$GardenContextCopyWithImpl<$Res, GardenContext>;
  @useResult
  $Res call(
      {String gardenId,
      String name,
      String? description,
      GardenLocation location,
      ClimateConditions climate,
      SoilInfo soil,
      List<String> activePlantIds,
      List<String> historicalPlantIds,
      GardenStats stats,
      CultivationPreferences preferences,
      DateTime? createdAt,
      DateTime? updatedAt,
      Map<String, dynamic> metadata});

  $GardenLocationCopyWith<$Res> get location;
  $ClimateConditionsCopyWith<$Res> get climate;
  $SoilInfoCopyWith<$Res> get soil;
  $GardenStatsCopyWith<$Res> get stats;
  $CultivationPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class _$GardenContextCopyWithImpl<$Res, $Val extends GardenContext>
    implements $GardenContextCopyWith<$Res> {
  _$GardenContextCopyWithImpl(this._value, this._then);

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
    Object? location = null,
    Object? climate = null,
    Object? soil = null,
    Object? activePlantIds = null,
    Object? historicalPlantIds = null,
    Object? stats = null,
    Object? preferences = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? metadata = null,
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
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GardenLocation,
      climate: null == climate
          ? _value.climate
          : climate // ignore: cast_nullable_to_non_nullable
              as ClimateConditions,
      soil: null == soil
          ? _value.soil
          : soil // ignore: cast_nullable_to_non_nullable
              as SoilInfo,
      activePlantIds: null == activePlantIds
          ? _value.activePlantIds
          : activePlantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      historicalPlantIds: null == historicalPlantIds
          ? _value.historicalPlantIds
          : historicalPlantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as GardenStats,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as CultivationPreferences,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GardenLocationCopyWith<$Res> get location {
    return $GardenLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ClimateConditionsCopyWith<$Res> get climate {
    return $ClimateConditionsCopyWith<$Res>(_value.climate, (value) {
      return _then(_value.copyWith(climate: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SoilInfoCopyWith<$Res> get soil {
    return $SoilInfoCopyWith<$Res>(_value.soil, (value) {
      return _then(_value.copyWith(soil: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GardenStatsCopyWith<$Res> get stats {
    return $GardenStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CultivationPreferencesCopyWith<$Res> get preferences {
    return $CultivationPreferencesCopyWith<$Res>(_value.preferences, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GardenContextImplCopyWith<$Res>
    implements $GardenContextCopyWith<$Res> {
  factory _$$GardenContextImplCopyWith(
          _$GardenContextImpl value, $Res Function(_$GardenContextImpl) then) =
      __$$GardenContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gardenId,
      String name,
      String? description,
      GardenLocation location,
      ClimateConditions climate,
      SoilInfo soil,
      List<String> activePlantIds,
      List<String> historicalPlantIds,
      GardenStats stats,
      CultivationPreferences preferences,
      DateTime? createdAt,
      DateTime? updatedAt,
      Map<String, dynamic> metadata});

  @override
  $GardenLocationCopyWith<$Res> get location;
  @override
  $ClimateConditionsCopyWith<$Res> get climate;
  @override
  $SoilInfoCopyWith<$Res> get soil;
  @override
  $GardenStatsCopyWith<$Res> get stats;
  @override
  $CultivationPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class __$$GardenContextImplCopyWithImpl<$Res>
    extends _$GardenContextCopyWithImpl<$Res, _$GardenContextImpl>
    implements _$$GardenContextImplCopyWith<$Res> {
  __$$GardenContextImplCopyWithImpl(
      _$GardenContextImpl _value, $Res Function(_$GardenContextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gardenId = null,
    Object? name = null,
    Object? description = freezed,
    Object? location = null,
    Object? climate = null,
    Object? soil = null,
    Object? activePlantIds = null,
    Object? historicalPlantIds = null,
    Object? stats = null,
    Object? preferences = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_$GardenContextImpl(
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
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GardenLocation,
      climate: null == climate
          ? _value.climate
          : climate // ignore: cast_nullable_to_non_nullable
              as ClimateConditions,
      soil: null == soil
          ? _value.soil
          : soil // ignore: cast_nullable_to_non_nullable
              as SoilInfo,
      activePlantIds: null == activePlantIds
          ? _value._activePlantIds
          : activePlantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      historicalPlantIds: null == historicalPlantIds
          ? _value._historicalPlantIds
          : historicalPlantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as GardenStats,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as CultivationPreferences,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GardenContextImpl implements _GardenContext {
  const _$GardenContextImpl(
      {required this.gardenId,
      required this.name,
      this.description,
      required this.location,
      required this.climate,
      required this.soil,
      required final List<String> activePlantIds,
      required final List<String> historicalPlantIds,
      required this.stats,
      required this.preferences,
      this.createdAt,
      this.updatedAt,
      final Map<String, dynamic> metadata = const {}})
      : _activePlantIds = activePlantIds,
        _historicalPlantIds = historicalPlantIds,
        _metadata = metadata;

  factory _$GardenContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$GardenContextImplFromJson(json);

  /// Identifiant unique du jardin
  @override
  final String gardenId;

  /// Nom du jardin
  @override
  final String name;

  /// Description du jardin
  @override
  final String? description;

  /// Emplacement du jardin
  @override
  final GardenLocation location;

  /// Conditions climatiques générales
  @override
  final ClimateConditions climate;

  /// Informations sur le sol
  @override
  final SoilInfo soil;

  /// Plantes actuellement dans le jardin
  final List<String> _activePlantIds;

  /// Plantes actuellement dans le jardin
  @override
  List<String> get activePlantIds {
    if (_activePlantIds is EqualUnmodifiableListView) return _activePlantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activePlantIds);
  }

  /// Historique des plantations
  final List<String> _historicalPlantIds;

  /// Historique des plantations
  @override
  List<String> get historicalPlantIds {
    if (_historicalPlantIds is EqualUnmodifiableListView)
      return _historicalPlantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_historicalPlantIds);
  }

  /// Statistiques du jardin
  @override
  final GardenStats stats;

  /// Préférences de culture
  @override
  final CultivationPreferences preferences;

  /// Date de création
  @override
  final DateTime? createdAt;

  /// Date de dernière mise à jour
  @override
  final DateTime? updatedAt;

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
    return 'GardenContext(gardenId: $gardenId, name: $name, description: $description, location: $location, climate: $climate, soil: $soil, activePlantIds: $activePlantIds, historicalPlantIds: $historicalPlantIds, stats: $stats, preferences: $preferences, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GardenContextImpl &&
            (identical(other.gardenId, gardenId) ||
                other.gardenId == gardenId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.climate, climate) || other.climate == climate) &&
            (identical(other.soil, soil) || other.soil == soil) &&
            const DeepCollectionEquality()
                .equals(other._activePlantIds, _activePlantIds) &&
            const DeepCollectionEquality()
                .equals(other._historicalPlantIds, _historicalPlantIds) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences) &&
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
      climate,
      soil,
      const DeepCollectionEquality().hash(_activePlantIds),
      const DeepCollectionEquality().hash(_historicalPlantIds),
      stats,
      preferences,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GardenContextImplCopyWith<_$GardenContextImpl> get copyWith =>
      __$$GardenContextImplCopyWithImpl<_$GardenContextImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GardenContextImplToJson(
      this,
    );
  }
}

abstract class _GardenContext implements GardenContext {
  const factory _GardenContext(
      {required final String gardenId,
      required final String name,
      final String? description,
      required final GardenLocation location,
      required final ClimateConditions climate,
      required final SoilInfo soil,
      required final List<String> activePlantIds,
      required final List<String> historicalPlantIds,
      required final GardenStats stats,
      required final CultivationPreferences preferences,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final Map<String, dynamic> metadata}) = _$GardenContextImpl;

  factory _GardenContext.fromJson(Map<String, dynamic> json) =
      _$GardenContextImpl.fromJson;

  @override

  /// Identifiant unique du jardin
  String get gardenId;
  @override

  /// Nom du jardin
  String get name;
  @override

  /// Description du jardin
  String? get description;
  @override

  /// Emplacement du jardin
  GardenLocation get location;
  @override

  /// Conditions climatiques générales
  ClimateConditions get climate;
  @override

  /// Informations sur le sol
  SoilInfo get soil;
  @override

  /// Plantes actuellement dans le jardin
  List<String> get activePlantIds;
  @override

  /// Historique des plantations
  List<String> get historicalPlantIds;
  @override

  /// Statistiques du jardin
  GardenStats get stats;
  @override

  /// Préférences de culture
  CultivationPreferences get preferences;
  @override

  /// Date de création
  DateTime? get createdAt;
  @override

  /// Date de dernière mise à jour
  DateTime? get updatedAt;
  @override

  /// Métadonnées additionnelles
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$GardenContextImplCopyWith<_$GardenContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GardenLocation _$GardenLocationFromJson(Map<String, dynamic> json) {
  return _GardenLocation.fromJson(json);
}

/// @nodoc
mixin _$GardenLocation {
  /// Latitude
  double get latitude => throw _privateConstructorUsedError;

  /// Longitude
  double get longitude => throw _privateConstructorUsedError;

  /// Adresse ou description de l'emplacement
  String? get address => throw _privateConstructorUsedError;

  /// Ville
  String? get city => throw _privateConstructorUsedError;

  /// Code postal
  String? get postalCode => throw _privateConstructorUsedError;

  /// Pays
  String? get country => throw _privateConstructorUsedError;

  /// Zone climatique USDA
  String? get usdaZone => throw _privateConstructorUsedError;

  /// Altitude (en mètres)
  double? get altitude => throw _privateConstructorUsedError;

  /// Exposition générale (N, S, E, O, etc.)
  String? get exposure => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GardenLocationCopyWith<GardenLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GardenLocationCopyWith<$Res> {
  factory $GardenLocationCopyWith(
          GardenLocation value, $Res Function(GardenLocation) then) =
      _$GardenLocationCopyWithImpl<$Res, GardenLocation>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      String? address,
      String? city,
      String? postalCode,
      String? country,
      String? usdaZone,
      double? altitude,
      String? exposure});
}

/// @nodoc
class _$GardenLocationCopyWithImpl<$Res, $Val extends GardenLocation>
    implements $GardenLocationCopyWith<$Res> {
  _$GardenLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? usdaZone = freezed,
    Object? altitude = freezed,
    Object? exposure = freezed,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      usdaZone: freezed == usdaZone
          ? _value.usdaZone
          : usdaZone // ignore: cast_nullable_to_non_nullable
              as String?,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double?,
      exposure: freezed == exposure
          ? _value.exposure
          : exposure // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GardenLocationImplCopyWith<$Res>
    implements $GardenLocationCopyWith<$Res> {
  factory _$$GardenLocationImplCopyWith(_$GardenLocationImpl value,
          $Res Function(_$GardenLocationImpl) then) =
      __$$GardenLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      String? address,
      String? city,
      String? postalCode,
      String? country,
      String? usdaZone,
      double? altitude,
      String? exposure});
}

/// @nodoc
class __$$GardenLocationImplCopyWithImpl<$Res>
    extends _$GardenLocationCopyWithImpl<$Res, _$GardenLocationImpl>
    implements _$$GardenLocationImplCopyWith<$Res> {
  __$$GardenLocationImplCopyWithImpl(
      _$GardenLocationImpl _value, $Res Function(_$GardenLocationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? usdaZone = freezed,
    Object? altitude = freezed,
    Object? exposure = freezed,
  }) {
    return _then(_$GardenLocationImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      usdaZone: freezed == usdaZone
          ? _value.usdaZone
          : usdaZone // ignore: cast_nullable_to_non_nullable
              as String?,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double?,
      exposure: freezed == exposure
          ? _value.exposure
          : exposure // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GardenLocationImpl implements _GardenLocation {
  const _$GardenLocationImpl(
      {required this.latitude,
      required this.longitude,
      this.address,
      this.city,
      this.postalCode,
      this.country,
      this.usdaZone,
      this.altitude,
      this.exposure});

  factory _$GardenLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$GardenLocationImplFromJson(json);

  /// Latitude
  @override
  final double latitude;

  /// Longitude
  @override
  final double longitude;

  /// Adresse ou description de l'emplacement
  @override
  final String? address;

  /// Ville
  @override
  final String? city;

  /// Code postal
  @override
  final String? postalCode;

  /// Pays
  @override
  final String? country;

  /// Zone climatique USDA
  @override
  final String? usdaZone;

  /// Altitude (en mètres)
  @override
  final double? altitude;

  /// Exposition générale (N, S, E, O, etc.)
  @override
  final String? exposure;

  @override
  String toString() {
    return 'GardenLocation(latitude: $latitude, longitude: $longitude, address: $address, city: $city, postalCode: $postalCode, country: $country, usdaZone: $usdaZone, altitude: $altitude, exposure: $exposure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GardenLocationImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.usdaZone, usdaZone) ||
                other.usdaZone == usdaZone) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.exposure, exposure) ||
                other.exposure == exposure));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude, address,
      city, postalCode, country, usdaZone, altitude, exposure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GardenLocationImplCopyWith<_$GardenLocationImpl> get copyWith =>
      __$$GardenLocationImplCopyWithImpl<_$GardenLocationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GardenLocationImplToJson(
      this,
    );
  }
}

abstract class _GardenLocation implements GardenLocation {
  const factory _GardenLocation(
      {required final double latitude,
      required final double longitude,
      final String? address,
      final String? city,
      final String? postalCode,
      final String? country,
      final String? usdaZone,
      final double? altitude,
      final String? exposure}) = _$GardenLocationImpl;

  factory _GardenLocation.fromJson(Map<String, dynamic> json) =
      _$GardenLocationImpl.fromJson;

  @override

  /// Latitude
  double get latitude;
  @override

  /// Longitude
  double get longitude;
  @override

  /// Adresse ou description de l'emplacement
  String? get address;
  @override

  /// Ville
  String? get city;
  @override

  /// Code postal
  String? get postalCode;
  @override

  /// Pays
  String? get country;
  @override

  /// Zone climatique USDA
  String? get usdaZone;
  @override

  /// Altitude (en mètres)
  double? get altitude;
  @override

  /// Exposition générale (N, S, E, O, etc.)
  String? get exposure;
  @override
  @JsonKey(ignore: true)
  _$$GardenLocationImplCopyWith<_$GardenLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClimateConditions _$ClimateConditionsFromJson(Map<String, dynamic> json) {
  return _ClimateConditions.fromJson(json);
}

/// @nodoc
mixin _$ClimateConditions {
  /// Température moyenne annuelle (°C)
  double get averageTemperature => throw _privateConstructorUsedError;

  /// Température minimale enregistrée (°C)
  double get minTemperature => throw _privateConstructorUsedError;

  /// Température maximale enregistrée (°C)
  double get maxTemperature => throw _privateConstructorUsedError;

  /// Précipitations annuelles moyennes (mm)
  double get averagePrecipitation => throw _privateConstructorUsedError;

  /// Humidité moyenne (%)
  double get averageHumidity => throw _privateConstructorUsedError;

  /// Nombre de jours de gel par an
  int get frostDays => throw _privateConstructorUsedError;

  /// Saison de croissance (en jours)
  int get growingSeasonLength => throw _privateConstructorUsedError;

  /// Vent dominant (direction)
  String? get dominantWindDirection => throw _privateConstructorUsedError;

  /// Vitesse moyenne du vent (km/h)
  double? get averageWindSpeed => throw _privateConstructorUsedError;

  /// Nombre d'heures d'ensoleillement par jour
  double? get averageSunshineHours => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClimateConditionsCopyWith<ClimateConditions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClimateConditionsCopyWith<$Res> {
  factory $ClimateConditionsCopyWith(
          ClimateConditions value, $Res Function(ClimateConditions) then) =
      _$ClimateConditionsCopyWithImpl<$Res, ClimateConditions>;
  @useResult
  $Res call(
      {double averageTemperature,
      double minTemperature,
      double maxTemperature,
      double averagePrecipitation,
      double averageHumidity,
      int frostDays,
      int growingSeasonLength,
      String? dominantWindDirection,
      double? averageWindSpeed,
      double? averageSunshineHours});
}

/// @nodoc
class _$ClimateConditionsCopyWithImpl<$Res, $Val extends ClimateConditions>
    implements $ClimateConditionsCopyWith<$Res> {
  _$ClimateConditionsCopyWithImpl(this._value, this._then);

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
    Object? dominantWindDirection = freezed,
    Object? averageWindSpeed = freezed,
    Object? averageSunshineHours = freezed,
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
      dominantWindDirection: freezed == dominantWindDirection
          ? _value.dominantWindDirection
          : dominantWindDirection // ignore: cast_nullable_to_non_nullable
              as String?,
      averageWindSpeed: freezed == averageWindSpeed
          ? _value.averageWindSpeed
          : averageWindSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      averageSunshineHours: freezed == averageSunshineHours
          ? _value.averageSunshineHours
          : averageSunshineHours // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClimateConditionsImplCopyWith<$Res>
    implements $ClimateConditionsCopyWith<$Res> {
  factory _$$ClimateConditionsImplCopyWith(_$ClimateConditionsImpl value,
          $Res Function(_$ClimateConditionsImpl) then) =
      __$$ClimateConditionsImplCopyWithImpl<$Res>;
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
      String? dominantWindDirection,
      double? averageWindSpeed,
      double? averageSunshineHours});
}

/// @nodoc
class __$$ClimateConditionsImplCopyWithImpl<$Res>
    extends _$ClimateConditionsCopyWithImpl<$Res, _$ClimateConditionsImpl>
    implements _$$ClimateConditionsImplCopyWith<$Res> {
  __$$ClimateConditionsImplCopyWithImpl(_$ClimateConditionsImpl _value,
      $Res Function(_$ClimateConditionsImpl) _then)
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
    Object? dominantWindDirection = freezed,
    Object? averageWindSpeed = freezed,
    Object? averageSunshineHours = freezed,
  }) {
    return _then(_$ClimateConditionsImpl(
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
      dominantWindDirection: freezed == dominantWindDirection
          ? _value.dominantWindDirection
          : dominantWindDirection // ignore: cast_nullable_to_non_nullable
              as String?,
      averageWindSpeed: freezed == averageWindSpeed
          ? _value.averageWindSpeed
          : averageWindSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      averageSunshineHours: freezed == averageSunshineHours
          ? _value.averageSunshineHours
          : averageSunshineHours // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClimateConditionsImpl implements _ClimateConditions {
  const _$ClimateConditionsImpl(
      {required this.averageTemperature,
      required this.minTemperature,
      required this.maxTemperature,
      required this.averagePrecipitation,
      required this.averageHumidity,
      required this.frostDays,
      required this.growingSeasonLength,
      this.dominantWindDirection,
      this.averageWindSpeed,
      this.averageSunshineHours});

  factory _$ClimateConditionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClimateConditionsImplFromJson(json);

  /// Température moyenne annuelle (°C)
  @override
  final double averageTemperature;

  /// Température minimale enregistrée (°C)
  @override
  final double minTemperature;

  /// Température maximale enregistrée (°C)
  @override
  final double maxTemperature;

  /// Précipitations annuelles moyennes (mm)
  @override
  final double averagePrecipitation;

  /// Humidité moyenne (%)
  @override
  final double averageHumidity;

  /// Nombre de jours de gel par an
  @override
  final int frostDays;

  /// Saison de croissance (en jours)
  @override
  final int growingSeasonLength;

  /// Vent dominant (direction)
  @override
  final String? dominantWindDirection;

  /// Vitesse moyenne du vent (km/h)
  @override
  final double? averageWindSpeed;

  /// Nombre d'heures d'ensoleillement par jour
  @override
  final double? averageSunshineHours;

  @override
  String toString() {
    return 'ClimateConditions(averageTemperature: $averageTemperature, minTemperature: $minTemperature, maxTemperature: $maxTemperature, averagePrecipitation: $averagePrecipitation, averageHumidity: $averageHumidity, frostDays: $frostDays, growingSeasonLength: $growingSeasonLength, dominantWindDirection: $dominantWindDirection, averageWindSpeed: $averageWindSpeed, averageSunshineHours: $averageSunshineHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClimateConditionsImpl &&
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
                other.averageSunshineHours == averageSunshineHours));
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
      averageSunshineHours);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClimateConditionsImplCopyWith<_$ClimateConditionsImpl> get copyWith =>
      __$$ClimateConditionsImplCopyWithImpl<_$ClimateConditionsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClimateConditionsImplToJson(
      this,
    );
  }
}

abstract class _ClimateConditions implements ClimateConditions {
  const factory _ClimateConditions(
      {required final double averageTemperature,
      required final double minTemperature,
      required final double maxTemperature,
      required final double averagePrecipitation,
      required final double averageHumidity,
      required final int frostDays,
      required final int growingSeasonLength,
      final String? dominantWindDirection,
      final double? averageWindSpeed,
      final double? averageSunshineHours}) = _$ClimateConditionsImpl;

  factory _ClimateConditions.fromJson(Map<String, dynamic> json) =
      _$ClimateConditionsImpl.fromJson;

  @override

  /// Température moyenne annuelle (°C)
  double get averageTemperature;
  @override

  /// Température minimale enregistrée (°C)
  double get minTemperature;
  @override

  /// Température maximale enregistrée (°C)
  double get maxTemperature;
  @override

  /// Précipitations annuelles moyennes (mm)
  double get averagePrecipitation;
  @override

  /// Humidité moyenne (%)
  double get averageHumidity;
  @override

  /// Nombre de jours de gel par an
  int get frostDays;
  @override

  /// Saison de croissance (en jours)
  int get growingSeasonLength;
  @override

  /// Vent dominant (direction)
  String? get dominantWindDirection;
  @override

  /// Vitesse moyenne du vent (km/h)
  double? get averageWindSpeed;
  @override

  /// Nombre d'heures d'ensoleillement par jour
  double? get averageSunshineHours;
  @override
  @JsonKey(ignore: true)
  _$$ClimateConditionsImplCopyWith<_$ClimateConditionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SoilInfo _$SoilInfoFromJson(Map<String, dynamic> json) {
  return _SoilInfo.fromJson(json);
}

/// @nodoc
mixin _$SoilInfo {
  /// Type de sol
  SoilType get type => throw _privateConstructorUsedError;

  /// pH du sol
  double get ph => throw _privateConstructorUsedError;

  /// Texture du sol
  SoilTexture get texture => throw _privateConstructorUsedError;

  /// Teneur en matière organique (%)
  double get organicMatter => throw _privateConstructorUsedError;

  /// Capacité de rétention d'eau (%)
  double get waterRetention => throw _privateConstructorUsedError;

  /// Drainage du sol
  SoilDrainage get drainage => throw _privateConstructorUsedError;

  /// Profondeur du sol (cm)
  double get depth => throw _privateConstructorUsedError;

  /// Teneur en nutriments
  NutrientLevels get nutrients => throw _privateConstructorUsedError;

  /// Activité biologique
  BiologicalActivity get biologicalActivity =>
      throw _privateConstructorUsedError;

  /// Contamination éventuelle
  List<String>? get contaminants => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SoilInfoCopyWith<SoilInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoilInfoCopyWith<$Res> {
  factory $SoilInfoCopyWith(SoilInfo value, $Res Function(SoilInfo) then) =
      _$SoilInfoCopyWithImpl<$Res, SoilInfo>;
  @useResult
  $Res call(
      {SoilType type,
      double ph,
      SoilTexture texture,
      double organicMatter,
      double waterRetention,
      SoilDrainage drainage,
      double depth,
      NutrientLevels nutrients,
      BiologicalActivity biologicalActivity,
      List<String>? contaminants});

  $NutrientLevelsCopyWith<$Res> get nutrients;
}

/// @nodoc
class _$SoilInfoCopyWithImpl<$Res, $Val extends SoilInfo>
    implements $SoilInfoCopyWith<$Res> {
  _$SoilInfoCopyWithImpl(this._value, this._then);

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
    Object? biologicalActivity = null,
    Object? contaminants = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SoilType,
      ph: null == ph
          ? _value.ph
          : ph // ignore: cast_nullable_to_non_nullable
              as double,
      texture: null == texture
          ? _value.texture
          : texture // ignore: cast_nullable_to_non_nullable
              as SoilTexture,
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
              as SoilDrainage,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double,
      nutrients: null == nutrients
          ? _value.nutrients
          : nutrients // ignore: cast_nullable_to_non_nullable
              as NutrientLevels,
      biologicalActivity: null == biologicalActivity
          ? _value.biologicalActivity
          : biologicalActivity // ignore: cast_nullable_to_non_nullable
              as BiologicalActivity,
      contaminants: freezed == contaminants
          ? _value.contaminants
          : contaminants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NutrientLevelsCopyWith<$Res> get nutrients {
    return $NutrientLevelsCopyWith<$Res>(_value.nutrients, (value) {
      return _then(_value.copyWith(nutrients: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SoilInfoImplCopyWith<$Res>
    implements $SoilInfoCopyWith<$Res> {
  factory _$$SoilInfoImplCopyWith(
          _$SoilInfoImpl value, $Res Function(_$SoilInfoImpl) then) =
      __$$SoilInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SoilType type,
      double ph,
      SoilTexture texture,
      double organicMatter,
      double waterRetention,
      SoilDrainage drainage,
      double depth,
      NutrientLevels nutrients,
      BiologicalActivity biologicalActivity,
      List<String>? contaminants});

  @override
  $NutrientLevelsCopyWith<$Res> get nutrients;
}

/// @nodoc
class __$$SoilInfoImplCopyWithImpl<$Res>
    extends _$SoilInfoCopyWithImpl<$Res, _$SoilInfoImpl>
    implements _$$SoilInfoImplCopyWith<$Res> {
  __$$SoilInfoImplCopyWithImpl(
      _$SoilInfoImpl _value, $Res Function(_$SoilInfoImpl) _then)
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
    Object? biologicalActivity = null,
    Object? contaminants = freezed,
  }) {
    return _then(_$SoilInfoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SoilType,
      ph: null == ph
          ? _value.ph
          : ph // ignore: cast_nullable_to_non_nullable
              as double,
      texture: null == texture
          ? _value.texture
          : texture // ignore: cast_nullable_to_non_nullable
              as SoilTexture,
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
              as SoilDrainage,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double,
      nutrients: null == nutrients
          ? _value.nutrients
          : nutrients // ignore: cast_nullable_to_non_nullable
              as NutrientLevels,
      biologicalActivity: null == biologicalActivity
          ? _value.biologicalActivity
          : biologicalActivity // ignore: cast_nullable_to_non_nullable
              as BiologicalActivity,
      contaminants: freezed == contaminants
          ? _value._contaminants
          : contaminants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SoilInfoImpl implements _SoilInfo {
  const _$SoilInfoImpl(
      {required this.type,
      required this.ph,
      required this.texture,
      required this.organicMatter,
      required this.waterRetention,
      required this.drainage,
      required this.depth,
      required this.nutrients,
      required this.biologicalActivity,
      final List<String>? contaminants})
      : _contaminants = contaminants;

  factory _$SoilInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SoilInfoImplFromJson(json);

  /// Type de sol
  @override
  final SoilType type;

  /// pH du sol
  @override
  final double ph;

  /// Texture du sol
  @override
  final SoilTexture texture;

  /// Teneur en matière organique (%)
  @override
  final double organicMatter;

  /// Capacité de rétention d'eau (%)
  @override
  final double waterRetention;

  /// Drainage du sol
  @override
  final SoilDrainage drainage;

  /// Profondeur du sol (cm)
  @override
  final double depth;

  /// Teneur en nutriments
  @override
  final NutrientLevels nutrients;

  /// Activité biologique
  @override
  final BiologicalActivity biologicalActivity;

  /// Contamination éventuelle
  final List<String>? _contaminants;

  /// Contamination éventuelle
  @override
  List<String>? get contaminants {
    final value = _contaminants;
    if (value == null) return null;
    if (_contaminants is EqualUnmodifiableListView) return _contaminants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SoilInfo(type: $type, ph: $ph, texture: $texture, organicMatter: $organicMatter, waterRetention: $waterRetention, drainage: $drainage, depth: $depth, nutrients: $nutrients, biologicalActivity: $biologicalActivity, contaminants: $contaminants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SoilInfoImpl &&
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
            (identical(other.nutrients, nutrients) ||
                other.nutrients == nutrients) &&
            (identical(other.biologicalActivity, biologicalActivity) ||
                other.biologicalActivity == biologicalActivity) &&
            const DeepCollectionEquality()
                .equals(other._contaminants, _contaminants));
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
      nutrients,
      biologicalActivity,
      const DeepCollectionEquality().hash(_contaminants));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SoilInfoImplCopyWith<_$SoilInfoImpl> get copyWith =>
      __$$SoilInfoImplCopyWithImpl<_$SoilInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SoilInfoImplToJson(
      this,
    );
  }
}

abstract class _SoilInfo implements SoilInfo {
  const factory _SoilInfo(
      {required final SoilType type,
      required final double ph,
      required final SoilTexture texture,
      required final double organicMatter,
      required final double waterRetention,
      required final SoilDrainage drainage,
      required final double depth,
      required final NutrientLevels nutrients,
      required final BiologicalActivity biologicalActivity,
      final List<String>? contaminants}) = _$SoilInfoImpl;

  factory _SoilInfo.fromJson(Map<String, dynamic> json) =
      _$SoilInfoImpl.fromJson;

  @override

  /// Type de sol
  SoilType get type;
  @override

  /// pH du sol
  double get ph;
  @override

  /// Texture du sol
  SoilTexture get texture;
  @override

  /// Teneur en matière organique (%)
  double get organicMatter;
  @override

  /// Capacité de rétention d'eau (%)
  double get waterRetention;
  @override

  /// Drainage du sol
  SoilDrainage get drainage;
  @override

  /// Profondeur du sol (cm)
  double get depth;
  @override

  /// Teneur en nutriments
  NutrientLevels get nutrients;
  @override

  /// Activité biologique
  BiologicalActivity get biologicalActivity;
  @override

  /// Contamination éventuelle
  List<String>? get contaminants;
  @override
  @JsonKey(ignore: true)
  _$$SoilInfoImplCopyWith<_$SoilInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutrientLevels _$NutrientLevelsFromJson(Map<String, dynamic> json) {
  return _NutrientLevels.fromJson(json);
}

/// @nodoc
mixin _$NutrientLevels {
  /// Azote (N)
  NutrientLevel get nitrogen => throw _privateConstructorUsedError;

  /// Phosphore (P)
  NutrientLevel get phosphorus => throw _privateConstructorUsedError;

  /// Potassium (K)
  NutrientLevel get potassium => throw _privateConstructorUsedError;

  /// Calcium (Ca)
  NutrientLevel get calcium => throw _privateConstructorUsedError;

  /// Magnésium (Mg)
  NutrientLevel get magnesium => throw _privateConstructorUsedError;

  /// Soufre (S)
  NutrientLevel get sulfur => throw _privateConstructorUsedError;

  /// Micronutriments
  Map<String, NutrientLevel> get micronutrients =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NutrientLevelsCopyWith<NutrientLevels> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutrientLevelsCopyWith<$Res> {
  factory $NutrientLevelsCopyWith(
          NutrientLevels value, $Res Function(NutrientLevels) then) =
      _$NutrientLevelsCopyWithImpl<$Res, NutrientLevels>;
  @useResult
  $Res call(
      {NutrientLevel nitrogen,
      NutrientLevel phosphorus,
      NutrientLevel potassium,
      NutrientLevel calcium,
      NutrientLevel magnesium,
      NutrientLevel sulfur,
      Map<String, NutrientLevel> micronutrients});
}

/// @nodoc
class _$NutrientLevelsCopyWithImpl<$Res, $Val extends NutrientLevels>
    implements $NutrientLevelsCopyWith<$Res> {
  _$NutrientLevelsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nitrogen = null,
    Object? phosphorus = null,
    Object? potassium = null,
    Object? calcium = null,
    Object? magnesium = null,
    Object? sulfur = null,
    Object? micronutrients = null,
  }) {
    return _then(_value.copyWith(
      nitrogen: null == nitrogen
          ? _value.nitrogen
          : nitrogen // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      phosphorus: null == phosphorus
          ? _value.phosphorus
          : phosphorus // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      potassium: null == potassium
          ? _value.potassium
          : potassium // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      calcium: null == calcium
          ? _value.calcium
          : calcium // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      magnesium: null == magnesium
          ? _value.magnesium
          : magnesium // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      sulfur: null == sulfur
          ? _value.sulfur
          : sulfur // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      micronutrients: null == micronutrients
          ? _value.micronutrients
          : micronutrients // ignore: cast_nullable_to_non_nullable
              as Map<String, NutrientLevel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutrientLevelsImplCopyWith<$Res>
    implements $NutrientLevelsCopyWith<$Res> {
  factory _$$NutrientLevelsImplCopyWith(_$NutrientLevelsImpl value,
          $Res Function(_$NutrientLevelsImpl) then) =
      __$$NutrientLevelsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NutrientLevel nitrogen,
      NutrientLevel phosphorus,
      NutrientLevel potassium,
      NutrientLevel calcium,
      NutrientLevel magnesium,
      NutrientLevel sulfur,
      Map<String, NutrientLevel> micronutrients});
}

/// @nodoc
class __$$NutrientLevelsImplCopyWithImpl<$Res>
    extends _$NutrientLevelsCopyWithImpl<$Res, _$NutrientLevelsImpl>
    implements _$$NutrientLevelsImplCopyWith<$Res> {
  __$$NutrientLevelsImplCopyWithImpl(
      _$NutrientLevelsImpl _value, $Res Function(_$NutrientLevelsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nitrogen = null,
    Object? phosphorus = null,
    Object? potassium = null,
    Object? calcium = null,
    Object? magnesium = null,
    Object? sulfur = null,
    Object? micronutrients = null,
  }) {
    return _then(_$NutrientLevelsImpl(
      nitrogen: null == nitrogen
          ? _value.nitrogen
          : nitrogen // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      phosphorus: null == phosphorus
          ? _value.phosphorus
          : phosphorus // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      potassium: null == potassium
          ? _value.potassium
          : potassium // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      calcium: null == calcium
          ? _value.calcium
          : calcium // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      magnesium: null == magnesium
          ? _value.magnesium
          : magnesium // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      sulfur: null == sulfur
          ? _value.sulfur
          : sulfur // ignore: cast_nullable_to_non_nullable
              as NutrientLevel,
      micronutrients: null == micronutrients
          ? _value._micronutrients
          : micronutrients // ignore: cast_nullable_to_non_nullable
              as Map<String, NutrientLevel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutrientLevelsImpl implements _NutrientLevels {
  const _$NutrientLevelsImpl(
      {required this.nitrogen,
      required this.phosphorus,
      required this.potassium,
      required this.calcium,
      required this.magnesium,
      required this.sulfur,
      final Map<String, NutrientLevel> micronutrients = const {}})
      : _micronutrients = micronutrients;

  factory _$NutrientLevelsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutrientLevelsImplFromJson(json);

  /// Azote (N)
  @override
  final NutrientLevel nitrogen;

  /// Phosphore (P)
  @override
  final NutrientLevel phosphorus;

  /// Potassium (K)
  @override
  final NutrientLevel potassium;

  /// Calcium (Ca)
  @override
  final NutrientLevel calcium;

  /// Magnésium (Mg)
  @override
  final NutrientLevel magnesium;

  /// Soufre (S)
  @override
  final NutrientLevel sulfur;

  /// Micronutriments
  final Map<String, NutrientLevel> _micronutrients;

  /// Micronutriments
  @override
  @JsonKey()
  Map<String, NutrientLevel> get micronutrients {
    if (_micronutrients is EqualUnmodifiableMapView) return _micronutrients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_micronutrients);
  }

  @override
  String toString() {
    return 'NutrientLevels(nitrogen: $nitrogen, phosphorus: $phosphorus, potassium: $potassium, calcium: $calcium, magnesium: $magnesium, sulfur: $sulfur, micronutrients: $micronutrients)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutrientLevelsImpl &&
            (identical(other.nitrogen, nitrogen) ||
                other.nitrogen == nitrogen) &&
            (identical(other.phosphorus, phosphorus) ||
                other.phosphorus == phosphorus) &&
            (identical(other.potassium, potassium) ||
                other.potassium == potassium) &&
            (identical(other.calcium, calcium) || other.calcium == calcium) &&
            (identical(other.magnesium, magnesium) ||
                other.magnesium == magnesium) &&
            (identical(other.sulfur, sulfur) || other.sulfur == sulfur) &&
            const DeepCollectionEquality()
                .equals(other._micronutrients, _micronutrients));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      nitrogen,
      phosphorus,
      potassium,
      calcium,
      magnesium,
      sulfur,
      const DeepCollectionEquality().hash(_micronutrients));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NutrientLevelsImplCopyWith<_$NutrientLevelsImpl> get copyWith =>
      __$$NutrientLevelsImplCopyWithImpl<_$NutrientLevelsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NutrientLevelsImplToJson(
      this,
    );
  }
}

abstract class _NutrientLevels implements NutrientLevels {
  const factory _NutrientLevels(
      {required final NutrientLevel nitrogen,
      required final NutrientLevel phosphorus,
      required final NutrientLevel potassium,
      required final NutrientLevel calcium,
      required final NutrientLevel magnesium,
      required final NutrientLevel sulfur,
      final Map<String, NutrientLevel> micronutrients}) = _$NutrientLevelsImpl;

  factory _NutrientLevels.fromJson(Map<String, dynamic> json) =
      _$NutrientLevelsImpl.fromJson;

  @override

  /// Azote (N)
  NutrientLevel get nitrogen;
  @override

  /// Phosphore (P)
  NutrientLevel get phosphorus;
  @override

  /// Potassium (K)
  NutrientLevel get potassium;
  @override

  /// Calcium (Ca)
  NutrientLevel get calcium;
  @override

  /// Magnésium (Mg)
  NutrientLevel get magnesium;
  @override

  /// Soufre (S)
  NutrientLevel get sulfur;
  @override

  /// Micronutriments
  Map<String, NutrientLevel> get micronutrients;
  @override
  @JsonKey(ignore: true)
  _$$NutrientLevelsImplCopyWith<_$NutrientLevelsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GardenStats _$GardenStatsFromJson(Map<String, dynamic> json) {
  return _GardenStats.fromJson(json);
}

/// @nodoc
mixin _$GardenStats {
  /// Nombre total de plantes
  int get totalPlants => throw _privateConstructorUsedError;

  /// Nombre de plantes actives
  int get activePlants => throw _privateConstructorUsedError;

  /// Surface totale cultivée (m²)
  double get totalArea => throw _privateConstructorUsedError;

  /// Surface cultivée actuellement (m²)
  double get activeArea => throw _privateConstructorUsedError;

  /// Rendement total (kg)
  double get totalYield => throw _privateConstructorUsedError;

  /// Rendement de l'année courante (kg)
  double get currentYearYield => throw _privateConstructorUsedError;

  /// Nombre de récoltes cette année
  int get harvestsThisYear => throw _privateConstructorUsedError;

  /// Nombre de plantations cette année
  int get plantingsThisYear => throw _privateConstructorUsedError;

  /// Taux de réussite (%)
  double get successRate => throw _privateConstructorUsedError;

  /// Coût total des intrants (€)
  double get totalInputCosts => throw _privateConstructorUsedError;

  /// Valeur totale des récoltes (€)
  double get totalHarvestValue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GardenStatsCopyWith<GardenStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GardenStatsCopyWith<$Res> {
  factory $GardenStatsCopyWith(
          GardenStats value, $Res Function(GardenStats) then) =
      _$GardenStatsCopyWithImpl<$Res, GardenStats>;
  @useResult
  $Res call(
      {int totalPlants,
      int activePlants,
      double totalArea,
      double activeArea,
      double totalYield,
      double currentYearYield,
      int harvestsThisYear,
      int plantingsThisYear,
      double successRate,
      double totalInputCosts,
      double totalHarvestValue});
}

/// @nodoc
class _$GardenStatsCopyWithImpl<$Res, $Val extends GardenStats>
    implements $GardenStatsCopyWith<$Res> {
  _$GardenStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPlants = null,
    Object? activePlants = null,
    Object? totalArea = null,
    Object? activeArea = null,
    Object? totalYield = null,
    Object? currentYearYield = null,
    Object? harvestsThisYear = null,
    Object? plantingsThisYear = null,
    Object? successRate = null,
    Object? totalInputCosts = null,
    Object? totalHarvestValue = null,
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
      totalArea: null == totalArea
          ? _value.totalArea
          : totalArea // ignore: cast_nullable_to_non_nullable
              as double,
      activeArea: null == activeArea
          ? _value.activeArea
          : activeArea // ignore: cast_nullable_to_non_nullable
              as double,
      totalYield: null == totalYield
          ? _value.totalYield
          : totalYield // ignore: cast_nullable_to_non_nullable
              as double,
      currentYearYield: null == currentYearYield
          ? _value.currentYearYield
          : currentYearYield // ignore: cast_nullable_to_non_nullable
              as double,
      harvestsThisYear: null == harvestsThisYear
          ? _value.harvestsThisYear
          : harvestsThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      plantingsThisYear: null == plantingsThisYear
          ? _value.plantingsThisYear
          : plantingsThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalInputCosts: null == totalInputCosts
          ? _value.totalInputCosts
          : totalInputCosts // ignore: cast_nullable_to_non_nullable
              as double,
      totalHarvestValue: null == totalHarvestValue
          ? _value.totalHarvestValue
          : totalHarvestValue // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GardenStatsImplCopyWith<$Res>
    implements $GardenStatsCopyWith<$Res> {
  factory _$$GardenStatsImplCopyWith(
          _$GardenStatsImpl value, $Res Function(_$GardenStatsImpl) then) =
      __$$GardenStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalPlants,
      int activePlants,
      double totalArea,
      double activeArea,
      double totalYield,
      double currentYearYield,
      int harvestsThisYear,
      int plantingsThisYear,
      double successRate,
      double totalInputCosts,
      double totalHarvestValue});
}

/// @nodoc
class __$$GardenStatsImplCopyWithImpl<$Res>
    extends _$GardenStatsCopyWithImpl<$Res, _$GardenStatsImpl>
    implements _$$GardenStatsImplCopyWith<$Res> {
  __$$GardenStatsImplCopyWithImpl(
      _$GardenStatsImpl _value, $Res Function(_$GardenStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPlants = null,
    Object? activePlants = null,
    Object? totalArea = null,
    Object? activeArea = null,
    Object? totalYield = null,
    Object? currentYearYield = null,
    Object? harvestsThisYear = null,
    Object? plantingsThisYear = null,
    Object? successRate = null,
    Object? totalInputCosts = null,
    Object? totalHarvestValue = null,
  }) {
    return _then(_$GardenStatsImpl(
      totalPlants: null == totalPlants
          ? _value.totalPlants
          : totalPlants // ignore: cast_nullable_to_non_nullable
              as int,
      activePlants: null == activePlants
          ? _value.activePlants
          : activePlants // ignore: cast_nullable_to_non_nullable
              as int,
      totalArea: null == totalArea
          ? _value.totalArea
          : totalArea // ignore: cast_nullable_to_non_nullable
              as double,
      activeArea: null == activeArea
          ? _value.activeArea
          : activeArea // ignore: cast_nullable_to_non_nullable
              as double,
      totalYield: null == totalYield
          ? _value.totalYield
          : totalYield // ignore: cast_nullable_to_non_nullable
              as double,
      currentYearYield: null == currentYearYield
          ? _value.currentYearYield
          : currentYearYield // ignore: cast_nullable_to_non_nullable
              as double,
      harvestsThisYear: null == harvestsThisYear
          ? _value.harvestsThisYear
          : harvestsThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      plantingsThisYear: null == plantingsThisYear
          ? _value.plantingsThisYear
          : plantingsThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalInputCosts: null == totalInputCosts
          ? _value.totalInputCosts
          : totalInputCosts // ignore: cast_nullable_to_non_nullable
              as double,
      totalHarvestValue: null == totalHarvestValue
          ? _value.totalHarvestValue
          : totalHarvestValue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GardenStatsImpl implements _GardenStats {
  const _$GardenStatsImpl(
      {required this.totalPlants,
      required this.activePlants,
      required this.totalArea,
      required this.activeArea,
      required this.totalYield,
      required this.currentYearYield,
      required this.harvestsThisYear,
      required this.plantingsThisYear,
      required this.successRate,
      required this.totalInputCosts,
      required this.totalHarvestValue});

  factory _$GardenStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GardenStatsImplFromJson(json);

  /// Nombre total de plantes
  @override
  final int totalPlants;

  /// Nombre de plantes actives
  @override
  final int activePlants;

  /// Surface totale cultivée (m²)
  @override
  final double totalArea;

  /// Surface cultivée actuellement (m²)
  @override
  final double activeArea;

  /// Rendement total (kg)
  @override
  final double totalYield;

  /// Rendement de l'année courante (kg)
  @override
  final double currentYearYield;

  /// Nombre de récoltes cette année
  @override
  final int harvestsThisYear;

  /// Nombre de plantations cette année
  @override
  final int plantingsThisYear;

  /// Taux de réussite (%)
  @override
  final double successRate;

  /// Coût total des intrants (€)
  @override
  final double totalInputCosts;

  /// Valeur totale des récoltes (€)
  @override
  final double totalHarvestValue;

  @override
  String toString() {
    return 'GardenStats(totalPlants: $totalPlants, activePlants: $activePlants, totalArea: $totalArea, activeArea: $activeArea, totalYield: $totalYield, currentYearYield: $currentYearYield, harvestsThisYear: $harvestsThisYear, plantingsThisYear: $plantingsThisYear, successRate: $successRate, totalInputCosts: $totalInputCosts, totalHarvestValue: $totalHarvestValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GardenStatsImpl &&
            (identical(other.totalPlants, totalPlants) ||
                other.totalPlants == totalPlants) &&
            (identical(other.activePlants, activePlants) ||
                other.activePlants == activePlants) &&
            (identical(other.totalArea, totalArea) ||
                other.totalArea == totalArea) &&
            (identical(other.activeArea, activeArea) ||
                other.activeArea == activeArea) &&
            (identical(other.totalYield, totalYield) ||
                other.totalYield == totalYield) &&
            (identical(other.currentYearYield, currentYearYield) ||
                other.currentYearYield == currentYearYield) &&
            (identical(other.harvestsThisYear, harvestsThisYear) ||
                other.harvestsThisYear == harvestsThisYear) &&
            (identical(other.plantingsThisYear, plantingsThisYear) ||
                other.plantingsThisYear == plantingsThisYear) &&
            (identical(other.successRate, successRate) ||
                other.successRate == successRate) &&
            (identical(other.totalInputCosts, totalInputCosts) ||
                other.totalInputCosts == totalInputCosts) &&
            (identical(other.totalHarvestValue, totalHarvestValue) ||
                other.totalHarvestValue == totalHarvestValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalPlants,
      activePlants,
      totalArea,
      activeArea,
      totalYield,
      currentYearYield,
      harvestsThisYear,
      plantingsThisYear,
      successRate,
      totalInputCosts,
      totalHarvestValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GardenStatsImplCopyWith<_$GardenStatsImpl> get copyWith =>
      __$$GardenStatsImplCopyWithImpl<_$GardenStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GardenStatsImplToJson(
      this,
    );
  }
}

abstract class _GardenStats implements GardenStats {
  const factory _GardenStats(
      {required final int totalPlants,
      required final int activePlants,
      required final double totalArea,
      required final double activeArea,
      required final double totalYield,
      required final double currentYearYield,
      required final int harvestsThisYear,
      required final int plantingsThisYear,
      required final double successRate,
      required final double totalInputCosts,
      required final double totalHarvestValue}) = _$GardenStatsImpl;

  factory _GardenStats.fromJson(Map<String, dynamic> json) =
      _$GardenStatsImpl.fromJson;

  @override

  /// Nombre total de plantes
  int get totalPlants;
  @override

  /// Nombre de plantes actives
  int get activePlants;
  @override

  /// Surface totale cultivée (m²)
  double get totalArea;
  @override

  /// Surface cultivée actuellement (m²)
  double get activeArea;
  @override

  /// Rendement total (kg)
  double get totalYield;
  @override

  /// Rendement de l'année courante (kg)
  double get currentYearYield;
  @override

  /// Nombre de récoltes cette année
  int get harvestsThisYear;
  @override

  /// Nombre de plantations cette année
  int get plantingsThisYear;
  @override

  /// Taux de réussite (%)
  double get successRate;
  @override

  /// Coût total des intrants (€)
  double get totalInputCosts;
  @override

  /// Valeur totale des récoltes (€)
  double get totalHarvestValue;
  @override
  @JsonKey(ignore: true)
  _$$GardenStatsImplCopyWith<_$GardenStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CultivationPreferences _$CultivationPreferencesFromJson(
    Map<String, dynamic> json) {
  return _CultivationPreferences.fromJson(json);
}

/// @nodoc
mixin _$CultivationPreferences {
  /// Méthode de culture préférée
  CultivationMethod get method => throw _privateConstructorUsedError;

  /// Utilisation de pesticides
  bool get usePesticides => throw _privateConstructorUsedError;

  /// Utilisation d'engrais chimiques
  bool get useChemicalFertilizers => throw _privateConstructorUsedError;

  /// Utilisation d'engrais organiques
  bool get useOrganicFertilizers => throw _privateConstructorUsedError;

  /// Rotation des cultures
  bool get cropRotation => throw _privateConstructorUsedError;

  /// Association de plantes
  bool get companionPlanting => throw _privateConstructorUsedError;

  /// Paillage
  bool get mulching => throw _privateConstructorUsedError;

  /// Irrigation automatique
  bool get automaticIrrigation => throw _privateConstructorUsedError;

  /// Surveillance régulière
  bool get regularMonitoring => throw _privateConstructorUsedError;

  /// Objectifs de culture
  List<String> get objectives => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CultivationPreferencesCopyWith<CultivationPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CultivationPreferencesCopyWith<$Res> {
  factory $CultivationPreferencesCopyWith(CultivationPreferences value,
          $Res Function(CultivationPreferences) then) =
      _$CultivationPreferencesCopyWithImpl<$Res, CultivationPreferences>;
  @useResult
  $Res call(
      {CultivationMethod method,
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
class _$CultivationPreferencesCopyWithImpl<$Res,
        $Val extends CultivationPreferences>
    implements $CultivationPreferencesCopyWith<$Res> {
  _$CultivationPreferencesCopyWithImpl(this._value, this._then);

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
              as CultivationMethod,
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
abstract class _$$CultivationPreferencesImplCopyWith<$Res>
    implements $CultivationPreferencesCopyWith<$Res> {
  factory _$$CultivationPreferencesImplCopyWith(
          _$CultivationPreferencesImpl value,
          $Res Function(_$CultivationPreferencesImpl) then) =
      __$$CultivationPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CultivationMethod method,
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
class __$$CultivationPreferencesImplCopyWithImpl<$Res>
    extends _$CultivationPreferencesCopyWithImpl<$Res,
        _$CultivationPreferencesImpl>
    implements _$$CultivationPreferencesImplCopyWith<$Res> {
  __$$CultivationPreferencesImplCopyWithImpl(
      _$CultivationPreferencesImpl _value,
      $Res Function(_$CultivationPreferencesImpl) _then)
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
    return _then(_$CultivationPreferencesImpl(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as CultivationMethod,
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
class _$CultivationPreferencesImpl implements _CultivationPreferences {
  const _$CultivationPreferencesImpl(
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

  factory _$CultivationPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CultivationPreferencesImplFromJson(json);

  /// Méthode de culture préférée
  @override
  final CultivationMethod method;

  /// Utilisation de pesticides
  @override
  final bool usePesticides;

  /// Utilisation d'engrais chimiques
  @override
  final bool useChemicalFertilizers;

  /// Utilisation d'engrais organiques
  @override
  final bool useOrganicFertilizers;

  /// Rotation des cultures
  @override
  final bool cropRotation;

  /// Association de plantes
  @override
  final bool companionPlanting;

  /// Paillage
  @override
  final bool mulching;

  /// Irrigation automatique
  @override
  final bool automaticIrrigation;

  /// Surveillance régulière
  @override
  final bool regularMonitoring;

  /// Objectifs de culture
  final List<String> _objectives;

  /// Objectifs de culture
  @override
  List<String> get objectives {
    if (_objectives is EqualUnmodifiableListView) return _objectives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_objectives);
  }

  @override
  String toString() {
    return 'CultivationPreferences(method: $method, usePesticides: $usePesticides, useChemicalFertilizers: $useChemicalFertilizers, useOrganicFertilizers: $useOrganicFertilizers, cropRotation: $cropRotation, companionPlanting: $companionPlanting, mulching: $mulching, automaticIrrigation: $automaticIrrigation, regularMonitoring: $regularMonitoring, objectives: $objectives)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CultivationPreferencesImpl &&
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
  _$$CultivationPreferencesImplCopyWith<_$CultivationPreferencesImpl>
      get copyWith => __$$CultivationPreferencesImplCopyWithImpl<
          _$CultivationPreferencesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CultivationPreferencesImplToJson(
      this,
    );
  }
}

abstract class _CultivationPreferences implements CultivationPreferences {
  const factory _CultivationPreferences(
      {required final CultivationMethod method,
      required final bool usePesticides,
      required final bool useChemicalFertilizers,
      required final bool useOrganicFertilizers,
      required final bool cropRotation,
      required final bool companionPlanting,
      required final bool mulching,
      required final bool automaticIrrigation,
      required final bool regularMonitoring,
      required final List<String> objectives}) = _$CultivationPreferencesImpl;

  factory _CultivationPreferences.fromJson(Map<String, dynamic> json) =
      _$CultivationPreferencesImpl.fromJson;

  @override

  /// Méthode de culture préférée
  CultivationMethod get method;
  @override

  /// Utilisation de pesticides
  bool get usePesticides;
  @override

  /// Utilisation d'engrais chimiques
  bool get useChemicalFertilizers;
  @override

  /// Utilisation d'engrais organiques
  bool get useOrganicFertilizers;
  @override

  /// Rotation des cultures
  bool get cropRotation;
  @override

  /// Association de plantes
  bool get companionPlanting;
  @override

  /// Paillage
  bool get mulching;
  @override

  /// Irrigation automatique
  bool get automaticIrrigation;
  @override

  /// Surveillance régulière
  bool get regularMonitoring;
  @override

  /// Objectifs de culture
  List<String> get objectives;
  @override
  @JsonKey(ignore: true)
  _$$CultivationPreferencesImplCopyWith<_$CultivationPreferencesImpl>
      get copyWith => throw _privateConstructorUsedError;
}

