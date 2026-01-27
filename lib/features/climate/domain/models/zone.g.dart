// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ZoneImpl _$$ZoneImplFromJson(Map<String, dynamic> json) => _$ZoneImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      monthShift: (json['monthShift'] as num?)?.toInt() ?? 0,
      preferRelativeRules: json['preferRelativeRules'] as bool? ?? false,
      preferSeasonDefinition: json['preferSeasonDefinition'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$ZoneImplToJson(_$ZoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'monthShift': instance.monthShift,
      'preferRelativeRules': instance.preferRelativeRules,
      'preferSeasonDefinition': instance.preferSeasonDefinition,
      'tags': instance.tags,
    };
