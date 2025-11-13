// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_condition_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherConditionHiveAdapter extends TypeAdapter<WeatherConditionHive> {
  @override
  final int typeId = 37;

  @override
  WeatherConditionHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherConditionHive(
      timestamp: fields[0] as DateTime,
      currentTemperature: fields[1] as double,
      minTemperature: fields[2] as double,
      maxTemperature: fields[3] as double,
      humidity: fields[4] as double,
      precipitation: fields[5] as double,
      windSpeed: fields[6] as double,
      cloudCover: fields[7] as int,
      forecast: (fields[8] as List).cast<WeatherForecastHive>(),
      trendIndex: fields[9] as int,
      metadata: (fields[10] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, WeatherConditionHive obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.currentTemperature)
      ..writeByte(2)
      ..write(obj.minTemperature)
      ..writeByte(3)
      ..write(obj.maxTemperature)
      ..writeByte(4)
      ..write(obj.humidity)
      ..writeByte(5)
      ..write(obj.precipitation)
      ..writeByte(6)
      ..write(obj.windSpeed)
      ..writeByte(7)
      ..write(obj.cloudCover)
      ..writeByte(8)
      ..write(obj.forecast)
      ..writeByte(9)
      ..write(obj.trendIndex)
      ..writeByte(10)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherConditionHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeatherForecastHiveAdapter extends TypeAdapter<WeatherForecastHive> {
  @override
  final int typeId = 38;

  @override
  WeatherForecastHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherForecastHive(
      date: fields[0] as DateTime,
      minTemperature: fields[1] as double,
      maxTemperature: fields[2] as double,
      humidity: fields[3] as double,
      precipitation: fields[4] as double,
      precipitationProbability: fields[5] as double,
      windSpeed: fields[6] as double,
      cloudCover: fields[7] as int,
      condition: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherForecastHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.minTemperature)
      ..writeByte(2)
      ..write(obj.maxTemperature)
      ..writeByte(3)
      ..write(obj.humidity)
      ..writeByte(4)
      ..write(obj.precipitation)
      ..writeByte(5)
      ..write(obj.precipitationProbability)
      ..writeByte(6)
      ..write(obj.windSpeed)
      ..writeByte(7)
      ..write(obj.cloudCover)
      ..writeByte(8)
      ..write(obj.condition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherForecastHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
