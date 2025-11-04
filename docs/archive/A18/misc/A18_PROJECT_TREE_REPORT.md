# 🌳 A18 Project Tree Report – Pre-Migration Analysis

**Generated:** Monday, October 13, 2025  
**Purpose:** Complete project structure analysis before Riverpod 3.x migration (Phase A18)  
**Status:** ✅ Complete

---

## 📊 Executive Summary

- **Total Root-Level Markdown Files:** 100
- **Total Files in Project:** 500+ (including generated files)
- **Key Directories:** `/lib/`, `/assets/`, `/test/`, `/docs/`
- **Recommendation:** Archive 95+ documentation files to `/docs/archive/A18/`

---

## 🗂️ Complete Directory Tree

### Root Level Structure

```
permacalendarv2/
├── .ai-doc/                           # AI documentation and archives
├── .dart_tool/                        # Dart build tools
├── .idea/                             # IDE configuration
├── android/                           # Android platform
├── assets/                            # Application assets ✅
│   ├── data/
│   │   ├── biological_control/
│   │   │   ├── beneficial_insects.json
│   │   │   └── pests.json
│   │   ├── plants.json               # Main plant catalog
│   │   ├── plants.json.backup
│   │   └── plants_legacy.json.backup
│   ├── fonts/
│   │   ├── Roboto-Bold.ttf
│   │   └── Roboto-Regular.ttf
│   └── images/
│       ├── backgrounds/
│       ├── icons/
│       ├── plants/
│       └── social/
├── build/                             # Build artifacts
├── coverage/                          # Test coverage reports
├── docs/                              # Documentation ✅
│   └── diagrams/
│       └── architecture_overview.md
├── ios/                               # iOS platform
├── lib/                               # Main source code ✅
│   ├── app_initializer.dart
│   ├── app_router.dart
│   ├── main.dart
│   ├── core/                          # Core business logic
│   ├── features/                      # Feature modules
│   └── shared/                        # Shared components
├── linux/                             # Linux platform
├── macos/                             # macOS platform
├── permacalendarassainissement_prompts/ # Legacy prompts folder
├── test/                              # Test suite ✅
├── test_hive/                         # Test database
├── tools/                             # Development tools
├── web/                               # Web platform
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
├── permacalendar.iml
└── [100 Markdown files]               # 🚨 TO BE ARCHIVED
```

---

## 📁 Detailed Structure - Key Directories

### 1️⃣ `/lib/` - Main Source Code (300+ files)

```
lib/
├── app_initializer.dart               # Application initialization
├── app_router.dart                    # Navigation configuration
├── main.dart                          # Entry point
├── core/                              # 150+ files
│   ├── adapters/                      # Data adapters
│   ├── analytics/                     # Analytics tracking
│   ├── data/                          # Data layer
│   │   ├── hive/                      # Hive database
│   │   └── migration/                 # Data migration
│   ├── di/                            # Dependency injection
│   ├── errors/                        # Error handling
│   ├── events/                        # Event system
│   │   ├── garden_event_bus.dart
│   │   ├── garden_events.dart
│   │   └── garden_events.freezed.dart
│   ├── models/                        # 45+ data models
│   │   ├── activity.dart, activity_v3.dart
│   │   ├── garden.dart, garden_v2.dart, garden_freezed.dart
│   │   ├── garden_bed.dart, garden_bed_v2.dart
│   │   ├── plant.dart, plant_v2.dart
│   │   ├── planting.dart, planting_v2.dart
│   │   └── unified_garden_context.dart
│   ├── providers/                     # Riverpod providers
│   ├── repositories/                  # Data repositories
│   ├── services/                      # 48+ services
│   │   ├── aggregation/               # Data aggregation (8 files)
│   │   ├── intelligence/              # AI services (3 files)
│   │   ├── migration/                 # Migration services (10 files)
│   │   ├── monitoring/                # Monitoring (4 files)
│   │   ├── performance/               # Performance (3 files)
│   │   └── README.md
│   ├── theme/                         # UI theming
│   └── utils/                         # Utilities
├── features/                          # 150+ files
│   ├── activities/                    # Activity management
│   ├── export/                        # Data export
│   ├── garden/                        # Garden management
│   ├── garden_bed/                    # Garden bed management
│   ├── garden_management/             # Complete garden management
│   ├── home/                          # Home screen
│   ├── plant_catalog/                 # Plant catalog (200+ species)
│   ├── plant_intelligence/            # 🧠 Intelligence Végétale (109+ files)
│   │   ├── data/                      # 11 files
│   │   │   ├── datasources/
│   │   │   ├── repositories/
│   │   │   └── services/
│   │   ├── domain/                    # 80 files
│   │   │   ├── entities/              # 50 entities (Freezed)
│   │   │   ├── models/
│   │   │   ├── repositories/          # 11 interfaces
│   │   │   ├── services/
│   │   │   │   ├── EVOLUTION_TRACKER_USAGE.md
│   │   │   │   ├── PLANT_EVOLUTION_QUICK_REF.md
│   │   │   │   └── PLANT_EVOLUTION_TRACKER_USAGE.md
│   │   │   └── usecases/              # 5 use cases
│   │   ├── presentation/              # 32 files
│   │   │   ├── providers/
│   │   │   ├── screens/               # 10 screens
│   │   │   └── widgets/               # 9 organized widgets
│   │   │       ├── cards/
│   │   │       ├── charts/
│   │   │       ├── evolution/
│   │   │       │   └── README.md
│   │   │       ├── indicators/
│   │   │       └── summaries/
│   │   ├── DEPLOYMENT_GUIDE.md
│   │   ├── INTEGRATION_GUIDE.md
│   │   ├── NOTIFICATION_SYSTEM_README.md
│   │   ├── PERFORMANCE_REPORT.md
│   │   └── QUICK_START.md
│   ├── planting/                      # Planting management
│   ├── social/                        # Social features (prepared)
│   └── weather/                       # Weather integration
└── shared/                            # Shared components
    ├── presentation/
    └── widgets/                       # 11 reusable widgets
```

