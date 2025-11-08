// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_health_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantHealthLevelAdapter extends TypeAdapter<PlantHealthLevel> {
  @override
  final int typeId = 54;

  @override
  PlantHealthLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlantHealthLevel.excellent;
      case 1:
        return PlantHealthLevel.good;
      case 2:
        return PlantHealthLevel.fair;
      case 3:
        return PlantHealthLevel.poor;
      case 4:
        return PlantHealthLevel.critical;
      default:
        return PlantHealthLevel.excellent;
    }
  }

  @override
  void write(BinaryWriter writer, PlantHealthLevel obj) {
    switch (obj) {
      case PlantHealthLevel.excellent:
        writer.writeByte(0);
        break;
      case PlantHealthLevel.good:
        writer.writeByte(1);
        break;
      case PlantHealthLevel.fair:
        writer.writeByte(2);
        break;
      case PlantHealthLevel.poor:
        writer.writeByte(3);
        break;
      case PlantHealthLevel.critical:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantHealthLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlantHealthFactorAdapter extends TypeAdapter<PlantHealthFactor> {
  @override
  final int typeId = 55;

  @override
  PlantHealthFactor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlantHealthFactor.humidity;
      case 1:
        return PlantHealthFactor.light;
      case 2:
        return PlantHealthFactor.temperature;
      case 3:
        return PlantHealthFactor.nutrients;
      case 4:
        return PlantHealthFactor.soilMoisture;
      case 5:
        return PlantHealthFactor.waterStress;
      case 6:
        return PlantHealthFactor.pestPressure;
      default:
        return PlantHealthFactor.humidity;
    }
  }

  @override
  void write(BinaryWriter writer, PlantHealthFactor obj) {
    switch (obj) {
      case PlantHealthFactor.humidity:
        writer.writeByte(0);
        break;
      case PlantHealthFactor.light:
        writer.writeByte(1);
        break;
      case PlantHealthFactor.temperature:
        writer.writeByte(2);
        break;
      case PlantHealthFactor.nutrients:
        writer.writeByte(3);
        break;
      case PlantHealthFactor.soilMoisture:
        writer.writeByte(4);
        break;
      case PlantHealthFactor.waterStress:
        writer.writeByte(5);
        break;
      case PlantHealthFactor.pestPressure:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantHealthFactorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlantHealthComponentAdapter
    extends TypeAdapter<_$PlantHealthComponentImpl> {
  @override
  final int typeId = 56;

  @override
  _$PlantHealthComponentImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$PlantHealthComponentImpl(
      factor: fields[0] as PlantHealthFactor,
      score: fields[1] as double,
      level: fields[2] as PlantHealthLevel,
      value: fields[3] as double?,
      optimalValue: fields[4] as double?,
      minValue: fields[5] as double?,
      maxValue: fields[6] as double?,
      unit: fields[7] as String?,
      trend: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, _$PlantHealthComponentImpl obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.factor)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.value)
      ..writeByte(4)
      ..write(obj.optimalValue)
      ..writeByte(5)
      ..write(obj.minValue)
      ..writeByte(6)
      ..write(obj.maxValue)
      ..writeByte(7)
      ..write(obj.unit)
      ..writeByte(8)
      ..write(obj.trend);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantHealthComponentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlantHealthStatusAdapter extends TypeAdapter<_$PlantHealthStatusImpl> {
  @override
  final int typeId = 57;

  @override
  _$PlantHealthStatusImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$PlantHealthStatusImpl(
      plantId: fields[0] as String,
      gardenId: fields[1] as String,
      overallScore: fields[2] as double,
      level: fields[3] as PlantHealthLevel,
      humidity: fields[4] as PlantHealthComponent,
      light: fields[5] as PlantHealthComponent,
      temperature: fields[6] as PlantHealthComponent,
      nutrients: fields[7] as PlantHealthComponent,
      soilMoisture: fields[8] as PlantHealthComponent?,
      waterStress: fields[9] as PlantHealthComponent?,
      pestPressure: fields[10] as PlantHealthComponent?,
      lastUpdated: fields[11] as DateTime,
      lastSyncedAt: fields[12] as DateTime?,
      activeAlerts: (fields[13] as List).cast<String>(),
      recommendedActions: (fields[14] as List).cast<String>(),
      healthTrend: fields[15] as String,
      factorTrends: (fields[16] as Map).cast<String, double>(),
      metadata: (fields[17] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, _$PlantHealthStatusImpl obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.plantId)
      ..writeByte(1)
      ..write(obj.gardenId)
      ..writeByte(2)
      ..write(obj.overallScore)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.humidity)
      ..writeByte(5)
      ..write(obj.light)
      ..writeByte(6)
      ..write(obj.temperature)
      ..writeByte(7)
      ..write(obj.nutrients)
      ..writeByte(8)
      ..write(obj.soilMoisture)
      ..writeByte(9)
      ..write(obj.waterStress)
      ..writeByte(10)
      ..write(obj.pestPressure)
      ..writeByte(11)
      ..write(obj.lastUpdated)
      ..writeByte(12)
      ..write(obj.lastSyncedAt)
      ..writeByte(15)
      ..write(obj.healthTrend)
      ..writeByte(13)
      ..write(obj.activeAlerts)
      ..writeByte(14)
      ..write(obj.recommendedActions)
      ..writeByte(16)
      ..write(obj.factorTrends)
      ..writeByte(17)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantHealthStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlantHealthComponentImpl _$$PlantHealthComponentImplFromJson(
        Map<String, dynamic> json) =>
    _$PlantHealthComponentImpl(
      factor: $enumDecode(_$PlantHealthFactorEnumMap, json['factor']),
      score: (json['score'] as num).toDouble(),
      level: $enumDecode(_$PlantHealthLevelEnumMap, json['level']),
      value: (json['value'] as num?)?.toDouble(),
      optimalValue: (json['optimalValue'] as num?)?.toDouble(),
      minValue: (json['minValue'] as num?)?.toDouble(),
      maxValue: (json['maxValue'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      trend: json['trend'] as String? ?? 'stable',
    );

Map<String, dynamic> _$$PlantHealthComponentImplToJson(
        _$PlantHealthComponentImpl instance) =>
    <String, dynamic>{
      'factor': _$PlantHealthFactorEnumMap[instance.factor]!,
      'score': instance.score,
      'level': _$PlantHealthLevelEnumMap[instance.level]!,
      'value': instance.value,
      'optimalValue': instance.optimalValue,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'unit': instance.unit,
      'trend': instance.trend,
    };

const _$PlantHealthFactorEnumMap = {
  PlantHealthFactor.humidity: 'humidity',
  PlantHealthFactor.light: 'light',
  PlantHealthFactor.temperature: 'temperature',
  PlantHealthFactor.nutrients: 'nutrients',
  PlantHealthFactor.soilMoisture: 'soilMoisture',
  PlantHealthFactor.waterStress: 'waterStress',
  PlantHealthFactor.pestPressure: 'pestPressure',
};

const _$PlantHealthLevelEnumMap = {
  PlantHealthLevel.excellent: 'excellent',
  PlantHealthLevel.good: 'good',
  PlantHealthLevel.fair: 'fair',
  PlantHealthLevel.poor: 'poor',
  PlantHealthLevel.critical: 'critical',
};

_$PlantHealthStatusImpl _$$PlantHealthStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$PlantHealthStatusImpl(
      plantId: json['plantId'] as String,
      gardenId: json['gardenId'] as String,
      overallScore: (json['overallScore'] as num).toDouble(),
      level: $enumDecode(_$PlantHealthLevelEnumMap, json['level']),
      humidity: PlantHealthComponent.fromJson(
          json['humidity'] as Map<String, dynamic>),
      light:
          PlantHealthComponent.fromJson(json['light'] as Map<String, dynamic>),
      temperature: PlantHealthComponent.fromJson(
          json['temperature'] as Map<String, dynamic>),
      nutrients: PlantHealthComponent.fromJson(
          json['nutrients'] as Map<String, dynamic>),
      soilMoisture: json['soilMoisture'] == null
          ? null
          : PlantHealthComponent.fromJson(
              json['soilMoisture'] as Map<String, dynamic>),
      waterStress: json['waterStress'] == null
          ? null
          : PlantHealthComponent.fromJson(
              json['waterStress'] as Map<String, dynamic>),
      pestPressure: json['pestPressure'] == null
          ? null
          : PlantHealthComponent.fromJson(
              json['pestPressure'] as Map<String, dynamic>),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      activeAlerts: (json['activeAlerts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      recommendedActions: (json['recommendedActions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      healthTrend: json['healthTrend'] as String? ?? 'unknown',
      factorTrends: (json['factorTrends'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const <String, double>{},
      metadata: json['metadata'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );

Map<String, dynamic> _$$PlantHealthStatusImplToJson(
        _$PlantHealthStatusImpl instance) =>
    <String, dynamic>{
      'plantId': instance.plantId,
      'gardenId': instance.gardenId,
      'overallScore': instance.overallScore,
      'level': _$PlantHealthLevelEnumMap[instance.level]!,
      'humidity': instance.humidity.toJson(),
      'light': instance.light.toJson(),
      'temperature': instance.temperature.toJson(),
      'nutrients': instance.nutrients.toJson(),
      'soilMoisture': instance.soilMoisture?.toJson(),
      'waterStress': instance.waterStress?.toJson(),
      'pestPressure': instance.pestPressure?.toJson(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'activeAlerts': instance.activeAlerts,
      'recommendedActions': instance.recommendedActions,
      'healthTrend': instance.healthTrend,
      'factorTrends': instance.factorTrends,
      'metadata': instance.metadata,
    };
