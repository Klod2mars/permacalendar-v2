# 🚀 Quick Start - Intelligence Végétale

## ⚡ Démarrage Rapide en 5 Minutes

### 1️⃣ Analyser une Plante

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_intelligence_providers.dart';

class PlantAnalysisWidget extends ConsumerWidget {
  final String plantId;
  final String gardenId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(analyzePlantProvider(
      AnalyzePlantSimpleParams(
        plantId: plantId,
        gardenId: gardenId,
      ),
    ));
    
    return analysisAsync.when(
      data: (condition) => Text('Score: ${condition.overallScore}/100'),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Erreur: $e'),
    );
  }
}
```

### 2️⃣ Obtenir des Recommandations

```dart
final recommendationsAsync = ref.watch(
  plantRecommendationsProvider(plantId),
);

recommendationsAsync.when(
  data: (recs) => ListView.builder(
    itemCount: recs.length,
    itemBuilder: (context, i) => ListTile(
      title: Text(recs[i].title),
      subtitle: Text(recs[i].description),
    ),
  ),
  loading: () => CircularProgressIndicator(),
  error: (e, _) => Text('Erreur: $e'),
);
```

### 3️⃣ Vérifier la Météo

```dart
final weatherAsync = ref.watch(currentWeatherProvider(gardenId));

weatherAsync.when(
  data: (weather) => Column(
    children: [
      Text('🌡️ ${weather?.currentTemperature}°C'),
      Text('💧 ${weather?.humidity}%'),
      Text('☁️ ${weather?.cloudCover}%'),
    ],
  ),
  loading: () => CircularProgressIndicator(),
  error: (e, _) => Text('Erreur: $e'),
);
```

### 4️⃣ Gérer les Notifications

```dart
// Récupérer les alertes actives
final alerts = ref.watch(alertNotificationsProvider);

// Ajouter une alerte
ref.read(alertNotificationsProvider.notifier).addAlert({
  'id': 'alert_1',
  'title': 'Gel imminent',
  'message': 'Protégez vos plants',
  'severity': 'high',
  'read': false,
});

// Marquer comme lue
ref.read(alertNotificationsProvider.notifier).markAsRead('alert_1');
```

### 5️⃣ Navigation vers le Dashboard

```dart
import 'package:go_router/go_router.dart';

// Naviguer vers le dashboard
context.go('/intelligence');

// Naviguer vers les recommandations
context.go('/intelligence/recommendations');

// Naviguer vers les paramètres
context.go('/intelligence/settings');
```

---

## 📋 Providers les Plus Utiles

| Provider | Paramètre | Retour | Usage |
|----------|-----------|--------|-------|
| `analyzePlantProvider` | `AnalyzePlantSimpleParams` | `PlantCondition` | Analyse complète |
| `plantRecommendationsProvider` | `String` (plantId) | `List<Recommendation>` | Recommandations |
| `currentWeatherProvider` | `String` (gardenId) | `WeatherCondition?` | Météo actuelle |
| `plantConditionHistoryProvider` | `PlantConditionHistoryParams` | `List<PlantCondition>` | Historique |
| `gardenContextProvider` | `String` (gardenId) | `GardenContext?` | Contexte jardin |

---

## 🎯 Exemples Complets

### Widget de Santé de Plante

```dart
class PlantHealthCard extends ConsumerWidget {
  final String plantId;
  final String gardenId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conditionAsync = ref.watch(
      plantConditionProvider(plantId),
    );
    
    return Card(
      child: conditionAsync.when(
        data: (condition) {
          if (condition == null) {
            return Text('Aucune donnée disponible');
          }
          
          return Column(
            children: [
              _buildStatusBadge(condition.status),
              Text('Score: ${condition.overallScore.toStringAsFixed(1)}/100'),
              _buildTemperature(condition.temperature),
              _buildMoisture(condition.moisture),
              _buildRisks(condition.risks),
            ],
          );
        },
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => Text('Erreur: $error'),
      ),
    );
  }
  
  Widget _buildStatusBadge(ConditionStatus status) {
    final color = {
      ConditionStatus.excellent: Colors.green,
      ConditionStatus.good: Colors.lightGreen,
      ConditionStatus.fair: Colors.orange,
      ConditionStatus.poor: Colors.deepOrange,
      ConditionStatus.critical: Colors.red,
    }[status]!;
    
    return Chip(
      label: Text(status.toString()),
      backgroundColor: color,
    );
  }
  
  Widget _buildTemperature(TemperatureCondition temp) {
    return ListTile(
      leading: Icon(Icons.thermostat),
      title: Text('${temp.current}°C'),
      subtitle: Text(temp.status),
      trailing: temp.isOptimal 
        ? Icon(Icons.check_circle, color: Colors.green)
        : Icon(Icons.warning, color: Colors.orange),
    );
  }
  
  Widget _buildMoisture(MoistureCondition moisture) {
    return ListTile(
      leading: Icon(Icons.water_drop),
      title: Text('${moisture.current}%'),
      subtitle: Text(moisture.status),
      trailing: moisture.isOptimal 
        ? Icon(Icons.check_circle, color: Colors.green)
        : Icon(Icons.warning, color: Colors.orange),
    );
  }
  
  Widget _buildRisks(List<RiskFactor> risks) {
    if (risks.isEmpty) {
      return ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green),
        title: Text('Aucun risque détecté'),
      );
    }
    
    return Column(
      children: risks.map((risk) => ListTile(
        leading: Icon(Icons.warning, color: Colors.red),
        title: Text(risk.type),
        subtitle: Text('Sévérité: ${risk.severity}'),
      )).toList(),
    );
  }
}
```

### Liste de Recommandations avec Actions

```dart
class RecommendationsList extends ConsumerWidget {
  final String plantId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(
      plantRecommendationsProvider(plantId),
    );
    
