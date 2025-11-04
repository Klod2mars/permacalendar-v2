# 📊 Tableau de Cartographie Exhaustive – Intelligence Végétale

**Date:** 10 octobre 2025  
**Module:** `lib/features/plant_intelligence/`

Ce tableau liste **tous** les composants du module avec leur état d'utilisation et rôle fonctionnel.

---

## Légende des statuts

| Icône | Statut | Description |
|-------|--------|-------------|
| 🟢 | **Utilisé** | Activement utilisé dans l'application |
| 🟡 | **Partiellement intégré** | Code fonctionnel mais pas complètement exposé en UI |
| 🔴 | **Non utilisé / Dormant** | Code existant mais non intégré |
| 🔵 | **Infrastructure** | Code support (cache, logging, etc.) |
| ⚠️ | **Déprécié** | Marqué deprecated dans le code |

---

## 📦 Domain Layer

### UseCases (5 fichiers)

| # | Nom du composant | Fichier | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|---------|------|--------|------------------|-------------|
| 1 | `AnalyzePlantConditionsUsecase` | `analyze_plant_conditions_usecase.dart` | UseCase | 🟢 Utilisé | Analyse 4 conditions (température, humidité, luminosité, sol) et calcule score de santé (0-100) | 596 lignes, 9 méthodes privées, validation stricte |
| 2 | `EvaluatePlantingTimingUsecase` | `evaluate_planting_timing_usecase.dart` | UseCase | 🟢 Utilisé | Évalue si c'est le moment optimal pour planter une espèce donnée | Vérifie période semis, météo, risques (gel) |
| 3 | `GenerateRecommendationsUsecase` | `generate_recommendations_usecase.dart` | UseCase | 🟢 Utilisé | Génère recommandations intelligentes (critiques, météo, saisonnières, historiques) | 372 lignes, 4 types de recommandations |
| 4 | `AnalyzePestThreatsUsecase` | `analyze_pest_threats_usecase.dart` | UseCase | 🟢 Utilisé | Analyse menaces ravageurs à partir des observations utilisateur | Enrichit observations avec catalogue, calcule threatLevel |
| 5 | `GenerateBioControlRecommendationsUsecase` | `generate_bio_control_recommendations_usecase.dart` | UseCase | 🟢 Utilisé | Génère recommandations de lutte biologique (4 stratégies) | Insectes bénéfiques, plantes compagnes, habitats, pratiques |

### Services (1 fichier)

| # | Nom du composant | Fichier | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|---------|------|--------|------------------|-------------|
| 6 | `PlantIntelligenceOrchestrator` | `plant_intelligence_orchestrator.dart` | Orchestrator | 🟢 Utilisé | Coordonne les 5 UseCases et génère rapports complets | 713 lignes, 4 méthodes publiques, 12 privées |

### Entités (18+ fichiers)

