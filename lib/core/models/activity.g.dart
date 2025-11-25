// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 16;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      id: fields[0] as String?,
      type: fields[1] as ActivityType,
      title: fields[2] as String,
      description: fields[3] as String,
      entityId: fields[4] as String?,
      entityType: fields[5] as EntityType?,
      timestamp: fields[6] as DateTime?,
      metadata: (fields[7] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
      isActive: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.entityId)
      ..writeByte(5)
      ..write(obj.entityType)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.metadata)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityTypeAdapter extends TypeAdapter<ActivityType> {
  @override
  final int typeId = 17;

  @override
  ActivityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityType.gardenCreated;
      case 1:
        return ActivityType.gardenUpdated;
      case 2:
        return ActivityType.gardenDeleted;
      case 3:
        return ActivityType.bedCreated;
      case 4:
        return ActivityType.bedUpdated;
      case 5:
        return ActivityType.bedDeleted;
      case 6:
        return ActivityType.plantingCreated;
      case 7:
        return ActivityType.plantingUpdated;
      case 8:
        return ActivityType.plantingHarvested;
      case 9:
        return ActivityType.careActionAdded;
      case 10:
        return ActivityType.germinationConfirmed;
      case 11:
        return ActivityType.plantCreated;
      case 12:
        return ActivityType.plantUpdated;
      case 13:
        return ActivityType.plantDeleted;
      case 14:
        return ActivityType.plantingDeleted;
      case 15:
        return ActivityType.weatherDataFetched;
      case 16:
        return ActivityType.weatherAlertTriggered;
      default:
        return ActivityType.gardenCreated;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityType obj) {
    switch (obj) {
      case ActivityType.gardenCreated:
        writer.writeByte(0);
        break;
      case ActivityType.gardenUpdated:
        writer.writeByte(1);
        break;
      case ActivityType.gardenDeleted:
        writer.writeByte(2);
        break;
      case ActivityType.bedCreated:
        writer.writeByte(3);
        break;
      case ActivityType.bedUpdated:
        writer.writeByte(4);
        break;
      case ActivityType.bedDeleted:
        writer.writeByte(5);
        break;
      case ActivityType.plantingCreated:
        writer.writeByte(6);
        break;
      case ActivityType.plantingUpdated:
        writer.writeByte(7);
        break;
      case ActivityType.plantingHarvested:
        writer.writeByte(8);
        break;
      case ActivityType.careActionAdded:
        writer.writeByte(9);
        break;
      case ActivityType.germinationConfirmed:
        writer.writeByte(10);
        break;
      case ActivityType.plantCreated:
        writer.writeByte(11);
        break;
      case ActivityType.plantUpdated:
        writer.writeByte(12);
        break;
      case ActivityType.plantDeleted:
        writer.writeByte(13);
        break;
      case ActivityType.plantingDeleted:
        writer.writeByte(14);
        break;
      case ActivityType.weatherDataFetched:
        writer.writeByte(15);
        break;
      case ActivityType.weatherAlertTriggered:
        writer.writeByte(16);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EntityTypeAdapter extends TypeAdapter<EntityType> {
  @override
  final int typeId = 18;

  @override
  EntityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EntityType.garden;
      case 1:
        return EntityType.gardenBed;
      case 2:
        return EntityType.planting;
      case 3:
        return EntityType.plant;
      case 4:
        return EntityType.germinationEvent;
      default:
        return EntityType.garden;
    }
  }

  @override
  void write(BinaryWriter writer, EntityType obj) {
    switch (obj) {
      case EntityType.garden:
        writer.writeByte(0);
        break;
      case EntityType.gardenBed:
        writer.writeByte(1);
        break;
      case EntityType.planting:
        writer.writeByte(2);
        break;
      case EntityType.plant:
        writer.writeByte(3);
        break;
      case EntityType.germinationEvent:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
