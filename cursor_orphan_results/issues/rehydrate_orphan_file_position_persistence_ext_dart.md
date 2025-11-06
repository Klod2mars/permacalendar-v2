# [rehydrate] Fichier orphelin: lib/core/utils/position_persistence_ext.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    // lib/core/utils/position_persistence_ext.dart
    import 'package:flutter/foundation.dart';
    import 'package:shared_preferences/shared_preferences.dart';
    
    /// Extension/helper for safe write of normalized positions.
    /// Matches the read pattern used by PositionPersistence.readPosition:
    /// - xKey: '${prefix}_${key}_x'
    /// - yKey: '${prefix}_${key}_y'
    /// - sizeKey: '${prefix}_${key}_size'
    /// - boolKey: '${prefix}_${key}_bool' (for enabled flag)
    class PositionPersistenceExt {
      /// Writes a position for prefix/key
      /// prefix: e.g. 'organic'
      /// key: e.g. 'METEO'
      /// x,y,size : normalized 0..1
      /// enabled: whether the zone is enabled (defaults to true)
      static Future<void> writePosition(
        String prefix,
        String key,
        double x,
        double y, {
        double? size,
        bool enabled = true,
      }) async {
        try {
          final prefs = await SharedPreferences.getInstance();
          final xKey = '${prefix}_${key}_x';
          final yKey = '${prefix}_${key}_y';
          final sizeKey = '${prefix}_${key}_size';
          final boolKey = '${prefix}_${key}_bool';
    
          await prefs.setDouble(xKey, x.clamp(0.0, 1.0));
          await prefs.setDouble(yKey, y.clamp(0.0, 1.0));
          if (size != null) {
            await prefs.setDouble(sizeKey, size.clamp(0.01, 1.0));
          }
          await prefs.setBool(boolKey, enabled);
    
          if (kDebugMode) {
            debugPrint(
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
