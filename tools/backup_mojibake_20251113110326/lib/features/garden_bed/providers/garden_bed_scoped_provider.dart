import 'package:riverpod/riverpod.dart';
import '../../../core/models/garden_bed.dart';
import '../../../core/data/hive/garden_boxes.dart';

/// Provider scopé par jardin pour les planches
/// Chaque jardin a son propre scope d'état pour éviter la contamination entre jardins
final gardenBedProvider =
    FutureProvider.family<List<GardenBed>, String>((ref, gardenId) async {
  // Charger uniquement les planches du jardin spécifié
  return GardenBoxes.getGardenBeds(gardenId);
});

/// Provider pour obtenir une planche spécifique par son ID dans un jardin donné
final gardenBedDetailProvider =
    FutureProvider.family<GardenBed?, ({String gardenId, String bedId})>(
        (ref, params) async {
  final gardenBeds = await ref.watch(gardenBedProvider(params.gardenId).future);
  return gardenBeds.where((bed) => bed.id == params.bedId).firstOrNull;
});

/// Provider pour compter les planches d'un jardin
final gardenBedCountProvider =
    FutureProvider.family<int, String>((ref, gardenId) async {
  final gardenBeds = await ref.watch(gardenBedProvider(gardenId).future);
  return gardenBeds.length;
});

/// Provider pour calculer la superficie totale des planches d'un jardin
final gardenTotalAreaProvider =
    FutureProvider.family<double, String>((ref, gardenId) async {
  final gardenBeds = await ref.watch(gardenBedProvider(gardenId).future);
  return gardenBeds.fold<double>(
      0.0, (sum, bed) => sum + bed.sizeInSquareMeters);
});