### 2️⃣ `/assets/` - Application Resources

```
assets/
├── data/
│   ├── biological_control/
│   │   ├── beneficial_insects.json    # 🐞 Beneficial insects database
│   │   └── pests.json                 # 🐛 Pests database
│   ├── plants.json                    # 🌱 200+ plant species catalog
│   ├── plants.json.backup
│   └── plants_legacy.json.backup
├── fonts/
│   ├── Roboto-Bold.ttf
│   └── Roboto-Regular.ttf
└── images/
    ├── backgrounds/
    ├── icons/
    ├── plants/
    └── social/
```

### 3️⃣ `/test/` - Test Suite (60+ test files)

```
test/
├── assets/
│   └── data/
│       └── plants_test.json
├── core/                              # Core tests
│   ├── adapters/
│   ├── data/
│   ├── events/
│   ├── models/
│   ├── providers/
│   ├── services/
│   │   ├── aggregation/
│   │   └── migration/
│   └── utils/
├── features/                          # Feature tests
│   ├── garden/
│   ├── garden_bed/
│   ├── garden_management/
│   ├── home/
│   ├── plant_catalog/
│   └── plant_intelligence/            # 25+ intelligence tests
│       ├── data/
│       ├── domain/
│       │   ├── entities/
│       │   ├── services/
│       │   └── usecases/
│       ├── integration/
│       └── presentation/
├── helpers/
├── integration/                       # E2E tests
│   ├── biological_control_e2e_test.dart
│   └── harvest_flow_test.dart
├── shared/
├── tools/
├── widget_test.dart
├── CONTRIBUTION_STANDARDS.md
├── MANUAL_TESTING_PLAN_INTELLIGENCE_ORCHESTRATOR.md
├── RAPPORT_FINAL_A2_REALISTE.md
├── README_TESTS.md
├── run_tests_with_coverage.bat
├── TEST_PLAN_V2.2.md
└── TESTING_GUIDE.md
```

---

## 📝 Root-Level Markdown Files Analysis

### 📊 Summary Statistics

- **Total Files:** 100 Markdown files
- **Total Size:** ~1.8 MB
- **Date Range:** 08/10/2025 - 13/10/2025
- **Categories:**
  - Phase Reports (A9, A15, A17, A18): 15 files
  - Audits: 20 files
  - Implementation Reports (RAPPORT_): 25 files
  - Guides & Documentation: 15 files
  - Corrections & Fixes: 12 files
  - Résumés & Synthèses: 13 files

### 📋 Complete List of Root Markdown Files

