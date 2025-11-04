import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/pest.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/pest_observation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/beneficial_insect.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/bio_control_recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_pest_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_beneficial_insect_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_plant_data_source.dart';
import 'package:permacalendar/features/plant_intelligence/domain/usecases/generate_bio_control_recommendations_usecase.dart';
import 'package:uuid/uuid.dart';

import 'test_plant_helper.dart';

// Import mocks will be generated
// ignore: unused_import
import 'generate_bio_control_recommendations_usecase_test.mocks.dart';

// Generate mocks
@GenerateMocks([], customMocks: [
  MockSpec<IPestRepository>(as: #MockIPestRepository),
  MockSpec<IBeneficialInsectRepository>(as: #MockIBeneficialInsectRepository),
  MockSpec<IPlantDataSource>(as: #MockIPlantDataSource),
  MockSpec<Uuid>(as: #MockUuid),
])
void main() {
  late GenerateBioControlRecommendationsUsecase usecase;
  late MockIPestRepository mockPestRepository;
  late MockIBeneficialInsectRepository mockBeneficialRepository;
  late MockIPlantDataSource mockPlantDataSource;
  late MockUuid mockUuid;

  setUp(() {
    mockPestRepository = MockIPestRepository();
    mockBeneficialRepository = MockIBeneficialInsectRepository();
    mockPlantDataSource = MockIPlantDataSource();
    mockUuid = MockUuid();

    usecase = GenerateBioControlRecommendationsUsecase(
      pestRepository: mockPestRepository,
      beneficialRepository: mockBeneficialRepository,
      plantDataSource: mockPlantDataSource,
      uuid: mockUuid,
    );
  });

  group('GenerateBioControlRecommendationsUsecase', () {
    const testGardenId = 'test_garden_123';

    const testPest = Pest(
      id: 'aphid_green',
      name: 'Puceron vert',
      scientificName: 'Aphis fabae',
      affectedPlants: ['tomato', 'pepper'],
      defaultSeverity: PestSeverity.moderate,
      symptoms: ['Feuilles enroulées', 'Miellat collant'],
      naturalPredators: ['ladybug', 'lacewing'],
      repellentPlants: ['nasturtium', 'garlic'],
    );

    const testBeneficial = BeneficialInsect(
      id: 'ladybug',
      name: 'Coccinelle à sept points',
      scientificName: 'Coccinella septempunctata',
      preyPests: ['aphid_green', 'aphid_black'],
      attractiveFlowers: ['yarrow', 'fennel', 'dill'],
      habitat: HabitatRequirements(
        needsWater: true,
        needsShelter: true,
        favorableConditions: ['Fleurs nectarifères', 'Pas de pesticides'],
      ),
      lifeCycle: 'Pond 400 œufs. Larves très voraces.',
      effectiveness: 90,
    );

    final testPlant = createTestPlant(
      id: 'nasturtium',
      commonName: 'Capucine',
      scientificName: 'Tropaeolum majus',
      family: 'Tropaeolaceae',
    );

    final testObservation = PestObservation(
      id: 'obs_1',
      pestId: 'aphid_green',
      plantId: 'tomato',
      gardenId: testGardenId,
      observedAt: DateTime.now(),
      severity: PestSeverity.moderate,
      isActive: true,
    );

    test('should return empty list when pest is not found', () async {
      // Arrange
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => null);

      // Act
      final result = await usecase.execute(testObservation);

      // Assert
      expect(result, isEmpty);
      verify(mockPestRepository.getPest('aphid_green')).called(1);
      verifyNever(mockBeneficialRepository.getPredatorsOf(any));
    });

    test('should generate beneficial insect recommendations', () async {
      // Arrange
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockBeneficialRepository.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => [testBeneficial]);
      when(mockPlantDataSource.getPlant(any))
          .thenAnswer((_) async => testPlant);
      when(mockUuid.v4()).thenReturn('uuid_1');

      // Act
      final result = await usecase.execute(testObservation);

      // Assert
      final beneficialRecs = result.where(
        (r) => r.type == BioControlType.introduceBeneficial,
      );
      expect(beneficialRecs, isNotEmpty);
      
      final rec = beneficialRecs.first;
      expect(rec.pestObservationId, equals('obs_1'));
      expect(rec.description, contains('Coccinelle'));
      expect(rec.description, contains('Puceron vert'));
      expect(rec.actions, isNotEmpty);
      expect(rec.effectivenessScore, equals(90.0));
      expect(rec.targetBeneficialId, equals('ladybug'));
    });

    test('should generate companion plant recommendations', () async {
      // Arrange
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockBeneficialRepository.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => []);
      when(mockPlantDataSource.getPlant('nasturtium'))
          .thenAnswer((_) async => testPlant);
      when(mockPlantDataSource.getPlant('garlic'))
          .thenAnswer((_) async => createTestPlant(
                id: 'garlic',
                commonName: 'Ail',
                scientificName: 'Allium sativum',
                family: 'Amaryllidaceae',
              ));
      when(mockUuid.v4()).thenAnswer((_) => 'uuid_test');

      // Act
      final result = await usecase.execute(testObservation);

      // Assert
      final companionRecs = result.where(
        (r) => r.type == BioControlType.plantCompanion,
      );
      expect(companionRecs, isNotEmpty);
      
      final rec = companionRecs.first;
      expect(rec.type, equals(BioControlType.plantCompanion));
      expect(rec.description.toLowerCase(), contains('planter'));
      expect(rec.description, contains('répulsif'));
      expect(rec.actions, isNotEmpty);
      expect(rec.priority, equals(3)); // Preventive
      expect(rec.effectivenessScore, equals(60.0));
      expect(rec.targetPlantId, isNotNull);
    });

    test('should generate habitat recommendations', () async {
      // Arrange
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockBeneficialRepository.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => [testBeneficial]);
      when(mockPlantDataSource.getPlant(any))
          .thenAnswer((_) async => testPlant);
      when(mockUuid.v4()).thenAnswer((_) => 'uuid_test');

      // Act
      final result = await usecase.execute(testObservation);

      // Assert
      final habitatRecs = result.where(
        (r) => r.type == BioControlType.createHabitat,
      );
      expect(habitatRecs, isNotEmpty);
      
      final rec = habitatRecs.first;
      expect(rec.type, equals(BioControlType.createHabitat));
      expect(rec.description, contains('habitat'));
      expect(rec.actions.length, greaterThan(1)); // Should have multiple actions
      expect(rec.priority, equals(4)); // Strategic long-term
      
      // Check for water and shelter actions
      final actionDescriptions = rec.actions.map((a) => a.description).join(' ');
      if (testBeneficial.habitat.needsWater) {
        expect(actionDescriptions.toLowerCase(), contains('eau'));
      }
      if (testBeneficial.habitat.needsShelter) {
        expect(actionDescriptions.toLowerCase(), contains('abri'));
      }
    });

    test('should generate cultural practice recommendations', () async {
      // Arrange
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockBeneficialRepository.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => []);
      when(mockPlantDataSource.getPlant(any))
          .thenAnswer((_) async => testPlant);
      when(mockUuid.v4()).thenAnswer((_) => 'uuid_test');

      // Act
      final result = await usecase.execute(testObservation);

      // Assert
      final culturalRecs = result.where(
        (r) => r.type == BioControlType.culturalPractice,
      );
      expect(culturalRecs, isNotEmpty);
      
      final rec = culturalRecs.first;
      expect(rec.type, equals(BioControlType.culturalPractice));
      expect(rec.description, contains('Pratiques culturales'));
      expect(rec.actions, isNotEmpty);
      
      // Should include manual removal
      final hasManualRemoval = rec.actions.any(
        (a) => a.description.toLowerCase().contains('manuel'),
      );
      expect(hasManualRemoval, isTrue);
    });

    test('should prioritize critical severity observations', () async {
      // Arrange
      final criticalObservation = PestObservation(
        id: 'obs_critical',
        pestId: 'aphid_green',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.critical,
        isActive: true,
      );

      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockBeneficialRepository.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => [testBeneficial]);
      when(mockPlantDataSource.getPlant(any))
          .thenAnswer((_) async => testPlant);
      when(mockUuid.v4()).thenAnswer((_) => 'uuid_test');

      // Act
      final result = await usecase.execute(criticalObservation);

      // Assert
      final beneficialRec = result.firstWhere(
        (r) => r.type == BioControlType.introduceBeneficial,
      );
      expect(beneficialRec.priority, equals(1)); // Urgent
      
      final action = beneficialRec.actions.first;
      expect(action.timing, equals('Immédiatement'));
    });

    test('should include neem oil for high severity', () async {
      // Arrange
      final highObservation = PestObservation(
        id: 'obs_high',
        pestId: 'aphid_green',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.high,
        isActive: true,
      );

      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockBeneficialRepository.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => []);
      when(mockPlantDataSource.getPlant(any))
          .thenAnswer((_) async => testPlant);
      when(mockUuid.v4()).thenAnswer((_) => 'uuid_test');

      // Act
      final result = await usecase.execute(highObservation);

      // Assert
      final culturalRec = result.firstWhere(
        (r) => r.type == BioControlType.culturalPractice,
      );
      
      final hasNeemOil = culturalRec.actions.any(
        (a) => a.description.toLowerCase().contains('neem'),
      );
      expect(hasNeemOil, isTrue);
    });

    test('should sort recommendations by priority and effectiveness', () async {
      // Arrange
      final criticalObservation = PestObservation(
        id: 'obs_critical',
        pestId: 'aphid_green',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.critical,
        isActive: true,
      );

      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockBeneficialRepository.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => [testBeneficial]);
      when(mockPlantDataSource.getPlant(any))
          .thenAnswer((_) async => testPlant);
      when(mockUuid.v4()).thenAnswer((_) => 'uuid_test');

      // Act
      final result = await usecase.execute(criticalObservation);

      // Assert
      expect(result, isNotEmpty);
      
      // First recommendation should have highest priority (lowest number)
      final firstPriority = result.first.priority;
      for (final rec in result) {
        expect(rec.priority, greaterThanOrEqualTo(firstPriority));
      }
    });

    test('should set createdAt timestamp', () async {
      // Arrange
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockBeneficialRepository.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => [testBeneficial]);
      when(mockPlantDataSource.getPlant(any))
          .thenAnswer((_) async => testPlant);
      when(mockUuid.v4()).thenAnswer((_) => 'uuid_test');

      final beforeExecution = DateTime.now();

      // Act
      final result = await usecase.execute(testObservation);

      final afterExecution = DateTime.now();

      // Assert
      for (final rec in result) {
        expect(rec.createdAt, isNotNull);
        expect(
          rec.createdAt!.isAfter(beforeExecution.subtract(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          rec.createdAt!.isBefore(afterExecution.add(const Duration(seconds: 1))),
          isTrue,
        );
      }
    });

    test('should handle multiple beneficial insects', () async {
      // Arrange
      const secondBeneficial = BeneficialInsect(
        id: 'lacewing',
        name: 'Chrysope verte',
        scientificName: 'Chrysoperla carnea',
        preyPests: ['aphid_green'],
        attractiveFlowers: ['yarrow', 'fennel'],
        habitat: HabitatRequirements(
          needsWater: true,
          needsShelter: true,
          favorableConditions: ['Haies', 'Fleurs'],
        ),
        lifeCycle: 'Larves très voraces',
        effectiveness: 95,
      );

      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockBeneficialRepository.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => [testBeneficial, secondBeneficial]);
      when(mockPlantDataSource.getPlant(any))
          .thenAnswer((_) async => testPlant);
      when(mockUuid.v4()).thenAnswer((_) => 'uuid_test');

      // Act
      final result = await usecase.execute(testObservation);

      // Assert
      final beneficialRecs = result.where(
        (r) => r.type == BioControlType.introduceBeneficial,
      );
      expect(beneficialRecs.length, greaterThanOrEqualTo(2));
      
      // Should have recommendations for both beneficial insects
      final targetIds = beneficialRecs
          .map((r) => r.targetBeneficialId)
          .where((id) => id != null)
          .toSet();
      expect(targetIds, contains('ladybug'));
      expect(targetIds, contains('lacewing'));
    });

    test('should skip companion plants that are not in repository', () async {
      // Arrange
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockBeneficialRepository.getPredatorsOf('aphid_green'))
          .thenAnswer((_) async => []);
      when(mockPlantDataSource.getPlant('nasturtium'))
          .thenAnswer((_) async => testPlant);
      when(mockPlantDataSource.getPlant('garlic'))
          .thenAnswer((_) async => null); // Missing plant
      when(mockUuid.v4()).thenAnswer((_) => 'uuid_test');

      // Act
      final result = await usecase.execute(testObservation);

      // Assert
      final companionRecs = result.where(
        (r) => r.type == BioControlType.plantCompanion,
      );
      
      // Should only have recommendation for nasturtium (not garlic)
      expect(companionRecs.length, equals(1));
      expect(companionRecs.first.targetPlantId, equals('nasturtium'));
    });
  });
}

