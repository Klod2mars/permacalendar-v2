// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantConditionImpl _$$PlantConditionImplFromJson(Map<String, dynamic> json) =>
    _$PlantConditionImpl(
      id: json['id'] as String,
      plantId: json['plantId'] as String,
      gardenId: json['gardenId'] as String,
      type: $enumDecode(_$ConditionTypeEnumMap, json['type']),
      status: $enumDecode(_$ConditionStatusEnumMap, json['status']),
      value: (json['value'] as num).toDouble(),
      optimalValue: (json['optimalValue'] as num).toDouble(),
      minValue: (json['minValue'] as num).toDouble(),
      maxValue: (json['maxValue'] as num).toDouble(),
      unit: json['unit'] as String,
      description: json['description'] as String?,
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      measuredAt: DateTime.parse(json['measuredAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PlantConditionImplToJson(
        _$PlantConditionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plantId': instance.plantId,
      'gardenId': instance.gardenId,
      'type': _$ConditionTypeEnumMap[instance.type]!,
      'status': _$ConditionStatusEnumMap[instance.status]!,
      'value': instance.value,
      'optimalValue': instance.optimalValue,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'unit': instance.unit,
      'description': instance.description,
      'recommendations': instance.recommendations,
      'measuredAt': instance.measuredAt.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ConditionTypeEnumMap = {
  ConditionType.temperature: 'temperature',
  ConditionType.humidity: 'humidity',
  ConditionType.light: 'light',
  ConditionType.soil: 'soil',
  ConditionType.wind: 'wind',
  ConditionType.water: 'water',
};

const _$ConditionStatusEnumMap = {
  ConditionStatus.optimal: 'optimal',
  ConditionStatus.excellent: 'excellent',
  ConditionStatus.good: 'good',
  ConditionStatus.suboptimal: 'suboptimal',
  ConditionStatus.fair: 'fair',
  ConditionStatus.poor: 'poor',
  ConditionStatus.critical: 'critical',
};
