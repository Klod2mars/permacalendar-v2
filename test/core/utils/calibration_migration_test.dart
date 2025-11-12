import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/utils/calibration_migration.dart';

void main() {
  test('CalibrationMigration.migrate completes without error', () async {
    await CalibrationMigration.migrate();
    expect(true, isTrue);
  });
}

