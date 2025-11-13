ï»¿import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'planting.g.dart';

@HiveType(typeId: 3)
class Planting extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String gardenBedId;

  @HiveField(2)
  final String plantId;

  @HiveField(3)
  String plantName; // Nom de la plante pour référence rapide

  @HiveField(4)
  DateTime plantedDate;

  @HiveField(5)
  DateTime? expectedHarvestStartDate;

  @HiveField(6)
  DateTime? expectedHarvestEndDate;

  @HiveField(7)
  DateTime? actualHarvestDate;

  @HiveField(8)
  int quantity;

  @HiveField(9)
  String status; // Semé, Planté

  @HiveField(10)
  String? notes;

  @HiveField(11)
  DateTime createdAt;

  @HiveField(12)
  DateTime updatedAt;

  @HiveField(13)
  Map<String, dynamic> metadata;

  @HiveField(14)
  bool isActive;

  @HiveField(15)
  List<String> careActions; // Actions de soin effectuées

  Planting({
    String? id,
    required this.gardenBedId,
    required this.plantId,
    required this.plantName,
    required this.plantedDate,
    this.expectedHarvestStartDate,
    this.expectedHarvestEndDate,
    this.actualHarvestDate,
    required this.quantity,
    this.status = 'Planté',
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    this.isActive = true,
    List<String>? careActions,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        metadata = metadata ?? {},
        careActions = careActions ?? [];

  // Statuts disponibles - Simplifiés selon les recommandations
  static const List<String> statusOptions = [
    'Semé',
    'Planté',
  ];

  // Actions de soin communes
  static const List<String> commonCareActions = [
    'Arrosage',
    'Fertilisation',
    'Désherbage',
    'Taille',
    'Traitement',
    'Paillage',
    'Buttage',
  ];

  // Méthodes utilitaires
  void markAsUpdated() {
    updatedAt = DateTime.now();
  }

  // Méthode pour Créer une copie avec les nouveaux champs
  Planting copyWith({
    String? id,
    String? gardenBedId,
    String? plantId,
    String? plantName,
    DateTime? plantedDate,
    DateTime? expectedHarvestStartDate,
    DateTime? expectedHarvestEndDate,
    DateTime? actualHarvestDate,
    int? quantity,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    bool? isActive,
    List<String>? careActions,
  }) {
    return Planting(
      id: id ?? this.id,
      gardenBedId: gardenBedId ?? this.gardenBedId,
      plantId: plantId ?? this.plantId,
      plantName: plantName ?? this.plantName,
      plantedDate: plantedDate ?? this.plantedDate,
      expectedHarvestStartDate:
          expectedHarvestStartDate ?? this.expectedHarvestStartDate,
      expectedHarvestEndDate:
          expectedHarvestEndDate ?? this.expectedHarvestEndDate,
      actualHarvestDate: actualHarvestDate ?? this.actualHarvestDate,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
      careActions: careActions ?? this.careActions,
    );
  }

  void addCareAction(String action) {
    final actionWithDate = '$action - ${DateTime.now().toIso8601String()}';
    careActions.add(actionWithDate);
    markAsUpdated();
  }

  void updateStatus(String newStatus) {
    if (statusOptions.contains(newStatus)) {
      status = newStatus;
      markAsUpdated();
    }
  }

  // Validation
  bool get isValid {
    return gardenBedId.isNotEmpty &&
        plantId.isNotEmpty &&
        plantName.isNotEmpty &&
        quantity > 0;
  }

  bool get isValidStatus => statusOptions.contains(status);

  // Calculs utilitaires
  int get daysPlanted {
    return DateTime.now().difference(plantedDate).inDays;
  }

  int? get daysToExpectedHarvestStart {
    if (expectedHarvestStartDate == null) return null;
    return expectedHarvestStartDate!.difference(DateTime.now()).inDays;
  }

  int? get daysToExpectedHarvestEnd {
    if (expectedHarvestEndDate == null) return null;
    return expectedHarvestEndDate!.difference(DateTime.now()).inDays;
  }

  int? get daysFromPlantingToHarvest {
    if (actualHarvestDate == null) return null;
    return actualHarvestDate!.difference(plantedDate).inDays;
  }

  bool get isInHarvestPeriod {
    if (expectedHarvestStartDate == null || expectedHarvestEndDate == null)
      return false;
    final now = DateTime.now();
    return now.isAfter(expectedHarvestStartDate!) &&
        now.isBefore(expectedHarvestEndDate!);
  }

  bool get isHarvested => actualHarvestDate != null;

  bool get isHarvestOverdue {
    if (expectedHarvestEndDate == null) return false;
    return DateTime.now().isAfter(expectedHarvestEndDate!);
  }

  double get successRate {
    if (!isHarvested) return 0.0;
    if (expectedHarvestStartDate == null) return 1.0;

    final expectedDays =
        expectedHarvestStartDate!.difference(plantedDate).inDays;
    final actualDays = actualHarvestDate!.difference(plantedDate).inDays;

    if (actualDays <= expectedDays) return 1.0;

    // Pénalité pour retard
    final delay = actualDays - expectedDays;
    return (1.0 - (delay / expectedDays)).clamp(0.0, 1.0);
  }

  // Conversion JSON pour export/import
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gardenBedId': gardenBedId,
      'plantId': plantId,
      'plantName': plantName,
      'plantedDate': plantedDate.toIso8601String(),
      'expectedHarvestStartDate': expectedHarvestStartDate?.toIso8601String(),
      'expectedHarvestEndDate': expectedHarvestEndDate?.toIso8601String(),
      'actualHarvestDate': actualHarvestDate?.toIso8601String(),
      'quantity': quantity,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
      'isActive': isActive,
      'careActions': careActions,
    };
  }

  factory Planting.fromJson(Map<String, dynamic> json) {
    return Planting(
      id: json['id'],
      gardenBedId: json['gardenBedId'],
      plantId: json['plantId'],
      plantName: json['plantName'],
      plantedDate: DateTime.parse(json['plantedDate']),
      expectedHarvestStartDate: json['expectedHarvestStartDate'] != null
          ? DateTime.parse(json['expectedHarvestStartDate'])
          : null,
      expectedHarvestEndDate: json['expectedHarvestEndDate'] != null
          ? DateTime.parse(json['expectedHarvestEndDate'])
          : null,
      actualHarvestDate: json['actualHarvestDate'] != null
          ? DateTime.parse(json['actualHarvestDate'])
          : null,
      quantity: json['quantity'],
      status: json['status'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      isActive: json['isActive'] ?? true,
      careActions: List<String>.from(json['careActions'] ?? []),
    );
  }

  @override
  String toString() {
    return 'Planting(id: $id, plant: $plantName, quantity: $quantity, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Planting && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


