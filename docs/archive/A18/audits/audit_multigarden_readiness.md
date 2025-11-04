# 🧩 Audit Multi-Garden Readiness for Intelligence Module

**Date:** 2025-10-12  
**Project:** PermaCalendar v2  
**Module:** Plant Intelligence System  
**Purpose:** Technical assessment for multi-garden expansion readiness

---

## I. Executive Summary

### Current State
The Plant Intelligence System is **functionally stable for single-garden operations** with reliable initialization, analysis, and UI synchronization. However, the system architecture currently assumes **a single active garden context** at any given time.

### Readiness Assessment
🟡 **PARTIALLY READY** - The system requires **moderate refactoring** to support concurrent multi-garden intelligence.

**Key Findings:**
- ✅ **Good foundation**: No global/static state barriers (except notification service)
- ✅ **Scoped providers**: Riverpod family providers already support parameterization
- ⚠️ **Implicit assumptions**: Multiple components assume single-garden context
- ⚠️ **Cache limitations**: Shared caches without garden-level isolation
- ⚠️ **Data model gaps**: PlantCondition/Recommendation lack explicit gardenId linkage

---

## II. Dependency Map & GardenId Flow

### A. State Management Layer

#### 1. IntelligenceStateProvider (`/lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart`)

**Current Implementation:**
```dart
class IntelligenceState {
  final String? currentGardenId;  // ⚠️ SINGLE GARDEN ONLY
  final List<String> activePlantIds;
  final Map<String, PlantCondition> plantConditions;
  final Map<String, List<Recommendation>> plantRecommendations;
  // ...
}
```

**Issues:**
- ❌ **Single garden assumption**: Only one `currentGardenId` can be active
- ❌ **Shared maps**: `plantConditions` and `plantRecommendations` are not indexed by garden
- ❌ **State collision risk**: Switching gardens would overwrite existing state

**Impact:**
- Switching between gardens would trigger full re-initialization
- No concurrent multi-garden data in memory
- Risk of stale data when rapidly switching contexts

---

#### 2. GardenAggregationHub (`/lib/core/services/aggregation/garden_aggregation_hub.dart`)

**Current Implementation:**
```dart
class GardenAggregationHub {
  final Map<String, dynamic> _cache = {};  // ⚠️ SHARED CACHE
  
  Future<UnifiedGardenContext> getUnifiedContext(String gardenId) async {
    final cacheKey = 'garden_context_$gardenId';
    if (_isCacheValid(cacheKey)) {
      return _cache[cacheKey];
    }
    // ...
  }
}
```

**Issues:**
- ✅ **Garden-scoped cache keys**: Already uses `gardenId` in cache keys
- ✅ **Single instance**: Uses instance-level cache (not static)
- ⚠️ **Cache invalidation**: `invalidateCache(gardenId)` only targets one garden
- ⚠️ **Memory growth**: No automatic cache eviction for inactive gardens

**Impact:**
- ✅ Already supports multi-garden caching at technical level
- ⚠️ Needs cache management strategy for multiple gardens

---

### B. Orchestration Layer

#### 3. PlantIntelligenceOrchestrator (`/lib/features/plant_intelligence/domain/services/plant_intelligence_orchestrator.dart`)

**Current Implementation:**
```dart
class PlantIntelligenceOrchestrator {
  Future<PlantIntelligenceReport> generateIntelligenceReport({
    required String plantId,
    required String gardenId,  // ✅ PARAMETERIZED
    PlantFreezed? plant,
  }) async {
    // ...
  }
  
  Future<void> invalidateAllCache() async {
    _gardenAggregationHub?.clearCache();  // ⚠️ CLEARS ALL GARDENS
  }
}
```

**Issues:**
- ✅ **Stateless design**: Orchestrator doesn't store gardenId as instance variable
- ✅ **Method-level scoping**: Each method receives gardenId as parameter
- ⚠️ **Cache invalidation**: `invalidateAllCache()` nukes all gardens indiscriminately
- ⚠️ **Hub dependency**: Single GardenAggregationHub instance shared across all gardens

**Impact:**
- ✅ Already multi-garden ready at method level
- ⚠️ Needs selective cache invalidation strategy

