# Plan de Test v2.2 - Sécurisation Tests

> **Objectif** : Atteindre ≥80% de couverture sur la couche Domain de l'Intelligence Végétale  
> **Focus** : Tests unitaires techniques + Tests d'intégration critiques  
> **Timeline** : 1-2 semaines

---

## 📊 État Actuel

### Tests Existants
- ✅ **UseCases** : 3 fichiers (analyze, generate_recommendations, evaluate_timing)
- ✅ **Orchestrateur** : 1 fichier (plant_intelligence_orchestrator)
- ✅ **Entities** : 2 fichiers (analysis_result, intelligence_report)
- ✅ **Modern Adapter** : 1 fichier (5 scénarios de validation Sanctuaire)
- ✅ **Aggregation Hub** : 1 fichier (stratégie de fallback, cache, health check)

### Résultats Tests Actuels
- **Total** : 49 tests
- **Passants** : 44 tests ✅
- **Échouants** : 5 tests ❌
- **Couverture estimée** : ~40-50% (Domain layer uniquement)

### Tests Échouants à Corriger
1. `analyze_plant_conditions_usecase_test.dart:58` - Warnings attendus vides mais contient humidité
2. `analyze_plant_conditions_usecase_test.dart:76` - Critical condition ne génère pas priorityActions
3. `analyze_plant_conditions_usecase_test.dart:173` - criticalConditionsCount = 0 au lieu de >0
4. `analyze_plant_conditions_usecase_test.dart:192` - Status 'poor' au lieu de 'critical'
5. `generate_recommendations_usecase_test.dart:155` - Pas de recommandation de tendance historique

---

## 🎯 Objectifs par Couche

### 1. Domain Layer (Priorité P0) - Objectif 80%

#### UseCases (Cible: 90%)
- [x] `AnalyzePlantConditionsUsecase` - 11 tests existants (à corriger)
- [x] `GenerateRecommendationsUsecase` - 10 tests existants (à corriger)
- [x] `EvaluatePlantingTimingUsecase` - 11 tests existants
- [ ] **MANQUANT** : Tests de gestion d'erreurs avancés

#### Services (Cible: 85%)
- [x] `PlantIntelligenceOrchestrator` - 9 tests existants
- [ ] **MANQUANT** : Tests de performance (timeout, débit)
- [ ] **MANQUANT** : Tests de résilience (retry logic)

#### Entities (Cible: 70%)
- [x] `PlantAnalysisResult` - 6 tests existants
- [x] `PlantIntelligenceReport` - 7 tests existants
- [ ] `PlantCondition` - Tests de création et validation
- [ ] `Recommendation` - Tests de priorité et deadlines
- [ ] `WeatherCondition` - Tests de conversion et validité

### 2. Data Layer (Priorité P1) - Objectif 60%

#### Repositories Implementations
- [ ] `PlantIntelligenceRepositoryImpl` - Tests CRUD basiques
- [ ] Cache behavior tests

#### Datasources
- [ ] `PlantIntelligenceLocalDatasource` - Tests Hive operations
- [ ] Error handling et edge cases

### 3. Integration Tests (Priorité P0) - Tests critiques

#### Tests de Flux Complets
- [x] Modern Adapter → Legacy Adapter (fallback)
- [x] GardenAggregationHub (cache, health check)
- [ ] **MANQUANT** : Sanctuary → Modern → Intelligence (flux E2E)
- [ ] **MANQUANT** : EventBus → Intelligence → Recommendations
- [ ] **MANQUANT** : Multi-garden scenario

#### Tests de Résilience
- [ ] Modern Adapter échoue → Legacy prend le relais
- [ ] Données corrompues → Fallback graceful
- [ ] Network timeout → Cache utilisé

---

## 📝 Plan d'Action Détaillé

### Phase 1: Correction Tests Échouants (Jour 1)

**Fichiers à corriger:**
1. `test/features/plant_intelligence/domain/usecases/analyze_plant_conditions_usecase_test.dart`
   - Ajuster expectations pour warnings et priorityActions
   - Corriger logique de détection status critical vs poor

2. `test/features/plant_intelligence/domain/usecases/generate_recommendations_usecase_test.dart`
   - Implémenter génération de recommandations de tendance

**Résultat attendu:** 49/49 tests passent ✅

### Phase 2: Tests Unitaires Manquants (Jours 2-5)

#### Jour 2: Entities
```
test/features/plant_intelligence/domain/entities/
├── plant_condition_test.dart [NOUVEAU]
├── recommendation_test.dart [NOUVEAU]
└── weather_condition_test.dart [NOUVEAU]
```

**Scénarios à couvrir:**
- Création et validation
- Calculs (scores, statuts)
- Edge cases (valeurs nulles, limites)

#### Jours 3-4: Data Layer
```
test/features/plant_intelligence/data/
├── repositories/
│   └── plant_intelligence_repository_impl_test.dart [NOUVEAU]
└── datasources/
    ├── plant_intelligence_local_datasource_test.dart [NOUVEAU]
    └── weather_datasource_test.dart [NOUVEAU]
```

**Scénarios à couvrir:**
- CRUD operations
- Cache behavior
- Error handling
- Hive integration

#### Jour 5: Tests Avancés UseCases
```
test/features/plant_intelligence/domain/usecases/
├── analyze_plant_conditions_usecase_advanced_test.dart [NOUVEAU]
├── generate_recommendations_usecase_advanced_test.dart [NOUVEAU]
└── evaluate_planting_timing_usecase_advanced_test.dart [NOUVEAU]
```

