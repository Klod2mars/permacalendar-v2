// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calibration_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalibrationTypeAdapter extends TypeAdapter<CalibrationType> {
  @override
  final int typeId = 61;

  @override
  CalibrationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CalibrationType.none;
      case 1:
        return CalibrationType.organic;
      default:
        return CalibrationType.none;
    }
  }

  @override
  void write(BinaryWriter writer, CalibrationType obj) {
    switch (obj) {
      case CalibrationType.none:
        writer.writeByte(0);
        break;
      case CalibrationType.organic:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalibrationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalibrationStateAdapter extends TypeAdapter<_$CalibrationStateImpl> {
  @override
  final int typeId = 60;

  @override
  _$CalibrationStateImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$CalibrationStateImpl(
      activeType: fields[0] as CalibrationType,
      hasUnsavedChanges: fields[1] as bool,
      isCalibrated: fields[2] as bool,
      calibrationDate: fields[3] as DateTime?,
      calibrationLevel: fields[4] as double,
      sensorOffsets: (fields[5] as Map).cast<String, double>(),
      temperatureOffsets: (fields[6] as Map).cast<String, double>(),
      zoneId: fields[7] as String?,
      profileId: fields[8] as String?,
      deviceId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, _$CalibrationStateImpl obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.activeType)
      ..writeByte(1)
      ..write(obj.hasUnsavedChanges)
      ..writeByte(2)
      ..write(obj.isCalibrated)
      ..writeByte(3)
      ..write(obj.calibrationDate)
      ..writeByte(4)
      ..write(obj.calibrationLevel)
      ..writeByte(7)
      ..write(obj.zoneId)
      ..writeByte(8)
      ..write(obj.profileId)
      ..writeByte(9)
      ..write(obj.deviceId)
      ..writeByte(5)
      ..write(obj.sensorOffsets)
      ..writeByte(6)
      ..write(obj.temperatureOffsets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalibrationStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalibrationStateImpl _$$CalibrationStateImplFromJson(
        Map<String, dynamic> json) =>
    _$CalibrationStateImpl(
      activeType: $enumDecodeNullable(
              _$CalibrationTypeEnumMap, json['activeType'],
              unknownValue: CalibrationType.none) ??
          CalibrationType.none,
      hasUnsavedChanges: json['hasUnsavedChanges'] as bool? ?? false,
      isCalibrated: json['isCalibrated'] as bool? ?? false,
      calibrationDate:
          const TimestampJsonConverter().fromJson(json['calibrationDate']),
      calibrationLevel: (json['calibrationLevel'] as num?)?.toDouble() ??
          _defaultCalibrationLevel,
      sensorOffsets: json['sensorOffsets'] == null
          ? const <String, double>{}
          : const DoubleMapJsonConverter()
              .fromJson(json['sensorOffsets'] as Map<String, dynamic>?),
      temperatureOffsets: json['temperatureOffsets'] == null
          ? const <String, double>{}
          : const DoubleMapJsonConverter()
              .fromJson(json['temperatureOffsets'] as Map<String, dynamic>?),
      zoneId: json['zoneId'] as String?,
      profileId: json['profileId'] as String?,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$$CalibrationStateImplToJson(
        _$CalibrationStateImpl instance) =>
    <String, dynamic>{
      'activeType': instance.activeType.toJson(),
      'hasUnsavedChanges': instance.hasUnsavedChanges,
      'isCalibrated': instance.isCalibrated,
      'calibrationDate':
          const TimestampJsonConverter().toJson(instance.calibrationDate),
      'calibrationLevel': instance.calibrationLevel,
      'sensorOffsets':
          const DoubleMapJsonConverter().toJson(instance.sensorOffsets),
      'temperatureOffsets':
          const DoubleMapJsonConverter().toJson(instance.temperatureOffsets),
      'zoneId': instance.zoneId,
      'profileId': instance.profileId,
      'deviceId': instance.deviceId,
    };

const _$CalibrationTypeEnumMap = {
  CalibrationType.none: 'none',
  CalibrationType.organic: 'organic',
};
