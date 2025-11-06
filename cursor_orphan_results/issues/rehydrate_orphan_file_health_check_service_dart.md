# [rehydrate] Fichier orphelin: lib/core/services/monitoring/health_check_service.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    // 🏥 Health Check Service - System Health Monitoring
    // PermaCalendar v2.8.0 - Prompt 5 Implementation
    // Clean Architecture + Health Check Patterns
    
    import 'dart:async';
    import 'dart:developer' as developer;
    import 'package:hive/hive.dart';
    
    /// Health status
    enum HealthStatus {
      healthy,
      degraded,
      unhealthy,
      unknown,
    }
    
    /// Health check result
    class HealthCheckResult {
      final String componentName;
      final HealthStatus status;
      final String? message;
      final Duration responseTime;
      final Map<String, dynamic> details;
      final DateTime checkedAt;
    
      HealthCheckResult({
        required this.componentName,
        required this.status,
        this.message,
        required this.responseTime,
        this.details = const {},
        DateTime? checkedAt,
      }) : checkedAt = checkedAt ?? DateTime.now();
    
      bool get isHealthy => status == HealthStatus.healthy;
      bool get isDegraded => status == HealthStatus.degraded;
      bool get isUnhealthy => status == HealthStatus.unhealthy;
    
      Map<String, dynamic> toJson() => {
            'componentName': componentName,
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
