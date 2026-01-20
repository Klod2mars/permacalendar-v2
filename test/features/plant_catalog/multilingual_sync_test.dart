import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permacalendar/features/plant_catalog/data/repositories/plant_hive_repository.dart';
import 'package:permacalendar/features/plant_catalog/data/models/plant_hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Define simplified JSONs for testing
  const String jsonFr = '''
  {
    "plants": [
      {
        "id": "tomato",
        "commonName": "Tomate",
        "plantingSeason": "Printemps",
        "harvestSeason": "Été",
        "daysToMaturity": 80,
        "spacing": 50,
        "depth": 1.0,
        "sunExposure": "Plein soleil",
        "waterNeeds": "Moyen",
        "description": "Rouge et ronde"
      }
    ]
  }
  ''';

  const String jsonEn = '''
  {
    "plants": [
      {
        "id": "tomato",
        "commonName": "Tomato",
        "plantingSeason": "Spring",
        "harvestSeason": "Summer",
        "daysToMaturity": 80,
        "spacing": 50,
        "depth": 1.0,
        "sunExposure": "Full Sun",
        "waterNeeds": "Medium",
        "description": "Red and round"
      }
    ]
  }
  ''';

  setUpAll(() async {
    // Initialize Hive
    final tempDir = await getTempDir();
    Hive.init(tempDir.path);
    // Register adapter if not already registered
    if (!Hive.isAdapterRegistered(29)) {
       Hive.registerAdapter(PlantHiveAdapter());
    }
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  setUp(() async {
    await PlantHiveRepository.initialize(); // Opens the box
  });

  tearDown(() async {
    final box = await Hive.openBox<PlantHive>('plants_box');
    await box.clear();
  });

  // Mock Asset Loading
  void mockAssets({required String lang}) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        if (message == null) return null;
        try {
           final String key = utf8.decode(message.buffer.asUint8List());
           
           if (key == 'assets/data/plants.json') return ByteData.view(utf8.encode(jsonFr).buffer);
           if (key == 'assets/data/json_multilangue_doc/plants_en.json') return ByteData.view(utf8.encode(jsonEn).buffer);
           
           return null;
        } catch (e) {
           return null;
        }
      },
    );
  }

  test('syncWithJson loads French by default', () async {
    mockAssets(lang: 'fr');
    final repo = PlantHiveRepository();
    
    await repo.syncWithJson('fr');
    
    final plant = await repo.getPlantById('tomato');
    expect(plant, isNotNull);
    expect(plant!.commonName, 'Tomate');
  });

  test('syncWithJson loads English', () async {
    mockAssets(lang: 'en');
    final repo = PlantHiveRepository();
    
    await repo.syncWithJson('en');
    
    final plant = await repo.getPlantById('tomato');
    expect(plant, isNotNull);
    expect(plant!.commonName, 'Tomato');
  });

  test('Smart Sync preserves user modifications (isActive)', () async {
    mockAssets(lang: 'fr'); 
    final repo = PlantHiveRepository();
    
    // 1. Initial Sync (FR)
    await repo.syncWithJson('fr');
    var plant = await repo.getPlantById('tomato');
    expect(plant!.commonName, 'Tomate');
    expect(plant.isActive, true); 
    
    // 2. Modify isActive
    final box = Hive.box<PlantHive>('plants_box');
    final hivePlant = box.get('tomato');
    if (hivePlant != null) {
      hivePlant.isActive = false;
      hivePlant.save();
    }
    
    // Check it's saved
    plant = await repo.getPlantById('tomato');
    expect(plant!.isActive, false);
    
    // 3. Sync with EN
    mockAssets(lang: 'en');
    
    await repo.syncWithJson('en');
    
    // 4. Verify
    plant = await repo.getPlantById('tomato');
    expect(plant!.commonName, 'Tomato'); 
    expect(plant.isActive, false); 
  });
}

Future<Directory> getTempDir() async {
  return Directory.systemTemp.createTemp('hive_test');
}
