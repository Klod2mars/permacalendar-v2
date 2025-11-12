// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comprehensive_garden_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ComprehensiveGardenAnalysisImpl _$$ComprehensiveGardenAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$ComprehensiveGardenAnalysisImpl(
      gardenId: json['gardenId'] as String,
      plantReports: (json['plantReports'] as List<dynamic>)
          .map((e) =>
              PlantIntelligenceReport.fromJson(e as Map<String, dynamic>))
          .toList(),
      bioControlRecommendations:
          (json['bioControlRecommendations'] as List<dynamic>)
              .map((e) =>
                  BioControlRecommendation.fromJson(e as Map<String, dynamic>))
              .toList(),
      overallHealthScore: (json['overallHealthScore'] as num).toDouble(),
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
      summary: json['summary'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ComprehensiveGardenAnalysisImplToJson(
        _$ComprehensiveGardenAnalysisImpl instance) =>
    <String, dynamic>{
      'gardenId': instance.gardenId,
      'plantReports': instance.plantReports,
      'bioControlRecommendations': instance.bioControlRecommendations,
      'overallHealthScore': instance.overallHealthScore,
      'analyzedAt': instance.analyzedAt.toIso8601String(),
      'summary': instance.summary,
      'metadata': instance.metadata,
    };

