import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/climate/domain/usecases/round_ph_to_step_usecase.dart';

void main() {
  group('RoundPhToStepUsecase', () {
    late RoundPhToStepUsecase usecase;

    setUp(() {
      usecase = RoundPhToStepUsecase();
    });

    group('basic rounding', () {
      test('should round 6.24 to 6.0', () {
        // Act
        final result = usecase(6.24);

        // Assert
        expect(result, equals(6.0));
      });

      test('should round 6.26 to 6.5', () {
        // Act
        final result = usecase(6.26);

        // Assert
        expect(result, equals(6.5));
      });

      test('should round 6.75 to 7.0', () {
        // Act
        final result = usecase(6.75);

        // Assert
        expect(result, equals(7.0));
      });

      test('should round 6.5 to 6.5 (already at step)', () {
        // Act
        final result = usecase(6.5);

        // Assert
        expect(result, equals(6.5));
      });

      test('should round 6.0 to 6.0 (already at step)', () {
        // Act
        final result = usecase(6.0);

        // Assert
        expect(result, equals(6.0));
      });
    });

    group('clamping', () {
      test('should clamp -1.0 to 0.0', () {
        // Act
        final result = usecase(-1.0);

        // Assert
        expect(result, equals(0.0));
      });

      test('should clamp 15.0 to 14.0', () {
        // Act
        final result = usecase(15.0);

        // Assert
        expect(result, equals(14.0));
      });

      test('should clamp 0.0 to 0.0 (at boundary)', () {
        // Act
        final result = usecase(0.0);

        // Assert
        expect(result, equals(0.0));
      });

      test('should clamp 14.0 to 14.0 (at boundary)', () {
        // Act
        final result = usecase(14.0);

        // Assert
        expect(result, equals(14.0));
      });
    });

    group('step navigation', () {
      test('should get next step correctly', () {
        // Act & Assert
        expect(usecase.nextStep(6.0), equals(6.5));
        expect(usecase.nextStep(6.5), equals(7.0));
        expect(usecase.nextStep(13.5), equals(14.0));
        expect(usecase.nextStep(14.0), equals(14.0)); // At maximum
      });

      test('should get previous step correctly', () {
        // Act & Assert
        expect(usecase.previousStep(6.5), equals(6.0));
        expect(usecase.previousStep(7.0), equals(6.5));
        expect(usecase.previousStep(0.5), equals(0.0));
        expect(usecase.previousStep(0.0), equals(0.0)); // At minimum
      });
    });

    group('step generation', () {
      test('should get all steps correctly', () {
        // Act
        final steps = usecase.getAllSteps();

        // Assert
        expect(steps, hasLength(29)); // 0.0 to 14.0 in 0.5 increments
        expect(steps.first, equals(0.0));
        expect(steps.last, equals(14.0));
        expect(steps[1], equals(0.5));
        expect(steps[2], equals(1.0));
        expect(steps[13], equals(6.5));
      });

      test('should get steps in range correctly', () {
        // Act
        final steps = usecase.getStepsInRange(6.0, 7.5);

        // Assert
        expect(steps, equals([6.0, 6.5, 7.0, 7.5]));
      });

      test('should handle invalid range', () {
        // Act
        final steps = usecase.getStepsInRange(7.5, 6.0); // min > max

        // Assert
        expect(steps, isEmpty);
      });

      test('should clamp range to valid bounds', () {
        // Act
        final steps = usecase.getStepsInRange(-1.0, 15.0);

        // Assert
        expect(steps.first, equals(0.0));
        expect(steps.last, equals(14.0));
      });
    });

    group('pH categories', () {
      test('should categorize pH values correctly', () {
        // Act & Assert
        expect(usecase.getCategory(4.0), equals('Très acide'));
        expect(usecase.getCategory(5.0), equals('Très acide'));
        expect(usecase.getCategory(5.5), equals('Acide'));
        expect(usecase.getCategory(6.0), equals('Acide'));
        expect(usecase.getCategory(6.5), equals('Neutre'));
        expect(usecase.getCategory(7.0), equals('Neutre'));
        expect(usecase.getCategory(7.5), equals('Alcalin'));
        expect(usecase.getCategory(8.0), equals('Alcalin'));
        expect(usecase.getCategory(8.5), equals('Très alcalin'));
        expect(usecase.getCategory(9.0), equals('Très alcalin'));
      });
    });

    group('optimal range', () {
      test('should identify optimal pH for most plants', () {
        // Act & Assert
        expect(usecase.isOptimalForMostPlants(5.5), isFalse);
        expect(usecase.isOptimalForMostPlants(6.0), isTrue);
        expect(usecase.isOptimalForMostPlants(6.5), isTrue);
        expect(usecase.isOptimalForMostPlants(7.0), isTrue);
        expect(usecase.isOptimalForMostPlants(7.5), isTrue);
        expect(usecase.isOptimalForMostPlants(8.0), isFalse);
      });
    });

    group('distance to optimal', () {
      test('should calculate distance to optimal correctly', () {
        // Act & Assert
        expect(usecase.distanceToOptimal(6.0), equals(0.0)); // At optimal
        expect(usecase.distanceToOptimal(6.5), equals(0.0)); // At optimal
        expect(usecase.distanceToOptimal(7.0), equals(0.0)); // At optimal
        expect(usecase.distanceToOptimal(7.5), equals(0.0)); // At optimal
        expect(
            usecase.distanceToOptimal(5.5), equals(0.5)); // 0.5 away from 6.0
        expect(
            usecase.distanceToOptimal(8.0), equals(0.5)); // 0.5 away from 7.5
      });
    });

    group('edge cases', () {
      test('should handle very small values', () {
        // Act
        final result = usecase(0.1);

        // Assert
        expect(result, equals(0.0));
      });

      test('should handle very large values', () {
        // Act
        final result = usecase(13.9);

        // Assert
        expect(result, equals(14.0));
      });

      test('should handle values very close to steps', () {
        // Act & Assert
        expect(usecase(6.49), equals(6.5));
        expect(usecase(6.51), equals(6.5));
        expect(usecase(6.74), equals(6.5));
        expect(usecase(6.76), equals(7.0));
      });
    });
  });
}

