# 🚀 Guide de Déploiement UI v2 - Express

**Durée estimée :** 15-20 minutes  
**Risque :** 🟢 Faible (rollback instantané via feature flags)

---

## ⚡ Quick Start (5 minutes)

### 1. Build & Run

```bash
# Vérifier qu'il n'y a pas d'erreurs
flutter analyze

# Lancer en mode debug
flutter run

# OU build release (Android)
flutter build apk --release
```

### 2. Vérification Rapide

✅ **App démarre** sans crash  
✅ **Home V2** s'affiche avec les 4 tuiles d'actions  
✅ **Calendrier** accessible depuis l'icône dans l'AppBar  
✅ **Thème M3** appliqué (bordures arrondies, couleurs harmonieuses)  

---

## 🧪 Tests Smoke (10 minutes)

Ouvrir l'app sur un device réel ou émulateur :

### Test 1: Home V2
- [ ] Les 4 tuiles d'actions sont visibles
- [ ] Le carrousel de jardins scroll horizontalement
- [ ] Les activités récentes s'affichent (3 dernières)
- [ ] Clic sur une tuile → navigation correcte

### Test 2: Calendrier
- [ ] Ouvrir le calendrier (icône dans AppBar)
- [ ] Mois courant affiché
- [ ] Chevrons gauche/droite changent de mois
- [ ] Clic sur une date avec plantation → détails affichés

### Test 3: Récolte Rapide
- [ ] Si plantes prêtes : FAB "Récolte rapide" apparaît
- [ ] Ouvrir le widget → liste des plantes
- [ ] Sélectionner 2 plantes → compteur = 2
- [ ] Cliquer "Récolter" → confirmation → succès

### Test 4: Multi-Jardin (Non-régression A15)
- [ ] Créer/Ouvrir 2 jardins différents
- [ ] Planter dans jardin A
- [ ] Planter dans jardin B
- [ ] Vérifier que les deux apparaissent dans le calendrier
- [ ] Pas de contamination entre jardins

### Test 5: Navigation & Performance
- [ ] Back button fonctionne correctement
- [ ] Pas de jank au scroll (60fps)
- [ ] Transitions fluides
- [ ] Pas de memory leak (relancer plusieurs fois)

### Test 6: Dark Mode
- [ ] Passer en mode sombre (system settings)
- [ ] Thème s'adapte correctement
- [ ] Contraste lisible partout

---

## 🧯 Rollback d'Urgence (30 secondes)

Si problème critique détecté :

```dart
// lib/core/feature_flags.dart
final featureFlagsProvider = Provider<FeatureFlags>(
  (_) => const FeatureFlags.allDisabled(), // ← Changer cette ligne
);
```

**Hot Restart** l'app → retour à l'ancienne UI instantanément.

### Rollback Partiel

Si seulement un composant pose problème :

```dart
// Désactiver seulement le calendrier
const FeatureFlags(
  homeV2: true,
  calendarView: false, // ← Désactivé
  quickHarvest: true,
  materialDesign3: true,
)

// OU désactiver seulement Home V2
const FeatureFlags(
  homeV2: false, // ← Désactivé
  calendarView: true,
  quickHarvest: true,
  materialDesign3: true,
)
```

---

## 📊 Instrumentation (Logs)

### Activer les Logs

Les logs sont activés par défaut. Chercher `[UI_ANALYTICS]` dans les logs :

```bash
flutter run --verbose | grep UI_ANALYTICS
```

### Événements à Surveiller

| Événement | Signification | Action si Absent |
|-----------|---------------|------------------|
| `home_v2_opened` | Home V2 chargé | Vérifier feature flag |
| `calendar_opened` | Calendrier utilisé | OK si 0 (pas découvert) |
| `quick_harvest_opened` | Récolte rapide utilisée | OK si 0 (pas de plantes prêtes) |
| `quick_harvest_confirmed` | Récolte effectuée | ✅ Succès du parcours |

### Désactiver Temporairement

```dart
// Dans main.dart ou avant runApp
UIAnalytics.disable();
```

---

## 🔢 KPIs à Monitorer (Bêta)

### Jour 1-2 (Détection Problèmes)

- **Taux de crash** : Doit rester < 1%
- **ANR (Android Not Responding)** : 0 toléré
- **Erreurs réseau** : Si > 5%, vérifier offline handling

