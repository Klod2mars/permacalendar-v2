# 🟥 Prompt 01 – Migration vers `plants.json v2.1.0`

**Projet :** Assainissement PermaCalendar  
**Phase :** Initialisation des données  
**Date :** 12 octobre 2025  
**Statut :** À exécuter  
**Priorité :** Critique

---

## 🎯 Objectif

Remplacer définitivement le fichier legacy `plants.json` par la version structurée `plants_v2.json`, et adapter les services pour qu’ils soient compatibles.

---

## 📋 Instructions détaillées

### 1. Sauvegarde de sécurité
- Copier le fichier actuel :
  ```bash
  cp assets/data/plants.json assets/data/plants_legacy.json.backup
  ```

### 2. Activation du nouveau format
- Remplacer le fichier :
  ```bash
  cp assets/data/plants_v2.json assets/data/plants.json
  ```

### 3. Mise à jour du code
- Modifier `plant_catalog_service.dart` pour qu’il détecte automatiquement les deux formats (legacy ou structuré)
- Ajouter un log dans `AppInitializer` pour afficher la version et la source des données au démarrage
- Créer une fonction `_validatePlantData()` si elle n’existe pas encore

### 4. Tests
- Créer un fichier de test unitaire dans `test/core/data/` :
  - Vérifie que `schema_version` = `"2.1.0"`
  - Vérifie la cohérence entre `metadata.total_plants` et la longueur du tableau
  - Vérifie qu’aucun champ obsolète ne subsiste

### 5. Nettoyage final
- Supprimer le fichier `plants_v2.json` devenu inutile
  ```bash
  rm assets/data/plants_v2.json
  ```

---

## ✅ Livrables attendus

- `assets/data/plants.json` → version 2.1.0
- `assets/data/plants_legacy.json.backup` → backup de sécurité
- `lib/core/services/plant_catalog_service.dart` → modifié
- `lib/app_initializer.dart` → modifié
- `test/core/data/plants_json_v2_validation_test.dart` → nouveau test

---

## 🧪 Tests à effectuer

- L’application démarre sans erreur
- Le catalogue de plantes s’affiche correctement
- Les données sont bien analysées dans le module Intelligence Végétale
- Le test unitaire passe

---

## 🟢 Bénéfices

- Précision accrue des analyses
- Métadonnées disponibles et exploitables
- Structure versionnée compatible avec les évolutions futures
