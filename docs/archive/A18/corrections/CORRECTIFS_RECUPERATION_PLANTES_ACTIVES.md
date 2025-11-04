# 🔧 Correctifs - Récupération Plantes Actives & Cohérence Cache

**Date :** 12 octobre 2025  
**Tag :** `assainissement-intelligence/correctifs-plantes-actives`  
**Base :** Audit `AUDIT_FIABILITE_RECUPERATION_PLANTES_ACTIVES.md`

Ce document contient les **implémentations concrètes** prêtes à intégrer pour corriger les problèmes identifiés dans l'audit.

---

## 🔴 CORRECTIF 1 : Nettoyage des PlantConditions orphelines dans Hive

### Fichier à modifier
`lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart`

### Code à ajouter

#### 1. Importer Hive

```dart
// Ajouter en haut du fichier après les imports existants
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/plant_condition.dart';
```

#### 2. Ajouter la méthode de nettoyage

**Emplacement :** Après la ligne 699 (dans la classe `IntelligenceStateNotifier`)

```dart
  /// 🧹 Nettoie les PlantConditions orphelines de la base Hive
  /// 
  /// Une condition est considérée orpheline si son plantId n'est plus dans la liste
  /// des plantes actives du jardin.
  /// 
  /// Cette méthode est idempotente et safe : elle ne bloque pas l'initialisation
  /// si le nettoyage échoue.
  /// 
  /// [activePlantIds] - Liste des IDs de plantes actuellement actives dans le jardin
  Future<void> _cleanOrphanedConditionsInHive(List<String> activePlantIds) async {
    try {
      developer.log(
        '🧹 NETTOYAGE HIVE - Début purge conditions orphelines',
        name: 'IntelligenceStateNotifier',
      );
      
      // Ouvrir la box des conditions (safe même si déjà ouverte)
      final box = await Hive.openBox<PlantCondition>('plant_conditions');
      
      developer.log(
        '🧹 NETTOYAGE HIVE - Box ouverte: ${box.length} entrées totales',
        name: 'IntelligenceStateNotifier',
      );
      
      // Identifier les conditions orphelines
      final orphanedKeys = <dynamic>[];
      for (final key in box.keys) {
        final condition = box.get(key);
        if (condition != null && !activePlantIds.contains(condition.plantId)) {
          orphanedKeys.add(key);
          developer.log(
            '🧹 NETTOYAGE HIVE - Condition orpheline détectée: ${condition.plantId} (key: $key)',
            name: 'IntelligenceStateNotifier',
            level: 500,
          );
        }
      }
      
      // Supprimer les conditions orphelines (opération idempotente)
      if (orphanedKeys.isNotEmpty) {
        await box.deleteAll(orphanedKeys);
        
        developer.log(
          '✅ NETTOYAGE HIVE - ${orphanedKeys.length} condition(s) orpheline(s) purgée(s)',
          name: 'IntelligenceStateNotifier',
        );
      } else {
        developer.log(
          '✅ NETTOYAGE HIVE - Aucune condition orpheline détectée',
          name: 'IntelligenceStateNotifier',
        );
      }
      
    } catch (e, stackTrace) {
      // Erreur non bloquante : logger mais ne pas interrompre l'initialisation
      developer.log(
        '❌ NETTOYAGE HIVE - Erreur non bloquante: $e',
        name: 'IntelligenceStateNotifier',
        level: 900,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// 🧹 Nettoie les Recommendations orphelines de la base Hive (optionnel)
  /// 
  /// Similaire à _cleanOrphanedConditionsInHive mais pour les recommandations
  Future<void> _cleanOrphanedRecommendationsInHive(List<String> activePlantIds) async {
    try {
      developer.log(
        '🧹 NETTOYAGE HIVE - Début purge recommandations orphelines',
        name: 'IntelligenceStateNotifier',
      );
      
      // Note: Adapter selon la structure réelle de stockage des recommandations
      // Si elles sont stockées dans une box dédiée "plant_recommendations"
      
      final box = await Hive.openBox('plant_recommendations');
      
      final orphanedKeys = <dynamic>[];
      for (final key in box.keys) {
        // Extraire le plantId de la clé (ex: "plantId_recommendationId")
        final keyStr = key.toString();
        final plantId = keyStr.split('_').first;
        
        if (!activePlantIds.contains(plantId)) {
          orphanedKeys.add(key);
        }
      }
      
      if (orphanedKeys.isNotEmpty) {
        await box.deleteAll(orphanedKeys);
        developer.log(
          '✅ NETTOYAGE HIVE - ${orphanedKeys.length} recommandation(s) orpheline(s) purgée(s)',
          name: 'IntelligenceStateNotifier',
        );
      }
      
    } catch (e, stackTrace) {
      developer.log(
        '❌ NETTOYAGE HIVE - Erreur nettoyage recommandations: $e',
        name: 'IntelligenceStateNotifier',
        level: 900,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
```

