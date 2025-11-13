// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intelligent_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IntelligentSuggestionImpl _$$IntelligentSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$IntelligentSuggestionImpl(
      id: json['id'] as String,
      gardenId: json['gardenId'] as String,
      message: json['message'] as String,
      priority: $enumDecode(_$SuggestionPriorityEnumMap, json['priority']),
      category: $enumDecode(_$SuggestionCategoryEnumMap, json['category']),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isActioned: json['isActioned'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$IntelligentSuggestionImplToJson(
        _$IntelligentSuggestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gardenId': instance.gardenId,
      'message': instance.message,
      'priority': _$SuggestionPriorityEnumMap[instance.priority]!,
      'category': _$SuggestionCategoryEnumMap[instance.category]!,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isRead': instance.isRead,
      'isActioned': instance.isActioned,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$SuggestionPriorityEnumMap = {
  SuggestionPriority.high: 'high',
  SuggestionPriority.medium: 'medium',
  SuggestionPriority.low: 'low',
};

const _$SuggestionCategoryEnumMap = {
  SuggestionCategory.weather: 'weather',
  SuggestionCategory.lunar: 'lunar',
  SuggestionCategory.seasonal: 'seasonal',
  SuggestionCategory.pest: 'pest',
  SuggestionCategory.harvest: 'harvest',
  SuggestionCategory.maintenance: 'maintenance',
};
