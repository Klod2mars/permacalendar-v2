// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GardenContextImpl _$$GardenContextImplFromJson(Map<String, dynamic> json) =>
    _$GardenContextImpl(
      gardenId: json['gardenId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      location:
          GardenLocation.fromJson(json['location'] as Map<String, dynamic>),
      climate:
          ClimateConditions.fromJson(json['climate'] as Map<String, dynamic>),
      soil: SoilInfo.fromJson(json['soil'] as Map<String, dynamic>),
      activePlantIds: (json['activePlantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      historicalPlantIds: (json['historicalPlantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      stats: GardenStats.fromJson(json['stats'] as Map<String, dynamic>),
      preferences: CultivationPreferences.fromJson(
          json['preferences'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$GardenContextImplToJson(_$GardenContextImpl instance) =>
    <String, dynamic>{
      'gardenId': instance.gardenId,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'climate': instance.climate,
      'soil': instance.soil,
      'activePlantIds': instance.activePlantIds,
      'historicalPlantIds': instance.historicalPlantIds,
      'stats': instance.stats,
      'preferences': instance.preferences,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

_$GardenLocationImpl _$$GardenLocationImplFromJson(Map<String, dynamic> json) =>
    _$GardenLocationImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      city: json['city'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      usdaZone: json['usdaZone'] as String?,
      altitude: (json['altitude'] as num?)?.toDouble(),
      exposure: json['exposure'] as String?,
    );

Map<String, dynamic> _$$GardenLocationImplToJson(
        _$GardenLocationImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'usdaZone': instance.usdaZone,
      'altitude': instance.altitude,
      'exposure': instance.exposure,
    };

_$ClimateConditionsImpl _$$ClimateConditionsImplFromJson(
        Map<String, dynamic> json) =>
    _$ClimateConditionsImpl(
      averageTemperature: (json['averageTemperature'] as num).toDouble(),
      minTemperature: (json['minTemperature'] as num).toDouble(),
      maxTemperature: (json['maxTemperature'] as num).toDouble(),
      averagePrecipitation: (json['averagePrecipitation'] as num).toDouble(),
      averageHumidity: (json['averageHumidity'] as num).toDouble(),
      frostDays: (json['frostDays'] as num).toInt(),
      growingSeasonLength: (json['growingSeasonLength'] as num).toInt(),
      dominantWindDirection: json['dominantWindDirection'] as String?,
      averageWindSpeed: (json['averageWindSpeed'] as num?)?.toDouble(),
      averageSunshineHours: (json['averageSunshineHours'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ClimateConditionsImplToJson(
        _$ClimateConditionsImpl instance) =>
    <String, dynamic>{
      'averageTemperature': instance.averageTemperature,
      'minTemperature': instance.minTemperature,
      'maxTemperature': instance.maxTemperature,
      'averagePrecipitation': instance.averagePrecipitation,
      'averageHumidity': instance.averageHumidity,
      'frostDays': instance.frostDays,
      'growingSeasonLength': instance.growingSeasonLength,
      'dominantWindDirection': instance.dominantWindDirection,
      'averageWindSpeed': instance.averageWindSpeed,
      'averageSunshineHours': instance.averageSunshineHours,
    };

_$SoilInfoImpl _$$SoilInfoImplFromJson(Map<String, dynamic> json) =>
    _$SoilInfoImpl(
      type: $enumDecode(_$SoilTypeEnumMap, json['type']),
      ph: (json['ph'] as num).toDouble(),
      texture: $enumDecode(_$SoilTextureEnumMap, json['texture']),
      organicMatter: (json['organicMatter'] as num).toDouble(),
      waterRetention: (json['waterRetention'] as num).toDouble(),
      drainage: $enumDecode(_$SoilDrainageEnumMap, json['drainage']),
      depth: (json['depth'] as num).toDouble(),
      nutrients:
          NutrientLevels.fromJson(json['nutrients'] as Map<String, dynamic>),
      biologicalActivity:
          $enumDecode(_$BiologicalActivityEnumMap, json['biologicalActivity']),
      contaminants: (json['contaminants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SoilInfoImplToJson(_$SoilInfoImpl instance) =>
    <String, dynamic>{
      'type': _$SoilTypeEnumMap[instance.type]!,
      'ph': instance.ph,
      'texture': _$SoilTextureEnumMap[instance.texture]!,
      'organicMatter': instance.organicMatter,
      'waterRetention': instance.waterRetention,
      'drainage': _$SoilDrainageEnumMap[instance.drainage]!,
      'depth': instance.depth,
      'nutrients': instance.nutrients,
      'biologicalActivity':
          _$BiologicalActivityEnumMap[instance.biologicalActivity]!,
      'contaminants': instance.contaminants,
    };

const _$SoilTypeEnumMap = {
  SoilType.clay: 'clay',
  SoilType.sandy: 'sandy',
  SoilType.loamy: 'loamy',
  SoilType.silty: 'silty',
  SoilType.peaty: 'peaty',
  SoilType.chalky: 'chalky',
  SoilType.rocky: 'rocky',
};

const _$SoilTextureEnumMap = {
  SoilTexture.fine: 'fine',
  SoilTexture.medium: 'medium',
  SoilTexture.coarse: 'coarse',
};

const _$SoilDrainageEnumMap = {
  SoilDrainage.poor: 'poor',
  SoilDrainage.moderate: 'moderate',
  SoilDrainage.good: 'good',
  SoilDrainage.excellent: 'excellent',
};

const _$BiologicalActivityEnumMap = {
  BiologicalActivity.veryLow: 'veryLow',
  BiologicalActivity.low: 'low',
  BiologicalActivity.moderate: 'moderate',
  BiologicalActivity.high: 'high',
  BiologicalActivity.veryHigh: 'veryHigh',
};

_$NutrientLevelsImpl _$$NutrientLevelsImplFromJson(Map<String, dynamic> json) =>
    _$NutrientLevelsImpl(
      nitrogen: $enumDecode(_$NutrientLevelEnumMap, json['nitrogen']),
      phosphorus: $enumDecode(_$NutrientLevelEnumMap, json['phosphorus']),
      potassium: $enumDecode(_$NutrientLevelEnumMap, json['potassium']),
      calcium: $enumDecode(_$NutrientLevelEnumMap, json['calcium']),
      magnesium: $enumDecode(_$NutrientLevelEnumMap, json['magnesium']),
      sulfur: $enumDecode(_$NutrientLevelEnumMap, json['sulfur']),
      micronutrients: (json['micronutrients'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, $enumDecode(_$NutrientLevelEnumMap, e)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$NutrientLevelsImplToJson(
        _$NutrientLevelsImpl instance) =>
    <String, dynamic>{
      'nitrogen': _$NutrientLevelEnumMap[instance.nitrogen]!,
      'phosphorus': _$NutrientLevelEnumMap[instance.phosphorus]!,
      'potassium': _$NutrientLevelEnumMap[instance.potassium]!,
      'calcium': _$NutrientLevelEnumMap[instance.calcium]!,
      'magnesium': _$NutrientLevelEnumMap[instance.magnesium]!,
      'sulfur': _$NutrientLevelEnumMap[instance.sulfur]!,
      'micronutrients': instance.micronutrients
          .map((k, e) => MapEntry(k, _$NutrientLevelEnumMap[e]!)),
    };

const _$NutrientLevelEnumMap = {
  NutrientLevel.deficient: 'deficient',
  NutrientLevel.low: 'low',
  NutrientLevel.adequate: 'adequate',
  NutrientLevel.high: 'high',
  NutrientLevel.excessive: 'excessive',
};

_$GardenStatsImpl _$$GardenStatsImplFromJson(Map<String, dynamic> json) =>
    _$GardenStatsImpl(
      totalPlants: (json['totalPlants'] as num).toInt(),
      activePlants: (json['activePlants'] as num).toInt(),
      totalArea: (json['totalArea'] as num).toDouble(),
      activeArea: (json['activeArea'] as num).toDouble(),
      totalYield: (json['totalYield'] as num).toDouble(),
      currentYearYield: (json['currentYearYield'] as num).toDouble(),
      harvestsThisYear: (json['harvestsThisYear'] as num).toInt(),
      plantingsThisYear: (json['plantingsThisYear'] as num).toInt(),
      successRate: (json['successRate'] as num).toDouble(),
      totalInputCosts: (json['totalInputCosts'] as num).toDouble(),
      totalHarvestValue: (json['totalHarvestValue'] as num).toDouble(),
    );

Map<String, dynamic> _$$GardenStatsImplToJson(_$GardenStatsImpl instance) =>
    <String, dynamic>{
      'totalPlants': instance.totalPlants,
      'activePlants': instance.activePlants,
      'totalArea': instance.totalArea,
      'activeArea': instance.activeArea,
      'totalYield': instance.totalYield,
      'currentYearYield': instance.currentYearYield,
      'harvestsThisYear': instance.harvestsThisYear,
      'plantingsThisYear': instance.plantingsThisYear,
      'successRate': instance.successRate,
      'totalInputCosts': instance.totalInputCosts,
      'totalHarvestValue': instance.totalHarvestValue,
    };

_$CultivationPreferencesImpl _$$CultivationPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$CultivationPreferencesImpl(
      method: $enumDecode(_$CultivationMethodEnumMap, json['method']),
      usePesticides: json['usePesticides'] as bool,
      useChemicalFertilizers: json['useChemicalFertilizers'] as bool,
      useOrganicFertilizers: json['useOrganicFertilizers'] as bool,
      cropRotation: json['cropRotation'] as bool,
      companionPlanting: json['companionPlanting'] as bool,
      mulching: json['mulching'] as bool,
      automaticIrrigation: json['automaticIrrigation'] as bool,
      regularMonitoring: json['regularMonitoring'] as bool,
      objectives: (json['objectives'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CultivationPreferencesImplToJson(
        _$CultivationPreferencesImpl instance) =>
    <String, dynamic>{
      'method': _$CultivationMethodEnumMap[instance.method]!,
      'usePesticides': instance.usePesticides,
      'useChemicalFertilizers': instance.useChemicalFertilizers,
      'useOrganicFertilizers': instance.useOrganicFertilizers,
      'cropRotation': instance.cropRotation,
      'companionPlanting': instance.companionPlanting,
      'mulching': instance.mulching,
      'automaticIrrigation': instance.automaticIrrigation,
      'regularMonitoring': instance.regularMonitoring,
      'objectives': instance.objectives,
    };

const _$CultivationMethodEnumMap = {
  CultivationMethod.conventional: 'conventional',
  CultivationMethod.organic: 'organic',
  CultivationMethod.biodynamic: 'biodynamic',
  CultivationMethod.permaculture: 'permaculture',
  CultivationMethod.agroforestry: 'agroforestry',
  CultivationMethod.hydroponic: 'hydroponic',
  CultivationMethod.aquaponic: 'aquaponic',
};
