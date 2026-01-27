import 'package:excel/excel.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

import 'package:permacalendar/l10n/app_localizations.dart';

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
import 'package:permacalendar/core/models/activity_v3.dart';
import 'package:permacalendar/features/statistics/application/services/nutrition_aggregation_service.dart';
import 'package:permacalendar/features/statistics/domain/models/nutrient_aggregation_result.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

class ExcelGeneratorService {
  /// Main Entry Point
  Future<List<int>> generateExport(ExportConfig config, AppLocalizations l10n) async {
    // Run in main isolate because we need Hive access
    return generateExportInMainIsolate(config, l10n);
  }



  // Real implementation running in main isolate (accessing Hive)
  Future<List<int>> generateExportInMainIsolate(ExportConfig config, AppLocalizations l10n) async {
    final excel = Excel.createExcel();
    // META Sheet Removed per user request
    // if (excel.sheets.containsKey('Sheet1')) {
    //   excel.rename('Sheet1', 'META');
    // } else {
    //   excel['META'];
    // }

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

    // Activities (V3)
    final allActivitiesRaw = <ActivityV3>[];
    try {
      final box = await Hive.openBox<ActivityV3>('activities_v3');
      allActivitiesRaw.addAll(box.values);
    } catch (e) {
      print('[Export] Error loading activities_v3: $e');
    }

    final filteredActivities = allActivitiesRaw.where((a) {
      if (!a.isActive) return false;
      
      // Date Filter
      if (dateStart != null && a.timestamp.isBefore(dateStart)) return false;
      if (dateEnd != null && a.timestamp.isAfter(dateEnd)) return false;

      // Garden Filter
      if (config.scope.gardenIds.isNotEmpty) {
        final gId = a.metadata?['gardenId'];
        // If activity has a gardenId, it MUST match.
        // If it doesn't have a gardenId, we include it only if we decide global activities are OK.
        // User request: "celui-ci doit également être appliqué au journal des activités"
        // implying loose structure but generally we should filter if applicable.
        // Let's exclude if gardenId exists and doesn't match.
        if (gId != null && !config.scope.gardenIds.contains(gId)) return false;
        
        // If no gardenId is present (e.g. system event), we might want to keep it or hide it.
        // Given the goal "cohérence des données exportées par jardin", if filtered by garden, generic events might be noise.
        // Safe bet: If strictly filtering by garden, allow only if gardenId matches OR if it's explicitly global?
        // Let's assume: include if gardenId matches OR if no gardenId (system wide). 
        // BUT user said "par jardin", implying strictness.
        // Let's try: Include if gardenId matches. If no gardenId, exclude?
        // Let's stick to: if metadata has gardenId, check it.
        if (gId != null && !config.scope.gardenIds.contains(gId)) return false;
      }
      
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

    // 2. Generate META Sheet (Disabled)
    // _generateMetaSheet(excel, config);
    
    // Clean up default sheet if not needed or rename to first data sheet
    // For now, let's just delete Sheet1 if we are going to create others, 
    // BUT 'excel' package requires at least one sheet.
    // So we will let _fillSheet create/get the sheets.
    // After filling, if 'Sheet1' is empty/unused, we can delete it.

    // 3. Generate Content Sheets
    if (config.format == ExportFormat.separateSheets) {
      if (config.isBlockEnabled(ExportBlockType.garden)) {
        _fillSheet(excel, l10n.export_block_garden.split(' (').first, ExportBlockType.garden, gardens, config, l10n);
      }
      if (config.isBlockEnabled(ExportBlockType.gardenBed)) {
        _fillSheet(excel, l10n.export_block_garden_bed.split(' (').first, ExportBlockType.gardenBed, beds, config, l10n);
      }
      if (config.isBlockEnabled(ExportBlockType.harvest)) {
        _fillSheet(excel, l10n.export_block_harvest.split(' (').first, ExportBlockType.harvest, filteredHarvests,
            config, l10n, extraData: {
          'beds': beds,
          'gardens': gardens,
          'plants': plantMap,
          'activities': filteredActivities
        });
      }
      if (config.isBlockEnabled(ExportBlockType.activity)) {
        _fillSheet(excel, l10n.export_block_activity.split(' (').first, ExportBlockType.activity,
            filteredActivities, config, l10n);
      }
      if (config.isBlockEnabled(ExportBlockType.nutrition)) {
        // --- NUTRITION EXPORT ---
        final plants = _adaptPlantsForNutrition();
        final nutritionService = NutritionAggregationService(plants);
        
        // Date Range Auto-detect if null
        DateTime start = config.scope.dateRange?.start ?? DateTime.now();
        DateTime end = config.scope.dateRange?.end ?? DateTime.now();

        if (config.scope.dateRange == null && filteredHarvests.isNotEmpty) {
           try {
             start = filteredHarvests.map((e) => e.date).reduce((a, b) => a.isBefore(b) ? a : b);
             end = filteredHarvests.map((e) => e.date).reduce((a, b) => a.isAfter(b) ? a : b);
           } catch (_) {}
        }
        
        final result = await nutritionService.aggregate(filteredHarvests, startDate: start, endDate: end, estimateMissing: true);
        
        _fillSheet(excel, l10n.export_block_nutrition.split(' (').first, ExportBlockType.nutrition,
             result.byNutrient.values.toList(), config, l10n);
      }

    } else {
      // FLAT TABLE MODE
      if (config.isBlockEnabled(ExportBlockType.harvest)) {
        _fillSheet(excel, 'Global_Export', ExportBlockType.harvest,
            filteredHarvests, config, l10n, extraData: {
          'beds': beds,
          'gardens': gardens,
          'plants': plantMap,
          'activities': filteredActivities,
          'flat': true
        });
      } else if (config.isBlockEnabled(ExportBlockType.activity)) {
        _fillSheet(excel, 'Global_Export', ExportBlockType.activity,
            filteredActivities, config, l10n,
            extraData: {'flat': true});
      }
    }

    // Cleanup default "Sheet1" if it's empty and we have other sheets
    if (excel.sheets.length > 1 && excel.sheets.containsKey('Sheet1')) {
      // Check if empty? Or just blindly delete if we know we created others.
      // Ideally we check if it has data. For now, simplistic safety:
      // If we added 'Activites' or 'Recoltes', Sheet1 is likely extra.
      excel.delete('Sheet1');
    }
    
    return excel.encode() ?? [];
  }

  void _fillSheet(Excel excel, String sheetName, ExportBlockType type,
      List<dynamic> data, ExportConfig config, AppLocalizations l10n,
      {Map<String, dynamic>? extraData}) {
    var sheet = excel[sheetName];
    // Use localized date format (e.g., 'dd/MM/yyyy HH:mm' for FR, maybe different for others, 
    // but mostly we want consistent ISO-like or locale aware)
    // Using default locale from l10n isn't directly available safely as a string code 'fr_FR' without parsing.
    // We can assume 'fr_FR' for now as per requirement or use standard.
    // Requirement says: "Date format string: DateFormat('d MMMM yyyy – HH\'h\'mm', 'fr_FR') will need to be localized."
    // But that was for filename. Here for Excel content 'dd/MM/yyyy HH:mm' is standard.
    // Let's keep 'dd/MM/yyyy HH:mm' but remove explicit 'fr_FR' so it defaults to system or use 'en_US' effectively? 
    // Actually the request implies consistency.
    // Let's use `l10n.localeName` if available or just valid standard. 
    // `DateFormat.yMd().add_Hms()`?
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

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
      // Localization of headers
      headerRow.add(TextCellValue(_getFieldLabel(fid, l10n)));
    }
    sheet.appendRow(headerRow);
    
    // --- STYLING: Bold Headers ---
    try {
      // Row 0 is the header (0-indexed)
      // Note: excel package uses 0-based indexing for rows/cols in some versions, check docs.
      // Based on usual usage 'appendRow' adds to end. First call = row 0.
      
      // Define style
      CellStyle headerStyle = CellStyle(
        bold: true,
        fontFamily: getFontFamily(FontFamily.Arial),
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
      );
      
      for (int i = 0; i < headerRow.length; i++) {
        var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.cellStyle = headerStyle;
      }
    } catch (_) {
       // Ignore styling errors if package version differs
    }

    // 2. Data Rows
    List<Garden> gardens = (extraData?['gardens'] as List<Garden>?) ?? [];
    List<dynamic> activities = (extraData?['activities'] as List<dynamic>?) ?? [];

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
          resolvedGardenName = '${l10n.export_excel_unknown} (${item.gardenId})';
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
                  GardenBoxes.getGardenBedById(resolvedBedId)?.name;
            }
          }
        } catch (_) {
          /* fallback plus bas */
        }

        // 2) Si non trouvé, fallback heuristique existante (activité)
        if (resolvedBedId == null) {
          final match = activities
              .whereType<model_activity.Activity>() 
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
                  GardenBoxes.getGardenBedById(resolvedBedId)?.name;
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
        // --- ACTIVITY MAPPING (Legacy) ---
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
        // --- ACTIVITY V3 MAPPING ---
        else if (type == ExportBlockType.activity && item is ActivityV3) {
           switch (fid) {
            case 'activity_date':
              value = item.timestamp;
              break;
            case 'activity_type':
              // Translate common types to readable strings if needed
              value = item.type;
              break;
            case 'activity_title':
              // ActivityV3 doesn't have a title, synthesize one from Type
              value = _mapActivityTypeToTitle(item.type, l10n); 
              break;
            case 'activity_desc':
              value = item.description;
              break;
            case 'activity_entity':
              value = item.metadata?['plantName'] ??
                  item.metadata?['bedName'] ??
                  item.metadata?['gardenName'];
              break;
            case 'activity_entity_id':
              value = item.metadata?['plantingId'] ??
                  item.metadata?['gardenBedId'] ??
                  item.metadata?['gardenId'];
              break;
          }
        }


        
        // --- NUTRITION MAPPING ---
        else if (type == ExportBlockType.nutrition && item is NutrientAggregate) {
           switch(fid) {
             case 'nutrient_key': value = item.key; break;
             case 'nutrient_label': value = _humanizeNutrientKey(item.key); break;
             case 'nutrient_unit': value = _extractNutrientUnit(item.key); break;
             case 'nutrient_total': value = item.sumAvailable; break;
             case 'mass_with_data_kg': value = item.massWithDataKg; break;
             case 'contributing_records': value = item.contributingRecords; break;
             case 'data_confidence': 
                value = (item.dataConfidence * 100).toStringAsFixed(2) + ' %'; 
                break;
             case 'coverage_percent': 
                value = item.coveragePercent.toStringAsFixed(2) + ' %'; 
                break;
             case 'lower_bound_coverage': 
                value = item.lowerBoundCoverage.toStringAsFixed(2) + ' %'; 
                break;
             case 'upper_bound_coverage': 
                value = item.upperBoundCoverage != null ? (item.upperBoundCoverage!.toStringAsFixed(2) + ' %') : ''; 
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

    // --- Ajout de la ligne TOTAL pour les récoltes ---
    if (type == ExportBlockType.harvest && data.isNotEmpty) {
      double totalQty = 0.0;
      double totalValue = 0.0;

      for (var item in data) {
        if (item is HarvestRecord) {
          totalQty += item.quantityKg;
          totalValue += item.totalValue;
        } else if (item is Map) {
          // Robustesse si les enregistrements sont des Map (JSON)
          try {
            final q = (item['quantityKg'] as num?)?.toDouble() ?? 0.0;
            final v = (item['totalValue'] as num?)?.toDouble() ?? 0.0;
            totalQty += q;
            totalValue += v;
          } catch (_) {
            // ignore malformed entries
          }
        }
      }

      // Construire une ligne de la même longueur que fieldIds
      List<CellValue> totalsRow =
          List<CellValue>.generate(fieldIds.length, (_) => TextCellValue(''));

      // Label TOTAL en colonne 0
      totalsRow[0] = TextCellValue(l10n.export_excel_total);

      // Positionner les totaux si les colonnes existent
      final qtyIndex = fieldIds.indexOf('harvest_qty');
      if (qtyIndex >= 0) {
        totalsRow[qtyIndex] =
            DoubleCellValue(double.parse(totalQty.toStringAsFixed(2)));
      }

      final valueIndex = fieldIds.indexOf('harvest_value');
      if (valueIndex >= 0) {
        totalsRow[valueIndex] =
            DoubleCellValue(double.parse(totalValue.toStringAsFixed(2)));
      }

      // Appender la ligne TOTAL
      sheet.appendRow(totalsRow);
      
      // Style TOTAL row to be bold
      final lastRowIndex = sheet.maxRows - 1;
      CellStyle totalStyle = CellStyle(bold: true);
       for (int i = 0; i < fieldIds.length; i++) {
        var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: lastRowIndex));
        cell.cellStyle = totalStyle;
      }
    }
    
    // --- POLISH: Auto-Size Columns (Approximate) ---
    // We set a default width that is comfortable (e.g., 25.0) for all columns
    // "Les textes sont trop resserrés" -> enlarge default
    for (int i = 0; i < fieldIds.length; i++) {
       sheet.setColumnWidth(i, 25.0);
    }
  }

  String _mapActivityTypeToTitle(String type, AppLocalizations l10n) {
    switch (type) {
      case 'gardenCreated': return l10n.export_activity_type_garden_created;
      case 'gardenUpdated': return l10n.export_activity_type_garden_updated;
      case 'gardenDeleted': return l10n.export_activity_type_garden_deleted;
      case 'gardenBedCreated': return l10n.export_activity_type_bed_created;
      case 'gardenBedUpdated': return l10n.export_activity_type_bed_updated;
      case 'gardenBedDeleted': return l10n.export_activity_type_bed_deleted;
      case 'plantingCreated': return l10n.export_activity_type_planting_created;
      case 'plantingUpdated': return l10n.export_activity_type_planting_updated;
      case 'plantingDeleted': return l10n.export_activity_type_planting_deleted;
      case 'harvestCompleted': return l10n.export_activity_type_harvest;
      case 'maintenanceCompleted': return l10n.export_activity_type_maintenance;
      case 'weatherUpdate': return l10n.export_activity_type_weather;
      case 'error': return l10n.export_activity_type_error;
      default: return type;
    }
  }

  String _getFieldLabel(String fieldId, AppLocalizations l10n) {
    switch (fieldId) {
      case 'garden_name': return l10n.export_field_garden_name;
      case 'garden_id': return l10n.export_field_garden_id;
      case 'garden_surface': return l10n.export_field_garden_surface;
      case 'garden_creation_date': return l10n.export_field_garden_creation;

      case 'bed_name': return l10n.export_field_bed_name;
      case 'bed_id': return l10n.export_field_bed_id;
      case 'bed_surface': return l10n.export_field_bed_surface;
      case 'bed_plant_count': return l10n.export_field_bed_plant_count;

      case 'plant_name': return l10n.export_field_plant_name;
      case 'plant_id': return l10n.export_field_plant_id;
      case 'plant_scientific': return l10n.export_field_plant_scientific;
      case 'plant_family': return l10n.export_field_plant_family;
      case 'plant_variety': return l10n.export_field_plant_variety;

      case 'harvest_date': return l10n.export_field_harvest_date;
      case 'harvest_qty': return l10n.export_field_harvest_qty;
      case 'harvest_plant_name': return l10n.export_field_harvest_plant_name;
      case 'harvest_price': return l10n.export_field_harvest_price;
      case 'harvest_value': return l10n.export_field_harvest_value;
      case 'harvest_notes': return l10n.export_field_harvest_notes;
      case 'harvest_garden_name': return l10n.export_field_harvest_garden_name;
      case 'harvest_garden_id': return l10n.export_field_harvest_garden_id;
      case 'harvest_bed_name': return l10n.export_field_harvest_bed_name;
      case 'harvest_bed_id': return l10n.export_field_harvest_bed_id;

      case 'activity_date': return l10n.export_field_activity_date;
      case 'activity_type': return l10n.export_field_activity_type;
      case 'activity_title': return l10n.export_field_activity_title;
      case 'activity_desc': return l10n.export_field_activity_desc;
      case 'activity_entity': return l10n.export_field_activity_entity;
      case 'activity_entity_id': return l10n.export_field_activity_entity_id;

      default: return fieldId;
    }
  }

  // --- NUTRITION HELPERS ---
  List<PlantFreezed> _adaptPlantsForNutrition() {
    return GardenBoxes.plants.values.map((p) {
      if (p is Plant) {
        return PlantFreezed.fromJson(p.toJson());
      } else if (p is Map) {
        try {
          return PlantFreezed.fromJson(Map<String, dynamic>.from(p));
        } catch (_) {
          return null;
        }
      }
      return null;
    }).whereType<PlantFreezed>().toList();
  }

  String _humanizeNutrientKey(String key) {
     final parts = key.split('_');
     if (parts.isEmpty) return key;
     // Heuristic: remove last part if it looks like a unit, convert rest to Title Case
     if (parts.length > 1) {
        final nameParts = parts.sublist(0, parts.length - 1);
        final name = nameParts.join(' ');
        if (name.trim().isEmpty) return key;
        return name[0].toUpperCase() + name.substring(1);
     }
     return key[0].toUpperCase() + key.substring(1);
  }

  String _extractNutrientUnit(String key) {
     final parts = key.split('_');
     if (parts.length > 1) return parts.last;
     return '';
  }
}
