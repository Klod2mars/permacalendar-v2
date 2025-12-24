# EXPORT POSITIONS - README

**Date**: 2025-12-24
**Author**: AntiGravity
**Device Target**: Appareil du producteur (déjà calibré)

## Description
Ce module fournit une page de debug pour exporter :
1. Les positions des bulles du dashboard (Tappable Zones) telles qu'elles sont configurées sur l'appareil.
2. Un backup de sécurité des boîtes Hive critiques.

L'export a été adapté pour lire l'état depuis **OrganicZonesProvider** (Riverpod) car l'audit a révélé que les positions ne sont PAS dans Hive, mais dans **SharedPreferences**.

## Instructions d'intégration et exécution

### 1. Installation
Les fichiers suivants ont été ajoutés/modifiés :
- `lib/debug/export_positions.dart` (Nouveau)
- `lib/app_router.dart` (Route ajoutée : `/debug/export_positions`)

### 2. Lancer l'export sur l'appareil
1. Compilez et installez l'app en mode DEBUG sur l'appareil cible.
   ```bash
   flutter run --debug
   ```
2. Ouvrez l'application.
3. Accédez à la page d'export.
   * Si l'app supporte les deep links : `adb shell am start -W -a android.intent.action.VIEW -d "example://permacalendar/debug/export_positions"` (Adapter le scheme).
   * **SINON (Méthode Recommandée)** : Modifiez temporairement `SettingsScreen` ou `HomeScreen` pour ajouter un `ElevatedButton(onPressed: () => context.push('/debug/export_positions'), child: Text('Export Debug'))`.
4. Sur la page "Debug Export Positions", cliquez sur **LANCER EXPORT**.
5. Vérifiez les logs affichés à l'écran. Le chemin d'export sera indiqué (ex: `/data/user/0/.../app_flutter/`).

### 3. Récupérer les fichiers (ADB)
Une fois l'export réussi, utilisez les commandes suivantes depuis votre terminal pour récupérer les artefacts.

**Remplacez `<package_name>` par l'ID de l'application (ex: `com.example.permacalendar`).**

```bash
# Créer le dossier local
mkdir -p assets/data/received_from_device

# Récupérer le JSON principal
adb shell "run-as com.example.permacalendar cat app_flutter/dashboard_bubbles_from_device.json" > assets/data/dashboard_bubbles_from_device.json

# Récupérer les backups Hive (optionnel)
# Note: utiliser une boucle ou copier manuellement
adb shell "run-as com.example.permacalendar ls app_flutter/hive_backup_*"
# Pour chaque fichier listé :
adb shell "run-as com.example.permacalendar cat app_flutter/hive_backup_gardens.json" > backups/hive_backups/hive_backup_gardens.json
# ... répéter pour autres fichiers
```

### 4. Finalisation
1. Vérifiez que `assets/data/dashboard_bubbles_from_device.json` contient bien des données valides.
2. Copiez l'image de fond utilisée (si nécessaire pour la référence) :
   `cp assets/images/backgrounds/dashboard_organic_final.png assets/images/dashboard/leaf_with_bubbles_backup.png`
3. Créez l'archive ZIP livrable.

## Notes Techniques (Audit)
- **Positions** : Stockées dans SharedPreferences (préfixe `organic_`). Le script d'export les lit via `ref.read(organicZonesProvider)` pour garantir la fidélité "What You See Is What You Get".
- **Hive** : Utilisé pour `gardens`, `plantings`, etc., mais pas pour la config visuelle du dashboard.
- **Image** : `assets/images/dashboard/leaf_with_bubbles.png` n'existait pas. Le script utilise `dashboard_organic_final.png` comme référence.
