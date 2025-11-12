// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_condition_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantConditionHiveAdapter extends TypeAdapter<PlantConditionHive> {
  @override
  final int typeId = 43;

  @override
  PlantConditionHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantConditionHive(
      id: fields[0] as String,
      plantId: fields[1] as String,
      gardenId: fields[2] as String,
      typeIndex: fields[3] as int,
      statusIndex: fields[4] as int,
      value: fields[5] as double,
      optimalValue: fields[6] as double,
      minValue: fields[7] as double,
      maxValue: fields[8] as double,
      unit: fields[9] as String,
      description: fields[10] as String?,
      recommendations: (fields[11] as List?)?.cast<String>(),
      measuredAt: fields[12] as DateTime,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PlantConditionHive obj) {
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
      ..write(obj.statusIndex)
      ..writeByte(5)
      ..write(obj.value)
      ..writeByte(6)
      ..write(obj.optimalValue)
      ..writeByte(7)
      ..write(obj.minValue)
      ..writeByte(8)
      ..write(obj.maxValue)
      ..writeByte(9)
      ..write(obj.unit)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.recommendations)
      ..writeByte(12)
      ..write(obj.measuredAt)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantConditionHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

