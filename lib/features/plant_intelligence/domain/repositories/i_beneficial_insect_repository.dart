import '../entities/beneficial_insect.dart';

/// Beneficial Insect Repository Interface
///
/// PHILOSOPHY:
/// This repository provides access to the beneficial insect catalog (knowledge base).
/// It reads from static data sources (JSON catalogs) and never modifies them.
/// The catalog represents known beneficial insects and their properties.
abstract class IBeneficialInsectRepository {
  /// Get a specific beneficial insect by ID
  Future<BeneficialInsect?> getInsect(String insectId);

  /// Get all beneficial insects from the catalog
  Future<List<BeneficialInsect>> getAllInsects();

  /// Get beneficial insects that prey on a specific pest
  Future<List<BeneficialInsect>> getPredatorsOf(String pestId);

  /// Get beneficial insects attracted to a specific plant/flower
  Future<List<BeneficialInsect>> getInsectsAttractedTo(String plantId);

  /// Search beneficial insects by name
  Future<List<BeneficialInsect>> searchInsects(String query);
}


