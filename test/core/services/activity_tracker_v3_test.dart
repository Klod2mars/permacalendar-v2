
import '../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:permacalendar/core/models/activity_v3.dart';
import 'package:permacalendar/core/providers/activity_tracker_v3_provider.dart';

void main() {
  test('ActivityTrackerV3Provider should instantiate correctly', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final tracker = container.read(activityTrackerV3Provider);
    expect(tracker, isNotNull);
  });

  test('recordActivity() should not throw errors', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final tracker = container.read(activityTrackerV3Provider);

    final activity = ActivityV3(
      id: 'test-activity',
      type: 'test',
      description: 'Test activity',
      timestamp: DateTime.now(),
    );

    await tracker.recordActivity(activity);
    final activities = await tracker.getRecentActivities();
    expect(activities, isA<List<ActivityV3>>());
  });
}


