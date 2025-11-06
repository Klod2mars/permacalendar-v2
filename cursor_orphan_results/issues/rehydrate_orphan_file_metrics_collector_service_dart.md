# [rehydrate] Fichier orphelin: lib/core/services/monitoring/metrics_collector_service.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    // 📈 Metrics Collector Service - Comprehensive Metrics Collection
    // PermaCalendar v2.8.0 - Prompt 5 Implementation
    // Clean Architecture + Observability Patterns
    
    import 'dart:async';
    import 'dart:developer' as developer;
    
    /// Metric type
    enum MetricCategory {
      performance,
      business,
      system,
      user,
      error,
    }
    
    /// Metric data point
    class MetricDataPoint {
      final String metricName;
      final MetricCategory category;
      final dynamic value;
      final DateTime timestamp;
      final Map<String, String> tags;
    
      MetricDataPoint({
        required this.metricName,
        required this.category,
        required this.value,
        DateTime? timestamp,
        this.tags = const {},
      }) : timestamp = timestamp ?? DateTime.now();
    
      Map<String, dynamic> toJson() => {
            'metricName': metricName,
            'category': category.toString(),
            'value': value,
            'timestamp': timestamp.toIso8601String(),
            'tags': tags,
          };
    }
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
