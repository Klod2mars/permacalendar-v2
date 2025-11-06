# [rehydrate] Fichier orphelin: lib/core/services/performance/intelligent_cache_service.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    // 🚀 Intelligent Cache Service - Multi-Level Caching System
    // PermaCalendar v2.8.0 - Prompt 5 Implementation
    // Clean Architecture + Enterprise Patterns
    
    import 'dart:async';
    import 'dart:collection';
    import 'dart:convert';
    import 'dart:developer' as developer;
    import 'package:hive/hive.dart';
    
    /// Configuration for cache levels and behavior
    class CacheConfig {
      final Duration memoryTtl;
      final Duration diskTtl;
      final int memoryMaxEntries;
      final int diskMaxEntries;
      final bool enableCompression;
      final bool enableMetrics;
    
      const CacheConfig({
        this.memoryTtl = const Duration(minutes: 10),
        this.diskTtl = const Duration(hours: 24),
        this.memoryMaxEntries = 100,
        this.diskMaxEntries = 1000,
        this.enableCompression = true,
        this.enableMetrics = true,
      });
    
      /// Conservative configuration (longer TTL, larger cache)
      factory CacheConfig.conservative() => const CacheConfig(
            memoryTtl: Duration(minutes: 30),
            diskTtl: Duration(days: 7),
            memoryMaxEntries: 200,
            diskMaxEntries: 2000,
          );
    
      /// Aggressive configuration (shorter TTL, smaller cache)
      factory CacheConfig.aggressive() => const CacheConfig(
            memoryTtl: Duration(minutes: 5),
            diskTtl: Duration(hours: 6),
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