| # | Nom du composant | Fichier | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|---------|------|--------|------------------|-------------|
| 7 | `PlantAnalysisResult` | `analysis_result.dart` | Entity | 🟢 Utilisé | Résultat complet d'analyse d'une plante | Freezed + .freezed.dart + .g.dart |
| 8 | `PlantCondition` | `plant_condition.dart` | Entity | 🟢 Utilisé | État d'une condition spécifique (temp/humidité/etc) | Freezed + Hive adapter |
| 9 | `WeatherCondition` | `weather_condition.dart` | Entity | 🟢 Utilisé | Conditions météorologiques mesurées | Freezed + Hive adapter |
| 10 | `GardenContext` | `garden_context.dart` | Entity | 🟢 Utilisé | Contexte complet d'un jardin (localisation, climat, sol, plantes) | Freezed + Hive adapter |
| 11 | `Recommendation` | `recommendation.dart` | Entity | 🟢 Utilisé | Recommandation actionnable avec priorité, deadline, coût | Freezed + Hive adapter |
| 12 | `PlantIntelligenceReport` | `intelligence_report.dart` | Entity | 🟢 Utilisé | Rapport complet intelligence d'une plante | Contient analyse, recs, timing, alertes, score |
| 13 | `NotificationAlert` | `notification_alert.dart` | Entity | 🟢 Utilisé | Notification/alerte pour l'utilisateur | Freezed + Hive adapter |
| 14 | `Pest` | `pest.dart` | Entity | 🟢 Utilisé | Ravageur (catalogue read-only) | Freezed, chargé depuis JSON |
| 15 | `PestObservation` | `pest_observation.dart` | Entity | 🟢 Utilisé | Observation de ravageur par l'utilisateur (Sanctuary) | Freezed + Hive adapter |
| 16 | `BeneficialInsect` | `beneficial_insect.dart` | Entity | 🟢 Utilisé | Insecte bénéfique (catalogue read-only) | Freezed, chargé depuis JSON |
| 17 | `BioControlRecommendation` | `bio_control_recommendation.dart` | Entity | 🟢 Utilisé | Recommandation de lutte biologique | Freezed + Hive adapter |
| 18 | `PestThreatAnalysis` | `pest_threat_analysis.dart` | Entity | 🟢 Utilisé | Analyse complète des menaces ravageurs d'un jardin | Freezed (partial) |
| 19 | `ComprehensiveGardenAnalysis` | `comprehensive_garden_analysis.dart` | Entity | 🟢 Utilisé | Analyse complète jardin (plantes + ravageurs + biocontrôle) | Freezed + .freezed.dart + .g.dart |
| 20-25 | Enums & Models | `condition_enums.dart`, `condition_models.dart`, `plant_health_status.dart`, `plant_freezed.dart` | Models | 🟢 Utilisé | Enums support et modèles | Enums: ConditionType, ConditionStatus, etc. |

### Repositories Interfaces (10 fichiers)

| # | Nom du composant | Fichier | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|---------|------|--------|------------------|-------------|
| 26 | `IPlantConditionRepository` | `i_plant_condition_repository.dart` | Interface | 🟢 Utilisé | CRUD conditions de plantes | 5 méthodes |
| 27 | `IWeatherRepository` | `i_weather_repository.dart` | Interface | 🟢 Utilisé | Gestion données météo | 3 méthodes |
| 28 | `IGardenContextRepository` | `i_garden_context_repository.dart` | Interface | 🟢 Utilisé | Gestion contexte jardin + plantes | 5 méthodes |
| 29 | `IRecommendationRepository` | `i_recommendation_repository.dart` | Interface | 🟢 Utilisé | CRUD recommandations | 6 méthodes |
| 30 | `IAnalyticsRepository` | `i_analytics_repository.dart` | Interface | 🟢 Utilisé | Analyses, alertes, statistiques | 10 méthodes |
| 31 | `IPestRepository` | `i_pest_repository.dart` | Interface | 🟢 Utilisé | Catalogue ravageurs (read-only) | 5 méthodes |
| 32 | `IBeneficialInsectRepository` | `i_beneficial_insect_repository.dart` | Interface | 🟢 Utilisé | Catalogue insectes bénéfiques (read-only) | 5 méthodes |
| 33 | `IPestObservationRepository` | `i_pest_observation_repository.dart` | Interface | 🟢 Utilisé | CRUD observations ravageurs (Sanctuary) | 8 méthodes |
| 34 | `IBioControlRecommendationRepository` | `i_bio_control_recommendation_repository.dart` | Interface | 🟢 Utilisé | CRUD recommandations biocontrôle | 7 méthodes |
| 35 | `PlantIntelligenceRepository` | `plant_intelligence_repository.dart` | Interface | ⚠️ Déprécié | Interface globale legacy | Remplacé par interfaces spécialisées (ISP) |
| 36 | `IPlantDataSource` | `i_plant_data_source.dart` | Interface | 🟢 Utilisé | Accès catalogue plantes | Interface datasource |

---

## 💾 Data Layer

### Repositories Implémentation (2 fichiers)

| # | Nom du composant | Fichier | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|---------|------|--------|------------------|-------------|
| 37 | `PlantIntelligenceRepositoryImpl` | `plant_intelligence_repository_impl.dart` | Repository | 🟢 Utilisé | Implémente 5 interfaces + legacy | 1452 lignes, cache 30min, météo hybride |
| 38 | `BiologicalControlRepositoryImpl` | `biological_control_repository_impl.dart` | Repository | 🟢 Utilisé | Implémente 4 interfaces biocontrôle | 357 lignes, catalogues + observations + recs |

