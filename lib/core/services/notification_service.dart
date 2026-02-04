import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final fln.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      fln.FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // --- Timezone init (important) ---
    tz.initializeTimeZones();
    try {
      final String timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      print('[NotificationService] Timezone set to $timeZoneName');
    } catch (e) {
      // fallback: tz.local may still be usable, but log
      print('[NotificationService] Failed to set local timezone: $e');
    }

    // --- Android icon ---
    const fln.AndroidInitializationSettings initializationSettingsAndroid =
        fln.AndroidInitializationSettings('@mipmap/ic_launcher');

    // --- iOS / macOS minimal + request permissions on initialization ---
    final fln.DarwinInitializationSettings initializationSettingsDarwin =
        const fln.DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final fln.InitializationSettings initializationSettings = fln.InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // Optionally add onDidReceiveNotificationResponse callbacks here
    );

    // --- Request runtime permission for notifications (Android 13+) ---
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final status = await Permission.notification.status;
        if (!status.isGranted) {
          final result = await Permission.notification.request();
          print('[NotificationService] Notification permission: $result');
        } else {
          print('[NotificationService] Notification permission already granted');
        }
      }
    } catch (e) {
      print('[NotificationService] permission request failed: $e');
    }

    // --- Create Android channel explicitly (robustness) ---
    try {
      final fln.AndroidNotificationChannel channel = const fln.AndroidNotificationChannel(
        'planting_steps_channel', // id
        'Planting Steps', // name
        description: 'Reminders for planting steps',
        importance: fln.Importance.max,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              fln.AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      print('[NotificationService] Android channel created: planting_steps_channel');
    } catch (e) {
      print('[NotificationService] creating Android channel failed: $e');
    }

    _initialized = true;
    print('[NotificationService] initialized');
  }

  Future<int> scheduleNotification({
    int? id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_initialized) await init();

    final int notificationId = id ?? DateTime.now().millisecondsSinceEpoch.remainder(2147483647);

    // Debug log
    print('[NotificationService] Scheduling notification id=$notificationId at $scheduledDate (local tz: ${tz.local.name})');

    final fln.NotificationDetails details = const fln.NotificationDetails(
      android: fln.AndroidNotificationDetails(
        'planting_steps_channel',
        'Planting Steps',
        channelDescription: 'Reminders for planting steps',
        importance: fln.Importance.max,
        priority: fln.Priority.high,
      ),
      iOS: fln.DarwinNotificationDetails(),
    );

    // Convert DateTime to TZDateTime in local zone
    final tz.TZDateTime tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        tzScheduled,
        details,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      print('[NotificationService] scheduled (id=$notificationId) for $tzScheduled');
    } catch (e) {
      print('[NotificationService] zonedSchedule failed: $e');
      rethrow;
    }

    return notificationId;
  }

  Future<void> cancelNotification(int id) async {
    if (!_initialized) await init();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    if (!_initialized) await init();
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
