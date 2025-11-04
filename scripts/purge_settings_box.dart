// Script pour purger les boxes Hive corrompus
// Utilisez ce script depuis l'app Flutter ou exécutez-le manuellement

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> main() async {
  print('🧹 Purging corrupted Hive settings boxes...');

  try {
    // Initialiser Hive Flutter (nécessite le contexte Flutter)
    await Hive.initFlutter();
    final appDir = await getApplicationDocumentsDirectory();
    print('✅ Hive initialized at: ${appDir.path}');

    // Purger le box 'app_settings' (le box principal)
    try {
      print('\n📦 Attempting to purge box "app_settings"...');
      // Essayer de supprimer le box du disque directement
      await Hive.deleteBoxFromDisk('app_settings');
      print('✅ Box "app_settings" deleted from disk');
    } catch (e) {
      print('⚠️ Error deleting app_settings: $e');
      // Si erreur, essayer de l'ouvrir et le vider
      try {
        final box = await Hive.openBox('app_settings');
        print('Found keys: ${box.keys}');
        await box.clear();
        await box.close();
        print('✅ Box "app_settings" cleared');
      } catch (openError) {
        print('⚠️ Could not open app_settings: $openError');
        // Essayer de supprimer les fichiers directement
        try {
          final boxFile = File('${appDir.path}/app_settings.hive');
          final lockFile = File('${appDir.path}/app_settings.lock');
          if (await boxFile.exists()) {
            await boxFile.delete();
            print('✅ Deleted app_settings.hive file');
          }
          if (await lockFile.exists()) {
            await lockFile.delete();
            print('✅ Deleted app_settings.lock file');
          }
        } catch (fileError) {
          print('⚠️ Could not delete files: $fileError');
        }
      }
    }

    // Purger aussi l'ancien box 'settings' s'il existe
    try {
      print('\n📦 Attempting to purge box "settings"...');
      await Hive.deleteBoxFromDisk('settings');
      print('✅ Box "settings" deleted from disk');
    } catch (e) {
      print('⚠️ Error deleting settings: $e');
      // Si erreur, essayer de l'ouvrir et le vider
      try {
        final box = await Hive.openBox('settings');
        print('Found keys: ${box.keys}');
        await box.clear();
        await box.close();
        print('✅ Box "settings" cleared');
      } catch (openError) {
        print('⚠️ Could not open settings: $openError');
        // Essayer de supprimer les fichiers directement
        try {
          final boxFile = File('${appDir.path}/settings.hive');
          final lockFile = File('${appDir.path}/settings.lock');
          if (await boxFile.exists()) {
            await boxFile.delete();
            print('✅ Deleted settings.hive file');
          }
          if (await lockFile.exists()) {
            await lockFile.delete();
            print('✅ Deleted settings.lock file');
          }
        } catch (fileError) {
          print('⚠️ Could not delete files: $fileError');
        }
      }
    }

    print('\n✅ Purge completed successfully.');
    print(
        '💡 You can now restart your app - it will recreate clean boxes with default values.');
    exit(0);
  } catch (e) {
    print('❌ Error during purge: $e');
    exit(1);
  }
}
