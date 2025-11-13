// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PestHiveAdapter extends TypeAdapter<PestHive> {
  @override
  final int typeId = 50;

  @override
  PestHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PestHive()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..scientificName = fields[2] as String
      ..affectedPlants = (fields[3] as List).cast<String>()
      ..defaultSeverity = fields[4] as String
      ..symptoms = (fields[5] as List).cast<String>()
      ..naturalPredators = (fields[6] as List).cast<String>()
      ..repellentPlants = (fields[7] as List).cast<String>()
      ..description = fields[8] as String?
      ..imageUrl = fields[9] as String?
      ..preventionTips = fields[10] as String?;
  }

  @override
  void write(BinaryWriter writer, PestHive obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.scientificName)
      ..writeByte(3)
      ..write(obj.affectedPlants)
      ..writeByte(4)
      ..write(obj.defaultSeverity)
      ..writeByte(5)
      ..write(obj.symptoms)
      ..writeByte(6)
      ..write(obj.naturalPredators)
      ..writeByte(7)
      ..write(obj.repellentPlants)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.imageUrl)
      ..writeByte(10)
      ..write(obj.preventionTips);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PestHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PestImpl _$$PestImplFromJson(Map<String, dynamic> json) => _$PestImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      scientificName: json['scientificName'] as String,
      affectedPlants: (json['affectedPlants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      defaultSeverity:
          $enumDecode(_$PestSeverityEnumMap, json['defaultSeverity']),
      symptoms:
          (json['symptoms'] as List<dynamic>).map((e) => e as String).toList(),
      naturalPredators: (json['naturalPredators'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      repellentPlants: (json['repellentPlants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      preventionTips: json['preventionTips'] as String?,
    );

Map<String, dynamic> _$$PestImplToJson(_$PestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'scientificName': instance.scientificName,
      'affectedPlants': instance.affectedPlants,
      'defaultSeverity': _$PestSeverityEnumMap[instance.defaultSeverity]!,
      'symptoms': instance.symptoms,
      'naturalPredators': instance.naturalPredators,
      'repellentPlants': instance.repellentPlants,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'preventionTips': instance.preventionTips,
    };

const _$PestSeverityEnumMap = {
  PestSeverity.low: 'low',
  PestSeverity.moderate: 'moderate',
  PestSeverity.high: 'high',
  PestSeverity.critical: 'critical',
};
