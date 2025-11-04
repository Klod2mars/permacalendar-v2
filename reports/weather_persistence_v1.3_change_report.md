# Rapport de changements v1.3 - WRITE-WEATHER-PERSISTENCE-2025-11-02-003

## ⚠️ AVERTISSEMENT IMPORTANT

Cette mission a **simplifié drastiquement** le modèle `AppSettings` :
- **Réduction de 13 champs à seulement 6 champs**
- **Changement de typeId de 60 à 0**
- **Suppression de nombreuses fonctionnalités**

## Impact

Cette modification va **casser le code existant** qui utilise :
- `themeMode` (String) → maintenant `darkMode` (bool)
- `showAnimations`
- `selectedCommune` 
- `alertThreshold`
- `temperatureUnit`
- `weatherRadius`
- `isRuralMode`
- `lastLatitude` / `lastLongitude` → maintenant `lastLat` / `lastLon`
- `analysisIntervalMinutes`
- `backupEnabled`
- `gardenCalibrationEnabled`

## Fichiers modifiés

1. `lib/core/models/app_settings.dart` - Réécrit complètement avec seulement 6 champs
2. `scripts/purge_settings_box.dart` - Créé pour purger l'ancien box settings

## Actions requises après cette modification

1. **Régénérer le code Hive** : `flutter packages pub run build_runner build --delete-conflicting-outputs`
2. **Adapter tous les fichiers** qui utilisent AppSettings :
   - `lib/core/providers/app_settings_provider.dart`
   - `lib/core/repositories/settings_repository.dart`
   - `lib/app_initializer.dart`
   - Tous les widgets/screens qui accèdent aux settings
3. **Adapter les tests** qui utilisent AppSettings

## Scripts créés

- `scripts/purge_settings_box.dart` - Purge le box 'settings' corrompu

