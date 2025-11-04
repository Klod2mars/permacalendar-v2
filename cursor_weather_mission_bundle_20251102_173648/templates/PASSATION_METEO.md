# PASSATION — Module Météo (suppression / rebuild Open‑Meteo)

## Objectif
Retirer proprement l’ancien module météo (legacy) et le reconstruire avec Open‑Meteo.

## Périmètre
- UI : dashboard, widgets, écrans météo
- Mobile client : Dart/Flutter feature `weather` (Riverpod)
- Data : Hive boxes `weatherBox`, `weather_old`, etc.
- Backend/CI : jobs, secrets, pipelines associés

## Inventaire (résultat de l’audit)
- Voir `reports/weather_audit/audit_table.md` et `audit_table.csv` (générés par scripts).

## Backups
- Emplacement des backups Hive : selon plateforme (créés par `hive_backup.dart`).
- Commandes/restore : voir helpers dans `lib/weather/local/hive_backup.dart`.

## Plan de suppression (étapes)
1. Feature flag OFF (`FeatureFlags.weatherV2Enabled = false`)
2. Pause cron & background jobs
3. Masquer UI (remplacer par placeholder)
4. Remplacer `WeatherRemoteDatasource` par `NullWeatherRemoteDatasource`
5. Backup Hive
6. Purger boxes (après validation Gate & backups)
7. Nettoyer secrets/API keys legacy
8. Commit & tag

## Plan rebuild (Open‑Meteo)
- Service : `OpenMeteoService`
- Endpoint : `https://api.open-meteo.com/v1/forecast`
- Params : lat/lon, hourly, daily, timezone, `current_weather=true`
- Caching : `WeatherCache` (Hive JSON), TTL par défaut 30 min
- UI : `WeatherWidget` (Riverpod) + indicateur d’état
- Rollout : staging → canary 5% → 25% → 100%

## Tests
- Unit : parsing JSON (voir `test/weather/open_meteo_service_test.dart`)
- Integration : mock http errors → fallback cache
- E2E : scénario fail + cache périmé

## Rollback
- Revert commit + restaurer backup Hive (helpers)
