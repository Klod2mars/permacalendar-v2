import 'dart:developer' as developer;
import '../../domain/repositories/i_pest_repository.dart';
import '../../domain/repositories/i_beneficial_insect_repository.dart';
import '../../domain/repositories/i_pest_observation_repository.dart';
import '../../domain/repositories/i_bio_control_recommendation_repository.dart';
import '../../domain/entities/pest.dart';
import '../../domain/entities/beneficial_insect.dart';
import '../../domain/entities/pest_observation.dart';
import '../../domain/entities/bio_control_recommendation.dart';
import '../datasources/biological_control_datasource.dart';

/// Implementation of biological control repositories
///
/// Following Clean Architecture and ISP (Interface Segregation Principle),
/// this class implements all 4 biological control repository interfaces:
/// - IPestRepository: Read-only access to pest catalog
/// - IBeneficialInsectRepository: Read-only access to beneficial insect catalog
/// - IPestObservationRepository: CRUD for user observations (Sanctuary)
/// - IBioControlRecommendationRepository: CRUD for AI recommendations
///
/// PHILOSOPHY:
/// This repository respects the Sanctuary principle:
/// - Pest observations are created ONLY by the user (Sanctuary data)
/// - Recommendations are generated ONLY by the AI
/// - Catalogs are read-only reference data
class BiologicalControlRepositoryImpl
    implements
        IPestRepository,
        IBeneficialInsectRepository,
        IPestObservationRepository,
        IBioControlRecommendationRepository {
  static const String _logName = 'BiologicalControlRepository';

  final BiologicalControlDataSource _dataSource;

  BiologicalControlRepositoryImpl({
    required BiologicalControlDataSource dataSource,
  }) : _dataSource = dataSource;

  // ==================== PEST REPOSITORY ====================

  @override
  Future<Pest?> getPest(String pestId) async {
    try {
      return await _dataSource.getPestById(pestId);
    } catch (e) {
      developer.log('Error getting pest $pestId: $e',
          name: _logName, level: 900);
      return null;
    }
  }

  @override
  Future<List<Pest>> getAllPests() async {
    try {
      return await _dataSource.loadPestCatalog();
    } catch (e) {
      developer.log('Error getting all pests: $e', name: _logName, level: 1000);
      return [];
    }
  }

  @override
  Future<List<Pest>> getPestsForPlant(String plantId) async {
    try {
      final allPests = await _dataSource.loadPestCatalog();
      return allPests
          .where((pest) => pest.affectedPlants.contains(plantId))
          .toList();
    } catch (e) {
      developer.log('Error getting pests for plant $plantId: $e',
          name: _logName, level: 900);
      return [];
    }
  }

  @override
  Future<List<Pest>> getPestsBySeverity(PestSeverity severity) async {
    try {
      final allPests = await _dataSource.loadPestCatalog();
      return allPests
          .where((pest) => pest.defaultSeverity == severity)
          .toList();
    } catch (e) {
      developer.log('Error getting pests by severity $severity: $e',
          name: _logName, level: 900);
      return [];
    }
  }

  @override
  Future<List<Pest>> searchPests(String query) async {
    try {
      final allPests = await _dataSource.loadPestCatalog();
      final lowerQuery = query.toLowerCase();
      return allPests
          .where((pest) =>
              pest.name.toLowerCase().contains(lowerQuery) ||
              pest.scientificName.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      developer.log('Error searching pests with query "$query": $e',
          name: _logName, level: 900);
      return [];
    }
  }

  // ==================== BENEFICIAL INSECT REPOSITORY ====================

  @override
  Future<BeneficialInsect?> getInsect(String insectId) async {
    try {
      return await _dataSource.getBeneficialInsectById(insectId);
    } catch (e) {
      developer.log('Error getting insect $insectId: $e',
          name: _logName, level: 900);
      return null;
    }
  }

  @override
  Future<List<BeneficialInsect>> getAllInsects() async {
    try {
      return await _dataSource.loadBeneficialInsectCatalog();
    } catch (e) {
      developer.log('Error getting all insects: $e',
          name: _logName, level: 1000);
      return [];
    }
  }

  @override
  Future<List<BeneficialInsect>> getPredatorsOf(String pestId) async {
    try {
      final allInsects = await _dataSource.loadBeneficialInsectCatalog();
      return allInsects
          .where((insect) => insect.preyPests.contains(pestId))
          .toList();
    } catch (e) {
      developer.log('Error getting predators for pest $pestId: $e',
          name: _logName, level: 900);
      return [];
    }
  }

  @override
  Future<List<BeneficialInsect>> getInsectsAttractedTo(String plantId) async {
    try {
      final allInsects = await _dataSource.loadBeneficialInsectCatalog();
      return allInsects
          .where((insect) => insect.attractiveFlowers.contains(plantId))
          .toList();
    } catch (e) {
      developer.log('Error getting insects attracted to plant $plantId: $e',
          name: _logName, level: 900);
      return [];
    }
  }

  @override
  Future<List<BeneficialInsect>> searchInsects(String query) async {
    try {
      final allInsects = await _dataSource.loadBeneficialInsectCatalog();
      final lowerQuery = query.toLowerCase();
      return allInsects
          .where((insect) =>
              insect.name.toLowerCase().contains(lowerQuery) ||
              insect.scientificName.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      developer.log('Error searching insects with query "$query": $e',
          name: _logName, level: 900);
      return [];
    }
  }

  // ==================== PEST OBSERVATION REPOSITORY ====================

  @override
  Future<void> savePestObservation(PestObservation observation) async {
    try {
      await _dataSource.savePestObservation(observation);
      developer.log('✅ Pest observation saved to Sanctuary', name: _logName);
    } catch (e, stackTrace) {
      developer.log(
        'Error saving pest observation',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> updatePestObservation(PestObservation observation) async {
    try {
      await _dataSource
          .savePestObservation(observation); // Update uses same method as save
      developer.log('✅ Pest observation updated', name: _logName);
    } catch (e, stackTrace) {
      developer.log(
        'Error updating pest observation',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<PestObservation>> getObservationsForGarden(
      String gardenId) async {
    try {
      return await _dataSource.getObservationsForGarden(gardenId);
    } catch (e) {
      developer.log('Error getting observations for garden $gardenId: $e',
          name: _logName, level: 1000);
      return [];
    }
  }

  @override
  Future<List<PestObservation>> getActiveObservations(String gardenId) async {
    try {
      return await _dataSource.getActiveObservations(gardenId);
    } catch (e) {
      developer.log(
          'Error getting active observations for garden $gardenId: $e',
          name: _logName,
          level: 1000);
      return [];
    }
  }

  @override
  Future<List<PestObservation>> getObservationsForPlant(String plantId) async {
    try {
      final allObservations =
          await _dataSource.getObservationsForPlant(plantId);
      return allObservations;
    } catch (e) {
      developer.log('Error getting observations for plant $plantId: $e',
          name: _logName, level: 900);
      return [];
    }
  }

  @override
  Future<PestObservation?> getObservation(String observationId) async {
    try {
      return await _dataSource.getObservation(observationId);
    } catch (e) {
      developer.log('Error getting observation $observationId: $e',
          name: _logName, level: 900);
      return null;
    }
  }

  @override
  Future<void> resolveObservation(
      String observationId, String resolutionMethod) async {
    try {
      await _dataSource.resolveObservation(observationId, resolutionMethod);
      developer.log('✅ Observation resolved: $observationId', name: _logName);
    } catch (e, stackTrace) {
      developer.log(
        'Error resolving observation',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteObservation(String observationId) async {
    try {
      await _dataSource.deleteObservation(observationId);
      developer.log('✅ Observation deleted: $observationId', name: _logName);
    } catch (e, stackTrace) {
      developer.log(
        'Error deleting observation',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // ==================== BIO CONTROL RECOMMENDATION REPOSITORY ====================

  @override
  Future<void> saveRecommendation(
      BioControlRecommendation recommendation) async {
    try {
      await _dataSource.saveBioControlRecommendation(recommendation);
      developer.log('✅ Bio control recommendation saved', name: _logName);
    } catch (e, stackTrace) {
      developer.log(
        'Error saving recommendation',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<BioControlRecommendation>> getRecommendationsForGarden(
      String gardenId) async {
    try {
      return await _dataSource.getRecommendationsForGarden(gardenId);
    } catch (e) {
      developer.log('Error getting recommendations for garden $gardenId: $e',
          name: _logName, level: 1000);
      return [];
    }
  }

  @override
  Future<List<BioControlRecommendation>> getRecommendationsForObservation(
      String observationId) async {
    try {
      final allRecommendations =
          await _dataSource.getRecommendationsForObservation(observationId);
      return allRecommendations;
    } catch (e) {
      developer.log(
          'Error getting recommendations for observation $observationId: $e',
          name: _logName,
          level: 900);
      return [];
    }
  }

  @override
  Future<BioControlRecommendation?> getRecommendation(
      String recommendationId) async {
    try {
      return await _dataSource.getRecommendation(recommendationId);
    } catch (e) {
      developer.log('Error getting recommendation $recommendationId: $e',
          name: _logName, level: 900);
      return null;
    }
  }

  @override
  Future<void> markRecommendationApplied(
      String recommendationId, String? userFeedback) async {
    try {
      await _dataSource.markRecommendationApplied(
          recommendationId, DateTime.now(), userFeedback);
      developer.log('✅ Recommendation marked as applied: $recommendationId',
          name: _logName);
    } catch (e, stackTrace) {
      developer.log(
        'Error marking recommendation as applied',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<BioControlRecommendation>> getAppliedRecommendations(
      String gardenId) async {
    try {
      final all = await _dataSource.getRecommendationsForGarden(gardenId);
      return all.where((rec) => rec.isApplied == true).toList();
    } catch (e) {
      developer.log(
          'Error getting applied recommendations for garden $gardenId: $e',
          name: _logName,
          level: 900);
      return [];
    }
  }

  @override
  Future<void> deleteRecommendation(String recommendationId) async {
    try {
      await _dataSource.deleteRecommendation(recommendationId);
      developer.log('✅ Recommendation deleted: $recommendationId',
          name: _logName);
    } catch (e, stackTrace) {
      developer.log(
        'Error deleting recommendation',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}


