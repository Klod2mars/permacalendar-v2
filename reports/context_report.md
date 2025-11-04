# Rapport d'Audit - Perte de selectedCommune

**Date**: 2025-11-02  
**Mission**: READ-2025-11-02-003  
**Intention**: root_cause_weather_persistence  
**Auditeurs**: AI Auto & User

---

## 🎯 Résumé Exécutif

La perte de `selectedCommune` entre deux lancements de l'application est causée par **une divergence critique entre les noms de boxes Hive** utilisées lors de la migration et par le repository de settings.

### Cause Racine

| Composant | Box Hive Utilisée | Fichier | Ligne |
|-----------|-------------------|---------|-------|
| **Migration** | `'app_settings_v2'` | `lib/app_initializer.dart` | 527 |
| **Repository** | `'app_settings'` | `lib/core/repositories/settings_repository.dart` | 12 |

**Résultat** : Les données migrées sont sauvegardées dans `app_settings_v2` mais le repository lit depuis `app_settings`, créant une désynchronisation permanente.

---

## 📋 Timeline d'Initialisation

### Phase 1 : Migration (app_initializer.dart:520-590)

```dart
// Ligne 527 : Migration sauvegarde dans 'app_settings_v2'
final appSettingsBox = await Hive.openBox<AppSettings>('app_settings_v2');

// Ligne 530-534 : Skip si déjà migré
if (appSettingsBox.containsKey('current_settings')) {
  print('✅ AppSettings already exists, skipping migration');
  return;
}

// Ligne 562-566 : Migration de selectedCommune depuis ancien système
final appSettings = AppSettings.defaults();
if (migratedCommune != null) {
  appSettings.selectedCommune = migratedCommune;
}

// Ligne 569 : SAUVEGARDE DANS 'app_settings_v2'
await appSettingsBox.put('current_settings', appSettings);
```

**État après migration** :
- ✅ Box `'app_settings_v2'` contient `AppSettings` avec `selectedCommune`
- ❌ Box `'app_settings'` est vide ou inexistante

### Phase 2 : Initialisation du Provider (app_settings_provider.dart:20-30)

```dart
// Ligne 21-30 : Provider démarre
AppSettings build() {
  _repository = ref.read(settingsRepositoryProvider);
  _loadSettings();  // Appel asynchrone
  return AppSettings.defaults();  // ⚠️ Retour immédiat avec defaults
}
```

**Timing critique** : Le provider retourne immédiatement des defaults, puis charge les vraies valeurs en async.

### Phase 3 : Chargement par le Repository (settings_repository.dart:18-26)

```dart
// Ligne 18-26 : Initialize ouvre 'app_settings'
Future<void> initialize() async {
  _box = await Hive.openBox<AppSettings>(_boxName);  // _boxName = 'app_settings'
  print('✅ SettingsRepository initialized');
}

// Ligne 12 : Définition de _boxName
static const String _boxName = 'app_settings';  // ⚠️ PAS 'app_settings_v2'
```

**Incohérence** : Repository ouvre `'app_settings'` alors que migration sauvegarde dans `'app_settings_v2'`.

### Phase 4 : Première Lecture (settings_repository.dart:39-49)

```dart
// Ligne 39-49 : Première lecture
Future<AppSettings> loadSettings() async {
  final box = await _ensureBox;  // Box 'app_settings'
  final settings = box.get(_settingsKey);  // null car vide !
  
  if (settings == null) {
    print('📋 No settings found, using defaults');
    final defaults = AppSettings.defaults();  // ⚠️ selectedCommune = null
    await saveSettings(defaults);  // ⚠️ ÉCRASEMENT
    return defaults;
  }
}
```

**Séquence fatale** :
1. Repository lit depuis `'app_settings'` → **null** (box vide)
2. Repository crée des defaults avec `selectedCommune = null`
3. Repository **sauvegarde les defaults** dans `'app_settings'`
4. Les données migrées dans `'app_settings_v2'` sont **ignorées définitivement**

---

## 🔍 Tableau des Écritures

