import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'garden_v2.g.dart';

/// âš ï¸ DÉPRÉCIÉ : Utilisez GardenFreezed à la place
///
/// Ce modèle Garden (v2, HiveType 10) est déprécié et sera supprimé dans la v3.0.
///
/// **Migration :**
/// ```dart
/// // Ancien code
/// final garden = Garden.create(name: 'Mon Jardin', ...);
///
/// // Nouveau code
/// final garden = GardenFreezed.create(name: 'Mon Jardin', ...);
///
/// // Ou pour migrer un jardin existant
/// final modernGarden = GardenMigrationAdapters.fromV2(v2Garden);
/// ```
///
/// **Raisons de la dépréciation :**
/// - Modèle incomplet (manque totalAreaInSquareMeters, updatedAt, etc.)
/// - Pas de support Freezed
/// - Duplication avec les autres modèles Garden
/// - Nom de classe ambigu (Garden existe aussi dans garden.dart)
///
/// **Perte de données lors de la migration :**
/// - `totalAreaInSquareMeters` : sera recalculé après migration des beds
/// - `updatedAt` : initialisé à createdDate
/// - `imageUrl` : sera null (pas disponible dans v2)
///
/// **Références :**
/// - Guide de migration : `lib/core/adapters/garden_migration_adapters.dart`
/// - Nouveau modèle : `lib/core/models/garden_freezed.dart`
/// - Prompt 7 : RETABLISSEMENT_PERMACALENDAR.md
@Deprecated('Utilisez GardenFreezed à la place. '
    'Utilisez GardenMigrationAdapters.fromV2() pour migrer. '
    'Sera supprimé dans la v3.0')
@HiveType(typeId: 10)
class Garden extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String location;

  @HiveField(4)
  final DateTime createdDate;

  @HiveField(5)
  final List<String> gardenBeds;

  Garden({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.createdDate,
    required this.gardenBeds,
  });

  // Factory constructor pour Créer un nouveau jardin avec ID généré
  factory Garden.create({
    required String name,
    required String description,
    required String location,
    List<String>? gardenBeds,
  }) {
    return Garden(
      id: const Uuid().v4(),
      name: name,
      description: description,
      location: location,
      createdDate: DateTime.now(),
      gardenBeds: gardenBeds ?? [],
    );
  }

  // Méthodes fromJson/toJson pour la sérialisation
  factory Garden.fromJson(Map<String, dynamic> json) {
    return Garden(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      gardenBeds: List<String>.from(json['gardenBeds'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'createdDate': createdDate.toIso8601String(),
      'gardenBeds': gardenBeds,
    };
  }

  // Méthode copyWith pour les modifications
  Garden copyWith({
    String? name,
    String? description,
    String? location,
    List<String>? gardenBeds,
  }) {
    return Garden(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      createdDate: createdDate,
      gardenBeds: gardenBeds ?? this.gardenBeds,
    );
  }

  @override
  String toString() {
    return 'Garden(id: $id, name: $name, location: $location, gardenBeds: ${gardenBeds.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Garden && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


