# 🔄 Intelligence Evolution Tracker - Usage Guide

## Overview

The `PlantIntelligenceEvolutionTracker` is a domain service that compares two intelligence analysis sessions for the same garden to detect plant health evolution.

**Status:** ✅ Implemented and injected into orchestrator (not yet actively integrated)

**Implemented in:** CURSOR PROMPT A3

---

## Architecture

- **Location:** `lib/features/plant_intelligence/domain/services/plant_intelligence_evolution_tracker.dart`
- **Type:** Pure domain service (no side effects)
- **Dependencies:** None
- **Test Coverage:** ✅ 8 test cases covering all scenarios

---

## Key Features

### 1. Report Comparison
- Compares two `PlantIntelligenceReport` objects (old vs new)
- Detects health improvements or degradations
- Tracks confidence changes
- Identifies recommendation changes (added/removed/modified)
- Detects timing shifts (seasonality changes)

### 2. Tolerance Threshold
- Configurable tolerance to ignore minor deltas
- Default: 1% (0.01)
- Prevents noise from insignificant fluctuations

### 3. Garden-wide Comparison
- Compare multiple plant reports simultaneously
- Identify overall garden health trends

---

## Data Structures

### IntelligenceEvolutionSummary

```dart
class IntelligenceEvolutionSummary {
  final String plantId;
  final String plantName;
  final double scoreDelta;              // Positive = improvement
  final double confidenceDelta;         // Positive = more confident
  final List<String> addedRecommendations;
  final List<String> removedRecommendations;
  final List<String> modifiedRecommendations;
  final bool isImproved;
  final bool isStable;
  final bool isDegraded;
  final double timingScoreShift;
  final PlantIntelligenceReport oldReport;
  final PlantIntelligenceReport newReport;
  final DateTime comparedAt;
}
```

---

## Usage Examples

### Example 1: Single Plant Comparison

```dart
// Create tracker instance
final tracker = PlantIntelligenceEvolutionTracker(
  enableLogging: true,
  toleranceThreshold: 0.01, // 1%
);

// Compare two reports
final summary = tracker.compareReports(oldReport, newReport);

// Check results
if (summary.isImproved) {
  print("✅ Plant ${summary.plantName} is doing better!");
  print("   Score improved by ${summary.scoreDelta.toStringAsFixed(1)} points");
}

// Check for new recommendations
if (summary.addedRecommendations.isNotEmpty) {
  print("📋 New recommendations:");
  for (final rec in summary.addedRecommendations) {
    print("   - $rec");
  }
}
```

### Example 2: Garden-wide Comparison

```dart
// Compare all plants in a garden
final summaries = tracker.compareGardenReports(
  oldReports,  // Previous analysis session
  newReports,  // Current analysis session
);

// Count improvements vs degradations
final improved = summaries.where((s) => s.isImproved).length;
final degraded = summaries.where((s) => s.isDegraded).length;
final stable = summaries.where((s) => s.isStable).length;

print("📊 Garden Evolution Summary:");
print("   ✅ Improved: $improved plants");
print("   ⚠️ Degraded: $degraded plants");
print("   ➡️ Stable: $stable plants");
```

### Example 3: Using Extension Methods

```dart
final summary = tracker.compareReports(oldReport, newReport);

// Get human-readable description
print(summary.description);
// Output: "📈 Tomato : Santé en amélioration ! Score : +15.0 points. 1 recommandation résolue."

// Check if there are significant changes
if (summary.hasSignificantChanges) {
  print("Significant changes detected!");
}

// Get time between reports
print("Time between analyses: ${summary.timeBetweenReportsText}");
// Output: "Time between analyses: 2 jours"
```

---

## Future Integration

### Recommended Integration Points

1. **In `generateIntelligenceReport()`:**
   - Fetch previous report from cache/database
   - Compare with new report
   - Attach evolution summary to report metadata
   - Log evolution trends for user notifications

2. **In `generateGardenIntelligenceReport()`:**
   - Compare all plant reports with previous session
   - Generate garden-wide evolution trends
   - Highlight plants that need attention (degraded)
   - Celebrate improvements

3. **In UI/Dashboard:**
   - Display evolution trends with charts
   - Show "Plant of the Week" (most improved)
   - Alert users to degrading plants
   - Track long-term health patterns

### Sample Integration Code

```dart
Future<PlantIntelligenceReport> generateIntelligenceReport({
  required String plantId,
  required String gardenId,
  PlantFreezed? plant,
}) async {
  // ... existing code ...
  
  // 🔄 NEW: Compare with previous report if available
  IntelligenceEvolutionSummary? evolutionSummary;
  if (_evolutionTracker != null) {
    try {
      final previousReport = await _analyticsRepository.getLastReport(plantId);
      if (previousReport != null) {
        evolutionSummary = _evolutionTracker!.compareReports(
          previousReport,
          report,
        );
        
        developer.log(
          '${evolutionSummary.statusEmoji} ${evolutionSummary.description}',
          name: 'PlantIntelligenceOrchestrator',
        );
        
        // Add to metadata
        report = report.copyWith(
          metadata: {
            ...report.metadata,
            'evolution': evolutionSummary.toJson(),
          },
        );
      }
    } catch (e) {
      developer.log('Error comparing evolution: $e', level: 900);
    }
  }
  
  return report;
}
```

---

## Configuration Options

### Tolerance Threshold

Adjust tolerance to control sensitivity:

```dart
// Very sensitive (detect even 0.1% changes)
final sensitiveTracker = PlantIntelligenceEvolutionTracker(
  toleranceThreshold: 0.001,
);

// Less sensitive (ignore changes < 5%)
final relaxedTracker = PlantIntelligenceEvolutionTracker(
  toleranceThreshold: 5.0,
);
```

### Debug Logging

Enable detailed logs during development:

```dart
final tracker = PlantIntelligenceEvolutionTracker(
  enableLogging: true, // Log all comparisons
);
```

---

## Test Coverage

✅ All 8 test cases passing:

1. ✅ Detect health improvement when score increases
2. ✅ Detect health degradation when score decreases
3. ✅ Detect stable health when no significant changes
4. ✅ Detect timing score changes
5. ✅ Throw ArgumentError when comparing different plants
6. ✅ Compare multiple reports for whole garden
7. ✅ Ignore changes within tolerance threshold
8. ✅ Extension methods provide helpful utilities

**Test File:** `test/features/plant_intelligence/domain/services/plant_intelligence_evolution_tracker_test.dart`

---

## Benefits

1. **User Engagement:** Users can see their gardening progress over time
2. **Early Warning:** Detect degrading plant health before it's critical
3. **Motivation:** Celebrate improvements and resolved issues
4. **Data-Driven:** Make informed decisions based on trends
5. **Historical Context:** Understand seasonal patterns and long-term health

---

## Next Steps

To activate this feature:

1. Add repository method to fetch previous reports
2. Integrate comparison logic in orchestrator
3. Add UI components to display evolution trends
4. Create notification system for significant changes
5. Build historical trend charts

---

## Related Documentation

- [Plant Intelligence Orchestrator](./plant_intelligence_orchestrator.dart)
- [Intelligence Report](../entities/intelligence_report.dart)
- [Recommendation](../entities/recommendation.dart)
- [Test Suite](../../../../test/features/plant_intelligence/domain/services/plant_intelligence_evolution_tracker_test.dart)

---

**Created:** CURSOR PROMPT A3  
**Status:** ✅ Ready for integration  
**Maintainer:** Domain Layer - Plant Intelligence Feature

