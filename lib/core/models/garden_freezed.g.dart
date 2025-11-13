// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_freezed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GardenFreezedImpl _$$GardenFreezedImplFromJson(Map<String, dynamic> json) =>
    _$GardenFreezedImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      totalAreaInSquareMeters:
          (json['totalAreaInSquareMeters'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$GardenFreezedImplToJson(_$GardenFreezedImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'totalAreaInSquareMeters': instance.totalAreaInSquareMeters,
      'location': instance.location,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'metadata': instance.metadata,
      'isActive': instance.isActive,
    };
