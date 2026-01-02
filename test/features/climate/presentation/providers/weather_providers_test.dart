import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/climate/presentation/providers/weather_providers.dart';
import 'package:permacalendar/core/services/open_meteo_service.dart';
import 'package:mockito/mockito.dart';

// Mocking dependencies would be ideal, but for now we just want to ensure it compiles and runs basic logic
// effectively testing the "offline" or "error" path if we mock the service.

void main() {
  test('currentWeatherProvider should return valid state or handle errors',
      () async {
    final container = ProviderContainer(
      overrides: [
        // Mock persisted coordinates to avoid Hive
        persistedCoordinatesProvider.overrideWith((ref) => Future.value(null)),
        // Mock selected coordinates
        selectedCommuneCoordinatesProvider.overrideWith((ref) => Future.value(
            Coordinates(
                latitude: 48.85, longitude: 2.35, resolvedName: 'Paris'))),
      ],
    );
    addTearDown(container.dispose);

    // Read the provider
    // Note: This will trigger OpenMeteoService network call.
    // If we want to strictly test error handling without network, we'd need to mock the service,
    // but the service is a static singleton.
    // For now, we assume network might fail or succeed, but we shouldn't crash.

    try {
      final result = await container.read(currentWeatherProvider.future);
      // If it succeeds, great.
      expect(result.coordinates.latitude, 48.85);
    } catch (e) {
      // If it fails (network), it should be handled?
      // Actually currentWeatherProvider catches errors and returns valid object with null temp.
      // So it should NOT throw.
      fail('Provider threw an exception instead of returning error object: $e');
    }
  });
}