### Jour 3-7 (Adoption)

- **% sessions avec `/calendar`** : Objectif > 20%
- **% récoltes via QuickHarvest** : Objectif > 50%
- **Durée moyenne session** : Doit augmenter de 10-20%

### Semaine 2+ (Satisfaction)

- **NPS (Net Promoter Score)** : Objectif ≥ 8/10
- **Taux d'abandon récolte** : Doit baisser de 30%
- **Feedback qualitatif** : Collecter via formulaire in-app

---

## 📱 Commandes Utiles

### Développement

```bash
# Hot reload (préserve l'état)
r

# Hot restart (repart de zéro)
R

# Analyser les performances
flutter run --profile
# → DevTools: http://127.0.0.1:9100

# Vérifier la taille de build
flutter build apk --analyze-size
```

### Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/

# Tests d'un fichier spécifique
flutter test test/features/home/screens/calendar_view_screen_test.dart
```

### Build Production

```bash
# Android (APK)
flutter build apk --release --split-per-abi

# Android (App Bundle - recommandé Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 🐛 Troubleshooting

### Problème: "Home V2 ne s'affiche pas"

**Solution:**
```dart
// Vérifier lib/core/feature_flags.dart
const FeatureFlags(
  homeV2: true, // ← Doit être true
  ...
)
```

### Problème: "Thème M3 pas appliqué"

**Solution:**
```dart
// Vérifier lib/core/feature_flags.dart
const FeatureFlags(
  materialDesign3: true, // ← Doit être true
  ...
)

// ET vérifier lib/main.dart
final lightTheme = flags.materialDesign3 
    ? AppThemeM3.lightTheme  // ← Import correct
    : AppTheme.lightTheme;
```

### Problème: "Calendrier 404"

**Solution:**
```dart
// Vérifier lib/app_router.dart
if (flags.calendarView) // ← Route conditionnelle présente
  GoRoute(
    path: AppRoutes.calendar,
    ...
  ),
```

### Problème: "QuickHarvest ne s'ouvre pas"

**Solution:**
- Vérifier qu'il y a des plantes avec statut "Prêt à récolter"
- Vérifier `quickHarvest: true` dans les flags
- Chercher les logs d'erreur dans la console

---

## 📋 Checklist Pré-Production

Avant de déployer à 100% des utilisateurs :

- [ ] Tous les tests smoke passent
- [ ] Performance 60fps confirmée
- [ ] Taux de crash < 1% sur 48h de bêta
- [ ] Feedback bêta majoritairement positif (≥ 70%)
- [ ] Documentation mise à jour
- [ ] Rollback plan validé et testé
- [ ] Logs d'analytics propres (pas de spam)
- [ ] Multi-jardin (A15) non-régressé confirmé

---

## 🎯 Stratégie de Rollout Recommandée

### Phase 1: Interne (Jour 0-2)
- **Audience:** Développeurs + 2-3 power users
- **Flags:** `FeatureFlags.beta()`
- **Objectif:** Détecter bugs bloquants

### Phase 2: Bêta Fermée (Jour 3-7)
- **Audience:** 10-20 utilisateurs volontaires
- **Flags:** `FeatureFlags.beta()`
- **Objectif:** Valider adoption + KPIs

### Phase 3: Rollout Progressif (Semaine 2)
- **Jour 8-10:** 25% des utilisateurs
- **Jour 11-12:** 50% des utilisateurs
- **Jour 13-14:** 100% des utilisateurs

### Phase 4: Stabilisation (Semaine 3+)
- Monitoring continu
- Itérations mineures (libellés, tailles, couleurs)
- Collecte feedback long-terme

---

## 🔗 Ressources

- **Rapport complet:** `ui_consolidation_report.md`
- **Feature flags:** `lib/core/feature_flags.dart`
- **Analytics:** `lib/core/analytics/ui_analytics.dart`
- **Tests:** `test/features/home/` et `test/shared/widgets/`

---

## ✉️ Contact

**Questions techniques:** [Votre équipe dev]  
**Rapports de bugs:** GitHub Issues  
**Feedback utilisateurs:** [Formulaire in-app ou email]

---

**Bon déploiement ! 🚀**

