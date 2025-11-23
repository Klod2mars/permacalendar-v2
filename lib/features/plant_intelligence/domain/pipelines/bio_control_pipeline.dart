import 'dart:developer' as developer;

import '../entities/pest_threat_analysis.dart';
import '../entities/bio_control_recommendation.dart';
import '../repositories/i_bio_control_recommendation_repository.dart';
import '../usecases/generate_bio_control_recommendations_usecase.dart';

/// Pipeline dédiée à la lutte biologique.
///
/// SRP :
///   👉 Exécuter le UseCase de génération de recos bio-control.
///   👉 Persister les recos via le repository dédié.
///   👉 Ne rien toucher d’autre.
///
/// Important :
///   - Cette pipeline ne doit PAS manipuler garden boxes.
///   - Elle est 100% isolée dans la surface bio-control.
///
class BioControlPipeline {
  final GenerateBioControlRecommendationsUsecase _generateUsecase;
  final IBioControlRecommendationRepository _bioRepo;

  BioControlPipeline({
    required GenerateBioControlRecommendationsUsecase generateUsecase,
    required IBioControlRecommendationRepository
        bioControlRecommendationRepository,
  })  : _generateUsecase = generateUsecase,
        _bioRepo = bioControlRecommendationRepository;

  /// Exécute tout le pipeline bio-control.
  ///
  /// - Si aucune menace → retourne liste vide.
  /// - Si aucune pipeline n’est configurée → retourne liste vide.
  ///
  /// ⚠️ Écriture autorisée uniquement dans les boxes BIO CONTROL.
  Future<List<BioControlRecommendation>> run(
    PestThreatAnalysis? threats,
  ) async {
    if (threats == null || threats.threats.isEmpty) {
      developer.log(
        '🟢 BioControlPipeline → Pas de menaces, aucune recommandation bio-control',
        name: 'BioControlPipeline',
      );
      return [];
    }

    developer.log(
      '🧬 BioControlPipeline → Génération recommandations bio-control (${threats.totalThreats} menaces)',
      name: 'BioControlPipeline',
    );

    final allRecs = <BioControlRecommendation>[];

    for (final threat in threats.threats) {
      try {
        final generated = await _generateUsecase.execute(threat.observation);

        // Persister chaque recommandation
        for (final rec in generated) {
          await _bioRepo.saveRecommendation(rec);
        }

        allRecs.addAll(generated);
      } catch (e) {
        developer.log(
          '⚠️ BioControlPipeline → Erreur génération recos pour observation ${threat.observation.id}: $e',
          name: 'BioControlPipeline',
          level: 900,
        );
      }
    }

    developer.log(
      '✅ BioControlPipeline → ${allRecs.length} recommandation(s) générée(s)',
      name: 'BioControlPipeline',
    );

    return allRecs;
  }
}
