// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_intelligence_evolution_tracker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IntelligenceEvolutionSummaryImpl _$$IntelligenceEvolutionSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$IntelligenceEvolutionSummaryImpl(
      plantId: json['plantId'] as String,
      plantName: json['plantName'] as String,
      scoreDelta: (json['scoreDelta'] as num).toDouble(),
      confidenceDelta: (json['confidenceDelta'] as num).toDouble(),
      addedRecommendations: (json['addedRecommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      removedRecommendations: (json['removedRecommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      modifiedRecommendations:
          (json['modifiedRecommendations'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      isImproved: json['isImproved'] as bool,
      isStable: json['isStable'] as bool,
      isDegraded: json['isDegraded'] as bool,
      timingScoreShift: (json['timingScoreShift'] as num?)?.toDouble() ?? 0.0,
      oldReport: PlantIntelligenceReport.fromJson(
          json['oldReport'] as Map<String, dynamic>),
      newReport: PlantIntelligenceReport.fromJson(
          json['newReport'] as Map<String, dynamic>),
      comparedAt: DateTime.parse(json['comparedAt'] as String),
    );

Map<String, dynamic> _$$IntelligenceEvolutionSummaryImplToJson(
        _$IntelligenceEvolutionSummaryImpl instance) =>
    <String, dynamic>{
      'plantId': instance.plantId,
      'plantName': instance.plantName,
      'scoreDelta': instance.scoreDelta,
      'confidenceDelta': instance.confidenceDelta,
      'addedRecommendations': instance.addedRecommendations,
      'removedRecommendations': instance.removedRecommendations,
      'modifiedRecommendations': instance.modifiedRecommendations,
      'isImproved': instance.isImproved,
      'isStable': instance.isStable,
      'isDegraded': instance.isDegraded,
      'timingScoreShift': instance.timingScoreShift,
      'oldReport': instance.oldReport,
      'newReport': instance.newReport,
      'comparedAt': instance.comparedAt.toIso8601String(),
    };
