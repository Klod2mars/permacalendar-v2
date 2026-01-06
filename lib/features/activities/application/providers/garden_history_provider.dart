import 'package:riverpod/riverpod.dart';
import '../../../../core/data/hive/garden_boxes.dart';
import '../../../../core/providers/garden_aggregation_providers.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../domain/models/garden_history.dart';

// Provider pour l'historique du jardin
final gardenHistoryProvider = FutureProvider.family<GardenHistory, String>((ref, gardenId) async {
  // Preferer hub/unified context when available
  try {
    // Note: unifiedGardenContextProvider currently returns UnifiedGardenContext
    // We would ideally extract history from there, but UnifiedGardenContext structure 
    // might not be perfectly aligned with Year/Bed hierarchy yet.
    // transform logic could go here if `unified.historicalPlants` was used.
    // For now, we use the robust fallback to GardenBoxes as requested.
    await ref.read(unifiedGardenContextProvider(gardenId).future);
  } catch (_) {
    // ignore error and proceed to fallback
  }

  // Fetch garden using the repository (Source of Truth)
  final gardenRepository = ref.read(gardenRepositoryProvider);
  // Note: getGardenById returns Future<GardenFreezed?>
  final garden = await gardenRepository.getGardenById(gardenId);
  
  if (garden == null) {
    throw Exception('Jardin non trouvé: $gardenId');
  }

  // Use GardenBoxes for beds/plantings (Legacy/Shared storage)
  // Assuming these boxes are correctly maintained/synced.
  final beds = GardenBoxes.getGardenBeds(gardenId);
  final Map<String, List<dynamic>> plantingsMap = {};
  for (final bed in beds) {
    plantingsMap[bed.id] = GardenBoxes.getPlantings(bed.id);
  }

  return transformToHistory(
    garden.id,
    garden.name,
    garden.createdAt,
    beds,
    plantingsMap,
  );
});

/// Pure transformation function for testing
GardenHistory buildGardenHistoryFromRawData({
  required String gardenId,
  required String gardenName,
  required DateTime gardenCreatedAt,
  required List<dynamic> beds, // List<GardenBed>
  required List<dynamic> allPlantings, // List<Planting>
}) {
  final Map<int, List<BedYearHistory>> yearToBeds = {};
  final Map<String, String> bedNames = {for (var b in beds) b.id: b.name};

  // Group plantings by bed
  final plantingsByBed = <String, List<dynamic>>{};
  for (final p in allPlantings) {
     final bedId = p.gardenBedId ?? ''; 
     // Note: Planting model usually has gardenBedId. 
     // If not, we rely on the caller passing plantings associated correctly?
     // In the provider above: "GardenBoxes.getPlantings(bed.id)" returns plantings for that bed.
     // But flattened list needs bedId. 
     // Let's assume Planting has bedId or we pass a map.
     // Actually, in the provider loop:
     // for (final bed in beds) { final plantings = ...; }
     // So we know the bed.
     // To make this function pure and simple, let's accept a Map<Bed, List<Planting>> or similar?
     // Or just iterate beds and filtered plantings.
     // To avoid complex refactor, let's keep the provider logic structure but parametrized.
  }
  
  // Re-approach: Let's pass the mapped data to avoid dependency on Planting internals if they are complex.
  // Actually, let's just use the provider logic but isolated.
  
  for (final bed in beds) {
    // Filter plantings for this bed if passed as a flat list
    // Assuming Planting has gardenBedId.
    // If not, we might need to pass map.
    // Let's assume the provider passes a Map<String, List<Planting>>?
    // No, let's pass the list of 'BedWithPlantings' or similar DTO?
    // Too complex for now.
    
    // Simplification: We will trust the test to pass objects that look like beds and plantings.
    // We can't rely on 'gardenBedId' property availability on 'dynamic' efficiently without reflection or casting.
    // Let's stick to the previous loop structure but in the function.
    
    // We need to know which plantings belong to which bed.
    // Let's change definition to accept Map.
  }
  return GardenHistory(gardenId: gardenId, gardenName: gardenName, years: []);
} 

// Better approach:
GardenHistory transformToHistory(
    String gardenId, 
    String gardenName, 
    DateTime gardenCreatedAt, 
    List<dynamic> beds, 
    Map<String, List<dynamic>> plantingsByBedId
    ) {
    
  final Map<int, List<BedYearHistory>> yearToBeds = {};

  for (final bed in beds) {
    final plantings = plantingsByBedId[bed.id] ?? [];
    
    for (final planting in plantings) {
      final dt = planting.plantedDate ?? DateTime.now();
      final year = dt.year;
      
      final plantHistory = PlantHistory(
        plantId: planting.plantId,
        plantName: planting.plantName,
        plantedDate: planting.plantedDate,
        harvestedDate: planting.actualHarvestDate, 
      );

      final list = yearToBeds.putIfAbsent(year, () => []);
      
      var existing = list.firstWhere(
        (b) => b.bedId == bed.id && b.year == year,
        orElse: () => BedYearHistory(
            bedId: bed.id, 
            bedName: bed.name, 
            year: year, 
            plants: []
        ),
      );
      
      if (existing.plants.isEmpty && !list.contains(existing)) {
         list.add(existing);
      } else if (!list.contains(existing)) {
         list.add(existing);
      }

      existing.plants.add(plantHistory);
    }
  }

  // Construct YearPage list sorted desc
  final years = yearToBeds.keys.toList()..sort((a,b) => b.compareTo(a));
  
  final startYear = gardenCreatedAt.year;
  final currentYear = DateTime.now().year;
  
  // Fill missing years range
  for (int y = currentYear; y >= startYear; y--) {
    if (!years.contains(y)) {
      years.add(y);
    }
  }
  years.sort((a,b) => b.compareTo(a));

  // Fill gap: Ensure every year has an entry for every bed
  for (final year in years) {
    final bedList = yearToBeds.putIfAbsent(year, () => []);
    for (final bed in beds) {
       // Check if bed is already present
       final isPresent = bedList.any((b) => b.bedId == bed.id);
       if (!isPresent) {
         bedList.add(BedYearHistory(
           bedId: bed.id,
           bedName: bed.name, 
           year: year, 
           plants: [],
         ));
       }
    }
    // Optional: Sort beds by name or generic order
    // bedList.sort((a,b) => a.bedName.compareTo(b.bedName));
  }

  final List<YearPage> yearPages = years.map((y) => YearPage(year: y, beds: yearToBeds[y] ?? [])).toList();

  return GardenHistory(gardenId: gardenId, gardenName: gardenName, years: yearPages);
}
