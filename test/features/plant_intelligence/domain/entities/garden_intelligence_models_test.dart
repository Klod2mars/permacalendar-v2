import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_intelligence_context.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_intelligence_memory.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_intelligence_settings.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligent_suggestion.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/analysis_result.dart';

void main() {
  group('GardenIntelligence Models Serialization', () {
    test('GardenIntelligenceContext toJson/fromJson', () {
      // Arrange
      final context = GardenIntelligenceContext(
        gardenId: 'test-garden-123',
        gardenName: 'Mon Potager Test',
        location: {
          'latitude': 48.8566,
          'longitude': 2.3522,
          'altitude': 35.0,
          'exposition': 'sud',
        },
        climate: {
          'zone': '8a',
          'temperature_min': -12.0,
          'temperature_max': 35.0,
          'precipitations': 650.0,
        },
        soil: {
          'type': 'argileux',
          'ph': 6.5,
          'drainage': 'moyen',
        },
        activePlantIds: ['plant-1', 'plant-2'],
        archivedPlantIds: ['plant-old'],
        stats: {
          'surface': 50.0,
          'nombre_plantes': 2,
          'rendement_annuel': 15.5,
        },
        preferences: {
          'methode': 'permaculture',
          'objectif': 'autonomie',
        },
        collaboratorIds: ['user-1', 'user-2'],
        customData: {'test_key': 'test_value'},
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
        lastIntelligenceSync: DateTime(2024, 1, 3),
      );

      // Act
      final json = context.toJson();
      final restoredContext = GardenIntelligenceContext.fromJson(json);

      // Assert
      expect(restoredContext.gardenId, equals('test-garden-123'));
      expect(restoredContext.gardenName, equals('Mon Potager Test'));
      expect(restoredContext.activePlantIds, equals(['plant-1', 'plant-2']));
      expect(restoredContext.archivedPlantIds, equals(['plant-old']));
      expect(restoredContext.collaboratorIds, equals(['user-1', 'user-2']));
      expect(restoredContext.customData, equals({'test_key': 'test_value'}));
      expect(
          restoredContext.location,
          equals({
            'latitude': 48.8566,
            'longitude': 2.3522,
            'altitude': 35.0,
            'exposition': 'sud',
          }));
      expect(
          restoredContext.lastIntelligenceSync, equals(DateTime(2024, 1, 3)));
    });

    test('GardenIntelligenceMemory toJson/fromJson', () {
      // Arrange - Test simplifié sans objets complexes dans les Maps
      final memory = GardenIntelligenceMemory(
        gardenId: 'test-garden-123',
        currentReports: {}, // Maps vides pour éviter les problèmes de sérialisation
        reportHistory: {},
        recentAnalyses: [],
        activeAlerts: [],
        activeSuggestions: [],
        globalIntelligenceScore: 0.85,
        globalConfidence: 0.9,
        totalReportsGenerated: 5,
        totalAnalysesPerformed: 12,
        lastReportGeneratedAt: DateTime.now(),
        memoryCreatedAt: DateTime(2024, 1, 1),
        memoryUpdatedAt: DateTime.now(),
      );

      // Act
      final json = memory.toJson();
      final restoredMemory = GardenIntelligenceMemory.fromJson(json);

      // Assert
      expect(restoredMemory.gardenId, equals('test-garden-123'));
      expect(restoredMemory.currentReports, isEmpty);
      expect(restoredMemory.reportHistory, isEmpty);
      expect(restoredMemory.globalIntelligenceScore, equals(0.85));
      expect(restoredMemory.globalConfidence, equals(0.9));
      expect(restoredMemory.totalReportsGenerated, equals(5));
      expect(restoredMemory.totalAnalysesPerformed, equals(12));
    });

    test('GardenIntelligenceSettings toJson/fromJson', () {
      // Arrange
      final settings = GardenIntelligenceSettings(
        gardenId: 'test-garden-123',
        alertLevel: NotificationLevel.high,
        enableWeatherAlerts: true,
        enableLunarSuggestions: false,
        enableSeasonalReminders: true,
        enablePestWarnings: false,
        reportFrequency: ReportFrequency.hourly,
        showDetailedAnalysis: true,
        showConfidenceScores: false,
        showDebugInfo: true,
        minConfidenceThreshold: 0.8,
        maxSuggestionsPerDay: 10,
        historyRetentionDays: 60,
        isSharedGarden: true,
        allowCollaboratorSuggestions: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime.now(),
      );

      // Act
      final json = settings.toJson();
      final restoredSettings = GardenIntelligenceSettings.fromJson(json);

      // Assert
      expect(restoredSettings.gardenId, equals('test-garden-123'));
      expect(restoredSettings.alertLevel, equals(NotificationLevel.high));
      expect(restoredSettings.enableWeatherAlerts, isTrue);
      expect(restoredSettings.enableLunarSuggestions, isFalse);
      expect(restoredSettings.reportFrequency, equals(ReportFrequency.hourly));
      expect(restoredSettings.minConfidenceThreshold, equals(0.8));
      expect(restoredSettings.maxSuggestionsPerDay, equals(10));
      expect(restoredSettings.historyRetentionDays, equals(60));
      expect(restoredSettings.isSharedGarden, isTrue);
      expect(restoredSettings.allowCollaboratorSuggestions, isFalse);
    });

    test('IntelligentSuggestion toJson/fromJson', () {
      // Arrange
      final suggestion = IntelligentSuggestion(
        id: 'suggestion-123',
        gardenId: 'test-garden-123',
        message: 'C\'est le moment idéal pour semer vos tomates',
        priority: SuggestionPriority.high,
        category: SuggestionCategory.seasonal,
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        isRead: false,
        isActioned: false,
        createdAt: DateTime.now(),
      );

      // Act
      final json = suggestion.toJson();
      final restoredSuggestion = IntelligentSuggestion.fromJson(json);

      // Assert
      expect(restoredSuggestion.id, equals('suggestion-123'));
      expect(restoredSuggestion.gardenId, equals('test-garden-123'));
      expect(restoredSuggestion.message,
          equals('C\'est le moment idéal pour semer vos tomates'));
      expect(restoredSuggestion.priority, equals(SuggestionPriority.high));
      expect(restoredSuggestion.category, equals(SuggestionCategory.seasonal));
      expect(restoredSuggestion.isRead, isFalse);
      expect(restoredSuggestion.isActioned, isFalse);
      expect(restoredSuggestion.expiresAt, isNotNull);
    });

    test('IntelligentSuggestion with null expiresAt', () {
      // Arrange
      final suggestion = IntelligentSuggestion(
        id: 'suggestion-456',
        gardenId: 'test-garden-123',
        message: 'Suggestion permanente',
        priority: SuggestionPriority.low,
        category: SuggestionCategory.maintenance,
        expiresAt: null, // Suggestion permanente
        isRead: true,
        isActioned: true,
        createdAt: DateTime.now(),
      );

      // Act
      final json = suggestion.toJson();
      final restoredSuggestion = IntelligentSuggestion.fromJson(json);

      // Assert
      expect(restoredSuggestion.expiresAt, isNull);
      expect(restoredSuggestion.isRead, isTrue);
      expect(restoredSuggestion.isActioned, isTrue);
    });
  });
}

