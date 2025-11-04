# 🟨 Prompt 03 – Rationalisation des providers d’activités

**Projet :** Assainissement PermaCalendar  
**Phase :** Réduction des redondances  
**Date :** 12 octobre 2025  
**Statut :** À exécuter  
**Priorité :** Élevée

---

## 🎯 Objectif

Réduire les 5 providers liés aux activités à un seul provider propre et centralisé autour du service unifié `ActivityTrackerV3`.

---

## 📋 Instructions

### 1. Analyse
- Identifier les 5 providers actuels :
  - `activity_provider.dart`
  - `activity_service_provider.dart`
  - `activity_service_simple_provider.dart`
  - `activity_tracker_v3_provider.dart`
  - `activity_unified_provider.dart`

### 2. Conception d’un provider unique
- Créer un seul provider basé sur le service `ActivityTrackerV3`
- Nom suggéré : `activityProvider`
- Utiliser `Provider.autoDispose` si pertinent
- Ajouter les logs nécessaires pour les diagnostics

### 3. Migration des usages
- Rechercher tous les fichiers utilisant les anciens providers
- Les remplacer par le nouveau provider
- Supprimer les anciens fichiers

---

## ✅ Fichier attendu

- `lib/core/providers/activity_provider.dart` → version unique
- Autres providers supprimés

---

## 🧪 Tests à réaliser

- L'application compile sans erreur
- Les écrans qui utilisent les activités (dashboard, récapitulatif, historique) s’affichent correctement
- Les activités sont bien récupérées via le nouveau provider

---

## 🧠 Conseils

- Ajouter une documentation inline au provider unifié
- Si certains anciens providers avaient des spécificités métier, intégrer leur logique dans des méthodes du service central
