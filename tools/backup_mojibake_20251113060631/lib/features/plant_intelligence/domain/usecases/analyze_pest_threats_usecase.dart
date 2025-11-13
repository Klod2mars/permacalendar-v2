import '../entities/pest_observation.dart';
import '../entities/pest_threat_analysis.dart';
import '../entities/pest.dart';
import '../repositories/i_pest_observation_repository.dart';
import '../repositories/i_pest_repository.dart';
import '../repositories/i_plant_data_source.dart';

/// AnalyzePestThreatsUsecase - Analyzes pest threats in a garden
///
/// PHILOSOPHY:
/// This use case reads observations from the Sanctuary (user-created pest observations)
/// and enriches them with knowledge from the pest catalog to produce a comprehensive
/// threat analysis. It NEVER modifies the Sanctuary, only reads and interprets.
///
/// FLOW:
/// Sanctuary (Observations) → Analysis (UseCase) → Threat Report (Output)
class AnalyzePestThreatsUsecase {
  final IPestObservationRepository _observationRepository;
  final IPestRepository _pestRepository;
  final IPlantDataSource _plantDataSource;

  AnalyzePestThreatsUsecase({
    required IPestObservationRepository observationRepository,
    required IPestRepository pestRepository,
    required IPlantDataSource plantDataSource,
  })  : _observationRepository = observationRepository,
        _pestRepository = pestRepository,
        _plantDataSource = plantDataSource;

  /// Execute the threat analysis for a specific garden
  Future<PestThreatAnalysis> execute(String gardenId) async {
    // Step 1: Get active pest observations from the Sanctuary
    final observations =
        await _observationRepository.getActiveObservations(gardenId);

    // Step 2: Enrich each observation with pest and plant data
    final threats = <PestThreat>[];
    for (final observation in observations) {
      final pest = await _pestRepository.getPest(observation.pestId);
      final plant = await _plantDataSource.getPlant(observation.plantId);

      if (pest != null && plant != null) {
        final threatLevel = _calculateThreatLevel(observation, pest);
        final impactScore =
            _calculateImpactScore(observation.severity, threatLevel);

        threats.add(PestThreat(
          observation: observation,
          pest: pest,
          affectedPlant: plant,
          threatLevel: threatLevel,
          impactScore: impactScore,
          threatDescription:
              _generateThreatDescription(pest, plant, threatLevel),
          potentialConsequences: _generateConsequences(pest, threatLevel),
        ));
      }
    }

    // Step 3: Calculate overall statistics
    final criticalCount =
        threats.where((t) => t.threatLevel == ThreatLevel.critical).length;
    final highCount =
        threats.where((t) => t.threatLevel == ThreatLevel.high).length;
    final moderateCount =
        threats.where((t) => t.threatLevel == ThreatLevel.moderate).length;
    final lowCount =
        threats.where((t) => t.threatLevel == ThreatLevel.low).length;

    final overallScore = _calculateOverallThreatScore(threats);
    final summary = _generateSummary(threats, criticalCount, highCount);

    return PestThreatAnalysis(
      gardenId: gardenId,
      threats: threats,
      totalThreats: threats.length,
      criticalThreats: criticalCount,
      highThreats: highCount,
      moderateThreats: moderateCount,
      lowThreats: lowCount,
      overallThreatScore: overallScore,
      analyzedAt: DateTime.now(),
      summary: summary,
    );
  }

  /// Calculate threat level based on observation severity and pest characteristics
  ThreatLevel _calculateThreatLevel(PestObservation observation, Pest pest) {
    // Combine observation severity with pest default severity
    final severityScore = _getSeverityScore(observation.severity);
    final pestSeverityScore = _getSeverityScore(pest.defaultSeverity);

    final averageScore = (severityScore + pestSeverityScore) / 2;

    if (averageScore >= 3.5) return ThreatLevel.critical;
    if (averageScore >= 2.5) return ThreatLevel.high;
    if (averageScore >= 1.5) return ThreatLevel.moderate;
    return ThreatLevel.low;
  }

  /// Convert severity enum to numeric score
  double _getSeverityScore(PestSeverity severity) {
    switch (severity) {
      case PestSeverity.low:
        return 1.0;
      case PestSeverity.moderate:
        return 2.0;
      case PestSeverity.high:
        return 3.0;
      case PestSeverity.critical:
        return 4.0;
    }
  }

  /// Calculate impact score (0-100)
  double _calculateImpactScore(PestSeverity severity, ThreatLevel threatLevel) {
    final severityScore = _getSeverityScore(severity);
    final threatScore = _getThreatLevelScore(threatLevel);

    return ((severityScore + threatScore) / 8.0) * 100;
  }

  /// Convert threat level to numeric score
  double _getThreatLevelScore(ThreatLevel level) {
    switch (level) {
      case ThreatLevel.low:
        return 1.0;
      case ThreatLevel.moderate:
        return 2.0;
      case ThreatLevel.high:
        return 3.0;
      case ThreatLevel.critical:
        return 4.0;
    }
  }

  /// Generate human-readable threat description
  String _generateThreatDescription(
      Pest pest, dynamic plant, ThreatLevel level) {
    final levelText = {
      ThreatLevel.low: 'faible',
      ThreatLevel.moderate: 'modérée',
      ThreatLevel.high: 'élevée',
      ThreatLevel.critical: 'critique',
    }[level];

    return 'Menace $levelText : ${pest.name} sur ${plant.commonName}';
  }

  /// Generate potential consequences list
  List<String> _generateConsequences(Pest pest, ThreatLevel level) {
    final consequences = <String>[];

    if (level == ThreatLevel.critical || level == ThreatLevel.high) {
      consequences.add('Perte potentielle de récolte');
      consequences.add('Propagation rapide possible');
    }

    if (level == ThreatLevel.critical) {
      consequences.add('Destruction de la plante');
      consequences.add('Contamination des plantes voisines');
    }

    if (pest.symptoms.isNotEmpty) {
      consequences.add('Symptômes : ${pest.symptoms.first}');
    }

    return consequences;
  }

  /// Calculate overall threat score for the garden
  double _calculateOverallThreatScore(List<PestThreat> threats) {
    if (threats.isEmpty) return 0.0;

    final totalImpact = threats.fold<double>(
      0.0,
      (sum, threat) => sum + (threat.impactScore ?? 0.0),
    );

    return totalImpact / threats.length;
  }

  /// Generate summary text
  String _generateSummary(List<PestThreat> threats, int critical, int high) {
    if (threats.isEmpty) {
      return 'Aucune menace détectée. Votre jardin est en bonne santé ! 🌱';
    }

    if (critical > 0) {
      return 'Attention ! $critical menace(s) critique(s) détectée(s). Action immédiate recommandée. 🚨';
    }

    if (high > 0) {
      return '$high menace(s) élevée(s) détectée(s). Surveillance et action recommandées. ⚠️';
    }

    return '${threats.length} menace(s) détectée(s). Surveillance régulière conseillée. 👀';
  }
}