#### 🚀 **Phase A18 Files (Recent - Keep Active)**
| File | Size (KB) | Last Modified | Status |
|------|-----------|---------------|--------|
| A18_AUDIT_MIGRATION_RIVERPOD_3X.md | 21.35 | 13/10/2025 07:23 | ✅ Keep |
| A18_EXECUTIVE_SUMMARY.md | 7.43 | 13/10/2025 07:23 | ✅ Keep |
| A18_INDEX_LIVRABLES.md | 12.68 | 13/10/2025 07:23 | ✅ Keep |
| A18_PROMPTS_MIGRATION_GUIDE.md | 36.25 | 13/10/2025 07:23 | ✅ Keep |
| A18_README.md | 12.34 | 13/10/2025 07:23 | ✅ Keep |
| A18_VISUAL_DASHBOARD.md | 30.57 | 13/10/2025 07:23 | ✅ Keep |
| SYNTHESE_MIGRATION_RIVERPOD_3X.md | 8.06 | 12/10/2025 20:46 | ✅ Keep |

#### 📦 **Phase A17 Files (Archive)**
| File | Size (KB) | Last Modified | Action |
|------|-----------|---------------|--------|
| A17_COMPLETION_SUMMARY.md | 14.43 | 12/10/2025 20:08 | 📁 Archive |
| COMMIT_MESSAGE_A17.md | 3.79 | 12/10/2025 20:06 | 📁 Archive |

#### 📦 **Phase A15 Files (Archive)**
| File | Size (KB) | Last Modified | Action |
|------|-----------|---------------|--------|
| A15_IMPLEMENTATION_SUMMARY.md | 12.68 | 12/10/2025 18:43 | 📁 Archive |
| A15_VISUAL_SUMMARY.md | 23.95 | 12/10/2025 18:46 | 📁 Archive |
| COMMIT_MESSAGE_A15.md | 4.12 | 12/10/2025 18:44 | 📁 Archive |
| DEPLOYMENT_GUIDE_MULTI_GARDEN_INTELLIGENCE.md | 13.59 | 12/10/2025 18:42 | 📁 Archive |
| README_PROMPT_A15.md | 6.88 | 12/10/2025 18:52 | 📁 Archive |

#### 📦 **Phase A9 Files (Archive)**
| File | Size (KB) | Last Modified | Action |
|------|-----------|---------------|--------|
| A9_EXECUTIVE_SUMMARY.md | 9.13 | 12/10/2025 14:35 | 📁 Archive |
| A9_VISUAL_IMPLEMENTATION_GUIDE.md | 14.44 | 12/10/2025 14:34 | 📁 Archive |
| CURSOR_PROMPT_A9_SUMMARY.md | 9.35 | 12/10/2025 14:33 | 📁 Archive |
| RAPPORT_IMPLEMENTATION_A9_EVOLUTION_UI_INTEGRATION.md | 12.53 | 12/10/2025 14:11 | 📁 Archive |

#### 📦 **Other Cursor Prompts (Archive)**
| File | Size (KB) | Last Modified | Action |
|------|-----------|---------------|--------|
| CURSOR_PROMPT_A4_SUMMARY.md | 10.85 | 12/10/2025 12:25 | 📁 Archive |
| CURSOR_PROMPT_A5_SUMMARY.md | 10.93 | 12/10/2025 12:36 | 📁 Archive |
| CURSOR_PROMPT_A6_SUMMARY.md | 12.42 | 12/10/2025 12:48 | 📁 Archive |
| CURSOR_PROMPT_A8_SUMMARY.md | 8.96 | 12/10/2025 18:56 | 📁 Archive |

#### 📦 **UI V2 Files (Archive)**
| File | Size (KB) | Last Modified | Action |
|------|-----------|---------------|--------|
| BETA_FEEDBACK_SUMMARY.md | 14.52 | 12/10/2025 19:46 | 📁 Archive |
| COMMIT_MESSAGE_UI_V2.md | 10.75 | 12/10/2025 19:23 | 📁 Archive |
| DEPLOYMENT_GUIDE_UI_V2.md | 7.40 | 12/10/2025 19:22 | 📁 Archive |
| PACKAGE_ATTERRISSAGE_COMPLET.md | 10.50 | 12/10/2025 19:39 | 📁 Archive |
| QUICKSTART_UI_V2.md | 1.89 | 12/10/2025 19:24 | 📁 Archive |
| RAPPORT_RECONNEXION_UI_INTELLIGENCE.md | 14.69 | 12/10/2025 18:56 | 📁 Archive |
| ui_consolidation_report.md | 36.85 | 12/10/2025 19:47 | 📁 Archive |
| VERIFICATION_UI_DATA_FLOW.md | 6.74 | 12/10/2025 18:56 | 📁 Archive |

