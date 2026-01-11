// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_localized.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantLocalizedAdapter extends TypeAdapter<PlantLocalized> {
  @override
  final int typeId = 33;

  @override
  PlantLocalized read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantLocalized(
      id: fields[0] as String,
      scientificName: fields[1] as String,
      taxonomy: fields[2] as String,
      attributes: (fields[3] as Map).cast<String, dynamic>(),
      localized: (fields[4] as Map).cast<String, LocalizedPlantFields>(),
      lastUpdated: fields[5] as DateTime,
      schemaVersion: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlantLocalized obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.scientificName)
      ..writeByte(2)
      ..write(obj.taxonomy)
      ..writeByte(3)
      ..write(obj.attributes)
      ..writeByte(4)
      ..write(obj.localized)
      ..writeByte(5)
      ..write(obj.lastUpdated)
      ..writeByte(6)
      ..write(obj.schemaVersion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantLocalizedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocalizedPlantFieldsAdapter extends TypeAdapter<LocalizedPlantFields> {
  @override
  final int typeId = 133;

  @override
  LocalizedPlantFields read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalizedPlantFields(
      commonName: fields[0] as String,
      shortDescription: fields[1] as String,
      symptoms: (fields[2] as List).cast<String>(),
      quickAdvice: fields[3] as String,
      source: fields[4] as String,
      confidence: fields[5] as double,
      needsReview: fields[6] as bool,
      lastReviewedBy: fields[7] as String?,
      lastReviewedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalizedPlantFields obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.commonName)
      ..writeByte(1)
      ..write(obj.shortDescription)
      ..writeByte(2)
      ..write(obj.symptoms)
      ..writeByte(3)
      ..write(obj.quickAdvice)
      ..writeByte(4)
      ..write(obj.source)
      ..writeByte(5)
      ..write(obj.confidence)
      ..writeByte(6)
      ..write(obj.needsReview)
      ..writeByte(7)
      ..write(obj.lastReviewedBy)
      ..writeByte(8)
      ..write(obj.lastReviewedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalizedPlantFieldsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
