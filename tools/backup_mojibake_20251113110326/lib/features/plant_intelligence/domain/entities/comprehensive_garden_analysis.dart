import 'package:freezed_annotation/freezed_annotation.dart';
import 'intelligence_report.dart';
import 'pest_threat_analysis.dart';
import 'bio_control_recommendation.dart';

part 'comprehensive_garden_analysis.freezed.dart';
part 'comprehensive_garden_analysis.g.dart';

/// Comprehensive Garden Analysis - Complete analysis including biological control
///
/// PHILOSOPHY:
/// This entity represents the complete intelligence analysis of a garden,
/// combining plant health analysis with pest threat analysis and biological
/// control recommendations. It embodies the holistic permaculture approach.
///
/// FLOW:
/// Sanctuary (Reality) → Modern System (Filter) → Intelligence (Analysis) → ComprehensiveGardenAnalysis (Output)
@freezed
class ComprehensiveGardenAnalysis with _$ComprehensiveGardenAnalysis {
  const factory ComprehensiveGardenAnalysis({
    required String gardenId,
    required List<PlantIntelligenceReport> plantReports,
    @JsonKey(includeFromJson: false, includeToJson: false)
    PestThreatAnalysis? pestThreats,
    required List<BioControlRecommendation> bioControlRecommendations,
    required double overallHealthScore, // 0-100
    required DateTime analyzedAt,
    required String summary,
    Map<String, dynamic>? metadata,
  }) = _ComprehensiveGardenAnalysis;

  factory ComprehensiveGardenAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ComprehensiveGardenAnalysisFromJson(json);
}