#### 📦 **Audit Files (Archive)**
| File | Size (KB) | Last Modified | Action |
|------|-----------|---------------|--------|
| ALERTE_LOGS_ABSENTS_DIAGNOSTIC_COMPLET.md | 13.49 | 12/10/2025 06:26 | 📁 Archive |
| AUDIT_COMPARATIF_INTERFACE_VS_CODE.md | 36.50 | 10/10/2025 18:07 | 📁 Archive |
| AUDIT_DOUBLONS_FICHIERS_OBSOLETES.md | 37.57 | 12/10/2025 09:08 | 📁 Archive |
| AUDIT_FIABILITE_RECUPERATION_PLANTES_ACTIVES.md | 25.65 | 12/10/2025 10:52 | 📁 Archive |
| AUDIT_FINAL_ABSENCE_LOGS.md | 12.10 | 12/10/2025 08:40 | 📁 Archive |
| AUDIT_FONCTIONNEL_INTELLIGENCE_VEGETALE.md | 37.52 | 10/10/2025 17:52 | 📁 Archive |
| audit_multigarden_readiness.md | 32.92 | 12/10/2025 17:33 | 📁 Archive |
| AUDIT_PLANTS_JSON_VS_V2.md | 18.20 | 12/10/2025 08:43 | 📁 Archive |
| AUDIT_STRUCTURAL_UI_FLOW_INTELLIGENCE.md | 18.98 | 12/10/2025 14:58 | 📁 Archive |
| AUDIT_SYNCHRONISATION_INTELLIGENCE_VEGETALE.md | 25.66 | 12/10/2025 10:34 | 📁 Archive |
| DIAGNOSTIC_FINAL_LOGS_ABSENTS.md | 10.81 | 12/10/2025 08:40 | 📁 Archive |
| FINAL_AUDIT_REPORT.md | 15.15 | 12/10/2025 15:03 | 📁 Archive |
| INDEX_AUDIT_INTELLIGENCE_VEGETALE.md | 10.00 | 10/10/2025 18:07 | 📁 Archive |
| INDEX_AUDIT_INTELLIGENCE_VEGETALE_PHASE2.md | 7.89 | 11/10/2025 04:36 | 📁 Archive |
| INDEX_UI_AUDIT_INTELLIGENCE_VEGETALE.md | 10.75 | 12/10/2025 15:02 | 📁 Archive |
| README_AUDIT.md | 7.22 | 10/10/2025 18:07 | 📁 Archive |
| README_AUDIT_NAVIGATION.md | 7.69 | 10/10/2025 01:45 | 📁 Archive |
| RAPPORT_AUDIT_INTELLIGENCE_VEGETALE_PHASE2.md | 48.12 | 11/10/2025 01:30 | 📁 Archive |
| RESUME_AUDIT_POUR_UTILISATEUR.md | 6.19 | 12/10/2025 08:40 | 📁 Archive |
| RESUME_EXECUTIF_AUDIT.md | 9.29 | 10/10/2025 18:07 | 📁 Archive |
| RESUME_EXECUTIF_AUDIT_PHASE2.md | 7.14 | 11/10/2025 04:36 | 📁 Archive |
| SUMMARY_UI_AUDIT_AND_FIX.md | 8.28 | 12/10/2025 14:59 | 📁 Archive |
| SYNTHESE_VISUELLE_AUDIT.md | 19.43 | 10/10/2025 18:02 | 📁 Archive |
| VERIFICATION_PLAN_UI_FIX.md | 9.27 | 12/10/2025 14:59 | 📁 Archive |
| VISUAL_FIX_EXPLANATION.md | 16.27 | 12/10/2025 15:01 | 📁 Archive |

