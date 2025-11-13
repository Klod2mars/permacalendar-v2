import 'package:uuid/uuid.dart';
import '../entities/pest_observation.dart';
import '../entities/pest.dart';
import '../entities/bio_control_recommendation.dart';
import '../repositories/i_pest_repository.dart';
import '../repositories/i_beneficial_insect_repository.dart';
import '../repositories/i_plant_data_source.dart';

/// GenerateBioControlRecommendationsUsecase - Generates biological control recommendations
///
/// PHILOSOPHY:
/// This use case is the "intelligence" that transforms observations (Sanctuary reality)
/// into actionable recommendations. It reads pest observations and pest/beneficial catalogs,
/// then generates contextual recommendations. It NEVER modifies the Sanctuary.
///
/// FLOW:
/// Observation (Sanctuary) + Catalogs (Knowledge) → Analysis (UseCase) → Recommendations (AI Output)
class GenerateBioControlRecommendationsUsecase {
  final IPestRepository _pestRepository;
  final IBeneficialInsectRepository _beneficialRepository;
  final IPlantDataSource _plantDataSource;
  final Uuid _uuid;

  GenerateBioControlRecommendationsUsecase({
    required IPestRepository pestRepository,
    required IBeneficialInsectRepository beneficialRepository,
    required IPlantDataSource plantDataSource,
    Uuid? uuid,
  })  : _pestRepository = pestRepository,
        _beneficialRepository = beneficialRepository,
        _plantDataSource = plantDataSource,
        _uuid = uuid ?? const Uuid();

  /// Generate recommendations for a specific pest observation
  Future<List<BioControlRecommendation>> execute(
    PestObservation observation,
  ) async {
    final recommendations = <BioControlRecommendation>[];

    // Step 1: Get pest information
    final pest = await _pestRepository.getPest(observation.pestId);
    if (pest == null) return recommendations;

    // Step 2: Generate Type 1 - Introduce Beneficial Insects
    final beneficialRecs = await _generateBeneficialRecommendations(
      observation,
      pest,
    );
    recommendations.addAll(beneficialRecs);

    // Step 3: Generate Type 2 - Plant Companion/Repellent Plants
    final companionRecs = await _generateCompanionPlantRecommendations(
      observation,
      pest,
    );
    recommendations.addAll(companionRecs);

    // Step 4: Generate Type 3 - Create Favorable Habitats
    final habitatRecs = await _generateHabitatRecommendations(
      observation,
      pest,
    );
    recommendations.addAll(habitatRecs);

    // Step 5: Generate Type 4 - Cultural Practices
    final culturalRecs = _generateCulturalPracticeRecommendations(
      observation,
      pest,
    );
    recommendations.addAll(culturalRecs);

    // Sort by priority (lower number = higher priority) and effectiveness
    recommendations.sort((a, b) {
      final priorityCompare = a.priority.compareTo(b.priority);
      if (priorityCompare != 0) return priorityCompare;
      return b.effectivenessScore.compareTo(a.effectivenessScore);
    });

    return recommendations;
  }

  /// Generate recommendations for introducing beneficial insects
  Future<List<BioControlRecommendation>> _generateBeneficialRecommendations(
    PestObservation observation,
    Pest pest,
  ) async {
    final recommendations = <BioControlRecommendation>[];

    // Get beneficial insects that prey on this pest
    final predators = await _beneficialRepository.getPredatorsOf(pest.id);

    for (final predator in predators) {
      final priority = _calculatePriority(observation.severity);
      final effectiveness = predator.effectiveness?.toDouble() ?? 80.0;

      recommendations.add(BioControlRecommendation(
        id: _uuid.v4(),
        pestObservationId: observation.id,
        type: BioControlType.introduceBeneficial,
        description: 'Introduire ${predator.name} pour contrôler ${pest.name}',
        actions: [
          BioControlAction(
            description:
                'Acheter ou attirer ${predator.name} dans votre jardin',
            timing: _getTimingFromSeverity(observation.severity),
            resources: [
              '${predator.name} (larves ou adultes)',
              'Fournisseur de lutte biologique',
            ],
            detailedInstructions: predator.lifeCycle,
          ),
        ],
        priority: priority,
        effectivenessScore: effectiveness,
        createdAt: DateTime.now(),
        targetBeneficialId: predator.id,
      ));
    }

    return recommendations;
  }

  /// Generate recommendations for planting companion/repellent plants
  Future<List<BioControlRecommendation>> _generateCompanionPlantRecommendations(
    PestObservation observation,
    Pest pest,
  ) async {
    final recommendations = <BioControlRecommendation>[];

    // Get repellent plants for this pest
    for (final plantId in pest.repellentPlants) {
      final plant = await _plantDataSource.getPlant(plantId);
      if (plant == null) continue;

      recommendations.add(BioControlRecommendation(
        id: _uuid.v4(),
        pestObservationId: observation.id,
        type: BioControlType.plantCompanion,
        description:
            'Planter ${plant.commonName} à proximité (effet répulsif contre ${pest.name})',
        actions: [
          BioControlAction(
            description:
                'Semer ou planter ${plant.commonName} autour des plantes attaquées',
            timing: 'Prochaine saison de plantation',
            resources: [
              'Graines de ${plant.commonName}',
              'Plants de ${plant.commonName}',
            ],
            detailedInstructions:
                'Les plantes compagnes répulsives doivent être plantées en bordure ou en intercalaire pour créer une barrière olfactive.',
          ),
        ],
        priority: 3, // Preventive measure
        effectivenessScore: 60.0,
        createdAt: DateTime.now(),
        targetPlantId: plantId,
      ));
    }

    return recommendations;
  }

