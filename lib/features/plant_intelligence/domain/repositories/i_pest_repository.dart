import '../entities/pest.dart';

/// Pest Repository Interface
///
/// PHILOSOPHY:
/// This repository provides access to the pest catalog (knowledge base).
/// It reads from static data sources (JSON catalogs) and never modifies them.
/// The catalog represents known pests, not real observations in the user's garden.
abstract class IPestRepository {
  /// Get a specific pest by ID
  Future<Pest?> getPest(String pestId);

  /// Get all pests from the catalog
  Future<List<Pest>> getAllPests();

  /// Get pests that affect a specific plant
  Future<List<Pest>> getPestsForPlant(String plantId);

  /// Search pests by name
  Future<List<Pest>> searchPests(String query);

  /// Get pests by severity level
  Future<List<Pest>> getPestsBySeverity(PestSeverity severity);
}

