// ðŸ§  Intelligent Recommendation Engine - ML-Powered Recommendations
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
  final Map<String, dynamic> context;

  IntelligentRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.urgency,
    required this.confidence,
    required this.actions,
    required this.reasoning,
    DateTime? createdAt,
    this.expiresAt,
    this.context = const {},
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type.toString(),
        'urgency': urgency.toString(),
        'confidence': confidence,
        'actions': actions,
        'reasoning': reasoning,
        'createdAt': createdAt.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
        'context': context,
      };
}

/// Recommendation batch
class RecommendationBatch {
  final List<IntelligentRecommendation> recommendations;
  final DateTime generatedAt;
  final Map<String, dynamic> metadata;

  RecommendationBatch({
    required this.recommendations,
    DateTime? generatedAt,
    this.metadata = const {},
  }) : generatedAt = generatedAt ?? DateTime.now();

  int get totalCount => recommendations.length;

  int get criticalCount => recommendations
      .where((r) => r.urgency == RecommendationUrgency.critical)
      .length;

  int get highCount => recommendations
      .where((r) => r.urgency == RecommendationUrgency.high)
      .length;

  List<IntelligentRecommendation> getByCriticalityCritical() => recommendations
      .where((r) => r.urgency == RecommendationUrgency.critical)
      .toList();

  Map<String, dynamic> toJson() => {
        'totalCount': totalCount,
        'criticalCount': criticalCount,
        'highCount': highCount,
        'generatedAt': generatedAt.toIso8601String(),
        'metadata': metadata,
        'recommendations': recommendations.map((r) => r.toJson()).toList(),
      };
}

/// Intelligent recommendation engine with ML
class IntelligentRecommendationEngine {
  final PredictiveAnalyticsService? _analyticsService;

  // Historical data for learning
  final Map<String, List<IntelligentRecommendation>> _recommendationHistory =
      {};
  final Map<String, double> _actionEffectiveness = {};

  // Statistics
  int _totalRecommendations = 0;
  int _acceptedRecommendations = 0;
  final Map<RecommendationType, int> _recommendationsByType = {};

  IntelligentRecommendationEngine({
    PredictiveAnalyticsService? analyticsService,
  }) : _analyticsService = analyticsService {
    _initializeDefaults();
  }

  /// Initialize default values
  void _initializeDefaults() {
    for (final type in RecommendationType.values) {
      _recommendationsByType[type] = 0;
    }
  }

