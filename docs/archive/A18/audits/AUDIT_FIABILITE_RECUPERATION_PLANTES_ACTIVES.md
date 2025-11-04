# 🧠 Audit Ciblé : Fiabilité de la récupération des plantes actives + cohérence de l'analyse

**Date :** 12 octobre 2025  
**Tag :** `assainissement-intelligence/audit-plantes-actives`  
**Scope :** Pipeline complet d'analyse végétale depuis la récupération jusqu'à l'affichage  

---

## 📊 Résumé Exécutif

| Critère | État | Note |
|---------|------|------|
| Récupération des plantes actives | ✅ Fiable | 9/10 |
| Nettoyage des conditions orphelines | ⚠️ Partiel | 5/10 |
| Gestion du cache | ⚠️ À améliorer | 6/10 |
| Logs de diagnostic | ✅ Excellent | 9/10 |

**Verdict Global :** Le pipeline est **globalement fiable** mais présente des **risques de désynchronisation** liés au cache et au nettoyage incomplet des données orphelines.

---

## 🔍 1. RÉCUPÉRATION DES PLANTES ACTIVES

### Architecture du flux de récupération

```
PlantIntelligenceOrchestrator.generateGardenIntelligenceReport()
    ↓
IGardenContextRepository.getGardenPlants(gardenId)
    ↓
PlantIntelligenceRepositoryImpl.getGardenPlants(gardenId)
    ↓
GardenAggregationHub.getActivePlants(gardenId)
    ↓
ModernDataAdapter.getActivePlants(gardenId)  [Priorité 3]
    ↓
GardenBoxes (Sanctuaire Hive) - Source de vérité
```

### 📦 Méthode responsable

**Fichier :** `lib/core/services/aggregation/modern_data_adapter.dart`  
**Lignes :** 126-201

```dart
Future<List<UnifiedPlantData>> getActivePlants(String gardenId) async {
  // ✅ ÉTAPE 1 : Récupérer le jardin spécifique depuis le Sanctuaire
  final garden = GardenBoxes.getGarden(gardenId);
  
  // ✅ ÉTAPE 2 : Récupérer les parcelles du jardin depuis le Sanctuaire
  final beds = GardenBoxes.getGardenBeds(gardenId);
  
  // ✅ ÉTAPE 3 : Extraire les IDs des plantes ACTIVES uniquement
  final activePlantIds = <String>{};
  for (final bed in beds) {
    final plantings = GardenBoxes.getPlantings(bed.id);
    for (final planting in plantings.where((p) => p.isActive)) {
      activePlantIds.add(planting.plantId);
    }
  }
  
  // ✅ ÉTAPE 4 : Enrichir depuis le catalogue (PlantHiveRepository)
  for (final plantId in activePlantIds) {
    final plant = await _plantRepository.getPlantById(plantId);
    if (plant != null) {
      plants.add(_convertToUnified(plant, garden));
    }
  }
  
  return plants;
}
```

### ✅ Points forts

1. **Source de vérité unique :** Les plantes actives sont récupérées directement depuis `GardenBoxes` (Hive Sanctuaire)
2. **Filtrage robuste :** Le filtre `planting.isActive` est appliqué à la source
3. **Logs exhaustifs :** Chaque étape est tracée avec des emojis clairs (🌱, 📦, ✅, ⚠️)
4. **Gestion d'erreurs défensive :** Retour d'une liste vide en cas d'échec, permettant le fallback vers `LegacyDataAdapter`
5. **Déduplication automatique :** Utilisation d'un `Set<String>` pour éliminer les doublons

### ⚠️ Risques identifiés

#### Risque 1 : Désynchronisation entre le GardenContext et les plantations

**Emplacement :** `PlantIntelligenceRepositoryImpl.getGardenContext()` (ligne 475-502)

```dart
Future<GardenContext?> getGardenContext(String gardenId) async {
  // 🔥 CORRECTION CRITIQUE : TOUJOURS synchroniser avec la source de vérité
  var context = await _syncGardenContextWithPlantings(gardenId);
  return context;
}
```

