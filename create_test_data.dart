import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'lib/core/models/garden_hive.dart';
import 'lib/core/models/garden_bed_hive.dart';
import 'lib/core/models/planting_hive.dart';
import 'lib/core/data/hive/garden_boxes.dart';

/// Script pour créer des données de test
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
    
    print('🌱 === CRÉATION DE DONNÉES DE TEST ===');
    
    // Créer un jardin de test
    final garden = GardenHive(
      id: 'test_garden_1',
      name: 'Mon Potager de Test',
      description: 'Jardin de test pour l\'Intelligence Végétale',
      location: 'Paris, France',
      area: 50.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // Sauvegarder le jardin
    await GardenBoxes.saveGarden(garden);
    print('✅ Jardin créé: ${garden.name}');
    
    // Créer des parcelles
    final bed1 = GardenBedHive(
      id: 'bed_1',
      gardenId: garden.id,
      name: 'Parcelle Légumes',
      description: 'Parcelle pour les légumes',
      area: 20.0,
      soilType: 'Limoneux',
      exposure: 'Plein soleil',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final bed2 = GardenBedHive(
      id: 'bed_2',
      gardenId: garden.id,
      name: 'Parcelle Aromates',
      description: 'Parcelle pour les aromates',
      area: 15.0,
      soilType: 'Sableux',
      exposure: 'Mi-ombre',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // Sauvegarder les parcelles
    await GardenBoxes.saveGardenBed(bed1);
    await GardenBoxes.saveGardenBed(bed2);
    print('✅ Parcelles créées: ${bed1.name}, ${bed2.name}');
    
    // Créer des plantations actives
    final plantings = [
      PlantingHive(
        id: 'planting_1',
        bedId: bed1.id,
        plantId: 'tomato',
        plantName: 'Tomate',
        variety: 'Cœur de Bœuf',
        quantity: 3,
        plantedDate: DateTime.now().subtract(const Duration(days: 30)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 50)),
        isActive: true,
        notes: 'Plantation de test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      PlantingHive(
        id: 'planting_2',
        bedId: bed1.id,
        plantId: 'lettuce',
        plantName: 'Laitue',
        variety: 'Batavia',
        quantity: 5,
        plantedDate: DateTime.now().subtract(const Duration(days: 20)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 40)),
        isActive: true,
        notes: 'Plantation de test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      PlantingHive(
        id: 'planting_3',
        bedId: bed2.id,
        plantId: 'basil',
        plantName: 'Basilic',
        variety: 'Grand Vert',
        quantity: 2,
        plantedDate: DateTime.now().subtract(const Duration(days: 15)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 60)),
        isActive: true,
        notes: 'Plantation de test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      PlantingHive(
        id: 'planting_4',
        bedId: bed2.id,
        plantId: 'parsley',
        plantName: 'Persil',
        variety: 'Plat',
        quantity: 3,
        plantedDate: DateTime.now().subtract(const Duration(days: 25)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 45)),
        isActive: true,
        notes: 'Plantation de test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      PlantingHive(
        id: 'planting_5',
        bedId: bed1.id,
        plantId: 'carrot',
        plantName: 'Carotte',
        variety: 'Nantaise',
        quantity: 10,
        plantedDate: DateTime.now().subtract(const Duration(days: 40)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        notes: 'Plantation de test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    
    // Sauvegarder les plantations
    for (final planting in plantings) {
      await GardenBoxes.savePlanting(planting);
    }
    
    print('✅ ${plantings.length} plantations créées');
    
    // Vérification
    final savedGardens = GardenBoxes.getAllGardens();
    print('\n📊 RÉSUMÉ:');
    print('   🌿 Jardins: ${savedGardens.length}');
    
    for (final g in savedGardens) {
      final beds = GardenBoxes.getGardenBeds(g.id);
      int totalPlantings = 0;
      int activePlantings = 0;
      
      for (final bed in beds) {
        final bedPlantings = GardenBoxes.getPlantings(bed.id);
        totalPlantings += bedPlantings.length;
        activePlantings += bedPlantings.where((p) => p.isActive).length;
      }
      
      print('   📦 ${g.name}: ${beds.length} parcelles, $activePlantings/$totalPlantings plantations actives');
    }
    
    print('\n🎉 Données de test créées avec succès!');
    print('💡 Relancez l\'application pour voir les nouvelles données.');
    
  } catch (e, stackTrace) {
    print('❌ Erreur: $e');
    print('📍 StackTrace: $stackTrace');
  }
}