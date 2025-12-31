import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/models/activity.dart';

void main() {
  test('Activity.customTask existence check', () {
    final t = Activity.customTask(
      title: 'Test',
      description: 'Desc',
      taskKind: 'generic',
    );
    expect(t.title, 'Test');
    expect(t.metadata['isCustomTask'], true);
  });
}
