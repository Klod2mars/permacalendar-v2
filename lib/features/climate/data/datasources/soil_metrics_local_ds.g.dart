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
      soilTempC: fields[0] as double?,
      soilPH: fields[1] as double?,
      lastUpdated: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SoilMetricsDto obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.soilTempC)
      ..writeByte(1)
      ..write(obj.soilPH)
      ..writeByte(2)
      ..write(obj.lastUpdated);
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
