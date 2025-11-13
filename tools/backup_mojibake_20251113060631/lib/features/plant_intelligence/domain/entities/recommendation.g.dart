// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationImpl _$$RecommendationImplFromJson(Map<String, dynamic> json) =>
    _$RecommendationImpl(
      id: json['id'] as String,
      plantId: json['plantId'] as String,
      gardenId: json['gardenId'] as String,
      type: $enumDecode(_$RecommendationTypeEnumMap, json['type']),
      priority: $enumDecode(_$RecommendationPriorityEnumMap, json['priority']),
      title: json['title'] as String,
      description: json['description'] as String,
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      reason: json['reason'] as String?,
      expectedImpact: (json['expectedImpact'] as num).toDouble(),
      effortRequired: (json['effortRequired'] as num).toDouble(),
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
      estimatedDuration: json['estimatedDuration'] == null
          ? null
          : Duration(microseconds: (json['estimatedDuration'] as num).toInt()),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      optimalConditions: (json['optimalConditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      requiredTools: (json['requiredTools'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status:
          $enumDecodeNullable(_$RecommendationStatusEnumMap, json['status']) ??
              RecommendationStatus.pending,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      notes: json['notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$RecommendationImplToJson(
        _$RecommendationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plantId': instance.plantId,
      'gardenId': instance.gardenId,
      'type': _$RecommendationTypeEnumMap[instance.type]!,
      'priority': _$RecommendationPriorityEnumMap[instance.priority]!,
      'title': instance.title,
      'description': instance.description,
      'instructions': instance.instructions,
      'reason': instance.reason,
      'expectedImpact': instance.expectedImpact,
      'effortRequired': instance.effortRequired,
      'estimatedCost': instance.estimatedCost,
      'estimatedDuration': instance.estimatedDuration?.inMicroseconds,
      'deadline': instance.deadline?.toIso8601String(),
      'optimalConditions': instance.optimalConditions,
      'requiredTools': instance.requiredTools,
      'status': _$RecommendationStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'notes': instance.notes,
      'metadata': instance.metadata,
    };

const _$RecommendationTypeEnumMap = {
  RecommendationType.watering: 'watering',
  RecommendationType.fertilizing: 'fertilizing',
  RecommendationType.pruning: 'pruning',
  RecommendationType.planting: 'planting',
  RecommendationType.harvesting: 'harvesting',
  RecommendationType.pestControl: 'pestControl',
  RecommendationType.diseaseControl: 'diseaseControl',
  RecommendationType.soilImprovement: 'soilImprovement',
  RecommendationType.weatherProtection: 'weatherProtection',
  RecommendationType.general: 'general',
};

const _$RecommendationPriorityEnumMap = {
  RecommendationPriority.low: 'low',
  RecommendationPriority.medium: 'medium',
  RecommendationPriority.high: 'high',
  RecommendationPriority.critical: 'critical',
};

const _$RecommendationStatusEnumMap = {
  RecommendationStatus.pending: 'pending',
  RecommendationStatus.inProgress: 'inProgress',
  RecommendationStatus.completed: 'completed',
  RecommendationStatus.dismissed: 'dismissed',
  RecommendationStatus.expired: 'expired',
};
