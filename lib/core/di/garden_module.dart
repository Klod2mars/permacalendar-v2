import 'dart:async';
import 'package:riverpod/riverpod.dart';
import 'package:hive/hive.dart';
import '../services/aggregation/garden_aggregation_hub.dart';
import '../repositories/garden_hive_repository.dart';
import '../data/migration/garden_data_migration.dart';
import '../services/migration/migration_orchestrator.dart';
import 'package:permacalendar/features/plant_intelligence/data/migration/multi_garden_migration.dart';

/// Module d'injection de dépendances pour le système Garden
///
/// Ce module centralise toutes les dépendances du système de gestion des jardins :
/// - Garden Aggregation Hub (hub central unifié)
/// - Repositories
/// - Adaptateurs de migration
/// - Services de migration
///
/// **Architecture :**
/// ```
/// GardenAggregationHub (Hub Central)
///   ├─→ LegacyGardenAdapter
///   └─→ ModernGardenAdapter
///
/// GardenHiveRepository
///   └─→ Hive (gardens_freezed box)
///
/// GardenMigrationAdapters
///   ├─→ Legacy → Freezed
///   ├─→ V2 → Freezed
///   └─→ Hive → Freezed
/// ```
///
/// **Usage :**
/// ```dart
/// final hub = ref.read(GardenModule.aggregationHubProvider);
/// final repository = ref.read(GardenModule.gardenRepositoryProvider);
/// ```
class GardenModule {
  GardenModule._(); // Private constructor pour empêcher l'instanciation

  // ==================== AGGREGATION HUB ====================

  /// Provider pour le Garden Aggregation Hub (Hub Central Unifié)
  ///
  /// **Architecture First (Prompt 2) :**
  /// Ce hub agrège les données de plusieurs sources (Legacy + Modern)
  /// SANS dépendre de l'Intelligence Végétale pour éviter les cycles.
  ///
  /// **Rôle :**
  /// - Unifie l'accès aux jardins Legacy (GardenHive) et Modern (GardenFreezed)
  /// - Fournit une API cohérente pour récupérer les données jardins/plantes
  /// - Utilisé par PlantIntelligenceRepository comme source de vérité
  ///
  /// **Note importante :**
  /// L'Intelligence Végétale est un CONSOMMATEUR du hub, pas un fournisseur.
  /// Cela évite la dépendance circulaire Hub → Intelligence → Hub.
  static final aggregationHubProvider = Provider<GardenAggregationHub>((ref) {
    // Créer le hub avec Legacy + Modern uniquement
    // L'Intelligence adapter n'est pas ajouté ici pour éviter les cycles
    return GardenAggregationHub();
  });

  // ==================== REPOSITORIES ====================

  /// Provider pour le repository des jardins
  ///
  /// **Responsabilité :**
  /// - CRUD des jardins (GardenFreezed)
  /// - Persistance via Hive
  /// - Accès à la box `gardens_freezed`
  ///
  /// **Migration :**
  /// Utilise GardenFreezed comme modèle unique depuis le Prompt 7.
  /// Les anciens modèles (Legacy, V2, Hive) sont convertis via les adaptateurs.
  static final gardenRepositoryProvider = Provider<GardenHiveRepository>((ref) {
    return GardenHiveRepository();
  });

  // ==================== MIGRATION ====================

  /// Note : GardenMigrationAdapters est une classe avec méthodes statiques uniquement.
  /// Les méthodes sont accessibles directement :
  ///
  /// **Responsabilité (Prompt 7) :**
  /// Convertir les anciens modèles Garden vers GardenFreezed :
  /// - Garden (Legacy, HiveType 0) → GardenFreezed
  /// - Garden (V2, HiveType 10) → GardenFreezed
  /// - GardenHive (HiveType 25) → GardenFreezed
  ///
  /// **Méthodes disponibles :**
  /// - GardenMigrationAdapters.fromLegacy(Garden) → GardenFreezed
  /// - GardenMigrationAdapters.fromV2(GardenV2) → GardenFreezed
  /// - GardenMigrationAdapters.fromHive(GardenHive) → GardenFreezed
  /// - GardenMigrationAdapters.batchMigrateLegacy(List<Garden>) → List<GardenFreezed>
  /// - GardenMigrationAdapters.batchMigrateV2(List<GardenV2>) → List<GardenFreezed>
  /// - GardenMigrationAdapters.batchMigrateHive(List<GardenHive>) → List<GardenFreezed>
  /// - GardenMigrationAdapters.autoMigrate(dynamic) → GardenFreezed

