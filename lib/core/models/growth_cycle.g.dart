// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_cycle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GrowthCycleAdapter extends TypeAdapter<GrowthCycle> {
  @override
  final int typeId = 5;

  @override
  GrowthCycle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrowthCycle(
      id: fields[0] as String?,
      plantId: fields[1] as String,
      phaseName: fields[2] as String,
      description: fields[3] as String,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      durationInDays: fields[6] as int,
      careInstructions: (fields[7] as List?)?.cast<String>(),
      requirements: (fields[8] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
      isActive: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GrowthCycle obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plantId)
      ..writeByte(2)
      ..write(obj.phaseName)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.durationInDays)
      ..writeByte(7)
      ..write(obj.careInstructions)
      ..writeByte(8)
      ..write(obj.requirements)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrowthCycleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
