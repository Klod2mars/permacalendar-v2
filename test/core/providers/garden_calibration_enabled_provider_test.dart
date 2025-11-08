import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:permacalendar/core/providers/garden_aggregation_providers.dart';

void main() {
  test('gardenCalibrationEnabledProvider returns false by default', () {
    final container = ProviderContainer(overrides: [
      hubHealthCheckProvider.overrideWith((ref) async {
        return {'errors': true};
      }),
    ]);
    addTearDown(container.dispose);

    final result = container.read(gardenCalibrationEnabledProvider);
    expect(result, false);
  });
}