---

### C. Persistence Layer

#### 4. Hive Boxes (`/lib/features/plant_intelligence/data/datasources/plant_intelligence_local_datasource.dart`)

**Box Structure:**

| Box Name | Key Structure | Garden Linkage | Multi-Garden Ready? |
|----------|---------------|----------------|---------------------|
| `plant_conditions` | `conditionId` | ❌ Indirect via `plantId` | ⚠️ Needs gardenId index |
| `recommendations` | `recommendationId` | ❌ Indirect via `plantId` | ⚠️ Needs gardenId index |
| `weather_conditions` | `gardenId_timestamp` | ✅ Direct | ✅ Yes |
| `garden_contexts` | `gardenId` | ✅ Direct | ✅ Yes |
| `intelligence_reports` | `plantId` | ❌ Indirect | ⚠️ Needs gardenId |
| `evolution_reports` | `plantId_timestamp` | ❌ Indirect | ⚠️ Needs gardenId |

**Critical Issue:**
```dart
// PlantCondition entity
@freezed
class PlantCondition with _$PlantCondition {
  const factory PlantCondition({
    required String id,
    required String plantId,  // ❌ NO gardenId FIELD
    // ...
  }) = _PlantCondition;
}

// Recommendation entity
@freezed
class Recommendation with _$Recommendation {
  const factory Recommendation({
    required String id,
    required String plantId,  // ❌ NO gardenId FIELD
    // ...
  }) = _Recommendation;
}
```

**Issues:**
- ❌ **Missing gardenId**: Core entities don't store garden context
- ❌ **Implicit linkage**: Must traverse `plantId → plant → gardenBedId → gardenId`
- ⚠️ **Orphaned data risk**: Conditions/recommendations can't be efficiently filtered by garden
- ⚠️ **Cross-contamination risk**: Same plantId could theoretically exist in multiple gardens

**Impact:**
- High: Requires entity model changes
- Queries like "get all conditions for gardenX" would require loading ALL conditions and filtering

---

#### 5. Repository Implementations (`/lib/features/plant_intelligence/data/repositories/plant_intelligence_repository_impl.dart`)

**Current Query Pattern:**
```dart
Future<GardenContext?> getGardenContext(String gardenId) async {
  // ✅ Direct garden query - GOOD
}

Future<List<PlantCondition>> getPlantConditionHistory({
  required String plantId,  // ❌ No gardenId parameter
  DateTime? startDate,
  // ...
}) async {
  // Must load all conditions for plantId, no garden filtering
}
```

**Issues:**
- ⚠️ **No garden-level queries**: Can't efficiently retrieve all intelligence data for a garden
- ⚠️ **Plant-centric design**: Assumes plants are unique across system (not per-garden)

---

### D. UI Layer

#### 6. Dashboard Screen (`/lib/features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart`)

**Current Implementation:**
```dart
void initState() {
  // ...
  final gardenId = gardens.first.id;  // ❌ HARDCODED TO FIRST GARDEN
  ref.read(intelligenceStateProvider.notifier)
      .initializeForGarden(gardenId);
}
```

**Issues:**
- ❌ **Single garden assumption**: Always uses `gardens.first.id`
- ❌ **No garden selector**: No UI to switch between gardens
- ⚠️ **State overwrite**: Navigating to different garden would reset intelligence state

**Impact:**
- Critical: Fundamental UI architectural issue
- Must add garden selection/switching UI paradigm

---

#### 7. Riverpod Providers (`/lib/core/providers/garden_aggregation_providers.dart`)

**Current Implementation:**
```dart
final unifiedGardenContextProvider = 
    FutureProvider.family<UnifiedGardenContext, String>(
  (ref, gardenId) async {  // ✅ ALREADY PARAMETERIZED
    final hub = ref.read(gardenAggregationHubProvider);
    return await hub.getUnifiedContext(gardenId);
  },
);
```

**Status:**
- ✅ **Already multi-garden ready**: Family providers accept gardenId
- ✅ **Automatic caching**: Riverpod handles per-garden cache internally
- ✅ **Selective invalidation**: Can invalidate specific garden with `ref.invalidate(provider(gardenId))`

