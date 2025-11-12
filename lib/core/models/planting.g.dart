// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantingAdapter extends TypeAdapter<Planting> {
  @override
  final int typeId = 3;

  @override
  Planting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Planting(
      id: fields[0] as String?,
      gardenBedId: fields[1] as String,
      plantId: fields[2] as String,
      plantName: fields[3] as String,
      plantedDate: fields[4] as DateTime,
      expectedHarvestStartDate: fields[5] as DateTime?,
      expectedHarvestEndDate: fields[6] as DateTime?,
      actualHarvestDate: fields[7] as DateTime?,
      quantity: fields[8] as int,
      status: fields[9] as String,
      notes: fields[10] as String?,
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
      metadata: (fields[13] as Map?)?.cast<String, dynamic>(),
      isActive: fields[14] as bool,
      careActions: (fields[15] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Planting obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gardenBedId)
      ..writeByte(2)
      ..write(obj.plantId)
      ..writeByte(3)
      ..write(obj.plantName)
      ..writeByte(4)
      ..write(obj.plantedDate)
      ..writeByte(5)
      ..write(obj.expectedHarvestStartDate)
      ..writeByte(6)
      ..write(obj.expectedHarvestEndDate)
      ..writeByte(7)
      ..write(obj.actualHarvestDate)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.metadata)
      ..writeByte(14)
      ..write(obj.isActive)
      ..writeByte(15)
      ..write(obj.careActions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

