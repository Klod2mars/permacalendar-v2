import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'garden_bed_v2.g.dart';

@HiveType(typeId: 11)
class GardenBed extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double sizeInSquareMeters;

  @HiveField(3)
  final String gardenId;

  @HiveField(4)
  final List<String> plantings;

  GardenBed({
    required this.id,
    required this.name,
    required this.sizeInSquareMeters,
    required this.gardenId,
    required this.plantings,
  });

  // Factory constructor pour Créer une nouvelle planche avec ID généré
  factory GardenBed.create({
    required String name,
    required double sizeInSquareMeters,
    required String gardenId,
    List<String>? plantings,
  }) {
    return GardenBed(
      id: const Uuid().v4(),
      name: name,
      sizeInSquareMeters: sizeInSquareMeters,
      gardenId: gardenId,
      plantings: plantings ?? [],
    );
  }

  // Méthodes fromJson/toJson pour la sérialisation
  factory GardenBed.fromJson(Map<String, dynamic> json) {
    return GardenBed(
      id: json['id'] as String,
      name: json['name'] as String,
      sizeInSquareMeters: (json['sizeInSquareMeters'] as num).toDouble(),
      gardenId: json['gardenId'] as String,
      plantings: List<String>.from(json['plantings'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sizeInSquareMeters': sizeInSquareMeters,
      'gardenId': gardenId,
      'plantings': plantings,
    };
  }

  // Méthode copyWith pour les modifications
  GardenBed copyWith({
    String? name,
    double? sizeInSquareMeters,
    String? gardenId,
    List<String>? plantings,
  }) {
    return GardenBed(
      id: id,
      name: name ?? this.name,
      sizeInSquareMeters: sizeInSquareMeters ?? this.sizeInSquareMeters,
      gardenId: gardenId ?? this.gardenId,
      plantings: plantings ?? this.plantings,
    );
  }

  @override
  String toString() {
    return 'GardenBed(id: $id, name: $name, size: ${sizeInSquareMeters}mÂ², plantings: ${plantings.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GardenBed && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


