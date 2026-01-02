import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/models/activity.dart';
import 'core/models/garden.dart';
import 'core/models/garden_bed.dart';
import 'core/models/planting.dart';
import 'core/data/hive/garden_boxes.dart';
import 'core/models/garden_hive.dart';
import 'core/models/garden_bed_hive.dart';
import 'core/models/planting_hive.dart';
import 'core/repositories/garden_hive_repository.dart';
import 'features/plant_catalog/data/models/plant_hive.dart';
import 'features/plant_catalog/data/repositories/plant_hive_repository.dart';
import 'core/models/sky_calibration_config.dart';
import 'core/models/activity_v3.dart';
import 'core/services/activity_observer_service.dart';
import 'core/hive/type_ids.dart';

class AppInitializer {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    await Hive.initFlutter();

    // Register Core Adapters
    try {
      // Legacy Adapters (Required for GardenBoxes/UI)
      if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(GardenAdapter());
      if (!Hive.isAdapterRegistered(1))
        Hive.registerAdapter(GardenBedAdapter());
      if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(PlantingAdapter());

      // Modern Adapters (Required for Repositories) - IDs verified from *.g.dart files
      if (!Hive.isAdapterRegistered(25))
        Hive.registerAdapter(GardenHiveAdapter());
      if (!Hive.isAdapterRegistered(26))
        Hive.registerAdapter(GardenBedHiveAdapter());
      if (!Hive.isAdapterRegistered(27))
        Hive.registerAdapter(PlantingHiveAdapter());
      if (!Hive.isAdapterRegistered(29))
        Hive.registerAdapter(PlantHiveAdapter());

      // Activity Adapters
      if (!Hive.isAdapterRegistered(16))
        Hive.registerAdapter(ActivityAdapter());
      if (!Hive.isAdapterRegistered(17))
        Hive.registerAdapter(ActivityTypeAdapter());

      // Modern ActivityV3 adapter (kTypeIdActivityV3 = 30)
      try {
        if (!Hive.isAdapterRegistered(kTypeIdActivityV3)) {
          Hive.registerAdapter(ActivityV3Adapter());
          print('✅ ActivityV3Adapter registered (typeId=$kTypeIdActivityV3)');
        } else {
          print(
              'ℹ️ ActivityV3Adapter already registered (typeId=$kTypeIdActivityV3)');
        }
      } catch (e) {
        print('⚠️ Error registering ActivityV3Adapter: $e');
      }

      // Sky Calibration Adapter
      if (!Hive.isAdapterRegistered(44))
        Hive.registerAdapter(SkyCalibrationConfigAdapter());
    } catch (e) {
      print('Warning: Error registering adapters: $e');
    }

    // Initialize Services
    await GardenHiveRepository.initialize();
    await GardenBoxes.initialize(); // Helper boxes for legacy/beds
    await PlantHiveRepository.initialize();

    // Seed Plant Data if empty
    try {
      final plantRepo = PlantHiveRepository();
      if ((await plantRepo.getAllPlants()).isEmpty) {
        print('🌱 Seeding Plant Catalog from JSON...');
        await plantRepo.initializeFromJson();
      }
    } catch (e) {
      print('⚠️ Error seeding plant data: $e');
    }

    // await WeatherService.initialize(); // Uncomment if needed

    // Initialiser l’observateur/trackers d'activités (ActivityObserverService -> ActivityTrackerV3)
    try {
      print('🔔 Initialisation ActivityObserverService / ActivityTrackerV3...');
      await ActivityObserverService().initialize();
      print('✅ ActivityObserverService / ActivityTrackerV3 initialisés');
    } catch (e) {
      print('❌ Erreur initialisation ActivityObserverService: $e');
      // Do not rethrow to avoid blocking the app initialization
    }

