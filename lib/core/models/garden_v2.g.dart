// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_v2.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GardenAdapter extends TypeAdapter<Garden> {
  @override
  final int typeId = 10;

  @override
  Garden read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Garden(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      location: fields[3] as String,
      createdDate: fields[4] as DateTime,
      gardenBeds: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Garden obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.createdDate)
      ..writeByte(5)
      ..write(obj.gardenBeds);
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
