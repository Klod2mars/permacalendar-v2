// lib/features/planting/domain/plant_steps_generator.dart
import 'package:flutter/foundation.dart';

import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../../core/models/planting.dart';
import 'plant_step.dart';

/// Générateur d'étapes à partir des données PlantFreezed et Planting.
///
/// Résumé des heuristiques :
/// - Germination -> mean(min,max) days after planting si disponible
/// - Watering -> étape récurrente (scheduledDate = null)
/// - Thinning -> daysAfterPlanting (notif or thinning.when) sinon 30
/// - Weeding -> étape récurrente si fréquence
/// - Biological control -> étapes pour chaque préparation
/// - Harvest -> si planting.expectedHarvestStartDate ou plant.daysToMaturity
List<PlantStep> generateSteps(PlantFreezed plant, Planting planting) {
  final List<PlantStep> steps = [];
  final DateTime planted = planting.plantedDate;
  final now = DateTime.now();

  // Helper to check completed
  bool isCompleted(String title) {
    return planting.careActions.any((a) => a.toLowerCase().contains(title.toLowerCase()));
  }

  // 1) Germination
  try {
    final g = plant.germination;
    if (g != null) {
      final gm = g['germinationTime'];
      if (gm != null) {
        int min = 7, max = 14;
        if (gm is Map<String, dynamic>) {
          min = (gm['min'] is num) ? (gm['min'] as num).toInt() : min;
          max = (gm['max'] is num) ? (gm['max'] as num).toInt() : max;
        } else if (gm is num) {
          min = gm.toInt();
          max = gm.toInt();
        }
        final mean = ((min + max) / 2).round();
        final scheduled = planted.add(Duration(days: mean));
        steps.add(PlantStep(
          id: 'germination',
          title: 'Germination attendue',
          description: 'Apparition des premières pousses (estimé à ~$mean jours)',
          scheduledDate: scheduled,
          category: 'germination',
          recommended: true,
          completed: now.difference(planted).inDays >= mean || isCompleted('germination'),
          meta: {'min': min, 'max': max},
        ));
      }
    }
  } catch (_) {}

  // 2) Watering
  try {
    final w = plant.watering ?? plant.notificationSettings?['watering'];
    if (w != null) {
      final amount = (w is Map && w['amount'] != null) ? w['amount'].toString() : null;
      final bestTime = (w is Map && w['bestTime'] != null) ? w['bestTime'].toString() : null;
      steps.add(PlantStep(
        id: 'watering',
        title: 'Arrosage recommandé',
        description: amount != null || bestTime != null
            ? '${amount != null ? 'Quantité: $amount' : ''}${amount != null && bestTime != null ? ' · ' : ''}${bestTime ?? ''}'
            : 'Arrosage régulier selon les besoins',
        scheduledDate: null, // tâche récurrente
        category: 'watering',
        recommended: true,
        completed: isCompleted('arrosage') || isCompleted('watering'),
        meta: w is Map<String, dynamic> ? Map<String, dynamic>.from(w) : {'raw': w},
      ));
    }
  } catch (_) {}

  // 3) Thinning (Éclaircissage)
  try {
    final t = plant.thinning ?? plant.notificationSettings?['thinning'];
    if (t != null) {
      int daysAfter = 30;
      if (t is Map<String, dynamic>) {
        if (t['daysAfterPlanting'] is num) daysAfter = (t['daysAfterPlanting'] as num).toInt();
        else if (t['when'] is String) {
          // ignore, we keep default daysAfter
        }
      }
      final scheduled = planted.add(Duration(days: daysAfter));
      steps.add(PlantStep(
        id: 'thinning',
        title: 'Éclaircissage recommandé',
        description: (t is Map && t['when'] != null) ? t['when'].toString() : 'Éclaircir pour obtenir un espacement optimal',
        scheduledDate: scheduled,
        category: 'thinning',
        recommended: true,
        completed: now.difference(planted).inDays >= daysAfter || isCompleted('éclaircissage') || isCompleted('thinning'),
        meta: t is Map<String, dynamic> ? Map<String, dynamic>.from(t) : {'raw': t},
      ));
    }
  } catch (_) {}

  // 4) Weeding (Désherbage)
  try {
    final we = plant.weeding ?? plant.notificationSettings?['weeding'];
    if (we != null) {
      final freq = (we is Map && we['frequency'] != null) ? we['frequency'].toString() : null;
      steps.add(PlantStep(
        id: 'weeding',
        title: 'Désherbage recommandé',
        description: freq != null ? 'Fréquence: $freq' : 'Désherbage régulier selon besoin',
        scheduledDate: null,
        category: 'weeding',
        recommended: true,
        completed: isCompleted('désherbage') || isCompleted('weeding'),
        meta: we is Map<String, dynamic> ? Map<String, dynamic>.from(we) : {'raw': we},
      ));
    }
  } catch (_) {}

  // 5) Biological control
  try {
    final bio = plant.biologicalControl;
    if (bio != null && bio.isNotEmpty) {
      // if there are preparations or recipes, create an item per preparation (best effort)
      if (bio['preparations'] is List) {
        final List preparations = bio['preparations'] as List;
        for (var i = 0; i < preparations.length; i++) {
          final prep = preparations[i];
          steps.add(PlantStep(
            id: 'bio_prep_$i',
            title: 'Préparation ${i + 1} contrôle biologique',
            description: prep is String ? prep : (prep is Map ? (prep['description']?.toString() ?? prep.toString()) : prep.toString()),
            scheduledDate: null,
            category: 'biological_control',
            recommended: true,
            completed: isCompleted('préparation') || isCompleted('biologique'),
            meta: prep is Map<String, dynamic> ? Map<String, dynamic>.from(prep) : {'raw': prep},
          ));
        }
      } else {
        steps.add(PlantStep(
          id: 'biological_control',
          title: 'Contrôle biologique',
          description: bio.toString(),
          scheduledDate: null,
          category: 'biological_control',
          recommended: true,
          completed: isCompleted('biologique') || isCompleted('traitement'),
          meta: bio is Map<String, dynamic> ? Map<String, dynamic>.from(bio) : {'raw': bio},
        ));
      }
    }
  } catch (_) {}

  // 6) Harvest (Récolte)
  try {
    if (planting.expectedHarvestStartDate != null) {
      steps.add(PlantStep(
        id: 'harvest_start',
        title: 'Début de récolte',
        description: 'Début prévu de la période de récolte',
        scheduledDate: planting.expectedHarvestStartDate,
        category: 'harvest',
        recommended: true,
        completed: planting.isHarvested || isCompleted('récolte') || isCompleted('harvest'),
        meta: {},
      ));

      if (planting.expectedHarvestEndDate != null) {
        steps.add(PlantStep(
          id: 'harvest_end',
          title: 'Fin de récolte',
          description: 'Fin prévue de la période de récolte',
          scheduledDate: planting.expectedHarvestEndDate,
          category: 'harvest',
          recommended: true,
          completed: planting.isHarvested || isCompleted('récolte') || isCompleted('harvest'),
          meta: {},
        ));
      }
    } else if (plant.daysToMaturity > 0) {
      final start = planted.add(Duration(days: plant.daysToMaturity));
      steps.add(PlantStep(
        id: 'harvest_estimated',
        title: 'Récolte estimée',
        description: 'Estimation basée sur ${
            plant.daysToMaturity} jours jusqu\'à maturité',
        scheduledDate: start,
        category: 'harvest',
        recommended: true,
        completed: now.isAfter(start) || isCompleted('récolte') || isCompleted('harvest'),
        meta: {'daysToMaturity': plant.daysToMaturity},
      ));
    }
  } catch (_) {}

  // dedupe by id
  final Map<String, PlantStep> unique = {};
  for (final s in steps) {
    unique[s.id] = s;
  }

  final result = unique.values.toList();

  // sort: scheduledDate nulls last, otherwise by date
  result.sort((a, b) {
    final aDate = a.scheduledDate ?? DateTime(9999);
    final bDate = b.scheduledDate ?? DateTime(9999);
    final c = aDate.compareTo(bDate);
    if (c != 0) return c;
    // fallback by category priority
    final priority = ['germination', 'watering', 'thinning', 'weeding', 'biological_control', 'harvest'];
    final aPr = priority.indexOf(a.category);
    final bPr = priority.indexOf(b.category);
    return aPr.compareTo(bPr);
  });

  return result;
}
