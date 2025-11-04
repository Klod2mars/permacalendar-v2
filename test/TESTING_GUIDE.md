# Guide de Tests — PermaCalendar Intelligence Végétale

> **Documentation** : Standards et bonnes pratiques pour tester l'Intelligence Végétale v2.2

---

## 📚 Table des Matières

1. [Philosophie de Tests](#philosophie-de-tests)
2. [Architecture de Tests](#architecture-de-tests)
3. [Types de Tests](#types-de-tests)
4. [Standards et Conventions](#standards-et-conventions)
5. [Outils et Commandes](#outils-et-commandes)
6. [Exemples Annotés](#exemples-annotés)
7. [Troubleshooting](#troubleshooting)

---

## 🎯 Philosophie de Tests

### Principes Fondamentaux

**FIRST Principles**
- **Fast** : Tests rapides (< 30s pour la suite complète)
- **Isolated** : Chaque test est indépendant
- **Repeatable** : Résultats déterministes
- **Self-validating** : Pass/Fail automatique
- **Timely** : Tests écrits avant ou avec le code

### Couverture Cible

| Couche | Cible | Justification |
|--------|-------|---------------|
| **Domain** | ≥80% | Logique métier critique |
| **Data** | ≥60% | Interactions avec persistence |
| **Presentation** | ≥40% | Widgets complexes uniquement |

### Validation du Sanctuaire

**Note Importante** : La validation philosophique du Sanctuaire (flux de vérité, respect des principes permacoles) se fait par **l'usage réel et les retours utilisateurs**, pas par des tests automatisés.

Les tests techniques se concentrent sur :
- ✅ Validation fonctionnelle (comportement correct)
- ✅ Validation structurelle (architecture respectée)
- ❌ **PAS** de validation philosophique abstraite

---

## 🏗️ Architecture de Tests

### Structure des Dossiers

```
test/
├── core/
│   ├── services/
│   │   └── aggregation/
│   │       ├── modern_data_adapter_test.dart
│   │       └── garden_aggregation_hub_test.dart
│   └── ...
├── features/
│   └── plant_intelligence/
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── analysis_result_test.dart
│       │   │   ├── intelligence_report_test.dart
│       │   │   └── ...
│       │   ├── services/
│       │   │   └── plant_intelligence_orchestrator_test.dart
│       │   └── usecases/
│       │       ├── analyze_plant_conditions_usecase_test.dart
│       │       ├── generate_recommendations_usecase_test.dart
│       │       ├── evaluate_planting_timing_usecase_test.dart
│       │       └── test_helpers.dart
│       └── data/
│           ├── repositories/
│           └── datasources/
├── integration/
│   ├── plant_intelligence_flow_test.dart
│   └── sanctuary_to_intelligence_flow_test.dart
├── helpers/
│   └── plant_intelligence_test_helpers.dart
├── TEST_PLAN_V2.2.md
├── TESTING_GUIDE.md (ce fichier)
└── CONTRIBUTION_STANDARDS.md
```

### Mapping Code ↔ Tests

**Règle** : Un fichier de code = Un fichier de test

```
lib/features/plant_intelligence/domain/usecases/analyze_plant_conditions_usecase.dart
  ↓
test/features/plant_intelligence/domain/usecases/analyze_plant_conditions_usecase_test.dart
```

---

## 🧪 Types de Tests

### 1. Tests Unitaires (Unit Tests)

**Objectif** : Tester une unité de code isolée (UseCase, méthode, fonction)

**Pattern AAA** (Arrange-Act-Assert)

```dart
test('should calculate health score correctly', () {
  // Arrange : Préparer les données
  final plant = createMockPlant();
  final weather = createMockWeather(temperature: 22.0);
  final garden = createMockGarden();
  
  // Act : Exécuter l'action
  final result = await usecase.execute(
    plant: plant,
    weather: weather,
    garden: garden,
  );
  
  // Assert : Vérifier le résultat
  expect(result.healthScore, greaterThan(75.0));
  expect(result.healthScore, lessThanOrEqualTo(100.0));
});
```

### 2. Tests d'Intégration (Integration Tests)

**Objectif** : Tester l'interaction entre plusieurs composants

```dart
testWidgets('Full flow: Sanctuary → Modern Adapter → Analysis', (tester) async {
  // ÉTAPE 1 : Créer plantation dans Sanctuaire
  final sanctuaryService = SanctuaryService();
  await sanctuaryService.createPlanting(
    gardenId: 'test_garden',
    plantId: 'spinach',
  );
  
  // ÉTAPE 2 : Récupérer via Modern Adapter
  final adapter = ModernDataAdapter();
  final plants = await adapter.getActivePlants('test_garden');
  
  // ÉTAPE 3 : Analyser
  final orchestrator = PlantIntelligenceOrchestrator();
  final analysis = await orchestrator.analyze('spinach');
  
  // Validation : Flux complet fonctionne
  expect(plants.length, equals(1));
  expect(analysis.plantId, equals('spinach'));
});
```

### 3. Tests de Widget (Widget Tests)

**Objectif** : Tester les composants UI

```dart
testWidgets('PlantAnalysisCard displays health score', (tester) async {
  // Arrange
  final analysis = createMockAnalysis(healthScore: 85.0);
  
  // Act
  await tester.pumpWidget(
    MaterialApp(
      home: PlantAnalysisCard(analysis: analysis),
    ),
  );
  
  // Assert
  expect(find.text('85%'), findsOneWidget);
  expect(find.byIcon(Icons.check_circle), findsOneWidget);
});
```

---

## 📐 Standards et Conventions

### Nommage des Tests

**Pattern** : `should_expectedBehavior_when_condition`

```dart
// ✅ BON
test('should return empty list when garden has no plantings', () {});
test('should throw ArgumentError when plantId is null', () {});
test('should calculate health score between 0 and 100', () {});

// ❌ MAUVAIS
test('test empty garden', () {});
test('error test', () {});
test('health calculation', () {});
```

### Helpers et Factories

**Principe** : Centraliser la création de données de test

```dart
// test/features/plant_intelligence/domain/usecases/test_helpers.dart

PlantFreezed createMockPlant({
  String id = 'tomato',
  String commonName = 'Tomate',
  List<String> sowingMonths = const ['M', 'A', 'M'],
  Map<String, dynamic>? metadata,
}) {
  return PlantFreezed(
    id: id,
    commonName: commonName,
    // ... autres propriétés avec valeurs par défaut
    metadata: metadata ?? _defaultMetadata(),
  );
}
```

### Mocking

**Utiliser Mockito pour les dépendances externes**

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Générer les mocks
@GenerateMocks([
  IPlantConditionRepository,
  IWeatherRepository,
  IGardenContextRepository,
])
import 'my_test.mocks.dart';

void main() {
  group('MyUseCase', () {
    late MockIPlantConditionRepository mockRepo;
    
    setUp(() {
      mockRepo = MockIPlantConditionRepository();
    });
    
    test('should call repository', () async {
      // Arrange
      when(mockRepo.getCondition(any()))
          .thenAnswer((_) async => mockCondition);
      
      // Act
      await usecase.execute();
      
      // Assert
      verify(mockRepo.getCondition(any())).called(1);
    });
  });
}
```

### Assertions Courantes

```dart
// Égalité
expect(result, equals(expected));
expect(result, isNotNull);

// Comparaisons
expect(value, greaterThan(0));
expect(value, lessThan(100));
expect(value, inRange(0, 100));

// Collections
expect(list, isEmpty);
expect(list, isNotEmpty);
expect(list, hasLength(3));
expect(list, contains('item'));
expect(list, containsAll(['a', 'b', 'c']));

// Exceptions
expect(() => method(), throwsException);
expect(() => method(), throwsA(isA<ArgumentError>()));

// Types
expect(result, isA<MyClass>());

// Custom matchers
expect(result.healthScore, closeTo(75.0, 1.0)); // ±1
```

---

## 🛠️ Outils et Commandes

### Exécution des Tests

```bash
# Tous les tests
flutter test

# Tests spécifiques
flutter test test/features/plant_intelligence/domain/

# Un seul fichier
flutter test test/features/plant_intelligence/domain/usecases/analyze_plant_conditions_usecase_test.dart

# Avec rapport détaillé
flutter test --reporter=expanded

# Avec couverture
flutter test --coverage

# Tests d'intégration uniquement
flutter test test/integration/
```

### Analyse de Couverture

```bash
# Générer rapport de couverture
flutter test --coverage

# Résumé global
lcov --summary coverage/lcov.info

# Détail par fichier
lcov --list coverage/lcov.info

# Filtrer Domain layer
lcov --extract coverage/lcov.info 'lib/features/plant_intelligence/domain/*' --output-file coverage/domain.info
lcov --summary coverage/domain.info

# Générer rapport HTML
genhtml coverage/lcov.info -o coverage/html
```

### Scripts Utiles

**`test/run_tests_with_coverage.bat`** (Windows)
```batch
@echo off
flutter test --coverage
genhtml coverage\lcov.info -o coverage\html
start coverage\html\index.html
```

**`test/run_domain_tests.sh`** (Linux/Mac)
```bash
#!/bin/bash
flutter test test/features/plant_intelligence/domain/ --coverage
echo "Domain tests completed!"
```

---

## 📖 Exemples Annotés

### Exemple 1 : Test UseCase Simple

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/usecases/analyze_plant_conditions_usecase.dart';
import 'test_helpers.dart';

void main() {
  // Grouper les tests liés
  group('AnalyzePlantConditionsUsecase', () {
    // Déclarer les dépendances
    late AnalyzePlantConditionsUsecase usecase;
    
    // setUp : Exécuté avant chaque test
    setUp(() {
      usecase = const AnalyzePlantConditionsUsecase();
    });
    
    // tearDown : Exécuté après chaque test (optionnel)
    tearDown(() {
      // Nettoyer les ressources si nécessaire
    });
    
    test('should analyze 4 conditions (temperature, humidity, light, soil)', () async {
      // ARRANGE : Préparer les données
      final plant = createMockPlant();
      final weather = createMockWeather(temperature: 22.0);
      final garden = createMockGarden();
      
      // ACT : Exécuter l'action
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // ASSERT : Vérifier les résultats
      expect(result, isA<PlantAnalysisResult>());
      expect(result.temperature, isNotNull);
      expect(result.humidity, isNotNull);
      expect(result.light, isNotNull);
      expect(result.soil, isNotNull);
      
      // Vérifier les propriétés calculées
      expect(result.healthScore, greaterThanOrEqualTo(0.0));
      expect(result.healthScore, lessThanOrEqualTo(100.0));
    });
    
    test('should throw exception when weather data is too old', () async {
      // ARRANGE
      final plant = createMockPlant();
      final oldDate = DateTime.now().subtract(const Duration(hours: 25));
      final weather = createMockWeather(measuredAt: oldDate);
      final garden = createMockGarden();
      
      // ACT & ASSERT : Vérifier l'exception
      expect(
        () => usecase.execute(plant: plant, weather: weather, garden: garden),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
```

### Exemple 2 : Test avec Mocks (Orchestrator)

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  IPlantConditionRepository,
  IWeatherRepository,
  IGardenContextRepository,
])
import 'plant_intelligence_orchestrator_test.mocks.dart';

void main() {
  group('PlantIntelligenceOrchestrator', () {
    late PlantIntelligenceOrchestrator orchestrator;
    late MockIPlantConditionRepository mockConditionRepo;
    late MockIWeatherRepository mockWeatherRepo;
    late MockIGardenContextRepository mockGardenRepo;
    
    setUp(() {
      // Créer les mocks
      mockConditionRepo = MockIPlantConditionRepository();
      mockWeatherRepo = MockIWeatherRepository();
      mockGardenRepo = MockIGardenContextRepository();
      
      // Injecter les mocks dans l'orchestrator
      orchestrator = PlantIntelligenceOrchestrator(
        conditionRepository: mockConditionRepo,
        weatherRepository: mockWeatherRepo,
        gardenRepository: mockGardenRepo,
      );
    });
    
    test('should generate complete intelligence report', () async {
      // ARRANGE : Configurer les mocks
      when(mockGardenRepo.getGardenContext('garden_1'))
          .thenAnswer((_) async => createMockGarden());
      
      when(mockWeatherRepo.getCurrentWeatherCondition('garden_1'))
          .thenAnswer((_) async => createMockWeather());
      
      when(mockConditionRepo.getPlantConditionHistory(
        plantId: anyNamed('plantId'),
        startDate: anyNamed('startDate'),
        limit: 100,
      )).thenAnswer((_) async => []);
      
      // ACT
      final report = await orchestrator.generateIntelligenceReport(
        plantId: 'tomato',
        gardenId: 'garden_1',
      );
      
      // ASSERT
      expect(report, isNotNull);
      expect(report.plantId, 'tomato');
      expect(report.analysis, isNotNull);
      
      // Vérifier les appels aux repositories
      verify(mockGardenRepo.getGardenContext('garden_1')).called(1);
      verify(mockWeatherRepo.getCurrentWeatherCondition('garden_1')).called(1);
    });
  });
}
```

---

## 🔧 Troubleshooting

### Problèmes Courants

#### 1. Tests échouent aléatoirement (Flaky Tests)

**Symptôme** : Tests passent parfois, échouent parfois

**Causes**:
- Dépendance sur `DateTime.now()` sans mock
- État partagé entre tests
- Ordres d'exécution non déterministes

**Solutions** :
```dart
// ❌ MAUVAIS : Dépendance sur temps réel
final now = DateTime.now();

// ✅ BON : Utiliser un temps fixe
final fixedDate = DateTime(2024, 1, 1, 12, 0);

// Ou mocker la date
when(mockClock.now()).thenReturn(fixedDate);
```

#### 2. Couverture trop basse

**Symptôme** : Couverture < 80% sur Domain

**Solutions** :
1. Identifier fichiers non couverts :
   ```bash
   lcov --list coverage/lcov.info | grep '0.0%'
   ```

2. Ajouter tests manquants pour :
   - Cas limites (null, vides, invalides)
   - Chemins d'erreur (exceptions)
   - Branches conditionnelles

#### 3. Tests lents (> 30s)

**Causes** :
- Appels réseau réels (pas mockés)
- Base de données réelle
- Trop de tests d'intégration

**Solutions** :
- Mocker les appels externes
- Utiliser in-memory database
- Paralléliser les tests

#### 4. Erreurs de compilation dans les tests

**Symptôme** : `The getter 'xxx' isn't defined`

**Solution** : Régénérer les mocks
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📚 Ressources Complémentaires

### Documentation Officielle
- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)

### Standards du Projet
- `test/TEST_PLAN_V2.2.md` : Plan de test complet
- `test/CONTRIBUTION_STANDARDS.md` : Standards de contribution
- `.github/workflows/flutter_tests.yml` : Configuration CI/CD

### Exemples de Référence
- `test/features/plant_intelligence/domain/usecases/` : Tests UseCases
- `test/core/services/aggregation/modern_data_adapter_test.dart` : Tests philosophie Sanctuaire

---

**Guide de Tests v2.2 — PermaCalendar Intelligence Végétale**  
**Auteur** : Équipe PermaCalendar  
**Dernière mise à jour** : Octobre 2025

