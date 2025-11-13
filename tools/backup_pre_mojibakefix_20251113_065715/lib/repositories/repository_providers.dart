ï»¿import 'package:riverpod/riverpod.dart';
import 'garden_hive_repository.dart';

/// Provider pour le repository des jardins
/// Utilise GardenHiveRepository qui gère les objets GardenFreezed
final gardenRepositoryProvider = Provider<GardenHiveRepository>((ref) {
  return GardenHiveRepository();
});


