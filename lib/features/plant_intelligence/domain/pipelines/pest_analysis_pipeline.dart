import 'dart:developer' as developer;

import '../entities/pest_threat_analysis.dart';
import '../usecases/analyze_pest_threats_usecase.dart';

/// Pipeline dédiée à l’analyse des menaces ravageurs dans un jardin.
///
/// SRP (Single Responsibility Principle) :
///   👉 Exécuter le UseCase d’analyse.
///   👉 Ne rien persister.
///   👉 Ne pas écrire dans Hive.
///   👉 Ne pas toucher au Sanctuaire.
///
/// L’Orchestrateur utilise cette pipeline si le module ravageurs est activé.
class PestAnalysisPipeline {
  final AnalyzePestThreatsUsecase _analyzePests;

  PestAnalysisPipeline({
    required AnalyzePestThreatsUsecase analyzePestThreatsUsecase,
  }) : _analyzePests = analyzePestThreatsUsecase;

  /// Analyse les menaces ravageurs pour un jardin.
  ///
  /// Peut retourner `null` si :
  ///  - le module n’est pas configuré
  ///  - l’analyse échoue (erreur non-bloquante)
  ///
  /// ⚠️ Zéro écriture Hive, zéro persistance : pure analyse.
  Future<PestThreatAnalysis?> run(String gardenId) async {
    developer.log(
      '🐛 PestAnalysisPipeline → Analyse des menaces pour jardin $gardenId',
      name: 'PestAnalysisPipeline',
    );

    try {
      final result = await _analyzePests.execute(gardenId);
      developer.log(
        '✅ PestAnalysisPipeline → ${result.totalThreats} menace(s) détectée(s)',
        name: 'PestAnalysisPipeline',
      );
      return result;
    } catch (e) {
      developer.log(
        '⚠️ PestAnalysisPipeline → Erreur analyse ravageurs (non bloquant): $e',
        name: 'PestAnalysisPipeline',
        level: 900,
      );
      return null; // bottleneck always safe
    }
  }
}
