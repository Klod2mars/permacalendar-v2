// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantAnalysisResultImpl _$$PlantAnalysisResultImplFromJson(
        Map<String, dynamic> json) =>
    _$PlantAnalysisResultImpl(
      id: json['id'] as String,
      plantId: json['plantId'] as String,
      temperature:
          PlantCondition.fromJson(json['temperature'] as Map<String, dynamic>),
      humidity:
          PlantCondition.fromJson(json['humidity'] as Map<String, dynamic>),
      light: PlantCondition.fromJson(json['light'] as Map<String, dynamic>),
      soil: PlantCondition.fromJson(json['soil'] as Map<String, dynamic>),
      overallHealth:
          $enumDecode(_$ConditionStatusEnumMap, json['overallHealth']),
      healthScore: (json['healthScore'] as num).toDouble(),
      warnings:
          (json['warnings'] as List<dynamic>).map((e) => e as String).toList(),
      strengths:
          (json['strengths'] as List<dynamic>).map((e) => e as String).toList(),
      priorityActions: (json['priorityActions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      confidence: (json['confidence'] as num).toDouble(),
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$PlantAnalysisResultImplToJson(
        _$PlantAnalysisResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plantId': instance.plantId,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'light': instance.light,
      'soil': instance.soil,
      'overallHealth': _$ConditionStatusEnumMap[instance.overallHealth]!,
      'healthScore': instance.healthScore,
      'warnings': instance.warnings,
      'strengths': instance.strengths,
      'priorityActions': instance.priorityActions,
      'confidence': instance.confidence,
      'analyzedAt': instance.analyzedAt.toIso8601String(),
      'metadata': instance.metadata,
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

