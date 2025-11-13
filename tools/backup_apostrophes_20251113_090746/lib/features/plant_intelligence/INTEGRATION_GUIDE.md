# 🔌 Guide d'Intégration - Système de Notifications

## 📋 Étapes d'Intégration dans PermaCalendar

### 1. Ajouter l'initialisation dans `lib/app_initializer.dart`

```dart
// Ajouter l'import au début du fichier
import 'features/plant_intelligence/data/services/notification_initialization.dart';

// Dans la méthode _initializeConditionalServices() ou après l'initialisation Hive
static Future<void> _initializeNotifications() async {
  print('🔔 Début initialisation du système de notifications...');
  
  try {
    await NotificationInitialization.initialize();
    print('✅ Système de notifications initialisé avec succès');
  } catch (e) {
    print('❌ Erreur initialisation notifications: $e');
    // Ne pas rethrow pour ne pas bloquer l'app
  }
}

// Appeler dans la méthode principale initialize()
Future<void> initialize() async {
  // ... autres initialisations ...
  
  // Après l'initialisation de Hive
  await _initializeNotifications();
  
  // ... suite ...
}
```

### 2. Ajouter la route dans `lib/app_router.dart`

```dart
// Ajouter l'import
import 'features/plant_intelligence/presentation/screens/notifications_screen.dart';
import 'features/plant_intelligence/presentation/screens/notification_preferences_screen.dart';

// Ajouter les routes
GoRoute(
  path: '/notifications',
  name: 'notifications',
  builder: (context, state) => const NotificationsScreen(),
),
GoRoute(
  path: '/notifications/preferences',
  name: 'notification-preferences',
  builder: (context, state) => const NotificationPreferencesScreen(),
),
```

### 3. Ajouter le badge de notification dans l'AppBar

Dans votre écran principal (ex: `home_screen.dart`) :

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/plant_intelligence/presentation/widgets/notification_list_widget.dart';
import 'features/plant_intelligence/presentation/providers/notification_providers.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PermaCalendar'),
        actions: [
          // Badge de notification
          NotificationBadge(
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ),
        ],
      ),
      body: // ... votre contenu
    );
  }
}
```

### 4. Intégrer avec PlantIntelligenceEngine

Dans `lib/core/services/plant_intelligence_engine.dart`, ajouter :

```dart
import '../../features/plant_intelligence/data/services/plant_notification_service.dart';

class PlantIntelligenceEngine {
  final PlantNotificationService _notificationService = PlantNotificationService();
  
  Future<PlantCondition> analyzePlant(
    String plantId,
    String gardenId, {
    bool forceRefresh = false,
  }) async {
    // ... analyse existante ...
    
    final condition = await _analyzeConditions(/* ... */);
    
    // Créer une notification si nécessaire
    if (condition.overallStatus == ConditionStatus.critical ||
        condition.overallStatus == ConditionStatus.poor) {
      await _notificationService.createCriticalConditionAlert(
        plantCondition: condition,
        plantName: plant.commonName,
      );
    } else if (condition.overallStatus == ConditionStatus.optimal) {
      await _notificationService.createOptimalConditionsAlert(
        plantCondition: condition,
        plantName: plant.commonName,
      );
    }
    
    return condition;
  }
  
  Future<List<PlantRecommendation>> getRecommendations(
    String plantId,
    String gardenId, {
    bool forceRefresh = false,
  }) async {
    // ... génération de recommandations ...
    
    final recommendations = await _generateRecommendations(/* ... */);
    
    // Créer des notifications pour les recommandations urgentes
    for (final rec in recommendations) {
      if (rec.priority == RecommendationPriority.critical ||
          rec.priority == RecommendationPriority.high) {
        await _notificationService.createRecommendationAlert(
          recommendation: rec,
          plantName: plant.commonName,
        );
      }
    }
    
    return recommendations;
  }
}
```

### 5. Intégrer les alertes météo

Dans votre service météo ou dans un provider :

```dart
import 'features/plant_intelligence/data/services/plant_notification_service.dart';
import 'features/plant_intelligence/domain/entities/weather_condition.dart';

class WeatherMonitoringService {
  final PlantNotificationService _notificationService = PlantNotificationService();
  
  Future<void> checkWeatherConditions(String gardenId) async {
    final weather = await _getWeatherConditions();
    
    // Créer une alerte si nécessaire
    await _notificationService.createWeatherAlert(
      weather: weather,
      gardenId: gardenId,
    );
  }
}
```

### 6. Tâche de fond pour surveillance continue (Optionnel)

Créer un service de surveillance en arrière-plan :

```dart
import 'dart:async';
import 'features/plant_intelligence/data/services/plant_notification_service.dart';

class PlantMonitoringService {
  static Timer? _monitoringTimer;
  static final PlantNotificationService _notificationService = PlantNotificationService();
  
  static void startMonitoring() {
    // Vérifier toutes les heures
    _monitoringTimer = Timer.periodic(Duration(hours: 1), (timer) async {
      await _checkAllPlantsConditions();
    });
  }
  