---

## III. Global & Static State Analysis

### Singleton Instances

**PlantNotificationService** (`/lib/features/plant_intelligence/data/services/plant_notification_service.dart`)
```dart
class PlantNotificationService {
  static final PlantNotificationService _instance = 
      PlantNotificationService._internal();
  // ⚠️ SINGLETON PATTERN
}
```

**Assessment:**
- ⚠️ **Potential issue**: Notifications are not garden-scoped
- ⚠️ **Risk**: User might receive mixed notifications from multiple gardens
- 💡 **Mitigation**: Add gardenId to notification metadata for filtering

### Static Constants
- ✅ **No problematic statics**: Only box names and log names (safe)

---

## IV. Race Conditions & Concurrency Risks

### Scenario Analysis

#### Scenario 1: Rapid Garden Switching
**Flow:**
1. User opens Dashboard for Garden A
2. IntelligenceStateProvider initializes for Garden A
3. User switches to Garden B before initialization completes
4. IntelligenceStateProvider initializes for Garden B
5. **Risk:** Garden A's late responses might overwrite Garden B's state

**Likelihood:** 🔴 **High** - No cancellation mechanism for ongoing operations

**Mitigation Required:**
- Implement operation cancellation tokens
- Add `isInitializing` lock per garden
- Debounce garden switching

---

#### Scenario 2: Concurrent Analysis Requests
**Flow:**
1. Garden A triggers plant analysis for Plant X
2. Garden B triggers plant analysis for Plant Y (same plantId hypothetically)
3. Both write to `plant_conditions` box with same plantId
4. **Risk:** Condition data collision

**Likelihood:** 🟡 **Medium** - Unlikely with proper plantId scoping per garden

**Mitigation Required:**
- Add gardenId to PlantCondition entity
- Use composite keys: `gardenId_plantId_timestamp`

---

#### Scenario 3: Cache Invalidation Side Effects
**Flow:**
1. User working in Garden A
2. Background sync invalidates GardenAggregationHub cache globally
3. Garden A UI refetches data unexpectedly
4. **Risk:** UI flicker, performance degradation

**Likelihood:** 🟡 **Medium** - Current `clearCache()` is too aggressive

**Mitigation Required:**
- Implement garden-specific cache invalidation
- Preserve active garden cache during background operations

---

## V. Transition Strategies

### Strategy A: Multi-Instance State (Per-Garden Providers)

**Concept:**
```dart
// One IntelligenceStateNotifier instance per garden
final intelligenceStateProvider = 
    StateNotifierProvider.family<IntelligenceStateNotifier, IntelligenceState, String>(
  (ref, gardenId) => IntelligenceStateNotifier(ref, gardenId: gardenId),
);
```

**Pros:**
- ✅ Complete isolation between gardens
- ✅ No shared state contamination
- ✅ Minimal refactoring of existing logic
- ✅ Natural cache per garden via Riverpod

**Cons:**
- ⚠️ Multiple instances in memory simultaneously
- ⚠️ Complexity in coordinating cross-garden operations
- ⚠️ Need to manage lifecycle (dispose inactive gardens?)

**Implementation Effort:** 🟡 Medium (2-3 days)

---

### Strategy B: Unified State with Garden Index

**Concept:**
```dart
class IntelligenceState {
  final Map<String, GardenIntelligenceState> gardenStates;  // Indexed by gardenId
  final String? activeGardenId;
}

class GardenIntelligenceState {
  final String gardenId;
  final List<String> activePlantIds;
  final Map<String, PlantCondition> plantConditions;
  // ...
}
```

**Pros:**
- ✅ Single source of truth
- ✅ Easy to compare across gardens
- ✅ Simpler cross-garden analytics
- ✅ Less memory overhead

**Cons:**
- ⚠️ Complex state management logic
- ⚠️ Risk of logic errors affecting all gardens
- ⚠️ Requires deep refactoring of notifier methods

**Implementation Effort:** 🔴 High (4-5 days)

---

### Strategy C: Delegation Through Aggregation Layer (RECOMMENDED ✨)

