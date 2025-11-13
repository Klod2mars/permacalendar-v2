import '../entities/pest_observation.dart';

/// Pest Observation Repository Interface
///
/// PHILOSOPHY:
/// This repository manages pest observations in the Sanctuary (user's garden reality).
/// Observations are created ONLY by the user, NEVER by the AI.
/// The Intelligence Végétale can READ observations but MUST NEVER CREATE or MODIFY them.
/// This maintains the sacred boundary: User (Reality) â†’ Sanctuary (Storage) â†’ Intelligence (Read-only)
abstract class IPestObservationRepository {
  /// Save a pest observation (USER ACTION ONLY)
  Future<void> savePestObservation(PestObservation observation);

  /// Update an existing observation (USER ACTION ONLY)
  Future<void> updatePestObservation(PestObservation observation);

  /// Get all observations for a specific garden
  Future<List<PestObservation>> getObservationsForGarden(String gardenId);

  /// Get active (unresolved) observations for a garden
  Future<List<PestObservation>> getActiveObservations(String gardenId);

  /// Get observations for a specific plant
  Future<List<PestObservation>> getObservationsForPlant(String plantId);

  /// Get a specific observation by ID
  Future<PestObservation?> getObservation(String observationId);

  /// Mark observation as resolved (USER ACTION ONLY)
  Future<void> resolveObservation(
    String observationId,
    String resolutionMethod,
  );

  /// Delete an observation (USER ACTION ONLY)
  Future<void> deleteObservation(String observationId);
}


