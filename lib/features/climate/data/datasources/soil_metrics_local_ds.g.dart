// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soil_metrics_local_ds.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoilMetricsDtoAdapter extends TypeAdapter<SoilMetricsDto> {
  @override
  final int typeId = 28;

  @override
  SoilMetricsDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoilMetricsDto(
      soilTempEstimatedC: fields[0] as double?,
      soilPH: fields[1] as double?,
      lastComputed: fields[2] as DateTime?,
      anchorTempC: fields[3] as double?,
      anchorTimestamp: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SoilMetricsDto obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.soilTempEstimatedC)
      ..writeByte(1)
      ..write(obj.soilPH)
      ..writeByte(2)
      ..write(obj.lastComputed)
      ..writeByte(3)
      ..write(obj.anchorTempC)
      ..writeByte(4)
      ..write(obj.anchorTimestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoilMetricsDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
