# 🟧 Prompt 02 – Unification des services d’activités

**Projet :** Assainissement PermaCalendar  
**Phase :** Refactorisation des services  
**Date :** 12 octobre 2025  
**Statut :** À exécuter  
**Priorité :** Élevée

---

## 🎯 Objectif

Supprimer les implémentations redondantes de services d’activités (`ActivityService`, `ActivityServiceSimple`, `ActivityTrackerV3`) et ne conserver qu’un service unifié, idéalement basé sur `ActivityTrackerV3`.

---

## 📋 Étapes à suivre

### 1. Cartographie
- Identifier les différences de logique entre :
  - `ActivityService`
  - `ActivityServiceSimple`
  - `ActivityTrackerV3`

### 2. Standardisation
- Consolider toutes les fonctionnalités nécessaires dans `ActivityTrackerV3` :
  - Cache interne
  - Filtrage des doublons
  - Singleton et accès global
- Veiller à ce que les anciennes features critiques soient conservées si encore utiles

### 3. Migration des données Hive
- Créer un script de migration de la box `activities` → `activities_v3` si les modèles sont différents
- Vérifier que toutes les données sont conservées et cohérentes

### 4. Nettoyage
- Supprimer les anciens services ou les marquer `@Deprecated`
- Supprimer les anciennes boxes Hive si elles ne sont plus utilisées

### 5. Réadaptation du code
- Mettre à jour toutes les références à `ActivityService` et `ActivityServiceSimple` vers le service unifié

---

## ✅ Livrables attendus

- `lib/core/services/activity_tracker_v3.dart` → version unifiée
- `lib/core/services/activity_service.dart`, `activity_service_simple.dart` → supprimés ou dépréciés
- Migration Hive validée

---

## 🧪 Tests à réaliser

- Création d’une activité dans l’application
- Affichage dans le dashboard et les modules d’historique
- Vérification que les anciennes données sont bien présentes après migration
- Tests unitaires associés

---

## 🔁 Bonnes pratiques

- Utiliser un modèle `ActivityV3` unique et structuré
- Documenter clairement les responsabilités du service unifié
