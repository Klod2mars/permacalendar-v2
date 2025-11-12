import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/pest.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/pest_observation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/pest_threat_analysis.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_pest_observation_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_pest_repository.dart';
import 'package:permacalendar/features/plant_intelligence/domain/repositories/i_plant_data_source.dart';
import 'package:permacalendar/features/plant_intelligence/domain/usecases/analyze_pest_threats_usecase.dart';

import 'test_plant_helper.dart';

// Import mocks will be generated
// ignore: unused_import
import 'analyze_pest_threats_usecase_test.mocks.dart';

// Generate mocks
@GenerateMocks([], customMocks: [
  MockSpec<IPestObservationRepository>(as: #MockIPestObservationRepository),
  MockSpec<IPestRepository>(as: #MockIPestRepository),
  MockSpec<IPlantDataSource>(as: #MockIPlantDataSource),
])
void main() {
  late AnalyzePestThreatsUsecase usecase;
  late MockIPestObservationRepository mockObservationRepository;
  late MockIPestRepository mockPestRepository;
  late MockIPlantDataSource mockPlantDataSource;

  setUp(() {
    mockObservationRepository = MockIPestObservationRepository();
    mockPestRepository = MockIPestRepository();
    mockPlantDataSource = MockIPlantDataSource();

    usecase = AnalyzePestThreatsUsecase(
      observationRepository: mockObservationRepository,
      pestRepository: mockPestRepository,
      plantDataSource: mockPlantDataSource,
    );
  });

  group('AnalyzePestThreatsUsecase', () {
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

    final testPlant = createTestPlant(
      id: 'tomato',
      commonName: 'Tomate',
      scientificName: 'Solanum lycopersicum',
      family: 'Solanaceae',
    );

    test('should return empty analysis when no observations exist', () async {
      // Arrange
      when(mockObservationRepository.getActiveObservations(testGardenId))
          .thenAnswer((_) async => []);

      // Act
      final result = await usecase.execute(testGardenId);

      // Assert
      expect(result.gardenId, equals(testGardenId));
      expect(result.totalThreats, equals(0));
      expect(result.threats, isEmpty);
      expect(result.criticalThreats, equals(0));
      expect(result.highThreats, equals(0));
      expect(result.moderateThreats, equals(0));
      expect(result.lowThreats, equals(0));
      expect(result.overallThreatScore, equals(0.0));
      expect(result.summary, contains('Aucune menace'));
      
      verify(mockObservationRepository.getActiveObservations(testGardenId))
          .called(1);
    });

    test('should analyze single moderate threat correctly', () async {
      // Arrange
      final testObservation = PestObservation(
        id: 'obs_1',
        pestId: 'aphid_green',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.moderate,
        isActive: true,
      );

      when(mockObservationRepository.getActiveObservations(testGardenId))
          .thenAnswer((_) async => [testObservation]);
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockPlantDataSource.getPlant('tomato'))
          .thenAnswer((_) async => testPlant);

      // Act
      final result = await usecase.execute(testGardenId);

      // Assert
      expect(result.totalThreats, equals(1));
      expect(result.threats.length, equals(1));
      expect(result.threats.first.pest.id, equals('aphid_green'));
      expect(result.threats.first.affectedPlant.id, equals('tomato'));
      expect(result.threats.first.threatLevel, equals(ThreatLevel.moderate));
      expect(result.threats.first.impactScore, greaterThan(0));
      expect(result.moderateThreats, equals(1));
      expect(result.criticalThreats, equals(0));
      
      verify(mockObservationRepository.getActiveObservations(testGardenId))
          .called(1);
      verify(mockPestRepository.getPest('aphid_green')).called(1);
      verify(mockPlantDataSource.getPlant('tomato')).called(1);
    });

    test('should calculate critical threat level correctly', () async {
      // Arrange
      const criticalPest = Pest(
        id: 'colorado_beetle',
        name: 'Doryphore',
        scientificName: 'Leptinotarsa decemlineata',
        affectedPlants: ['potato'],
        defaultSeverity: PestSeverity.critical,
        symptoms: ['Défoliation rapide'],
        naturalPredators: ['ground_beetle'],
        repellentPlants: ['nasturtium'],
      );

      final testObservation = PestObservation(
        id: 'obs_2',
        pestId: 'colorado_beetle',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.critical,
        isActive: true,
      );

      when(mockObservationRepository.getActiveObservations(testGardenId))
          .thenAnswer((_) async => [testObservation]);
      when(mockPestRepository.getPest('colorado_beetle'))
          .thenAnswer((_) async => criticalPest);
      when(mockPlantDataSource.getPlant('tomato'))
          .thenAnswer((_) async => testPlant);

      // Act
      final result = await usecase.execute(testGardenId);

      // Assert
      expect(result.totalThreats, equals(1));
      expect(result.threats.first.threatLevel, equals(ThreatLevel.critical));
      expect(result.criticalThreats, equals(1));
      expect(result.summary, contains('Attention'));
      expect(result.summary, contains('critique'));
      expect(result.overallThreatScore, greaterThan(80.0));
    });

    test('should handle multiple threats of different severities', () async {
      // Arrange
      final observation1 = PestObservation(
        id: 'obs_1',
        pestId: 'aphid_green',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.low,
        isActive: true,
      );

      final observation2 = PestObservation(
        id: 'obs_2',
        pestId: 'aphid_green',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.high,
        isActive: true,
      );

      final observation3 = PestObservation(
        id: 'obs_3',
        pestId: 'aphid_green',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.moderate,
        isActive: true,
      );

      when(mockObservationRepository.getActiveObservations(testGardenId))
          .thenAnswer((_) async => [observation1, observation2, observation3]);
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockPlantDataSource.getPlant('tomato'))
          .thenAnswer((_) async => testPlant);

      // Act
      final result = await usecase.execute(testGardenId);

      // Assert
      expect(result.totalThreats, equals(3));
      expect(result.threats.length, equals(3));
      // At least 2 different threat levels should exist
      expect(
        result.threats.map((t) => t.threatLevel).toSet().length,
        greaterThanOrEqualTo(1),
      );
    });

    test('should skip observations with missing pest data', () async {
      // Arrange
      final observation1 = PestObservation(
        id: 'obs_1',
        pestId: 'aphid_green',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.moderate,
        isActive: true,
      );

      final observation2 = PestObservation(
        id: 'obs_2',
        pestId: 'invalid_pest',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.high,
        isActive: true,
      );

      when(mockObservationRepository.getActiveObservations(testGardenId))
          .thenAnswer((_) async => [observation1, observation2]);
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockPestRepository.getPest('invalid_pest'))
          .thenAnswer((_) async => null); // Missing pest data
      when(mockPlantDataSource.getPlant('tomato'))
          .thenAnswer((_) async => testPlant);

      // Act
      final result = await usecase.execute(testGardenId);

      // Assert
      expect(result.totalThreats, equals(1)); // Only valid observation
      expect(result.threats.first.observation.id, equals('obs_1'));
      
      verify(mockPestRepository.getPest('aphid_green')).called(1);
      verify(mockPestRepository.getPest('invalid_pest')).called(1);
    });

    test('should skip observations with missing plant data', () async {
      // Arrange
      final observation = PestObservation(
        id: 'obs_1',
        pestId: 'aphid_green',
        plantId: 'invalid_plant',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.moderate,
        isActive: true,
      );

      when(mockObservationRepository.getActiveObservations(testGardenId))
          .thenAnswer((_) async => [observation]);
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockPlantDataSource.getPlant('invalid_plant'))
          .thenAnswer((_) async => null); // Missing plant data

      // Act
      final result = await usecase.execute(testGardenId);

      // Assert
      expect(result.totalThreats, equals(0)); // Skipped due to missing plant
      expect(result.threats, isEmpty);
    });

    test('should include threat description and consequences', () async {
      // Arrange
      final testObservation = PestObservation(
        id: 'obs_1',
        pestId: 'aphid_green',
        plantId: 'tomato',
        gardenId: testGardenId,
        observedAt: DateTime.now(),
        severity: PestSeverity.high,
        isActive: true,
      );

      when(mockObservationRepository.getActiveObservations(testGardenId))
          .thenAnswer((_) async => [testObservation]);
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockPlantDataSource.getPlant('tomato'))
          .thenAnswer((_) async => testPlant);

      // Act
      final result = await usecase.execute(testGardenId);

      // Assert
      final threat = result.threats.first;
      expect(threat.threatDescription, isNotNull);
      expect(threat.threatDescription, contains('Puceron vert'));
      expect(threat.threatDescription, contains('Tomate'));
      expect(threat.potentialConsequences, isNotNull);
      expect(threat.potentialConsequences, isNotEmpty);
    });

    test('should set analyzedAt timestamp', () async {
      // Arrange
      when(mockObservationRepository.getActiveObservations(testGardenId))
          .thenAnswer((_) async => []);

      final beforeExecution = DateTime.now();

      // Act
      final result = await usecase.execute(testGardenId);

      final afterExecution = DateTime.now();

      // Assert
      expect(result.analyzedAt, isNotNull);
      expect(
        result.analyzedAt!.isAfter(beforeExecution.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        result.analyzedAt!.isBefore(afterExecution.add(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('should calculate overall threat score correctly', () async {
      // Arrange
      final observations = [
        PestObservation(
          id: 'obs_1',
          pestId: 'aphid_green',
          plantId: 'tomato',
          gardenId: testGardenId,
          observedAt: DateTime.now(),
          severity: PestSeverity.low,
          isActive: true,
        ),
        PestObservation(
          id: 'obs_2',
          pestId: 'aphid_green',
          plantId: 'tomato',
          gardenId: testGardenId,
          observedAt: DateTime.now(),
          severity: PestSeverity.critical,
          isActive: true,
        ),
      ];

      when(mockObservationRepository.getActiveObservations(testGardenId))
          .thenAnswer((_) async => observations);
      when(mockPestRepository.getPest('aphid_green'))
          .thenAnswer((_) async => testPest);
      when(mockPlantDataSource.getPlant('tomato'))
          .thenAnswer((_) async => testPlant);

      // Act
      final result = await usecase.execute(testGardenId);

      // Assert
      expect(result.overallThreatScore, greaterThan(0));
      expect(result.overallThreatScore, lessThanOrEqualTo(100));
      // Average of low and critical should be moderate range
      expect(result.overallThreatScore, greaterThan(30));
      expect(result.overallThreatScore, lessThan(80));
    });
  });
}