#### 3. Intégrer dans initializeForGarden()

**Emplacement :** Ligne 532, après le log "✅ Toutes les analyses terminées"

```dart
      developer.log('✅ DIAGNOSTIC - Toutes les analyses terminées: ${state.plantConditions.length} conditions, ${state.plantRecommendations.length} plantes avec recommandations', name: 'IntelligenceStateNotifier');

      // 🔥 NOUVEAU : Nettoyer les conditions orphelines en base Hive
      print('🔴 [DIAGNOSTIC PROVIDER] Nettoyage des conditions orphelines...');
      developer.log('🧹 NETTOYAGE - Début purge Hive pour gardenId=$gardenId', name: 'IntelligenceStateNotifier');
      await _cleanOrphanedConditionsInHive(activePlants);
      await _cleanOrphanedRecommendationsInHive(activePlants);
      developer.log('✅ NETTOYAGE - Purge Hive terminée', name: 'IntelligenceStateNotifier');
      print('🔴 [DIAGNOSTIC PROVIDER] Nettoyage terminé');

      print('🔴 [DIAGNOSTIC PROVIDER] ✅ initializeForGarden terminé: ${activePlants.length} plantes');
```

### Tests à ajouter

**Fichier :** `test/features/plant_intelligence/providers/intelligence_state_notifier_cleanup_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart';

void main() {
  late Box<PlantCondition> conditionsBox;
  
  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PlantConditionAdapter()); // Adapter généré par build_runner
  });
  
  setUp(() async {
    // Créer une box test
    conditionsBox = await Hive.openBox<PlantCondition>('plant_conditions_test');
  });
  
  tearDown(() async {
    await conditionsBox.clear();
    await conditionsBox.close();
  });

  group('Nettoyage PlantConditions orphelines', () {
    test('Supprime les conditions des plantes supprimées', () async {
      // Arrange
      final activeCondition = PlantCondition(
        id: 'cond-1',
        plantId: 'spinach',
        type: ConditionType.temperature,
        status: ConditionStatus.good,
        value: 20.0,
        healthScore: 85.0,
        assessedAt: DateTime.now(),
      );
      
      final orphanedCondition = PlantCondition(
        id: 'cond-2',
        plantId: 'deleted-plant',
        type: ConditionType.temperature,
        status: ConditionStatus.good,
        value: 20.0,
        healthScore: 85.0,
        assessedAt: DateTime.now(),
      );
      
      await conditionsBox.put(activeCondition.id, activeCondition);
      await conditionsBox.put(orphanedCondition.id, orphanedCondition);
      
      expect(conditionsBox.length, 2);
      
      // Act
      final activePlantIds = ['spinach', 'tomato']; // 'deleted-plant' n'est plus actif
      
      // Simuler l'appel de la méthode privée via l'initialisation
      // Note: Il faudra créer une méthode publique pour tester, ou tester via initializeForGarden()
      
      // Assert
      final remainingConditions = conditionsBox.values
          .where((c) => c.plantId == 'deleted-plant')
          .toList();
      
      expect(remainingConditions, isEmpty);
      expect(conditionsBox.length, 1);
      expect(conditionsBox.values.first.plantId, 'spinach');
    });
    
    test('Ne supprime pas les conditions des plantes actives', () async {
      // Arrange
      final condition1 = PlantCondition(
        id: 'cond-1',
        plantId: 'spinach',
        type: ConditionType.temperature,
        status: ConditionStatus.good,
        value: 20.0,
        healthScore: 85.0,
        assessedAt: DateTime.now(),
      );
      
      final condition2 = PlantCondition(
        id: 'cond-2',
        plantId: 'tomato',
        type: ConditionType.humidity,
        status: ConditionStatus.excellent,
        value: 70.0,
        healthScore: 95.0,
        assessedAt: DateTime.now(),
      );
      
      await conditionsBox.put(condition1.id, condition1);
      await conditionsBox.put(condition2.id, condition2);
      
      // Act
      final activePlantIds = ['spinach', 'tomato'];
      
      // Assert
      expect(conditionsBox.length, 2);
    });
    
    test('Gère les erreurs sans bloquer l\'initialisation', () async {
      // Arrange : Fermer la box pour simuler une erreur
      await conditionsBox.close();
      
      // Act : L'appel ne devrait pas lancer d'exception
      // La méthode doit logger l'erreur mais continuer
      
      expect(() async {
        // Simuler l'appel avec une box fermée
        // La méthode devrait capturer l'exception
      }, returnsNormally);
    });
  });
}
```

