# 🌱 Plant Evolution Tracker Service - Guide d'Utilisation

## 📋 Vue d'Ensemble

Le `PlantEvolutionTrackerService` est un service de domaine pur qui compare deux rapports d'intelligence végétale (`PlantIntelligenceReport`) et génère un rapport d'évolution structuré (`PlantEvolutionReport`).

**Objectif:** Suivre la progression, la régression ou la stabilité de la santé des plantes au fil du temps.

---

## 🚀 Démarrage Rapide

### Import

```dart
import 'package:permacalendar/features/plant_intelligence/domain/services/plant_evolution_tracker_service.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_evolution_report.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
```

### Utilisation Basique

```dart
// 1. Créer une instance du tracker
final tracker = PlantEvolutionTrackerService();

// 2. Comparer deux rapports
final evolution = tracker.compareReports(
  previous: previousReport,
  current: currentReport,
);

// 3. Analyser les résultats
if (evolution.hasImproved) {
  print('🎉 Plante en amélioration!');
  print('Score: ${evolution.deltaScore.toStringAsFixed(1)} points');
} else if (evolution.hasDegraded) {
  print('⚠️ Plante en dégradation');
  print('Conditions dégradées: ${evolution.degradedConditions}');
} else {
  print('➡️ Plante stable');
}
```

---

## 🎨 Cas d'Usage

### 1. Suivi de l'Amélioration d'une Plante

```dart
final tracker = PlantEvolutionTrackerService();

// Rapport de la semaine dernière
final lastWeekReport = PlantIntelligenceReport(
  id: 'report_1',
  plantId: 'tomato_123',
  plantName: 'Tomate Cerise',
  intelligenceScore: 62.0, // Score faible
  analysis: analysisWithPoorConditions,
  // ...
);

// Rapport d'aujourd'hui
final todayReport = PlantIntelligenceReport(
  id: 'report_2',
  plantId: 'tomato_123',
  plantName: 'Tomate Cerise',
  intelligenceScore: 78.0, // Score amélioré
  analysis: analysisWithGoodConditions,
  // ...
);

// Comparer
final evolution = tracker.compareReports(
  previous: lastWeekReport,
  current: todayReport,
);

// Afficher les résultats
print('📊 Évolution sur 7 jours:');
print('  - Trend: ${evolution.trend}'); // "up"
print('  - Delta: +${evolution.deltaScore} points'); // +16.0
print('  - Améliorations: ${evolution.improvedConditions}');
// Output: ['humidity', 'temperature']
print('  - ${evolution.description}');
// Output: "📈 Amélioration : +16.0 points | 2 condition(s) améliorée(s)"
```

### 2. Détection de Dégradation

```dart
final evolution = tracker.compareReports(
  previous: healthyReport,    // Score: 85
  current: degradedReport,    // Score: 58
);

if (evolution.hasDegraded) {
  // Alerter l'utilisateur
  showAlert(
    title: 'Attention!',
    message: evolution.description,
    severity: AlertSeverity.warning,
  );
  
  // Identifier les conditions problématiques
  for (final condition in evolution.degradedConditions) {
    print('⚠️ $condition nécessite attention');
  }
  
  // Recommander des actions
  if (evolution.degradedConditions.contains('humidity')) {
    print('💧 Augmenter l\'arrosage');
  }
  if (evolution.degradedConditions.contains('light')) {
    print('☀️ Déplacer vers un endroit plus lumineux');
  }
}
```

### 3. Tableau de Bord d'Évolution

```dart
Widget buildEvolutionCard(PlantEvolutionReport evolution) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre avec emoji
          Text(
            evolution.hasImproved ? '📈 En Amélioration'
            : evolution.hasDegraded ? '📉 En Dégradation'
            : '➡️ Stable',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          SizedBox(height: 8),
          
          // Delta de score
          Text(
            'Score: ${evolution.previousScore.toInt()} → ${evolution.currentScore.toInt()}',
          ),
          
          Text(
            'Delta: ${evolution.deltaScore > 0 ? '+' : ''}${evolution.deltaScore.toStringAsFixed(1)} points',
            style: TextStyle(
              color: evolution.hasImproved ? Colors.green
                   : evolution.hasDegraded ? Colors.red
                   : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(height: 16),
          
          // Conditions améliorées
          if (evolution.improvedConditions.isNotEmpty) ...[
            Text('✅ Améliorations:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...evolution.improvedConditions.map((c) => Text('  • $c')),
          ],
          
          // Conditions dégradées
          if (evolution.degradedConditions.isNotEmpty) ...[
            SizedBox(height: 8),
            Text('⚠️ Dégradations:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...evolution.degradedConditions.map((c) => Text('  • $c')),
          ],
          
          SizedBox(height: 16),
          
          // Durée
          Text(
            'Mesuré il y a ${_formatDuration(evolution.timeBetweenReports)}',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}
```

### 4. Graphique de Progression

