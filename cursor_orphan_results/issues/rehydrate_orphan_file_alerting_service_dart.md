# [rehydrate] Fichier orphelin: lib/core/services/monitoring/alerting_service.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    // 🚨 Alerting Service - Intelligent Alert Management
    // PermaCalendar v2.8.0 - Prompt 5 Implementation
    // Clean Architecture + Alert Management Patterns
    
    import 'dart:async';
    import 'dart:developer' as developer;
    
    /// Alert severity
    enum AlertSeverity {
      info,
      warning,
      error,
      critical,
    }
    
    /// Alert type
    enum AlertType {
      performance,
      health,
      business,
      security,
      system,
    }
    
    /// Alert
    class Alert {
      final String id;
      final String title;
      final String message;
      final AlertSeverity severity;
      final AlertType type;
      final DateTime createdAt;
      final Map<String, dynamic> context;
      final String? source;
    
      bool acknowledged;
      DateTime? acknowledgedAt;
      String? acknowledgedBy;
    
      Alert({
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
