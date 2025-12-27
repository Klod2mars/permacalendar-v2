
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import 'package:permacalendar/core/models/activity.dart' as model_activity; 
import 'package:permacalendar/core/models/garden.dart';
import 'package:permacalendar/core/models/garden_bed.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/models/plant.dart';
import 'package:permacalendar/features/harvest/domain/models/harvest_record.dart';
import 'package:permacalendar/features/export/domain/models/export_config.dart';
import 'package:permacalendar/features/export/domain/models/export_schema.dart';

class ExcelGeneratorService {
  
  /// Main Entry Point
  Future<List<int>> generateExport(ExportConfig config) async {
    // Run in main isolate because we need Hive access
    return generateExportInMainIsolate(config);
  }

  // Legacy/Unused stub for compute
  static Future<List<int>> _generateExcelTask(ExportConfig config) async {
    throw UnimplementedError("Use generateExportInMainIsolate instead");
  }

  // Real implementation running in main isolate (accessing Hive)
  Future<List<int>> generateExportInMainIsolate(ExportConfig config) async {
    final excel = Excel.createExcel();
    if (excel.sheets.containsKey('Sheet1')) {
      excel.rename('Sheet1', 'META');
    } else {
      excel['META'];
    }

    // 1. Fetch Data
    final gardens = GardenBoxes.gardens.values.where((g) => 
      config.scope.gardenIds.isEmpty || config.scope.gardenIds.contains(g.id)
    ).toList();
    
    final beds = GardenBoxes.gardenBeds.values.where((b) => 
      (config.scope.gardenIds.isEmpty || config.scope.gardenIds.contains(b.gardenId)) &&
      (config.scope.gardenBedIds.isEmpty || config.scope.gardenBedIds.contains(b.id))
    ).toList();
    
    // Filter Plantings/Activities/Harvests based on Scope (Garden/Bed/Date)
    final dateStart = config.scope.dateRange?.start;
    final dateEnd = config.scope.dateRange?.end;

    // Harvests
    final allHarvestsRaw = GardenBoxes.harvests.values.toList(); 
    final allHarvests = allHarvestsRaw.map((e) {
      if (e is HarvestRecord) return e;
      if (e is Map) {
        try {
           return HarvestRecord.fromJson(Map<String, dynamic>.from(e));
        } catch (_) { return null; }
      }
      return null;
    }).whereType<HarvestRecord>().toList();

    final filteredHarvests = allHarvests.where((h) {
      if (config.scope.gardenIds.isNotEmpty && !config.scope.gardenIds.contains(h.gardenId)) return false;
      if (dateStart != null && h.date.isBefore(dateStart)) return false;
      if (dateEnd != null && h.date.isAfter(dateEnd)) return false;
      return true;
    }).toList();

    // Activities
    final allActivitiesRaw = GardenBoxes.activities.values.toList();
    final allActivities = allActivitiesRaw.map((e) {
       if (e is model_activity.Activity) return e;
       // If stored as JSON map?
       if (e is Map) {
         try {
           return model_activity.Activity.fromJson(Map<String, dynamic>.from(e));
         } catch (_) { return null; }
       }
       return null;
    }).whereType<model_activity.Activity>().toList();
    
    final filteredActivities = allActivities.where((a) {
      if (dateStart != null && a.timestamp.isBefore(dateStart)) return false;
      if (dateEnd != null && a.timestamp.isAfter(dateEnd)) return false;
      return true; 
    }).toList();

    // Plants (Reference)
    final plantMap = <String, Plant>{};
    for (var p in GardenBoxes.plants.values) {
      if (p is Plant) {
         plantMap[p.id] = p;
      } else if (p is Map) {
         try {
            final plantObj = Plant.fromJson(Map<String,dynamic>.from(p));
            plantMap[plantObj.id] = plantObj;
         } catch (_) {}
      }
    }

    // 2. Generate META Sheet
    _generateMetaSheet(excel, config);

    // 3. Generate Content Sheets
    if (config.format == ExportFormat.separateSheets) {
       if (config.isBlockEnabled(ExportBlockType.garden)) {
         _fillSheet(excel, 'Gardens', ExportBlockType.garden, gardens, config);
       }
       if (config.isBlockEnabled(ExportBlockType.gardenBed)) {
         _fillSheet(excel, 'Parcelles', ExportBlockType.gardenBed, beds, config);
       }
       if (config.isBlockEnabled(ExportBlockType.harvest)) {
         _fillSheet(excel, 'Recoltes', ExportBlockType.harvest, filteredHarvests, config, 
           extraData: {'beds': beds, 'plants': plantMap, 'activities': filteredActivities}
         );
       }
       if (config.isBlockEnabled(ExportBlockType.activity)) {
         _fillSheet(excel, 'Activites', ExportBlockType.activity, filteredActivities, config);
       }
       // Plants...
    } else {
      // FLAT TABLE MODE
      // We prioritize the "most detailed" block selected.
      // E.g. If Harvests is selected, we iterate Harvests.
      // If only Gardens selected, we iterate Gardens.
      // This is complex. For now, we create ONE Master Sheet depending on primary selection.
      // Usually "Flat Table" implies Transactional Data (Harvests or Activities).
      
      if (config.isBlockEnabled(ExportBlockType.harvest)) {
         _fillSheet(excel, 'Global_Export', ExportBlockType.harvest, filteredHarvests, config, 
           extraData: {'beds': beds, 'plants': plantMap, 'activities': filteredActivities, 'flat': true}
         );
      } else if (config.isBlockEnabled(ExportBlockType.activity)) {
         _fillSheet(excel, 'Global_Export', ExportBlockType.activity, filteredActivities, config,
           extraData: {'flat': true}
         );
      } else {
         // Fallback to separate sheets if no transactional data
      }
    }

    return excel.encode() ?? [];
  }