    // Validation des données
    await _validatePlantData();
  }

  /// ✅ NOUVEAU - Migration v2.1.0 : Validation du format plants.json
  ///
  /// Détecte automatiquement la version du fichier et affiche les métadonnées.
  /// Valide la cohérence entre metadata.total_plants et la longueur réelle.
  static Future<void> _validatePlantData() async {
    try {
      print('🔎 ========================================');
      print('   Validation des données de plantes');
      print('========================================');

      // Charger le JSON brut
      final jsonString = await rootBundle.loadString('assets/data/plants.json');
      final dynamic jsonData = json.decode(jsonString);

      // Vérifier le format
      if (jsonData is Map<String, dynamic>) {
        // Format v2.1.0+ (structured)
        final schemaVersion = jsonData['schema_version'] as String?;
        final metadata = jsonData['metadata'] as Map<String, dynamic>?;
        final plants = jsonData['plants'] as List?;

        if (schemaVersion != null && metadata != null && plants != null) {
          print('✅ Format v$schemaVersion détecté');
          print('');
          print('📋 Métadonnées :');
          print('   - Version        : ${metadata['version']}');
          print('   - Total plantes  : ${metadata['total_plants']}');
          print('   - Source         : ${metadata['source']}');
          print('   - mise à jour    : ${metadata['updated_at']}');
          print('   - Description    : ${metadata['description']}');

          if (metadata.containsKey('migration_date')) {
            print('   - Date migration : ${metadata['migration_date']}');
            print('   - Migré depuis   : ${metadata['migrated_from']}');
          }

          print('');
          print('🔍 Validation de cohérence :');

          // Validation de cohérence
          final expectedTotal = metadata['total_plants'] as int?;
          final actualTotal = plants.length;

          if (expectedTotal != null) {
            if (actualTotal == expectedTotal) {
              print('   ✅ Cohérence validée : $actualTotal plantes');
            } else {
              print('   ⚠️  INCOHÉRENCE détectée !');
              print('      - Attendu : $expectedTotal plantes');
              print('      - Trouvé  : $actualTotal plantes');
              print(
                  '      - Écart   : ${(actualTotal - expectedTotal).abs()} plante(s)');
            }
          } else {
            print('   ⚠️  Champ total_plants manquant dans les métadonnées');
            print('      - Plantes trouvées : $actualTotal');
          }

          // Vérification de quelques plantes
          if (plants.isNotEmpty) {
            final firstPlant = plants.first as Map<String, dynamic>?;
            if (firstPlant != null) {
              print('');
              print('🌱 Première plante :');
              print('   - ID   : ${firstPlant['id']}');
              print('   - Nom  : ${firstPlant['commonName']}');

              // Vérifier l'absence des champs obsolètes (plantingSeason, harvestSeason)
              final hasPlantingSeason =
                  firstPlant.containsKey('plantingSeason');
              final hasHarvestSeason = firstPlant.containsKey('harvestSeason');

              if (!hasPlantingSeason && !hasHarvestSeason) {
                print('   ✅ Format normalisé (sans champs obsolètes)');
              } else {
                print('   ⚠️  Champs obsolètes détectés :');
                if (hasPlantingSeason) print('      - plantingSeason présent');
                if (hasHarvestSeason) print('      - harvestSeason présent');
              }
            }
          }
        } else {
          print('⚠️  Format Map détecté mais structure invalide');
          print('   - schema_version : ${schemaVersion != null ? "✅" : "❌"}');
          print('   - metadata       : ${metadata != null ? "✅" : "❌"}');
          print('   - plants         : ${plants != null ? "✅" : "❌"}');
        }
      } else if (jsonData is List) {
        // Format Legacy (array-only)
        print('⚠️  Format Legacy détecté (array-only)');
        print('   - Plantes trouvées : ${jsonData.length}');
        print('   - Recommandation   : Migrer vers v2.1.0');
        print('   - Commande         : dart tools/migrate_plants_json.dart');
      } else {
        print('❌ Format JSON invalide détecté !');
        print('   - Type reçu : ${jsonData.runtimeType}');
        print('   - Attendu   : List ou Map<String, dynamic>');
      }

      print('========================================\n');
    } catch (e, stackTrace) {
      print('❌ Erreur lors de la validation des données de plantes:');
      print('   $e');
      print('   StackTrace: $stackTrace');
      print('========================================\n');
      // Ne pas bloquer le démarrage de l'app
    }
  }
}
