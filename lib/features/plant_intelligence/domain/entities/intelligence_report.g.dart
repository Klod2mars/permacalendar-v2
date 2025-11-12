// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intelligence_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantIntelligenceReportImpl _$$PlantIntelligenceReportImplFromJson(
        Map<String, dynamic> json) =>
    _$PlantIntelligenceReportImpl(
      id: json['id'] as String,
      plantId: json['plantId'] as String,
      plantName: json['plantName'] as String,
      gardenId: json['gardenId'] as String,
      analysis: PlantAnalysisResult.fromJson(
          json['analysis'] as Map<String, dynamic>),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
      plantingTiming: json['plantingTiming'] == null
          ? null
          : PlantingTimingEvaluation.fromJson(
              json['plantingTiming'] as Map<String, dynamic>),
      activeAlerts: (json['activeAlerts'] as List<dynamic>?)
              ?.map(
                  (e) => NotificationAlert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      intelligenceScore: (json['intelligenceScore'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$PlantIntelligenceReportImplToJson(
        _$PlantIntelligenceReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plantId': instance.plantId,
      'plantName': instance.plantName,
      'gardenId': instance.gardenId,
      'analysis': instance.analysis,
      'recommendations': instance.recommendations,
      'plantingTiming': instance.plantingTiming,
      'activeAlerts': instance.activeAlerts,
      'intelligenceScore': instance.intelligenceScore,
      'confidence': instance.confidence,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'metadata': instance.metadata,
    };

_$PlantingTimingEvaluationImpl _$$PlantingTimingEvaluationImplFromJson(
        Map<String, dynamic> json) =>
    _$PlantingTimingEvaluationImpl(
      isOptimalTime: json['isOptimalTime'] as bool,
      timingScore: (json['timingScore'] as num).toDouble(),
      reason: json['reason'] as String,
      optimalPlantingDate: json['optimalPlantingDate'] == null
          ? null
          : DateTime.parse(json['optimalPlantingDate'] as String),
      favorableFactors: (json['favorableFactors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      unfavorableFactors: (json['unfavorableFactors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      risks:
          (json['risks'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$PlantingTimingEvaluationImplToJson(
        _$PlantingTimingEvaluationImpl instance) =>
    <String, dynamic>{
      'isOptimalTime': instance.isOptimalTime,
      'timingScore': instance.timingScore,
      'reason': instance.reason,
      'optimalPlantingDate': instance.optimalPlantingDate?.toIso8601String(),
      'favorableFactors': instance.favorableFactors,
      'unfavorableFactors': instance.unfavorableFactors,
      'risks': instance.risks,
    };

