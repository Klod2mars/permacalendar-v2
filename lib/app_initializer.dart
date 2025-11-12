import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Imports des modèles et adaptateurs
import 'core/models/activity.dart';
import 'core/models/activity_v3.dart';
import 'core/models/garden.dart';
import 'core/models/garden_bed.dart';
import 'core/models/planting.dart';
import 'core/models/plant.dart';
import 'core/models/plant_variety.dart';
import 'core/models/growth_cycle.dart';
import 'core/models/germination_event.dart';
import 'features/plant_catalog/data/models/plant_hive.dart';
import 'features/plant_intelligence/domain/entities/plant_condition_hive.dart';
import 'features/plant_intelligence/domain/entities/plant_condition.dart';
import 'features/plant_intelligence/domain/entities/weather_condition_hive.dart';
import 'features/plant_intelligence/domain/entities/recommendation_hive.dart';
import 'features/plant_intelligence/domain/entities/recommendation.dart';
import 'features/plant_intelligence/domain/entities/garden_context_hive.dart';

// Imports des adaptateurs Hive
import 'core/models/garden_hive.dart';
import 'core/models/garden_bed_hive.dart';
import 'core/models/planting_hive.dart';

// Imports des services
import 'core/services/environment_service.dart';
import 'core/data/hive/hive_service.dart';
import 'core/services/activity_tracker_v3.dart';
import 'core/services/activity_observer_service.dart';
import 'core/services/garden_event_observer_service.dart';
import 'core/services/intelligence_auto_notifier.dart';
import 'features/plant_intelligence/data/services/notification_initialization.dart';

// ✅ NOUVEAU - Prompt 8 : Modules d'injection de dépendances
import 'core/di/intelligence_module.dart';
import 'package:riverpod/riverpod.dart';

// Imports des repositories
import 'core/repositories/garden_hive_repository.dart';
import 'features/plant_catalog/data/repositories/plant_hive_repository.dart';

// Imports des boxes
import 'core/data/hive/garden_boxes.dart';
import 'core/data/hive/plant_boxes.dart';
import 'core/data/hive/data_migration_service.dart';

// Note: Les boxes d'Intelligence Végétale utilisent des types dynamiques
// car la conversion Hive est gérée dans les DataSources

class AppInitializer {
  /// Force un nettoyage complet de toutes les données Hive
  static Future<void> forceCleanHiveData() async {
    print('🧹 Nettoyage forcé de toutes les données Hive...');
    await HiveService.deleteAllBoxes();
    print('✅ Nettoyage terminé');
  }

  static Future<void> initialize() async {
    // Charger les variables d'environnement
    await dotenv.load(fileName: '.env');

    // Initialiser les services d'environnement avec les variables chargées
    await EnvironmentService.initialize();

    // Configurer l'activation des fonctionnalités sociales
    EnvironmentService.isSocialEnabled =
        dotenv.env['SOCIAL_ENABLED']?.toLowerCase() == 'true';

    // ✅ NOUVEAU : Valider les données de plantes au démarrage
    await _validatePlantData();

    // ✅ CRITIQUE : Initialiser Hive avant tout
    await Hive.initFlutter();

    // 🔄 NOUVEAU : Vérifier et exécuter les migrations
    await DataMigrationService.checkAndMigrate();

    // Enregistrer les adaptateurs Hive
    await _registerHiveAdapters();

    // Ouvrir les boxes Hive
    await _openHiveBoxes();

    // Initialiser les services conditionnels
    await _initializeConditionalServices();
  }