```dart
class PlantProgressChart extends StatelessWidget {
  final List<PlantEvolutionReport> evolutionHistory;
  
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        spots: evolutionHistory.asMap().entries.map((entry) {
          return FlSpot(
            entry.key.toDouble(),
            entry.value.currentScore,
          );
        }).toList(),
        
        // Colorier selon la tendance
        lineBarsData: [
          LineChartBarData(
            spots: /* ... */,
            color: _getTrendColor(evolutionHistory.last),
            isCurved: true,
          ),
        ],
      ),
    );
  }
  
  Color _getTrendColor(PlantEvolutionReport evolution) {
    if (evolution.hasImproved) return Colors.green;
    if (evolution.hasDegraded) return Colors.red;
    return Colors.orange;
  }
}
```

### 5. Configuration Personnalisée

```dart
// Seuil de stabilité plus élevé (pour plantes résistantes)
final tolerantTracker = PlantEvolutionTrackerService(
  stabilityThreshold: 5.0, // ±5 points considérés comme stable
  enableLogging: true, // Activer les logs pour debug
);

final evolution = tolerantTracker.compareReports(
  previous: previousReport, // Score: 70
  current: currentReport,   // Score: 73 (+3)
);

print(evolution.trend); // "stable" car +3 < 5.0

// Seuil de stabilité strict (pour plantes fragiles)
final strictTracker = PlantEvolutionTrackerService(
  stabilityThreshold: 0.5, // ±0.5 points
  enableLogging: false,
);

final strictEvolution = strictTracker.compareReports(
  previous: previousReport, // Score: 70
  current: currentReport,   // Score: 70.6 (+0.6)
);

print(strictEvolution.trend); // "up" car +0.6 > 0.5
```

### 6. Notification Intelligente

```dart
void checkAndNotify(PlantEvolutionReport evolution) {
  // Ne notifier que si changement significatif
  if (evolution.trend == 'stable') {
    return; // Pas de notification pour les changements mineurs
  }
  
  // Calculer le niveau de priorité
  final priority = _calculateNotificationPriority(evolution);
  
  // Construire le message
  final message = evolution.hasDegraded
      ? '⚠️ ${evolution.plantId} nécessite attention: ${evolution.description}'
      : '🎉 ${evolution.plantId} s\'améliore: ${evolution.description}';
  
  // Envoyer la notification
  NotificationService.send(
    title: evolution.hasDegraded ? 'Plante en Difficulté' : 'Progrès de Plante',
    body: message,
    priority: priority,
    data: {
      'plantId': evolution.plantId,
      'trend': evolution.trend,
      'deltaScore': evolution.deltaScore,
    },
  );
}

NotificationPriority _calculateNotificationPriority(PlantEvolutionReport evolution) {
  if (evolution.degradationRate >= 75) {
    return NotificationPriority.critical; // 75%+ de conditions dégradées
  }
  if (evolution.deltaScore.abs() > 20) {
    return NotificationPriority.high; // Changement > 20 points
  }
  return NotificationPriority.medium;
}
```

### 7. Historique d'Évolution

```dart
class PlantEvolutionHistory {
  final String plantId;
  final List<PlantIntelligenceReport> reports;
  final PlantEvolutionTrackerService tracker;
  
  PlantEvolutionHistory({
    required this.plantId,
    required this.reports,
  }) : tracker = PlantEvolutionTrackerService();
  
  /// Génère l'historique d'évolution complet
  List<PlantEvolutionReport> generateHistory() {
    final history = <PlantEvolutionReport>[];
    
    // Trier les rapports par date
    final sortedReports = [...reports]
      ..sort((a, b) => a.generatedAt.compareTo(b.generatedAt));
    
    // Comparer chaque paire successive
    for (int i = 1; i < sortedReports.length; i++) {
      final evolution = tracker.compareReports(
        previous: sortedReports[i - 1],
        current: sortedReports[i],
      );
      history.add(evolution);
    }
    
    return history;
  }
  
  /// Calcule la tendance globale
  String getOverallTrend() {
    final history = generateHistory();
    
    if (history.isEmpty) return 'unknown';
    
    final improvements = history.where((e) => e.hasImproved).length;
    final degradations = history.where((e) => e.hasDegraded).length;
    
    if (improvements > degradations * 1.5) {
      return 'improving';
    } else if (degradations > improvements * 1.5) {
      return 'degrading';
    } else {
      return 'fluctuating';
    }
  }
  
  /// Trouve la période de plus grande amélioration
  PlantEvolutionReport? getBestImprovement() {
    final history = generateHistory();
    
    if (history.isEmpty) return null;
    
    return history.reduce((best, current) {
      return current.deltaScore > best.deltaScore ? current : best;
    });
  }
}
```

---

## 📊 Interprétation des Résultats

### Trend Values

| Trend      | Signification                    | Action Recommandée              |
|------------|----------------------------------|---------------------------------|
| `"up"`     | Amélioration (delta > +1.0)      | Continuer les soins actuels     |
| `"stable"` | Stable (delta entre -1.0 et +1.0)| Maintenir la routine            |
| `"down"`   | Dégradation (delta < -1.0)       | Intervenir rapidement           |

