import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/climate/presentation/providers/soil_temp_provider.dart';
import 'package:permacalendar/features/climate/presentation/providers/soil_ph_provider.dart';
import 'package:permacalendar/features/climate/presentation/providers/weather_providers.dart';
import 'package:permacalendar/features/climate/presentation/providers/soil_metrics_repository_provider.dart';

void main() {
  group('Climate Rosace Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should create soil temperature provider with demo scope', () {
      // Arrange
      const scopeKey = "garden:demo";

      // Act
      final soilTempProvider = container.read(soilTempProvider(scopeKey));

      // Assert
      expect(soilTempProvider, isA<AsyncValue<double?>>());
    });

    test('should create soil pH provider with demo scope', () {
      // Arrange
      const scopeKey = "garden:demo";

      // Act
      final soilPHProvider = container.read(soilPHProvider(scopeKey));

      // Assert
      expect(soilPHProvider, isA<AsyncValue<double?>>());
    });

    test('should create weather providers', () {
      // Act & Assert
      final currentWeather = container.read(currentWeatherProvider);
      final alerts = container.read(alertsProvider);
      final forecast = container.read(forecastProvider);
      final shouldPulse = container.read(shouldPulseAlertProvider);

      expect(currentWeather, isA<AsyncValue>());
      expect(alerts, isA<AsyncValue<List>>());
      expect(forecast, isA<AsyncValue<List>>());
      expect(shouldPulse, isA<bool>());
    });

    test('should create repository provider', () {
      // Act
      final repository = container.read(soilMetricsRepositoryProvider);

      // Assert
      expect(repository, isNotNull);
    });

    test('should handle soil temperature controller operations', () async {
      // Arrange
      const scopeKey = "garden:demo";
      final controller = container.read(soilTempProvider(scopeKey).notifier);

      // Act & Assert
      // Test manual temperature setting
      await controller.setManual(20.5);
      final state = container.read(soilTempProvider(scopeKey));
      expect(state.hasValue, isTrue);
      expect(state.value, equals(20.5));

      // Test update from air temperature
      await controller.updateFromAirTemp(25.0);
      final updatedState = container.read(soilTempProvider(scopeKey));
      expect(updatedState.hasValue, isTrue);
      expect(updatedState.value, isNotNull);
      expect(updatedState.value,
          greaterThan(20.5)); // Should be higher due to thermal diffusion
    });

    test('should handle soil pH controller operations', () async {
      // Arrange
      const scopeKey = "garden:demo";
      final controller = container.read(soilPHProvider(scopeKey).notifier);

      // Act & Assert
      // Test pH setting
      await controller.setPH(6.8);
      final state = container.read(soilPHProvider(scopeKey));
      expect(state.hasValue, isTrue);
      expect(state.value, equals(6.8));

      // Test pH adjustment
      await controller.adjustPH(0.5);
      final adjustedState = container.read(soilPHProvider(scopeKey));
      expect(adjustedState.hasValue, isTrue);
      expect(adjustedState.value, equals(7.0)); // Should be rounded to 0.5 step
    });

    test('should handle multiple scopes independently', () async {
      // Arrange
      const scopeKey1 = "garden:demo1";
      const scopeKey2 = "garden:demo2";
      final controller1 = container.read(soilTempProvider(scopeKey1).notifier);
      final controller2 = container.read(soilTempProvider(scopeKey2).notifier);

      // Act
      await controller1.setManual(15.0);
      await controller2.setManual(25.0);

      // Assert
      final state1 = container.read(soilTempProvider(scopeKey1));
      final state2 = container.read(soilTempProvider(scopeKey2));

      expect(state1.value, equals(15.0));
      expect(state2.value, equals(25.0));
      expect(state1.value, isNot(equals(state2.value)));
    });
  });
}