  static Future<void> _registerHiveAdapters() async {
    // Enregistrer les adaptateurs pour les modèles de données
    // Les adaptateurs seront générés par build_runner

    // Adaptateurs pour les jardins et parcelles
    Hive.registerAdapter(GardenAdapter());
    Hive.registerAdapter(GardenBedAdapter());
    Hive.registerAdapter(PlantingAdapter());

    // Adaptateurs Hive pour les modèles v2
    Hive.registerAdapter(GardenHiveAdapter());
    Hive.registerAdapter(GardenBedHiveAdapter());
    Hive.registerAdapter(PlantingHiveAdapter());

    // Adaptateurs pour les plantes
    Hive.registerAdapter(PlantAdapter());
    Hive.registerAdapter(PlantVarietyAdapter());
    Hive.registerAdapter(GrowthCycleAdapter());

    // Adaptateur pour PlantHive (catalogue plantes)
    Hive.registerAdapter(PlantHiveAdapter());

    // Adaptateurs pour les activités
    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(ActivityTypeAdapter());
    Hive.registerAdapter(EntityTypeAdapter());
    Hive.registerAdapter(ActivityV3Adapter());

    // Adaptateur pour les événements de germination
    Hive.registerAdapter(GerminationEventAdapter());

    // Adaptateurs pour l'Intelligence Végétale
    Hive.registerAdapter(PlantConditionHiveAdapter());
    Hive.registerAdapter(WeatherConditionHiveAdapter());
    Hive.registerAdapter(RecommendationHiveAdapter());
    Hive.registerAdapter(GardenContextHiveAdapter());

    // Adaptateurs sociaux (désactivés)
    // if (EnvironmentService.isSocialEnabled) {
    //   Hive.registerAdapter(UserProfileAdapter());
    //   Hive.registerAdapter(CommunityPostAdapter());
    // }
  }

  static Future<void> _openHiveBoxes() async {
    try {
      // Ouvrir les boxes principales
      await GardenBoxes.initialize();
      await PlantBoxes.initialize();

      // Initialiser le service HiveService qui gère toutes les boxes
      await HiveService.initialize();

      // Initialiser le nouveau repository Hive
      await GardenHiveRepository.initialize();

      // Initialiser le PlantHiveRepository et charger depuis plants.json
      await PlantHiveRepository.initialize();
      final plantRepository = PlantHiveRepository();
      await plantRepository.initializeFromJson();

      // ✅ NOUVEAU : Initialiser les boxes pour l'Intelligence Végétale
      await _initializePlantIntelligenceBoxes();

      print('✅ Toutes les boxes Hive ont été initialisées avec succès');
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation des boxes Hive: $e');
      print('🔄 Tentative de nettoyage complet des données Hive...');

      // En cas d'erreur, nettoyer complètement et réessayer
      await HiveService.deleteAllBoxes();

      // Réessayer l'initialisation
      try {
        await GardenBoxes.initialize();
        await PlantBoxes.initialize();
        await HiveService.initialize();
        await GardenHiveRepository.initialize();
        await PlantHiveRepository.initialize();
        final plantRepository = PlantHiveRepository();
        await plantRepository.initializeFromJson();

        // Réinitialiser les boxes d'intelligence végétale
        await _initializePlantIntelligenceBoxes();

        print('✅ Réinitialisation réussie après nettoyage');
      } catch (retryError) {
        print('❌ Échec de la réinitialisation: $retryError');
        rethrow;
      }
    }

    // Boxes sociales (désactivées)
    // if (EnvironmentService.isSocialEnabled) {
    //   await SocialBoxes.initialize();
    // }
  }

  /// Initialise les boxes Hive pour l'Intelligence Végétale
  static Future<void> _initializePlantIntelligenceBoxes() async {
    try {
      print('🌱 Initialisation des boxes Intelligence Végétale...');

      // Ouvrir les boxes nécessaires pour l'intelligence végétale avec les types Hive
      await Hive.openBox<PlantCondition>('plant_conditions');
      await Hive.openBox<WeatherConditionHive>('weather_conditions');
      await Hive.openBox('weather_forecasts');
      await Hive.openBox<Recommendation>('recommendations');
      await Hive.openBox('notification_alerts');
      await Hive.openBox('plant_analyses');
      await Hive.openBox('active_alerts');

      // Boxes pour la lutte biologique
      await Hive.openBox<Map>('pest_observations');
      await Hive.openBox<Map>('bio_control_recommendations');

      print('✅ Boxes Intelligence Végétale initialisées avec succès');
      print('✅ Boxes Lutte Biologique initialisées avec succès');
    } catch (e) {
      print('❌ Erreur initialisation boxes Intelligence Végétale: $e');
      rethrow;
    }
  }

