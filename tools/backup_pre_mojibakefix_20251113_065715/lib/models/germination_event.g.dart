// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'germination_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GerminationEventAdapter extends TypeAdapter<GerminationEvent> {
  @override
  final int typeId = 6;

  @override
  GerminationEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GerminationEvent(
      id: fields[0] as String?,
      date: fields[1] as DateTime?,
      plantingId: fields[2] as String,
      confirmedDate: fields[3] as DateTime?,
      userSoilTemp: fields[4] as double?,
      notes: fields[5] as String?,
      note: fields[6] as String?,
      weatherContext: (fields[7] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
      metadata: (fields[10] as Map?)?.cast<String, dynamic>(),
      isActive: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GerminationEvent obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.plantingId)
      ..writeByte(3)
      ..write(obj.confirmedDate)
      ..writeByte(4)
      ..write(obj.userSoilTemp)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.note)
      ..writeByte(7)
      ..write(obj.weatherContext)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.metadata)
      ..writeByte(11)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GerminationEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