**Concept:**
```dart
// GardenAggregationHub becomes the multi-garden coordinator
class GardenAggregationHub {
  final Map<String, GardenIntelligenceCache> _gardenCaches;
  
  Future<IntelligenceState> getGardenIntelligence(String gardenId) async {
    if (!_gardenCaches.containsKey(gardenId)) {
      _gardenCaches[gardenId] = await _initializeGardenCache(gardenId);
    }
    return _gardenCaches[gardenId]!.toState();
  }
}

// IntelligenceStateProvider becomes a thin wrapper
final intelligenceStateProvider = 
    FutureProvider.family<IntelligenceState, String>(
  (ref, gardenId) async {
    final hub = ref.read(gardenAggregationHubProvider);
    return await hub.getGardenIntelligence(gardenId);
  },
);
```

**Pros:**
- ✅ Leverages existing architecture (GardenAggregationHub)
- ✅ Clean separation: Hub manages multi-garden, UI consumes per-garden
- ✅ Easy to add cache eviction policies
- ✅ Maintains backward compatibility
- ✅ Aligns with existing adapter pattern

**Cons:**
- ⚠️ Hub becomes more complex
- ⚠️ Need to refactor hub to manage intelligence data

**Implementation Effort:** 🟢 Low-Medium (1-3 days)

---

## VI. Data Model Modifications Required

### Critical Changes

#### 1. Add gardenId to Core Entities

**PlantCondition:**
```dart
@freezed
class PlantCondition with _$PlantCondition {
  const factory PlantCondition({
    required String id,
    required String plantId,
    required String gardenId,  // ✅ ADD THIS
    required ConditionType type,
    // ...
  }) = _PlantCondition;
}
```

**Impact:**
- 🔴 Breaking change
- Requires Hive adapter update (new HiveField)
- Requires migration of existing data

**Migration Strategy:**
```dart
Future<void> migratePlantConditions() async {
  final box = await Hive.openBox<PlantCondition>('plant_conditions');
  
  for (final condition in box.values) {
    if (condition.gardenId == null) {
      // Infer gardenId from plantId → plant → gardenBedId → gardenId
      final gardenId = await _inferGardenIdFromPlantId(condition.plantId);
      final updated = condition.copyWith(gardenId: gardenId);
      await box.put(condition.id, updated);
    }
  }
}
```

---

#### 2. Add gardenId to Recommendation

**Recommendation:**
```dart
@freezed
class Recommendation with _$Recommendation {
  const factory Recommendation({
    required String id,
    required String plantId,
    required String gardenId,  // ✅ ADD THIS
    required RecommendationType type,
    // ...
  }) = _Recommendation;
}
```

**Impact:** Same as PlantCondition

---

#### 3. Update Intelligence Reports

**PlantIntelligenceReport:**
```dart
@freezed
class PlantIntelligenceReport with _$PlantIntelligenceReport {
  const factory PlantIntelligenceReport({
    required String id,
    required String plantId,
    required String gardenId,  // ✅ ADD THIS (if not already present)
    // ...
  }) = _PlantIntelligenceReport;
}
```

---

#### 4. Update Hive Box Keys

**Recommendation:**
- Current: `recommendationId` → `{gardenId}_recommendations`
- New Strategy: Separate boxes per garden OR composite keys

**Option A: Separate Boxes**
```dart
Future<Box<Recommendation>> _getRecommendationsBox(String gardenId) async {
  return await Hive.openBox<Recommendation>('recommendations_$gardenId');
}
```

**Option B: Composite Keys (RECOMMENDED)**
```dart
// Key format: gardenId_recommendationId
final key = '${gardenId}_${recommendation.id}';
await box.put(key, recommendation);
```

---

## VII. UI/UX Design Considerations

### Required UI Changes

#### 1. Garden Selector
**Location:** App Bar or Navigation Drawer  
**Functionality:**
- Display list of active gardens
- Show current garden badge
- Allow quick switching
- Persist last selected garden

