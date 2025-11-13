import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'garden_bed_hive.dart';
import 'garden_freezed.dart';

part 'garden_hive.g.dart';

@HiveType(typeId: 25)
class GardenHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime createdDate;

  @HiveField(4)
  final List<GardenBedHive> gardenBeds;

  GardenHive({
    required this.id,
    required this.name,
    required this.description,
    required this.createdDate,
    this.gardenBeds = const <GardenBedHive>[],
  });

  // Factory constructor pour créer un nouveau jardin avec ID généré
  factory GardenHive.create({
    required String name,
    required String description,
    List<GardenBedHive>? gardenBeds,
  }) {
    return GardenHive(
      id: const Uuid().v4(),
      name: name,
      description: description,
      createdDate: DateTime.now(),
      gardenBeds: gardenBeds ?? [],
    );
  }

  // Conversion depuis GardenFreezed
  factory GardenHive.fromGardenFreezed(GardenFreezed garden,
      {List<GardenBedHive>? gardenBeds}) {
    return GardenHive(
      id: garden.id,
      name: garden.name,
      description: garden.description ?? '',
      createdDate: garden.createdAt,
      gardenBeds: gardenBeds ?? [],
    );
  }

  // Conversion vers GardenFreezed
  GardenFreezed toGardenFreezed({
    double? totalAreaInSquareMeters,
    String? location,
    DateTime? updatedAt,
    String? imageUrl,
    Map<String, dynamic>? metadata,
    bool? isActive,
  }) {
    return GardenFreezed(
      id: id,
      name: name,
      description: description,
      totalAreaInSquareMeters: totalAreaInSquareMeters ?? _calculateTotalArea(),
      location: location ?? '',
      createdAt: createdDate,
      updatedAt: updatedAt ?? DateTime.now(),
      imageUrl: imageUrl,
      metadata: metadata ?? {},
      isActive: isActive ?? true,
    );
  }

  // Méthodes fromJson/toJson pour la sérialisation
  factory GardenHive.fromJson(Map<String, dynamic> json) {
    return GardenHive(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      gardenBeds: (json['gardenBeds'] as List<dynamic>?)
              ?.map((e) => GardenBedHive.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
      'gardenBeds': gardenBeds.map((e) => e.toJson()).toList(),
    };
  }

  // Méthode copyWith pour les modifications
  GardenHive copyWith({
    String? name,
    String? description,
    DateTime? createdDate,
    List<GardenBedHive>? gardenBeds,
  }) {
    return GardenHive(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      gardenBeds: gardenBeds ?? this.gardenBeds,
    );
  }

  // Méthodes utilitaires
  double _calculateTotalArea() {
    return gardenBeds.fold(0.0, (sum, bed) => sum + bed.sizeInSquareMeters);
  }

  int get totalPlantings {
    return gardenBeds.fold(0, (sum, bed) => sum + bed.plantingIds.length);
  }

  List<String> get allPlantingIds {
    return gardenBeds.expand((bed) => bed.plantingIds).toList();
  }

  // Ajouter une parcelle avec validation de l'isolation
  /// 🔧 CORRECTION: S'assurer que la parcelle appartient bien à ce jardin
  GardenHive addGardenBed(GardenBedHive gardenBed) {
    // Validation: la parcelle doit appartenir à ce jardin
    if (gardenBed.gardenId != id) {
      throw ArgumentError(
          'La parcelle (gardenId: ${gardenBed.gardenId}) ne peut pas être ajoutée au jardin (id: $id)');
    }

    final updatedBeds = List<GardenBedHive>.from(gardenBeds)..add(gardenBed);
    return copyWith(gardenBeds: updatedBeds);
  }

  // Supprimer une parcelle
  GardenHive removeGardenBed(String gardenBedId) {
    final updatedBeds =
        gardenBeds.where((bed) => bed.id != gardenBedId).toList();
    return copyWith(gardenBeds: updatedBeds);
  }

  // Mettre à jour une parcelle avec validation de l'isolation
  /// 🔧 CORRECTION: S'assurer que la parcelle mise à jour appartient bien à ce jardin
  GardenHive updateGardenBed(GardenBedHive updatedBed) {
    // Validation: la parcelle doit appartenir à ce jardin
    if (updatedBed.gardenId != id) {
      throw ArgumentError(
          'La parcelle mise à jour (gardenId: ${updatedBed.gardenId}) ne peut pas être mise à jour dans le jardin (id: $id)');
    }

    final updatedBeds = gardenBeds.map((bed) {
      return bed.id == updatedBed.id ? updatedBed : bed;
    }).toList();
    return copyWith(gardenBeds: updatedBeds);
  }

  @override
  String toString() {
    return 'GardenHive(id: $id, name: $name, beds: ${gardenBeds.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GardenHive && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


