import 'package:riverpod/riverpod.dart';
import '../../../core/models/garden_bed.dart';
import '../../../core/data/hive/garden_boxes.dart';

/// Source de vérité scoptée par jardin pour les planches (Canonique)
/// Chaque jardin a son propre scope d'état pour éviter la contamination entre jardins
final gardenBedsForGardenProvider =
    FutureProvider.family<List<GardenBed>, String>((ref, gardenId) async {
  // Charger uniquement les planches du jardin spécifié
  return GardenBoxes.getGardenBeds(gardenId);
});

/// Deprecated alias for compatibility if needed during strict transition,
/// but since we are refactoring consumers, we might not strictly need it exposed here if we change all files.
/// However, to be safe with imports I'll leave it but flagged.
@Deprecated('Use gardenBedsForGardenProvider')
final gardenBedProvider = gardenBedsForGardenProvider;

/// Provider pour obtenir une planche spécifique par son ID dans un jardin donné
final gardenBedDetailProvider =
    FutureProvider.family<GardenBed?, ({String gardenId, String bedId})>(
        (ref, params) async {
  final gardenBeds = await ref.watch(gardenBedsForGardenProvider(params.gardenId).future);
  return gardenBeds.where((bed) => bed.id == params.bedId).firstOrNull;
});

/// Provider pour compter les planches d'un jardin
final gardenBedCountProvider =
    FutureProvider.family<int, String>((ref, gardenId) async {
  final gardenBeds = await ref.watch(gardenBedsForGardenProvider(gardenId).future);
  return gardenBeds.length;
});

/// Provider pour calculer la superficie totale des planches d'un jardin
final gardenTotalAreaProvider =
    FutureProvider.family<double, String>((ref, gardenId) async {
  final gardenBeds = await ref.watch(gardenBedsForGardenProvider(gardenId).future);
  return gardenBeds.fold<double>(
      0.0, (sum, bed) => sum + bed.sizeInSquareMeters);
});
