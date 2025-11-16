// lib/core/utils/planting_utils.dart
import '../models/planting.dart';

/// Calcule la progression d'une plantation entre `plantedDate` et
/// `expectedHarvestStartDate`.
/// Retourne une valeur entre 0.0 et 1.0.
/// Si la date de début de récolte attendue est absente ou invalide, retourne 0.0.
double computePlantingProgress(Planting planting) {
  final DateTime start = planting.plantedDate;
  final DateTime? target = planting.expectedHarvestStartDate;

  if (target == null) return 0.0;

  // Utiliser des secondes pour plus de précision sur de courtes périodes
  final int totalSeconds = target.difference(start).inSeconds;
  if (totalSeconds <= 0) return 0.0;

  final int elapsedSeconds = DateTime.now().difference(start).inSeconds;
  final double raw = elapsedSeconds / totalSeconds;
  if (!raw.isFinite) return 0.0;
  return raw.clamp(0.0, 1.0);
}
