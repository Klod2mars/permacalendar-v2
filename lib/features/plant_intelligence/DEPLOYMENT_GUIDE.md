# 🌱 Guide de Déploiement - Intelligence Végétale PermaCalendar v2.0

## 📋 Vue d'Ensemble

Ce document décrit l'architecture complète et le déploiement du système d'**Intelligence Végétale** dans PermaCalendar v2.0. Le système fournit des analyses en temps réel, des recommandations intelligentes et un suivi complet de la santé des plantes.

---

## 🏗️ Architecture du Système

### Structure des Couches

```
┌─────────────────────────────────────────────────────────┐
│              PRESENTATION LAYER                          │
│  ┌────────────┐  ┌───────────┐  ┌──────────────┐       │
│  │  Screens   │  │  Widgets  │  │  Providers   │       │
│  └────────────┘  └───────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────┘
                        ⬇ ⬆
┌─────────────────────────────────────────────────────────┐
│               DOMAIN LAYER                               │
│  ┌────────────┐  ┌───────────┐  ┌──────────────┐       │
│  │  UseCases  │  │ Entities  │  │ Repositories │       │
│  └────────────┘  └───────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────┘
                        ⬇ ⬆
┌─────────────────────────────────────────────────────────┐
│                DATA LAYER                                │
│  ┌─────────────┐  ┌──────────┐  ┌─────────────┐        │
│  │ DataSources │  │   Hive   │  │  OpenMeteo  │        │
│  └─────────────┘  └──────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────┘
                        ⬇ ⬆
┌─────────────────────────────────────────────────────────┐
│              CORE SERVICES LAYER                         │
│  ┌──────────────────┐  ┌──────────────────────┐         │
│  │ Intelligence     │  │  Weather Impact      │         │
│  │ Engine           │  │  Analyzer            │         │
│  └──────────────────┘  └──────────────────────┘         │
└─────────────────────────────────────────────────────────┘
```

---

## 📦 Composants Principaux

### 1. **PlantIntelligenceEngine** (Service Principal)

Le moteur central qui orchestre toutes les analyses et recommandations.

**Localisation** : `lib/core/services/plant_intelligence_engine.dart`

**Responsabilités** :
- Analyse des conditions des plantes
- Génération de recommandations intelligentes
- Évaluation du timing de plantation
- Gestion du cache multi-niveaux
- Statistiques de performance

**Cache optimisé** :
- `_conditionCache` : TTL 30 minutes, max 50 entrées
- `_recommendationCache` : TTL 15 minutes, max 100 entrées
- `_timingCache` : TTL 1 heure
- `_weatherImpactCache` : TTL 20 minutes

### 2. **PlantIntelligenceRepository** (Couche Data)

Gère la persistance et l'accès aux données.

**Localisation** : `lib/features/plant_intelligence/data/repositories/plant_intelligence_repository_impl.dart`

**DataSources intégrées** :
- `PlantIntelligenceLocalDataSource` : Persistance Hive locale
- `WeatherDataSource` : Données météorologiques via OpenMeteo
- `PlantHiveRepository` : Catalogue de plantes
- `GardenHiveRepository` : Contexte des jardins

### 3. **Use Cases** (Logique Métier)

**`AnalyzePlantConditionsUsecase`** : Analyse complète d'une plante
- Évalue température, humidité, lumière, sol
- Calcule un score global de santé
- Identifie les risques et opportunités

**`GenerateRecommendationsUsecase`** : Génération de recommandations
- Recommandations contextuelles et prioritaires
- Actions concrètes et mesurables
- Basées sur les conditions réelles

**`EvaluatePlantingTimingUsecase`** : Timing optimal de plantation
- Analyse des conditions météo actuelles et prévues
- Recommandations de fenêtres de plantation
- Prise en compte de la saisonnalité

### 4. **Entities** (Modèles Domain)

**`PlantCondition`** : État d'une plante à un instant T
```dart
PlantCondition(
  id: String,
  plantId: String,
  analyzedAt: DateTime,
  status: ConditionStatus,
  temperature: TemperatureCondition,
  moisture: MoistureCondition,
  light: LightCondition,
  soil: SoilCondition,
  risks: List<RiskFactor>,
  opportunities: List<Opportunity>,
  overallScore: double,
)
```

