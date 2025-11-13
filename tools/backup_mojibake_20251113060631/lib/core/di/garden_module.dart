import 'package:riverpod/riverpod.dart';
import 'package:hive/hive.dart';
import '../services/aggregation/garden_aggregation_hub.dart';
import '../repositories/garden_hive_repository.dart';
import '../data/migration/garden_data_migration.dart';

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

  // ==================== HELPERS ====================

  /// Provider pour vérifier si une migration est nécessaire
  ///
  /// Vérifie la présence de données dans les anciennes boxes :
  /// - gardens (Legacy, HiveType 0)
  /// - gardens_v2 (V2, HiveType 10)
  /// - gardens_hive (Hive, HiveType 25)
  ///
  /// Retourne `true` si au moins une des anciennes boxes contient des données.
  static final isMigrationNeededProvider = FutureProvider<bool>((ref) async {
    try {
      // Ouvrir les anciennes boxes sans les créer
      final legacyBox = await Hive.openBox('gardens').catchError((_) => null);
      final v2Box = await Hive.openBox('gardens_v2').catchError((_) => null);
      final hiveBox =
          await Hive.openBox('gardens_hive').catchError((_) => null);

      final hasLegacy = legacyBox.isNotEmpty;
      final hasV2 = v2Box.isNotEmpty;
      final hasHive = hiveBox.isNotEmpty;

      return hasLegacy || hasV2 || hasHive;
    } catch (e) {
      // En cas d'erreur, considérer qu'aucune migration n'est nécessaire
      return false;
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
      final legacyBox = await Hive.openBox('gardens').catchError((_) => null);
      final v2Box = await Hive.openBox('gardens_v2').catchError((_) => null);
      final hiveBox =
          await Hive.openBox('gardens_hive').catchError((_) => null);
      final freezedBox =
          await Hive.openBox('gardens_freezed').catchError((_) => null);

      final legacyCount = legacyBox.length ?? 0;
      final v2Count = v2Box.length ?? 0;
      final hiveCount = hiveBox.length ?? 0;
      final freezedCount = freezedBox.length ?? 0;

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


