import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'planting_v2.g.dart';

@HiveType(typeId: 14)
class Planting extends HiveObject {
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

  Planting({
    required this.id,
    required this.plantId,
    required this.gardenBedId,
    required this.plantingDate,
    required this.status,
  });

  // Factory constructor pour Créer une nouvelle plantation avec ID généré
  factory Planting.create({
    required String plantId,
    required String gardenBedId,
    required DateTime plantingDate,
    required String status,
  }) {
    return Planting(
      id: const Uuid().v4(),
      plantId: plantId,
      gardenBedId: gardenBedId,
      plantingDate: plantingDate,
      status: status,
    );
  }

  // Méthodes fromJson/toJson pour la sérialisation
  factory Planting.fromJson(Map<String, dynamic> json) {
    return Planting(
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
  Planting copyWith({
    String? plantId,
    String? gardenBedId,
    DateTime? plantingDate,
    String? status,
  }) {
    return Planting(
      id: id,
      plantId: plantId ?? this.plantId,
      gardenBedId: gardenBedId ?? this.gardenBedId,
      plantingDate: plantingDate ?? this.plantingDate,
      status: status ?? this.status,
    );
  }

  // Statuts de plantation disponibles
  static const List<String> availableStatuses = [
    'Planifié',
    'Planté',
    'En croissance',
    'Prêt à récolter',
    'Récolté',
    'Échoué',
  ];

  @override
  String toString() {
    return 'Planting(id: $id, plantId: $plantId, gardenBedId: $gardenBedId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Planting && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