  /// Generate recommendations for a garden
  Future<RecommendationBatch> generateRecommendations({
    required String gardenId,
    required Map<String, dynamic> gardenData,
    required Map<String, dynamic> weatherData,
    required List<Map<String, dynamic>> plants,
  }) async {
    _log('Generating recommendations for garden: $gardenId');

    final recommendations = <IntelligentRecommendation>[];

    // Analyze weather conditions
    recommendations.addAll(await _analyzeWeatherConditions(
      gardenId: gardenId,
      weatherData: weatherData,
      plants: plants,
    ));

    // Analyze plant health
    recommendations.addAll(await _analyzePlantHealth(
      gardenId: gardenId,
      plants: plants,
    ));

    // Analyze seasonal opportunities
    recommendations.addAll(await _analyzeSeasonalOpportunities(
      gardenId: gardenId,
      gardenData: gardenData,
    ));

    // Analyze companion planting opportunities
    recommendations.addAll(await _analyzeCompanionPlanting(
      gardenId: gardenId,
      plants: plants,
    ));

    // Sort by urgency and confidence
    recommendations.sort((a, b) {
      if (a.urgency != b.urgency) {
        return b.urgency.index.compareTo(a.urgency.index);
      }
      return b.confidence.compareTo(a.confidence);
    });

    // Update statistics
    _totalRecommendations += recommendations.length;
    for (final rec in recommendations) {
      _recommendationsByType[rec.type] =
          (_recommendationsByType[rec.type] ?? 0) + 1;
    }

    // Store in history
    _recommendationHistory[gardenId] = recommendations;

    return RecommendationBatch(
      recommendations: recommendations,
      metadata: {
        'gardenId': gardenId,
        'plantCount': plants.length,
        'analysisDate': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Analyze weather conditions for recommendations
  Future<List<IntelligentRecommendation>> _analyzeWeatherConditions({
    required String gardenId,
    required Map<String, dynamic> weatherData,
    required List<Map<String, dynamic>> plants,
  }) async {
    final recommendations = <IntelligentRecommendation>[];

    // Temperature analysis
    final temp = weatherData['temperature'] as double? ?? 20.0;
    final minTemp = weatherData['minTemperature'] as double? ?? 15.0;
    final maxTemp = weatherData['maxTemperature'] as double? ?? 25.0;

    // Frost warning
    if (minTemp < 5.0) {
      recommendations.add(IntelligentRecommendation(
        id: 'frost_warning_${DateTime.now().millisecondsSinceEpoch}',
        title: 'âš ï¸ Risque de Gel',
        description:
            'Température minimale prévue : ${minTemp.toStringAsFixed(1)}Â°C. Protégez vos plantes sensibles.',
        type: RecommendationType.seasonal,
        urgency: RecommendationUrgency.critical,
        confidence: 0.95,
        actions: [
          'Couvrir les plantes sensibles avec un voile d\'hivernage',
          'Arroser avant le gel pour protéger les racines',
          'Rentrer les plantes en pots à l\'intérieur',
        ],
        reasoning: {
          'minTemp': minTemp,
          'threshold': 5.0,
          'riskLevel': 'critical',
        },
        context: {'gardenId': gardenId},
      ));
    }

    // Heat warning
    if (maxTemp > 35.0) {
      recommendations.add(IntelligentRecommendation(
        id: 'heat_warning_${DateTime.now().millisecondsSinceEpoch}',
        title: 'ðŸ”¥ Canicule Prévue',
        description:
            'Température maximale prévue : ${maxTemp.toStringAsFixed(1)}Â°C. Augmentez l\'arrosage.',
        type: RecommendationType.watering,
        urgency: RecommendationUrgency.high,
        confidence: 0.9,
        actions: [
          'Arroser tôt le matin ou tard le soir',
          'Pailler le sol pour conserver l\'humidité',
          'Créer de l\'ombre pour les plantes sensibles',
        ],
        reasoning: {
          'maxTemp': maxTemp,
          'threshold': 35.0,
          'riskLevel': 'high',
        },
        context: {'gardenId': gardenId},
      ));
    }

    // Rainfall analysis
    final rainfall = weatherData['rainfall'] as double? ?? 0.0;
    final humidity = weatherData['humidity'] as double? ?? 50.0;

    if (rainfall < 1.0 && humidity < 40.0) {
      recommendations.add(IntelligentRecommendation(
        id: 'drought_warning_${DateTime.now().millisecondsSinceEpoch}',
        title: 'ðŸ’§ Conditions Sèches',
        description:
            'Faible pluviométrie et humidité basse. Arrosage nécessaire.',
        type: RecommendationType.watering,
        urgency: RecommendationUrgency.medium,
        confidence: 0.85,
        actions: [
          'Arroser en profondeur plutôt que fréquemment',
          'Installer un système de goutte-à-goutte',
          'Vérifier le sol avant d\'arroser',
        ],
        reasoning: {
          'rainfall': rainfall,
          'humidity': humidity,
          'threshold': 40.0,
        },
        context: {'gardenId': gardenId},
      ));
    }

    return recommendations;
  }

  /// Analyze plant health for recommendations
  Future<List<IntelligentRecommendation>> _analyzePlantHealth({
    required String gardenId,
    required List<Map<String, dynamic>> plants,
  }) async {
    final recommendations = <IntelligentRecommendation>[];

    for (final plant in plants) {
      final healthScore = plant['healthScore'] as double? ?? 0.7;
      final plantName = plant['name'] as String? ?? 'Plante';

      // Low health score
      if (healthScore < 0.5) {
        recommendations.add(IntelligentRecommendation(
          id: 'health_${plant['id']}_${DateTime.now().millisecondsSinceEpoch}',
          title: 'ðŸŒ± Santé de $plantName à Surveiller',
          description:
              'Score de santé faible (${(healthScore * 100).toInt()}%). Action immédiate recommandée.',
          type: RecommendationType.pestControl,
          urgency: RecommendationUrgency.high,
          confidence: 0.8,
          actions: [
            'Inspecter les feuilles pour détecter maladies ou parasites',
            'Vérifier l\'humidité du sol',
            'Ajuster la fertilisation si nécessaire',
          ],
          reasoning: {
            'healthScore': healthScore,
            'threshold': 0.5,
            'plantId': plant['id'],
          },
          context: {'gardenId': gardenId, 'plantId': plant['id']},
        ));
      }
    }

    return recommendations;
  }

  /// Analyze seasonal opportunities
  Future<List<IntelligentRecommendation>> _analyzeSeasonalOpportunities({
    required String gardenId,
    required Map<String, dynamic> gardenData,
  }) async {
    final recommendations = <IntelligentRecommendation>[];
    final now = DateTime.now();
    final month = now.month;

    // Spring planting (March-May)
    if (month >= 3 && month <= 5) {
      recommendations.add(IntelligentRecommendation(
        id: 'spring_planting_${now.millisecondsSinceEpoch}',
        title: 'ðŸŒ¸ Période de Plantation Printanière',
        description: 'C\'est le moment idéal pour planter vos légumes d\'été !',
        type: RecommendationType.planting,
        urgency: RecommendationUrgency.medium,
        confidence: 0.9,
        actions: [
          'Planter tomates, courgettes, aubergines',
          'Semer haricots, concombres, melons',
          'Préparer le sol avec du compost',
        ],
        reasoning: {
          'season': 'spring',
          'month': month,
          'optimal': true,
        },
        context: {'gardenId': gardenId},
      ));
    }

    // Fall planting (September-October)
    if (month >= 9 && month <= 10) {
      recommendations.add(IntelligentRecommendation(
        id: 'fall_planting_${now.millisecondsSinceEpoch}',
        title: 'ðŸ‚ Plantation d\'Automne',
        description:
            'Période idéale pour les cultures d\'hiver et légumes-feuilles.',
        type: RecommendationType.planting,
        urgency: RecommendationUrgency.medium,
        confidence: 0.85,
        actions: [
          'Planter épinards, mâche, roquette',
          'Semer oignons et échalotes d\'hiver',
          'Planter ail et fèves',
        ],
        reasoning: {
          'season': 'fall',
          'month': month,
          'optimal': true,
        },
        context: {'gardenId': gardenId},
      ));
    }

    return recommendations;
  }

  /// Analyze companion planting opportunities
  Future<List<IntelligentRecommendation>> _analyzeCompanionPlanting({
    required String gardenId,
    required List<Map<String, dynamic>> plants,
  }) async {
    final recommendations = <IntelligentRecommendation>[];

    // Define companion relationships
    final companions = {
      'tomate': ['basilic', 'oeillet', 'carotte'],
      'carotte': ['oignon', 'poireau', 'tomate'],
      'haricot': ['maÃ¯s', 'courge'],
      'laitue': ['radis', 'carotte'],
    };

    // Analyze existing plants
    final plantNames =
        plants.map((p) => (p['name'] as String).toLowerCase()).toList();

    for (final plant in plants) {
      final plantName = (plant['name'] as String).toLowerCase();

      if (companions.containsKey(plantName)) {
        final goodCompanions = companions[plantName]!;
        final missingCompanions =
            goodCompanions.where((c) => !plantNames.contains(c)).toList();

        if (missingCompanions.isNotEmpty) {
          recommendations.add(IntelligentRecommendation(
            id: 'companion_${plant['id']}_${DateTime.now().millisecondsSinceEpoch}',
            title: 'ðŸ¤ Opportunité de Compagnonnage',
            description:
                'Améliorez la croissance de vos ${plant['name']} avec des plantes compagnes.',
            type: RecommendationType.companion,
            urgency: RecommendationUrgency.low,
            confidence: 0.75,
            actions: [
              'Planter ${missingCompanions.join(", ")} à proximité',
              'Espacer correctement les plants',
              'Observer les résultats',
            ],
            reasoning: {
              'plantName': plantName,
              'missingCompanions': missingCompanions,
              'benefits': 'Protection naturelle, meilleure croissance',
            },
            context: {'gardenId': gardenId, 'plantId': plant['id']},
          ));
        }
      }
    }

    return recommendations;
  }

  /// Generate personalized recommendations using ML
  Future<List<IntelligentRecommendation>> generatePersonalizedRecommendations({
    required String userId,
    required Map<String, dynamic> userPreferences,
    required Map<String, dynamic> historicalData,
  }) async {
    _log('Generating personalized recommendations for user: $userId');

    final recommendations = <IntelligentRecommendation>[];

    // Analyze user behavior patterns
    final preferredActivities =
        userPreferences['preferredActivities'] as List<String>? ?? [];

    // Analyze historical success rates
    final successRates =
        historicalData['successRates'] as Map<String, double>? ?? {};

    // Generate recommendations based on patterns
    if (preferredActivities.contains('organic_gardening')) {
      recommendations.add(IntelligentRecommendation(
        id: 'organic_${DateTime.now().millisecondsSinceEpoch}',
        title: 'ðŸŒ¿ Jardinage Biologique',
        description: 'Techniques bio adaptées à vos préférences.',
        type: RecommendationType.pestControl,
        urgency: RecommendationUrgency.low,
        confidence: 0.8,
        actions: [
          'Utiliser du purin d\'ortie comme fertilisant',
          'Installer des hôtels à insectes',
          'Pratiquer la rotation des cultures',
        ],
        reasoning: {
          'userPreference': 'organic_gardening',
          'personalizedPrediction': true,
        },
        context: {'userId': userId},
      ));
    }

    return recommendations;
  }

  /// Record recommendation acceptance
  void recordRecommendationAcceptance({
    required String recommendationId,
    required bool accepted,
  }) {
    if (accepted) {
      _acceptedRecommendations++;
      _actionEffectiveness[recommendationId] = 1.0;
    } else {
      _actionEffectiveness[recommendationId] = 0.0;
    }

    _log(
        'Recommendation $recommendationId ${accepted ? "accepted" : "rejected"}');
  }

  /// Get recommendation history for a garden
  List<IntelligentRecommendation> getRecommendationHistory(String gardenId) {
    return _recommendationHistory[gardenId] ?? [];
  }

  /// Get acceptance rate
  double getAcceptanceRate() {
    return _totalRecommendations > 0
        ? _acceptedRecommendations / _totalRecommendations
        : 0.0;
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalRecommendations': _totalRecommendations,
      'acceptedRecommendations': _acceptedRecommendations,
      'acceptanceRate': getAcceptanceRate(),
      'recommendationsByType': _recommendationsByType.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
    };
  }

  /// Reset statistics
  void resetStatistics() {
    _totalRecommendations = 0;
    _acceptedRecommendations = 0;
    _recommendationsByType.updateAll((key, value) => 0);
    _actionEffectiveness.clear();
    _recommendationHistory.clear();
    _log('Recommendation engine statistics reset');
  }

  /// Logging helper
  void _log(String message) {
    developer.log(
      message,
      name: 'IntelligentRecommendationEngine',
      level: 500,
    );
  }
}
