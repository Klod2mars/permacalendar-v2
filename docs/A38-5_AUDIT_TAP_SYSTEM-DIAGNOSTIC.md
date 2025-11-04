# A38-5 — TAP System Diagnostic

## Note clé

"Le mode TAP ne dépend pas de AppSettings ; il repose uniquement sur Riverpod (calibrationStateProvider)."

## Contexte bref

- Le flux actif est: Paramètres → Provider → Dashboard → Zone.
- La persistance TAP utilise `PositionPersistence` (SharedPreferences) et non Hive.
- `AppSettings.gardenCalibrationEnabled` n'influence pas le mode TAP; l'état d'activation provient de `CalibrationState.activeType` via `calibrationStateProvider`.

## Implication

- Aucun chevauchement logique entre `gardenCalibrationEnabled` (Hive) et le mode TAP.
- Les actions de calibration TAP passent par `enableTapZonesCalibration()` / `disableCalibration()`.


