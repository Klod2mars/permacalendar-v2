ï»¿import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'garden_bed_hive.g.dart';

@HiveType(typeId: 26)
class GardenBedHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double sizeInSquareMeters;

  @HiveField(3)
  final String gardenId;

  @HiveField(4)
  final List<String> plantingIds;

  GardenBedHive({
    required this.id,
    required this.name,
    required this.sizeInSquareMeters,
    required this.gardenId,
    required this.plantingIds,
  });

  // Factory constructor pour Créer une nouvelle parcelle avec ID généré
  factory GardenBedHive.create({
    required String name,
    required double sizeInSquareMeters,
    required String gardenId,
    List<String>? plantingIds,
  }) {
    return GardenBedHive(
      id: const Uuid().v4(),
      name: name,
      sizeInSquareMeters: sizeInSquareMeters,
      gardenId: gardenId,
      plantingIds: plantingIds ?? [],
    );
  }

  // Méthodes fromJson/toJson pour la sérialisation
  factory GardenBedHive.fromJson(Map<String, dynamic> json) {
    return GardenBedHive(
      id: json['id'] as String,
      name: json['name'] as String,
      sizeInSquareMeters: (json['sizeInSquareMeters'] as num).toDouble(),
      gardenId: json['gardenId'] as String,
      plantingIds: List<String>.from(json['plantingIds'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sizeInSquareMeters': sizeInSquareMeters,
      'gardenId': gardenId,
      'plantingIds': plantingIds,
    };
  }

  // Méthode copyWith pour les modifications
  GardenBedHive copyWith({
    String? name,
    double? sizeInSquareMeters,
    String? gardenId,
    List<String>? plantingIds,
  }) {
    return GardenBedHive(
      id: id,
      name: name ?? this.name,
      sizeInSquareMeters: sizeInSquareMeters ?? this.sizeInSquareMeters,
      gardenId: gardenId ?? this.gardenId,
      plantingIds: plantingIds ?? this.plantingIds,
    );
  }

  // Méthodes utilitaires pour gérer les plantations
  GardenBedHive addPlanting(String plantingId) {
    if (plantingIds.contains(plantingId)) return this;
    final updatedIds = List<String>.from(plantingIds)..add(plantingId);
    return copyWith(plantingIds: updatedIds);
  }

  GardenBedHive removePlanting(String plantingId) {
    final updatedIds = plantingIds.where((id) => id != plantingId).toList();
    return copyWith(plantingIds: updatedIds);
  }

  // Propriétés calculées
  int get plantingCount => plantingIds.length;

  bool get hasPlantings => plantingIds.isNotEmpty;

  String get formattedSize => '${sizeInSquareMeters.toStringAsFixed(1)} mÂ²';

  // Validation
  bool get isValid {
    return name.isNotEmpty && sizeInSquareMeters > 0 && gardenId.isNotEmpty;
  }

  @override
  String toString() {
    return 'GardenBedHive(id: $id, name: $name, size: ${sizeInSquareMeters}mÂ², plantings: ${plantingIds.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GardenBedHive && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