  /// Provider pour le service de migration des données
  ///
  /// **Responsabilité (Prompt 7) :**
  /// Migration automatique de toutes les données Garden depuis 3 sources
  /// vers le modèle unifié GardenFreezed.
  ///
  /// **Fonctionnalités :**
  /// - Migration complète (Legacy + V2 + Hive → Freezed)
  /// - Mode dry-run (simulation sans écriture)
  /// - Backup automatique avant migration
  /// - Vérification d'intégrité post-migration
  /// - Cleanup des anciennes boxes (optionnel)
  /// - Rollback via backup
  ///
  /// **Usage :**
  /// ```dart
  /// final migration = ref.read(GardenModule.dataMigrationProvider);
  ///
  /// // Simulation
  /// final result = await migration.migrateAllGardens(dryRun: true);
  ///
  /// // Migration réelle
  /// if (result.success) {
  ///   final realResult = await migration.migrateAllGardens(
  ///     dryRun: false,
  ///     backupBeforeMigration: true,
  ///     cleanupOldBoxes: false,
  ///   );
  /// }
  /// ```
  static final dataMigrationProvider = Provider<GardenDataMigration>((ref) {
    return GardenDataMigration();
  });

  /// Provider pour le service de migration multi-garden (Prompt A15)
  ///
  /// **Responsabilité :** Orchestrer la migration des jardins depuis les
  /// versions Legacy/V2/Hive et synchroniser les données du sanctuaire (conditions
  /// & recommandations) via `MultiGardenMigration`.
  ///
  /// **Injection Riverpod 3 :** toutes les dépendances proviennent de
  /// `ref.read(...)` (aucun état global).
  static final multiGardenMigrationProvider = Provider<MultiGardenMigration>((ref) {
    final dataMigration = ref.read(GardenModule.dataMigrationProvider);
    final orchestrator = ref.read(migrationOrchestratorProvider);
    return MultiGardenMigration(
      dataMigration: dataMigration,
      orchestrator: orchestrator,
    );
  });

  // ==================== HELPERS ====================

  /// Helper pour ouvrir une box Hive de manière sécurisée
  static Future<({Box? box, bool wasOpen})> _safeOpenBox(String boxName) async {
    // Wrapper toute la fonction dans un try-catch pour garantir que toutes les exceptions sont interceptées
    try {
      // Vérifier si la box est déjà ouverte
      bool isOpen = false;
      try {
        isOpen = Hive.isBoxOpen(boxName);
      } catch (_) {
        // Hive non initialisé ou erreur
        return (box: null, wasOpen: false);
      }

      if (isOpen) {
        try {
          final box = Hive.box(boxName);
          return (box: box, wasOpen: true);
        } catch (_) {
          return (box: null, wasOpen: false);
        }
      } else {
        // Utiliser runZonedGuarded pour intercepter toutes les exceptions, y compris synchrones
        Box? box;
        await runZonedGuarded(() async {
          try {
            box = await Hive.openBox(boxName);
          } catch (e) {
            box = null;
          }
        }, (error, stack) {
          // Intercepter toutes les erreurs non catchées
          box = null;
        });
        
        if (box == null) {
          return (box: null, wasOpen: false);
        }
        return (box: box, wasOpen: false);
      }
    } catch (e, stackTrace) {
      // Intercepter toutes les erreurs, y compris celles propagées de manière asynchrone
      // Retourner une valeur par défaut au lieu de propager l'erreur
      return (box: null, wasOpen: false);
    }
  }

