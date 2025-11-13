// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_intelligence_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GardenIntelligenceContextImpl _$$GardenIntelligenceContextImplFromJson(
        Map<String, dynamic> json) =>
    _$GardenIntelligenceContextImpl(
      gardenId: json['gardenId'] as String,
      location: json['location'] as String,
      climate: json['climate'] as String,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 0.0,
      soilPh: (json['soilPh'] as num?)?.toDouble() ?? 0.0,
      soilTemperature: (json['soilTemperature'] as num?)?.toDouble() ?? 0.0,
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
    );

Map<String, dynamic> _$$GardenIntelligenceContextImplToJson(
        _$GardenIntelligenceContextImpl instance) =>
    <String, dynamic>{
      'gardenId': instance.gardenId,
      'location': instance.location,
      'climate': instance.climate,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'soilPh': instance.soilPh,
      'soilTemperature': instance.soilTemperature,
      'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
    };
