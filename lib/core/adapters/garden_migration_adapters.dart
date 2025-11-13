import '../models/garden.dart' as legacy;
import '../models/garden_v2.dart' as v2;
import '../models/garden_hive.dart';
import '../models/garden_bed_hive.dart';
import '../models/garden_freezed.dart';

/// Adaptateurs pour migrer les anciens modèles Garden vers GardenFreezed
///
/// Cette classe fournit des méthodes statiques pour convertir les différentes
/// versions de modèles Garden vers le modèle cible GardenFreezed.
///
/// **Modèles pris en charge :**
/// - Garden (legacy) - HiveType(typeId: 0)
/// - Garden (v2) - HiveType(typeId: 10)
/// - GardenHive - HiveType(typeId: 25)
///
/// **Modèle cible :**
/// - GardenFreezed (Freezed + immutable)
///
/// **Usage :**
/// ```dart
/// final legacyGarden = Garden(...);
/// final modernGarden = GardenMigrationAdapters.fromLegacy(legacyGarden);
/// ```
class GardenMigrationAdapters {
  // Constructeur privé pour empêcher l'instanciation
  GardenMigrationAdapters._();

  /// Convertit un Garden (legacy, HiveType 0) vers GardenFreezed
  ///
  /// **Mapping des champs :**
  /// - `id` → `id` (conservé)
  /// - `name` → `name`
  /// - `description` → `description`
  /// - `totalAreaInSquareMeters` → `totalAreaInSquareMeters`
  /// - `location` → `location`
  /// - `createdAt` → `createdAt`
  /// - `updatedAt` → `updatedAt`
  /// - `imageUrl` → `imageUrl`
  /// - `metadata` → `metadata`
  /// - `isActive` → `isActive`
  ///
  /// **Exemple :**
  /// ```dart
  /// final legacyGarden = Garden(
  ///   name: 'Mon Jardin',
  ///   description: 'Un beau jardin',
  ///   totalAreaInSquareMeters: 100.0,
  ///   location: 'Paris',
  /// );
  /// final modernGarden = GardenMigrationAdapters.fromLegacy(legacyGarden);
  /// ```
  static GardenFreezed fromLegacy(legacy.Garden legacyGarden) {
    return GardenFreezed(
      id: legacyGarden.id,
      name: legacyGarden.name,
      description: legacyGarden.description,
      totalAreaInSquareMeters: legacyGarden.totalAreaInSquareMeters,
      location: legacyGarden.location,
      createdAt: legacyGarden.createdAt,
      updatedAt: legacyGarden.updatedAt,
      imageUrl: legacyGarden.imageUrl,
      metadata: Map<String, dynamic>.from(legacyGarden.metadata),
      isActive: legacyGarden.isActive,
    );
  }

  /// Convertit un GardenFreezed vers Garden (legacy) pour compatibilité
  ///
  /// **Note :** Cette conversion est nécessaire pour maintenir la compatibilité
  /// avec le code existant qui utilise encore Garden (legacy).
  ///
  /// **Perte de données :** Aucune
  static legacy.Garden toLegacy(GardenFreezed gardenFreezed) {
    return legacy.Garden(
      id: gardenFreezed.id,
      name: gardenFreezed.name,
      description: gardenFreezed.description ?? '',
      totalAreaInSquareMeters: gardenFreezed.totalAreaInSquareMeters,
      location: gardenFreezed.location,
      createdAt: gardenFreezed.createdAt,
      updatedAt: gardenFreezed.updatedAt,
      imageUrl: gardenFreezed.imageUrl,
      metadata: Map<String, dynamic>.from(gardenFreezed.metadata),
      isActive: gardenFreezed.isActive,
    );
  }

  /// Convertit un Garden (v2, HiveType 10) vers GardenFreezed
  ///
  /// **Mapping des champs :**
  /// - `id` → `id` (conservé)
  /// - `name` → `name`
  /// - `description` → `description`
  /// - `location` → `location`
  /// - `createdDate` → `createdAt`
  /// - `gardenBeds` → `metadata['gardenBedIds']` (liste des IDs)
  ///
  /// **Valeurs par défaut :**
  /// - `totalAreaInSquareMeters` = 0.0 (sera recalculé plus tard)
  /// - `updatedAt` = `createdDate`
  /// - `imageUrl` = null
  /// - `isActive` = true
  ///
  /// **Note :** GardenV2 ne stocke que les IDs des parcelles, pas leur surface.
  /// La surface totale devra être recalculée après la migration complète.
  static GardenFreezed fromV2(v2.Garden gardenV2) {
    return GardenFreezed(
      id: gardenV2.id,
      name: gardenV2.name,
      description: gardenV2.description,
      totalAreaInSquareMeters: 0.0, // Sera recalculé après migration des beds
      location: gardenV2.location,
      createdAt: gardenV2.createdDate,
      updatedAt: gardenV2.createdDate, // Pas de updatedAt dans v2
      imageUrl: null, // Pas disponible dans v2
      metadata: {
        'gardenBedIds': List<String>.from(gardenV2.gardenBeds),
        'migratedFrom': 'GardenV2',
        'migrationDate': DateTime.now().toIso8601String(),
      },
      isActive: true, // Valeur par défaut
    );
  }

