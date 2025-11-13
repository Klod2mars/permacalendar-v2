// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_variety.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantVarietyAdapter extends TypeAdapter<PlantVariety> {
  @override
  final int typeId = 4;

  @override
  PlantVariety read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantVariety(
      id: fields[0] as String?,
      plantId: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      daysToMaturity: fields[4] as int,
      imageUrl: fields[5] as String?,
      characteristics: (fields[6] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
      isActive: fields[9] as bool,
      notes: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlantVariety obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plantId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.daysToMaturity)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.characteristics)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantVarietyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
