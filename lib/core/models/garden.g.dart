// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GardenAdapter extends TypeAdapter<Garden> {
  @override
  final int typeId = 0;

  @override
  Garden read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Garden(
      id: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String,
      totalAreaInSquareMeters: fields[3] as double,
      location: fields[4] as String,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
      imageUrl: fields[7] as String?,
      metadata: (fields[8] as Map?)?.cast<String, dynamic>(),
      isActive: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Garden obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.totalAreaInSquareMeters)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.metadata)
      ..writeByte(9)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GardenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