  /// Convertit un GardenFreezed vers Garden (v2) pour compatibilité
  ///
  /// **Note :** Cette conversion est nécessaire pour maintenir la compatibilité
  /// avec le code existant qui utilise encore Garden (v2).
  ///
  /// **Perte de données :**
  /// - `totalAreaInSquareMeters` (non stocké dans v2)
  /// - `updatedAt` (non stocké dans v2)
  /// - `imageUrl` (non stocké dans v2)
  /// - `metadata` (sauf gardenBedIds)
  /// - `isActive` (non stocké dans v2)
  static v2.Garden toV2(GardenFreezed gardenFreezed) {
    // Récupérer les gardenBedIds depuis metadata ou utiliser liste vide
    final gardenBedIds =
        gardenFreezed.metadata['gardenBedIds'] as List<dynamic>?;
    final ids = gardenBedIds?.cast<String>() ?? <String>[];

    return v2.Garden(
      id: gardenFreezed.id,
      name: gardenFreezed.name,
      description: gardenFreezed.description ?? '',
      location: gardenFreezed.location,
      createdDate: gardenFreezed.createdAt,
      gardenBeds: ids,
    );
  }

  /// Convertit un GardenHive (HiveType 25) vers GardenFreezed
  ///
  /// **Note :** GardenHive a déjà une méthode `toGardenFreezed()` native.
  /// Cet adaptateur fournit une interface unifiée et ajoute des métadonnées.
  ///
  /// **Mapping des champs :**
  /// - `id` → `id`
  /// - `name` → `name`
  /// - `description` → `description`
  /// - `createdDate` → `createdAt`
  /// - `gardenBeds` → Surface totale calculée + IDs en metadata
  ///
  /// **Calculs effectués :**
  /// - `totalAreaInSquareMeters` = somme des surfaces des parcelles
  /// - Extraction des IDs de parcelles
  static GardenFreezed fromHive(GardenHive gardenHive) {
    // Calculer la surface totale depuis les parcelles
    final totalArea = gardenHive.gardenBeds.fold<double>(
      0.0,
      (sum, bed) => sum + bed.sizeInSquareMeters,
    );

    // Extraire les IDs des parcelles
    final gardenBedIds = gardenHive.gardenBeds.map((bed) => bed.id).toList();

    return GardenFreezed(
      id: gardenHive.id,
      name: gardenHive.name,
      description: gardenHive.description,
      totalAreaInSquareMeters: totalArea,
      location: '', // GardenHive n'a pas de location
      createdAt: gardenHive.createdDate,
      updatedAt: DateTime.now(), // Pas de updatedAt dans GardenHive
      imageUrl: null, // Pas disponible dans GardenHive
      metadata: {
        'gardenBedIds': gardenBedIds,
        'totalPlantings': gardenHive.totalPlantings,
        'migratedFrom': 'GardenHive',
        'migrationDate': DateTime.now().toIso8601String(),
      },
      isActive: true,
    );
  }

  /// Convertit un GardenFreezed vers GardenHive
  ///
  /// **Note :** Cette conversion nécessite la liste des GardenBedHive complets.
  /// Si non fournie, crée un GardenHive vide.
  ///
  /// **Perte de données :**
  /// - `totalAreaInSquareMeters` (recalculé depuis les beds)
  /// - `location` (non stocké dans GardenHive)
  /// - `updatedAt` (non stocké dans GardenHive)
  /// - `imageUrl` (non stocké dans GardenHive)
  /// - `isActive` (non stocké dans GardenHive)
  static GardenHive toHive(GardenFreezed gardenFreezed,
      {List<GardenBedHive>? gardenBeds}) {
    return GardenHive(
      id: gardenFreezed.id,
      name: gardenFreezed.name,
      description: gardenFreezed.description ?? '',
      createdDate: gardenFreezed.createdAt,
      gardenBeds: gardenBeds ?? [],
    );
  }

  /// Migration batch : Convertit une liste de jardins legacy vers GardenFreezed
  ///
  /// **Usage :**
  /// ```dart
  /// final legacyGardens = await getLegacyGardens();
  /// final modernGardens = GardenMigrationAdapters.batchMigrateLegacy(legacyGardens);
  /// ```
  static List<GardenFreezed> batchMigrateLegacy(List<legacy.Garden> gardens) {
    return gardens.map((garden) => fromLegacy(garden)).toList();
  }

  /// Migration batch : Convertit une liste de jardins v2 vers GardenFreezed
  static List<GardenFreezed> batchMigrateV2(List<v2.Garden> gardens) {
    return gardens.map((garden) => fromV2(garden)).toList();
  }

  /// Migration batch : Convertit une liste de jardins Hive vers GardenFreezed
  static List<GardenFreezed> batchMigrateHive(List<GardenHive> gardens) {
    return gardens.map((garden) => fromHive(garden)).toList();
  }

