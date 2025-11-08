import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permacalendarv2/core/providers/activity_tracker_initialized_provider.dart';

void main() {
  test('ActivityTrackerInitializedProvider returns a bool', () async {
    final container = ProviderContainer();
    final result =
        await container.read(activityTrackerInitializedProvider.future);
    expect(result, isA<bool>());
  });
}

