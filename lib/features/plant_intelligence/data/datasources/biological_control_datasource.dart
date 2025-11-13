import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/pest.dart';
import '../../domain/entities/beneficial_insect.dart';
import '../../domain/entities/pest_observation.dart';
import '../../domain/entities/bio_control_recommendation.dart';

/// DataSource for biological control data
///
/// Manages:
/// - Loading pest catalog from JSON
/// - Loading beneficial insect catalog from JSON
/// - Persisting pest observations (Hive)
/// - Persisting bio control recommendations (Hive)
abstract class BiologicalControlDataSource {
  // Catalog access (read-only from JSON)
  Future<List<Pest>> loadPestCatalog();
  Future<List<BeneficialInsect>> loadBeneficialInsectCatalog();
  Future<Pest?> getPestById(String pestId);
  Future<BeneficialInsect?> getBeneficialInsectById(String insectId);

  // Observations (user-created, persisted in Hive)
  Future<void> savePestObservation(PestObservation observation);
  Future<List<PestObservation>> getObservationsForGarden(String gardenId);
  Future<List<PestObservation>> getActiveObservations(String gardenId);
  Future<List<PestObservation>> getObservationsForPlant(String plantId);
  Future<PestObservation?> getObservation(String observationId);
  Future<void> resolveObservation(
      String observationId, String resolutionMethod);
  Future<void> deleteObservation(String observationId);

  // Recommendations (AI-generated, persisted in Hive)
  Future<void> saveBioControlRecommendation(
      BioControlRecommendation recommendation);
  Future<List<BioControlRecommendation>> getRecommendationsForGarden(
      String gardenId);
  Future<List<BioControlRecommendation>> getRecommendationsForObservation(
      String observationId);
  Future<BioControlRecommendation?> getRecommendation(String recommendationId);
  Future<void> markRecommendationApplied(
      String recommendationId, DateTime? appliedAt, String? userFeedback);
  Future<void> deleteRecommendation(String recommendationId);
}

/// Implementation of BiologicalControlDataSource
class BiologicalControlDataSourceImpl implements BiologicalControlDataSource {
  static const String _logName = 'BiologicalControlDataSource';

  final HiveInterface _hive;

  // Cache for JSON catalogs (loaded once)
  List<Pest>? _pestCatalogCache;
  List<BeneficialInsect>? _beneficialCatalogCache;

  BiologicalControlDataSourceImpl(this._hive);

  // ==================== CATALOG LOADING ====================

