import 'package:riverpod/riverpod.dart';
import '../../../core/models/garden_freezed.dart';
import '../../../core/repositories/repository_providers.dart';

/// Provider pour récupérer un jardin spécifique par son ID
final gardenDetailProvider =
    FutureProvider.family<GardenFreezed?, String>((ref, gardenId) async {
  final repository = ref.watch(gardenRepositoryProvider);
  final gardens = await repository.getAllGardens();
  return gardens.where((garden) => garden.id == gardenId).firstOrNull;
});

/// Provider pour récupérer tous les jardins
final gardensListProvider = FutureProvider<List<GardenFreezed>>((ref) async {
  final repository = ref.watch(gardenRepositoryProvider);
  return await repository.getAllGardens();
});

/// Provider pour les jardins actifs uniquement
final activeGardensProvider = FutureProvider<List<GardenFreezed>>((ref) async {
  final gardens = await ref.watch(gardensListProvider.future);
  return gardens.where((garden) => garden.isActive).toList();
});
