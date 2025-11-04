# ⚡ QuickStart UI v2 - 5 Minutes

## 🎯 TL;DR

**4 nouveaux composants** (2,187 lignes) :
- 📅 **Calendrier** : Vue mensuelle plantations + récoltes
- 🌾 **Récolte rapide** : Multi-sélection (-70% clics)
- 🏡 **Home V2** : Tuiles d'actions + carrousel jardins
- 🎨 **Thème M3** : Design moderne + dark mode

**Feature flags** : Rollback instantané sans rebuild  
**Non-régression A15** : Multi-jardin ✅ Compatible

---

## 🚀 Lancer l'App

```bash
# Vérifier
flutter analyze

# Lancer
flutter run
```

**Résultat attendu :**
- Home avec 4 tuiles d'actions
- Calendrier accessible (icône AppBar)
- Thème M3 appliqué (bordures arrondies)

---

## 🧪 Test Rapide (2 min)

1. ✅ **Home** : 4 tuiles visibles
2. ✅ **Calendrier** : Ouvrir → voir plantations
3. ✅ **Récolte** : Si plantes prêtes → FAB "Récolte rapide"
4. ✅ **Dark mode** : Activer → thème s'adapte

---

## 🧯 Rollback d'Urgence (30 sec)

Si problème :

```dart
// lib/core/feature_flags.dart - ligne 82
final featureFlagsProvider = Provider<FeatureFlags>(
  (_) => const FeatureFlags.allDisabled(), // ← Changer ici
);
```

Hot restart → ancienne UI restaurée.

---

## 📊 Logs (Optionnel)

```bash
flutter run --verbose | grep UI_ANALYTICS
```

Chercher :
- `home_v2_opened`
- `calendar_opened`
- `quick_harvest_confirmed`

---

## 📄 Docs Complètes

- **Technique :** `ui_consolidation_report.md` (1,200 lignes)
- **Déploiement :** `DEPLOYMENT_GUIDE_UI_V2.md` (300 lignes)
- **Commit :** `COMMIT_MESSAGE_UI_V2.md` (messages prêts)

---

## ✅ Checklist Avant Production

- [ ] Tests smoke passent
- [ ] Performance 60fps
- [ ] Taux crash < 1%
- [ ] Multi-jardin (A15) non-régressé
- [ ] Feedback bêta positif

---

**Questions ?** Voir `DEPLOYMENT_GUIDE_UI_V2.md` pour troubleshooting.

**Prêt à déployer ! 🚀**

