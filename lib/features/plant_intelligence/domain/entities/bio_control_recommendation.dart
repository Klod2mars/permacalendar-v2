import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'bio_control_recommendation.freezed.dart';
part 'bio_control_recommendation.g.dart';

/// Types of Biological Control
enum BioControlType {
  introduceBeneficial, // Introduce beneficial insects
  plantCompanion, // Plant companion/repellent plants
  createHabitat, // Create favorable habitat for beneficials
  culturalPractice, // Cultural practices (rotation, spacing, etc.)
}

/// BioControlAction - Specific action within a recommendation
@freezed
class BioControlAction with _$BioControlAction {
  const factory BioControlAction({
    required String description,
    required String timing, // "Immediately", "Next spring", etc.
    required List<String>
        resources, // Required resources (ladybugs, seeds, etc.)
    String? detailedInstructions,
    int? estimatedCostEuros,
    int? estimatedTimeMinutes,
  }) = _BioControlAction;

  factory BioControlAction.fromJson(Map<String, dynamic> json) =>
      _$BioControlActionFromJson(json);
}

/// BioControlRecommendation Entity - AI-generated recommendation for biological pest control
///
/// PHILOSOPHY:
/// This entity is generated ONLY by the Intelligence Végétale, NEVER by the user.
/// It represents the AI's interpretation and recommendation based on pest observations.
/// The AI reads from the Sanctuary (observations) and produces recommendations,
/// but NEVER modifies the Sanctuary. This maintains the unidirectional flow:
/// Sanctuary (Reality) → Intelligence (Analysis & Recommendations) → User (Decision)
@freezed
class BioControlRecommendation with _$BioControlRecommendation {
  const factory BioControlRecommendation({
    required String id,
    required String pestObservationId,
    required BioControlType type,
    required String description,
    required List<BioControlAction> actions,
    required int priority, // 1 (urgent) to 5 (preventive)
    required double effectivenessScore, // 0-100%
    DateTime? createdAt,
    String? targetBeneficialId, // For introduceBeneficial type
    String? targetPlantId, // For plantCompanion type
    bool? isApplied, // Whether user applied this recommendation
    DateTime? appliedAt,
    String? userFeedback,
  }) = _BioControlRecommendation;

  factory BioControlRecommendation.fromJson(Map<String, dynamic> json) =>
      _$BioControlRecommendationFromJson(json);
}

/// Hive adapter for BioControlRecommendation
@HiveType(typeId: 53)
class BioControlRecommendationHive extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String pestObservationId;

  @HiveField(2)
  late String type; // Stored as string

  @HiveField(3)
  late String description;

  @HiveField(4)
  late List<String> actionDescriptions; // Simplified storage

  @HiveField(5)
  late List<String> actionTimings;

  @HiveField(6)
  late int priority;

  @HiveField(7)
  late double effectivenessScore;

  @HiveField(8)
  DateTime? createdAt;

  @HiveField(9)
  String? targetBeneficialId;

  @HiveField(10)
  String? targetPlantId;

  @HiveField(11)
  bool? isApplied;

  @HiveField(12)
  DateTime? appliedAt;

  @HiveField(13)
  String? userFeedback;

  BioControlRecommendationHive();

  factory BioControlRecommendationHive.fromDomain(
      BioControlRecommendation recommendation) {
    return BioControlRecommendationHive()
      ..id = recommendation.id
      ..pestObservationId = recommendation.pestObservationId
      ..type = recommendation.type.name
      ..description = recommendation.description
      ..actionDescriptions =
          recommendation.actions.map((a) => a.description).toList()
      ..actionTimings = recommendation.actions.map((a) => a.timing).toList()
      ..priority = recommendation.priority
      ..effectivenessScore = recommendation.effectivenessScore
      ..createdAt = recommendation.createdAt
      ..targetBeneficialId = recommendation.targetBeneficialId
      ..targetPlantId = recommendation.targetPlantId
      ..isApplied = recommendation.isApplied
      ..appliedAt = recommendation.appliedAt
      ..userFeedback = recommendation.userFeedback;
  }

  BioControlRecommendation toDomain() {
    final actions = <BioControlAction>[];
    for (int i = 0; i < actionDescriptions.length; i++) {
      actions.add(BioControlAction(
        description: actionDescriptions[i],
        timing: actionTimings[i],
        resources: [], // Simplified - full resources would need separate storage
      ));
    }

    return BioControlRecommendation(
      id: id,
      pestObservationId: pestObservationId,
      type: BioControlType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => BioControlType.introduceBeneficial,
      ),
      description: description,
      actions: actions,
      priority: priority,
      effectivenessScore: effectivenessScore,
      createdAt: createdAt,
      targetBeneficialId: targetBeneficialId,
      targetPlantId: targetPlantId,
      isApplied: isApplied,
      appliedAt: appliedAt,
      userFeedback: userFeedback,
    );
  }
}