  /// Détecte le type de modèle Garden à partir d'un Map JSON
  ///
  /// Utile pour les migrations automatiques depuis des données sérialisées.
  ///
  /// **Détection basée sur les champs présents :**
  /// - Legacy : `totalAreaInSquareMeters`, `updatedAt`
  /// - V2 : `createdDate` (DateTime), `gardenBeds` (List<String>)
  /// - Hive : `gardenBeds` (List<Object>), pas de `location`
  /// - Freezed : Structure Freezed complète
  ///
  /// **Retourne :** 'legacy', 'v2', 'hive', 'freezed', ou 'unknown'
  static String detectGardenModelType(Map<String, dynamic> json) {
    // Freezed : a toutes les propriétés modernes
    if (json.containsKey('totalAreaInSquareMeters') &&
        json.containsKey('location') &&
        json.containsKey('createdAt') &&
        json.containsKey('updatedAt') &&
        json.containsKey('metadata') &&
        json.containsKey('isActive')) {
      return 'freezed';
    }

    // Legacy : a totalAreaInSquareMeters et updatedAt
    if (json.containsKey('totalAreaInSquareMeters') &&
        json.containsKey('updatedAt')) {
      return 'legacy';
    }

    // V2 : a createdDate et gardenBeds (list of strings)
    if (json.containsKey('createdDate') && json.containsKey('gardenBeds')) {
      final gardenBeds = json['gardenBeds'];
      if (gardenBeds is List &&
          (gardenBeds.isEmpty || gardenBeds.first is String)) {
        return 'v2';
      }
    }

    // Hive : a createdDate et gardenBeds (list of objects)
    if (json.containsKey('createdDate') && json.containsKey('gardenBeds')) {
      final gardenBeds = json['gardenBeds'];
      if (gardenBeds is List &&
          gardenBeds.isNotEmpty &&
          gardenBeds.first is Map) {
        return 'hive';
      }
    }

    return 'unknown';
  }

  /// Migration automatique depuis n'importe quel modèle vers GardenFreezed
  ///
  /// Détecte automatiquement le type de modèle et applique la conversion appropriée.
  ///
  /// **Usage :**
  /// ```dart
  /// final json = await loadGardenFromDatabase();
  /// final modernGarden = GardenMigrationAdapters.autoMigrate(json);
  /// ```
  ///
  /// **Throws :** Exception si le type de modèle est inconnu
  static GardenFreezed autoMigrate(Map<String, dynamic> json) {
    final modelType = detectGardenModelType(json);

    switch (modelType) {
      case 'freezed':
        return GardenFreezed.fromJson(json);
      case 'legacy':
        return fromLegacy(legacy.Garden.fromJson(json));
      case 'v2':
        return fromV2(v2.Garden.fromJson(json));
      case 'hive':
        return fromHive(GardenHive.fromJson(json));
      default:
        throw Exception(
            'Type de modèle Garden inconnu : $modelType. JSON: $json');
    }
  }

  /// Statistiques de migration
  ///
  /// Retourne des informations sur les champs conservés/perdus lors de la migration.
  ///
  /// **Usage :**
  /// ```dart
  /// final stats = GardenMigrationAdapters.getMigrationStats('v2', 'freezed');
  /// print('Champs perdus: ${stats['fieldsLost']}');
  /// ```
  static Map<String, dynamic> getMigrationStats(
      String fromType, String toType) {
    if (fromType == 'v2' && toType == 'freezed') {
      return {
        'fieldsLost': [
          'totalAreaInSquareMeters',
          'updatedAt',
          'imageUrl',
          'isActive'
        ],
        'fieldsGained': ['location', 'metadata', 'imageUrl', 'isActive'],
        'fieldsPreserved': [
          'id',
          'name',
          'description',
          'createdAt/createdDate',
          'gardenBeds'
        ],
        'dataLoss': 'moderate',
        'recommendation':
            'Recalculer totalAreaInSquareMeters après migration des beds',
      };
    }

    if (fromType == 'legacy' && toType == 'freezed') {
      return {
        'fieldsLost': [],
        'fieldsGained': [],
        'fieldsPreserved': [
          'id',
          'name',
          'description',
          'location',
          'totalAreaInSquareMeters',
          'createdAt',
          'updatedAt',
          'imageUrl',
          'metadata',
          'isActive'
        ],
        'dataLoss': 'none',
        'recommendation': 'Migration sans perte de données',
      };
    }

    if (fromType == 'hive' && toType == 'freezed') {
      return {
        'fieldsLost': [],
        'fieldsGained': ['location', 'imageUrl'],
        'fieldsPreserved': [
          'id',
          'name',
          'description',
          'createdDate/createdAt',
          'gardenBeds'
        ],
        'dataLoss': 'low',
        'recommendation': 'totalAreaInSquareMeters calculé automatiquement',
      };
    }

    return {
      'error': 'Type de migration non documenté',
    };
  }
}