  /// Generate recommendations for creating favorable habitats
  Future<List<BioControlRecommendation>> _generateHabitatRecommendations(
    PestObservation observation,
    Pest pest,
  ) async {
    final recommendations = <BioControlRecommendation>[];

    // Get beneficial insects that prey on this pest
    final predators = await _beneficialRepository.getPredatorsOf(pest.id);

    for (final predator in predators) {
      // Only create habitat recommendations for insects with attractive flowers
      if (predator.attractiveFlowers.isEmpty) continue;

      final actions = <BioControlAction>[];

      // Add action for planting attractive flowers
      actions.add(BioControlAction(
        description: 'Planter des fleurs attractives pour ${predator.name}',
        timing: 'Printemps prochain',
        resources: predator.attractiveFlowers,
        detailedInstructions:
            'Créer des bandes fleuries à proximité du potager pour attirer et maintenir les auxiliaires. ${predator.lifeCycle}',
      ));

      // Add habitat-specific actions
      if (predator.habitat.needsWater) {
        actions.add(const BioControlAction(
          description: 'Créer des points d\'eau peu profonds',
          timing: 'Immédiatement',
          resources: [
            'Soucoupes',
            'Pierres plates',
            'Billes pour empêcher noyade'
          ],
          detailedInstructions:
              'Les auxiliaires ont besoin d\'eau pour survivre. Placez des soucoupes avec de l\'eau et des pierres.',
        ));
      }

      if (predator.habitat.needsShelter) {
        actions.add(BioControlAction(
          description: 'Créer des abris pour ${predator.name}',
          timing: 'Immédiatement',
          resources: [
            'Tas de pierres',
            'Bûches',
            'Hôtel à insectes',
            'Feuilles mortes',
          ],
          detailedInstructions:
              'Les abris permettent aux auxiliaires de se reproduire et d\'hiverner.',
        ));
      }

      recommendations.add(BioControlRecommendation(
        id: _uuid.v4(),
        pestObservationId: observation.id,
        type: BioControlType.createHabitat,
        description: 'Créer un habitat favorable pour ${predator.name}',
        actions: actions,
        priority: 4, // Strategic long-term
        effectivenessScore: 70.0,
        createdAt: DateTime.now(),
        targetBeneficialId: predator.id,
      ));
    }

    return recommendations;
  }

  /// Generate recommendations for cultural practices
  List<BioControlRecommendation> _generateCulturalPracticeRecommendations(
    PestObservation observation,
    Pest pest,
  ) {
    final recommendations = <BioControlRecommendation>[];

    // General cultural practices based on pest type
    final actions = <BioControlAction>[];

    // Manual removal (always applicable)
    actions.add(BioControlAction(
      description: 'Inspection et retrait manuel des ravageurs',
      timing: 'Quotidiennement',
      resources: ['Gants', 'Seau d\'eau savonneuse'],
      detailedInstructions:
          'Inspectez les plantes tôt le matin. Retirez manuellement les ${pest.name} et plongez-les dans de l\'eau savonneuse.',
    ));

    // Neem oil spray (organic option)
    if (observation.severity == PestSeverity.high ||
        observation.severity == PestSeverity.critical) {
      actions.add(const BioControlAction(
        description: 'Pulvérisation d\'huile de neem (traitement bio)',
        timing: 'Immédiatement, puis tous les 7 jours',
        resources: ['Huile de neem', 'Pulvérisateur'],
        detailedInstructions:
            'Diluer l\'huile de neem selon les instructions. Pulvériser en fin de journée sur toutes les parties de la plante.',
        estimatedCostEuros: 15,
      ));
    }

    // Crop rotation reminder
    actions.add(const BioControlAction(
      description:
          'Planifier la rotation des cultures pour la prochaine saison',
      timing: 'Prochaine saison',
      resources: ['Plan de rotation'],
      detailedInstructions:
          'Évitez de replanter la même famille au même endroit. Cela réduit la pression des ravageurs spécialisés.',
    ));

    recommendations.add(BioControlRecommendation(
      id: _uuid.v4(),
      pestObservationId: observation.id,
      type: BioControlType.culturalPractice,
      description: 'Pratiques culturales pour gérer ${pest.name}',
      actions: actions,
      priority: _calculatePriority(observation.severity),
      effectivenessScore: 65.0,
      createdAt: DateTime.now(),
    ));

    return recommendations;
  }

  /// Calculate priority based on severity (1 = urgent, 5 = preventive)
  int _calculatePriority(PestSeverity severity) {
    switch (severity) {
      case PestSeverity.critical:
        return 1; // Urgent
      case PestSeverity.high:
        return 2; // High priority
      case PestSeverity.moderate:
        return 3; // Medium priority
      case PestSeverity.low:
        return 4; // Low priority
    }
  }

  /// Get timing text based on severity
  String _getTimingFromSeverity(PestSeverity severity) {
    switch (severity) {
      case PestSeverity.critical:
      case PestSeverity.high:
        return 'Immédiatement';
      case PestSeverity.moderate:
        return 'Dans les prochains jours';
      case PestSeverity.low:
        return 'Lorsque possible';
    }
  }
}