### DataSources (5 fichiers)

| # | Nom du composant | Fichier | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|---------|------|--------|------------------|-------------|
| 39 | `PlantIntelligenceLocalDataSource` | `plant_intelligence_local_datasource.dart` | DataSource | 🟢 Utilisé | Persistance Hive (13+ boxes) | 40+ méthodes CRUD, stats, export/import |
| 40 | `PlantIntelligenceRemoteDataSource` | `plant_intelligence_remote_datasource.dart` | DataSource | 🔴 Non implémenté | API distante (future) | Interface uniquement |
| 41 | `WeatherDataSource` | `weather_datasource.dart` | DataSource | 🟢 Utilisé | Données météo via OpenMeteo | Actuelle + historique 14j |
| 42 | `BiologicalControlDataSource` | `biological_control_datasource.dart` | DataSource | 🟢 Utilisé | Chargement JSON catalogues + CRUD Hive | 2 catalogues + 2 boxes |
| 43 | `PlantDataSourceImpl` | `plant_datasource_impl.dart` | DataSource | 🟢 Utilisé | Accès catalogue plantes | Via Hive |

### Services (3 fichiers)

| # | Nom du composant | Fichier | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|---------|------|--------|------------------|-------------|
| 44 | `PlantNotificationService` | `plant_notification_service.dart` | Service | 🟢 Utilisé | Gestion notifications + streams temps réel | 938 lignes, singleton, 2 boxes Hive, 20+ méthodes |
| 45 | `FlutterNotificationService` | `flutter_notification_service.dart` | Service | 🟢 Utilisé | Notifications système Flutter | ~200 lignes |
| 46 | `NotificationInitialization` | `notification_initialization.dart` | Service | 🟢 Utilisé | Initialisation service notifications | ~50 lignes |

---

## 🎨 Presentation Layer

### Providers (4 fichiers, 50+ providers)

#### plant_intelligence_providers.dart (30+ providers)

| # | Nom du composant | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|------|--------|------------------|-------------|
| 47 | `plantIntelligenceOrchestratorProvider` | Provider | 🟢 Utilisé | Fournit Orchestrator | Déprécié, utiliser module DI |
| 48 | `analyzePlantConditionsUsecaseProvider` | Provider | 🟢 Utilisé | Fournit UseCase analyse | Déprécié, utiliser module DI |
| 49 | `evaluatePlantingTimingUsecaseProvider` | Provider | 🟢 Utilisé | Fournit UseCase timing | Déprécié, utiliser module DI |
| 50 | `generateRecommendationsUsecaseProvider` | Provider | 🟢 Utilisé | Fournit UseCase recommandations | Déprécié, utiliser module DI |
| 51 | `generateIntelligenceReportProvider` | FutureProvider.family | 🟢 Utilisé | Génère rapport complet plante | Utilisé par Dashboard |
| 52 | `generateGardenIntelligenceReportProvider` | FutureProvider.family | 🟢 Utilisé | Génère rapports toutes plantes jardin | Action "Analyser jardin" |
| 53 | `analyzePlantConditionsOnlyProvider` | FutureProvider.family | 🟡 Partiellement | Analyse rapide sans rapport | Utilisé occasionnellement |
| 54 | `generateComprehensiveGardenAnalysisProvider` | FutureProvider.family | 🟡 Partiellement | Analyse complète jardin + biocontrôle | Provider créé, UI incomplète |
| 55 | `analyzePlantProvider` | FutureProvider.family | 🟢 Utilisé | Analyse plante (simplifié) | Utilisé par widgets |
| 56 | `generatePlantRecommendationsProvider` | FutureProvider.family | 🟢 Utilisé | Génère recommandations plante | Utilisé par écran recommandations |
| 57 | `evaluatePlantingTimingProvider` | FutureProvider.family | 🟢 Utilisé | Évalue timing plantation | Utilisé par Dashboard section timing |
| 58-77 | Providers données | Provider/FutureProvider | 🟢 Utilisé | Conditions, historique, météo, contexte, alertes, stats, etc. | 20 providers données diverses |
| 78-79 | Providers notifications | StateNotifierProvider | 🟢 Utilisé | Alertes et recommandations notifiers | Gestion état notifications |
| 80-81 | Providers configuration | Provider/StateNotifierProvider | 🟢 Utilisé | Config repository, paramètres app | Configuration système |

