import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'lib/core/data/hive/garden_boxes.dart';
import 'lib/core/models/garden_hive.dart';
import 'lib/core/models/planting_hive.dart';
import 'lib/core/models/garden_bed_hive.dart';

/// Script de debug pour vérifier les données des plantes
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Hive
  await Hive.initFlutter();
  
  // Enregistrer les adaptateurs
  Hive.registerAdapter(GardenHiveAdapter());
  Hive.registerAdapter(GardenBedHiveAdapter());
  Hive.registerAdapter(PlantingHiveAdapter());
  
  try {
    // Initialiser les boxes
    await GardenBoxes.initialize();
    
    print('🔍 === DIAGNOSTIC DES PLANTES ===');
    
    // Récupérer tous les jardins
    final gardens = GardenBoxes.getAllGardens();
    print('📦 Jardins trouvés: ${gardens.length}');
    
    for (final garden in gardens) {
      print('\n🌿 JARDIN: ${garden.name} (ID: ${garden.id})');
      
      // Récupérer les parcelles
      final beds = GardenBoxes.getGardenBeds(garden.id);
      print('   📦 Parcelles: ${beds.length}');
      
      int totalPlantings = 0;
      int activePlantings = 0;
      
      for (final bed in beds) {
        final plantings = GardenBoxes.getPlantings(bed.id);
        totalPlantings += plantings.length;
        
        print('   🛏️ Parcelle: ${bed.name} (${plantings.length} plantations)');
        
        for (final planting in plantings) {
          final status = planting.isActive ? '✅ ACTIVE' : '❌ INACTIVE';
          print('      🌱 ${planting.plantId} - $status');
          
          if (planting.isActive) {
            activePlantings++;
          }
        }
      }
      
      print('   📊 RÉSUMÉ: $activePlantings actives / $totalPlantings totales');
    }
    
    print('\n✅ Diagnostic terminé');
    
  } catch (e) {
    print('❌ Erreur: $e');
  }
}