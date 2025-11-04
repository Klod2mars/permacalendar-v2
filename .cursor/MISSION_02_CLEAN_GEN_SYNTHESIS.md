# Mission #2 : Clean-Gen - Vue d'ensemble logique complète

**Date**: 2025-11-03  
**Statut**: 🚀 **EN COURS**

---

## 📋 Vue d'ensemble de la logique complète

### Objectif principal
Nettoyer les fichiers générés obsolètes puis régénérer proprement avec la pile de génération compatible (legacy stack alignée sur Mission #1).

### Contexte stratégique
- **Mission #1** : Compromis accepté → `build_runner 2.4.13`, `analyzer 6.4.1`, `freezed 2.5.2` (compatibilité `hive_generator 2.0.1`)
- **Sanctuaire Hive** : 31+ fichiers générés dépendent de `hive_generator`, aucun adapter écrit à la main
- **Objectif** : Régénération propre avant migration Riverpod 3 (#3 → #5)

---

## 🔍 Inventaire des fichiers générés

### Fichiers `.g.dart` (Hive adapters + codegen divers)
- **44 fichiers** identifiés
- Tous générés automatiquement (marqueur "GENERATED CODE - DO NOT MODIFY BY HAND")
- Sources principales :
  - `lib/core/models/*.g.dart` (gardens, plants, activities, etc.)
  - `lib/features/plant_intelligence/domain/entities/*.g.dart` (Hive entities)
  - `lib/features/plant_catalog/data/models/*.g.dart`
  - `lib/features/climate/data/datasources/*.g.dart`

### Fichiers `.freezed.dart` (Freezed immutable models)
- **30 fichiers** identifiés
- Générés automatiquement par `freezed 2.5.2`
- Sources principales :
  - `lib/core/models/*.freezed.dart`
  - `lib/features/plant_intelligence/domain/entities/*.freezed.dart`
  - `lib/features/statistics/domain/models/*.freezed.dart`

### ✅ Vérification sécurité
- **Aucun adapter Hive écrit à la main** : tous sont générés
- **Fichiers source protégés** : Les `.dart` sources (ex: `garden_context_hive.dart`) ne seront **PAS** supprimés
- **Seuls les artefacts générés** seront supprimés puis régénérés

---

## 🛠️ Actions prévues

### 1. Suppression ciblée
```bash
# Commandes prévues (adaptées Windows PowerShell)
# Suppression des *.g.dart et *.freezed.dart uniquement
```

**Garde-fous** :
- ✅ Ne supprime que les fichiers avec extensions `.g.dart` et `.freezed.dart`
- ✅ Ne touche pas aux fichiers source `.dart`
- ✅ Ne touche pas aux répertoires de données Hive
- ✅ Ne touche pas aux caches système (`.dart_tool/build/` sera nettoyé par `build_runner`)

### 2. Régénération complète
```bash
dart run build_runner build --delete-conflicting-outputs
```

**Paramètres** :
- `--delete-conflicting-outputs` : Supprime les conflits résiduels
- Utilise la pile verrouillée (Mission #1) : `build_runner 2.4.13`, `analyzer 6.4.1`, `freezed 2.5.2`

---

## 📊 Critères d'acceptation

| Critère | Statut | Détails |
|---------|--------|---------|
| `build_runner build` termine sans erreur fatale | ⏳ En attente | Log sauvegardé dans `.cursor/build_gen_step2.log` |
| Présence des `.g.dart` attendus | ⏳ En attente | Vérification post-génération |
| Présence des `.freezed.dart` attendus | ⏳ En attente | Vérification post-génération |
| Aucun fichier source supprimé | ⏳ En attente | Vérification git status |
| Sanctuaire Hive intact | ⏳ En attente | Aucune modification des répertoires Hive/data |
| `pubspec.lock` inchangé côté versions | ⏳ En attente | Toujours `build_runner 2.4.13`, `analyzer 6.4.1`, etc. |

---

## 🚨 Garde-fous explicites

### Sanctuaire Hive
- ✅ **Aucune modification** des répertoires de persistance Hive
- ✅ **Aucune suppression** d'adapters écrits à la main (vérifié : aucun trouvé)
- ✅ **Aucune modification** des fichiers source contenant `@HiveType` / `@HiveField`

### Suppression contrôlée
- ✅ Cible uniquement les fichiers générés (`*.g.dart`, `*.freezed.dart`)
- ✅ Ne supprime pas les sources `lib/**/*.dart` (hors `.g.dart` / `.freezed.dart`)
- ✅ Ne supprime pas les caches système (géré par `build_runner`)
- ✅ Ne supprime pas les répertoires `config/state/`, `assets/data/`, etc.

### Isolation des risques
- ✅ Commande `build_runner` avec pile legacy (pas de tentative d'upgrade)
- ✅ Log complet sauvegardé pour diagnostic
- ✅ Commit garde-fou recommandé avant exécution

---

## 🔄 Dépendances croisées & compatibilité

### Impact Mission #1
- **Pile legacy acceptée** : `build_runner 2.4.13` + `analyzer 6.4.1` + `freezed 2.5.2`
- **Compatible avec Riverpod 3** : Riverpod 3 ne dépend pas d'`analyzer 9`
- **Blocage connu** : `hive_generator 2.0.1` impose `build ^2.0.0`, incompatible avec `build_runner >= 2.10`

### Impact missions suivantes
- **#3 Imports-Riverpod3** : Pas d'exigence directe sur la pile de génération
- **#4 Migration-Notifier** : Pas d'exigence directe sur la pile de génération
- **#5 Fixers-Cascade** : Pas d'exigence directe sur la pile de génération
- **#6 Run-Stable** : Nécessite une base génération saine (résultat attendu de #2)

### Conclusion
✅ Le compromis de Mission #1 n'empêche pas la migration Riverpod 3 (#3 → #5)  
✅ Mission #2 est faisable avec la pile legacy  
✅ Régénération propre préparera les étapes suivantes

---

## 📁 Livrables attendus

- ✅ `.cursor/build_gen_step2.log` : Log complet de l'exécution `build_runner`
- ✅ Rapport final (ce document) : Statut d'exécution et résultats
- ✅ Git status post-génération : Vérification des fichiers régénérés

---

## 🔗 Références

- Mission précédente : `# 1-Toolchain-Lock.yaml` → `.cursor/MISSION_01_TOOLCHAIN_LOCK_REPORT.md`
- Mission suivante : `# 3-Imports-Riverpod3.yaml`
- Convention générale : `# 0-Convention-Generale.yaml`

---

## ⚡ Risques & parades

### Risque 1 : "Delete conflicting outputs" supprime trop large
**Parade** :
- Liste préalable des fichiers à supprimer (git status)
- Confirmation que seuls les artefacts générés sont ciblés
- Commit garde-fou avant exécution

### Risque 2 : Incompatibilité silencieuse d'un générateur
**Parade** :
- Si erreur `build_runner`, isoler le builder problématique
- Valider Hive/freezed d'abord, puis réintroduire les générateurs Riverpod
- Log complet pour diagnostic

### Risque 3 : Régressions après régénération
**Parade** :
- Vérification post-génération des fichiers attendus
- "BAT Jaune" (Clean Run) pour smoke test
- Git diff pour vérifier les changements

---

## 🎯 Next Step

Après validation de Mission #2 :
→ **Mission #3 : Imports-Riverpod3** (passe large de réécriture d'imports)

---

**Rapport généré le** : 2025-11-03  
**Exécuteur** : Auto (Agent Router)

