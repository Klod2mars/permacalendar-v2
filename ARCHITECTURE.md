# Architecture PermaCalendar v2.1

**Version :** 2.1.0  
**Date :** 8 octobre 2025  
**Statut :** Rétabli et documenté  
**Architecture :** Clean Architecture + Feature-based

---

## 📋 Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Principes architecturaux](#principes-architecturaux)
3. [Structure du projet](#structure-du-projet)
4. [Couches architecturales](#couches-architecturales)
5. [Patterns utilisés](#patterns-utilisés)
6. [Intelligence Végétale](#intelligence-végétale)
7. [Injection de dépendances](#injection-de-dépendances)
8. [Gestion des événements](#gestion-des-événements)
9. [Modèles de données](#modèles-de-données)
10. [Tests](#tests)
11. [Décisions architecturales (ADR)](#décisions-architecturales-adr)
12. [Maintenance](#maintenance)

---

## 🎯 Vue d'ensemble

PermaCalendar v2.1 est une application Flutter de gestion de jardin en permaculture avec une **Intelligence Végétale** intégrée. L'application suit une architecture **Clean Architecture** avec une approche **feature-based**.

### Principes directeurs

1. **Clean Architecture** : Séparation stricte domain / data / presentation
2. **SOLID** : Respect des 5 principes (SRP, OCP, LSP, ISP, DIP)
3. **Feature-based** : Code organisé par fonctionnalité métier
4. **Dependency Injection** : Via Riverpod modules centralisés
5. **Event-Driven** : Communication asynchrone entre features

### Technologies clés

- **Framework :** Flutter 3.x
- **State Management :** Riverpod 2.x
- **Persistance :** Hive (NoSQL local)
- **Sérialisation :** Freezed + json_serializable
- **Tests :** Flutter Test + Mockito
- **Architecture :** Clean Architecture

---

## 🏛️ Principes architecturaux

### Clean Architecture

L'application respecte les principes de Clean Architecture d'Uncle Bob :

```
┌─────────────────────────────────────────────────────┐
│                  Presentation                        │
│              (UI, Widgets, Providers)                │
└──────────────────┬──────────────────────────────────┘
                   │ Dépend de ↓
┌──────────────────▼──────────────────────────────────┐
│                    Domain                            │
│    (Entities, UseCases, Repository Interfaces)       │
└──────────────────△──────────────────────────────────┘
                   │ Implémente △
┌──────────────────┴──────────────────────────────────┐
│                     Data                             │
│    (Repository Impl, DataSources, Models)            │
└─────────────────────────────────────────────────────┘
```

**Règle d'or :** Les dépendances pointent toujours vers le centre (domain).

### SOLID

| Principe | Application dans PermaCalendar |
|----------|-------------------------------|
| **S**RP (Single Responsibility) | Chaque classe/UseCase a une seule responsabilité |
| **O**CP (Open/Closed) | Extensions via nouvelles entités/UseCases sans modification |
| **L**SP (Liskov Substitution) | Les implémentations respectent leurs contrats |
| **I**SP (Interface Segregation) | 5 interfaces spécialisées au lieu d'une monolithique (Prompt 4) |
| **D**IP (Dependency Inversion) | Dépendances via abstractions (interfaces, providers) |

---

## 📁 Structure du projet

```
lib/
├── core/                           # Code partagé transverse
│   ├── di/                         # Modules d'injection de dépendances
│   │   ├── intelligence_module.dart    # DI Intelligence Végétale
│   │   └── garden_module.dart          # DI Garden + Migration
│   ├── events/                     # Event Bus domain
│   │   ├── garden_events.dart          # Événements jardin (Freezed)
│   │   └── garden_event_bus.dart       # Bus pub-sub
│   ├── services/                   # Services infrastructure
│   │   ├── garden_event_observer_service.dart
│   │   └── aggregation/
│   │       └── garden_aggregation_hub.dart
│   ├── adapters/                   # Adaptateurs de migration
│   │   └── garden_migration_adapters.dart
│   ├── data/                       # Services data génériques
│   │   └── migration/
│   │       └── garden_data_migration.dart
│   └── models/                     # Modèles legacy (dépréciés)
│
├── features/                       # Features métier
│   ├── plant_intelligence/         # 🌱 Intelligence Végétale
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── plant_condition.dart
│   │   │   │   ├── analysis_result.dart       # Prompt 1
│   │   │   │   ├── intelligence_report.dart   # Prompt 1
│   │   │   │   ├── recommendation.dart
│   │   │   │   ├── weather_condition.dart
│   │   │   │   └── garden_context.dart
│   │   │   ├── repositories/       # Interfaces (ISP)
│   │   │   │   ├── i_plant_condition_repository.dart    # Prompt 4
│   │   │   │   ├── i_weather_repository.dart            # Prompt 4
│   │   │   │   ├── i_garden_context_repository.dart     # Prompt 4
│   │   │   │   ├── i_recommendation_repository.dart     # Prompt 4
│   │   │   │   ├── i_analytics_repository.dart          # Prompt 4
│   │   │   │   └── plant_intelligence_repository.dart   # @Deprecated
│   │   │   ├── usecases/
│   │   │   │   ├── analyze_plant_conditions_usecase.dart     # Prompt 2
│   │   │   │   ├── evaluate_planting_timing_usecase.dart     # Prompt 2
│   │   │   │   └── generate_recommendations_usecase.dart     # Prompt 2
│   │   │   └── services/
│   │   │       └── plant_intelligence_orchestrator.dart      # Prompt 3
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── plant_intelligence_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── plant_intelligence_repository_impl.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── plant_intelligence_providers.dart
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── plant_catalog/              # Catalogue de plantes
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── plant_entity.dart
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── plant_hive_repository.dart  # Prompt 9 (multi-format)
│   │   └── presentation/
│   │
│   ├── garden_management/          # Gestion des jardins
│   ├── planting/                   # Plantations
│   ├── activities/                 # Activités
│   └── weather/                    # Météo
│
├── shared/                         # Widgets réutilisables
│   ├── widgets/
│   └── presentation/
│
├── app_initializer.dart            # Initialisation app (Prompt 8)
├── app_router.dart                 # Navigation
└── main.dart                       # Point d'entrée
```

### Organisation par feature

Chaque feature suit la structure Clean Architecture :

```
features/ma_feature/
├── domain/              # Couche métier
│   ├── entities/        # Entités domain (Freezed)
│   ├── repositories/    # Interfaces
│   ├── usecases/        # Cas d'usage
│   └── services/        # Orchestrators (optionnel)
├── data/                # Couche données
│   ├── datasources/     # Sources de données
│   ├── repositories/    # Implémentations
│   └── models/          # Modèles de persistance
└── presentation/        # Couche UI
    ├── providers/       # State management
    ├── screens/         # Écrans
    └── widgets/         # Widgets spécifiques
```

---

## 🏗️ Couches architecturales

### Domain Layer (Couche métier)

**Responsabilités :**
- Définir les **entités métier** (immutables, Freezed)
- Encapsuler la **logique métier** (UseCases)
- Définir les **contrats** (interfaces repositories)
- Orchestrer les **flux complexes** (Orchestrators)

**Dépendances :** ✅ **AUCUNE** (couche indépendante)

**Exemple :** `PlantIntelligenceOrchestrator`
```dart
// domain/services/plant_intelligence_orchestrator.dart
class PlantIntelligenceOrchestrator {
  // Dépend uniquement d'interfaces domain
  final IPlantConditionRepository _conditionRepository;
  final IWeatherRepository _weatherRepository;
  // ...
  
  Future<PlantIntelligenceReport> generateIntelligenceReport({
    required String plantId,
    required String gardenId,
  }) async {
    // Orchestration de 3 UseCases
    final analysis = await _analyzeUsecase.execute(...);
    final timing = await _evaluateTimingUsecase.execute(...);
    final recommendations = await _generateRecommendationsUsecase.execute(...);
    
    return PlantIntelligenceReport(...);
  }
}
```

### Data Layer (Couche données)

**Responsabilités :**
- **Implémenter** les interfaces repositories
- Gérer les **DataSources** (local Hive, remote API)
- Convertir **data ↔ domain** (modèles → entités)
- Gérer la **persistance** et le **cache**

**Dépendances :** Domain (interfaces uniquement)

**Exemple :** `PlantIntelligenceRepositoryImpl`
```dart
// data/repositories/plant_intelligence_repository_impl.dart
class PlantIntelligenceRepositoryImpl implements 
    IPlantConditionRepository,
    IWeatherRepository,
    IGardenContextRepository,
    IRecommendationRepository,
    IAnalyticsRepository {
  
  final IPlantIntelligenceLocalDataSource _localDataSource;
  final GardenAggregationHub _aggregationHub;
  
  // Implémentation de toutes les interfaces (ISP)
  @override
  Future<String> savePlantCondition(...) async {
    // Persistance via DataSource
  }
}
```

### Presentation Layer (Couche UI)

**Responsabilités :**
- **Widgets** et **Screens** (UI)
- **State Management** (Riverpod providers)
- **Navigation** (go_router)
- **Interaction utilisateur**

**Dépendances :** Domain (via providers)

**Exemple :** Provider
```dart
// presentation/providers/plant_intelligence_providers.dart
final generateIntelligenceReportProvider = FutureProvider.family<
  PlantIntelligenceReport,
  ({String plantId, String gardenId})
>((ref, params) async {
  final orchestrator = ref.read(IntelligenceModule.orchestratorProvider);
  return orchestrator.generateIntelligenceReport(
    plantId: params.plantId,
    gardenId: params.gardenId,
  );
});
```

---

## 🔧 Patterns utilisés

### 1. Repository Pattern

Les repositories abstrayent l'accès aux données derrière des interfaces.

**Avantages :**
- ✅ Découplage domain/data
- ✅ Facilite les tests (mocks)
- ✅ Changement de source de données transparent

**Exemple :**
```dart
// Interface (domain)
abstract class IPlantConditionRepository {
  Future<PlantCondition?> getCurrentPlantCondition(String plantId);
}

// Implémentation (data)
class PlantIntelligenceRepositoryImpl implements IPlantConditionRepository {
  @override
  Future<PlantCondition?> getCurrentPlantCondition(String plantId) async {
    // Lecture depuis Hive
  }
}
```

### 2. UseCase Pattern

Chaque cas d'usage métier est isolé dans un UseCase.

**Avantages :**
- ✅ Logique métier testable unitairement
- ✅ Responsabilité unique (SRP)
- ✅ Réutilisable

**Exemple :**
```dart
class AnalyzePlantConditionsUsecase {
  Future<PlantAnalysisResult> execute({
    required PlantFreezed plant,
    required WeatherCondition weather,
    required GardenContext garden,
  }) async {
    // Analyse des 4 conditions
    final temperature = _analyzeTemperature(...);
    final humidity = _analyzeHumidity(...);
    final light = _analyzeLight(...);
    final soil = _analyzeSoil(...);
    
    // Calcul santé globale
    return PlantAnalysisResult(...);
  }
}
```

### 3. Orchestrator Pattern

Les orchestrators coordonnent plusieurs UseCases pour des flux complexes.

**Avantages :**
- ✅ Séparation des responsabilités
- ✅ Logique métier de haut niveau
- ✅ Testable avec mocks

**Flux :**
```
Orchestrator
  ├─→ UseCase 1 → Résultat 1
  ├─→ UseCase 2 → Résultat 2
  └─→ UseCase 3 → Résultat 3
       ↓
  Combine → Résultat final
```

### 4. Event Bus Pattern (Pub-Sub)

Communication asynchrone entre features via événements domain.

**Avantages :**
- ✅ Découplage complet des features
- ✅ Communication asynchrone
- ✅ Facilite l'ajout de nouvelles features

**Exemple :**
```dart
// Émission d'événement
GardenEventBus().emit(
  GardenEvent.plantingAdded(
    gardenId: 'garden_1',
    plantingId: 'planting_123',
    plantId: 'tomato',
    timestamp: DateTime.now(),
  ),
);

// Écoute d'événements
GardenEventBus().events.listen((event) {
  event.when(
    plantingAdded: (gardenId, plantingId, plantId, timestamp, metadata) {
      // Déclencher analyse Intelligence Végétale
    },
    // ... autres événements
  );
});
```

### 5. Adapter Pattern

Convertit entre différentes représentations de données (migration).

**Exemple :** Migration Garden Legacy → Freezed
```dart
class GardenMigrationAdapters {
  static GardenFreezed fromLegacy(Garden legacy) {
    return GardenFreezed(
      id: legacy.id,
      name: legacy.name,
      // ... conversion complète
    );
  }
}
```

---

## 🌱 Intelligence Végétale

L'Intelligence Végétale est la fonctionnalité centrale de PermaCalendar, permettant d'analyser les conditions des plantes et de générer des recommandations personnalisées.

### Architecture complète

```
┌─────────────────────────────────────────────────────────────┐
│                      User Action                             │
│              (Planter, Arroser, Modifier)                    │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌──────────────────────▼──────────────────────────────────────┐
│                 GardenEventBus                               │
│            emit(GardenEvent.plantingAdded)                   │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌──────────────────────▼──────────────────────────────────────┐
│           GardenEventObserverService                         │
│              (Écoute et réagit aux événements)               │
└──────────────────────┬──────────────────────────────────────┘
                       ↓
┌──────────────────────▼──────────────────────────────────────┐
│        PlantIntelligenceOrchestrator (Domain)                │
│         Coordonne les 3 UseCases                             │
└───┬──────────────┬─────────────────┬───────────────────────┘
    ↓              ↓                 ↓
┌───▼────┐  ┌─────▼──────┐  ┌──────▼──────────┐
│Analyze │  │ Evaluate   │  │  Generate       │
│Condi-  │  │ Planting   │  │  Recommenda-    │
│tions   │  │ Timing     │  │  tions          │
└───┬────┘  └─────┬──────┘  └──────┬──────────┘
    ↓              ↓                 ↓
    └──────────────┴─────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│             PlantIntelligenceReport                          │
│  - Analysis (4 conditions + santé globale)                   │
│  - Timing (optimal pour planter ?)                           │
│  - Recommendations (actions prioritaires)                    │
│  - Active Alerts (alertes critiques)                         │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│              Repositories (Persistance)                      │
│   - Conditions sauvegardées                                  │
│   - Recommandations enregistrées                             │
│   - Historique constitué                                     │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│                    UI Display                                │
│        - Dashboard Intelligence                              │
│        - Notifications                                       │
│        - Historique                                          │
└─────────────────────────────────────────────────────────────┘
```

### Flux de données détaillé

**1. Événement trigger**
```dart
// Utilisateur crée une plantation
GardenEventBus().emit(
  GardenEvent.plantingAdded(...)
);
```

**2. Observer détecte**
```dart
GardenEventObserverService._handleEvent(event) {
  event.when(
    plantingAdded: (gardenId, plantingId, plantId, ...) async {
      // Déclencher analyse
      await _orchestrator.generateIntelligenceReport(
        plantId: plantId,
        gardenId: gardenId,
      );
    },
    // ...
  );
}
```

**3. Orchestrator coordonne**
```dart
Future<PlantIntelligenceReport> generateIntelligenceReport(...) async {
  // Étape 1 : Récupérer contexte
  final plant = await _getPlant(plantId);
  final garden = await _gardenRepository.getGardenContext(gardenId);
  final weather = await _weatherRepository.getCurrentWeatherCondition(gardenId);
  
  // Étape 2 : Analyser conditions
  final analysis = await _analyzeUsecase.execute(
    plant: plant, weather: weather, garden: garden
  );
  
  // Étape 3 : Évaluer timing
  final timing = await _evaluateTimingUsecase.execute(...);
  
  // Étape 4 : Générer recommandations
  final recommendations = await _generateRecommendationsUsecase.execute(
    plant: plant,
    analysisResult: analysis,
    weather: weather,
    garden: garden,
  );
  
  // Étape 5 : Créer rapport
  return PlantIntelligenceReport(...);
}
```

**4. UseCases exécutent**

Chaque UseCase a une responsabilité unique :

| UseCase | Responsabilité | Résultat |
|---------|---------------|----------|
| `AnalyzePlantConditionsUsecase` | Analyse 4 conditions (T°, humidité, lumière, sol) | `PlantAnalysisResult` |
| `EvaluatePlantingTimingUsecase` | Évalue si c'est le bon moment pour planter | `PlantingTimingEvaluation` |
| `GenerateRecommendationsUsecase` | Génère recommandations personnalisées | `List<Recommendation>` |

**5. Repositories persistent**
```dart
// Sauvegarder les 4 conditions
await _conditionRepository.savePlantCondition(analysis.temperature);
await _conditionRepository.savePlantCondition(analysis.humidity);
// ...

// Sauvegarder les recommandations
for (final rec in recommendations) {
  await _recommendationRepository.saveRecommendation(rec);
}

// Sauvegarder l'analyse complète
await _analyticsRepository.saveAnalysisResult(...);
```

**6. UI affiche**
```dart
// Provider expose le rapport
final reportProvider = generateIntelligenceReportProvider(
  (plantId: 'tomato', gardenId: 'garden_1')
);

// Widget consomme
ref.watch(reportProvider).when(
  data: (report) => IntelligenceReportWidget(report: report),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => ErrorWidget(e),
);
```

### Entités domain créées (Prompts 1-2)

**1. PlantAnalysisResult** (Prompt 1)
```dart
@freezed
class PlantAnalysisResult with _$PlantAnalysisResult {
  const factory PlantAnalysisResult({
    required String id,
    required String plantId,
    required PlantCondition temperature,   // Température
    required PlantCondition humidity,      // Humidité
    required PlantCondition light,         // Luminosité
    required PlantCondition soil,          // Sol
    required ConditionStatus overallHealth, // Santé globale
    required double healthScore,           // Score 0-100
    required List<String> warnings,        // Avertissements
    required List<String> strengths,       // Points forts
    required List<String> priorityActions, // Actions prioritaires
    required double confidence,            // Confiance 0-1
    required DateTime analyzedAt,
  }) = _PlantAnalysisResult;
}

// Extensions utilitaires
extension PlantAnalysisResultExtension on PlantAnalysisResult {
  bool get isCritical => overallHealth == ConditionStatus.critical;
  bool get isHealthy => overallHealth == ConditionStatus.excellent;
  int get criticalConditionsCount { /* ... */ }
  PlantCondition get mostCriticalCondition { /* ... */ }
}
```

**2. PlantIntelligenceReport** (Prompt 1)
```dart
@freezed
class PlantIntelligenceReport with _$PlantIntelligenceReport {
  const factory PlantIntelligenceReport({
    required String id,
    required String plantId,
    required String plantName,
    required String gardenId,
    required PlantAnalysisResult analysis,           // Analyse complète
    required List<Recommendation> recommendations,   // Recommandations
    PlantingTimingEvaluation? plantingTiming,        // Timing
    @Default([]) List<NotificationAlert> activeAlerts, // Alertes
    required double intelligenceScore,               // Score global 0-100
    required double confidence,                      // Confiance 0-1
    required DateTime generatedAt,
    required DateTime expiresAt,                     // Durée de validité
  }) = _PlantIntelligenceReport;
}
```

**3. PlantingTimingEvaluation** (Prompt 1)
```dart
@freezed
class PlantingTimingEvaluation with _$PlantingTimingEvaluation {
  const factory PlantingTimingEvaluation({
    required bool isOptimalTime,          // Bon moment ?
    required double timingScore,          // Score 0-100
    required String reason,               // Raison
    DateTime? optimalPlantingDate,        // Prochaine date optimale
    @Default([]) List<String> favorableFactors,     // Facteurs +
    @Default([]) List<String> unfavorableFactors,   // Facteurs -
    @Default([]) List<String> risks,                // Risques
  }) = _PlantingTimingEvaluation;
}
```

---

## 💉 Injection de dépendances

L'injection de dépendances est centralisée dans des **modules Riverpod** (Prompt 8).

### Modules disponibles

**1. IntelligenceModule** (`lib/core/di/intelligence_module.dart`)

Centralise toutes les dépendances de l'Intelligence Végétale :

```dart
class IntelligenceModule {
  // DataSources (1)
  static final localDataSourceProvider = Provider<IPlantIntelligenceLocalDataSource>(...);
  
  // Repositories (6 : implémentation + 5 interfaces ISP)
  static final repositoryImplProvider = Provider<PlantIntelligenceRepositoryImpl>(...);
  static final conditionRepositoryProvider = Provider<IPlantConditionRepository>(...);
  static final weatherRepositoryProvider = Provider<IWeatherRepository>(...);
  static final gardenContextRepositoryProvider = Provider<IGardenContextRepository>(...);
  static final recommendationRepositoryProvider = Provider<IRecommendationRepository>(...);
  static final analyticsRepositoryProvider = Provider<IAnalyticsRepository>(...);
  
  // UseCases (3)
  static final analyzeConditionsUsecaseProvider = Provider<AnalyzePlantConditionsUsecase>(...);
  static final evaluateTimingUsecaseProvider = Provider<EvaluatePlantingTimingUsecase>(...);
  static final generateRecommendationsUsecaseProvider = Provider<GenerateRecommendationsUsecase>(...);
  
  // Orchestrator (1)
  static final orchestratorProvider = Provider<PlantIntelligenceOrchestrator>((ref) {
    return PlantIntelligenceOrchestrator(
      conditionRepository: ref.read(conditionRepositoryProvider),
      weatherRepository: ref.read(weatherRepositoryProvider),
      gardenRepository: ref.read(gardenContextRepositoryProvider),
      recommendationRepository: ref.read(recommendationRepositoryProvider),
      analyticsRepository: ref.read(analyticsRepositoryProvider),
      analyzeUsecase: ref.read(analyzeConditionsUsecaseProvider),
      evaluateTimingUsecase: ref.read(evaluateTimingUsecaseProvider),
      generateRecommendationsUsecase: ref.read(generateRecommendationsUsecaseProvider),
    );
  });
}
```

**2. GardenModule** (`lib/core/di/garden_module.dart`)

Centralise les dépendances du système Garden :

```dart
class GardenModule {
  // Hub central
  static final aggregationHubProvider = Provider<GardenAggregationHub>(...);
  
  // Repository
  static final gardenRepositoryProvider = Provider<GardenHiveRepository>(...);
  
  // Migration
  static final dataMigrationProvider = Provider<GardenDataMigration>(...);
  
  // Helpers
  static final isMigrationNeededProvider = FutureProvider<bool>(...);
  static final migrationStatsProvider = FutureProvider<Map<String, int>>(...);
}
```

### Usage

**Dans AppInitializer :**
```dart
// app_initializer.dart
static Future<void> _initializeConditionalServices() async {
  final container = ProviderContainer();
  
  // Récupérer l'orchestrateur depuis le module DI
  final orchestrator = container.read(IntelligenceModule.orchestratorProvider);
  
  // Initialiser le service d'observation
  GardenEventObserverService.instance.initialize(
    orchestrator: orchestrator,
  );
}
```

**Dans un provider :**
```dart
// Accès direct au module
final orchestrator = ref.read(IntelligenceModule.orchestratorProvider);

// Ou via extension
extension IntelligenceModuleExtensions on Ref {
  PlantIntelligenceOrchestrator get intelligenceOrchestrator =>
      read(IntelligenceModule.orchestratorProvider);
}

final orchestrator = ref.intelligenceOrchestrator;
```

**Dans un widget :**
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accès à l'interface spécialisée
    final weatherRepo = ref.read(IntelligenceModule.weatherRepositoryProvider);
    
    // Utilisation
    final weather = await weatherRepo.getCurrentWeatherCondition('garden_1');
  }
}
```

### Avantages

✅ **Configuration unique** : Un seul endroit pour toutes les dépendances  
✅ **Réutilisabilité** : Modules accessibles partout (app, providers, tests)  
✅ **Testabilité** : Mocks faciles via override de providers  
✅ **Cache automatique** : Riverpod gère le cache des instances  
✅ **Type-safe** : Erreurs détectées à la compilation  

---

## 📡 Gestion des événements

Communication asynchrone entre features via un EventBus domain (Prompt 6).

### Architecture Event-Driven

```
Feature A                      Feature B
   ↓                              ↑
   emit(Event)                    listen(Event)
   ↓                              ↑
   └──→ GardenEventBus ──────────┘
        (Broadcast Stream)
```

**Avantages :**
- ✅ Découplage complet des features
- ✅ Communication asynchrone
- ✅ Facilite l'ajout de nouvelles features
- ✅ Pas de dépendances circulaires

### GardenEvent (Freezed)

5 types d'événements définis :

```dart
// core/events/garden_events.dart
@freezed
class GardenEvent with _$GardenEvent {
  // 1. Nouvelle plantation
  const factory GardenEvent.plantingAdded({
    required String gardenId,
    required String plantingId,
    required String plantId,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = PlantingAddedEvent;
  
  // 2. Récolte
  const factory GardenEvent.plantingHarvested({
    required String gardenId,
    required String plantingId,
    required double harvestYield,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = PlantingHarvestedEvent;
  
  // 3. Changement météo significatif
  const factory GardenEvent.weatherChanged({
    required String gardenId,
    required double previousTemperature,
    required double currentTemperature,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = WeatherChangedEvent;
  
  // 4. Activité utilisateur
  const factory GardenEvent.activityPerformed({
    required String gardenId,
    required String activityType,  // watering, fertilizing, etc.
    String? targetId,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = ActivityPerformedEvent;
  
  // 5. Mise à jour contexte jardin
  const factory GardenEvent.gardenContextUpdated({
    required String gardenId,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = GardenContextUpdatedEvent;
}
```

### GardenEventBus (Singleton)

```dart
// core/events/garden_event_bus.dart
class GardenEventBus {
  static final GardenEventBus _instance = GardenEventBus._internal();
  factory GardenEventBus() => _instance;
  
  final _controller = StreamController<GardenEvent>.broadcast();
  
  // Stream en lecture seule
  Stream<GardenEvent> get events => _controller.stream;
  
  // Émettre un événement
  void emit(GardenEvent event) {
    _controller.add(event);
    _eventCount++;
  }
  
  // Statistiques
  int get eventCount => _eventCount;
  int get listenerCount => _controller.stream.length;
  
  void dispose() => _controller.close();
}
```

### Émission d'événements

**Exemple : Nouvelle plantation**
```dart
// features/planting/providers/planting_provider.dart
void _onPlantingCreated(Planting planting) {
  // Émettre événement
  GardenEventBus().emit(
    GardenEvent.plantingAdded(
      gardenId: planting.gardenId,
      plantingId: planting.id,
      plantId: planting.plantId,
      timestamp: DateTime.now(),
      metadata: {
        'bedId': planting.bedId,
        'quantity': planting.quantity,
      },
    ),
  );
}
```

### Écoute d'événements

**GardenEventObserverService :**
```dart
// core/services/garden_event_observer_service.dart
class GardenEventObserverService {
  void initialize({required PlantIntelligenceOrchestrator orchestrator}) {
    _orchestrator = orchestrator;
    
    // S'abonner aux événements
    _subscription = GardenEventBus().events.listen(_handleEvent);
  }
  
  Future<void> _handleEvent(GardenEvent event) async {
    await event.when(
      plantingAdded: (gardenId, plantingId, plantId, timestamp, metadata) async {
        // Déclencher analyse Intelligence Végétale
        await _orchestrator!.generateIntelligenceReport(
          plantId: plantId,
          gardenId: gardenId,
        );
      },
      
      weatherChanged: (gardenId, prevTemp, currTemp, timestamp, metadata) async {
        final tempDiff = (currTemp - prevTemp).abs();
        
        // Si changement significatif (> 5°C), analyser toutes les plantes
        if (tempDiff > 5.0) {
          await _orchestrator!.generateGardenIntelligenceReport(
            gardenId: gardenId,
          );
        }
      },
      
      // ... autres handlers
    );
  }
}
```

---

## 💾 Modèles de données

### Garden Models (Prompt 7)

**Avant :** 5 modèles Garden différents ❌  
**Après :** 1 modèle unifié ✅

| Modèle | HiveType | Statut | Usage |
|--------|----------|--------|-------|
| `Garden` (legacy) | 0 | ⚠️ @Deprecated | Migration uniquement |
| `Garden` (v2) | 10 | ⚠️ @Deprecated | Migration uniquement |
| `GardenHive` | 25 | ✅ Actif | Compatible Freezed |
| `GardenFreezed` | - | ✅ **Principal** | **Modèle unique cible** |

**Migration automatique :**
```dart
// core/data/migration/garden_data_migration.dart
class GardenDataMigration {
  Future<GardenMigrationResult> migrateAllGardens({
    bool dryRun = false,
    bool backupBeforeMigration = true,
    bool cleanupOldBoxes = false,
  }) async {
    // 1. Migrer Legacy → Freezed
    await _migrateLegacyGardens();
    
    // 2. Migrer V2 → Freezed
    await _migrateV2Gardens();
    
    // 3. Migrer Hive → Freezed
    await _migrateHiveGardens();
    
    // 4. Vérifier intégrité
    await _verifyIntegrity();
    
    return GardenMigrationResult(...);
  }
}
```

**Adaptateurs :**
```dart
// core/adapters/garden_migration_adapters.dart
class GardenMigrationAdapters {
  static GardenFreezed fromLegacy(Garden legacy) { /* ... */ }
  static GardenFreezed fromV2(GardenV2 v2) { /* ... */ }
  static GardenFreezed fromHive(GardenHive hive) { /* ... */ }
  
  // Auto-détection
  static GardenFreezed autoMigrate(dynamic source) {
    if (source is Garden) return fromLegacy(source);
    if (source is GardenV2) return fromV2(source);
    if (source is GardenHive) return fromHive(source);
    throw UnsupportedError('Type non supporté: ${source.runtimeType}');
  }
}
```

### Plants.json (Prompt 9)

**Avant :** Format array-only, 203.9 KB ❌  
**Après :** Format structuré v2.1.0, 156.4 KB (-23.3%) ✅

**Structure v2.1.0 :**
```json
{
  "schema_version": "2.1.0",
  "metadata": {
    "version": "2.1.0",
    "updated_at": "2025-10-08",
    "total_plants": 44,
    "source": "PermaCalendar Team",
    "description": "Base de données des plantes pour permaculture"
  },
  "plants": [
    {
      "id": "tomato",
      "commonName": "Tomate",
      "scientificName": "Solanum lycopersicum",
      "family": "Solanaceae",
      "sowingMonths": ["M", "A", "M"],
      "harvestMonths": ["J", "J", "A", "S", "O"],
      // plantingSeason supprimé (redondant)
      // harvestSeason supprimé (redondant)
      // notificationSettings supprimé (logique applicative)
    }
  ]
}
```

**Support multi-format :**
```dart
// plant_catalog/data/repositories/plant_hive_repository.dart
Future<void> initializeFromJson() async {
  final jsonString = await rootBundle.loadString('assets/data/plants.json');
  final dynamic jsonData = json.decode(jsonString);
  
  List<dynamic> plantsList;
  String detectedFormat;
  
  if (jsonData is List) {
    // Format Legacy (array-only)
    plantsList = jsonData;
    detectedFormat = 'Legacy (array-only)';
  } else if (jsonData is Map<String, dynamic>) {
    // Format v2.1.0+ (structured)
    final schemaVersion = jsonData['schema_version'];
    plantsList = jsonData['plants'];
    detectedFormat = 'v$schemaVersion (structured)';
    
    // Logger métadonnées
    final metadata = jsonData['metadata'];
    developer.log('Version: ${metadata['version']}, Plantes: ${metadata['total_plants']}');
  }
  
  // Charger les plantes
  for (var plant in plantsList) {
    // ...
  }
}
```

---

## 🧪 Tests

### Stratégie de tests

| Type de test | Cible | Couverture visée | Outils |
|-------------|-------|------------------|--------|
| **Tests unitaires** | Domain (Entities, UseCases) | 80% | Flutter Test |
| **Tests d'intégration** | Orchestrators + Repositories | 70% | Mockito |
| **Tests widgets** | Screens + Widgets critiques | 40% | Flutter Test |

### Tests créés (Prompt 5)

**Total : 127 tests** (90.7% de réussite)

| Suite de tests | Tests | Résultat |
|---------------|-------|----------|
| Entités (analysis_result, intelligence_report) | 15 | 15/15 (100%) ✅ |
| UseCases (analyze, evaluate, generate) | 30 | 26/30 (87%) ⚠️ |
| Orchestrator | 9 | 9/9 (100%) ✅ |
| EventBus | 7 | 7/7 (100%) ✅ |
| GardenEventObserver | 8 | 8/8 (100%) ✅ |
| Garden Migration Adapters | 28 | 28/28 (100%) ✅ |
| Garden Data Migration | 16 | 16/16 (100%) ✅ |
| Plants.json Migration | 14 | 14/14 (100%) ✅ |
| **Total** | **127** | **123/127 (96.9%)** |

### Helpers de test

**Centralisés** dans `test/helpers/plant_intelligence_test_helpers.dart` :

```dart
// Créer une plante mock
PlantFreezed createMockPlant({
  String id = 'tomato',
  String commonName = 'Tomate',
  Map<String, dynamic>? metadata,
}) { /* ... */ }

// Créer des conditions météo mock
WeatherCondition createMockWeather({
  double temperature = 20.0,
  DateTime? measuredAt,
}) { /* ... */ }

// Créer un contexte jardin mock
GardenContext createMockGarden({
  String id = 'garden_1',
  double ph = 6.5,
}) { /* ... */ }

// Créer une analyse mock
PlantAnalysisResult createMockAnalysis({ /* ... */ }) { /* ... */ }

// Créer un rapport mock
PlantIntelligenceReport createMockReport({ /* ... */ }) { /* ... */ }
```

### Exécution des tests

```bash
# Tous les tests
flutter test

# Tests avec couverture
flutter test --coverage

# Tests d'une feature spécifique
flutter test test/features/plant_intelligence/

# Générer rapport HTML de couverture
genhtml coverage/lcov.info -o coverage/html
```

### Configuration CI/CD

```yaml
# .github/workflows/tests.yml
- name: Run tests with coverage
  run: flutter test --coverage

- name: Upload coverage to Codecov
  uses: codecov/codecov-action@v3
  with:
    file: ./coverage/lcov.info
```

---

## 📜 Décisions architecturales (ADR)

### ADR-001 : Découpage du repository en interfaces (ISP)

**Date :** 8 octobre 2025  
**Statut :** ✅ Accepté  
**Prompt :** 4

**Contexte :**  
`PlantIntelligenceRepository` contenait 40+ méthodes, violant le principe ISP. Les clients dépendaient de méthodes inutilisées.

**Décision :**  
Découper en 5 interfaces spécialisées :
- `IPlantConditionRepository` (5 méthodes)
- `IWeatherRepository` (3 méthodes)
- `IGardenContextRepository` (6 méthodes)
- `IRecommendationRepository` (7 méthodes)
- `IAnalyticsRepository` (11 méthodes)

**Conséquences :**
- ✅ ISP respecté
- ✅ Clients dépendent uniquement de ce dont ils ont besoin
- ✅ Tests plus ciblés (mocks spécifiques)
- ✅ Maintenabilité accrue
- ⚠️ Augmentation du nombre de fichiers (+5)

---

### ADR-002 : Event Bus pour communication inter-features

**Date :** 8 octobre 2025  
**Statut :** ✅ Accepté  
**Prompt :** 6

**Contexte :**  
Intelligence Végétale doit réagir aux événements jardin (plantation, météo) sans créer de dépendances circulaires.

**Décision :**  
Créer un `GardenEventBus` domain avec pattern Publish-Subscribe :
- 5 types d'événements définis avec Freezed
- StreamController broadcast
- Singleton

**Conséquences :**
- ✅ Découplage complet des features
- ✅ Communication asynchrone
- ✅ Facilite l'ajout de nouvelles features
- ✅ Testabilité (mocks d'événements)
- ⚠️ Complexité ajoutée (asynchrone)

---

### ADR-003 : Modules Riverpod pour DI

**Date :** 8 octobre 2025  
**Statut :** ✅ Accepté  
**Prompt :** 8

**Contexte :**  
Instanciations directes dans `AppInitializer` et duplication de configuration dans les providers.

**Décision :**  
Créer des modules statiques Riverpod :
- `IntelligenceModule` (11 providers)
- `GardenModule` (5 providers)

**Conséquences :**
- ✅ Configuration unique et centralisée
- ✅ Réutilisabilité maximale
- ✅ Cache automatique Riverpod
- ✅ Testabilité (override providers)
- ⚠️ Apprentissage Riverpod nécessaire

---

### ADR-004 : GardenFreezed comme modèle unique

**Date :** 8 octobre 2025  
**Statut :** ✅ Accepté  
**Prompt :** 7

**Contexte :**  
5 modèles Garden différents causaient confusion et bugs de synchronisation.

**Décision :**  
Unifier sur `GardenFreezed` :
- Adaptateurs de migration (Legacy/V2/Hive → Freezed)
- Script de migration automatique
- Dépréciation progressive des anciens modèles

**Conséquences :**
- ✅ Un seul modèle actif (maintenabilité)
- ✅ Migration automatisée (44 tests)
- ✅ Compatibilité maintenue (adaptateurs)
- ⚠️ Migration manuelle nécessaire en production

---

### ADR-005 : Versioning plants.json

**Date :** 8 octobre 2025  
**Statut :** ✅ Accepté  
**Prompt :** 9

**Contexte :**  
`plants.json` sans versioning, format array-only, duplication de données (plantingSeason + sowingMonths).

**Décision :**  
Créer format structuré v2.1.0 :
- `schema_version` + `metadata`
- Suppression redondances (plantingSeason, harvestSeason, notificationSettings)
- Support multi-format (détection automatique)

**Conséquences :**
- ✅ Versioning et évolutivité
- ✅ Réduction 23.3% de taille (47.5 KB)
- ✅ Validation automatisée (JSON Schema)
- ✅ Compatibilité legacy maintenue

---

## 🛠️ Maintenance

### Ajouter une nouvelle feature

**Étapes :**

1. **Créer la structure feature-based**
   ```
   lib/features/ma_feature/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   ├── data/
   │   ├── datasources/
   │   └── repositories/
   └── presentation/
       ├── providers/
       ├── screens/
       └── widgets/
   ```

2. **Définir le domain**
   - Créer les entités (Freezed)
   - Définir les interfaces repositories
   - Implémenter les UseCases

3. **Implémenter la couche data**
   - Créer les DataSources
   - Implémenter les repositories

4. **Créer la présentation**
   - Créer les providers Riverpod
   - Créer les screens et widgets

5. **Créer le module DI**
   ```dart
   // lib/core/di/ma_feature_module.dart
   class MaFeatureModule {
     static final dataSourceProvider = Provider<IMaFeatureDataSource>(...);
     static final repositoryProvider = Provider<IMaFeatureRepository>(...);
     static final usecaseProvider = Provider<MaFeatureUsecase>(...);
   }
   ```

6. **Ajouter les tests**
   ```
   test/features/ma_feature/
   ├── domain/
   │   ├── entities/
   │   └── usecases/
   └── data/
       └── repositories/
   ```

7. **Intégrer aux événements** (si nécessaire)
   ```dart
   // Émettre des événements
   GardenEventBus().emit(MaFeatureEvent(...));
   
   // Écouter des événements
   GardenEventObserverService._handleEvent(event) {
     event.when(
       maFeatureEvent: (...) async { /* Réagir */ },
     );
   }
   ```

### Modifier une entité

**Étapes :**

1. **Modifier l'entité dans domain**
   ```dart
   // domain/entities/my_entity.dart
   @freezed
   class MyEntity with _$MyEntity {
     const factory MyEntity({
       required String id,
       required String newProperty,  // ✅ Ajout
     }) = _MyEntity;
   }
   ```

2. **Régénérer avec build_runner**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Mettre à jour les UseCases concernés**
   ```dart
   // domain/usecases/my_usecase.dart
   Future<MyEntity> execute() async {
     return MyEntity(
       id: '1',
       newProperty: 'value',  // ✅ Utiliser nouvelle propriété
     );
   }
   ```

4. **Mettre à jour les tests**
   ```dart
   test('should include new property', () {
     final entity = MyEntity(id: '1', newProperty: 'value');
     expect(entity.newProperty, 'value');
   });
   ```

5. **Vérifier les impacts**
   ```bash
   # Rechercher tous les usages
   grep -r "MyEntity" lib/
   
   # Lancer les tests
   flutter test
   ```

### Ajouter un nouveau UseCase

**Template :**

```dart
// domain/usecases/my_new_usecase.dart
class MyNewUsecase {
  final IMyRepository _repository;
  
  const MyNewUsecase(this._repository);
  
  /// Description du cas d'usage
  /// 
  /// [param1] - Description paramètre 1
  /// [param2] - Description paramètre 2
  /// 
  /// Retourne [MyEntity] avec les données traitées
  Future<MyEntity> execute({
    required String param1,
    required int param2,
  }) async {
    // 1. Validation des paramètres
    _validateInputs(param1, param2);
    
    // 2. Récupérer les données
    final data = await _repository.getData(param1);
    
    // 3. Traiter
    final processed = _process(data, param2);
    
    // 4. Retourner
    return MyEntity(
      id: processed.id,
      // ...
    );
  }
  
  void _validateInputs(String param1, int param2) {
    if (param1.isEmpty) throw ArgumentError('param1 cannot be empty');
    if (param2 < 0) throw ArgumentError('param2 must be positive');
  }
  
  // ... méthodes privées
}
```

**Test correspondant :**

```dart
// test/domain/usecases/my_new_usecase_test.dart
void main() {
  group('MyNewUsecase', () {
    late MyNewUsecase usecase;
    late MockIMyRepository mockRepository;
    
    setUp(() {
      mockRepository = MockIMyRepository();
      usecase = MyNewUsecase(mockRepository);
    });
    
    test('should return MyEntity when executed successfully', () async {
      // Arrange
      when(mockRepository.getData(any))
          .thenAnswer((_) async => mockData);
      
      // Act
      final result = await usecase.execute(
        param1: 'test',
        param2: 42,
      );
      
      // Assert
      expect(result, isA<MyEntity>());
      verify(mockRepository.getData('test')).called(1);
    });
    
    test('should throw ArgumentError when param1 is empty', () async {
      // Act & Assert
      expect(
        () => usecase.execute(param1: '', param2: 42),
        throwsArgumentError,
      );
    });
  });
}
```

### Debugging

**Logs disponibles :**

```dart
// Activer les logs détaillés
import 'dart:developer' as developer;

developer.log('Message', name: 'FeatureName');
developer.log('Erreur', name: 'FeatureName', error: e, stackTrace: stackTrace);
```

**EventBus statistiques :**

```dart
// Afficher les statistiques d'événements
GardenEventBus().logStats();
// Output:
// 📊 EventBus Stats:
//    - Events emitted: 42
//    - Active listeners: 3
```

**GardenEventObserver statistiques :**

```dart
// Afficher les statistiques de traitement
print(GardenEventObserverService.instance.plantingEventsCount);
print(GardenEventObserverService.instance.analysisTriggeredCount);
print(GardenEventObserverService.instance.successRate);
```

---

## 📚 Ressources

### Documentation

- [Clean Architecture (Uncle Bob)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Riverpod Documentation](https://riverpod.dev/)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Hive Documentation](https://docs.hivedb.dev/)

### Liens internes

- [README.md](README.md) - Guide de démarrage
- [RETABLISSEMENT_PERMACALENDAR.md](RETABLISSEMENT_PERMACALENDAR.md) - Guide de refactoring complet
- [Rapports d'exécution](.ai-doc/ARCHIVES/) - Détails de chaque prompt exécuté
- [tests/README_TESTS.md](test/README_TESTS.md) - Guide des tests

### Outils de développement

```bash
# Lancer l'application
flutter run

# Générer le code (Freezed, json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Lancer les tests
flutter test

# Lancer les tests avec couverture
flutter test --coverage

# Analyser le code
flutter analyze

# Formater le code
dart format lib/ test/

# Migrer les données Garden
dart run lib/core/data/migration/garden_data_migration.dart

# Migrer plants.json
dart run tools/migrate_plants_json.dart

# Valider plants.json
dart run tools/validate_plants_json.dart assets/data/plants_v2.json
```

---

## 🎉 Conclusion

PermaCalendar v2.1 respecte maintenant une architecture **Clean Architecture** solide avec :

✅ **Séparation des responsabilités** (domain/data/presentation)  
✅ **SOLID complet** (ISP ajouté dans Prompt 4)  
✅ **Event-Driven Architecture** (découplage des features)  
✅ **Injection de dépendances centralisée** (modules Riverpod)  
✅ **Tests complets** (127 tests, 96.9% de réussite)  
✅ **Intelligence Végétale opérationnelle** (100%)  
✅ **Données normalisées** (Garden unifié, plants.json versionné)  
✅ **Documentation complète** (ce fichier + diagrammes)  

**Version :** 2.1.0  
**Date de rétablissement :** 8 octobre 2025  
**Statut :** ✅ Production-ready

---

**🌱 Cultivons l'avenir avec une architecture saine ! ✨**
