import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'garden.g.dart';

/// ⚠️ DÉPRÉCIÉ : Utilisez GardenFreezed à la place
///
/// Ce modèle Garden (legacy, HiveType 0) est déprécié et sera supprimé dans la v3.0.
///
/// **Migration :**
/// ```dart
/// // Ancien code
/// final garden = Garden(name: 'Mon Jardin', ...);
///
/// // Nouveau code
/// final garden = GardenFreezed.create(name: 'Mon Jardin', ...);
///
/// // Ou pour migrer un jardin existant
/// final modernGarden = GardenMigrationAdapters.fromLegacy(legacyGarden);
/// ```
///
/// **Raisons de la dépréciation :**
/// - Modèle mutable (contraire aux bonnes pratiques Flutter)
/// - Pas de support Freezed (pas de copyWith immutable, pas de génération de code)
/// - Duplication avec les autres modèles Garden
///
/// **Références :**
/// - Guide de migration : `lib/core/adapters/garden_migration_adapters.dart`
/// - Nouveau modèle : `lib/core/models/garden_freezed.dart`
/// - Prompt 7 : RETABLISSEMENT_PERMACALENDAR.md
@Deprecated('Utilisez GardenFreezed à la place. '
    'Utilisez GardenMigrationAdapters.fromLegacy() pour migrer. '
    'Sera supprimé dans la v3.0')
@HiveType(typeId: 0)
class Garden extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  double totalAreaInSquareMeters;

  @HiveField(4)
  String location;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  @HiveField(7)
  String? imageUrl;

  @HiveField(8)
  Map<String, dynamic> metadata;

  @HiveField(9)
  bool isActive;

  Garden({
    String? id,
    required this.name,
    required this.description,
    required this.totalAreaInSquareMeters,
    required this.location,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.imageUrl,
    Map<String, dynamic>? metadata,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        metadata = metadata ?? {};

  // Méthodes utilitaires
  void markAsUpdated() {
    updatedAt = DateTime.now();
  }

  // Validation
  bool get isValid {
    return name.isNotEmpty &&
        totalAreaInSquareMeters > 0 &&
        location.isNotEmpty;
  }

  // Conversion JSON pour export/import
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'totalAreaInSquareMeters': totalAreaInSquareMeters,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'imageUrl': imageUrl,
      'metadata': metadata,
      'isActive': isActive,
    };
  }

  factory Garden.fromJson(Map<String, dynamic> json) {
    return Garden(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      totalAreaInSquareMeters: json['totalAreaInSquareMeters'].toDouble(),
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      imageUrl: json['imageUrl'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      isActive: json['isActive'] ?? true,
    );
  }

  // Copie avec modifications
  Garden copyWith({
    String? name,
    String? description,
    double? totalAreaInSquareMeters,
    String? location,
    String? imageUrl,
    Map<String, dynamic>? metadata,
    bool? isActive,
  }) {
    return Garden(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      totalAreaInSquareMeters:
          totalAreaInSquareMeters ?? this.totalAreaInSquareMeters,
      location: location ?? this.location,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? Map<String, dynamic>.from(this.metadata),
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'Garden(id: $id, name: $name, area: ${totalAreaInSquareMeters}m²)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Garden && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


