import 'dart:developer' as developer;

import '../entities/intelligence_report.dart';
import '../repositories/i_garden_context_repository.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_freezed.dart';

/// Pipeline pour analyser un jardin entier.
///
/// SRP :
///   👉 Récupérer la liste des plantes du jardin
///   👉 Laisser l'Orchestrateur générer chaque rapport
///   👉 Retourner la liste des rapports
///
/// Important :
///   - Aucun calcul d’évolution ici
///   - Pas de persistance globale
///   - Aucun accès box Garden*
class GardenReportPipeline {
  final IGardenContextRepository _gardenRepository;

  /// Callback permettant d'exécuter l'analyse d'une plante.
  ///
  /// L'Orchestrateur fournit :
  /// ```dart
  /// (plantId, plant) => generateIntelligenceReport(...)
  /// ```
  final Future<PlantIntelligenceReport> Function({
    required String plantId,
    required String gardenId,
    PlantFreezed? plant,
  }) _reportGenerator;

  GardenReportPipeline({
    required IGardenContextRepository gardenRepository,
    required Future<PlantIntelligenceReport> Function({
      required String plantId,
      required String gardenId,
      PlantFreezed? plant,
    }) reportGenerator,
  })  : _gardenRepository = gardenRepository,
        _reportGenerator = reportGenerator;

  /// Analyse toutes les plantes actives d’un jardin.
  Future<List<PlantIntelligenceReport>> run({
    required String gardenId,
  }) async {
    developer.log(
      '🪴 GardenReportPipeline → Récupération des plantes pour jardin $gardenId',
      name: 'GardenReportPipeline',
    );

    // 1. Récupérer toutes les plantes
    final plants = await _gardenRepository.getGardenPlants(gardenId);

    developer.log(
      '🌱 GardenReportPipeline → ${plants.length} plante(s) à analyser',
      name: 'GardenReportPipeline',
    );

    final reports = <PlantIntelligenceReport>[];

    // 2. Analyse séquentielle ou parallèle (séquentiel pour cohérence logs)
    for (final plant in plants) {
      try {
        final report = await _reportGenerator(
          plantId: plant.id,
          gardenId: gardenId,
          plant: plant,
        );

        reports.add(report);
      } catch (e) {
        developer.log(
          '⚠️ GardenReportPipeline → Erreur analyse pour plante ${plant.id}: $e',
          name: 'GardenReportPipeline',
          level: 900,
        );
        // Continue avec les autres
      }
    }

    developer.log(
      '🏁 GardenReportPipeline → ${reports.length}/${plants.length} rapports générés',
      name: 'GardenReportPipeline',
    );

    return reports;
  }
}