**Design Pattern:**
```dart
class GardenSelectorWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardens = ref.watch(activeGardensProvider);
    final currentGardenId = ref.watch(currentGardenIdProvider);
    
    return DropdownButton<String>(
      value: currentGardenId,
      items: gardens.map((garden) => 
        DropdownMenuItem(value: garden.id, child: Text(garden.name))
      ).toList(),
      onChanged: (gardenId) {
        ref.read(currentGardenIdProvider.notifier).state = gardenId;
        // Trigger intelligence re-initialization
      },
    );
  }
}
```

---

#### 2. Multi-Garden Dashboard View

**Option A: Tabbed Interface**
```
┌────────────────────────────────┐
│  Garden A │ Garden B │ Garden C │
├────────────────────────────────┤
│  Intelligence Data for Garden A │
│  [Plant Health Cards]          │
│  [Recommendations]             │
└────────────────────────────────┘
```

**Option B: List/Grid View**
```
┌─────────────────────────┐
│  Garden A              ↗│
│  ✓ 12 plants healthy    │
│  ⚠ 2 alerts             │
├─────────────────────────┤
│  Garden B              ↗│
│  ✓ 8 plants healthy     │
│  🚨 1 critical issue    │
└─────────────────────────┘
```

**Option C: Unified Dashboard with Filters (RECOMMENDED)**
```
┌─────────────────────────┐
│  [All Gardens ▾]       │
├─────────────────────────┤
│  Garden A              │
│  └─ Plant X: Good ✓    │
│  Garden B              │
│  └─ Plant Y: Warning ⚠ │
└─────────────────────────┘
```

---

#### 3. Navigation Context

**Challenge:** User navigates from Garden List → Garden A → Intelligence Dashboard

**Required State Flow:**
```dart
// Pass gardenId through navigation
context.push('/gardens/${gardenId}/intelligence');

// Or use global provider
final currentGardenIdProvider = StateProvider<String?>((ref) => null);

// In dashboard:
final gardenId = ref.watch(currentGardenIdProvider);
if (gardenId == null) {
  return SelectGardenPrompt();
}
```

---

## VIII. Recommended Implementation Roadmap

### Phase 1: Data Model Foundation (Week 1)
**Priority:** 🔴 Critical

**Tasks:**
1. ✅ Add `gardenId` field to `PlantCondition` entity
2. ✅ Add `gardenId` field to `Recommendation` entity  
3. ✅ Update Hive adapters with new fields
4. ✅ Implement data migration script
5. ✅ Update all repositories to use gardenId in queries
6. ✅ Add integration tests for multi-garden data isolation

**Deliverables:**
- Updated entity models
- Migration utility
- Test suite

---

### Phase 2: Architecture Refactoring (Week 2)
**Priority:** 🔴 Critical

**Tasks:**
1. ✅ Refactor `IntelligenceStateProvider` to use family pattern
2. ✅ Update `GardenAggregationHub` to manage per-garden intelligence caches
3. ✅ Implement selective cache invalidation
4. ✅ Add operation cancellation for garden switching
5. ✅ Update `PlantIntelligenceOrchestrator` methods to validate gardenId
6. ✅ Add garden-scoped notification filtering

**Deliverables:**
- Multi-garden state management
- Selective cache system
- Cancellation tokens

---

### Phase 3: UI/UX Enhancement (Week 3)
**Priority:** 🟡 High

**Tasks:**
1. ✅ Add garden selector widget
2. ✅ Update dashboard to accept gardenId parameter
3. ✅ Implement garden-aware navigation
4. ✅ Add multi-garden overview screen
5. ✅ Update recommendation screens to show garden context
6. ✅ Add garden badge to all intelligence-related widgets

**Deliverables:**
- Garden selector component
- Updated dashboard
- Navigation flow

---

### Phase 4: Performance & Polish (Week 4)
**Priority:** 🟢 Medium

**Tasks:**
1. ✅ Implement cache eviction policy (LRU for inactive gardens)
2. ✅ Add lazy loading for garden intelligence
3. ✅ Optimize multi-garden queries
4. ✅ Add loading states for garden switching
5. ✅ Performance profiling and optimization
6. ✅ End-to-end testing with 3+ gardens

**Deliverables:**
- Performance benchmarks
- Cache management system
- E2E test suite