**Analyse :**  
- La synchronisation se fait via `_syncGardenContextWithPlantings()` qui récupère les plantations depuis Hive
- Cependant, `getGardenPlants()` ne réutilise PAS cette liste synchronisée, elle refait un appel au hub
- **Risque de race condition :** Si une plantation est créée entre les deux appels, les listes peuvent diverger

**Impact :** Faible (fenêtre temporelle étroite) mais possible

#### Risque 2 : Plantes manquantes dans le catalogue

**Emplacement :** `modern_data_adapter.dart` ligne 171-180

```dart
final plant = await _plantRepository.getPlantById(plantId);
if (plant != null) {
  plants.add(_convertToUnified(plant, garden));
} else {
  developer.log(
    '⚠️ Plante $plantId présente dans Sanctuaire mais absente du catalogue',
    level: 800,
  );
}
```

**Analyse :**  
- Si une plantation référence un `plantId` qui n'existe pas dans `plants.json`, la plante est **ignorée silencieusement**
- Log de niveau 800 (warning) mais **pas d'exception**
- La boucle d'analyse dans l'orchestrateur va **échouer** pour cette plante

**Impact :** Moyen - Une plante peut être invisible dans l'UI sans erreur visible

### 🎯 Testabilité

**État :** ✅ Excellent

- Repository mockable (`IGardenContextRepository`)
- Entrée : `gardenId` (String)
- Sortie : `List<PlantFreezed>` déterministe
- Pas de dépendances statiques difficiles à mocker dans la couche repository

**Test suggéré :**
```dart
test('getGardenPlants retourne toutes les plantes actives', () async {
  // Arrange
  final mockHub = MockGardenAggregationHub();
  when(mockHub.getActivePlants(any)).thenAnswer((_) async => [
    mockPlant('spinach'),
    mockPlant('tomato'),
  ]);
  
  // Act
  final plants = await repository.getGardenPlants(testGardenId);
  
  // Assert
  expect(plants.length, 2);
  expect(plants.map((p) => p.id), containsAll(['spinach', 'tomato']));
});
```

---

## 🧹 2. NETTOYAGE DES CONDITIONS ORPHELINES

### État actuel

#### Nettoyage dans le State Provider (Mémoire uniquement)

**Emplacement :** `intelligence_state_providers.dart` ligne 474-492

```dart
Future<void> initializeForGarden(String gardenId) async {
  // 🔥 NOUVEAU : Nettoyer les anciennes plantConditions qui ne sont plus actives
  final cleanedConditions = <String, PlantCondition>{};
  final cleanedRecommendations = <String, List<Recommendation>>{};
  
  // Garder seulement les conditions des plantes encore actives
  for (final plantId in activePlants) {
    if (state.plantConditions.containsKey(plantId)) {
      cleanedConditions[plantId] = state.plantConditions[plantId]!;
    }
    if (state.plantRecommendations.containsKey(plantId)) {
      cleanedRecommendations[plantId] = state.plantRecommendations[plantId]!;
    }
  }
  
  final removedConditions = state.plantConditions.length - cleanedConditions.length;
  if (removedConditions > 0) {
    developer.log('🧹 NETTOYAGE - $removedConditions condition(s) orpheline(s) supprimée(s)');
  }
}
```

**Verdict :** ✅ Le nettoyage mémoire fonctionne correctement

#### ❌ PROBLÈME CRITIQUE : Pas de nettoyage dans Hive

**Analyse :**
1. Les `PlantCondition` sont stockées dans la box Hive `plant_conditions`
2. Lors de `initializeForGarden()`, le nettoyage ne s'applique qu'au `state` (mémoire)
3. Les entrées orphelines **restent en base Hive indéfiniment**
4. Au fil du temps, la box `plant_conditions` accumule des données obsolètes

**Preuve :**  
Fichier `plant_intelligence_local_datasource.dart` ligne 312-315
```dart
Future<void> savePlantCondition(PlantCondition condition) async {
  final box = await _plantConditionsBox;
  await box.put(condition.id, condition);  // ❌ Jamais de suppression des anciennes entrées
}
```

