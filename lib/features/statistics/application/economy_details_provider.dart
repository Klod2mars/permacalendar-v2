
import 'package:riverpod/riverpod.dart';
import '../../harvest/application/harvest_records_provider.dart';
import '../../planting/providers/planting_provider.dart';
import '../../harvest/domain/models/harvest_record.dart';
import '../../../core/models/planting.dart';

// --- DTOs ---

enum GroupBy { none, day, week, month, year }
enum AggregationPeriod { day, week, month, year }

class EconomyQueryParams {
  final Set<String> gardenIds;
  final DateTime startDate;
  final DateTime endDate;
  final GroupBy groupBy; // Optional, might be used for future drill-down
  final AggregationPeriod aggregationPeriod;

  EconomyQueryParams({
     this.gardenIds = const {},
    required this.startDate,
    required this.endDate,
    this.groupBy = GroupBy.month,
    this.aggregationPeriod = AggregationPeriod.month,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EconomyQueryParams &&
          runtimeType == other.runtimeType &&
          // Set equality check (naive but sufficient if order doesn't matter, usually setsEqual need deeper check)
          // We assume usage of sets that are comparable or we construct them consistently.
          // Better: use set equality helper if available, or simplified check.
          // For now, checks length and contains.
          gardenIds.length == other.gardenIds.length &&
          gardenIds.containsAll(other.gardenIds) &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          groupBy == other.groupBy &&
          aggregationPeriod == other.aggregationPeriod;

  @override
  int get hashCode =>
      Object.hashAll(gardenIds) ^
      startDate.hashCode ^
      endDate.hashCode ^
      groupBy.hashCode ^
      aggregationPeriod.hashCode;
}

// ... (skipping unchanged classes) ...

class PlantRanking {
  final String plantId;
  final String plantName;
  final double totalValue;
  final double totalKg;
  final double avgPricePerKg;
  final double percentShare;

  PlantRanking({
    required this.plantId,
    required this.plantName,
    required this.totalValue,
    required this.totalKg,
    required this.avgPricePerKg,
    required this.percentShare,
  });
}

class MonthRevenue {
  final int year;
  final int month;
  final double totalValue;
  
  DateTime get date => DateTime(year, month, 1);

  MonthRevenue({required this.year, required this.month, required this.totalValue});
}

class SeriesPoint {
  final DateTime date;
  final double value;

  SeriesPoint(this.date, this.value);
}

class FastLongMetrics {
  final String plantName;
  final double avgDaysToHarvest;
  final double avgRevenuePerHarvest;
  final String classification; // 'Fast', 'Medium', 'Long'

  FastLongMetrics({
    required this.plantName,
    required this.avgDaysToHarvest,
    required this.avgRevenuePerHarvest,
    required this.classification,
  });
}

class EconomyDetails {
  final double totalValue;
  final double totalKg;
  final double weightedAvgPrice;
  final int harvestCount;
  final List<PlantRanking> topPlants;
  final List<MonthRevenue> monthlyRevenue;
  final Map<int, PlantRanking> topPlantPerMonth; // Key: year*100 + month
  final List<SeriesPoint> revenueSeries;
  final Map<String, double> plantShare;
  final int mostProfitableMonthIndex; // Index in monthlyRevenue
  final int leastProfitableMonthIndex; // Index in monthlyRevenue
  final double diversityIndex;
  final String diversityLabel; 
  final List<String> top3Recommendations;
  final String recommendationText;
  final List<FastLongMetrics> fastVsLongTerm;

  EconomyDetails({
    required this.totalValue,
    required this.totalKg,
    required this.weightedAvgPrice,
    required this.harvestCount,
    required this.topPlants,
    required this.monthlyRevenue,
    required this.topPlantPerMonth,
    required this.revenueSeries,
    required this.plantShare,
    required this.mostProfitableMonthIndex,
    required this.leastProfitableMonthIndex,
    required this.diversityIndex,
    required this.diversityLabel,
    required this.top3Recommendations,
    required this.recommendationText,
    required this.fastVsLongTerm,
  });
  
  // Factory for empty state
  factory EconomyDetails.empty() {
    return EconomyDetails(
      totalValue: 0.0,
      totalKg: 0.0,
      weightedAvgPrice: 0.0,
      harvestCount: 0,
      topPlants: [],
      monthlyRevenue: [],
      topPlantPerMonth: {},
      revenueSeries: [],
      plantShare: {},
      mostProfitableMonthIndex: -1,
      leastProfitableMonthIndex: -1,
      diversityIndex: 0.0,
      diversityLabel: 'N/A',
      top3Recommendations: [],
      recommendationText: 'Pas assez de données.',
      fastVsLongTerm: [],
    );
  }
}

// --- Provider ---

final economyDetailsProvider =
    Provider.family<EconomyDetails, EconomyQueryParams>((ref, params) {
  final harvestState = ref.watch(harvestRecordsProvider);
  // Need plantings for Fast vs Long term analysis
  final plantingsState = ref.watch(plantingProvider); 
  
  final plantings = plantingsState.plantings; // List<Planting>

  if (harvestState.isLoading || harvestState.records.isEmpty) {
    return EconomyDetails.empty();
  }

  // 1. Filtering
  final filteredRecords = harvestState.records.where((record) {
    if (params.gardenIds.isNotEmpty && !params.gardenIds.contains(record.gardenId)) {
      return false;
    }
    // Timezone normalization for inclusive comparison
    return !record.date.isBefore(params.startDate) &&
           !record.date.isAfter(params.endDate);
  }).toList();

  if (filteredRecords.isEmpty) {
    return EconomyDetails.empty();
  }

  // 2. Aggregate Totals
  double totalVal = 0.0;
  double totalKg = 0.0;
  int count = 0;

  // For grouping
  final Map<String, List<HarvestRecord>> plantsMap = {};
  
  // For monthly buckets
  final Map<int, List<HarvestRecord>> monthlyBuckets = {}; // Key: year*100 + month

  for (final r in filteredRecords) {
    totalVal += r.totalValue;
    totalKg += r.quantityKg;
    count++;
    
    // Group by plant (using plantId + name as key is safer, but name is used for display)
    // We'll trust plantId is present, fall back to name or 'unknown'
    final plantKey = r.plantId.isNotEmpty ? r.plantId : (r.plantName ?? 'unknown');
    plantsMap.putIfAbsent(plantKey, () => []).add(r);

    // Bucket by month (Local time normalization)
    final localDate = r.date.toLocal();
    final monthKey = localDate.year * 100 + localDate.month;
    monthlyBuckets.putIfAbsent(monthKey, () => []).add(r);
  }

  final weightedAvgPrice = totalKg > 0 ? totalVal / totalKg : 0.0;

  // 3. Plant Rankings
  final List<PlantRanking> rankings = [];
  for (final entry in plantsMap.entries) {
    final plantRecords = entry.value;
    final pName = plantRecords.first.plantName ?? 'Inconnu';
    final pId = entry.key;
    
    double pVal = 0.0;
    double pKg = 0.0;
    for (final r in plantRecords) {
      pVal += r.totalValue;
      pKg += r.quantityKg;
    }
    
    final share = totalVal > 0 ? (pVal / totalVal) * 100 : 0.0;
    final avgPrice = pKg > 0 ? pVal / pKg : 0.0;

    rankings.add(PlantRanking(
      plantId: pId,
      plantName: pName,
      totalValue: pVal,
      totalKg: pKg,
      avgPricePerKg: avgPrice,
      percentShare: share,
    ));
  }
  
  // Sort descending by value
  rankings.sort((a, b) => b.totalValue.compareTo(a.totalValue));
  
  // 4. Monthly Revenue & Top Plant Per Month
  final List<MonthRevenue> monthlyRevenueList = [];
  final Map<int, PlantRanking> topPlantMonthMap = {};
  
  // Sorted keys
  final sortedMonthKeys = monthlyBuckets.keys.toList()..sort();
  
  for (final mKey in sortedMonthKeys) {
    final recordsInMonth = monthlyBuckets[mKey]!;
    final year = mKey ~/ 100;
    final month = mKey % 100;
    
    double mVal = 0.0;
    final Map<String, double> mPlantVal = {};
    
    for (final r in recordsInMonth) {
      mVal += r.totalValue;
      final pKey = r.plantId.isNotEmpty ? r.plantId : (r.plantName ?? 'unknown');
      mPlantVal[pKey] = (mPlantVal[pKey] ?? 0.0) + r.totalValue;
    }
    
    monthlyRevenueList.add(MonthRevenue(year: year, month: month, totalValue: mVal));
    
    // Find top plant for this month
    if (mPlantVal.isNotEmpty) {
      // Find max entry
      var bestEntry = mPlantVal.entries.first;
      for (final e in mPlantVal.entries) {
        if (e.value > bestEntry.value) bestEntry = e;
      }
      
      // Need full ranking info for this plant? 
      // We can look it up in the main rankings or recompute. 
      // Simplified: Just create a specialized ranking or reuse logic.
      // Reusing logic (retrieving name from main map if possible)
      final bestRecs = recordsInMonth.where((r) => (r.plantId == bestEntry.key || (r.plantId.isEmpty && r.plantName == bestEntry.key))).toList();
      String bestName = bestRecs.isNotEmpty ? (bestRecs.first.plantName ?? 'Inconnu') : 'Inconnu';
      
      // Compute stats for just this month for this plant
      double bestPkg = 0;
      for (final r in bestRecs) bestPkg += r.quantityKg;
      
      topPlantMonthMap[mKey] = PlantRanking(
        plantId: bestEntry.key,
        plantName: bestName,
        totalValue: bestEntry.value,
        totalKg: bestPkg,
        avgPricePerKg: bestPkg > 0 ? bestEntry.value / bestPkg : 0.0,
        percentShare: mVal > 0 ? (bestEntry.value / mVal) * 100 : 0.0, // share of the month
      );
    }
  }

  // 5. Revenue Series (Annual Curve)
  final List<SeriesPoint> revenueSeries = monthlyRevenueList.map((mr) {
    return SeriesPoint(DateTime(mr.year, mr.month, 1), mr.totalValue);
  }).toList();

  // 6. Plant Share (Pie)
  // Map<String, double>
  final Map<String, double> plantShareMap = {};
  for (final r in rankings) {
    plantShareMap[r.plantName] = r.percentShare;
  }

  // 7. Most/Least Profitable Month
  int mostProfIdx = -1;
  int leastProfIdx = -1;
  if (monthlyRevenueList.isNotEmpty) {
    double maxV = -1.0;
    double minV = double.maxFinite;
    
    for (int i = 0; i < monthlyRevenueList.length; i++) {
      final v = monthlyRevenueList[i].totalValue;
      if (v > maxV) {
        maxV = v;
        mostProfIdx = i;
      }
      if (v < minV) {
        minV = v;
        leastProfIdx = i;
      }
    }
  }

  // 8. Diversity Indicator (HHI)
  // p_i = value_i / totalValue
  // HHI = sum(p_i^2)
  // Score = 1 - HHI
  double hhi = 0.0;
  if (totalVal > 0) {
    for (final r in rankings) {
      final p_i = r.totalValue / totalVal;
      hhi += p_i * p_i;
    }
  }
  final diversityScore = 1.0 - hhi;
  
  String diversityLabel = 'Concentré';
  if (diversityScore > 0.7) diversityLabel = 'Très diversifié';
  else if (diversityScore > 0.45) diversityLabel = 'Moyen';
  else diversityLabel = 'Peu diversifié';

  // 9. Recommendations
  // Top 3 names + text
  final top3 = rankings.take(3).toList();
  final top3Names = top3.map((r) => r.plantName).toList();
  
  String recText = '';
  if (top3.isNotEmpty) {
    final first = top3[0];
    recText = 'Vos trois cultures les plus rentables sont ${top3Names.join(", ")}. '
              '${first.plantName} représente ${first.percentShare.toStringAsFixed(1)}% du revenu.';
  } else {
    recText = 'Aucune donnée pour générer des recommandations.';
  }

  // 10. Fast vs Long Term Analysis
  final List<FastLongMetrics> fastLongList = [];
  
  // We process per plant type (aggregate)
  for (final pEntry in plantsMap.entries) {
    final plantId = pEntry.key;
    final pRecs = pEntry.value;
    final pName = pRecs.first.plantName ?? 'Inconnu';
    
    // Calculate Avg Revenue Per Harvest
    double sumRev = 0;
    for (final r in pRecs) sumRev += r.totalValue;
    final avgRev = pRecs.isNotEmpty ? sumRev / pRecs.length : 0.0;
    
    // Calculate Avg Days To Harvest
    // Attempt matching with plantings
    List<int> daysList = [];
    
    for (final r in pRecs) {
        // Strategy: 
        // 1. Try to find planting with matching ID (if we had plantingId in HarvestRecord, but assumed missing or partial)
        // 2. Fallback: Find most recent planting of same plantId BEFORE harvest date
        // Note: r.plantingId might not exist on HarvestRecord yet unless we modify it.
        // The prompt says: "Requiert rapprochement Planting <-> HarvestRecord... or calculate only if Planting contains actualHarvestDate"
        
        // Let's assume we search in `plantings` list for a matching plantId
        // Filter plantings for this plant
        final validPlantings = plantings.where((p) => p.plantId == plantId && p.plantedDate.isBefore(r.date)).toList();
        
        if (validPlantings.isNotEmpty) {
             // Find closest
             validPlantings.sort((a, b) => b.plantedDate.compareTo(a.plantedDate)); // Descending dates
             final bestP = validPlantings.first;
             final days = r.date.difference(bestP.plantedDate).inDays;
             if (days >= 0) {
                 daysList.add(days);
             }
        }
    }
    
    if (daysList.isNotEmpty) {
        final avgDays = daysList.reduce((a, b) => a + b) / daysList.length;
        
        String classification = 'Général';
        if (avgDays <= 60) classification = 'Rapide';
        else if (avgDays <= 180) classification = 'Moyen';
        else classification = 'Long terme';
        
        fastLongList.add(FastLongMetrics(
            plantName: pName,
            avgDaysToHarvest: avgDays,
            avgRevenuePerHarvest: avgRev,
            classification: classification,
        ));
    }
  }

  return EconomyDetails(
    totalValue: totalVal,
    totalKg: totalKg,
    weightedAvgPrice: weightedAvgPrice,
    harvestCount: count,
    topPlants: rankings,
    monthlyRevenue: monthlyRevenueList,
    topPlantPerMonth: topPlantMonthMap,
    revenueSeries: revenueSeries,
    plantShare: plantShareMap,
    mostProfitableMonthIndex: mostProfIdx,
    leastProfitableMonthIndex: leastProfIdx,
    diversityIndex: diversityScore,
    diversityLabel: diversityLabel,
    top3Recommendations: top3Names,
    recommendationText: recText,
    fastVsLongTerm: fastLongList,
  );
});
