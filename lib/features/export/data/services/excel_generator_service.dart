import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

// NEW IMPORTS
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permacalendar/core/models/garden_hive.dart'; // Ensure this model is available
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
    // FIX: Read from the correct 'gardens_hive' box instead of legacy GardenBoxes
    var gardens = <Garden>[];
    try {
      final box = await Hive.openBox<GardenHive>('gardens_hive');
      gardens = box.values
          .where((gh) =>
              config.scope.gardenIds.isEmpty ||
              config.scope.gardenIds.contains(gh.id))
          .map((gh) {
            // Convert GardenHive to Garden
             // Calculate minimal area from beds if possible, or default
            double totalArea = 10.0;
            if (gh.gardenBeds.isNotEmpty) {
                 totalArea = gh.gardenBeds.fold(0.0, (sum, bed) => sum + bed.sizeInSquareMeters);
            }
            
            return Garden(
              id: gh.id,
              name: gh.name, // The crucial part
              description: gh.description ?? '',
              totalAreaInSquareMeters: totalArea,
              location: 'Jardin ${gh.name}',
              createdAt: gh.createdDate,
              updatedAt: gh.createdDate,
              metadata: {},
              isActive: true
            );
          })
          .toList();
          
          print('[Export] Loaded ${gardens.length} gardens from "gardens_hive".');
    } catch (e) {
      print('[Export] Error loading gardens from gardens_hive: $e');
      // Fallback to GardenBoxes if new way fails (unlikely)
      gardens = GardenBoxes.gardens.values
          .where((g) =>
              config.scope.gardenIds.isEmpty ||
              config.scope.gardenIds.contains(g.id))
          .toList();
    }
    
    // DEBUG LOGS (Using print for visibility)
    print('[Export] Final Filtered Gardens: ${gardens.length}');
    
    // Dump all available garden IDs for debugging
    for (var g in gardens) {
      print('[Export] Garden available: id="${g.id}" name="${g.name}"');
    }

    final beds = GardenBoxes.gardenBeds.values
        .where((b) =>
            (config.scope.gardenIds.isEmpty ||
                config.scope.gardenIds.contains(b.gardenId)) &&
            (config.scope.gardenBedIds.isEmpty ||
                config.scope.gardenBedIds.contains(b.id)))
        .toList();

    // Filter Plantings/Activities/Harvests based on Scope (Garden/Bed/Date)
    final dateStart = config.scope.dateRange?.start;
    final dateEnd = config.scope.dateRange?.end;

    // Harvests
    final allHarvestsRaw = GardenBoxes.harvests.values.toList();
    final allHarvests = allHarvestsRaw
        .map((e) {
          if (e is HarvestRecord) return e;
          if (e is Map) {
            try {
              return HarvestRecord.fromJson(Map<String, dynamic>.from(e));
            } catch (_) {
              return null;
            }
          }
          return null;
        })
        .whereType<HarvestRecord>()
        .toList();

    final filteredHarvests = allHarvests.where((h) {
      if (config.scope.gardenIds.isNotEmpty &&
          !config.scope.gardenIds.contains(h.gardenId)) return false;
      if (dateStart != null && h.date.isBefore(dateStart)) return false;
      if (dateEnd != null && h.date.isAfter(dateEnd)) return false;
      return true;
    }).toList();

    // Activities
    final allActivitiesRaw = GardenBoxes.activities.values.toList();
    final allActivities = allActivitiesRaw
        .map((e) {
          if (e is model_activity.Activity) return e;
          // If stored as JSON map?
          if (e is Map) {
            try {
              return model_activity.Activity.fromJson(
                  Map<String, dynamic>.from(e));
            } catch (_) {
              return null;
            }
          }
          return null;
        })
        .whereType<model_activity.Activity>()
        .toList();

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
          final plantObj = Plant.fromJson(Map<String, dynamic>.from(p));
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
        _fillSheet(excel, 'Recoltes', ExportBlockType.harvest, filteredHarvests,
            config, extraData: {
          'beds': beds,
          'gardens': gardens,
          'plants': plantMap,
          'activities': filteredActivities
        });
      }
      if (config.isBlockEnabled(ExportBlockType.activity)) {
        _fillSheet(excel, 'Activites', ExportBlockType.activity,
            filteredActivities, config);
      }
    } else {
      // FLAT TABLE MODE
      if (config.isBlockEnabled(ExportBlockType.harvest)) {
        _fillSheet(excel, 'Global_Export', ExportBlockType.harvest,
            filteredHarvests, config, extraData: {
          'beds': beds,
          'gardens': gardens,
          'plants': plantMap,
          'activities': filteredActivities,
          'flat': true
        });
      } else if (config.isBlockEnabled(ExportBlockType.activity)) {
        _fillSheet(excel, 'Global_Export', ExportBlockType.activity,
            filteredActivities, config,
            extraData: {'flat': true});
      }
    }

    return excel.encode() ?? [];
  }

  void _generateMetaSheet(Excel excel, ExportConfig config) {
    var sheet = excel['META'];
    sheet.appendRow([TextCellValue('Export Metrics Application')]);
    sheet.appendRow(
        [TextCellValue('Version Schema'), TextCellValue(ExportSchema.version)]);
    sheet.appendRow([
      TextCellValue('Date Export'),
      TextCellValue(DateTime.now().toIso8601String())
    ]);
    sheet.appendRow([TextCellValue('Preset'), TextCellValue(config.name)]);
    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([TextCellValue('Scope')]);
    sheet.appendRow([
      TextCellValue('Gardens'),
      IntCellValue(config.scope.gardenIds.length)
    ]);
    sheet.appendRow([
      TextCellValue('Start Date'),
      TextCellValue(config.scope.dateRange?.start.toString() ?? 'All')
    ]);
    sheet.appendRow([
      TextCellValue('End Date'),
      TextCellValue(config.scope.dateRange?.end.toString() ?? 'All')
    ]);

    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([TextCellValue('Dictionary')]);
    sheet.appendRow([
      TextCellValue('Column ID'),
      TextCellValue('Label'),
      TextCellValue('Description')
    ]);

    for (var block in config.blocks) {
      if (!block.isEnabled) continue;

      // Include forced fields for Harvest block in Dictionary
      List<String> effectiveFieldIds = List.from(block.selectedFieldIds);
      if (block.type == ExportBlockType.harvest) {
        final required = ['harvest_garden_name', 'harvest_bed_name'];
        for (var req in required) {
          if (!effectiveFieldIds.contains(req)) {
            effectiveFieldIds.add(req);
          }
        }
      }

      for (var fieldId in effectiveFieldIds) {
        final def = ExportSchema.getFieldById(block.type, fieldId);
        if (def != null) {
          sheet.appendRow([
            TextCellValue(def.id),
            TextCellValue(def.label),
            TextCellValue(def.description)
          ]);
        }
      }
    }
  }

  void _fillSheet(Excel excel, String sheetName, ExportBlockType type,
      List<dynamic> data, ExportConfig config,
      {Map<String, dynamic>? extraData}) {
    var sheet = excel[sheetName];
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR');

    // 1. Headers
    List<String> fieldIds = config.getSelectedFieldsFor(type);

    // Forcer l'ajout des colonnes Jardin + Parcelle uniquement pour Recoltes
    if (type == ExportBlockType.harvest) {
      final required = ['harvest_garden_name', 'harvest_bed_name'];
      // Insérer dans l'ordre requis au début en évitant les doublons
      for (var req in required.reversed) {
        if (fieldIds.contains(req)) {
          fieldIds.remove(req);
        }
        fieldIds.insert(0, req);
      }
    }
    List<CellValue> headerRow = [];
    for (var fid in fieldIds) {
      final def = ExportSchema.getFieldById(type, fid);
      headerRow.add(TextCellValue(def?.label ?? fid));
    }
    sheet.appendRow(headerRow);

    // 2. Data Rows
    List<GardenBed> beds = (extraData?['beds'] as List<GardenBed>?) ?? [];
    List<Garden> gardens = (extraData?['gardens'] as List<Garden>?) ?? [];
    List<model_activity.Activity> activities =
        (extraData?['activities'] as List<model_activity.Activity>?) ?? [];

    for (var item in data) {
      List<CellValue> row = [];

      // Context Resolution (Harvest specific)
      String? resolvedGardenName;
      String? resolvedGardenId;
      String? resolvedBedName;
      String? resolvedBedId;

      if (type == ExportBlockType.harvest && item is HarvestRecord) {
        // Résolution jardin
        // 1. Try from filtered list
        var garden = gardens.where((g) => g.id == item.gardenId).firstOrNull;
        
        // 2. Fallback: Scan ALL gardens in DB (Robust lookup)
        if (garden == null) {
           print('[Export] Resolution failed for gardenId="${item.gardenId}" in filtered list. Scanning DB...');
           try {
             // Use the 'gardens' list which is now correctly populated from hives
             garden = gardens.firstWhere(
               (g) => g.id.toString() == item.gardenId.toString(),
               orElse: () => gardens.firstWhere(
                  (g) => g.id.trim() == item.gardenId.trim(),
                  orElse: () => throw Exception('Not found') 
               )
             );
           } catch (_) {
             print('[Export] CRITICAL: Could not find garden with id="${item.gardenId}" in pre-loaded list.');
           }
        }
        
        resolvedGardenName = garden?.name;
        // FALLBACK: If name not found, show ID to prove we tried
        if (resolvedGardenName == null || resolvedGardenName.isEmpty) {
          resolvedGardenName = 'Unknown (${item.gardenId})';
        }
        
        resolvedGardenId = item.gardenId;

        // 1) Chercher plantation pertinente dans le même jardin
        try {
          final candidatePlantings =
              GardenBoxes.getActivePlantingsForGarden(item.gardenId)
                  .where((p) => p.plantId == item.plantId)
                  .toList();

          if (candidatePlantings.isNotEmpty) {
            candidatePlantings
                .sort((a, b) => b.plantedDate.compareTo(a.plantedDate));
            final Planting? chosen = candidatePlantings.firstWhere(
              (p) => !p.plantedDate.isAfter(item.date),
              orElse: () => candidatePlantings.first,
            );
            if (chosen != null) {
              resolvedBedId = chosen.gardenBedId;
              resolvedBedName =
                  GardenBoxes.getGardenBedById(resolvedBedId!)?.name;
            }
          }
        } catch (_) {
          /* fallback plus bas */
        }

        // 2) Si non trouvé, fallback heuristique existante (activité)
        if (resolvedBedId == null) {
          final match = activities
              .where((a) =>
                  a.type == model_activity.ActivityType.plantingHarvested &&
                  a.metadata['plantName'] == item.plantName &&
                  a.timestamp.difference(item.date).abs().inMinutes < 5)
              .firstOrNull;

          if (match != null && match.entityId != null) {
            final planting = GardenBoxes.plantings.get(match.entityId!);
            if (planting != null) {
              resolvedBedId = planting.gardenBedId;
              resolvedBedName =
                  GardenBoxes.getGardenBedById(resolvedBedId!)?.name;
            }
          }
        }
      }

      for (var fid in fieldIds) {
        dynamic value;

        // --- HARVEST MAPPING ---
        if (type == ExportBlockType.harvest && item is HarvestRecord) {
          switch (fid) {
            case 'harvest_date':
              value = item.date;
              break;
            case 'harvest_qty':
              value = item.quantityKg;
              break;
            case 'harvest_plant_name':
              value = item.plantName;
              break;
            case 'harvest_price':
              value = item.pricePerKg;
              break;
            case 'harvest_value':
              value = item.totalValue;
              break;
            case 'harvest_notes':
              value = item.notes;
              break;
            case 'harvest_bed_name':
              value = resolvedBedName;
              break;
            case 'harvest_bed_id':
              value = resolvedBedId;
              break;
            case 'harvest_garden_name':
              value = resolvedGardenName;
              break;
            case 'harvest_garden_id':
              value = resolvedGardenId;
              break;
          }
        }

        // --- GARDEN BED MAPPING ---
        else if (type == ExportBlockType.gardenBed && item is GardenBed) {
          switch (fid) {
            case 'bed_name':
              value = item.name;
              break;
            case 'bed_id':
              value = item.id;
              break;
            case 'bed_surface':
              value = item.sizeInSquareMeters;
              break;
            case 'bed_plant_count':
              value = GardenBoxes.getPlantings(item.id)
                  .where((p) => p.isActive)
                  .length;
              break;
          }
        }

        // --- GARDEN MAPPING ---
        else if (type == ExportBlockType.garden && item is Garden) {
          switch (fid) {
            case 'garden_name':
              value = item.name;
              break;
            case 'garden_id':
              value = item.id;
              break;
            case 'garden_surface':
              value = 0;
              break;
            case 'garden_creation_date':
              value = item.createdAt;
              break;
          }
        }

        // --- ACTIVITY MAPPING ---
        else if (type == ExportBlockType.activity &&
            item is model_activity.Activity) {
          switch (fid) {
            case 'activity_date':
              value = item.timestamp;
              break;
            case 'activity_type':
              value = item.type.name;
              break;
            case 'activity_title':
              value = item.title;
              break;
            case 'activity_desc':
              value = item.description;
              break;
            case 'activity_entity':
              value = item.metadata['plantName'] ??
                  item.metadata['bedName'] ??
                  item.metadata['gardenName'];
              break;
            case 'activity_entity_id':
              value = item.entityId;
              break;
          }
        }

        // Convert to CellValue
        if (value == null) {
          row.add(TextCellValue(''));
        } else if (value is num) {
          row.add(DoubleCellValue(value.toDouble()));
        } else if (value is DateTime) {
          row.add(TextCellValue(dateFormat.format(value)));
        } else {
          row.add(TextCellValue(value.toString()));
        }
      }
      sheet.appendRow(row);
    }
  }
}
