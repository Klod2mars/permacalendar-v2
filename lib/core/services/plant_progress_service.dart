// lib/core/services/plant_progress_service.dart
import 'dart:developer' as developer;

import '../../features/plant_catalog/domain/entities/plant_entity.dart';
import '../models/planting.dart';

/// Service utilitaire pour calculer le pourcentage de vie (0.0..1.0)
/// d'une planting et produire la date de récolte attendue.
/// Il centralise la logique :
///
/// - getProgressReference(...) : obtient la référence temporelle et le % de référence
///   (progressReference dans metadata, sinon initialGrowthPercent, sinon règles Semé/Planté)
/// - computeProgress(...) : calcule le % actuel à partir de la référence
/// - computeExpectedHarvestDate(...) : calcule la date de récolte attendue
/// - buildProgressReferenceMap(...) : format JSON-friendly pour la sauvegarde
/// - addObservationToMeta(...) : ajoute une observation et met à jour progressReference
class PlantProgressService {
  /// Helper de debug : log la référence calculée pour une planting.
  static void _debugLogRef(
      Planting planting, PlantFreezed? plant, DateTime refDate, double refProgress) {
    try {
      final plantName = planting.plantName;
      final id = planting.id;
      final status = planting.status;
      final daysToMaturity = plant?.daysToMaturity;
      developer.log(
        '[PlantProgressService] ref: planting=$id name="$plantName" status=$status refDate=${refDate.toIso8601String()} refProgress=${(refProgress * 100).toStringAsFixed(1)}% daysToMaturity=${daysToMaturity ?? 'null'}',
      );
    } catch (_) {
      // ignore logging errors
    }
  }

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
            _debugLogRef(planting, plant, refDate, refProgress);
            return {'date': refDate, 'progress': refProgress};
          } else {
            developer.log(
                '[PlantProgressService] progressReference present but malformed for planting=${planting.id} rawRef=$rawRef');
          }
        }
      }
    } catch (e, s) {
      developer.log(
          '[PlantProgressService] getProgressReference: error reading progressReference for planting=${planting.id}: $e\n$s');
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
          _debugLogRef(planting, plant, refDate, refProgress);
          return {'date': refDate, 'progress': refProgress};
        } else {
          developer.log(
              '[PlantProgressService] initialGrowthPercent present but unparsable for planting=${planting.id} value=$ipRaw');
        }
      }
    } catch (e, s) {
      developer.log(
          '[PlantProgressService] getProgressReference: error reading initialGrowthPercent for planting=${planting.id}: $e\n$s');
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
        _debugLogRef(planting, plant, refDate, refProgress);
        return {'date': refDate, 'progress': refProgress};
      }
    } catch (e, s) {
      developer.log(
          '[PlantProgressService] getProgressReference: error processing Planté fallback for planting=${planting.id}: $e\n$s');
    }

    // 4) défaut Semé
    refDate = planting.plantedDate;
    refProgress = 0.0;
    _debugLogRef(planting, plant, refDate, refProgress);
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

    if (M <= 0) {
      developer.log(
          '[PlantProgressService] computeProgress: M<=0 for planting=${planting.id}, returning refProgress ${(refProgress * 100).toStringAsFixed(1)}%');
      return refProgress;
    }

    final int daysSinceRef = now.isBefore(refDate) ? 0 : now.difference(refDate).inDays;
    final double progress = (refProgress + (daysSinceRef / M)).clamp(0.0, 1.0).toDouble();

    // Debug log détaillé
    try {
      developer.log(
        '[PlantProgressService] computeProgress: planting=${planting.id} refDate=${refDate.toIso8601String()} daysSinceRef=$daysSinceRef M=$M refProgress=${(refProgress * 100).toStringAsFixed(1)}% => progress=${(progress * 100).toStringAsFixed(1)}% now=${now.toIso8601String()}',
      );
    } catch (_) {
      // ignore logging errors
    }

    return progress;
  }

  /// Calcule la date de récolte attendue à partir de la référence.
  static DateTime computeExpectedHarvestDate(Planting planting, PlantFreezed? plant) {
    final int M = (plant?.daysToMaturity ?? 60);
    final ref = getProgressReference(planting, plant);
    final DateTime refDate = ref['date'] as DateTime;
    final double refProgress = (ref['progress'] as double).clamp(0.0, 1.0);

    if (M <= 0) return refDate;

    final int effectiveMaturityDays = (M * (1.0 - refProgress)).ceil().clamp(1, M);
    final DateTime expected = refDate.add(Duration(days: effectiveMaturityDays));

    developer.log(
      '[PlantProgressService] computeExpectedHarvestDate: planting=${planting.id} refProgress=${(refProgress * 100).toStringAsFixed(1)}% effectiveMaturityDays=$effectiveMaturityDays expected=${expected.toIso8601String()}',
    );

    return expected;
  }

  /// Construit un objet progressReference JSON-friendly pour stockage.
  static Map<String, dynamic> buildProgressReferenceMap(DateTime date, double progress) {
    return {'date': date.toIso8601String(), 'progress': progress.clamp(0.0, 1.0)};
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
    final List<Map<String, dynamic>> obs =
        (newMeta['observations'] as List?)
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
    developer.log(
      '[PlantProgressService] addObservationToMeta: added observation type=$type date=${date.toIso8601String()} progress=${(progress * 100).toStringAsFixed(1)}%',
    );
    return newMeta;
  }
}
