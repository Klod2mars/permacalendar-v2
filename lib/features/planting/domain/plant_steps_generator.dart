// lib/features/planting/domain/plant_steps_generator.dart
import 'package:flutter/foundation.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

import '../../../core/models/plant.dart';
import '../../../core/models/planting.dart';
import 'plant_step.dart';

/// Générateur d'étapes à partir des données PlantFreezed et Planting.
///
/// Heuristiques :
/// - Germination -> mean(min,max) days after planting si disponible
/// - Watering -> étape récurrente (scheduledDate = null)
/// - Thinning -> daysAfterPlanting (notif or thinning.when) sinon 30
/// - Weeding -> étape récurrente si fréquence
/// - Biological control -> étapes pour chaque préparation
/// - Harvest -> si planting.expectedHarvestStartDate ou plant.daysToMaturity
List<PlantStep> generateSteps(Plant plant, Planting planting, [AppLocalizations? l10n]) {
  final List<PlantStep> steps = [];
  
  // Helper for optional localization
  String t(String Function(AppLocalizations) f, String fallback) =>
      l10n != null ? f(l10n) : fallback;

  final DateTime planted = planting.plantedDate;
  final now = DateTime.now();

  // Helper to check completed
  bool isCompleted(String title) {
    return planting.careActions
        .any((a) => a.toLowerCase().contains(title.toLowerCase()));
  }

  // Détection si c'est un plant repiqué (Planté) ou si la croissance initiale est avancée
  final bool isTransplanted = planting.status.toLowerCase() == 'planté' ||
      (planting.metadata != null &&
          planting.metadata['initialGrowthPercent'] != null &&
          (planting.metadata['initialGrowthPercent'] is num) &&
          (planting.metadata['initialGrowthPercent'] as num) > 0.0);

  // 1) Germination - Uniquement si ce n'est pas un plant repiqué
  if (!isTransplanted) {
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
            title: t((l) => l.step_germination_title, 'Germination attendue'),
            description: t((l) => l.step_germination_desc(mean), 'Apparition des premières pousses (estimé à ~$mean jours)'),
            scheduledDate: scheduled,
            category: 'germination',
            recommended: true,
            completed: now.difference(planted).inDays >= mean ||
                isCompleted('germination'),
            meta: {'min': min, 'max': max},
          ));
        }
      }
    } catch (_) {}
  }

  // 2) Watering
  try {
    final w = plant.watering ?? (plant.notificationSettings ?? {})['watering'];
    if (w != null) {
      final amount =
          (w is Map && w['amount'] != null) ? w['amount'].toString() : null;
      final bestTime =
          (w is Map && w['bestTime'] != null) ? w['bestTime'].toString() : null;
      steps.add(PlantStep(
        id: 'watering',
        title: t((l) => l.step_watering_title, 'Arrosage recommandé'),
        description: amount != null || bestTime != null
            ? '${amount != null ? t((l) => l.step_watering_desc_amount(amount), 'Quantité: $amount') : ''}${amount != null && bestTime != null ? ' · ' : ''}${bestTime ?? ''}'
            : t((l) => l.step_watering_desc_regular, 'Arrosage régulier selon les besoins'),
        scheduledDate: null, // tâche récurrente
        category: 'watering',
        recommended: true,
        completed: isCompleted('arrosage') || isCompleted('watering'),
        meta: w is Map<String, dynamic>
            ? Map<String, dynamic>.from(w)
            : {'raw': w},
      ));
    }
  } catch (_) {}

  // 3) Thinning (Éclaircissage) - Uniquement si ce n'est pas un plant repiqué
  if (!isTransplanted) {
    try {
      final t =
          plant.thinning ?? (plant.notificationSettings ?? {})['thinning'];
      if (t != null) {
        int daysAfter = 30;
        if (t is Map<String, dynamic>) {
          if (t['daysAfterPlanting'] is num)
            daysAfter = (t['daysAfterPlanting'] as num).toInt();
        }
        final scheduled = planted.add(Duration(days: daysAfter));
        steps.add(PlantStep(
          id: 'thinning',
          title: t((l) => l.step_thinning_title, 'Éclaircissage recommandé'),
          description: (t is Map && t['when'] != null)
              ? t['when'].toString()
              : t((l) => l.step_thinning_desc_default, 'Éclaircir pour obtenir un espacement optimal'),
          scheduledDate: scheduled,
          category: 'thinning',
          recommended: true,
          completed: now.difference(planted).inDays >= daysAfter ||
              isCompleted('éclaircissage') ||
              isCompleted('thinning'),
          meta: t is Map<String, dynamic>
              ? Map<String, dynamic>.from(t)
              : {'raw': t},
        ));
      }
    } catch (_) {}
  }

  // 4) Weeding (Désherbage)
  try {
    final we = plant.weeding ?? (plant.notificationSettings ?? {})['weeding'];
    if (we != null) {
      final freq = (we is Map && we['frequency'] != null)
          ? we['frequency'].toString()
          : null;
      steps.add(PlantStep(
        id: 'weeding',
        title: t((l) => l.step_weeding_title, 'Désherbage recommandé'),
        description: freq != null
            ? t((l) => l.step_weeding_desc_freq(freq), 'Fréquence: $freq')
            : t((l) => l.step_weeding_desc_regular, 'Désherbage régulier selon besoin'),
        scheduledDate: null,
        category: 'weeding',
        recommended: true,
        completed: isCompleted('désherbage') || isCompleted('weeding'),
        meta: we is Map<String, dynamic>
            ? Map<String, dynamic>.from(we)
            : {'raw': we},
      ));
    }
  } catch (_) {}

  // 5) Biological control
  try {
    final bio = plant.biologicalControl;
    if (bio != null && bio.isNotEmpty) {
      if (bio['preparations'] is List) {
        final List preparations = bio['preparations'] as List;
        for (var i = 0; i < preparations.length; i++) {
          final prep = preparations[i];
          steps.add(PlantStep(
            id: 'bio_prep_$i',
            title: t((l) => l.step_bio_control_prep_title(i + 1), 'Préparation ${i + 1} contrôle biologique'),
            description: prep is String
                ? prep
                : (prep is Map
                    ? (prep['description']?.toString() ?? prep.toString())
                    : prep.toString()),
            scheduledDate: null,
            category: 'biological_control',
            recommended: true,
            completed: isCompleted('préparation') || isCompleted('biologique'),
            meta: prep is Map<String, dynamic>
                ? Map<String, dynamic>.from(prep)
                : {'raw': prep},
          ));
        }
      } else {
        steps.add(PlantStep(
          id: 'biological_control',
          title: t((l) => l.step_bio_control_title, 'Contrôle biologique'),
          description: bio.toString(),
          scheduledDate: null,
          category: 'biological_control',
          recommended: true,
          completed: isCompleted('biologique') || isCompleted('traitement'),
          meta: bio is Map<String, dynamic>
              ? Map<String, dynamic>.from(bio)
              : {'raw': bio},
        ));
      }
    }
  } catch (_) {}

  // 6) Harvest (Récolte)
  try {
    if (planting.expectedHarvestStartDate != null) {
      steps.add(PlantStep(
        id: 'harvest_start',
        title: t((l) => l.step_harvest_start_title, 'Début de récolte'),
        description: t((l) => l.step_harvest_start_desc, 'Début prévu de la période de récolte'),
        scheduledDate: planting.expectedHarvestStartDate,
        category: 'harvest',
        recommended: true,
        completed: planting.isHarvested ||
            isCompleted('récolte') ||
            isCompleted('harvest'),
        meta: {},
      ));

      if (planting.expectedHarvestEndDate != null) {
        steps.add(PlantStep(
          id: 'harvest_end',
          title: t((l) => l.step_harvest_end_title, 'Fin de récolte'),
          description: t((l) => l.step_harvest_end_desc, 'Fin prévue de la période de récolte'),
          scheduledDate: planting.expectedHarvestEndDate,
          category: 'harvest',
          recommended: true,
          completed: planting.isHarvested ||
            isCompleted('récolte') ||
            isCompleted('harvest'),
          meta: {},
        ));
      }
    }
      
      // Calcul de la date estimée en prenant en compte l'avancement initial (repiquage)
      // Logique alignée avec PlantLifecycleService
      int maturityDays = plant.daysToMaturity > 0 ? plant.daysToMaturity : 60;
      
      double initialProgress = 0.0;
      if (planting.metadata != null && planting.metadata!['initialGrowthPercent'] != null) {
         final dynamic raw = planting.metadata!['initialGrowthPercent'];
         if (raw is num) initialProgress = raw.toDouble().clamp(0.0, 1.0);
         else if (raw is String) initialProgress = (double.tryParse(raw) ?? 0.0).clamp(0.0, 1.0);
      } else if (planting.status == 'Planté') {
         // Fallback pour ancien planting sans metadata explicite
         initialProgress = 0.3; 
      }

      final int effectiveMaturityDays = (maturityDays * (1.0 - initialProgress)).ceil().clamp(1, maturityDays);
      final start = planted.add(Duration(days: effectiveMaturityDays));

      steps.add(PlantStep(
        id: 'harvest_estimated',
        title: t((l) => l.step_harvest_estimated_title, 'Récolte estimée'),
        description: t((l) => l.step_harvest_estimated_desc(plant.daysToMaturity), 'Estimation basée sur ${plant.daysToMaturity} jours (ajusté: ${initialProgress > 0 ? "repiquage" : "semis"})'),
        scheduledDate: start,
        category: 'harvest',
        recommended: true,
        completed: now.isAfter(start) ||
            isCompleted('récolte') ||
            isCompleted('harvest'),
        meta: {
          'daysToMaturity': plant.daysToMaturity,
          'effectiveMaturityDays': effectiveMaturityDays,
          'initialProgress': initialProgress
        },
      ));
    
  } catch (_) {}

  // dé-duplication par id (garde la dernière)
  final Map<String, PlantStep> unique = {};
  for (final s in steps) {
    unique[s.id] = s;
  }

  final result = unique.values.toList();

  // tri : scheduledDate nulls en fin, sinon par date ; fallback par priorité de catégorie
  result.sort((a, b) {
    final aDate = a.scheduledDate ?? DateTime(9999);
    final bDate = b.scheduledDate ?? DateTime(9999);
    final c = aDate.compareTo(bDate);
    if (c != 0) return c;
    final priority = [
      'germination',
      'watering',
      'thinning',
      'weeding',
      'biological_control',
      'harvest'
    ];
    final aPr = priority.indexOf(a.category);
    final bPr = priority.indexOf(b.category);
    return aPr.compareTo(bPr);
  });

  return result;
}