**Impact :**
- 🔴 **Croissance illimitée de la base de données** (fuite de mémoire disque)
- 🟡 **Dégradation progressive des performances** (filtrage sur une box de plus en plus grande)
- 🔴 **Risque de confusion** si une plante supprimée est recréée avec le même ID

### ⚠️ Absence de mécanisme de purge

**Recherche effectuée :**
```bash
grep -r "deletePlantCondition\|cleanOrphaned\|purge" lib/features/plant_intelligence/
```

**Résultat :** Aucun mécanisme de purge automatique trouvé

### 📝 Recommandation : Mécanisme de nettoyage idempotent

#### Solution proposée

**Emplacement :** Ajouter dans `IntelligenceStateNotifier.initializeForGarden()`

```dart
Future<void> _cleanOrphanedConditionsInHive(List<String> activePlantIds) async {
  try {
    developer.log('🧹 NETTOYAGE HIVE - Début purge conditions orphelines', 
      name: 'IntelligenceStateNotifier');
    
    // Récupérer le datasource pour accès direct à Hive
    final datasource = _ref.read(IntelligenceModule.localDataSourceProvider);
    
    // Récupérer toutes les conditions en base
    final box = await Hive.openBox<PlantCondition>('plant_conditions');
    final allConditions = box.values.toList();
    
    // Identifier les orphelines (plantId non présent dans activePlantIds)
    final orphanedIds = <String>[];
    for (final condition in allConditions) {
      if (!activePlantIds.contains(condition.plantId)) {
        orphanedIds.add(condition.id);
      }
    }
    
    // Supprimer les orphelines (opération idempotente)
    for (final conditionId in orphanedIds) {
      await datasource.deletePlantCondition(conditionId);
    }
    
    developer.log('✅ NETTOYAGE HIVE - ${orphanedIds.length} condition(s) orpheline(s) purgée(s)', 
      name: 'IntelligenceStateNotifier');
    
  } catch (e, stackTrace) {
    developer.log('❌ NETTOYAGE HIVE - Erreur non bloquante: $e', 
      name: 'IntelligenceStateNotifier', 
      level: 900);
    // Ne pas bloquer l'initialisation si le nettoyage échoue
  }
}
```

**Intégration :**
```dart
Future<void> initializeForGarden(String gardenId) async {
  // ... code existant ...
  
  // 🧹 Nettoyer les conditions orphelines en base (après le nettoyage mémoire)
  await _cleanOrphanedConditionsInHive(activePlants);
  
  // ... suite du code ...
}
```

**Propriétés :**
- ✅ **Idempotent :** Peut être appelé plusieurs fois sans effet de bord
- ✅ **Safe :** Erreurs capturées, ne bloque pas l'initialisation
- ✅ **Auditable :** Logs clairs avec nombre d'entrées supprimées
- ✅ **Testable :** Logique isolée dans une méthode privée

---

## 💾 3. USAGE DU CACHE

### Architecture du cache

Le système utilise **deux niveaux de cache** :

1. **Cache Repository (30 minutes)** - `PlantIntelligenceRepositoryImpl`
2. **Cache Hub (10 minutes)** - `GardenAggregationHub`

### Analyse détaillée

#### Cache Repository

**Emplacement :** `plant_intelligence_repository_impl.dart` ligne 95-125

```dart
Future<PlantCondition?> getCurrentPlantCondition(String plantId) async {
  final cacheKey = 'current_condition_$plantId';
  
  // ❌ PROBLÈME : Cache vérifié avant la récupération
  if (_isCacheValid(cacheKey)) {
    return _cache[cacheKey];  // Peut retourner des données périmées
  }
  
  final condition = await _localDataSource.getCurrentPlantCondition(plantId);
  
  _cache[cacheKey] = condition;
  _cache['${cacheKey}_timestamp'] = DateTime.now();
  
  return condition;
}
```

**Durée de validité :** 30 minutes (`_cacheValidityDuration`)

#### Cache Hub

**Emplacement :** `garden_aggregation_hub.dart` ligne 196-240

