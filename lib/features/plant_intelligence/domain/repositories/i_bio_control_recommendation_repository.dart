import '../entities/bio_control_recommendation.dart';

/// Biological Control Recommendation Repository Interface
///
/// PHILOSOPHY:
/// This repository manages AI-generated recommendations for biological pest control.
/// Recommendations are created ONLY by the Intelligence Végétale, NEVER by the user directly.
/// The user can READ recommendations and mark them as applied, but creation is AI-driven.
/// This maintains the unidirectional flow: Observation (Sanctuary) → Analysis (Intelligence) → Recommendation (AI Output)
abstract class IBioControlRecommendationRepository {
  /// Save a recommendation (AI ACTION ONLY)
  Future<void> saveRecommendation(BioControlRecommendation recommendation);

  /// Get all recommendations for a specific garden
  Future<List<BioControlRecommendation>> getRecommendationsForGarden(
    String gardenId,
  );

  /// Get recommendations for a specific pest observation
  Future<List<BioControlRecommendation>> getRecommendationsForObservation(
    String observationId,
  );

  /// Get a specific recommendation by ID
  Future<BioControlRecommendation?> getRecommendation(String recommendationId);

  /// Mark recommendation as applied by user (USER ACTION)
  Future<void> markRecommendationApplied(
    String recommendationId,
    String? userFeedback,
  );

  /// Get applied recommendations for tracking effectiveness
  Future<List<BioControlRecommendation>> getAppliedRecommendations(
    String gardenId,
  );

  /// Delete a recommendation
  Future<void> deleteRecommendation(String recommendationId);
}


