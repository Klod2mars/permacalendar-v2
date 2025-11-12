// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bio_control_recommendation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BioControlRecommendationHiveAdapter
    extends TypeAdapter<BioControlRecommendationHive> {
  @override
  final int typeId = 53;

  @override
  BioControlRecommendationHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BioControlRecommendationHive()
      ..id = fields[0] as String
      ..pestObservationId = fields[1] as String
      ..type = fields[2] as String
      ..description = fields[3] as String
      ..actionDescriptions = (fields[4] as List).cast<String>()
      ..actionTimings = (fields[5] as List).cast<String>()
      ..priority = fields[6] as int
      ..effectivenessScore = fields[7] as double
      ..createdAt = fields[8] as DateTime?
      ..targetBeneficialId = fields[9] as String?
      ..targetPlantId = fields[10] as String?
      ..isApplied = fields[11] as bool?
      ..appliedAt = fields[12] as DateTime?
      ..userFeedback = fields[13] as String?;
  }

  @override
  void write(BinaryWriter writer, BioControlRecommendationHive obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pestObservationId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.actionDescriptions)
      ..writeByte(5)
      ..write(obj.actionTimings)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.effectivenessScore)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.targetBeneficialId)
      ..writeByte(10)
      ..write(obj.targetPlantId)
      ..writeByte(11)
      ..write(obj.isApplied)
      ..writeByte(12)
      ..write(obj.appliedAt)
      ..writeByte(13)
      ..write(obj.userFeedback);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BioControlRecommendationHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BioControlActionImpl _$$BioControlActionImplFromJson(
        Map<String, dynamic> json) =>
    _$BioControlActionImpl(
      description: json['description'] as String,
      timing: json['timing'] as String,
      resources:
          (json['resources'] as List<dynamic>).map((e) => e as String).toList(),
      detailedInstructions: json['detailedInstructions'] as String?,
      estimatedCostEuros: (json['estimatedCostEuros'] as num?)?.toInt(),
      estimatedTimeMinutes: (json['estimatedTimeMinutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$BioControlActionImplToJson(
        _$BioControlActionImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'timing': instance.timing,
      'resources': instance.resources,
      'detailedInstructions': instance.detailedInstructions,
      'estimatedCostEuros': instance.estimatedCostEuros,
      'estimatedTimeMinutes': instance.estimatedTimeMinutes,
    };

_$BioControlRecommendationImpl _$$BioControlRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$BioControlRecommendationImpl(
      id: json['id'] as String,
      pestObservationId: json['pestObservationId'] as String,
      type: $enumDecode(_$BioControlTypeEnumMap, json['type']),
      description: json['description'] as String,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => BioControlAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      priority: (json['priority'] as num).toInt(),
      effectivenessScore: (json['effectivenessScore'] as num).toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      targetBeneficialId: json['targetBeneficialId'] as String?,
      targetPlantId: json['targetPlantId'] as String?,
      isApplied: json['isApplied'] as bool?,
      appliedAt: json['appliedAt'] == null
          ? null
          : DateTime.parse(json['appliedAt'] as String),
      userFeedback: json['userFeedback'] as String?,
    );

Map<String, dynamic> _$$BioControlRecommendationImplToJson(
        _$BioControlRecommendationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pestObservationId': instance.pestObservationId,
      'type': _$BioControlTypeEnumMap[instance.type]!,
      'description': instance.description,
      'actions': instance.actions,
      'priority': instance.priority,
      'effectivenessScore': instance.effectivenessScore,
      'createdAt': instance.createdAt?.toIso8601String(),
      'targetBeneficialId': instance.targetBeneficialId,
      'targetPlantId': instance.targetPlantId,
      'isApplied': instance.isApplied,
      'appliedAt': instance.appliedAt?.toIso8601String(),
      'userFeedback': instance.userFeedback,
    };

const _$BioControlTypeEnumMap = {
  BioControlType.introduceBeneficial: 'introduceBeneficial',
  BioControlType.plantCompanion: 'plantCompanion',
  BioControlType.createHabitat: 'createHabitat',
  BioControlType.culturalPractice: 'culturalPractice',
};