```dart
Future<List<UnifiedPlantData>> getActivePlants(String gardenId) async {
  final cacheKey = 'active_plants_$gardenId';
  
  // ❌ PROBLÈME : Cache vérifié avant la récupération
  if (_isCacheValid(cacheKey)) {
    return _cache[cacheKey];
  }
  
  // Stratégie de résolution : essayer chaque adaptateur
  for (final adapter in _adapters) {
    final plants = await adapter.getActivePlants(gardenId);
    if (plants.isNotEmpty) {
      _cache[cacheKey] = plants;
      _cache['${cacheKey}_timestamp'] = DateTime.now();
      return plants;
    }
  }
  
  return [];
}
```

**Durée de validité :** 10 minutes

### ❌ Problèmes identifiés

#### 1. Absence d'invalidation lors d'une analyse manuelle

**Scénario problématique :**
```
1. Utilisateur ouvre l'UI → Cache rempli avec les plantes actives
2. Utilisateur ajoute une nouvelle plantation "carrot" via l'UI Plantings
3. Utilisateur déclenche une analyse manuelle → ❌ Cache retourné (liste obsolète)
4. "carrot" n'est PAS analysée → UI incomplète
```

**Emplacement du déclenchement manuel :**  
`plant_intelligence_dashboard_screen.dart` - Bouton "Rafraîchir l'analyse"

```dart
onPressed: () async {
  await ref.read(intelligenceStateProvider.notifier)
      .initializeForGarden(gardenId);
}
```

**Analyse :** `initializeForGarden()` **ne force PAS** le rafraîchissement du cache Hub

#### 2. Cache peut masquer des échecs silencieux

**Scénario :**
```
1. Analyse initiale réussie → Cache rempli
2. Plante "spinach" supprimée du jardin
3. Analyse déclenchée → Échec pour "spinach" (plante introuvable)
4. getCurrentPlantCondition("spinach") → ❌ Retourne l'ancien cache (données périmées)
5. UI affiche un statut obsolète pour "spinach"
```

**Impact :** L'utilisateur voit des données incorrectes sans indication d'erreur

### 🔍 Base vierge : Retour explicite

**Test effectué :**
```dart
// Première initialisation (aucune analyse précédente)
await notifier.initializeForGarden(gardenId);
```

**Résultat attendu :** `state.plantConditions` doit être **vide** si aucune analyse n'a été faite

**Code actuel :**
```dart
// intelligence_state_providers.dart ligne 509-521
for (final plantId in activePlants) {
  try {
    await analyzePlant(plantId);  // Génère une analyse pour chaque plante
  } catch (e) {
    // Continue avec les autres plantes
  }
}
```

**Verdict :** ✅ Si aucune analyse n'a été faite, `plantConditions` sera vide, ce qui est correct

**UI correspondante :**  
`plant_intelligence_dashboard_screen.dart` vérifie `state.plantConditions.isEmpty` et affiche "Aucune analyse disponible"

### 📝 Recommandations

#### 1. Invalider le cache lors d'une analyse manuelle

```dart
Future<void> initializeForGarden(String gardenId) async {
  developer.log('🔄 INVALIDATION CACHE - Forcer rafraîchissement complet', 
    name: 'IntelligenceStateNotifier');
  
  // 🔥 NOUVEAU : Invalider le cache du hub pour forcer la récupération fraîche
  final hub = _ref.read(IntelligenceModule.aggregationHubProvider);
  hub.invalidateCache('active_plants_$gardenId');
  hub.invalidateCache('garden_context_$gardenId');
  
  // 🔥 NOUVEAU : Invalider le cache du repository
  final repo = _ref.read(plantIntelligenceRepositoryProvider);
  await repo.clearCache();
  
  // ... reste du code existant ...
}
```

#### 2. Ajouter une méthode `invalidateCache()` au Hub

**Fichier :** `garden_aggregation_hub.dart`

```dart
/// Invalide une entrée du cache pour forcer le rafraîchissement
void invalidateCache(String cacheKey) {
  _cache.remove(cacheKey);
  _cache.remove('${cacheKey}_timestamp');
  
  developer.log(
    '🗑️ Cache invalidé: $cacheKey',
    name: _logName,
    level: 500,
  );
}

/// Invalide tout le cache (utile pour les analyses manuelles)
void invalidateAllCache() {
  final keysCount = _cache.length ~/ 2; // Diviser par 2 car on a key + timestamp
  _cache.clear();
  
  developer.log(
    '🗑️ Cache complet invalidé ($keysCount entrées)',
    name: _logName,
    level: 500,
  );
}
```