  /// Provider pour vérifier si une migration est nécessaire
  ///
  /// Vérifie la présence de données dans les anciennes boxes :
  /// - gardens (Legacy, HiveType 0)
  /// - gardens_v2 (V2, HiveType 10)
  /// - gardens_hive (Hive, HiveType 25)
  ///
  /// Retourne `true` si au moins une des anciennes boxes contient des données.
  ///
  /// **Note :** Ce provider ouvre temporairement les boxes pour vérifier leur contenu
  /// et les ferme automatiquement pour éviter les fuites de ressources.
  static final isMigrationNeededProvider = FutureProvider<bool>((ref) async {
    Box? legacyBox;
    Box? v2Box;
    Box? hiveBox;
    bool legacyWasOpen = false;
    bool v2WasOpen = false;
    bool hiveWasOpen = false;

    try {
      // Ouvrir les anciennes boxes sans les créer si elles n'existent pas
      // Note: Toutes les opérations Hive sont protégées car Hive peut ne pas être initialisé
      try {
        final legacyResult = await _safeOpenBox('gardens');
        legacyBox = legacyResult.box;
        legacyWasOpen = legacyResult.wasOpen;
      } catch (_) {
        legacyBox = null;
        legacyWasOpen = false;
      }

      try {
        final v2Result = await _safeOpenBox('gardens_v2');
        v2Box = v2Result.box;
        v2WasOpen = v2Result.wasOpen;
      } catch (_) {
        v2Box = null;
        v2WasOpen = false;
      }

      try {
        final hiveResult = await _safeOpenBox('gardens_hive');
        hiveBox = hiveResult.box;
        hiveWasOpen = hiveResult.wasOpen;
      } catch (_) {
        hiveBox = null;
        hiveWasOpen = false;
      }

      // Vérifier si les boxes contiennent des données
      final hasLegacy = legacyBox?.isNotEmpty ?? false;
      final hasV2 = v2Box?.isNotEmpty ?? false;
      final hasHive = hiveBox?.isNotEmpty ?? false;

      return hasLegacy || hasV2 || hasHive;
    } catch (e) {
      // En cas d'erreur, considérer qu'aucune migration n'est nécessaire
      return false;
    } finally {
      // Fermer uniquement les boxes que nous avons ouvertes (pas celles déjà ouvertes)
      try {
        if (legacyBox != null && !legacyWasOpen) {
          await legacyBox.close();
        }
      } catch (_) {
        // Ignorer les erreurs de fermeture
      }

      try {
        if (v2Box != null && !v2WasOpen) {
          await v2Box.close();
        }
      } catch (_) {
        // Ignorer les erreurs de fermeture
      }

      try {
        if (hiveBox != null && !hiveWasOpen) {
          await hiveBox.close();
        }
      } catch (_) {
        // Ignorer les erreurs de fermeture
      }
    }
  });

  /// Provider pour obtenir les statistiques de migration
  ///
  /// Retourne un objet contenant :
  /// - `legacyCount` : Nombre de jardins Legacy
  /// - `v2Count` : Nombre de jardins V2
  /// - `hiveCount` : Nombre de jardins Hive
  /// - `totalOld` : Total à migrer
  /// - `freezedCount` : Nombre de jardins déjà migrés (dans gardens_freezed)
  ///
  /// Utile pour afficher une UI de migration avec progression.
  static final migrationStatsProvider =
      FutureProvider<Map<String, int>>((ref) async {
    try {
      Box? legacyBox;
      Box? v2Box;
      Box? hiveBox;
      Box? freezedBox;

      try {
        legacyBox = await Hive.openBox('gardens');
      } catch (_) {
        // Box n'existe pas ou erreur d'ouverture
      }

      try {
        v2Box = await Hive.openBox('gardens_v2');
      } catch (_) {
        // Box n'existe pas ou erreur d'ouverture
      }

      try {
        hiveBox = await Hive.openBox('gardens_hive');
      } catch (_) {
        // Box n'existe pas ou erreur d'ouverture
      }

      try {
        freezedBox = await Hive.openBox('gardens_freezed');
      } catch (_) {
        // Box n'existe pas ou erreur d'ouverture
      }

      final legacyCount = legacyBox?.length ?? 0;
      final v2Count = v2Box?.length ?? 0;
      final hiveCount = hiveBox?.length ?? 0;
      final freezedCount = freezedBox?.length ?? 0;

      return {
        'legacyCount': legacyCount,
        'v2Count': v2Count,
        'hiveCount': hiveCount,
        'totalOld': legacyCount + v2Count + hiveCount,
        'freezedCount': freezedCount,
      };
    } catch (e) {
      return {
        'legacyCount': 0,
        'v2Count': 0,
        'hiveCount': 0,
        'totalOld': 0,
        'freezedCount': 0,
      };
    }
  });
}

/// Extension pour faciliter l'accès aux providers depuis IntelligenceModule
extension GardenModuleExtensions on Ref {
  /// Raccourci pour accéder au hub d'agrégation
  GardenAggregationHub get gardenHub =>
      read(GardenModule.aggregationHubProvider);

  /// Raccourci pour accéder au repository des jardins
  GardenHiveRepository get gardenRepository =>
      read(GardenModule.gardenRepositoryProvider);
}