---

## IX. Risk Assessment Matrix

| Risk | Probability | Impact | Mitigation | Priority |
|------|-------------|--------|------------|----------|
| **Data Migration Failure** | Low | Critical | Backup strategy, rollback plan | 🔴 High |
| **State Collision** | High | High | Add gardenId to entities, composite keys | 🔴 High |
| **Cache Memory Bloat** | Medium | Medium | LRU eviction, memory monitoring | 🟡 Medium |
| **Race Conditions** | High | Medium | Cancellation tokens, debouncing | 🟡 Medium |
| **UI Confusion** | Low | High | Clear garden selector, badges | 🟡 Medium |
| **Notification Mix-up** | Medium | Low | Garden-scoped filtering | 🟢 Low |
| **Performance Degradation** | Low | Medium | Lazy loading, profiling | 🟢 Low |

---

## X. Pseudo-Code for Recommended Approach

### Strategy C: Delegation Through Aggregation

```dart
// ==================== STEP 1: Enhance GardenAggregationHub ====================

class GardenAggregationHub {
  final Map<String, GardenIntelligenceCache> _intelligenceCaches = {};
  
  /// Get or create intelligence cache for a garden
  Future<GardenIntelligenceCache> getGardenIntelligenceCache(String gardenId) async {
    if (!_intelligenceCaches.containsKey(gardenId)) {
      _intelligenceCaches[gardenId] = await _initializeIntelligenceCache(gardenId);
    }
    return _intelligenceCaches[gardenId]!;
  }
  
  /// Initialize intelligence data for a garden
  Future<GardenIntelligenceCache> _initializeIntelligenceCache(String gardenId) async {
    // 1. Fetch garden context
    final context = await getGardenContext(gardenId);
    
    // 2. Fetch active plants
    final plants = await getActivePlants(gardenId);
    
    // 3. Fetch plant conditions (filtered by gardenId)
    final conditions = await _fetchPlantConditions(gardenId);
    
    // 4. Fetch recommendations (filtered by gardenId)
    final recommendations = await _fetchRecommendations(gardenId);
    
    // 5. Create cache object
    return GardenIntelligenceCache(
      gardenId: gardenId,
      context: context,
      plants: plants,
      conditions: conditions,
      recommendations: recommendations,
      lastUpdated: DateTime.now(),
    );
  }
  
  /// Invalidate cache for specific garden
  void invalidateGardenCache(String gardenId) {
    _intelligenceCaches.remove(gardenId);
    developer.log('Cache invalidated for garden $gardenId');
  }
  
  /// Evict least recently used caches
  void evictLRUCaches({int keepCount = 3}) {
    if (_intelligenceCaches.length <= keepCount) return;
    
    final sorted = _intelligenceCaches.entries.toList()
      ..sort((a, b) => b.value.lastUpdated.compareTo(a.value.lastUpdated));
    
    for (var i = keepCount; i < sorted.length; i++) {
      _intelligenceCaches.remove(sorted[i].key);
    }
  }
}

class GardenIntelligenceCache {
  final String gardenId;
  final UnifiedGardenContext context;
  final List<UnifiedPlantData> plants;
  final Map<String, PlantCondition> conditions;
  final Map<String, List<Recommendation>> recommendations;
  final DateTime lastUpdated;
  
  GardenIntelligenceCache({
    required this.gardenId,
    required this.context,
    required this.plants,
    required this.conditions,
    required this.recommendations,
    required this.lastUpdated,
  });
}

// ==================== STEP 2: Refactor IntelligenceStateProvider ====================

// Convert to family provider
final intelligenceStateProvider = 
    FutureProvider.family<IntelligenceState, String>(
  (ref, gardenId) async {
    final hub = ref.read(gardenAggregationHubProvider);
    final cache = await hub.getGardenIntelligenceCache(gardenId);
    
    return IntelligenceState(
      isInitialized: true,
      isAnalyzing: false,
      currentGardenId: gardenId,
      activePlantIds: cache.context.activePlantIds,
      plantConditions: cache.conditions,
      plantRecommendations: cache.recommendations,
      currentGarden: cache.context.toGardenContext(),
      lastAnalysis: cache.lastUpdated,
    );
  },
);

// Add current garden selector
final currentGardenIdProvider = StateProvider<String?>((ref) => null);

// Convenience provider for active garden intelligence
final activeGardenIntelligenceProvider = FutureProvider<IntelligenceState?>((ref) async {
  final gardenId = ref.watch(currentGardenIdProvider);
  if (gardenId == null) return null;
  
  return await ref.watch(intelligenceStateProvider(gardenId).future);
});

// ==================== STEP 3: Update Dashboard Screen ====================

class PlantIntelligenceDashboardScreen extends ConsumerStatefulWidget {
  final String? initialGardenId;
  
  const PlantIntelligenceDashboardScreen({this.initialGardenId, super.key});
  
  @override
  ConsumerState<PlantIntelligenceDashboardScreen> createState() => 
      _PlantIntelligenceDashboardScreenState();
}

class _PlantIntelligenceDashboardScreenState 
    extends ConsumerState<PlantIntelligenceDashboardScreen> {
  
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set initial garden or use first available
      final gardens = ref.read(gardenProvider).gardens;
      if (gardens.isNotEmpty) {
        final gardenId = widget.initialGardenId ?? gardens.first.id;
        ref.read(currentGardenIdProvider.notifier).state = gardenId;
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final currentGardenId = ref.watch(currentGardenIdProvider);
    
    if (currentGardenId == null) {
      return _buildSelectGardenPrompt();
    }
    
    final intelligenceAsync = ref.watch(intelligenceStateProvider(currentGardenId));
    
    return intelligenceAsync.when(
      data: (state) => _buildDashboard(state),
      loading: () => _buildLoadingView(),
      error: (error, stack) => _buildErrorView(error),
    );
  }
  
  Widget _buildDashboard(IntelligenceState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intelligence'),
        actions: [
          _buildGardenSelector(),  // ✅ Garden switcher
          _buildRefreshButton(),
        ],
      ),
      body: _buildIntelligenceContent(state),
    );
  }
  
  Widget _buildGardenSelector() {
    return Consumer(
      builder: (context, ref, child) {
        final gardens = ref.watch(gardenProvider).gardens;
        final currentGardenId = ref.watch(currentGardenIdProvider);
        
        return PopupMenuButton<String>(
          initialValue: currentGardenId,
          icon: Icon(Icons.eco),
          onSelected: (gardenId) {
            // Switch garden
            ref.read(currentGardenIdProvider.notifier).state = gardenId;
            
            // Optional: Invalidate old cache
            final hub = ref.read(gardenAggregationHubProvider);
            hub.evictLRUCaches(keepCount: 2);
          },
          itemBuilder: (context) => gardens.map((garden) {
            return PopupMenuItem<String>(
              value: garden.id,
              child: Row(
                children: [
                  if (garden.id == currentGardenId) 
                    Icon(Icons.check, color: Colors.green),
                  SizedBox(width: 8),
                  Text(garden.name),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ==================== STEP 4: Update Repository Queries ====================

class PlantIntelligenceRepositoryImpl {
  Future<List<PlantCondition>> getPlantConditionsByGarden({
    required String gardenId,
    DateTime? startDate,
    int limit = 100,
  }) async {
    // 🆕 New method: Query by gardenId
    final box = await _plantConditionsBox;
    var conditions = box.values
        .where((c) => c.gardenId == gardenId)  // ✅ Filter by garden
        .toList();
    
    if (startDate != null) {
      conditions = conditions
          .where((c) => c.measuredAt.isAfter(startDate))
          .toList();
    }
    
    conditions.sort((a, b) => b.measuredAt.compareTo(a.measuredAt));
    return conditions.take(limit).toList();
  }
  
  Future<List<Recommendation>> getRecommendationsByGarden({
    required String gardenId,
    RecommendationStatus? status,
    int limit = 50,
  }) async {
    // 🆕 New method: Query by gardenId
    final box = await _recommendationsBox;
    var recommendations = box.values
        .where((r) => r.gardenId == gardenId)  // ✅ Filter by garden
        .toList();
    
    if (status != null) {
      recommendations = recommendations
          .where((r) => r.status == status)
          .toList();
    }
    
    recommendations.sort((a, b) => 
        _getPriorityWeight(b.priority.name).compareTo(_getPriorityWeight(a.priority.name)));
    
    return recommendations.take(limit).toList();
  }
}

// ==================== STEP 5: Add Operation Cancellation ====================

class CancellationToken {
  bool _isCancelled = false;
  
  bool get isCancelled => _isCancelled;
  
  void cancel() {
    _isCancelled = true;
  }
  
  void throwIfCancelled() {
    if (_isCancelled) {
      throw OperationCancelledException();
    }
  }
}

class OperationCancelledException implements Exception {
  @override
  String toString() => 'Operation was cancelled';
}

// Usage in Orchestrator
class PlantIntelligenceOrchestrator {
  final Map<String, CancellationToken> _gardenOperations = {};
  
  Future<PlantIntelligenceReport> generateIntelligenceReport({
    required String plantId,
    required String gardenId,
    PlantFreezed? plant,
  }) async {
    // Create cancellation token for this garden
    final token = CancellationToken();
    _gardenOperations[gardenId]?.cancel();  // Cancel previous operation
    _gardenOperations[gardenId] = token;
    
    try {
      token.throwIfCancelled();
      
      // 1. Fetch data
      final resolvedPlant = plant ?? await _getPlant(plantId);
      token.throwIfCancelled();
      
      final gardenContext = await _gardenRepository.getGardenContext(gardenId);
      token.throwIfCancelled();
      
      // ... rest of analysis
      
      return report;
    } on OperationCancelledException {
      developer.log('Analysis cancelled for garden $gardenId');
      rethrow;
    } finally {
      _gardenOperations.remove(gardenId);
    }
  }
}
```

