import 'package:hive/hive.dart';
import 'plant_condition.dart';

part 'plant_condition_hive.g.dart';

/// Adaptateur Hive pour la persistance de PlantCondition
/// TypeId: 43 - Moved from 30 to 43 to avoid conflict with ActivityV3 (TypeId 30)
/// Range: Intelligence Végétale (37-50)
@HiveType(typeId: 43)
class PlantConditionHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String plantId;

  @HiveField(2)
  String gardenId;

  @HiveField(3)
  int typeIndex; // Index de ConditionType

  @HiveField(4)
  int statusIndex; // Index de ConditionStatus

  @HiveField(5)
  double value;

  @HiveField(6)
  double optimalValue;

  @HiveField(7)
  double minValue;

  @HiveField(8)
  double maxValue;

  @HiveField(9)
  String unit;

  @HiveField(10)
  String? description;

  @HiveField(11)
  List<String>? recommendations;

  @HiveField(12)
  DateTime measuredAt;

  @HiveField(13)
  DateTime? createdAt;

  @HiveField(14)
  DateTime? updatedAt;

  PlantConditionHive({
    required this.id,
    required this.plantId,
    required this.gardenId,
    required this.typeIndex,
    required this.statusIndex,
    required this.value,
    required this.optimalValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    this.description,
    this.recommendations,
    required this.measuredAt,
    this.createdAt,
    this.updatedAt,
  });

  /// Convertir depuis PlantCondition vers PlantConditionHive
  factory PlantConditionHive.fromDomain(PlantCondition condition) {
    return PlantConditionHive(
      id: condition.id,
      plantId: condition.plantId,
      gardenId: condition.gardenId,
      typeIndex: condition.type.index,
      statusIndex: condition.status.index,
      value: condition.value,
      optimalValue: condition.optimalValue,
      minValue: condition.minValue,
      maxValue: condition.maxValue,
      unit: condition.unit,
      description: condition.description,
      recommendations: condition.recommendations,
      measuredAt: condition.measuredAt,
      createdAt: condition.createdAt,
      updatedAt: condition.updatedAt,
    );
  }

  /// Convertir vers PlantCondition depuis PlantConditionHive
  PlantCondition toDomain() {
    return PlantCondition(
      id: id,
      plantId: plantId,
      gardenId: gardenId,
      type: ConditionType.values[typeIndex],
      status: ConditionStatus.values[statusIndex],
      value: value,
      optimalValue: optimalValue,
      minValue: minValue,
      maxValue: maxValue,
      unit: unit,
      description: description,
      recommendations: recommendations,
      measuredAt: measuredAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}


