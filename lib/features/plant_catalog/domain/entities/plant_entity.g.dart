// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantFreezedImpl _$$PlantFreezedImplFromJson(Map<String, dynamic> json) =>
    _$PlantFreezedImpl(
      id: json['id'] as String,
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      family: json['family'] as String,
      plantingSeason: json['plantingSeason'] as String,
      harvestSeason: json['harvestSeason'] as String,
      daysToMaturity: (json['daysToMaturity'] as num).toInt(),
      spacing: (json['spacing'] as num).toInt(),
      depth: (json['depth'] as num).toDouble(),
      sunExposure: json['sunExposure'] as String,
      waterNeeds: json['waterNeeds'] as String,
      description: json['description'] as String,
      sowingMonths: (json['sowingMonths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      harvestMonths: (json['harvestMonths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      marketPricePerKg: (json['marketPricePerKg'] as num?)?.toDouble(),
      defaultUnit: json['defaultUnit'] as String?,
      nutritionPer100g: json['nutritionPer100g'] as Map<String, dynamic>?,
      germination: json['germination'] as Map<String, dynamic>?,
      growth: json['growth'] as Map<String, dynamic>?,
      watering: json['watering'] as Map<String, dynamic>?,
      thinning: json['thinning'] as Map<String, dynamic>?,
      weeding: json['weeding'] as Map<String, dynamic>?,
      culturalTips: (json['culturalTips'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      biologicalControl: json['biologicalControl'] as Map<String, dynamic>?,
      harvestTime: json['harvestTime'] as String?,
      companionPlanting: json['companionPlanting'] as Map<String, dynamic>?,
      notificationSettings:
          json['notificationSettings'] as Map<String, dynamic>?,
      varieties: json['varieties'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      referenceProfile: json['referenceProfile'] as Map<String, dynamic>?,
      zoneProfiles: json['zoneProfiles'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PlantFreezedImplToJson(_$PlantFreezedImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commonName': instance.commonName,
      'scientificName': instance.scientificName,
      'family': instance.family,
      'plantingSeason': instance.plantingSeason,
      'harvestSeason': instance.harvestSeason,
      'daysToMaturity': instance.daysToMaturity,
      'spacing': instance.spacing,
      'depth': instance.depth,
      'sunExposure': instance.sunExposure,
      'waterNeeds': instance.waterNeeds,
      'description': instance.description,
      'sowingMonths': instance.sowingMonths,
      'harvestMonths': instance.harvestMonths,
      'marketPricePerKg': instance.marketPricePerKg,
      'defaultUnit': instance.defaultUnit,
      'nutritionPer100g': instance.nutritionPer100g,
      'germination': instance.germination,
      'growth': instance.growth,
      'watering': instance.watering,
      'thinning': instance.thinning,
      'weeding': instance.weeding,
      'culturalTips': instance.culturalTips,
      'biologicalControl': instance.biologicalControl,
      'harvestTime': instance.harvestTime,
      'companionPlanting': instance.companionPlanting,
      'notificationSettings': instance.notificationSettings,
      'varieties': instance.varieties,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isActive': instance.isActive,
      'referenceProfile': instance.referenceProfile,
      'zoneProfiles': instance.zoneProfiles,
    };