#### intelligence_state_providers.dart (10 providers)

| # | Nom du composant | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|------|--------|------------------|-------------|
| 82 | `intelligenceStateProvider` | StateNotifierProvider | 🟢 Utilisé | État global intelligence | Initialisation, jardin actif, plantes |
| 83 | `realTimeAnalysisProvider` | StateNotifierProvider | 🟡 Non activé | Analyses temps réel (5min) | Code prêt, pas d'UI toggle |
| 84 | `intelligentAlertsProvider` | StateNotifierProvider | 🟡 Partiellement | Gestion alertes intelligentes | Utilisé partiellement |
| 85 | `contextualRecommendationsProvider` | StateNotifierProvider | 🟡 Partiellement | Recommandations contextuelles | Utilisé partiellement |
| 86 | `forecastProvider` | StateNotifierProvider | 🔴 Non implémenté | Prévisions météo + plantes | Structure définie, logique absente |
| 87-91 | Classes état | Classes | 🟢 Utilisé | IntelligenceState, RealTimeAnalysisState, etc. | 5 classes état + notifiers |

#### notification_providers.dart (20+ providers)

| # | Nom du composant | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|------|--------|------------------|-------------|
| 92 | `plantNotificationServiceProvider` | Provider | 🟢 Utilisé | Fournit service notifications | Singleton |
| 93 | `notificationStreamProvider` | StreamProvider | 🟢 Utilisé | Stream notifications temps réel | Broadcast |
| 94 | `unreadNotificationCountStreamProvider` | StreamProvider | 🟢 Utilisé | Stream compteur non lues | Temps réel |
| 95-104 | Providers données notifications | FutureProvider | 🟢 Utilisé | All, active, unread, by priority, by type, for plant, etc. | 10 providers |
| 105-106 | Notifiers notifications | StateNotifierProvider | 🟢 Utilisé | NotificationListNotifier, PreferencesNotifier | Gestion état + actions |
| 107-115 | Providers computed | FutureProvider | 🟢 Utilisé | Critical, urgent, sorted, grouped, stats | 9 providers calculés |
| 116-117 | Providers actions | Provider | 🟢 Utilisé | Create, cleanup | 2 actions |

#### plant_intelligence_ui_providers.dart (5 providers)

| # | Nom du composant | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|------|--------|------------------|-------------|
| 118 | `displayPreferencesProvider` | StateNotifierProvider | 🔴 20% utilisé | Préférences affichage (thème, unités, langue) | Peu utilisé |
| 119 | `chartSettingsProvider` | StateNotifierProvider | 🔴 Non utilisé | Paramètres graphiques | Pas de graphiques intégrés |
| 120 | `viewModeProvider` | StateProvider | 🔴 Non utilisé | Mode vue (dashboard/list/grid/timeline) | Seul dashboard implémenté |
| 121 | `selectedPlantFilterProvider` | StateProvider | 🔴 Non utilisé | Filtre plantes sélectionné | Pas de filtrage UI |
| 122 | `selectedGardenFilterProvider` | StateProvider | 🔴 Non utilisé | Filtre jardin sélectionné | Pas de filtrage UI |
| 123 | `visualizationPeriodProvider` | StateProvider | 🔴 Non utilisé | Période visualisation | Pas d'historiques UI |

### Écrans (10 fichiers)