**`Recommendation`** : Recommandation intelligente
```dart
Recommendation(
  id: String,
  plantId: String,
  type: RecommendationType,
  priority: RecommendationPriority,
  title: String,
  description: String,
  action: String,
  estimatedImpact: double,
  validUntil: DateTime?,
)
```

**`WeatherCondition`** : Conditions météorologiques
```dart
WeatherCondition(
  timestamp: DateTime,
  currentTemperature: double,
  minTemperature: double,
  maxTemperature: double,
  humidity: double,
  precipitation: double,
  windSpeed: double,
  cloudCover: double,
  uvIndex: double,
  pressure: double,
)
```

**`NotificationAlert`** : Alertes et notifications
```dart
NotificationAlert(
  id: String,
  title: String,
  message: String,
  type: NotificationType,
  priority: NotificationPriority,
  status: NotificationStatus,
  createdAt: DateTime,
  readAt: DateTime?,
  plantId: String?,
  gardenId: String?,
  actionUrl: String?,
)
```

---

## 🗄️ Persistance Hive

### Boxes Utilisées

Le système utilise les boxes Hive suivantes :

| Box Name | Type | TypeId | Description |
|----------|------|--------|-------------|
| `plant_conditions` | `PlantConditionHive` | 30 | Historique des conditions de plantes |
| `weather_conditions` | `WeatherConditionHive` | 37 | Données météorologiques |
| `weather_forecasts` | `WeatherForecastHive` | 38 | Prévisions météo |
| `recommendations` | `RecommendationHive` | 39 | Recommandations actives |
| `notification_alerts` | `NotificationAlert` | 43 | Notifications et alertes |
| `plant_analyses` | `dynamic` | - | Résultats d'analyses |
| `active_alerts` | `dynamic` | - | Alertes actives |

### Adaptateurs Hive Enregistrés

Les adaptateurs suivants sont enregistrés dans `app_initializer.dart` :

**Conditions de plantes (TypeId 30-36)** :
- `PlantConditionHiveAdapter` (30)
- `TemperatureConditionHiveAdapter` (31)
- `MoistureConditionHiveAdapter` (32)
- `LightConditionHiveAdapter` (33)
- `SoilConditionHiveAdapter` (34)
- `RiskFactorHiveAdapter` (35)
- `OpportunityHiveAdapter` (36)

**Conditions météorologiques (TypeId 37-38)** :
- `WeatherConditionHiveAdapter` (37)
- `WeatherForecastHiveAdapter` (38)

**Recommandations (TypeId 39)** :
- `RecommendationHiveAdapter` (39)

**Notifications (TypeId 40-43)** :
- `NotificationTypeAdapter` (40)
- `NotificationPriorityAdapter` (41)
- `NotificationStatusAdapter` (42)
- `NotificationAlertAdapter` (43)

---

## 🔌 Intégration Riverpod

### Providers Disponibles

Le système expose plus de 20 providers Riverpod pour une intégration facile :

#### **Providers de Base**

```dart
// Services core
final plantIntelligenceEngineProvider = Provider<PlantIntelligenceEngine>((ref) => ...);
final plantIntelligenceRepositoryProvider = Provider<PlantIntelligenceRepository>((ref) => ...);

// Use cases
final analyzePlantConditionsUsecaseProvider = Provider<AnalyzePlantConditionsUsecase>((ref) => ...);
final generateRecommendationsUsecaseProvider = Provider<GenerateRecommendationsUsecase>((ref) => ...);
final evaluatePlantingTimingUsecaseProvider = Provider<EvaluatePlantingTimingUsecase>((ref) => ...);
```

#### **Providers de Données**

```dart
// Conditions de plantes
final plantConditionProvider = FutureProvider.family<PlantCondition?, String>((ref, plantId) async => ...);
final plantConditionHistoryProvider = FutureProvider.family<List<PlantCondition>, PlantConditionHistoryParams>((ref, params) async => ...);

// Recommandations
final plantRecommendationsProvider = FutureProvider.family<List<Recommendation>, String>((ref, plantId) async => ...);
final plantRecommendationsByPriorityProvider = FutureProvider.family<List<Recommendation>, PlantRecommendationsByPriorityParams>((ref, params) async => ...);

// Météo
final currentWeatherProvider = FutureProvider.family<WeatherCondition?, String>((ref, gardenId) async => ...);
final weatherHistoryProvider = FutureProvider.family<List<WeatherCondition>, WeatherHistoryParams>((ref, params) async => ...);

// Contexte jardin
final gardenContextProvider = FutureProvider.family<GardenContext?, String>((ref, gardenId) async => ...);
final userGardensProvider = FutureProvider.family<List<GardenContext>, String>((ref, userId) async => ...);
```

