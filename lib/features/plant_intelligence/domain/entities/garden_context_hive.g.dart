// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_context_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GardenContextHiveAdapter extends TypeAdapter<GardenContextHive> {
  @override
  final int typeId = 50;

  @override
  GardenContextHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GardenContextHive(
      gardenId: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      address: fields[5] as String?,
      city: fields[6] as String?,
      postalCode: fields[7] as String?,
      country: fields[8] as String?,
      usdaZone: fields[9] as String?,
      altitude: fields[10] as double?,
      exposure: fields[11] as String?,
      averageTemperature: fields[12] as double,
      minTemperature: fields[13] as double,
      maxTemperature: fields[14] as double,
      averagePrecipitation: fields[15] as double,
      averageHumidity: fields[16] as double,
      frostDays: fields[17] as int,
      growingSeasonLength: fields[18] as int,
      dominantWindDirection: fields[19] as String?,
      averageWindSpeed: fields[20] as double?,
      averageSunshineHours: fields[21] as double?,
      soilType: fields[22] as int,
      ph: fields[23] as double,
      soilTexture: fields[24] as int,
      organicMatter: fields[25] as double,
      waterRetention: fields[26] as double,
      soilDrainage: fields[27] as int,
      depth: fields[28] as double,
      nitrogen: fields[29] as int,
      phosphorus: fields[30] as int,
      potassium: fields[31] as int,
      calcium: fields[32] as int,
      magnesium: fields[33] as int,
      sulfur: fields[34] as int,
      biologicalActivity: fields[35] as int,
      contaminants: (fields[36] as List?)?.cast<String>(),
      activePlantIds: (fields[37] as List).cast<String>(),
      historicalPlantIds: (fields[38] as List).cast<String>(),
      totalPlants: fields[39] as int,
      activePlants: fields[40] as int,
      totalArea: fields[41] as double,
      activeArea: fields[42] as double,
      totalYield: fields[43] as double,
      currentYearYield: fields[44] as double,
      harvestsThisYear: fields[45] as int,
      plantingsThisYear: fields[46] as int,
      successRate: fields[47] as double,
      totalInputCosts: fields[48] as double,
      totalHarvestValue: fields[49] as double,
      cultivationMethod: fields[50] as int,
      usePesticides: fields[51] as bool,
      useChemicalFertilizers: fields[52] as bool,
      useOrganicFertilizers: fields[53] as bool,
      cropRotation: fields[54] as bool,
      companionPlanting: fields[55] as bool,
      mulching: fields[56] as bool,
      automaticIrrigation: fields[57] as bool,
      regularMonitoring: fields[58] as bool,
      objectives: (fields[59] as List).cast<String>(),
      createdAt: fields[60] as DateTime?,
      updatedAt: fields[61] as DateTime?,
      metadata: (fields[62] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, GardenContextHive obj) {
    writer
      ..writeByte(63)
      ..writeByte(0)
      ..write(obj.gardenId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(7)
      ..write(obj.postalCode)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.usdaZone)
      ..writeByte(10)
      ..write(obj.altitude)
      ..writeByte(11)
      ..write(obj.exposure)
      ..writeByte(12)
      ..write(obj.averageTemperature)
      ..writeByte(13)
      ..write(obj.minTemperature)
      ..writeByte(14)
      ..write(obj.maxTemperature)
      ..writeByte(15)
      ..write(obj.averagePrecipitation)
      ..writeByte(16)
      ..write(obj.averageHumidity)
      ..writeByte(17)
      ..write(obj.frostDays)
      ..writeByte(18)
      ..write(obj.growingSeasonLength)
      ..writeByte(19)
      ..write(obj.dominantWindDirection)
      ..writeByte(20)
      ..write(obj.averageWindSpeed)
      ..writeByte(21)
      ..write(obj.averageSunshineHours)
      ..writeByte(22)
      ..write(obj.soilType)
      ..writeByte(23)
      ..write(obj.ph)
      ..writeByte(24)
      ..write(obj.soilTexture)
      ..writeByte(25)
      ..write(obj.organicMatter)
      ..writeByte(26)
      ..write(obj.waterRetention)
      ..writeByte(27)
      ..write(obj.soilDrainage)
      ..writeByte(28)
      ..write(obj.depth)
      ..writeByte(29)
      ..write(obj.nitrogen)
      ..writeByte(30)
      ..write(obj.phosphorus)
      ..writeByte(31)
      ..write(obj.potassium)
      ..writeByte(32)
      ..write(obj.calcium)
      ..writeByte(33)
      ..write(obj.magnesium)
      ..writeByte(34)
      ..write(obj.sulfur)
      ..writeByte(35)
      ..write(obj.biologicalActivity)
      ..writeByte(36)
      ..write(obj.contaminants)
      ..writeByte(37)
      ..write(obj.activePlantIds)
      ..writeByte(38)
      ..write(obj.historicalPlantIds)
      ..writeByte(39)
      ..write(obj.totalPlants)
      ..writeByte(40)
      ..write(obj.activePlants)
      ..writeByte(41)
      ..write(obj.totalArea)
      ..writeByte(42)
      ..write(obj.activeArea)
      ..writeByte(43)
      ..write(obj.totalYield)
      ..writeByte(44)
      ..write(obj.currentYearYield)
      ..writeByte(45)
      ..write(obj.harvestsThisYear)
      ..writeByte(46)
      ..write(obj.plantingsThisYear)
      ..writeByte(47)
      ..write(obj.successRate)
      ..writeByte(48)
      ..write(obj.totalInputCosts)
      ..writeByte(49)
      ..write(obj.totalHarvestValue)
      ..writeByte(50)
      ..write(obj.cultivationMethod)
      ..writeByte(51)
      ..write(obj.usePesticides)
      ..writeByte(52)
      ..write(obj.useChemicalFertilizers)
      ..writeByte(53)
      ..write(obj.useOrganicFertilizers)
      ..writeByte(54)
      ..write(obj.cropRotation)
      ..writeByte(55)
      ..write(obj.companionPlanting)
      ..writeByte(56)
      ..write(obj.mulching)
      ..writeByte(57)
      ..write(obj.automaticIrrigation)
      ..writeByte(58)
      ..write(obj.regularMonitoring)
      ..writeByte(59)
      ..write(obj.objectives)
      ..writeByte(60)
      ..write(obj.createdAt)
      ..writeByte(61)
      ..write(obj.updatedAt)
      ..writeByte(62)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GardenContextHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

