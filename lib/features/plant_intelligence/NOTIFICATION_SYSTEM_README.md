# 🔔 Système de Notifications - Intelligence Végétale

## 📋 Vue d'Ensemble

Ce système de notifications intelligent permet d'alerter l'utilisateur des conditions critiques et des recommandations importantes pour ses plantes. Il intègre :

- ✅ **Persistance locale** avec Hive
- ✅ **Notifications système** avec flutter_local_notifications
- ✅ **Gestion des préférences** utilisateur
- ✅ **Filtrage et tri** avancés
- ✅ **Notifications en temps réel** via streams
- ✅ **Interface utilisateur** complète

## 🏗️ Architecture

### Couche Domain (Entités)

```
lib/features/plant_intelligence/domain/entities/
└── notification_alert.dart
    ├── NotificationAlert (entité principale)
    ├── NotificationType (enum)
    ├── NotificationPriority (enum)
    └── NotificationStatus (enum)
```

### Couche Data (Services)

```
lib/features/plant_intelligence/data/services/
├── plant_notification_service.dart       # Service principal de gestion
├── flutter_notification_service.dart     # Intégration flutter_local_notifications
└── notification_initialization.dart      # Initialisation et configuration
```

### Couche Présentation

```
lib/features/plant_intelligence/presentation/
├── providers/
│   └── notification_providers.dart       # Providers Riverpod
├── screens/
│   ├── notifications_screen.dart         # Écran principal
│   └── notification_preferences_screen.dart # Paramètres
└── widgets/
    └── notification_list_widget.dart     # Liste et widgets
```

## 🚀 Utilisation

### 1. Initialisation

Ajouter dans `lib/app_initializer.dart` :

```dart
import 'package:permacalendar/features/plant_intelligence/data/services/notification_initialization.dart';

// Dans la méthode d'initialisation
await NotificationInitialization.initialize();
```

### 2. Créer une notification

```dart
import 'package:permacalendar/features/plant_intelligence/data/services/plant_notification_service.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/notification_alert.dart';

final service = PlantNotificationService();

await service.createNotification(
  title: 'Alerte Gel',
  message: 'Risque de gel cette nuit. Protégez vos plantes sensibles.',
  type: NotificationType.weatherAlert,
  priority: NotificationPriority.critical,
  gardenId: 'garden_123',
);
```

### 3. Notifications météo automatiques

```dart
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';

final weatherCondition = WeatherCondition(
  temperature: -2.0,
  humidity: 85,
  // ... autres propriétés
);

await service.createWeatherAlert(
  weather: weatherCondition,
  gardenId: 'garden_123',
);
```

### 4. Notifications de conditions critiques

```dart
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';

final plantCondition = PlantCondition(
  plantId: 'tomato_001',
  overallStatus: ConditionStatus.critical,
  // ... autres propriétés
);

await service.createCriticalConditionAlert(
  plantCondition: plantCondition,
  plantName: 'Tomate',
);
```

### 5. Notifications de recommandations

```dart
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';

final recommendation = Recommendation(
  id: 'rec_001',
  plantId: 'tomato_001',
  title: 'Arrosage Urgent',
  description: 'Vos tomates nécessitent un arrosage immédiat.',
  priority: RecommendationPriority.high,
  // ... autres propriétés
);

await service.createRecommendationAlert(
  recommendation: recommendation,
  plantName: 'Tomate',
);
```

### 6. Utilisation dans l'interface

#### Afficher la liste des notifications

```dart
import 'package:permacalendar/features/plant_intelligence/presentation/screens/notifications_screen.dart';

// Navigation vers l'écran des notifications
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NotificationsScreen(),
  ),
);
```

#### Badge de notification avec compteur

```dart
import 'package:permacalendar/features/plant_intelligence/presentation/widgets/notification_list_widget.dart';

NotificationBadge(
  child: IconButton(
    icon: const Icon(Icons.notifications),
    onPressed: () {
      // Ouvrir l'écran des notifications
    },
  ),
)
```

#### Liste simple de notifications

```dart
const NotificationListWidget(
  showOnlyUnread: true,  // Afficher uniquement les non lues
)
```

### 7. Gestion avec Riverpod

```dart
// Récupérer le nombre de notifications non lues
final unreadCount = ref.watch(unreadNotificationCountProvider);

// Marquer une notification comme lue
ref.read(notificationListNotifierProvider.notifier).markAsRead(notificationId);

// Actualiser la liste
ref.read(notificationListNotifierProvider.notifier).refresh();

// Récupérer les notifications critiques
final criticalNotifications = ref.watch(criticalUnreadNotificationsProvider);
```

