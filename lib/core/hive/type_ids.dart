/// Centralized TypeIds for Hive adapters
///
/// This file centralizes all TypeIds to avoid conflicts and ensure
/// proper management of the modern range (25-30) for new adapters.
///
/// Legacy TypeIds (0-18) are preserved and should NOT be modified.
library;

// ============================================================================
// LEGACY TYPEIDS (0-18) - DO NOT MODIFY
// ============================================================================
// These are preserved for backward compatibility
// 0: Garden (legacy)
// 1: GardenBed (legacy)
// 2: Plant (legacy)
// 3: Planting (legacy)
// 4: PlantVariety
// 5: GrowthCycle
// 6: GerminationEvent
// 7-9: Reserved
// 10: GardenV2
// 11: GardenBedV2
// 12: PlantV2
// 13-15: Reserved
// 16: Activity
// 17: ActivityType
// 18: EntityType

// ============================================================================
// MODERN TYPEIDS (25-30) - SAFE RANGE FOR NEW ADAPTERS
// ============================================================================
// These are used for new features and can be safely modified

/// GardenHive - Modern garden storage
const int kTypeIdGardenHive = 25;

/// GardenBedHive - Modern garden bed storage
const int kTypeIdGardenBedHive = 26;

/// PlantingHive - Modern planting storage
const int kTypeIdPlantingHive = 27;

/// PlantHive - Modern plant catalog storage
const int kTypeIdPlantHive = 29;

/// ActivityV3 - Modern activity tracking
const int kTypeIdActivityV3 = 30;

/// PlantLocalized - Multilingual plant data (offline packs)
const int kTypeIdPlantLocalized = 33;

/// LocalizedPlantFields - fields stored for each locale (canonical)
const int kTypeIdLocalizedPlantFields = 133;

// ============================================================================
// EXTENDED TYPEIDS (31+) - FOR SPECIALIZED FEATURES
// ============================================================================

/// CalendarEvent - Calendar system
const int kTypeIdCalendarEvent = 31;

/// StageCompletionRecord - Plant intelligence
const int kTypeIdStageCompletionRecord = 32;

/// HarvestRecord - Harvest tracking
const int kTypeIdHarvestRecord = 54;

/// UserInsightSettings - User preferences
const int kTypeIdUserInsightSettings = 56;

/// PlantConditionHive - Plant intelligence
const int kTypeIdPlantConditionHive = 57;

/// AppSettings - Application settings
const int kTypeIdAppSettings = 60;

// ============================================================================
// CLIMATE FEATURE TYPEIDS - NEW FOR PHASE 2
// ============================================================================

/// SoilMetricsDto - Soil temperature and pH storage
const int kTypeIdSoilMetrics = 28; // Using 28 as it's available in the range
