// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_evolution_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantEvolutionReportImpl _$$PlantEvolutionReportImplFromJson(
        Map<String, dynamic> json) =>
    _$PlantEvolutionReportImpl(
      plantId: json['plantId'] as String,
      previousDate: DateTime.parse(json['previousDate'] as String),
      currentDate: DateTime.parse(json['currentDate'] as String),
      previousScore: (json['previousScore'] as num).toDouble(),
      currentScore: (json['currentScore'] as num).toDouble(),
      deltaScore: (json['deltaScore'] as num).toDouble(),
      trend: json['trend'] as String,
      improvedConditions: (json['improvedConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      degradedConditions: (json['degradedConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      unchangedConditions: (json['unchangedConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PlantEvolutionReportImplToJson(
        _$PlantEvolutionReportImpl instance) =>
    <String, dynamic>{
      'plantId': instance.plantId,
      'previousDate': instance.previousDate.toIso8601String(),
      'currentDate': instance.currentDate.toIso8601String(),
      'previousScore': instance.previousScore,
      'currentScore': instance.currentScore,
      'deltaScore': instance.deltaScore,
      'trend': instance.trend,
      'improvedConditions': instance.improvedConditions,
      'degradedConditions': instance.degradedConditions,
      'unchangedConditions': instance.unchangedConditions,
    };

