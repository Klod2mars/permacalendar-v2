import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/data/hive/garden_boxes.dart';
import '../../../core/services/plant_catalog_service.dart';
import '../../../features/planting/domain/plant_steps_generator.dart';
import '../../../core/providers/activity_tracker_v3_provider.dart';
import '../../../core/services/activity_observer_service.dart';

final calendarAggregationProvider = FutureProvider.family<Map<String, Map<String, dynamic>>, DateTime>((ref, month) async {
  // Audit préalable (lecture seule)
  try {
    GardenBoxes.plantings; // throw si non initialisée
  } catch (e) {
    throw Exception('GardenBoxes.plantings non initialisée : $e');
  }

  final Map<String, Map<String, dynamic>> agg = {};
  final dateFormat = DateFormat('yyyy-MM-dd');
  final firstDay = DateTime(month.year, month.month, 1);
  final lastDay = DateTime(month.year, month.month + 1, 0);

  for (DateTime d = firstDay; !d.isAfter(lastDay); d = d.add(const Duration(days: 1))) {
    final key = dateFormat.format(d);
    agg[key] = {
      'plantingCount': 0,
      'wateringCount': 0,
      'harvestCount': 0,
      'overdueCount': 0,
      'frost': false,
    };
  }

  final now = DateTime.now();
  final plantings = GardenBoxes.plantings.values.toList();
  int resolvedPlants = 0;
  int failedPlantResolves = 0;

  for (final p in plantings) {
    if (!(p?.isActive ?? false)) continue;

    // plantingCount
    try {
      final pd = p.plantedDate;
      if (pd.year == month.year && pd.month == month.month) {
        final k = dateFormat.format(pd);
        if (agg.containsKey(k)) {
          agg[k]!['plantingCount'] = (agg[k]!['plantingCount'] as int) + 1;
        }
      }
    } catch (_) {}

    // harvestCount via expectedHarvestStartDate
    try {
      final hd = p.expectedHarvestStartDate;
      if (hd != null && hd.year == month.year && hd.month == month.month) {
        final k = dateFormat.format(hd);
        if (agg.containsKey(k)) {
          agg[k]!['harvestCount'] = (agg[k]!['harvestCount'] as int) + 1;
        }
      }
    } catch (_) {}

    // overdueCount
    try {
      final hd = p.expectedHarvestStartDate;
      if (hd != null && hd.isBefore(now) && p.status != 'Récolté') {
        final k = dateFormat.format(hd);
        if (agg.containsKey(k)) {
           agg[k]!['overdueCount'] = (agg[k]!['overdueCount'] as int) + 1;
        }
      }
    } catch (_) {}

    // watering via generateSteps
    try {
      final plant = await PlantCatalogService.getPlantById(p.plantId);
      if (plant != null) {
        resolvedPlants++;
        final steps = generateSteps(plant as dynamic, p); // assume dynamic cast or implicit works
        for (final s in steps) {
          if (s.scheduledDate != null) {
            final sd = s.scheduledDate!;
            if (sd.year == month.year && sd.month == month.month) {
              final k = dateFormat.format(sd);
              if (agg.containsKey(k)) {
                if (s.category == 'watering' && !(s.completed)) {
                  agg[k]!['wateringCount'] = (agg[k]!['wateringCount'] as int) + 1;
                } else if (s.category == 'harvest' && !(s.completed)) {
                  agg[k]!['harvestCount'] = (agg[k]!['harvestCount'] as int) + 1;
                }
              }
            }
          }
        }
      } else {
        failedPlantResolves++;
      }
    } catch (e) {
      failedPlantResolves++;
    }
  }

  // frost detection via ActivityTrackerV3
  try {
    final trackerInitialized = ref.read(activityTrackerInitializedProvider);
    if (!trackerInitialized) {
      try {
        await ActivityObserverService().initialize();
      } catch (e) {
        // log
      }
    }
    final tracker = ref.read(activityTrackerV3Provider);
    if (tracker.isInitialized) {
      final weatherActivities = await tracker.getActivitiesByType('weatherAlert');
      for (final a in weatherActivities) {
        final ts = a.timestamp;
        if (ts.year == month.year && ts.month == month.month) {
          final meta = a.metadata ?? {};
          final desc = (meta['description']?.toString() ?? '').toLowerCase();
          final isFrost = (meta['type'] == 'frost') || (meta['alert'] == 'frost') || desc.contains('gel') || desc.contains('frost');
          if (isFrost) {
            final k = dateFormat.format(ts);
            if (agg.containsKey(k)) agg[k]!['frost'] = true;
          }
        }
      }
    }
  } catch (e) {
    // log frost error
  }

  // Log d'audit minimal
  final auditLog = 'calendarAggregation: plantings=${plantings.length}, '
      'resolvedPlants=$resolvedPlants, failedResolve=$failedPlantResolves, '
      'month=${dateFormat.format(firstDay)}';
  print(auditLog);

  return agg;
});
