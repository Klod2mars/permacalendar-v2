import 'dart:io';

void main() {
  print('🔍 === DIAGNOSTIC SIMPLE ===');
  
  // Vérifier si les dossiers Hive existent
  final hiveDir = Directory('test_hive');
  if (hiveDir.existsSync()) {
    print('📦 Dossier test_hive existe');
    final files = hiveDir.listSync();
    print('📁 Fichiers: ${files.map((f) => f.path.split('\\').last).join(', ')}');
  } else {
    print('❌ Dossier test_hive n\'existe pas');
  }
  
  // Vérifier les assets
  final assetsDir = Directory('assets/data');
  if (assetsDir.existsSync()) {
    print('📦 Dossier assets/data existe');
    final files = assetsDir.listSync();
    print('📁 Fichiers: ${files.map((f) => f.path.split('\\').last).join(', ')}');
  } else {
    print('❌ Dossier assets/data n\'existe pas');
  }
  
  print('✅ Diagnostic terminé');
}