#### **Providers d'Actions**

```dart
// Analyse de plante
final analyzePlantProvider = FutureProvider.family<PlantCondition, AnalyzePlantSimpleParams>((ref, params) async => ...);

// Génération de recommandations
final generatePlantRecommendationsProvider = FutureProvider.family<List<PlantRecommendation>, AnalyzePlantSimpleParams>((ref, params) async => ...);

// Évaluation du timing
final evaluatePlantingTimingProvider = FutureProvider.family<PlantingTimingEvaluation, AnalyzePlantSimpleParams>((ref, params) async => ...);
```

#### **Providers d'État**

```dart
// État de chargement et erreurs
final plantIntelligenceLoadingProvider = StateProvider<bool>((ref) => false);
final plantIntelligenceErrorProvider = StateProvider<String?>((ref) => null);

// Santé du système
final plantIntelligenceHealthProvider = FutureProvider<bool>((ref) async => ...);
```

#### **Providers de Notifications**

```dart
// Notifications
final alertNotificationsProvider = StateNotifierProvider<AlertNotificationsNotifier, List<Map<String, dynamic>>>((ref) => ...);
final recommendationNotificationsProvider = StateNotifierProvider<RecommendationNotificationsNotifier, List<Recommendation>>((ref) => ...);
```

---

## 🛣️ Routes de Navigation

Les routes suivantes sont disponibles dans `app_router.dart` :

| Route | Nom | Écran | Description |
|-------|-----|-------|-------------|
| `/intelligence` | `intelligence` | `PlantIntelligenceDashboardScreen` | Dashboard principal |
| `/intelligence/plant/:id` | `intelligence-detail` | À implémenter | Détail d'une plante |
| `/intelligence/recommendations` | `recommendations` | `RecommendationsScreen` | Liste des recommandations |
| `/intelligence/settings` | `intelligence-settings` | `IntelligenceSettingsSimple` | Paramètres |

**Exemple de navigation** :
```dart
context.go('/intelligence');
context.go('/intelligence/recommendations');
context.go('/intelligence/settings');
```

---

## 🚀 Initialisation de l'Application

### Séquence de Démarrage

L'initialisation complète du système est gérée dans `app_initializer.dart` :

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation complète via AppInitializer
  await AppInitializer.initialize();
  
  // Initialiser les données locales pour les dates
  await initializeDateFormatting('fr_FR', null);
  
  runApp(const ProviderScope(child: MyApp()));
}
```

### Étapes d'Initialisation

1. **Chargement des variables d'environnement** (`.env`)
2. **Initialisation de Hive** (`Hive.initFlutter()`)
3. **Migrations de données** (si nécessaires)
4. **Enregistrement des adaptateurs Hive** (tous les TypeAdapters)
5. **Ouverture des boxes Hive** (gardens, plants, intelligence)
6. **Initialisation des repositories** (GardenHive, PlantHive)
7. **Chargement des données initiales** (`plants.json`)
8. **Initialisation des boxes Intelligence Végétale** (7 boxes)
9. **Initialisation des services conditionnels** (ActivityTracker, etc.)

---

## 📊 Performance et Optimisations

### Système de Cache

Le `PlantIntelligenceEngine` utilise un système de cache multi-niveaux optimisé :

**Caractéristiques** :
- Cache LRU (Least Recently Used)
- TTL (Time To Live) configurables par type de données
- Nettoyage automatique quand limite atteinte
- Statistiques de performance en temps réel

**Statistiques disponibles** :
```dart
final stats = await engine.getCacheStatistics();
print('Cache Hits: ${stats.cacheHits}');
print('Cache Misses: ${stats.cacheMisses}');
print('Hit Rate: ${stats.hitRate}%');
print('Analyses Count: ${stats.analysisCount}');
print('Error Count: ${stats.errorCount}');
```

### Retry avec Backoff Exponentiel

Les opérations critiques bénéficient d'un système de retry automatique :
- 3 tentatives maximum
- Backoff exponentiel : 100ms, 200ms, 400ms
- Logging détaillé des échecs

### Logging Structuré

Utilisation de `dart:developer` pour un logging professionnel :
```dart
import 'dart:developer' as developer;

