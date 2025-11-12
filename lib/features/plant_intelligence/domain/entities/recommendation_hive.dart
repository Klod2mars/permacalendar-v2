import 'package:hive/hive.dart';
import 'recommendation.dart';

part 'recommendation_hive.g.dart';

/// Adaptateur Hive pour la persistance de Recommendation
/// TypeId: 39 - Utilisé pour stocker les recommandations intelligentes
@HiveType(typeId: 39)
class RecommendationHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String plantId;

  @HiveField(2)
  String gardenId;

  @HiveField(3)
  int typeIndex; // Index de RecommendationType

  @HiveField(4)
  int priorityIndex; // Index de RecommendationPriority

  @HiveField(5)
  String title;

  @HiveField(6)
  String description;

  @HiveField(7)
  List<String> instructions;

  @HiveField(8)
  DateTime? deadline;

  @HiveField(9)
  List<String>? optimalConditions;

  @HiveField(10)
  double expectedImpact;

  @HiveField(11)
  Map<String, dynamic>? metadata;

  @HiveField(12)
  int statusIndex; // Index de RecommendationStatus

  @HiveField(13)
  DateTime? createdAt;

  @HiveField(14)
  DateTime? completedAt;

  RecommendationHive({
    required this.id,
    required this.plantId,
    required this.gardenId,
    required this.typeIndex,
    required this.priorityIndex,
    required this.title,
    required this.description,
    required this.instructions,
    this.deadline,
    this.optimalConditions,
    required this.expectedImpact,
    this.metadata,
    required this.statusIndex,
    this.createdAt,
    this.completedAt,
  });

  /// Convertir depuis Recommendation vers RecommendationHive
  factory RecommendationHive.fromDomain(Recommendation recommendation) {
    return RecommendationHive(
      id: recommendation.id,
      plantId: recommendation.plantId,
      gardenId: recommendation.gardenId,
      typeIndex: recommendation.type.index,
      priorityIndex: recommendation.priority.index,
      title: recommendation.title,
      description: recommendation.description,
      instructions: recommendation.instructions,
      deadline: recommendation.deadline,
      optimalConditions: recommendation.optimalConditions,
      expectedImpact: recommendation.expectedImpact,
      metadata: recommendation.metadata,
      statusIndex: recommendation.status.index,
      createdAt: recommendation.createdAt,
      completedAt: recommendation.completedAt,
    );
  }

  /// Convertir vers Recommendation depuis RecommendationHive
  Recommendation toDomain() {
    return Recommendation(
      id: id,
      plantId: plantId,
      gardenId: gardenId,
      type: RecommendationType.values[typeIndex],
      priority: RecommendationPriority.values[priorityIndex],
      title: title,
      description: description,
      instructions: instructions,
      deadline: deadline,
      optimalConditions: optimalConditions,
      expectedImpact: expectedImpact,
      effortRequired: 0.0, // Valeur par défaut
      estimatedCost: 0.0, // Valeur par défaut
      metadata: metadata ?? {},
      status: RecommendationStatus.values[statusIndex],
      createdAt: createdAt,
      completedAt: completedAt,
    );
  }
}