#### 3. Ajouter un indicateur visuel de fraîcheur des données

**UI suggestion :**
```dart
// Afficher l'âge du cache dans l'UI
Text('Dernière analyse: ${_formatAge(state.lastAnalysis)}')
```

---

## 📝 4. LOGS DE DIAGNOSTIC

### ✅ Qualité des logs : Excellent

#### Convention claire et cohérente

| Emoji | Signification | Niveau |
|-------|---------------|--------|
| 🔍 | Diagnostic/Debug | 500 |
| ✅ | Succès | 500 |
| ❌ | Erreur critique | 1000 |
| ⚠️ | Avertissement | 900 |
| 🔬 | Analyse en cours | 500 |
| 🔄 | Synchronisation | 500 |
| 🧹 | Nettoyage | 500 |
| 🌱 | Plantes | 500 |

### Traçabilité complète dans la boucle d'analyse

**Emplacement :** `plant_intelligence_orchestrator.dart` ligne 225-278

```dart
Future<List<PlantIntelligenceReport>> generateGardenIntelligenceReport({
  required String gardenId,
}) async {
  developer.log(
    'Génération rapport intelligence pour jardin $gardenId',
    name: 'PlantIntelligenceOrchestrator',
  );
  
  final plants = await _gardenRepository.getGardenPlants(gardenId);
  
  developer.log(
    '${plants.length} plantes à analyser',
    name: 'PlantIntelligenceOrchestrator',
  );
  
  final reports = <PlantIntelligenceReport>[];
  
  for (final plant in plants) {
    try {
      final report = await generateIntelligenceReport(
        plantId: plant.id,
        gardenId: gardenId,
        plant: plant,
      );
      reports.add(report);
    } catch (e) {
      developer.log(
        'Erreur génération rapport pour plante ${plant.id}: $e',
        name: 'PlantIntelligenceOrchestrator',
        level: 900,  // ✅ Erreur loggée mais non bloquante
      );
    }
  }
  
  developer.log(
    '${reports.length}/${plants.length} rapports générés',
    name: 'PlantIntelligenceOrchestrator',
  );
  
  return reports;
}
```

### ✅ Points forts

1. **Logs avant/après chaque opération** : Permet de tracer le flux complet
2. **Gestion d'erreurs individuelles** : Si une plante échoue, les autres continuent
3. **Compteurs de progression** : `${reports.length}/${plants.length}`
4. **Niveaux appropriés** : 500 (info), 900 (warning), 1000 (error)
5. **Logs dans _getPlant()** : Diagnostiquer les problèmes de catalogue

### Exemple de logs pour une analyse complète

```
[PlantIntelligenceOrchestrator] Génération rapport intelligence pour jardin garden-001
[GardenAggregationHub] 🔍 Hub: Récupération contexte unifié pour jardin garden-001
[ModernDataAdapter] 🌱 Récupération plantes ACTIVES pour jardin: garden-001
[ModernDataAdapter] 📦 3 parcelle(s) trouvée(s) pour jardin garden-001
[ModernDataAdapter] ✅ 5 plante(s) ACTIVE(s) identifiée(s) dans le Sanctuaire
[ModernDataAdapter] ✅ 5 plante(s) enrichie(s) retournée(s)
[PlantIntelligenceOrchestrator] 5 plantes à analyser
[PlantIntelligenceOrchestrator] Génération rapport intelligence pour plante spinach
[PlantIntelligenceOrchestrator] 🔍 Recherche de la plante "spinach"
[PlantIntelligenceOrchestrator] 📚 Catalogue chargé: 50 plantes disponibles
[PlantIntelligenceOrchestrator] ✅ Plante trouvée: "Spinach" (Spinacia oleracea)
[PlantIntelligenceOrchestrator] Analyse des conditions...
[PlantIntelligenceOrchestrator] Évaluation timing plantation...
[PlantIntelligenceOrchestrator] Génération recommandations...
[PlantIntelligenceOrchestrator] Rapport généré avec succès (score: 85.3)
[PlantIntelligenceOrchestrator] ... (répété pour les 4 autres plantes)
[PlantIntelligenceOrchestrator] 5/5 rapports générés
```

