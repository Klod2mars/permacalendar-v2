// ✅ Patch v1.2 — purge du box Hive corrompu avant relance
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> main() async {
  print('🧹 Purge de l\'ancien box Hive (settings)...');

  try {
    // Initialiser Hive avec le répertoire de l'application
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);

    // Ouvrir et vider le box "settings"
    final box = await Hive.openBox('settings');
    await box.clear();
    await box.close();

    print('✅ Box "settings" vidé avec succès.');
  } catch (e) {
    print('⚠️  Erreur lors de la purge: $e');
    exit(1);
  }
}
