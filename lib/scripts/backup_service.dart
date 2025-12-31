import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../core/data/hive/garden_boxes.dart';

class BackupService {
  static Future<void> exportAll() async {
    final now = DateTime.now();
    final dateStr = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    
    // Ensure backup directory exists
    final backupDir = Directory('backup');
    if (!await backupDir.exists()) {
      await backupDir.create();
    }

    try {
      // 1. Export Activities
      final activities = GardenBoxes.activities.values.map((e) => e.toJson()).toList();
      final activitiesFile = File('${backupDir.path}/activities_backup_$dateStr.json');
      await activitiesFile.writeAsString(jsonEncode(activities));
      print('✅ Activities backup created: ${activitiesFile.absolute.path}');
      print('   Count: ${activities.length}');

      // 2. Export Plantings
      final plantings = GardenBoxes.plantings.values.map((e) => e.toJson()).toList();
      final plantingsFile = File('${backupDir.path}/plantings_backup_$dateStr.json');
      await plantingsFile.writeAsString(jsonEncode(plantings));
      print('✅ Plantings backup created: ${plantingsFile.absolute.path}');
      print('   Count: ${plantings.length}');
      
    } catch (e) {
      print('❌ Backup failed: $e');
      rethrow;
    }
  }
}