### 📝 Suggestion d'amélioration mineure

Ajouter un log récapitulatif avec durée :

```dart
final startTime = DateTime.now();

// ... analyse ...

final duration = DateTime.now().difference(startTime);
developer.log(
  '✅ Analyse complète terminée en ${duration.inSeconds}s (${reports.length} rapports)',
  name: 'PlantIntelligenceOrchestrator',
);
```

---

## 🎯 SYNTHÈSE DES RECOMMANDATIONS PRIORITAIRES

### 🔴 Priorité HAUTE (Critique)

#### 1. Implémenter le nettoyage des PlantConditions orphelines dans Hive

**Fichier :** `lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart`  
**Ligne :** Ajouter après ligne 492

**Code :**
```dart
Future<void> _cleanOrphanedConditionsInHive(List<String> activePlantIds) async {
  // ... (voir section 2)
}

// Appeler dans initializeForGarden() après le nettoyage mémoire
await _cleanOrphanedConditionsInHive(activePlants);
```

**Impact :**
- Évite la croissance illimitée de la base Hive
- Améliore les performances à long terme
- Élimine les risques de données incohérentes

**Effort :** 2h (développement + tests)

---

### 🟡 Priorité MOYENNE (Important)

#### 2. Invalider le cache lors d'une analyse manuelle

**Fichier :** `lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart`  
**Ligne :** Début de `initializeForGarden()` (avant ligne 443)

**Code :**
```dart
Future<void> initializeForGarden(String gardenId) async {
  // 🔥 NOUVEAU : Invalider le cache pour forcer un rafraîchissement complet
  final hub = _ref.read(IntelligenceModule.aggregationHubProvider);
  hub.invalidateAllCache();
  
  final repo = _ref.read(plantIntelligenceRepositoryProvider);
  await repo.clearCache();
  
  developer.log('🔄 Cache invalidé pour analyse forcée', name: 'IntelligenceStateNotifier');
  
  // ... reste du code existant ...
}
```

**Impact :**
- Garantit que l'analyse manuelle analyse TOUTES les plantes actives
- Élimine les risques de données cachées obsolètes

**Effort :** 1h (développement + tests)

---

### 🟢 Priorité BASSE (Nice to have)

#### 3. Ajouter un indicateur de fraîcheur des données dans l'UI

**Fichier :** `lib/features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart`

**Code :**
```dart
Text(
  'Dernière analyse: ${_formatAge(state.lastAnalysis)}',
  style: Theme.of(context).textTheme.caption,
)

String _formatAge(DateTime? lastAnalysis) {
  if (lastAnalysis == null) return 'Jamais';
  final age = DateTime.now().difference(lastAnalysis);
  if (age.inMinutes < 60) return 'Il y a ${age.inMinutes} min';
  if (age.inHours < 24) return 'Il y a ${age.inHours}h';
  return 'Il y a ${age.inDays} jour(s)';
}
```

**Impact :**
- Transparence pour l'utilisateur
- Encourage le rafraîchissement si les données sont vieilles

**Effort :** 30min

#### 4. Ajouter un log de durée pour l'analyse complète

**Fichier :** `lib/features/plant_intelligence/domain/services/plant_intelligence_orchestrator.dart`  
**Ligne :** Début et fin de `generateGardenIntelligenceReport()`

**Effort :** 15min

---

## 📊 TABLEAU DE DÉCISION

| Problème | Sévérité | Probabilité | Effort | Priorité |
|----------|----------|-------------|--------|----------|
| PlantConditions orphelines en Hive | 🔴 Haute | Certaine | 2h | 🔴 HAUTE |
| Cache non invalidé lors d'analyse manuelle | 🟡 Moyenne | Fréquente | 1h | 🟡 MOYENNE |
| Désynchronisation GardenContext/Plantings | 🟢 Faible | Rare | 3h | 🟢 BASSE |
| Plantes manquantes dans catalogue | 🟡 Moyenne | Rare | 2h | 🟢 BASSE |

