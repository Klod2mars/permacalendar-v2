// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherConditionImpl _$$WeatherConditionImplFromJson(
        Map<String, dynamic> json) =>
    _$WeatherConditionImpl(
      id: json['id'] as String,
      type: $enumDecode(_$WeatherTypeEnumMap, json['type']),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      description: json['description'] as String?,
      impact: json['impact'] == null
          ? null
          : WeatherImpact.fromJson(json['impact'] as Map<String, dynamic>),
      measuredAt: DateTime.parse(json['measuredAt'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WeatherConditionImplToJson(
        _$WeatherConditionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$WeatherTypeEnumMap[instance.type]!,
      'value': instance.value,
      'unit': instance.unit,
      'description': instance.description,
      'impact': instance.impact,
      'measuredAt': instance.measuredAt.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$WeatherTypeEnumMap = {
  WeatherType.temperature: 'temperature',
  WeatherType.humidity: 'humidity',
  WeatherType.precipitation: 'precipitation',
  WeatherType.windSpeed: 'windSpeed',
  WeatherType.windDirection: 'windDirection',
  WeatherType.pressure: 'pressure',
  WeatherType.cloudCover: 'cloudCover',
  WeatherType.uvIndex: 'uvIndex',
  WeatherType.visibility: 'visibility',
};

_$WeatherImpactImpl _$$WeatherImpactImplFromJson(Map<String, dynamic> json) =>
    _$WeatherImpactImpl(
      type: $enumDecode(_$ImpactTypeEnumMap, json['type']),
      intensity: (json['intensity'] as num).toDouble(),
      description: json['description'] as String,
      affectedPlants: (json['affectedPlants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
    );

Map<String, dynamic> _$$WeatherImpactImplToJson(_$WeatherImpactImpl instance) =>
    <String, dynamic>{
      'type': _$ImpactTypeEnumMap[instance.type]!,
      'intensity': instance.intensity,
      'description': instance.description,
      'affectedPlants': instance.affectedPlants,
      'recommendations': instance.recommendations,
      'duration': instance.duration?.inMicroseconds,
    };

const _$ImpactTypeEnumMap = {
  ImpactType.beneficial: 'beneficial',
  ImpactType.harmful: 'harmful',
  ImpactType.neutral: 'neutral',
  ImpactType.stress: 'stress',
  ImpactType.growth: 'growth',
  ImpactType.flowering: 'flowering',
  ImpactType.fruiting: 'fruiting',
  ImpactType.disease: 'disease',
  ImpactType.pest: 'pest',
};

