# Standards de Contribution — Tests

> **Guide** : Standards et bonnes pratiques pour contribuer aux tests de l'Intelligence Végétale

---

## 📐 Standards de Code

### Formatage

```bash
# Avant de commiter
dart format .

# Vérifier le formatage
dart format --set-exit-if-changed .
```

### Analyse Statique

```bash
# Vérifier les warnings
flutter analyze

# Corriger les problèmes automatiquement
dart fix --apply
```

---

## ✅ Checklist avant PR

### Tests
- [ ] Tous les tests passent localement (`flutter test`)
- [ ] Couverture ≥80% sur Domain layer
- [ ] Nouveaux tests pour nouveau code
- [ ] Pas de tests flaky (instables)
- [ ] Tests documentés si logique complexe

### Code Quality
- [ ] Code formaté (`dart format`)
- [ ] Pas de warnings (`flutter analyze`)
- [ ] Documentation ajoutée pour API publiques
- [ ] Noms de variables/fonctions explicites

### CI/CD
- [ ] Workflow GitHub Actions passe
- [ ] Couverture ne diminue pas
- [ ] Pas de régression de performance

---

## 🎯 Guidelines par Type de Test

### Tests Unitaires

**Obligatoires pour** :
- ✅ UseCases (logique métier critique)
- ✅ Services (orchestration)
- ✅ Entités avec logique (getters calculés, méthodes)

**Structure** :
```dart
group('MyUseCase', () {
  late MyUseCase usecase;
  
  setUp(() {
    usecase = MyUseCase();
  });
  
  test('should_behavior_when_condition', () async {
    // Arrange
    final input = createTestData();
    
    // Act
    final result = await usecase.execute(input);
    
    // Assert
    expect(result, isExpected);
  });
});
```

### Tests d'Intégration

**Quand créer** :
- ✅ Flux critiques (Sanctuary → Intelligence)
- ✅ Interactions complexes entre composants
- ✅ Tests de fallback/resilience

**Pattern** :
```dart
testWidgets('Integration: ComponentA → ComponentB → ComponentC', (tester) async {
  // Given: État initial
  await setupInitialState();
  
  // When: Actions séquentielles
  await componentA.action1();
  await componentB.action2();
  
  // Then: Résultat final
  final result = await componentC.getFinalState();
  expect(result, isValid);
});
```

---

## 🚫 Anti-Patterns à Éviter

### ❌ Tests Fragiles

```dart
// MAUVAIS : Dépend du temps réel
test('should expire after 24 hours', () {
  final created = DateTime.now();
  // ...
  expect(report.isExpired, isTrue); // Flaky!
});

// BON : Temps contrôlé
test('should expire after 24 hours', () {
  final fixedDate = DateTime(2024, 1, 1);
  final report = createReportAt(fixedDate);
  // ...
  expect(report.isExpiredAt(fixedDate.add(Duration(hours: 25))), isTrue);
});
```

### ❌ Tests Couplés

```dart
// MAUVAIS : Dépend d'un autre test
test('test A', () {
  sharedState.value = 42;
});

test('test B', () {
  expect(sharedState.value, 42); // ERREUR si test A n'a pas tourné!
});

// BON : Tests isolés
test('test A', () {
  final state = TestState(value: 42);
  // ...
});

test('test B', () {
  final state = TestState(value: 42);
  expect(state.value, 42); // Indépendant
});
```

### ❌ Tests Trop Larges

```dart
// MAUVAIS : Teste trop de choses
test('should do everything', () {
  // 50 lignes de code
  // 20 assertions
  expect(...);
  expect(...);
  // ...
});

// BON : Tests ciblés
test('should calculate health score', () {
  expect(result.healthScore, inRange(0, 100));
});

test('should generate warnings for poor conditions', () {
  expect(result.warnings, isNotEmpty);
});
```

---

## 📊 Couverture

### Mesurer la Couverture

```bash
# Globale
flutter test --coverage
lcov --summary coverage/lcov.info

# Domain layer uniquement
lcov --extract coverage/lcov.info 'lib/features/plant_intelligence/domain/*' \
     --output-file coverage/domain.info
lcov --summary coverage/domain.info
```

### Interpréter les Résultats

| Couverture | Évaluation | Action |
|------------|------------|--------|
| < 60% | 🔴 Insuffisant | Ajouter tests prioritaires |
| 60-80% | 🟡 Acceptable | Continuer amélioration |
| > 80% | 🟢 Excellent | Maintenir niveau |

### Fichiers à Exclure

Certains fichiers n'ont pas besoin de tests :
- ❌ `*.g.dart` (code généré)
- ❌ `*.freezed.dart` (code généré)
- ❌ `main.dart` (point d'entrée)
- ❌ Widgets simples sans logique

---

## 🔄 Workflow de Contribution

### 1. Créer une Branche

```bash
git checkout -b feature/add-bio-control-tests
```

### 2. Développer avec TDD (optionnel mais recommandé)

```
1. Écrire le test (RED)
   ↓
2. Implémenter le code minimal (GREEN)
   ↓
3. Refactorer (REFACTOR)
   ↓
4. Répéter
```

### 3. Vérifier Localement

```bash
# Tests
flutter test

# Couverture
flutter test --coverage
lcov --summary coverage/lcov.info

# Analyse
flutter analyze

# Format
dart format .
```

### 4. Créer Pull Request

**Template PR** :

```markdown
## Description
Courte description des changements

## Type de changement
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation

## Tests
- [ ] Tests unitaires ajoutés
- [ ] Tests d'intégration ajoutés
- [ ] Tous les tests passent
- [ ] Couverture ≥80%

## Checklist
- [ ] Code formaté
- [ ] Pas de warnings
- [ ] Documentation mise à jour
- [ ] CI/CD passe
```

### 5. Review Process

**Critères de Review** :
- ✅ Tests pertinents et bien nommés
- ✅ Couverture satisfaisante
- ✅ Pas de code dupliqué
- ✅ Documentation claire
- ✅ Pas de régression

---

## 🎓 Formation Continue

### Ressources Internes
1. Lire `test/TESTING_GUIDE.md`
2. Étudier les tests existants dans `test/features/plant_intelligence/domain/usecases/`
3. Consulter `test/TEST_PLAN_V2.2.md` pour le contexte global

### Ressources Externes
- [Flutter Testing Cookbook](https://flutter.dev/docs/cookbook/testing)
- [Effective Testing](https://testing.googleblog.com/)
- [Test-Driven Development (Kent Beck)](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)

---

## 🤝 Support

### Questions
- Consulter la documentation dans `test/`
- Ouvrir une issue GitHub avec label `question`
- Demander en review de PR

### Bugs dans les Tests
- Vérifier si c'est un test flaky
- Reproduire localement
- Ouvrir une issue avec label `bug:test`

### Suggestions d'Amélioration
- Proposer dans une issue avec label `enhancement:test`
- Ou directement dans une PR

---

**Standards de Contribution v2.2**  
**Dernière mise à jour** : Octobre 2025

