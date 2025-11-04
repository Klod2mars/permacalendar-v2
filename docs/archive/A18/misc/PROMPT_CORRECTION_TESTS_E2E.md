# 🔧 PROMPT CORRECTION TESTS E2E - Intelligence Végétale v2.2

## **Contexte**
Les tests d'intégration E2E de la lutte biologique échouent à cause d'incompatibilités avec le modèle `Plant`. Le fichier `test/integration/biological_control_e2e_test.dart` utilise des propriétés et constructeurs qui n'existent plus dans le modèle actuel.

## **Erreurs Identifiées**

### **Problèmes de Compilation**
```
Error: Undefined name 'PlantCategory'
Error: Undefined name 'Climate' 
Error: Undefined name 'SunExposure'
Error: Undefined name 'WaterNeeds'
Error: Undefined name 'SoilType'
Error: Couldn't find constructor 'PlantRequirements'
Error: No named parameter with the name 'category'
```

### **Cause Racine**
Le test utilise un ancien modèle `Plant` avec :
- Propriété `category` (n'existe plus)
- Constructeur `PlantRequirements` (n'existe plus)
- Enums `PlantCategory`, `Climate`, `SunExposure`, etc. (n'existent plus)

## **Mission**

### **Objectif Principal**
Corriger le fichier `test/integration/biological_control_e2e_test.dart` pour qu'il soit compatible avec le modèle `Plant` actuel et que les 3 scénarios E2E passent avec succès.

### **Actions Requises**

#### 1. **Analyser le Modèle Plant Actuel**
- Examiner `lib/core/models/plant.dart`
- Identifier la structure actuelle du constructeur
- Lister les propriétés disponibles
- Comprendre les types et enums utilisés

#### 2. **Corriger les Objets Plant de Test**
Dans `biological_control_e2e_test.dart`, corriger les 3 instances Plant :
- **Ligne ~117** : Plant "Tomate" 
- **Ligne ~179** : Plant "Capucine"
- **Ligne ~368** : Plant "Carotte"

**Remplacer :**
```dart
// ❌ ANCIEN (ne fonctionne plus)
Plant(
  id: 'tomato',
  name: 'Tomate',
  category: plant_model.PlantCategory.vegetable,  // ❌
  requirements: const plant_model.PlantRequirements(  // ❌
    climate: plant_model.Climate.temperate,  // ❌
    sunExposure: plant_model.SunExposure.fullSun,  // ❌
    waterNeeds: plant_model.WaterNeeds.moderate,  // ❌
    soilType: plant_model.SoilType.loam,  // ❌
  ),
)
```

**Par :**
```dart
// ✅ NOUVEAU (compatible modèle actuel)
Plant(
  id: 'tomato',
  name: 'Tomate',
  // Utiliser UNIQUEMENT les propriétés qui existent dans le modèle actuel
  // Adapter selon la structure réelle trouvée dans plant.dart
)
```

#### 3. **Vérifier les Imports**
- S'assurer que les imports sont corrects
- Supprimer les imports d'enums inexistants
- Ajouter les imports manquants si nécessaire

#### 4. **Valider les Tests**
Après correction, vérifier que :
```bash
flutter test test/integration/biological_control_e2e_test.dart
```
Retourne : **3/3 tests passent** ✅

### **Scénarios E2E à Valider**

#### **Scénario 1 : Flux E2E Complet**
1. Créer observation ravageur sur tomate
2. Analyser menaces du jardin
3. Générer recommandations biologiques
4. Vérifier cohérence des données

#### **Scénario 2 : Sévérité Critique → Priorité Urgente**
1. Observer ravageur avec sévérité CRITIQUE
2. Vérifier que recommandations ont priorité 1 (urgent)
3. Vérifier inclusion huile de neem pour sévérité haute

#### **Scénario 3 : Multiples Observations → Agrégation**
1. Créer plusieurs observations (tomate + carotte)
2. Analyser menaces globales du jardin
3. Vérifier agrégation correcte des statistiques

## **Contraintes Techniques**

### **Respect de l'Architecture**
- ✅ Garder la logique des tests inchangée
- ✅ Corriger UNIQUEMENT les objets Plant incompatibles
- ✅ Maintenir les 3 scénarios existants
- ✅ Préserver les assertions et validations

### **Philosophie du Sanctuaire**
- ✅ Tests doivent valider le flux : Observation → Analyse → Recommandation
- ✅ Vérifier que l'utilisateur crée les observations
- ✅ Vérifier que l'IA génère les recommandations
- ✅ Aucune modification du Sanctuaire par l'IA

## **Livrables Attendus**

### **Fichier Corrigé**
- `test/integration/biological_control_e2e_test.dart` fonctionnel

### **Validation**
```bash
# Commande de validation
flutter test test/integration/ --reporter=compact

# Résultat attendu
00:01 +3: All tests passed! ✅
```

### **Rapport de Correction**
Documenter :
- Propriétés Plant supprimées vs ajoutées
- Changements apportés aux 3 objets Plant
- Confirmation que les 3 scénarios passent

## **Temps Estimé**
**30-45 minutes** maximum

## **Critères de Succès**

| Critère | Validation |
|---------|-----------|
| **Compilation** | ✅ Aucune erreur de compilation |
| **Tests E2E** | ✅ 3/3 scénarios passent |
| **Logique préservée** | ✅ Assertions inchangées |
| **Architecture respectée** | ✅ Flux Sanctuaire validé |

---

## **Instructions Spécifiques**

1. **Commencer par** : `flutter test test/integration/ --reporter=compact` pour voir les erreurs
2. **Examiner** : `lib/core/models/plant.dart` pour comprendre le modèle actuel
3. **Corriger** : Les 3 objets Plant dans le fichier de test
4. **Valider** : Relancer les tests jusqu'à 3/3 succès
5. **Documenter** : Les changements apportés

---

**Mission** : Finaliser la validation automatique du module Intelligence Végétale v2.2 en corrigeant les tests E2E ! 🚀🌱