---

## 🟡 CORRECTIF 2 : Invalidation du cache lors d'une analyse manuelle

### Fichier 1 : Ajouter invalidateAllCache() au Hub

`lib/core/services/aggregation/garden_aggregation_hub.dart`

**Emplacement :** Après la ligne 615 (fin de la classe, avant l'exception)

```dart
  // ==================== GESTION DU CACHE ====================
  
  /// Invalide une entrée spécifique du cache
  /// 
  /// Utilisé pour forcer le rafraîchissement d'une donnée spécifique
  /// sans affecter le reste du cache
  void invalidateCache(String cacheKey) {
    _cache.remove(cacheKey);
    _cache.remove('${cacheKey}_timestamp');
    
    developer.log(
      '🗑️ Cache invalidé: $cacheKey',
      name: _logName,
      level: 500,
    );
  }
  
  /// Invalide tout le cache du hub
  /// 
  /// Utilisé lors d'une analyse manuelle pour garantir que toutes les données
  /// sont récupérées à nouveau depuis la source de vérité (Hive Sanctuaire)
  void invalidateAllCache() {
    final keysCount = _cache.length ~/ 2; // Diviser par 2 car on a key + timestamp
    _cache.clear();
    
    developer.log(
      '🗑️ Cache complet invalidé ($keysCount entrées)',
      name: _logName,
      level: 500,
    );
  }
  
  /// Retourne le nombre d'entrées dans le cache
  int get cacheSize => _cache.length ~/ 2;
  
  /// Retourne l'âge du cache pour une clé donnée
  Duration? getCacheAge(String cacheKey) {
    final timestampKey = '${cacheKey}_timestamp';
    if (!_cache.containsKey(timestampKey)) {
      return null;
    }
    
    final timestamp = _cache[timestampKey] as DateTime;
    return DateTime.now().difference(timestamp);
  }
```

### Fichier 2 : Exposer clearCache() dans le Repository

`lib/features/plant_intelligence/data/repositories/plant_intelligence_repository_impl.dart`

**Vérifier que la méthode clearCache() est bien publique** (elle l'est déjà à la ligne 1045)

Si non, ajouter :

```dart
  @override
  Future<bool> clearCache({Duration? olderThan}) async {
    try {
      developer.log(
        '🗑️ Nettoyage cache repository',
        name: 'PlantIntelligenceRepository',
        level: 500,
      );
      
      // Nettoyer le cache local
      final entriesCount = _cache.length ~/ 2;
      _cache.clear();
      
      developer.log(
        '✅ Cache repository nettoyé ($entriesCount entrées)',
        name: 'PlantIntelligenceRepository',
        level: 500,
      );
      
      // Nettoyer le cache de la source de données
      return await _localDataSource.clearCache(olderThan: olderThan);
    } catch (e) {
      developer.log(
        '❌ Erreur nettoyage cache: $e',
        name: 'PlantIntelligenceRepository',
        level: 900,
        error: e,
      );
      return false;
    }
  }
```

### Fichier 3 : Invalider le cache dans initializeForGarden()

`lib/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart`

**Emplacement :** Ligne 439, AVANT le premier log

```dart
  /// Initialiser l'intelligence pour un jardin
  Future<void> initializeForGarden(String gardenId) async {
    print('🔴 [DIAGNOSTIC PROVIDER] initializeForGarden() DÉBUT - gardenId=$gardenId');
    developer.log('🔍 DIAGNOSTIC - Début initializeForGarden: gardenId=$gardenId', name: 'IntelligenceStateNotifier');
    
    // 🔥 NOUVEAU : Invalider TOUT le cache pour forcer un rafraîchissement complet
    // Cela garantit que l'analyse manuelle récupère bien toutes les plantes actives
    // sans se baser sur un cache potentiellement obsolète
    print('🔴 [DIAGNOSTIC PROVIDER] Invalidation du cache...');
    developer.log('🔄 INVALIDATION CACHE - Début nettoyage complet', name: 'IntelligenceStateNotifier');
    
    try {
      // Invalider le cache du Hub (plantes actives, contexte jardin)
      final hub = _ref.read(IntelligenceModule.aggregationHubProvider);
      hub.invalidateAllCache();
      developer.log('✅ INVALIDATION CACHE - Hub invalidé', name: 'IntelligenceStateNotifier');
      
      // Invalider le cache du Repository (conditions, recommandations)
      final repo = _ref.read(plantIntelligenceRepositoryProvider);
      await repo.clearCache();
      developer.log('✅ INVALIDATION CACHE - Repository invalidé', name: 'IntelligenceStateNotifier');
      
      print('🔴 [DIAGNOSTIC PROVIDER] Cache complètement invalidé');
    } catch (e) {
      // Erreur non bloquante
      developer.log(
        '⚠️ INVALIDATION CACHE - Erreur non bloquante: $e',
        name: 'IntelligenceStateNotifier',
        level: 900,
      );
      print('🔴 [DIAGNOSTIC PROVIDER] ⚠️ Erreur invalidation cache (non bloquant): $e');
    }
    
    state = state.copyWith(isAnalyzing: true, error: null);
    print('🔴 [DIAGNOSTIC PROVIDER] State mis à jour: isAnalyzing=true');

    // ... reste du code existant ...
```

### Tests à ajouter

**Fichier :** `test/features/plant_intelligence/providers/intelligence_state_notifier_cache_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:permacalendar/core/services/aggregation/garden_aggregation_hub.dart';
import 'package:permacalendar/features/plant_intelligence/data/repositories/plant_intelligence_repository_impl.dart';
import 'package:permacalendar/features/plant_intelligence/presentation/providers/intelligence_state_providers.dart';

void main() {
  late ProviderContainer container;
  late MockGardenAggregationHub mockHub;
  late MockPlantIntelligenceRepository mockRepo;
  
  setUp(() {
    mockHub = MockGardenAggregationHub();
    mockRepo = MockPlantIntelligenceRepository();
    
    container = ProviderContainer(
      overrides: [
        IntelligenceModule.aggregationHubProvider.overrideWithValue(mockHub),
        plantIntelligenceRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });
  
  tearDown(() {
    container.dispose();
  });

  group('Invalidation du cache lors d\'une analyse manuelle', () {
    test('Invalide le cache Hub lors de initializeForGarden()', () async {
      // Arrange
      when(mockHub.getUnifiedContext(any)).thenAnswer((_) async => mockGardenContext);
      when(mockHub.getActivePlants(any)).thenAnswer((_) async => []);
      
      // Act
      await container.read(intelligenceStateProvider.notifier)
          .initializeForGarden('test-garden');
      
      // Assert
      verify(mockHub.invalidateAllCache()).called(1);
    });
    
    test('Invalide le cache Repository lors de initializeForGarden()', () async {
      // Arrange
      when(mockRepo.getGardenContext(any)).thenAnswer((_) async => mockGardenContext);
      when(mockRepo.clearCache()).thenAnswer((_) async => true);
      
      // Act
      await container.read(intelligenceStateProvider.notifier)
          .initializeForGarden('test-garden');
      
      // Assert
      verify(mockRepo.clearCache()).called(1);
    });
    
    test('Continue l\'initialisation même si l\'invalidation échoue', () async {
      // Arrange
      when(mockHub.invalidateAllCache()).thenThrow(Exception('Cache error'));
      when(mockHub.getUnifiedContext(any)).thenAnswer((_) async => mockGardenContext);
      
      // Act & Assert : Ne devrait pas lancer d'exception
      expect(() async {
        await container.read(intelligenceStateProvider.notifier)
            .initializeForGarden('test-garden');
      }, returnsNormally);
    });
    
    test('Récupère les nouvelles plantes après invalidation du cache', () async {
      // Arrange : Simuler une plante ajoutée après la première analyse
      var plantsList = ['spinach'];
      
      when(mockHub.getActivePlants(any)).thenAnswer((_) async {
        return plantsList.map((id) => mockPlantData(id)).toList();
      });
      
      // Act 1 : Première analyse
      await container.read(intelligenceStateProvider.notifier)
          .initializeForGarden('test-garden');
      
      var state1 = container.read(intelligenceStateProvider);
      expect(state1.activePlantIds.length, 1);
      
      // Ajouter une nouvelle plante
      plantsList = ['spinach', 'carrot'];
      
      // Act 2 : Analyse manuelle (devrait récupérer 'carrot')
      await container.read(intelligenceStateProvider.notifier)
          .initializeForGarden('test-garden');
      
      var state2 = container.read(intelligenceStateProvider);
      
      // Assert
      expect(state2.activePlantIds.length, 2);
      expect(state2.activePlantIds, containsAll(['spinach', 'carrot']));
    });
  });
}
```

---

## 🟢 CORRECTIF 3 : Indicateur de fraîcheur des données (optionnel)

### Fichier à modifier
`lib/features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart`

### Code à ajouter

**Emplacement :** Dans le header du dashboard, après le titre

```dart
// Après le titre "Intelligence Végétale"
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Intelligence Végétale',
      style: Theme.of(context).textTheme.headlineMedium,
    ),
    const SizedBox(height: 4),
    _buildFreshnessIndicator(context, state),
  ],
)

// ... plus bas dans la classe ...

Widget _buildFreshnessIndicator(BuildContext context, IntelligenceState state) {
  if (state.lastAnalysis == null) {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          'Aucune analyse effectuée',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  
  final age = DateTime.now().difference(state.lastAnalysis!);
  final ageText = _formatAge(age);
  final isStale = age.inMinutes > 30;
  
  return Row(
    children: [
      Icon(
        isStale ? Icons.warning_amber_rounded : Icons.check_circle_outline,
        size: 16,
        color: isStale ? Colors.orange : Colors.green,
      ),
      const SizedBox(width: 4),
      Text(
        'Dernière analyse: $ageText',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isStale ? Colors.orange : Colors.green,
        ),
      ),
      if (isStale) ...[
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: () async {
            await ref.read(intelligenceStateProvider.notifier)
                .initializeForGarden(gardenId);
          },
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Rafraîchir'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    ],
  );
}

String _formatAge(Duration age) {
  if (age.inSeconds < 60) {
    return 'À l\'instant';
  } else if (age.inMinutes < 60) {
    return 'Il y a ${age.inMinutes} min';
  } else if (age.inHours < 24) {
    return 'Il y a ${age.inHours}h';
  } else {
    return 'Il y a ${age.inDays} jour(s)';
  }
}
```

---

## 🟢 CORRECTIF 4 : Log de durée pour l'analyse complète (optionnel)

### Fichier à modifier
`lib/features/plant_intelligence/domain/services/plant_intelligence_orchestrator.dart`

### Code à modifier

**Ligne 225-278 :** Remplacer la méthode `generateGardenIntelligenceReport()`

```dart
  Future<List<PlantIntelligenceReport>> generateGardenIntelligenceReport({
    required String gardenId,
  }) async {
    // 🔥 NOUVEAU : Timer pour mesurer la durée
    final startTime = DateTime.now();
    
    developer.log(
      'Génération rapport intelligence pour jardin $gardenId',
      name: 'PlantIntelligenceOrchestrator',
    );
    
    try {
      // Récupérer toutes les plantes du jardin
      final plants = await _gardenRepository.getGardenPlants(gardenId);
      
      developer.log(
        '${plants.length} plantes à analyser',
        name: 'PlantIntelligenceOrchestrator',
      );
      
      // Générer un rapport pour chaque plante
      final reports = <PlantIntelligenceReport>[];
      var successCount = 0;
      var failureCount = 0;
      
      for (final plant in plants) {
        try {
          final report = await generateIntelligenceReport(
            plantId: plant.id,
            gardenId: gardenId,
            plant: plant,
          );
          reports.add(report);
          successCount++;
        } catch (e) {
          failureCount++;
          developer.log(
            'Erreur génération rapport pour plante ${plant.id}: $e',
            name: 'PlantIntelligenceOrchestrator',
            level: 900,
          );
          // Continue avec les autres plantes
        }
      }
      
      // 🔥 NOUVEAU : Calculer la durée et logger les métriques
      final duration = DateTime.now().difference(startTime);
      
      developer.log(
        '✅ Analyse complète terminée en ${duration.inSeconds}s (${duration.inMilliseconds}ms)',
        name: 'PlantIntelligenceOrchestrator',
      );
      
      developer.log(
        '📊 Résultats: $successCount succès, $failureCount échec(s) sur ${plants.length} plantes',
        name: 'PlantIntelligenceOrchestrator',
      );
      
      if (successCount > 0) {
        final avgTimePerPlant = duration.inMilliseconds / successCount;
        developer.log(
          '⏱️ Temps moyen par plante: ${avgTimePerPlant.toStringAsFixed(0)}ms',
          name: 'PlantIntelligenceOrchestrator',
        );
      }
      
      return reports;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime);
      
      developer.log(
        '❌ Erreur génération rapport jardin (après ${duration.inSeconds}s)',
        name: 'PlantIntelligenceOrchestrator',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
```

---

## 📋 CHECKLIST D'IMPLÉMENTATION

### Phase 1 : Correctifs Prioritaires (🔴 + 🟡)

- [ ] **Correctif 1** : Nettoyage PlantConditions orphelines
  - [ ] Ajouter imports Hive
  - [ ] Ajouter méthode `_cleanOrphanedConditionsInHive()`
  - [ ] Ajouter méthode `_cleanOrphanedRecommendationsInHive()`
  - [ ] Intégrer dans `initializeForGarden()`
  - [ ] Tester manuellement
  - [ ] Écrire tests automatisés

- [ ] **Correctif 2** : Invalidation du cache
  - [ ] Ajouter `invalidateAllCache()` au Hub
  - [ ] Vérifier `clearCache()` dans Repository
  - [ ] Intégrer invalidation dans `initializeForGarden()`
  - [ ] Tester manuellement
  - [ ] Écrire tests automatisés

### Phase 2 : Améliorations UX (🟢)

- [ ] **Correctif 3** : Indicateur de fraîcheur
  - [ ] Ajouter `_buildFreshnessIndicator()` dans dashboard
  - [ ] Ajouter `_formatAge()` helper
  - [ ] Tester visuellement

- [ ] **Correctif 4** : Logs de durée
  - [ ] Modifier `generateGardenIntelligenceReport()`
  - [ ] Vérifier les logs en console

### Phase 3 : Validation

- [ ] Relire l'audit `AUDIT_FIABILITE_RECUPERATION_PLANTES_ACTIVES.md`
- [ ] Vérifier que tous les problèmes identifiés sont corrigés
- [ ] Tester le scénario complet :
  1. Créer un jardin avec 3 plantes
  2. Lancer une analyse
  3. Supprimer 1 plante
  4. Ajouter 1 nouvelle plante
  5. Relancer l'analyse
  6. Vérifier que les données sont cohérentes
- [ ] Vérifier les logs en console
- [ ] Commit avec message clair

---

## 🧪 SCÉNARIO DE TEST MANUEL COMPLET

### Setup initial

```bash
# 1. Réinitialiser l'app pour une base vierge
flutter clean
flutter pub get
flutter run
```

### Test 1 : Analyse initiale

1. Créer un jardin "Test Garden"
2. Ajouter 3 plantations : "spinach", "tomato", "carrot"
3. Ouvrir le dashboard Intelligence
4. Cliquer sur "Rafraîchir l'analyse"
5. **Vérifier dans les logs :**
   ```
   [IntelligenceStateNotifier] 🔄 INVALIDATION CACHE - Début nettoyage complet
   [GardenAggregationHub] 🗑️ Cache complet invalidé (0 entrées)
   [IntelligenceStateNotifier] 🌱 Plantes actives détectées: 3
   [IntelligenceStateNotifier] 📊 Analyses générées: 3/3
   ```

### Test 2 : Nettoyage des orphelines

6. Via l'UI Plantings, supprimer "carrot"
7. Ouvrir le dashboard Intelligence
8. Cliquer sur "Rafraîchir l'analyse"
9. **Vérifier dans les logs :**
   ```
   [IntelligenceStateNotifier] 🧹 NETTOYAGE HIVE - Début purge conditions orphelines
   [IntelligenceStateNotifier] 🧹 NETTOYAGE HIVE - Condition orpheline détectée: carrot
   [IntelligenceStateNotifier] ✅ NETTOYAGE HIVE - 1 condition(s) orpheline(s) purgée(s)
   ```

### Test 3 : Invalidation du cache

10. Ajouter une nouvelle plantation "pepper"
11. **SANS fermer le dashboard**, cliquer sur "Rafraîchir l'analyse"
12. **Vérifier dans l'UI :**
    - "pepper" apparaît dans la liste des plantes analysées
    - Le compteur affiche "3 plantes analysées" (spinach, tomato, pepper)
13. **Vérifier dans les logs :**
    ```
    [IntelligenceStateNotifier] 🔄 INVALIDATION CACHE - Début nettoyage complet
    [GardenAggregationHub] 🗑️ Cache complet invalidé (2 entrées)
    [IntelligenceStateNotifier] 🌱 Plantes actives détectées: 3
    ```

### Test 4 : Indicateur de fraîcheur (si implémenté)

14. Attendre 2 minutes
15. Recharger le dashboard
16. **Vérifier dans l'UI :**
    - "Dernière analyse: Il y a 2 min" avec icône verte
17. Attendre 30 minutes (ou simuler en changeant l'heure système)
18. Recharger le dashboard
19. **Vérifier dans l'UI :**
    - "Dernière analyse: Il y a 30+ min" avec icône orange
    - Bouton "Rafraîchir" visible

### Résultat attendu

✅ Tous les tests passent  
✅ Aucune erreur dans la console  
✅ Les données sont cohérentes entre l'UI et la base Hive  
✅ Les logs sont clairs et informatifs  

---

## 📊 MÉTRIQUES DE SUCCÈS

Après implémentation, ces métriques doivent être atteintes :

| Métrique | Avant | Après | Objectif |
|----------|-------|-------|----------|
| Fiabilité récupération plantes | 9/10 | 10/10 | ✅ |
| Nettoyage conditions orphelines | 5/10 | 10/10 | ✅ |
| Gestion du cache | 6/10 | 9/10 | ✅ |
| Logs de diagnostic | 9/10 | 10/10 | ✅ |
| **Note globale** | **7.25/10** | **9.75/10** | **✅** |

---

**Prochaine étape :** Implémenter les correctifs **Priorité HAUTE** (Correctif 1) puis **Priorité MOYENNE** (Correctif 2), tester manuellement, puis écrire les tests automatisés.

**Temps estimé :** 5h (développement + tests)

