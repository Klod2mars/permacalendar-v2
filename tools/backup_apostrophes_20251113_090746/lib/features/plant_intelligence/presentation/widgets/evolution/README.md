# 📊 Plant Evolution Widgets - Guide Rapide

**CURSOR PROMPT A8** - Widgets pour l'affichage des évolutions d'intelligence végétale

---

## 🎯 Vue d'Ensemble

Ce dossier contient les widgets pour afficher l'historique des évolutions de santé des plantes.

### Widgets Disponibles

1. **`PlantEvolutionTimeline`** - Timeline chronologique complète
2. **`PlantEvolutionCard`** - Carte compacte pour une évolution unique

---

## 🚀 Quick Start

### 1. Timeline Complète

```dart
import 'package:permacalendar/features/plant_intelligence/presentation/widgets/evolution/plant_evolution_timeline.dart';

// Utilisation basique
PlantEvolutionTimeline(
  plantId: 'tomato-001',
)

// Avec options
PlantEvolutionTimeline(
  plantId: 'tomato-001',
  showTimeFilter: true,  // Afficher les filtres temporels
  scrollPhysics: BouncingScrollPhysics(),
)
```

### 2. Carte Compacte

```dart
import 'package:permacalendar/features/plant_intelligence/presentation/widgets/evolution/plant_evolution_card.dart';

// Mode compact
PlantEvolutionCard(
  evolution: evolutionReport,
  compact: true,
  onTap: () => navigateToDetails(),
)

// Mode full
PlantEvolutionCard(
  evolution: evolutionReport,
  compact: false,
)
```

### 3. Écran Dédié

```dart
import 'package:permacalendar/features/plant_intelligence/presentation/screens/plant_evolution_history_screen.dart';

// Navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PlantEvolutionHistoryScreen(
      plantId: 'tomato-001',
      plantName: 'Tomate Cerise',
    ),
  ),
);
```

---

## 📦 Providers Disponibles

```dart
import 'package:permacalendar/features/plant_intelligence/presentation/providers/plant_evolution_providers.dart';

// Historique complet
final evolutions = ref.watch(plantEvolutionHistoryProvider('plantId'));

// Historique filtré
final filtered = ref.watch(
  filteredEvolutionHistoryProvider(
    FilterParams(plantId: 'plantId', days: 30),
  ),
);

// Dernière évolution uniquement
final latest = ref.watch(latestEvolutionProvider('plantId'));

// Période sélectionnée (StateProvider)
final period = ref.watch(selectedTimePeriodProvider);
ref.read(selectedTimePeriodProvider.notifier).state = 90;
```

---

## 🎨 États Gérés

### ✅ État Vide (Empty)
- Affiché quand aucune évolution n'existe
- Message encourageant pour première utilisation

### ⏳ État Loading
- CircularProgressIndicator pendant le chargement
- Message "Chargement de l'historique..."

### ❌ État Erreur (Error)
- Icône d'erreur rouge
- Message explicatif
- Détails de l'erreur affichés

### 📊 État Data
- Timeline avec toutes les évolutions
- Filtres temporels
- Statistiques

---

## 🎯 Exemples d'Intégration

### Dans un Onglet

```dart
DefaultTabController(
  length: 2,
  child: Scaffold(
    appBar: AppBar(
      bottom: TabBar(
        tabs: [
          Tab(text: 'Intelligence'),
          Tab(text: 'Évolutions'),
        ],
      ),
    ),
    body: TabBarView(
      children: [
        IntelligenceView(...),
        PlantEvolutionTimeline(plantId: plantId),
      ],
    ),
  ),
)
```

### Dans un Dashboard

```dart
class DashboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref.watch(latestEvolutionProvider(plantId));

    return latest.when(
      data: (evolution) {
        if (evolution == null) return SizedBox.shrink();
        
        return PlantEvolutionCard(
          evolution: evolution,
          compact: true,
          onTap: () => navigateToFullHistory(),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (_, __) => ErrorWidget(),
    );
  }
}
```

### Avec Filtres Personnalisés

```dart
class CustomFilteredView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Définir la période
    ref.read(selectedTimePeriodProvider.notifier).state = 30;
    
    // Le widget utilisera automatiquement le filtre
    return PlantEvolutionTimeline(
      plantId: plantId,
      showTimeFilter: true,
    );
  }
}
```

---

## 🧪 Tests

Les tests sont disponibles dans :
```
test/features/plant_intelligence/presentation/widgets/plant_evolution_timeline_test.dart
```

Exécution :
```bash
flutter test test/features/plant_intelligence/presentation/widgets/plant_evolution_timeline_test.dart
```

---

## 📚 Documentation Complète

Voir **`RAPPORT_IMPLEMENTATION_A8_EVOLUTION_UI.md`** pour :
- Architecture détaillée
- Diagrammes de flux
- Guide de personnalisation
- Métriques et performance
- Évolutions futures

---

## 🔗 Dépendances

- `flutter_riverpod`: State management
- `intl`: Formatage des dates
- `IAnalyticsRepository`: Récupération des données
- `PlantEvolutionReport`: Entity affichée

---

## 💡 Conseils

### Performance
- Utilisez `const` quand possible
- Le cache Riverpod évite les requêtes répétées
- Auto-dispose nettoie automatiquement

### Personnalisation
- Utilisez `ThemeData` pour les couleurs
- Overridez les méthodes pour personnaliser
- Créez vos propres filtres via providers

### Maintenance
- Les providers sont auto-dispose
- Pas d'écriture Hive, uniquement lecture
- Gestion défensive des erreurs

---

**Auteur:** Cursor AI Assistant  
**Date:** 2025-10-12  
**Version:** 1.0  
**Prompt:** CURSOR PROMPT A8


