// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_bed_v2.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GardenBedAdapter extends TypeAdapter<GardenBed> {
  @override
  final int typeId = 11;

  @override
  GardenBed read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GardenBed(
      id: fields[0] as String,
      name: fields[1] as String,
      sizeInSquareMeters: fields[2] as double,
      gardenId: fields[3] as String,
      plantings: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, GardenBed obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sizeInSquareMeters)
      ..writeByte(3)
      ..write(obj.gardenId)
      ..writeByte(4)
      ..write(obj.plantings);
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
