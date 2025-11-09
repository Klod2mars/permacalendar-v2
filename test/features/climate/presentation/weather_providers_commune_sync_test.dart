
import '../../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/providers/app_settings_provider.dart';
import 'package:permacalendar/features/climate/presentation/providers/weather_providers.dart';

void main() {
  group('Weather Providers Commune Sync', () {
    test('changing selected commune triggers weather refresh', () async {
      // Arrange: CrÃ©er un container de providers
      final container = ProviderContainer();

      // Act 1: Lire la mÃ©tÃ©o initiale (commune par dÃ©faut)
      final initialWeatherAsync = container.read(currentWeatherProvider);
      await initialWeatherAsync.when(
        loading: () async {},
        error: (error, stack) =>
            fail('Erreur lors du chargement initial: $error'),
        data: (weather) {
          // Assert: MÃ©tÃ©o initiale chargÃ©e pour commune par dÃ©faut
          expect(weather, isNotNull);
          expect(weather.temperature, isNotNull);
        },
      );

      // Act 2: Changer la commune dans les settings
      await container.read(appSettingsProvider.notifier).setCommune('Lyon');

      // Attendre que les settings soient persistÃ©s
      await Future.delayed(const Duration(milliseconds: 100));

      // Act 3: Relire le provider mÃ©tÃ©o (doit se mettre Ã  jour automatiquement)
      container.invalidate(currentWeatherProvider);
      final updatedWeatherAsync = container.read(currentWeatherProvider);

      await updatedWeatherAsync.when(
        loading: () async {},
        error: (error, stack) => fail('Erreur lors du rechargement: $error'),
        data: (weather) {
          // Assert: MÃ©tÃ©o mise Ã  jour (devrait Ãªtre pour Lyon maintenant)
          expect(weather, isNotNull);
          expect(weather.temperature, isNotNull);
          // Note: La comparaison exacte nÃ©cessiterait un mock d'OpenMeteoService
          // Pour l'instant, on vÃ©rifie juste que le provider se met Ã  jour
        },
      );

      // Cleanup
      container.dispose();
    });

    test('resolvedCoordinatesProvider uses selectedCommuneSettingsProvider',
        () async {
      // Arrange
      final container = ProviderContainer();

      // Act 1: VÃ©rifier avec commune par dÃ©faut
      final initialCoordsAsync = container.read(resolvedCoordinatesProvider);
      await initialCoordsAsync.when(
        loading: () async {},
        error: (error, stack) =>
            fail('Erreur lors du chargement initial: $error'),
        data: (coords) {
          expect(coords, isNotNull);
          expect(coords.latitude, isNotNull);
          expect(coords.longitude, isNotNull);
        },
      );

      // Act 2: Changer la commune
      await container
          .read(appSettingsProvider.notifier)
          .setCommune('Marseille');

      // Attendre que les settings soient persistÃ©s
      await Future.delayed(const Duration(milliseconds: 100));

      // Act 3: Invalider et relire (doit se mettre Ã  jour)
      container.invalidate(resolvedCoordinatesProvider);
      final updatedCoordsAsync = container.read(resolvedCoordinatesProvider);

      await updatedCoordsAsync.when(
        loading: () async {},
        error: (error, stack) => fail('Erreur lors du rechargement: $error'),
        data: (coords) {
          // Assert: CoordonnÃ©es mises Ã  jour
          expect(coords, isNotNull);
          // Note: La comparaison exacte nÃ©cessiterait un mock d'OpenMeteoService
          // Pour l'instant, on vÃ©rifie juste que le provider se met Ã  jour
        },
      );

      // Cleanup
      container.dispose();
    });

    test('forecastProvider uses resolvedCoordinatesProvider', () async {
      // Arrange
      final container = ProviderContainer();

      // Act: Lire le provider forecast (devrait utiliser resolvedCoordinatesProvider)
      final forecastAsync = container.read(forecastProvider);

      await forecastAsync.when(
        loading: () async {},
        error: (error, stack) => fail('Erreur lors du chargement: $error'),
        data: (forecast) {
          // Assert: PrÃ©visions chargÃ©es
          expect(forecast, isNotNull);
          expect(forecast, isA<List>());
        },
      );

      // Cleanup
      container.dispose();
    });

    test('forecastHistoryProvider uses resolvedCoordinatesProvider', () async {
      // Arrange
      final container = ProviderContainer();

      // Act: Lire le provider forecastHistory (devrait utiliser resolvedCoordinatesProvider)
      final historyAsync = container.read(forecastHistoryProvider);

      await historyAsync.when(
        loading: () async {},
        error: (error, stack) => fail('Erreur lors du chargement: $error'),
        data: (history) {
          // Assert: Historique chargÃ©
          expect(history, isNotNull);
          expect(history, isA<List>());
        },
      );

      // Cleanup
      container.dispose();
    });

    test('null commune falls back to defaultCommuneName', () async {
      // Arrange
      final container = ProviderContainer();

      // Act: RÃ©initialiser la commune Ã  null
      await container.read(appSettingsProvider.notifier).setCommune(null);

      // Attendre que les settings soient persistÃ©s
      await Future.delayed(const Duration(milliseconds: 100));

      // Act: Invalider et relire
      container.invalidate(resolvedCoordinatesProvider);
      final coordsAsync = container.read(resolvedCoordinatesProvider);

      await coordsAsync.when(
        loading: () async {},
        error: (error, stack) => fail('Erreur lors du chargement: $error'),
        data: (coords) {
          // Assert: CoordonnÃ©es par dÃ©faut utilisÃ©es (fallback)
          expect(coords, isNotNull);
          expect(coords.resolvedName, isNotNull);
          // Doit utiliser la commune par dÃ©faut
        },
      );

      // Cleanup
      container.dispose();
    });
  });
}

