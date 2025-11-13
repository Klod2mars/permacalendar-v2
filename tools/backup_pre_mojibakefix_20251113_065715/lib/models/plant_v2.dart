ï»¿import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'plant_v2.g.dart';

@HiveType(typeId: 12)
class Plant extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String species;

  @HiveField(3)
  final String family;

  @HiveField(4)
  final List<String> growthCycles;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.family,
    required this.growthCycles,
  });

  // Factory constructor pour Créer une nouvelle plante avec ID généré
  factory Plant.create({
    required String name,
    required String species,
    required String family,
    List<String>? growthCycles,
  }) {
    return Plant(
      id: const Uuid().v4(),
      name: name,
      species: species,
      family: family,
      growthCycles: growthCycles ?? [],
    );
  }

  // Méthodes fromJson/toJson pour la sérialisation
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      family: json['family'] as String,
      growthCycles: List<String>.from(json['growthCycles'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'family': family,
      'growthCycles': growthCycles,
    };
  }

  // Méthode copyWith pour les modifications
  Plant copyWith({
    String? name,
    String? species,
    String? family,
    List<String>? growthCycles,
  }) {
    return Plant(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      family: family ?? this.family,
      growthCycles: growthCycles ?? this.growthCycles,
    );
  }

  @override
  String toString() {
    return 'Plant(id: $id, name: $name, species: $species, family: $family, growthCycles: ${growthCycles.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Plant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


