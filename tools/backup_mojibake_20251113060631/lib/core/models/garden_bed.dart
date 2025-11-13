import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'garden_bed.g.dart';

@HiveType(typeId: 1)
class GardenBed extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String gardenId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String description;

  @HiveField(4)
  double sizeInSquareMeters;

  @HiveField(5)
  String soilType;

  @HiveField(6)
  String exposure; // Ensoleillé, Mi-ombre, Ombre

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  @HiveField(9)
  Map<String, dynamic> metadata;

  @HiveField(10)
  bool isActive;

  @HiveField(11)
  String? notes;

  GardenBed({
    String? id,
    required this.gardenId,
    required this.name,
    required this.description,
    required this.sizeInSquareMeters,
    required this.soilType,
    required this.exposure,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    this.isActive = true,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        metadata = metadata ?? {};

  // Types d'exposition disponibles
  static const List<String> exposureTypes = [
    'Plein soleil',
    'Mi-soleil',
    'Mi-ombre',
    'Ombre',
  ];

  // Types de sol disponibles
  static const List<String> soilTypes = [
    'Argileux',
    'Sableux',
    'Limoneux',
    'Humifère',
    'Calcaire',
    'Mixte',
  ];

  // Méthodes utilitaires
  void markAsUpdated() {
    updatedAt = DateTime.now();
  }

  // Validation
  bool get isValid {
    return name.isNotEmpty &&
        sizeInSquareMeters > 0 &&
        soilType.isNotEmpty &&
        exposure.isNotEmpty &&
        gardenId.isNotEmpty;
  }

  bool get isValidExposure => exposureTypes.contains(exposure);
  bool get isValidSoilType => soilTypes.contains(soilType);

  // Calculs utilitaires
  double get sizeInSquareMetersRounded =>
      double.parse(sizeInSquareMeters.toStringAsFixed(2));

  String get formattedSize => '${sizeInSquareMetersRounded}m²';

  // Conversion JSON pour export/import
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gardenId': gardenId,
      'name': name,
      'description': description,
      'sizeInSquareMeters': sizeInSquareMeters,
      'soilType': soilType,
      'exposure': exposure,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
      'isActive': isActive,
      'notes': notes,
    };
  }

  factory GardenBed.fromJson(Map<String, dynamic> json) {
    return GardenBed(
      id: json['id'],
      gardenId: json['gardenId'],
      name: json['name'],
      description: json['description'],
      sizeInSquareMeters: json['sizeInSquareMeters'].toDouble(),
      soilType: json['soilType'],
      exposure: json['exposure'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      isActive: json['isActive'] ?? true,
      notes: json['notes'],
    );
  }

  // Copie avec modifications
  GardenBed copyWith({
    String? name,
    String? description,
    double? sizeInSquareMeters,
    String? soilType,
    String? exposure,
    Map<String, dynamic>? metadata,
    bool? isActive,
    String? notes,
  }) {
    return GardenBed(
      id: id,
      gardenId: gardenId,
      name: name ?? this.name,
      description: description ?? this.description,
      sizeInSquareMeters: sizeInSquareMeters ?? this.sizeInSquareMeters,
      soilType: soilType ?? this.soilType,
      exposure: exposure ?? this.exposure,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      metadata: metadata ?? Map<String, dynamic>.from(this.metadata),
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'GardenBed(id: $id, name: $name, size: $formattedSize)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GardenBed && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


