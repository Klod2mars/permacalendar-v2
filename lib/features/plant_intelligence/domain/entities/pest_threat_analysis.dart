import 'package:freezed_annotation/freezed_annotation.dart';
import 'pest_observation.dart';
import 'pest.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';

part 'pest_threat_analysis.freezed.dart';

/// Threat Level for a pest observation
enum ThreatLevel {
  low,
  moderate,
  high,
  critical,
}

/// PestThreat - Represents a single pest threat with analysis
/// Note: This is a runtime analysis result, not persisted to JSON
@freezed
class PestThreat with _$PestThreat {
  const factory PestThreat({
    required PestObservation observation,
    required Pest pest,
    required PlantFreezed affectedPlant,
    required ThreatLevel threatLevel,
    double? impactScore, // 0-100 estimated impact
    String? threatDescription,
    List<String>? potentialConsequences,
  }) = _PestThreat;
}

/// PestThreatAnalysis - Comprehensive analysis of all pest threats in a garden
/// Note: This is a runtime analysis result, not persisted to JSON
@freezed
class PestThreatAnalysis with _$PestThreatAnalysis {
  const factory PestThreatAnalysis({
    required String gardenId,
    required List<PestThreat> threats,
    required int totalThreats,
    required int criticalThreats,
    required int highThreats,
    required int moderateThreats,
    required int lowThreats,
    required double overallThreatScore, // 0-100
    DateTime? analyzedAt,
    String? summary,
  }) = _PestThreatAnalysis;
}


