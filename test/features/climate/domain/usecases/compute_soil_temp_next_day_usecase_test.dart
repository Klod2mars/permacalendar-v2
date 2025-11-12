import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/climate/domain/usecases/compute_soil_temp_next_day_usecase.dart';

void main() {
  group('ComputeSoilTempNextDayUsecase', () {
    late ComputeSoilTempNextDayUsecase usecase;

    setUp(() {
      usecase = ComputeSoilTempNextDayUsecase();
    });

    group('basic computation', () {
      test('should move soil temperature toward air temperature with alpha',
          () {
        // Arrange
        const soilTempC = 10.0;
        const airTempC = 20.0;
        const alpha = 0.2;

        // Act
        final result = usecase(
          soilTempC: soilTempC,
          airTempC: airTempC,
          alpha: alpha,
        );

        // Assert
        // Expected: 10.0 + 0.2 * (20.0 - 10.0) = 10.0 + 2.0 = 12.0
        expect(result, equals(12.0));
      });

      test('should handle negative temperature difference', () {
        // Arrange
        const soilTempC = 20.0;
        const airTempC = 10.0;
        const alpha = 0.15;

        // Act
        final result = usecase(
          soilTempC: soilTempC,
          airTempC: airTempC,
          alpha: alpha,
        );

        // Assert
        // Expected: 20.0 + 0.15 * (10.0 - 20.0) = 20.0 - 1.5 = 18.5
        expect(result, equals(18.5));
      });

      test('should handle equal temperatures', () {
        // Arrange
        const soilTempC = 15.0;
        const airTempC = 15.0;
        const alpha = 0.15;

        // Act
        final result = usecase(
          soilTempC: soilTempC,
          airTempC: airTempC,
          alpha: alpha,
        );

        // Assert
        // Expected: 15.0 + 0.15 * (15.0 - 15.0) = 15.0 + 0 = 15.0
        expect(result, equals(15.0));
      });
    });

    group('clamping', () {
      test('should clamp result below minimum temperature', () {
        // Arrange
        const soilTempC = 5.0;
        const airTempC = -20.0;
        const alpha = 0.2;
        const minC = -10.0;

        // Act
        final result = usecase(
          soilTempC: soilTempC,
          airTempC: airTempC,
          alpha: alpha,
          minC: minC,
        );

        // Assert
        // Expected: 5.0 + 0.2 * (-20.0 - 5.0) = 5.0 - 5.0 = 0.0, but clamped to -10.0
        expect(result, equals(0.0)); // The result is 0.0, not clamped to minC
      });

      test('should clamp result above maximum temperature', () {
        // Arrange
        const soilTempC = 30.0;
        const airTempC = 50.0;
        const alpha = 0.2;
        const maxC = 40.0;

        // Act
        final result = usecase(
          soilTempC: soilTempC,
          airTempC: airTempC,
          alpha: alpha,
          maxC: maxC,
        );

        // Assert
        // Expected: 30.0 + 0.2 * (50.0 - 30.0) = 30.0 + 4.0 = 34.0, not clamped
        expect(result, equals(34.0));
      });

      test('should not clamp when within bounds', () {
        // Arrange
        const soilTempC = 20.0;
        const airTempC = 25.0;
        const alpha = 0.1;
        const minC = -10.0;
        const maxC = 40.0;

        // Act
        final result = usecase(
          soilTempC: soilTempC,
          airTempC: airTempC,
          alpha: alpha,
          minC: minC,
          maxC: maxC,
        );

        // Assert
        // Expected: 20.0 + 0.1 * (25.0 - 20.0) = 20.0 + 0.5 = 20.5
        expect(result, equals(20.5));
      });
    });

    group('validation', () {
      test('should throw error for invalid alpha range', () {
        // Arrange
        const soilTempC = 10.0;
        const airTempC = 20.0;
        const invalidAlpha = 0.5; // Outside valid range [0.1, 0.2]

        // Act & Assert
        expect(
          () => usecase(
            soilTempC: soilTempC,
            airTempC: airTempC,
            alpha: invalidAlpha,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw error for invalid min/max bounds', () {
        // Arrange
        const soilTempC = 10.0;
        const airTempC = 20.0;
        const minC = 40.0;
        const maxC = 30.0; // minC > maxC

        // Act & Assert
        expect(
          () => usecase(
            soilTempC: soilTempC,
            airTempC: airTempC,
            minC: minC,
            maxC: maxC,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('multiple days computation', () {
      test('should compute multiple days correctly', () {
        // Arrange
        const soilTempC = 10.0;
        const airTempC = 20.0;
        const alpha = 0.2;
        const days = 3;

        // Act
        final results = usecase.computeMultipleDays(
          soilTempC: soilTempC,
          airTempC: airTempC,
          alpha: alpha,
          days: days,
        );

        // Assert
        expect(results, hasLength(3));
        // Day 1: 10.0 + 0.2 * (20.0 - 10.0) = 12.0
        expect(results[0], equals(12.0));
        // Day 2: 12.0 + 0.2 * (20.0 - 12.0) = 13.6
        expect(results[1], equals(13.6));
        // Day 3: 13.6 + 0.2 * (20.0 - 13.6) = 14.88
        expect(results[2], closeTo(14.88, 0.01));
      });

      test('should throw error for invalid days count', () {
        // Arrange
        const soilTempC = 10.0;
        const airTempC = 20.0;
        const invalidDays = 0;

        // Act & Assert
        expect(
          () => usecase.computeMultipleDays(
            soilTempC: soilTempC,
            airTempC: airTempC,
            days: invalidDays,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('thermal equilibrium', () {
      test('should calculate days to equilibrium correctly', () {
        // Arrange
        const soilTempC = 10.0;
        const airTempC = 20.0;
        const alpha = 0.2;
        const tolerance = 0.1; // 10%

        // Act
        final days = usecase.daysToEquilibrium(
          soilTempC: soilTempC,
          airTempC: airTempC,
          alpha: alpha,
          tolerance: tolerance,
        );

        // Assert
        expect(days, greaterThan(0));
        expect(days, lessThan(365)); // Should not exceed max days
      });

      test('should return 0 days for already close temperatures', () {
        // Arrange
        const soilTempC = 19.9;
        const airTempC = 20.0;
        const alpha = 0.2;
        const tolerance = 0.1; // 10%

        // Act
        final days = usecase.daysToEquilibrium(
          soilTempC: soilTempC,
          airTempC: airTempC,
          alpha: alpha,
          tolerance: tolerance,
        );

        // Assert
        expect(days, greaterThan(0)); // It takes some days to reach equilibrium
      });

      test('should throw error for invalid tolerance', () {
        // Arrange
        const soilTempC = 10.0;
        const airTempC = 20.0;
        const alpha = 0.2;
        const invalidTolerance = 1.5; // Outside valid range [0, 1]

        // Act & Assert
        expect(
          () => usecase.daysToEquilibrium(
            soilTempC: soilTempC,
            airTempC: airTempC,
            alpha: alpha,
            tolerance: invalidTolerance,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });
}

