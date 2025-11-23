import 'dart:developer' as developer;

import '../entities/intelligence_report.dart';
import '../entities/pest_threat_analysis.dart';
import '../entities/bio_control_recommendation.dart';

/// Service dédié à la génération d’un résumé textuel d’un jardin.
///
/// SRP strict :
///   👉 Recevoir les rapports complets des plantes
///   👉 Recevoir les menaces ravageurs
///   👉 Recevoir les recos bio-control
///   👉 Produire un texte clair
///
/// Aucun effet de bord, aucune persistance.
class SummaryService {
  /// Construit un résumé lisible de l’état du jardin.
  ///
  /// Combine :
  ///   - Nombre de plantes
  ///   - Score de santé moyen
  ///   - Menaces ravageurs
  ///   - Recos bio-control
  String buildGardenSummary({
    required List<PlantIntelligenceReport> plantReports,
    PestThreatAnalysis? pestThreats,
    required List<BioControlRecommendation> bioControlRecommendations,
  }) {
    developer.log(
      '📝 SummaryService → Construction du résumé jardin…',
      name: 'SummaryService',
    );

    final buffer = StringBuffer();

    // ════════════════════════════════════════════════════
    // 1) Résumé plantes
    // ════════════════════════════════════════════════════

    if (plantReports.isNotEmpty) {
      final count = plantReports.length;
      buffer.write('$count plante(s) analysée(s). ');

      final average = plantReports.fold<double>(
            0.0,
            (sum, r) => sum + r.intelligenceScore,
          ) /
          count;

      if (average >= 80) {
        buffer.write('🌿 Excellent état général ! ');
      } else if (average >= 60) {
        buffer.write('🍃 État satisfaisant. ');
      } else {
        buffer.write('⚠️ Certaines plantes nécessitent une attention. ');
      }
    }

    // ════════════════════════════════════════════════════
    // 2) Menaces ravageurs
    // ════════════════════════════════════════════════════

    if (pestThreats != null && pestThreats.totalThreats > 0) {
      buffer.write('\n\n🐛 Menaces détectées : ');

      if (pestThreats.criticalThreats > 0) {
        buffer.write('${pestThreats.criticalThreats} critique(s) 🚨 ');
      }
      if (pestThreats.highThreats > 0) {
        buffer.write('${pestThreats.highThreats} élevée(s) ⚠️ ');
      }
      if (pestThreats.moderateThreats > 0) {
        buffer.write('${pestThreats.moderateThreats} modérée(s) 👀 ');
      }
      if (pestThreats.lowThreats > 0) {
        buffer.write('${pestThreats.lowThreats} faible(s) ℹ️ ');
      }
    } else {
      buffer.write('\n\n✔️ Aucune menace ravageur détectée.');
    }

    // ════════════════════════════════════════════════════
    // 3) Recommandations bio-control
    // ════════════════════════════════════════════════════

    if (bioControlRecommendations.isNotEmpty) {
      final count = bioControlRecommendations.length;
      buffer.write(
        '\n\n🧬 $count recommandation(s) de lutte biologique disponible(s).',
      );

      final urgent =
          bioControlRecommendations.where((r) => r.priority <= 2).length;
      if (urgent > 0) {
        buffer.write(' $urgent action(s) urgente(s) recommandée(s).');
      }
    }

    final summary = buffer.toString();

    developer.log(
      '✅ SummaryService → Résumé généré (${summary.length} caractères)',
      name: 'SummaryService',
    );

    return summary;
  }
}