| # | Nom du composant | Fichier | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|---------|------|--------|------------------|-------------|
| 124 | `PlantIntelligenceDashboardScreen` | `plant_intelligence_dashboard_screen.dart` | Screen | 🟢 Actif | 🎯 Écran principal - tableau de bord intelligence | 2118 lignes, 7 sections |
| 125 | `PlantIntelligenceDashboardSimple` | `plant_intelligence_dashboard_simple.dart` | Screen | 🔴 Non intégré | Version simplifiée dashboard | Pas de route |
| 126 | `BioControlRecommendationsScreen` | `bio_control_recommendations_screen.dart` | Screen | 🟢 Actif | Liste recommandations biocontrôle | Utilisé depuis Dashboard |
| 127 | `PestObservationScreen` | `pest_observation_screen.dart` | Screen | 🟢 Actif | Formulaire création observation ravageur | Sanctuary data entry |
| 128 | `RecommendationsScreen` | `recommendations_screen.dart` | Screen | 🟢 Actif | Liste détaillée recommandations | Filtres, tri, actions |
| 129 | `RecommendationsSimple` | `recommendations_simple.dart` | Screen | 🔴 Non intégré | Version simplifiée recommandations | Pas de route |
| 130 | `NotificationsScreen` | `notifications_screen.dart` | Screen | 🟢 Actif | Liste notifications avec actions | Filtres, groupement |
| 131 | `NotificationPreferencesScreen` | `notification_preferences_screen.dart` | Screen | 🟢 Actif | Paramètres notifications | Heures silencieuses, types |
| 132 | `IntelligenceSettingsScreen` | `intelligence_settings_screen.dart` | Screen | 🔴 Non intégré | Paramètres intelligence complets | Pas de route |
| 133 | `IntelligenceSettingsSimple` | `intelligence_settings_simple.dart` | Screen | 🔴 Non intégré | Paramètres intelligence simples | Pas de route |

### Widgets (9 fichiers)

| # | Nom du composant | Fichier | Type | Statut | Rôle fonctionnel | Observation |
|---|------------------|---------|------|--------|------------------|-------------|
| 134 | `AlertBanner` | `cards/alert_banner.dart` | Widget | 🟢 Utilisé | Bannière alerte colorée avec icône | Utilisé dans Dashboard |
| 135 | `RecommendationCard` | `cards/recommendation_card.dart` | Widget | 🟢 Utilisé | Carte recommandation avec priorité, actions | Utilisé dans listes recommandations |
| 136 | `ConditionRadarChartSimple` | `charts/condition_radar_chart_simple.dart` | Widget | 🔴 Non utilisé | Graphique radar 4 conditions | Code prêt, non intégré |
| 137 | `ConditionIndicator` | `indicators/condition_indicator.dart` | Widget | 🟢 Utilisé | Indicateur visuel état (excellent/good/fair/poor/critical) | Utilisé Dashboard section analyses |
| 138 | `OptimalTimingWidget` | `indicators/optimal_timing_widget.dart` | Widget | 🟡 Partiellement | Widget timing optimal plantation | Utilisé Dashboard section timing |
| 139 | `PlantHealthIndicator` | `indicators/plant_health_indicator.dart` | Widget | 🟢 Utilisé | Jauge score santé (0-100) | Utilisé Dashboard stats rapides |
| 140 | `GardenOverviewWidget` | `summaries/garden_overview_widget.dart` | Widget | 🔴 Non utilisé | Vue d'ensemble jardin | Code prêt, non intégré |
| 141 | `IntelligenceSummary` | `summaries/intelligence_summary.dart` | Widget | 🟡 Partiellement | Résumé textuel intelligence | Utilisé partiellement |
| 142 | `NotificationListWidget` | `notification_list_widget.dart` | Widget | 🟢 Utilisé | Liste notifications avec groupement | Utilisé NotificationsScreen |

---

## 📄 Documentation (5 fichiers)

| # | Nom du fichier | Type | Statut | Contenu | Observation |
|---|----------------|------|--------|---------|-------------|
| 143 | `DEPLOYMENT_GUIDE.md` | Doc | 🔴 À vérifier | Guide déploiement | Non vérifié si à jour |
| 144 | `INTEGRATION_GUIDE.md` | Doc | 🔴 À vérifier | Guide intégration | Non vérifié si à jour |
| 145 | `NOTIFICATION_SYSTEM_README.md` | Doc | 🔴 À vérifier | Documentation système notifications | Non vérifié si à jour |
| 146 | `PERFORMANCE_REPORT.md` | Doc | 🔴 À vérifier | Rapport performance | Non vérifié si à jour |
| 147 | `QUICK_START.md` | Doc | 🔴 À vérifier | Guide démarrage rapide | Non vérifié si à jour |

