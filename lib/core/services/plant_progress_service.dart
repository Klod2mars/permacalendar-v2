// lib/core/services/plant_progress_service.dart
import '../../features/plant_catalog/domain/entities/plant_entity.dart';
import '../models/planting.dart';

/// Service utilitaire pour calculer le pourcentage de vie (0.0..1.0)
/// d'une planting et produire la date de récolte attendue.
/// Il centralise la logique :
/// - getProgressReference(...) : obtient la référence temporelle et le % de référence
///   (progressReference dans metadata, sinon initialGrowthPercent, sinon règles Semé/Planté)
/// - computeProgress(...) : calcule le % actuel à partir de la référence
/// - computeExpectedHarvestDate(...) : calcule la date de récolte attendue
/// - buildProgressReferenceMap(...) : format JSON-friendly pour la sauvegarde
/// - addObservationToMeta(...) : ajoute une observation et met à jour progressReference
class PlantProgressService {
  /// Lit et normalise la progressReference depuis la planting.
  /// Retourne une Map {'date': DateTime, 'progress': double}.
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

    // 1) progressReference explicite (si présent, on l'utilise)
    try {
      if (meta.containsKey('progressReference')) {
        final dynamic rawRef = meta['progressReference'];
        if (rawRef is Map) {
          final ref = Map<String, dynamic>.from(rawRef);
          final String? dateStr = ref['date'] as String?;
          final dynamic pRaw = ref['progress'];
          final double? p = (pRaw is num)
              ? pRaw.toDouble()
              : (double.tryParse(pRaw?.toString() ?? ''));
          if (dateStr != null && p != null) {
            refDate = DateTime.parse(dateStr);
            refProgress = p.clamp(0.0, 1.0).toDouble();
            return {'date': refDate, 'progress': refProgress};
          }
        }
      }
    } catch (_) {
      // fallback to next options
    }

    // 2) initialGrowthPercent dans metadata
    try {
      if (meta.containsKey('initialGrowthPercent')) {
        final dynamic ipRaw = meta['initialGrowthPercent'];
        final double? ip = (ipRaw is num)
            ? ipRaw.toDouble()
            : double.tryParse(ipRaw?.toString() ?? '');
        if (ip != null) {
          refDate = planting.plantedDate;
          refProgress = ip.clamp(0.0, 1.0).toDouble();
          return {'date': refDate, 'progress': refProgress};
        }
      }
    } catch (_) {
      // fallback
    }

    // 3) status Planté -> chercher plant.growth['transplantInitialPercent']
    try {
      if (planting.status == 'Planté') {
        double candidate = 0.3;
        try {
          if (plant?.growth != null) {
            final dynamic raw = plant!.growth!['transplantInitialPercent'];
            if (raw is num) {
              candidate = raw.toDouble();
            } else if (raw is String) {
              candidate = double.tryParse(raw) ?? 0.3;
            }
          }
        } catch (_) {
          candidate = 0.3;
        }
        refDate = planting.plantedDate;
        refProgress = candidate.clamp(0.0, 1.0).toDouble();
        return {'date': refDate, 'progress': refProgress};
      }
    } catch (_) {
      // fallback
    }

    // 4) défaut Semé
    refDate = planting.plantedDate;
    refProgress = 0.0;
    return {'date': refDate, 'progress': refProgress};
  }

  /// Calcule le pourcentage de progression actuel (0..1) sur la base de la
  /// référence et du nombre de jours de maturité (daysToMaturity).
  /// now est injection-friendly pour les tests.
  static double computeProgress(Planting planting, PlantFreezed? plant,
      {DateTime? now}) {
    now = now ?? DateTime.now();
    final int M = (plant?.daysToMaturity ?? 60);
    final ref = getProgressReference(planting, plant);
    final DateTime refDate = ref['date'] as DateTime;
    final double refProgress = (ref['progress'] as double).clamp(0.0, 1.0);

    if (M <= 0) return refProgress;

    final int daysSinceRef =
        now.isBefore(refDate) ? 0 : now.difference(refDate).inDays;
    final double progress =
        (refProgress + (daysSinceRef / M)).clamp(0.0, 1.0).toDouble();
    return progress;
  }

  /// Calcule la date de récolte attendue à partir de la référence.
  static DateTime computeExpectedHarvestDate(
      Planting planting, PlantFreezed? plant) {
    final int M = (plant?.daysToMaturity ?? 60);
    final ref = getProgressReference(planting, plant);
    final DateTime refDate = ref['date'] as DateTime;
    final double refProgress = (ref['progress'] as double).clamp(0.0, 1.0);

    if (M <= 0) return refDate;

    final int effectiveMaturityDays =
        (M * (1.0 - refProgress)).ceil().clamp(1, M);
    return refDate.add(Duration(days: effectiveMaturityDays));
  }

  /// Construit un objet progressReference JSON-friendly pour stockage.
  static Map<String, dynamic> buildProgressReferenceMap(
      DateTime date, double progress) {
    return {
      'date': date.toIso8601String(),
      'progress': progress.clamp(0.0, 1.0)
    };
  }

  /// Ajoute une observation dans les métadonnées (renvoie une nouvelle map).
  /// - type : 'germinated' | 'manual_progress' | 'transplant' ...
  /// - date : Date de l'observation
  /// - progress : 0.0..1.0
  static Map<String, dynamic> addObservationToMeta(
    Map<String, dynamic>? meta,
    String type,
    DateTime date,
    double progress, {
    String? notes,
  }) {
    final Map<String, dynamic> newMeta = Map<String, dynamic>.from(meta ?? {});
    final List<Map<String, dynamic>> obs = (newMeta['observations'] as List?)
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