**Scénarios à couvrir:**
- Timeouts et performances
- Données corrompues
- Cas limites multiples

### Phase 3: Tests d'Intégration (Jours 6-8)

#### Jour 6: Flux E2E
```
test/integration/
├── plant_intelligence_flow_test.dart [EXTENSION]
├── sanctuary_to_intelligence_flow_test.dart [NOUVEAU]
└── event_driven_intelligence_test.dart [NOUVEAU]
```

#### Jours 7-8: Tests de Résilience
```
test/integration/
├── adapter_fallback_scenarios_test.dart [NOUVEAU]
├── data_corruption_recovery_test.dart [NOUVEAU]
└── performance_stress_test.dart [NOUVEAU]
```

### Phase 4: CI/CD Configuration (Jour 9)

**Fichiers à créer:**
```
.github/workflows/
└── flutter_tests.yml [NOUVEAU]
```

**Configuration:**
- Tests automatiques sur PR
- Couverture mesurée et rapportée
- Échec de build si couverture < 80%
- Génération de badges de couverture

### Phase 5: Documentation (Jour 10)

**Fichiers à créer/mettre à jour:**
```
test/
├── TESTING_GUIDE.md [NOUVEAU]
├── CONTRIBUTION_STANDARDS.md [NOUVEAU]
└── README_TESTS.md [MISE À JOUR]
```

---

## 🔧 Commandes et Scripts

### Exécution Tests

```bash
# Tests complets avec couverture
flutter test --coverage

# Tests spécifiques Domain
flutter test test/features/plant_intelligence/domain/

# Tests d'intégration uniquement
flutter test test/integration/

# Tests avec rapport HTML
flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
```

### Analyse de Couverture

```bash
# Couverture globale
lcov --summary coverage/lcov.info

# Couverture par fichier
lcov --list coverage/lcov.info

# Filtrer Domain layer uniquement
lcov --extract coverage/lcov.info 'lib/features/plant_intelligence/domain/*' --output-file coverage/domain.info
```

### Scripts Automatisés

**`test/run_tests_with_coverage.bat`** (déjà existant)
```batch
@echo off
flutter test --coverage
genhtml coverage\lcov.info -o coverage\html
start coverage\html\index.html
```

**`test/run_domain_tests.bat`** [NOUVEAU]
```batch
@echo off
flutter test test\features\plant_intelligence\domain\ --coverage
echo Domain tests completed!
```

---

## 📊 Métriques de Succès

### Critères de Validation

| Métrique | Cible | Actuel | Statut |
|----------|-------|--------|--------|
| **Tests totaux** | ≥100 | 49 | 🟡 49% |
| **Tests passants** | 100% | 89% | 🟡 44/49 |
| **Couverture Domain** | ≥80% | ~45% | 🔴 Insuffisant |
| **Couverture Data** | ≥60% | ~10% | 🔴 Insuffisant |
| **Tests intégration** | ≥10 | 8 | 🟡 80% |
| **CI/CD configuré** | Oui | Non | 🔴 Manquant |

### Indicateurs Qualité

- **Temps d'exécution** : < 30s pour suite complète
- **Fiabilité** : 0 tests flaky (instables)
- **Maintenance** : Documentation complète
- **Isolation** : Chaque test indépendant

---

## 🚀 Priorités d'Exécution

### P0 - Critique (Jours 1-3)
1. ✅ Corriger les 5 tests échouants
2. ⏳ Ajouter tests entities manquantes
3. ⏳ Tests intégration E2E critiques

### P1 - Important (Jours 4-7)
4. ⏳ Tests Data layer (repositories)
5. ⏳ Tests avancés UseCases
6. ⏳ Tests de résilience

### P2 - Nice to Have (Jours 8-10)
7. ⏳ CI/CD configuration
8. ⏳ Documentation et guides
9. ⏳ Performance tests

---

## 📚 Ressources et Références

### Standards de Tests Flutter
- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Integration Testing](https://flutter.dev/docs/testing/integration-tests)

### Best Practices
- **AAA Pattern** : Arrange, Act, Assert
- **FIRST Principles** : Fast, Isolated, Repeatable, Self-validating, Timely
- **Test Doubles** : Mocks, Stubs, Fakes appropriés

### Conventions de Nommage
```dart
// Pattern: should_expectedBehavior_when_condition
test('should return empty list when garden has no plantings', () {
  // ...
});

// Pattern: should_throw_exception_when_invalidInput
test('should throw ArgumentError when gardenId is empty', () {
  // ...
});
```

---

## ✅ Checklist de Validation Finale

### Tests Unitaires
- [ ] Tous les UseCases testés à ≥90%
- [ ] Orchestrateur testé à ≥85%
- [ ] Entities testées à ≥70%
- [ ] Repositories testés à ≥60%
- [ ] Datasources testés à ≥60%

### Tests d'Intégration
- [ ] Flux E2E complet validé
- [ ] Stratégie de fallback testée
- [ ] EventBus intégration testée
- [ ] Multi-garden scenarios testés
- [ ] Résilience et recovery testés

### Infrastructure
- [ ] CI/CD GitHub Actions configuré
- [ ] Rapport de couverture automatique
- [ ] Badges de statut ajoutés
- [ ] Notifications configurées

### Documentation
- [ ] Guide de test complet
- [ ] Standards de contribution
- [ ] Exemples de tests annotés
- [ ] Troubleshooting guide

---

**Plan de Test v2.2 établi.**  
**Prêt pour exécution séquentielle par phase.**  
**Timeline : 10 jours pour 80%+ couverture.**