  @override
  Future<List<Pest>> loadPestCatalog() async {
    // Return cached if available
    if (_pestCatalogCache != null) {
      return _pestCatalogCache!;
    }

    try {
      developer.log('Loading pest catalog from JSON...', name: _logName);

      final jsonString = await rootBundle
          .loadString('assets/data/biological_control/pests.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      _pestCatalogCache = jsonData.map((json) => Pest.fromJson(json)).toList();

      developer.log('âœ… ${_pestCatalogCache!.length} pests loaded',
          name: _logName);

      return _pestCatalogCache!;
    } catch (e, stackTrace) {
      developer.log(
        'Error loading pest catalog',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  @override
  Future<List<BeneficialInsect>> loadBeneficialInsectCatalog() async {
    // Return cached if available
    if (_beneficialCatalogCache != null) {
      return _beneficialCatalogCache!;
    }

    try {
      developer.log('Loading beneficial insect catalog from JSON...',
          name: _logName);

      final jsonString = await rootBundle
          .loadString('assets/data/biological_control/beneficial_insects.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      _beneficialCatalogCache =
          jsonData.map((json) => BeneficialInsect.fromJson(json)).toList();

      developer.log(
          'âœ… ${_beneficialCatalogCache!.length} beneficial insects loaded',
          name: _logName);

      return _beneficialCatalogCache!;
    } catch (e, stackTrace) {
      developer.log(
        'Error loading beneficial insect catalog',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  @override
  Future<Pest?> getPestById(String pestId) async {
    final catalog = await loadPestCatalog();
    try {
      return catalog.firstWhere((pest) => pest.id == pestId);
    } catch (e) {
      developer.log('Pest not found: $pestId', name: _logName, level: 900);
      return null;
    }
  }

  @override
  Future<BeneficialInsect?> getBeneficialInsectById(String insectId) async {
    final catalog = await loadBeneficialInsectCatalog();
    try {
      return catalog.firstWhere((insect) => insect.id == insectId);
    } catch (e) {
      developer.log('Beneficial insect not found: $insectId',
          name: _logName, level: 900);
      return null;
    }
  }

  // ==================== OBSERVATIONS (HIVE) ====================

  Future<Box<Map>> get _observationsBox async {
    if (_hive.isBoxOpen('pest_observations')) {
      try {
        return _hive.box<Map>('pest_observations');
      } catch (e) {
        developer.log('Error getting pest_observations box, reopening...',
            name: _logName);
        await _hive.box('pest_observations').close();
        return await _hive.openBox<Map>('pest_observations');
      }
    }
    return await _hive.openBox<Map>('pest_observations');
  }

  @override
  Future<void> savePestObservation(PestObservation observation) async {
    try {
      final box = await _observationsBox;
      await box.put(observation.id, observation.toJson());
      developer.log('âœ… Pest observation saved: ${observation.id}',
          name: _logName);
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
  Future<List<PestObservation>> getObservationsForGarden(
      String gardenId) async {
    try {
      final box = await _observationsBox;
      final observations = <PestObservation>[];

      for (final key in box.keys) {
        try {
          final json = box.get(key);
          final observation =
              PestObservation.fromJson(Map<String, dynamic>.from(json as Map));

          if (observation.gardenId == gardenId) {
            observations.add(observation);
          }
        } catch (e) {
          developer.log('Error parsing observation $key: $e',
              name: _logName, level: 900);
        }
      }

      return observations;
    } catch (e, stackTrace) {
      developer.log(
        'Error getting observations',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  @override
  Future<List<PestObservation>> getActiveObservations(String gardenId) async {
    final all = await getObservationsForGarden(gardenId);
    return all
        .where((obs) => obs.isActive == true && obs.resolvedAt == null)
        .toList();
  }

  @override
  Future<List<PestObservation>> getObservationsForPlant(String plantId) async {
    try {
      final box = await _observationsBox;
      final observations = <PestObservation>[];

      for (final key in box.keys) {
        try {
          final json = box.get(key);
          final observation =
              PestObservation.fromJson(Map<String, dynamic>.from(json as Map));

          if (observation.plantId == plantId) {
            observations.add(observation);
          }
        } catch (e) {
          developer.log('Error parsing observation $key: $e',
              name: _logName, level: 900);
        }
      }

      return observations;
    } catch (e, stackTrace) {
      developer.log(
        'Error getting observations for plant',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  @override
  Future<PestObservation?> getObservation(String observationId) async {
    try {
      final box = await _observationsBox;
      final json = box.get(observationId);

      if (json != null) {
        return PestObservation.fromJson(Map<String, dynamic>.from(json));
      }
      return null;
    } catch (e, stackTrace) {
      developer.log(
        'Error getting observation',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> resolveObservation(
      String observationId, String resolutionMethod) async {
    try {
      final box = await _observationsBox;
      final json = box.get(observationId);

      if (json != null) {
        final observation =
            PestObservation.fromJson(Map<String, dynamic>.from(json));
        final updated = observation.copyWith(
          isActive: false,
          resolvedAt: DateTime.now(),
          resolutionMethod: resolutionMethod,
        );
        await box.put(observationId, updated.toJson());
        developer.log('âœ… Observation resolved: $observationId', name: _logName);
      }
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
      final box = await _observationsBox;
      await box.delete(observationId);
      developer.log('âœ… Observation deleted: $observationId', name: _logName);
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

  // ==================== RECOMMENDATIONS (HIVE) ====================

  Future<Box<Map>> get _recommendationsBox async {
    if (_hive.isBoxOpen('bio_control_recommendations')) {
      try {
        return _hive.box<Map>('bio_control_recommendations');
      } catch (e) {
        developer.log(
            'Error getting bio_control_recommendations box, reopening...',
            name: _logName);
        await _hive.box('bio_control_recommendations').close();
        return await _hive.openBox<Map>('bio_control_recommendations');
      }
    }
    return await _hive.openBox<Map>('bio_control_recommendations');
  }

  @override
  Future<void> saveBioControlRecommendation(
      BioControlRecommendation recommendation) async {
    try {
      final box = await _recommendationsBox;
      await box.put(recommendation.id, recommendation.toJson());
      developer.log('âœ… Bio control recommendation saved: ${recommendation.id}',
          name: _logName);
    } catch (e, stackTrace) {
      developer.log(
        'Error saving bio control recommendation',
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
      final box = await _recommendationsBox;
      final observationsBox = await _observationsBox;
      final recommendations = <BioControlRecommendation>[];

      for (final key in box.keys) {
        try {
          final json = box.get(key);
          final recommendation = BioControlRecommendation.fromJson(
              Map<String, dynamic>.from(json as Map));

          // Find the observation linked to this recommendation
          final observationJson =
              observationsBox.get(recommendation.pestObservationId);
          if (observationJson != null) {
            final observation = PestObservation.fromJson(
                Map<String, dynamic>.from(observationJson));

            if (observation.gardenId == gardenId) {
              recommendations.add(recommendation);
            }
          }
        } catch (e) {
          developer.log('Error parsing recommendation $key: $e',
              name: _logName, level: 900);
        }
      }

      return recommendations;
    } catch (e, stackTrace) {
      developer.log(
        'Error getting recommendations',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  @override
  Future<List<BioControlRecommendation>> getRecommendationsForObservation(
      String observationId) async {
    try {
      final box = await _recommendationsBox;
      final recommendations = <BioControlRecommendation>[];

      for (final key in box.keys) {
        try {
          final json = box.get(key);
          final recommendation = BioControlRecommendation.fromJson(
              Map<String, dynamic>.from(json as Map));

          if (recommendation.pestObservationId == observationId) {
            recommendations.add(recommendation);
          }
        } catch (e) {
          developer.log('Error parsing recommendation $key: $e',
              name: _logName, level: 900);
        }
      }

      return recommendations;
    } catch (e, stackTrace) {
      developer.log(
        'Error getting recommendations for observation',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  @override
  Future<BioControlRecommendation?> getRecommendation(
      String recommendationId) async {
    try {
      final box = await _recommendationsBox;
      final json = box.get(recommendationId);

      if (json != null) {
        return BioControlRecommendation.fromJson(
            Map<String, dynamic>.from(json));
      }
      return null;
    } catch (e, stackTrace) {
      developer.log(
        'Error getting recommendation',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> markRecommendationApplied(String recommendationId,
      DateTime? appliedAt, String? userFeedback) async {
    try {
      final box = await _recommendationsBox;
      final json = box.get(recommendationId);

      if (json != null) {
        final recommendation =
            BioControlRecommendation.fromJson(Map<String, dynamic>.from(json));
        final updated = recommendation.copyWith(
          isApplied: true,
          appliedAt: appliedAt ?? DateTime.now(),
          userFeedback: userFeedback,
        );
        await box.put(recommendationId, updated.toJson());
        developer.log('âœ… Recommendation marked as applied: $recommendationId',
            name: _logName);
      }
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
  Future<void> deleteRecommendation(String recommendationId) async {
    try {
      final box = await _recommendationsBox;
      await box.delete(recommendationId);
      developer.log('âœ… Recommendation deleted: $recommendationId',
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


