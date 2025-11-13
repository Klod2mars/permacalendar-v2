import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'growth_cycle.g.dart';

@HiveType(typeId: 5)
class GrowthCycle extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String plantId;

  @HiveField(2)
  String phaseName;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime endDate;

  @HiveField(6)
  int durationInDays;

  @HiveField(7)
  List<String> careInstructions;

  @HiveField(8)
  Map<String, dynamic> requirements;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime updatedAt;

  @HiveField(11)
  bool isActive;

  GrowthCycle({
    String? id,
    required this.plantId,
    required this.phaseName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.durationInDays,
    List<String>? careInstructions,
    Map<String, dynamic>? requirements,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        careInstructions = careInstructions ?? [],
        requirements = requirements ?? {},
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Phases de croissance communes
  static const List<String> commonPhases = [
    'Germination',
    'Plantule',
    'Croissance végétative',
    'Floraison',
    'Fructification',
    'Maturation',
    'Récolte',
  ];

  // Méthodes utilitaires
  void addCareInstruction(String instruction) {
    if (!careInstructions.contains(instruction)) {
      careInstructions.add(instruction);
      markAsUpdated();
    }
  }

  void markAsUpdated() {
    updatedAt = DateTime.now();
  }

  // Validation
  bool get isValid {
    return plantId.isNotEmpty &&
        phaseName.isNotEmpty &&
        startDate.isBefore(endDate) &&
        durationInDays > 0;
  }

  // Calculs utilitaires
  bool isCurrentPhase(DateTime date) {
    return date.isAfter(startDate) && date.isBefore(endDate);
  }

  bool hasStarted(DateTime date) {
    return date.isAfter(startDate);
  }

  bool hasEnded(DateTime date) {
    return date.isAfter(endDate);
  }

  int daysRemaining(DateTime date) {
    if (hasEnded(date)) return 0;
    return endDate.difference(date).inDays;
  }

  int daysSinceStart(DateTime date) {
    if (!hasStarted(date)) return 0;
    return date.difference(startDate).inDays;
  }

  double progressPercentage(DateTime date) {
    if (!hasStarted(date)) return 0.0;
    if (hasEnded(date)) return 100.0;

    final totalDays = endDate.difference(startDate).inDays;
    final elapsedDays = date.difference(startDate).inDays;

    return (elapsedDays / totalDays * 100).clamp(0.0, 100.0);
  }

  // Conversion JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'phaseName': phaseName,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'durationInDays': durationInDays,
      'careInstructions': careInstructions,
      'requirements': requirements,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory GrowthCycle.fromJson(Map<String, dynamic> json) {
    return GrowthCycle(
      id: json['id'],
      plantId: json['plantId'],
      phaseName: json['phaseName'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      durationInDays: json['durationInDays'],
      careInstructions: List<String>.from(json['careInstructions'] ?? []),
      requirements: Map<String, dynamic>.from(json['requirements'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  String toString() {
    return 'GrowthCycle(id: $id, phase: $phaseName, duration: ${durationInDays}d)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GrowthCycle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


