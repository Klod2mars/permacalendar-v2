# Persistance des Préférences Météo

## Vue d'ensemble

Ce document décrit l'architecture de persistance des préférences météo dans l'application PermaCalendar. Les préférences météo incluent la commune sélectionnée, le rayon de recherche, le mode rural, et les coordonnées GPS résolues pour le fonctionnement hors ligne.

## Architecture

### Modèle de Données

Le modèle `AppSettings` (HiveObject) centralise toutes les préférences de l'application, y compris les préférences météo :

```dart
@HiveType(typeId: 60)
class AppSettings extends HiveObject {
  @HiveField(2) String? selectedCommune;        // Commune sélectionnée
  @HiveField(5) String temperatureUnit;         // Unité de température
  @HiveField(9) double? weatherRadius;          // Rayon de recherche (km)
  @HiveField(10) bool isRuralMode;              // Mode rural
  @HiveField(11) double? lastLatitude;          // Dernière latitude résolue
  @HiveField(12) double? lastLongitude;         // Dernière longitude résolue
}
```

### Persistance

**Storage:** Hive Box `app_settings`  
**Repository:** `SettingsRepository`  
**Provider:** `AppSettingsNotifier` (Riverpod)

### Flux de Données

```
┌─────────────────┐
│ AppSettings     │  (Modèle Hive)
│ - Météo         │
│ - Autres        │
└────────┬────────┘
         │
         v
┌─────────────────┐
│ SettingsRepo    │  (Repository)
│ - loadSettings  │
│ - saveSettings  │
└────────┬────────┘
         │
         v
┌─────────────────┐
│ AppSettingsNot  │  (Provider Riverpod)
│ - State         │
│ - Methods       │
└────────┬────────┘
         │
         v
┌─────────────────┐
│ UI Components   │  (Widgets)
│ - Settings      │
│ - Weather        │
└─────────────────┘
```

## Préférences Météo

### Commune Sélectionnée

**Stockage:** `selectedCommune` (String?, nullable)  
**HiveField:** 2  
**Default:** null (utilise commune par défaut)

**Utilisation:**
```dart
final settings = ref.watch(appSettingsProvider);
final commune = settings.selectedCommune;
```

**Mise à jour:**
```dart
await ref.read(appSettingsProvider.notifier).setCommune('Paris');
```

### Rayon de Recherche

**Stockage:** `weatherRadius` (double?, nullable, en km)  
**HiveField:** 9  
**Default:** null (utilise rayon par défaut du système)

**Valeurs suggérées:** 5, 10, 20, 50 km

**Utilisation:**
```dart
final radius = ref.watch(weatherRadiusProvider);
```

**Mise à jour:**
```dart
await ref.read(appSettingsProvider.notifier).setWeatherRadius(10.0);
```

### Mode Rural

**Stockage:** `isRuralMode` (bool)  
**HiveField:** 10  
**Default:** false

**Utilisation:**
```dart
final isRural = ref.watch(ruralModeProvider);
```

**Mise à jour:**
```dart
await ref.read(appSettingsProvider.notifier).setRuralMode(true);
```

### Coordonnées GPS Résolues

**Stockage:** `lastLatitude` (double?), `lastLongitude` (double?)  
**HiveFields:** 11, 12  
**Default:** null

**Objectif:** Stocker les coordonnées résolues lors du géocodage pour utilisation hors ligne.

**Sauvegarde automatique:**
```dart
// Dans selectedCommuneCoordinatesProvider
await notifier.setLastCoordinates(latitude, longitude);
```

**Utilisation en fallback:**
```dart
// Dans selectedCommuneCoordinatesProvider
if (settings.lastLatitude != null && settings.lastLongitude != null) {
  return Coordinates(
    latitude: settings.lastLatitude!,
    longitude: settings.lastLongitude!,
    resolvedName: name,
  );
}
```

## Stratégie de Cache

### Cache Multi-Niveau

1. **Cache Mémoire** (Provider Riverpod)
   - État réactif via `appSettingsProvider`
   - Invalidation automatique lors des mises à jour

2. **Cache Hive** (Stockage Local)
   - Persistance sur disque
   - Survit aux redémarrages de l'app
   - Compatible hors ligne

