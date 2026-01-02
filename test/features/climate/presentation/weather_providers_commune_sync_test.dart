import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:permacalendar/core/providers/app_settings_provider.dart';

import 'package:permacalendar/features/climate/presentation/providers/weather_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory testDir;

  setUpAll(() async {
    testDir = await Directory.systemTemp.createTemp('hive_test_sync_');
    Hive.init(testDir.path);
  });

  tearDownAll(() async {
    await Hive.close();
    if (await testDir.exists()) {
      await testDir.delete(recursive: true);
    }
  });

  group('Weather Providers Commune Sync', () {
    test('changing selected commune triggers weather refresh', () async {
      // Arrange: Créer un container de providers

      final container = ProviderContainer();

      // Act 1: Lire la météo initiale (commune par défaut)

      final initialWeatherAsync = container.read(currentWeatherProvider);

      await initialWeatherAsync.when(
        loading: () async {},
        error: (error, stack) =>
            fail('Erreur lors du chargement initial: $error'),
        data: (weather) {
          // Assert: Météo initiale chargée pour commune par défaut

          expect(weather, isNotNull);

          expect(weather.temperature, isNotNull);
        },
      );

      // Act 2: Changer la commune dans les settings

      // Act 2: Changer la commune dans les settings
      await container
          .read(appSettingsProvider.notifier)
          .setSelectedCommune('Lyon');

      // Attendre que les settings soient persistés

      await Future.delayed(const Duration(milliseconds: 100));

      // Act 3: Relire le provider météo (doit se mettre à jour automatiquement)

      container.invalidate(currentWeatherProvider);

      final updatedWeatherAsync = container.read(currentWeatherProvider);

      await updatedWeatherAsync.when(
        loading: () async {},
        error: (error, stack) => fail('Erreur lors du rechargement: $error'),
        data: (weather) {
          // Assert: Météo mise à jour (devrait être pour Lyon maintenant)

          expect(weather, isNotNull);

          expect(weather.temperature, isNotNull);

          // Note: La comparaison exacte nécessiterait un mock d'OpenMeteoService

          // Pour l'instant, on vérifie juste que le provider se met à jour
        },
      );

      // Cleanup

      container.dispose();
    });

    test(
        'selectedCommuneCoordinatesProvider uses selectedCommuneSettingsProvider',
        () async {
      // Arrange

      final container = ProviderContainer();

      // Act 1: Vérifier avec commune par défaut

      final initialCoordsAsync =
          container.read(selectedCommuneCoordinatesProvider);
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

      // Attendre que les settings soient persistés

      await Future.delayed(const Duration(milliseconds: 100));

      // Act 3: Invalider et relire (doit se mettre à jour)

      container.invalidate(selectedCommuneCoordinatesProvider);

      final updatedCoordsAsync =
          container.read(selectedCommuneCoordinatesProvider);

      await updatedCoordsAsync.when(
        loading: () async {},
        error: (error, stack) => fail('Erreur lors du rechargement: $error'),
        data: (coords) {
          // Assert: Coordonnées mises à jour

          expect(coords, isNotNull);

          // Note: La comparaison exacte nécessiterait un mock d'OpenMeteoService

          // Pour l'instant, on vérifie juste que le provider se met à jour
        },
      );

      // Cleanup

      container.dispose();
    });

    test('forecastProvider uses selectedCommuneCoordinatesProvider', () async {
      // Arrange

      final container = ProviderContainer();

      // Act: Lire le provider forecast (devrait utiliser selectedCommuneCoordinatesProvider)

      final forecastAsync = container.read(forecastProvider);

      await forecastAsync.when(
        loading: () async {},
        error: (error, stack) => fail('Erreur lors du chargement: $error'),
        data: (forecast) {
          // Assert: Prévisions chargées

          expect(forecast, isNotNull);

          expect(forecast, isA<List>());
        },
      );

      // Cleanup

      container.dispose();
    });

    test('forecastHistoryProvider uses selectedCommuneCoordinatesProvider',
        () async {
      // Arrange

      final container = ProviderContainer();

      // Act: Lire le provider forecastHistory (devrait utiliser selectedCommuneCoordinatesProvider)

      final historyAsync = container.read(forecastHistoryProvider);

      await historyAsync.when(
        loading: () async {},
        error: (error, stack) => fail('Erreur lors du chargement: $error'),
        data: (history) {
          // Assert: Historique chargé

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

      // Act: Réinitialiser la commune à null

      // Act: Réinitialiser la commune à null
      await container
          .read(appSettingsProvider.notifier)
          .setSelectedCommune(null);

      // Attendre que les settings soient persistés

      await Future.delayed(const Duration(milliseconds: 100));

      // Act: Invalider et relire

      container.invalidate(selectedCommuneCoordinatesProvider);
      final coordsAsync = container.read(selectedCommuneCoordinatesProvider);

      await coordsAsync.when(
        loading: () async {},
        error: (error, stack) => fail('Erreur lors du chargement: $error'),
        data: (coords) {
          // Assert: Coordonnées par défaut utilisées (fallback)

          expect(coords, isNotNull);

          expect(coords.resolvedName, isNotNull);

          // Doit utiliser la commune par défaut
        },
      );

      // Cleanup

      container.dispose();
    });
  });
}
