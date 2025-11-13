import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'planting_hive.g.dart';

@HiveType(typeId: 27)
class PlantingHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String plantId;

  @HiveField(2)
  final String gardenBedId;

  @HiveField(3)
  final DateTime plantingDate;

  @HiveField(4)
  final String status;

  PlantingHive({
    required this.id,
    required this.plantId,
    required this.gardenBedId,
    required this.plantingDate,
    required this.status,
  });

  // Factory constructor pour créer une nouvelle plantation avec ID généré
  factory PlantingHive.create({
    required String plantId,
    required String gardenBedId,
    DateTime? plantingDate,
    String? status,
  }) {
    return PlantingHive(
      id: const Uuid().v4(),
      plantId: plantId,
      gardenBedId: gardenBedId,
      plantingDate: plantingDate ?? DateTime.now(),
      status: status ?? 'Planté',
    );
  }

  // Méthodes fromJson/toJson pour la sérialisation
  factory PlantingHive.fromJson(Map<String, dynamic> json) {
    return PlantingHive(
      id: json['id'] as String,
      plantId: json['plantId'] as String,
      gardenBedId: json['gardenBedId'] as String,
      plantingDate: DateTime.parse(json['plantingDate'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'gardenBedId': gardenBedId,
      'plantingDate': plantingDate.toIso8601String(),
      'status': status,
    };
  }

  // Méthode copyWith pour les modifications
  PlantingHive copyWith({
    String? plantId,
    String? gardenBedId,
    DateTime? plantingDate,
    String? status,
  }) {
    return PlantingHive(
      id: id,
      plantId: plantId ?? this.plantId,
      gardenBedId: gardenBedId ?? this.gardenBedId,
      plantingDate: plantingDate ?? this.plantingDate,
      status: status ?? this.status,
    );
  }

  // Statuts disponibles
  static const List<String> availableStatuses = [
    'Planté',
    'En croissance',
    'Prêt à récolter',
    'Récolté',
    'Échoué',
  ];

  // Propriétés calculées
  bool get isActive => status != 'Récolté' && status != 'Échoué';

  bool get isHarvestable => status == 'Prêt à récolter';

  bool get isCompleted => status == 'Récolté' || status == 'Échoué';

  int get daysFromPlanting => DateTime.now().difference(plantingDate).inDays;

  String get formattedPlantingDate =>
      '${plantingDate.day.toString().padLeft(2, '0')}/'
      '${plantingDate.month.toString().padLeft(2, '0')}/'
      '${plantingDate.year}';

  // Validation
  bool get isValid {
    return plantId.isNotEmpty &&
        gardenBedId.isNotEmpty &&
        availableStatuses.contains(status);
  }

  // Méthodes utilitaires pour changer le statut
  PlantingHive markAsGrowing() => copyWith(status: 'En croissance');

  PlantingHive markAsReadyToHarvest() => copyWith(status: 'Prêt à récolter');

  PlantingHive markAsHarvested() => copyWith(status: 'Récolté');

  PlantingHive markAsFailed() => copyWith(status: 'Échoué');

  @override
  String toString() {
    return 'PlantingHive(id: $id, plantId: $plantId, status: $status, days: $daysFromPlanting)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlantingHive && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


