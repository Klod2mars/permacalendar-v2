// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_intelligence_memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GardenIntelligenceMemoryImpl _$$GardenIntelligenceMemoryImplFromJson(
        Map<String, dynamic> json) =>
    _$GardenIntelligenceMemoryImpl(
      gardenId: json['gardenId'] as String,
      totalReportsGenerated:
          (json['totalReportsGenerated'] as num?)?.toInt() ?? 0,
      totalAnalysesPerformed:
          (json['totalAnalysesPerformed'] as num?)?.toInt() ?? 0,
      lastReportGeneratedAt:
          DateTime.parse(json['lastReportGeneratedAt'] as String),
      memoryCreatedAt: DateTime.parse(json['memoryCreatedAt'] as String),
      memoryUpdatedAt: DateTime.parse(json['memoryUpdatedAt'] as String),
    );

Map<String, dynamic> _$$GardenIntelligenceMemoryImplToJson(
        _$GardenIntelligenceMemoryImpl instance) =>
    <String, dynamic>{
      'gardenId': instance.gardenId,
      'totalReportsGenerated': instance.totalReportsGenerated,
      'totalAnalysesPerformed': instance.totalAnalysesPerformed,
      'lastReportGeneratedAt': instance.lastReportGeneratedAt.toIso8601String(),
      'memoryCreatedAt': instance.memoryCreatedAt.toIso8601String(),
      'memoryUpdatedAt': instance.memoryUpdatedAt.toIso8601String(),
    };

