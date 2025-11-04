# 📊 A9 - Visual Implementation Guide

## Quick Reference for Evolution Timeline UI Integration

---

## 🎯 Implementation Overview

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  PlantIntelligenceDashboardScreen                  │
│  ┌───────────────────────────────────────────────┐ │
│  │ Actions Rapides                               │ │
│  │                                               │ │
│  │ 🐛 Signaler un ravageur                      │ │
│  │ 🌿 Lutte biologique                          │ │
│  │ 📊 Historique d'évolution          [NEW!]   │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  User taps ───────────────────────────────────────┐│
│                                                    ││
└────────────────────────────────────────────────────┘│
                                                      │
                                                      ↓
┌─────────────────────────────────────────────────────┐
│  Plant Selection Modal                              │
│  ┌───────────────────────────────────────────────┐ │
│  │ Historique d'évolution                        │ │
│  │ Sélectionnez une plante                       │ │
│  │                                               │ │
│  │  🌱 Tomate Cerise                      →     │ │
│  │     Solanum lycopersicum                     │ │
│  │                                               │ │
│  │  🌱 Carotte                            →     │ │
│  │     Daucus carota                             │ │
│  │                                               │ │
│  └───────────────────────────────────────────────┘ │
│                                                     │
│  User selects plant ──────────────────────────────┐│
│                                                    ││
└────────────────────────────────────────────────────┘│
                                                      │
                                                      ↓
┌─────────────────────────────────────────────────────┐
│  PlantEvolutionHistoryScreen                        │
│  ┌───────────────────────────────────────────────┐ │
│  │ Historique d'évolution                        │ │
│  │ Tomate Cerise                                 │ │
│  │                                               │ │
│  │  Évolutions: 5  │  Améliorations: 2          │ │
│  │  Dégradations: 2 │  Stables: 1               │ │
│  │                                               │ │
│  │  [Tous] [30j] [90j] [1 an]                   │ │
│  │                                               │ │
│  │  ●─── 15 Jan 2024 ────  📈 +5.0 pts         │ │
│  │  │                                           │ │
│  │  ●─── 22 Jan 2024 ────  📉 -3.0 pts         │ │
│  │  │                                           │ │
│  │  ●─── 29 Jan 2024 ────  ➡️  +0.5 pts        │ │
│  │                                               │ │
│  └───────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

---

## 🌿 Degradation Banner Flow

```
PlantingDetailScreen
┌─────────────────────────────────────────────────────┐
│                                                     │
│  IF (deltaScore < -1.0 OR trend == 'down'):         │
│  ┌─────────────────────────────────────────────┐   │
│  │ ⚠️  Santé en baisse                    ▼   │   │
│  │     Score baissé de 5.0 points en 7 jours  │   │
│  │                                             │   │
│  │  [EXPANDED STATE]                           │   │
│  │  ┌────────────────┬────────────────┐       │   │
│  │  │ Score actuel   │ Variation      │       │   │
│  │  │    72.0        │  -5.0 pts      │       │   │
│  │  └────────────────┴────────────────┘       │   │
│  │                                             │   │
│  │  Conditions affectées:                      │   │
│  │  [↓ Eau]  [↓ Nutriments]  [↓ Lumière]     │   │
│  │                                             │   │
│  │  [📊 Voir l'historique complet]           │   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
│  ELSE: No banner shown                              │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │ Header with plant info                      │   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
└─────────────────────────────────────────────────────┘

User taps button ───────────────────────────────────┐
                                                     │
                                                     ↓
                        PlantEvolutionHistoryScreen
```

---

## 🎨 Component Structure

### PlantHealthDegradationBanner

```dart
PlantHealthDegradationBanner(
  plantId: String,        // Required
  plantName: String,      // Required
  isExpandable: bool,     // Optional (default: true)
)

States:
  - Hidden (no degradation detected)
  - Collapsed (summary only)
  - Expanded (full details)
```

**Conditional Logic**:
```dart
if (deltaScore < -1.0 || trend == 'down') {
  // Show banner
} else {
  // Hide banner
}
```

---

## 📁 File Structure

```
lib/features/plant_intelligence/presentation/
├── screens/
│   ├── plant_intelligence_dashboard_screen.dart
│   │   ├── _showPlantSelectionForEvolution()    [NEW]
│   │   └── _navigateToEvolutionHistory()        [NEW]
│   └── plant_evolution_history_screen.dart      [EXISTING]
│
├── widgets/
│   └── plant_health_degradation_banner.dart      [NEW]
│
└── providers/
    └── plant_evolution_providers.dart            [EXISTING]

lib/features/planting/presentation/screens/
└── planting_detail_screen.dart                   [MODIFIED]
    └── Added PlantHealthDegradationBanner

test/features/plant_intelligence/presentation/
├── widgets/
│   └── plant_health_degradation_banner_test.dart [NEW]
└── integration/
    └── evolution_timeline_integration_test.dart  [NEW]
```

---

## 🔌 Provider Integration

```dart
// Latest evolution for a plant
final latestEvolution = ref.watch(
  latestEvolutionProvider('plant-id')
);

// Full history
final history = ref.watch(
  plantEvolutionHistoryProvider('plant-id')
);

// Filtered history (30 days)
final filtered = ref.watch(
  filteredEvolutionHistoryProvider(
    FilterParams(plantId: 'plant-id', days: 30)
  )
);

// Current filter selection
final filter = ref.watch(selectedTimePeriodProvider);
```

