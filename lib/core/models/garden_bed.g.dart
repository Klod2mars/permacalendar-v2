// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_bed.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GardenBedAdapter extends TypeAdapter<GardenBed> {
  @override
  final int typeId = 1;

  @override
  GardenBed read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GardenBed(
      id: fields[0] as String?,
      gardenId: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      sizeInSquareMeters: fields[4] as double,
      soilType: fields[5] as String,
      exposure: fields[6] as String,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
      metadata: (fields[9] as Map?)?.cast<String, dynamic>(),
      isActive: fields[10] as bool,
      notes: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GardenBed obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gardenId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.sizeInSquareMeters)
      ..writeByte(5)
      ..write(obj.soilType)
      ..writeByte(6)
      ..write(obj.exposure)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.metadata)
      ..writeByte(10)
      ..write(obj.isActive)
      ..writeByte(11)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GardenBedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
