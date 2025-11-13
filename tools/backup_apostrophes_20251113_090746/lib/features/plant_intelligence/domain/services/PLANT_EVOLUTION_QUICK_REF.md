# 🚀 Plant Evolution Tracker - Quick Reference

## Basic Usage

```dart
// 1. Create tracker
final tracker = PlantEvolutionTrackerService();

// 2. Compare reports
final evolution = tracker.compareReports(
  previous: oldReport,
  current: newReport,
);

// 3. Check results
if (evolution.hasImproved) {
  print('📈 Plant improved by ${evolution.deltaScore} points');
} else if (evolution.hasDegraded) {
  print('📉 Plant degraded by ${evolution.deltaScore} points');
} else {
  print('➡️ Plant is stable');
}
```

---

## Quick Reference

### Trend Values
- `"up"` → Score increased by > 1.0 point
- `"down"` → Score decreased by > 1.0 point  
- `"stable"` → Score changed by < ±1.0 point

### Key Properties
```dart
evolution.plantId              // String
evolution.previousScore        // double
evolution.currentScore         // double
evolution.deltaScore           // double (can be negative)
evolution.trend                // "up" | "down" | "stable"
evolution.improvedConditions   // List<String>
evolution.degradedConditions   // List<String>
evolution.unchangedConditions  // List<String>
```

### Extension Methods
```dart
evolution.hasImproved          // bool
evolution.hasDegraded          // bool
evolution.isStable             // bool
evolution.description          // String (human-readable)
evolution.timeBetweenReports   // Duration
evolution.hasConditionChanges  // bool
evolution.improvementRate      // double (%)
evolution.degradationRate      // double (%)
```

---

## Common Patterns

### Pattern 1: UI Display
```dart
String getEmoji(PlantEvolutionReport evolution) {
  if (evolution.hasImproved) return '📈';
  if (evolution.hasDegraded) return '📉';
  return '➡️';
}

Color getColor(PlantEvolutionReport evolution) {
  if (evolution.hasImproved) return Colors.green;
  if (evolution.hasDegraded) return Colors.red;
  return Colors.grey;
}
```

### Pattern 2: Notifications
```dart
void notifyIfNeeded(PlantEvolutionReport evolution) {
  if (evolution.hasDegraded && evolution.deltaScore.abs() > 10) {
    sendAlert('Plant needs attention!');
  }
}
```

### Pattern 3: Historical Tracking
```dart
List<PlantEvolutionReport> buildHistory(List<PlantIntelligenceReport> reports) {
  final history = <PlantEvolutionReport>[];
  for (int i = 1; i < reports.length; i++) {
    history.add(tracker.compareReports(
      previous: reports[i - 1],
      current: reports[i],
    ));
  }
  return history;
}
```

---

## Configuration

### Default
```dart
final tracker = PlantEvolutionTrackerService();
// threshold: 1.0, logging: false
```

### Custom Threshold
```dart
final tracker = PlantEvolutionTrackerService(
  stabilityThreshold: 5.0,  // ±5 points = stable
  enableLogging: true,
);
```

---

## Error Handling

```dart
try {
  final evolution = tracker.compareReports(
    previous: report1,
    current: report2,
  );
} catch (e) {
  if (e is ArgumentError) {
    // Different plants
    print('Cannot compare different plants');
  }
}
```

---

## Condition Names

- `"temperature"` - Temperature status
- `"humidity"` - Humidity status
- `"light"` - Light status
- `"soil"` - Soil status

---

## Files

- **Model:** `plant_evolution_report.dart`
- **Service:** `plant_evolution_tracker_service.dart`
- **Tests:** `plant_evolution_tracker_service_test.dart`
- **Full Guide:** `PLANT_EVOLUTION_TRACKER_USAGE.md`
- **Report:** `RAPPORT_IMPLEMENTATION_A5_PLANT_EVOLUTION_TRACKER.md`