    return recommendationsAsync.when(
      data: (recommendations) {
        if (recommendations.isEmpty) {
          return Center(
            child: Text('Aucune recommandation pour le moment'),
          );
        }
        
        // Trier par priorité
        final sorted = [...recommendations]
          ..sort((a, b) => _priorityValue(b.priority)
              .compareTo(_priorityValue(a.priority)));
        
        return ListView.builder(
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final rec = sorted[index];
            return RecommendationCard(
              recommendation: rec,
              onApply: () => _applyRecommendation(ref, rec),
              onDismiss: () => _dismissRecommendation(ref, rec),
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erreur: $error')),
    );
  }
  
  int _priorityValue(RecommendationPriority priority) {
    return {
      RecommendationPriority.critical: 4,
      RecommendationPriority.high: 3,
      RecommendationPriority.medium: 2,
      RecommendationPriority.low: 1,
    }[priority]!;
  }
  
  void _applyRecommendation(WidgetRef ref, Recommendation rec) {
    // Logique pour appliquer la recommandation
    ref.read(recommendationNotificationsProvider.notifier)
        .markAsApplied(rec.id);
    
    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recommandation appliquée')),
    );
  }
  
  void _dismissRecommendation(WidgetRef ref, Recommendation rec) {
    ref.read(recommendationNotificationsProvider.notifier)
        .removeRecommendation(rec.id);
  }
}

class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;
  final VoidCallback onApply;
  final VoidCallback onDismiss;
  