  static Future<void> _checkAllPlantsConditions() async {
    // Récupérer tous les jardins et plantes
    final gardens = await _getAllGardens();
    
    for (final garden in gardens) {
      final plants = await _getPlantsForGarden(garden.id);
      
      for (final plant in plants) {
        // Analyser chaque plante
        final condition = await _analyzePlantCondition(plant, garden);
        
        // Créer notifications si nécessaire
        if (condition.overallStatus == ConditionStatus.critical) {
          await _notificationService.createCriticalConditionAlert(
            plantCondition: condition,
            plantName: plant.commonName,
          );
        }
      }
      
      // Vérifier la météo
      final weather = await _getWeatherForGarden(garden.id);
      await _notificationService.createWeatherAlert(
        weather: weather,
        gardenId: garden.id,
      );
    }
  }
  
  static void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
  }
}

// Démarrer dans main.dart après l'initialisation
void main() async {
  // ... initialisations ...
  
  await AppInitializer.initialize();
  
  // Démarrer la surveillance
  PlantMonitoringService.startMonitoring();
  
  runApp(MyApp());
}
```

## 🧪 Test de l'Intégration

### 1. Créer une notification de test

```dart
import 'package:flutter/material.dart';
import 'features/plant_intelligence/data/services/plant_notification_service.dart';
import 'features/plant_intelligence/domain/entities/notification_alert.dart';

void testNotification() async {
  final service = PlantNotificationService();
  
  await service.createNotification(
    title: '🌱 Test Notification',
    message: 'Ceci est une notification de test du système d\'intelligence végétale.',
    type: NotificationType.reminder,
    priority: NotificationPriority.medium,
  );
  
  print('✅ Notification de test créée');
}
```

### 2. Vérifier dans l'interface

1. Lancer l'application
2. Appuyer sur l'icône de notification dans l'AppBar
3. Vérifier que la notification apparaît
4. Tester les actions (marquer comme lu, ignorer, etc.)

### 3. Tester les préférences

1. Aller dans Notifications → Paramètres (icône ⚙️)
2. Désactiver certains types de notifications
3. Créer une notification de ce type
4. Vérifier qu'elle n'est pas créée

### 4. Tester les alertes météo

```dart
import 'features/plant_intelligence/domain/entities/weather_condition.dart';

void testWeatherAlert() async {
  final service = PlantNotificationService();
  
  // Simuler un gel
  final freezingWeather = WeatherCondition(
    temperature: -2.0,
    humidity: 85,
    windSpeed: 10,
    precipitation: 0,
    timestamp: DateTime.now(),
  );
  
  await service.createWeatherAlert(
    weather: freezingWeather,
    gardenId: 'test_garden',
  );
  
  print('✅ Alerte gel créée');
}
```

## ⚠️ Points d'Attention

### 1. Permissions

Sur Android 13+, les notifications nécessitent une permission :
- Le système demande automatiquement la permission
- Tester sur un appareil réel pour valider

### 2. Performance

- Le nettoyage automatique s'exécute à l'initialisation
- Limiter la fréquence des vérifications en arrière-plan
- Utiliser le cache pour éviter les analyses répétées

### 3. Notifications en double

Pour éviter les notifications en double :

```dart
// Avant de créer une notification, vérifier s'il en existe une similaire
final existingNotifications = await service.getNotificationsForPlant(plantId);
final hasRecentAlert = existingNotifications.any((n) => 
  n.type == NotificationType.criticalCondition &&
  n.age.inHours < 6  // Moins de 6 heures
);

if (!hasRecentAlert) {
  await service.createCriticalConditionAlert(/* ... */);
}
```

### 4. Gestion de la mémoire

Le service utilise des streams - penser à se désabonner :

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  StreamSubscription<NotificationAlert>? _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = PlantNotificationService()
        .notificationStream
        .listen((notification) {
      // Traiter la notification
    });
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

## 📊 Monitoring

### Vérifier l'état du système

```dart
void checkNotificationSystemStatus() async {
  final service = PlantNotificationService();
  
  final stats = {
    'total': (await service.getAllNotifications()).length,
    'unread': (await service.getUnreadNotifications()).length,
    'active': (await service.getActiveNotifications()).length,
    'enabled': await service.areNotificationsEnabled(),
  };
  
  print('📊 État du système de notifications:');
  print(stats);
}
```

## 🐛 Debugging

### Activer les logs détaillés

Les services utilisent `dart:developer`. Filtrer par :
- `PlantNotificationService`
- `FlutterNotificationService`
- `NotificationInitialization`

Dans Android Studio / VS Code :
```
Filtrer les logs: "PlantNotificationService"
```

### Vider les notifications de test

```dart
void clearAllNotifications() async {
  final service = PlantNotificationService();
  final allNotifications = await service.getAllNotifications();
  
  for (final notification in allNotifications) {
    await service.deleteNotification(notification.id);
  }
  
  print('✅ Toutes les notifications supprimées');
}
```

## ✅ Checklist d'Intégration

- [ ] Initialisation ajoutée dans `app_initializer.dart`
- [ ] Routes ajoutées dans `app_router.dart`
- [ ] Badge de notification dans l'AppBar
- [ ] Intégration avec PlantIntelligenceEngine
- [ ] Alertes météo configurées
- [ ] Test des notifications basiques
- [ ] Test des préférences
- [ ] Test des alertes météo
- [ ] Test sur appareil réel
- [ ] Vérification des permissions
- [ ] Documentation mise à jour

## 📞 Support

En cas de problème :
1. Vérifier les logs dans la console
2. Vérifier l'initialisation dans `app_initializer.dart`
3. Vérifier les permissions sur l'appareil
4. Consulter `NOTIFICATION_SYSTEM_README.md`





