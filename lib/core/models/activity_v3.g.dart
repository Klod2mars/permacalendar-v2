// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_v3.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityV3Adapter extends TypeAdapter<ActivityV3> {
  @override
  final int typeId = 30;

  @override
  ActivityV3 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityV3(
      id: fields[0] as String,
      type: fields[1] as String,
      description: fields[2] as String,
      timestamp: fields[3] as DateTime,
      metadata: (fields[4] as Map?)?.cast<String, dynamic>(),
      isActive: fields[5] as bool,
      priority: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityV3 obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.metadata)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityV3Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityV3Impl _$$ActivityV3ImplFromJson(Map<String, dynamic> json) =>
    _$ActivityV3Impl(
      id: json['id'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ActivityV3ImplToJson(_$ActivityV3Impl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
      'isActive': instance.isActive,
      'priority': instance.priority,
    };