  void _generateMetaSheet(Excel excel, ExportConfig config) {
    var sheet = excel['META'];
    sheet.appendRow([TextCellValue('Export Metrics Application')]);
    sheet.appendRow([TextCellValue('Version Schema'), TextCellValue(ExportSchema.version)]);
    sheet.appendRow([TextCellValue('Date Export'), TextCellValue(DateTime.now().toIso8601String())]);
    sheet.appendRow([TextCellValue('Preset'), TextCellValue(config.name)]);
    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([TextCellValue('Scope')]);
    sheet.appendRow([TextCellValue('Gardens'), IntCellValue(config.scope.gardenIds.length)]);
    sheet.appendRow([TextCellValue('Start Date'), TextCellValue(config.scope.dateRange?.start.toString() ?? 'All')]);
    sheet.appendRow([TextCellValue('End Date'), TextCellValue(config.scope.dateRange?.end.toString() ?? 'All')]);
    
    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([TextCellValue('Dictionary')]);
    sheet.appendRow([TextCellValue('Column ID'), TextCellValue('Label'), TextCellValue('Description')]);
    
    // List all fields from enabled blocks
    for (var block in config.blocks) {
      if (!block.isEnabled) continue;
      for (var fieldId in block.selectedFieldIds) {
        final def = ExportSchema.getFieldById(block.type, fieldId);
        if (def != null) {
          sheet.appendRow([TextCellValue(def.id), TextCellValue(def.label), TextCellValue(def.description)]);
        }
      }
    }
  }

