// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_alert.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationAlertAdapter extends TypeAdapter<NotificationAlert> {
  @override
  final int typeId = 43;

  @override
  NotificationAlert read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationAlert(
      id: fields[0] as String,
      title: fields[1] as String,
      message: fields[2] as String,
      type: fields[3] as NotificationType,
      priority: fields[4] as NotificationPriority,
      severity: fields[14] as AlertSeverity,
      createdAt: fields[5] as DateTime,
      readAt: fields[6] as DateTime?,
      plantId: fields[7] as String?,
      gardenId: fields[8] as String?,
      actionId: fields[9] as String?,
      status: fields[10] as NotificationStatus,
      metadata: (fields[11] as Map).cast<String, dynamic>(),
      archivedAt: fields[12] as DateTime?,
      dismissedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationAlert obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(14)
      ..write(obj.severity)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.readAt)
      ..writeByte(7)
      ..write(obj.plantId)
      ..writeByte(8)
      ..write(obj.gardenId)
      ..writeByte(9)
      ..write(obj.actionId)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.metadata)
      ..writeByte(12)
      ..write(obj.archivedAt)
      ..writeByte(13)
      ..write(obj.dismissedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationAlertAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 40;

  @override
  NotificationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationType.weatherAlert;
      case 1:
        return NotificationType.plantCondition;
      case 2:
        return NotificationType.recommendation;
      case 3:
        return NotificationType.reminder;
      case 4:
        return NotificationType.criticalCondition;
      case 5:
        return NotificationType.optimalCondition;
      default:
        return NotificationType.weatherAlert;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    switch (obj) {
      case NotificationType.weatherAlert:
        writer.writeByte(0);
        break;
      case NotificationType.plantCondition:
        writer.writeByte(1);
        break;
      case NotificationType.recommendation:
        writer.writeByte(2);
        break;
      case NotificationType.reminder:
        writer.writeByte(3);
        break;
      case NotificationType.criticalCondition:
        writer.writeByte(4);
        break;
      case NotificationType.optimalCondition:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationPriorityAdapter extends TypeAdapter<NotificationPriority> {
  @override
  final int typeId = 41;

  @override
  NotificationPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationPriority.low;
      case 1:
        return NotificationPriority.medium;
      case 2:
        return NotificationPriority.high;
      case 3:
        return NotificationPriority.critical;
      default:
        return NotificationPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationPriority obj) {
    switch (obj) {
      case NotificationPriority.low:
        writer.writeByte(0);
        break;
      case NotificationPriority.medium:
        writer.writeByte(1);
        break;
      case NotificationPriority.high:
        writer.writeByte(2);
        break;
      case NotificationPriority.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationStatusAdapter extends TypeAdapter<NotificationStatus> {
  @override
  final int typeId = 42;

  @override
  NotificationStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationStatus.unread;
      case 1:
        return NotificationStatus.read;
      case 2:
        return NotificationStatus.archived;
      case 3:
        return NotificationStatus.dismissed;
      default:
        return NotificationStatus.unread;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationStatus obj) {
    switch (obj) {
      case NotificationStatus.unread:
        writer.writeByte(0);
        break;
      case NotificationStatus.read:
        writer.writeByte(1);
        break;
      case NotificationStatus.archived:
        writer.writeByte(2);
        break;
      case NotificationStatus.dismissed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlertSeverityAdapter extends TypeAdapter<AlertSeverity> {
  @override
  final int typeId = 44;

  @override
  AlertSeverity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AlertSeverity.info;
      case 1:
        return AlertSeverity.warning;
      case 2:
        return AlertSeverity.error;
      default:
        return AlertSeverity.info;
    }
  }

  @override
  void write(BinaryWriter writer, AlertSeverity obj) {
    switch (obj) {
      case AlertSeverity.info:
        writer.writeByte(0);
        break;
      case AlertSeverity.warning:
        writer.writeByte(1);
        break;
      case AlertSeverity.error:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertSeverityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationAlertImpl _$$NotificationAlertImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationAlertImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      priority: $enumDecode(_$NotificationPriorityEnumMap, json['priority']),
      severity: $enumDecodeNullable(_$AlertSeverityEnumMap, json['severity']) ??
          AlertSeverity.info,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      plantId: json['plantId'] as String?,
      gardenId: json['gardenId'] as String?,
      actionId: json['actionId'] as String?,
      status:
          $enumDecodeNullable(_$NotificationStatusEnumMap, json['status']) ??
              NotificationStatus.unread,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
      dismissedAt: json['dismissedAt'] == null
          ? null
          : DateTime.parse(json['dismissedAt'] as String),
    );

Map<String, dynamic> _$$NotificationAlertImplToJson(
        _$NotificationAlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
      'severity': _$AlertSeverityEnumMap[instance.severity]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'plantId': instance.plantId,
      'gardenId': instance.gardenId,
      'actionId': instance.actionId,
      'status': _$NotificationStatusEnumMap[instance.status]!,
      'metadata': instance.metadata,
      'archivedAt': instance.archivedAt?.toIso8601String(),
      'dismissedAt': instance.dismissedAt?.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.weatherAlert: 'weatherAlert',
  NotificationType.plantCondition: 'plantCondition',
  NotificationType.recommendation: 'recommendation',
  NotificationType.reminder: 'reminder',
  NotificationType.criticalCondition: 'criticalCondition',
  NotificationType.optimalCondition: 'optimalCondition',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'low',
  NotificationPriority.medium: 'medium',
  NotificationPriority.high: 'high',
  NotificationPriority.critical: 'critical',
};

const _$AlertSeverityEnumMap = {
  AlertSeverity.info: 'info',
  AlertSeverity.warning: 'warning',
  AlertSeverity.error: 'error',
};

const _$NotificationStatusEnumMap = {
  NotificationStatus.unread: 'unread',
  NotificationStatus.read: 'read',
  NotificationStatus.archived: 'archived',
  NotificationStatus.dismissed: 'dismissed',
};
