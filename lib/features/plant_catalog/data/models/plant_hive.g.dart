// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantHiveAdapter extends TypeAdapter<PlantHive> {
  @override
  final int typeId = 29;

  @override
  PlantHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantHive(
      id: fields[0] as String,
      commonName: fields[1] as String,
      scientificName: fields[2] as String,
      family: fields[3] as String,
      plantingSeason: fields[4] as String,
      harvestSeason: fields[5] as String,
      daysToMaturity: fields[6] as int,
      spacing: fields[7] as int,
      depth: fields[8] as double,
      sunExposure: fields[9] as String,
      waterNeeds: fields[10] as String,
      description: fields[11] as String,
      sowingMonths: (fields[12] as List).cast<String>(),
      harvestMonths: (fields[13] as List).cast<String>(),
      marketPricePerKg: fields[14] as double?,
      defaultUnit: fields[15] as String?,
      nutritionPer100g: (fields[16] as Map?)?.cast<String, dynamic>(),
      germination: (fields[17] as Map?)?.cast<String, dynamic>(),
      growth: (fields[18] as Map?)?.cast<String, dynamic>(),
      watering: (fields[19] as Map?)?.cast<String, dynamic>(),
      thinning: (fields[20] as Map?)?.cast<String, dynamic>(),
      weeding: (fields[21] as Map?)?.cast<String, dynamic>(),
      culturalTips: (fields[22] as List?)?.cast<String>(),
      biologicalControl: (fields[23] as Map?)?.cast<String, dynamic>(),
      harvestTime: fields[24] as String?,
      companionPlanting: (fields[25] as Map?)?.cast<String, dynamic>(),
      notificationSettings: (fields[26] as Map?)?.cast<String, dynamic>(),
      varieties: (fields[27] as Map?)?.cast<String, dynamic>(),
      metadata: (fields[28] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[29] as DateTime?,
      updatedAt: fields[30] as DateTime?,
      isActive: fields[31] as bool,
      referenceProfile: (fields[32] as Map?)?.cast<String, dynamic>(),
      zoneProfiles: (fields[33] as Map?)?.cast<String, dynamic>(),
      notes: fields[34] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlantHive obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.commonName)
      ..writeByte(2)
      ..write(obj.scientificName)
      ..writeByte(3)
      ..write(obj.family)
      ..writeByte(4)
      ..write(obj.plantingSeason)
      ..writeByte(5)
      ..write(obj.harvestSeason)
      ..writeByte(6)
      ..write(obj.daysToMaturity)
      ..writeByte(7)
      ..write(obj.spacing)
      ..writeByte(8)
      ..write(obj.depth)
      ..writeByte(9)
      ..write(obj.sunExposure)
      ..writeByte(10)
      ..write(obj.waterNeeds)
      ..writeByte(11)
      ..write(obj.description)
      ..writeByte(12)
      ..write(obj.sowingMonths)
      ..writeByte(13)
      ..write(obj.harvestMonths)
      ..writeByte(14)
      ..write(obj.marketPricePerKg)
      ..writeByte(15)
      ..write(obj.defaultUnit)
      ..writeByte(16)
      ..write(obj.nutritionPer100g)
      ..writeByte(17)
      ..write(obj.germination)
      ..writeByte(18)
      ..write(obj.growth)
      ..writeByte(19)
      ..write(obj.watering)
      ..writeByte(20)
      ..write(obj.thinning)
      ..writeByte(21)
      ..write(obj.weeding)
      ..writeByte(22)
      ..write(obj.culturalTips)
      ..writeByte(23)
      ..write(obj.biologicalControl)
      ..writeByte(24)
      ..write(obj.harvestTime)
      ..writeByte(25)
      ..write(obj.companionPlanting)
      ..writeByte(26)
      ..write(obj.notificationSettings)
      ..writeByte(27)
      ..write(obj.varieties)
      ..writeByte(28)
      ..write(obj.metadata)
      ..writeByte(29)
      ..write(obj.createdAt)
      ..writeByte(30)
      ..write(obj.updatedAt)
      ..writeByte(31)
      ..write(obj.isActive)
      ..writeByte(32)
      ..write(obj.referenceProfile)
      ..writeByte(33)
      ..write(obj.zoneProfiles)
      ..writeByte(34)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