3. **Cache API OpenMeteo** (30 minutes TTL)
   - Cache des résultats de géocodage
   - Améliore les performances réseau

### Flux de Résolution des Coordonnées

```
1. Vérifier commune sélectionnée
   ↓
2. Si coordonnées stockées disponibles
   → Utiliser en fallback
   ↓
3. Essayer géocodage API
   ↓
4. Si succès
   → Sauvegarder coordonnées résolues
   → Retourner coordonnées
   ↓
5. Si échec
   → Utiliser coordonnées stockées (si disponibles)
   → Sinon utiliser défaut système
```

## Compatibilité Hors Ligne

### Points Clés

1. **Coordonnées Stockées:** Les coordonnées résolues sont automatiquement sauvegardées lors du géocodage
2. **Fallback Intelligent:** En cas d'erreur réseau, utilisation des coordonnées stockées
3. **Données Météo:** Les données météo sont persistées dans Hive (`weather_conditions` box)

### Scénarios Hors Ligne

**Scénario 1: Géocodage échoue**
- Utilisation des coordonnées stockées (`lastLatitude`, `lastLongitude`)
- Si non disponibles, utilisation des coordonnées par défaut

**Scénario 2: Commune déjà géocodée**
- Utilisation directe des coordonnées stockées
- Pas besoin de géocodage

**Scénario 3: Aucune commune sélectionnée**
- Utilisation des coordonnées stockées si disponibles
- Sinon, utilisation des coordonnées par défaut

## Initialisation

### Séquence de Chargement

```
1. App démarre
   ↓
2. AppInitializer.initialize()
   - Hive.initFlutter()
   - Enregistre AppSettingsAdapter
   ↓
3. Premier accès à appSettingsProvider
   ↓
4. AppSettingsNotifier.build()
   - Retourne AppSettings.defaults() (immédiat)
   - Lance _loadSettings() (asynchrone)
   ↓
5. _loadSettings()
   - Repository.initialize() → ouvre box Hive
   - Repository.loadSettings() → lit depuis Hive
   - Si existe → state = settings chargés
   - Si null → state = defaults (et sauvegarde)
   ↓
6. Providers météo utilisent settings
```

### État Initial

**Problème potentiel:** Race condition mineure entre retour immédiat de defaults et chargement asynchrone.

**Solution actuelle:** Fallback sur valeurs par défaut dans les providers météo.

**Amélioration future:** Utiliser `FutureProvider` pour garantir chargement complet avant utilisation.

## Migration

### Migration depuis Legacy

Lors de la migration depuis l'ancienne box `settings`:

1. Vérifie si migration déjà effectuée
2. Lit `selected_commune_name` depuis l'ancienne box
3. Crée `AppSettings` avec la commune migrée
4. Gère les erreurs (unknown typeId, etc.)

**Fichier:** `lib/app_initializer.dart` → `_migrateToAppSettings()`

## Tests

### Tests Unitaires

**Fichier:** `test/core/app_settings_test.dart`

**Couverture:**
- ✅ Création avec valeurs par défaut
- ✅ `copyWith` pour nouveaux champs
- ✅ Nullabilité des champs optionnels
- ✅ `toString` inclut tous les champs
- ✅ Conversion `themeModeEnum`

### Tests d'Intégration

**Recommandation:** Créer des tests d'intégration pour:
- Chargement depuis Hive
- Sauvegarde vers Hive
- Migration depuis legacy
- Fallback hors ligne

## Références

- **Modèle:** `lib/core/models/app_settings.dart`
- **Repository:** `lib/core/repositories/settings_repository.dart`
- **Provider:** `lib/core/providers/app_settings_provider.dart`
- **Weather Provider:** `lib/features/climate/presentation/providers/weather_providers.dart`
- **UI:** `lib/shared/presentation/widgets/settings/weather_settings_section.dart`

## Historique

- **2025-11-02:** Ajout des préférences météo (weatherRadius, isRuralMode, lastLatitude, lastLongitude)
- **A31-2 Phase 1:** Création du modèle unifié AppSettings
- **Initial:** Commune et unité température uniquement

