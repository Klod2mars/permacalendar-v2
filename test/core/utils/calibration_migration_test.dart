
import '../../test_setup_stub.dart';

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:permacalendar/core/utils/calibration_migration.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late CalibrationMigration migration;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tempDir = await Directory.systemTemp.createTemp('calibration_migration');
    Hive.init(tempDir.path);
    migration = CalibrationMigration();
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('migrates legacy hive profiles into v2 storage', () async {
    final legacyBox = await Hive.openBox('garden_calibration');
    await legacyBox.put('device-alpha', <String, dynamic>{
      'deviceId': 'device-alpha',
      'updatedAt': '2024-08-14T10:00:00Z',
      'active': true,
      'metrics': <String, dynamic>{
        'temp': <String, dynamic>{
          'value': 23.4,
          'unit': 'Celsius',
          'timestamp': '2024-08-14T10:00:00Z',
        },
        'light': <String, dynamic>{
          'value': 1200,
          'unit': 'lux',
          'timestamp': 1692007200000,
        },
      },
    });

    final report = await migration.migrateCalibrationData();

    expect(report.errors, isEmpty, reason: 'errors: ${report.errors}');
    expect(report.success, isTrue);
    expect(report.migratedProfiles, equals(1));

    final v2Box = await Hive.openBox('calibration_v2');
    final stored = v2Box.get('device-alpha') as Map?;

    expect(stored, isNotNull);
    final metrics = stored!['metrics'] as Map<dynamic, dynamic>;
    expect((metrics['temp'] as Map)['unit'], equals('Â°C'));
    expect((metrics['light'] as Map)['value'], equals(1200));
    expect(stored['isActive'], isTrue);
  });

  test('handles partial sensors and validates units', () async {
    final legacyBox = await Hive.openBox('garden_calibration');
    await legacyBox.put('device-beta', <String, dynamic>{
      'metrics': <String, dynamic>{
        'humidity': <String, dynamic>{'value': '45', 'unit': '%'},
        'unknown': <String, dynamic>{'value': 10, 'unit': 'ppm'},
      },
      'deviceId': 'device-beta',
      'updatedAt': '2024-01-01T00:00:00Z',
    });

    final report = await migration.migrateCalibrationData();

    expect(report.errors, isEmpty, reason: 'errors: ${report.errors}');
    expect(report.success, isTrue);
    expect(report.warnings, isNotEmpty);

    final v2Box = await Hive.openBox('calibration_v2');
    final stored = v2Box.get('device-beta')! as Map;
    final metrics = stored['metrics'] as Map<dynamic, dynamic>;

    expect(metrics.containsKey('humidity'), isTrue);
    expect(metrics.containsKey('unknown'), isFalse);
  });

  test('dryRun does not persist data', () async {
    final legacyBox = await Hive.openBox('garden_calibration');
    await legacyBox.put('device-dry', <String, dynamic>{
      'deviceId': 'device-dry',
      'metrics': <String, dynamic>{
        'temp': <String, dynamic>{'value': 21, 'unit': 'C'},
      },
    });

    final report = await migration.migrateCalibrationData(dryRun: true);

    expect(report.success, isTrue);
    expect(report.preview, isNotEmpty);
    expect(await Hive.boxExists('calibration_v2'), isFalse);
  });

  test('captures hive open errors', () async {
    final migrationWithError = CalibrationMigration(
      legacyBoxOpenerOverride: (_) async {
        throw Exception('legacy box failure');
      },
    );

    final report = await migrationWithError.migrateCalibrationData();

    expect(report.success, isFalse);
    expect(report.errors, isNotEmpty);
  });

  test('merge preserves most recent active profile', () async {
    final legacyBox = await Hive.openBox('garden_calibration');
    await legacyBox.put('device-sanctuary', <String, dynamic>{
      'deviceId': 'device-sanctuary',
      'updatedAt': '2024-02-01T00:00:00Z',
      'active': false,
      'metrics': <String, dynamic>{
        'temp': <String, dynamic>{'value': 20, 'unit': 'C'},
      },
    });

    final v2Box = await Hive.openBox('calibration_v2');
    await v2Box.put('device-sanctuary', <String, dynamic>{
      'profileId': 'device-sanctuary',
      'deviceId': 'device-sanctuary',
      'isActive': true,
      'updatedAt': '2024-03-01T00:00:00Z',
      'metrics': <String, dynamic>{
        'temp': <String, dynamic>{
          'sensorId': 'temp',
          'value': 22,
          'unit': 'Â°C',
          'updatedAt': '2024-03-01T00:00:00Z',
        },
      },
    });

    expect(Hive.isBoxOpen('garden_calibration'), isTrue);
    expect(Hive.isBoxOpen('calibration_v2'), isTrue);

    final report = await migration.migrateCalibrationData();

    expect(report.errors, isEmpty, reason: 'errors: ${report.errors}');
    expect(report.success, isTrue);

    final refreshed = await Hive.openBox('calibration_v2');
    final stored = refreshed.get('device-sanctuary')! as Map;
    expect(stored['isActive'], isTrue);
    final metrics = stored['metrics'] as Map<dynamic, dynamic>;
    expect((metrics['temp'] as Map)['value'], equals(22));
  });
}