#### 📦 **Implementation Reports (Archive)**
| File | Size (KB) | Last Modified | Action |
|------|-----------|---------------|--------|
| implementation_multigarden_plan_results.md | 41.14 | 12/10/2025 18:29 | 📁 Archive |
| RAPPORT_IMPLEMENTATION_A2_ORCHESTRATOR_TESTS.md | 13.61 | 12/10/2025 11:54 | 📁 Archive |
| RAPPORT_IMPLEMENTATION_A3_EVOLUTION_TRACKER.md | 11.17 | 12/10/2025 12:11 | 📁 Archive |
| RAPPORT_IMPLEMENTATION_A4_REPORT_PERSISTENCE.md | 15.57 | 12/10/2025 12:21 | 📁 Archive |
| RAPPORT_IMPLEMENTATION_A5_PLANT_EVOLUTION_TRACKER.md | 12.78 | 12/10/2025 12:33 | 📁 Archive |
| RAPPORT_IMPLEMENTATION_A7_EVOLUTION_PERSISTENCE.md | 12.51 | 12/10/2025 13:04 | 📁 Archive |
| RAPPORT_IMPLEMENTATION_A8_EVOLUTION_UI.md | 39.94 | 12/10/2025 14:01 | 📁 Archive |
| RAPPORT_IMPLEMENTATION_CLEAN_ORPHANED_CONDITIONS.md | 9.70 | 12/10/2025 11:02 | 📁 Archive |
| RAPPORT_IMPLEMENTATION_CURSOR_PROMPT_2_CACHE_INVALIDATION.md | 10.95 | 12/10/2025 11:40 | 📁 Archive |

#### 📦 **Correction Reports (Archive)**
| File | Size (KB) | Last Modified | Action |
|------|-----------|---------------|--------|
| CORRECTIFS_COMPILATION_PHASE3.md | 5.35 | 11/10/2025 03:19 | 📁 Archive |
| CORRECTIFS_RECUPERATION_PLANTES_ACTIVES.md | 28.22 | 12/10/2025 10:54 | 📁 Archive |
| CORRECTIF_NAVIGATION_INTELLIGENCE.md | 19.69 | 10/10/2025 01:49 | 📁 Archive |
| RAPPORT_CORRECTION_DECLENCHEUR_ANALYSE.md | 6.73 | 12/10/2025 06:10 | 📁 Archive |
| RAPPORT_CORRECTION_PLANTCONDITIONS_VIDES.md | 14.90 | 12/10/2025 09:59 | 📁 Archive |
| RAPPORT_CORRECTION_PROVIDERS_INTELLIGENCE.md | 9.94 | 11/10/2025 23:11 | 📁 Archive |
| RAPPORT_CORRECTION_SYNCHRONISATION_INTELLIGENCE.md | 20.68 | 12/10/2025 10:37 | 📁 Archive |
| RAPPORT_CORRECTION_TESTS_E2E_BIOLOGICAL_CONTROL.md | 19.08 | 09/10/2025 18:38 | 📁 Archive |
| SYNTHESE_CORRECTION_GETPLANT.md | 4.78 | 12/10/2025 10:18 | 📁 Archive |
| SYNTHESE_CORRECTION_SYNCHRONISATION.md | 14.90 | 12/10/2025 10:39 | 📁 Archive |

#### 📦 **Phase 3 Files (Archive)**
| File | Size (KB) | Last Modified | Action |
|------|-----------|---------------|--------|
| CHECKLIST_VALIDATION_INTELLIGENCE.md | 9.65 | 11/10/2025 23:07 | 📁 Archive |
| FLUX_PROPAGATION_INTELLIGENCE_COMPLETE.md | 14.76 | 11/10/2025 23:08 | 📁 Archive |
| GUIDE_UTILISATEUR_PHASE3.md | 7.73 | 11/10/2025 03:27 | 📁 Archive |
| RAPPORT_ACTIVATION_FONCTIONNALITES_PHASE3.md | 12.28 | 11/10/2025 01:48 | 📁 Archive |
| RAPPORT_NETTOYAGE_CONNEXION_JARDIN_INTELLIGENCE.md | 11.40 | 11/10/2025 19:14 | 📁 Archive |
| RESUME_FINAL_PROPAGATION_COMPLETE.md | 9.90 | 11/10/2025 23:11 | 📁 Archive |
| RESUME_PHASE3_ACTIVATION.md | 5.20 | 11/10/2025 01:48 | 📁 Archive |
| SYNTHESE_COMPLETE_PHASE3.md | 17.05 | 11/10/2025 03:19 | 📁 Archive |
| TABLEAU_CARTOGRAPHIE_INTELLIGENCE_VEGETALE.md | 21.92 | 11/10/2025 01:32 | 📁 Archive |

