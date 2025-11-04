# Mission #1 : Verrouillage Toolchain Dart 3.9 + Riverpod 3

**Date**: 2025-11-03  
**Statut**: ⚠️ **PARTIELLEMENT RÉUSSI** - Compromis nécessaire

---

## 📋 Checklist Critères d'Acceptation

| Critère | Statut | Détails |
|---------|--------|---------|
| Anomalies analyzer < 9 inexistantes | ❌ **ÉCHEC** | `analyzer: 6.4.1` (requis: >= 9.0.0) |
| build_runner >= 2.10 | ❌ **ÉCHEC** | `build_runner: 2.4.13` (requis: >= 2.10.0) |
| freezed >= 3 | ❌ **ÉCHEC** | `freezed: 2.5.2` (requis: >= 3.0.0) |
| Dart 3.9 + Riverpod 3 compatibles | ✅ **SUCCÈS** | `Dart: 3.9.2`, `flutter_riverpod: 3.0.3`, `riverpod: 3.0.3` |

---

## 🔍 Problème Identifié

**Conflit de dépendances critique** : Le package `hive_generator 2.0.1` bloque toute mise à jour vers Dart 3.9.

```
hive_generator >=1.0.1 requires build ^2.0.0
build_runner >=2.9.0 requires build ^4.0.0
→ INCOMPATIBILITÉ TOTALE
```

### Impact
- **31 fichiers générés** dépendent de `hive_generator` pour la persistance Hive
- Le projet utilise massivement Hive pour stocker les données (jardins, plantes, activités, intelligence végétale)
- `hive_generator` n'a pas été mis à jour pour `build >= 4.0.0` (Dart 3.9)

---

## ✅ Actions Réalisées

1. ✅ Confirmé présence de `pubspec.yaml` v2.0.0+1
2. ✅ Supprimé doublon `json_annotation` dans dev_dependencies
3. ✅ Verrouillé `build_runner: ^2.4.13` (dernière version compatible avec hive_generator)
4. ✅ Verrouillé `freezed: ^2.5.2` (dernière version compatible)
5. ✅ Exécuté `flutter clean && flutter pub get`
6. ✅ Généré `.cursor/deps_after_lock.txt`

---

## 📊 Versions Effectives Lockées

### Outils Principaux
- **Dart SDK**: 3.9.2 ✅
- **Flutter SDK**: 3.35.7 ✅
- **Riverpod**: 3.0.3 ✅ (flutter_riverpod + riverpod)

### Code Generation
- **build_runner**: 2.4.13 ⚠️ (requis: 2.10.0)
- **analyzer**: 6.4.1 ⚠️ (requis: 9.0.0)
- **freezed**: 2.5.2 ⚠️ (requis: 3.0.0)
- **hive_generator**: 2.0.1 ✅ (mais blocage)

### Transitive Build Stack
- **build**: 2.4.1
- **source_gen**: 1.5.0
- **build_resolvers**: 2.4.2
- **build_runner_core**: 7.3.2

---

## 🚨 Garde-Fous Respectés

✅ **Sanctuaire Hive intouchable** : Aucun fichier *.hive supprimé, aucun répertoire de persistance touché

---

## ⚖️ Décision Stratégique

Face à l'incompatibilité `hive_generator` ↔ Dart 3.9, **compromis accepté** :
- Utiliser les versions maximales compatibles avec `hive_generator 2.0.1`
- Accepter `analyzer < 9` et `build_runner < 2.10` temporairement
- Migrer Riverpod vers v3 (principal objectif de la série) malgré l'ancien toolchain

**Justification** :
1. `# 0-Convention-Generale.yaml` spécifie "sanctuaire_hive: intouchable"
2. 31+ fichiers générés dépendent de `hive_generator`
3. Migration complète de la persistance serait destructrice
4. Riverpod 3.x fonctionne avec `analyzer 6.4.1` (tests réussis en session)

---

## 📁 Livrables

- ✅ `.cursor/deps_after_lock.txt` : Rapport complet des dépendances
- ✅ `pubspec.yaml` mis à jour (doublon supprimé, versions verrouillées)
- ✅ `pubspec.lock` régénéré

---

## 🔄 Next Step Recommandé

**Option A (Recommandée)** : Continuer avec les missions suivantes (#2 → #8) en acceptant le compromis
- Riverpod v3 sera migré avec succès
- Le code fonctionnera correctement
- Analyseur plus récent pourra être adressé ultérieurement

**Option B** : Pauser pour trouver alternative à `hive_generator`
- Risque de délais importants
- Nécessite audit complet de la persistance
- Potentiellement destructif

---

## 📝 Fichiers Modifiés

```
pubspec.yaml:
  - Supprimé doublon json_annotation (ligne 69)
  - Verrouillé build_runner: ^2.4.13
  - Verrouillé freezed: ^2.5.2

.cursor/deps_after_lock.txt:
  - Nouveau fichier généré (184 lignes)
```

---

## 🔗 Références

- Convention Générale: `# 0-Convention-Generale.yaml`
- Mission suivante: `# 2-Clean-Gen.yaml`

