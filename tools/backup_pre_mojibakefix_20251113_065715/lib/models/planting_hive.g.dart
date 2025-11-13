// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planting_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantingHiveAdapter extends TypeAdapter<PlantingHive> {
  @override
  final int typeId = 27;

  @override
  PlantingHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantingHive(
      id: fields[0] as String,
      plantId: fields[1] as String,
      gardenBedId: fields[2] as String,
      plantingDate: fields[3] as DateTime,
      status: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlantingHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plantId)
      ..writeByte(2)
      ..write(obj.gardenBedId)
      ..writeByte(3)
      ..write(obj.plantingDate)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantingHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