#### 📦 **Other Reports & Guides (Archive)**
| File | Size (KB) | Last Modified | Action |
|------|-----------|---------------|--------|
| GUIDE_IMPLEMENTATION_CORRECTIONS.md | 48.69 | 10/10/2025 18:07 | 📁 Archive |
| GUIDE_TEST_CORRECTION_PLANTCONDITIONS.md | 5.02 | 12/10/2025 10:01 | 📁 Archive |
| LIVRABLES_PROMPT_A2.md | 4.55 | 12/10/2025 15:27 | 📁 Archive |
| LIVRABLES_PROMPT_CURSOR_1_CLEAN_ORPHANED_CONDITIONS.md | 10.53 | 12/10/2025 11:03 | 📁 Archive |
| PROMPT_CORRECTION_TESTS_E2E.md | 5.22 | 09/10/2025 18:18 | 📁 Archive |
| PROMPT_FINALISATION_A2.md | 3.00 | 09/10/2025 17:01 | 📁 Archive |
| QUICK_REFERENCE_CONST_VS_REACTIVE.md | 8.59 | 12/10/2025 15:05 | 📁 Archive |
| RAPPORT_DIAGNOSTIC_LOGS_ABSENTS.md | 10.71 | 12/10/2025 06:34 | 📁 Archive |
| RAPPORT_EXECUTION_PROMPT_03_RATIONALISATION_PROVIDERS.md | 23.34 | 12/10/2025 09:41 | 📁 Archive |
| RAPPORT_FINAL_MISSION_PLANTCONDITIONS.md | 17.52 | 12/10/2025 10:04 | 📁 Archive |
| RAPPORT_MIGRATION_PLANTS_V2.md | 15.96 | 12/10/2025 08:55 | 📁 Archive |
| RAPPORT_RENFORCEMENT_GETPLANT_ORCHESTRATOR.md | 13.58 | 12/10/2025 10:19 | 📁 Archive |
| rapport_validation_UI_intelligence.md | 19.90 | 12/10/2025 06:46 | 📁 Archive |
| RESUME_POUR_DIRECTEUR.md | 3.12 | 12/10/2025 06:27 | 📁 Archive |
| SYNTHESE_SITUATION_ANALYSE_INTELLIGENTE.md | 8.64 | 12/10/2025 06:22 | 📁 Archive |

#### ✅ **Keep at Root (Active Documentation)**
| File | Size (KB) | Last Modified | Status |
|------|-----------|---------------|--------|
| README.md | 16.70 | 08/10/2025 20:06 | ✅ Keep - Main documentation |
| ARCHITECTURE.md | 50.47 | 08/10/2025 19:56 | ✅ Keep - Core architecture |

---

## 📂 Archival Recommendations

### ✅ **Files to Keep at Root (9 files)**

1. **README.md** - Main project documentation
2. **ARCHITECTURE.md** - Core architecture documentation
3. **A18_AUDIT_MIGRATION_RIVERPOD_3X.md** - Current phase audit
4. **A18_EXECUTIVE_SUMMARY.md** - Current phase summary
5. **A18_INDEX_LIVRABLES.md** - Current deliverables index
6. **A18_PROMPTS_MIGRATION_GUIDE.md** - Current migration guide
7. **A18_README.md** - Current phase README
8. **A18_VISUAL_DASHBOARD.md** - Current visual dashboard
9. **SYNTHESE_MIGRATION_RIVERPOD_3X.md** - Current synthesis

### 📁 **Files to Archive (91 files)**

#### Target Directory: `/docs/archive/A18/`

**Subdirectory Structure:**
```
docs/
├── archive/
│   └── A18/
│       ├── phase_a9/              # A9 files (4 files)
│       ├── phase_a15/             # A15 files (5 files)
│       ├── phase_a17/             # A17 files (2 files)
│       ├── cursor_prompts/        # Cursor prompt summaries (4 files)
│       ├── ui_v2/                 # UI V2 documentation (8 files)
│       ├── audits/                # All audit files (24 files)
│       ├── implementations/       # Implementation reports (9 files)
│       ├── corrections/           # Correction reports (10 files)
│       ├── phase_3/               # Phase 3 files (9 files)
│       └── misc/                  # Other reports and guides (16 files)
└── diagrams/
    └── architecture_overview.md
```