  const RecommendationCard({
    required this.recommendation,
    required this.onApply,
    required this.onDismiss,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: _getIconForType(recommendation.type),
            title: Text(
              recommendation.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(recommendation.description),
            trailing: _getPriorityChip(recommendation.priority),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Action recommandée:'),
                SizedBox(height: 4),
                Text(
                  recommendation.action,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 8),
                Text(
                  'Impact estimé: ${(recommendation.estimatedImpact * 100).toStringAsFixed(0)}%',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
          ButtonBar(
            children: [
              TextButton.icon(
                icon: Icon(Icons.close),
                label: Text('Ignorer'),
                onPressed: onDismiss,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.check),
                label: Text('Appliquer'),
                onPressed: onApply,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Icon _getIconForType(RecommendationType type) {
    return {
      RecommendationType.watering: Icon(Icons.water_drop, color: Colors.blue),
      RecommendationType.fertilizing: Icon(Icons.grass, color: Colors.green),
      RecommendationType.pruning: Icon(Icons.cut, color: Colors.brown),
      RecommendationType.protection: Icon(Icons.shield, color: Colors.orange),
      RecommendationType.harvesting: Icon(Icons.agriculture, color: Colors.amber),
      RecommendationType.planting: Icon(Icons.eco, color: Colors.lightGreen),
      RecommendationType.monitoring: Icon(Icons.visibility, color: Colors.purple),
    }[type] ?? Icon(Icons.info);
  }
  
  Widget _getPriorityChip(RecommendationPriority priority) {
    final config = {
      RecommendationPriority.critical: ('Critique', Colors.red),
      RecommendationPriority.high: ('Haute', Colors.orange),
      RecommendationPriority.medium: ('Moyenne', Colors.amber),
      RecommendationPriority.low: ('Basse', Colors.green),
    }[priority]!;
    
    return Chip(
      label: Text(config.$1),
      backgroundColor: config.$2.withOpacity(0.2),
    );
  }
}
```

### Dashboard Météo Intégré

```dart
class WeatherDashboard extends ConsumerWidget {
  final String gardenId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider(gardenId));
    
    return Card(
      child: weatherAsync.when(
        data: (weather) {
          if (weather == null) {
            return Text('Données météo non disponibles');
          }
          
          return Column(
            children: [
              _buildHeader(weather),
              Divider(),
              _buildDetails(weather),
              Divider(),
              _buildForecastButton(context),
            ],
          );
        },
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => Text('Erreur météo: $error'),
      ),
    );
  }
  
  Widget _buildHeader(WeatherCondition weather) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Icon(Icons.thermostat, size: 48, color: Colors.red),
              SizedBox(height: 8),
              Text(
                '${weather.currentTemperature.toStringAsFixed(1)}°C',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: [
              Icon(Icons.water_drop, size: 48, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                '${weather.humidity.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: [
              Icon(Icons.cloud, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                '${weather.cloudCover.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetails(WeatherCondition weather) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDetailRow(Icons.arrow_downward, 'Min', 
              '${weather.minTemperature.toStringAsFixed(1)}°C'),
          _buildDetailRow(Icons.arrow_upward, 'Max', 
              '${weather.maxTemperature.toStringAsFixed(1)}°C'),
          _buildDetailRow(Icons.water, 'Précipitations', 
              '${weather.precipitation.toStringAsFixed(1)} mm'),
          _buildDetailRow(Icons.air, 'Vent', 
              '${weather.windSpeed.toStringAsFixed(1)} km/h'),
          _buildDetailRow(Icons.sunny, 'UV', 
              weather.uvIndex.toStringAsFixed(1)),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Text('$label:', style: TextStyle(fontWeight: FontWeight.w500)),
          Spacer(),
          Text(value),
        ],
      ),
    );
  }
  
  Widget _buildForecastButton(BuildContext context) {
    return TextButton.icon(
      icon: Icon(Icons.calendar_today),
      label: Text('Voir les prévisions'),
      onPressed: () {
        // Navigation vers l'écran de prévisions
        context.go('/intelligence/weather-forecast');
      },
    );
  }
}
```

---

## 🎨 Composants UI Prêts à l'Emploi

### 1. Badge de Statut

```dart
Widget buildStatusBadge(ConditionStatus status) {
  final config = {
    ConditionStatus.excellent: ('Excellent', Colors.green),
    ConditionStatus.good: ('Bon', Colors.lightGreen),
    ConditionStatus.fair: ('Moyen', Colors.orange),
    ConditionStatus.poor: ('Mauvais', Colors.deepOrange),
    ConditionStatus.critical: ('Critique', Colors.red),
  }[status]!;
  
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: config.$2.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: config.$2),
    ),
    child: Text(
      config.$1,
      style: TextStyle(
        color: config.$2,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
```

### 2. Graphique de Score

```dart
Widget buildScoreIndicator(double score) {
  final color = score >= 80 ? Colors.green :
                score >= 60 ? Colors.orange :
                Colors.red;
  
  return Column(
    children: [
      CircularProgressIndicator(
        value: score / 100,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation(color),
        strokeWidth: 8,
      ),
      SizedBox(height: 8),
      Text(
        '${score.toStringAsFixed(1)}/100',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}
```

### 3. Liste de Risques

```dart
Widget buildRisksList(List<RiskFactor> risks) {
  if (risks.isEmpty) {
    return ListTile(
      leading: Icon(Icons.check_circle, color: Colors.green),
      title: Text('Aucun risque détecté'),
    );
  }
  
  return Column(
    children: risks.map((risk) {
      final severityColor = risk.severity >= 8 ? Colors.red :
                           risk.severity >= 5 ? Colors.orange :
                           Colors.amber;
      
      return ListTile(
        leading: Icon(Icons.warning, color: severityColor),
        title: Text(risk.type),
        subtitle: Text(risk.description),
        trailing: Chip(
          label: Text('${risk.severity}/10'),
          backgroundColor: severityColor.withOpacity(0.2),
        ),
      );
    }).toList(),
  );
}
```

---

## 💡 Astuces et Bonnes Pratiques

### ✅ À Faire

```dart
// ✅ Utiliser family providers avec des paramètres
final condition = ref.watch(plantConditionProvider(plantId));

// ✅ Gérer tous les états (data, loading, error)
conditionAsync.when(
  data: (data) => ...,
  loading: () => ...,
  error: (e, s) => ...,
);

// ✅ Rafraîchir les données quand nécessaire
ref.invalidate(plantConditionProvider);

// ✅ Utiliser ref.read() dans les callbacks
onPressed: () {
  ref.read(provider.notifier).doSomething();
}
```

### ❌ À Éviter

```dart
// ❌ Ne pas utiliser ref.watch() dans des callbacks
onPressed: () {
  ref.watch(provider); // ERREUR!
}

// ❌ Ne pas ignorer les erreurs
conditionAsync.when(
  data: (data) => ...,
  loading: () => ...,
  error: (e, s) => Container(), // Mauvais!
);

// ❌ Ne pas créer de providers dans build()
Widget build(BuildContext context, WidgetRef ref) {
  final provider = Provider(...); // ERREUR!
  ...
}
```

---

## 🔗 Liens Utiles

- 📖 [Guide de Déploiement Complet](DEPLOYMENT_GUIDE.md)
- 🏗️ [Architecture Détaillée](ARCHITECTURE.md)
- 🧪 [Guide des Tests](TESTING_GUIDE.md)
- 📚 [Référence API](API_REFERENCE.md)

---

**Happy Coding! 🚀🌱**

