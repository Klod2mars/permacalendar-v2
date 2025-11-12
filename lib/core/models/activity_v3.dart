import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'activity_v3.freezed.dart';
part 'activity_v3.g.dart';

@freezed
@HiveType(typeId: 30) // TypeId unique pour éviter les conflits
class ActivityV3 with _$ActivityV3 {
  const factory ActivityV3({
    @HiveField(0) required String id,
    @HiveField(1) required String type,
    @HiveField(2) required String description,
    @HiveField(3) required DateTime timestamp,
    @HiveField(4) Map<String, dynamic>? metadata,
    @HiveField(5) @Default(true) bool isActive,
    @HiveField(6) @Default(0) int priority, // 0=normal, 1=important, 2=critical
  }) = _ActivityV3;

  factory ActivityV3.fromJson(Map<String, dynamic> json) =>
      _$ActivityV3FromJson(json);
}

// Types d'activités prédéfinis pour éviter les erreurs de typage
enum ActivityType {
  gardenCreated,
  gardenUpdated,
  gardenDeleted,
  gardenBedCreated,
  gardenBedUpdated,
  gardenBedDeleted,
  plantingCreated,
  plantingUpdated,
  plantingDeleted,
  plantAdded,
  plantRemoved,
  harvestCompleted,
  maintenanceCompleted,
  weatherUpdate,
  systemEvent,
}

// Priorités des activités
enum ActivityPriority {
  normal(0),
  important(1),
  critical(2);

  const ActivityPriority(this.value);
  final int value;
}

