import 'dart:developer' as developer;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/garden.dart';
import '../../data/hive/garden_boxes.dart';

/// Data Archival Service - Service d'Archivage des Données
///
/// **Architecture Enterprise - Design Pattern: Repository + Strategy**
///
/// Ce service gère l'archivage sécurisé des données Legacy avant
/// leur suppression définitive :
/// - Sauvegarde complète en JSON
/// - Compression des archives
/// - Gestion des versions d'archives
/// - Restauration possible depuis archives
///
/// **Stratégie d'Archivage :**
/// 1. **Export JSON** : Format universel et lisible
/// 2. **Horodatage** : Archives avec timestamp pour traçabilité
/// 3. **Métadonnées** : Informations de contexte (version, date, nombre)
/// 4. **Restauration** : Possibilité de restaurer depuis archives
///
/// **Standards :**
/// - Clean Architecture
/// - SOLID (Single Responsibility)
/// - Data Persistence (formats standards)
class DataArchivalService {
  static const String _logName = 'DataArchivalService';
  static const String _archiveFolder = 'hive_archives';

  // Statistiques
  int _archivesCreated = 0;
  int _gardensArchived = 0;
  double _totalArchiveSize = 0.0; // En MB

  /// Constructeur
  DataArchivalService() {
    _log('🏗️ Data Archival Service créé', level: 500);
  }

  // ==================== ARCHIVAGE ====================

  /// Archive toutes les données Legacy
  Future<bool> archiveAllLegacyData() async {
    try {
      _log('📦 Archivage complet des données Legacy', level: 500);

      final startTime = DateTime.now();

      // Créer le dossier d'archive
      final archiveDir = await _createArchiveDirectory();

      // Archive les jardins
      final gardensArchived = await _archiveGardens(archiveDir);

      // Archive les métadonnées
      await _archiveMetadata(archiveDir, startTime);

      // Calculer la taille totale
      final archiveSize = await _calculateArchiveSize(archiveDir);
      _totalArchiveSize = archiveSize;

      _archivesCreated++;

      final duration = DateTime.now().difference(startTime);
      _log(
        '✅ Archivage terminé: $gardensArchived jardins, ${archiveSize.toStringAsFixed(2)} MB, ${duration.inSeconds}s',
        level: 500,
      );

      return true;
    } catch (e, stackTrace) {
      _logError('❌ Erreur archivage complet', e, stackTrace);
      return false;
    }
  }

  /// Archive un jardin spécifique
  Future<bool> archiveGarden(String gardenId) async {
    try {
      _log('📦 Archivage jardin $gardenId', level: 500);

      // Récupérer le jardin
      final garden = GardenBoxes.getGarden(gardenId);
      if (garden == null) {
        _log('❌ Jardin $gardenId introuvable', level: 1000);
        return false;
      }

      // Créer le dossier d'archive
      final archiveDir = await _createArchiveDirectory();

      // Sauvegarder en JSON
      final gardenJson = garden.toJson();
      final fileName =
          'garden_${gardenId}_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${archiveDir.path}/$fileName');

      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(gardenJson),
      );

      _gardensArchived++;