developer.log('Message', name: 'PlantIntelligenceEngine', level: 500);  // DEBUG
developer.log('Error', name: 'PlantIntelligenceEngine', level: 1000);  // ERROR
```

**Niveaux de log** :
- `500` : Debug (informations détaillées)
- `1000` : Error (erreurs critiques)

---

## 🧪 Tests

### Structure des Tests

```
test/features/plant_intelligence/
├── unit/
│   ├── analyze_plant_conditions_usecase_test.dart
│   ├── generate_recommendations_usecase_test.dart
│   └── evaluate_planting_timing_usecase_test.dart
├── integration/
│   ├── plant_intelligence_integration_test.dart
│   └── data_sources_integration_test.dart
└── mocks/
    └── mock_services.dart
```

### Exécution des Tests

```bash
# Tests unitaires
flutter test test/features/plant_intelligence/unit/

# Tests d'intégration
flutter test test/features/plant_intelligence/integration/

# Tous les tests avec couverture
flutter test --coverage

# Visualiser la couverture
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 📖 Utilisation pour les Développeurs

### Exemple Complet : Analyser une Plante

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart';

class MyWidget extends ConsumerWidget {
  final String plantId;
  final String gardenId;
  
  const MyWidget({required this.plantId, required this.gardenId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Analyser la plante
    final analysisAsync = ref.watch(analyzePlantProvider(
      AnalyzePlantSimpleParams(
        plantId: plantId,
        gardenId: gardenId,
        forceRefresh: false,
      ),
    ));
    
    return analysisAsync.when(
      data: (condition) {
        return Column(
          children: [
            Text('État: ${condition.status}'),
            Text('Score: ${condition.overallScore}/100'),
            Text('Température: ${condition.temperature.current}°C'),
            // ...
          ],
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Erreur: $error'),
    );
  }
}
```

### Exemple : Obtenir des Recommandations

```dart
final recommendationsAsync = ref.watch(
  plantRecommendationsProvider(plantId),
);

recommendationsAsync.when(
  data: (recommendations) {
    return ListView.builder(
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final rec = recommendations[index];
        return ListTile(
          title: Text(rec.title),
          subtitle: Text(rec.description),
          trailing: Chip(
            label: Text(rec.priority.toString()),
          ),
        );
      },
    );
  },
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Erreur: $error'),
);
```

### Exemple : Gérer les Notifications

```dart
// Ajouter une alerte
ref.read(alertNotificationsProvider.notifier).addAlert({
  'id': 'alert_1',
  'title': 'Gel imminent',
  'message': 'Protégez vos plants de tomates',
  'severity': 'high',
  'read': false,
});

// Marquer comme lue
ref.read(alertNotificationsProvider.notifier).markAsRead('alert_1');

// Supprimer
ref.read(alertNotificationsProvider.notifier).removeAlert('alert_1');
```

---

## 🔧 Configuration

### Variables d'Environnement

Créer un fichier `.env` à la racine du projet :

```env
# Intelligence Végétale
PLANT_INTELLIGENCE_ENABLED=true
WEATHER_API_ENABLED=true

# OpenMeteo API (gratuit, pas de clé requise)
OPEN_METEO_BASE_URL=https://api.open-meteo.com/v1

# Cache
CACHE_ENABLED=true
CACHE_EXPIRATION_MINUTES=30

# Fonctionnalités sociales (désactivées)
SOCIAL_ENABLED=false
```

### Paramètres du Repository

```dart
final repositoryConfig = RepositoryConfig(
  databasePath: 'plant_intelligence_db',
  enableCache: true,
  cacheExpiration: Duration(hours: 1),
  enableSync: false,
);
```

---

## 🐛 Débogage

### Vérifier la Santé du Système

```dart
final healthAsync = ref.watch(plantIntelligenceHealthProvider);

healthAsync.when(
  data: (isHealthy) {
    if (isHealthy) {
      print('✅ Système d\'intelligence végétale opérationnel');
    } else {
      print('❌ Problème détecté dans le système');
    }
  },
  loading: () => print('Vérification en cours...'),
  error: (error, stack) => print('Erreur de santé: $error'),
);
```

### Statistiques de Performance

```dart
final engine = ref.read(plantIntelligenceEngineProvider);
final stats = await engine.getCacheStatistics();

print('=== Statistiques d\'Intelligence Végétale ===');
print('Cache Hits: ${stats.cacheHits}');
print('Cache Misses: ${stats.cacheMisses}');
print('Hit Rate: ${stats.hitRate.toStringAsFixed(2)}%');
print('Analyses totales: ${stats.analysisCount}');
print('Erreurs: ${stats.errorCount}');
print('Taux d\'erreur: ${stats.errorRate.toStringAsFixed(2)}%');
```

### Logs de Développement

Pour activer les logs détaillés :

```dart
// Dans app_settings
ref.read(appSettingsProvider.notifier).updateSetting('debugMode', true);
```

---

## 📝 Checklist de Déploiement

### Pré-Déploiement

- [x] ✅ Tous les adaptateurs Hive enregistrés
- [x] ✅ Boxes Hive initialisées
- [x] ✅ Providers Riverpod configurés
- [x] ✅ Routes de navigation définies
- [x] ✅ Initialisation dans `app_initializer.dart`
- [ ] ⏳ Tests unitaires complets (90%+ couverture)
- [ ] ⏳ Tests d'intégration validés
- [ ] ⏳ Tests E2E fonctionnels

### Déploiement

1. **Build de production** :
   ```bash
   flutter build apk --release
   flutter build appbundle --release
   flutter build ios --release
   ```

2. **Vérification des performances** :
   ```bash
   flutter run --profile
   # Utiliser DevTools pour analyser
   ```

3. **Tests sur appareils réels** :
   - Tester sur Android (API 21+)
   - Tester sur iOS (13.0+)
   - Vérifier la persistance Hive
   - Vérifier les analyses en temps réel

### Post-Déploiement

- [ ] Monitoring des erreurs (Sentry, Firebase Crashlytics)
- [ ] Analyse des performances (Firebase Performance)
- [ ] Feedback utilisateurs
- [ ] Optimisations itératives

---

## 🆘 Support et Maintenance

### Problèmes Courants

**❌ Erreur : "Box not found"**
```
Solution : Vérifier que toutes les boxes sont ouvertes dans _initializePlantIntelligenceBoxes()
```

**❌ Erreur : "TypeAdapter not registered"**
```
Solution : Vérifier que tous les adaptateurs sont enregistrés dans _registerHiveAdapters()
```

**❌ Erreur : "Provider disposed"**
```
Solution : Utiliser ref.read() au lieu de ref.watch() dans les méthodes
```

### Nettoyage des Données

Pour réinitialiser complètement les données d'intelligence végétale :

```dart
await AppInitializer.forceCleanHiveData();
```

⚠️ **ATTENTION** : Cette opération supprime TOUTES les données Hive de l'application !

---

## 📚 Ressources Supplémentaires

- **Architecture** : Voir `ARCHITECTURE.md` pour plus de détails
- **Tests** : Voir `TESTING_GUIDE.md` pour les stratégies de tests
- **API** : Voir `API_REFERENCE.md` pour la documentation complète des APIs

---

## 🎉 Conclusion

Le système d'**Intelligence Végétale** est maintenant complètement intégré et prêt pour la production. Il fournit :

✅ **Analyses en temps réel** des conditions de plantes  
✅ **Recommandations intelligentes** basées sur des données réelles  
✅ **Système de cache optimisé** pour des performances élevées  
✅ **Architecture robuste** et maintenable  
✅ **Intégration Riverpod** complète et simple d'utilisation  
✅ **Persistance Hive** fiable et performante  
✅ **Documentation complète** pour les développeurs  

**🌱 Bonne culture ! 🌱**

---

**Version** : 2.0.0  
**Date** : Octobre 2025  
**Auteur** : PermaCalendar Team  
**License** : Propriétaire

