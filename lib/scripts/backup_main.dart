import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permacalendar/app_initializer.dart';
import 'package:permacalendar/scripts/backup_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 Starting Backup Sequence...');
  
  try {
    // Initialize App (Hive, etc.)
    await AppInitializer.initialize();
    
    // Run Backup
    await BackupService.exportAll();
    
    print('✨ Backup completed successfully!');
  } catch (e, stack) {
    print('❌ Fatal Error during backup: $e');
    print(stack);
    exit(1);
  }
  
  // Exit gracefully
  exit(0);
}
