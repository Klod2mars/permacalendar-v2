// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntitlementAdapter extends TypeAdapter<Entitlement> {
  @override
  final int typeId = 61;

  @override
  Entitlement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Entitlement(
      isPremium: fields[0] as bool,
      productId: fields[1] as String?,
      expiresAt: fields[2] as DateTime?,
      source: fields[3] as String?,
      lastValidatedAt: fields[4] as DateTime?,
      metadata: (fields[5] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Entitlement obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isPremium)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.expiresAt)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.lastValidatedAt)
      ..writeByte(5)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntitlementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
