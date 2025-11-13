// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beneficial_insect.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BeneficialInsectHiveAdapter extends TypeAdapter<BeneficialInsectHive> {
  @override
  final int typeId = 51;

  @override
  BeneficialInsectHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BeneficialInsectHive()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..scientificName = fields[2] as String
      ..preyPests = (fields[3] as List).cast<String>()
      ..attractiveFlowers = (fields[4] as List).cast<String>()
      ..habitatNeedsWater = fields[5] as bool
      ..habitatNeedsShelter = fields[6] as bool
      ..habitatFavorableConditions = (fields[7] as List).cast<String>()
      ..lifeCycle = fields[8] as String
      ..description = fields[9] as String?
      ..imageUrl = fields[10] as String?
      ..effectiveness = fields[11] as int?;
  }

  @override
  void write(BinaryWriter writer, BeneficialInsectHive obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.scientificName)
      ..writeByte(3)
      ..write(obj.preyPests)
      ..writeByte(4)
      ..write(obj.attractiveFlowers)
      ..writeByte(5)
      ..write(obj.habitatNeedsWater)
      ..writeByte(6)
      ..write(obj.habitatNeedsShelter)
      ..writeByte(7)
      ..write(obj.habitatFavorableConditions)
      ..writeByte(8)
      ..write(obj.lifeCycle)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.imageUrl)
      ..writeByte(11)
      ..write(obj.effectiveness);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeneficialInsectHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitatRequirementsImpl _$$HabitatRequirementsImplFromJson(
        Map<String, dynamic> json) =>
    _$HabitatRequirementsImpl(
      needsWater: json['needsWater'] as bool,
      needsShelter: json['needsShelter'] as bool,
      favorableConditions: (json['favorableConditions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$HabitatRequirementsImplToJson(
        _$HabitatRequirementsImpl instance) =>
    <String, dynamic>{
      'needsWater': instance.needsWater,
      'needsShelter': instance.needsShelter,
      'favorableConditions': instance.favorableConditions,
    };

_$BeneficialInsectImpl _$$BeneficialInsectImplFromJson(
        Map<String, dynamic> json) =>
    _$BeneficialInsectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      scientificName: json['scientificName'] as String,
      preyPests:
          (json['preyPests'] as List<dynamic>).map((e) => e as String).toList(),
      attractiveFlowers: (json['attractiveFlowers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      habitat:
          HabitatRequirements.fromJson(json['habitat'] as Map<String, dynamic>),
      lifeCycle: json['lifeCycle'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      effectiveness: (json['effectiveness'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$BeneficialInsectImplToJson(
        _$BeneficialInsectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'scientificName': instance.scientificName,
      'preyPests': instance.preyPests,
      'attractiveFlowers': instance.attractiveFlowers,
      'habitat': instance.habitat,
      'lifeCycle': instance.lifeCycle,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'effectiveness': instance.effectiveness,
    };