---

## 📊 Synthèse quantitative

### Par type de composant

| Type | Total | Utilisés (🟢) | Partiels (🟡) | Dormants (🔴) | Dépréciés (⚠️) |
|------|-------|---------------|---------------|---------------|----------------|
| **UseCases** | 5 | 5 | 0 | 0 | 0 |
| **Orchestrators** | 1 | 1 | 0 | 0 | 0 |
| **Entités** | 18+ | 18+ | 0 | 0 | 0 |
| **Interfaces Repositories** | 10 | 9 | 0 | 0 | 1 |
| **Repositories Impl** | 2 | 2 | 0 | 0 | 0 |
| **DataSources** | 5 | 4 | 0 | 1 | 0 |
| **Services** | 3 | 3 | 0 | 0 | 0 |
| **Providers** | 50+ | ~40 | ~5 | ~5 | 0 |
| **Écrans** | 10 | 6 | 0 | 4 | 0 |
| **Widgets** | 9 | 5 | 2 | 2 | 0 |
| **Documentation** | 5 | 0 | 0 | 5 | 0 |
| **TOTAL** | **118+** | **~93** | **~7** | **~17** | **1** |

### Taux d'utilisation global

- **Utilisé (🟢)** : ~79%
- **Partiellement intégré (🟡)** : ~6%
- **Dormant/Non utilisé (🔴)** : ~14%
- **Déprécié (⚠️)** : ~1%

---

## 🔍 Observations spécifiques par composant

### Composants avec fonctionnalités non exploitées

| Composant | Fonctionnalités dormantes | Raison |
|-----------|---------------------------|--------|
| `PlantIntelligenceRepositoryImpl` | Export/Import, Backup/Restore, Stats avancées, Recherche avancée | Pas d'UI pour déclencher |
| `PlantNotificationService` | Cleanup automatique, Création auto avancée | Pas appelé automatiquement |
| `intelligence_state_providers` | Analyses temps réel, Prévisions | Pas d'UI toggle / logique manquante |
| `plant_intelligence_ui_providers` | Modes vue, Filtres, Périodes visualisation | Non implémentés en UI |
| Widgets graphiques | Radar chart, Garden overview, Intelligence summary | Non intégrés Dashboard |
| Écrans "Simple" | 4 écrans alternatifs | Pas de routes navigation |

### Composants critiques bien utilisés

| Composant | Raison du succès |
|-----------|------------------|
| `PlantIntelligenceOrchestrator` | Hub central coordonnant tout, bien exposé via providers |
| 5 UseCases | Logique métier claire, séparée, testable |
| `PlantIntelligenceDashboardScreen` | UI complète, bien structurée, affiche résultats analyses |
| `PlantNotificationService` | Système complet, streams temps réel, bien intégré |
| Entités Freezed | Typage fort, immutabilité, serialization automatique |

### Architecture exemplaire

✅ **Clean Architecture** parfaitement respectée :
- Domain indépendant (0 imports externes)
- Data implémente interfaces Domain
- Presentation consomme via Providers
- Séparation responsabilités claire

✅ **SOLID principles** appliqués :
- SRP : Chaque UseCase une responsabilité
- OCP : Extensible via interfaces
- LSP : Implémentations respectent contrats
- **ISP** : 10 interfaces spécialisées vs 1 monolithique
- DIP : Dépendances vers abstractions

✅ **Patterns reconnus** :
- Repository Pattern
- UseCase Pattern
- Provider Pattern (Riverpod)
- Observer Pattern (Streams)
- Singleton (Services)
- Cache Pattern

---

**Fin du tableau**  
Audit réalisé le 10 octobre 2025  
**Total composants analysés : 147**  
**Lignes de code estimées : ~15 000+**