## 📊 Types de Notifications

### 1. Alertes Météo (`weatherAlert`)
- Gel imminent (température < 0°C)
- Chaleur excessive (température > 35°C)
- Sécheresse (humidité < 30%)
- Vents forts (vitesse > 50 km/h)

### 2. Conditions Critiques (`criticalCondition`)
- Plantes en situation critique
- Problèmes de température, humidité ou humidité du sol

### 3. Recommandations (`recommendation`)
- Actions suggérées pour améliorer les conditions
- Basées sur les analyses de l'intelligence végétale

### 4. Conditions Optimales (`optimalCondition`)
- Moment idéal pour planter
- Conditions parfaites détectées

### 5. État des Plantes (`plantCondition`)
- Changements dans l'état de santé
- Mises à jour de conditions

### 6. Rappels (`reminder`)
- Actions à effectuer
- Tâches planifiées

## 🎚️ Niveaux de Priorité

1. **Critique** (`critical`) 🔴
   - Action immédiate requise
   - Son et vibration activés
   - Notification système prioritaire

2. **Élevée** (`high`) 🟠
   - Nécessite une attention rapide
   - Son et vibration activés

3. **Moyenne** (`medium`) 🟡
   - À traiter dans les prochains jours
   - Son activé

4. **Faible** (`low`) 🟢
   - Information générale
   - Notification silencieuse

## ⚙️ Préférences Utilisateur

Les utilisateurs peuvent configurer :

- ✅ Activation/désactivation globale
- ✅ Activation par type de notification
- ✅ Activation par priorité
- ✅ Son et vibration
- ✅ Heures de silence (à implémenter)

## 🔧 Maintenance

### Nettoyage automatique

Le système nettoie automatiquement les anciennes notifications :

```dart
// Supprimer les notifications archivées/ignorées de plus de 30 jours
await service.cleanupOldNotifications(daysToKeep: 30);
```

### Statistiques

```dart
// Récupérer les statistiques
final stats = await ref.watch(notificationStatsProvider.future);

print('Total: ${stats['total']}');
print('Non lues: ${stats['unread']}');
print('Critiques: ${stats['criticalCount']}');
```

## 🎨 Personnalisation

### Canaux de notification Android

Le système crée 4 canaux Android :

1. `plant_intelligence_critical` - Alertes critiques
2. `plant_intelligence_high` - Alertes importantes
3. `plant_intelligence_default` - Notifications générales
4. `plant_intelligence_low` - Informations

### Icônes et couleurs

Chaque type et priorité a sa propre icône et couleur :

```dart
// Type
notification.type.icon        // Emoji ou nom d'icône
notification.type.colorHex    // Couleur hexadécimale

// Priorité
notification.priority.icon     // Emoji ou nom d'icône
notification.priority.colorHex // Couleur hexadécimale
```

## 📱 Intégration avec l'Intelligence Végétale

Le système s'intègre automatiquement avec :

- **PlantIntelligenceEngine** - Génération automatique d'alertes
- **WeatherImpactAnalyzer** - Alertes météo basées sur l'analyse
- **PlantConditionAnalyzer** - Alertes de conditions critiques
- **RecommendationSystem** - Notifications de recommandations

## 🧪 Tests

Pour tester le système :

```dart
// Créer une notification de test
await service.createNotification(
  title: 'Test',
  message: 'Ceci est une notification de test',
  type: NotificationType.reminder,
  priority: NotificationPriority.low,
);

// Vérifier le nombre de notifications
final count = await service.getUnreadCount();
print('Notifications non lues: $count');
```

## 📝 TODO / Améliorations Futures

- [ ] Heures de silence (quiet hours)
- [ ] Notifications récurrentes
- [ ] Groupement de notifications
- [ ] Actions rapides dans les notifications
- [ ] Notifications push (backend)
- [ ] Sons personnalisés par type
- [ ] Localisation complète (i18n)
- [ ] Tests unitaires et d'intégration

## 🐛 Debugging

Pour activer les logs détaillés :

```dart
// Les services utilisent dart:developer
// Filtrer les logs par nom :
// - PlantNotificationService
// - FlutterNotificationService
// - NotificationInitialization
```

## 📄 Licence

Ce système fait partie de PermaCalendar v2.0





