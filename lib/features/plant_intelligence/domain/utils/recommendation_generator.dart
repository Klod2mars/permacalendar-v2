// Exemple : lib/features/plant_intelligence/domain/utils/recommendation_generator.dart

import 'package:uuid/uuid.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/core/models/unified_plant_data.dart';

final _uuid = Uuid();

/// Génère une liste minimale de recommandations à partir d'un UnifiedPlantData.
/// - gardenId : ID du jardin
/// - plantingDate : si connue, servira à calculer deadlines (optionnel)
List<Recommendation> generateRecommendationsFromUnifiedPlant({
  required UnifiedPlantData plant,
  required String gardenId,
  DateTime? plantingDate,
}) {
  final now = DateTime.now();
  final pDate = plantingDate ?? now;

  final List<Recommendation> recs = [];

  // 1) Semis / Germination (si le plant a germination info)
  if (plant.metadata != null && plant.metadata['germination'] != null) {
    final germ = plant.metadata['germination'] as Map<String, dynamic>?;
    final int maxDays = (germ?['maxDays'] as int?) ?? 14;
    final deadline = pDate.add(Duration(days: maxDays));
    final instructions = <String>[];
    if (germ != null) {
      if (germ['depth'] != null) instructions.add('Profondeur: ${germ['depth']} cm');
      if (germ['optimalTemp'] != null) instructions.add('Température optimale: ${germ['optimalTemp']}°C');
      if (germ['notes'] != null) instructions.add(germ['notes'].toString());
    }

    recs.add(Recommendation(
      id: _uuid.v4(),
      plantId: plant.plantId,
      gardenId: gardenId,
      type: RecommendationType.planting,
      priority: RecommendationPriority.medium,
      title: 'Semis / Germination — ${plant.commonName}',
      description: 'Semis et surveillance de la levée',
      instructions: instructions.isNotEmpty ? instructions : ['Semer selon les recommandations du catalogue'],
      expectedImpact: 60.0,
      effortRequired: 30.0,
      estimatedCost: 10.0,
      estimatedDuration: Duration(days: 1),
      deadline: deadline,
      optimalConditions: ['Matin/no pluie'],
      requiredTools: ['Graines', 'Râteau'],
      createdAt: now,
      updatedAt: now,
      metadata: {
        'generatedBy': 'recommendation_generator_v1',
        'rule': 'germination_based',
      },
    ));
  }

  // 2) Arrosage — task quotidienne récurrente
  if (plant.waterNeeds != null) {
    recs.add(Recommendation(
      id: _uuid.v4(),
      plantId: plant.plantId,
      gardenId: gardenId,
      type: RecommendationType.watering,
      priority: RecommendationPriority.medium,
      title: 'Arrosage régulier — ${plant.commonName}',
      description: 'Arroser selon fréquence recommandée',
      instructions: [
        'Arroser ${plant.waterNeeds ?? 'selon catalogue'}',
        'Heure recommandée: matin / soir selon météo'
      ],
      expectedImpact: 30.0,
      effortRequired: 10.0,
      estimatedCost: 0.0,
      estimatedDuration: Duration(minutes: 10),
      deadline: now.add(Duration(days: 1)), // marquer quotidien
      createdAt: now,
      updatedAt: now,
      metadata: {
        'isRecurring': true,
        'recurrence': 'P1D', // ISO 8601 simple
        'generatedBy': 'recommendation_generator_v1'
      },
    ));
  }

  // 3) Eclaircissage / Thinning (si present)
  if (plant.metadata != null && (plant.metadata['thinning'] != null || plant.metadata['spacingInCm'] != null)) {
    final dt = pDate.add(Duration(days: (plant.daysToMaturity * 0.1).round()));
    final spacing = plant.spacingInCm;
    recs.add(Recommendation(
      id: _uuid.v4(),
      plantId: plant.plantId,
      gardenId: gardenId,
      type: RecommendationType.general,
      priority: RecommendationPriority.medium,
      title: 'Éclaircissage — ${plant.commonName}',
      description: 'Eclaircir pour atteindre un espacement idéal (~${spacing ?? 'N/A'} cm)',
      instructions: ['Éclaircir selon espacement: ${spacing ?? 'voir catalogue'}'],
      expectedImpact: 40.0,
      effortRequired: 20.0,
      estimatedCost: 0.0,
      estimatedDuration: Duration(hours: 1),
      deadline: dt,
      createdAt: now,
      updatedAt: now,
      metadata: {'generatedBy': 'recommendation_generator_v1', 'rule': 'thinning_estimate'},
    ));
  }

  return recs;
}
