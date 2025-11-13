import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'pest.freezed.dart';
part 'pest.g.dart';

/// Pest Severity Levels
enum PestSeverity {
  low,
  moderate,
  high,
  critical,
}

/// Pest Entity - Represents a garden pest/ravageur
///
/// PHILOSOPHY:
/// This entity represents pests that can affect plants in the garden.
/// It contains information about natural predators and repellent plants,
/// enabling biological pest control recommendations.
@freezed
class Pest with _$Pest {
  const factory Pest({
    required String id,
    required String name,
    required String scientificName,
    required List<String> affectedPlants, // Plant IDs that this pest targets
    required PestSeverity defaultSeverity, // Default severity level
    required List<String> symptoms, // Visible symptoms
    required List<String>
        naturalPredators, // Beneficial insect IDs that prey on this pest
    required List<String> repellentPlants, // Plant IDs that repel this pest
    String? description,
    String? imageUrl,
    String? preventionTips,
  }) = _Pest;

  factory Pest.fromJson(Map<String, dynamic> json) => _$PestFromJson(json);
}

/// Hive adapter for Pest
@HiveType(typeId: 50)
class PestHive extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String scientificName;

  @HiveField(3)
  late List<String> affectedPlants;

  @HiveField(4)
  late String defaultSeverity; // Stored as string

  @HiveField(5)
  late List<String> symptoms;

  @HiveField(6)
  late List<String> naturalPredators;

  @HiveField(7)
  late List<String> repellentPlants;

  @HiveField(8)
  String? description;

  @HiveField(9)
  String? imageUrl;

  @HiveField(10)
  String? preventionTips;

  PestHive();

  factory PestHive.fromDomain(Pest pest) {
    return PestHive()
      ..id = pest.id
      ..name = pest.name
      ..scientificName = pest.scientificName
      ..affectedPlants = pest.affectedPlants
      ..defaultSeverity = pest.defaultSeverity.name
      ..symptoms = pest.symptoms
      ..naturalPredators = pest.naturalPredators
      ..repellentPlants = pest.repellentPlants
      ..description = pest.description
      ..imageUrl = pest.imageUrl
      ..preventionTips = pest.preventionTips;
  }

  Pest toDomain() {
    return Pest(
      id: id,
      name: name,
      scientificName: scientificName,
      affectedPlants: affectedPlants,
      defaultSeverity: PestSeverity.values.firstWhere(
        (e) => e.name == defaultSeverity,
        orElse: () => PestSeverity.moderate,
      ),
      symptoms: symptoms,
      naturalPredators: naturalPredators,
      repellentPlants: repellentPlants,
      description: description,
      imageUrl: imageUrl,
      preventionTips: preventionTips,
    );
  }
}


