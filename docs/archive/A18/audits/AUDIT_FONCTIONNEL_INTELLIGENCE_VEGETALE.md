# 🌱 AUDIT FONCTIONNEL COMPLET – INTELLIGENCE VÉGÉTALE

**Date de l'audit** : 10 octobre 2025  
**Version analysée** : v2.2  
**Répertoire** : `lib/features/plant_intelligence/`

---

## 📋 Table des matières

1. [Vue d'ensemble du module](#vue-densemble-du-module)
2. [Architecture du module](#architecture-du-module)
3. [Couche Domain](#couche-domain)
   - [Entités](#entités)
   - [Use Cases](#use-cases)
   - [Services Domain](#services-domain)
   - [Interfaces Repositories](#interfaces-repositories)
   - [Modèles](#modèles)
4. [Couche Data](#couche-data)
   - [Repositories](#repositories-implémentation)
   - [DataSources](#datasources)
   - [Services Data](#services-data)
5. [Couche Présentation](#couche-présentation)
   - [Providers](#providers)
   - [Screens](#screens)
   - [Widgets](#widgets)
6. [Fonctionnalités détaillées](#fonctionnalités-détaillées)
7. [Récapitulatif des composants](#récapitulatif-des-composants)

---

## 1. Vue d'ensemble du module

### 🎯 Objectif

Le module **Intelligence Végétale** est le cœur analytique de l'application PermaCalendar. Il fournit une analyse intelligente et contextuelle des conditions de croissance des plantes, génère des recommandations personnalisées et gère les alertes pour optimiser la santé du jardin.

### 🌟 Philosophie

Le module suit le principe du **flux de vérité unidirectionnel** :
```
Sanctuary (Réalité) → Modern System (Filtre) → Intelligence (Analyse) → User (Décision)
```

L'intelligence **OBSERVE** mais ne **MODIFIE JAMAIS** le Sanctuary (les données utilisateur).

### 📊 Statistiques

- **Total de fichiers** : 107 fichiers (102 `.dart`, 5 `.md`)
- **Entités Domain** : 18 entités principales
- **Use Cases** : 5 use cases
- **Écrans** : 10 écrans d'interface
- **Services** : 3 services principaux

---

## 2. Architecture du module

### 🏗️ Structure en Clean Architecture

```
lib/features/plant_intelligence/
├── domain/                      # Logique métier pure
│   ├── entities/               # 18 entités métier
│   ├── usecases/               # 5 cas d'usage
│   ├── services/               # 1 orchestrateur
│   ├── repositories/           # 11 interfaces
│   └── models/                 # 2 modèles
├── data/                        # Implémentation data
│   ├── datasources/            # 5 sources de données
│   ├── repositories/           # 2 implémentations repository
│   └── services/               # 3 services data
└── presentation/                # Interface utilisateur
    ├── providers/              # 4 providers Riverpod
    ├── screens/                # 10 écrans
    └── widgets/                # 9 composants UI
```

### 🔄 Flux de données

1. **UI → Provider** : L'utilisateur interagit avec les écrans
2. **Provider → Orchestrator** : Coordination des use cases
3. **Orchestrator → Use Cases** : Exécution de la logique métier
4. **Use Cases → Repositories** : Accès aux données via interfaces
5. **Repositories → DataSources** : Récupération des données (Hive, API, etc.)

---

## 3. Couche Domain

### 3.1. Entités

#### 🌿 **Entités Principales**

| Entité | Fichier | Description | Clé |
|--------|---------|-------------|-----|
| **PlantAnalysisResult** | `analysis_result.dart` | Résultat d'analyse complète d'une plante | Analyse des 4 conditions (temp, humidité, lumière, sol) |
| **PlantIntelligenceReport** | `intelligence_report.dart` | Rapport complet d'intelligence pour une plante | Combine analyse + recommandations + timing |
| **Recommendation** | `recommendation.dart` | Recommandation d'action pour une plante | 10 types, 4 niveaux de priorité |
| **PlantCondition** | `plant_condition.dart` | Condition unitaire mesurée | 6 types (température, humidité, lumière, sol, vent, eau) |
| **WeatherCondition** | `weather_condition.dart` | Condition météorologique | 9 types (température, humidité, précipitations, etc.) |
| **GardenContext** | `garden_context.dart` | Contexte complet du jardin | Localisation, climat, sol, statistiques, préférences |
| **NotificationAlert** | `notification_alert.dart` | Alerte/notification pour l'utilisateur | 6 types, 4 priorités, 4 statuts |
| **ComprehensiveGardenAnalysis** | `comprehensive_garden_analysis.dart` | Analyse globale du jardin incluant lutte biologique | Reports + menaces + recommandations bio |

#### 🐛 **Entités Lutte Biologique (v2.2)**

| Entité | Fichier | Description |
|--------|---------|-------------|
| **Pest** | `pest.dart` | Ravageur affectant les plantes |
| **BeneficialInsect** | `beneficial_insect.dart` | Insecte auxiliaire bénéfique |
| **PestObservation** | `pest_observation.dart` | Observation utilisateur d'un ravageur (SANCTUARY) |
| **BioControlRecommendation** | `bio_control_recommendation.dart` | Recommandation de lutte biologique (AI) |
| **PestThreat** | `pest_threat_analysis.dart` | Menace ravageur avec analyse |
| **PestThreatAnalysis** | `pest_threat_analysis.dart` | Analyse complète des menaces d'un jardin |

#### 🔧 **Modèles Complémentaires**

| Entité | Fichier | Description |
|--------|---------|-------------|
| **PlantingTimingEvaluation** | `intelligence_report.dart` | Évaluation du timing de plantation |
| **ConditionStatus** | `plant_condition.dart` | Enum : excellent, good, fair, poor, critical |
| **ConditionType** | `plant_condition.dart` | Enum : temperature, humidity, light, soil, wind, water |
| **RecommendationPriority** | `recommendation.dart` | Enum : low, medium, high, critical |
| **RecommendationType** | `recommendation.dart` | Enum : watering, fertilizing, pruning, planting, harvesting, pestControl, etc. |

#### 📦 **Entités Hive (Persistence)**

Toutes les entités principales ont des adaptateurs Hive associés :
- `PlantConditionHive` (TypeId: non spécifié)
- `WeatherConditionHive` (TypeId: non spécifié)
- `NotificationAlertAdapter` (TypeId: 43)
- `PestHive` (TypeId: 50)
- `BeneficialInsectHive` (TypeId: 51)
- `PestObservationHive` (TypeId: 52)
- `BioControlRecommendationHive` (TypeId: 53)

---

### 3.2. Use Cases

#### ✅ **5 Use Cases Principaux**

| Use Case | Fichier | Responsabilité | Entrées | Sorties |
|----------|---------|----------------|---------|---------|
| **AnalyzePlantConditionsUsecase** | `analyze_plant_conditions_usecase.dart` | Analyse les 4 conditions d'une plante (température, humidité, lumière, sol) | PlantFreezed, WeatherCondition, GardenContext | PlantAnalysisResult |
| **EvaluatePlantingTimingUsecase** | `evaluate_planting_timing_usecase.dart` | Évalue si c'est le bon moment pour planter | PlantFreezed, WeatherCondition, GardenContext | PlantingTimingEvaluation |
| **GenerateRecommendationsUsecase** | `generate_recommendations_usecase.dart` | Génère des recommandations intelligentes | PlantFreezed, PlantAnalysisResult, WeatherCondition, GardenContext | List<Recommendation> |
| **AnalyzePestThreatsUsecase** | `analyze_pest_threats_usecase.dart` | Analyse les menaces ravageurs dans un jardin | gardenId | PestThreatAnalysis |
| **GenerateBioControlRecommendationsUsecase** | `generate_bio_control_recommendations_usecase.dart` | Génère des recommandations de lutte biologique | PestObservation | List<BioControlRecommendation> |

#### 🔬 **Détails des Use Cases**

##### 1. **AnalyzePlantConditionsUsecase**

**Responsabilités** :
- Valider les paramètres d'entrée (fraîcheur des données météo < 24h)
- Analyser 4 conditions : température, humidité, lumière, sol
- Calculer l'état de santé global (excellent → critical)
- Calculer le score de santé (0-100)
- Générer warnings, strengths et priority actions
- Estimer la confiance de l'analyse

**Méthodes principales** :
- `execute()` : Point d'entrée principal
- `_createTemperatureCondition()` : Analyse température vs optimum plante
- `_createHumidityCondition()` : Analyse besoins en eau
- `_createLightCondition()` : Analyse exposition soleil
- `_createSoilCondition()` : Analyse qualité du sol
- `_calculateOverallHealth()` : Calcul santé globale
- `_calculateHealthScore()` : Calcul score 0-100
- `_generateWarnings()` : Liste des avertissements
- `_generateStrengths()` : Liste des points forts
- `_generatePriorityActions()` : Actions prioritaires

**Logique métier** :
```dart
// Extraction des besoins réels depuis plants.json
final waterNeeds = plant.waterNeeds.toLowerCase();
final sunExposure = plant.sunExposure.toLowerCase();

// Calcul des plages optimales
if (waterNeeds.contains('élevé')) {
  optimalHumidity = 80.0; minHumidity = 60.0; maxHumidity = 95.0;
}

// Détermination du statut
if (current >= min && current <= max) {
  if (distanceFromOptimal <= 2) return ConditionStatus.excellent;
  if (distanceFromOptimal <= 5) return ConditionStatus.good;
  return ConditionStatus.fair;
}
```

##### 2. **EvaluatePlantingTimingUsecase**

**Responsabilités** :
- Vérifier si période de semis (plant.sowingMonths)
- Vérifier conditions météo actuelles
- Calculer le score de timing (0-100)
- Identifier facteurs favorables et défavorables
- Identifier risques (gel, chaleur, etc.)
- Calculer la date optimale si pas maintenant

**Méthodes principales** :
- `execute()` : Évaluation complète du timing
- `_calculateTimingScore()` : Score basé sur période + conditions
- `_calculateOptimalPlantingDate()` : Calcul prochaine date optimale
- `_generateReason()` : Génération de la raison textuelle

**Logique métier** :
```dart
// Score de base = 50
score += isInSowingPeriod ? 30 : 0;
score += favorableFactors * 10;
score -= unfavorableFactors * 10;
score -= risks * 20;

// Risque de gel
if (weather.value < 5.0 && plant.isFrostSensitive) {
  risks.add('Plante sensible au gel - risque de mort');
}
```

##### 3. **GenerateRecommendationsUsecase**

**Responsabilités** :
- Générer recommandations pour conditions critiques
- Générer recommandations basées sur météo (gel, canicule)
- Générer recommandations saisonnières (semis, récolte)
- Générer recommandations basées sur l'historique (tendances)
- Trier par priorité (critical → low)

**Types de recommandations générées** :
1. **Critiques** : Température/humidité/lumière/sol critiques
2. **Météo** : Risque de gel, canicule
3. **Saisonnières** : Période de semis, période de récolte
4. **Historiques** : Tendances à la baisse/hausse

**Méthodes principales** :
- `execute()` : Génération complète
- `_generateCriticalRecommendations()` : Conditions critiques
- `_generateWeatherRecommendations()` : Alertes météo
- `_generateSeasonalRecommendations()` : Calendrier cultural
- `_generateHistoricalRecommendations()` : Analyse des tendances

##### 4. **AnalyzePestThreatsUsecase**

**Responsabilités** :
- Récupérer observations actives du Sanctuary
- Enrichir avec données ravageurs et plantes
- Calculer le niveau de menace (low → critical)
- Calculer l'impact score (0-100)
- Générer descriptions et conséquences
- Calculer statistiques globales (total, critical, high, etc.)

**Méthodes principales** :
- `execute()` : Analyse complète d'un jardin
- `_calculateThreatLevel()` : Combinaison sévérité observation + sévérité ravageur
- `_calculateImpactScore()` : Score d'impact 0-100
- `_generateThreatDescription()` : Description textuelle
- `_generateConsequences()` : Liste des conséquences potentielles
- `_calculateOverallThreatScore()` : Score global du jardin

**Logique métier** :
```dart
// Combinaison de la sévérité observée et de la sévérité du ravageur
final severityScore = _getSeverityScore(observation.severity);
final pestSeverityScore = _getSeverityScore(pest.defaultSeverity);
final averageScore = (severityScore + pestSeverityScore) / 2;

if (averageScore >= 3.5) return ThreatLevel.critical;
if (averageScore >= 2.5) return ThreatLevel.high;
```

##### 5. **GenerateBioControlRecommendationsUsecase**

**Responsabilités** :
- Générer 4 types de recommandations :
  1. **Introduire auxiliaires** : Coccinelles, chrysopes, etc.
  2. **Planter compagnes** : Plantes répulsives
  3. **Créer habitats** : Bandes fleuries, abris, points d'eau
  4. **Pratiques culturales** : Retrait manuel, rotation, neem

**Méthodes principales** :
- `execute()` : Génération complète pour une observation
- `_generateBeneficialRecommendations()` : Auxiliaires à introduire
- `_generateCompanionPlantRecommendations()` : Plantes répulsives
- `_generateHabitatRecommendations()` : Création d'habitats
- `_generateCulturalPracticeRecommendations()` : Pratiques bio

**Logique métier** :
```dart
// Priorité basée sur la sévérité
switch (severity) {
  case PestSeverity.critical: return 1; // Urgent
  case PestSeverity.high: return 2;
  case PestSeverity.moderate: return 3;
  case PestSeverity.low: return 4;
}

// Timing basé sur la sévérité
switch (severity) {
  case PestSeverity.critical:
  case PestSeverity.high:
    return 'Immédiatement';
  case PestSeverity.moderate:
    return 'Dans les prochains jours';
  case PestSeverity.low:
    return 'Lorsque possible';
}
```

---

### 3.3. Services Domain

#### 🎯 **PlantIntelligenceOrchestrator**

**Fichier** : `plant_intelligence_orchestrator.dart`

**Responsabilités** :
- Coordonner les 5 Use Cases
- Générer des rapports complets `PlantIntelligenceReport`
- Sauvegarder les résultats via repositories
- Calculer métriques globales (score d'intelligence, confiance)
- Générer analyses complètes avec lutte biologique

**Méthodes principales** :

| Méthode | Description | Paramètres | Retour |
|---------|-------------|------------|--------|
| `generateIntelligenceReport()` | Rapport complet pour une plante | plantId, gardenId, plant? | PlantIntelligenceReport |
| `generateGardenIntelligenceReport()` | Rapports pour toutes les plantes d'un jardin | gardenId | List<PlantIntelligenceReport> |
| `analyzePlantConditions()` | Analyse uniquement conditions (rapide) | plantId, gardenId, plant? | PlantAnalysisResult |
| `analyzeGardenWithBioControl()` | Analyse complète incluant lutte biologique | gardenId | ComprehensiveGardenAnalysis |

**Dépendances (5 interfaces ISP - Prompt 4)** :
1. `IPlantConditionRepository` : Historique des conditions
2. `IWeatherRepository` : Conditions météo
3. `IGardenContextRepository` : Contexte jardin et plantes
4. `IRecommendationRepository` : Sauvegarde recommandations
5. `IAnalyticsRepository` : Sauvegarde analyses

**Logique métier** :
```dart
// Calcul du score d'intelligence (0-100)
score = (healthScore * 0.6) + (timingScore * 0.2);
if (criticalRecommendations == 0) score += 20;

// Calcul santé globale jardin (70% plantes + 30% menaces)
final avgPlantHealth = plantReports.avg * 0.7;
final threatPenalty = (critical * 10 + high * 5 + moderate * 2).clamp(0, 30);
final healthScore = avgPlantHealth + ((100 - threatPenalty) * 0.3);
```

---

### 3.4. Interfaces Repositories

#### 📚 **11 Interfaces Repository**

| Interface | Fichier | Responsabilité |
|-----------|---------|----------------|
| **IPlantConditionRepository** | `i_plant_condition_repository.dart` | Gestion des conditions de plantes |
| **IWeatherRepository** | `i_weather_repository.dart` | Gestion des conditions météo |
| **IGardenContextRepository** | `i_garden_context_repository.dart` | Gestion du contexte jardin |
| **IRecommendationRepository** | `i_recommendation_repository.dart` | Gestion des recommandations |
| **IAnalyticsRepository** | `i_analytics_repository.dart` | Gestion des analyses et statistiques |
| **IPlantDataSource** | `i_plant_data_source.dart` | Accès aux données plantes |
| **IPestRepository** | `i_pest_repository.dart` | Gestion des ravageurs (catalog) |
| **IBeneficialInsectRepository** | `i_beneficial_insect_repository.dart` | Gestion des auxiliaires (catalog) |
| **IPestObservationRepository** | `i_pest_observation_repository.dart` | Gestion des observations ravageurs (Sanctuary) |
| **IBioControlRecommendationRepository** | `i_bio_control_recommendation_repository.dart` | Gestion des recommandations bio (AI) |
| **PlantIntelligenceRepository** | `plant_intelligence_repository.dart` | Interface globale (DÉPRÉCIÉ - v2.1) |

**Note ISP (Interface Segregation Principle)** :
Le module a été refactoré (Prompt 4) pour suivre ISP. L'interface monolithique `PlantIntelligenceRepository` a été remplacée par 5 interfaces spécialisées.

---

### 3.5. Modèles

| Modèle | Fichier | Description |
|--------|---------|-------------|
| **PlantFreezed** | `plant_freezed.dart` | Extension Freezed pour PlantEntity |
| **PlantHealthStatus** | `plant_health_status.dart` | Énumération des états de santé |

---

## 4. Couche Data

### 4.1. Repositories (Implémentation)

#### 📦 **2 Implémentations Repository**

| Repository | Fichier | Implémente | Description |
|------------|---------|------------|-------------|
| **PlantIntelligenceRepositoryImpl** | `plant_intelligence_repository_impl.dart` | PlantIntelligenceRepository + 5 interfaces ISP | Implémentation complète de toutes les interfaces |
| **BiologicalControlRepositoryImpl** | `biological_control_repository_impl.dart` | IBioControlRecommendationRepository | Gestion lutte biologique |

**PlantIntelligenceRepositoryImpl - Méthodes clés** :
- Conditions plantes : `savePlantCondition()`, `getCurrentPlantCondition()`, `getPlantConditionHistory()`
- Météo : `saveWeatherCondition()`, `getCurrentWeatherCondition()`, `getWeatherHistory()`
- Contexte jardin : `saveGardenContext()`, `getGardenContext()`, `getUserGardens()`
- Recommandations : `saveRecommendation()`, `getActiveRecommendations()`, `getRecommendationsByPriority()`
- Analytics : `saveAnalysisResult()`, `getActiveAlerts()`, `getPlantHealthStats()`, `getGardenPerformanceMetrics()`

---

### 4.2. DataSources

#### 🗃️ **5 DataSources**

| DataSource | Fichier | Responsabilité | Technologie |
|------------|---------|----------------|-------------|
| **PlantIntelligenceLocalDataSource** | `plant_intelligence_local_datasource.dart` | Stockage local des données d'intelligence | Hive |
| **PlantIntelligenceRemoteDataSource** | `plant_intelligence_remote_datasource.dart` | API distante (future) | HTTP |
| **PlantDataSourceImpl** | `plant_datasource_impl.dart` | Accès aux données plantes (plants.json) | JSON |
| **BiologicalControlDataSource** | `biological_control_datasource.dart` | Accès aux catalogues ravageurs/auxiliaires | JSON + Hive |
| **WeatherDataSource** | `weather_datasource.dart` | Accès aux données météo | API externe |

**PlantIntelligenceLocalDataSource - Boxes Hive** :
- `plant_conditions` : PlantCondition
- `weather_conditions` : WeatherCondition
- `garden_contexts` : GardenContext
- `recommendations` : Recommendation
- `notifications` : NotificationAlert
- `analytics` : Map<String, dynamic>

**BiologicalControlDataSource - Sources** :
- `assets/data/biological_control/pests.json` : Catalogue ravageurs
- `assets/data/biological_control/beneficial_insects.json` : Catalogue auxiliaires
- Boxes Hive : `pests`, `beneficial_insects`, `pest_observations`, `bio_control_recommendations`

---

### 4.3. Services Data

#### ⚙️ **3 Services Data**

| Service | Fichier | Responsabilité |
|---------|---------|----------------|
| **PlantNotificationService** | `plant_notification_service.dart` | Gestion des notifications d'intelligence |
| **FlutterNotificationService** | `flutter_notification_service.dart` | Notifications système Flutter |
| **NotificationInitialization** | `notification_initialization.dart` | Initialisation du système de notifications |

**PlantNotificationService - Fonctionnalités** :
- Création de notifications (6 types)
- Gestion des préférences utilisateur
- Filtrage par type, priorité, plante, jardin
- Marquer comme lu/archivé/ignoré
- Nettoyage automatique des anciennes notifications
- Streams en temps réel (notifications, unread count)
- Génération automatique d'alertes :
  - Alertes météo (gel, chaleur, sécheresse, vent)
  - Alertes conditions optimales
  - Alertes conditions critiques
  - Alertes recommandations urgentes

**Préférences par défaut** :
```dart
{
  'enabled': true,
  'types': {
    'weatherAlert': true,
    'plantCondition': true,
    'recommendation': true,
    'reminder': true,
    'criticalCondition': true,
    'optimalCondition': false, // Désactivé par défaut
  },
  'priorities': {
    'low': false,
    'medium': true,
    'high': true,
    'critical': true,
  },
  'quietHoursEnabled': false,
  'soundEnabled': true,
  'vibrationEnabled': true,
}
```

---

## 5. Couche Présentation

### 5.1. Providers

#### 🔌 **4 Providers Riverpod**

| Provider | Fichier | Responsabilité |
|----------|---------|----------------|
| **plant_intelligence_providers** | `plant_intelligence_providers.dart` | Providers principaux d'intelligence |
| **intelligence_state_providers** | `intelligence_state_providers.dart` | État de l'intelligence (IntelligenceState) |
| **notification_providers** | `notification_providers.dart` | Providers de notifications |
| **plant_intelligence_ui_providers** | `plant_intelligence_ui_providers.dart` | Providers UI spécifiques |

**plant_intelligence_providers - Providers clés** :
- `plantIntelligenceOrchestratorProvider` : Orchestrateur principal
- `generateIntelligenceReportProvider` : Génération rapport complet
- `generateGardenIntelligenceReportProvider` : Rapport jardin complet
- `analyzePlantConditionsOnlyProvider` : Analyse rapide
- `plantConditionProvider` : Conditions d'une plante
- `plantRecommendationsProvider` : Recommandations actives
- `currentWeatherProvider` : Météo actuelle
- `gardenContextProvider` : Contexte jardin

**intelligence_state_providers - État géré** :
```dart
class IntelligenceState {
  final bool isInitialized;
  final bool isAnalyzing;
  final String? currentGardenId;
  final GardenContext? currentGarden;
  final List<String> activePlantIds;
  final Map<String, PlantCondition> plantConditions;
  final Map<String, List<Recommendation>> plantRecommendations;
  final DateTime? lastAnalysis;
  final String? error;
}
```

**notification_providers - Providers clés** :
- `intelligentAlertsProvider` : État des alertes intelligentes
- `contextualRecommendationsProvider` : Recommandations contextuelles
- `unreadNotificationCountProvider` : Compteur de non-lus
- `notificationStreamProvider` : Stream des nouvelles notifications

---

### 5.2. Screens

#### 🖥️ **10 Écrans**

| Écran | Fichier | Description | Route |
|-------|---------|-------------|-------|
| **PlantIntelligenceDashboardScreen** | `plant_intelligence_dashboard_screen.dart` | Tableau de bord principal | `/intelligence` |
| **PlantIntelligenceDashboardSimple** | `plant_intelligence_dashboard_simple.dart` | Version simplifiée du dashboard | - |
| **RecommendationsScreen** | `recommendations_screen.dart` | Liste complète des recommandations | `/recommendations` |
| **RecommendationsSimple** | `recommendations_simple.dart` | Version simplifiée des recommandations | - |
| **NotificationsScreen** | `notifications_screen.dart` | Liste des notifications | `/notifications` |
| **IntelligenceSettingsScreen** | `intelligence_settings_screen.dart` | Paramètres d'intelligence végétale | `/intelligence-settings` |
| **IntelligenceSettingsSimple** | `intelligence_settings_simple.dart` | Version simplifiée des paramètres | - |
| **NotificationPreferencesScreen** | `notification_preferences_screen.dart` | Préférences de notifications | `/notification-preferences` |
| **PestObservationScreen** | `pest_observation_screen.dart` | Signalement d'un ravageur | `/pest-observation` |
| **BioControlRecommendationsScreen** | `bio_control_recommendations_screen.dart` | Recommandations de lutte biologique | `/bio-control` |

**PlantIntelligenceDashboardScreen - Sections** :
1. **En-tête** : Titre + dernière analyse
2. **Statistiques rapides** : 4 cartes (plantes, recommandations, alertes, score moyen)
3. **Alertes** : Liste des alertes actives (max 3 affichées)
4. **Actions rapides** : Boutons "Signaler un ravageur" et "Lutte biologique"
5. **Recommandations** : Liste des recommandations (max 3 affichées)
6. **FAB** : Bouton "Analyser" pour analyser toutes les plantes

---

### 5.3. Widgets

#### 🧩 **9 Widgets Réutilisables**

**Cards** :
- `AlertBanner` (`cards/alert_banner.dart`) : Bannière d'alerte colorée
- `RecommendationCard` (`cards/recommendation_card.dart`) : Carte de recommandation avec actions

**Charts** :
- `ConditionRadarChartSimple` (`charts/condition_radar_chart_simple.dart`) : Graphique radar des conditions

**Indicators** :
- `ConditionIndicator` (`indicators/condition_indicator.dart`) : Indicateur de condition (jauge)
- `OptimalTimingWidget` (`indicators/optimal_timing_widget.dart`) : Indicateur de timing optimal
- `PlantHealthIndicator` (`indicators/plant_health_indicator.dart`) : Indicateur de santé (score + couleur)

**Summaries** :
- `GardenOverviewWidget` (`summaries/garden_overview_widget.dart`) : Vue d'ensemble du jardin
- `IntelligenceSummary` (`summaries/intelligence_summary.dart`) : Résumé d'intelligence

**Lists** :
- `NotificationListWidget` (`notification_list_widget.dart`) : Liste de notifications avec filtrage

---

## 6. Fonctionnalités détaillées

### 🌡️ **Analyse des Conditions**

**4 Conditions analysées** :
1. **Température** : Comparaison avec température optimale de germination/croissance
2. **Humidité** : Basée sur les besoins en eau de la plante (élevé/moyen/faible)
3. **Luminosité** : Basée sur l'exposition requise (plein soleil/mi-ombre/ombre)
4. **Sol** : Qualité du sol basée sur le type (limoneux/argileux/sableux/etc.)

**Statuts possibles** :
- `excellent` : Conditions parfaites
- `good` : Bonnes conditions
- `fair` : Conditions acceptables
- `poor` : Conditions médiocres
- `critical` : Conditions critiques nécessitant action immédiate

**Score de santé** :
- 0-20 : Critique
- 20-40 : Mauvais
- 40-60 : Correct
- 60-80 : Bon
- 80-100 : Excellent

---

### 💡 **Génération de Recommandations**

**Types de recommandations** :
1. `watering` : Arrosage
2. `fertilizing` : Fertilisation
3. `pruning` : Taille
4. `planting` : Plantation
5. `harvesting` : Récolte
6. `pestControl` : Lutte contre ravageurs
7. `diseaseControl` : Lutte contre maladies
8. `soilImprovement` : Amélioration du sol
9. `weatherProtection` : Protection météo
10. `general` : Général

**Priorités** :
- `critical` : Action immédiate (< 24h)
- `high` : Haute priorité (< 7 jours)
- `medium` : Priorité moyenne (< 30 jours)
- `low` : Faible priorité (> 30 jours)

**Statuts** :
- `pending` : En attente
- `inProgress` : En cours
- `completed` : Terminée
- `dismissed` : Ignorée
- `expired` : Expirée

---

### 🐛 **Lutte Biologique (v2.2)**

**Flux de données** :
```
User observe un ravageur
    ↓
PestObservation créée (SANCTUARY)
    ↓
AnalyzePestThreatsUsecase lit les observations
    ↓
PestThreatAnalysis généré (menaces + statistiques)
    ↓
GenerateBioControlRecommendationsUsecase analyse
    ↓
4 types de recommandations bio générées
    ↓
User applique les recommandations
```

**4 Types de recommandations bio** :
1. **introduceBeneficial** : Introduire des auxiliaires (coccinelles, chrysopes, etc.)
2. **plantCompanion** : Planter des plantes répulsives (œillet d'Inde, basilic, etc.)
3. **createHabitat** : Créer des habitats favorables (bandes fleuries, hôtels à insectes, points d'eau)
4. **culturalPractice** : Pratiques culturales (retrait manuel, rotation, huile de neem)

**Catalogues** :
- **Pests** (ravageurs) : Pucerons, chenilles, limaces, etc. avec :
  - Plantes affectées
  - Symptômes
  - Prédateurs naturels
  - Plantes répulsives
- **Beneficial Insects** (auxiliaires) : Coccinelles, chrysopes, syrphes, etc. avec :
  - Proies
  - Fleurs attractives
  - Besoins d'habitat
  - Cycle de vie
  - Efficacité (0-100)

---

### 🔔 **Système de Notifications**

**6 Types de notifications** :
1. `weatherAlert` : Alertes météo (gel, chaleur, sécheresse, vent)
2. `plantCondition` : Conditions de plante
3. `recommendation` : Recommandations
4. `reminder` : Rappels
5. `criticalCondition` : Conditions critiques
6. `optimalCondition` : Conditions optimales

**4 Priorités** :
1. `critical` : Critique (rouge)
2. `high` : Élevée (orange)
3. `medium` : Moyenne (jaune)
4. `low` : Faible (vert)

**4 Statuts** :
1. `unread` : Non lue
2. `read` : Lue
3. `archived` : Archivée
4. `dismissed` : Ignorée

**Génération automatique** :
- **Alerte gel** : Température < 0°C et plante sensible au gel
- **Alerte chaleur** : Température > 35°C
- **Alerte sécheresse** : Humidité < 30% et précipitations < 1mm
- **Alerte vent** : Vitesse du vent > 50 km/h
- **Alerte condition critique** : overallStatus == critical ou poor
- **Alerte condition optimale** : overallStatus == optimal

---

### 📊 **Analytics et Métriques**

**Statistiques disponibles** :
- **Par plante** :
  - Score de santé moyen (30 derniers jours)
  - Tendances des conditions (température, humidité, lumière, sol)
  - Nombre de recommandations générées
  - Nombre d'alertes critiques
  - Taux de complétion des recommandations

- **Par jardin** :
  - Score de santé global
  - Nombre de plantes analysées
  - Nombre total de recommandations
  - Nombre d'alertes actives
  - Performance vs objectifs
  - Rendement par m²
  - Rentabilité (€/m²)

**Métriques calculées** :
- **Intelligence Score** (0-100) :
  - 60% : Score de santé de l'analyse
  - 20% : Score du timing de plantation
  - 20% : Bonus basé sur le nombre de recommandations critiques

- **Confiance** (0-1) :
  - Basé sur la fraîcheur des données météo
  - < 1h : 0.95
  - < 6h : 0.85
  - < 12h : 0.75
  - < 24h : 0.65
  - > 24h : 0.50

- **Overall Garden Health** (0-100) :
  - 70% : Score moyen de santé des plantes
  - 30% : Impact des menaces ravageurs
  - Pénalité : critical * 10 + high * 5 + moderate * 2 + low * 0.5 (max 30)

---

## 7. Récapitulatif des composants

### 📦 **Statistiques complètes**

| Catégorie | Nombre | Détails |
|-----------|--------|---------|
| **Entités Domain** | 18 | PlantAnalysisResult, PlantIntelligenceReport, Recommendation, PlantCondition, WeatherCondition, GardenContext, NotificationAlert, ComprehensiveGardenAnalysis, Pest, BeneficialInsect, PestObservation, BioControlRecommendation, PestThreat, PestThreatAnalysis, PlantingTimingEvaluation, + 3 modèles |
| **Use Cases** | 5 | AnalyzePlantConditions, EvaluatePlantingTiming, GenerateRecommendations, AnalyzePestThreats, GenerateBioControlRecommendations |
| **Services Domain** | 1 | PlantIntelligenceOrchestrator |
| **Interfaces Repository** | 11 | IPlantCondition, IWeather, IGardenContext, IRecommendation, IAnalytics, IPlantDataSource, IPest, IBeneficialInsect, IPestObservation, IBioControlRecommendation, PlantIntelligence (déprécié) |
| **Implémentations Repository** | 2 | PlantIntelligenceRepositoryImpl, BiologicalControlRepositoryImpl |
| **DataSources** | 5 | PlantIntelligenceLocal, PlantIntelligenceRemote, PlantData, BiologicalControl, Weather |
| **Services Data** | 3 | PlantNotification, FlutterNotification, NotificationInitialization |
| **Providers** | 4 | plant_intelligence, intelligence_state, notification, ui |
| **Screens** | 10 | Dashboard, Recommendations, Notifications, Settings, PestObservation, BioControl, + versions simples |
| **Widgets** | 9 | AlertBanner, RecommendationCard, ConditionRadarChart, ConditionIndicator, OptimalTimingWidget, PlantHealthIndicator, GardenOverviewWidget, IntelligenceSummary, NotificationListWidget |
| **Fichiers Markdown** | 5 | DEPLOYMENT_GUIDE.md, INTEGRATION_GUIDE.md, NOTIFICATION_SYSTEM_README.md, PERFORMANCE_REPORT.md, QUICK_START.md |

---

### 🔄 **Dépendances externes**

**Packages utilisés** :
- `freezed` : Génération de classes immutables
- `freezed_annotation` : Annotations Freezed
- `hive` : Base de données locale
- `hive_flutter` : Intégration Hive avec Flutter
- `uuid` : Génération d'identifiants uniques
- `flutter_riverpod` : Gestion d'état
- `go_router` : Navigation
- `flutter_local_notifications` : Notifications système

**Assets requis** :
- `assets/data/plants_v2.json` : Catalogue des plantes
- `assets/data/biological_control/pests.json` : Catalogue des ravageurs
- `assets/data/biological_control/beneficial_insects.json` : Catalogue des auxiliaires

---

### 🏛️ **Principes architecturaux**

1. **Clean Architecture** : Séparation stricte domain/data/presentation
2. **ISP (Interface Segregation Principle)** : 5 interfaces spécialisées au lieu d'une monolithique
3. **DRY (Don't Repeat Yourself)** : Réutilisation maximale des composants
4. **Single Responsibility** : Chaque classe a une seule responsabilité
5. **Dependency Inversion** : Dépendance sur abstractions, pas sur implémentations
6. **Immutabilité** : Utilisation de Freezed pour classes immutables
7. **Reactive Programming** : Streams et Riverpod pour réactivité
8. **Repository Pattern** : Abstraction de la source de données
9. **Use Case Pattern** : Logique métier encapsulée dans des use cases
10. **Orchestrator Pattern** : Coordination des use cases via orchestrateur

---

### 🎯 **Points forts du module**

✅ **Architecture solide** : Clean Architecture bien respectée  
✅ **Séparation des responsabilités** : Domain/Data/Presentation clairs  
✅ **Testabilité** : Interfaces permettant facilement le mocking  
✅ **Réutilisabilité** : Composants modulaires et réutilisables  
✅ **Extensibilité** : Facile d'ajouter de nouveaux use cases ou entités  
✅ **Documentation** : Code bien documenté avec commentaires et markdown  
✅ **Performance** : Utilisation de Hive pour stockage local rapide  
✅ **Réactivité** : Streams et Riverpod pour UI réactive  
✅ **Lutte biologique** : Intégration complète de la gestion des ravageurs  
✅ **Notifications** : Système robuste avec préférences utilisateur  

---

### 🚀 **Fonctionnalités visibles à l'écran**

1. **Dashboard Intelligence** :
   - Vue d'ensemble avec statistiques
   - Alertes en temps réel
   - Actions rapides (signalement ravageurs, lutte bio)
   - Recommandations prioritaires
   - Bouton "Analyser" pour analyse complète

2. **Recommandations** :
   - Liste filtrée par priorité/type
   - Détails des recommandations
   - Marquer comme complété/ignoré
   - Instructions détaillées
   - Outils/ressources nécessaires

3. **Notifications** :
   - Liste des notifications avec filtres
   - Badge de compteur non-lus
   - Marquer comme lu/archivé/ignoré
   - Détails de notification
   - Préférences personnalisables

4. **Lutte biologique** :
   - Signalement de ravageurs (formulaire)
   - Vue des menaces actives
   - Recommandations bio personnalisées
   - Informations sur auxiliaires
   - Catalogues pests/beneficial insects

5. **Paramètres** :
   - Activation/désactivation par type
   - Activation/désactivation par priorité
   - Heures silencieuses
   - Sons et vibrations

---

### 🔮 **Fonctionnalités non visibles (Backend)**

1. **Analyse automatique** :
   - Calcul des conditions optimales
   - Détection de seuils critiques
   - Génération proactive de recommandations
   - Analyse des tendances historiques

2. **Sauvegarde persistante** :
   - Historique des conditions (Hive)
   - Historique des recommandations (Hive)
   - Historique des analyses (Hive)
   - Sauvegarde des préférences (Hive)

3. **Calculs complexes** :
   - Scores de santé (0-100)
   - Scores d'intelligence (0-100)
   - Confiance des analyses (0-1)
   - Impact des menaces ravageurs
   - Timing optimal de plantation

4. **Orchestration** :
   - Coordination de 5 use cases
   - Gestion des dépendances entre analyses
   - Cache et optimisation
   - Gestion d'erreurs robuste

5. **Enrichissement de données** :
   - Croisement plantes.json + météo + jardin
   - Enrichissement observations avec catalogues
   - Calcul de métriques dérivées
   - Génération de descriptions textuelles

---

## 📖 Documentation complémentaire

Le module contient 5 fichiers Markdown de documentation :

1. **DEPLOYMENT_GUIDE.md** : Guide de déploiement
2. **INTEGRATION_GUIDE.md** : Guide d'intégration avec autres modules
3. **NOTIFICATION_SYSTEM_README.md** : Documentation système de notifications
4. **PERFORMANCE_REPORT.md** : Rapport de performance
5. **QUICK_START.md** : Guide de démarrage rapide

---

## 🎓 Conclusion

Le module **Intelligence Végétale** est un système complet et robuste qui fournit une analyse intelligente du jardin de l'utilisateur. Il combine :

- **Analyse des conditions** : Température, humidité, lumière, sol
- **Évaluation du timing** : Quand planter ?
- **Recommandations** : Que faire ?
- **Lutte biologique** : Comment gérer les ravageurs naturellement ?
- **Notifications** : Alertes proactives
- **Analytics** : Métriques et statistiques

L'architecture Clean Architecture garantit la maintenabilité, la testabilité et l'extensibilité du module, tout en respectant les principes SOLID.

---

**Fin de l'audit fonctionnel**

**Généré le** : 10 octobre 2025  
**Par** : Assistant AI Claude Sonnet 4.5  
**Module** : `lib/features/plant_intelligence/`  
**Version** : v2.2

