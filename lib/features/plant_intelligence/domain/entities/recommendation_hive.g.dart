// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationHiveAdapter extends TypeAdapter<RecommendationHive> {
  @override
  final int typeId = 39;

  @override
  RecommendationHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationHive(
      id: fields[0] as String,
      plantId: fields[1] as String,
      gardenId: fields[2] as String,
      typeIndex: fields[3] as int,
      priorityIndex: fields[4] as int,
      title: fields[5] as String,
      description: fields[6] as String,
      instructions: (fields[7] as List).cast<String>(),
      deadline: fields[8] as DateTime?,
      optimalConditions: (fields[9] as List?)?.cast<String>(),
      expectedImpact: fields[10] as double,
      metadata: (fields[11] as Map?)?.cast<String, dynamic>(),
      statusIndex: fields[12] as int,
      createdAt: fields[13] as DateTime?,
      completedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationHive obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plantId)
      ..writeByte(2)
      ..write(obj.gardenId)
      ..writeByte(3)
      ..write(obj.typeIndex)
      ..writeByte(4)
      ..write(obj.priorityIndex)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.instructions)
      ..writeByte(8)
      ..write(obj.deadline)
      ..writeByte(9)
      ..write(obj.optimalConditions)
      ..writeByte(10)
      ..write(obj.expectedImpact)
      ..writeByte(11)
      ..write(obj.metadata)
      ..writeByte(12)
      ..write(obj.statusIndex)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

