// Tests unitaires pour IntelligentRecommendationEngine
// PermaCalendar v2.8.0 - Prompt 5 Implementation


import '../../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/services/intelligence/intelligent_recommendation_engine.dart';
import 'package:permacalendar/core/services/intelligence/predictive_analytics_service.dart';

void main() {
  group('IntelligentRecommendationEngine', () {
    late IntelligentRecommendationEngine engine;

    setUp(() {
      engine = IntelligentRecommendationEngine();
    });

    tearDown(() {
      engine.resetStatistics();
    });

    group('generateRecommendations', () {
      test('should generate recommendations for valid garden data', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {
          'name': 'Mon Jardin',
          'location': 'Paris',
        };
        final weatherData = {
          'temperature': 20.0,
          'minTemperature': 15.0,
          'maxTemperature': 25.0,
          'rainfall': 5.0,
          'humidity': 60.0,
        };
        final plants = [
          {
            'id': 'plant-1',
            'name': 'Tomate',
            'healthScore': 0.8,
          },
        ];

        // Act
        final batch = await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        // Assert
        expect(batch, isNotNull);
        expect(batch.recommendations, isNotEmpty);
        expect(batch.metadata['gardenId'], equals(gardenId));
        expect(batch.metadata['plantCount'], equals(1));
      });

      test('should handle empty plants list gracefully', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = {
          'temperature': 20.0,
          'minTemperature': 15.0,
          'maxTemperature': 25.0,
        };
        final plants = <Map<String, dynamic>>[];

        // Act
        final batch = await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        // Assert
        expect(batch, isNotNull);
        expect(batch.recommendations, isA<List<IntelligentRecommendation>>());
        expect(batch.metadata['plantCount'], equals(0));
      });

      test('should generate frost warning for low temperature', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = {
          'temperature': 5.0,
          'minTemperature': 2.0, // Below 5Â°C threshold
          'maxTemperature': 10.0,
        };
        final plants = <Map<String, dynamic>>[];

        // Act
        final batch = await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        // Assert
        expect(batch.recommendations, isNotEmpty);
        final frostRecommendation = batch.recommendations.firstWhere(
          (r) => r.title.contains('Gel'),
          orElse: () => throw Exception('Frost recommendation not found'),
        );
        expect(frostRecommendation.urgency, equals(RecommendationUrgency.critical));
        expect(frostRecommendation.type, equals(RecommendationType.seasonal));
      });

      test('should generate heat warning for high temperature', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = {
          'temperature': 30.0,
          'minTemperature': 25.0,
          'maxTemperature': 38.0, // Above 35Â°C threshold
        };
        final plants = <Map<String, dynamic>>[];

        // Act
        final batch = await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        // Assert
        expect(batch.recommendations, isNotEmpty);
        final heatRecommendation = batch.recommendations.firstWhere(
          (r) => r.title.contains('Canicule'),
          orElse: () => throw Exception('Heat recommendation not found'),
        );
        expect(heatRecommendation.urgency, equals(RecommendationUrgency.high));
        expect(heatRecommendation.type, equals(RecommendationType.watering));
      });

      test('should generate drought warning for dry conditions', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = {
          'temperature': 25.0,
          'minTemperature': 20.0,
          'maxTemperature': 30.0,
          'rainfall': 0.5, // Below 1mm threshold
          'humidity': 35.0, // Below 40% threshold
        };
        final plants = <Map<String, dynamic>>[];

        // Act
        final batch = await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        // Assert
        expect(batch.recommendations, isNotEmpty);
        final droughtRecommendation = batch.recommendations.firstWhere(
          (r) => r.title.contains('SÃ¨ches'),
          orElse: () => throw Exception('Drought recommendation not found'),
        );
        expect(droughtRecommendation.urgency, equals(RecommendationUrgency.medium));
        expect(droughtRecommendation.type, equals(RecommendationType.watering));
      });

      test('should generate health warning for unhealthy plants', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = {
          'temperature': 20.0,
          'minTemperature': 15.0,
          'maxTemperature': 25.0,
        };
        final plants = [
          {
            'id': 'plant-1',
            'name': 'Tomate',
            'healthScore': 0.3, // Below 0.5 threshold
          },
        ];

        // Act
        final batch = await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        // Assert
        expect(batch.recommendations, isNotEmpty);
        final healthRecommendation = batch.recommendations.firstWhere(
          (r) => r.title.contains('SantÃ©'),
          orElse: () => throw Exception('Health recommendation not found'),
        );
        expect(healthRecommendation.urgency, equals(RecommendationUrgency.high));
        expect(healthRecommendation.type, equals(RecommendationType.pestControl));
      });

      test('should sort recommendations by urgency and confidence', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = {
          'temperature': 5.0,
          'minTemperature': 2.0, // Critical
          'maxTemperature': 38.0, // High
        };
        final plants = [
          {
            'id': 'plant-1',
            'name': 'Tomate',
            'healthScore': 0.3, // High
          },
        ];

        // Act
        final batch = await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        // Assert
        expect(batch.recommendations.length, greaterThan(1));
        // Critical should come first
        expect(
          batch.recommendations.first.urgency,
          equals(RecommendationUrgency.critical),
        );
      });

      test('should handle missing weather data gracefully', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = <String, dynamic>{}; // Empty
        final plants = <Map<String, dynamic>>[];

        // Act
        final batch = await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        // Assert
        expect(batch, isNotNull);
        // Should not throw, may return empty or default recommendations
      });

      test('should handle invalid plant data gracefully', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = {
          'temperature': 20.0,
          'minTemperature': 15.0,
          'maxTemperature': 25.0,
        };
        final plants = [
          {
            'id': 'plant-1',
            // Missing 'name' and 'healthScore'
          },
        ];

        // Act
        final batch = await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        // Assert
        expect(batch, isNotNull);
        // Should not throw, should handle missing fields gracefully
      });
    });

    group('generatePersonalizedRecommendations', () {
      test('should generate personalized recommendations', () async {
        // Arrange
        const userId = 'user-123';
        final userPreferences = {
          'preferredActivities': ['organic_gardening'],
        };
        final historicalData = {
          'successRates': {'planting': 0.8, 'watering': 0.9},
        };

        // Act
        final recommendations = await engine.generatePersonalizedRecommendations(
          userId: userId,
          userPreferences: userPreferences,
          historicalData: historicalData,
        );

        // Assert
        expect(recommendations, isNotEmpty);
        final organicRecommendation = recommendations.firstWhere(
          (r) => r.title.contains('Biologique'),
          orElse: () => throw Exception('Organic recommendation not found'),
        );
        expect(organicRecommendation.context['userId'], equals(userId));
      });

      test('should handle empty preferences gracefully', () async {
        // Arrange
        const userId = 'user-123';
        final userPreferences = <String, dynamic>{};
        final historicalData = <String, dynamic>{};

        // Act
        final recommendations = await engine.generatePersonalizedRecommendations(
          userId: userId,
          userPreferences: userPreferences,
          historicalData: historicalData,
        );

        // Assert
        expect(recommendations, isA<List<IntelligentRecommendation>>());
        // May return empty list if no preferences match
      });
    });

    group('recordRecommendationAcceptance', () {
      test('should record accepted recommendation', () {
        // Arrange
        const recommendationId = 'rec-123';

        // Act
        engine.recordRecommendationAcceptance(
          recommendationId: recommendationId,
          accepted: true,
        );

        // Assert
        final stats = engine.getStatistics();
        expect(stats['acceptedRecommendations'], equals(1));
      });

      test('should record rejected recommendation', () {
        // Arrange
        const recommendationId = 'rec-123';

        // Act
        engine.recordRecommendationAcceptance(
          recommendationId: recommendationId,
          accepted: false,
        );

        // Assert
        final stats = engine.getStatistics();
        expect(stats['acceptedRecommendations'], equals(0));
      });
    });

    group('getRecommendationHistory', () {
      test('should return empty list for unknown garden', () {
        // Arrange
        const gardenId = 'unknown-garden';

        // Act
        final history = engine.getRecommendationHistory(gardenId);

        // Assert
        expect(history, isEmpty);
      });

      test('should return history for known garden', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = {
          'temperature': 20.0,
          'minTemperature': 15.0,
          'maxTemperature': 25.0,
        };
        final plants = <Map<String, dynamic>>[];

        // Generate recommendations to create history
        await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        // Act
        final history = engine.getRecommendationHistory(gardenId);

        // Assert
        expect(history, isNotEmpty);
      });
    });

    group('getStatistics', () {
      test('should return initial statistics', () {
        // Act
        final stats = engine.getStatistics();

        // Assert
        expect(stats['totalRecommendations'], equals(0));
        expect(stats['acceptedRecommendations'], equals(0));
        expect(stats['acceptanceRate'], equals(0.0));
        expect(stats['recommendationsByType'], isA<Map>());
      });

      test('should update statistics after generating recommendations', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = {
          'temperature': 20.0,
          'minTemperature': 15.0,
          'maxTemperature': 25.0,
        };
        final plants = <Map<String, dynamic>>[];

        // Act
        await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        final stats = engine.getStatistics();

        // Assert
        expect(stats['totalRecommendations'], greaterThan(0));
      });
    });

    group('resetStatistics', () {
      test('should reset all statistics', () async {
        // Arrange
        const gardenId = 'garden-123';
        final gardenData = {'name': 'Mon Jardin'};
        final weatherData = {
          'temperature': 20.0,
          'minTemperature': 15.0,
          'maxTemperature': 25.0,
        };
        final plants = <Map<String, dynamic>>[];

        await engine.generateRecommendations(
          gardenId: gardenId,
          gardenData: gardenData,
          weatherData: weatherData,
          plants: plants,
        );

        engine.recordRecommendationAcceptance(
          recommendationId: 'rec-1',
          accepted: true,
        );

        // Act
        engine.resetStatistics();

        // Assert
        final stats = engine.getStatistics();
        expect(stats['totalRecommendations'], equals(0));
        expect(stats['acceptedRecommendations'], equals(0));
        expect(engine.getRecommendationHistory(gardenId), isEmpty);
      });
    });

    group('Error handling', () {
      test('should handle null analytics service gracefully', () {
        // Arrange & Act
        final engineWithoutAnalytics = IntelligentRecommendationEngine(
          analyticsService: null,
        );

        // Assert
        expect(engineWithoutAnalytics, isNotNull);
      });

      test('should handle analytics service injection', () {
        // Arrange
        final analyticsService = PredictiveAnalyticsService();

        // Act
        final engineWithAnalytics = IntelligentRecommendationEngine(
          analyticsService: analyticsService,
        );

        // Assert
        expect(engineWithAnalytics, isNotNull);
      });
    });
  });
}


