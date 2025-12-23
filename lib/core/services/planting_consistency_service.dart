
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/services/plant_catalog_service.dart';
import 'package:permacalendar/shared/utils/plant_image_resolver.dart';

class PlantingConsistencyReport {
  final List<Planting> orphans;
  final List<String> missingAssets;
  final List<String> fixedPlantings;
  final List<String> logs;

  PlantingConsistencyReport({
    required this.orphans,
    required this.missingAssets,
    required this.fixedPlantings,
    required this.logs,
  });
}

class PlantingConsistencyService {
  static final PlantingConsistencyService _instance = PlantingConsistencyService._();
  factory PlantingConsistencyService() => _instance;
  PlantingConsistencyService._();

  final List<String> _logs = [];

  void _log(String message) {
    if (kDebugMode) print('[PlantingConsistency] $message');
    _logs.add(message);
  }

  Future<PlantingConsistencyReport> audit() async {
    _logs.clear();
    _log('Starting Non-Destructive Audit...');
    
    final allPlantings = GardenBoxes.plantings.values.toList();
    _log('Found ${allPlantings.length} total plantings.');

    final orphans = <Planting>[];
    final missingAssets = <String>[];

    // 1. Check for Orphans
    for (final p in allPlantings) {
      final plant = await PlantCatalogService.getPlantById(p.plantId);
      if (plant == null) {
        orphans.add(p);
        _log('ORPHAN FOUND: PlantingID=${p.id}, PlantID=${p.plantId}, PlantName=${p.plantName}');
      }
    }
    _log('Total Orphans: ${orphans.length}');

    // 2. Check for Missing Assets
    // We need to load all plants (or at least the ones used) to check their assets
    // But audit requirement 4 says: "Charger AssetManifest.json et pour chaque plantation orpheline calculer la liste de candidats..."
    // ... "Liste des plantIDs pour lesquels aucun asset candidat n’existe"
    // Actually, we should check *all* used plants, or just orphans? The user said "Vérifier le manifeste d’assets vs candidats ... pour chaque plantation orpheline".
    // But missing images affect non-orphans too if the asset is missing. To be safe, let's check orphans first as requested.
    
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final manifestKeys = manifestMap.keys.map((k) => k.toLowerCase()).toSet();

    for (final p in allPlantings) { // checking all plantings for image issues
       // We emulate logic from PlantingImage / plant_image_resolver
       // If plant is linked, we use plant data. If orphan, we use planting data.
       final plant = await PlantCatalogService.getPlantById(p.plantId);
       
       // Construct candidates
       // Note: we can't easily access the private _buildCandidates from PlantingImage
       // But we can approximate it or use findPlantImageAsset logic manually
       // findPlantImageAsset returns a valid asset path if found.
       
       // We want to know if it RETURNS null or fallback.
       final resolved = await findPlantImageAsset(plant); 
       // If resolved is null, it means no asset found.
       // However, findPlantImageAsset returns null if not found.
       // But wait, findPlantImageAsset handles fallback? No, GardenBedCard handles fallback if result is null.
       
       if (resolved == null) {
          // Double check if we can resolve using planting data ONLY (if orphan)
          // findPlantImageAsset accepts 'plant' object. If null, it returns null.
          // PlantingImage widget does custom fallback logic using planting.plantName/id if plant is null.
          // We should check if *that* logic finds something.
          // Let's manually verify candidates based on planting info.
          
          final commonName = p.plantName;
          final id = p.plantId;
          
          // Re-implement simplified candidate generation
          final candidates = _generateCandidates(id, commonName, plant?.metadata);
          
          bool found = false;
          for (final c in candidates) {
            if (manifestKeys.contains(c.toLowerCase())) {
              found = true;
              break;
            }
          }
          
          if (!found) {
             missingAssets.add('Planting ${p.id} (${p.plantName}): No asset found for ID=$id, Name=$commonName');
             _log('MISSING ASSET: Planting ${p.id} (${p.plantName})');
          }
       }
    }

    return PlantingConsistencyReport(
      orphans: orphans,
      missingAssets: missingAssets,
      fixedPlantings: [],
      logs: List.from(_logs),
    );
  }

  Future<PlantingConsistencyReport> runMigration() async {
    _logs.clear();
    _log('Starting Migration (Repair)...');
    final result = await audit();
    final orphans = result.orphans;
    final fixedIds = <String>[];

    for (final p in orphans) {
      _log('Attempting to fix orphan: ${p.plantName} (CurrentID: ${p.plantId})');
      
      // Try fuzzy search
      try {
        final searchResults = await PlantCatalogService.searchPlants(p.plantName);
        if (searchResults.isNotEmpty) {
           // Heuristic: Pick first if exact match on common name or strong match
           final bestMatch = searchResults.first;
           
           // Normalize comparison
           final pName = p.plantName.trim().toLowerCase();
           final cName = bestMatch.commonName.trim().toLowerCase();
           
           // If reasonable match
           if (cName == pName || cName.contains(pName) || pName.contains(cName)) {
              _log('MATCH FOUND: ${bestMatch.commonName} (ID: ${bestMatch.id})');
              
              // APPLY FIX
              final updated = p.copyWith(
                plantId: bestMatch.id,
                plantName: bestMatch.commonName, // Normalize name to French
              );
              
              await GardenBoxes.savePlanting(updated);
              fixedIds.add(p.id);
              _log('FIX APPLIED: Planting ${p.id} now linked to ${bestMatch.id}');
           } else {
             _log('Ambiguous match skipped: ${bestMatch.commonName} vs ${p.plantName}');
           }
        } else {
          _log('No match found for ${p.plantName}');
        }
      } catch (e) {
        _log('Error searching/fixing ${p.id}: $e');
      }
    }
    
    return PlantingConsistencyReport(
      orphans: result.orphans.where((o) => !fixedIds.contains(o.id)).toList(), // Remaining orphans
      missingAssets: result.missingAssets,
      fixedPlantings: fixedIds,
      logs: List.from(_logs),
    );
  }

  List<String> _generateCandidates(String id, String commonName, Map? metadata) {
      final candidates = <String>[];
      
      // Add id-based
      if (id.isNotEmpty) {
        candidates.add('assets/images/legumes/$id.jpg');
        candidates.add('assets/images/legumes/$id.png');
        candidates.add('assets/images/plants/$id.jpg');
        candidates.add('assets/images/plants/$id.png');
      }
      
      // Add name-based
      if (commonName.isNotEmpty) {
         final safe = _toFilenameSafe(commonName);
         candidates.add('assets/images/legumes/$safe.jpg');
         candidates.add('assets/images/legumes/$safe.png');
         candidates.add('assets/images/plants/$safe.jpg');
         candidates.add('assets/images/plants/$safe.png');
      }
      
      return candidates;
  }
  
  String _toFilenameSafe(String s) {
    // simplified version of PlantingImage logic
    var out = s.trim().toLowerCase();
    out = out.replaceAll(RegExp(r'[^\w\s\-]'), '');
    out = out.replaceAll(RegExp(r'\s+'), '_');
    return out;
  }

}
