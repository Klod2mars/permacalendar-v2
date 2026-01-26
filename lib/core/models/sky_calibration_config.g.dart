// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sky_calibration_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkyCalibrationConfigAdapter extends TypeAdapter<SkyCalibrationConfig> {
  @override
  final int typeId = 44;

  @override
  SkyCalibrationConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SkyCalibrationConfig(
      cx: fields[0] as double,
      cy: fields[1] as double,
      rx: fields[2] as double,
      ry: fields[3] as double,
      rotation: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SkyCalibrationConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.cx)
      ..writeByte(1)
      ..write(obj.cy)
      ..writeByte(2)
      ..write(obj.rx)
      ..writeByte(3)
      ..write(obj.ry)
      ..writeByte(4)
      ..write(obj.rotation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkyCalibrationConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SkyCalibrationConfigImpl _$$SkyCalibrationConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$SkyCalibrationConfigImpl(
      cx: (json['cx'] as num?)?.toDouble() ?? 0.503,
      cy: (json['cy'] as num?)?.toDouble() ?? 0.226,
      rx: (json['rx'] as num?)?.toDouble() ?? 0.14,
      ry: (json['ry'] as num?)?.toDouble() ?? 0.105,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$SkyCalibrationConfigImplToJson(
        _$SkyCalibrationConfigImpl instance) =>
    <String, dynamic>{
      'cx': instance.cx,
      'cy': instance.cy,
      'rx': instance.rx,
      'ry': instance.ry,
      'rotation': instance.rotation,
    };
