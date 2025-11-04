# 📋 Manual Testing Plan - Plant Intelligence Orchestrator

## 🎯 Objective

Validate the complete initialization and intelligence analysis flow on real devices after unit tests pass.

**Feature**: Plant Intelligence Orchestrator with robust initialization and cleanup
**Components Under Test**:
- `PlantIntelligenceOrchestrator.initializeForGarden()`
- `PlantIntelligenceOrchestrator.generateGardenIntelligenceReport()`
- Orphaned conditions cleanup
- Cache invalidation
- Error handling and graceful degradation

---

## ✅ Prerequisites

Before starting manual tests:

1. ✅ All unit tests in `plant_intelligence_orchestrator_test.dart` must pass
2. ✅ Build succeeds without warnings
3. ✅ Test device/emulator running Flutter (Android/iOS)
4. ✅ Access to developer logs (`flutter logs` or Android Studio Logcat)
5. ✅ Fresh install of the app (no cached data) recommended for first scenario

---

## 🧪 Test Scenarios

### SCENARIO 1: Initial Garden with Valid Plant

**Objective**: Verify complete flow from initialization to successful analysis

#### Setup
1. Start with a clean install (clear app data) or create a new garden
2. Ensure `plants.json` is properly loaded in the app
3. Have developer logs open

#### Steps
1. Create a new garden named "Test Garden 1"
2. Add one plant known to exist in `plants.json` (e.g., "spinach", "tomato", "lettuce")
3. Navigate to the Intelligence/Analysis screen
4. Tap "Analyze Garden" button

#### Expected Results
✅ Analysis completes successfully without crashes
✅ Intelligence report is displayed with:
   - Plant name and details
   - Health score (0-100)
   - Recommendations (if any)
   - Planting timing information
   - Confidence level (0-1)

#### Log Verification
Search logs for the following sequence:
```
🚀 Initialisation pour jardin [gardenId]
🧹 Étape 1/2 : Nettoyage des conditions orphelines
✅ Nettoyage terminé : X condition(s) supprimée(s)
🧹 Étape 2/2 : Invalidation des caches
✅ Caches invalidés avec succès
✅ Initialisation complète avec succès
🧹 Début invalidation de tous les caches
✅ Cache GardenAggregationHub invalidé
Génération rapport intelligence pour jardin [gardenId]
✅ X rapports générés
```

#### Pass Criteria
- [ ] No crashes or exceptions
- [ ] All log messages appear in correct order
- [ ] Intelligence report displays valid data
- [ ] UI is responsive

---

### SCENARIO 2: Remove Plant → Orphan Condition Cleared

**Objective**: Verify orphaned conditions are properly cleaned up

#### Setup
1. Continue from SCENARIO 1 (garden with 1 plant already analyzed)
2. Logs must be cleared/marked for new test

#### Steps
1. Note the plant ID that was analyzed
2. Go to garden management
3. **Remove** the plant from the garden (or mark as inactive)
4. Navigate back to Intelligence screen
5. Tap "Analyze Garden" again

#### Expected Results
✅ No crash when analyzing garden without the plant
✅ Previously stored conditions for removed plant are cleaned
✅ If garden is now empty → empty report or "No plants to analyze" message
✅ If other plants exist → only those are analyzed

#### Log Verification
Search for:
```
🧹 Début du nettoyage des conditions orphelines
📚 Récupération des plantes actives du catalogue...
✅ X plante(s) active(s) trouvée(s)
🔍 Analyse des conditions stockées...
🗑️ Conditions orphelines détectées: Y
🧹 Suppression des conditions orphelines...
✅ Y condition(s) orpheline(s) supprimée(s) avec succès
```

Where `Y > 0` (at least one orphaned condition removed)

#### Pass Criteria
- [ ] Orphaned conditions detected in logs (Y > 0)
- [ ] Cleanup completes without error
- [ ] No crash when re-analyzing
- [ ] Correct behavior for empty/non-empty garden

---

### SCENARIO 3: Add Invalid Plant (ID typo)

**Objective**: Verify graceful error handling for missing plant data

#### Setup
1. Use a test build with debug capabilities
2. Have a way to inject/simulate a plant with incorrect ID
   - Option A: Manually edit Hive data (advanced)
   - Option B: Use debug screen to add plant with typo (e.g., "spinnach" instead of "spinach")
   - Option C: Temporarily modify `plants.json` to break an ID

#### Steps
1. Create a garden
2. Add a plant with ID "spinnach" (typo - should be "spinach")
3. Navigate to Intelligence screen
4. Tap "Analyze Garden"

#### Expected Results
✅ App does NOT crash
✅ Error is logged but app continues
✅ UI shows graceful error message:
   - "Unable to analyze plant [plantId]"
   - OR "Some plants could not be analyzed"
✅ Other valid plants (if any) are still analyzed
✅ User can navigate away and retry

#### Log Verification
Search for:
```
❌ Plante "spinnach" introuvable dans le catalogue
PlantNotFoundException: plantId: spinnach, catalogSize: X
Erreur génération rapport pour plante spinnach: [exception details]
```

#### Pass Criteria
- [ ] PlantNotFoundException logged
- [ ] App continues without crash
- [ ] User sees helpful error message
- [ ] Other plants still analyzed

---

### SCENARIO 4: Empty Catalog

**Objective**: Verify system handles empty plant catalog gracefully