| Ordre | Action | Box | Clé | Valeur selectedCommune | Fichier | Ligne |
|-------|--------|-----|-----|----------------------|---------|-------|
| 1 | Migration initiale | `app_settings_v2` | `current_settings` | `migratedCommune` | app_initializer.dart | 569 |
| 2 | Repository init (premier accès) | `app_settings` | `current_settings` | **null** (defaults) | settings_repository.dart | 47 |
| 3 | Utilisateur sélectionne commune | `app_settings` | `current_settings` | `user_commune` | app_settings_provider.dart | 93 |
| 4 | Fermeture app → données dans `app_settings` | `app_settings` | `current_settings` | `user_commune` | - | - |
| 5 | Relance app → migration skip | `app_settings_v2` | - | skip (déjà migré) | app_initializer.dart | 534 |
| 6 | Repository init → lit `app_settings` | `app_settings` | `current_settings` | `user_commune` ✅ | settings_repository.dart | 42 |

**Note** : Si la migration n'a jamais été exécutée, ou si `'app_settings_v2'` est supprimée/corrompue, les settings sont perdus.

---

## 🐛 Scénarios de Repro

### Scénario A : Perte lors de la première initialisation

**Conditions** :
1. Application jamais lancée OU box `'app_settings_v2'` supprimée
2. Utilisateur sélectionne une commune
3. L'application se ferme

**Résultat** :
- Migration s'exécute (ou se ré-exécute si box supprimée)
- Migration sauvegarde dans `'app_settings_v2'`
- Repository lit depuis `'app_settings'` → trouve null → crée defaults
- Repository écrase avec defaults (selectedCommune = null)

### Scénario B : Inconsistance persistante

**Conditions** :
1. Migration déjà exécutée → `'app_settings_v2'` contient des données
2. Utilisateur sélectionne commune → sauvegarde dans `'app_settings'`
3. Les deux boxes coexistent avec potentiellement des valeurs différentes

**Résultat** :
- Box `'app_settings_v2'` : anciennes données de migration
- Box `'app_settings'` : données utilisateur actuelles
- Si `'app_settings'` est supprimée/corrompue → perte des données

### Scénario C : Reset accidentel

**Conditions** :
1. Code invoque `resetToDefaults()` ou `clearAll()` sur repository
2. Cela ne touche que `'app_settings'`
3. `'app_settings_v2'` reste intacte mais inutilisée

**Résultat** :
- Utilisateur voit ses settings réinitialisés
- Anciennes données dans `'app_settings_v2'` jamais récupérées

---

## 🔬 Analyse du Code Critique

### Point A : Migration (_migrateToAppSettings)

```dart
// app_initializer.dart:527
final appSettingsBox = await Hive.openBox<AppSettings>('app_settings_v2');
```

**Problème** : Hardcodé `'app_settings_v2'` sans constante partagée.

**Intention originale** (ligne 526 commentaire) :
```
// ✅ A31-SYNC: Use new box name to avoid legacy typeId conflicts
```

**Conséquence** : Découplage avec le repository.

### Point B : Repository (_boxName)

```dart
// settings_repository.dart:12
static const String _boxName = 'app_settings';
```

**Problème** : Nom différent de celui utilisé par la migration.

**Problème secondaire** : Aucune migration depuis `'app_settings_v2'` vers `'app_settings'`.

### Point C : Provider Build

```dart
// app_settings_provider.dart:21-30
AppSettings build() {
  _repository = ref.read(settingsRepositoryProvider);
  _loadSettings();  // Async
  return AppSettings.defaults();  // ⚠️ Synchronous
}
```

**Problème** : Race condition potentielle.

**Conséquence** : Les widgets reçoivent des defaults temporairement.

**Impact sur selectedCommune** : Si un widget lit au mauvais moment, il voit `selectedCommune = null`.

### Point D : Repository Load avec auto-save

```dart
// settings_repository.dart:44-48
if (settings == null) {
  print('📋 No settings found, using defaults');
  final defaults = AppSettings.defaults();
  await saveSettings(defaults);  // ⚠️ Auto-save
  return defaults;
}
```

**Problème** : Auto-save des defaults sans vérifier `'app_settings_v2'`.

**Conséquence** : Écrase immédiatement si erreur de timing.

---

## 🎯 Points de Prévention Manquants