---

## ✅ TESTS SUGGÉRÉS

### Test 1 : Récupération complète des plantes actives

```dart
test('generateGardenIntelligenceReport analyse toutes les plantes actives', () async {
  // Arrange
  final testGardenId = 'test-garden-001';
  await seedTestData(testGardenId, plantIds: ['spinach', 'tomato', 'carrot']);
  
  // Act
  final reports = await orchestrator.generateGardenIntelligenceReport(
    gardenId: testGardenId,
  );
  
  // Assert
  expect(reports.length, 3);
  expect(reports.map((r) => r.plantId), containsAll(['spinach', 'tomato', 'carrot']));
});
```

### Test 2 : Nettoyage des conditions orphelines

```dart
test('initializeForGarden nettoie les PlantConditions orphelines en Hive', () async {
  // Arrange
  final testGardenId = 'test-garden-001';
  await seedPlantCondition('deleted-plant', testGardenId); // Plante supprimée
  await seedActivePlanting('spinach', testGardenId); // Plante active
  
  // Act
  await notifier.initializeForGarden(testGardenId);
  
  // Assert
  final box = await Hive.openBox<PlantCondition>('plant_conditions');
  final remainingConditions = box.values.toList();
  
  expect(remainingConditions.any((c) => c.plantId == 'deleted-plant'), false);
  expect(remainingConditions.any((c) => c.plantId == 'spinach'), true);
});
```

### Test 3 : Invalidation du cache lors d'une analyse manuelle

```dart
test('Analyse manuelle invalide le cache et récupère les nouvelles plantes', () async {
  // Arrange
  final testGardenId = 'test-garden-001';
  await seedActivePlanting('spinach', testGardenId);
  await notifier.initializeForGarden(testGardenId); // Première analyse
  
  // Act : Ajouter une nouvelle plante et relancer l'analyse
  await seedActivePlanting('carrot', testGardenId);
  await notifier.initializeForGarden(testGardenId); // Analyse manuelle
  
  // Assert
  final state = notifier.state;
  expect(state.plantConditions.keys, containsAll(['spinach', 'carrot']));
});
```

---

## 📖 CONCLUSION

### Points forts du système actuel

✅ **Architecture solide** : Séparation claire des responsabilités (Orchestrator → Repository → Hub → Adapter)  
✅ **Source de vérité unique** : GardenBoxes (Hive Sanctuaire)  
✅ **Logs exhaustifs** : Traçabilité complète avec convention claire  
✅ **Gestion d'erreurs défensive** : Échecs individuels non bloquants  
✅ **Testabilité** : Dépendances injectables, méthodes unitaires  

### Faiblesses identifiées

⚠️ **Nettoyage incomplet** : Conditions orphelines accumulées en Hive  
⚠️ **Cache agressif** : Analyse manuelle ne force pas le rafraîchissement  
⚠️ **Désynchronisation potentielle** : GardenContext vs Plantings  

### Impact des corrections proposées

Si toutes les recommandations **Priorité HAUTE** et **Priorité MOYENNE** sont implémentées :

| Critère | Avant | Après |
|---------|-------|-------|
| Fiabilité récupération plantes | 9/10 | 10/10 |
| Nettoyage conditions orphelines | 5/10 | 10/10 |
| Gestion du cache | 6/10 | 9/10 |
| Logs de diagnostic | 9/10 | 10/10 |

**Note globale :** 7.25/10 → **9.75/10**

### Temps total estimé

- Priorité HAUTE : 2h
- Priorité MOYENNE : 1h
- Tests automatisés : 2h
- **Total : 5h**

---

**Prochaine étape suggérée :**  
Implémenter les corrections **Priorité HAUTE** et **Priorité MOYENNE** dans cet ordre, avec tests automatisés pour garantir la non-régression.

---

**Audit réalisé par :** Claude Sonnet 4.5  
**Date :** 12 octobre 2025  
**Tag Cursor :** `assainissement-intelligence/audit-plantes-actives`

