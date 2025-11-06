# [rehydrate] Fichier orphelin: lib/core/services/intelligence/intelligent_recommendation_engine.dart

- **Type**: fichier non référencé
- **Détecté par**: tools/orphan_analyzer.dart
- **Preuves**: cursor_orphan_results/unreferenced_files.txt
- **Extrait du fichier**:
```dart
    // 🧠 Intelligent Recommendation Engine - ML-Powered Recommendations
    // PermaCalendar v2.8.0 - Prompt 5 Implementation
    // Clean Architecture + ML Patterns
    
    import 'dart:async';
    import 'dart:developer' as developer;
    import 'package:permacalendar/core/services/intelligence/predictive_analytics_service.dart';
    
    /// Recommendation type
    enum RecommendationType {
      planting,
      watering,
      fertilizing,
      harvesting,
      pestControl,
      pruning,
      companion,
      seasonal,
    }
    
    /// Recommendation urgency
    enum RecommendationUrgency {
      low,
      medium,
      high,
      critical,
    }
    
    /// Intelligent recommendation
    class IntelligentRecommendation {
      final String id;
      final String title;
      final String description;
      final RecommendationType type;
      final RecommendationUrgency urgency;
      final double confidence;
      final List<String> actions;
      final Map<String, dynamic> reasoning;
      final DateTime createdAt;
      final DateTime? expiresAt;
```
- **Plan de ré-intégration**:
  1. Vérifier s'il était exporté via un barrel file
  2. S'il contient un widget/feature utile, réintroduire l'import dans l'arbre de widgets ou routeur
  3. Ajouter tests unitaires/instrumentés
  4. Mettre à jour exports (lib/my_package.dart) et PR