**Archive Categories:**
- **Phase A9:** 4 files (~45 KB)
- **Phase A15:** 5 files (~70 KB)
- **Phase A17:** 2 files (~18 KB)
- **Cursor Prompts:** 4 files (~43 KB)
- **UI V2:** 8 files (~103 KB)
- **Audits:** 24 files (~420 KB)
- **Implementations:** 9 files (~175 KB)
- **Corrections:** 10 files (~148 KB)
- **Phase 3:** 9 files (~114 KB)
- **Miscellaneous:** 16 files (~200 KB)

**Total to Archive:** ~1.6 MB across 91 files

---

## 🔍 Duplicate & Obsolete Files Analysis

### Potential Duplicates Identified

1. **plants.json files:**
   - `assets/data/plants.json` (active)
   - `assets/data/plants.json.backup` (backup)
   - `assets/data/plants_legacy.json.backup` (legacy)
   - **Action:** Keep active and one backup, consider removing legacy

2. **Test data:**
   - `test/assets/data/plants_test.json` (test data - keep)

3. **Multiple resume/synthese files:**
   - Multiple RESUME_ and SYNTHESE_ files covering similar content
   - **Action:** Archive all, create consolidated summary if needed

### Files Marked for Potential Deletion

None at this time - recommend archiving instead of deletion for historical reference.

---

## 📊 Project Statistics

### Code Metrics
- **Total Dart Files:** 300+ files
- **Core Files:** ~150 files
- **Feature Files:** ~150 files
- **Test Files:** 60+ files
- **Lines of Code:** ~50,000+ (estimated)

### Documentation Metrics
- **Root MD Files:** 100 files
- **Embedded MD Files:** 25+ files in /lib/ and /test/
- **Total Documentation:** ~1.8 MB

### Asset Metrics
- **Plant Database:** 200+ species
- **Biological Control DB:** 2 JSON files
- **Images:** Multiple directories
- **Fonts:** 2 font files

---

## 🎯 Next Steps for Phase A18

### Pre-Migration Checklist

- [ ] **1. Archive Markdown Files**
  - Create `/docs/archive/A18/` structure
  - Move 91 files to appropriate subdirectories
  - Keep only 9 active files at root
  
- [ ] **2. Verify Active Documentation**
  - Update README.md if needed
  - Ensure ARCHITECTURE.md is current
  - Validate A18_* files are complete

- [ ] **3. Clean Build Artifacts**
  - Clean `/build/` directory
  - Clear `/coverage/` if needed
  - Verify `.dart_tool/` is in `.gitignore`

- [ ] **4. Backup Current State**
  - Create git tag: `pre-A18-migration`
  - Export current database state
  - Document current dependencies

- [ ] **5. Begin Riverpod 3.x Migration**
  - Follow A18_PROMPTS_MIGRATION_GUIDE.md
  - Update dependencies in pubspec.yaml
  - Migrate providers systematically
  - Run tests after each migration step

---

## 📝 Notes

### File Naming Conventions Observed

- **Phase Reports:** `A{N}_*.md` format
- **Implementation Reports:** `RAPPORT_IMPLEMENTATION_*.md`
- **Correction Reports:** `RAPPORT_CORRECTION_*.md`
- **Audits:** `AUDIT_*.md`
- **Summaries:** `RESUME_*.md` or `SYNTHESE_*.md`
- **Guides:** `GUIDE_*.md` or `DEPLOYMENT_GUIDE_*.md`

### Recommendations

1. **Consolidate Documentation Structure:**
   - Move all historical docs to `/docs/archive/`
   - Keep only active phase docs at root
   - Create a `/docs/active/` for current work-in-progress

2. **Implement Documentation Lifecycle:**
   - Active docs at root (current phase only)
   - Completed phase docs → archive
   - Max 3 phases of history in archive

3. **Create Index Files:**
   - `/docs/archive/INDEX.md` - master index
   - `/docs/archive/A18/INDEX.md` - phase index
   - Link between related documents

4. **Version Control:**
   - Tag each phase completion
   - Branch for major migrations
   - Maintain changelog

---

## ✅ Completion Status

- ✅ Directory tree generated
- ✅ All Markdown files identified (100 files)
- ✅ File sizes and dates collected
- ✅ Categorization complete
- ✅ Archive structure proposed
- ✅ Next steps documented

---

**Report Generated:** Monday, October 13, 2025  
**For Phase:** A18 - Riverpod 3.x Migration  
**Total Root MD Files:** 100  
**Files to Archive:** 91  
**Files to Keep:** 9  

**Ready for Phase A18 🚀**