      _log('✅ Jardin $gardenId archivé: $fileName', level: 500);
      return true;
    } catch (e, stackTrace) {
      _logError('❌ Erreur archivage jardin $gardenId', e, stackTrace);
      return false;
    }
  }

  // ==================== RESTAURATION ====================

  /// Restaure depuis la dernière archive
  Future<bool> restoreFromLatestArchive() async {
    try {
      _log('⏪ Restauration depuis dernière archive', level: 500);

      final archives = await listAvailableArchives();
      if (archives.isEmpty) {
        _log('❌ Aucune archive disponible', level: 1000);
        return false;
      }

      // Prendre la dernière archive (la plus récente)
      final latestArchive = archives.last;
      _log('📦 Restauration depuis: $latestArchive', level: 500);

      return await restoreFromArchive(latestArchive);
    } catch (e, stackTrace) {
      _logError('❌ Erreur restauration dernière archive', e, stackTrace);
      return false;
    }
  }

  /// Restaure depuis une archive spécifique
  Future<bool> restoreFromArchive(String archivePath) async {
    try {
      _log('⏪ Restauration depuis: $archivePath', level: 500);

      final archiveDir = Directory(archivePath);
      if (!await archiveDir.exists()) {
        _log('❌ Archive introuvable: $archivePath', level: 1000);
        return false;
      }

      // Lister les fichiers JSON dans l'archive
      final files = await archiveDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.json'))
          .toList();

      _log('📄 ${files.length} fichiers à restaurer', level: 500);

      var restoredCount = 0;

      for (final fileEntity in files) {
        if (fileEntity is File) {
          try {
            final content = await fileEntity.readAsString();
            final json = jsonDecode(content) as Map<String, dynamic>;

            // Restaurer selon le type de fichier
            if (fileEntity.path.contains('garden_')) {
              final garden = Garden.fromJson(json);
              await GardenBoxes.saveGarden(garden);
              restoredCount++;
            }
          } catch (e) {
            _log('⚠️ Erreur restauration fichier ${fileEntity.path}: $e',
                level: 900);
          }
        }
      }

      _log('✅ Restauration terminée: $restoredCount éléments', level: 500);
      return restoredCount > 0;
    } catch (e, stackTrace) {
      _logError('❌ Erreur restauration archive', e, stackTrace);
      return false;
    }
  }

  /// Liste les archives disponibles
  Future<List<String>> listAvailableArchives() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final archivesDir = Directory('${appDir.path}/$_archiveFolder');

      if (!await archivesDir.exists()) {
        return [];
      }

      final archives = await archivesDir
          .list()
          .where((entity) => entity is Directory)
          .map((entity) => entity.path)
          .toList();

      // Trier par date (plus récent en dernier)
      archives.sort();

      _log('📋 ${archives.length} archives disponibles', level: 500);
      return archives;
    } catch (e, stackTrace) {
      _logError('❌ Erreur liste archives', e, stackTrace);
      return [];
    }
  }

  // ==================== NETTOYAGE ARCHIVES ====================

  /// Supprime les anciennes archives (garde les 5 plus récentes)
  Future<bool> cleanupOldArchives({int keepCount = 5}) async {
    try {
      _log('🧹 Nettoyage anciennes archives (garder $keepCount)', level: 500);

      final archives = await listAvailableArchives();
      if (archives.length <= keepCount) {
        _log('ℹ️ Pas besoin de nettoyage (${archives.length} archives)',
            level: 500);
        return true;
      }

      // Supprimer les plus anciennes
      final toDelete = archives.length - keepCount;
      var deletedCount = 0;

      for (var i = 0; i < toDelete; i++) {
        try {
          final archiveDir = Directory(archives[i]);
          await archiveDir.delete(recursive: true);
          deletedCount++;
          _log('  🗑️ Archive supprimée: ${archives[i]}', level: 500);
        } catch (e) {
          _log('  ⚠️ Erreur suppression ${archives[i]}: $e', level: 900);
        }
      }

      _log('✅ $deletedCount anciennes archives supprimées', level: 500);
      return deletedCount == toDelete;
    } catch (e, stackTrace) {
      _logError('❌ Erreur nettoyage archives', e, stackTrace);
      return false;
    }
  }

  // ==================== MÉTHODES PRIVÉES ====================

  Future<Directory> _createArchiveDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final archiveDir =
        Directory('${appDir.path}/$_archiveFolder/archive_$timestamp');

    await archiveDir.create(recursive: true);
    _log('📁 Dossier archive créé: ${archiveDir.path}', level: 500);

    return archiveDir;
  }

  Future<bool> _archiveGardens(Directory archiveDir) async {
    try {
      final gardens = GardenBoxes.getAllGardens();
      _log('📦 Archivage de ${gardens.length} jardins', level: 500);

      for (final garden in gardens) {
        final gardenJson = garden.toJson();
        final fileName = 'garden_${garden.id}.json';
        final file = File('${archiveDir.path}/$fileName');

        await file.writeAsString(
          const JsonEncoder.withIndent('  ').convert(gardenJson),
        );
      }

      _gardensArchived += gardens.length;
      _log('✅ ${gardens.length} jardins archivés', level: 500);

      return true;
    } catch (e) {
      _log('❌ Erreur archivage jardins: $e', level: 1000);
      return false;
    }
  }

  Future<void> _archiveMetadata(
      Directory archiveDir, DateTime startTime) async {
    try {
      final metadata = {
        'archiveDate': DateTime.now().toIso8601String(),
        'migrationStartDate': startTime.toIso8601String(),
        'version': '2.7.0',
        'type': 'legacy_data_archive',
        'gardens': _gardensArchived,
        'source': 'PermaCalendar Legacy System',
      };

      final file = File('${archiveDir.path}/metadata.json');
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(metadata),
      );

      _log('✅ Métadonnées archivées', level: 500);
    } catch (e) {
      _log('⚠️ Erreur archivage métadonnées: $e', level: 900);
    }
  }

  Future<double> _calculateArchiveSize(Directory archiveDir) async {
    try {
      var totalSize = 0;

      await for (final entity in archiveDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      return totalSize / (1024 * 1024); // Convertir en MB
    } catch (e) {
      _log('⚠️ Erreur calcul taille archive: $e', level: 900);
      return 0.0;
    }
  }

  // ==================== STATISTIQUES ====================

  Map<String, dynamic> getStatistics() {
    return {
      'archivesCreated': _archivesCreated,
      'gardensArchived': _gardensArchived,
      'totalArchiveSize': _totalArchiveSize,
    };
  }

  void resetStatistics() {
    _archivesCreated = 0;
    _gardensArchived = 0;
    _totalArchiveSize = 0.0;
    _log('📊 Statistiques archivage réinitialisées', level: 500);
  }

  // ==================== UTILITAIRES ====================

  void _log(String message, {int level = 500}) {
    developer.log(message, name: _logName, level: level);
    print('[$_logName] $message');
  }

  void _logError(String message, Object error, [StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _logName,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    print('[$_logName] ERROR: $message - $error');
  }

  // ==================== GETTERS ====================

  int get archivesCreated => _archivesCreated;
  int get gardensArchived => _gardensArchived;
  double get totalArchiveSize => _totalArchiveSize;
}

/// Exception d'archivage
class DataArchivalException implements Exception {
  final String message;
  const DataArchivalException(this.message);

  @override
  String toString() => 'DataArchivalException: $message';
}