1. ❌ Aucune constante partagée pour le nom de box
2. ❌ Aucune migration depuis `'app_settings_v2'` vers `'app_settings'`
3. ❌ Aucune logique de fallback qui vérifie les deux boxes
4. ❌ Aucune validation que la migration a effectivement copié les données
5. ❌ Aucun test d'intégration couvrant ce flux

---

## 🔧 Solutions Recommandées

### Solution Court-Terme (Rapide)

Créer une migration ponctuelle qui :
1. Lit depuis `'app_settings_v2'` si elle existe
2. Copie les données dans `'app_settings'`
3. Supprime `'app_settings_v2'` après migration
4. Centralise le nom de box dans une constante

**Fichiers à modifier** :
- `lib/app_initializer.dart` : Ajouter migration bidirectionnelle
- `lib/core/repositories/settings_repository.dart` : Utiliser constante partagée
- `lib/core/data/hive/constants.dart` : Créer constante `APP_SETTINGS_BOX_NAME`

### Solution Long-Terme (Robuste)

1. **Centraliser la configuration Hive** :
   - Créer `core/data/hive/hive_config.dart` avec tous les noms de boxes
   - Importer partout pour éviter les divergences

2. **Améliorer la migration** :
   - Vérifier l'existence de `'app_settings'` avant migration
   - Si `'app_settings'` existe, l'utiliser directement
   - Si seulement `'app_settings_v2'` existe, migrer vers `'app_settings'`

3. **Ajouter tests d'intégration** :
   - Test : Migration puis lecture → données préservées
   - Test : Deux boxes coexistent → pas de corruption
   - Test : Reset → reste stable

4. **Logging amélioré** :
   - Logger le nom de box utilisé à chaque opération
   - Logger les divergences entre boxes
   - Alert si données détectées dans box obsolète

---

## 📊 Impact et Gravité

| Aspect | Gravité | Impact |
|--------|---------|--------|
| **Perte de données utilisateur** | 🔴 CRITIQUE | selectedCommune est perdue entre sessions |
| **Expérience utilisateur** | 🔴 CRITIQUE | L'utilisateur doit re-sélectionner sa commune |
| **Robustesse** | 🟡 MOYEN | Fonctionne une fois la migration correcte |
| **Maintenabilité** | 🟠 ÉLEVÉ | Deux boxes différentes créent confusion |
| **Tests** | 🔴 CRITIQUE | Aucun test couvre ce flux |

---

## ✅ Checklist de Vérification

Pour confirmer que le fix est complet, vérifier :

- [ ] Constante `APP_SETTINGS_BOX_NAME` définie et utilisée partout
- [ ] Migration bidirectionnelle `'app_settings_v2'` ↔ `'app_settings'`
- [ ] Suppression de `'app_settings_v2'` après migration réussie
- [ ] Tests d'intégration passent (migration + lecture)
- [ ] Logs montrent le bon nom de box utilisé
- [ ] Aucune référence restante à `'app_settings_v2'` hardcodée

---

## 📝 Références

### Fichiers Clés

1. **lib/app_initializer.dart** : Lignes 520-590 (migration)
2. **lib/core/repositories/settings_repository.dart** : Lignes 1-259 (repository)
3. **lib/core/providers/app_settings_provider.dart** : Lignes 1-268 (provider)
4. **lib/core/models/app_settings.dart** : Lignes 1-182 (modèle)

### Patterns Similaires à Vérifier

Chercher si d'autres migrations ou boxes Hive ont le même problème :
- `garden_contexts` / `garden_contexts_v2` ?
- `harvest_records` / anciennes boxes ?
- Autres migrations avec numéros de version ?

---

## 🏁 Conclusion

Le problème de perte de `selectedCommune` est causé par une **incohérence architecturale** :
- La migration utilise une box temporaire (`'app_settings_v2'`)
- Le repository utilise la box finale (`'app_settings'`)
- **Aucune logique ne synchronise les deux**

La solution nécessite :
1. **Unifier les noms de boxes** via constantes partagées
2. **Ajouter une migration bidirectionnelle** robuste
3. **Supprimer les boxes temporaires** après migration
4. **Couvrir par des tests d'intégration**

**Priorité** : 🔴 CRITIQUE - Impact utilisateur direct