  static Future<void> _initializeConditionalServices() async {
    print('🔧 Début initialisation des services conditionnels...');

    // ✅ NOUVEAU : Initialiser ActivityTrackerV3
    try {
      print('🔧 Initialisation ActivityTrackerV3...');
      await ActivityTrackerV3().initialize();
      print('✅ ActivityTrackerV3 initialisé avec succès');
    } catch (e) {
      print('❌ Erreur initialisation ActivityTrackerV3: $e');
    }

    // ✅ NOUVEAU : Initialiser ActivityObserverService
    try {
      print('🔧 Initialisation ActivityObserverService...');
      await ActivityObserverService().initialize();
      print('✅ ActivityObserverService initialisé avec succès');
    } catch (e) {
      print('❌ Erreur initialisation ActivityObserverService: $e');
    }

    // ✅ NOUVEAU - Phase 1 : Initialiser le système de notifications
    try {
      print('🔔 Initialisation système de notifications...');
      await NotificationInitialization.initialize();
      print('✅ Système de notifications initialisé');
    } catch (e) {
      print('⚠️ Erreur initialisation notifications: $e');
      print('   Les notifications ne fonctionneront pas');
    }

    // ✅ REFACTORÉ Prompt 8 : Initialiser Intelligence Végétale via modules DI
    try {
      print('🔧 Initialisation Intelligence Végétale...');

      // Créer un conteneur Riverpod temporaire pour l'initialisation
      final container = ProviderContainer();

      // Récupérer l'orchestrateur depuis le module DI
      // Toutes les dépendances sont gérées automatiquement par les modules
      final orchestrator =
          container.read(IntelligenceModule.orchestratorProvider);

      // Initialiser le service d'observation avec l'orchestrateur
      GardenEventObserverService.instance.initialize(
        orchestrator: orchestrator,
      );

      // ✅ NOUVEAU - Phase 1 : Notifications automatiques
      // Initialiser le service de notifications automatiques
      try {
        print('🔔 Initialisation IntelligenceAutoNotifier...');
        container.read(intelligenceAutoNotifierProvider);
        print('✅ IntelligenceAutoNotifier initialisé');
        print('   - Écoute des changements de conditions: Active');
        print('   - Génération automatique d\'alertes: Active');
      } catch (e) {
        print('⚠️ Avertissement IntelligenceAutoNotifier: $e');
        print('   Les notifications automatiques ne fonctionneront pas');
      }

      print('✅ Intelligence Végétale initialisée avec succès');
      print('   - Orchestrateur: Créé via IntelligenceModule');
      print('   - Dépendances: Injectées automatiquement (DI)');
      print('   - EventBus: Écoute active');
      print('   - Analyses automatiques: Activées');
      print('   - Notifications automatiques: Activées');

      // Note: Le conteneur est conservé en mémoire pour la durée de l'application
      // Les dépendances créées restent accessibles via les providers globaux
    } catch (e, stackTrace) {
      print('❌ Erreur initialisation Intelligence Végétale: $e');
      print('   StackTrace: $stackTrace');
      print('   L\'Intelligence Végétale ne fonctionnera pas correctement');
    }

    // Services toujours actifs (désactivés temporairement)
    // await NotificationService.initialize();

    // Services conditionnels (désactivés pour l'instant)
    // if (EnvironmentService.isWeatherEnabled) {
    //   await WeatherService.initialize();
    // }

    // Services sociaux (désactivés)
    // if (EnvironmentService.isSocialEnabled) {
    //   await SocialService.initialize();
    // }
  }

  /// ✅ NOUVEAU - Migration v2.1.0 : Validation du format plants.json
  ///
  /// Détecte automatiquement la version du fichier et affiche les métadonnées.
  /// Valide la cohérence entre metadata.total_plants et la longueur réelle.
  static Future<void> _validatePlantData() async {
    try {
      print('🔍 ========================================');
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
          print('   - Mise à jour    : ${metadata['updated_at']}');
          print('   - Description    : ${metadata['description']}');

          if (metadata.containsKey('migration_date')) {
            print('   - Date migration : ${metadata['migration_date']}');
            print('   - Migré depuis   : ${metadata['migrated_from']}');
          }

          print('');
          print('🔎 Validation de cohérence :');

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

