import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'plant_variety.g.dart';

@HiveType(typeId: 4)
class PlantVariety extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String plantId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String description;

  @HiveField(4)
  int daysToMaturity;

  @HiveField(5)
  String? imageUrl;

  @HiveField(6)
  Map<String, dynamic> characteristics;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  @HiveField(9)
  bool isActive;

  @HiveField(10)
  String? notes;

  PlantVariety({
    String? id,
    required this.plantId,
    required this.name,
    required this.description,
    required this.daysToMaturity,
    this.imageUrl,
    Map<String, dynamic>? characteristics,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        characteristics = characteristics ?? {},
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Méthodes utilitaires
  void markAsUpdated() {
    updatedAt = DateTime.now();
  }

  // Validation
  bool get isValid {
    return name.isNotEmpty && plantId.isNotEmpty && daysToMaturity > 0;
  }

  // Conversion JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'name': name,
      'description': description,
      'daysToMaturity': daysToMaturity,
      'imageUrl': imageUrl,
      'characteristics': characteristics,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'notes': notes,
    };
  }

  factory PlantVariety.fromJson(Map<String, dynamic> json) {
    return PlantVariety(
      id: json['id'],
      plantId: json['plantId'],
      name: json['name'],
      description: json['description'],
      daysToMaturity: json['daysToMaturity'],
      imageUrl: json['imageUrl'],
      characteristics: Map<String, dynamic>.from(json['characteristics'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'] ?? true,
      notes: json['notes'],
    );
  }

  @override
  String toString() {
    return 'PlantVariety(id: $id, name: $name, daysToMaturity: $daysToMaturity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlantVariety && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