  void _fillSheet(Excel excel, String sheetName, ExportBlockType type, List<dynamic> data, ExportConfig config, {Map<String, dynamic>? extraData}) {
    var sheet = excel[sheetName];
    
    // 1. Headers
    List<String> fieldIds = config.getSelectedFieldsFor(type);
    List<CellValue> headerRow = [];
    for (var fid in fieldIds) {
      final def = ExportSchema.getFieldById(type, fid);
      headerRow.add(TextCellValue(def?.label ?? fid)); // Use Label for readability in Row 1
    }
    sheet.appendRow(headerRow);

    // 2. Data Rows
    // Map for fast lookups
    List<GardenBed> beds = (extraData?['beds'] as List<GardenBed>?) ?? [];
    Map<String, Plant> plants = (extraData?['plants'] as Map<String, Plant>?) ?? {};
    List<model_activity.Activity> activities = (extraData?['activities'] as List<model_activity.Activity>?) ?? [];

    for (var item in data) {
      List<CellValue> row = [];
      
      // Context Resolution (Harvest specific)
      String? resolvedBedName;
      String? resolvedBedId;
      
      if (type == ExportBlockType.harvest && item is HarvestRecord) {
         // RESOLUTION STRATEGY
         // 1. Try to find Activity with 'plantingHarvested' entityId that matches? 
         // Actually, Activity.plantingHarvested has entityId = plantingId.
         // But HarvestRecord doesn't have reference to activityId or plantingId.
         // Correlation: Same date (to the minute?), same qty?
         // This is heuristic.
         
         // Heuristic:
         // Find activity where type=plantingHarvested, timestamp ~= harvest.date, metadata['quantity'] == harvest.quantityKg (approx)
         // metadata['plantName'] == harvest.plantName
         
         final match = activities.where((a) => 
           a.type == model_activity.ActivityType.plantingHarvested &&
           a.metadata['plantName'] == item.plantName &&
           a.timestamp.difference(item.date).abs().inMinutes < 5 // 5 min tolerance
         ).firstOrNull;
         
         if (match != null && match.entityId != null) {
             // EntityId is plantingId.
             // We need to find the planting inside boxes to get bedId.
             final planting = GardenBoxes.plantings.get(match.entityId!);
             if (planting != null) {
               resolvedBedId = planting.gardenBedId;
               final bed = beds.where((b) => b.id == resolvedBedId).firstOrNull;
               resolvedBedName = bed?.name;
             }
         }
      }

      for (var fid in fieldIds) {
        // MAPPING LOGIC
        dynamic value;
        
        // --- HARVEST MAPPING ---
        if (type == ExportBlockType.harvest && item is HarvestRecord) {
           switch (fid) {
             case 'harvest_date': value = item.date; break;
             case 'harvest_qty': value = item.quantityKg; break;
             case 'harvest_plant_name': value = item.plantName; break;
             case 'harvest_price': value = item.pricePerKg; break;
             case 'harvest_value': value = item.totalValue; break;
             case 'harvest_notes': value = item.notes; break;
             case 'harvest_bed_name': value = resolvedBedName; break;
             case 'harvest_bed_id': value = resolvedBedId; break;
           }
        }
        
        // --- GARDEN BED MAPPING ---
        else if (type == ExportBlockType.gardenBed && item is GardenBed) {
           switch (fid) {
             case 'bed_name': value = item.name; break;
             case 'bed_id': value = item.id; break;
             case 'bed_surface': value = item.sizeInSquareMeters; break;
             case 'bed_plant_count': value = GardenBoxes.getPlantings(item.id).where((p) => p.isActive).length; break;
           }
        }
        
        // --- GARDEN MAPPING ---
        else if (type == ExportBlockType.garden && item is Garden) {
           switch (fid) {
             case 'garden_name': value = item.name; break;
             case 'garden_id': value = item.id; break;
             case 'garden_surface': value = 0; break; // Calculate?
             case 'garden_creation_date': value = item.createdAt; break;
           }
        }
        
        // --- ACTIVITY MAPPING ---
        else if (type == ExportBlockType.activity && item is model_activity.Activity) {
           switch (fid) {
             case 'activity_date': value = item.timestamp; break;
             case 'activity_type': value = item.type.name; break;
             case 'activity_title': value = item.title; break;
             case 'activity_desc': value = item.description; break;
             case 'activity_entity': value = item.metadata['plantName'] ?? item.metadata['bedName'] ?? item.metadata['gardenName']; break;
             case 'activity_entity_id': value = item.entityId; break;
           }
        }
        
        // Convert to CellValue
        if (value == null) {
          row.add(TextCellValue(''));
        } else if (value is num) {
          row.add(DoubleCellValue(value.toDouble()));
        } else if (value is DateTime) {
          // Excel Date? Or String?
          // Using ISO String for maximum compat
          row.add(TextCellValue(value.toIso8601String()));
        } else {
          row.add(TextCellValue(value.toString()));
        }
      }
      sheet.appendRow(row);
    }
  }

}