---

## XI. Conclusion

### Summary of Findings

**Current State:**
- ✅ **Solid foundation**: Well-architected system with clean separation of concerns
- ✅ **Riverpod-ready**: Already uses family providers for garden-scoped data
- ⚠️ **Single-garden mindset**: Implicit assumptions throughout stack
- ⚠️ **Data model gaps**: Missing gardenId in core entities

**Readiness Score:** **6/10** (Partially Ready)

---

### Recommended Path Forward

**✨ STRATEGY C: Delegation Through Aggregation Layer**

**Why This Strategy?**
1. **Minimal disruption**: Leverages existing GardenAggregationHub architecture
2. **Clean separation**: Hub manages multi-garden complexity, UI stays simple
3. **Incremental rollout**: Can implement phase by phase without breaking existing features
4. **Performance**: Built-in cache management with LRU eviction
5. **Maintainability**: Centralized multi-garden logic in one component

**Estimated Timeline:** 3-4 weeks  
**Risk Level:** 🟡 Medium  
**Effort:** 🟢 Moderate  

---

### Next Steps

**Immediate Actions (Week 1):**
1. 🔴 **Critical**: Add `gardenId` field to `PlantCondition` and `Recommendation` entities
2. 🔴 **Critical**: Update Hive adapters and implement migration
3. 🟡 **High**: Refactor `IntelligenceStateProvider` to family pattern
4. 🟡 **High**: Add garden selector UI widget

**Success Metrics:**
- ✅ All intelligence data correctly scoped to gardenId
- ✅ No state collision between gardens
- ✅ UI allows seamless garden switching
- ✅ Performance < 100ms for garden switch
- ✅ All existing tests pass with multi-garden scenarios

---

### Final Recommendation

**Proceed with Strategy C (Delegation Through Aggregation)** with the following priority order:

1. **Phase 1** (Critical): Data model migration
2. **Phase 2** (Critical): Architecture refactoring
3. **Phase 3** (High): UI/UX enhancement
4. **Phase 4** (Medium): Performance optimization

The system is **ready for multi-garden expansion** with the outlined modifications. The refactoring effort is **moderate** and can be completed in **3-4 weeks** by following the phased approach.

---

**End of Audit Report**  
**Prepared by:** AI Technical Architect  
**Date:** 2025-10-12  
**Version:** 1.0

