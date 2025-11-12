// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_intelligence_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GardenIntelligenceSettingsImpl _$$GardenIntelligenceSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$GardenIntelligenceSettingsImpl(
      gardenId: json['gardenId'] as String,
      autoAnalysis: json['autoAnalysis'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      analysisIntervalHours:
          (json['analysisIntervalHours'] as num?)?.toInt() ?? 24,
      confidenceThreshold:
          (json['confidenceThreshold'] as num?)?.toDouble() ?? 0.8,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$GardenIntelligenceSettingsImplToJson(
        _$GardenIntelligenceSettingsImpl instance) =>
    <String, dynamic>{
      'gardenId': instance.gardenId,
      'autoAnalysis': instance.autoAnalysis,
      'notificationsEnabled': instance.notificationsEnabled,
      'analysisIntervalHours': instance.analysisIntervalHours,
      'confidenceThreshold': instance.confidenceThreshold,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
