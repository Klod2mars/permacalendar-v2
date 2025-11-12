// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pest_observation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PestObservationHiveAdapter extends TypeAdapter<PestObservationHive> {
  @override
  final int typeId = 52;

  @override
  PestObservationHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PestObservationHive()
      ..id = fields[0] as String
      ..pestId = fields[1] as String
      ..plantId = fields[2] as String
      ..gardenId = fields[3] as String
      ..observedAt = fields[4] as DateTime
      ..severity = fields[5] as String
      ..bedId = fields[6] as String?
      ..notes = fields[7] as String?
      ..photoUrls = (fields[8] as List?)?.cast<String>()
      ..isActive = fields[9] as bool?
      ..resolvedAt = fields[10] as DateTime?
      ..resolutionMethod = fields[11] as String?;
  }

  @override
  void write(BinaryWriter writer, PestObservationHive obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pestId)
      ..writeByte(2)
      ..write(obj.plantId)
      ..writeByte(3)
      ..write(obj.gardenId)
      ..writeByte(4)
      ..write(obj.observedAt)
      ..writeByte(5)
      ..write(obj.severity)
      ..writeByte(6)
      ..write(obj.bedId)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.photoUrls)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.resolvedAt)
      ..writeByte(11)
      ..write(obj.resolutionMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PestObservationHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PestObservationImpl _$$PestObservationImplFromJson(
        Map<String, dynamic> json) =>
    _$PestObservationImpl(
      id: json['id'] as String,
      pestId: json['pestId'] as String,
      plantId: json['plantId'] as String,
      gardenId: json['gardenId'] as String,
      observedAt: DateTime.parse(json['observedAt'] as String),
      severity: $enumDecode(_$PestSeverityEnumMap, json['severity']),
      bedId: json['bedId'] as String?,
      notes: json['notes'] as String?,
      photoUrls: (json['photoUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isActive: json['isActive'] as bool?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      resolutionMethod: json['resolutionMethod'] as String?,
    );

Map<String, dynamic> _$$PestObservationImplToJson(
        _$PestObservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pestId': instance.pestId,
      'plantId': instance.plantId,
      'gardenId': instance.gardenId,
      'observedAt': instance.observedAt.toIso8601String(),
      'severity': _$PestSeverityEnumMap[instance.severity]!,
      'bedId': instance.bedId,
      'notes': instance.notes,
      'photoUrls': instance.photoUrls,
      'isActive': instance.isActive,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'resolutionMethod': instance.resolutionMethod,
    };

const _$PestSeverityEnumMap = {
  PestSeverity.low: 'low',
  PestSeverity.moderate: 'moderate',
  PestSeverity.high: 'high',
  PestSeverity.critical: 'critical',
};

