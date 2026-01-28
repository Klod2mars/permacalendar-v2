import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Just in case, but file_picker handles most
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class FullBackupService {
  static const String _prefsFileName = 'app_preferences.json';
  static const String _backupPrefix = 'permacalendar_backup_';

  // Singleton
  static final FullBackupService _instance = FullBackupService._internal();
  factory FullBackupService() => _instance;
  FullBackupService._internal();

  /// Create a full backup (ZIP) and share it / save it
  Future<void> createAndShareBackup({required String shareSubject}) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final tempDir = await getTemporaryDirectory();
      
      // 1. Define backup file path
      final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final backupFileName = '$_backupPrefix$timestamp.zip';
      final backupFile = File(p.join(tempDir.path, backupFileName));
      
      if (await backupFile.exists()) {
        await backupFile.delete();
      }

      final archive = Archive();

      // 2. Add SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final allPrefs = prefs.getKeys().fold<Map<String, dynamic>>({}, (map, key) {
        map[key] = prefs.get(key);
        return map;
      });
      final prefsJson = jsonEncode(allPrefs);
      archive.addFile(ArchiveFile(_prefsFileName, utf8.encode(prefsJson).length, utf8.encode(prefsJson)));

      // 3. Add Hive files & Images from AppDocumentsDir
      final files = appDir.listSync(recursive: true);
      for (final file in files) {
        if (file is File) {
          final relativePath = p.relative(file.path, from: appDir.path);
          
          // Filter out unwanted files
          if (_shouldIncludeFile(relativePath)) {
             final content = await file.readAsBytes();
             archive.addFile(ArchiveFile(relativePath, content.length, content));
          }
        }
      }

      // 4. Create ZIP
      final zipEncoder = ZipEncoder();
      final encodedZip = zipEncoder.encode(archive);
      if (encodedZip == null) throw Exception('Failed to encode ZIP');

      await backupFile.writeAsBytes(encodedZip);
      debugPrint('Backup created at: ${backupFile.path} (${(backupFile.lengthSync() / 1024).toStringAsFixed(1)} KB)');

      // 5. Share/Save
      await Share.shareXFiles(
        [XFile(backupFile.path)],
        text: '$shareSubject $timestamp',
      );

    } catch (e) {
      debugPrint('Error creating backup: $e');
      rethrow;
    }
  }

  /// Restore from a ZIP file
  Future<void> restoreBackup() async {
    try {
      // 1. Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null || result.files.single.path == null) {
        return; // Cancelled
      }

      final backupPath = result.files.single.path!;
      debugPrint('Restoring from: $backupPath');

      final appDir = await getApplicationDocumentsDirectory();
      final bytes = await File(backupPath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // 2. Validate Archive (Basic check)
      // Check if it looks like a valid backup (e.g. has prefs or hive boxes)
      // For now we assume if it opens it's okay, but checking for _prefsFileName is safer
      bool hasPrefs = archive.any((f) => f.name == _prefsFileName);
      if (!hasPrefs) {
         debugPrint('Warning: No $_prefsFileName found in archive. Proceeding anyway...');
      }

      // 3. Restore Files
      // CRITICAL: Close Hive to release file locks before overwriting!
      await Hive.close();
      debugPrint('Hive closed for restore.');

      for (final file in archive) {
        if (file.isFile) {
          final data = file.content as List<int>;
          
          if (file.name == _prefsFileName) {
            // Restore Prefs
            final jsonStr = utf8.decode(data);
            final map = jsonDecode(jsonStr) as Map<String, dynamic>;
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear(); // Clear old prefs
            
            for (final key in map.keys) {
              final val = map[key];
              if (val is bool) await prefs.setBool(key, val);
              else if (val is int) await prefs.setInt(key, val);
              else if (val is double) await prefs.setDouble(key, val);
              else if (val is String) await prefs.setString(key, val);
              else if (val is List) await prefs.setStringList(key, List<String>.from(val));
            }
          } else {
            // Restore File
            // Security: Prevent Zip Slip (.. in paths)
            if (file.name.contains('..')) continue;
            
            // Skip lock files if they were accidentally backed up
            if (file.name.endsWith('.lock')) continue;

            final outFile = File(p.join(appDir.path, file.name));
            
            // SECURITY/STABILITY FIX:
            // Delete the file if it exists before writing.
            // On Android, Hive uses mmap. Overwriting an mmapped file that wasn't fully released
            // (even after close) can cause a SIGBUS crash. Unlinking (deleting) it first is safer.
            if (await outFile.exists()) {
              await outFile.delete();
            }

            if (!await outFile.parent.exists()) {
              await outFile.parent.create(recursive: true);
            }
            
            // Note: Lock files are already skipped by the loop check added previously
            await outFile.writeAsBytes(data);
            debugPrint('Restored: ${file.name} (${data.length} bytes)');
          }
        }
      }
      
      debugPrint('Restore completed. Exiting app.');
      // Force exit to ensure clean state on next launch
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      exit(0);

    } catch (e) {
      debugPrint('Error restoring backup: $e');
      rethrow;
    }
  }

  bool _shouldIncludeFile(String relativePath) {
    // Exclude hidden files?
    if (relativePath.startsWith('.')) return false;
    
    // Include Hive files (BUT NOT Locks)
    if (relativePath.endsWith('.hive')) return true;
    
    // Include Images
    if (relativePath.startsWith('plant_images') || relativePath.contains('images')) return true; // Adjust based on structure

    // Safety: Include everything else in root
    return true; 
  }
}
