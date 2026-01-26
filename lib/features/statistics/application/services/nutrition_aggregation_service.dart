import 'package:permacalendar/features/harvest/domain/models/harvest_record.dart'; // Adjust path if needed
import 'package:permacalendar/features/statistics/domain/models/nutrient_aggregation_result.dart';
import 'package:permacalendar/core/services/nutrition_normalizer.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';

class NutritionAggregationService {
  final List<PlantFreezed> plantCatalog;

  NutritionAggregationService(this.plantCatalog);

  /// Default DRI values (Adult Average) - acts as fallback if not provided
  /// Can be moved to a configuration file.
  static const Map<String, double> _defaultDri = {
    'calories_kcal': 2000,
    'protein_g': 50,
    'fiber_g': 30,
    'vitamin_a_mcg': 900,
    'vitamin_c_mg': 90,
    'vitamin_e_mg': 15,
    'vitamin_k_mcg': 120,
    'vitamin_b1_mg': 1.2,
    'vitamin_b2_mg': 1.3,
    'vitamin_b3_mg': 16,
    'vitamin_b6_mg': 1.7,
    'vitamin_b9_mcg': 400,
    'vitamin_b12_mcg': 2.4,
    'calcium_mg': 1000,
    'iron_mg': 18, // Femme (18), Homme (8) - Moyenne haute
    'magnesium_mg': 400,
    'potassium_mg': 4700,
    'zinc_mg': 11,
    'manganese_mg': 2.3,
    'phosphorus_mg': 700,
    'selenium_mcg': 55,
  };

  PlantFreezed? _findPlant(String plantId, String? plantName) {
    // ID match
    final byId = plantCatalog.where((p) => p.id == plantId).firstOrNull;
    if (byId != null) return byId;

    // Name match fallback
    if (plantName != null) {
      return plantCatalog
          .where((p) => p.commonName.toLowerCase() == plantName.toLowerCase())
          .firstOrNull;
    }
    return null;
  }

  Future<NutrientAggregationResult> aggregate(
    List<HarvestRecord> records, {
    required DateTime startDate,
    required DateTime endDate,
    Map<String, double>? customDri,
    bool estimateMissing = false, // Future use for upper bound
  }) async {
    final days = endDate.difference(startDate).inDays + 1;
    final driMap = customDri ?? _defaultDri;

    final totals = <String, double>{};
    final massWithData = <String, double>{};
    final counts = <String, int>{};
    // Initialize monthly map
    final monthly = <int, Map<String, double>>{};
    final monthlyCounts = <int, int>{};
    final monthlyMass = <int, double>{};
    for (var m = 1; m <= 12; m++) {
      monthly[m] = {};
      monthlyCounts[m] = 0;
      monthlyMass[m] = 0.0;
    }

    double totalMass = 0.0;

    for (final r in records) {
      if (r.quantityKg <= 0) continue;
      
      totalMass += r.quantityKg;

      // 1. Resolve Nutrition Snapshot
      Map<String, double> snapshot = {};

      // A. Existing snapshot in record (Legacy or frozen)
      if (r.nutritionSnapshot != null && r.nutritionSnapshot!.isNotEmpty) {
         snapshot = NutritionNormalizer.normalizeMap(Map<String, dynamic>.from(r.nutritionSnapshot!));
      } 
      // B. Compute from Catalog
      else {
        final plant = _findPlant(r.plantId, r.plantName);
        if (plant != null) {
           // 1. Try to get cached canonical from metadata
           Map<String, dynamic>? cached = plant.metadata['nutrition_canonical'] as Map<String, dynamic>?;
           
           if (cached != null) {
              snapshot = NutritionNormalizer.computeSnapshot(cached, r.quantityKg);
           } else {
              // 2. Fallback
              if (plant.nutritionPer100g != null) {
                 final canonical = NutritionNormalizer.normalizeMap(plant.nutritionPer100g!);
                 snapshot = NutritionNormalizer.computeSnapshot(canonical, r.quantityKg);
              }
           }
        }
      }

      if (snapshot.isEmpty) continue;

      final month = r.date.month;
      monthlyCounts[month] = (monthlyCounts[month] ?? 0) + 1;
      monthlyMass[month] = (monthlyMass[month] ?? 0.0) + r.quantityKg;

      // 2. Accumulate
      for (final e in snapshot.entries) {
        // Total
        totals[e.key] = (totals[e.key] ?? 0.0) + e.value;
        
        // Mass with Data
        massWithData[e.key] = (massWithData[e.key] ?? 0.0) + r.quantityKg;
        
        // Count
        counts[e.key] = (counts[e.key] ?? 0) + 1;
        
        // Monthly
        monthly[month]![e.key] = (monthly[month]![e.key] ?? 0.0) + e.value;
      }
    }

    final byNutrient = <String, NutrientAggregate>{};
    
    // We iterate over all INTERESTING keys (DRI keys + any found keys)
    final allKeys = <String>{}
      ..addAll(totals.keys)
      ..addAll(driMap.keys);

    for (final key in allKeys) {
      final sum = totals[key] ?? 0.0;
      final massData = massWithData[key] ?? 0.0;
      final cnt = counts[key] ?? 0;
      
      final confidence = totalMass > 0 
          ? (massData / totalMass).clamp(0.0, 1.0)
          : 0.0;

      final dri = driMap[key] ?? 0.0;
      
      final safeDays = days > 0 ? days : 1;
      
      final double coverage;
      if (dri > 0) {
        coverage = (sum / (dri * safeDays)) * 100.0; 
      } else {
        coverage = 0.0;
      }

      byNutrient[key] = NutrientAggregate(
        key: key,
        sumAvailable: sum,
        massWithDataKg: massData,
        contributingRecords: cnt,
        dataConfidence: confidence,
        coveragePercent: coverage,
        lowerBoundCoverage: coverage,
        upperBoundCoverage: estimateMissing && confidence > 0 
            ? (coverage / confidence) 
            : null,
      );
    }

    return NutrientAggregationResult(
      startDate: startDate,
      endDate: endDate,
      daysInPeriod: days,
      totalMassKg: totalMass,
      totalRecords: records.length,
      byNutrient: byNutrient,
      monthlyTotals: monthly,
      monthlyRecordCounts: monthlyCounts,
      monthlyMassKg: monthlyMass,
    );
  }
}
