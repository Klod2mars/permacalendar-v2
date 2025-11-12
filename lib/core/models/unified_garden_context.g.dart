// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unified_garden_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnifiedGardenContextImpl _$$UnifiedGardenContextImplFromJson(
        Map<String, dynamic> json) =>
    _$UnifiedGardenContextImpl(
      gardenId: json['gardenId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      totalArea: (json['totalArea'] as num?)?.toDouble(),
      activePlants: (json['activePlants'] as List<dynamic>)
          .map((e) => UnifiedPlantData.fromJson(e as Map<String, dynamic>))
          .toList(),
      historicalPlants: (json['historicalPlants'] as List<dynamic>)
          .map((e) => UnifiedPlantData.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: UnifiedGardenStats.fromJson(json['stats'] as Map<String, dynamic>),
      soil: UnifiedSoilInfo.fromJson(json['soil'] as Map<String, dynamic>),
      climate: UnifiedClimate.fromJson(json['climate'] as Map<String, dynamic>),
      preferences: UnifiedCultivationPreferences.fromJson(
          json['preferences'] as Map<String, dynamic>),
      recentActivities: (json['recentActivities'] as List<dynamic>)
          .map(
              (e) => UnifiedActivityHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      primarySource: $enumDecode(_$DataSourceEnumMap, json['primarySource']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UnifiedGardenContextImplToJson(
        _$UnifiedGardenContextImpl instance) =>
    <String, dynamic>{
      'gardenId': instance.gardenId,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'totalArea': instance.totalArea,
      'activePlants': instance.activePlants,
      'historicalPlants': instance.historicalPlants,
      'stats': instance.stats,
      'soil': instance.soil,
      'climate': instance.climate,
      'preferences': instance.preferences,
      'recentActivities': instance.recentActivities,
      'primarySource': _$DataSourceEnumMap[instance.primarySource]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$DataSourceEnumMap = {
  DataSource.legacy: 'legacy',
  DataSource.modern: 'modern',
  DataSource.intelligence: 'intelligence',
  DataSource.aggregated: 'aggregated',
  DataSource.fallback: 'fallback',
};

_$UnifiedPlantDataImpl _$$UnifiedPlantDataImplFromJson(
        Map<String, dynamic> json) =>
    _$UnifiedPlantDataImpl(
      plantId: json['plantId'] as String,
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      family: json['family'] as String?,
      variety: json['variety'] as String?,
      plantingSeason: (json['plantingSeason'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      harvestSeason: (json['harvestSeason'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      growthCycle: json['growthCycle'] as String?,
      sunExposure: json['sunExposure'] as String?,
      waterNeeds: json['waterNeeds'] as String?,
      soilType: json['soilType'] as String?,
      spacingInCm: (json['spacingInCm'] as num?)?.toDouble(),
      depthInCm: (json['depthInCm'] as num?)?.toDouble(),
      companionPlants: json['companionPlants'] as String?,
      incompatiblePlants: json['incompatiblePlants'] as String?,
      diseases: json['diseases'] as String?,
      pests: json['pests'] as String?,
      benefits: json['benefits'] as String?,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      source: $enumDecode(_$DataSourceEnumMap, json['source']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UnifiedPlantDataImplToJson(
        _$UnifiedPlantDataImpl instance) =>
    <String, dynamic>{
      'plantId': instance.plantId,
      'commonName': instance.commonName,
      'scientificName': instance.scientificName,
      'family': instance.family,
      'variety': instance.variety,
      'plantingSeason': instance.plantingSeason,
      'harvestSeason': instance.harvestSeason,
      'growthCycle': instance.growthCycle,
      'sunExposure': instance.sunExposure,
      'waterNeeds': instance.waterNeeds,
      'soilType': instance.soilType,
      'spacingInCm': instance.spacingInCm,
      'depthInCm': instance.depthInCm,
      'companionPlants': instance.companionPlants,
      'incompatiblePlants': instance.incompatiblePlants,
      'diseases': instance.diseases,
      'pests': instance.pests,
      'benefits': instance.benefits,
      'notes': instance.notes,
      'imageUrl': instance.imageUrl,
      'source': _$DataSourceEnumMap[instance.source]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$UnifiedGardenStatsImpl _$$UnifiedGardenStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$UnifiedGardenStatsImpl(
      totalPlants: (json['totalPlants'] as num).toInt(),
      activePlants: (json['activePlants'] as num).toInt(),
      historicalPlants: (json['historicalPlants'] as num).toInt(),
      totalArea: (json['totalArea'] as num).toDouble(),
      activeArea: (json['activeArea'] as num).toDouble(),
      totalBeds: (json['totalBeds'] as num).toInt(),
      activeBeds: (json['activeBeds'] as num).toInt(),
      plantingsThisYear: (json['plantingsThisYear'] as num).toInt(),
      harvestsThisYear: (json['harvestsThisYear'] as num).toInt(),
      successRate: (json['successRate'] as num).toDouble(),
      totalYield: (json['totalYield'] as num).toDouble(),
      currentYearYield: (json['currentYearYield'] as num).toDouble(),
      averageHealth: (json['averageHealth'] as num).toDouble(),
      activeRecommendations: (json['activeRecommendations'] as num).toInt(),
      activeAlerts: (json['activeAlerts'] as num).toInt(),
    );

Map<String, dynamic> _$$UnifiedGardenStatsImplToJson(
        _$UnifiedGardenStatsImpl instance) =>
    <String, dynamic>{
      'totalPlants': instance.totalPlants,
      'activePlants': instance.activePlants,
      'historicalPlants': instance.historicalPlants,
      'totalArea': instance.totalArea,
      'activeArea': instance.activeArea,
      'totalBeds': instance.totalBeds,
      'activeBeds': instance.activeBeds,
      'plantingsThisYear': instance.plantingsThisYear,
      'harvestsThisYear': instance.harvestsThisYear,
      'successRate': instance.successRate,
      'totalYield': instance.totalYield,
      'currentYearYield': instance.currentYearYield,
      'averageHealth': instance.averageHealth,
      'activeRecommendations': instance.activeRecommendations,
      'activeAlerts': instance.activeAlerts,
    };

_$UnifiedSoilInfoImpl _$$UnifiedSoilInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$UnifiedSoilInfoImpl(
      type: json['type'] as String,
      ph: (json['ph'] as num).toDouble(),
      texture: json['texture'] as String,
      organicMatter: (json['organicMatter'] as num).toDouble(),
      waterRetention: (json['waterRetention'] as num).toDouble(),
      drainage: json['drainage'] as String,
      depth: (json['depth'] as num).toDouble(),
      nutrients: Map<String, String>.from(json['nutrients'] as Map),
    );

Map<String, dynamic> _$$UnifiedSoilInfoImplToJson(
        _$UnifiedSoilInfoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'ph': instance.ph,
      'texture': instance.texture,
      'organicMatter': instance.organicMatter,
      'waterRetention': instance.waterRetention,
      'drainage': instance.drainage,
      'depth': instance.depth,
      'nutrients': instance.nutrients,
    };

_$UnifiedClimateImpl _$$UnifiedClimateImplFromJson(Map<String, dynamic> json) =>
    _$UnifiedClimateImpl(
      averageTemperature: (json['averageTemperature'] as num).toDouble(),
      minTemperature: (json['minTemperature'] as num).toDouble(),
      maxTemperature: (json['maxTemperature'] as num).toDouble(),
      averagePrecipitation: (json['averagePrecipitation'] as num).toDouble(),
      averageHumidity: (json['averageHumidity'] as num).toDouble(),
      frostDays: (json['frostDays'] as num).toInt(),
      growingSeasonLength: (json['growingSeasonLength'] as num).toInt(),
      dominantWindDirection: json['dominantWindDirection'] as String,
      averageWindSpeed: (json['averageWindSpeed'] as num).toDouble(),
      averageSunshineHours: (json['averageSunshineHours'] as num).toDouble(),
      usdaZone: json['usdaZone'] as String?,
      climateType: json['climateType'] as String?,
    );

Map<String, dynamic> _$$UnifiedClimateImplToJson(
        _$UnifiedClimateImpl instance) =>
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
      'usdaZone': instance.usdaZone,
      'climateType': instance.climateType,
    };

_$UnifiedCultivationPreferencesImpl
    _$$UnifiedCultivationPreferencesImplFromJson(Map<String, dynamic> json) =>
        _$UnifiedCultivationPreferencesImpl(
          method: json['method'] as String,
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

Map<String, dynamic> _$$UnifiedCultivationPreferencesImplToJson(
        _$UnifiedCultivationPreferencesImpl instance) =>
    <String, dynamic>{
      'method': instance.method,
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

_$UnifiedActivityHistoryImpl _$$UnifiedActivityHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$UnifiedActivityHistoryImpl(
      activityId: json['activityId'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      plantId: json['plantId'] as String?,
      bedId: json['bedId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UnifiedActivityHistoryImplToJson(
        _$UnifiedActivityHistoryImpl instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
      'type': instance.type,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'plantId': instance.plantId,
      'bedId': instance.bedId,
      'metadata': instance.metadata,
    };
