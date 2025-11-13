import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Service de migration des données Hive pour gérer les changements de structure
class DataMigrationService {
  static const String _migrationVersionKey = 'hive_migration_version';
  static const int _currentVersion =
      2; // Version actuelle après les modifications

  /// Vérifie et exécute les migrations nécessaires
  static Future<void> checkAndMigrate() async {
    try {
      // Utiliser Hive pour stocker la version de migration
      final migrationBox = await Hive.openBox('migration_info');
      final currentStoredVersion =
          migrationBox.get(_migrationVersionKey, defaultValue: 0) as int;

      print(
          '🔄 Migration Hive: Version actuelle stockée: $currentStoredVersion, Version cible: $_currentVersion');

      if (currentStoredVersion < _currentVersion) {
        print('⚠️ Migration nécessaire détectée');
        await _performMigration(currentStoredVersion, _currentVersion);
        await migrationBox.put(_migrationVersionKey, _currentVersion);
        print('✅ Migration terminée avec succès');
      } else {
        print('✅ Aucune migration nécessaire');
      }
    } catch (e) {
      print('❌ Erreur lors de la migration: $e');
      // En cas d'erreur de migration, nettoyer et repartir à zéro
      await _emergencyCleanup();
    }
  }

  /// Exécute les migrations étape par étape
  static Future<void> _performMigration(int fromVersion, int toVersion) async {
    for (int version = fromVersion + 1; version <= toVersion; version++) {
      print('🔄 Exécution de la migration vers la version $version');

      switch (version) {
        case 1:
          await _migrateToV1();
          break;
        case 2:
          await _migrateToV2();
          break;
        default:
          print('⚠️ Migration vers la version $version non implémentée');
      }
    }
  }

  /// Migration vers la version 1 (si nécessaire)
  static Future<void> _migrateToV1() async {
    // Migration initiale si nécessaire
    print('📦 Migration vers v1: Initialisation des structures de base');
  }

  /// Migration vers la version 2 (modifications du modèle Planting)
  static Future<void> _migrateToV2() async {
    print('📦 Migration vers v2: Adaptation du modèle Planting');

    try {
      // Sauvegarder les données existantes avant migration
      await _backupExistingData();

      // Nettoyer les boxes incompatibles
      await _cleanIncompatibleBoxes();

      print('✅ Migration v2 terminée');
    } catch (e) {
      print('❌ Erreur lors de la migration v2: $e');
      rethrow;
    }
  }

  /// Sauvegarde les données existantes avant migration
  static Future<void> _backupExistingData() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory(
          '${appDir.path}/hive_backup_${DateTime.now().millisecondsSinceEpoch}');
      await backupDir.create(recursive: true);

      final hiveDir = Directory('${appDir.path}/hive');
      if (await hiveDir.exists()) {
        await hiveDir.rename('${backupDir.path}/hive');
        print('💾 Sauvegarde créée dans: ${backupDir.path}');
      }
    } catch (e) {
      print('⚠️ Impossible de créer une sauvegarde: $e');
    }
  }

  /// Nettoie les boxes incompatibles
  static Future<void> _cleanIncompatibleBoxes() async {
    final boxesToClean = [
      'plantings',
      'gardens',
      'garden_beds',
      'plants',
      'activities',
      'germination_events',
      'growth_cycles',
      'plant_varieties'
    ];

    for (final boxName in boxesToClean) {
      try {
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).close();
        }
        await Hive.deleteBoxFromDisk(boxName);
        print('🗑️ Box $boxName nettoyée');
      } catch (e) {
        print('⚠️ Erreur lors du nettoyage de $boxName: $e');
      }
    }
  }

  /// Nettoyage d'urgence en cas d'échec de migration
  static Future<void> _emergencyCleanup() async {
    print('🚨 Nettoyage d\'urgence des données Hive');
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final hiveDir = Directory('${appDir.path}/hive');

      if (await hiveDir.exists()) {
        await hiveDir.delete(recursive: true);
        print('✅ Nettoyage d\'urgence terminé');
      }
    } catch (e) {
      print('❌ Erreur lors du nettoyage d\'urgence: $e');
    }
  }

  /// Restaure les données depuis une sauvegarde
  static Future<void> restoreFromBackup(String backupPath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final hiveDir = Directory('${appDir.path}/hive');
      final backupDir = Directory(backupPath);

      if (await hiveDir.exists()) {
        await hiveDir.delete(recursive: true);
      }

      if (await backupDir.exists()) {
        await backupDir.rename('${appDir.path}/hive');
        print('✅ Données restaurées depuis: $backupPath');
      } else {
        print('❌ Sauvegarde introuvable: $backupPath');
      }
    } catch (e) {
      print('❌ Erreur lors de la restauration: $e');
    }
  }

  /// Liste les sauvegardes disponibles
  static Future<List<String>> listAvailableBackups() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final appDirContents = await appDir.list().toList();

      return appDirContents
          .where((entity) =>
              entity is Directory && entity.path.contains('hive_backup_'))
          .map((entity) => entity.path)
          .toList();
    } catch (e) {
      print('❌ Erreur lors de la liste des sauvegardes: $e');
      return [];
    }
  }
}


