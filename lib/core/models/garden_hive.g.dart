// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GardenHiveAdapter extends TypeAdapter<GardenHive> {
  @override
  final int typeId = 25;

  @override
  GardenHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GardenHive(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      createdDate: fields[3] as DateTime,
      gardenBeds: (fields[4] as List).cast<GardenBedHive>(),
    );
  }

  @override
  void write(BinaryWriter writer, GardenHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdDate)
      ..writeByte(4)
      ..write(obj.gardenBeds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GardenHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
