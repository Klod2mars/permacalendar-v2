import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/usecases/evaluate_planting_timing_usecase.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_report.dart';
import 'test_helpers.dart';

void main() {
  group('EvaluatePlantingTimingUsecase', () {
    late EvaluatePlantingTimingUsecase usecase;
    
    setUp(() {
      usecase = const EvaluatePlantingTimingUsecase();
    });
    
    test('should return PlantingTimingEvaluation', () async {
      // Arrange
      final plant = createMockPlant();
      final weather = createMockWeather(temperature: 22.0);
      final garden = createMockGarden();
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(result, isA<PlantingTimingEvaluation>());
      expect(result.isOptimalTime, isA<bool>());
      expect(result.timingScore, greaterThanOrEqualTo(0.0));
      expect(result.timingScore, lessThanOrEqualTo(100.0));
      expect(result.reason, isNotEmpty);
    });
    
    test('should return optimal time during sowing season with good conditions', () async {
      // Arrange
      final currentMonth = DateTime.now().month;
      final monthAbbr = _getMonthAbbreviation(currentMonth);
      final plant = createMockPlant(
        sowingMonths: [monthAbbr],
        metadata: {
          'germination': {
            'optimalTemperature': {'min': 18, 'max': 25},
          },
          'frostSensitive': false,
        },
      );
      final weather = createMockWeather(temperature: 20.0); // Optimal
      final garden = createMockGarden();
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(result.isOptimalTime, isTrue);
      expect(result.timingScore, greaterThan(70.0));
      expect(result.favorableFactors, isNotEmpty);
      expect(result.risks, isEmpty);
    });
    
    test('should return non-optimal time outside sowing season', () async {
      // Arrange
      final currentMonth = DateTime.now().month;
      // Get month that's NOT in sowing period
      final nextMonth = (currentMonth % 12) + 1;
      final nextMonthAbbr = _getMonthAbbreviation(nextMonth);
      final plant = createMockPlant(
        sowingMonths: [nextMonthAbbr], // Different month
      );
      final weather = createMockWeather();
      final garden = createMockGarden();
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(result.unfavorableFactors, isNotEmpty);
      expect(
        result.unfavorableFactors.any((f) => f.contains('période')),
        isTrue,
      );
    });
    
    test('should detect frost risk for sensitive plants', () async {
      // Arrange
      final currentMonth = DateTime.now().month;
      final monthAbbr = _getMonthAbbreviation(currentMonth);
      final plant = createMockPlant(
        sowingMonths: [monthAbbr],
        metadata: {
          'germination': {
            'optimalTemperature': {'min': 18, 'max': 25},
          },
          'frostSensitive': true,
        },
      );
      final weather = createMockWeather(temperature: 2.0); // Frost risk
      final garden = createMockGarden();
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(result.risks, isNotEmpty);
      expect(
        result.risks.any((r) => r.toLowerCase().contains('gel')),
        isTrue,
      );
      expect(result.isOptimalTime, isFalse);
    });
    
    test('should identify favorable factors', () async {
      // Arrange
      final currentMonth = DateTime.now().month;
      final monthAbbr = _getMonthAbbreviation(currentMonth);
      final plant = createMockPlant(
        sowingMonths: [monthAbbr],
        metadata: {
          'germination': {
            'optimalTemperature': {'min': 18, 'max': 25},
          },
        },
      );
      final weather = createMockWeather(temperature: 20.0);
      final garden = createMockGarden(ph: 6.8);
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(result.favorableFactors, isNotEmpty);
    });
    
    test('should identify unfavorable factors', () async {
      // Arrange
      final plant = createMockPlant(
        metadata: {
          'germination': {
            'optimalTemperature': {'min': 18, 'max': 25},
          },
        },
      );
      final weather = createMockWeather(temperature: 10.0); // Too low
      final garden = createMockGarden(ph: 5.0); // Too acidic
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(result.unfavorableFactors, isNotEmpty);
    });
    
    test('should calculate optimal planting date when not optimal', () async {
      // Arrange
      final currentMonth = DateTime.now().month;
      final nextMonth = (currentMonth % 12) + 1;
      final nextMonthAbbr = _getMonthAbbreviation(nextMonth);
      final plant = createMockPlant(sowingMonths: [nextMonthAbbr]);
      final weather = createMockWeather();
      final garden = createMockGarden();
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      if (!result.isOptimalTime) {
        expect(result.optimalPlantingDate, isNotNull);
        expect(result.optimalPlantingDate!.isAfter(DateTime.now()), isTrue);
      }
    });
    
    test('should have timing score between 0 and 100', () async {
      // Arrange
      final plant = createMockPlant();
      final weather = createMockWeather();
      final garden = createMockGarden();
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(result.timingScore, greaterThanOrEqualTo(0.0));
      expect(result.timingScore, lessThanOrEqualTo(100.0));
    });
    
    test('should provide meaningful reason for evaluation', () async {
      // Arrange
      final plant = createMockPlant();
      final weather = createMockWeather();
      final garden = createMockGarden();
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(result.reason, isNotEmpty);
      expect(result.reason.length, greaterThan(20)); // Meaningful message
    });
    
    test('should handle temperature outside optimal range', () async {
      // Arrange
      final plant = createMockPlant(
        metadata: {
          'germination': {
            'optimalTemperature': {'min': 18, 'max': 25},
          },
        },
      );
      final weather = createMockWeather(temperature: 35.0); // Too hot
      final garden = createMockGarden();
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(result.unfavorableFactors, isNotEmpty);
      expect(
        result.unfavorableFactors.any((f) => f.toLowerCase().contains('température')),
        isTrue,
      );
    });
    
    test('should consider soil pH in evaluation', () async {
      // Arrange
      final plant = createMockPlant();
      final weather = createMockWeather();
      final garden = createMockGarden(ph: 6.5); // Optimal
      
      // Act
      final result = await usecase.execute(
        plant: plant,
        weather: weather,
        garden: garden,
      );
      
      // Assert
      expect(
        result.favorableFactors.any((f) => f.toLowerCase().contains('ph')),
        isTrue,
      );
    });
  });
}

// ==================== HELPER FUNCTIONS ====================

String _getMonthAbbreviation(int month) {
  const abbr = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
  return abbr[month - 1];
}

