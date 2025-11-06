# [rehydrate] Fichier orphelin: lib/core/utils/calibration_migration.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    import 'package:flutter/foundation.dart';
    
    /// Migration des anciennes clés de calibration vers le système organique unifié.
    class CalibrationMigration {
      /// Effectue les migrations nécessaires. Idempotent.
      static Future<void> migrate() async {
        // Placeholder pour implémentations futures.
        // Les migrations détaillées (SharedPreferences/Hive) seront ajoutées lors de l'intégration.
        if (kDebugMode) {
          // ignore: avoid_print
          print('ℹ️ CalibrationMigration.migrate(): nothing to migrate yet');
        }
      }
    }
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
