import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  print('ðŸ§¹ Starting Hive box cleanup for Plant Intelligence...');
  await Hive.initFlutter();

  final boxes = [
    'plant_conditions',
    'weather_conditions',
    'weather_forecasts',
    'recommendations',
    'notification_alerts',
    'plant_analyses',
    'active_alerts',
    'pest_observations',
    'bio_control_recommendations',
  ];

  int deletedCount = 0;

  for (final boxName in boxes) {
    try {
      if (await Hive.boxExists(boxName)) {
        await Hive.deleteBoxFromDisk(boxName);
        print('âœ… Deleted: $boxName');
        deletedCount++;
      } else {
        print('â„¹ï¸  Not found: $boxName');
      }
    } catch (e) {
      print('â Œ Error deleting $boxName: $e');
    }
  }

  print('ðŸ   Cleanup finished. Deleted $deletedCount boxes.');
}
