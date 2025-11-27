// lib/core/services/plant_progress_service.dart
import '../../features/plant_catalog/domain/entities/plant_entity.dart';
import '../models/planting.dart';

/// Service utilitaire pour calculer le pourcentage de vie d'une planting
/// et construire les références d'observation.
/// - computeProgress(...) : retourne un double 0.0..1.0
/// - computeExpectedHarvestDate(...) : date estimée de récolte à partir de la référence
/// - getProgressReference(...) : retourne { 'date': DateTime, 'progress': double }
class PlantProgressService {
  /// Retourne une référence { 'date': DateTime, 'progress': double }
  /// Priorités :
  /// 1) metadata['progressReference'] (date ISO / progress)
  /// 2) metadata['initialGrowthPercent'] (avec plantedDate comme date)
  /// 3) si status == 'Planté' -> plant.growth['transplantInitialPercent'] ou défaut 0.3
  /// 4) sinon Semé -> 0.0
  static Map<String, dynamic> getProgressReference(
      Planting planting, PlantFreezed? plant) {
    final meta = planting.metadata ?? {};
    DateTime refDate = planting.plantedDate;
    double refProgress = 0.0;

    // 1) progressReference explicite
    try {
      if (meta.containsKey('progressReference')) {
        final ref = Map<String, dynamic>.from(meta['progressReference']);
        final dateStr = ref['date'] as String?;
        final pRaw = ref['progress'];
        final p = (pRaw is num) ? pRaw.toDouble() : double.tryParse(pRaw?.toString() ?? '');
        if (dateStr != null && p != null) {
          refDate = DateTime.parse(dateStr);
          refProgress = p.clamp(0.0, 1.0);
          return {'date': refDate, 'progress': refProgress};
        }
      }
    } catch (_) {
      // ignore, fallback to next options
    }

    // 2) initialGrowthPercent
    try {
      if (meta.containsKey('initialGrowthPercent')) {
        final ipRaw = meta['initialGrowthPercent'];
        final ip = (ipRaw is num) ? ipRaw.toDouble() : double.tryParse(ipRaw?.toString() ?? '');
        if (ip != null) {
          refDate = planting.plantedDate;
          refProgress = ip.clamp(0.0, 1.0);
          return {'date': refDate, 'progress': refProgress};
        }
      }
    } catch (_) {}

    // 3) status Planté -> vérifier plant.growth['transplantInitialPercent']
    try {
      if (planting.status == 'Planté') {
        if (plant?.growth != null) {
          final raw = plant!.growth!['transplantInitialPercent'];
          if (raw is num) {
            refProgress = raw.toDouble().clamp(0.0, 1.0);
          } else if (raw is String) {
            final p = double.tryParse(raw);
            refProgress = (p ?? 0.3).clamp(0.0, 1.0);
          } else {
            refProgress = 0.3;
          }
        } else {
          refProgress = 0.3;
        }
        refDate = planting.plantedDate;
        return {'date': refDate, 'progress': refProgress};
      }
    } catch (_) {}

    // 4) défaut Semé
    refDate = planting.plantedDate;
    refProgress = 0.0;
    return {'date': refDate, 'progress': refProgress};
  }

  /// Calcule le pourcentage de progression actuel (0..1) sur la base de la
  /// référence et du nombre de jours de maturité (daysToMaturity).
  static double computeProgress(Planting planting, PlantFreezed? plant, {DateTime? now}) {
    now = now ?? DateTime.now();
    final int M = (plant?.daysToMaturity ?? 60);
    final ref = getProgressReference(planting, plant);
    final DateTime refDate = ref['date'] as DateTime;
    final double refProgress = (ref['progress'] as double).clamp(0.0, 1.0);

    if (M <= 0) return refProgress;

    final int daysSinceRef = now.difference(refDate).inDays;
    final double progress = (refProgress + (daysSinceRef / M)).clamp(0.0, 1.0);
    return progress;
  }

  /// Calcule la date de récolte attendue à partir de la référence
  static DateTime computeExpectedHarvestDate(Planting planting, PlantFreezed? plant) {
    final int M = (plant?.daysToMaturity ?? 60);
    final ref = getProgressReference(planting, plant);
    final DateTime refDate = ref['date'] as DateTime;
    final double refProgress = (ref['progress'] as double).clamp(0.0, 1.0);

    if (M <= 0) return refDate;

    final int effectiveMaturityDays = (M * (1.0 - refProgress)).ceil().clamp(1, M);
    return refDate.add(Duration(days: effectiveMaturityDays));
  }

  /// Construit un objet progressReference pour le stockage (JSON-friendly)
  static Map<String, dynamic> buildProgressReferenceMap(DateTime date, double progress) {
    return {'date': date.toIso8601String(), 'progress': progress.clamp(0.0, 1.0)};
  }

  /// Ajoute une observation dans les métadonnées (renvoie une nouvelle map)
  static Map<String, dynamic> addObservationToMeta(
    Map<String, dynamic>? meta,
    String type,
    DateTime date,
    double progress, {
    String? notes,
  }) {
    final Map<String, dynamic> newMeta = Map<String, dynamic>.from(meta ?? {});
    final obs = (newMeta['observations'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        <Map<String, dynamic>>[];
    obs.add({
      'type': type,
      'date': date.toIso8601String(),
      'progress': progress.clamp(0.0, 1.0),
      'notes': notes,
    });
    newMeta['observations'] = obs;
    newMeta['progressReference'] = buildProgressReferenceMap(date, progress);
    return newMeta;
  }
}
