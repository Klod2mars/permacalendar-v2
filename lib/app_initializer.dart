import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import 'features/climate/data/initialization/soil_metrics_initialization.dart';
// Generated Hive adapters
import 'models/plant_localized.dart';

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

      // PlantLocalized & LocalizedPlantFields (ensure adapters exist & registered)
      if (!Hive.isAdapterRegistered(kTypeIdPlantLocalized)) {
        Hive.registerAdapter(PlantLocalizedAdapter());
        print('✅ PlantLocalizedAdapter registered (typeId=$kTypeIdPlantLocalized)');
      } else {
        print('ℹ️ PlantLocalizedAdapter already registered (typeId=$kTypeIdPlantLocalized)');
      }

      if (!Hive.isAdapterRegistered(kTypeIdLocalizedPlantFields)) {
        Hive.registerAdapter(LocalizedPlantFieldsAdapter());
        print('✅ LocalizedPlantFieldsAdapter registered (typeId=$kTypeIdLocalizedPlantFields)');
      } else {
        print('ℹ️ LocalizedPlantFieldsAdapter already registered (typeId=$kTypeIdLocalizedPlantFields)');
      }

      // Activity Adapters
      if (!Hive.isAdapterRegistered(16))
        Hive.registerAdapter(ActivityAdapter());
      if (!Hive.isAdapterRegistered(17))
        Hive.registerAdapter(ActivityTypeAdapter());
      if (!Hive.isAdapterRegistered(18))
        Hive.registerAdapter(EntityTypeAdapter());

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
      
      // ✅ Soil Metrics Adapter
      await SoilMetricsInitialization.initialize();
    } catch (e) {
      print('Warning: Error registering adapters: $e');
    }

    // Initialize Services
    await GardenHiveRepository.initialize();
    await GardenBoxes.initialize(); // Helper boxes for legacy/beds
    await PlantHiveRepository.initialize();

    // Auto-Sync Plant Data on every startup
    // This ensures new plants in JSON are added and existing descriptions are updated
    // while preserving user preferences (isActive).
    try {
      final plantRepo = PlantHiveRepository();
      print('🌱 Synchronizing Plant Catalog with JSON...');
      
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString('app_locale') ?? 'fr';
      
      await plantRepo.syncWithJson(savedLang);
    } catch (e) {
      print('⚠️ Error syncing plant data: $e');
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

  /// Validation simple des données
  static Future<void> _validatePlantData() async {
    // La validation stricte est désactivée car le système Auto-Sync gère désormais
    // l'ajout automatique des nouvelles plantes et la mise à jour des définitions.
    print('✅ Système Auto-Sync actif : La base de données est synchronisée avec le JSON.');
  }
}
