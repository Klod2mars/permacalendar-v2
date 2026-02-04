import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../data/hive/garden_boxes.dart';
import '../models/activity.dart';
import '../services/notification_service.dart';

/// Provider minimal pour les réglages de l'application.
/// Fournit l'objet AppSettings.
final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<AppSettings> {
  static const String _keyNotificationsEnabled = 'app_settings_notifications_enabled';
  static const String _keyShowNutritionInterpretation = 'app_settings_nutrition_interpretation';
  static const String _keyCustomZoneId = 'app_settings_custom_zone_id';
  static const String _keyCustomLastFrostDate = 'app_settings_custom_last_frost_date';

  @override
  AppSettings build() {
    _loadPersistence();
    return AppSettings.defaults();
  }

  Future<void> _loadPersistence() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool(_keyNotificationsEnabled) ?? true;
    final showInterpretation = prefs.getBool(_keyShowNutritionInterpretation) ?? false;
    final zoneId = prefs.getString(_keyCustomZoneId);
    final frostStr = prefs.getString(_keyCustomLastFrostDate);
    DateTime? frostDate;
    if (frostStr != null) {
      frostDate = DateTime.tryParse(frostStr);
    }
    
    state = state.copyWith(
      notificationsEnabled: notificationsEnabled,
      showNutritionInterpretation: showInterpretation,
      customZoneId: zoneId,
      customLastFrostDate: frostDate,
    );
  }

  /// Sauvegarde des dernières coordonnées (utilisé par weather_providers)
  Future<void> setLastCoordinates(double latitude, double longitude) async {
    state = state.copyWith(lastLatitude: latitude, lastLongitude: longitude);
  }

  /// Setter pratique pour la commune sélectionnée si besoin ultérieur
  Future<void> setSelectedCommune(String? commune) async {
    state = state.copyWith(selectedCommune: commune);
  }

  void toggleShowAnimations(bool value) {
    state = state.copyWith(showAnimations: value);
  }

  void toggleShowMoonInOvoid(bool value) {
    state = state.copyWith(showMoonInOvoid: value);
  }

  Future<void> setShowHistoryHint(bool value) async {
    state = state.copyWith(showHistoryHint: value);
  }
  
  Future<void> setNotificationsEnabled(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, value);

    if (!value) {
      // 1) Cancel all notifications at OS level
      try {
        await NotificationService().cancelAllNotifications();
      } catch (e) {
        print('[AppSettingsNotifier] cancelAllNotifications failed: $e');
      }

      // 2) Iterate user activities and clear personalNotification notificationIds
      try {
        final activities = GardenBoxes.activities.values.cast<Activity>().toList();
        for (final a in activities) {
          final pn = a.metadata['personalNotification'];
          if (pn is Map && pn['notificationIds'] is List) {
            final List ids = List.from(pn['notificationIds']);
            for (final id in ids) {
              try { await NotificationService().cancelNotification(id as int); } catch (_) {}
            }
            // Update metadata to reflect that notifications are disabled / removed
            final newPn = Map<String, dynamic>.from(pn)..['enabled'] = false;
            newPn.remove('notificationIds');
            final newMeta = Map<String, dynamic>.from(a.metadata)..['personalNotification'] = newPn;
            final updated = Activity(
              id: a.id,
              type: a.type,
              title: a.title,
              description: a.description,
              entityId: a.entityId,
              entityType: a.entityType,
              timestamp: a.timestamp,
              metadata: newMeta,
              createdAt: a.createdAt,
              updatedAt: DateTime.now(),
              isActive: a.isActive,
            );
            await GardenBoxes.activities.put(a.id, updated);
          }
        }
      } catch (e) {
        print('[AppSettingsNotifier] cleaning activities failed: $e');
      }
    }
  }

  Future<void> toggleShowNutritionInterpretation(bool value) async {
    state = state.copyWith(showNutritionInterpretation: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowNutritionInterpretation, value);
  }

  Future<void> setCustomZoneId(String? zoneId) async {
    state = state.copyWith(customZoneId: zoneId);
    final prefs = await SharedPreferences.getInstance();
    if (zoneId != null) {
      await prefs.setString(_keyCustomZoneId, zoneId);
    } else {
      await prefs.remove(_keyCustomZoneId);
    }
  }

  Future<void> setCustomLastFrostDate(DateTime? date) async {
    state = state.copyWith(customLastFrostDate: date);
    final prefs = await SharedPreferences.getInstance();
    if (date != null) {
      await prefs.setString(_keyCustomLastFrostDate, date.toIso8601String());
    } else {
      await prefs.remove(_keyCustomLastFrostDate);
    }
  }
}