---

## 🎯 Key Integration Points

### 1. Dashboard Quick Actions

**Location**: `plant_intelligence_dashboard_screen.dart`  
**Line**: ~2547-2610

```dart
// Action 3 : Historique d'évolution
Card(
  child: InkWell(
    onTap: hasGarden 
      ? () => _showPlantSelectionForEvolution(context, intelligenceState)
      : null,
    child: Row(
      children: [
        Icon(Icons.timeline),
        Text('📊 Historique d\'évolution'),
        Icon(Icons.arrow_forward_ios),
      ],
    ),
  ),
)
```

### 2. Plant Selection Modal

**Location**: `plant_intelligence_dashboard_screen.dart`  
**Method**: `_showPlantSelectionForEvolution()`  
**Line**: ~3290-3460

```dart
showModalBottomSheet(
  builder: (context) => DraggableScrollableSheet(
    builder: (context, scrollController) {
      return ListView.builder(
        itemCount: activePlants.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () => _navigateToEvolutionHistory(...),
            ),
          );
        },
      );
    },
  ),
);
```

### 3. Degradation Banner

**Location**: `planting_detail_screen.dart`  
**Line**: ~106-109

```dart
SingleChildScrollView(
  child: Column(
    children: [
      // ✅ CURSOR PROMPT A9 - Health Degradation Banner
      PlantHealthDegradationBanner(
        plantId: planting.plantId,
        plantName: planting.plantName,
      ),
      
      // Rest of planting detail...
      _buildHeader(...),
      _buildStatusSection(...),
      // ...
    ],
  ),
)
```

---

## 🧪 Testing Strategy

### Widget Tests

```dart
testWidgets('should not display when no degradation', (tester) async {
  // Arrange
  final evolution = PlantEvolutionReport(
    deltaScore: 5.0,  // Positive
    trend: 'up',
  );
  
  // Act
  await tester.pumpWidget(...);
  
  // Assert
  expect(find.text('⚠️'), findsNothing);
});

testWidgets('should display when degraded', (tester) async {
  // Arrange
  final evolution = PlantEvolutionReport(
    deltaScore: -5.0,  // Negative > 1
    trend: 'down',
  );
  
  // Act
  await tester.pumpWidget(...);
  
  // Assert
  expect(find.text('⚠️'), findsOneWidget);
  expect(find.text('Santé en baisse'), findsOneWidget);
});
```

### Integration Tests

```dart
testWidgets('Dashboard to Timeline navigation', (tester) async {
  // Act
  await tester.tap(find.text('📊 Historique d\'évolution'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Tomate Cerise'));
  await tester.pumpAndSettle();
  
  // Assert
  expect(find.byType(PlantEvolutionHistoryScreen), findsOneWidget);
});
```

---

## 🚀 Deployment Checklist

- [x] All files created and modified
- [x] Imports added correctly
- [x] No linter errors
- [x] Code formatted
- [x] Widget tests passing
- [x] Integration tests passing
- [x] Documentation complete
- [x] Clean architecture respected
- [x] No direct DB access in UI
- [x] Providers used correctly
- [x] Animations smooth
- [x] Responsive design
- [x] Empty states handled
- [x] Error states handled

---

## 📚 Quick Reference

### Important Methods

| Method | Purpose | Location |
|--------|---------|----------|
| `_showPlantSelectionForEvolution()` | Shows plant selection modal | dashboard_screen.dart:3293 |
| `_navigateToEvolutionHistory()` | Navigates to timeline | dashboard_screen.dart:3467 |
| `_shouldShowBanner()` | Checks if banner should display | plant_health_degradation_banner.dart:94 |
| `_toggleExpanded()` | Toggles banner state | plant_health_degradation_banner.dart:329 |

### Key Providers

| Provider | Returns | Use Case |
|----------|---------|----------|
| `latestEvolutionProvider` | `PlantEvolutionReport?` | Banner conditional display |
| `plantEvolutionHistoryProvider` | `List<PlantEvolutionReport>` | Full timeline |
| `filteredEvolutionHistoryProvider` | `List<PlantEvolutionReport>` | Filtered timeline |
| `selectedTimePeriodProvider` | `int?` | Current filter selection |

---

## 💡 Tips for Future Modifications

1. **Adding New Filters**: Modify `_buildTimeFilter()` in `plant_evolution_timeline.dart`
2. **Changing Banner Colors**: Update color constants in `plant_health_degradation_banner.dart`
3. **Adjusting Conditions**: Modify `_shouldShowBanner()` logic
4. **Adding Animations**: Use `AnimationController` in banner state
5. **Custom Icons**: Replace `Icons.timeline` with custom asset

---

## 🎓 Summary

**What was built**:
- Dashboard button → Plant selection → Evolution timeline
- Conditional health degradation banner in planting detail
- Full navigation flow with proper state management
- Comprehensive test coverage (widget + integration)

**Key achievements**:
- Clean architecture maintained
- No direct database access
- Proper provider usage
- Responsive design
- Smooth animations
- Complete test coverage

**Status**: ✅ **READY FOR PRODUCTION**

---

**Visual Guide v1.0** | Created: 12 Oct 2025

