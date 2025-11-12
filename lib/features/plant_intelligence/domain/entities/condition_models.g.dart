// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemperatureConditionImpl _$$TemperatureConditionImplFromJson(
        Map<String, dynamic> json) =>
    _$TemperatureConditionImpl(
      current: (json['current'] as num).toDouble(),
      optimal: (json['optimal'] as num).toDouble(),
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      isOptimal: json['isOptimal'] as bool,
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$TemperatureConditionImplToJson(
        _$TemperatureConditionImpl instance) =>
    <String, dynamic>{
      'current': instance.current,
      'optimal': instance.optimal,
      'min': instance.min,
      'max': instance.max,
      'isOptimal': instance.isOptimal,
      'status': instance.status,
      'metadata': instance.metadata,
    };

_$MoistureConditionImpl _$$MoistureConditionImplFromJson(
        Map<String, dynamic> json) =>
    _$MoistureConditionImpl(
      current: (json['current'] as num).toDouble(),
      optimal: (json['optimal'] as num).toDouble(),
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      isOptimal: json['isOptimal'] as bool,
      status: json['status'] as String,
      measurementType: json['measurementType'] as String? ?? 'soil',
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$MoistureConditionImplToJson(
        _$MoistureConditionImpl instance) =>
    <String, dynamic>{
      'current': instance.current,
      'optimal': instance.optimal,
      'min': instance.min,
      'max': instance.max,
      'isOptimal': instance.isOptimal,
      'status': instance.status,
      'measurementType': instance.measurementType,
      'metadata': instance.metadata,
    };

_$LightConditionImpl _$$LightConditionImplFromJson(Map<String, dynamic> json) =>
    _$LightConditionImpl(
      current: (json['current'] as num).toDouble(),
      optimal: (json['optimal'] as num).toDouble(),
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      dailyHours: (json['dailyHours'] as num).toDouble(),
      optimalHours: (json['optimalHours'] as num).toDouble(),
      isOptimal: json['isOptimal'] as bool,
      status: json['status'] as String,
      exposureType: $enumDecode(_$ExposureTypeEnumMap, json['exposureType']),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$LightConditionImplToJson(
        _$LightConditionImpl instance) =>
    <String, dynamic>{
      'current': instance.current,
      'optimal': instance.optimal,
      'min': instance.min,
      'max': instance.max,
      'dailyHours': instance.dailyHours,
      'optimalHours': instance.optimalHours,
      'isOptimal': instance.isOptimal,
      'status': instance.status,
      'exposureType': _$ExposureTypeEnumMap[instance.exposureType]!,
      'metadata': instance.metadata,
    };

const _$ExposureTypeEnumMap = {
  ExposureType.fullSun: 'fullSun',
  ExposureType.partialSun: 'partialSun',
  ExposureType.partialShade: 'partialShade',
  ExposureType.fullShade: 'fullShade',
};

_$SoilConditionImpl _$$SoilConditionImplFromJson(Map<String, dynamic> json) =>
    _$SoilConditionImpl(
      ph: (json['ph'] as num).toDouble(),
      optimalPh: (json['optimalPh'] as num).toDouble(),
      minPh: (json['minPh'] as num).toDouble(),
      maxPh: (json['maxPh'] as num).toDouble(),
      soilType: $enumDecode(_$SoilTypeEnumMap, json['soilType']),
      nutrientLevel: (json['nutrientLevel'] as num).toDouble(),
      drainageLevel: (json['drainageLevel'] as num).toDouble(),
      compactionLevel: (json['compactionLevel'] as num).toDouble(),
      isOptimal: json['isOptimal'] as bool,
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$SoilConditionImplToJson(_$SoilConditionImpl instance) =>
    <String, dynamic>{
      'ph': instance.ph,
      'optimalPh': instance.optimalPh,
      'minPh': instance.minPh,
      'maxPh': instance.maxPh,
      'soilType': _$SoilTypeEnumMap[instance.soilType]!,
      'nutrientLevel': instance.nutrientLevel,
      'drainageLevel': instance.drainageLevel,
      'compactionLevel': instance.compactionLevel,
      'isOptimal': instance.isOptimal,
      'status': instance.status,
      'metadata': instance.metadata,
    };

const _$SoilTypeEnumMap = {
  SoilType.clay: 'clay',
  SoilType.sandy: 'sandy',
  SoilType.loamy: 'loamy',
  SoilType.chalky: 'chalky',
  SoilType.peaty: 'peaty',
};

_$RiskFactorImpl _$$RiskFactorImplFromJson(Map<String, dynamic> json) =>
    _$RiskFactorImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      severity: (json['severity'] as num).toDouble(),
      probability: (json['probability'] as num).toDouble(),
      preventiveActions: (json['preventiveActions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      favoringConditions: (json['favoringConditions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$RiskFactorImplToJson(_$RiskFactorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'severity': instance.severity,
      'probability': instance.probability,
      'preventiveActions': instance.preventiveActions,
      'favoringConditions': instance.favoringConditions,
      'metadata': instance.metadata,
    };

_$OpportunityImpl _$$OpportunityImplFromJson(Map<String, dynamic> json) =>
    _$OpportunityImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      benefit: (json['benefit'] as num).toDouble(),
      feasibility: (json['feasibility'] as num).toDouble(),
      recommendedActions: (json['recommendedActions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timeWindow: json['timeWindow'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$OpportunityImplToJson(_$OpportunityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'benefit': instance.benefit,
      'feasibility': instance.feasibility,
      'recommendedActions': instance.recommendedActions,
      'timeWindow': instance.timeWindow,
      'metadata': instance.metadata,
    };

_$WeatherForecastImpl _$$WeatherForecastImplFromJson(
        Map<String, dynamic> json) =>
    _$WeatherForecastImpl(
      date: DateTime.parse(json['date'] as String),
      minTemperature: (json['minTemperature'] as num).toDouble(),
      maxTemperature: (json['maxTemperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      precipitationProbability:
          (json['precipitationProbability'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      cloudCover: (json['cloudCover'] as num).toInt(),
      condition: json['condition'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$WeatherForecastImplToJson(
        _$WeatherForecastImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'minTemperature': instance.minTemperature,
      'maxTemperature': instance.maxTemperature,
      'humidity': instance.humidity,
      'precipitation': instance.precipitation,
      'precipitationProbability': instance.precipitationProbability,
      'windSpeed': instance.windSpeed,
      'cloudCover': instance.cloudCover,
      'condition': instance.condition,
      'metadata': instance.metadata,
    };

_$CompanionPlantImpl _$$CompanionPlantImplFromJson(Map<String, dynamic> json) =>
    _$CompanionPlantImpl(
      plantId: json['plantId'] as String,
      name: json['name'] as String,
      relationshipType: json['relationshipType'] as String,
      benefits:
          (json['benefits'] as List<dynamic>).map((e) => e as String).toList(),
      recommendedDistance: (json['recommendedDistance'] as num).toDouble(),
      optimalPeriod: json['optimalPeriod'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$CompanionPlantImplToJson(
        _$CompanionPlantImpl instance) =>
    <String, dynamic>{
      'plantId': instance.plantId,
      'name': instance.name,
      'relationshipType': instance.relationshipType,
      'benefits': instance.benefits,
      'recommendedDistance': instance.recommendedDistance,
      'optimalPeriod': instance.optimalPeriod,
      'metadata': instance.metadata,
    };