#### Setup
1. **WARNING**: This requires modifying app data or build configuration
2. Options:
   - Option A: Temporarily empty `assets/data/plants.json` and rebuild
   - Option B: Use a debug method to simulate empty catalog
   - Option C: Clear Hive plant box before analysis (requires debug build)

#### Steps
1. Ensure plant catalog is empty (getAllPlants() returns [])
2. Create a garden
3. Attempt to add any plant (should fail or show empty list)
4. Navigate to Intelligence screen
5. Tap "Analyze Garden"

#### Expected Results
✅ App does NOT crash
✅ `EmptyPlantCatalogException` is raised and logged
✅ User sees clear message:
   - "Plant catalog is empty"
   - "Please reload the app or contact support"
✅ Analysis halts gracefully (no partial results)

#### Log Verification
Search for:
```
❌ ERREUR: Le catalogue de plantes est vide!
EmptyPlantCatalogException: Le catalogue de plantes est vide. Vérifiez que plants.json est correctement chargé.
```

#### Pass Criteria
- [ ] EmptyPlantCatalogException logged
- [ ] No crash
- [ ] Clear error message to user
- [ ] No attempt to analyze plants

---

## 🔧 Additional Validation Tests

### TEST 5: Multiple Plants with Mixed Validity

**Setup**: Garden with 3 plants: 2 valid, 1 invalid

**Expected**: 
- 2 valid plants analyzed successfully
- 1 invalid plant logged as error
- Report shows 2 intelligence reports
- No crash

---

### TEST 6: Repeated Analysis (Idempotency)

**Setup**: Analyze same garden 3 times in a row

**Expected**:
- All 3 analyses complete successfully
- Cache invalidated each time
- Logs show consistent behavior
- No memory leaks or performance degradation

---

### TEST 7: Network/Weather Data Unavailable

**Setup**: Disable network or mock weather service failure

**Expected**:
- `PlantIntelligenceOrchestratorException` with message about weather
- No crash
- User notified about missing weather data

---

## 📊 Log Analysis Keywords

For each test, search logs for these indicators:

### ✅ Success Indicators
```
✅ Initialisation complète avec succès
✅ X rapports générés
✅ Cache GardenAggregationHub invalidé
✅ Nettoyage terminé
✅ Analyse terminée
```

### ⚠️ Warning Indicators (Non-blocking)
```
⚠️ Erreur lors du nettoyage (non bloquant)
⚠️ Erreur invalidation GardenAggregationHub (non bloquant)
⚠️ Initialisation terminée avec X avertissement(s)
```

### ❌ Error Indicators (Should be handled gracefully)
```
❌ Plante "X" introuvable dans le catalogue
❌ ERREUR: Le catalogue de plantes est vide!
❌ Erreur génération rapport pour plante X
PlantNotFoundException
EmptyPlantCatalogException
PlantIntelligenceOrchestratorException
```

---

## 🎯 Overall Acceptance Criteria

For the complete feature to be validated:

- [ ] **SCENARIO 1** passes completely
- [ ] **SCENARIO 2** passes completely
- [ ] **SCENARIO 3** passes completely
- [ ] **SCENARIO 4** passes completely
- [ ] All error cases are handled gracefully (no crashes)
- [ ] Logs show proper trace of all operations
- [ ] UI remains responsive in all scenarios
- [ ] Users receive clear feedback on errors
- [ ] Data integrity maintained (no corrupted Hive boxes)

---

## 🚨 Critical Failure Indicators

**STOP and report immediately if:**

1. ❌ Any scenario causes app crash
2. ❌ Hive data becomes corrupted (app won't restart)
3. ❌ Silent failures (no logs, no error, no result)
4. ❌ UI freezes or becomes unresponsive
5. ❌ Orphaned conditions are NOT cleaned up
6. ❌ Cache is NOT invalidated before analysis
7. ❌ Invalid plants cause entire analysis to fail

---

## 📝 Test Execution Checklist

### Pre-Test
- [ ] Unit tests passing
- [ ] Build successful
- [ ] Device/emulator ready
- [ ] Logs accessible
- [ ] Test data prepared

### During Test
- [ ] Record all log outputs
- [ ] Note any unexpected behavior
- [ ] Capture screenshots of errors
- [ ] Monitor memory/performance

### Post-Test
- [ ] Verify all scenarios passed
- [ ] Document any failures
- [ ] Check log completeness
- [ ] Validate data integrity

---

## 📞 Support Information

**Test Date**: _______________
**Tester**: _______________
**Device**: _______________
**Build Version**: _______________

**Results Summary**:
- Scenarios Passed: ____ / 4
- Scenarios Failed: ____
- Blockers Found: ____
- Warnings: ____

**Notes**:
```
[Add any additional observations, edge cases discovered, or suggestions]
```

---

## 🔄 Regression Testing

After any changes to:
- `PlantIntelligenceOrchestrator`
- `_cleanOrphanedConditionsInHive()`
- `invalidateAllCache()`
- `initializeForGarden()`
- `generateGardenIntelligenceReport()`

Re-run at minimum: SCENARIO 1, SCENARIO 2, and SCENARIO 3

---

**Document Version**: 1.0
**Created**: 2025-10-12
**Last Updated**: 2025-10-12
**Related**: `CURSOR_PROMPT_A2.md`, `plant_intelligence_orchestrator_test.dart`