### Condition Changes

```dart
// Accéder aux changements de conditions
final improved = evolution.improvedConditions;    // ['temperature', 'light']
final degraded = evolution.degradedConditions;    // ['humidity']
final unchanged = evolution.unchangedConditions;  // ['soil']

// Calculer les taux
print('Taux d\'amélioration: ${evolution.improvementRate}%'); // 50%
print('Taux de dégradation: ${evolution.degradationRate}%');  // 25%

// Vérifier s'il y a des changements
if (evolution.hasConditionChanges) {
  print('Des conditions ont changé');
}
```

### Extension Methods

```dart
// Méthodes de commodité
evolution.hasImproved;        // bool: true si trend == 'up'
evolution.hasDegraded;        // bool: true si trend == 'down'
evolution.isStable;           // bool: true si trend == 'stable'

// Description lisible
evolution.description;        // String: "📈 Amélioration : +15.0 points | 2 condition(s) améliorée(s)"

// Durée entre rapports
evolution.timeBetweenReports; // Duration: 7 jours

// Métriques
evolution.totalConditions;    // int: 4 (temperature, humidity, light, soil)
evolution.improvementRate;    // double: 50.0 (%)
evolution.degradationRate;    // double: 25.0 (%)
```

---

## ⚠️ Gestion des Erreurs

### 1. Plantes Différentes

```dart
try {
  final evolution = tracker.compareReports(
    previous: tomatoReport,
    current: pepperReport, // ❌ Différente plante
  );
} catch (e) {
  if (e is ArgumentError) {
    print('Erreur: ${e.message}');
    // "Cannot compare reports for different plants: tomato_1 vs pepper_1"
  }
}
```

### 2. Validation Préalable

```dart
bool canCompare(
  PlantIntelligenceReport a,
  PlantIntelligenceReport b,
) {
  return a.plantId == b.plantId;
}

if (canCompare(previousReport, currentReport)) {
  final evolution = tracker.compareReports(
    previous: previousReport,
    current: currentReport,
  );
} else {
  print('Les rapports ne concernent pas la même plante');
}
```

---

## 🧪 Tests

### Exemple de Test

```dart
test('should detect improvement when score increases', () {
  final tracker = PlantEvolutionTrackerService();
  
  final previousReport = createMockReport(
    plantId: 'tomato_1',
    score: 60.0,
  );
  
  final currentReport = createMockReport(
    plantId: 'tomato_1',
    score: 75.0,
  );
  
  final evolution = tracker.compareReports(
    previous: previousReport,
    current: currentReport,
  );
  
  expect(evolution.trend, 'up');
  expect(evolution.deltaScore, 15.0);
  expect(evolution.hasImproved, isTrue);
});
```

---

## 🔗 Intégration avec l'Orchestrateur

Le service sera utilisé dans `PlantIntelligenceOrchestrator` (Prompt A6):

```dart
class PlantIntelligenceOrchestrator {
  final PlantEvolutionTrackerService evolutionTracker;
  
  PlantIntelligenceOrchestrator({
    PlantEvolutionTrackerService? evolutionTracker,
  }) : evolutionTracker = evolutionTracker ?? PlantEvolutionTrackerService();
  
  Future<PlantEvolutionReport?> getEvolutionSinceLastReport(String plantId) async {
    final previousReport = await _getPreviousReport(plantId);
    final currentReport = await _getCurrentReport(plantId);
    
    if (previousReport == null || currentReport == null) {
      return null;
    }
    
    return evolutionTracker.compareReports(
      previous: previousReport,
      current: currentReport,
    );
  }
}
```

---

## 💡 Conseils d'Utilisation

### ✅ Bonnes Pratiques

1. **Comparer des rapports proches dans le temps** (quelques jours à quelques semaines)
2. **Vérifier `canCompare` avant la comparaison**
3. **Utiliser les extensions pour un code plus lisible**
4. **Adapter le seuil selon le type de plante**
5. **Conserver un historique pour tendances à long terme**

### ❌ À Éviter

1. ❌ Comparer des rapports de plantes différentes
2. ❌ Comparer des rapports trop éloignés dans le temps (> 1 mois)
3. ❌ Ignorer les `degradedConditions` critiques
4. ❌ Utiliser un seuil trop élevé (masque les problèmes)
5. ❌ Comparer avec des rapports expirés

---

## 📚 Ressources

- **Modèle:** `PlantEvolutionReport` - Structure du rapport d'évolution
- **Service:** `PlantEvolutionTrackerService` - Logique de comparaison
- **Tests:** `plant_evolution_tracker_service_test.dart` - 14 tests complets
- **Rapport:** `RAPPORT_IMPLEMENTATION_A5_PLANT_EVOLUTION_TRACKER.md` - Documentation complète

---

**Auteur:** Cursor Prompt A5  
**Date:** 12 octobre 2025  
**Version:** 1.0.0

