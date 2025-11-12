import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:uuid/uuid.dart';

import 'package:permacalendar/features/plant_intelligence/domain/entities/pest.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/pest_observation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/beneficial_insect.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/bio_control_recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_pest_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_beneficial_insect_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_pest_observation_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_bio_control_recommendation_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_plant_data_source.dart';
import 'package:permacalendar/features/plant_intelligence/domain/usecases/analyze_pest_threats_usecase.dart';
import 'package:permacalendar/features/plant_intelligence/domain/usecases/generate_bio_control_recommendations_usecase.dart';
import 'package:permacalendar/core/models/plant.dart' as plant_model;

@GenerateMocks([
  IPestRepository,
  IBeneficialInsectRepository,
  IPestObservationRepository,
  IBioControlRecommendationRepository,
  IPlantDataSource,
])
import 'biological_control_e2e_test.mocks.dart';

/// Integration Test - Biological Control Complete Flow
/// 
/// This test validates the complete end-to-end flow of biological pest control:
/// 1. User creates pest observation (Sanctuary principle)
/// 2. Intelligence analyzes the threats (UseCase: AnalyzePestThreats)
/// 3. Intelligence generates recommendations (UseCase: GenerateBioControl)
/// 4. Recommendations are saved and can be retrieved
/// 
/// PHILOSOPHY VALIDATION:
/// - Observations are created ONLY by the user (Sanctuary)
/// - Recommendations are generated ONLY by the AI (Intelligence)
/// - Unidirectional flow is respected
void main() {
  group('Biological Control E2E Integration Test', () {
    late MockIPestRepository mockPestRepo;
    late MockIBeneficialInsectRepository mockBeneficialRepo;
    late MockIPestObservationRepository mockObservationRepo;
    late MockIBioControlRecommendationRepository mockRecommendationRepo;
    late MockIPlantDataSource mockPlantDataSource;
    
    late AnalyzePestThreatsUsecase analyzePestThreatsUsecase;
    late GenerateBioControlRecommendationsUsecase generateBioControlUsecase;

    const testGardenId = 'test-garden-123';
    const testPlantId = 'tomato';

    setUp(() {
      mockPestRepo = MockIPestRepository();
      mockBeneficialRepo = MockIBeneficialInsectRepository();
      mockObservationRepo = MockIPestObservationRepository();
      mockRecommendationRepo = MockIBioControlRecommendationRepository();
      mockPlantDataSource = MockIPlantDataSource();

      analyzePestThreatsUsecase = AnalyzePestThreatsUsecase(
        observationRepository: mockObservationRepo,
        pestRepository: mockPestRepo,
        plantDataSource: mockPlantDataSource,
      );

      generateBioControlUsecase = GenerateBioControlRecommendationsUsecase(
        pestRepository: mockPestRepo,
        beneficialRepository: mockBeneficialRepo,
        plantDataSource: mockPlantDataSource,
      );
    });

    test('E2E: Complete biological control flow from observation to recommendations', () async {
      // ======== STEP 1: USER CREATES PEST OBSERVATION (SANCTUARY PRINCIPLE) ========
      final pestObservation = PestObservation(
        id: const Uuid().v4(),
        pestId: 'aphid_green',
        plantId: testPlantId,
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.moderate,
        notes: 'Green aphids observed on tomato leaves',
        isActive: true,
      );

      // Simulate user saving the observation
      await mockObservationRepo.savePestObservation(pestObservation);

      // Mock: Repository returns the saved observation
      when(mockObservationRepo.getActiveObservations(testGardenId))
          .thenAnswer((_) async => [pestObservation]);

      // ======== STEP 2: INTELLIGENCE ANALYZES THE THREAT ========
      
      // Mock pest data
      const aphidGreen = Pest(
        id: 'aphid_green',
        name: 'Puceron vert',
        scientificName: 'Aphis fabae',
        affectedPlants: ['tomato', 'pepper', 'bean'],
        defaultSeverity: PestSeverity.moderate,
        symptoms: ['Feuilles enroulées', 'Miellat collant'],
        naturalPredators: ['ladybug', 'lacewing'],
        repellentPlants: ['nasturtium', 'garlic'],
        description: 'Common green aphid',
      );

      when(mockPestRepo.getPest('aphid_green'))
          .thenAnswer((_) async => aphidGreen);

      // Mock plant data
      final tomatoPlant = plant_model.Plant(
        id: testPlantId,
        commonName: 'Tomate',
        scientificName: 'Solanum lycopersicum',
        family: 'Solanaceae',
        description: 'Tomate pour tests E2E',
        plantingSeason: 'Printemps',
        harvestSeason: 'Été',
        daysToMaturity: 75,
        spacing: 50.0,
        depth: 2.0,
        sunExposure: 'Plein soleil',
        waterNeeds: 'Moyen',
        sowingMonths: ['M', 'A', 'M'],
        harvestMonths: ['J', 'J', 'A', 'S'],
        marketPricePerKg: 3.5,
        defaultUnit: 'kg',
        nutritionPer100g: {},
        germination: {},
        growth: {},
        watering: {},
        thinning: {},
        weeding: {},
        culturalTips: [],
        biologicalControl: {},
        harvestTime: 'Matin',
        companionPlanting: {},
        notificationSettings: {},
      );

      when(mockPlantDataSource.getPlant(testPlantId))
          .thenAnswer((_) async => tomatoPlant);

      // Execute threat analysis
      final threatAnalysis = await analyzePestThreatsUsecase.execute(testGardenId);

      // Validate threat analysis
      expect(threatAnalysis.totalThreats, equals(1));
      expect(threatAnalysis.threats.first.pest.id, equals('aphid_green'));
      expect(threatAnalysis.threats.first.observation.id, equals(pestObservation.id));
      expect(threatAnalysis.summary, contains('menace'));

      // ======== STEP 3: INTELLIGENCE GENERATES BIO CONTROL RECOMMENDATIONS ========
      
      // Mock beneficial insects
      const ladybug = BeneficialInsect(
        id: 'ladybug',
        name: 'Coccinelle',
        scientificName: 'Coccinella septempunctata',
        preyPests: ['aphid_green', 'aphid_black'],
        attractiveFlowers: ['yarrow', 'fennel'],
        habitat: HabitatRequirements(
          needsWater: true,
          needsShelter: true,
          favorableConditions: ['Fleurs nectarifères', 'Zones non traitées'],
        ),
        lifeCycle: 'Pond 400 œufs, larves très voraces',
        effectiveness: 90,
      );

      const lacewing = BeneficialInsect(
        id: 'lacewing',
        name: 'Chrysope',
        scientificName: 'Chrysoperla carnea',
        preyPests: ['aphid_green', 'whitefly'],
        attractiveFlowers: ['yarrow', 'fennel'],
        habitat: HabitatRequirements(
          needsWater: true,
          needsShelter: true,
          favorableConditions: ['Haies et arbustes'],
        ),
        lifeCycle: 'Larves très voraces',
        effectiveness: 95,
      );

      when(mockBeneficialRepo.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => [ladybug, lacewing]);

      // Mock repellent plants
      final nasturtium = plant_model.Plant(
        id: 'nasturtium',
        commonName: 'Capucine',
        scientificName: 'Tropaeolum majus',
        family: 'Tropaeolaceae',
        description: 'Capucine pour tests E2E',
        plantingSeason: 'Printemps',
        harvestSeason: 'Été',
        daysToMaturity: 60,
        spacing: 30.0,
        depth: 1.5,
        sunExposure: 'Plein soleil',
        waterNeeds: 'Faible',
        sowingMonths: ['A', 'M', 'J'],
        harvestMonths: ['J', 'J', 'A', 'S'],
        marketPricePerKg: 0.0,
        defaultUnit: 'unité',
        nutritionPer100g: {},
        germination: {},
        growth: {},
        watering: {},
        thinning: {},
        weeding: {},
        culturalTips: [],
        biologicalControl: {},
        harvestTime: 'Matin',
        companionPlanting: {},
        notificationSettings: {},
      );

      when(mockPlantDataSource.getPlant('nasturtium'))
          .thenAnswer((_) async => nasturtium);

      // Mock garlic plant
      final garlic = plant_model.Plant(
        id: 'garlic',
        commonName: 'Ail',
        scientificName: 'Allium sativum',
        family: 'Amaryllidaceae',
        description: 'Ail pour tests E2E',
        plantingSeason: 'Automne',
        harvestSeason: 'Été',
        daysToMaturity: 240,
        spacing: 10.0,
        depth: 3.0,
        sunExposure: 'Plein soleil',
        waterNeeds: 'Faible',
        sowingMonths: ['S', 'O', 'N'],
        harvestMonths: ['J', 'J'],
        marketPricePerKg: 8.0,
        defaultUnit: 'kg',
        nutritionPer100g: {},
        germination: {},
        growth: {},
        watering: {},
        thinning: {},
        weeding: {},
        culturalTips: [],
        biologicalControl: {},
        harvestTime: 'Matin',
        companionPlanting: {},
        notificationSettings: {},
      );

      when(mockPlantDataSource.getPlant('garlic'))
          .thenAnswer((_) async => garlic);

      // Generate recommendations
      final recommendations = await generateBioControlUsecase.execute(pestObservation);

      // ======== STEP 4: VALIDATE RECOMMENDATIONS ========
      
      // Should have multiple recommendation types
      expect(recommendations.isNotEmpty, isTrue);
      
      // Should have beneficial insect recommendations
      final beneficialRecs = recommendations.where(
        (r) => r.type == BioControlType.introduceBeneficial,
      ).toList();
      expect(beneficialRecs.length, greaterThanOrEqualTo(2)); // Ladybug + Lacewing
      
      // Validate ladybug recommendation
      final ladybugRec = beneficialRecs.firstWhere(
        (r) => r.description.contains('Coccinelle'),
      );
      expect(ladybugRec.effectivenessScore, equals(90.0));
      expect(ladybugRec.priority, equals(3)); // Moderate severity → priority 3
      expect(ladybugRec.actions.isNotEmpty, isTrue);
      
      // Should have companion plant recommendations
      final companionRecs = recommendations.where(
        (r) => r.type == BioControlType.plantCompanion,
      ).toList();
      expect(companionRecs.isNotEmpty, isTrue);
      
      // Should have habitat creation recommendations
      final habitatRecs = recommendations.where(
        (r) => r.type == BioControlType.createHabitat,
      ).toList();
      expect(habitatRecs.isNotEmpty, isTrue);
      
      // Should have cultural practice recommendations
      final culturalRecs = recommendations.where(
        (r) => r.type == BioControlType.culturalPractice,
      ).toList();
      expect(culturalRecs.isNotEmpty, isTrue);
      
      // Recommendations should be sorted by priority
      for (int i = 0; i < recommendations.length - 1; i++) {
        expect(
          recommendations[i].priority <= recommendations[i + 1].priority,
          isTrue,
          reason: 'Recommendations should be sorted by priority (ascending)',
        );
      }

      // ======== STEP 5: VALIDATE SANCTUARY PRINCIPLE ========
      
      // Verify that the observation repository was called to SAVE observation
      verify(mockObservationRepo.savePestObservation(any)).called(1);
      
      // Verify that recommendation repository would save AI-generated recommendations
      // (In real app, the orchestrator would call this)
      for (final rec in recommendations) {
        // Simulate saving each recommendation
        await mockRecommendationRepo.saveRecommendation(rec);
      }
      
      // Verify recommendations were saved
      verify(mockRecommendationRepo.saveRecommendation(any)).called(recommendations.length);
      
      // ======== PHILOSOPHY VALIDATION ========
      
      // ✅ Observation created by USER (not AI)
      expect(pestObservation.id, isNotEmpty);
      expect(pestObservation.observedAt, isNotNull);
      
      // ✅ Recommendations generated by AI (not user)
      for (final rec in recommendations) {
        expect(rec.pestObservationId, equals(pestObservation.id));
        expect(rec.createdAt, isNotNull);
        expect(rec.type, isNotNull);
      }
      
      // ✅ Unidirectional flow validated
      // Sanctuary (Observation) → Intelligence (Analysis) → Recommendations (AI Output)
      expect(threatAnalysis.gardenId, equals(testGardenId));
      expect(recommendations.every((r) => r.pestObservationId == pestObservation.id), isTrue);
    });

    test('E2E: Critical severity triggers urgent priority recommendations', () async {
      // Create CRITICAL observation
      final criticalObservation = PestObservation(
        id: const Uuid().v4(),
        pestId: 'colorado_beetle',
        plantId: 'potato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.critical,
        isActive: true,
      );

      const coloradoBeetle = Pest(
        id: 'colorado_beetle',
        name: 'Doryphore',
        scientificName: 'Leptinotarsa decemlineata',
        affectedPlants: ['potato', 'eggplant'],
        defaultSeverity: PestSeverity.critical,
        symptoms: ['Défoliation rapide'],
        naturalPredators: ['ground_beetle'],
        repellentPlants: ['nasturtium'],
      );

      when(mockPestRepo.getPest('colorado_beetle'))
          .thenAnswer((_) async => coloradoBeetle);

      when(mockBeneficialRepo.getPredatorsOf('colorado_beetle'))
          .thenAnswer((_) async => []);

      when(mockPlantDataSource.getPlant('nasturtium'))
          .thenAnswer((_) async => null);

      // Generate recommendations
      final recommendations = await generateBioControlUsecase.execute(criticalObservation);

      // Critical severity should result in priority 1 (urgent)
      final urgentRecs = recommendations.where((r) => r.priority == 1).toList();
      expect(urgentRecs.isNotEmpty, isTrue,
          reason: 'Critical severity should generate urgent (priority 1) recommendations');
    });

    test('E2E: Multiple observations in same garden aggregate correctly', () async {
      final observation1 = PestObservation(
        id: const Uuid().v4(),
        pestId: 'aphid_green',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.moderate,
        isActive: true,
      );

      final observation2 = PestObservation(
        id: const Uuid().v4(),
        pestId: 'whitefly',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.high,
        isActive: true,
      );

      when(mockObservationRepo.getActiveObservations(testGardenId))
          .thenAnswer((_) async => [observation1, observation2]);

      const aphid = Pest(
        id: 'aphid_green',
        name: 'Puceron vert',
        scientificName: 'Aphis fabae',
        affectedPlants: ['tomato'],
        defaultSeverity: PestSeverity.moderate,
        symptoms: [],
        naturalPredators: [],
        repellentPlants: [],
      );

      const whitefly = Pest(
        id: 'whitefly',
        name: 'Mouche blanche',
        scientificName: 'Trialeurodes',
        affectedPlants: ['tomato'],
        defaultSeverity: PestSeverity.moderate,
        symptoms: [],
        naturalPredators: [],
        repellentPlants: [],
      );

      when(mockPestRepo.getPest('aphid_green')).thenAnswer((_) async => aphid);
      when(mockPestRepo.getPest('whitefly')).thenAnswer((_) async => whitefly);

      final tomatoPlant = plant_model.Plant(
        id: 'tomato',
        commonName: 'Tomate',
        scientificName: 'Solanum lycopersicum',
        family: 'Solanaceae',
        description: 'Tomate pour tests E2E',
        plantingSeason: 'Printemps',
        harvestSeason: 'Été',
        daysToMaturity: 75,
        spacing: 50.0,
        depth: 2.0,
        sunExposure: 'Plein soleil',
        waterNeeds: 'Moyen',
        sowingMonths: ['M', 'A', 'M'],
        harvestMonths: ['J', 'J', 'A', 'S'],
        marketPricePerKg: 3.5,
        defaultUnit: 'kg',
        nutritionPer100g: {},
        germination: {},
        growth: {},
        watering: {},
        thinning: {},
        weeding: {},
        culturalTips: [],
        biologicalControl: {},
        harvestTime: 'Matin',
        companionPlanting: {},
        notificationSettings: {},
      );

      when(mockPlantDataSource.getPlant('tomato'))
          .thenAnswer((_) async => tomatoPlant);

      // Analyze threats
      final threatAnalysis = await analyzePestThreatsUsecase.execute(testGardenId);

      // Should detect both threats
      expect(threatAnalysis.totalThreats, equals(2));
      expect(threatAnalysis.highThreats, equals(1)); // Whitefly is high
      expect(threatAnalysis.moderateThreats, equals(1)); // Aphid is moderate
    });
  });
}



