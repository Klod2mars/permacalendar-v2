import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:permacalendar/core/providers/activity_count_provider.dart';
import 'package:permacalendar/core/providers/activity_tracker_v3_provider.dart';
import 'package:permacalendar/core/services/activity_tracker_v3.dart';

void main() {
  test('ActivityCountProvider returns non-negative count', () async {
    final tracker = ActivityTrackerV3();
    final container = ProviderContainer(
      overrides: [
        activityTrackerV3Provider.overrideWithValue(tracker),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(activityCountProvider.future);

    expect(result, greaterThanOrEqualTo(0));
  });
}

